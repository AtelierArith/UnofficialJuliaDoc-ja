# Using AI agents to work on Julia

> ![WARNING] PRで提出するコードには、提出者自身が責任を負います。内容を理解していないコードや、JuliaのPRに求められる通常の品質基準を満たさないAI生成コードを含むPRは提出しないでください。


このページでは、Juliaで作業するAIエージェントを設定する際のベストプラクティスを説明します。一般的なタスクで役立つ追加のプロンプト指示があれば、AGENTS.mdへの追加をPRで提案してください。

## Google Jules

以下を`Initial Setup`の設定に使用してください。

```
curl -fsSL https://install.julialang.org | sh -s -- -y --default-channel nightly
. /home/swebot/.profile
```

Julesはインターネットにアクセスできるため、プロンプトに課題や追加ドキュメントへのリンクを含めることができます。

## OpenAI Codex

次の項目を設定してください。

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

Codexは初期セットアップ後にインターネットへアクセスできないため、追加情報をリンクで渡すことはできません。関連するテキストをプロンプトにコピーする必要があります。

なお、Codexは呼び出しのたびに環境を再構築するため、大幅な遅延が発生することがあります。Codexは、1回の実行で解決できる明確に定義されたタスクに適しています。
