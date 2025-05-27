# UnofficialJuliaDoc-ja

Julia 公式ドキュメント日本語翻訳化プロジェクト

English follows Japanese

## 使用方法

下記のコマンドを実行するだけです．

```sh
git clone https://github.com/AtelierArith/UnofficialJuliaDoc-ja.git
cd UnofficialJuliaDoc-ja
git submodule update --init --recursive
bash run.sh
julia -e 'using LiveServer; serve(dir="julia/doc/_build/html/ja")'
```

上記のコマンドによって下記が実行されます．

1. UnofficialJuliaDoc-ja のクローン
1. `julia` リポジトリ v1.11.5 をクローン
1. `assets` 以下にあるファイルを `julia/doc` に適用. `julia/doc/Project.toml`, `julia/doc/Manifest.toml`, `julia/doc/make.jl` が更新されます．
1. `make -C julia && make -C julia/doc` が実行されます．

上記の手順を踏むことで下記が成果物として得られます：

`julia/doc/_build/html/ja` に翻訳された日本語ドキュメントが生成されます．

翻訳結果は使用した OpenAI API の品質に左右されます．翻訳結果に不備・不満がある場合は `translation` ディレクトリにある `ja.md` を修正してください．`original.md` は編集・修正しないでください．

### Appendix: 他の言語に翻訳する場合

1. OpenAI API キーを取得. OpenAI.jl の README.md を参考にすること
1. 環境変数 `OPENAI_API_KEY=sk-<blah>` を設定
1. https://github.com/AtelierArith/UnofficialJuliaDoc-ja/blob/8fa08fbf6392ed3f8e136a5d2edd53a5ab402b9e/assets/make_1.11.5.jl#L18 にある `:ja` を変更. `:ja` は [ISO 639 language codes](https://en.wikipedia.org/wiki/List_of_ISO_639_language_codes) における日本語(Japanese)に対応します．
1. `bash run.sh` を実行

---

# UnofficialJuliaDoc-ja (English)

Julia Official Documentation Japanese Translation Project

## Usage

Simply run the following commands:

```sh
git clone https://github.com/AtelierArith/UnofficialJuliaDoc-ja.git
cd UnofficialJuliaDoc-ja
git submodule update --init --recursive
bash run.sh
julia -e 'using LiveServer; serve(dir="julia/doc/_build/html/ja")'
```

The above commands will execute the following:

1. Clone UnofficialJuliaDoc-ja
1. Clone `julia` repository v1.11.5
1. Apply files under `assets` to `julia/doc`. This will update `julia/doc/Project.toml`, `julia/doc/Manifest.toml`, and `julia/doc/make.jl`.
1. Execute `make -C julia && make -C julia/doc`

By following the above steps, you will obtain the following output:

Translated Japanese documentation will be generated in `julia/doc/_build/html/ja`.

The translation quality depends on the OpenAI API used. If there are issues or dissatisfaction with the translation results, please modify `ja.md` in the `translation` directory. Do not edit or modify `original.md`.

### Appendix: Translating to Other Languages

1. Obtain an OpenAI API key. Refer to the OpenAI.jl README.md for guidance
1. Set the environment variable `OPENAI_API_KEY=sk-<blah>`
1. Change `:ja` in https://github.com/AtelierArith/UnofficialJuliaDoc-ja/blob/8fa08fbf6392ed3f8e136a5d2edd53a5ab402b9e/assets/make_1.11.5.jl#L18. `:ja` corresponds to Japanese in [ISO 639 language codes](https://en.wikipedia.org/wiki/List_of_ISO_639_language_codes).
1. Run `bash run.sh`

