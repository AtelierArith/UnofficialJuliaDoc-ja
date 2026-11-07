```julia
select_platform(download_info::Dict, platform::AbstractPlatform = HostPlatform())
```

プラットフォームと値を対応付けた辞書 `download_info` が与えられたとき、キーが `platform` に最もよく一致する値を選びます。一致するものが見つからない場合は、`nothing` を返します。

アーキテクチャ、libc、呼び出し ABI などのプラットフォーム属性は、すべて完全に一致する必要があります。ただし、コンパイラ ABI などの属性にはワイルドカードを含めることができます。たとえば、`nothing` は GCC の任意のバージョンに一致します。
