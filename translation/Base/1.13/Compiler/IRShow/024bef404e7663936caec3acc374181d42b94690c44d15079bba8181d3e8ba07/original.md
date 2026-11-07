```julia
IRShowConfig
```

  * `line_info_preprinter(io::IO, indent::String, idx::Int)``may print relevant info at the beginning of the line, and should at least print`indent`. It returns a string that will be printed after the final basic-block annotation.
  * `line_info_postprinter(io::IO; type, used::Bool, show_type::Bool, idx::Int)` prints relevant information like type-annotation at the end of the statement
  * `should_print_stmt(idx::Int) -> Bool`: whether the statement at index `idx` should be printed as part of the IR or not
  * `bb_color`: color used for printing the basic block brackets on the left
  * `label_dynamic_calls`: whether to label calls as dynamic / builtin / intrinsic
