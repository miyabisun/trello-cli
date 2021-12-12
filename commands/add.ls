require! {
  \node-fetch : fetch
  ramda: R
  \../modules/config
  \../modules/find-current-board
  \../modules/move-list
}

module.exports =
  command: "add <name...>"
  desc: "create card to To Do list"
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
      todo-list = board.lists.find (.name is "To Do")
      for name in argv.name
        res = await fetch "https://api.trello.com/1/cards?key=#{login.key}&token=#{login.token}",
          method: \POST
          headers:
            Accept: \application/json
            \Content-Type : \application/json
          body: JSON.stringify do
            name: name
            pos: \bottom
            id-list: todo-list.id
        throw res if res.status isnt 200
        card = await res.json!
        console.info "#name is created (#{card.id-short})."
    catch
      console.error e
