```julia
download(url::AbstractString, [path::AbstractString = tempname()]) -> path
```

指定された URL からファイルをダウンロードし、`path` に保存します。保存先が指定されていない場合は、一時パスに保存します。ダウンロードしたファイルのパスを返します。

!!! note
    Julia 1.6 以降、この関数は非推奨であり、`Downloads.download` を呼び出すだけの薄いラッパーです。新しいコードでは、この関数を呼び出す代わりに、直接そちらを使用してください。

