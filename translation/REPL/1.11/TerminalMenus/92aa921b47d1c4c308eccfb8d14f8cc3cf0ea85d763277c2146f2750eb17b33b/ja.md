```
MultiSelectMenu
```

ユーザーがリストから複数のオプションを選択できるメニューです。

# サンプル出力

```julia-repl
julia> request(MultiSelectMenu(options))
好きな果物を選んでください:
[press: Enter=toggle, a=all, n=none, d=done, q=abort]
   [ ] りんご
 > [X] オレンジ
   [X] ぶどう
   [ ] いちご
   [ ] ブルーベリー
   [X] 桃
   [ ] レモン
   [ ] ライム
あなたが好きな果物:
  - オレンジ
  - ぶどう
  - 桃
```
