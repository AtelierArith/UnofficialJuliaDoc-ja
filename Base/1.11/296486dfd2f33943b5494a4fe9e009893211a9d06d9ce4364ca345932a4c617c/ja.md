```
LinearIndices(A::AbstractArray)
```

同じ形状と[`axes`](@ref)を持つ`LinearIndices`配列を返し、`A`の各エントリの線形インデックスを保持します。この配列を直交インデックスでインデックス付けすることで、線形インデックスにマッピングできます。

従来のインデックス付け（インデックスは1から始まる）を持つ配列や任意の多次元配列の場合、線形インデックスは1から`length(A)`までの範囲になります。しかし、`AbstractVector`の場合、線形インデックスは`axes(A, 1)`であり、したがって、従来でないインデックス付けを持つベクトルでは1から始まりません。

この関数を呼び出すことは、線形インデックスを利用するアルゴリズムを書く「安全な」方法です。

# 例

```jldoctest
julia> A = fill(1, (5,6,7));

julia> b = LinearIndices(A);

julia> extrema(b)
(1, 210)
```

```
LinearIndices(inds::CartesianIndices) -> R
LinearIndices(sz::Dims) -> R
LinearIndices((istart:istop, jstart:jstop, ...)) -> R
```

指定された形状または[`axes`](@ref)を持つ`LinearIndices`配列を返します。

# 例

このコンストラクタの主な目的は、直交インデックスから線形インデックスへの直感的な変換です：

```jldoctest
julia> linear = LinearIndices((1:3, 1:2))
3×2 LinearIndices{2, Tuple{UnitRange{Int64}, UnitRange{Int64}}}:
 1  4
 2  5
 3  6

julia> linear[1,2]
4
```
