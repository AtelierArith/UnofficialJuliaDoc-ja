```julia
Slices{P,SM,AX,S,N} <: AbstractSlices{S,N}
```

指定した次元に沿って親配列をスライスし、その他の次元のデータをすべて選択するビューを返す `AbstractArray`。

通常は [`eachslice`](@ref)、[`eachcol`](@ref)、または [`eachrow`](@ref) で構築します。

[`parent(s::Slices)`](@ref) は親配列を返します。
