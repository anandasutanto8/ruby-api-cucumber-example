# ruby-api-cucumber-example

A small example for implementing Cucumber BDD Framework for API testing using Ruby programming language.

## Prequisites
1. Ruby programming language installed (notes: this repository developed with ruby 3.0.6)

## Installation
1. Clone this repository
2. Go to this repository directory on your device, for example:
```shell
cd ruby-api-cucumber-example
```
3. Install **bundler** gem
```shell
gem install bundler
```
4. Install dependencies
```shell
bundle install
```
5. Execute test (notes: server will run on `http://127.0.0.1:4567`)
```shell
ruby server.rb & bundle exec cucumber
```

## API
API functionality is to create, read, update, and delete contact data that consist of name, address, and telephone. API to terminate server process is also available (see point number 7).

1. `POST http://127.0.0.1:4567/addcontact` for adding new contact data
```
(201 - Created)

Sample Request Body:
{
    "name":"Sample Name",
    "address": "Sample Address",
    "telephone": "001012345"
}

Sample Response Body:
{
    "message": "new contact added successfully",
    "error": "none",
    "contact": {
        "id": 1,
        "name": "Sample Name",
        "address": "Sample Address",
        "telephone": "001012345"
    }
}
```
```
(400 - Bad Request)

Sample Request Body:
{
    "name":"",
    "address": "",
    "telephone": ""
}

Sample Response Body:
{
    "message": "failed to add new contact",
    "error": [
        "name should be in string format with 1-500 characters long",
        "address should be in string format with 2-500 characters long",
        "telephone should be in string format with 2-50 characters long"
    ]
}
```
```
(500 - Internal Server Error)

Sample Request Body:
{
    "name": asdfg,
    "address": "",
    "telephone": ""
}

Sample Response Body:
{
    "message": "error found",
    "error": "please re-check request body, there maybe invalid key or values"
}
```

2. `GET http://127.0.0.1:4567/get_all_contact` for retrieving all contact data
```
(200 - OK)

Sample Response Body (3 Contact Data Existed):
{
    "message": "success",
    "count": 3,
    "contact": [
        {
            "id": 1,
            "name": "Sample Name 1",
            "address": "Sample Address 1",
            "telephone": "001012345"
        },
        {
            "id": 2,
            "name": "Sample Name 2",
            "address": "Sample Address 2",
            "telephone": "002012345"
        },
        {
            "id": 3,
            "name": "Sample Name 3",
            "address": "Sample Address 3",
            "telephone": "003012345"
        }
    ]
}
```
```
(200 - OK)

Sample Response Body (0 Contact Data Existed):
{
    "message": "success",
    "count": 0,
    "contact": []
}
```

3. `GET http://127.0.0.1:4567/get_contact_by_id?id=<contact_id>` for retrieving contact data by id
```
(200 - OK)

Sample Request (Contact Found):
http://127.0.0.1:4567/get_contact_by_id?id=1

Sample Response Body:
{
    "message": "contact found",
    "contact": {
        "id": 1,
        "name": "Sample Name 1",
        "address": "Sample Address 1",
        "telephone": "001012345"
    }
}
```
```
(200 - OK)

Sample Request (Contact Not Found):
http://127.0.0.1:4567/get_contact_by_id?id=4

Sample Response Body:
{
    "message": "contact not found"
}
```

4. `PUT http://127.0.0.1:4567/update_contact_by_id?id=<contact_id>` for modifying contact data. All keys (`name`, `address`, `telephone`) is mandatory.
```
(200 OK)

Sample Request & Request Body (Contact Existed):
http://127.0.0.1:4567/update_contact_by_id?id=1
{
    "name": "Sample Name 1 Modified",
    "address": "Sample Address 1 Modified",
    "telephone": "081100001111"
}

Sample Response Body:
{
    "message": "respective contact has been updated",
    "previous_contact_information": {
        "id": 1,
        "name": "Sample Name 1",
        "address": "Sample Address 1",
        "telephone": "001012345"
    },
    "current_contact_information": {
        "id": 1,
        "name": "Sample Name 1 Modified",
        "address": "Sample Address 1 Modified",
        "telephone": "081100001111"
    }
}
```
```
(200 OK)

Sample Request & Request Body (Contact Not Existed):
http://127.0.0.1:4567/update_contact_by_id?id=4
{
    "name": "Sample Name 1 Modified",
    "address": "Sample Address 1 Modified",
    "telephone": "081100001111"
}

Sample Response Body:
{
    "message": "contact not found, there is no updated contact"
}
```
```
(400 Bad Request)

Sample Request & Request Body:
http://127.0.0.1:4567/update_contact_by_id?id=1
{
    "name": "",
    "address": "",
    "telephone": ""
}

Sample Response Body:
{
    "message": "failed to update respective contact",
    "error": [
        "name should be in string format with 1-500 characters long",
        "address should be in string format with 2-500 characters long",
        "telephone should be in string format with 2-50 characters long"
    ]
}
```
```
(500 - Internal Server Error)

Sample Request & Request Body:
http://127.0.0.1:4567/update_contact_by_id?id=1
{
    "name": asdfg,
    "address": "",
    "telephone": ""
}

Sample Response Body:
{
    "message": "error found",
    "error": "please re-check request body, there maybe invalid key or values"
}
```

5. `DELETE http://127.0.0.1:4567/delete_contact_by_id?id=<contact_id>` for deleting contact data by id
```
(200 OK)

Sample Request (Contact Existed):
http://127.0.0.1:4567/delete_contact_by_id?id=3

Sample Response Body:
{
    "message": "respective contact has been deleted",
    "deleted_contact": {
        "id": 3,
        "name": "Sample Name 3",
        "address": "Sample Address 3",
        "telephone": "003012345"
    }
}
```
```
(200 OK)

Sample Request (Contact Not Existed):
http://127.0.0.1:4567/delete_contact_by_id?id=4

Sample Response Body:
{
    "message": "contact not found, there is no deleted contact"
}
```

6. `DELETE http://127.0.0.1:4567/delete_all_contact` for deleting all contact data
```
(200 OK)

Sample Request:
http://127.0.0.1:4567/delete_all_contact

Sample Response Body:
{
    "message": "all contact data has been deleted"
}
```

7. `GET http://127.0.0.1:4567/quit` for terminating server process
```
(200 OK)

Sample Request:
http://127.0.0.1:4567/quit

Sample Response Body:
{
    "message": "success, server process should be terminated after this request"
}
```
