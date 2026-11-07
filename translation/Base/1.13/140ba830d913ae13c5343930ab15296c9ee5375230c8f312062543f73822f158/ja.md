```julia
_eval_import(imported::Bool, to::Module, from::Union{Expr, Nothing}, paths::Expr...)
```

インポートパスを評価し、インポートする各名前について `Core._import` を呼び出します。`imported` インポートは `import` で作成され、`using A: x` はこれを false に設定します。`from` は、インポートパスのうち `:` より前の部分です。これは `import`、`import ...:`、`using ...:` を低水準化した形式です。

```julia
import A             => _eval_import(true,  Main, nothing,          Expr(:., :A))
import A.b           => _eval_import(true,  Main, nothing,          Expr(:., :A, :b))
import A.b as c      => _eval_import(true,  Main, nothing,          Expr(:as, Expr(:., :A, :b), :c))
import A.B: C.d, e   => _eval_import(true,  Main, Expr(:., :A, :B), Expr(:., :C, :d), Expr(:., :e))
import A.B: C.d as e => _eval_import(true,  Main, Expr(:., :A, :B), Expr(:as, Expr(:., :C, :d), :e))
using  A.B: C.d, e   => _eval_import(false, Main, Expr(:., :A, :B), Expr(:., :C, :d), Expr(:., :e))

See also [`_import`](@ref Core._import).
```
