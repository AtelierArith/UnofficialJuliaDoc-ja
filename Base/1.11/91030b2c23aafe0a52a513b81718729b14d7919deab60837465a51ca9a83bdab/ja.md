```
factorial(n::Integer)
```

`n`の階乗。`n`が[`Integer`](@ref)の場合、階乗は整数として計算されます（少なくとも64ビットに昇格されます）。`n`が小さくない場合、オーバーフローする可能性があることに注意してください。ただし、`factorial(big(n))`を使用して、任意の精度で正確に結果を計算できます。

また、[`binomial`](@ref)も参照してください。

# 例

```jldoctest
julia> factorial(6)
720

julia> factorial(21)
ERROR: OverflowError: 21 is too large to look up in the table; consider using `factorial(big(21))` instead
Stacktrace:
[...]

julia> factorial(big(21))
51090942171709440000
```

# 外部リンク

  * [Factorial](https://en.wikipedia.org/wiki/Factorial) on Wikipedia.

```
