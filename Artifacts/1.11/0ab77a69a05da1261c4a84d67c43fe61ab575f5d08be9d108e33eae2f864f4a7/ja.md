```julia
query_override(hash::SHA1; overrides::Dict = load_overrides())
```

読み込まれた`<DEPOT>/artifacts/Overrides.toml`設定を検索し、特定のパスまたは別のコンテンツハッシュにリダイレクトすべきアーティファクトを探します。
