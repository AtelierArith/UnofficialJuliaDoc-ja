```
@goto name
```

`@goto name` unconditionally jumps to the statement at the location [`@label name`](@ref).

`@label` and `@goto` cannot create jumps to different top-level statements. Attempts cause an error. To still use `@goto`, enclose the `@label` and `@goto` in a block.
