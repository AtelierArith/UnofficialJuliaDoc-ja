```
versioninfo(io::IO=stdout; verbose::Bool=false)
```

Print information about the version of Julia in use. The output is controlled with boolean keyword arguments:

  * `verbose`: print all additional information

!!! warning
    The output of this function may contain sensitive information. Before sharing the output, please review the output and remove any data that should not be shared publicly.


See also: [`VERSION`](@ref).
