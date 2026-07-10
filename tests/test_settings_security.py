from pathlib import Path


def _settings_source():
    path = Path(__file__).resolve().parent.parent / "config" / "settings.py"
    return path.read_text()


def test_secret_key_is_read_from_env():
    assert "SECRET_KEY = env(" in _settings_source()


def test_debug_is_read_from_env():
    assert "DEBUG = env.bool(" in _settings_source()
