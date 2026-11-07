```julia
takestring!(x)::AbstractString
```

`x` の内容から文字列を作成し、`x` を空にします。

# Examples

```jldoctest
julia> v = [0x61, 0x62, 0x63];

julia> s = takestring!(v)
"abc"

julia> isempty(v)
true
```

!!! compat "Julia 1.13"
    この関数を使用するには、Julia 1.13 以降が必要です。

