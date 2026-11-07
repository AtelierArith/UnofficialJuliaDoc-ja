`Lexer` reads from an input stream and emits a single token each time `next_token` is called.

Ideally a lexer is stateless but some state is needed here for:

  * Disambiguating cases like x' (adjoint) vs 'x' (character literal)
  * Tokenizing code within string interpolations
