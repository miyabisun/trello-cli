require! {
  ramda: R
  \../modules/boards
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
      lists = board.lists.reduce (obj, {id, name}) -> {...obj, "#id": name}, {}
      board.cards
        |> R.map -> {...it, board-name: lists.(it.id-list)}
        |> R.juxt [\Doing, "To Do"].map (name) ->
          (.find (.board-name is name))
        |> R.find R.identity
        |> (?.name)
        |> console.log
    catch
      console.error e
