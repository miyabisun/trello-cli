require! {
  \../modules/boards
  \../modules/cards
  \../modules/check
}

module.exports =
  command: "start <id...>"
  desc: "move card to Doing list"
  handler: (argv) ->>
    check.login!
    check.current-board!
    try
      board = await boards.current!
      for id in argv.id
        card = await cards.move-list board, id, \Doing
        continue unless card
        console.info "#{card.name} is start."
    catch
      console.error e
