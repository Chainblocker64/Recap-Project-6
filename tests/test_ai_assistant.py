from ai_assistant.services import get_openai_client


def test_client_reads_api_key_from_env(monkeypatch):
    monkeypatch.setenv("OPENAI_API_KEY", "test-key-123")
    client = get_openai_client()
    assert client.api_key == "test-key-123"
