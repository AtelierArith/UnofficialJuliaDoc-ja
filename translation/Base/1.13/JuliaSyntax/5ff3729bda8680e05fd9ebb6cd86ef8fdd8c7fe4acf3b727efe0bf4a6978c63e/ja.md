```julia
highlight(io, x; color, note, notecolor,
          context_lines_before, context_lines_inner, context_lines_after)

highlight(io::IO, source::SourceFile, range::UnitRange; kws...)
```

背景色が`color`で、テキスト内のマーカーによって下線が引かれた`x`の前後にあるソースコードの行を出力します。注釈として、`notecolor`内の`note`を指定できます。デフォルトでは、`x`は`sourcefile(x)`と`byte_range(x)`が実装されたオブジェクトである必要があります。

コンテキスト引数`context_lines_before`などは、前後にコンテキストとして出力するコード行数を指定します。`inner`は複数行にわたる領域内のコンテキスト行数を指定します。

2つ目の形式では、1つ目の形式と同じキーワードを使用しつつ、ソースファイルとバイト範囲を明示的に指定できます。
