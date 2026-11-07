```julia
intersect!(s::Union{AbstractSet,AbstractVector}, itrs...)
```

渡されたすべての集合の共通部分を求め、その結果で`s`を上書きします。配列では順序を維持します。

!!! warning
    変更される引数がほかの引数とメモリを共有している場合、予期しない動作が発生することがあります。

