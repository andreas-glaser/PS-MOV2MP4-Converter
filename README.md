# PS-MOV2MP4-Converter

A PowerShell script to convert MOV files to MP4 using ffmpeg—with customizable settings, automatic file renaming, built-in trash bin support, and optional logging.

## Introduction

**PS-MOV2MP4-Converter** is a versatile PowerShell script designed to convert MOV files to MP4 format using ffmpeg. It offers fully customizable encoding parameters, automatically resolves output file naming conflicts (just like Windows), and **moves the original file to the Recycle Bin by default** after a successful conversion. Logging can be enabled to record detailed conversion information in log files stored alongside the script.

## Features

- **Customizable Conversion Settings:**  
  Adjust video codec, CRF (quality), preset, pixel format, and audio bitrate.
- **Automatic Output File Naming:**  
  If an output file with the intended name already exists, the script appends a numeric suffix (e.g., " (1)", " (2)", etc.) until a unique name is found.
- **Built-in Trash Bin Support:**  
  By default, the original MOV file is moved to the Recycle Bin after conversion. Use `-MoveToTrash:$false` if you prefer to keep the original file.
- **Optional Logging:**  
  Enable logging with the `-EnableLogging` switch to write `conversion.log` and `conversion_errors.log` in the script’s directory.
- **Recursive Processing:**  
  Process files in subdirectories using the `-Recurse` switch.
- **Progress Feedback:**  
  A visual progress bar and per-file conversion times provide real-time feedback.
- **Parameter Confirmation:**  
  A summary of your settings is displayed before conversion begins, allowing you to confirm or cancel the operation.

## Dependencies

- **PowerShell 7 or later:**  
  This script is designed for PowerShell 7+.
- **ffmpeg:**  
  Ensure ffmpeg is installed and available in your system’s PATH.
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

- **Convert files in a directory (non-recursive, with default settings):**
  ```powershell
  .\mov2mp4.ps1 -TargetDirectory "C:\Videos\MOVFiles"
  ```
  *This converts files and moves the original files to the Recycle Bin by default.*

- **Convert files recursively:**
  ```powershell
  .\mov2mp4.ps1 -TargetDirectory "C:\Videos\MOVFiles" -Recurse
  ```

- **Convert files and keep original files:**
  ```powershell
  .\mov2mp4.ps1 -TargetDirectory "C:\Videos\MOVFiles" -MoveToTrash:$false
  ```

- **Convert files with logging enabled (logs are created in the script's directory):**
  ```powershell
  .\mov2mp4.ps1 -TargetDirectory "C:\Videos\MOVFiles" -EnableLogging
  ```

- **Combine switches (recursive, keep originals, and logging enabled):**
  ```powershell
  .\mov2mp4.ps1 -TargetDirectory "C:\Videos\MOVFiles" -Recurse -MoveToTrash:$false -EnableLogging
  ```

- **Specify a custom output extension (e.g., ".mp4"):**
  ```powershell
  .\mov2mp4.ps1 -TargetDirectory "C:\Videos\MOVFiles" -OutputExtension ".mp4"
  ```

## Parameters

| Parameter           | Type    | Possible Values                                                                                                       | Default     | Description                                                                                                    |
|---------------------|---------|-----------------------------------------------------------------------------------------------------------------------|-------------|----------------------------------------------------------------------------------------------------------------|
| `-TargetDirectory`  | String  | Any valid directory path                                                                                              | *(Required)*| The directory containing MOV files to be converted. Validates that the directory exists.                       |
| `-Recurse`          | Switch  | Present or absent                                                                                                     | Absent      | Process files in subdirectories recursively.                                                                  |
| `-MoveToTrash`      | Boolean | `$true` or `$false`                                                                                                   | `$true`     | Move the original MOV file to the Recycle Bin after conversion. Use `-MoveToTrash:$false` to keep the original file. |
| `-EnableLogging`    | Switch  | Present or absent                                                                                                     | Absent      | Enable logging. Log files (`conversion.log` and `conversion_errors.log`) are created in the script’s directory.   |
| `-InputExtension`   | String  | File extension pattern (must start with `"*."`, e.g., `"*.mov"`)                                                       | `"*.mov"`   | File extension filter for input files.                                                                       |
| `-OutputExtension`  | String  | File extension (must start with a dot, e.g., `".mp4"`)                                                                | `".mp4"`    | Output file extension for the converted file.                                                                |
| `-VideoCodec`       | String  | `"libx265"`, `"libx264"`                                                                                               | `"libx265"` | The video codec to use for conversion.                                                                       |
| `-CRF`              | Int     | A number between 0 (lossless) and 51 (lowest quality)                                                                  | `23`        | CRF (Constant Rate Factor) value determining video quality. Lower values yield higher quality and larger file sizes. |
| `-Preset`           | String  | `"ultrafast"`, `"superfast"`, `"veryfast"`, `"faster"`, `"fast"`, `"medium"`, `"slow"`, `"veryslow"`, `"placebo"`         | `"slow"`    | Determines encoding speed and compression efficiency.                                                        |
| `-PixelFormat`      | String  | `"yuv420p"`, `"yuv422p"`, `"yuv444p"`                                                                                  | `"yuv420p"` | Pixel format for the output video.                                                                           |
| `-AudioCodec`       | String  | `"aac"`, `"copy"`                                                                                                     | `"aac"`     | The audio codec for conversion.                                                                              |
| `-AudioBitrate`     | String  | A bitrate pattern such as `"320k"` (must match a pattern like `^\d+k$`)                                                 | `"320k"`    | The audio bitrate for encoding.                                                                              |

## How It Works

1. **Parameter Confirmation:**  
   The script displays a summary of the provided settings and prompts you for confirmation before starting the conversion process.
2. **File Discovery:**  
   It scans the specified target directory (and subdirectories if `-Recurse` is used) for files matching the `-InputExtension`.
3. **Conversion:**  
   Each MOV file is converted to MP4 using ffmpeg with the provided parameters. If an output file name conflict occurs, a numeric suffix is appended to ensure the filename is unique.
4. **Optional File Management:**  
   By default, the original MOV file is moved to the Recycle Bin upon successful conversion. To keep the original file, run the script with `-MoveToTrash:$false`.
5. **Logging:**  
   If enabled, detailed conversion output and any errors are written to `conversion.log` and `conversion_errors.log` in the script's directory.
6. **Progress Feedback:**  
   A progress bar and individual file conversion times are displayed as files are processed. Once complete, the total conversion time is reported.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
