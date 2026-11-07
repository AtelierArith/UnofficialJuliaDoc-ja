```julia
Float64(x [, mode::RoundingMode])
```

`x`から`Float64`を作成します。`x`を正確に表現できない場合は、`mode`によって`x`の丸め方が決まります。

# Examples

```jldoctest
julia> Float64(pi, RoundDown)
3.141592653589793

julia> Float64(pi, RoundUp)
3.1415926535897936
```

利用可能な丸めモードについては、[`RoundingMode`](@ref)を参照してください。
