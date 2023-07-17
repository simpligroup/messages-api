import os
from pytest_bdd import scenarios, given, when, then, parsers
from fastapi.testclient import TestClient
from src.app.main import app
import json

scenarios("create_channel.feature", "manage_consumer.feature")

client = TestClient(app)
request_body = ""
response = ""


@given(parsers.parse("The body:\n{body}"))
def set_body(body):
    global request_body
    request_body = json.loads(body)


@when(parsers.parse('I send a PUT request to "{url}" with the body'))
def send_put_request(url):
    global response
    response = client.put(url, json=request_body)


@then(parsers.parse('the response status code should be "{code}"'))
def check_response_status_code_201(code):
    assert response.status_code == int(code)


@then("the response should be empty")
def check_response_empty():
    assert response.json() is None
