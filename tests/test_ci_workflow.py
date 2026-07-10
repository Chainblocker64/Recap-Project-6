from pathlib import Path


def test_ci_workflow_runs_pytest_against_postgres():
    workflow_path = Path(__file__).resolve().parent.parent / ".github" / "workflows" / "ci.yml"
    assert workflow_path.exists(), "expected .github/workflows/ci.yml to exist"

    content = workflow_path.read_text()
    assert "uv run pytest" in content
    assert "postgres" in content.lower()
