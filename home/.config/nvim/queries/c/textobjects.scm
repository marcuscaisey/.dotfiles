; extends

(translation_unit
  [
    (function_definition)
    (struct_specifier)
    (enum_specifier)
  ] @section.outer)

(translation_unit
  (preproc_ifdef
    [
      (declaration)
      (struct_specifier)
      (enum_specifier)
    ] @section.outer))
