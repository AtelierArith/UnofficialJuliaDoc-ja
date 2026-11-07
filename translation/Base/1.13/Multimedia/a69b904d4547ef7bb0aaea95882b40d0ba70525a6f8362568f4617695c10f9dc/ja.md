```julia
@MIME_str
```

[`MIME`](@ref)型の書き込みに使う便利なマクロです。通常は[`show`](@ref)にメソッドを追加する際に使用します。たとえば、`show(io::IO, ::MIME"text/html", x::MyType) = ...`という構文を使って、`MyType`のHTML表現を書き出す方法を定義できます。
