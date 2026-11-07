```julia
ccall((function_name, library), returntype, (argtype1, ...), argvalue1, ...)
ccall(function_name, returntype, (argtype1, ...), argvalue1, ...)
ccall(function_pointer, returntype, (argtype1, ...), argvalue1, ...)
```

C からエクスポートされた共有ライブラリ内の関数を呼び出します。関数は、各要素が文字列またはシンボルであるタプル `(function_name, library)` で指定します。ライブラリを指定する代わりに、現在のプロセス内で解決されるシンボルまたは文字列 `function_name` も使用できます。また、`ccall` を使って関数ポインター `function_pointer` を呼び出すこともできます。たとえば、`dlsym` が返すポインターを指定できます。

引数の型タプルには、タプル値を持つ変数や式ではなく、リテラルのタプルを指定する必要があります。

`ccall` に渡す各 `argvalue` は、`unsafe_convert(argtype, cconvert(argtype, argvalue))` の呼び出しが自動的に挿入され、対応する `argtype` に変換されます。（詳しくは、[`unsafe_convert`](@ref Base.unsafe_convert) および [`cconvert`](@ref Base.cconvert) のドキュメントも参照してください。）ほとんどの場合、これは単に `convert(argtype, argvalue)` の呼び出しになります。
