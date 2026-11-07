```julia
stringmime(mime, x; context=nothing)
```

`x`の表現を、指定された`mime`型で格納した`AbstractString`を返します。これは[`repr(mime, x)`](@ref)に似ていますが、バイナリデータがASCII文字列としてBase64エンコードされる点が異なります。

省略可能なキーワード引数`context`には、`:key=>value`のペア、または`IO`や[`IOContext`](@ref)のオブジェクトを指定できます。これらの属性は、[`show`](@ref)に渡されるI/Oストリームに使用されます。
