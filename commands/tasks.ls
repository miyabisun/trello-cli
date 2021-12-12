require! {
  \node-fetch : fetch
  \../modules/config
  \../modules/find-current-board
}

module.exports =
  command: \tasks
  desc: "show cards in To Do and Doing list"
  builder: (yargs) ->
    yargs
      .option \short,
        alias: \s
        description: "show short list"
      .option \done,
        alias: \d
        description: "show Done cards"
  handler: (argv) ->>
    {login, current-board} = config.read!
    unless login
      console.error "has not logged in yet."
      return
    unless current-board
      console.error "has not select current board yet."
      return
    try
      board = await find-current-board login, current-board

      doing-list = board.lists.find (.name is \Doing)
      doing-cards = board.cards.filter (.id-list is doing-list.id)
      if doing-cards.length > 0
        if argv.short
          doing-cards.for-each ({id-short, name}) ->
            console.info "[doing] #id-short: #name"
        else
          console.info "=== Doing tasks ==="
          doing-cards.for-each ({id-short, name}) ->
            console.info "#id-short: #name"

      todo-list = board.lists.find (.name is "To Do")
      todo-cards = board.cards.filter (.id-list is todo-list.id)
      if todo-cards.length > 0
        if argv.short
          todo-cards.for-each ({id-short, name}) ->
            console.info "[todo] #id-short: #name"
        else
          console.info "=== To Do tasks ==="
          todo-cards.for-each ({id-short, name}) ->
            console.info "#id-short: #name"

      if argv.done
        done-list = board.lists.find (.name is \Done)
        done-cards = board.cards.filter (.id-list is done-list.id)
        if done-cards.length > 0
          if argv.short
            done-cards.for-each ({id-short, name}) ->
              console.info "[done] #id-short: #name"
          else
            console.info "=== Done tasks ==="
            done-cards.for-each ({id-short, name}) ->
              console.info "#id-short: #name"
    catch
      console.error e
