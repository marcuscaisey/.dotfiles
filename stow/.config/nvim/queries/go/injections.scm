; extends

; Inject SQL into strings which start with SELECT, INSERT, or UPDATE
((raw_string_literal) @injection.content
  (#lua-match? @injection.content "^`%s*SELECT")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "sql"))

((raw_string_literal) @injection.content
  (#lua-match? @injection.content "^`%s*INSERT")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "sql"))

((raw_string_literal) @injection.content
  (#lua-match? @injection.content "^`%s*UPDATE")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "sql"))

((interpreted_string_literal) @injection.content
  (#lua-match? @injection.content "^\"%s*SELECT")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "sql"))

((interpreted_string_literal) @injection.content
  (#lua-match? @injection.content "^\"%s*INSERT")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "sql"))

((interpreted_string_literal) @injection.content
  (#lua-match? @injection.content "^\"%s*UPDATE")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "sql"))

; Inject Python into strings which contain a line like "api = 4.0.0"
((raw_string_literal) @injection.content
  (#match? @injection.content "api\\s*\\=\\s*(\"\\d\\.\\d\\.\\d\"|'\\d\\.\\d\\.\\d')\n")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "python"))
