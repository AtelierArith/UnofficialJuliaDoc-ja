```julia
@stable_muladdmul
```

Replaces a function call, that has a `MulAddMul(alpha, beta)` constructor as an argument, with a branch over possible values of `isone(alpha)` and `iszero(beta)` and constructs `MulAddMul{isone(alpha), iszero(beta)}` explicitly in each branch. For example, 'f(x, y, MulAddMul(alpha, beta))` is transformed into

```julia
if isone(alpha)
    if iszero(beta)
        f(x, y, MulAddMul{true, true, typeof(alpha), typeof(beta)}(alpha, beta))
    else
        f(x, y, MulAddMul{true, false, typeof(alpha), typeof(beta)}(alpha, beta))
    end
else
    if iszero(beta)
        f(x, y, MulAddMul{false, true, typeof(alpha), typeof(beta)}(alpha, beta))
    else
        f(x, y, MulAddMul{false, false, typeof(alpha), typeof(beta)}(alpha, beta))
    end
end
```

This avoids the type instability of the `MulAddMul(alpha, beta)` constructor, which causes runtime dispatch in case alpha and zero are not constants.
