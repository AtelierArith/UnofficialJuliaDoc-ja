```julia
reinterpret(reshape, T, A::AbstractArray{S}) -> B
```

`A`の型解釈を変更し、「チャネル次元」を消費または追加します。

もし`sizeof(T) = n*sizeof(S)`で`n>1`の場合、`A`の最初の次元はサイズ`n`でなければならず、`B`は`A`の最初の次元を欠きます。逆に、もし`sizeof(S) = n*sizeof(T)`で`n>1`の場合、`B`はサイズ`n`の新しい最初の次元を持ちます。`sizeof(T) == sizeof(S)`の場合、次元数は変わりません。

!!! compat "Julia 1.6"
    このメソッドは少なくともJulia 1.6を必要とします。


# 例

```jldoctest
julia> A = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> reinterpret(reshape, Complex{Int}, A)    # 結果はベクトルです
2-element reinterpret(reshape, Complex{Int64}, ::Matrix{Int64}) with eltype Complex{Int64}:
 1 + 3im
 2 + 4im

julia> a = [(1,2,3), (4,5,6)]
2-element Vector{Tuple{Int64, Int64, Int64}}:
 (1, 2, 3)
 (4, 5, 6)

julia> reinterpret(reshape, Int, a)             # 結果は行列です
3×2 reinterpret(reshape, Int64, ::Vector{Tuple{Int64, Int64, Int64}}) with eltype Int64:
 1  4
 2  5
 3  6
```
