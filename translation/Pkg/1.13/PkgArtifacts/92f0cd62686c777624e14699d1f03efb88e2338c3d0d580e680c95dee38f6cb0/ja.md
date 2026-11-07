```julia
unbind_artifact!(artifacts_toml::String, name::String; platform = nothing)
```

ファイル内の`(Julia)Artifacts.toml`から、指定された`name`のバインディングを解除します。該当するバインディングがファイル内に存在しない場合は、何もせずに失敗します。
