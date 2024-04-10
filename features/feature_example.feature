Feature: Contact API

  @new-test-1 @positive @add-new-contact
  Scenario Outline: Add a new contact
    Given endpoint is "/add_contact"
    And http method is "POST"
    And used request body is
    """
    {
      "name": "<Name>",
      "address": "<Address>",
      "telephone": "<Telephone>"
    }
    """
    When request sent
    Then http status code should be "201"
    And key "$.message" should be existed
    And key "$.message" type should be "string"
    And key "$.message" value should be "new contact added successfully"
    And key "$.error" should be existed
    And key "$.error" type should be "string"
    And key "$.error" value should be "none"
    And key "$.contact" should be existed
    And key "$.contact.id" should be existed
    And key "$.contact.id" type should be "integer"
    And key "$.contact.id" value should be "<ID>"
    And key "$.contact.name" should be existed
    And key "$.contact.name" type should be "string"
    And key "$.contact.name" value should be "<Name>"
    And key "$.contact.address" should be existed
    And key "$.contact.address" type should be "string"
    And key "$.contact.address" value should be "<Address>"
    And key "$.contact.telephone" should be existed
    And key "$.contact.telephone" type should be "string"
    And key "$.contact.telephone" value should be "<Telephone>"
    Examples:
      | Name           | Address           | Telephone    | ID |
      | Sample Name 1  | Sample Address 1  | 081100001111 | 1  |
      | Sample Name 2  | Sample Address 2  | 081200001111 | 2  |
      | Sample Name 3  | Sample Address 3  | 081300001111 | 3  |
      | Sample Name 4  | Sample Address 4  | 081400001111 | 4  |
      | Sample Name 5  | Sample Address 5  | 081500001111 | 5  |
      | Sample Name 6  | Sample Address 6  | 081600001111 | 6  |
      | Sample Name 7  | Sample Address 7  | 081700001111 | 7  |
      | Sample Name 8  | Sample Address 8  | 081800001111 | 8  |
      | Sample Name 9  | Sample Address 9  | 081900001111 | 9  |
      | Sample Name 10 | Sample Address 10 | 081200001010 | 10 |
      | Sample Name 11 | Sample Address 11 | 081200001011 | 11 |
      | Sample Name 12 | Sample Address 12 | 081200001012 | 12 |
  
  @new-test-1 @positive @get-all-contact
  Scenario: Get all contact
    Given added contact data is
      | Name           | Address           | Telephone    |
      | Sample Name 1  | Sample Address 1  | 081100001111 |
      | Sample Name 2  | Sample Address 2  | 081200001111 |
      | Sample Name 3  | Sample Address 3  | 081300001111 |
      | Sample Name 4  | Sample Address 4  | 081400001111 |
      | Sample Name 5  | Sample Address 5  | 081500001111 |
    Given endpoint is "/get_all_contact"
    And http method is "GET"
    When request sent
    Then http status code should be "200"
    And key "$.message" should be existed
    And key "$.message" type should be "string"
    And key "$.message" value should be "success"
    And key "$.count" should be existed
    And key "$.count" type should be "integer"
    And key "$.contact" should be existed
    And key "$.contact" type should be "array"
    And array item count on key "$.contact" should be equal with value on key "$.count"
    And key "$..id" should be existed
    And key "$..id" type should be "integer"
    And key "$..id" value should be same with all key "$.contact.id" value from saved body response from add new contact endpoint
    And key "$..name" should be existed
    And key "$..name" type should be "string"
#    And key "$..name" value should be same with all key "$.contact.name" value from saved body response from add new contact endpoint
    And key "$..address" should be existed
    And key "$..address" type should be "string"
#    And key "$..address" value should be same with all key "$.contact.address" value from saved body response from add new contact endpoint
    And key "$..telephone" should be existed
    And key "$..telephone" type should be "string"
