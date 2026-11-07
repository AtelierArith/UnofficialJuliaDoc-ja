```julia
_eval_using(to::Module, path::Expr)
```

モジュールへのインポートパスを評価し、そのモジュールに対して[`Core._using`](@ref)を呼び出して、エクスポートを`to`モジュールから利用できるようにします。これは`using A`をlowered formにしたものです。

```julia
using A.B            => _module_using(Main, Expr(:., :A, :B))
```

[`_using`](@ref Core._using)も参照してください。
