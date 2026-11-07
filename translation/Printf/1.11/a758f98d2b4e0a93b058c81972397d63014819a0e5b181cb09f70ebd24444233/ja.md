```julia
Printf.Format(format_str)
```

値の書式設定に使用できる、C の printf と互換性のあるフォーマットオブジェクトを作成します。

入力の `format_str` には、有効なフォーマット指定子の文字と修飾子を任意に含めることができます。

`Format` オブジェクトは、`Printf.format(f::Format, args...)` に渡して書式設定済みの文字列を生成したり、`Printf.format(io::IO, f::Format, args...)` に渡して書式設定済みの文字列を `io` に直接出力したりできます。

簡便な方法として、`Printf.format"..."` 文字列マクロ形式を使うと、マクロ展開時に `Printf.Format` オブジェクトを作成できます。

!!! compat "Julia 1.6"
    `Printf.Format` には Julia 1.6 以降が必要です。

