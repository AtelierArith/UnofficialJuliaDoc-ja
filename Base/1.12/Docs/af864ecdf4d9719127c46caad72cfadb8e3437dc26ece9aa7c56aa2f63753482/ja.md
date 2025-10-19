```julia
@__doc__(ex)
```

マクロによって返される式を文書化するためにマークするために使用される低レベルのマクロです。複数の式がマークされている場合、同じドキュメント文字列が各式に適用されます。

```julia
macro example(f)
    quote
        $(f)() = 0
        @__doc__ $(f)(x) = 1
        $(f)(x, y) = 2
    end |> esc
end
```

`@__doc__` は、それを使用するマクロが文書化されていない場合には効果がありません。

!!! compat "Julia 1.12"
    このセクションは、他のマクロを定義し、それを同じ展開内で使用しようとするマクロにのみ関連する非常に微妙なコーナーケースを文書化しています。このようなマクロは、Julia 1.12以前には書くことが不可能であり、現在でも非常に稀です。そのようなマクロを書いていない場合は、このノートを無視しても構いません。

    Julia 1.12以前のバージョンでは、マクロ展開は `Expr(:toplevel)` ブロックを再帰的に展開していました。この動作は、Julia 1.12で変更され、マクロが他のマクロを再帰的に定義し、同じ返された式内でそれらを使用できるようになりました。ただし、既存の `@__doc__` の使用との後方互換性を保つために、ドキュメントシステムは `@__doc__` マーカーを探す際に依然として `Expr(:toplevel)` ブロックを展開します。その結果、マクロを定義するマクロは、ドキュメント文字列で注釈された場合に観察可能な動作の違いを持ちます：

    ```julia
    julia> macro macroception()
        Expr(:toplevel, :(macro foo() 1 end), :(@foo))
    end

    julia> @macroception
    1

    julia> "Docstring" @macroception
    ERROR: LoadError: UndefVarError: `@foo` not defined in `Main`
    ```

    サポートされている回避策は、定義マクロ内で手動で `@__doc__` マクロを展開することであり、ドキュメントシステムはそれを認識し、再帰的な展開を抑制します：

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

