# Convert auto-property initializers (e.g. `public T Prop { get; } = new T();`) into
# a private backing field + explicit getter property.
# Usage: powershell -ExecutionPolicy Bypass -File .\.scripts\fix_auto_prop_init.ps1

$root = Get-Location
$files = Get-ChildItem -Path $root -Recurse -Filter *.cs | Where-Object { $_.FullName -notlike "*\bin\*" -and $_.FullName -notlike "*\obj\*" }
$pattern = '^(?<indent>\s*)(?<modifiers>(public|protected|internal|private)(?:\s+[^\s{]+)*)\s+(?<type>[^{}\r\n]+?)\s+(?<name>[A-Za-z_][A-Za-z0-9_]*)\s*\{\s*get;\s*\}\s*=\s*(?<init>.+);\s*$'
$regex = [regex]$pattern

foreach ($f in $files) {
    $text = Get-Content -Raw -Path $f.FullName -ErrorAction SilentlyContinue
    if ($null -eq $text) { continue }
    $lines = $text -split "\r?\n"
    $changed = $false
    for ($i = 0; $i -lt $lines.Length; $i++) {
        $line = $lines[$i]
        $m = $regex.Match($line)
        if ($m.Success) {
            $indent = $m.Groups['indent'].Value
            $modifiers = $m.Groups['modifiers'].Value.Trim()
            $type = $m.Groups['type'].Value.Trim()
            $name = $m.Groups['name'].Value.Trim()
            $init = $m.Groups['init'].Value.Trim()

            $fieldName = '_' + ($name.Substring(0,1).ToLower() + $name.Substring(1))

            # Ensure field name doesn't already exist in file (simple check)
            if ($text -match "\b$fieldName\b") {
                $fieldName = '_' + [System.Guid]::NewGuid().ToString('N').Substring(0,8) + '_' + $name
            }

            $fieldLine = "$indentprivate $type $fieldName = $init;"
            $propLine = "$indent$modifiers $type $name { get { return $fieldName; } }"

            $lines[$i] = $fieldLine
            # insert property line after field
            $pre = $lines[0..($i)]
            $post = if ($i -lt $lines.Length-1) { $lines[($i+1)..($lines.Length-1)] } else { @() }
            $lines = $pre + $propLine + $post
            $changed = $true
            # advance index to skip newly inserted prop
            $i++
            $text = ($lines -join "`r`n")
        }
    }
    if ($changed) {
        Copy-Item -Path $f.FullName -Destination "$($f.FullName).bak" -Force -ErrorAction SilentlyContinue
        Set-Content -Path $f.FullName -Value ($lines -join "`r`n") -Encoding UTF8
        Write-Output "Patched: $($f.FullName)"
    }
}
Write-Output "Done. Backups saved as *.bak"
