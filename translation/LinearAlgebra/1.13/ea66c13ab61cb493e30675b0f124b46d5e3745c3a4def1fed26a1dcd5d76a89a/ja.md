```julia
Tridiagonal(dl::V, d::V, du::V) where V <: AbstractVector
```

第1副対角、第1上対角、対角の順に指定して、三重対角行列を構築します。結果の型は`Tridiagonal`で、効率的な専用線形ソルバーを利用できます。ただし、[`convert(Array, _)`](@ref)（または略して`Array(_)`）を使って通常の行列に変換することもできます。`dl`と`du`の長さは、`d`の長さより1短くなければなりません。

!!! note
    副対角の`dl`と上対角の`du`は、互いにエイリアスしていてはなりません。エイリアスが検出された場合、コンストラクターは引数として`du`のコピーを使用します。


# Examples

```jldoctest
julia> dl = [1, 2, 3];

julia> du = [4, 5, 6];

julia> d = [7, 8, 9, 0];

julia> Tridiagonal(dl, d, du)
4×4 Tridiagonal{Int64, Vector{Int64}}:
 7  4  ⋅  ⋅
 1  8  5  ⋅
 ⋅  2  9  6
 ⋅  ⋅  3  0
```
