require 'net/http'
require 'json'

def item_xml(options = {})
  <<-ITEM
  <item arg="#{options[:arg]}" uid="#{options[:uid]}">
    <title>#{options[:title]}</title>
    <subtitle>#{options[:subtitle]}</subtitle>
    <icon>#{options[:path]}</icon>
  </item>
  ITEM
end

uri = URI.parse(URI.encode("http://www.haskell.org/hoogle/?mode=json&hoogle=#{ARGV.first}").gsub('+', '%2B'))

response = JSON.parse(Net::HTTP.get(uri))

items = response['results'].map do |result|
  item_xml({ :arg => result['location'], :title => result['self'],
             :subtitle => result['docs'], :uid => result['location'] })
end.join

output = "<?xml version='1.0'?>\n<items>\n#{items}</items>"

puts output
