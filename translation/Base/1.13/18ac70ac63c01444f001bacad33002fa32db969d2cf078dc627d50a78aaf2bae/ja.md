```julia
capture_exception(ex, bt)::Exception
```

例外を返します。バックトレース `bt` の情報が含まれる場合もあります。デフォルトでは [`CapturedException(ex, bt)`](@ref) を返します。

ユーザー指定の関数呼び出し中にスローされた例外を捕捉するため、[`asyncmap`](@ref) および [`asyncmap!`](@ref) で使用されます。
