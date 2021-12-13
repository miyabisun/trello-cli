require! {
  \node-fetch : fetch
  \./config
}
{login} = config.read!
base = "https://api.trello.com/1"

module.exports =
  get: (path, params = {}) ->>
    query = new URLSearchParams ({} <<< login <<< params)
    res = await fetch "#base#path?#query"
    throw res if res.status isnt 200
    res.json!
  post: (path, params = {}) ->>
    query = new URLSearchParams login
    res = await fetch "#base#path?#query",
      method: \POST
      headers:
        \Accept : \application/json
        \Content-Type : \application/json
      body: JSON.stringify params
    throw res if res.status isnt 200
    res.json!
  put: (path, params = {}) ->>
    query = new URLSearchParams login
    res = await fetch "#base#path?#query",
      method: \PUT
      headers:
        \Accept : \application/json
        \Content-Type : \application/json
      body: JSON.stringify params
    throw res if res.status isnt 200
    res.json!
  delete: (path) ->>
    query = new URLSearchParams login
    res = await fetch "#base#path?#query",
      method: \DELETE
    throw res if res.status isnt 200
    res.json!
