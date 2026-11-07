```julia
approve(payload::CredentialPayload; shred::Bool=true) -> nothing
```

今後の認証で再利用できるよう、`payload` 認証情報を保存します。認証に成功した場合にのみ呼び出してください。

`shred` キーワードは、ペイロードの認証情報フィールドに含まれる機密情報を破棄するかどうかを制御します。テスト時にのみ `false` に設定してください。
