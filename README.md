
# Logger

Console のラッパー

## インストール
https://www.npmjs.com/package/amo.modules.logger

```
npm install --save-dev amo.modules.logger
```

## 使い方

```coffeescript
Logger = require "amo.modules.logger"

if DEBUG
  Logger.defaultLogger = Logger.create console # ログ情報は console に出力される
else
  Logger.defaultLogger = Logger.create {}      # ログ情報は破棄される
  # Logger.defaultLogger = Logger.create anotherReporter  # reporter オブジェクトを渡し、別の方法でログを収集することも可能
```

以下、Log.create に console を渡した場合の挙動を説明する
ブラウザによっては使えない関数もあるが、その場合は単に無視される

### `log, debug, info, warn, error`
console のそれと同じだが、先頭に時刻がつく  
ただし、フォーマットテキストは使えない

```coffeescript
logger = require("amo.modules.logger").defaultLogger # 以下略
logger.log   "hoge", "fuga"  # [LOG] 2015-11-28T11:56:48.197Z :: hoge fuga
logger.debug "hoge", "fuga"  # [LOG] 2015-11-28T11:56:48.197Z :: hoge fuga
logger.info  "hoge", "fuga"  # [LOG] 2015-11-28T11:56:48.197Z :: hoge fuga
logger.warn  "hoge", "fuga"  # [LOG] 2015-11-28T11:56:48.197Z :: hoge fuga
logger.error "hoge", "fuga"  # [LOG] 2015-11-28T11:56:48.197Z :: hoge fuga
```

### `logger.assert(expression, msgs...)`
`expression` が false だった場合、msgs 以下が出力される

```coffeescript
a = 1 + 2
logger.assert (a is 3), "hoge", "fuga" # a is 3 が true なので何も出力されない
logger.assert (a isnt 3), "hoge", "fuga" # a isnt 3 が false なので "hoge fuga" が出力される
```

### `logger.clear()`
console の表示をクリアする

### `logger.dir(obj)`
obj の持つプロパティを再帰的に表示する

```coffeescript
obj =
  hoge: "fuga"
  fizzbuzz:
    1: 1
    2: 2
    3: "fizz"
    4: 4
    5: "buzz"
logger.dir obj # obj の持つプロパティが再帰的に表示される
```

### `logger.dirxml(node)`
xml の中身を再帰的に表示する

```coffeescript
node = document.getElementById "hoge"
logger.dirxml node
```

### `logger.table(obj)`
例えば、以下の様な形式の object をいい感じに出力してくれる（詳しいことは未調査）

```coffeescript
table = [
  {hoge: 1, fuga: "fugafuga", fizz: "buzz"}
  {hoge: 2, fuga: "hogehoge", fizz: "____"}
  {hoge: 2, fuga: "piyopiyo", fizz: ";;;;"}
]
logger.table table
```

### `logger.trace()`
これまでのスタックトレースを出力する

```coffeescript
f = -> logger.trace()
g = -> f()
h = -> g()
h()
```

### `logger.count([label])`
この関数が呼び出された回数が表示される
引数なしでカウント出来るほか、 label ごとにカウントすることも可能

### `logger.group(name, block)`
ログをグルーピングすることができる。
block 内で出力されるログは、すべて name というグループのログとして出力される
グループは入れ子にすることも可能

### `logger.time(name, block)`
block() の実行時間を出力する

### `logger.profile(name, block)`
name という名のプロファイルを作成する（が、詳しいことは未調査）

