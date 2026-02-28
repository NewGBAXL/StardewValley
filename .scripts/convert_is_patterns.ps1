# Converts common C# pattern-matching `is Type var` idioms to older `as` + null-check forms.
# WARNING: This is a brute-force textual transform and may introduce compile errors. Back up before running.
Get-ChildItem -Recurse -Filter *.cs | ForEach-Object {
    $path = $_.FullName
    $text = Get-Content -Raw -Encoding UTF8 -LiteralPath $path
    $original = $text

    # Pattern 1: if (!(EXPR is TYPE VAR)) return;
    $regex1 = [regex] 'if\s*\(\s*!\(\s*(?<expr>.+?)\s+is\s+(?<type>[A-Za-z0-9_<>.,\[\]]+)\s+(?<var>[A-Za-z_][A-Za-z0-9_]*)\s*\)\s*\)\s*return\s*;'
    $text = $regex1.Replace($text, {
        param($m)
        $expr = $m.Groups['expr'].Value.Trim()
        $type = $m.Groups['type'].Value.Trim()
        $var = $m.Groups['var'].Value.Trim()
        "$type $var = $expr as $type;`r`n      if ($var == $null)`r`n        return;"
    })

    # Pattern 2: if (EXPR is TYPE VAR) {
    $regex2 = [regex] 'if\s*\(\s*(?<expr>.+?)\s+is\s+(?<type>[A-Za-z0-9_<>.,\[\]]+)\s+(?<var>[A-Za-z_][A-Za-z0-9_]*)\s*\)\s*\{'
    $text = $regex2.Replace($text, {
        param($m)
        $expr = $m.Groups['expr'].Value.Trim()
        $type = $m.Groups['type'].Value.Trim()
        $var = $m.Groups['var'].Value.Trim()
        "$type $var = $expr as $type;`r`n      if ($var != $null) {"
    })

    if ($text -ne $original) {
        Set-Content -Encoding UTF8 -LiteralPath $path -Value $text
        Write-Output "Patched: $path"
    }
}
Write-Output "Done."