#    And key "$..telephone" value should be same with all key "$.contact.telephone" value from saved body response from add new contact endpoint

  @new-test-1 @positive @get-contact-by-id
  Scenario Outline: Get contact by id
    Given added contact data is
      | Name           | Address          | Telephone    |
      | Sample Name 1  | Sample Address 1 | 081100001111 |
      | Sample Name 2  | Sample Address 2 | 081200001111 |
      | Sample Name 3  | Sample Address 3 | 081300001111 |
      | Sample Name 4  | Sample Address 4 | 081400001111 |
      | Sample Name 5  | Sample Address 5 | 081500001111 |
    Given endpoint is "/get_contact_by_id"
    And query param "id" value is from all key "$.contact.id" value from saved body response from add new contact endpoint
    And http method is "GET"
    When multiple request sent
    Then all http status code (from multiple request) should be "200"
    And all key "$.message" (from multiple request) should be existed
    And all key "$.message" (from multiple request) type should be "string"
    And all key "$.message" (from multiple request) value should be "contact found"
    And all key "$.contact" (from multiple request) should be existed
    And all key "$.contact.id" (from multiple request) should be existed
    And all key "$.contact.id" (from multiple request) type should be "integer"
    And all key "$.contact.id" (from multiple request) value should be same with all key "$.contact.id" value from saved body response from add new contact endpoint
    And all key "$.contact.name" (from multiple request) should be existed
    And all key "$.contact.name" (from multiple request) type should be "string"
    And all key "$.contact.id" (from multiple request) value should be same with all key "$.contact.name" value from saved body response from add new contact endpoint
    And all key "$.contact.address" (from multiple request) should be existed
    And all key "$.contact.address" (from multiple request) type should be "string"
    And all key "$.contact.id" (from multiple request) value should be same with all key "$.contact.address" value from saved body response from add new contact endpoint
    And all key "$.contact.telephone" (from multiple request) should be existed
    And all key "$.contact.telephone" (from multiple request) type should be "string"
    And all key "$.contact.id" (from multiple request) value should be same with all key "$.contact.telephone" value from saved body response from add new contact endpoint

  @positive @delete-contact-by-id-get-contact-by-id
  Scenario Outline: Delete contact by id with contact check (by id)
    Given endpoint is "/delete_contact_by_id"
    And query param "id" value is "<ID>"
    And http method is "DELETE"
    When request sent
    Then http status code should be "200"
    And key "$.message" should be existed
    And key "$.message" type should be "string"
    And key "$.message" value should be "respective contact has been deleted"
    And key "$.deleted_contact" should be existed
    And key "$.deleted_contact.id" should be existed
    And key "$.deleted_contact.id" type should be "integer"
    And key "$.deleted_contact.id" value should be "<ID>"
    And key "$.deleted_contact.name" should be existed
    And key "$.deleted_contact.name" type should be "string"
    And key "$.deleted_contact.name" value should be "<Name>"
    And key "$.deleted_contact.address" should be existed
    And key "$.deleted_contact.address" type should be "string"
    And key "$.deleted_contact.address" value should be "<Address>"
    And key "$.deleted_contact.telephone" should be existed
    And key "$.deleted_contact.telephone" type should be "string"
    And key "$.deleted_contact.telephone" value should be "<Telephone>"
    Given endpoint is "/get_contact_by_id"
    And query param "id" value is "<ID>"
    And http method is "GET"
    When request sent
    Then http status code should be "200"
    And key "$.message" should be existed
    And key "$.message" type should be "string"
    And key "$.message" value should be "contact not found"
    Examples:
      | ID | Name           | Address           | Telephone    |
      | 2  | Sample Name 2  | Sample Address 2  | 081200001111 |
      | 11 | Sample Name 11 | Sample Address 11 | 081200001011 |
      | 5  | Sample Name 5  | Sample Address 5  | 081500001111 |

  @positive @delete-contact-by-id-get-contact-all
  Scenario: Delete contact by id with contact check (all)
    Given added contact data is
      | Name           | Address           | Telephone    |
      | Sample Name 1  | Sample Address 1  | 081100001111 |
      | Sample Name 2  | Sample Address 2  | 081200001111 |
      | Sample Name 3  | Sample Address 3  | 081300001111 |
      | Sample Name 4  | Sample Address 4  | 081400001111 |
      | Sample Name 5  | Sample Address 5  | 081500001111 |
    When "3" random contact deleted (by id)
    Then only "2" contact remained form get all contact API response

  @positive @delete-all-contact
  Scenario: Delete all by id with contact check (all)
    Given added contact data is
      | Name           | Address           | Telephone    |
      | Sample Name 1  | Sample Address 1  | 081100001111 |
      | Sample Name 2  | Sample Address 2  | 081200001111 |
      | Sample Name 3  | Sample Address 3  | 081300001111 |
      | Sample Name 4  | Sample Address 4  | 081400001111 |
      | Sample Name 5  | Sample Address 5  | 081500001111 |
    Given endpoint is "/delete_all_contact"
    And http method is "DELETE"
    When request sent
    Then http status code should be "200"
    And key "$.message" should be existed
    And key "$.message" type should be "string"
    And key "$.message" value should be "all contact data has been deleted"
    Given endpoint is "/get_all_contact"
    And http method is "GET"
    When request sent
    Then http status code should be "200"
    And key "$.count" should be existed
    And key "$.count" type should be "integer"
    And key "$.count" value should be "0"
    And key "$.contact" should be existed
    And key "$.contact" value should be "[]"

  @positive @update-contact-by-id
  Scenario Outline: Modify a contact data
    Given added contact data is
      | Name           | Address           | Telephone   |
      | Sample Name 1  | Sample Address 1  | 02100010001 |
    Given endpoint is "/update_contact_by_id"
    And query param "id" value is "1"
    And http method is "PUT"
    And request body is at example "<Updated Name>" "<Updated Address>" "<Updated Telephone>"
    When request sent
    Then http status code should be "200"
    And key "$.message" should be existed
    And key "$.message" type should be "string"
    And key "$.message" value should be "respective contact has been updated"
    And key "$.previous_contact_information.id" value should be "1"
    And key "$.previous_contact_information.name" value should be "Sample Name 1"
    And key "$.previous_contact_information.address" value should be "Sample Address 1"
    And key "$.previous_contact_information.telephone" value should be "02100010001"
    And key "$.current_contact_information.name" value should be "<Updated Name>"
    And key "$.current_contact_information.address" value should be "<Updated Address>"
    And key "$.current_contact_information.telephone" value should be "<Updated Telephone>"
    Examples:
      | Updated Name          | Updated Address          | Updated Telephone |
      | Updated Sample Name 1 | Updated Sample Address 1 | 081100001111      |

  @positive @update-contact-by-id-get-contact-by-id
  Scenario Outline: Check a modified contact data by id
    Given added contact data is
      | Name           | Address           | Telephone   |
      | Sample Name 1  | Sample Address 1  | 02100010001 |
    Given endpoint is "/update_contact_by_id"
    And query param "id" value is "1"
    And http method is "PUT"
    And request body is at example "<Updated Name>" "<Updated Address>" "<Updated Telephone>"
    When request sent
    Then http status code should be "200"
    Given endpoint is "/get_contact_by_id"
    And query param "id" value is "1"
    And http method is "GET"
    When request sent
    Then http status code should be "200"
    And key "$.message" value should be "contact found"
    And key "$.contact.id" value should be "1"
    And key "$.contact.name" value should be "<Updated Name>"
    And key "$.contact.address" value should be "<Updated Address>"
    And key "$.contact.telephone" value should be "<Updated Telephone>"
    Examples:
      | Updated Name          | Updated Address          | Updated Telephone |
      | Updated Sample Name 1 | Updated Sample Address 1 | 081100001111      |

  @negative @add-contact-error-400
  Scenario: Error 400 returned when add contact key on request body is empty string
    Given endpoint is "/add_contact"
    And http method is "POST"
    And used request body is
    """
    {
      "name": "",
      "address": "",
      "telephone": ""
    }
    """
    When request sent
    Then http status code should be "400"
    And key "$.message" value should be "failed to add new contact"
    And key "$.error[0]" value should be "name should be in string format with 1-500 characters long"
    And key "$.error[1]" value should be "address should be in string format with 2-500 characters long"
    And key "$.error[2]" value should be "telephone should be in string format with 2-50 characters long"

  @negative @add-contact-error-404
  Scenario: Error 404 returned when endpoint is invalid
    Given endpoint is "/add_contact"
    And http method is "GET"
    When request sent
    Then http status code should be "404"
    And key "$.message" value should be "error found"
    And key "$.error" value should be "please re-check http method and request url"

  @negative @get-contact-by-id-not-found
  Scenario: Get contact by id is not found if id not existed
    Given contact data is empty
    Given endpoint is "/get_contact_by_id"
    And query param "id" value is "1"
    And http method is "GET"
    When request sent
    Then http status code should be "200"
    And key "$.message" value should be "contact not found"

  @negative @delete-contact-by-id-not-found
  Scenario: Delete contact by id is not found if id not existed
    Given contact data is empty
    Given endpoint is "/delete_contact_by_id"
    And query param "id" value is "1"
    And http method is "DELETE"
    When request sent
    Then http status code should be "200"
    And key "$.message" value should be "contact not found, there is no deleted contact"
