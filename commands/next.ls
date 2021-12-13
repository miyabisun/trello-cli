require! {
  \../modules/boards
  \../modules/cards
  \../modules/check
}

module.exports =
  command: <[next n]>
  desc: "show doing card"
  handler: (argv) ->>
    check.login!
    check.current-board!
    try
      board = await boards.current!
      doing-card = board.cards.find (.id-list)
        >> (is board.lists.find (.name is \Doing) .id)
      if doing-card
        {name} = doing-card
        console.info name
        return

      todo-card = board.cards.find (.id-list)
        >> (is board.lists.find (.name is "To Do") .id)
      if todo-card
        {name, id-short} = todo-card
        await cards.move-list board, id-short, \Doing
        console.info name
        return
    catch
      console.error e
