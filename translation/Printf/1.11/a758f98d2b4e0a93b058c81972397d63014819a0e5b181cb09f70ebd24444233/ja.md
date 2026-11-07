```julia
Printf.Format(format_str)
```

値の書式設定に使用できる、C の printf 互換フォーマットオブジェクトを作成します。

入力の `format_str` には、有効な書式指定文字と修飾子を任意に指定できます。

`Format` オブジェクトを `Printf.format(f::Format, args...)` に渡すと書式化された文字列を生成でき、`Printf.format(io::IO, f::Format, args...)` に渡すと書式化された文字列を直接 `io` に出力できます。

簡便な方法として、`Printf.format"..."` 文字列マクロ形式を使うと、マクロ展開時に `Printf.Format` オブジェクトを作成できます。

!!! compat "Julia 1.6"
    `Printf.Format` には Julia 1.6 以降が必要です。

