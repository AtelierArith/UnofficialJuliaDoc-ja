```julia
macroexpand(m::Module, x; recursive=true, legacyscope=true)
```

式 `x` を受け取り、すべてのマクロを展開して削除した、モジュール `m` で実行可能な等価な式を返します。`recursive` キーワードは、ネストされたマクロをさらに深い階層まで展開するかどうかを制御します。`legacyscope` キーワードは、従来のマクロスコープ展開を行うかどうかを制御します。以下の例で説明します。

```jldoctest; filter = r"#= .*:6 =#"
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
:(#= REPL[1]:6 =# @m1)
```

!!! compat "Julia 1.13"
    `legacyscope` キーワード引数を使用するには、Julia 1.13 以降が必要です。

