```julia
DEFAULT_STABLE
```

The default sorting algorithm.

This algorithm is guaranteed to be stable (i.e. it will not reorder elements that compare equal). It makes an effort to be fast for most inputs.

The algorithms used by `DEFAULT_STABLE` are an implementation detail. See the docstring of `Base.Sort.DefaultStable` for the current dispatch system.
