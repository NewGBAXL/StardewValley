# Fix malformed generic tokens where decompiler inserted "; }, Net" instead of ", Net"
# Usage: run from repository root
# powershell -ExecutionPolicy Bypass -File .\.scripts\fix_semicolon_generic.ps1

$root = Get-Location
$files = Get-ChildItem -Path $root -Recurse -Filter *.cs | Where-Object { $_.FullName -notlike "*\bin\*" -and $_.FullName -notlike "*\obj\*" }

foreach ($f in $files) {
    try {
        $text = Get-Content -Raw -Path $f.FullName -ErrorAction Stop
    } catch {
        Write-Warning "Could not read $($f.FullName): $_"
        continue
    }
    $new = $text -replace ";\s*\},\s*Net", ", Net"
    if ($new -ne $text) {
        Copy-Item -Path $f.FullName -Destination "$($f.FullName).bak" -Force -ErrorAction SilentlyContinue
        Set-Content -Path $f.FullName -Value $new -Encoding UTF8
        Write-Output "Patched: $($f.FullName)"
    }
}
Write-Output "Done. Review .bak files to revert individual files if needed."
