```julia
Experimental.@max_methods n::Int function fname end
```

ジェネリック関数 `fname` の推論を実行する際に、マッチする可能性のあるメソッドを検討する最大数を設定します。モジュール単位またはグローバルな推論設定の max_methods を上書きします。この設定は、ジェネリック関数全体（より正確には MethodTable）に適用されます。
