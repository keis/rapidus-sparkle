describe "parser", ->
    {parse, SyntaxError} = require '../../lib/parser'

    it "parses a token", ->
        expected = [token: 'test']
        actual = parse ':test'
        assert.deepEqual actual, expected

    it "parses a coloured section", ->
        expected = [
            color: 'red'
            pattern: []
        ]
        actual = parse '%{red}'
        assert.deepEqual actual, expected

    it "parses a coloured section with a token", ->
        expected = [
            color:
                token: 'status'
            pattern: []
        ]
        actual = parse '%{:status}'
        assert.deepEqual actual, expected

    it "parses a two nested coloured sections", ->
        expected = [
            color: 'red'
            pattern: [
                color: 'black'
                pattern: []
            ]
        ]
        actual = parse '%{red%{black}}'
        assert.deepEqual actual, expected

    it "parses a literal", ->
        expected = [
            literal: 'literal'
        ]
        actual = parse 'literal'
        assert.deepEqual actual, expected

    it "parses a percentage sign", ->
        expected = [
            literal: '%'
        ]
        actual = parse '%%'
        assert.deepEqual actual, expected

    it "throws on badly formatted colour", ->
        fun = ->
            parse '%{red%'
        assert.throws fun, SyntaxError, /but .%. found/

    it "parses a complex format", ->
        expected = [
            (token: 'foo')
            (literal: '-')
            (token: 'bar')
            color: 'white'
            pattern: [
                (literal: 'status ')
                color:
                    token: 'status'
                pattern: [token: 'status']
                (literal: '!')
            ]
            (literal: ' 100%')
        ]
        actual = parse ':foo-:bar%{white status %{:status:status}!} 100%%'
        assert.deepEqual actual, expected
