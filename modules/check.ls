require! {
  \./config
}

module.exports =
  login: ->
    {login} = config.read!
    unless login
      console.error "has not logged in yet."
      process.exit 1
    {key, token} = login
    unless key and token
      console.error "incorrect login data."
      process.exit 1
  current-board: ->
    {current-board} = config.read!
    unless current-board
      console.error "has not select current board yet."
      process.exit 1
    {id, name} = current-board
    unless id and name
      console.error "incorrect current-board data."
      process.exit 1
