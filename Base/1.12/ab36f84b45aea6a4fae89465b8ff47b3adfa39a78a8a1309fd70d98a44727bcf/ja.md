```julia
macroexpand(m::Module, x; recursive=true)
```

式 `x` を取り、モジュール `m` で実行するためにすべてのマクロが削除された（展開された）同等の式を返します。`recursive` キーワードは、ネストされたマクロのより深いレベルも展開されるかどうかを制御します。これは以下の例で示されています：

```julia-repl
julia> module M
           macro m1()
               42
           end
           macro m2()
               :(@m1())
           end
       end
M

julia> macroexpand(M, :(@m2()), recursive=true)
42

julia> macroexpand(M, :(@m2()), recursive=false)
:(#= REPL[16]:6 =# M.@m1)
```
