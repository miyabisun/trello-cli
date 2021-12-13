require! {
  \./fetch-json
}

module.exports =
  create: (list-id, name) ->>
    fetch-json.post "/cards",
      name: name
      pos: \bottom
      id-list: list-id
  move: (card-id, list-id) ->>
    fetch-json.put "/cards/#card-id",
      id-list: list-id
      pos: \bottom
  move-list: (board, short-id, list-name) ->>
    list = board.lists.find (.name is list-name)
    card = board.cards.find (.id-short is short-id)
    unless card
      console.error "id: #short-id is not found..."
      return
    module.exports.move card.id, list.id
  delete: (id) ->>
    fetch-json.delete "/cards/#{id}"
