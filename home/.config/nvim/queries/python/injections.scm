; Inject Python into strings which contain a line like 'edge_api_version = "1"'
((string_content) @injection.content
  (#match? @injection.content "edge_api_version\\s*\\=\\s*\"\\d\"")
  (#set! injection.language "python"))
