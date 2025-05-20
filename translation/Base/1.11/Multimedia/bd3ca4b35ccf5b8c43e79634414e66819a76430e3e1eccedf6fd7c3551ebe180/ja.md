```
@MIME_str
```

[`MIME`](@ref) タイプを書くための便利なマクロで、通常は [`show`](@ref) にメソッドを追加する際に使用されます。例えば、構文 `show(io::IO, ::MIME"text/html", x::MyType) = ...` を使用して、`MyType` の HTML 表現の書き方を定義することができます。
