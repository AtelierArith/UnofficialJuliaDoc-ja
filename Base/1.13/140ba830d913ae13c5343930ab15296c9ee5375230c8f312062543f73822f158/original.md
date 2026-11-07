```julia
_eval_import(imported::Bool, to::Module, from::Union{Expr, Nothing}, paths::Expr...)
```

Evaluate the import paths, calling `Core._import` for each name to be imported. `imported` imports are created with `import`, `using A: x` sets this to false. The `from` is the part of the import path before the `:`.  This is the lowered form of `import`, `import ...:`, and `using ...:`.

```julia
import A             => _eval_import(true,  Main, nothing,          Expr(:., :A))
import A.b           => _eval_import(true,  Main, nothing,          Expr(:., :A, :b))
import A.b as c      => _eval_import(true,  Main, nothing,          Expr(:as, Expr(:., :A, :b), :c))
import A.B: C.d, e   => _eval_import(true,  Main, Expr(:., :A, :B), Expr(:., :C, :d), Expr(:., :e))
import A.B: C.d as e => _eval_import(true,  Main, Expr(:., :A, :B), Expr(:as, Expr(:., :C, :d), :e))
using  A.B: C.d, e   => _eval_import(false, Main, Expr(:., :A, :B), Expr(:., :C, :d), Expr(:., :e))

See also [`_import`](@ref Core._import).
```
