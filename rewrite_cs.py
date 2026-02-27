import re
from pathlib import Path
from tqdm import tqdm

ROOT_FOLDER = r"C:\Users\newgb\Documents\GitHub\StardewValley"
DRY_RUN = False

# Matches expression-bodied methods/properties
method_pattern = re.compile(
    r'(\b[\w<>\[\],\s]+\s+\w+\s*\([^;{}]*?\))\s*=>\s*(.+?);',
    re.MULTILINE
)

# Matches simple lambdas like: x => x+1
lambda_pattern = re.compile(
    r'(\b\w+\b)\s*=>\s*([^;,\n]+)'
)

def rewrite_expression_bodied_methods(text):
    def repl(match):
        signature = match.group(1).strip()
        body = match.group(2).strip()

        if signature.startswith("void"):
            return f"{signature} {{ {body}; }}"
        else:
            return f"{signature} {{ return {body}; }}"
    return method_pattern.sub(repl, text)


def rewrite_simple_lambdas(text):
    def repl(match):
        param = match.group(1)
        body = match.group(2).strip()
        return f"delegate({param}) {{ return {body}; }}"
    return lambda_pattern.sub(repl, text)


def process_file(path):
    try:
        original = path.read_text(encoding="utf-8")

        if "=>" not in original:
            return False

        modified = original
        modified = rewrite_expression_bodied_methods(modified)
        modified = rewrite_simple_lambdas(modified)

        if modified != original:
            if not DRY_RUN:
                path.write_text(modified, encoding="utf-8")
            return True

        return False

    except Exception as e:
        print(f"\nError in {path}: {e}")
        return False


def main():
    files = list(Path(ROOT_FOLDER).rglob("*.cs"))
    print(f"Found {len(files)} C# files")

    changed = 0

    for file in tqdm(files, desc="Rewriting", unit="file"):
        if process_file(file):
            changed += 1

    print(f"\nDone. Modified {changed} files.")


if __name__ == "__main__":
    main()
