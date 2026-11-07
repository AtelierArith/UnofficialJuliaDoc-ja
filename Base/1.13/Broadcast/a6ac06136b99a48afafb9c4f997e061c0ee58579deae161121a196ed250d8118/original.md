`Broadcast.Style{C}()` defines a [`BroadcastStyle`](@ref) signaling through the type parameter `C`. You can use this as an alternative to creating custom subtypes of `BroadcastStyle`, for example

```julia
Base.BroadcastStyle(::Type{<:MyContainer}) = Broadcast.Style{MyContainer}()
```
