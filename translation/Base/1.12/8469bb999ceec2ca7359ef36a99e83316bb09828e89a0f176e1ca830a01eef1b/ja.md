```julia
factorial(n::Integer)
```

`n`の階乗。`n`が[`Integer`](@ref)である場合、階乗は整数として計算され（少なくとも64ビットに昇格される）、`n`が小さくない場合はオーバーフローする可能性がありますが、`factorial(big(n))`を使用して任意の精度で正確に結果を計算できます。

他に[`binomial`](@ref)も参照してください。

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
