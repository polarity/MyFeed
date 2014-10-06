# MyFeed

You can now have your own news feed (like a facebook profile) on your own domain/webserver. Put links, images and text into a text field, let the app parse everything nicely for you and get a nice looking web feed for your audience. You can follow other peoples domains and get their content into your own stream.

# current frontend features
- Avatars via Gravtar :)
- Simple! (no media upload, just hotlink your services, just one textbox for all)
- Markdown (format your content easily)
- Special view for Text below 140 chars (speechbubble)
- Attachments (Links are parsed and used for metatags and open graph metatags)
- Format your Posts in realtime. The design tries to adapt to your content.
- One time login. Stay logged in in every browser until you log out.
- RSS Feed (i use it with ifttt to automatically twitter all my posts)
- Special attachment behavior for Vimeo, Youtube, imgur, Flickr. (more following)

# current backend features
- backend based on nodejs. just npm install and create a redirect on your domain and you´re set up.
- config via text files
- frontend based on AngularJS.
- live parsing of stylus2css and jade2html via express middleware
- no additional db needed. Just download a directory to backup your content. (pouchdb used internally, saved to disk)

# future
- get postings from followed domains (stores content of your friends in your db)
- basic settins of your MyFeed for personalisation with background images, colours, fonts and so forth
- make this thing work without a server. (later)
- import api. Stuff your MyFeed from other sources.