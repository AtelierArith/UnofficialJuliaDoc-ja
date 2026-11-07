```julia
CartesianIndices(sz::Dims) -> R
CartesianIndices((istart:[istep:]istop, jstart:[jstep:]jstop, ...)) -> R
```

整数インデックスの多次元の矩形範囲にわたる領域 `R` を定義します。これは主に反復処理で使われ、`for I in R ... end` は、次の入れ子のループと同等の [`CartesianIndex`](@ref) インデックス `I` を返します。

```julia
for j = jstart:jstep:jstop
    for i = istart:istep:istop
        ...
    end
end
```

このため、任意の次元で動作するアルゴリズムを記述する際に役立ちます。

```julia
CartesianIndices(A::AbstractArray) -> R
```

利便性のため、配列から `CartesianIndices` を構築すると、その配列のインデックスの範囲が作成されます。

!!! compat "Julia 1.6"
    ステップ付き範囲のメソッド `CartesianIndices((istart:istep:istop, jstart:[jstep:]jstop, ...))` には、Julia 1.6 以降が必要です。


# Examples

```jldoctest
julia> foreach(println, CartesianIndices((2, 2, 2)))
CartesianIndex(1, 1, 1)
CartesianIndex(2, 1, 1)
CartesianIndex(1, 2, 1)
CartesianIndex(2, 2, 1)
CartesianIndex(1, 1, 2)
CartesianIndex(2, 1, 2)
CartesianIndex(1, 2, 2)
CartesianIndex(2, 2, 2)

julia> CartesianIndices(fill(1, (2,3)))
CartesianIndices((2, 3))
```

## Conversion between linear and cartesian indices

線形インデックスからデカルトインデックスへの変換では、`CartesianIndices` が `AbstractArray` であり、線形インデックスでアクセスできることを利用します。

```jldoctest
julia> cartesian = CartesianIndices((1:3, 1:2))
CartesianIndices((1:3, 1:2))

julia> cartesian[4]
CartesianIndex(1, 2)

julia> cartesian = CartesianIndices((1:2:5, 1:2))
CartesianIndices((1:2:5, 1:2))

julia> cartesian[2, 2]
CartesianIndex(3, 2)
```

## Broadcasting

`CartesianIndices` は、`CartesianIndex` との算術演算（+ および -）のブロードキャストをサポートします。

!!! compat "Julia 1.1"
    CartesianIndices のブロードキャストには、Julia 1.1 以降が必要です。


```jldoctest
julia> CIs = CartesianIndices((2:3, 5:6))
CartesianIndices((2:3, 5:6))

julia> CI = CartesianIndex(3, 4)
CartesianIndex(3, 4)

julia> CIs .+ CI
CartesianIndices((5:6, 9:10))
```

デカルトインデックスから線形インデックスへの変換については、[`LinearIndices`](@ref) を参照してください。
