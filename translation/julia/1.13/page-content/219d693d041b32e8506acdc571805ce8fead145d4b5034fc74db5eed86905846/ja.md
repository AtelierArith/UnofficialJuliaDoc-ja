# Using AI agents to work on Julia

> ![WARNING] PRに提出するコードの責任は、提出者であるあなたにあります。理解していないコードや、juliaのPRに求められる通常の品質基準を満たさないAI生成コードを含むPRは提出しないでください。


このページでは、Juliaで作業するAIエージェントを設定する際のベストプラクティスを説明します。一般的なタスクで有効なプロンプト指示をほかにも見つけた場合は、AGENTS.mdに追加するPRの提出をご検討ください。

## Google Jules

`Initial Setup`の設定には、以下を使用してください。

```
curl -fsSL https://install.julialang.org | sh -s -- -y --default-channel nightly
. /home/swebot/.profile
```

Julesはインターネットにアクセスできるため、プロンプトに課題や追加ドキュメントへのリンクを含めることができます。

## OpenAI Codex

以下を設定してください。

セットアップスクリプト

```
apt update
apt install less
curl -fsSL https://install.julialang.org | sh -s -- -y --default-channel nightly
source /root/.bashrc
make -C /workspace/julia/doc alldeps JULIA_EXECUTABLE="/root/.juliaup/bin/julia"
make -C /workspace/julia/test install-revise-deps JULIA_EXECUTABLE="/root/.juliaup/bin/julia"
```

環境変数

```
JULIA_PKG_OFFLINE=true
```

Codexは初期セットアップ後にインターネットへアクセスできないため、追加情報をリンクで渡すことはできません。関連するテキストはプロンプトにコピーする必要があります。

なお、Codexは呼び出しのたびに環境を再構築します。そのため、待ち時間が大幅に増えることがあります。Codexは、1回の実行で解決できる明確に定義されたタスクに最適です。
