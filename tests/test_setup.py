from django.conf import settings


def test_settings_configured():
    assert settings.configured
