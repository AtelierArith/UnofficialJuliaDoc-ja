```julia
LibGit2.split_cfg_entry(ce::LibGit2.ConfigEntry)::Tuple{String,String,String,String}
```

`ConfigEntry`を、section、subsection、name、valueの各要素に分解します。

# Examples

次の内容を含むgit設定ファイルがあるとします。

```julia
[credential "https://example.com"]
    username = me
```

`ConfigEntry`は次のようになります。

```julia-repl
julia> entry
ConfigEntry("credential.https://example.com.username", "me")

julia> LibGit2.split_cfg_entry(entry)
("credential", "https://example.com", "username", "me")
```

詳しくは[git config syntax documentation](https://git-scm.com/docs/git-config#_syntax)を参照してください。
