```julia
stringmime(mime, x; context=nothing)
```

要求された`mime`型で`x`を表現した`AbstractString`を返します。これは[`repr(mime, x)`](@ref)に似ていますが、バイナリデータがASCII文字列としてBase64エンコードされる点が異なります。

省略可能なキーワード引数`context`には、`:key=>value`のペア、または属性が[`show`](@ref)に渡されるI/Oストリームに使用される`IO`または[`IOContext`](@ref)オブジェクトを指定できます。
