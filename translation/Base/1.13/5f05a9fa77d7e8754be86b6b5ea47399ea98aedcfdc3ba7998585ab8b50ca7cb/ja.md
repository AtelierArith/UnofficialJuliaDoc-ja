```julia
@macroexpand [mod,] ex
```

すべてのマクロを展開して、マクロを含まない同等の式を返します。引数を2つ指定した場合、1つ目の引数は評価対象のモジュールです。

`@macroexpand` と [`macroexpand`](@ref) には、次の違いがあります。

  * [`macroexpand`](@ref) はキーワード引数 `recursive` を受け取りますが、`@macroexpand` は常に再帰的です。再帰しないマクロ版については、[`@macroexpand1`](@ref) を参照してください。
  * [`macroexpand`](@ref) には明示的な `module` 引数がありますが、`@macroexpand` は常に、呼び出されたモジュールに基づいて展開されます。

次の例を見ると、違いがよくわかります。

```jldoctest
julia> module M
           macro m()
               1
           end
           function f()
               (@macroexpand(@m),
                macroexpand(M, :(@m)),
                macroexpand(parentmodule(M), :(@m))
               )
           end
       end
M

julia> macro m()
           2
       end
@m (macro with 1 method)

julia> M.f()
(1, 1, 2)
```

`@macroexpand` では、式はコード中の `@macroexpand` の位置（この例ではモジュール `M`）で展開されます。一方、`macroexpand` では、最初の引数で指定したモジュール内で式が展開されます。

!!! compat "Julia 1.11"
    2引数形式を使用するには、Julia 1.11以降が必要です。

