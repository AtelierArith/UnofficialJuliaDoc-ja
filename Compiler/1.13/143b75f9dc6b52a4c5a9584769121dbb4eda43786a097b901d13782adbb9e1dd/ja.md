```julia
builtin_nothrow(𝕃::AbstractLattice, f::Builtin, argtypes::Vector{Any}, rt)::Bool
```

組み込み関数呼び出しのスロー可能性を計算します。`argtypes`には、`f`自体を含めないでください。
