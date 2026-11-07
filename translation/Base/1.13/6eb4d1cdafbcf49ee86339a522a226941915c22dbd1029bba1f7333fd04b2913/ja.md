```julia
takestring!(io::IOBuffer)::String
```

バッファを初期状態にリセットし、`io`の内容を`String`として返します。`IOBuffer`から文字列を作成するには、`String(take!(io))`を呼び出すよりも、この方法が推奨されます。

# Examples

```jldoctest
julia> io = IOBuffer();

julia> write(io, [0x61, 0x62, 0x63]);

julia> s = takestring!(io)
"abc"

julia> isempty(take!(io)) # io is now empty
true
```

!!! compat "Julia 1.13"
    この関数を使用するには、Julia 1.13以降が必要です。

