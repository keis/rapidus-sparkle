describe "sparkle", ->
    {createFormatter} = require '../../lib/sparkle'

    record =
        foo: 'foo-text'
        bar: 'bar-text'
        baz: 'red'
        level: -> 'WARNING'

    it "performs a simple substitution", ->
        frmt = createFormatter
            format: ':foo - :bar!'
        str = frmt record
        assert.equal str, 'foo-text - bar-text!'

    it "colours a text", ->
        frmt = createFormatter
            format: '%{cyan my little text}'
        str = frmt record
        assert.equal str, 'my little text'.cyan

    it "colours a text based on a token", ->
        frmt = createFormatter
            format: '%{:baz my little text}'
        str = frmt record
        assert.equal str, 'my little text'.red

    it "calls attributes that are resolved to functions", ->
        frmt = createFormatter
            format: ':level'
        str = frmt record
        assert.equal str, 'WARNING'

    it "ignores bad colour identifiers", ->
        frmt = createFormatter
            format: '%{fisk zoidberg}'
        str = frmt record
        assert.equal str, 'zoidberg'

    it "resolves aliases for colours", ->
        frmt = createFormatter
            format: '%{:level zoidberg}'
            colors:
                WARNING: 'yellow'
        str = frmt record
        assert.equal str, 'zoidberg'.yellow
