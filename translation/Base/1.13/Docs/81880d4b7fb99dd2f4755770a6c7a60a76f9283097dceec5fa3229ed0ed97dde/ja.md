```julia
@__doc__(ex)
```

マクロが返す式のうち、ドキュメント化する式を示すために使う低レベルのマクロです。複数の式にマークを付けた場合、同じ docstring が各式に適用されます。

```julia
macro example(f)
    quote
        $(f)() = 0
        @__doc__ $(f)(x) = 1
        $(f)(x, y) = 2
    end |> esc
end
```

これを使うマクロがドキュメント化されていない場合、`@__doc__` は何の効果もありません。

!!! compat "Julia 1.12"
    この節では、非常に微妙な特殊ケースについて説明します。このケースが関係するのは、マクロ自身が別のマクロを定義し、同じ展開内でそのマクロを使おうとする場合に限られます。このようなマクロは Julia 1.12 より前には記述できず、現在でも非常にまれです。このようなマクロを記述していない場合は、この注記を無視してかまいません。

    Julia 1.12 より前のバージョンでは、マクロ展開は `Expr(:toplevel)` ブロックの内部まで再帰的に展開していました。この動作は、マクロが別のマクロを再帰的に定義し、返す式の中でそれを使えるようにするため、Julia 1.12 で変更されました。ただし、`@__doc__` の既存の使用との後方互換性を保つため、ドキュメントシステムは `@__doc__` マーカーを探す際、引き続き `Expr(:toplevel)` ブロックの内部まで展開します。その結果、マクロを定義するマクロに docstring を付けると、観察可能な動作の違いが生じます。

    ```julia
    julia> macro macroception()
        Expr(:toplevel, :(macro foo() 1 end), :(@foo))
    end

    julia> @macroception
    1

    julia> "Docstring" @macroception
    ERROR: LoadError: UndefVarError: `@foo` not defined in `Main`
    ```

    サポートされている回避策は、定義側のマクロ内で `@__doc__` マクロを手動で展開することです。ドキュメントシステムはこれを認識し、再帰的な展開を抑制します。

    ```julia
    julia> macro macroception()
        Expr(:toplevel,
            macroexpand(__module__, :(@__doc__ macro foo() 1 end); recursive=false),
            :(@foo))
    end

    julia> @macroception
    1

    julia> "Docstring" @macroception
    1
    ```

