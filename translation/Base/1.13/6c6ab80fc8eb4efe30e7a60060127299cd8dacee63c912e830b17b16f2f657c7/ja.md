```julia
Base.mightalias(A::AbstractArray, B::AbstractArray)
```

配列 `A` と `B` が同じメモリを共有している可能性があるか、保守的なテストを行います。

デフォルトでは、両方の配列が [`Base.dataids`](@ref) で識別される同じメモリ領域を参照しているかどうかを確認するだけです。
