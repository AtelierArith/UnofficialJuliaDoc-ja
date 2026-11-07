```julia
Printf.tofloat(x)
```

printf 形式での書式設定用に、引数を Base の浮動小数点型に変換します。デフォルトでは、引数は `Float64` に `Float64(x)` で変換されます。Base の浮動小数点型への変換を持ち、printf 形式での書式設定に対応させたいカスタム数値型では、次のようにこのメソッドを拡張できます。

```julia
Printf.tofloat(x::MyCustomType) = convert_my_custom_type_to_float(x)
```

任意精度の数値型では、次のようにメソッドを拡張できます。

```julia
Printf.tofloat(x::MyArbitraryPrecisionType) = BigFloat(x)
```

!!! compat "Julia 1.6"
    この関数を使用するには、Julia 1.6 以降が必要です。

