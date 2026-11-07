```julia
focus_matches(search::FilterSpec, content::AnnotatedString, targetwidth::Int) -> AnnotatedString
```

一致領域が中央に来るように `content` を切り詰め、省略記号を追加します。

一致箇所を最適に表示するため、この関数は次の段階を踏んで処理します。

1. `matchregions(search, String(content))` を使って、`content` 内の一致する文字範囲をすべて見つけます。
2. `targetwidth` 内に全体を表示できる一致領域を、最初の一致を優先して主領域として選びます。
3. その領域の末尾から、文字の表示幅を考慮しながら、ウィンドウを左方向に `targetwidth` まで広げます。
4. 左端が `content` の先頭より後にある場合は、先頭の省略記号（`LINE_ELLIPSIS`）用のスペースを確保し、ウィンドウを調整します。
5. 同様にウィンドウを右方向に広げ、残りのテキストがある場合は末尾に省略記号を挿入します。
6. 既存のアノテーションを保持しながら、算出した部分文字列を `content` から切り出します。
7. ウィンドウ内の一致領域に、一致箇所を強調表示するフェイス（`:REPL_History_search_match`）を再適用します。
8. 結果の表示幅が `targetwidth` 未満の場合は、スペースで埋めます。

返される `AnnotatedString` の表示幅は正確に `targetwidth` 桁となり、少なくとも1つの一致箇所が全体表示され、強調表示されることが保証されます。
