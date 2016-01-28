require 'bundler/setup'
require 'lob'
require 'pry'
require 'optparse'

require 'yaml'
@yaml = YAML.load_file('address.yml')

def to_address
  @yaml['to']
end

def from_address
  same_as_to = @yaml['from']['same_as_to']

  if same_as_to
    return to_address
  else
    return @yaml['from']
  end
end

@options = {}
OptionParser.new do |opts|
  opts.on("-l", "--live", "Use the live API key") do |v|
    @options[:live] = v
  end

  opts.on("-f", "--file=val", String, "The path to the file you want to mail") do |f|
    @options[:file] = f
  end
end.parse!

def live?
  @options[:live]
end

def file_contents
  fail ArgumentError, "Missing --file parameter" if @options[:file].nil?

  File.read @options[:file]
end

def html
  file_contents.split("\n").map do |line|
    "<p>#{line}</p>"
  end.join
end

api_key = live? ? ENV['LOB_LIVE_API_KEY'] : ENV['LOB_TEST_API_KEY']

if live?
  STDOUT.puts "Using the Live API key"
else
  STDOUT.puts "Using the Test API key"
end

@lob = Lob.load(api_key: ENV['LOB_TEST_API_KEY'])

begin

letter = @lob.letters.create(
  description: "A letter from myself",
  to: to_address,
  from: from_address,
  file: html,
  color: false
)

  STDOUT.puts "Successfuly sent your letter."
  STDOUT.puts "To: #{to_address}"
  STDOUT.puts "From: #{from_address}"
  STDOUT.puts "Tracking information:"
  STDOUT.puts "Tracking #: #{letter['tracking']['tracking_number']}"
  STDOUT.puts "Carrier: #{letter['tracking']['carrier']}"
  STDOUT.puts "Tracking link (where available): #{letter['tracking']['link']}"

rescue Exception => e
  STDOUT.puts "There was an error: #{e.message}"
end
