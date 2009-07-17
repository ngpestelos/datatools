# Extracts feed URLs from an OPML file

require 'rubygems'
require 'hpricot'
require 'json'
require 'couchrest'

content = Hpricot.parse(open(ARGV[0]))
outlines = content.search('outline')
hashes = outlines.collect do |outline|
  { 'title'   => outline.attributes['title'],
    'text'    => outline.attributes['text'],
    '_id'     => outline.attributes['xmlurl'],
    'type'    => outline.attributes['type'],
    'htmlurl' => outline.attributes['htmlurl']
  }
end

filtered = hashes.find_all { |h| h['_id'] != nil }

couch = CouchRest.new('http://127.0.0.1:5984')
db = couch.database('feeds')
db.delete! rescue nil
db = couch.create_db('feeds')

filtered.each { |feed| db.save_doc(feed) rescue puts "Unable to load #{feed['_id']}" }
