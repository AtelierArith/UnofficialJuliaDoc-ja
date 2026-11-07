```julia
tokenize(text; operators_as_identifiers=true)
```

UTF-8エンコードされた`text`をトークン化し、`Token`のベクトルとして返します。トークンのテキストは`untokenize()`を使って取得できます。たとえば、`join(untokenize.(tokenize(text), text))`を使うと、テキスト全体を再構成できます。

このインターフェースが扱うのは、UTF-8エンコードされた文字列またはバッファーデータのみです。

キーワード`operators_as_identifiers`は、識別子の位置にある演算子を`K"Identifier"`として扱うか、より具体的な演算子の種類として出力するかを指定します。たとえば、`a + b`内の`+`を、`K"Identifier"`（デフォルト）として出力するか、`K"+"`として出力するかを指定します。
