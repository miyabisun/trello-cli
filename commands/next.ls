require! {
  \node-fetch : fetch
  \../modules/config
  \../modules/find-current-board
  \./start
}

module.exports =
  command: \next
  desc: "show doing card"
  handler: (argv) ->>
    {login, current-board} = config.read!
    unless login
      console.error "has not logged in yet."
      return
    unless current-board
      console.error "has not select current board yet."
      return
    try
      board = await find-current-board!

      doing-list = board.lists.find (.name is \Doing)
      doing-card = board.cards.find (.id-list is doing-list.id)
      if doing-card
        {name} = doing-card
        console.info name
        return

      todo-list = board.lists.find (.name is "To Do")
      todo-card = board.cards.find (.id-list is todo-list.id)
      if todo-card
        {name, id-short} = todo-card
        await start.handler {id: [id-short]}
        console.info name
        return
    catch
      console.error e
