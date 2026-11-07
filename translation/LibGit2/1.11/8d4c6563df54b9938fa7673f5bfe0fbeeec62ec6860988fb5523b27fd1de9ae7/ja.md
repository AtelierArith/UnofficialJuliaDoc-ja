```julia
reset!(payload, [config])::CredentialPayload
```

`payload` の状態を初期値にリセットすると、credential callback 内で再び使用できるようになります。`config` が指定されている場合は、設定も更新されます。
