```
download(url::AbstractString, [path::AbstractString = tempname()]) -> path
```

指定されたurlからファイルをダウンロードし、`path`に保存します。指定されていない場合は、一時的なパスに保存されます。ダウンロードしたファイルのパスを返します。

!!! note
    Julia 1.6以降、この関数は非推奨であり、`Downloads.download`の薄いラッパーに過ぎません。新しいコードでは、この関数を呼び出すのではなく、直接その関数を使用するべきです。

