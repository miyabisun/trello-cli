require! {
  \node-fetch : fetch
  ramda: R
  \../modules/config
}

module.exports =
  command: \lists
  desc: "show boards"
  handler: (argv) ->>
    {login, current-board} = config.read!
    unless login
      console.error "has not logged in yet."
      return
    try
      res = await fetch "https://api.trello.com/1/members/me/boards?fields=name&lists=open&key=#{login.key}&token=#{login.token}"
      (await res.json!)
      |> R.for-each (.name)
        >> (R.if-else (is current-board.name), ("* " +), ("  " +))
        >> console.log
    catch
      console.error e
