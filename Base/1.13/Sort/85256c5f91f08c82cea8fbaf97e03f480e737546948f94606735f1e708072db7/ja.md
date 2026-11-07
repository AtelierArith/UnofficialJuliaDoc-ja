```julia
CheckSorted(next) isa Base.Sort.Algorithm
```

入力がすでにソート済みかどうかを確認します。入力が大きい場合は、逆順にソートされているかどうかも確認します。逆順ソートの判定は安定ではありません。
