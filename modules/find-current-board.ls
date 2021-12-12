require! {
  \node-fetch : fetch
  \./config
}

module.exports = (login, current-board) ->>
  unless login and current-board
    {login, current-board} = config.read!
  (await fetch "https://api.trello.com/1/boards/#{current-board.id}?cards=open&lists=open&key=#{login.key}&token=#{login.token}")
  |> (.json!)
