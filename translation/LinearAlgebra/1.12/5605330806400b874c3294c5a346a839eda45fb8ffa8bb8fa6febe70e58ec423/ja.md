```julia
Tridiagonal(dl::V, d::V, du::V) where V <: AbstractVector
```

最初の下対角成分、対角成分、および最初の上対角成分から三重対角行列を構築します。結果は `Tridiagonal` 型であり、効率的な特化型線形ソルバーを提供しますが、[`convert(Array, _)`](@ref)（または短縮形の `Array(_)`）を使用して通常の行列に変換することができます。`dl` と `du` の長さは `d` の長さよりも1少なくなければなりません。

!!! note
    下対角成分 `dl` と上対角成分 `du` は互いにエイリアスであってはなりません。エイリアスが検出された場合、コンストラクタは引数として `du` のコピーを使用します。


# 例

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
