```julia
display(x)
display(d::AbstractDisplay, x)
display(mime, x)
display(d::AbstractDisplay, mime, x)
```

`x`は、ディスプレイスタックで最上位にある適用可能なディスプレイを使って表示します。通常は、`x`に対応する中で最も高機能なマルチメディア出力を使用し、フォールバックとしてプレーンテキストの[`stdout`](@ref)出力を使います。`display(d, x)`の形式では、指定されたディスプレイ`d`だけを使って`x`を表示しようとします。この種類のオブジェクトを`d`で表示できない場合は、[`MethodError`](@ref)をスローします。

一般に、`display`の出力先が`stdout`だとは限りません（[`print(x)`](@ref)や[`show(x)`](@ref)とは異なります）。たとえば、`display(x)`は、画像を別ウィンドウで開くことがあります。`display(x)`は、「現在の出力デバイスに応じて、最適な方法で`x`を表示する」という意味です。REPLのようなテキスト出力を確実に`stdout`へ出力したい場合は、代わりに[`show(stdout, "text/plain", x)`](@ref)を使ってください。

さらに、`mime`引数（`"image/png"`などのMIMEタイプ文字列）を取る形式が2つあります。これらは、指定されたMIMEタイプだけを使って`x`を表示しようとします。そのタイプがディスプレイまたは`x`でサポートされていない場合は、`MethodError`をスローします。これらの形式では、`x::AbstractString`（text/htmlやapplication/postscriptなど、テキストベースで格納されるMIMEタイプの場合）または`x::Vector{UInt8}`（バイナリMIMEタイプの場合）を渡すことで、指定したMIMEタイプの「生」データを指定することもできます。

ある型のインスタンスの表示方法をカスタマイズするには、`display`ではなく[`show`](@ref)をオーバーロードしてください。詳しくは、マニュアルの[custom pretty-printing](@ref man-custom-pretty-printing)の節を参照してください。
