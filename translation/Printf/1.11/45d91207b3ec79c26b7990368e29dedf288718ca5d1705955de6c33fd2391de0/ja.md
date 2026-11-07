```julia
Printf.format(f::Printf.Format, args...) => String
Printf.format(io::IO, f::Printf.Format, args...)
```

printf形式のオブジェクト`f`を、指定された`args`に適用して書式付き文字列を返す（第1の方法）か、`io`オブジェクトに直接出力します（第2の方法）。Cの`printf`サポートの詳細については、[`@printf`](@ref)を参照してください。
