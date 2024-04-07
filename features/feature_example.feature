Feature: Contact API

  Scenario Outline: Add a new contact
    Given endpoint is "/add_contact"
    And http method is "POST"
    And request body is at example "<Name>" "<Address>" "<Telephone>"
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
  
  Scenario: Get all contact
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
    And array of object item count on key "$.contact" should be equal with value on key "$.count"
    And key "$..id" should be existed
    And key "$..id" type should be "integer"
    And key "$..name" should be existed
    And key "$..name" type should be "string"
    And key "$..address" should be existed
    And key "$..address" type should be "string"
    And key "$..telephone" should be existed
    And key "$..telephone" type should be "string"

  Scenario Outline: Get contact by id
    Given endpoint is "/get_contact_by_id"
    And query param "id" value is "<ID>"
    And http method is "GET"
    When request sent
    Then http status code should be "200"
    And key "$.message" should be existed
    And key "$.message" type should be "string"
    And key "$.message" value should be "contact found"
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
      | ID | Name           | Address           | Telephone    |
      | 1  | Sample Name 1  | Sample Address 1  | 081100001111 |
      | 6  | Sample Name 6  | Sample Address 6  | 081600001111 |
      | 12 | Sample Name 12 | Sample Address 12 | 081200001012 |

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
