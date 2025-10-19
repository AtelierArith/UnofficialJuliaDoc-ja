```julia
Bool <: Integer
```

ブール型で、値は `true` と `false` を含みます。

`Bool` は数の一種です：`false` は数値的に `0` と等しく、`true` は数値的に `1` と等しいです。さらに、`false` は [`NaN`](@ref) と [`Inf`](@ref) に対して乗法的な「強いゼロ」として機能します：

```jldoctest
julia> [true, false] == [1, 0]
true

julia> 42.0 + true
43.0

julia> 0 .* (NaN, Inf, -Inf)
(NaN, NaN, NaN)

julia> false .* (NaN, Inf, -Inf)
(0.0, 0.0, -0.0)
```

[`if`](@ref) や他の条件文では `Bool` のみを受け入れます。Julia には「真値」と呼ばれる値は存在しません。

比較は通常 `Bool` を返し、ブロードキャストされた比較は `Array{Bool}` の代わりに [`BitArray`](@ref) を返すことがあります。

```jldoctest
julia> [1 2 3 4 5] .< pi
1×5 BitMatrix:
 1  1  1  0  0

julia> map(>(pi), [1 2 3 4 5])
1×5 Matrix{Bool}:
 0  0  0  1  1
```

他に [`trues`](@ref)、[`falses`](@ref)、[`ifelse`](@ref) も参照してください。
