```julia
info::OpaqueClosureCallInfo
```

不透明クロージャの解決済み呼び出しを表し、処理済みのメソッドの`info.match::MethodMatch`を保持します。必要に応じて、定数情報を保持する`info.result::InferenceResult`も保持します。
