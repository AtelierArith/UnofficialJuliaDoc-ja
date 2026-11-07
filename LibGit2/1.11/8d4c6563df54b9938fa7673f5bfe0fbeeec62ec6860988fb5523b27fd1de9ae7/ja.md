```julia
reset!(payload, [config])::CredentialPayload
```

`payload` の状態を初期値にリセットし、認証情報コールバック内で再び使用できるようにします。`config` が指定されている場合は、設定も更新されます。
