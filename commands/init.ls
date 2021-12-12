require! {
  \node-fetch : fetch
  ramda: R
  \../modules/config
}

module.exports =
  command: "init <name>"
  desc: "initialize board (create board and lists)"
  builder: (yargs) ->
    yargs
      .option \select,
        alias: \s
        description: "with select"
  handler: (argv) ->>
    {login} = config.read!
    unless login
      console.error "has not logged in yet."
      return
    {name, select} = argv

    try
      b-res = await fetch "https://api.trello.com/1/members/me/boards?fields=name&lists=open&key=#{login.key}&token=#{login.token}"
      board = (await b-res.json!) |> R.find (.name is name)

      unless board
        res = await fetch "https://api.trello.com/1/boards?key=#{login.key}&token=#{login.token}",
          method: \POST
          headers:
            Accept: \application/json
            \Content-Type : \application/json
          body: JSON.stringify do
            name: name
            default-lists: false
        throw res if res.status isnt 200
        console.info "create #name board."
        b-res = await fetch "https://api.trello.com/1/members/me/boards?fields=name&lists=open&key=#{login.key}&token=#{login.token}"
        board = (await b-res.json!) |> R.find (.name is name)

      has-lists = (n) -> board.lists |> R.map (.name) |> R.includes n, _
      create-list = (n) ->>
        res = await fetch "https://api.trello.com/1/boards/#{board.id}/lists?key=#{login.key}&token=#{login.token}",
          method: \POST
          headers:
            Accept: \application/json
            \Content-Type : \application/json
          body: JSON.stringify do
            name: n
            pos: \bottom
        throw res if res.status isnt 200

      unless has-lists "To Do"
        await create-list "To Do"
        console.info "create To Do list"
      unless has-lists \Doing
        await create-list \Doing
        console.info "create Doing list"
      unless has-lists \Done
        await create-list \Done
        console.info "create Done list"

      console.info "initialize is done"

      if select
        config.write \currentBoard, {board.id, board.name}
        console.info "selected board to #name"
    catch
      console.error e
