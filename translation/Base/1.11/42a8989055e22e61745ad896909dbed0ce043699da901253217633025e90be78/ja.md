```
Slices{P,SM,AX,S,N} <: AbstractSlices{S,N}
```

指定された次元に対する親配列へのスライスの`AbstractArray`であり、他の次元からすべてのデータを選択するビューを返します。

これらは通常、[`eachslice`](@ref)、[`eachcol`](@ref)または[`eachrow`](@ref)によって構築されるべきです。

[`parent(s::Slices)`](@ref)は親配列を返します。
