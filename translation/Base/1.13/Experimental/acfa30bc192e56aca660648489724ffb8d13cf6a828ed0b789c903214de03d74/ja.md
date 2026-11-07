```julia
Experimental.register_error_hint(handler, exceptiontype)
```

エラーを回避する方法をユーザーに提案する「ヒント」関数 `handler(io, exception)` を登録します。`handler` は `exception` を調べ、ヒントを表示する条件が満たされているかを確認し、満たされていれば `io` に出力します。パッケージでは、`__init__` 関数内から `register_error_hint` を呼び出してください。

特定の例外型では、`handler` が追加の引数を受け取る必要があります。

  * `MethodError`: 結合された引数を位置引数とキーワード引数に分割する `handler(io, exc::MethodError, argtypes, kwargs)` を指定します。

ヒントを表示する際は、通常、出力を `\n` で始めます。

独自の例外型を定義する場合、`showerror` メソッドから [`Experimental.show_error_hints`](@ref) を呼び出すことで、ヒントを表示できます。

# Examples

```julia
julia> module Hinter

       only_int(x::Int)      = 1
       any_number(x::Number) = 2

       function __init__()
           Base.Experimental.register_error_hint(MethodError) do io, exc, argtypes, kwargs
               if exc.f == only_int
                    # Color is not necessary, this is just to show it's possible.
                    print(io, "\nDid you mean to call ")
                    printstyled(io, "`any_number`?", color=:cyan)
               end
           end
       end

       end
```

この場合、`Hinter.only_int` に `Int` ではないものを渡すと（その結果、`MethodError` が発生します）、次のヒントが表示されます。

```julia
julia> Hinter.only_int(1.0)
ERROR: MethodError: no method matching only_int(::Float64)
The function `only_int` exists, but no method is defined for this combination of argument types.
Did you mean to call `any_number`?
Closest candidates are:
    ...
```

!!! compat "Julia 1.5"
    独自のエラーヒントは Julia 1.5 以降で利用できます。


!!! warning
    このインターフェースは実験的なものであり、予告なく変更または削除される可能性があります。変更の影響を受けないようにするには、登録処理を `if isdefined(Base.Experimental, :register_error_hint) ... end` ブロック内に記述することを検討してください。

