# Module loading

[`Base.require`](@ref) はモジュールのロードを担当し、プリコンパイルキャッシュも管理します。これは `import` ステートメントの実装です。

## Experimental features

以下の機能は実験的であり、安定したJulia APIの一部ではありません。これらを基に構築する前に、現在の考え方や、近く変更される可能性があるかどうかについて情報を得てください。

### Package loading callbacks

`Base.require`によってロードされたパッケージをリッスンすることは、コールバックを登録することで可能です。

```julia
loaded_packages = Base.PkgId[]
callback = (pkg::Base.PkgId) -> push!(loaded_packages, pkg)
push!(Base.package_callbacks, callback)
```

これを使用すると、次のようになります:

```julia-repl
julia> using Example

julia> loaded_packages
1-element Vector{Base.PkgId}:
 Example [7876af07-990d-54b4-ab0e-23690620f79a]
```
