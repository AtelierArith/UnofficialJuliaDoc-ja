# UnofficialJuliaDoc-ja

Julia 公式ドキュメント日本語翻訳化プロジェクト

## 使用方法

```sh
git clone https://github.com/AtelierArith/UnofficialJuliaDoc-ja.git
cd UnofficialJuliaDoc-ja
git submodule update --init --recursive
bash run.sh
```

上記のコマンドによって下記が実行されます．

1. UnofficialJuliaDocJP のクローン
1. `julia` リポジトリ v1.11.5 をクローン
1. `assets` 以下にあるファイルを `julia/doc` に適用. julia/doc/Project.toml, julia/doc/Manifest.toml, julia/doc/make.jl が更新されます．
1. `make -C julia && make -C julia/doc` が実行されます．

上記の手順を踏むことで下記が成果物として得られます：

`julia/doc/_build/html/ja` に翻訳された日本語ドキュメントが生成されます．

翻訳結果は使用した OpenAI API の品質に左右されます．翻訳結果に不備・不満がある場合は `translation` ディレクトリにある `ja.md` を修正してください．`original.md` は編集・修正しないでください．
