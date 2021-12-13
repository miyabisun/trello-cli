require! {
  \../modules/boards
  \../modules/cards
  \../modules/check
}

module.exports =
  command: ["add <name...>" "a <name...>"]
  desc: "create card to To Do list"
  handler: (argv) ->>
    check.login!
    check.current-board!
    try
      board = await boards.current!
      list = board.lists.find (.name is "To Do")
      for name in argv.name
        {id-short} = await cards.create list.id, name
        console.info "'#name' is created (#id-short)."
    catch
      console.error e
