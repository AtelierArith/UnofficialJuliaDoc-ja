```julia
Sys.CPU_NAME::String
```

CPUの名前を表す文字列。

# Examples

たとえば、`Sys.CPU_NAME`は[Intel Core "Tiger Lake" CPU](https://en.wikipedia.org/wiki/Tiger_Lake)上では`"tigerlake"`、[Apple M1 CPU](https://en.wikipedia.org/wiki/Apple_M1)上では`"apple-m1"`となる場合があります。

注: 詳細なシステム情報には`versioninfo(verbose=true)`を介して含まれます。
