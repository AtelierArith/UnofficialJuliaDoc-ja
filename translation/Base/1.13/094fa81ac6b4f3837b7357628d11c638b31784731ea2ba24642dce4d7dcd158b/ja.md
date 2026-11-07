```julia
factorial(n::Integer)
```

`n` の階乗。`n` が [`Integer`](@ref) の場合、階乗は整数（少なくとも64ビットに拡張）として計算されます。`n` が小さくない場合、オーバーフローする可能性があります。ただし、`factorial(big(n))` を使えば、任意精度で正確な結果を計算できます。

[`binomial`](@ref) も参照してください。

# Examples

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

# External links

  * Wikipedia の [Factorial](https://en.wikipedia.org/wiki/Factorial)。
