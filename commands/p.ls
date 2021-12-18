require! {
  \node-fzf
  ramda: R
  \../modules/boards
  \../modules/cards
  \../modules/check
}

module.exports =
  command: \p
  desc: "[tty] move card to To Do list"
  handler: (argv) ->>
    check.login!
    check.current-board!
    try
      board = await boards.current!
      lists = board.lists.reduce (obj, {id, name}) -> {...obj, "#id": name}, {}

      {selected} = await node-fzf do
        list: board.cards
          |> R.map -> {...it, board-name: lists.(it.id-list)}
          |> R.juxt [\Doing, \Done].map (name) ->
            (.filter (.board-name is name))
          |> R.flatten
          |> R.map ({board-name, id-short, name}) ->
            "[#board-name] #id-short: #name"
      return unless selected

      id-short = selected?.value.match /^[^\]]*\] (\d+):/ .1 |> parse-int
      card = await cards.move-list board, id-short, "To Do"
      return unless card
      console.info "#{card.name} is paused."
    catch
      console.error e
