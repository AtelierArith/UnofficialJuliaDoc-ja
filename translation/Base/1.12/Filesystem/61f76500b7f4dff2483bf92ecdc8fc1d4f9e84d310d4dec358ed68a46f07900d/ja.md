```julia
abspath(path::AbstractString) -> String
```

現在のディレクトリを必要に応じて追加することで、パスを絶対パスに変換します。また、[`normpath`](@ref)のようにパスを正規化します。

# 例

`JuliaExample`というディレクトリにいる場合、使用しているデータが`JuliaExample`ディレクトリから2階層上にある場合、次のように書くことができます。

```julia
abspath("../../data")
```

これにより、`"/home/JuliaUser/data/"`のようなパスが得られます。

他にも[`joinpath`](@ref)、[`pwd`](@ref)、[`expanduser`](@ref)を参照してください。
