# Fix common malformed syntax introduced by naive conversions.
# BACKUP recommended.
Get-ChildItem -Recurse -Filter *.cs | ForEach-Object {
    $path = $_.FullName
    $text = Get-Content -Raw -Encoding UTF8 -LiteralPath $path
    $orig = $text

    # 1) Fix '== )' -> '== null)'
    $text = $text -replace '==\s*\)', '== null)'

    # 2) Add missing 'get' before property return bodies when declaration appears to be a property (no '(' in the header)
    # Pattern: line starts with access modifier and contains '{' followed by optional whitespace and 'return'
    $text = [regex]::Replace($text, '(?m)^(\s*(?:public|protected|private|internal)\b[^\(\r\n]*?)\{\s*return', '${1}{ get { return')

    # 3) Remove 'return ' from setters (set { return X = value; } -> set { X = value; })
    $text = $text -replace 'set\s*\{\s*return\s+', 'set { '

    # 4) Remove 'return ' immediately after opening brace in void methods: 'void Name(...) { return expr; }' -> 'void Name(...) { expr; }'
    $text = [regex]::Replace($text, '(?ms)(\bvoid\s+[A-Za-z0-9_]+\s*\([^\)]*\)\s*\{)\s*return\s+', '${1} ')

    # 5) Ensure property setters that used 'return <assignment>;' now end without extra 'return'
    # (clean up any 'return this.' leftover in void contexts) - redundant with above.

    if ($text -ne $orig) {
        Set-Content -Encoding UTF8 -LiteralPath $path -Value $text
        Write-Output "Patched: $path"
    }
}
Write-Output "Done."