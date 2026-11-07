```julia
macroexpand(m::Module, x; recursive=true, legacyscope=true)
```

Take the expression `x` and return an equivalent expression with all macros removed (expanded) for executing in module `m`. The `recursive` keyword controls whether deeper levels of nested macros are also expanded. The `legacyscope` keyword controls whether legacy macroscope expansion is performed. This is demonstrated in the example below:

```jldoctest; filter = r"#= .*:6 =#"
julia> module M
           macro m1()
               42
           end
           macro m2()
               :(@m1())
           end
       end
M

julia> macroexpand(M, :(@m2()), recursive=true)
42

julia> macroexpand(M, :(@m2()), recursive=false)
:(#= REPL[1]:6 =# @m1)
```

!!! compat "Julia 1.13"
    The `legacyscope` keyword argument requires at least Julia 1.13.

