# PS-MOV2MP4-Converter

A PowerShell script to convert MOV files to MP4 using ffmpeg—with customizable settings, automatic file renaming, optional trash bin support, and optional logging.

## Introduction

**PS-MOV2MP4-Converter** is a simple yet powerful PowerShell script designed to convert MOV files to MP4 format using ffmpeg. It provides customizable encoding parameters, handles output file naming conflicts automatically (just like Windows does), and offers an option to move the original file to the Recycle Bin after conversion. Additionally, logging can be enabled to record conversion details in log files stored alongside the script.

## Features

- **Customizable Conversion Settings:**  
  Adjust video codec, CRF, preset, pixel format, and audio bitrate.
- **Automatic Output File Naming:**  
  If an output MP4 file with the intended name already exists, the script appends a numeric suffix (e.g., " (1)", " (2)", etc.) until a unique name is found.
- **Optional Trash Bin Support:**  
  Use the `-MoveToTrash` switch to move the original MOV file to the Recycle Bin after a successful conversion; by default, the original file is kept in place.
- **Optional Logging:**  
  Enable logging with the `-EnableLogging` switch to write `conversion.log` and `conversion_errors.log` in the same directory as the script. Logging is disabled by default.
- **Recursive Processing:**  
  Optionally process files in subdirectories with the `-Recurse` switch.
- **Progress Bar:**  
  A visual progress bar displays conversion progress.

## Dependencies

- **PowerShell 7 or later:**  
  This script is designed for PowerShell 7+.
- **ffmpeg:**  
  The script relies on ffmpeg for the conversion process. Ensure ffmpeg is installed and available in your system’s PATH.
- **Microsoft.VisualBasic Assembly:**  
  Used to move files to the Recycle Bin (included by default on Windows).

## Installation

1. Clone or download the repository.
2. Ensure ffmpeg is installed and added to your system PATH.
3. Open PowerShell (version 7 or later) and navigate to the repository directory.

## Usage

Run the script using the following syntax:

```powershell
.\mov2mp4.ps1 -TargetDirectory "Path\To\Your\Directory" [-Recurse] [-MoveToTrash] [-EnableLogging] [other parameters]
```

### Examples

- **Convert files in a directory (non-recursive):**
  ```powershell
  .\mov2mp4.ps1 -TargetDirectory "C:\Videos\MOVFiles"
  ```

- **Convert files recursively:**
  ```powershell
  .\mov2mp4.ps1 -TargetDirectory "C:\Videos\MOVFiles" -Recurse
  ```

- **Convert files and move originals to the Recycle Bin:**
  ```powershell
  .\mov2mp4.ps1 -TargetDirectory "C:\Videos\MOVFiles" -MoveToTrash
  ```

- **Convert files with logging enabled (logs are created in the same directory as the script):**
  ```powershell
  .\mov2mp4.ps1 -TargetDirectory "C:\Videos\MOVFiles" -EnableLogging
  ```

- **Combine switches (recursive, move originals, and logging enabled):**
  ```powershell
  .\mov2mp4.ps1 -TargetDirectory "C:\Videos\MOVFiles" -Recurse -MoveToTrash -EnableLogging
  ```

## Parameters

| Parameter           | Type    | Possible Values                                                                                                     | Default     | Description                                                                                         |
|---------------------|---------|---------------------------------------------------------------------------------------------------------------------|-------------|-----------------------------------------------------------------------------------------------------|
| `-TargetDirectory`  | String  | Any valid directory path                                                                                            | *(Required)*| The directory containing MOV files to be converted.                                               |
| `-Recurse`          | Switch  | Present or absent                                                                                                   | Absent      | Process files in subdirectories recursively.                                                      |
| `-MoveToTrash`      | Switch  | Present or absent                                                                                                   | Absent      | If specified, move the original MOV file to the Recycle Bin after conversion; otherwise, keep it.   |
| `-EnableLogging`    | Switch  | Present or absent                                                                                                   | Absent      | If specified, enable logging. Log files are created in the same directory as the script.             |
| `-InputExtension`   | String  | Any valid file extension pattern (e.g., `"*.mov"`)                                                                  | `"*.mov"`   | File extension filter for input files.                                                            |
| `-VideoCodec`       | String  | Any ffmpeg-compatible video codec (e.g., `"libx265"`, `"libx264"`)                                                  | `"libx265"` | The video codec to use for conversion.                                                            |
| `-CRF`              | String  | Numeric value as a string (e.g., `"18"`, `"23"`, `"28"`)                                                            | `"23"`      | The Constant Rate Factor for video quality (lower means higher quality and larger file size).        |
| `-Preset`           | String  | ffmpeg presets such as `"ultrafast"`, `"superfast"`, `"veryfast"`, `"faster"`, `"fast"`, `"medium"`, `"slow"`, `"veryslow"` | `"slow"`    | Determines encoding speed and compression efficiency.                                             |
| `-PixelFormat`      | String  | Typically `"yuv420p"`                                                                                               | `"yuv420p"` | Pixel format for the output video (most compatible).                                              |
| `-AudioCodec`       | String  | Any ffmpeg-compatible audio codec (e.g., `"aac"`, `"copy"`)                                                         | `"aac"`     | The audio codec for conversion.                                                                   |
| `-AudioBitrate`     | String  | Bitrate values such as `"320k"`, `"256k"`, `"128k"`                                                                 | `"320k"`    | The audio bitrate for encoding.                                                                   |

## How It Works

1. **Parameter Summary:**  
   When you run the script, it displays a formatted summary of your settings so you can review them before confirming.
2. **File Discovery:**  
   The script scans the specified target directory (and subdirectories if `-Recurse` is provided) for files matching the input extension.
3. **Conversion:**  
   Each MOV file is converted to MP4 using ffmpeg with the specified parameters. If an output file name conflict occurs, the script automatically appends a numeric suffix until a unique name is found.
4. **Optional File Moving:**  
   If the `-MoveToTrash` switch is used, the original MOV file is moved to the Recycle Bin upon successful conversion.
5. **Optional Logging:**  
   If logging is enabled with `-EnableLogging`, conversion details and errors are logged into `conversion.log` and `conversion_errors.log` in the script's directory.
6. **Progress Feedback:**  
   A progress bar updates as each file is processed.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
