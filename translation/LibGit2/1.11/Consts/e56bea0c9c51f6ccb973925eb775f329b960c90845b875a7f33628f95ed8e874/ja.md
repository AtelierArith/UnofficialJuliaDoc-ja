設定ファイルの優先度。

これらの優先度は、git で設定項目を検索する際の自然な優先順位（高いものから低いものへ）に対応しています。

  * `CONFIG_LEVEL_DEFAULT` - 利用可能な場合は、グローバル、XDG、システムの各設定ファイルを開きます。
  * `CONFIG_LEVEL_PROGRAMDATA` - Windows では、portable git との互換性のためのシステム全体の設定ファイル
  * `CONFIG_LEVEL_SYSTEM` - システム全体の設定ファイル。Linux システムでは `/etc/gitconfig`
  * `CONFIG_LEVEL_XDG` - XDG 互換の設定ファイル。通常は `~/.config/git/config`
  * `CONFIG_LEVEL_GLOBAL` - ユーザー固有の設定ファイル（グローバル設定ファイルとも呼ばれます）。通常は `~/.gitconfig`
  * `CONFIG_LEVEL_LOCAL` - リポジトリ固有の設定ファイル。ベアでないリポジトリでは `$WORK_DIR/.git/config`
  * `CONFIG_LEVEL_WORKTREE` - ワークツリー固有の設定ファイル。`$GIT_DIR/config.worktree`
  * `CONFIG_LEVEL_APP` - アプリケーション固有の設定ファイル。アプリケーションが自由に定義します
  * `CONFIG_HIGHEST_LEVEL` - 利用可能な設定ファイルのうち、実際に読み込まれる最も具体的な設定ファイル（つまり、利用可能な設定ファイルの最高優先度）を表します。
