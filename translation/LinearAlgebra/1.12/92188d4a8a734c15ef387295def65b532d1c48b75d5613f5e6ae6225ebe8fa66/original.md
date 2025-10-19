```julia
Hermitian(A::AbstractMatrix, uplo::Symbol=:U)
```

Construct a `Hermitian` view of the upper (if `uplo = :U`) or lower (if `uplo = :L`) triangle of the matrix `A`.

To compute the Hermitian part of `A`, use [`hermitianpart`](@ref).

# Examples

```jldoctest
julia> A = [1 2+2im 3-3im; 4 5 6-6im; 7 8+8im 9]
3×3 Matrix{Complex{Int64}}:
 1+0im  2+2im  3-3im
 4+0im  5+0im  6-6im
 7+0im  8+8im  9+0im

julia> Hupper = Hermitian(A)
3×3 Hermitian{Complex{Int64}, Matrix{Complex{Int64}}}:
 1+0im  2+2im  3-3im
 2-2im  5+0im  6-6im
 3+3im  6+6im  9+0im

julia> Hlower = Hermitian(A, :L)
3×3 Hermitian{Complex{Int64}, Matrix{Complex{Int64}}}:
 1+0im  4+0im  7+0im
 4+0im  5+0im  8-8im
 7+0im  8+8im  9+0im

julia> hermitianpart(A)
3×3 Hermitian{ComplexF64, Matrix{ComplexF64}}:
 1.0+0.0im  3.0+1.0im  5.0-1.5im
 3.0-1.0im  5.0+0.0im  7.0-7.0im
 5.0+1.5im  7.0+7.0im  9.0+0.0im
```

Note that `Hupper` will not be equal to `Hlower` unless `A` is itself Hermitian (e.g. if `A == adjoint(A)`).

All non-real parts of the diagonal will be ignored.

```julia
Hermitian(fill(complex(1,1), 1, 1)) == fill(1, 1, 1)
```
