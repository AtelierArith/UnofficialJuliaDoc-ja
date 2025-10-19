```julia
intersect!(s::Union{AbstractSet,AbstractVector}, itrs...)
```

渡されたすべての集合を交差させ、結果で`s`を上書きします。配列の順序を維持します。

!!! warning
    変更された引数が他の引数とメモリを共有している場合、動作が予期しないものになることがあります。

