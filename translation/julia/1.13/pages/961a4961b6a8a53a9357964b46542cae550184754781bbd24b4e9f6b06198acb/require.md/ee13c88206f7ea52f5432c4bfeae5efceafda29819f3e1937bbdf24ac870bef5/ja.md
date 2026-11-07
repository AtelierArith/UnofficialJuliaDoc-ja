# Module loading

[`Base.require`](@ref)は、モジュールの読み込みを担い、プリコンパイルキャッシュも管理します。`import`文の実装です。

## Experimental features

以下の機能は実験的なものであり、安定版のJulia APIには含まれていません。これらを利用した開発を始める前に、現在の見解や、近いうちに変更される可能性があるかどうかを確認してください。

### Package loading callbacks

コールバックを登録すると、`Base.require`によって読み込まれたパッケージを監視できます。

```julia
loaded_packages = Base.PkgId[]
callback = (pkg::Base.PkgId) -> push!(loaded_packages, pkg)
push!(Base.package_callbacks, callback)
```

使用例は次のようになります。

```julia-repl
julia> using Example

julia> loaded_packages
1-element Vector{Base.PkgId}:
 Example [7876af07-990d-54b4-ab0e-23690620f79a]
```
