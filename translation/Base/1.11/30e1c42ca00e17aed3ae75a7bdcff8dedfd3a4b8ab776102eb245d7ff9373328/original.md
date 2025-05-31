```
@cmd str
```

Similar to `cmd`, generate a `Cmd` from the `str` string which represents the shell command(s) to be executed. The [`Cmd`](@ref) object can be run as a process and can outlive the spawning julia process (see `Cmd` for more).

# Examples

```jldoctest
julia> cm = @cmd " echo 1 "
`echo 1`

julia> run(cm)
1
Process(`echo 1`, ProcessExited(0))
```
