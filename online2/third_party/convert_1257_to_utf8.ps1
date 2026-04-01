# Convert file from Windows-1257 (Baltic) to UTF-8
# Usage: .\convert_1257_to_utf8.ps1 <filepath>

param(
    [Parameter(Mandatory=$true)]
    [string]$FilePath
)

$enc1257 = [System.Text.Encoding]::GetEncoding(1257)
$encUtf8 = [System.Text.Encoding]::UTF8

$content = [System.IO.File]::ReadAllText($FilePath, $enc1257)
[System.IO.File]::WriteAllText($FilePath, $content, $encUtf8)

Write-Host "Converted $FilePath from Windows-1257 to UTF-8."
