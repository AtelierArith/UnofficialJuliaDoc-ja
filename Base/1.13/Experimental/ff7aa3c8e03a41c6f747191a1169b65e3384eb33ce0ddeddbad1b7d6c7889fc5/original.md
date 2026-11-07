```julia
Experimental.@optlevel n::Int
```

Set the optimization level (equivalent to the `-O` command line argument) for code in the current module. Submodules inherit the setting of their parent module.

Supported values are 0, 1, 2, and 3.

The effective optimization level is the minimum of that specified on the command line and in per-module settings. If a `--min-optlevel` value is set on the command line, that is enforced as a lower bound.
