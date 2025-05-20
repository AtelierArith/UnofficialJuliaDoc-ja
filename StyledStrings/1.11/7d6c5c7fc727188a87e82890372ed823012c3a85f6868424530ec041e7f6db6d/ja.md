[`Face`](@ref)は、テキストを表示するためのグラフィカル属性のコレクションです。Facesは、テキストがターミナルや他の場所でどのように表示されるかを制御します。

ほとんどの場合、[`Face`](@ref)は、*face name* シンボルとの一意の関連付けとしてグローバルなfaces辞書に保存され、この名前で参照されることが最も多いです。

# 属性

すべての属性はキーワードコンストラクタを介して設定でき、デフォルトは`nothing`です。

  * `height`（`Int`または`Float64`）：デシポイント（`Int`の場合）またはベースサイズの係数（`Float64`の場合）での高さ。
  * `weight`（`Symbol`）：最も薄いものから最も濃いものまでのシンボルの1つで、`:thin`、`:extralight`、`:light`、`:semilight`、`:normal`、`:medium`、`:semibold`、`:bold`、`:extrabold`、または`:black`。ターミナルでは、`:normal`より大きい重さは太字として表示され、可変明度テキストをサポートするターミナルでは、`:normal`より小さい重さは薄く表示されます。
  * `slant`（`Symbol`）：`:italic`、`:oblique`、または`:normal`のいずれかのシンボル。
  * `foreground`（`SimpleColor`）：テキストの前景色。
  * `background`（`SimpleColor`）：テキストの背景色。
  * `underline`、テキストの下線で、次のいずれかの形式を取ります：

      * `Bool`：テキストに下線を引くべきかどうか。
      * `SimpleColor`：この色でテキストに下線を引くべき。
      * `Tuple{Nothing, Symbol}`：シンボルによって設定されたスタイル（`:straight`、`:double`、`:curly`、`:dotted`、または`:dashed`のいずれか）を使用してテキストに下線を引くべき。
      * `Tuple{SimpleColor, Symbol}`：指定されたSimpleColorでテキストに下線を引き、前述のシンボルによって指定されたスタイルを使用するべき。
  * `strikethrough`（`Bool`）：テキストに打ち消し線を引くべきかどうか。
  * `inverse`（`Bool`）：前景色と背景色を反転させるべきかどうか。
  * `inherit`（`Vector{Symbol}`）：継承する顔の名前で、早い顔が優先されます。すべての顔は`:default`顔から継承します。
