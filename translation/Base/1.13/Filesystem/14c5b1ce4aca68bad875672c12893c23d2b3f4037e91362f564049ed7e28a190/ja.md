```julia
abspath(path::AbstractString)::String
```

必要に応じて現在のディレクトリを追加し、パスを絶対パスに変換します。また、[`normpath`](@ref)と同様にパスを正規化します。

# Examples

`JuliaExample`ディレクトリから見て2階層上にあるデータを使用していて、現在のディレクトリが`JuliaExample`という名前の場合、次のように記述できます。

```julia
abspath("../../data")
```

これにより、`"/home/JuliaUser/data/"`のようなパスが得られます。

[`joinpath`](@ref)、[`pwd`](@ref)、[`expanduser`](@ref)も参照してください。
