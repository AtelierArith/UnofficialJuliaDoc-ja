```julia
Base.mightalias(A::AbstractArray, B::AbstractArray)
```

配列 `A` と `B` が同じメモリを共有している可能性があるかどうかを、保守的に判定します。

デフォルトでは、両方の配列が [`Base.dataids`](@ref) で識別される同じメモリ領域を参照しているかどうかだけを確認します。
