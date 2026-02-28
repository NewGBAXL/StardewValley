# Fix common null-conditional operator patterns introduced by the decompiler
# Saves backups as <file>.bak before writing
$patched = @()
Get-ChildItem -Recurse -Include *.cs | ForEach-Object {
    $path = $_.FullName
    $text = Get-Content -Raw -Encoding UTF8 $path
    $orig = $text

    # 1) expr?.ToString() ?? ""  -> (expr != null ? expr.ToString() : "")
    $text = [regex]::Replace($text, '([A-Za-z0-9_\.]+)\?\.\s*ToString\(\)\s*\?\?\s*""', '($1 != null ? $1.ToString() : "")')

    # 2) expr?.ToString() ?? defaultValue
    $text = [regex]::Replace($text, '([A-Za-z0-9_\.]+)\?\.\s*ToString\(\)\s*\?\?\s*([^,\)\;\n]+)', '($1 != null ? $1.ToString() : $2)')

    # 3) expr?.ToString() -> (expr != null ? expr.ToString() : null)
    $text = [regex]::Replace($text, '([A-Za-z0-9_\.]+)\?\.\s*ToString\(\)', '($1 != null ? $1.ToString() : null)')

    # 4) statement calls: obj?.Method(args); -> if (obj != null) obj.Method(args);
    $text = [regex]::Replace($text, '([A-Za-z0-9_\.]+)\?\.(\w+)\((.*?)\);', 'if ($1 != null) $1.$2($3);', [System.Text.RegularExpressions.RegexOptions]::Singleline)

    # 5) nullable int assignment: int? name = obj?.Member; -> int? name = (obj != null ? (int?)obj.Member : null);
    $text = [regex]::Replace($text, 'int\?\s+([A-Za-z0-9_]+)\s*=\s*([A-Za-z0-9_\.]+)\?\.([A-Za-z0-9_]+);', 'int? $1 = ($2 != null ? (int?) $2.$3 : null);')

    if ($text -ne $orig) {
        Copy-Item $path ($path + '.bak') -Force
        Set-Content -Path $path -Value $text -Encoding UTF8
        $patched += $path
        Write-Host "Patched: $path"
    }
}
Write-Host "Done. Patched $($patched.Count) files. Backups saved as *.bak"