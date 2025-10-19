```julia
reset!(payload, [config]) -> CredentialPayload
```

`payload`の状態を初期値にリセットして、資格情報コールバック内で再度使用できるようにします。`config`が提供されている場合、設定も更新されます。
