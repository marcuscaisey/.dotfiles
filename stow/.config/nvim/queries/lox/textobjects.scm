; function
(function_declaration
  body: (block
    .
    "{"
    _+ @function.inner
    "}")) @function.outer

(function_expression
  body: (block
    .
    "{"
    _+ @function.inner
    "}")) @function.outer

(method_declaration
  body: (block
    .
    "{"
    _+ @function.inner
    "}")) @function.outer

; parameters
(parameter_list
  "," @parameter.outer
  .
  (identifier) @parameter.inner @parameter.outer)

(parameter_list
  .
  (identifier) @parameter.inner @parameter.outer
  .
  ","? @parameter.outer)

; arguments
(argument_list
  "," @parameter.outer
  .
  _ @parameter.inner @parameter.outer)

(argument_list
  .
  _ @parameter.inner @parameter.outer
  .
  ","? @parameter.outer)
