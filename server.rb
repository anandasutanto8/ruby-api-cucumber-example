require 'sinatra'
require 'json'
set :logging, false

arr_contact = []

def send_response(param_response, param_status) 
  content_type :json
  status param_status
  param_response.to_json
end

def get_request_body
  JSON.parse request.body.read
end

post '/add_contact' do
  request_body = nil
  begin
    request_body = get_request_body
  rescue JSON::ParserError
    halt 500
  end

  name = request_body['name']
  address = request_body['address']
  telephone = request_body['telephone']

  error_count = 0
  error_message = nil
  error_temp = []

  # name validation
  # type: str, char: 1 - 500
  if name == nil || name.class.to_s != 'String' || name.length < 1 || name.length > 500
    error_count += 1
    error_temp << 'name should be in string format with 1-500 characters long'
  end

  # address validation
  # address type: str, char: 2 - 500
  if address == nil || address.class.to_s != 'String' || address.length < 2 || address.length > 500
    error_count += 1
    error_temp << 'address should be in string format with 2-500 characters long'
  end

  # telephone validation
  # type: str, char: 2 - 50
  if telephone == nil || telephone.class.to_s != 'String' || telephone.length < 2 || telephone.length > 50
    error_count += 1
    error_temp << 'telephone should be in string format with 2-50 characters long'
  end

  if error_count > 0
    error_message = error_temp
    response =
    {
      message: 'failed to add new contact',
      error: error_message
    }
    send_response(response, 400)
  else
    error_message = 'none'

    new_contact_id = 1
    if arr_contact.length > 0
      new_contact_id = arr_contact[arr_contact.length-1][0] + 1
    end

    arr_contact << [new_contact_id, "#{name}", "#{address}", "#{telephone}"]
    response =
    {
      message: 'new contact added successfully',
      error: error_message,
      contact: {
        id: arr_contact[arr_contact.length - 1][0],
        name: "#{arr_contact[arr_contact.length - 1][1]}",
        address: "#{arr_contact[arr_contact.length - 1][2]}",
        telephone: "#{arr_contact[arr_contact.length - 1][3]}"
      }
    }
    send_response(response, 201)
  end
end

put '/update_contact_by_id' do
  contact_id = params[:id]

  request_body = nil
  begin
    request_body = get_request_body
  rescue JSON::ParserError
    halt 500
  end

  name = request_body['name']
  address = request_body['address']
  telephone = request_body['telephone']

  error_count = 0
  error_message = nil
  error_temp = []

  # name validation
  # type: str, char: 1 - 500
  if name == nil || name.class.to_s != 'String' || name.length < 1 || name.length > 500
    error_count += 1
    error_temp << 'name should be in string format with 1-500 characters long'
  end

  # address validation
  # address type: str, char: 2 - 500
  if address == nil || address.class.to_s != 'String' || address.length < 2 || address.length > 500
    error_count += 1
    error_temp << 'address should be in string format with 2-500 characters long'
  end

  # telephone validation
  # type: str, char: 2 - 50
  if telephone == nil || telephone.class.to_s != 'String' || telephone.length < 2 || telephone.length > 50
    error_count += 1
    error_temp << 'telephone should be in string format with 2-50 characters long'
  end

  if error_count > 0
    error_message = error_temp
    response =
    {
      message: 'failed to update respective contact',
      error: error_message
    }
    send_response(response, 400)
  else
    error_message = 'none'
    idx = 0
    is_found = false
    response = nil

    while is_found == false && idx < arr_contact.length
      if arr_contact[idx][0].to_i == contact_id.to_i
        is_found = true
      else
        idx += 1
      end
    end

    previous_contact = nil;
    current_contact = nil;
  
    if is_found
      previous_name = arr_contact[idx][1]
      previous_address = arr_contact[idx][2]
      previous_telephone = arr_contact[idx][3]

      arr_contact[idx][1] = name
      arr_contact[idx][2] = address
      arr_contact[idx][3] = telephone
      response =
      {
        message: 'respective contact has been updated',
        previous_contact_information: {
          id: arr_contact[idx][0],
          name: previous_name,
          address: previous_address,
          telephone: previous_telephone
        },
        current_contact_information: {
          id: arr_contact[idx][0],
          name: "#{arr_contact[idx][1]}",
          address: "#{arr_contact[idx][2]}",
          telephone: "#{arr_contact[idx][3]}"
        }
      }
    else
      response =
      {
        message: 'contact not found, there is no updated contact'
      }
    end
    send_response(response, 200)
  end
end

get '/get_all_contact' do
  temp = arr_contact.map do |contact|
    {
      id: contact[0],
      name: contact[1],
      address: contact[2],
      telephone: contact[3]
    }
  end

  response =
  {
    message: 'success',
    count: arr_contact.length,
    contact: temp
  }
  send_response(response, 200)
end

get '/get_contact_by_id' do
  contact_id = params[:id]
  is_found = false
  found_contact_item = nil

  idx = 0
  while is_found == false && idx < arr_contact.length
    if arr_contact[idx][0].to_i == contact_id.to_i
      is_found = true
      found_contact_item = 
      {
        id: arr_contact[idx][0],
        name: arr_contact[idx][1],
        address: arr_contact[idx][2],
        telephone: arr_contact[idx][3]
      }
    else
      idx += 1
    end
  end

  response = nil
  if is_found
    response =
    {
      message: 'contact found',
      contact: found_contact_item
    }
  else
    response =
    {
      message: 'contact not found'
    }
  end
  send_response(response, 200)
end

delete '/delete_contact_by_id' do
  contact_id = params[:id]
  is_found = false
  found_contact_item = nil

  idx = 0
  while is_found == false && idx < arr_contact.length
    if arr_contact[idx][0].to_i == contact_id.to_i
      is_found = true
      found_contact_item = 
      {
        id: arr_contact[idx][0],
        name: arr_contact[idx][1],
        address: arr_contact[idx][2],
        telephone: arr_contact[idx][3]
      }
    else
      idx += 1
    end
  end

  response = nil
  if is_found
    arr_contact.delete_at(idx)
    response =
    {
      message: 'respective contact has been deleted',
      deleted_contact: found_contact_item
    }
  else
    response =
    {
      message: 'contact not found, there is no deleted contact'
    }
  end
  send_response(response, 200)
end

delete '/delete_all_contact' do
  arr_contact = []
  response =
  {
    message: 'all contact data has been deleted'
  }
  send_response(response, 200)
end

error 404 do
  response =
  {
    message: 'error found',
    error: 'please re-check http method and request url'
  }
  send_response(response, 404)
end

error 500 do
  response =
  {
    message: 'error found',
    error: 'please re-check request body, there maybe invalid key or values'
  }
  send_response(response, 500)
end

get '/quit' do
  Process.kill('TERM', Process.pid)
  response =
  {
    message: 'success, server process should be terminated after this request',
  }
  send_response(response, 200)
end
