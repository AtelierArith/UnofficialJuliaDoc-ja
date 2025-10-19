```julia
CartesianIndices(sz::Dims) -> R
CartesianIndices((istart:[istep:]istop, jstart:[jstep:]jstop, ...)) -> R
```

整数インデックスの多次元矩形範囲を含む領域 `R` を定義します。これは、`for I in R ... end` がネストされたループに相当する [`CartesianIndex`](@ref) インデックス `I` を返す反復の文脈で最も一般的に遭遇します。

```julia
for j = jstart:jstep:jstop
    for i = istart:istep:istop
        ...
    end
end
```

したがって、これらは任意の次元で動作するアルゴリズムを書くのに役立ちます。

```julia
CartesianIndices(A::AbstractArray) -> R
```

配列から `CartesianIndices` を構築することは、そのインデックスの範囲を作成する便利な方法です。

!!! compat "Julia 1.6"
    ステップ範囲メソッド `CartesianIndices((istart:istep:istop, jstart:[jstep:]jstop, ...))` は、少なくとも Julia 1.6 が必要です。


# 例

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

## 線形インデックスとカーテシアンインデックスの変換

線形インデックスからカーテシアンインデックスへの変換は、`CartesianIndices` が `AbstractArray` であり、線形にインデックスできるという事実を利用します。

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

## ブロードキャスティング

`CartesianIndices` は、`CartesianIndex` とのブロードキャスティング演算（+ と -）をサポートしています。

!!! compat "Julia 1.1"
    CartesianIndices のブロードキャスティングには、少なくとも Julia 1.1 が必要です。


```jldoctest
julia> CIs = CartesianIndices((2:3, 5:6))
CartesianIndices((2:3, 5:6))

julia> CI = CartesianIndex(3, 4)
CartesianIndex(3, 4)

julia> CIs .+ CI
CartesianIndices((5:6, 9:10))
```

カーテシアンから線形インデックスへの変換については、[`LinearIndices`](@ref) を参照してください。
