require! {
  \node-fetch : fetch
  ramda: R
  \../modules/config
}

module.exports =
  command: "select <name>"
  desc: "select current board"
  builder: (yargs) ->
    yargs
      .option \init,
        alias: \i
        description: "with init (create ToDo, Doing, Done lists)"
  handler: (argv) ->>
    {login} = config.read!
    unless login
      console.error "has not logged in yet."
      return
    {name, init} = argv
    try
      b-res = await fetch "https://api.trello.com/1/members/me/boards?fields=name&lists=open&key=#{login.key}&token=#{login.token}"
      borders = await b-res.json!
      border = borders |> R.find (.name is name)
      unless border
        console.info "not found border (#name)"
        if init
          console.info "try initialize!"
          # await initialize argv
          return
        else return
      has-lists = (n) -> border.lists |> R.map (.name) |> R.includes n, _
      unless R.all has-lists, <[ToDo Doing Done]>
        console.error "lists is insufficient"
        if init
          console.info "try initialize!"
          # await initialize argv
          return
        else return
      config.write \currentBoard, {border.id, border.name}
      console.info "selected board to #name"
    catch
      console.error e
