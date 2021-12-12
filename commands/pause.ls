require! {
  \node-fetch : fetch
  ramda: R
  \../modules/config
  \../modules/find-current-board
  \../modules/move-list
}

module.exports =
  command: "pause <id...>"
  desc: "move card to To Do list"
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
      for id in argv.id
        card = await move-list login, board, id, "To Do"
        continue unless card
        console.info "#{card.name} is paused."
    catch
      console.error e
