```
ENV
```

シングルトン `EnvDict` への参照で、システム環境変数への辞書インターフェースを提供します。

（Windowsでは、システム環境変数は大文字と小文字を区別しないため、`ENV` はすべてのキーを表示、反復、コピーのために大文字に変換します。ポータブルなコードは、変数を大文字と小文字で区別できる能力に依存すべきではなく、表面的に小文字の変数を設定すると大文字の `ENV` キーになる可能性があることに注意する必要があります。）

!!! warning
    環境を変更することはスレッドセーフではありません。


# 例

```julia-repl
julia> ENV
Base.EnvDict with "50" entries:
  "SECURITYSESSIONID"            => "123"
  "USER"                         => "username"
  "MallocNanoZone"               => "0"
  ⋮                              => ⋮

julia> ENV["JULIA_EDITOR"] = "vim"
"vim"

julia> ENV["JULIA_EDITOR"]
"vim"
```

関連項目: [`withenv`](@ref), [`addenv`](@ref).
