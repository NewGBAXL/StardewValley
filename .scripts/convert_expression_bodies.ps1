# Convert expression-bodied members (methods/properties) using '=>' to block-bodied forms.
Get-ChildItem -Recurse -Filter *.cs | ForEach-Object {
    $path = $_.FullName
    $text = Get-Content -Raw -Encoding UTF8 -LiteralPath $path
    $orig = $text

    # Method-like (has parentheses before =>)
    $methodPattern = '(?m)^(\s*(?:public|protected|private|internal|static|virtual|override|sealed|extern|new|unsafe|readonly|volatile|\s)+[^\n(]*\([^\)]*\))\s*=>\s*(?<body>[^;]+);'
    $text = [regex]::Replace($text, $methodPattern, {
        param($m)
        $sig = $m.Groups[1].Value.TrimEnd()
        $body = $m.Groups['body'].Value.Trim()
        if ($sig -match '\bvoid\b') { return "$sig { $body; }" }
        return "$sig { return $body; }"
    })

    # Property-like (no parentheses before =>)
    $propPattern = '(?m)^(\s*(?:public|protected|private|internal|static|virtual|override|sealed|extern|new|readonly|volatile|\s)+[A-Za-z0-9_<>\[\],\s]+\s+[A-Za-z0-9_]+)\s*=>\s*(?<body>[^;]+);'
    $text = [regex]::Replace($text, $propPattern, {
        param($m)
        $sig = $m.Groups[1].Value.Trim()
        $body = $m.Groups['body'].Value.Trim()
        return "$sig { get { return $body; } }"
    })

    if ($text -ne $orig) {
        Set-Content -Encoding UTF8 -LiteralPath $path -Value $text
        Write-Output "Patched: $path"
    }
}
Write-Output "Done."