```julia
_sort!(v::AbstractVector, a::Base.Sort.Algorithm, o::Base.Order.Ordering, kw; t, offset)
```

`kw`で指定された仕様（たとえば`lo`や`hi`。これらの場合は`view(v, lo:hi)`のみをソートします）に従い、`o`の順序で、アルゴリズム`a`を使って`v`をソートする内部関数です。

ソート中に指定または作成されたスクラッチ領域を返します。スクラッチ領域がない場合は`nothing`を返します。

!!! note
    `_sort!`は`v`を変更しますが、返しません。


返されるスクラッチ領域は`Vector{T}`です。`T`は通常、`v`のeltypeです。ただし例外もあります。たとえば`eltype(v) == Union{Missing, T}`の場合、`MissingOptimization`によって`v`のeltypeが`T`に変わるため、スクラッチ領域が`Vector{T}`になることがあります。

`t`は、対象のアルゴリズムに適したスクラッチ領域であり、`t[i + offset]`としてアクセスします。`t`は、内部呼び出しや再帰呼び出しでアルゴリズムがスクラッチ領域を自身に渡すために使われます。
