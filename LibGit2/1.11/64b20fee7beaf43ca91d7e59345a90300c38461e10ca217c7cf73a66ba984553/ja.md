```
reject(payload::CredentialPayload; shred::Bool=true) -> Nothing
```

将来の認証で再利用されることを防ぐために、`payload` 認証情報を破棄します。認証が失敗したときのみ呼び出すべきです。

`shred` キーワードは、ペイロード認証情報フィールド内の機密情報を破壊するかどうかを制御します。テスト中のみ `false` に設定するべきです。
