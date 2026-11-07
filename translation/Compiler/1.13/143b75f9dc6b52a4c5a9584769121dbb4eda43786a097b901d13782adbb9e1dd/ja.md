```julia
builtin_nothrow(𝕃::AbstractLattice, f::Builtin, argtypes::Vector{Any}, rt)::Bool
```

組み込み関数の呼び出しが例外をスローするかどうかを計算します。`argtypes`には、`f`自体を含めないでください。
