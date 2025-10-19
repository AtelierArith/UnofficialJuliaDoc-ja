```julia
as
```

`as` is used as a keyword to rename an identifier brought into scope by `import` or `using`, for the purpose of working around name conflicts as well as for shortening names.  (Outside of `import` or `using` statements, `as` is not a keyword and can be used as an ordinary identifier.)

`import LinearAlgebra as LA` brings the imported `LinearAlgebra` standard library into scope as `LA`.

`import LinearAlgebra: eigen as eig, cholesky as chol` brings the `eigen` and `cholesky` methods from `LinearAlgebra` into scope as `eig` and `chol` respectively.

`as` works with `using` only when individual identifiers are brought into scope. For example, `using LinearAlgebra: eigen as eig` or `using LinearAlgebra: eigen as eig, cholesky as chol` works, but `using LinearAlgebra as LA` is invalid syntax, since it is nonsensical to rename *all* exported names from `LinearAlgebra` to `LA`.
