```
begin
```

`begin...end` はコードのブロックを示します。

```julia
begin
    println("Hello, ")
    println("World!")
end
```

通常、`begin` は必要ありません。なぜなら、[`function`](@ref) や [`let`](@ref) のようなキーワードは、暗黙的にコードのブロックを開始するからです。詳細は [`;`](@ref) を参照してください。

`begin` は、コレクションの最初のインデックスや配列の次元の最初のインデックスを表すためにインデックス指定時にも使用できます。例えば、`a[begin]` は配列 `a` の最初の要素です。

!!! compat "Julia 1.4"
    インデックスとしての `begin` の使用は、Julia 1.4 以降が必要です。


# 例

```jldoctest
julia> A = [1 2; 3 4]
2×2 Array{Int64,2}:
 1  2
 3  4

julia> A[begin, :]
2-element Array{Int64,1}:
 1
 2
```
