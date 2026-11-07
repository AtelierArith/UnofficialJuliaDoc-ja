```julia
LinearIndices(A::AbstractArray)
```

`A` の各要素の線形インデックスを格納する、`A` と同じ形状および [`axes`](@ref) を持つ `LinearIndices` 配列を返します。この配列を直積インデックスでインデックス付けすると、それらを線形インデックスに対応付けられます。

通常のインデックス（インデックスが 1 から始まる）を持つ配列、または任意の多次元配列では、線形インデックスは 1 から `length(A)` までの範囲になります。ただし、`AbstractVector` の線形インデックスは `axes(A, 1)` であるため、通常とは異なるインデックスを持つベクトルでは 1 から始まりません。

この関数を呼び出すことが、線形インデックスを利用するアルゴリズムを安全に記述する方法です。

# Examples

```jldoctest
julia> A = fill(1, (5,6,7));

julia> b = LinearIndices(A);

julia> extrema(b)
(1, 210)
```

```julia
LinearIndices(inds::CartesianIndices) -> R
LinearIndices(sz::Dims) -> R
LinearIndices((istart:istop, jstart:jstop, ...)) -> R
```

指定した形状または [`axes`](@ref) を持つ `LinearIndices` 配列を返します。

# Examples

このコンストラクターの主な目的は、直積インデックスから線形インデックスへの直感的な変換です。

```jldoctest
julia> linear = LinearIndices((1:3, 1:2))
3×2 LinearIndices{2, Tuple{UnitRange{Int64}, UnitRange{Int64}}}:
 1  4
 2  5
 3  6

julia> linear[1,2]
4
```
