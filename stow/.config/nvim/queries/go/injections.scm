; extends

((raw_string_literal) @sql (#lua-match? @sql "^`%s*SELECT") (#offset! @sql 0 1 0 -1))
((raw_string_literal) @sql (#lua-match? @sql "^`%s*INSERT") (#offset! @sql 0 1 0 -1))
((raw_string_literal) @sql (#lua-match? @sql "^`%s*UPDATE") (#offset! @sql 0 1 0 -1))

((interpreted_string_literal) @sql (#lua-match? @sql "^\"%s*SELECT") (#offset! @sql 0 1 0 -1))
((interpreted_string_literal) @sql (#lua-match? @sql "^\"%s*INSERT") (#offset! @sql 0 1 0 -1))
((interpreted_string_literal) @sql (#lua-match? @sql "^\"%s*UPDATE") (#offset! @sql 0 1 0 -1))
