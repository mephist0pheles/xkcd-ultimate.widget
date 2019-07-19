# Uncomment this command to always show the latest comic strip
# command: "curl --silent https://xkcd.com/info.0.json"

# Use this command to load a random comic strip from the past
command: "last=$(python -c 'import urllib, json, sys; print(json.loads(urllib.urlopen(\"http://xkcd.com/info.0.json\").read())[\"num\"])') && newid=$((RANDOM%$last+1)) && curl --silent https://xkcd.com/$newid/info.0.json"

# Set the refresh frequency (milliseconds) to every hour
refreshFrequency: 60*60*1000

style: """

  widget-align = left			// Align contents left or right
  bottom: 10px				// Position widget
  left: 10px
  color: #fff				// Text settings
  font-family Helvetica Neue
  background rgba(#000, .5)
  padding 20px 20px 20px 20px
  border-radius 5px

  #container				// Settings for widget container
    text-align: widget-align
    position: relative
    clear: both

  #xkcd-title
    font-size 14px
    text-transform uppercase
    font-weight bold

  #xkcd-alt-text
      font-size 13px
  
  img
    max-height: 80vh		// allow the img to use up at most 85% of the desktop's height
    max-width: 50vw		// allow the img to use up at most 50% of the desktop's width
    // filter: invert(100%)		// uncomment this setting to display an inverted (white on black) comic strip

"""
# Render the output.
render: (output) -> """
  <div id='container'>
  <div>
"""
	  
update: (output, domEl) -> 
  try
    xkcd = JSON.parse(output)
    container = $(domEl).find('#container')
    content = 
      """
	  <div id="xkcd-title">#{xkcd.title}</div>
	  <p style="width: 300px" id="xkcd-alt-text">#{xkcd.alt}</p>
           <script>
		   var comic = document.createElement("img");
		   document.getElementById("xkcd-alt-text").prepend(document.createElement("br"));
		   document.getElementById("xkcd-alt-text").prepend(document.createElement("br"));
		   document.getElementById("xkcd-alt-text").prepend(comic);
		   comic.onload = function() {
		   document.getElementById("xkcd-alt-text").style.width = comic.clientWidth + "px";
		   }
		   comic.src = "#{xkcd.img}";
	  </script>
      """
    $(container).html content
  catch e
    # do nothing
