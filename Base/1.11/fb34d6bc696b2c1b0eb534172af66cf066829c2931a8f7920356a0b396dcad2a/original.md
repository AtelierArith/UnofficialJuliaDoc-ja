```
eachindex(A...)
eachindex(::IndexStyle, A::AbstractArray...)
```

Create an iterable object for visiting each index of an `AbstractArray` `A` in an efficient manner. For array types that have opted into fast linear indexing (like `Array`), this is simply the range `1:length(A)` if they use 1-based indexing. For array types that have not opted into fast linear indexing, a specialized Cartesian range is typically returned to efficiently index into the array with indices specified for every dimension.

In general `eachindex` accepts arbitrary iterables, including strings and dictionaries, and returns an iterator object supporting arbitrary index types (e.g. unevenly spaced or non-integer indices).

If `A` is `AbstractArray` it is possible to explicitly specify the style of the indices that should be returned by `eachindex` by passing a value having `IndexStyle` type as its first argument (typically `IndexLinear()` if linear indices are required or `IndexCartesian()` if Cartesian range is wanted).

If you supply more than one `AbstractArray` argument, `eachindex` will create an iterable object that is fast for all arguments (typically a [`UnitRange`](@ref) if all inputs have fast linear indexing, a [`CartesianIndices`](@ref) otherwise). If the arrays have different sizes and/or dimensionalities, a `DimensionMismatch` exception will be thrown.

See also [`pairs`](@ref)`(A)` to iterate over indices and values together, and [`axes`](@ref)`(A, 2)` for valid indices along one dimension.

# Examples

```jldoctest
julia> A = [10 20; 30 40];

julia> for i in eachindex(A) # linear indexing
           println("A[", i, "] == ", A[i])
       end
A[1] == 10
A[2] == 30
A[3] == 20
A[4] == 40

julia> for i in eachindex(view(A, 1:2, 1:1)) # Cartesian indexing
           println(i)
       end
CartesianIndex(1, 1)
CartesianIndex(2, 1)
```
