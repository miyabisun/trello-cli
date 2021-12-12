require! {
  \node-fetch : fetch
  ramda: R
  \../modules/config
  \../modules/find-current-board
  \../modules/move-list
}

module.exports =
  command: "close [id...]"
  desc: "delete cards in Done list"
  builder: (yargs) ->
    yargs
      .option \done,
        alias: \d
        description: "delete all Done cards"
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

      if argv.done
        done-list = board.lists.find (.name is \Done)
        done-cards = board.cards.filter (.id-list is done-list.id)
        for card in done-cards
          res = await fetch "https://api.trello.com/1/cards/#{card.id}?key=#{login.key}&token=#{login.token}",
            method: \DELETE
          throw res if res.status isnt 200
          console.info "#{card.name} is deleted."

      for card in board.cards.filter (.id-short in argv.id)
        res = await fetch "https://api.trello.com/1/cards/#{card.id}?key=#{login.key}&token=#{login.token}",
          method: \DELETE
        throw res if res.status isnt 200
        console.info "#{card.name} is deleted."
    catch
      console.error e
