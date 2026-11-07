`Broadcast.AbstractArrayStyle{N} <: BroadcastStyle` is the abstract supertype for any style associated with an `AbstractArray` type. The `N` parameter is the dimensionality, which can be handy for AbstractArray types that only support specific dimensionalities:

```julia
struct SparseMatrixStyle <: Broadcast.AbstractArrayStyle{2} end
Base.BroadcastStyle(::Type{<:SparseMatrixCSC}) = SparseMatrixStyle()
```

For `AbstractArray` types that support arbitrary dimensionality, `N` can be set to `Any`:

```julia
struct MyArrayStyle <: Broadcast.AbstractArrayStyle{Any} end
Base.BroadcastStyle(::Type{<:MyArray}) = MyArrayStyle()
```

In cases where you want to be able to mix multiple `AbstractArrayStyle`s and keep track of dimensionality, your style needs to support a [`Val`](@ref) constructor:

```julia
struct MyArrayStyleDim{N} <: Broadcast.AbstractArrayStyle{N} end
(::Type{<:MyArrayStyleDim})(::Val{N}) where N = MyArrayStyleDim{N}()
```

Note that if two or more `AbstractArrayStyle` subtypes conflict, broadcasting machinery will fall back to producing `Array`s. If this is undesirable, you may need to define binary [`BroadcastStyle`](@ref) rules to control the output type.

See also [`Broadcast.DefaultArrayStyle`](@ref).
