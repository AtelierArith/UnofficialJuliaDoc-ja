```julia
LogRange{T}(start, stop, len) <: AbstractVector{T}
```

要素が`start`から`stop`まで対数間隔で並ぶ範囲です。間隔は`len`で指定します。[`logrange`](@ref)によって返されます。

[`LinRange`](@ref)と同様に、最初と最後の要素は指定した値と完全に一致しますが、中間の値には小さな浮動小数点誤差が生じる場合があります。これらの値は端点の対数を使って計算されます。対数は構築時に保存され、`T`より高精度であることもよくあります。

# Examples

```jldoctest
julia> logrange(1, 4, length=5)
5-element Base.LogRange{Float64, Base.TwicePrecision{Float64}}:
 1.0, 1.41421, 2.0, 2.82843, 4.0

julia> Base.LogRange{Float16}(1, 4, 5)
5-element Base.LogRange{Float16, Float64}:
 1.0, 1.414, 2.0, 2.828, 4.0

julia> logrange(1e-310, 1e-300, 11)[1:2:end]
6-element Vector{Float64}:
 1.0e-310
 9.999999999999974e-309
 9.999999999999981e-307
 9.999999999999988e-305
 9.999999999999994e-303
 1.0e-300

julia> prevfloat(1e-308, 5) == ans[2]
true
```

整数型のeltype `T`は使用できない点に注意してください。たとえば`round.(Int, xs)`を使うか、次のように整数の底のべき乗を明示的に指定してください。

```jldoctest
julia> xs = logrange(1, 512, 4)
4-element Base.LogRange{Float64, Base.TwicePrecision{Float64}}:
 1.0, 8.0, 64.0, 512.0

julia> 2 .^ (0:3:9) |> println
[1, 8, 64, 512]
```

!!! compat "Julia 1.11"
    この型を使用するには、Julia 1.11以降が必要です。

