# UnofficialJuliaDoc-ja

Julia 1.13.3 の公式ドキュメントを日本語へ翻訳するプロジェクトです。English follows Japanese.

## 実行前の準備

Julia 本体をソースからビルドできる開発環境が必要です。初回実行では Julia 本体もビルドします。

General に登録された DocstringTranslation.jl 0.1.8 を使用します。ローカルチェックアウトは不要です。`assets/Project_1.13.3.toml` の compat は `"0.1.8"`、`assets/Manifest_1.13.3.toml` の解決済みバージョンは 0.1.8 です。`run.sh` は毎回これらのファイルを `julia/doc/translation-env/` にコピーするため、コピー先だけを編集しても次回実行時に上書きされます。

初めてチェックアウトする場合：

```sh
git clone https://github.com/AtelierArith/UnofficialJuliaDoc-ja.git
cd UnofficialJuliaDoc-ja
git submodule update --init --recursive
git -C julia fetch --tags origin
git -C julia checkout v1.13.3
```

リポジトリ直下に `.env` を用意します。既にある場合は、そのファイルを使用します。

```dotenv
OPENAI_API_KEY=your-api-key
DOCSTRINGTRANSLATION_CONCURRENCY=32
DOCSTRINGTRANSLATION_MODEL=gpt-6-luna
DOCSTRINGTRANSLATION_FALLBACK_MODEL=gpt-6.1-sol
```

`.env` は DotEnv.jl で読み込みます。シェルで設定済みの環境変数が優先されます。

## 通常の実行

リポジトリ直下で実行します。

```sh
bash run.sh
```

docstring と Markdown ページを既定32並列の async 処理で翻訳し、HTML を生成します。Julia のスレッド数を増やす必要はありません。非公開 API や BLAS/LAPACK のような入れ子モジュールも、実際の docstring メタデータから先読みします。HTTP の接続プールも並列数に揃えます。２回目以降は成功済みの翻訳キャッシュを再利用し、未翻訳・前回失敗した箇所を翻訳します。

並列数を変更する例：

```sh
DOCSTRINGTRANSLATION_CONCURRENCY=32 bash run.sh
```

翻訳結果は `translation/`、HTML は `julia/doc/_build/html/ja/` に生成されます。`run.sh` は翻訳用の `make.jl` を一時的に適用し、終了時にはビルドの成否にかかわらず元へ戻します。

生成した HTML を閲覧する例：

```sh
python3 -m http.server 8000 --directory julia/doc/_build/html/ja
```

ブラウザーで <http://localhost:8000/> を開いてください。

## API を呼ばずにビルドを確認

```sh
DOCSTRINGTRANSLATION_CACHE_ONLY=1 bash run.sh
```

既存の翻訳キャッシュを使用し、キャッシュのない箇所は原文で表示します。新しい翻訳は生成しません。

## 翻訳を最初からやり直す

実行中のビルドがない状態で、リポジトリ直下から実行します。手修正を含む翻訳キャッシュがすべて削除されます。

```sh
rm -rf -- ./translation
bash run.sh
```

訳文を手で修正する場合は `translation/` 内の `ja.md` を編集してください。`original.md` は編集しません。

## モデルの切り替えと費用

通常は GPT-6 Luna を使い、最大３回の試行後も失敗した文書だけ GPT-6.1 Sol（medium）で１回再試行します。成功済みキャッシュの再翻訳は行いません。Sol でも失敗した場合は原文でビルドを続行します。

`.env` の `DOCSTRINGTRANSLATION_MODEL` と `DOCSTRINGTRANSLATION_FALLBACK_MODEL` でモデルを設定できます。追加モデルを無効にする場合は `DOCSTRINGTRANSLATION_FALLBACK_MODEL=none` を指定してください。通常料金（キャッシュ割引なし）の同一トークン数では Sol は Luna の約20倍なので、失敗した文書に限定して使用します。[比較試験と失敗原因の調査](docs/translation-model-evaluation.md)も参照してください。

API の読み取りタイムアウトは既定180秒（整数）です。必要なら `.env` の `DOCSTRINGTRANSLATION_REQUEST_TIMEOUT_SECONDS` で変更できます。

## 翻訳の失敗を確認

翻訳に失敗しても、その箇所は原文で表示してビルドを続行します。不合格の訳文や原文へのフォールバックは、翻訳済みキャッシュに保存しません。

警告には対象・原因が表示され、構造検証の再試行では試行回数も報告します。ビルド末尾に docstring とページを分けて失敗件数が集計されます。１件は docstring 全体または Markdown １ファイルで、段落数や再試行回数ではありません。構造検証に失敗した応答は、次のディレクトリに診断用ファイルとして保存します。

```text
julia/doc/_build/translation-errors/
```

各試行の `original.md`（原文）、`protected.md`（API に送った保護済み文書）、`response.md`（API 応答）、`error.txt`（対象と不一致の詳細）を比較できます。診断ファイルはプロセス終了後も残ります。

