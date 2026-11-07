```julia
withfaces(f, kv::Pair...)
withfaces(f, kvpair_itr)
```

Execute `f` with `FACES``.current` temporarily modified by zero or more `:name => val` arguments `kv`, or `kvpair_itr` which produces `kv`-form values.

`withfaces` is generally used via the `withfaces(kv...) do ... end` syntax. A value of `nothing` can be used to temporarily unset a face (if it has been set). When `withfaces` returns, the original `FACES``.current` has been restored.

# Examples

```jldoctest; setup = :(import StyledStrings: Face, withfaces)
julia> withfaces(:yellow => Face(foreground=:red), :green => :blue) do
           println(styled"{yellow:red} and {green:blue} mixed make {magenta:purple}")
       end
red and blue mixed make purple
```
