require! {
  \node-fetch : fetch
}

module.exports = (login, board, id, list) ->>
  target-list = board.lists.find (.name is list)

  card = board.cards.find (.id-short is id)
  unless card
    console.error "id: #id is not found..."
    return

  res = await fetch "https://api.trello.com/1/cards/#{card.id}?key=#{login.key}&token=#{login.token}",
    method: \PUT
    headers:
      Accept: \application/json
      \Content-Type : \application/json
    body: JSON.stringify do
      id-list: target-list.id
      pos: \bottom
  throw res if res.status isnt 200

  return card
