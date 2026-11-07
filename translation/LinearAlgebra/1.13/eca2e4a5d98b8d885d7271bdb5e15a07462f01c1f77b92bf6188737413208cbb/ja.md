```julia
_MulAddMul_nonzeroalpha(_add::MulAddMul[, ::Val{false}])
```

`alpha`の値を、型で許可されている場合はリテラルの非ゼロ値（例：`_add.alpha isa Bool`）に設定した、新しい`MulAddMul`を返します。この場合、返されるインスタンスでは`alpha`が`true`に設定されます。それ以外の場合、引数を1つだけ指定した呼び出しは何もせず、変更を加えずに`_add`を返します。

さらに、2番目の引数として`Val(false)`が指定されている場合、返される`MulAddMul`インスタンスでは、`beta`が`false`に設定されます。
