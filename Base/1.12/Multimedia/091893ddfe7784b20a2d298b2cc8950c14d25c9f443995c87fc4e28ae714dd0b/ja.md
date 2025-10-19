```julia
display(x)
display(d::AbstractDisplay, x)
display(mime, x)
display(d::AbstractDisplay, mime, x)
```

`x`を表示スタックの最上位の適用可能な表示を使用して表示します。通常、`x`のためにサポートされている最もリッチなマルチメディア出力を使用し、プレーンテキスト[`stdout`](@ref)出力をフォールバックとして使用します。`display(d, x)`のバリアントは、指定された表示`d`のみに`x`を表示しようとし、`d`がこのタイプのオブジェクトを表示できない場合は[`MethodError`](@ref)をスローします。

一般に、`display`の出力が`stdout`に送られるとは限りません（[`print(x)`](@ref)や[`show(x)`](@ref)とは異なります）。たとえば、`display(x)`は画像を表示するために別のウィンドウを開くことがあります。`display(x)`は「現在の出力デバイスに対して最良の方法で`x`を表示する」という意味です。`stdout`に確実に送られるREPLのようなテキスト出力が必要な場合は、代わりに[`show(stdout, "text/plain", x)`](@ref)を使用してください。

`mime`引数（例えば、`"image/png"`のようなMIMEタイプ文字列）を持つ2つのバリアントもあり、要求されたMIMEタイプ*のみ*を使用して`x`を表示しようとし、このタイプが表示または`x`によってサポートされていない場合は`MethodError`をスローします。これらのバリアントを使用すると、`x::AbstractString`（text/htmlやapplication/postscriptのようなテキストベースのストレージを持つMIMEタイプの場合）または`x::Vector{UInt8}`（バイナリMIMEタイプの場合）を渡すことで、要求されたMIMEタイプの「生」データを提供することもできます。

型のインスタンスがどのように表示されるかをカスタマイズするには、マニュアルの[カスタムプリティプリンティング](@ref man-custom-pretty-printing)のセクションで説明されているように、`display`ではなく[`show`](@ref)をオーバーロードしてください。
