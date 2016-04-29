Redis = require "redis"

module.exports = (robot) ->
  robot.respond /get account github$/i, (res) ->
    redis_key = "github-accounts"
    client = Redis.createClient()
    client.get "#{redis_key}", (err, result) ->
      if err
        throw err
      else if reslt
        res.send JSON.parse(result)
      else
        res.send "key: #{redis_key}は見つかりません."

  robot.respond /set account github (.*)$/i, (res) ->
    redis_key = "github-accounts"
    redis_val = {
      res.message.user.name: res.match[1].trim()
    }
    client = Redis.createClient()
    client.set "#{redis_key}", "#{redis_val}", (err, keys_replies) ->
      if err
        throw err
    res.reply "OK! #{JSON.parse redis_val}"
