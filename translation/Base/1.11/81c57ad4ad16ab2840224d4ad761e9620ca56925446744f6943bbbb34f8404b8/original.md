```
Base.depwarn(msg::String, funcsym::Symbol; force=false)
```

Print `msg` as a deprecation warning. The symbol `funcsym` should be the name of the calling function, which is used to ensure that the deprecation warning is only printed the first time for each call place. Set `force=true` to force the warning to always be shown, even if Julia was started with `--depwarn=no` (the default).

See also [`@deprecate`](@ref).

# Examples

```julia
function deprecated_func()
    Base.depwarn("Don't use `deprecated_func()`!", :deprecated_func)

    1 + 1
end
```
