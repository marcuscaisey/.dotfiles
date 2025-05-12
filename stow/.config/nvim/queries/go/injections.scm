; extends

; Inject sql into strings which start with SELECT, INSERT, or UPDATE
(
  [
    (raw_string_literal_content)
    (interpreted_string_literal_content)
  ] @injection.content
  (#match? @injection.content "^\\s*(SELECT|UPDATE|DELETE)")
  (#set! injection.language "sql"))

; Inject python into raw strings which contain a line like "api = 4.0.0"
((raw_string_literal_content) @injection.content
  (#match? @injection.content "api\\s*\\=\\s*(\"\\d\\.\\d\\d?\\.\\d\"|'\\d\\.\\d\\d?\\.\\d')\n")
  (#set! injection.language "python"))

; Inject python into raw strings which contain a line like 'edge_api_version = "1"'
((raw_string_literal_content) @injection.content
  (#match? @injection.content "edge_api_version\\s*\\=\\s*\"\\d\"\n")
  (#set! injection.language "python"))
