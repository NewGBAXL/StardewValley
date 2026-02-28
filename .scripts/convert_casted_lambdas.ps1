# Convert explicitly cast lambdas like (Action) (() => ...) and (Func<...>) (() => ...) to delegate(...) { ... } or delegate(...) { return ...; }
Get-ChildItem -Recurse -Filter *.cs | ForEach-Object {
    $path = $_.FullName
    $text = Get-Content -Raw -Encoding UTF8 -LiteralPath $path
    $orig = $text

    $regex = [regex] '(\(\s*(?<cast>[^)]+)\s*\))\s*\(\s*\(\s*(?<params>[^)]*)\)\s*=>\s*(?<body>.*?)\)'
    $text = $regex.Replace($text, {
        param($m)
        $cast = $m.Groups['cast'].Value.Trim()
        $params = $m.Groups['params'].Value.Trim()
        $body = $m.Groups['body'].Value.Trim()
        if ($cast -match '\bAction\b' -or $cast -match '\bAction<') {
            if ($body -notmatch ';$') { $body = $body + ';' }
            $paramsOut = if ($params -eq '') { '' } else { $params }
            return "($cast) (delegate($paramsOut) { $body })"
        } else {
            # Assume Func - return the expression
            if ($body -match '^\{') {
                # already a block
                return "($cast) (delegate($params) $body)"
            }
            if ($body -notmatch ';$') { $bodyOut = "return $body;" } else { $bodyOut = $body }
            $paramsOut = if ($params -eq '') { '' } else { $params }
            return "($cast) (delegate($paramsOut) { $bodyOut })"
        }
    })

    if ($text -ne $orig) {
        Set-Content -Encoding UTF8 -LiteralPath $path -Value $text
        Write-Output "Patched: $path"
    }
}
Write-Output "Done."