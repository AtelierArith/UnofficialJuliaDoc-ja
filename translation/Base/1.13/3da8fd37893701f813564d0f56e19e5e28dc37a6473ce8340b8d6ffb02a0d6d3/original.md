```julia
invmod(n::Integer, T) where {T <: Base.BitInteger}
invmod(n::T) where {T <: Base.BitInteger}
```

Compute the modular inverse of `n` in the integer ring of type `T`, i.e. modulo `2^N` where `N = 8*sizeof(T)` (e.g. `N = 32` for `Int32`). In other words, these methods satisfy the following identities:

```julia
n * invmod(n) == 1
(n * invmod(n, T)) % T == 1
(n % T) * invmod(n, T) == 1
```

Note that `*` here is modular multiplication in the integer ring, `T`.  This will throw an error if `n` is even, because then it is not relatively prime with `2^N` and thus has no such inverse.

Specifying the modulus implied by an integer type as an explicit value is often inconvenient since the modulus is by definition too big to be represented by the type.

The modular inverse is computed much more efficiently than the general case using the algorithm described in https://arxiv.org/pdf/2204.04342.pdf.

!!! compat "Julia 1.11"
    The `invmod(n)` and `invmod(n, T)` methods require Julia 1.11 or later.

