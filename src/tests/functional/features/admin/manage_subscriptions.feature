Feature: Create a new consumer
  In order to have subscribed consumers to channels
  As a user with admin permissions
  I want to manage a consumer

  Scenario: A valid non existing subscription
  
    Given The body:
      """
      {
        "id": "b252d466-259b-11ee-be56-0242ac120002",
        "name": "product-creation"
      }
      """
    When I send a "PUT" request to "/channels/b252d466-259b-11ee-be56-0242ac120002" with the body
    Given The body:
      """
      {
        "id": "b252d9de-259b-11ee-be56-0242ac120002",
        "name": "hd",
        "services": [
          {
            "id": "b252dba0-259b-11ee-be56-0242ac120002",
            "name": "new-product",
            "hostName": "localhost",
            "endpoint": "/products"
          }
        ]
      }
      """
    When I send a "PUT" request to "/consumers/b252d9de-259b-11ee-be56-0242ac120002" with the body
    Given The body:
      """
      {
        "channelName": "product-creation",
        "consumerName": "hd",
        "serviceName": "new-product"
      }
      """
    When I send a "POST" request to "/subscriptions" with the body
    Then the response status code should be "201"
    And the response should be empty

  Scenario: A valid existing subscription
  
    Given The body:
      """
      {
        "id": "b252d466-259b-11ee-be56-0242ac120002",
        "name": "product-creation"
      }
      """
    When I send a "PUT" request to "/channels/b252d466-259b-11ee-be56-0242ac120002" with the body
    Given The body:
      """
      {
        "id": "b252d9de-259b-11ee-be56-0242ac120002",
        "name": "hd",
        "services": [
          {
            "id": "b252dba0-259b-11ee-be56-0242ac120002",
            "name": "new-product",
            "hostName": "localhost",
            "endpoint": "/products"
          }
        ]
      }
      """
    When I send a "PUT" request to "/consumers/b252d9de-259b-11ee-be56-0242ac120002" with the body
    Given The body:
      """
      {
        "channelName": "product-creation",
        "consumerName": "hd",
        "serviceName": "new-product"
      }
      """
    When I send a "POST" request to "/subscriptions" with the body
    Then the response status code should be "200"
    And the response should be empty
  
  Scenario: A subscription without channel 
  
    Given The body:
      """
      {
        "id": "b252de0c-259b-11ee-be56-0242ac120002",
        "name": "hd-2",
        "services": [
          {
            "id": "b252dba0-259b-11ee-be56-0242ac120002",
            "name": "new-product",
            "hostName": "localhost",
            "endpoint": "/products"
          }
        ]
      }
      """
    When I send a "PUT" request to "/consumers/b252de0c-259b-11ee-be56-0242ac120002" with the body
    Given The body:
      """
      {
        "consumerName": "hd-2",
        "serviceName": "new-product"
      }
      """
    When I send a "POST" request to "/subscriptions" with the body
    Then the response status code should be "422"
    
  Scenario: A subscription without consumer 
  
    Given The body:
      """
      {
        "id": "b252e104-259b-11ee-be56-0242ac120002",
        "name": "customer-update"
      }
      """
    When I send a "PUT" request to "/channels/b252e104-259b-11ee-be56-0242ac120002" with the body
    Given The body:
      """
      {
        "channelName": "customer-update",
        "serviceName": "new-product"
      }
      """
    When I send a "POST" request to "/subscriptions" with the body
    Then the response status code should be "422"
  
  Scenario: A subscription without service 
  
    Given The body:
      """
      {
        "id": "b252e230-259b-11ee-be56-0242ac120002",
        "name": "customer-delete"
      }
      """
    When I send a "PUT" request to "/channels/b252e230-259b-11ee-be56-0242ac120002" with the body
    Given The body:
      """
      {
        "channelName": "customer-delete",
        "consumerName": "hd-2"
      }
      """
    When I send a "POST" request to "/subscriptions" with the body
    Then the response status code should be "422"
    
  Scenario: A subscription with a non existent channel 
  
    Given The body:
      """
      {
        "id": "b252de0c-259b-11ee-be56-0242ac120002",
        "name": "hd-2",
        "services": [
          {
            "id": "b252dba0-259b-11ee-be56-0242ac120002",
            "name": "new-product",
            "hostName": "localhost",
            "endpoint": "/products"
          }
        ]
      }
      """
    When I send a "PUT" request to "/consumers/b252de0c-259b-11ee-be56-0242ac120002" with the body
    Given The body:
      """
      {
        "channelName": "fake",
        "consumerName": "hd-2",
        "serviceName": "new-product"
      }
      """
    When I send a "POST" request to "/subscriptions" with the body
    Then the response status code should be "404"
    
  Scenario: A subscription with a non existent consumer 
  
    Given The body:
      """
      {
        "id": "b252e104-259b-11ee-be56-0242ac120002",
        "name": "customer-update"
      }
      """
    When I send a "PUT" request to "/channels/b252e104-259b-11ee-be56-0242ac120002" with the body
    Given The body:
      """
      {
        "channelName": "customer-update",
        "consumerName": "fake",
        "serviceName": "new-product"
      }
      """
    When I send a "POST" request to "/subscriptions" with the body
    Then the response status code should be "404"
  
  Scenario: A subscription with a non existent service 
  
    Given The body:
      """
      {
        "id": "b252e104-259b-11ee-be56-0242ac120002",
        "name": "customer-update"
      }
      """
    When I send a "PUT" request to "/channels/b252e104-259b-11ee-be56-0242ac120002" with the body
    Given The body:
      """
      {
        "id": "94fa6950-25a6-11ee-be56-0242ac120002",
        "name": "hd-3",
        "services": [
          {
            "id": "b252dba0-259b-11ee-be56-0242ac120002",
            "name": "new-product",
            "hostName": "localhost",
            "endpoint": "/products"
          }
        ]
      }
      """
    When I send a "PUT" request to "/consumers/94fa6950-25a6-11ee-be56-0242ac120002" with the body
    Given The body:
      """
      {
        "channelName": "customer-update",
        "consumerName": "hd-3",
        "serviceName": "fake"
      }
      """
    When I send a "POST" request to "/subscriptions" with the body
    Then the response status code should be "404"