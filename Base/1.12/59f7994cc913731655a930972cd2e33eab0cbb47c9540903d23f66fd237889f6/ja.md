```julia
@macroexpand [mod,] ex
```

すべてのマクロが削除された（展開された）同等の式を返します。2つの引数が提供される場合、最初の引数は評価するモジュールです。

`@macroexpand`と[`macroexpand`](@ref)の間には違いがあります。

  * [`macroexpand`](@ref)がキーワード引数`recursive`を取るのに対し、`@macroexpand`は常に再帰的です。非再帰的なマクロバージョンについては、[`@macroexpand1`](@ref)を参照してください。
  * [`macroexpand`](@ref)には明示的な`module`引数がありますが、`@macroexpand`は常に呼び出されたモジュールに関して展開されます。

これは次の例で最もよく見られます：

```julia-repl
julia> module M
           macro m()
               1
           end
           function f()
               (@macroexpand(@m),
                macroexpand(M, :(@m)),
                macroexpand(Main, :(@m))
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

`@macroexpand`を使用すると、式はコード内の`@macroexpand`が出現する場所（例ではモジュール`M`）で展開されます。`macroexpand`を使用すると、式は最初の引数として与えられたモジュールで展開されます。

!!! compat "Julia 1.11"
    2引数形式は少なくともJulia 1.11が必要です。

