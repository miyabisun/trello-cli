require! {
  \../modules/boards
  \../modules/cards
  \../modules/check
}

module.exports =
  command: ["done [id...]" "d [id...]"]
  desc: "move card to Done list"
  handler: (argv) ->>
    check.login!
    check.current-board!
    try
      board = await boards.current!
      if argv.id
        for id in argv.id
          card = await cards.move-list board, id, \Done
          continue unless card
          console.info "#{card.name} is done."
      else
        card = board.cards.find (.id-list)
          >> (is board.lists.find (.name is \Doing) .id)
        if card
          await cards.move-list board, card.id-short, \Done
          console.info "#{card.name} is done."
    catch
      console.error e
