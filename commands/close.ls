require! {
  ramda: R
  \../modules/boards
  \../modules/cards
  \../modules/check
}

module.exports =
  command: ["close [id...]" "c [id...]"]
  desc: "delete cards"
  builder: (yargs) ->
    yargs
      .option \done,
        alias: \d
        description: "delete all Done cards"
      .option \board,
        alias: \b
        type: \string
        description: "delete board"
  handler: (argv) ->>
    check.login!
    check.current-board!
    try
      board = await boards.current!
      done-list = board.lists.find (.name is \Done)
      del-cards = argv.id or []
        |> R.map (id) -> board.cards.find (.id-short is id)
        |> R.filter R.identity
        |> R.when do
          -> argv.done
          R.concat board.cards.filter (.id-list is done-list.id)
        |> R.uniq-by (.id)
      for {id, name} in del-cards
        await cards.delete id
        console.info "'#name' is deleted."
      if argv.board
        target = await boards.find that
        if target
          await boards.delete target.id
          console.info "'#{argv.board}' board is deleted."

    catch
      console.error e
