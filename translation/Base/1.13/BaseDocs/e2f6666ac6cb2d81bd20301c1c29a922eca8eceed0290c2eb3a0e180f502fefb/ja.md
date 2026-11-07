```julia
begin
```

`begin...end`はコードブロックを表します。

```julia
begin
    println("Hello, ")
    println("World!")
end
```

通常、`begin`は必要ありません。[`function`](@ref)や[`let`](@ref)などのキーワードは、暗黙的にコードブロックを開始するためです。詳しくは[`;`](@ref)も参照してください。

`begin`は、コレクションの最初のインデックスや、配列の次元の最初のインデックスを表すために、インデックス指定で使うこともできます。たとえば、`a[begin]`は配列`a`の最初の要素です。

!!! compat "Julia 1.4"
    インデックスとして`begin`を使うには、Julia 1.4以降が必要です。


# Examples

```jldoctest
julia> A = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> A[begin, :]
2-element Matrix{Int64}:
 1
 2
```
