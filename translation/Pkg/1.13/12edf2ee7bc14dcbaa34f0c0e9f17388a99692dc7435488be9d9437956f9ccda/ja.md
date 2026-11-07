```julia
PackageSpec(name::String, [uuid::UUID, version::VersionNumber])
PackageSpec(; name, url, path, subdir, rev, version, mode, level)
```

`PackageSpec`は、さまざまなメタデータを持つパッケージを表します。メタデータには次のものが含まれます。

  * パッケージの`name`。
  * パッケージ固有の`uuid`。
  * `version`（たとえば、パッケージを追加する場合）。アップグレード時には、列挙型[`UpgradeLevel`](@ref)のインスタンスを指定することもできます。バージョンを`String`として指定すると、明示されていないバージョンは「制約なし」とみなされます。たとえば、`version="0.5"`を指定すると、任意のバージョンの`0.5.x`をインストールできます。`VersionNumber`として指定した場合は、指定したバージョンがそのまま使われます。たとえば、`version=v"0.5.3"`です。
  * `url`と、任意のgit `rev`ision。`rev`には、ブランチ名またはgitコミットのSHA1を指定できます。
  * ローカルの`path`。これは`url`引数を使うのと同等ですが、より説明的に記述できます。
  * リポジトリのルートにないパッケージを追加する際に使える`subdir`。

Pkgのほとんどの関数は、`PackageSpec`の`Vector`を受け取り、ベクター内のすべてのパッケージに対して処理を行います。

`PackageSpec`または`Vector{PackageSpec}`を受け取る多くの関数は、`NamedTuple`を使った簡潔な記法でも呼び出せます。たとえば、`Pkg.add`は、明示的な記法と簡潔な記法のどちらでも、次のように呼び出せます。

| 明示的な記法                                                              | 簡潔な記法                                            |
|:------------------------------------------------------------------- |:------------------------------------------------ |
| `Pkg.add(PackageSpec(name="Package"))`                              | `Pkg.add(name = "Package")`                      |
| `Pkg.add(PackageSpec(url="www.myhost.com/MyPkg")))`                 | `Pkg.add(url="www.myhost.com/MyPkg")`            |
| `Pkg.add([PackageSpec(name="Package"), PackageSpec(path="/MyPkg"])` | `Pkg.add([(;name="Package"), (;path="/MyPkg")])` |

以下に、REPLモードと関数APIを比較します。

| `REPL`               | `API`                                                |
|:-------------------- |:---------------------------------------------------- |
| `Package`            | `PackageSpec("Package")`                             |
| `Package@0.2`        | `PackageSpec(name="Package", version="0.2")`         |
| -                    | `PackageSpec(name="Package", version=v"0.2.1")`      |
| `Package=a67d...`    | `PackageSpec(name="Package", uuid="a67d...")`        |
| `Package#master`     | `PackageSpec(name="Package", rev="master")`          |
| `local/path#feature` | `PackageSpec(path="local/path"; rev="feature")`      |
| `www.mypkg.com`      | `PackageSpec(url="www.mypkg.com")`                   |
| `--major Package`    | `PackageSpec(name="Package", version=UPLEVEL_MAJOR)` |
