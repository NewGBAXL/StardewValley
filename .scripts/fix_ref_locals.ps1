# Replace local ref declarations like: ref float x = ref someExpr;  ->  float x = someExpr;
# Saves backups as <file>.bak before writing
$patched = @()
Get-ChildItem -Recurse -Include *.cs | ForEach-Object {
    $path = $_.FullName
    $text = Get-Content -Raw -Encoding UTF8 $path
    $orig = $text

    $text = [regex]::Replace($text, '\bref\s+([A-Za-z0-9_<>,\[\]\.\s]+?)\s+([A-Za-z0-9_]+)\s*=\s*ref\s*([^;]+);', '$1 $2 = $3;', [System.Text.RegularExpressions.RegexOptions]::Multiline)

    # handle `ref var name = ref expr;` -> `var name = expr;`
    $text = [regex]::Replace($text, '\bref\s+var\s+([A-Za-z0-9_]+)\s*=\s*ref\s*([^;]+);', 'var $1 = $2;', [System.Text.RegularExpressions.RegexOptions]::Multiline)

    if ($text -ne $orig) {
        Copy-Item $path ($path + '.bak') -Force
        Set-Content -Path $path -Value $text -Encoding UTF8
        $patched += $path
        Write-Host "Patched: $path"
    }
}
Write-Host "Done. Patched $($patched.Count) files. Backups saved as *.bak"