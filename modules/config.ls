require! {
  fs
  \js-yaml : yaml
}
path = "#{process.env.HOME}/.todo.yml"
state = cache: null
reload = ->
  try
    state.cache = fs.read-file-sync path
      |> yaml.load _
      |> (or {})
  catch
    {}
load = -> state.cache or reload!

module.exports =
  read: load
  write: (key, value) ->
    config = load!
    config.(key) = value
    yaml.dump config
    |> fs.write-file-sync path, _
    reload!
  update: (obj) ->
    ({} <<< load! <<< obj)
    |> yaml.dump _
    |> fs.write-file-sync path, _
    reload!
