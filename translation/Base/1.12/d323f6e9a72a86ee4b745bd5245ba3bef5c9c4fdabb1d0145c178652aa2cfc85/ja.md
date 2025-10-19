```julia
ascii(s::AbstractString)
```

文字列を `String` 型に変換し、ASCIIデータのみを含むことを確認します。そうでない場合は、最初の非ASCIIバイトの位置を示す `ArgumentError` をスローします。

非ASCII文字をフィルタリングまたは置き換えるための [`isascii`](@ref) プレディケートも参照してください。

# 例

```jldoctest
julia> ascii("abcdeγfgh")
ERROR: ArgumentError: invalid ASCII at index 6 in "abcdeγfgh"
Stacktrace:
[...]

julia> ascii("abcdefgh")
"abcdefgh"
```
