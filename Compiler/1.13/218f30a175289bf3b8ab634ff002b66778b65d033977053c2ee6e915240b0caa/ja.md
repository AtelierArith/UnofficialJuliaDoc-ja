```julia
inflate_ir!(ci::CodeInfo, mi::MethodInstance) -> ir::IRCode
inflate_ir!(ci::CodeInfo, sptypes::Vector{VarState}, argtypes::Vector{Any}) -> ir::IRCode
```

`ci::CodeInfo`-IRを`ir::IRCode`形式に展開します。元の`ci::CodeInfo`のフィールドを変更するインプレース変換のため、使用には注意が必要です。
