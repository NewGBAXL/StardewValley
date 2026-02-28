# Replace simple C# 9+ `with { ... }` usages with equivalent older constructs
# - Vector2 declarations using Vector2.Zero with { X = ..., Y = ... } -> new Vector2(...)
# - (boundingBox with { Height = N }).Intersects(rect) -> (new Rectangle(boundingBox.X, boundingBox.Y, boundingBox.Width, N)).Intersects(rect)
# Saves backups as <file>.bak
$patched = @()
Get-ChildItem -Recurse -Include *.cs | ForEach-Object {
    $path = $_.FullName
    $text = Get-Content -Raw -Encoding UTF8 $path
    $orig = $text

    # Vector2 declaration: Vector2 name = Vector2.Zero with { X = expr1, Y = expr2 };
    $text = [regex]::Replace($text, '\bVector2\s+([A-Za-z0-9_]+)\s*=\s*Vector2\.Zero\s*with\s*\{\s*X\s*=\s*([^,\}]+),\s*Y\s*=\s*([^\}]+)\s*\}\s*;', 'Vector2 $1 = new Vector2($2, $3);', [System.Text.RegularExpressions.RegexOptions]::Singleline)

    # Inline Vector2 expression: (someExpr with { X = a, Y = b }) -> new Vector2(a, b)
    $text = [regex]::Replace($text, '\(\s*([A-Za-z0-9_\.]+)\s*with\s*\{\s*X\s*=\s*([^,\}]+),\s*Y\s*=\s*([^\}]+)\s*\}\s*\)', 'new Vector2($2, $3)', [System.Text.RegularExpressions.RegexOptions]::Singleline)

    # Rectangle Height case used in BedFurniture: (boundingBox with { Height = 64 }).Intersects(rect)
    $text = [regex]::Replace($text, '\(\s*([A-Za-z0-9_\.]+)\s*with\s*\{\s*Height\s*=\s*([^\}]+)\s*\}\s*\)\.Intersects\(', '(new Rectangle($1.X, $1.Y, $1.Width, $2)).Intersects(', [System.Text.RegularExpressions.RegexOptions]::Singleline)

    if ($text -ne $orig) {
        Copy-Item $path ($path + '.bak') -Force
        Set-Content -Path $path -Value $text -Encoding UTF8
        $patched += $path
        Write-Host "Patched: $path"
    }
}
Write-Host "Done. Patched $($patched.Count) files. Backups saved as *.bak"