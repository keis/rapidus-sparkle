// The syntax of the formatter string is specified as a PEG parser
var parser = require('./parser'),
    colors = require('colors');

// Push a literal snippet of text onto the buffer
function literal(text, next) {
    return function (obj, buffer) {
        buffer.push(text);
        return next(obj, buffer);
    };
}

// Resolve an attribute of the object and push onto the buffer.
function token(token, next) {
    return function (obj, buffer) {
        var val = obj[token];
        buffer.push('' + (val && val.call ? val.call(obj) : val));
        return next(obj, buffer);
    };
}

// Format a subpattern and apply a colour to it.
function color(color, subpattern, next) {
    return function (obj, buffer) {
        var text = subpattern(obj),
            style;

        if (color.token) {
            style = colors[obj[color.token]];
        } else {
            style = colors[color];
        }

        buffer.push(style(text));
        return next(obj, buffer);
    };
}

// Join the contents of the buffer together to form a single string.
function join(obj, buffer) {
    return buffer.join('');
}

// Kick off the formatting by initializing the buffer to an empty list.
function start(next) {
    return function (obj) {
        return next(obj, []);
    }
}

// Create a chain of functions from a parsed formatter.
function chain(elems) {
    // The chain is constructed backwards and the last step is to join all
    // buffered text together.
    var last = join,
        elem;

    // Pop nodes from the parse tree and create functions accordingly with
    // every function holding a reference to the next function in the chain to
    // call.
    while ((elem = elems.pop())) {
        if (elem.literal) {
            last = literal(elem.literal, last);
        } else if (elem.token) {
            last = token(elem.token, last);
        } else if (elem.color) {
            last = color(elem.color, chain(elem.pattern), last);
        }
    }

    // Wrap the chain with a start function that creates the buffer.
    return start(last);
}

// Create a function that formats strings with placeholders and pretty colours
// from a string specification.
function createFormatter(options) {
    var elems = parser.parse(options.format);
    return chain(elems);
}

// Export
module.exports.createFormatter = createFormatter;
