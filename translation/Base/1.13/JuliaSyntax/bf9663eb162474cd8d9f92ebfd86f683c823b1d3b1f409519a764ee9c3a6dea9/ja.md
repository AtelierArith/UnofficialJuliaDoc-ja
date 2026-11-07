```julia
SourceFile(code [; filename=nothing, first_line=1, first_index=1])
```

ファイル名と行番号を伴うUTF-8ソーステキスト。各行の開始位置の文字インデックスを保持します。`first_line`と`first_index`を使うと、より大きなソーステキスト内にある`code`の行番号と先頭文字のインデックスを指定できます。

`SourceFile`は、`getindex`または`view`でインデックスを指定して文字列を取得できます。バイトオフセットに対応する行情報は、`source_line`、`source_location`、`source_line_range`の各関数で参照できます。
