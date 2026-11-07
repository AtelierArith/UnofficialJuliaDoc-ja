```julia
LinRange{T,L}
```

`start`から`stop`までを、間隔が線形になるように`len`個に分割した範囲です。間隔の大きさは`len`で指定します。これは`Integer`でなければなりません。

# Examples

```jldoctest
julia> LinRange(1.5, 5.5, 9)
9-element LinRange{Float64, Int64}:
 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0, 5.5
```

[`range`](@ref)を使う場合と比べて、`LinRange`を直接構築するとオーバーヘッドは小さくなりますが、浮動小数点誤差の補正は試みません。

```jldoctest
julia> collect(range(-0.1, 0.3, length=5))
5-element Vector{Float64}:
 -0.1
  0.0
  0.1
  0.2
  0.3

julia> collect(LinRange(-0.1, 0.3, 5))
5-element Vector{Float64}:
 -0.1
 -1.3877787807814457e-17
  0.09999999999999999
  0.19999999999999998
  0.3
```

対数間隔の点については、[`Base.LogRange`](@ref Base.LogRange)も参照してください。
