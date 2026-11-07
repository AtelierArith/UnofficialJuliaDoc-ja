```julia
archive_artifact(hash::SHA1, tarball_path::String; honor_overrides::Bool=false)
```

アーティファクトをアーカイブし、`tarball_path` に保存された tarball を作成します。作成された tarball の SHA256 を16進文字列として返します。アーティファクトが存在しない場合はエラーをスローします。アーティファクトが上書きされる場合、`honor_overrides` が設定されていないとエラーをスローします。
