```julia
verify_artifact(hash::SHA1; honor_overrides::Bool=false)
```

指定されたアーティファクト（SHA1 の Git ツリーハッシュで識別）がディスク上にインストールされており、整合性が保たれていることを検証します。指定されたアーティファクトがオーバーライドされている場合、`honor_overrides` が `true` に設定されていない限り、検証をスキップします。
