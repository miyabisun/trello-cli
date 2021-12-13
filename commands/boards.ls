require! {
  ramda: R
  \../modules/boards
  \../modules/check
  \../modules/config
}

module.exports =
  command: \boards
  desc: "show boards"
  handler: (argv) ->>
    check.login!
    try
      board-name = config.read!.current-board?.name
      (await boards.list!)
      |> R.map (.name)
        >> (R.if-else (is board-name), ("* " +), ("  " +))
        >> console.log
    catch
      console.error e
