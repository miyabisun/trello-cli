require! {
  \../modules/boards
  \../modules/cards
  \../modules/check
}

module.exports =
  command: ["pause <id...>", "p <id...>"]
  desc: "move card to To Do list"
  handler: (argv) ->>
    check.login!
    check.current-board!
    try
      board = await boards.current!
      for id in argv.id
        card = await cards.move-list board, id, "To Do"
        continue unless card
        console.info "#{card.name} is paused."
    catch
      console.error e
