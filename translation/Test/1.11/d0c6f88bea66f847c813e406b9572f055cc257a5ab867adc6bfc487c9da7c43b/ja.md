```julia
detect_unbound_args(mod1, mod2...; recursive=false, allowed_undefineds=nothing)
```

束縛されていない型パラメーターを持つ可能性のある`Method`のベクトルを返します。すべてのサブモジュールでテストするには、`recursive=true`を使用します。

デフォルトでは、未定義のシンボルがあると警告が表示されます。警告を省略するシンボルのコレクションを`GlobalRef`として指定すると、この警告を抑制できます。たとえば、次のように設定すると、

```julia
allowed_undefineds = Set([GlobalRef(Base, :active_repl),
                          GlobalRef(Base, :active_repl_backend)])
```

`Base.active_repl`および`Base.active_repl_backend`に関する警告が抑制されます。

!!! compat "Julia 1.8"
    `allowed_undefineds`にはJulia 1.8以降が必要です。

