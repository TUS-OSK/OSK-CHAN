Redis = require "redis"

module.exports = (robot) ->
  robot.respond /get account/i, (res) ->
    redis_key = res.message.user.name
    client = Redis.createClient()
    client.get "#{redis_key}", (err, result) ->
      if err
        throw err
      else if result
        res.send JSON.parse result
      else
        res.send "key: #{redis_key}は見つかりません"

  robot.respond /set account (.*) (.*)/i, (res) ->
    redis_key = res.message.user.name
    client = Redis.createClient()
    client.get "#{redis_key}", (err, result) ->
      if err
        throw err
      redis_val = JSON.parse result
      redis_val[res.match[1].trim()] = res.match[2].trim()
      redis_val = JSON.stringify redis_val
      client.set "#{redis_key}", "#{redis_val}", (err, keys_replies) ->
        if err
          throw err
        res.reply "OK! #{redis_val}"

  robot.respond /delete account (.*)/i, (res) ->
    redis_key = res.message.user.name
    client = Redis.createClient()
    client.get "#{redis_key}", (err, result) ->
      if err
        throw err
      else if result
        redis_val = JSON.parse result
        delete redis_val[res.match[1].trim()]
        redis_val = JSON.stringify redis_val
        client.set "#{redis_key}", "#{redis_val}", (err, keys_replies) ->
          if err
            throw err
          res.reply "OK! #{redis_val}"
      else
        res.reply "already nothing."