否定表現・語順・強調・段落の自然な変更は許容し、コード・数式・リンクや参照ID、表のセルやリスト項目の境界を検証します。別言語へ翻訳する場合は `assets/make_1.13.3.jl` の `lang = "ja"` を変更してください。

## Julia の新しい系列へのアップデートガイド

以下は **1.13.3 → 1.14.0** を例にした手順です。対象タグが公開されてから、実際のバージョン番号に置き換えてください。実行中のビルドが終了した状態で作業します。

### 1. Julia のタグと現在の変更を確認

```sh
JULIA_OLD_VERSION=1.13.3
JULIA_NEW_VERSION=1.14.0

git -C julia status --short
git -C julia fetch --tags origin
git -C julia show "v${JULIA_NEW_VERSION}:VERSION"
```

`git status` にソースの手修正がある場合は、その変更を保持したうえでタグを切り替えてください。

```sh
git -C julia checkout "v${JULIA_NEW_VERSION}"
cat julia/VERSION
```

`julia/` の新しいコミットへの変更も、このリポジトリで記録する対象です。

### 2. 新バージョン用の assets を作成

旧版の翻訳用ファイルは残し、新しい名前で用意します。

```sh
cp "assets/Project_${JULIA_OLD_VERSION}.toml" "assets/Project_${JULIA_NEW_VERSION}.toml"
git -C julia show "v${JULIA_OLD_VERSION}:doc/make.jl" > "/tmp/julia-make-${JULIA_OLD_VERSION}.jl"
git -C julia show "v${JULIA_NEW_VERSION}:doc/make.jl" > "assets/make_${JULIA_NEW_VERSION}.jl"
diff -u "/tmp/julia-make-${JULIA_OLD_VERSION}.jl" "assets/make_${JULIA_NEW_VERSION}.jl"
```

**新しい上流の `doc/make.jl` を土台にして**、旧 `assets/make_*.jl` の翻訳用変更を移植します。旧版のファイルのバージョン番号だけを書き換える方法では、Julia 本家のビルド手順・ページ構成・stdlib の配置変更を取り込めません。

移植・確認する箇所：

- 上流の buildroot・stdlib パス・Documenter 用 depot・依存セットアップを維持する。
- 翻訳用環境を `julia/doc/translation-env/` に切り替える。
- DotEnv によるリポジトリ直下の `.env` の読み込みと、モデル・並列数・診断先の設定を移植する。
- `@switchlang!`、翻訳キャッシュの指定、docstring の async 事前翻訳を移植する。共有ヘルパー `assets/docstring_prefetch.jl` の読み込みも維持する。
- 新しいソースページが配置された後、`makedocs` の前にページの並列翻訳を行う。
- 言語・出力先 `ja`、翻訳失敗時の集計、doctest/linkcheck/warnonly の設定を確認する。
- 上流で追加・削除されたページ、stdlib、`makedocs` 引数を確認する。ビルドのエラーを一律に警告へ変換せず、翻訳失敗と元の文書・コードの問題を区別する。

### 3. Project と Manifest を対象 Julia で更新

`assets/Project_${JULIA_NEW_VERSION}.toml` を編集します。

- `[compat] julia` を新しいバージョンに合わせる。
- Documenter などの依存・互換条件を、新しい上流 `make.jl` と照合する。
- DocstringTranslation の compat を確認する。並列翻訳・モデルフォールバック API と、チェックアウト先に依存しないページキャッシュキー、Markdown の往復で崩れない書き出しを備えた登録済み 0.1.8 以降を使用する。開発目的で `[sources]` を追加した場合は、登録版へ戻す際に上書きを外して Manifest を再解決する。

Juliaup を使用している場合の依存解決例です。**対象バージョンの Julia** で新しい Manifest を生成します。

```sh
juliaup add "$JULIA_NEW_VERSION"
julia "+${JULIA_NEW_VERSION}" --startup-file=no -e '
using Pkg
version = ARGS[1]
mktempdir() do env_dir
    cp("assets/Project_$(version).toml", joinpath(env_dir, "Project.toml"))
    Pkg.activate(env_dir)
    Pkg.resolve()
    cp(joinpath(env_dir, "Manifest.toml"), "assets/Manifest_$(version).toml"; force=true)
end
' "$JULIA_NEW_VERSION"
```

旧版の Manifest のコピーや手書きのバージョン置換で済ませず、依存解決に成功することを確認します。

### 4. run.sh と README の参照を切り替え

`run.sh` の次の箇所を新しいバージョンへ変更します。

- `julia/VERSION` の期待値。
- `Project_*.toml`、`Manifest_*.toml`、`make_*.jl` の参照名。

`make.jl` を終了時に復元する trap は維持します。README の対象バージョン、タグ、依存バージョンの説明も更新してください。

### 5. 段階的に動作確認

```sh
bash -n run.sh
git diff --check
julia "+${JULIA_NEW_VERSION}" --startup-file=no test/docstring_prefetch.jl
DOCSTRINGTRANSLATION_CACHE_ONLY=1 bash run.sh
```

