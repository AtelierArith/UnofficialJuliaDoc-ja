```julia
codepoint(c::AbstractChar)::Integer
```

文字 `c` に対応する Unicode コードポイント（符号なし整数）を返します（`c` が有効な文字を表していない場合は、例外をスローします）。`Char` の場合、これは `UInt32` の値ですが、Unicode の一部のみを表す `AbstractChar` 型では、異なるサイズの整数が返されることがあります（例：`UInt8`）。
