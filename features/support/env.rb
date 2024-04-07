require 'httparty'
require 'jsonpath'

$base_url = 'http://127.0.0.1:4567'

def terminate_server
  HTTParty.get($base_url + '/quit', headers: {'Content-Type' => 'application/json'})
end

BeforeAll do
  puts "\n\n"
end

After do |scenario|
  if scenario.failed?
    terminate_server
  end
end

AfterAll do
  terminate_server
end

# run with this command:
# ruby server.rb & bundle exec cucumber
