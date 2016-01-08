# own modules
parseFollowing = require("./parse_following.coffee")

# reserve var
# set it in "module.exports"
# on the bottom
db = false

# when the pouchdb responds with an array
# of followed myfeeds
onDbResponse = (err, docs)->
	return false if !docs
	docs.rows.forEach (row)->
		# parse the response from the foreign website
		parseFollowing(row.doc.domain+'/api/feed', db)

# called every nth time
# as long the app runs
onInterval = ()->
	# get some feed urls from the db
	map = (doc, emit)=> emit(doc._id, doc) if doc.type == 'follow'
	db.query map, {include_docs: true}, onDbResponse

# export to use this in our main app
module.exports = (pdb, delay)->
	db = pdb
	setInterval onInterval, delay
	onInterval()
