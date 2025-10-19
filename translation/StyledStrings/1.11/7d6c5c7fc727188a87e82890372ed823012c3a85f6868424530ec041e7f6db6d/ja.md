A [`Face`](@ref) は、テキストを表示するためのグラフィカル属性のコレクションです。フェイスは、テキストがターミナルや他の場所でどのように表示されるかを制御します。

ほとんどの場合、[`Face`](@ref) はグローバルなフェイス辞書に *フェイス名* シンボルとのユニークな関連付けとして保存され、この名前で参照されることが最も多いです。

# 属性

すべての属性はキーワードコンストラクタを介して設定でき、デフォルトは `nothing` です。

  * `height` (an `Int` or `Float64`): デシポイント（`Int` の場合）またはベースサイズの因子（`Float64` の場合）での高さ。
  * `weight` (a `Symbol`): 最も薄いものから最も濃いものまでのシンボル `:thin`, `:extralight`, `:light`, `:semilight`, `:normal`, `:medium`, `:semibold`, `:bold`, `:extrabold`, または `:black` のいずれか。ターミナルでは、`:normal` より大きい重さは太字として表示され、可変明度テキストをサポートするターミナルでは、`:normal` より小さい重さは薄く表示されます。
  * `slant` (a `Symbol`): シンボル `:italic`, `:oblique`, または `:normal` のいずれか。
  * `foreground` (a `SimpleColor`): テキストの前景色。
  * `background` (a `SimpleColor`): テキストの背景色。
  * `underline`, テキストの下線で、次のいずれかの形式を取ります：

      * a `Bool`: テキストに下線を引くべきかどうか。
      * a `SimpleColor`: この色でテキストに下線を引くべき。
      * a `Tuple{Nothing, Symbol}`: シンボルによって設定されたスタイル（`:straight`, `:double`, `:curly`, `:dotted`, または `:dashed` のいずれか）を使用してテキストに下線を引くべき。
      * a `Tuple{SimpleColor, Symbol}`: 指定された SimpleColor でテキストに下線を引き、前述のシンボルによって指定されたスタイルを使用するべき。
  * `strikethrough` (a `Bool`): テキストに打ち消し線を引くべきかどうか。
  * `inverse` (a `Bool`): 前景色と背景色を反転させるべきかどうか。
  * `inherit` (a `Vector{Symbol}`): 継承するフェイスの名前で、早いフェイスが優先されます。すべてのフェイスは `:default` フェイスを継承します。
