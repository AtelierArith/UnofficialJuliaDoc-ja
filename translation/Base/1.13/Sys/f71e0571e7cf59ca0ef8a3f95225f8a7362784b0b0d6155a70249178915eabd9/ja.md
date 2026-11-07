```julia
Sys.CPU_NAME::String
```

CPUの名前を表す文字列です。

# Examples

たとえば、`Sys.CPU_NAME`は、[Intel Core "Tiger Lake" CPU](https://en.wikipedia.org/wiki/Tiger_Lake)では`"tigerlake"`、[Apple M1 CPU](https://en.wikipedia.org/wiki/Apple_M1)では`"apple-m1"`となる場合があります。

注: 詳細なシステム情報に`versioninfo(verbose=true)`を介して含まれます。
