```julia
Printf.Format(format_str)
```

値をフォーマットするために使用できるC printf互換のフォーマットオブジェクトを作成します。

入力の`format_str`には、任意の有効なフォーマット指定子文字と修飾子を含めることができます。

`Format`オブジェクトは、`Printf.format(f::Format, args...)`に渡してフォーマットされた文字列を生成するか、`Printf.format(io::IO, f::Format, args...)`に渡してフォーマットされた文字列を直接`io`に印刷することができます。

便利のために、`Printf.format"..."`文字列マクロ形式を使用して、マクロ展開時に`Printf.Format`オブジェクトを構築することができます。

!!! compat "Julia 1.6"
    `Printf.Format`はJulia 1.6以降が必要です。

