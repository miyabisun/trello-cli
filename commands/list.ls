require! {
  ramda: R
  \../modules/check
  \../modules/boards
}

module.exports =
  command: <[list ls]>
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
    check.login!
    check.current-board!
    try
      board = await boards.current!
      [
        [\Doing, \doing]
        ["To Do", \todo]
      ]
      |> R.when do
        -> argv.done
        R.append [\Done, \done]
      |> R.for-each ([list, short-list]) ->
        cards = board.cards.filter (.id-list)
          >> (is board.lists.find (.name is list) .id)
        if cards.length
          if argv.short
            cards.for-each ({id-short, name}) ->
              console.info "[#short-list] #id-short: #name"
          else
            console.info "=== #list tasks ==="
            cards.for-each ({id-short, name}) ->
              console.info "#id-short: #name"
    catch
      console.error e
