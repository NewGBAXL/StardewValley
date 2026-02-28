# Replace 'delegate(Name)' artifacts and remove stray semicolons after accessors
Get-ChildItem -Path . -Recurse -Filter *.cs | ForEach-Object {
    $path = $_.FullName
    $text = Get-Content -Raw -Encoding UTF8 $path
    $new = $text
    # Replace delegate(Name) -> Name
    $new = [regex]::Replace($new, 'delegate\(([A-Za-z_][A-Za-z0-9_]*)\)', '$1')
    # Remove stray semicolon after get { ... };
    $new = [regex]::Replace($new, '(get\s*\{[\s\S]*?\})\s*;', '$1')
    # Remove stray semicolon after set { ... };
    $new = [regex]::Replace($new, '(set\s*\{[\s\S]*?\})\s*;', '$1')
    if ($new -ne $text) {
        Set-Content -Path $path -Value $new -Encoding UTF8
        Write-Host "Patched: $path"
    }
}
Write-Host "Done."