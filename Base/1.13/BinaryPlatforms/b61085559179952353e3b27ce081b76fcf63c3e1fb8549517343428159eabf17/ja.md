```julia
detect_libgfortran_version()
```

現在の Julia プロセスを調べ、この Julia がリンクしている libgfortran のバージョン（存在する場合）を特定します。libgfortran のバージョン依存性が検出されない場合は、`nothing` を返します。
