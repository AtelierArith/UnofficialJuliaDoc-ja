```julia
codepoint(c::AbstractChar) -> Integer
```

文字 `c` に対応する Unicode コードポイント（符号なし整数）を返します（または `c` が有効な文字を表さない場合は例外をスローします）。`Char` の場合、これは `UInt32` 値ですが、Unicode のサブセットのみを表す `AbstractChar` 型は異なるサイズの整数（例：`UInt8`）を返すことがあります。
