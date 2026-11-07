```julia
ascii(s::AbstractString)
```

文字列を`String`型に変換し、ASCIIデータのみを含むことを確認します。ASCII以外のデータが含まれている場合は、最初の非ASCIIバイトの位置を示す`ArgumentError`をスローします。

ASCII以外の文字をフィルタリングまたは置換するには、[`isascii`](@ref)述語も参照してください。

# Examples

```jldoctest
julia> ascii("abcdeγfgh")
ERROR: ArgumentError: invalid ASCII at index 6 in "abcdeγfgh"
Stacktrace:
[...]

julia> ascii("abcdefgh")
"abcdefgh"
```
