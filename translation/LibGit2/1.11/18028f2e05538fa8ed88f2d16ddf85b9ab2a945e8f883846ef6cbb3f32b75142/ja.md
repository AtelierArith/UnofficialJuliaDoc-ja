```
approve(payload::CredentialPayload; shred::Bool=true) -> Nothing
```

将 `payload` 認証情報を保存し、将来の認証で再利用します。認証が成功したときのみ呼び出すべきです。

`shred` キーワードは、ペイロード認証情報フィールド内の機密情報を破棄するかどうかを制御します。テスト中は `false` に設定するべきです。
