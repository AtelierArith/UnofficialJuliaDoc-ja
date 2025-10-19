```julia
SubArray{T,N,P,I,L} <: AbstractArray{T,N}
```

親配列（型 `P`）への `N` 次元のビューで、要素型 `T` を持ち、インデックスのタプル（型 `I`）によって制限されています。`L` は、高速な線形インデックスをサポートする型に対しては true であり、それ以外は false です。

[`view`](@ref) 関数を使用して `SubArray` を構築します。
