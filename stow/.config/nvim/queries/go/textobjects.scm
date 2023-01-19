; extends

(keyed_element
  (literal_element)
  (literal_element) @value.inner) @value.outer

(literal_value
  "," @_start .
  (literal_element) @value.inner
  (#make-range! "value.outer" @_start @value.inner))

(literal_value
  . (literal_element) @value.inner
  . ","? @_end
  (#make-range! "value.outer" @value.inner @_end))

right: (expression_list) @value.inner @value.outer
