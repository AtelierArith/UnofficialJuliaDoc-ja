```julia
convert(T, x)
```

`x`を`T`型の値に変換します。

`T`が[`Integer`](@ref)型の場合、`x`を`T`で表現できないと、[`InexactError`](@ref)が発生します。たとえば、`x`が整数値でない場合や、`T`がサポートする範囲外の場合です。

# Examples

```jldoctest
julia> convert(Int, 3.0)
3

julia> convert(Int, 3.5)
ERROR: InexactError: Int64(3.5)
Stacktrace:
[...]
```

`T`が[`AbstractFloat`](@ref)型の場合、`x`に最も近い、`T`で表現可能な値を返します。最近傍を判定する際、Infは`floatmax(T)`より1 ulp大きい値として扱われます。

```jldoctest
julia> x = 1/3
0.3333333333333333

julia> convert(Float32, x)
0.33333334f0

julia> convert(BigFloat, x)
0.333333333333333314829616256247390992939472198486328125
```

`T`がコレクション型で、`x`がコレクションの場合、`convert(T, x)`の結果は、`x`の全体または一部とメモリを共有することがあります。

```jldoctest
julia> x = Int[1, 2, 3];

julia> y = convert(Vector{Int}, x);

julia> y === x
true
```

関連項目: [`round`](@ref)、[`trunc`](@ref)、[`oftype`](@ref)、[`reinterpret`](@ref)。
