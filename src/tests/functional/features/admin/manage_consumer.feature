Feature: Create a new consumer
  In order to have consumers through which messages are sent 
  As a user with admin permissions
  I want to create a new consumer

  Scenario: A valid non existing consumer
    Given The body:
      """
      {
        "id": "ef8ac118-8d7f-49cc-abec-78e0d05af80a",
        "name": "harley-davidson",
        "services": [
          {
            "id": "ea6a02d4-250f-11ee-be56-0242ac120002",
            "name": "leads-catcher",
            "hostName": "localhost",
            "endpoint": "/lead"
          }
        ]
      }
      """
    When I send a PUT request to "/consumers/ef8ac118-8d7f-49cc-abec-78e0d05af80a" with the body
    Then the response status code should be "201"
    And the response should be empty

  Scenario: Update a valid existing consumer
    Given The body:
      """
      {
        "id": "ef8ac118-8d7f-49cc-abec-78e0d05af80a",
        "name": "harley-davidson",
        "services": [
          {
            "id": "ea6a02d4-250f-11ee-be56-0242ac120002",
            "name": "leads-catcher",
            "hostName": "localhost",
            "endpoint": "/leads"
          },
          {
            "id": "9832ead4-2510-11ee-be56-0242ac120002",
            "name": "customer",
            "hostName": "localhost",
            "endpoint": "/customers"
          }
        ]
      }
      """
    When I send a PUT request to "/consumers/ef8ac118-8d7f-49cc-abec-78e0d05af80a" with the body
    Then the response status code should be "200"
    And the response should be empty

  Scenario: An invalid consumer, no services
    Given The body:
      """
      {
        "id": "56d09f90-2511-11ee-be56-0242ac120002",
        "name": "harley-davidson",
        "services": []
      }
      """
    When I send a PUT request to "/consumers/56d09f90-2511-11ee-be56-0242ac120002" with the body
    Then the response status code should be "422"

  Scenario: An invalid consumer, the ids do not match
    Given The body:
      """
      {
        "id": "56d0a38c-2511-11ee-be56-0242ac120002",
        "name": "harley-davidson",
        "services": [
          {
            "id": "9832ead4-2510-11ee-be56-0242ac120002",
            "name": "customer",
            "hostName": "localhost",
            "endpoint": "/customers"
          }
        ]
      }
      """
    When I send a PUT request to "/consumers/56d0a5e4-2511-11ee-be56-0242ac120002" with the body
    Then the response status code should be "422"
  
  Scenario: An invalid consumer, bad naming
    Given The body:
      """
      {
        "id": "56d0a80a-2511-11ee-be56-0242ac120002",
        "name": "harley_davidson",
        "services": [
          
          {
            "id": "9832ead4-2510-11ee-be56-0242ac120002",
            "name": "customer",
            "hostName": "localhost",
            "endpoint": "/customers"
          }
        ]
      }
      """
    When I send a PUT request to "/consumers/56d0a80a-2511-11ee-be56-0242ac120002" with the body
    Then the response status code should be "422"

  
  Scenario: An invalid consumer, service bad naming 
    Given The body:
      """
      {
        "id": "56d0a80a-2511-11ee-be56-0242ac120002",
        "name": "harley-davidson",
        "services": [
          {
            "id": "9832ead4-2510-11ee-be56-0242ac120002",
            "name": "customer_catcher",
            "hostName": "localhost",
            "endpoint": "/customers"
          }
        ]
      }
      """
    When I send a PUT request to "/consumers/56d0a80a-2511-11ee-be56-0242ac120002" with the body
    Then the response status code should be "422"
  
  Scenario: Trying to create a consumer with an existing consumer name
    Given The body:
      """
      {
        "id": "56d0aa76-2511-11ee-be56-0242ac120002",
        "name": "harley-davidson",
        "services": [
          {
            "id": "ea6a02d4-250f-11ee-be56-0242ac120002",
            "name": "leads-catcher",
            "hostName": "localhost",
            "endpoint": "/lead"
          }
        ]
      }
      """
    When I send a PUT request to "/consumers/56d0aa76-2511-11ee-be56-0242ac120002" with the body
    Then the response status code should be "409"


  Scenario: Trying to create a consumer with an existing consumer id
    Given The body:
      """
      {
        "id": "56d0b62e-2511-11ee-be56-0242ac120002",
        "name": "toyota-peru",
        "services": [
          {
            "id": "ea6a02d4-250f-11ee-be56-0242ac120002",
            "name": "leads-catcher",
            "hostName": "localhost",
            "endpoint": "/lead"
          }
        ]
      }
      """
    When I send a PUT request to "/consumers/56d0b62e-2511-11ee-be56-0242ac120002" with the body
    Given The body:
      """
      {
        "id": "56d0b62e-2511-11ee-be56-0242ac120002",
        "name": "toyota-ar",
        "services": [
          {
            "id": "ea6a02d4-250f-11ee-be56-0242ac120002",
            "name": "leads-catcher",
            "hostName": "localhost",
            "endpoint": "/lead"
          }
        ]
      }
      """
    When I send a PUT request to "/consumers/56d0b62e-2511-11ee-be56-0242ac120002" with the body
    Then the response status code should be "409"