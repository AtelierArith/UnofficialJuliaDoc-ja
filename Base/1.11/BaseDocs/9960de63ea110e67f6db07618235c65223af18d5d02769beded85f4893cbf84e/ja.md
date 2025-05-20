```
Core.set_binding_type!(module::Module, name::Symbol, [type::Type])
```

モジュール `module` 内のバインディング `name` の宣言された型を `type` に設定します。バインディングがすでに `type` と等しくない型を持っている場合はエラーになります。`type` 引数が省略された場合、未設定であればバインディングの型を `Any` に設定しますが、エラーにはなりません。

!!! compat "Julia 1.9"
    この関数は Julia 1.9 以降が必要です。

