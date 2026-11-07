```julia
SourceFile(code [; filename=nothing, first_line=1, first_index=1])
```

ファイル名と行番号を伴うUTF-8のソーステキストで、各行の先頭の文字インデックスを格納します。`first_line`と`first_index`を使うと、より大きなソーステキスト内にある`code`の先頭文字の行番号とインデックスを指定できます。

`SourceFile`は、`getindex`または`view`でインデックスを指定して文字列を取得できます。バイトオフセットに対応する行情報は、`source_line`、`source_location`、`source_line_range`の各関数で検索できます。
