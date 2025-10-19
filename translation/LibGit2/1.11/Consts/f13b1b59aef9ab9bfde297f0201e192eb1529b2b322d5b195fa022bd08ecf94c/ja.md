設定ファイルの優先度レベル。

これらの優先度レベルは、gitで設定エントリを検索する際の自然なエスカレーションロジック（高いものから低いものへ）に対応しています。

  * `CONFIG_LEVEL_DEFAULT` - 利用可能な場合は、グローバル、XDG、およびシステム設定ファイルを開きます。
  * `CONFIG_LEVEL_PROGRAMDATA` - ポータブルgitとの互換性のため、Windows全体で
  * `CONFIG_LEVEL_SYSTEM` - システム全体の設定ファイル；Linuxシステムでは`/etc/gitconfig`
  * `CONFIG_LEVEL_XDG` - XDG互換の設定ファイル；通常は`~/.config/git/config`
  * `CONFIG_LEVEL_GLOBAL` - ユーザー固有の設定ファイル（グローバル設定ファイルとも呼ばれる）；通常は`~/.gitconfig`
  * `CONFIG_LEVEL_LOCAL` - リポジトリ固有の設定ファイル；非ベアリポジトリでは`$WORK_DIR/.git/config`
  * `CONFIG_LEVEL_WORKTREE` - ワークツリー固有の設定ファイル；`$GIT_DIR/config.worktree`
  * `CONFIG_LEVEL_APP` - アプリケーション固有の設定ファイル；アプリケーションによって自由に定義される
  * `CONFIG_HIGHEST_LEVEL` - 利用可能な設定ファイルの中で最も高いレベルを表します（つまり、実際に読み込まれる最も特定的な設定ファイル）
