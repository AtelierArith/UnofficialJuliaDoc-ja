# [Installation](@id man-installation)

Juliaをインストールする方法はいくつかあります。以下のセクションでは、主要なサポートプラットフォームごとに推奨される方法を強調し、その後、特定の状況で役立つかもしれない代替方法を紹介します。

現在のインストール推奨は、Juliaupに基づくソリューションです。以前にJuliaをJuliaupに基づかない方法でインストールした場合、システムをJuliaupに基づくインストールに切り替えたい場合は、すべての以前のJuliaバージョンをアンインストールし、`PATH`変数からJuliaに関連するものをすべて削除し、その後、以下に記載されている方法のいずれかでJuliaをインストールすることをお勧めします。

## Windows

Windowsでは、JuliaはWindowsストアから直接インストールできます [here](https://www.microsoft.com/store/apps/9NJNWW8PVKMN)。同じバージョンを実行することでもインストールできます。

```
winget install julia -s msstore
```

任意のシェルで。

## Mac and Linux

Juliaは、LinuxまたはMacで実行することでインストールできます。

```
curl -fsSL https://install.julialang.org | sh
```

シェル内で。

### Command line arguments

Juliaインストーラーにさまざまなコマンドライン引数を渡すことができます。インストーラー引数の構文は

```bash
curl -fsSL https://install.julialang.org | sh -s -- <ARGS>
```

ここで `<ARGS>` は、以下の引数の1つ以上に置き換えられるべきです：

  * `--yes` (または `-y`): インストーラーを非対話モードで実行します。すべての設定値はデフォルト値またはコマンドライン引数として指定された値を使用します。
  * `--default-channel=<NAME>`: Juliaupのデフォルトチャネルを設定します。例えば、`--default-channel lts`は`lts`チャネルをインストールし、それをデフォルトとして設定します。
  * `--add-to-path=<yes|no>`: Juliaを`PATH`環境変数に追加するかどうかを設定します。有効な値は`yes`（デフォルト）と`no`です。
  * `--background-selfupdate=<SECONDS>`: `<SECONDS>` が 0 より大きい場合に、Juliaup を自動更新するオプションの CRON ジョブを構成します。実際の値は、CRON ジョブが新しい Juliaup バージョンを確認するために実行される頻度を秒単位で制御します。デフォルト値は 0 であり、つまり CRON ジョブは作成されません。
  * `--startup-selfupdate=<MINUTES>`: Juliaが起動時にJuliaupの新しいバージョンをチェックする頻度を設定します。デフォルトは1440分ごとです。
  * `-p=<PATH>` (または `--path`): JuliaおよびJuliaupのバイナリがインストールされる場所を設定します。デフォルトは `~/.juliaup` です。

## Alternative installation methods

上記のインストール方法があなたのシステムで機能しない場合に限り、以下の方法を推奨します。

以下に説明するインストール方法のいくつかでは、`juliaup`というパッケージのインストールを推奨しています。ただし、これは完全に機能するJuliaシステムをインストールするものであり、単にJuliaupだけではありません。

### App Installer (Windows)

If the Windows Store is blocked on a system, we have an alternative [MSIX App Installer](https://learn.microsoft.com/en-us/windows/msix/app-installer/app-installer-file-overview) based setup. To use the App Installer version, download [this](https://install.julialang.org/Julia.appinstaller) file and open it by double clicking on it.

### MSI Installer (Windows)

Windows StoreやApp InstallerのバージョンがあなたのWindowsシステムで動作しない場合、MSIベースのインストーラーを使用することもできます。このインストール方法には深刻な制限があり、他の方法が機能しない場合を除いて一般的には推奨されません。たとえば、このインストール方法ではJuliaupの自動更新メカニズムはありません。MSIインストーラーの64ビット版は[here](https://install.julialang.org/Julia-x64.msi)からダウンロードでき、32ビット版は[here](https://install.julialang.org/Julia-x86.msi)からダウンロードできます。

デフォルトでは、インストールは昇格を必要としないユーザーごとのインストールになります。また、次のコマンドをシェルから実行することでシステムインストールを行うこともできます：

```
msiexec /i <PATH_TO_JULIA_MSI> ALLUSERS=1
```

### [Homebrew](https://brew.sh) (Mac and Linux)

brewを使用しているシステムでは、次のコマンドを実行してJuliaをインストールできます。

```
brew install juliaup
```

シェル内で。標準のbrewコマンドを使用してJuliaupを更新する必要があることに注意してください。

### [Arch Linux - AUR](https://aur.archlinux.org/packages/juliaup/) (Linux)

Arch Linuxでは、Juliaupは利用可能です [in the Arch User Repository (AUR)](https://aur.archlinux.org/packages/juliaup/)。

### [openSUSE Tumbleweed](https://get.opensuse.org/tumbleweed/) (Linux)

openSUSE Tumbleweedでは、次のコマンドを実行してJuliaをインストールできます。

```sh
zypper install juliaup
```

ルート権限を持つシェルで。

### [cargo](https://crates.io/crates/juliaup/) (Windows, Mac and Linux)

Rustのcargoを使用してJuliaをインストールするには、次のコマンドを実行します:

```sh
cargo install juliaup
```
