url = require("url")
request = require("request")
module.exports = (req, res) ->
  url = req.query.url
  if url
    x = request(url)
    req.pipe(x).pipe res
  else
    res.writeHead 400,
      "Content-Type": "text/plain"
    res.end "No url"