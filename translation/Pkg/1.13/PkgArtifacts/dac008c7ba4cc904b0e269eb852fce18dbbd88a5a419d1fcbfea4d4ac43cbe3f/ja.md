```julia
archive_artifact(hash::SHA1, tarball_path::String; honor_overrides::Bool=false)
```

アーティファクトをアーカイブし、`tarball_path` に保存された tarball を作成します。作成した tarball の SHA256 を16進文字列で返します。アーティファクトが存在しない場合はエラーをスローします。アーティファクトが上書きされる場合、`honor_overrides` が設定されていないとエラーをスローします。
