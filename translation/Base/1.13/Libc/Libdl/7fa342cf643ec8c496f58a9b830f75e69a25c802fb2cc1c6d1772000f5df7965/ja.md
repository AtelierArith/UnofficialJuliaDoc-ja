```julia
dlopen_e(libfile::AbstractString [, flags::Integer])
```

[`dlopen`](@ref)と同様ですが、エラーをスローする代わりに`C_NULL`を返します。このメソッドは非推奨となり、今後は`dlopen(libfile::AbstractString [, flags::Integer]; throw_error=false)`を使用してください。
