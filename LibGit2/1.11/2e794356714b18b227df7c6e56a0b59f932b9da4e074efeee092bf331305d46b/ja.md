```julia
default_username(config, git_cred)::Union{String, Nothing}
```

指定された`git_cred`に対して有効な、`config`が提供するデフォルトのユーザー名があれば、それを返します。
