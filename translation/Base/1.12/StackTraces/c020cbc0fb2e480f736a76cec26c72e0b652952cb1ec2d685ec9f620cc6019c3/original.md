```julia
StackFrame
```

Stack information representing execution context, with the following fields:

  * `func::Symbol`

    The name of the function containing the execution context.
  * `linfo::Union{Method, Core.MethodInstance, Core.CodeInstance, Core.CodeInfo, Nothing}`

    The Method, MethodInstance, CodeInstance, or CodeInfo containing the execution context (if it could be found), or nothing (for example, if the inlining was a result of macro expansion).
  * `file::Symbol`

    The path to the file containing the execution context.
  * `line::Int`

    The line number in the file containing the execution context.
  * `from_c::Bool`

    True if the code is from C.
  * `inlined::Bool`

    True if the code is from an inlined frame.
  * `pointer::UInt64`

    Representation of the pointer to the execution context as returned by `backtrace`.
