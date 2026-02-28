# Fix semicolons that immediately follow accessor blocks (get { ... }; or set { ... };)
# Usage: run from repository root
# powershell -ExecutionPolicy Bypass -File .\.scripts\fix_accessor_semicolons.ps1

$root = Get-Location
$files = Get-ChildItem -Path $root -Recurse -Filter *.cs | Where-Object { $_.FullName -notlike "*\bin\*" -and $_.FullName -notlike "*\obj\*" }
$patternGet = '(?s)(get\s*\{.*?\})\s*;'
$patternSet = '(?s)(set\s*\{.*?\})\s*;'
$encoding = [System.Text.Encoding]::UTF8

foreach ($f in $files) {
    try {
        $text = Get-Content -Raw -Path $f.FullName -ErrorAction Stop
    } catch {
        Write-Warning "Could not read $($f.FullName): $_"
        continue
    }
    $new = [System.Text.RegularExpressions.Regex]::Replace($text, $patternGet, '$1')
    $new = [System.Text.RegularExpressions.Regex]::Replace($new, $patternSet, '$1')
    if ($new -ne $text) {
        Copy-Item -Path $f.FullName -Destination "$($f.FullName).bak" -Force -ErrorAction SilentlyContinue
        Set-Content -Path $f.FullName -Value $new -Encoding UTF8
        Write-Output "Patched: $($f.FullName)"
    }
}
Write-Output "Done. Review .bak files if you need to revert individual files."
