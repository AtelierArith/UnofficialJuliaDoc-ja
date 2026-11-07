Bump several tokens, gluing them together into a single token

This is for use in special circumstances where the parser needs to resolve lexing ambiguities. There's no special whitespace handling — bump any whitespace if necessary with bump_trivia.
