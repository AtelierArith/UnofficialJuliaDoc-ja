```julia
zeroslike(::Type{M}, ax::Tuple{AbstractUnitRange, Vararg{AbstractUnitRange}}) where {M<:AbstractMatrix}
zeroslike(::Type{M}, sz::Tuple{Integer, Vararg{Integer}}) where {M<:AbstractMatrix}
```

`M`に似た適切なゼロ配列を、軸`ax`またはサイズ`sz`を使用して返します。これは、行列値のバンド行列の構造的ゼロ要素として使用されます。デフォルトでは、`zeroslike`は各軸に沿ったサイズを使用して配列を構築します。
