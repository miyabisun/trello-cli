require! {
  fs
  \js-yaml : yaml
}
path = "#{process.env.HOME}/.todo.yml"
load = ->
  try
    fs.read-file-sync path
    |> yaml.load _
    |> (or {})
  catch
    {}

module.exports =
  read: load
  write: (key, value) ->
    config = load!
    config.(key) = value
    yaml.dump config
    |> fs.write-file-sync path, _
  update: (obj) ->
    (load! <<< obj)
    |> yaml.dump _
    |> fs.write-file-sync path, _
