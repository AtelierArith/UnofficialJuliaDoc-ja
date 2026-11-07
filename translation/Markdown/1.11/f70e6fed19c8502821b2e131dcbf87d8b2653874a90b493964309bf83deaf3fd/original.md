```julia
with_output_annotations(f::Function, io::AnnotIO, annots::Pair{Symbol, <:Any}...)
```

Call `f(io)`, and apply `annots` to the output created by doing so.
