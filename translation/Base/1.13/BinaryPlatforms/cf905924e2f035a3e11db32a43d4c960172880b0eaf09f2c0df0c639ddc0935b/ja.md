```julia
detect_libstdcxx_version(max_minor_version::Int=30)
```

現在実行中の Julia プロセスを調べ、（リンクされている場合）どのバージョンの libstdc++ にリンクされているかを確認します。検索対象となる GLIBCXX の 3.4 系列の最新バージョンは `max_minor_version` です。
