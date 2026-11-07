```julia
with_output_annotations(f::Function, io::AnnotIO, annots::Pair{Symbol, <:Any}...)
```

`f(io)`を呼び出し、その実行によって生成された出力に`annots`を適用します。
