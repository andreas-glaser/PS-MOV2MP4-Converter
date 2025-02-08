param (
    [Parameter(Mandatory = $true)]
    [string]$TargetDirectory,

    [switch]$Recurse,

    # If specified, the original file is moved to the Recycle Bin after conversion;
    # otherwise, the original file is kept in place.
    [switch]$MoveToTrash,

    # If specified, logging is enabled. Log files (conversion.log and conversion_errors.log)
    # are written to the same directory as the script.
    [switch]$EnableLogging,

    [string]$InputExtension = "*.mov",
    [string]$VideoCodec     = "libx265",
    [string]$CRF            = "23",       # CRF set to 23 as requested
    [string]$Preset         = "slow",
    [string]$PixelFormat    = "yuv420p",
    [string]$AudioCodec     = "aac",
    [string]$AudioBitrate   = "320k"
)

# Build a formatted parameter summary.
$parametersMessage = @"
------------------------------------------
         Conversion Parameters
------------------------------------------
Target Directory : $TargetDirectory
Recurse          : $Recurse
Move To Trash    : $MoveToTrash
Enable Logging   : $EnableLogging
Input Extension  : $InputExtension
Video Codec      : $VideoCodec
CRF              : $CRF
Preset           : $Preset
Pixel Format     : $PixelFormat
Audio Codec      : $AudioCodec
Audio Bitrate    : $AudioBitrate
------------------------------------------
"@

# Display the parameter summary.
Write-Host $parametersMessage -ForegroundColor Cyan

# Ask for confirmation before proceeding.
$confirmation = Read-Host "Do you really want to convert files in '$TargetDirectory' with the above settings? (Y/N)"
if ($confirmation -notmatch '^[Yy]$') {
    Write-Host "Operation cancelled." -ForegroundColor Yellow
    exit
}

# If logging is enabled, define log file paths in the script directory; otherwise, leave as $null.
if ($EnableLogging) {
    $logFile = Join-Path $PSScriptRoot "conversion.log"
    $errorLogFile = Join-Path $PSScriptRoot "conversion_errors.log"
}
else {
    $logFile = $null
    $errorLogFile = $null
}

# Build the file list.
if ($Recurse) {
    $fileList = Get-ChildItem -Path $TargetDirectory -Filter $InputExtension -Recurse
} else {
    $fileList = Get-ChildItem -Path $TargetDirectory -Filter $InputExtension
}

$totalFiles = $fileList.Count
if ($totalFiles -eq 0) {
    Write-Host "No files found in '$TargetDirectory' matching '$InputExtension'." -ForegroundColor Yellow
    exit
}

Write-Host "Found $totalFiles file(s) to convert."

$counter = 0
foreach ($file in $fileList) {
    $counter++

    # Build the base output file path (same directory, with .mp4 extension)
    $outputFile = Join-Path $file.DirectoryName "$($file.BaseName).mp4"

    # Check if the output file already exists; if so, append a numeric suffix.
    if (Test-Path $outputFile) {
        $baseName = $file.BaseName
        $extension = ".mp4"
        $i = 1
        do {
            $newName = "$baseName ($i)$extension"
            $newOutputFile = Join-Path $file.DirectoryName $newName
            $i++
        } while (Test-Path $newOutputFile)
        $outputFile = $newOutputFile
    }

    Write-Host "Starting conversion: $($file.FullName)" -ForegroundColor Cyan

    # Prepare ffmpeg arguments as an array to avoid quoting issues.
    $arguments = @(
        "-y",                      # Overwrite output file without asking.
        "-i", $file.FullName,      # Input file.
        "-map_metadata", "0",      # Copy metadata.
        "-c:v", $VideoCodec,       # Video codec.
        "-crf", $CRF,              # CRF value.
        "-preset", $Preset,        # Preset.
        "-pix_fmt", $PixelFormat,  # Pixel format.
        "-c:a", $AudioCodec,       # Audio codec.
        "-b:a", $AudioBitrate,     # Audio bitrate.
        "-movflags", "+faststart", # Optimize MP4 for streaming.
        $outputFile              # Output file.
    )

    # Execute ffmpeg conversion.
    $ffmpegOutput = & ffmpeg @arguments 2>&1

    # If logging is enabled, append ffmpeg output to the conversion log.
    if ($EnableLogging -and $logFile) {
        Add-Content -Path $logFile -Value $ffmpegOutput
    }

    # Check if ffmpeg failed.
    if ($LASTEXITCODE -ne 0) {
        $errorMessage = "$($file.FullName) - Error: ffmpeg conversion failed with exit code $LASTEXITCODE"
        Write-Host "Error converting $($file.FullName): $errorMessage" -ForegroundColor Red
        if ($EnableLogging -and $errorLogFile) {
            Add-Content -Path $errorLogFile -Value $errorMessage
        }
    }
    else {
        Write-Host "Finished conversion: $($file.FullName) -> $outputFile" -ForegroundColor Green

        # If the -MoveToTrash switch was specified, move the original file.
        if ($MoveToTrash) {
            # Load the required assembly for Recycle Bin functionality.
            Add-Type -AssemblyName Microsoft.VisualBasic

            # Move the original file to the Recycle Bin.
            [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile(
                $file.FullName,
                'OnlyErrorDialogs',    # Suppress UI dialogs unless errors occur.
                'SendToRecycleBin'     # Move file to the Recycle Bin.
            )
            Write-Host "Moved to Recycle Bin: $($file.FullName)" -ForegroundColor Yellow
        }
        else {
            Write-Host "Original file kept in place: $($file.FullName)" -ForegroundColor Yellow
        }
    }

    # Update the progress bar.
    $percentComplete = ($counter / $totalFiles) * 100
    Write-Progress -Activity "Converting files" `
                   -Status "$counter of $totalFiles processed ($([math]::Round($percentComplete,2))%)" `
                   -PercentComplete $percentComplete
}

Write-Host "All conversions complete." -ForegroundColor Green
