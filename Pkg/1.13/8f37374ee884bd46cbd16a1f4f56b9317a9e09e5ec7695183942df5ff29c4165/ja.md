```julia
normalize_path_for_toml(path::String)
```

TOML ファイル（Project.toml/Manifest.toml）に書き込むパスを正規化します。Windows では、プラットフォーム間の互換性を保つため、相対パスの区切り文字をスラッシュに変換します。絶対パスは本質的にプラットフォーム固有であるため、そのままにします。
