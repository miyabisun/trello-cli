require! {
  \node-fetch : fetch
  ramda: R
  \../modules/config
  \../modules/boards : boards
  \../modules/lists : lists
}

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
      board = await boards.find name
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
          board = await boards.find name
          console.info "create '#name' board."
        else return

      for n in ["To Do", \Doing, \Done]
        continue if n in board.lists.map (.name)
        console.error "'#n' list is insufficient."
        if init
          await lists.create board, n
          console.info "create '#n' list."
        else return

      config.write \currentBoard, {board.id, board.name}
      console.info "selected board to #name."
    catch
      console.error e
