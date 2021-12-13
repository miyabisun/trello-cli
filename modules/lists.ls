require! {
  \./fetch-json
}

module.exports =
  create: (board, name) ->>
    fetch-json.post "/boards/#{board.id}/lists",
      name: name
      pos: \bottom
