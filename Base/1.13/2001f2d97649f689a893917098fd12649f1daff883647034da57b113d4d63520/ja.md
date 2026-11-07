```julia
Base.get_bool_env(name::String, default::Bool; throw=false)::Union{Bool,Nothing}
Base.get_bool_env(f_default::Callable, name::String; throw=false)::Union{Bool,Nothing}
```

環境変数 `name` の値が真偽値を表す文字列かどうかを判定し、該当する場合は `nothing` を返します。どちらにも該当しない場合は、`throw=true` なら例外をスローします。環境変数が設定されていない場合、または値が "" の場合は、`default` を返すか、`f_default()` を実行した結果を返します。

認識される値は次のとおりです（先頭のみ大文字の形式とすべて大文字の形式も認識されます）。     真: "t", "true", "y", "yes", "1"     偽: "f", "false", "n", "no", "0"
