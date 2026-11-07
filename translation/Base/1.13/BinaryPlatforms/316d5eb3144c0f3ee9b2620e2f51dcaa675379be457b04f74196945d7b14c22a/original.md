```julia
platforms_match(a::AbstractPlatform, b::AbstractPlatform)
```

Return `true` if `a` and `b` are matching platforms, where matching is determined by comparing all keys contained within the platform objects, and if both objects contain entries for that key, they must match.  Comparison, by default, is performed using the `==` operator, however this can be overridden on a key-by-key basis by adding "comparison strategies" through `set_compare_strategy!(platform, key, func)`.

Note that as the comparison strategy is set on the `Platform` object, and not globally, a custom comparison strategy is first looked for within the `a` object, then if none is found, it is looked for in the `b` object.  Finally, if none is found in either, the default of `==(ak, bk)` is used.  We throw an error if custom comparison strategies are used on both `a` and `b` and they are not the same custom comparison.

The reserved tags `os_version` and `libstdcxx_version` use this mechanism to provide bounded version constraints, where an artifact can specify that it was built using APIs only available in macOS `v"10.11"` and later, or an artifact can state that it requires a libstdc++ that is at least `v"3.4.22"`, etc...
