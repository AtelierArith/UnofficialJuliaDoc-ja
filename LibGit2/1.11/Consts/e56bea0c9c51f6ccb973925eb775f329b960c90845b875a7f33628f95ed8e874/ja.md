設定ファイルの優先度。

これらの優先度は、Git が設定項目を検索する際の自然な優先順位（高い順）に対応しています。

  * `CONFIG_LEVEL_DEFAULT` - グローバル、XDG、システムの各設定ファイルが存在する場合は、それらを開きます。
  * `CONFIG_LEVEL_PROGRAMDATA` - Windows では、portable git との互換性のため、システム全体に適用されます。
  * `CONFIG_LEVEL_SYSTEM` - システム全体の設定ファイル。Linux システムでは `/etc/gitconfig`
  * `CONFIG_LEVEL_XDG` - XDG 互換の設定ファイル。通常は `~/.config/git/config`
  * `CONFIG_LEVEL_GLOBAL` - ユーザー固有の設定ファイル（グローバル設定ファイルとも呼ばれます）。通常は `~/.gitconfig`
  * `CONFIG_LEVEL_LOCAL` - リポジトリ固有の設定ファイル。ベアでないリポジトリでは `$WORK_DIR/.git/config`
  * `CONFIG_LEVEL_WORKTREE` - ワークツリー固有の設定ファイル。`$GIT_DIR/config.worktree`
  * `CONFIG_LEVEL_APP` - アプリケーション固有の設定ファイル。アプリケーションが自由に定義します。
  * `CONFIG_HIGHEST_LEVEL` - 利用可能な設定ファイルのうち最も高い優先度を表します（つまり、実際に読み込まれる設定ファイルの中で最も具体的なもの）。
