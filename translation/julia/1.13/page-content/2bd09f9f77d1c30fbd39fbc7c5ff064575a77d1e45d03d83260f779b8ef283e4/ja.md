# [Installation](@id man-installation)

Julia のインストール方法はいくつもあります。以下では、主なサポート対象プラットフォームごとに推奨される方法を紹介し、その後、特定の状況で役立つ可能性のある代替方法を説明します。

現在推奨されているのは、Juliaup を利用する方法です。以前、Juliaup を利用しない方法で Julia をインストールしていて、Juliaup を利用するインストール方法に切り替えたい場合は、以前の Julia のバージョンをすべてアンインストールし、`PATH` から Julia 関連の項目をすべて削除してから、以下のいずれかの方法で Julia をインストールすることをおすすめします。

## Windows

Windows では、Windows ストア [here](https://www.microsoft.com/store/apps/9NJNWW8PVKMN) から Julia を直接インストールできます。同じバージョンは、任意のシェルで次のコマンドを実行してインストールすることもできます。

```
winget install --name Julia --id 9NJNWW8PVKMN -e -s msstore
```

## Mac and Linux

Linux または Mac では、シェルで次のコマンドを実行して Julia をインストールできます。

```
curl -fsSL https://install.julialang.org | sh
```

### Command line arguments

Julia インストーラーには、さまざまなコマンドライン引数を渡せます。引数の構文は次のとおりです。

```bash
curl -fsSL https://install.julialang.org | sh -s -- <ARGS>
```

ここで、`<ARGS>` は、以下の引数のうち1つ以上に置き換えます。

  * `--yes`（または `-y`）：インストーラーを非対話モードで実行します。すべての設定値には、既定値またはコマンドライン引数で指定した値が使用されます。
  * `--default-channel=<NAME>`：Juliaup の既定のチャンネルを設定します。たとえば、`--default-channel lts` を指定すると、`lts` チャンネルがインストールされ、既定として設定されます。
  * `--add-to-path=<yes|no>`：Julia を `PATH` 環境変数に追加するかどうかを設定します。有効な値は `yes`（既定値）と `no` です。
  * `--background-selfupdate=<SECONDS>`：`<SECONDS>` が 0 より大きい値の場合に、Juliaup を自動更新する任意の CRON ジョブを設定します。この値は、CRON ジョブが新しい Juliaup のバージョンを確認する間隔を秒単位で指定します。既定値は 0 で、この場合 CRON ジョブは作成されません。
  * `--startup-selfupdate=<MINUTES>`：Julia の起動時に、新しい Juliaup のバージョンを確認する頻度を設定します。既定では 1440 分ごとに確認します。
  * `-p=<PATH>`（または `--path`）：Julia と Juliaup のバイナリのインストール先を設定します。既定値は `~/.juliaup` です。

## Alternative installation methods

以下の方法は、上記のインストール方法がどれもお使いのシステムで機能しない場合に限っておすすめします。

以下で紹介するインストール方法の中には、`juliaup` というパッケージのインストールを推奨するものがあります。ただし、これによってインストールされるのは Juliaup だけではなく、完全に機能する Julia システムです。

### App Installer (Windows)

システムで Windows ストアがブロックされている場合は、代替となる [MSIX App Installer](https://learn.microsoft.com/en-us/windows/msix/app-installer/app-installer-file-overview) ベースのセットアップを利用できます。App Installer 版を使うには、[this](https://install.julialang.org/Julia.appinstaller) ファイルをダウンロードし、ダブルクリックして開きます。同じバージョンは、PowerShell で次のコマンドを実行してインストールすることもできます。

```
Add-AppxPackage -AppInstallerFile https://install.julialang.org/Julia.appinstaller
```

### MSI Installer (Windows)

Windows ストア版も App Installer 版もお使いの Windows システムで動作しない場合は、MSI ベースのインストーラーも利用できます。ただし、このインストール方法には重大な制限があるため、ほかの方法が使えない場合を除き、一般にはおすすめしません。たとえば、この方法では Juliaup の自動更新機能がありません。64 ビット版の MSI インストーラーは [here](https://install.julialang.org/Julia-x64.msi) から、32 ビット版は [here](https://install.julialang.org/Julia-x86.msi) からダウンロードできます。

既定では、昇格権限を必要としないユーザー単位のインストールが行われます。シェルで次のコマンドを実行すれば、システム全体へのインストールもできます。

```
msiexec /i <PATH_TO_JULIA_MSI> ALLUSERS=1
```

### [Homebrew](https://brew.sh) (Mac and Linux)

brew がインストールされているシステムでは、シェルで次のコマンドを実行して Julia をインストールできます。

```
brew install juliaup
```

Juliaup の更新には、通常の brew コマンドを使う必要があります。

### [Arch Linux - AUR](https://aur.archlinux.org/packages/juliaup/) (Linux)

Arch Linux では、Juliaup を [in the Arch User Repository (AUR)](https://aur.archlinux.org/packages/juliaup/) から入手できます。

### [openSUSE Tumbleweed](https://get.opensuse.org/tumbleweed/) (Linux)

openSUSE Tumbleweed では、root 権限のあるシェルで次のコマンドを実行して Julia をインストールできます。

```sh
zypper install juliaup
```

### [cargo](https://crates.io/crates/juliaup/) (Windows, Mac and Linux)

Rust の cargo を使って Julia をインストールするには、次のコマンドを実行します。

```sh
cargo install juliaup
```
