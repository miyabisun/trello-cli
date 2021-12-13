require! {
  \./config
  \./fetch-json
}

module.exports =
  list: (params = {}) ->>
    fetch-json.get "/members/me/boards", ({fields: \name} <<< params)
  get: (id) ->>
    fetch-json.get "/boards/#id",
      cards: \open
      lists: \open
  find: (name) ->>
    json = await fetch-json.get "/members/me/boards",
      fields: \name
      lists: \open
    json.find (.name is name)
  current: ->>
    {current-board} = config.read!
    module.exports.get current-board.id
  delete: (id) ->>
    await fetch-json.delete "/boards/#id"
