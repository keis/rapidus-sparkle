// Export
module.exports.createFormatter = createFormatter

// The syntax of the formatter string is specified as a PEG parser
var parser = require('./parser')
  , chalk = new (require('chalk')).constructor({enabled: true})

// Push a literal snippet of text onto the buffer
function literal(text, next) {
  return function (obj, buffer) {
    buffer.push(text)
    return next(obj, buffer)
  }
}

// Resolve an attribute of the object and push onto the buffer.
function token(token, next) {
  return function (obj, buffer) {
    var val = obj[token]

    if (val && val.call) {
      val = val.call(obj)
    }

    buffer.push(val !== void 0 ? '' + val : '-')
    return next(obj, buffer)
  }
}

// Format a subpattern and apply a colour to it.
function color(color, colorMap, subpattern, next) {
  colorMap = colorMap || {}

  return function (obj, buffer) {
    var text = subpattern(obj)
      , val
      , style

    // Get the colour name as a literal or from an attribute on the object
    if (color.token) {
      val = obj[color.token]
      val = '' + (val && val.call ? val.call(obj) : val)
    } else {
      val = color
    }

    // Resolve the name to a function a optional colormap will be checked
    // to traslate the name of the colour
    style = chalk[colorMap[val] || val]

    // If a function was found apply it to the text else the text is untouched
    if (style) {
      text = style(text)
    }

    buffer.push(text)
    return next(obj, buffer)
  }
}

// Join the contents of the buffer together to form a single string.
function join(obj, buffer) {
  return buffer.join('')
}

// Kick off the formatting by initializing the buffer to an empty list.
function start(next) {
  return function (obj) {
    return next(obj, [])
  }
}

// Create a chain of functions from a parsed formatter.
function chain(elems, options) {
  // The chain is constructed backwards and the last step is to join all
  // buffered text together.
  var last = join
    , elem

  // Pop nodes from the parse tree and create functions accordingly with
  // every function holding a reference to the next function in the chain to
  // call.
  while ((elem = elems.pop())) {
    if (elem.literal) {
      last = literal(elem.literal, last)
    } else if (elem.token) {
      last = token(elem.token, last)
    } else if (elem.color) {
      last = color( elem.color
                  , options.colors
                  , chain(elem.pattern, options)
                  , last)
    }
  }

  // Wrap the chain with a start function that creates the buffer.
  return start(last)
}

// Create a function that formats strings with placeholders and pretty colours
// from a string specification.
function createFormatter(format, options) {
  if (typeof format !== 'string') {
    options = format
    format = options.format
  }

  var elems = parser.parse(format)
  return chain(elems, options || {})
}
