Feature: Create a new channel
  In order to have channels through which messages are sent 
  As a user with admin permissions
  I want to create a new channel

  Scenario: A valid non existing channel
    Given The body:
      """
      {
        "id": "ef8ac118-8d7f-49cc-abec-78e0d05af80a",
        "name": "leads-creation"
      }
      """
    When I send a "PUT" request to "/channels/ef8ac118-8d7f-49cc-abec-78e0d05af80a" with the body
    Then the response status code should be "201"
    And the response should be empty

  Scenario: An invalid non existing channel
    Given The body:
      """
      {
        "id": "ef8ac118-8d7f-49cc-abec-78e0d05af80a",
        "name": "leads_creation"
      }
      """
    When I send a "PUT" request to "/channels/ef8ac118-8d7f-49cc-abec-78e0d05af80a" with the body
    Then the response status code should be "422"

  Scenario: An valid existing channel
    Given The body:
      """
      {
        "id": "ef8ac118-8d7f-49cc-abec-78e0d05af80a",
        "name": "leads-creation"
      }
      """
    When I send a "PUT" request to "/channels/ef8ac118-8d7f-49cc-abec-78e0d05af80a" with the body
    Given The body:
      """
      {
        "id": "ef8ac118-8d7f-49cc-abec-78e0d05af80a",
        "name": "leads-creation"
      }
      """
    When I send a "PUT" request to "/channels/ef8ac118-8d7f-49cc-abec-78e0d05af80a" with the body
    Then the response status code should be "200"
    And the response should be empty

  Scenario: Trying to rewrite a channel
    Given The body:
      """
      {
        "id": "ef8ac118-8d7f-49cc-abec-78e0d05af80a",
        "name": "leads-creation"
      }
      """
    When I send a "PUT" request to "/channels/ef8ac118-8d7f-49cc-abec-78e0d05af80a" with the body
    Given The body:
      """
      {
        "id": "ef8ac118-8d7f-49cc-abec-78e0d05af80a",
        "name": "other-name"
      }
      """
    When I send a "PUT" request to "/channels/ef8ac118-8d7f-49cc-abec-78e0d05af80a" with the body
    Then the response status code should be "409"

  
  Scenario: Trying to create a channel with an existing channel name
    Given The body:
      """
      {
        "id": "j2fyo50q-8d7f-49cc-abec-78e0d05af440",
        "name": "leads-creation"
      }
      """
    When I send a "PUT" request to "/channels/j2fyo50q-8d7f-49cc-abec-78e0d05af440" with the body
    Then the response status code should be "409"

  Scenario: Trying to create a channel with diferent Ids
    Given The body:
      """
      {
        "id": "j2fyo50q-8d7f-49cc-abec-78e0d05af440",
        "name": "leads-creation"
      }
      """
    When I send a "PUT" request to "/channels/ef8ac118-8d7f-49cc-abec-78e0d05af80a" with the body
    Then the response status code should be "422"
