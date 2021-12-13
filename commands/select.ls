require! {
  \node-fetch : fetch
  ramda: R
  \../modules/config
}

find-board = (login, name) ->>
  res = await fetch "https://api.trello.com/1/members/me/boards?fields=name&lists=open&key=#{login.key}&token=#{login.token}"
  (await res.json!).find (.name is name)

has-lists = (board, name) ->
  board.lists
  |> R.map (.name)
  |> R.includes name, _

create-list = (login, board, name) ->>
  res = await fetch "https://api.trello.com/1/boards/#{board.id}/lists?key=#{login.key}&token=#{login.token}",
    method: \POST
    headers:
      Accept: \application/json
      \Content-Type : \application/json
    body: JSON.stringify do
      name: name
      pos: \bottom
  throw res if res.status isnt 200

module.exports =
  command: "select <name>"
  desc: "select current board"
  builder: (yargs) ->
    yargs
      .option \init,
        alias: \i
        description: "with init (create To Do, Doing, Done lists)"
  handler: (argv) ->>
    {login} = config.read!
    unless login
      console.error "has not logged in yet."
      return
    {name, init} = argv
    try
      board = await find-board login, name
      unless board
        console.error "not found '#name' board."
        if init
          res = await fetch "https://api.trello.com/1/boards?key=#{login.key}&token=#{login.token}",
            method: \POST
            headers:
              Accept: \application/json
              \Content-Type : \application/json
            body: JSON.stringify do
              name: name
              default-lists: false
          throw res if res.status isnt 200
          board = await find-board login, name
          console.info "create '#name' board."
        else return

      for n in ["To Do", \Doing, \Done]
        continue if has-lists board, n
        console.error "'#n' list is insufficient."
        if init
          await create-list login, board, n
          console.info "create '#n' list."
        else return

      config.write \currentBoard, {board.id, board.name}
      console.info "selected board to #name."
    catch
      console.error e
