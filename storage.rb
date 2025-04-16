require 'json'

def load_data
  if File.exist?('data.json')
    JSON.parse(File.read('data.json'))
  else
    { "notes" => [], "reminders" => [] }
  end
end

def save_data(data)
  File.write('data.json', JSON.pretty_generate(data))
end
