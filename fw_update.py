import re as regex
from pathlib import Path
import subprocess
from functools import cached_property
from typing import NamedTuple, Optional, List

FW_TOOL_VERSION_TO_REGEX = {
    "2.55.1.0": r"[0-9]+\) \[USB\] Intel RealSense (.+?) s/n (\d+), update serial number: (\d+), firmware version: ([\d.]+)",
    "default": r"[0-9]+\) Name: (.*?), serial number: (.*?), update serial number: ([0-9]+), firmware version: (.*?), USB type: (.*?)",
}


class FWDevice(NamedTuple):
    serial_number: str
    firmware_version: str
    is_recovery: bool


class FirmwareUpdater:  # noqa: D101
    path = "rs-fw-update"

    @cached_property
    def devices(self) -> List[FWDevice]:
        return self._get_devices()

    @cached_property
    def fw_updater_version(self) -> str:
        """Parses the firmware updater version from the output of the command `rs-fw-update --version`.

        Needed because a genius at intel decided to change the output formats of the commands.

        Returns:
            str: Version of the fw updater tool.
        """
        out = subprocess.check_output([FirmwareUpdater.path, "--version"])
        line = out.decode("utf-8")
        version = line.split("version: ")[1].split("\n")[0]
        return version

    def parse_device_line(self, line: str) -> Optional[FWDevice]:
        """Parses a line that can contain the device information, and creates a Device if the line is parsed.

        Args:
            line (str): line to parse

        Returns:
            Optional[Device]: Device if the line is parsed, None otherwise.
        """
        if self.fw_updater_version in FW_TOOL_VERSION_TO_REGEX:
            re = FW_TOOL_VERSION_TO_REGEX[self.fw_updater_version]
        else:
            re = FW_TOOL_VERSION_TO_REGEX["default"]
        match = regex.match(re, line)

        if "Recovery" in line:
            match = regex.search(r"update serial number:\s*(\d+)", line)
            update_firmware_serial_number = match.group(1)
            return FWDevice(
                serial_number=update_firmware_serial_number,
                firmware_version="",
                is_recovery=True,
            )

        if match is None:
            return None
        device_serial_number = match.group(2)
        firmware_version = match.group(4)

        return FWDevice(
            serial_number=device_serial_number,
            firmware_version=firmware_version,
            is_recovery="Recovery" in line,
        )

    def _get_devices(self) -> List[FWDevice]:  # noqa: D102
        params = [FirmwareUpdater.path, "-l"]
        res = subprocess.check_output(params)
        devices = []
        for line in res.splitlines():
            print(line.decode("utf-8"))
            parsed_device = self.parse_device_line(line.decode("utf-8"))
            if parsed_device is None:
                continue
            else:
                devices.append(parsed_device)
        return devices

    def update_device(
        self, device: FWDevice, firmware_filepath: str
    ) -> bool:  # noqa: D102
        params = [
            FirmwareUpdater.path,
            "-f",
            firmware_filepath,
            "-s",
            device.serial_number,
        ]

        if device.is_recovery:
            params.append("-r")

        res = subprocess.check_output(params)
        if "Firmware update done" not in res.decode("utf-8"):
            print("Failed to update device, check the log:")
            print(res.decode("utf-8"))
            return False

        print("Device updated successfully")
        return True


def update_firmware(
    filename: str, firmware_updater: Optional[FirmwareUpdater] = None
) -> None:
    """Updates the firmware of the connected cameras from the provided binary file.

    Args:
        filename (str): Name of the binary file containing the realsense update.
        firmware_updater (Optional[FirmwareUpdater], optional): _description_. Defaults to None.

    Raises:
        FileNotFoundError: _description_
    """
    from rich.console import Console

    console = Console()

    firmware_updater = FirmwareUpdater()
    file_path = Path(filename)
    if not file_path.exists() and file_path.is_file:
        raise FileNotFoundError(file_path.resolve())
    devices = firmware_updater.devices
    console.print(f"Will update {devices} - DO NOT DISCONNECT THE CAMERAS!")
    for device in devices:
        if device.firmware_version in ("5.15.1", "05.15.01.00"):
            console.print(
                f"Device {device.serial_number} is already up to date {device.firmware_version} [green]:heavy_check_mark: [/green]"
            )
            continue
        console.print(f"Updating {device.serial_number} ...")
        res = firmware_updater.update_device(device, str(file_path.resolve()))
        if res:
            console.print(
                f" ({device.serial_number}) updated successfully ! [green]:heavy_check_mark: [/green]"
            )
        else:
            console.print(
                f" ({device.serial_number}) failed to update [red]:heavy_multiplication_x: [/red]"
            )


if __name__ == "__main__":
    update_firmware("Signed_Image_UVC_5_15_1_0.bin")
