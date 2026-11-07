```julia
Platform
```

`Platform`は、プロセッサのアーキテクチャ、オペレーティングシステム、libcの実装など、Juliaプロセスが実行環境について把握する必要のある関連情報をすべて表します。本質的には、タグ（`arch`、`os`、`libc`など）と値（`"arch" => "x86_64"`や`"os" => "windows"`など）を対応付けるキーと値のマッピングです。`Platform`オブジェクトは拡張可能で、予約済みタグ（`arch`、`os`、`os_version`、`libc`、`call_abi`、`libgfortran_version`、`libstdcxx_version`、`cxxstring_abi`、`julia_version`）と競合しない限り、ユーザーが独自のマッピングを追加できます。

有効なタグと値には、英数字とピリオドを使用できます。表記のばらつきを抑えるため、保存時にはすべてのタグと値が小文字に変換されます。

例：

```julia
Platform("x86_64", "windows"; cuda = "10.1")
```
