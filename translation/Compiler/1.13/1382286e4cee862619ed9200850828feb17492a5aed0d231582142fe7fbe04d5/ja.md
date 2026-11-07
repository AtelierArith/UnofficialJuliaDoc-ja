```julia
codegen_cache(interp::AbstractInterpreter) -> Union{Nothing, IdDict{CodeInstance, CodeInfo}}
```

必要に応じて、`CodeInfo`と`CodeInstance`を対応付けるキャッシュを返すことができます。このキャッシュは、今後`invoke(f, ::CodeInstance, args...)`を介して実行するためにJITへ追加されます。このキャッシュは`typeinf_ext_toplevel`中に使用され、この関数の呼び出し間で安全に破棄できます。

デフォルトでは、`nothing`の値が返され、`CodeInstance`をJITに追加しないことを示します。`invoke`を介して実行しようとすると、エラーになります。
