import pytest
from django.contrib.auth.models import User
from django.db import connection


def test_database_is_postgresql():
    assert connection.vendor == "postgresql"


@pytest.mark.django_db
def test_can_create_and_query_a_user():
    User.objects.create_user(username="alice", password="password123")
    assert User.objects.filter(username="alice").exists()
