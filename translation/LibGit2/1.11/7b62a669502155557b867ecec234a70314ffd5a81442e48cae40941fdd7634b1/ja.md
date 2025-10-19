```julia
LibGit2.split_cfg_entry(ce::LibGit2.ConfigEntry) -> Tuple{String,String,String,String}
```

`ConfigEntry`を以下の部分に分割します: セクション、サブセクション、名前、値。

# 例

次のgit設定ファイルがあるとします:

```julia
[credential "https://example.com"]
    username = me
```

`ConfigEntry`は次のようになります:

```julia-repl
julia> entry
ConfigEntry("credential.https://example.com.username", "me")

julia> LibGit2.split_cfg_entry(entry)
("credential", "https://example.com", "username", "me")
```

詳細については、[git config syntax documentation](https://git-scm.com/docs/git-config#_syntax)を参照してください。
