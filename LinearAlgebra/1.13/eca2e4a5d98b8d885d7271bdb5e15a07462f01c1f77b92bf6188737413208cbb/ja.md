```julia
_MulAddMul_nonzeroalpha(_add::MulAddMul[, ::Val{false}])
```

`alpha`の値を、型で許可されている場合はゼロ以外のリテラル値（たとえば`_add.alpha isa Bool`の場合は、返されるインスタンスで`alpha`が`true`に設定されます）に設定できる、新しい`MulAddMul`を返します。それ以外の場合、引数を1つだけ指定した呼び出しは何もせず、変更のない`_add`を返します。

さらに、`Val(false)`を第2引数として指定すると、返される`MulAddMul`インスタンスでは`beta`が`false`に設定されます。
