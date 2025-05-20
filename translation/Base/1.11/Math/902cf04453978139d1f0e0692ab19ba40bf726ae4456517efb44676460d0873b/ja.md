```
exp2(x)
```

`x`の底2指数を計算します。言い換えれば、$2^x$です。

関連情報としては、[`ldexp`](@ref)、[`<<`](@ref)があります。

# 例

```jldoctest
julia> exp2(5)
32.0

julia> 2^5
32

julia> exp2(63) > typemax(Int)
true
```
