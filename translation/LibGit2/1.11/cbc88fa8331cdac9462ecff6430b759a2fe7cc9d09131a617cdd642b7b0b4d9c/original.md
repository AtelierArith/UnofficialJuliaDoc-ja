```julia
fetch(rmt::GitRemote, refspecs; options::FetchOptions=FetchOptions(), msg="")
```

Fetch from the specified `rmt` remote git repository, using `refspecs` to determine which remote branch(es) to fetch. The keyword arguments are:

  * `options`: determines the options for the fetch, e.g. whether to prune afterwards. See [`FetchOptions`](@ref) for more information.
  * `msg`: a message to insert into the reflogs.
