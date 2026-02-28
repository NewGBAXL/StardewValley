# Fix decompiler accessor artifacts and a few malformed returns
Get-ChildItem -Path . -Recurse -Filter *.cs | ForEach-Object {
    $path = $_.FullName
    $text = Get-Content -Raw -Encoding UTF8 $path
    $new = $text -replace 'delegate\(get\)\s*\{','get {' -replace 'delegate\(set\)\s*\{','set {' -replace 'return\s+throw\s+','throw '
    if ($new -ne $text) {
        Set-Content -Path $path -Value $new -Encoding UTF8
        Write-Host "Patched: $path"
    }
}
Write-Host "Done."