suite 'sparkle', ->
  createFormatter = require '../lib/sparkle'

  record =
    foo: 'foo-text'
    bar: 'bar-text'
    level: -> 'WARNING'

  set 'iterations', 100000

  simple = createFormatter ':foo'
  complex = createFormatter '[:foo] :bar :level'
  big = createFormatter '-:foo-:bar-:foo-:foo-:bar-:foo-:bar-:foo-:bar'
  color = createFormatter '%{cyan :foo}'

  bench 'simple attribute', ->
    simple record

  bench 'complex format string', ->
    complex record

  bench 'big format string', ->
    big record

  bench 'coloring', ->
    color record


suite 'dullstring', ->
  createFormatter = require 'dullstring'

  record =
    foo: 'foo-text'
    bar: 'bar-text'
    level: -> 'WARNING'

  set 'iterations', 100000

  simple = createFormatter ':foo'
  complex = createFormatter '[:foo] :bar :level'
  big = createFormatter '-:foo-:bar-:foo-:foo-:bar-:foo-:bar-:foo-:bar'

  bench 'simple attribute', ->
    simple record

  bench 'complex format string', ->
    complex record

  bench 'big format string', ->
    big record


suite 'hogan', ->
  hogan = require 'hogan'

  record =
    foo: 'foo-text'
    bar: 'bar-text'
    level: -> 'WARNING'

  set 'iterations', 100000

  simple = hogan.compile '{{foo}}'
  complex = hogan.compile '[{{foo}}] {{bar}} {{level}}'
  big = hogan.compile '-{{foo}}-{{bar}}-{{foo}}-{{foo}}-{{bar}}-{{foo}}-{{bar}}-{{foo}}-{{bar}}'

  bench 'simple attribute', ->
    simple.render record

  bench 'complex format string', ->
    complex.render record

  bench 'big format string', ->
    big.render record
