```julia
reinterpret(reshape, T, A::AbstractArray{S}) -> B
```

「チャネル次元」を消費または追加する際に、`A`の型解釈を変更します。

`n>1`に対して`sizeof(T) = n*sizeof(S)`の場合、`A`の第1次元のサイズは`n`でなければならず、`B`には`A`の第1次元がありません。逆に、`n>1`に対して`sizeof(S) = n*sizeof(T)`の場合、`B`にはサイズ`n`の新しい第1次元が追加されます。`sizeof(T) == sizeof(S)`の場合、次元数は変わりません。

!!! compat "Julia 1.6"
    このメソッドを使用するには、Julia 1.6以降が必要です。


# Examples

```jldoctest
julia> A = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> reinterpret(reshape, Complex{Int}, A)    # the result is a vector
2-element reinterpret(reshape, Complex{Int64}, ::Matrix{Int64}) with eltype Complex{Int64}:
 1 + 3im
 2 + 4im

julia> a = [(1,2,3), (4,5,6)]
2-element Vector{Tuple{Int64, Int64, Int64}}:
 (1, 2, 3)
 (4, 5, 6)

julia> reinterpret(reshape, Int, a)             # the result is a matrix
3×2 reinterpret(reshape, Int64, ::Vector{Tuple{Int64, Int64, Int64}}) with eltype Int64:
 1  4
 2  5
 3  6
```
