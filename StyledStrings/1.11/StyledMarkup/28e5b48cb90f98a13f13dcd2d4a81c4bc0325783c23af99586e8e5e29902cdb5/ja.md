```
@styled_str -> AnnotatedString
```

スタイル付き文字列を構築します。文字列内の `{<specs>:<content>}` 構造は、カンマ区切りの仕様 `<specs>` のリストに従って `<content>` にフォーマットを適用します。各仕様は、フェイス名、インラインフェイス仕様、または `key=value` ペアの形式を取ることができます。値には、`{...}` でラップされている必要があります。これは、`=:{}` のいずれかの文字を含む場合です。

`$` を使った文字列補間は、通常の文字列と同じように機能しますが、引用符はエスケープする必要があります。フェイス、キー、および値も `$` で補間できます。

# 例

```julia
styled"The {bold:{italic:quick} {(foreground=#cd853f):brown} fox} jumped over the {link={https://en.wikipedia.org/wiki/Laziness}:lazy} dog"
```

# 拡張ヘルプ

このマクロは、次の EBNF 文法で説明できます。

```ebnf
styledstring = { styled | interpolated | escaped | plain } ;

specialchar = '{' | '}' | '$' | '\"' ;
anychar = [\u0-\u1fffff] ;
plain = { anychar - specialchar } ;
escaped = '\\', specialchar ;

interpolated = '$', ? expr ? | '$(', ? expr ?, ')' ;

styled = '{', ws, annotations, ':', content, '}' ;
content = { interpolated | plain | escaped | styled } ;
annotations = annotation | annotations, ws, ',', ws, annotation ;
annotation = face | inlineface | keyvalue ;
ws = { ' ' | '\t' | '\n' } ; (* ホワイトスペース *)

face = facename | interpolated ;
facename = [A-Za-z0-9_]+ ;

inlineface = '(', ws, [ faceprop ], { ws, ',', faceprop }, ws, ')' ;
faceprop = [a-z]+, ws, '=', ws, ( [^,)]+ | interpolated) ;

keyvalue = key, ws, '=', ws, value ;
key = ( [^\0${}=,:], [^\0=,:]* ) | interpolated ;
value = simplevalue | curlybraced | interpolated ;
curlybraced = '{' { escaped | plain } '}' ;
simplevalue = [^${},:], [^,:]* ;
```

上記の文法にエンコードされていない追加の規定は、`plain` が [`unescape_string`](@ref) に対する有効な入力であるべきであり、`specialchar` が保持されることです。

`inlineface` の上記の文法は簡略化されており、実際の実装はもう少し洗練されています。完全な動作は以下に示されています。

```ebnf
faceprop = ( 'face', ws, '=', ws, ( ? string ? | interpolated ) ) |
           ( 'height', ws, '=', ws, ( ? number ? | interpolated ) ) |
           ( 'weight', ws, '=', ws, ( symbol | interpolated ) ) |
           ( 'slant', ws, '=', ws, ( symbol | interpolated ) ) |
           ( ( 'foreground' | 'fg' | 'background' | 'bg' ),
               ws, '=', ws, ( simplecolor | interpolated ) ) |
           ( 'underline', ws, '=', ws, ( underline | interpolated ) ) |
           ( 'strikethrough', ws, '=', ws, ( bool | interpolated ) ) |
           ( 'inverse', ws, '=', ws, ( bool | interpolated ) ) |
           ( 'inherit', ws, '=', ws, ( inherit | interpolated ) ) ;

nothing = 'nothing' ;
bool = 'true' | 'false' ;
symbol = [^ ,)]+ ;
hexcolor = ('#' | '0x'), [0-9a-f]{6} ;
simplecolor = hexcolor | symbol | nothing ;

underline = nothing | bool | simplecolor | underlinestyled;
underlinestyled = '(', ws, ('' | nothing | simplecolor | interpolated), ws,
                  ',', ws, ( symbol | interpolated ), ws ')' ;

inherit = ( '[', inheritval, { ',', inheritval }, ']' ) | inheritval;
inheritval = ws, ':'?, symbol ;
```
