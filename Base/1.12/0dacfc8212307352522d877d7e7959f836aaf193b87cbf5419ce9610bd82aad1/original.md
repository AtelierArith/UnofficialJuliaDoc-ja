```julia
setcpuaffinity(original_command::Cmd, cpus) -> command::Cmd
```

Set the CPU affinity of the `command` by a list of CPU IDs (1-based) `cpus`.  Passing `cpus = nothing` means to unset the CPU affinity if the `original_command` has any.

This function is supported only in Linux and Windows.  It is not supported in macOS because libuv does not support affinity setting.

!!! compat "Julia 1.8"
    This function requires at least Julia 1.8.


# Examples

In Linux, the `taskset` command line program can be used to see how `setcpuaffinity` works.

```julia
julia> run(setcpuaffinity(`sh -c 'taskset -p $$'`, [1, 2, 5]));
pid 2273's current affinity mask: 13
```

Note that the mask value `13` reflects that the first, second, and the fifth bits (counting from the least significant position) are turned on:

```julia
julia> 0b010011
0x13
```
