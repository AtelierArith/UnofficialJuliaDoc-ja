```julia
Experimental.@compiler_options optimize={0,1,2,3} compile={yes,no,all,min} infer={true,false} max_methods={default,1,2,3,4}
```

Set compiler options for code in the enclosing module. Options correspond directly to command-line options with the same name, where applicable. The following options are currently supported:

  * `optimize`: Set optimization level.
  * `compile`: Toggle native code compilation. Currently only `min` is supported, which requests the minimum possible amount of compilation.
  * `infer`: Enable or disable type inference. If disabled, implies [`@nospecialize`](@ref).
  * `max_methods`: Maximum number of matching methods considered when running type inference.
