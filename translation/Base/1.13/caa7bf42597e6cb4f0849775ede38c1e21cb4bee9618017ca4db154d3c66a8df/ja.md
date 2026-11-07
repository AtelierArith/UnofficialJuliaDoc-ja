```julia
count(
    pattern::Union{AbstractChar,AbstractString,AbstractPattern},
    string::AbstractString;
    overlap::Bool = false,
)
```

`string`内で`pattern`に一致する回数を返します。これは`length(findall(pattern, string))`を呼び出すのと同等ですが、より効率的です。

`overlap=true`の場合、一致する並びは元の文字列内でインデックスが重なっていてもかまいません。そうでない場合は、互いに重ならない文字範囲に含まれている必要があります。

!!! compat "Julia 1.3"
    このメソッドを使用するには、Julia 1.3以降が必要です。


!!! compat "Julia 1.7"
    パターンとして文字を使用するには、Julia 1.7以降が必要です。


# Examples

```jldoctest
julia> count('a', "JuliaLang")
2

julia> count(r"a(.)a", "cabacabac", overlap=true)
3

julia> count(r"a(.)a", "cabacabac")
2
```

# See also

[`eachmatch`](@ref), [`occursin`](@ref), [`findall`](@ref)
