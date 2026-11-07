```julia
VersionNumber
```

[semantic versioning (semver)](https://semver.org/spec/v2.0.0-rc.2.html)の仕様に従うバージョン番号型です。メジャー、マイナー、パッチの数値に続いて、プレリリースおよびビルドを表す英数字の注釈で構成されます。

`VersionNumber`オブジェクトは、標準の比較演算子（`==`、`<`、`<=`など）で比較できます。比較結果はsemver v2.0.0-rc.2の規則に従います。

`VersionNumber`には、次のパブリックフィールドがあります。

  * `v.major::Integer`
  * `v.minor::Integer`
  * `v.patch::Integer`
  * `v.prerelease::Tuple{Vararg{Union{Integer, AbstractString}}}`
  * `v.build::Tuple{Vararg{Union{Integer, AbstractString}}}`

semver形式のリテラル文字列から`VersionNumber`オブジェクトを効率よく構築するには[`@v_str`](@ref)を、Julia自体の`VersionNumber`については[`VERSION`](@ref)を、マニュアルの[Version Number Literals](@ref man-version-number-literals)も参照してください。

# Examples

```jldoctest
julia> a = VersionNumber(1, 2, 3)
v"1.2.3"

julia> a >= v"1.2"
true

julia> b = VersionNumber("2.0.1-rc1")
v"2.0.1-rc1"

julia> b >= v"2.0.1"
false
```
