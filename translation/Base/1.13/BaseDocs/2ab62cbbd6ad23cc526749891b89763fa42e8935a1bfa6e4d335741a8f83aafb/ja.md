```julia
ErrorException(msg)
```

汎用エラー型です。`.msg`フィールドのエラーメッセージに、より詳しい情報が記載されている場合があります。

# Examples

```jldoctest
julia> ex = ErrorException("I've done a bad thing");

julia> ex.msg
"I've done a bad thing"
```
