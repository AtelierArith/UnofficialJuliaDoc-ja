```
convert(T, x)
```

`x`を型`T`の値に変換します。

`T`が[`Integer`](@ref)型の場合、`x`が`T`で表現できない場合（例えば、`x`が整数値でない場合や、`T`がサポートする範囲外の場合）には、[`InexactError`](@ref)が発生します。

# 例

```jldoctest
julia> convert(Int, 3.0)
3

julia> convert(Int, 3.5)
ERROR: InexactError: Int64(3.5)
Stacktrace:
[...]
```

`T`が[`AbstractFloat`](@ref)型の場合、`T`で表現可能な`x`に最も近い値が返されます。Infは、最も近い値を決定する目的で`floatmax(T)`よりも1 ulp大きいものとして扱われます。

```jldoctest
julia> x = 1/3
0.3333333333333333

julia> convert(Float32, x)
0.33333334f0

julia> convert(BigFloat, x)
0.333333333333333314829616256247390992939472198486328125
```

`T`がコレクション型で、`x`がコレクションの場合、`convert(T, x)`の結果は`x`の全体または一部をエイリアスすることがあります。

```jldoctest
julia> x = Int[1, 2, 3];

julia> y = convert(Vector{Int}, x);

julia> y === x
true
```

関連項目: [`round`](@ref), [`trunc`](@ref), [`oftype`](@ref), [`reinterpret`](@ref). ```
