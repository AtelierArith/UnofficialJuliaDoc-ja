```
@everywhere [procs()] expr
```

Execute an expression under `Main` on all `procs`. Errors on any of the processes are collected into a [`CompositeException`](@ref) and thrown. For example:

```
@everywhere bar = 1
```

will define `Main.bar` on all current processes. Any processes added later (say with [`addprocs()`](@ref)) will not have the expression defined.

Unlike [`@spawnat`](@ref), `@everywhere` does not capture any local variables. Instead, local variables can be broadcast using interpolation:

```
foo = 1
@everywhere bar = $foo
```

The optional argument `procs` allows specifying a subset of all processes to have execute the expression.

Similar to calling `remotecall_eval(Main, procs, expr)`, but with two extra features:

```
- `using` and `import` statements run on the calling process first, to ensure
  packages are precompiled.
- The current source file path used by `include` is propagated to other processes.
```
