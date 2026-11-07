```julia
@aliasscope expr
```

Allows the compiler to assume that all `Const`s are not being modified through stores within this scope, even if the compiler can't prove this to be the case.

!!! warning
    Experimental API. Subject to change without deprecation.

