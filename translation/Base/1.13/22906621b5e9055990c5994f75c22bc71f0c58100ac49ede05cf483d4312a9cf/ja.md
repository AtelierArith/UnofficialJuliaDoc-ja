```julia
count([f=identity,] itr; init=0)::Integer
```

`f` が `true` を返す要素の数を、`itr` から数えます。`f` を省略した場合は、`itr`（ブール値のコレクションである必要があります）に含まれる `true` 要素の数を数えます。`init` は、カウントの開始値を指定するオプションの引数であり、出力の型も決定します。

!!! compat "Julia 1.6"
    `init` キーワード引数は Julia 1.6 で追加されました。


関連項目: [`any`](@ref)、[`sum`](@ref)。

# Examples

```jldoctest
julia> count(i->(4<=i<=6), [2,3,4,5,6])
3

julia> count([true, false, true, true])
3

julia> count(>(3), 1:7, init=UInt(0))
0x0000000000000004
```
