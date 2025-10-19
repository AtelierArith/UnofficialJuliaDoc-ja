```@meta
EditURL = "https://github.com/JuliaLang/Pkg.jl/blob/master/docs/src/basedocs.md"
```

# Pkg

PkgはJuliaの組み込みパッケージマネージャであり、パッケージのインストール、更新、削除などの操作を処理します。

!!! note
    以下はPkgの非常に簡単な紹介です。`Project.toml`ファイル、`Manifest.toml`ファイル、パッケージのバージョン互換性（`[compat]`）、環境、レジストリなどに関する詳細情報については、こちらで入手可能な完全なマニュアルを読むことを強くお勧めします：[https://pkgdocs.julialang.org](https://pkgdocs.julialang.org)。


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
