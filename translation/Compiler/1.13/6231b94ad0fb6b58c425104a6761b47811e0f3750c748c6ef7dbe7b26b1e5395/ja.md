```julia
info::InvokeCallInfo
```

解決済みの `Core.invoke` 呼び出しを表し、処理済みのメソッドの `info.match::MethodMatch` を保持します。定数情報を保持する `info.result::InferenceResult` を任意で保持します。
