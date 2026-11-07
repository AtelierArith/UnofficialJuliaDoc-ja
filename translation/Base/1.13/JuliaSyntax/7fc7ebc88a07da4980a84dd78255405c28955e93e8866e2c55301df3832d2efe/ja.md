```julia
ParseStream(text::AbstractString,          index::Integer=1; version=VERSION)
ParseStream(text::IO;                                        version=VERSION)
ParseStream(text::Vector{UInt8},           index::Integer=1; version=VERSION)
ParseStream(ptr::Ptr{UInt8}, len::Integer, index::Integer=1; version=VERSION)
```

さまざまな形式の入力から `ParseStream` を構築します。

  * 文字列（`String` と `SubString` はゼロコピー）
  * `IO` オブジェクト（`IOBuffer` はゼロコピー）。`IO` オブジェクトはシーク可能である必要があります。
  * バイトバッファー（ゼロコピー）。`(ptr,len)` として渡すバッファーは、呼び出し側が保持する責任を負います。

解析を開始する位置として、バイト `index` を指定できます。

ParseStream はパーサー向けの IO インターフェースを提供します。ソーステキスト入力をトークンに字句解析し、パーサーに代わって重要でない空白トークンを管理するとともに、出力トークンとツリーノードを 2 つの出力配列に格納します。

`version`（デフォルトは `VERSION`）を使うと、構文バージョンを任意の Julia バージョン `>= v"1.0"` に設定できます。v"1.0" 以降に追加された Julia の構文をすべて解析することを目指しており、指定された `version` と互換性がない場合はエラーを出力します。
