```julia
display(x)
display(d::AbstractDisplay, x)
display(mime, x)
display(d::AbstractDisplay, mime, x)
```

ディスプレイスタック内で適用可能な最上位のディスプレイを使って、`x` を表示します。通常は、`x` に対してサポートされる最もリッチなマルチメディア出力を使い、フォールバックとしてプレーンテキストの [`stdout`](@ref) 出力を使います。`display(d, x)` 形式では、指定されたディスプレイ `d` のみで `x` の表示を試みます。`d` がこの型のオブジェクトを表示できない場合は、[`MethodError`](@ref) をスローします。

一般に、`display` の出力先が `stdout` であるとは限りません（[`print(x)`](@ref) や [`show(x)`](@ref) とは異なります）。たとえば、`display(x)` は別のウィンドウを開いて画像を表示することがあります。`display(x)` は、「現在の出力デバイスで可能な最善の方法で `x` を表示する」という意味です。REPL のようなテキスト出力が必要で、出力先を確実に `stdout` にしたい場合は、代わりに [`show(stdout, "text/plain", x)`](@ref) を使ってください。

`mime` 引数（`"image/png"` などの MIME 型文字列）を取る形式も 2 つあります。これらは、指定された MIME 型*のみ*を使って `x` の表示を試みます。この型がディスプレイ側または `x` 側のいずれかでサポートされていない場合は、`MethodError` をスローします。これらの形式では、`x::AbstractString`（text/html や application/postscript など、テキストベースで格納される MIME 型の場合）または `x::Vector{UInt8}`（バイナリの MIME 型の場合）を渡すことで、指定された MIME 型の「生」データを直接与えることもできます。

ある型のインスタンスの表示方法をカスタマイズするには、マニュアルの [custom pretty-printing](@ref man-custom-pretty-printing) の節で説明されているとおり、`display` ではなく [`show`](@ref) をオーバーロードしてください。
