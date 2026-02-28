# Replace patterns like: EXPR is Type @name  -> (EXPR as Type) != null
# This removes the pattern-variable; backups saved as <file>.bak
$patched = @()
Get-ChildItem -Recurse -Include *.cs | ForEach-Object {
    $path = $_.FullName
    $text = Get-Content -Raw -Encoding UTF8 $path
    $orig = $text

    $text = [regex]::Replace($text, '([A-Za-z0-9_\)\]\>\.]+)\s+is\s+([A-Za-z0-9_\.]+)\s+@([A-Za-z0-9_]+)', '($1 as $2) != null')

    if ($text -ne $orig) {
        Copy-Item $path ($path + '.bak') -Force
        Set-Content -Path $path -Value $text -Encoding UTF8
        $patched += $path
        Write-Host "Patched: $path"
    }
}
Write-Host "Done. Patched $($patched.Count) files. Backups saved as *.bak"