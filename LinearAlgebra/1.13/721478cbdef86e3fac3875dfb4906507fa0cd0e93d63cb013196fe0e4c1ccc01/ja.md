```julia
zeroslike(::Type{M}, ax::Tuple{AbstractUnitRange, Vararg{AbstractUnitRange}}) where {M<:AbstractMatrix}
zeroslike(::Type{M}, sz::Tuple{Integer, Vararg{Integer}}) where {M<:AbstractMatrix}
```

`M`に似た、適切なゼロ要素の配列を返します。軸`ax`またはサイズ`sz`を指定してください。これは、行列値を持つ帯行列の構造的なゼロ要素として使用されます。デフォルトでは、`zeroslike`は各軸のサイズを使って配列を構築します。
