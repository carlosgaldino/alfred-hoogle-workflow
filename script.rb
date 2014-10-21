require 'net/http'
require 'json'
require 'erb'

substitutions = {
  '+' => '%2B',
  '&' => '%26',
}

def item_xml(options = {})
  <<-ITEM
  <item arg="#{options[:arg]}" uid="#{options[:uid]}">
    <title>#{options[:title]}</title>
    <subtitle>#{options[:subtitle]}</subtitle>
    <icon>#{options[:path]}</icon>
  </item>
  ITEM
end

def escape_html(str)
  ERB::Util.html_escape(str)
end

arg = URI.escape(ARGV.first)

substitutions.each { |k, v| arg.gsub!(k, v) }

uri = URI.parse("http://www.haskell.org/hoogle/?mode=json&hoogle=#{arg}")

response = JSON.parse(Net::HTTP.get(uri))

items = response['results'].map do |result|
  item_xml({ :arg => escape_html(result['location']), :title => escape_html(result['self']),
             :subtitle => escape_html(result['docs']), :uid => escape_html(result['location']) })
end.join

output = "<?xml version='1.0'?>\n<items>\n#{items}</items>"

puts output
