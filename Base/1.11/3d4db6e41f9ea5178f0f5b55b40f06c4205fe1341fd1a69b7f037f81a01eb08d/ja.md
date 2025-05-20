```
count([f=identity,] itr; init=0) -> Integer
```

`f` が `true` を返す `itr` の要素の数をカウントします。`f` が省略された場合、`itr` の `true` 要素の数をカウントします（これはブール値のコレクションである必要があります）。`init` はカウントを開始する値を指定するオプションであり、出力の型も決定します。

!!! compat "Julia 1.6"
    `init` キーワードは Julia 1.6 で追加されました。


参照: [`any`](@ref), [`sum`](@ref).

# 例

```jldoctest
julia> count(i->(4<=i<=6), [2,3,4,5,6])
3

julia> count([true, false, true, true])
3

julia> count(>(3), 1:7, init=0x03)
0x07
```
