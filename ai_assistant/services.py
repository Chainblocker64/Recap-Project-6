import environ
from openai import OpenAI

env = environ.Env()


def get_openai_client():
    return OpenAI(api_key=env("OPENAI_API_KEY"))
