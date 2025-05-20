```
varinfo(m::Module=Main, pattern::Regex=r""; all=false, imported=false, recursive=false, sortby::Symbol=:name, minsize::Int=0)
```

Return a markdown table giving information about public global variables in a module, optionally restricted to those matching `pattern`.

The memory consumption estimate is an approximate lower bound on the size of the internal structure of the object.

  * `all` : also list non-public objects defined in the module, deprecated objects, and compiler-generated objects.
  * `imported` : also list objects explicitly imported from other modules.
  * `recursive` : recursively include objects in sub-modules, observing the same settings in each.
  * `sortby` : the column to sort results by. Options are `:name` (default), `:size`, and `:summary`.
  * `minsize` : only includes objects with size at least `minsize` bytes. Defaults to `0`.

The output of `varinfo` is intended for display purposes only.  See also [`names`](@ref) to get an array of symbols defined in a module, which is suitable for more general manipulations.
