```julia
show_invalid(io::IO, c::AbstractChar)
```

`show(io, c)`が呼び出されるのは、[`isoverlong(c)`](@ref)または[`ismalformed(c)`](@ref)が`true`を返す場合です。無効な文字データの保存をサポートする場合、`AbstractChar`のサブクラスでは`Base.show_invalid`メソッドを定義してください。
