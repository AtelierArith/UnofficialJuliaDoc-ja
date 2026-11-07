```julia
ci_has_abi(interp::AbstractInterpreter, code::CodeInstance)
```

この CodeInstance が、interp からランタイムシステムに渡された場合に呼び出し可能かどうかを判定します（すでに ->invoke ptr を持っている場合、または interp にコンパイル可能なソースがある場合）。
