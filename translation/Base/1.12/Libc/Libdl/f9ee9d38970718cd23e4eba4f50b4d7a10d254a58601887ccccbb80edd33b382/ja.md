```julia
dlopen_e(libfile::AbstractString [, flags::Integer])
```

[`dlopen`](@ref)と似ていますが、エラーを発生させる代わりに`C_NULL`を返します。このメソッドは、`dlopen(libfile::AbstractString [, flags::Integer]; throw_error=false)`の代わりに非推奨となりました。
