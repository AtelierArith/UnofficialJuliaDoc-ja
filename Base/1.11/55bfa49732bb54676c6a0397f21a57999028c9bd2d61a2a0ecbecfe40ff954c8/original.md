```
splice!(a::Vector, indices, [replacement]) -> items
```

Remove items at specified indices, and return a collection containing the removed items. Subsequent items are shifted left to fill the resulting gaps. If specified, replacement values from an ordered collection will be spliced in place of the removed items; in this case, `indices` must be a `AbstractUnitRange`.

To insert `replacement` before an index `n` without removing any items, use `splice!(collection, n:n-1, replacement)`.

!!! warning
    Behavior can be unexpected when any mutated argument shares memory with any other argument.


!!! compat "Julia 1.5"
    Prior to Julia 1.5, `indices` must always be a `UnitRange`.


!!! compat "Julia 1.8"
    Prior to Julia 1.8, `indices` must be a `UnitRange` if splicing in replacement values.


# Examples

```jldoctest
julia> A = [-1, -2, -3, 5, 4, 3, -1]; splice!(A, 4:3, 2)
Int64[]

julia> A
8-element Vector{Int64}:
 -1
 -2
 -3
  2
  5
  4
  3
 -1
```
