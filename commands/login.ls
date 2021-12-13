require! {
  \../modules/boards
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
      process.exit 1
    try
      await boards.list {key, token}
      config.write \login, {key, token}
      console.log "login successful!"
    catch
      console.log e
      config.write \login, null
      console.log "login failed..."
