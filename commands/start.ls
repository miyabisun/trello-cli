require! {
  \node-fetch : fetch
  ramda: R
  \../modules/config
  \../modules/find-current-board
  \../modules/move-list
}

module.exports =
  command: "start <id...>"
  desc: "move card to Doing list"
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
        card = await move-list login, board, id, \Doing
        continue unless card
        console.info "#{card.name} is start."
    catch
      console.error e
