require 'rubygems'
require 'couchrest'

couch = CouchRest.new('http://127.0.0.1:5984')
db = couch.database('feeds')

hostname = {
  :map => 'function(doc) {
    var parse_hostname = /^http:\/\/([\w]+\.[\w]+(\.[\w]+)+).*$/;
    var a = parse_hostname.exec(doc._id);
    emit (a[1], doc);
  }'
}

db.delete db.get('_design/hostname') rescue nil

db.save({
  "_id" => "_design/hostname",
  "language" => "javascript",
  :views => {
    :all => hostname
  }
})
