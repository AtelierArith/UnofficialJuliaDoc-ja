```
detect_unbound_args(mod1, mod2...; recursive=false, allowed_undefineds=nothing)
```

未束縛の型パラメータを持つ可能性のある `Method` のベクターを返します。すべてのサブモジュールでテストするには `recursive=true` を使用します。

デフォルトでは、未定義のシンボルは警告を引き起こします。この警告は、警告をスキップできる `GlobalRef` のコレクションを提供することで抑制できます。たとえば、次のように設定することで

```
allowed_undefineds = Set([GlobalRef(Base, :active_repl),
                          GlobalRef(Base, :active_repl_backend)])
```

`Base.active_repl` と `Base.active_repl_backend` に関する警告を抑制できます。

!!! compat "Julia 1.8"
    `allowed_undefineds` は少なくとも Julia 1.8 が必要です。

