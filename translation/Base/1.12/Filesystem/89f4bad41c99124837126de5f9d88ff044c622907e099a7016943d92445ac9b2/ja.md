```julia
homedir() -> String
```

現在のユーザーのホームディレクトリを返します。

!!! note
    `homedir` は `libuv` の `uv_os_homedir` を介してホームディレクトリを決定します。詳細については（環境変数を介してホームディレクトリを指定する方法など）、[`uv_os_homedir` ドキュメント](http://docs.libuv.org/en/v1.x/misc.html#c.uv_os_homedir)を参照してください。


他にも [`Sys.username`](@ref) を参照してください。
