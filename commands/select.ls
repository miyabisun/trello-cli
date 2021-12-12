require! {
  \node-fetch : fetch
  ramda: R
  \../modules/config
  \./init : {handler: initialize}
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
      b-res = await fetch "https://api.trello.com/1/members/me/boards?fields=name&lists=open&key=#{login.key}&token=#{login.token}"
      boards = await b-res.json!
      board = boards |> R.find (.name is name)
      unless board
        console.error "not found board (#name)"
        if init
          console.info "try initialize!"
          initialize {name, select: yes}
        return

      has-lists = (n) -> board.lists |> R.map (.name) |> R.includes n, _
      unless R.all has-lists, ["To Do", \Doing, \Done]>
        console.error "lists is insufficient"
        if init
          console.info "try initialize!"
          initialize {name, select: yes}
        return

      config.write \currentBoard, {board.id, board.name}
      console.info "selected board to #name"
    catch
      console.error e
