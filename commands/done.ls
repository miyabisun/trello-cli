require! {
  \../modules/boards
  \../modules/cards
  \../modules/check
}

module.exports =
  command: "done <id...>"
  desc: "move card to Done list"
  handler: (argv) ->>
    check.login!
    check.current-board!
    try
      board = await boards.current!
      for id in argv.id
        card = await cards.move-list board, id, \Done
        continue unless card
        console.info "#{card.name} is done."
    catch
      console.error e