まず API を使わず、新しい Julia 本体とドキュメント全体がビルドできること、`julia/doc/_build/html/ja/index.html` が生成されることを確認します。

次に API を有効にして確認します。

```sh
DOCSTRINGTRANSLATION_CACHE_ONLY=0 bash run.sh
```

確認する内容：

- 実際に選択された DocstringTranslation のソース・モデルが意図どおりか。
- キャッシュのある箇所が再利用され、新しい原文だけが翻訳されるか。
- Luna 失敗時に Sol へ切り替わり、両方の失敗時には原文で続行するか。
- docstring とページの失敗件数、診断ファイル、生成された HTML のコード・リンク・表・参照ID。
- `julia/doc/make.jl` が実行前の内容に戻っているか。

DocstringTranslation 自体を変更した場合は、そのリポジトリでも対象 Julia による `Pkg.test()` を実行します。今回のような検証・復元の不具合には、実 API を呼ばない回帰テストを追加してください。

更新時も `translation/` は保持して実行します。互換性のある原文ハッシュのキャッシュを再利用できます。全訳し直す場合だけ、前述のキャッシュ初期化手順を使ってください。

---

## English

This project translates Julia 1.13.3 documentation into Japanese. A Julia source-build toolchain is required; the first run builds Julia itself.

This project uses DocstringTranslation.jl 0.1.8 from General; no local package checkout is required. `assets/Project_1.13.3.toml` sets compatibility to `"0.1.8"`, and the accompanying Manifest resolves version 0.1.8. `run.sh` overwrites `julia/doc/translation-env/` from these assets on each run.

For a new checkout:

```sh
git clone https://github.com/AtelierArith/UnofficialJuliaDoc-ja.git
cd UnofficialJuliaDoc-ja
git submodule update --init --recursive
git -C julia fetch --tags origin
git -C julia checkout v1.13.3
```

Create `.env` at the repository root (or use the existing file):

```dotenv
OPENAI_API_KEY=your-api-key
DOCSTRINGTRANSLATION_CONCURRENCY=32
DOCSTRINGTRANSLATION_MODEL=gpt-6-luna
DOCSTRINGTRANSLATION_FALLBACK_MODEL=gpt-6.1-sol
```

DotEnv.jl loads the file; existing environment variables take precedence. Run from the repository root:

```sh
bash run.sh
```

Docstrings and pages use 32 asynchronous workers by default. Change the limit with `DOCSTRINGTRANSLATION_CONCURRENCY=32 bash run.sh`; additional Julia threads are not required; the HTTP connection pool is configured to match the worker count. Successful translations are cached in `translation/`, and HTML is generated in `julia/doc/_build/html/ja/`. Later runs reuse successful translations and retry uncached work. The original `julia/doc/make.jl` is restored on exit, including on build failure.

Preview the result:

```sh
python3 -m http.server 8000 --directory julia/doc/_build/html/ja
```

Open <http://localhost:8000/>. To build without API calls, using cached translations and original text for cache misses:

```sh
DOCSTRINGTRANSLATION_CACHE_ONLY=1 bash run.sh
```

To start translation from scratch, with no build currently running (this deletes all translation caches, including manual edits):

```sh
rm -rf -- ./translation
bash run.sh
```

Luna is the primary model (up to three attempts); only exhausted failures use GPT-6.1 Sol with medium reasoning for one additional attempt. Configure `DOCSTRINGTRANSLATION_MODEL` and `DOCSTRINGTRANSLATION_FALLBACK_MODEL` in `.env`; use `none` to disable the second model. API requests have a 180-second HTTP read timeout, configurable with `DOCSTRINGTRANSLATION_REQUEST_TIMEOUT_SECONDS`.

If both models fail, translations fall back to original text, report the source/reason and validation retry counts, and contribute to the final failure count. Fallbacks are never saved as successful translations. Validation diagnostics persist under `julia/doc/_build/translation-errors/`: compare `original.md`, `protected.md`, `response.md` and `error.txt` for each attempt.

Natural word order, emphasis and adjacent prose paragraph changes are allowed; code, mathematics, links/reference IDs and structural container boundaries remain protected. Edit cached `ja.md` files to improve translations; leave `original.md` unchanged. For another language, change `lang = "ja"` in `assets/make_1.13.3.jl`.

### Updating to another Julia release

Use the Japanese update guide above as the full checklist (example: 1.13.3 to a future 1.14.0). Start after the current build finishes and the target tag exists. Base the new `assets/make_*.jl` on the **new upstream** `doc/make.jl`, then port translation changes; retain upstream path/stdlib/page updates. Update Project compatibility and resolve a new Manifest with the target Julia runtime. Switch the version guard and three asset references in `run.sh`, and record the updated Julia submodule commit. Verify a cache-only full build before enabling API translation, inspect failure counts and HTML, and retain existing translation caches. Run DocstringTranslation tests if its code changes.
