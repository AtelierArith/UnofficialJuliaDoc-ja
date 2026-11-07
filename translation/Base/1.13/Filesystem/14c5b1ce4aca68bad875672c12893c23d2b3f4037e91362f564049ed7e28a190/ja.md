```julia
abspath(path::AbstractString)::String
```

必要に応じて現在のディレクトリを追加し、パスを絶対パスに変換します。また、[`normpath`](@ref)と同様にパスを正規化します。

# Examples

`JuliaExample`というディレクトリにいて、使用するデータが`JuliaExample`ディレクトリから見て2階層上にある場合は、次のように記述できます。

```julia
abspath("../../data")
```

この場合、パスは`"/home/JuliaUser/data/"`のようになります。

[`joinpath`](@ref)、[`pwd`](@ref)、[`expanduser`](@ref)も参照してください。
