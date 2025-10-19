```julia
count(
    pattern::Union{AbstractChar,AbstractString,AbstractPattern},
    string::AbstractString;
    overlap::Bool = false,
)
```

`pattern`が`string`内で一致する回数を返します。これは`length(findall(pattern, string))`を呼び出すのと同等ですが、より効率的です。

`overlap=true`の場合、一致するシーケンスは元の文字列内のインデックスで重複することが許可されます。そうでない場合は、互いに重ならない文字範囲からでなければなりません。

!!! compat "Julia 1.3"
    このメソッドは少なくともJulia 1.3が必要です。


!!! compat "Julia 1.7"
    パターンとして文字を使用するには、少なくともJulia 1.7が必要です。


# 例

```jldoctest
julia> count('a', "JuliaLang")
2

julia> count(r"a(.)a", "cabacabac", overlap=true)
3

julia> count(r"a(.)a", "cabacabac")
2
```
