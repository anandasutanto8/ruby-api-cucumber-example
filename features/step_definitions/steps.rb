# @endpoint             # API endpoint
# @http_method          # http method for request
# @request_body         # request body
# @query_param          # request query params

# @json_response_body   # response body in json
# @http_response_code   # http response code, value is integer

# @arr_saved_id         # to save generated id after adding new contact
# @arr_deleted_id       # to save deleted id after delete existing contact

Given('endpoint is {string}') do |string|
  @endpoint = $base_url + string

  # reset query param
  @query_param = nil
end

Given('query param {string} value is {string}') do |str_qpr_name, str_qpr_val|
  if @query_param.nil?
    @query_param = Hash.new
  end
  @query_param.store(str_qpr_name, str_qpr_val)
end

Given('http method is {string}') do |string|
  @http_method = string
end

Given('request body is') do |string|
  @request_body = string
end

Given('request body is at example {string} {string} {string}') do |str_name, str_addr, str_tel|
  @request_body =
  {
    name: str_name,
    address: str_addr,
    telephone: str_tel
  }
end

Given('added contact data is') do |table|
  ### re-assign endpoint to delete all existing data
  @endpoint = $base_url + '/delete_all_contact'
  response = HTTParty.delete(@endpoint, headers: {'Content-Type' => 'application/json'})

  ### re-assign endpoint to add new data
  @endpoint = $base_url + '/add_contact'

  @arr_saved_id = []
  for i in 1...table.raw.length do
    ### re-assign request body to add new data
    @request_body =
    {
      name: table.raw[i][0],
      address: table.raw[i][1],
      telephone: table.raw[i][2]
    }
    response = JSON.parse(HTTParty.post(@endpoint, headers: {'Content-Type' => 'application/json'}, body: JSON.generate(@request_body)).body)
    @arr_saved_id << JsonPath.on(response, "$.contact.id").to_s
  end
end

When('request sent') do
  response = nil
  if @http_method == "POST"
    response = HTTParty.post(@endpoint, headers: {'Content-Type' => 'application/json'}, body: JSON.generate(@request_body))
  elsif @http_method == "GET"
    if @query_param.nil?
      response = HTTParty.get(@endpoint, headers: {'Content-Type' => 'application/json'})
    else
      response = HTTParty.get(@endpoint, headers: {'Content-Type' => 'application/json'}, query: @query_param)
    end
  elsif @http_method == "PUT"
    response = HTTParty.put(@endpoint, headers: {'Content-Type' => 'application/json'}, body: JSON.generate(@request_body), query: @query_param)
  elsif @http_method == "DELETE"
    response = HTTParty.delete(@endpoint, headers: {'Content-Type' => 'application/json'}, query: @query_param)
  end

  @http_response_code = response.code
  @json_response_body = JSON.parse(response.body)
end

When('{string} random contact deleted \(by id)') do |str_value|
  @arr_deleted_id = @arr_saved_id.sample(str_value.to_i)

  ### re-assign endpoint to delete data by id
  @endpoint = $base_url + '/delete_contact_by_id'

  @arr_deleted_id.each do |i|
    ### re-assign query param to delete data by id
    @query_param = {'id' => i.gsub('[', '').gsub(']', '')}
    response = HTTParty.delete(@endpoint, headers: {'Content-Type' => 'application/json'}, query: @query_param)
  end
end

Then('http status code should be {string}') do |string|
  expect(@http_response_code).to eq(string.to_i)
end

Then('key {string} should be existed') do |str_path|
  arr_value = JsonPath.on(@json_response_body, "#{str_path}")
  if arr_value.length == 1
    expect(arr_value[0]).not_to be_nil
  else
    arr_value.each do |item|
      expect(item).not_to be_nil
    end
  end
end

Then('key {string} type should be {string}') do |str_path, str_type|
  arr_value = JsonPath.on(@json_response_body, "#{str_path}")
  if arr_value.length == 1
    expect(arr_value[0].class.to_s.downcase).to eq(str_type.downcase)
  else
    arr_value.each do |item|
      expect(item.class.to_s.downcase).to eq(str_type.downcase)
    end
  end
end

Then('key {string} value should be {string}') do |str_path, str_value|
  arr_value = JsonPath.on(@json_response_body, "#{str_path}")
  if arr_value.length == 1
    expect(arr_value[0].to_s).to eq(str_value)
  else
    arr_value.each do |item|
      expect(item.to_s).to eq(str_value)
    end
  end
end

Then('array of object item count on key {string} should be equal with value on key {string}') do |str_arr_path, str_path|
  expect(JsonPath.on(@json_response_body, "#{str_arr_path}")[0].length).to eq(JsonPath.on(@json_response_body, "#{str_path}")[0].to_i)
end

Then('only {string} contact remained form get all contact API response') do |str_value|
  ### re-assign endpoint to get all data
  @endpoint = $base_url + '/get_all_contact'
  response = JSON.parse(HTTParty.get(@endpoint, headers: {'Content-Type' => 'application/json'}).body)

  point = str_value.to_i

  arr_remaining_id = @arr_saved_id - @arr_deleted_id
  arr_remaining_id.each do |remaining_id|
    JsonPath.on(response, '$..id').each do |response_id|
      if remaining_id.to_i == response_id.to_i
        point += 1
      end
    end
  end

  expect(JsonPath.on(response, '$.count')[0].to_i).to eq(str_value.to_i)
  expect(point.to_i).to eq(str_value.to_i)
end
