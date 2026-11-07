```julia
reflectorApply!(x, τ, A)
```

Multiplies `A` in-place by a Householder reflection on the left. It is equivalent to `A .= (I - [1; x[2:end]] * conj(τ) * [1; x[2:end]]') * A`.
