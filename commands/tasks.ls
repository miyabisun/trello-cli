require! {
  \node-fetch : fetch
  ramda: R
  \../modules/config
}

module.exports =
  command: \tasks
  desc: "show cards in ToDo and Doing list"
  builder: (yargs) ->
    yargs
      .option \short,
        alias: \s
        description: "echo short list"
  handler: (argv) ->>
    {login, current-board} = config.read!
    unless login
      console.error "has not logged in yet."
      return
    unless current-board
      console.error "has not select current board yet."
      return
    try
      b-res = await fetch "https://api.trello.com/1/boards/#{current-board.id}?cards=open&lists=open&key=#{login.key}&token=#{login.token}"
      board = await b-res.json!

      doing-list = board.lists.find (.name is \Doing)
      doing-tasks = board.cards.filter (.id-list is doing-list.id)
      if doing-tasks.length > 0
        if argv.short
          doing-tasks.for-each ({id-short, name}) ->
            console.info "[doing] #id-short: #name"
        else
          console.info "=== Doing tasks ==="
          doing-tasks.for-each ({id-short, name}) ->
            console.info "#id-short: #name"
          console.info ""

      todo-list = board.lists.find (.name is \ToDo)
      todo-tasks = board.cards.filter (.id-list is todo-list.id)
      if todo-tasks.length > 0
        if argv.short
          todo-tasks.for-each ({id-short, name}) ->
            console.info "[todo] #id-short: #name"
        else
          console.info "=== ToDo tasks ==="
          todo-tasks.for-each ({id-short, name}) ->
            console.info "#id-short: #name"
    catch
      console.error e
