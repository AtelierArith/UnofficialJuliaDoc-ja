```julia
@MIME_str
```

[`MIME`](@ref)型の書き込みに使う便利なマクロです。通常、[`show`](@ref)にメソッドを追加する際に使用します。たとえば、`MyType`のHTML表現を書き込む方法を定義するには、`show(io::IO, ::MIME"text/html", x::MyType) = ...`という構文を使用できます。
