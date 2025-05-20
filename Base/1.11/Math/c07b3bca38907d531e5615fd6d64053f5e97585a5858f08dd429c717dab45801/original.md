```
atan(y)
atan(y, x)
```

Compute the inverse tangent of `y` or `y/x`, respectively.

For one real argument, this is the angle in radians between the positive *x*-axis and the point (1, *y*), returning a value in the interval $[-\pi/2, \pi/2]$.

For two arguments, this is the angle in radians between the positive *x*-axis and the point (*x*, *y*), returning a value in the interval $[-\pi, \pi]$. This corresponds to a standard [`atan2`](https://en.wikipedia.org/wiki/Atan2) function. Note that by convention `atan(0.0,x)` is defined as $\pi$ and `atan(-0.0,x)` is defined as $-\pi$ when `x < 0`.

See also [`atand`](@ref) for degrees.

# Examples

```jldoctest
julia> rad2deg(atan(-1/√3))
-30.000000000000004

julia> rad2deg(atan(-1, √3))
-30.000000000000004

julia> rad2deg(atan(1, -√3))
150.0
```
