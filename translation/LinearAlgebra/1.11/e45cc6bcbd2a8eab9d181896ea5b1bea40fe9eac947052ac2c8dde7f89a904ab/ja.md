```
opnorm(A::Adjoint{<:Any,<:AbstractVector}, q::Real=2)
opnorm(A::Transpose{<:Any,<:AbstractVector}, q::Real=2)
```

Adjoint/Transposeでラップされたベクトルの場合、`A`の演算子$q$-ノルムを返します。これは、値`p = q/(q-1)`の`p`-ノルムに相当します。`p = q = 2`のときに一致します。`A`の`p`ノルムをベクトルとして計算するには、[`norm`](@ref)を使用してください。

ベクトル空間とその双対の間のノルムの違いは、双対性と内積の関係を保持するために生じ、結果は`1 × n`行列の演算子`p`-ノルムと一致します。

# 例

```jldoctest
julia> v = [1; im];

julia> vc = v';

julia> opnorm(vc, 1)
1.0

julia> norm(vc, 1)
2.0

julia> norm(v, 1)
2.0

julia> opnorm(vc, 2)
1.4142135623730951

julia> norm(vc, 2)
1.4142135623730951

julia> norm(v, 2)
1.4142135623730951

julia> opnorm(vc, Inf)
2.0

julia> norm(vc, Inf)
1.0

julia> norm(v, Inf)
1.0
```
