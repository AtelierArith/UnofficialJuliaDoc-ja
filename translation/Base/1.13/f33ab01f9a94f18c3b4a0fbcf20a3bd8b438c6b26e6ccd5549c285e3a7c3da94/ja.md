```julia
ENV
```

システム環境変数への辞書インターフェースを提供する、シングルトンの`EnvDict`への参照です。

（Windowsでは、システム環境変数の大文字と小文字は区別されません。そのため、`ENV`は、表示、反復処理、コピーの際にすべてのキーを大文字に変換します。移植性のあるコードでは、大文字と小文字の違いによって変数を区別できることを前提にしないでください。また、小文字で設定したつもりの変数が、大文字の`ENV`キーになる場合があることにも注意してください。）

!!! warning
    環境の変更はスレッドセーフではありません。


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
