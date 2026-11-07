```julia
ENV
```

システム環境変数への辞書インターフェースを提供する、シングルトン`EnvDict`への参照です。

（Windowsでは、システム環境変数の大文字と小文字は区別されません。そのため、`ENV`は、表示、反復処理、コピーの際にすべてのキーを大文字に変換します。移植性のあるコードでは、大文字と小文字の違いによって変数を区別できることを前提にしないでください。また、小文字で指定したつもりの変数を設定すると、キーが大文字の`ENV`になる場合があることにも注意してください。）

!!! warning
    環境変数の変更はスレッドセーフではありません。


# Examples

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

関連項目：[`withenv`](@ref)、[`addenv`](@ref)。
