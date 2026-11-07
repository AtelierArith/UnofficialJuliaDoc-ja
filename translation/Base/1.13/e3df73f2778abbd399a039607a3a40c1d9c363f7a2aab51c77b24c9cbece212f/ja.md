```julia
ccall_macro_parse(expression)
```

`ccall_macro_parse` は `@ccall` の実装上の詳細です。

`:(printf("%d"::Cstring, value::Cuint)::Cvoid)` のような式を受け取り、`(function_name, return_type, arg_types, args)` のタプルを返します。

上記の入力は次のように出力されます。

```julia
(:printf, :Cvoid, [:Cstring, :Cuint], ["%d", :value])
```
