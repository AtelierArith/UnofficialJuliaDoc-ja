```julia
SubArray{T,N,P,I,L} <: AbstractArray{T,N}
```

要素型が `T` で、インデックスのタプル（型 `I`）によって制限された、親配列（型 `P`）への `N` 次元ビューです。高速な線形インデックス付けをサポートする型では `L` が true になり、それ以外の型では `false` になります。

[`view`](@ref) 関数を使って `SubArray` を構築します。
