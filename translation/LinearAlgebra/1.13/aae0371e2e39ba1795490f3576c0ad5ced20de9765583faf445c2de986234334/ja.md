```julia
opnorm(A::Adjoint{<:Any,<:AbstractVector}, q::Real=2)
opnorm(A::Transpose{<:Any,<:AbstractVector}, q::Real=2)
```

Adjoint/Transposeでラップされたベクトルに対しては、`A`の作用素``q``ノルムを返します。これは、値が`p = q/(q-1)`の`p`ノルムと等価です。両者は`p = q = 2`で一致します。`A`をベクトルとして扱ったときの`p`ノルムの計算には、[`norm`](@ref)を使用してください。

ベクトル空間とその双対空間でノルムが異なるのは、双対性と内積の関係を保つためです。この結果は、`1 × n`行列の作用素`p`ノルムとも整合します。

# Examples

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
