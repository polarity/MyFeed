# generates a title from the post information
# when theres no content, we take the
# title of the first attachment
module.exports = (doc)->
	# are there some content?
	if doc.content && doc.content.length > 0
		strippedContent = markdown(doc.content).replace(/<(?:.|\n)*?>/gm, '').trim()
		# console.log strippedContent
		# try to get the first line (100chars max) & until a line break
		strippedTitle = strippedContent.match(/^([\S\s]{0,100}\n)/g)
		if strippedTitle
			strippedTitle = strippedTitle[0].replace(/(\n)+/g, '')
			# take the first 80 chars and use it as a title
			return strippedTitle
		else
			# nothing found? just take 100 chars off the content
			return truncate(strippedContent, 100)

	# no content? maybe some attachments there?
	else if doc.attachments && doc.attachments.length > 0 && doc.attachments[0].title
		# take the title of the first 
		# attachment and use it as title
		return doc.attachments[0].title
	else
		return "rnd-"+Math.random()