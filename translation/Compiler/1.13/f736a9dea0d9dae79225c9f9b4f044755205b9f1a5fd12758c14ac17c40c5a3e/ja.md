```julia
info::ReturnTypeCallInfo <: CallInfo
```

`Core.Compiler.return_type` の解決済みの呼び出しを表します。`info.call` は、`Core.Compiler.return_type` 呼び出しが解析するはずだった呼び出しに対応する情報を囲みます。
