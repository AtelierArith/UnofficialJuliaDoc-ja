```julia
homedir()::String
```

現在のユーザーのホームディレクトリを返します。

!!! note
    `homedir`は、`libuv`の`uv_os_homedir`を使ってホームディレクトリを決定します。詳細（環境変数を使ったホームディレクトリの指定方法など）については、[`uv_os_homedir` documentation](http://docs.libuv.org/en/v1.x/misc.html#c.uv_os_homedir)を参照してください。


[`Sys.username`](@ref)も参照してください。
