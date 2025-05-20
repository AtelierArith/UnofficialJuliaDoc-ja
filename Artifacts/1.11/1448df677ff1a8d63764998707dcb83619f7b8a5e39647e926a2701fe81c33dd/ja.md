```
query_override(hash::SHA1; overrides::Dict = load_overrides())
```

読み込まれた `<DEPOT>/artifacts/Overrides.toml` 設定をクエリして、特定のパスまたは別のコンテンツハッシュにリダイレクトされるべきアーティファクトを取得します。
