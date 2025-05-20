```
llvmcall(fun_ir::String, returntype, Tuple{argtype1, ...}, argvalue1, ...)
llvmcall((mod_ir::String, entry_fn::String), returntype, Tuple{argtype1, ...}, argvalue1, ...)
llvmcall((mod_bc::Vector{UInt8}, entry_fn::String), returntype, Tuple{argtype1, ...}, argvalue1, ...)
```

最初の引数として提供されたLLVMコードを呼び出します。この最初の引数を指定する方法はいくつかあります：

  * 関数レベルのIRを表すリテラル文字列として（LLVMの`define`ブロックに似ており）、引数は連続した無名のSSA変数（%0, %1など）として利用可能です。
  * 2要素のタプルとして、モジュールIRの文字列と呼び出すエントリポイント関数の名前を表す文字列を含みます。
  * 2要素のタプルとして、ビットコードを持つ`Vector{UInt8}`としてモジュールを提供します。

`ccall`とは異なり、引数の型はタプル型として指定する必要があり、型のタプルではありません。すべての型とLLVMコードはリテラルとして指定する必要があり、変数や式ではありません（これらのリテラルを生成するために`@eval`を使用する必要があるかもしれません）。

[不透明ポインタ](https://llvm.org/docs/OpaquePointers.html)（`ptr`として記述）はLLVMコードでは許可されていません。

使用例については[`test/llvmcall.jl`](https://github.com/JuliaLang/julia/blob/v1.11.5/test/llvmcall.jl)を参照してください。
