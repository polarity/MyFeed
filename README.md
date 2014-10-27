# MyFeed

You can now have your own news feed (like a facebook profile) on your own domain/webserver. Put links, images and text into a text field, let the app parse everything nicely for you and get a nice looking web feed for your audience. You can follow other peoples domains and get their content into your own stream. (demo on my own domain [http://robert-agthe.de](http://robert-agthe.de))

# current frontend features
- Post content to create a profile/blog/website/feed
- Avatars via Gravtar :)
- Simple! (no media upload, just hotlink your services, just one textbox for all)
- Markdown (format your content easily)
- Special view for Text below 140 chars (speechbubble)
- Attachments (Links are parsed and used for metatags and open graph metatags)
- Format your Posts in realtime. The design tries to adapt to your content.
- One time login. Stay logged in in every browser until you log out.
- RSS Feed (i use it with ifttt to automatically twitter all my posts)
- Special attachment behavior for Vimeo, Youtube, imgur, Flickr. (more following)
- Timeline: Your content mixed with the content of users you follow. (like your twitter und facebook stream)
- Add domains you want to follow under "Settings"

# current backend features
- get postings from users you follow by scraping them every 10min for new content. Data is copied/stored/cached in your server database.
- backend based on nodejs. just npm install and create a redirect on your domain and you´re set up.
- config via text files
- frontend based on AngularJS.
- live parsing of stylus2css, coffee-script and jade2html via express
- [pouchdb](http://pouchdb.com/) database lives completely inside the nodejs session. Stores permanently to disk. Just download a directory to backup. Replicate with Couchdb, Pouchdb)

# future
- basic settins of your MyFeed for personalisation with background images, colours, fonts and so forth
- make this thing work without a server. (later)
- mport api. Stuff your MyFeed from other sources.

# install on [uberspace.de](https://uberspace.de/)
Use "uberspace_install.sh" via shell. This downloads the software into ~/MyFeed/, installs every npm/bower module, creates an .env with your data and setup a new service via daemon tools. It creates also a .htaccess in ~/html/ to redirect every apache request to the nodejs service. The Install script asks for your desired port, username, pw, email and so forth.

# generic install 
... watch this space ...