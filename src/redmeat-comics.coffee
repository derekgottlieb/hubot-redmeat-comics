# Description:
#   Get the latest Red Meat comics
#
# Dependencies:
#   "htmlparser": "1.7.6"
#   "soupselect": "0.2.0"
#
# Configuration:
#   None
#
# Commands:
#   hubot red meat - The latest Red Meat comic
#   hubot redmeat - The latest Red Meat comic
#
# Author:
#   derekgottlieb

htmlparser = require "htmlparser"
Select     = require("soupselect").select

module.exports = (robot) ->
  getComic = (msg, url) ->
    msg.http(url)
        .get() (err, res, body) ->
          handler = new htmlparser.DefaultHandler()
          parser = new htmlparser.Parser(handler)
          parser.parseComplete(body)

          comicStrip = Select handler.dom, ".comicStrip"
          img = comicStrip[0].children[1].children[0]
          comic = img.attribs

          msg.send comic.src
          msg.send comic.alt if comic.alt

  robot.respond /red( )?meat$/i, (msg) ->
    getComic(msg, "http://www.redmeat.com/max-cannon/FreshMeat")
