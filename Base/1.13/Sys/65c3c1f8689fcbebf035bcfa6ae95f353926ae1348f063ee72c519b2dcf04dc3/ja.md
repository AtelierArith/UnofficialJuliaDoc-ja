```julia
Sys.JIT::String
```

現在のランタイムで使用されている、特定のJust-In-Time（JIT）コンパイラーを表す文字列です。

# Examples

現在は、LLVMの「ORC」（「On-Request Compilation」）JITライブラリを示す`"ORCJIT"`です。

```jldoctest
julia> Sys.JIT
"ORCJIT"
```

注：詳細なシステム情報には`versioninfo(verbose=true)`を介して含まれます。
