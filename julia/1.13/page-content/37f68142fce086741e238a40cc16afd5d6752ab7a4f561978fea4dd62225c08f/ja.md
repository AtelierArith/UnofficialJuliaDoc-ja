```@meta
EditURL = "https://github.com/JuliaLang/Pkg.jl/blob/master/docs/src/basedocs.md"
```

# Pkg

PkgはJuliaに組み込まれているパッケージマネージャーで、パッケージのインストール、更新、削除などの操作を行います。

!!! note
    以下では、Pkgについてごく簡単に紹介します。`Project.toml`ファイル、`Manifest.toml`ファイル、パッケージのバージョン互換性（`[compat]`）、環境、レジストリなどについて詳しく知りたい場合は、こちらから参照できるマニュアル全文を読むことを強くおすすめします。[https://pkgdocs.julialang.org](https://pkgdocs.julialang.org)


```@eval
import Markdown
file = joinpath(Sys.STDLIB, "Pkg", "docs", "src", "getting-started.md")
str = read(file, String)
str = replace(str, r"^#.*$"m => "")
str = replace(str, "[API Reference](@ref)" => "[API Reference](https://pkgdocs.julialang.org/v1/api/)")
str = replace(str, "(@ref Working-with-Environments)" => "(https://pkgdocs.julialang.org/v1/environments/)")
str = replace(str, "(@ref Managing-Packages)" => "(https://pkgdocs.julialang.org/v1/managing-packages/)")
Markdown.parse(str)
```
