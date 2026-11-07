```julia
require_stdlib(package_uuidkey::PkgId, [ext::String, from::Module])
```

!!! warning "May load duplicate copies of stdlib packages."
    This requires that all stdlib packages loaded are compatible with having concurrent copies of themselves loaded into memory. It also places additional restrictions on the kinds of type-piracy that are allowed in stdlibs, since type-piracy can cause the dispatch table to become visibly "torn" across multiple different packages.

    The specific requirements are:

    The import side (caller of `require_stdlib`) must not leak any stdlib types, esp.   to any context that may have a conflicting copy of the stdlib(s) (or vice-versa).      - e.g., if an output is forwarded to user code, it must contain only Base types.      - e.g., if an output contains types from the stdlib, it must be consumed "internally"              before reaching user code.

    The imported code (loaded stdlibs) must be very careful about type piracy:      - It must not access any global state that may differ between stdlib copies in        type-pirated methods.      - It must not return any stdlib types from any type-pirated public methods (since        a loaded duplicate would overwrite the Base method again, returning different        types that don't correspond to the user-accessible copy of the stdlib).      - It must not pass / discriminate stdlib types in type-pirated methods, except        indirectly via methods defined in Base and implemented (w/o type-piracy) in        all copies of the stdlib over their respective types.

    The idea behind the above restrictions is that any type-pirated methods in the stdlib   must return a result that is simultaneously correct for all of the stdlib's loaded   copies, including accounting for global state differences and split type identities.

    Furthermore, any imported code must not leak any stdlib types to globals and containers   (e.g. Vectors and mutable structs) in upstream Modules, since this will also lead to   type-confusion when the type is later pulled out in user / stdlib code.

    For examples of issues like the above, see:   [1] https://github.com/JuliaLang/Pkg.jl/issues/4017#issuecomment-2377589989   [2] https://github.com/JuliaLang/StyledStrings.jl/issues/91#issuecomment-2379602914

