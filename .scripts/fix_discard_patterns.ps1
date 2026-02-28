# Replace pattern match discards like 'case Type _:' and 'is Type _' which can cause parse errors on older compilers.
Get-ChildItem -Recurse -Filter *.cs | ForEach-Object {
    $path = $_.FullName
    $text = Get-Content -Raw -Encoding UTF8 -LiteralPath $path
    $orig = $text

    # case Type _:
    $text = [regex]::Replace($text, 'case\s+([A-Za-z0-9_<>\\.]+)\s+_\s*:', 'case $1:')

    # is Type _ (e.g., if (x is Type _)) -> is Type
    $text = [regex]::Replace($text, '\bis\s+([A-Za-z0-9_<>\\.]+)\s+_', 'is $1')

    if ($text -ne $orig) {
        Set-Content -Encoding UTF8 -LiteralPath $path -Value $text
        Write-Output "Patched: $path"
    }
}
Write-Output "Done."