```julia
validate_code!(errors::Vector{InvalidCodeError}, c::CodeInfo)
```

`c`を検証し、違反があれば`InvalidCodeError`を`errors`に追加して記録します。
