```
Experimental.register_error_hint(handler, exceptiontype)
```

"ヒント" 関数 `handler(io, exception)` を登録し、ユーザーがエラーを回避するための潜在的な方法を提案できるようにします。 `handler` は `exception` を調べて、ヒントに適した条件が満たされているかどうかを確認し、そうであれば `io` に出力を生成します。パッケージは `__init__` 関数内から `register_error_hint` を呼び出すべきです。

特定の例外タイプに対して、`handler` は追加の引数を受け取る必要があります：

  * `MethodError`: `handler(io, exc::MethodError, argtypes, kwargs)` を提供し、結合された引数を位置引数とキーワード引数に分割します。

ヒントを発行する際、出力は通常 `\n` で始まるべきです。

カスタム例外タイプを定義する場合、`showerror` メソッドは [`Experimental.show_error_hints`](@ref) を呼び出すことでヒントをサポートできます。

# 例

```
julia> module Hinter

       only_int(x::Int)      = 1
       any_number(x::Number) = 2

       function __init__()
           Base.Experimental.register_error_hint(MethodError) do io, exc, argtypes, kwargs
               if exc.f == only_int
                    # 色は必要ありません、これは可能であることを示すためだけです。
                    print(io, "\n呼び出そうとしましたか ")
                    printstyled(io, "`any_number`?", color=:cyan)
               end
           end
       end

       end
```

その後、`Hinter.only_int` を `Int` でないものに呼び出すと（これにより `MethodError` が発生し）、ヒントが発行されます：

```
julia> Hinter.only_int(1.0)
ERROR: MethodError: no method matching only_int(::Float64)
関数 `only_int` は存在しますが、この引数タイプの組み合わせに対して定義されたメソッドはありません。
`any_number` を呼び出そうとしましたか？
最も近い候補は：
    ...
```

!!! compat "Julia 1.5"
    カスタムエラーヒントは Julia 1.5 から利用可能です。


!!! warning
    このインターフェースは実験的であり、通知なしに変更または削除される可能性があります。変更に対して自分自身を保護するために、すべての登録を `if isdefined(Base.Experimental, :register_error_hint) ... end` ブロック内に置くことを検討してください。

