```
ord(lt, by, rev::Union{Bool, Nothing}, order::Ordering=Forward)
```

Construct an [`Ordering`](@ref) object from the same arguments used by [`sort!`](@ref). Elements are first transformed by the function `by` (which may be [`identity`](@ref)) and are then compared according to either the function `lt` or an existing ordering `order`. `lt` should be [`isless`](@ref) or a function that obeys the same rules as the `lt` parameter of [`sort!`](@ref). Finally, the resulting order is reversed if `rev=true`.

Passing an `lt` other than `isless` along with an `order` other than [`Base.Order.Forward`](@ref) or [`Base.Order.Reverse`](@ref) is not permitted, otherwise all options are independent and can be used together in all possible combinations.
