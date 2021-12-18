# todo-cli

This is a to-do management tool that uses the [Trello](https://trello.com/) service.  
Node.js is used, and all operations can be performed from the command line.

# installation

dependencies Node.js and npm package module.  
install Node.js and type this.

```bash
$ npm install -g https://github.com/miyabisun/todo-cli
```

## get Trello api-key and token

First, log in to [Trello](https://trello.com/).  
Then go to the [API Key for Developers](https://trello.com/app-key) page to receive your API key and token.

Set it up as a ToDo tool with the following command.

```bash
$ todo login -k <API Key> -t <Token>
login successful!

$ ls -a ~ | grep todo
.todo.yml
```

## uninstall

To uninstall, delete `~/.todo.yml` file.  
Then remove the package you installed with npm.

```bash
$ rm ~/.todo.yml

$ npm uninstall -g todo-cli
Removed executable 'todo' installed by 'todo-cli'
success: package 'todo-cli' uninstalled
```

# usage

show `--help` option mode.

```bash
$ todo -h
todo [コマンド]

コマンド:
  todo add <name...>  create card to To Do list                  [エイリアス: a]
  todo boards         show boards
  todo close [id...]  delete cards                               [エイリアス: c]
  todo done [id...]   move card to Done list                     [エイリアス: d]
  todo list           show cards in To Do and Doing list        [エイリアス: ls]
  todo login          try login and save to ~/.todo.yml
  todo next           show doing card                            [エイリアス: n]
  todo pause <id...>  move card to To Do list                    [エイリアス: p]
  todo select <name>  select current board
  todo start <id...>  move card to Doing list                    [エイリアス: s]

オプション:
  -h, --help     ヘルプを表示                                             [真偽]
  -v, --version  バージョンを表示                                         [真偽]
```

## todo-cli flow

1. `todo select <Board Name> -i`
2. `todo add <todo name1> <todo name2> ...`
3. `todo start <id>`
4. `todo done`
5. `todo close -d`

show subcommand `--help` options.  
eg. `todo init -h`

## set up current board

todo-cli will use Trello's Board, but will require the following List.

- `To Do`
- `Doing`
- `Done`

You can use the `todo select <Board name>` command to switch the target Board,  
but it will fail if these Lists do not exist.

Use the `todo select <new Board name> -i` command to create a Board.  
At this time, if the name of the Board already exists, three Lists will be generated in the Board.

```bash
# Check the Board list.
$ todo boards

# Create Board and select
$ todo select test-board -i
not found 'test-board' board.
create test-board board.
'To Do' list is insufficient.
create 'To Do' list.
'Doing' list is insufficient.
create 'Doing' list.
'Done' list is insufficient.
create 'Done' list.
selected board to test-board.

# "*" is current Board
$ todo boards
* test-board
```

## card

### create

Now let's create a new card.  
The card created by the command will be stored in the To Do list.

```bash
$ todo add "test-task"
'test-task' is created (79).
```

### show cards

You can check the list of cards you have created by using the following command.

```bash
$ todo
[todo] 79: test-task

# The above command is an alias for this
$ todo ls -s
[todo] 79: test-task
```

The number to the left of the card name indicates the card's ID.

### start card

Set catd to Doing.  
Specify the ID set in the card.

```bash
$ todo start 79
test-task is start.
```

### done card

Move the completed card to the Done list.

```bash
$ todo done 79
test-task is done.
```

### pause card

Oh no, this card can't continue to work.  
Let's put it back on the to-do list.

```bash
$ todo pause 79
test-task is paused.
```
