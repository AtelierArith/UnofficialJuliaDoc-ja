```
Printf.tofloat(x)
```

引数をprintfフォーマット用のBase float型に変換します。デフォルトでは、引数は`Float64`を介して`Float64(x)`に変換されます。printfフォーマットにフックしたいBase float型への変換を持つカスタム数値型は、このメソッドを次のように拡張できます。

```julia
Printf.tofloat(x::MyCustomType) = convert_my_custom_type_to_float(x)
```

任意精度の数値の場合、次のようにメソッドを拡張できます。

```julia
Printf.tofloat(x::MyArbitraryPrecisionType) = BigFloat(x)
```

!!! compat "Julia 1.6"
    この関数はJulia 1.6以降が必要です。

