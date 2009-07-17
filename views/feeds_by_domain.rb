require 'rubygems'
require 'couchrest'

couch = CouchRest.new('http://127.0.0.1:5984')
db = couch.database('feeds')

domain = {
  :map => 'function(doc) {
    var parse_domain = /^http:\/\/[\w]+\.([\w]+(\.[\w]+)+).*$/;
    var a = parse_domain.exec(doc._id);
    emit (a[1], doc);
  }'
}

db.delete db.get('_design/domain') rescue nil

db.save({
  "_id" => "_design/domain",
  :views => {
    :all => domain
  }
})
