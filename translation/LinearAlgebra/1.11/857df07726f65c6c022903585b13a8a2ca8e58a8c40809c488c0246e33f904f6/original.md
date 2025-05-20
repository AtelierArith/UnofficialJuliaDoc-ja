```
reflectorApply!(x, τ, A)
```

Multiplies `A` in-place by a Householder reflection on the left. It is equivalent to `A .= (I - conj(τ)*[1; x[2:end]]*[1; x[2:end]]')*A`.
