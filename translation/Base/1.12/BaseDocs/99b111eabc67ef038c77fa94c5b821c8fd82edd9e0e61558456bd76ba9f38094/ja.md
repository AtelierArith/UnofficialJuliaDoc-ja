```julia
ccall((function_name, library), returntype, (argtype1, ...), argvalue1, ...)
ccall(function_name, returntype, (argtype1, ...), argvalue1, ...)
ccall(function_pointer, returntype, (argtype1, ...), argvalue1, ...)
```

Cでエクスポートされた共有ライブラリ内の関数を呼び出します。これはタプル `(function_name, library)` で指定され、各コンポーネントは文字列またはシンボルのいずれかです。ライブラリを指定する代わりに、現在のプロセスで解決される `function_name` シンボルまたは文字列を使用することもできます。あるいは、`ccall` を使用して `dlsym` によって返されるような関数ポインタ `function_pointer` を呼び出すこともできます。

引数の型タプルはリテラルタプルでなければならず、タプル値の変数や式ではありません。

各 `argvalue` は、`unsafe_convert(argtype, cconvert(argtype, argvalue))` への呼び出しを自動的に挿入することによって、対応する `argtype` に変換されます。（詳細については、[`unsafe_convert`](@ref Base.unsafe_convert) および [`cconvert`](@ref Base.cconvert) のドキュメントも参照してください。）ほとんどの場合、これは単に `convert(argtype, argvalue)` への呼び出しをもたらします。
