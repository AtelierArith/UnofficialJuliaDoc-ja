```julia
RadioMenu
```

ユーザーがリストから単一のオプションを選択できるメニューです。

# サンプル出力

```julia-repl
julia> request(RadioMenu(options, pagesize=4))
好きな果物を選んでください:
^  ぶどう
   いちご
 > ブルーベリー
v  桃
あなたの好きな果物はブルーベリーです!
```
