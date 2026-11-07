```julia
Float32(x [, mode::RoundingMode])
```

`x`から`Float32`を作成します。`x`を正確に表現できない場合は、`mode`によって`x`の丸め方が決まります。

# Examples

```jldoctest
julia> Float32(1/3, RoundDown)
0.3333333f0

julia> Float32(1/3, RoundUp)
0.33333334f0
```

利用可能な丸めモードについては、[`RoundingMode`](@ref)を参照してください。
