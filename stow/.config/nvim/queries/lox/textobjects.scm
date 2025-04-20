; function
(function_declaration
  body: (block
    .
    "{"
    .
    (_) @_start @_end
    (_)? @_end
    .
    "}"
    (#make-range! "function.inner" @_start @_end))) @function.outer

(function_expression
  body: (block
    .
    "{"
    .
    (_) @_start @_end
    (_)? @_end
    .
    "}"
    (#make-range! "function.inner" @_start @_end))) @function.outer

(method_declaration
  body: (block
    .
    "{"
    .
    (_) @_start @_end
    (_)? @_end
    .
    "}"
    (#make-range! "function.inner" @_start @_end))) @function.outer

; parameters
(parameter_list
  "," @_start
  .
  (identifier) @parameter.inner
  (#make-range! "parameter.outer" @_start @parameter.inner))

(parameter_list
  .
  (identifier) @parameter.inner
  .
  ","? @_end
  (#make-range! "parameter.outer" @parameter.inner @_end))

; arguments
(argument_list
  "," @_start
  .
  (_) @parameter.inner
  (#make-range! "parameter.outer" @_start @parameter.inner))

(argument_list
  .
  (_) @parameter.inner
  .
  ","? @_end
  (#make-range! "parameter.outer" @parameter.inner @_end))
