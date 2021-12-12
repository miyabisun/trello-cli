require! {
  \node-fetch : fetch
  \../modules/config
}

module.exports =
  command: \login
  desc: "try login and save to ~/.todo.yml"
  builder: (yargs) ->
    yargs
      .option \key,
        alias: \k
        type: \string
        description: "api-key: show https://trello.com/app-key"
      .option \token,
        alias: \t
        type: \string
        description: "token: click <create-token> link in api-key page"
  handler: ({key, token}) ->>
    {login: def} = config.read!
    key = key or def.key
    token = token or def.token
    if (!key or !token)
      console.error "not found api-key." unless key
      console.error "not found token." unless token
      return
    try
      res = await fetch "https://api.trello.com/1/members/me/boards?fields=name&key=#{key}&token=#{token}"
      throw res if res.status isnt 200
      config.write \login, {key, token}
      console.log "login successful!"
    catch
      console.error "status-code: #{e.status}"
      console.error "reason: #{await res.text!}"
      config.write \login, null
      console.log "login failed..."
