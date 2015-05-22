# rapidus-sparkle

[![NPM Version][npm-image]](https://npmjs.org/package/rapidus-sparkle)
[![Build Status][travis-image]](https://travis-ci.org/keis/rapidus-sparkle)
[![Coverage Status][coveralls-image]](https://coveralls.io/r/keis/rapidus-sparkle?branch=master)

A string formatter that creates shiny strings that sparkle with colour. Built
using `pegjs` and `chalk`.


## Installation

```bash
npm install --save rapidus-sparkle
```


## Usage

```javascript
// Create a formatter
var frmt = require('rapidus-sparkle')('%{red :foo %{:middle-#-} %{blue:bar}, yo!}')

// Format things
console.log(frmt({ foo: 'a foo thing'
                 , bar: 'a bar thing'
                 , middle: 'green'
                 }))
```

## Format

* `:attr` replace place holder with value from object.

    `sparkle('hello :subj')({subj: 'world'})` will create the string "hello world"

* `%{color ...}` applies a colour to the text up until the matching `}`

    The colour can either be specified as a literal colour name or it can be
    resolved from an attribute of the object.

    `sparkle('%{blue hello!}')({})` uses a literal colur and will create the
    string "hello!" in blue. And `sparkle('%{:foo hello!}')({foo: 'green'})`
    uses `foo` from the object to create the string "hello!" in green.

    For a full list of available colours see the [chalk page](https://github.com/sindresorhus/chalk#styles)

* `%%` insert a literal "%"


> Trying to find a memory in a dark room

[npm-image]: https://img.shields.io/npm/v/rapidus-sparkle.svg?style=flat
[travis-image]: https://img.shields.io/travis/keis/rapidus-sparkle.svg?style=flat
[coveralls-image]: https://img.shields.io/coveralls/keis/rapidus-sparkle.svg?style=flat
