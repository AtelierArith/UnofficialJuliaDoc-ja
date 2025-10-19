```julia
PackageSpec(name::String, [uuid::UUID, version::VersionNumber])
PackageSpec(; name, url, path, subdir, rev, version, mode, level)
```

`PackageSpec`は、さまざまなメタデータを持つパッケージの表現です。これには以下が含まれます：

  * パッケージの`name`。
  * パッケージのユニークな`uuid`。
  * `version`（例えば、パッケージを追加する際）。アップグレード時には、列挙型[`UpgradeLevel`](@ref)のインスタンスでもかまいません。バージョンが`String`として指定される場合、指定されていないバージョンは「自由」であることを意味します。例えば、`version="0.5"`は、任意のバージョン`0.5.x`のインストールを許可します。`VersionNumber`として指定された場合、正確なバージョンが使用されます。例えば、`version=v"0.5.3"`。
  * `url`とオプションのgit`rev`ision。`rev`はブランチ名またはgitコミットSHA1であることができます。
  * ローカル`path`。これは`url`引数を使用することと同等ですが、より説明的であることができます。
  * リポジトリのルートにないパッケージを追加する際に使用できる`subdir`。

Pkgのほとんどの関数は`PackageSpec`の`Vector`を受け取り、ベクター内のすべてのパッケージに対して操作を行います。

`PackageSpec`または`Vector{PackageSpec}`を受け取る多くの関数は、`NamedTuple`を使用してより簡潔な表記で呼び出すことができます。例えば、`Pkg.add`は明示的なバージョンまたは簡潔なバージョンのいずれかとして呼び出すことができます：

| 明示的                                                                 | 簡潔                                               |
|:------------------------------------------------------------------- |:------------------------------------------------ |
| `Pkg.add(PackageSpec(name="Package"))`                              | `Pkg.add(name = "Package")`                      |
| `Pkg.add(PackageSpec(url="www.myhost.com/MyPkg")))`                 | `Pkg.add(url="www.myhost.com/MyPkg")`            |
| `Pkg.add([PackageSpec(name="Package"), PackageSpec(path="/MyPkg"])` | `Pkg.add([(;name="Package"), (;path="/MyPkg")])` |

以下は、REPLモードと関数APIの比較です：

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
