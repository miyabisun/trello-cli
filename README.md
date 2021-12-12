# todo-cli

# installation

dependencies Node.js and npm package module.
install Node.js and type this.

```bash
$ npm install -g https://github.com/miyabisun/todo-cli
```

# usage

show `--help` option mode.

```bash
$ todo -h
todo [コマンド]

コマンド:
  todo add <name...>  create card to To Do list
  todo close [id...]  delete cards in Done list
  todo done [id...]   move card to Done list
  todo init <name>    initialize board (create board and lists)
  todo lists          show boards
  todo login          try login and save to ~/.todo.yml
  todo next           show doing card
  todo pause <id...>  move card to To Do list
  todo select <name>  select current board
  todo start <id...>  move card to Doing list
  todo tasks          show cards in To Do and Doing list

オプション:
  -h, --help     ヘルプを表示                                             [真偽]
  -v, --version  バージョンを表示                                         [真偽]
```

todo-cli flow

1. `todo login -k <API-key> -t <Token>`
2. `todo init <Border Name> -s`
3. `todo add <todo name1> <todo name2> ...`
4. `todo`
5. `todo start <id>`
6. `todo done`
7. `todo close -d`

show subcommand `--help` options.
eg. `todo login -h`
