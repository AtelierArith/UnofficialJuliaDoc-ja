```julia
quantile(itr, p; sorted=false, alpha::Real=1.0, beta::Real=alpha)
```

Compute the quantile(s) of a collection `itr` at a specified probability or vector or tuple of probabilities `p` on the interval [0,1]. The keyword argument `sorted` indicates whether `itr` can be assumed to be sorted.

Samples quantile are defined by `Q(p) = (1-γ)*x[j] + γ*x[j+1]`, where `x[j]` is the j-th order statistic of `itr`, `j = floor(n*p + m)`, `m = alpha + p*(1 - alpha - beta)` and `γ = n*p + m - j`.

By default (`alpha = beta = 1`), quantiles are computed via linear interpolation between the points `((k-1)/(n-1), x[k])`, for `k = 1:n` where `n = length(itr)`. This corresponds to Definition 7 of Hyndman and Fan (1996), and is the same as the R and NumPy default.

The keyword arguments `alpha` and `beta` correspond to the same parameters in Hyndman and Fan, setting them to different values allows to calculate quantiles with any of the methods 4-9 defined in this paper:

  * Def. 4: `alpha=0`, `beta=1`
  * Def. 5: `alpha=0.5`, `beta=0.5` (MATLAB default)
  * Def. 6: `alpha=0`, `beta=0` (Excel `PERCENTILE.EXC`, Python default, Stata `altdef`)
  * Def. 7: `alpha=1`, `beta=1` (Julia, R and NumPy default, Excel `PERCENTILE` and `PERCENTILE.INC`, Python `'inclusive'`)
  * Def. 8: `alpha=1/3`, `beta=1/3`
  * Def. 9: `alpha=3/8`, `beta=3/8`

!!! note
    An `ArgumentError` is thrown if `v` contains `NaN` or [`missing`](@ref) values. Use the [`skipmissing`](@ref) function to omit `missing` entries and compute the quantiles of non-missing values.


# References

  * Hyndman, R.J and Fan, Y. (1996) "Sample Quantiles in Statistical Packages", *The American Statistician*, Vol. 50, No. 4, pp. 361-365
  * [Quantile on Wikipedia](https://en.wikipedia.org/wiki/Quantile) details the different quantile definitions

# Examples

```jldoctest
julia> using Statistics

julia> quantile(0:20, 0.5)
10.0

julia> quantile(0:20, [0.1, 0.5, 0.9])
3-element Vector{Float64}:
  2.0
 10.0
 18.0

julia> quantile(skipmissing([1, 10, missing]), 0.5)
5.5
```
