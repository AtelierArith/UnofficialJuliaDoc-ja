```
Float64(x [, mode::RoundingMode])
```

`x`から`Float64`を作成します。`x`が正確に表現できない場合、`mode`が`x`の丸め方を決定します。

# 例

```jldoctest
julia> Float64(pi, RoundDown)
3.141592653589793

julia> Float64(pi, RoundUp)
3.1415926535897936
```

利用可能な丸めモードについては[`RoundingMode`](@ref)を参照してください。
