```
combine_styles(cs...) -> BroadcastStyle
```

Decides which `BroadcastStyle` to use for any number of value arguments. Uses [`BroadcastStyle`](@ref) to get the style for each argument, and uses [`result_style`](@ref) to combine styles.

# Examples

```jldoctest
julia> Broadcast.combine_styles([1], [1 2; 3 4])
Base.Broadcast.DefaultArrayStyle{2}()
```
