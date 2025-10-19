```julia
VersionNumber
```

バージョン番号タイプで、[セマンティックバージョニング (semver)](https://semver.org/spec/v2.0.0-rc.2.html) の仕様に従い、メジャー、マイナー、パッチの数値値で構成され、プレリリースおよびビルドのアルファベット注釈が続きます。

`VersionNumber` オブジェクトは、すべての標準比較演算子（`==`, `<`, `<=` など）で比較でき、その結果は semver v2.0.0-rc.2 ルールに従います。

`VersionNumber` には以下の公開フィールドがあります：

  * `v.major::Integer`
  * `v.minor::Integer`
  * `v.patch::Integer`
  * `v.prerelease::Tuple{Vararg{Union{Integer, AbstractString}}}`
  * `v.build::Tuple{Vararg{Union{Integer, AbstractString}}}`

効率的に `VersionNumber` オブジェクトを semver 形式のリテラル文字列から構築するための [`@v_str`](@ref)、Julia 自体の `VersionNumber` のための [`VERSION`](@ref)、およびマニュアルの [Version Number Literals](@ref man-version-number-literals) も参照してください。

# 例

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
