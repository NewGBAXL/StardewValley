# Convert patterns like:
#   return EXPR is Type name ? name.Method(...) : other;
# into:
#   var __maybe = EXPR as Type;
#   return __maybe != null ? __maybe.Method(...) : other;

$patched = @()
Get-ChildItem -Recurse -Include *.cs | ForEach-Object {
    $path = $_.FullName
    $text = Get-Content -Raw -Encoding UTF8 $path
    $orig = $text

    $pattern = 'return\s+([^;]+?)\s+is\s+([A-Za-z0-9_\.]+)\s+([A-Za-z0-9_]+)\s*\?\s*([^:;]+)\s*:\s*([^;]+);'
    $replacement = 'var __maybe = $1 as $2;\n        return __maybe != null ? $4 : $5;'

    $new = [regex]::Replace($text, $pattern, $replacement, [System.Text.RegularExpressions.RegexOptions]::Singleline)

    if ($new -ne $orig) {
        Copy-Item $path ($path + '.bak') -Force
        Set-Content -Path $path -Value $new -Encoding UTF8
        $patched += $path
        Write-Host "Patched: $path"
    }
}
Write-Host "Done. Patched $($patched.Count) files. Backups saved as *.bak"