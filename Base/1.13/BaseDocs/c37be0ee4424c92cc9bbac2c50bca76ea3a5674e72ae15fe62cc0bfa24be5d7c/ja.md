```julia
llvmcall(fun_ir::String, returntype, Tuple{argtype1, ...}, argvalue1, ...)
llvmcall((mod_ir::String, entry_fn::String), returntype, Tuple{argtype1, ...}, argvalue1, ...)
llvmcall((mod_bc::Vector{UInt8}, entry_fn::String), returntype, Tuple{argtype1, ...}, argvalue1, ...)
```

第1引数で指定したLLVMコードを呼び出します。この第1引数は、いくつかの方法で指定できます。

  * 関数レベルのIRを表す文字列リテラルとして指定します（LLVMの`define`ブロックに似ています）。引数は、名前のないSSA変数（%0、%1など）として連続して利用できます。
  * モジュールIRを表す文字列と、呼び出すエントリーポイント関数の名前を表す文字列を含む、2要素のタプルとして指定します。
  * 2要素のタプルとして指定しますが、モジュールはビットコードを含む`Vector{UInt8}`として渡します。

`ccall`とは異なり、引数の型は型のタプルではなく、タプル型として指定する必要がある点に注意してください。型とLLVMコードはすべて、変数や式ではなくリテラルとして指定してください（これらのリテラルを生成するには、`@eval`が必要になる場合があります）。

使用例については、[`test/llvmcall.jl`](https://github.com/JuliaLang/julia/blob/v1.13.3/test/llvmcall.jl)を参照してください。
