import re
from pathlib import Path


def test_env_example_has_one_variable_per_line():
    path = Path(__file__).resolve().parent.parent / ".env.example"
    text = path.read_text()

    lines = [line for line in text.splitlines() if line.strip() and not line.startswith("#")]
    assert lines, "expected .env.example to have at least one variable"

    for line in lines:
        key, sep, value = line.partition("=")
        assert sep, f"malformed line (no '='): {line!r}"
        assert re.fullmatch(r"[A-Z_][A-Z0-9_]*", key), f"malformed key: {line!r}"
        assert not re.search(r"[A-Z_][A-Z0-9_]*=", value), (
            f"line's value contains an embedded second variable: {line!r}"
        )
