(function(f){if(typeof exports==="object"&&typeof module!=="undefined"){module.exports=f()}else if(typeof define==="function"&&define.amd){define([],f)}else{var g;if(typeof window!=="undefined"){g=window}else if(typeof global!=="undefined"){g=global}else if(typeof self!=="undefined"){g=self}else{g=this}g.LuckyExcel = f()}})(function(){var define,module,exports;return (function(){function r(e,n,t){function o(i,f){if(!n[i]){if(!e[i]){var c="function"==typeof require&&require;if(!f&&c)return c(i,!0);if(u)return u(i,!0);var a=new Error("Cannot find module '"+i+"'");throw a.code="MODULE_NOT_FOUND",a}var p=n[i]={exports:{}};e[i][0].call(p.exports,function(r){var n=e[i][1][r];return o(n||r)},p,p.exports,r,e,n,t)}return n[i].exports}for(var u="function"==typeof require&&require,i=0;i<t.length;i++)o(t[i]);return o}return r})()({1:[function(require,module,exports){
'use strict'

exports.byteLength = byteLength
exports.toByteArray = toByteArray
exports.fromByteArray = fromByteArray

var lookup = []
var revLookup = []
var Arr = typeof Uint8Array !== 'undefined' ? Uint8Array : Array

var code = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
for (var i = 0, len = code.length; i < len; ++i) {
  lookup[i] = code[i]
  revLookup[code.charCodeAt(i)] = i
}

// Support decoding URL-safe base64 strings, as Node.js does.
// See: https://en.wikipedia.org/wiki/Base64#URL_applications
revLookup['-'.charCodeAt(0)] = 62
revLookup['_'.charCodeAt(0)] = 63

function getLens (b64) {
  var len = b64.length

  if (len % 4 > 0) {
    throw new Error('Invalid string. Length must be a multiple of 4')
  }

  // Trim off extra bytes after placeholder bytes are found
  // See: https://github.com/beatgammit/base64-js/issues/42
  var validLen = b64.indexOf('=')
  if (validLen === -1) validLen = len

  var placeHoldersLen = validLen === len
    ? 0
    : 4 - (validLen % 4)

  return [validLen, placeHoldersLen]
}

// base64 is 4/3 + up to two characters of the original data
function byteLength (b64) {
  var lens = getLens(b64)
  var validLen = lens[0]
  var placeHoldersLen = lens[1]
  return ((validLen + placeHoldersLen) * 3 / 4) - placeHoldersLen
}

function _byteLength (b64, validLen, placeHoldersLen) {
  return ((validLen + placeHoldersLen) * 3 / 4) - placeHoldersLen
}

function toByteArray (b64) {
  var tmp
  var lens = getLens(b64)
  var validLen = lens[0]
  var placeHoldersLen = lens[1]

  var arr = new Arr(_byteLength(b64, validLen, placeHoldersLen))

  var curByte = 0

  // if there are placeholders, only get up to the last complete 4 chars
  var len = placeHoldersLen > 0
    ? validLen - 4
    : validLen

  var i
  for (i = 0; i < len; i += 4) {
    tmp =
      (revLookup[b64.charCodeAt(i)] << 18) |
      (revLookup[b64.charCodeAt(i + 1)] << 12) |
      (revLookup[b64.charCodeAt(i + 2)] << 6) |
      revLookup[b64.charCodeAt(i + 3)]
    arr[curByte++] = (tmp >> 16) & 0xFF
    arr[curByte++] = (tmp >> 8) & 0xFF
    arr[curByte++] = tmp & 0xFF
  }

  if (placeHoldersLen === 2) {
    tmp =
      (revLookup[b64.charCodeAt(i)] << 2) |
      (revLookup[b64.charCodeAt(i + 1)] >> 4)
    arr[curByte++] = tmp & 0xFF
  }

  if (placeHoldersLen === 1) {
    tmp =
      (revLookup[b64.charCodeAt(i)] << 10) |
      (revLookup[b64.charCodeAt(i + 1)] << 4) |
      (revLookup[b64.charCodeAt(i + 2)] >> 2)
    arr[curByte++] = (tmp >> 8) & 0xFF
    arr[curByte++] = tmp & 0xFF
  }

  return arr
}

function tripletToBase64 (num) {
  return lookup[num >> 18 & 0x3F] +
    lookup[num >> 12 & 0x3F] +
    lookup[num >> 6 & 0x3F] +
    lookup[num & 0x3F]
}

function encodeChunk (uint8, start, end) {
  var tmp
  var output = []
  for (var i = start; i < end; i += 3) {
    tmp =
      ((uint8[i] << 16) & 0xFF0000) +
      ((uint8[i + 1] << 8) & 0xFF00) +
      (uint8[i + 2] & 0xFF)
    output.push(tripletToBase64(tmp))
  }
  return output.join('')
}

function fromByteArray (uint8) {
  var tmp
  var len = uint8.length
  var extraBytes = len % 3 // if we have 1 byte left, pad 2 bytes
  var parts = []
  var maxChunkLength = 16383 // must be multiple of 3

  // go through the array every three bytes, we'll deal with trailing stuff later
  for (var i = 0, len2 = len - extraBytes; i < len2; i += maxChunkLength) {
    parts.push(encodeChunk(uint8, i, (i + maxChunkLength) > len2 ? len2 : (i + maxChunkLength)))
  }

  // pad the end with zeros, but make sure to not forget the extra bytes
  if (extraBytes === 1) {
    tmp = uint8[len - 1]
    parts.push(
      lookup[tmp >> 2] +
      lookup[(tmp << 4) & 0x3F] +
      '=='
    )
  } else if (extraBytes === 2) {
    tmp = (uint8[len - 2] << 8) + uint8[len - 1]
    parts.push(
      lookup[tmp >> 10] +
      lookup[(tmp >> 4) & 0x3F] +
      lookup[(tmp << 2) & 0x3F] +
      '='
    )
  }

  return parts.join('')
}

},{}],2:[function(require,module,exports){

},{}],3:[function(require,module,exports){
(function (global,Buffer){
/*!
 * The buffer module from node.js, for the browser.
 *
 * @author   Feross Aboukhadijeh <http://feross.org>
 * @license  MIT
 */
/* eslint-disable no-proto */

'use strict'

var base64 = require('base64-js')
var ieee754 = require('ieee754')
var isArray = require('isarray')

exports.Buffer = Buffer
exports.SlowBuffer = SlowBuffer
exports.INSPECT_MAX_BYTES = 50

/**
 * If `Buffer.TYPED_ARRAY_SUPPORT`:
 *   === true    Use Uint8Array implementation (fastest)
 *   === false   Use Object implementation (most compatible, even IE6)
 *
 * Browsers that support typed arrays are IE 10+, Firefox 4+, Chrome 7+, Safari 5.1+,
 * Opera 11.6+, iOS 4.2+.
 *
 * Due to various browser bugs, sometimes the Object implementation will be used even
 * when the browser supports typed arrays.
 *
 * Note:
 *
 *   - Firefox 4-29 lacks support for adding new properties to `Uint8Array` instances,
 *     See: https://bugzilla.mozilla.org/show_bug.cgi?id=695438.
 *
 *   - Chrome 9-10 is missing the `TypedArray.prototype.subarray` function.
 *
 *   - IE10 has a broken `TypedArray.prototype.subarray` function which returns arrays of
 *     incorrect length in some situations.

 * We detect these buggy browsers and set `Buffer.TYPED_ARRAY_SUPPORT` to `false` so they
 * get the Object implementation, which is slower but behaves correctly.
 */
Buffer.TYPED_ARRAY_SUPPORT = global.TYPED_ARRAY_SUPPORT !== undefined
  ? global.TYPED_ARRAY_SUPPORT
  : typedArraySupport()

/*
 * Export kMaxLength after typed array support is determined.
 */
exports.kMaxLength = kMaxLength()

function typedArraySupport () {
  try {
    var arr = new Uint8Array(1)
    arr.__proto__ = {__proto__: Uint8Array.prototype, foo: function () { return 42 }}
    return arr.foo() === 42 && // typed array instances can be augmented
        typeof arr.subarray === 'function' && // chrome 9-10 lack `subarray`
        arr.subarray(1, 1).byteLength === 0 // ie10 has broken `subarray`
  } catch (e) {
    return false
  }
}

function kMaxLength () {
  return Buffer.TYPED_ARRAY_SUPPORT
    ? 0x7fffffff
    : 0x3fffffff
}

function createBuffer (that, length) {
  if (kMaxLength() < length) {
    throw new RangeError('Invalid typed array length')
  }
  if (Buffer.TYPED_ARRAY_SUPPORT) {
    // Return an augmented `Uint8Array` instance, for best performance
    that = new Uint8Array(length)
    that.__proto__ = Buffer.prototype
  } else {
    // Fallback: Return an object instance of the Buffer class
    if (that === null) {
      that = new Buffer(length)
    }
    that.length = length
  }

  return that
}

/**
 * The Buffer constructor returns instances of `Uint8Array` that have their
 * prototype changed to `Buffer.prototype`. Furthermore, `Buffer` is a subclass of
 * `Uint8Array`, so the returned instances will have all the node `Buffer` methods
 * and the `Uint8Array` methods. Square bracket notation works as expected -- it
 * returns a single octet.
 *
 * The `Uint8Array` prototype remains unmodified.
 */

function Buffer (arg, encodingOrOffset, length) {
  if (!Buffer.TYPED_ARRAY_SUPPORT && !(this instanceof Buffer)) {
    return new Buffer(arg, encodingOrOffset, length)
  }

  // Common case.
  if (typeof arg === 'number') {
    if (typeof encodingOrOffset === 'string') {
      throw new Error(
        'If encoding is specified then the first argument must be a string'
      )
    }
    return allocUnsafe(this, arg)
  }
  return from(this, arg, encodingOrOffset, length)
}

Buffer.poolSize = 8192 // not used by this implementation

// TODO: Legacy, not needed anymore. Remove in next major version.
Buffer._augment = function (arr) {
  arr.__proto__ = Buffer.prototype
  return arr
}

function from (that, value, encodingOrOffset, length) {
  if (typeof value === 'number') {
    throw new TypeError('"value" argument must not be a number')
  }

  if (typeof ArrayBuffer !== 'undefined' && value instanceof ArrayBuffer) {
    return fromArrayBuffer(that, value, encodingOrOffset, length)
  }

  if (typeof value === 'string') {
    return fromString(that, value, encodingOrOffset)
  }

  return fromObject(that, value)
}

/**
 * Functionally equivalent to Buffer(arg, encoding) but throws a TypeError
 * if value is a number.
 * Buffer.from(str[, encoding])
 * Buffer.from(array)
 * Buffer.from(buffer)
 * Buffer.from(arrayBuffer[, byteOffset[, length]])
 **/
Buffer.from = function (value, encodingOrOffset, length) {
  return from(null, value, encodingOrOffset, length)
}

if (Buffer.TYPED_ARRAY_SUPPORT) {
  Buffer.prototype.__proto__ = Uint8Array.prototype
  Buffer.__proto__ = Uint8Array
  if (typeof Symbol !== 'undefined' && Symbol.species &&
      Buffer[Symbol.species] === Buffer) {
    // Fix subarray() in ES2016. See: https://github.com/feross/buffer/pull/97
    Object.defineProperty(Buffer, Symbol.species, {
      value: null,
      configurable: true
    })
  }
}

function assertSize (size) {
  if (typeof size !== 'number') {
    throw new TypeError('"size" argument must be a number')
  } else if (size < 0) {
    throw new RangeError('"size" argument must not be negative')
  }
}

function alloc (that, size, fill, encoding) {
  assertSize(size)
  if (size <= 0) {
    return createBuffer(that, size)
  }
  if (fill !== undefined) {
    // Only pay attention to encoding if it's a string. This
    // prevents accidentally sending in a number that would
    // be interpretted as a start offset.
    return typeof encoding === 'string'
      ? createBuffer(that, size).fill(fill, encoding)
      : createBuffer(that, size).fill(fill)
  }
  return createBuffer(that, size)
}

/**
 * Creates a new filled Buffer instance.
 * alloc(size[, fill[, encoding]])
 **/
Buffer.alloc = function (size, fill, encoding) {
  return alloc(null, size, fill, encoding)
}

function allocUnsafe (that, size) {
  assertSize(size)
  that = createBuffer(that, size < 0 ? 0 : checked(size) | 0)
  if (!Buffer.TYPED_ARRAY_SUPPORT) {
    for (var i = 0; i < size; ++i) {
      that[i] = 0
    }
  }
  return that
}

/**
 * Equivalent to Buffer(num), by default creates a non-zero-filled Buffer instance.
 * */
Buffer.allocUnsafe = function (size) {
  return allocUnsafe(null, size)
}
/**
 * Equivalent to SlowBuffer(num), by default creates a non-zero-filled Buffer instance.
 */
Buffer.allocUnsafeSlow = function (size) {
  return allocUnsafe(null, size)
}

function fromString (that, string, encoding) {
  if (typeof encoding !== 'string' || encoding === '') {
    encoding = 'utf8'
  }

  if (!Buffer.isEncoding(encoding)) {
    throw new TypeError('"encoding" must be a valid string encoding')
  }

  var length = byteLength(string, encoding) | 0
  that = createBuffer(that, length)

  var actual = that.write(string, encoding)

  if (actual !== length) {
    // Writing a hex string, for example, that contains invalid characters will
    // cause everything after the first invalid character to be ignored. (e.g.
    // 'abxxcd' will be treated as 'ab')
    that = that.slice(0, actual)
  }

  return that
}

function fromArrayLike (that, array) {
  var length = array.length < 0 ? 0 : checked(array.length) | 0
  that = createBuffer(that, length)
  for (var i = 0; i < length; i += 1) {
    that[i] = array[i] & 255
  }
  return that
}

function fromArrayBuffer (that, array, byteOffset, length) {
  array.byteLength // this throws if `array` is not a valid ArrayBuffer

  if (byteOffset < 0 || array.byteLength < byteOffset) {
    throw new RangeError('\'offset\' is out of bounds')
  }

  if (array.byteLength < byteOffset + (length || 0)) {
    throw new RangeError('\'length\' is out of bounds')
  }

  if (byteOffset === undefined && length === undefined) {
    array = new Uint8Array(array)
  } else if (length === undefined) {
    array = new Uint8Array(array, byteOffset)
  } else {
    array = new Uint8Array(array, byteOffset, length)
  }

  if (Buffer.TYPED_ARRAY_SUPPORT) {
    // Return an augmented `Uint8Array` instance, for best performance
    that = array
    that.__proto__ = Buffer.prototype
  } else {
    // Fallback: Return an object instance of the Buffer class
    that = fromArrayLike(that, array)
  }
  return that
}

function fromObject (that, obj) {
  if (Buffer.isBuffer(obj)) {
    var len = checked(obj.length) | 0
    that = createBuffer(that, len)

    if (that.length === 0) {
      return that
    }

    obj.copy(that, 0, 0, len)
    return that
  }

  if (obj) {
    if ((typeof ArrayBuffer !== 'undefined' &&
        obj.buffer instanceof ArrayBuffer) || 'length' in obj) {
      if (typeof obj.length !== 'number' || isnan(obj.length)) {
        return createBuffer(that, 0)
      }
      return fromArrayLike(that, obj)
    }

    if (obj.type === 'Buffer' && isArray(obj.data)) {
      return fromArrayLike(that, obj.data)
    }
  }

  throw new TypeError('First argument must be a string, Buffer, ArrayBuffer, Array, or array-like object.')
}

function checked (length) {
  // Note: cannot use `length < kMaxLength()` here because that fails when
  // length is NaN (which is otherwise coerced to zero.)
  if (length >= kMaxLength()) {
    throw new RangeError('Attempt to allocate Buffer larger than maximum ' +
                         'size: 0x' + kMaxLength().toString(16) + ' bytes')
  }
  return length | 0
}

function SlowBuffer (length) {
  if (+length != length) { // eslint-disable-line eqeqeq
    length = 0
  }
  return Buffer.alloc(+length)
}

Buffer.isBuffer = function isBuffer (b) {
  return !!(b != null && b._isBuffer)
}

Buffer.compare = function compare (a, b) {
  if (!Buffer.isBuffer(a) || !Buffer.isBuffer(b)) {
    throw new TypeError('Arguments must be Buffers')
  }

  if (a === b) return 0

  var x = a.length
  var y = b.length

  for (var i = 0, len = Math.min(x, y); i < len; ++i) {
    if (a[i] !== b[i]) {
      x = a[i]
      y = b[i]
      break
    }
  }

  if (x < y) return -1
  if (y < x) return 1
  return 0
}

Buffer.isEncoding = function isEncoding (encoding) {
  switch (String(encoding).toLowerCase()) {
    case 'hex':
    case 'utf8':
    case 'utf-8':
    case 'ascii':
    case 'latin1':
    case 'binary':
    case 'base64':
    case 'ucs2':
    case 'ucs-2':
    case 'utf16le':
    case 'utf-16le':
      return true
    default:
      return false
  }
}

Buffer.concat = function concat (list, length) {
  if (!isArray(list)) {
    throw new TypeError('"list" argument must be an Array of Buffers')
  }

  if (list.length === 0) {
    return Buffer.alloc(0)
  }

  var i
  if (length === undefined) {
    length = 0
    for (i = 0; i < list.length; ++i) {
      length += list[i].length
    }
  }

  var buffer = Buffer.allocUnsafe(length)
  var pos = 0
  for (i = 0; i < list.length; ++i) {
    var buf = list[i]
    if (!Buffer.isBuffer(buf)) {
      throw new TypeError('"list" argument must be an Array of Buffers')
    }
    buf.copy(buffer, pos)
    pos += buf.length
  }
  return buffer
}

function byteLength (string, encoding) {
  if (Buffer.isBuffer(string)) {
    return string.length
  }
  if (typeof ArrayBuffer !== 'undefined' && typeof ArrayBuffer.isView === 'function' &&
      (ArrayBuffer.isView(string) || string instanceof ArrayBuffer)) {
    return string.byteLength
  }
  if (typeof string !== 'string') {
    string = '' + string
  }

  var len = string.length
  if (len === 0) return 0

  // Use a for loop to avoid recursion
  var loweredCase = false
  for (;;) {
    switch (encoding) {
      case 'ascii':
      case 'latin1':
      case 'binary':
        return len
      case 'utf8':
      case 'utf-8':
      case undefined:
        return utf8ToBytes(string).length
      case 'ucs2':
      case 'ucs-2':
      case 'utf16le':
      case 'utf-16le':
        return len * 2
      case 'hex':
        return len >>> 1
      case 'base64':
        return base64ToBytes(string).length
      default:
        if (loweredCase) return utf8ToBytes(string).length // assume utf8
        encoding = ('' + encoding).toLowerCase()
        loweredCase = true
    }
  }
}
Buffer.byteLength = byteLength

function slowToString (encoding, start, end) {
  var loweredCase = false

  // No need to verify that "this.length <= MAX_UINT32" since it's a read-only
  // property of a typed array.

  // This behaves neither like String nor Uint8Array in that we set start/end
  // to their upper/lower bounds if the value passed is out of range.
  // undefined is handled specially as per ECMA-262 6th Edition,
  // Section 13.3.3.7 Runtime Semantics: KeyedBindingInitialization.
  if (start === undefined || start < 0) {
    start = 0
  }
  // Return early if start > this.length. Done here to prevent potential uint32
  // coercion fail below.
  if (start > this.length) {
    return ''
  }

  if (end === undefined || end > this.length) {
    end = this.length
  }

  if (end <= 0) {
    return ''
  }

  // Force coersion to uint32. This will also coerce falsey/NaN values to 0.
  end >>>= 0
  start >>>= 0

  if (end <= start) {
    return ''
  }

  if (!encoding) encoding = 'utf8'

  while (true) {
    switch (encoding) {
      case 'hex':
        return hexSlice(this, start, end)

      case 'utf8':
      case 'utf-8':
        return utf8Slice(this, start, end)

      case 'ascii':
        return asciiSlice(this, start, end)

      case 'latin1':
      case 'binary':
        return latin1Slice(this, start, end)

      case 'base64':
        return base64Slice(this, start, end)

      case 'ucs2':
      case 'ucs-2':
      case 'utf16le':
      case 'utf-16le':
        return utf16leSlice(this, start, end)

      default:
        if (loweredCase) throw new TypeError('Unknown encoding: ' + encoding)
        encoding = (encoding + '').toLowerCase()
        loweredCase = true
    }
  }
}

// The property is used by `Buffer.isBuffer` and `is-buffer` (in Safari 5-7) to detect
// Buffer instances.
Buffer.prototype._isBuffer = true

function swap (b, n, m) {
  var i = b[n]
  b[n] = b[m]
  b[m] = i
}

Buffer.prototype.swap16 = function swap16 () {
  var len = this.length
  if (len % 2 !== 0) {
    throw new RangeError('Buffer size must be a multiple of 16-bits')
  }
  for (var i = 0; i < len; i += 2) {
    swap(this, i, i + 1)
  }
  return this
}

Buffer.prototype.swap32 = function swap32 () {
  var len = this.length
  if (len % 4 !== 0) {
    throw new RangeError('Buffer size must be a multiple of 32-bits')
  }
  for (var i = 0; i < len; i += 4) {
    swap(this, i, i + 3)
    swap(this, i + 1, i + 2)
  }
  return this
}

Buffer.prototype.swap64 = function swap64 () {
  var len = this.length
  if (len % 8 !== 0) {
    throw new RangeError('Buffer size must be a multiple of 64-bits')
  }
  for (var i = 0; i < len; i += 8) {
    swap(this, i, i + 7)
    swap(this, i + 1, i + 6)
    swap(this, i + 2, i + 5)
    swap(this, i + 3, i + 4)
  }
  return this
}

Buffer.prototype.toString = function toString () {
  var length = this.length | 0
  if (length === 0) return ''
  if (arguments.length === 0) return utf8Slice(this, 0, length)
  return slowToString.apply(this, arguments)
}

Buffer.prototype.equals = function equals (b) {
  if (!Buffer.isBuffer(b)) throw new TypeError('Argument must be a Buffer')
  if (this === b) return true
  return Buffer.compare(this, b) === 0
}

Buffer.prototype.inspect = function inspect () {
  var str = ''
  var max = exports.INSPECT_MAX_BYTES
  if (this.length > 0) {
    str = this.toString('hex', 0, max).match(/.{2}/g).join(' ')
    if (this.length > max) str += ' ... '
  }
  return '<Buffer ' + str + '>'
}

Buffer.prototype.compare = function compare (target, start, end, thisStart, thisEnd) {
  if (!Buffer.isBuffer(target)) {
    throw new TypeError('Argument must be a Buffer')
  }

  if (start === undefined) {
    start = 0
  }
  if (end === undefined) {
    end = target ? target.length : 0
  }
  if (thisStart === undefined) {
    thisStart = 0
  }
  if (thisEnd === undefined) {
    thisEnd = this.length
  }

  if (start < 0 || end > target.length || thisStart < 0 || thisEnd > this.length) {
    throw new RangeError('out of range index')
  }

  if (thisStart >= thisEnd && start >= end) {
    return 0
  }
  if (thisStart >= thisEnd) {
    return -1
  }
  if (start >= end) {
    return 1
  }

  start >>>= 0
  end >>>= 0
  thisStart >>>= 0
  thisEnd >>>= 0

  if (this === target) return 0

  var x = thisEnd - thisStart
  var y = end - start
  var len = Math.min(x, y)

  var thisCopy = this.slice(thisStart, thisEnd)
  var targetCopy = target.slice(start, end)

  for (var i = 0; i < len; ++i) {
    if (thisCopy[i] !== targetCopy[i]) {
      x = thisCopy[i]
      y = targetCopy[i]
      break
    }
  }

  if (x < y) return -1
  if (y < x) return 1
  return 0
}

// Finds either the first index of `val` in `buffer` at offset >= `byteOffset`,
// OR the last index of `val` in `buffer` at offset <= `byteOffset`.
//
// Arguments:
// - buffer - a Buffer to search
// - val - a string, Buffer, or number
// - byteOffset - an index into `buffer`; will be clamped to an int32
// - encoding - an optional encoding, relevant is val is a string
// - dir - true for indexOf, false for lastIndexOf
function bidirectionalIndexOf (buffer, val, byteOffset, encoding, dir) {
  // Empty buffer means no match
  if (buffer.length === 0) return -1

  // Normalize byteOffset
  if (typeof byteOffset === 'string') {
    encoding = byteOffset
    byteOffset = 0
  } else if (byteOffset > 0x7fffffff) {
    byteOffset = 0x7fffffff
  } else if (byteOffset < -0x80000000) {
    byteOffset = -0x80000000
  }
  byteOffset = +byteOffset  // Coerce to Number.
  if (isNaN(byteOffset)) {
    // byteOffset: it it's undefined, null, NaN, "foo", etc, search whole buffer
    byteOffset = dir ? 0 : (buffer.length - 1)
  }

  // Normalize byteOffset: negative offsets start from the end of the buffer
  if (byteOffset < 0) byteOffset = buffer.length + byteOffset
  if (byteOffset >= buffer.length) {
    if (dir) return -1
    else byteOffset = buffer.length - 1
  } else if (byteOffset < 0) {
    if (dir) byteOffset = 0
    else return -1
  }

  // Normalize val
  if (typeof val === 'string') {
    val = Buffer.from(val, encoding)
  }

  // Finally, search either indexOf (if dir is true) or lastIndexOf
  if (Buffer.isBuffer(val)) {
    // Special case: looking for empty string/buffer always fails
    if (val.length === 0) {
      return -1
    }
    return arrayIndexOf(buffer, val, byteOffset, encoding, dir)
  } else if (typeof val === 'number') {
    val = val & 0xFF // Search for a byte value [0-255]
    if (Buffer.TYPED_ARRAY_SUPPORT &&
        typeof Uint8Array.prototype.indexOf === 'function') {
      if (dir) {
        return Uint8Array.prototype.indexOf.call(buffer, val, byteOffset)
      } else {
        return Uint8Array.prototype.lastIndexOf.call(buffer, val, byteOffset)
      }
    }
    return arrayIndexOf(buffer, [ val ], byteOffset, encoding, dir)
  }

  throw new TypeError('val must be string, number or Buffer')
}

function arrayIndexOf (arr, val, byteOffset, encoding, dir) {
  var indexSize = 1
  var arrLength = arr.length
  var valLength = val.length

  if (encoding !== undefined) {
    encoding = String(encoding).toLowerCase()
    if (encoding === 'ucs2' || encoding === 'ucs-2' ||
        encoding === 'utf16le' || encoding === 'utf-16le') {
      if (arr.length < 2 || val.length < 2) {
        return -1
      }
      indexSize = 2
      arrLength /= 2
      valLength /= 2
      byteOffset /= 2
    }
  }

  function read (buf, i) {
    if (indexSize === 1) {
      return buf[i]
    } else {
      return buf.readUInt16BE(i * indexSize)
    }
  }

  var i
  if (dir) {
    var foundIndex = -1
    for (i = byteOffset; i < arrLength; i++) {
      if (read(arr, i) === read(val, foundIndex === -1 ? 0 : i - foundIndex)) {
        if (foundIndex === -1) foundIndex = i
        if (i - foundIndex + 1 === valLength) return foundIndex * indexSize
      } else {
        if (foundIndex !== -1) i -= i - foundIndex
        foundIndex = -1
      }
    }
  } else {
    if (byteOffset + valLength > arrLength) byteOffset = arrLength - valLength
    for (i = byteOffset; i >= 0; i--) {
      var found = true
      for (var j = 0; j < valLength; j++) {
        if (read(arr, i + j) !== read(val, j)) {
          found = false
          break
        }
      }
      if (found) return i
    }
  }

  return -1
}

Buffer.prototype.includes = function includes (val, byteOffset, encoding) {
  return this.indexOf(val, byteOffset, encoding) !== -1
}

Buffer.prototype.indexOf = function indexOf (val, byteOffset, encoding) {
  return bidirectionalIndexOf(this, val, byteOffset, encoding, true)
}

Buffer.prototype.lastIndexOf = function lastIndexOf (val, byteOffset, encoding) {
  return bidirectionalIndexOf(this, val, byteOffset, encoding, false)
}

function hexWrite (buf, string, offset, length) {
  offset = Number(offset) || 0
  var remaining = buf.length - offset
  if (!length) {
    length = remaining
  } else {
    length = Number(length)
    if (length > remaining) {
      length = remaining
    }
  }

  // must be an even number of digits
  var strLen = string.length
  if (strLen % 2 !== 0) throw new TypeError('Invalid hex string')

  if (length > strLen / 2) {
    length = strLen / 2
  }
  for (var i = 0; i < length; ++i) {
    var parsed = parseInt(string.substr(i * 2, 2), 16)
    if (isNaN(parsed)) return i
    buf[offset + i] = parsed
  }
  return i
}

function utf8Write (buf, string, offset, length) {
  return blitBuffer(utf8ToBytes(string, buf.length - offset), buf, offset, length)
}

function asciiWrite (buf, string, offset, length) {
  return blitBuffer(asciiToBytes(string), buf, offset, length)
}

function latin1Write (buf, string, offset, length) {
  return asciiWrite(buf, string, offset, length)
}

function base64Write (buf, string, offset, length) {
  return blitBuffer(base64ToBytes(string), buf, offset, length)
}

function ucs2Write (buf, string, offset, length) {
  return blitBuffer(utf16leToBytes(string, buf.length - offset), buf, offset, length)
}

Buffer.prototype.write = function write (string, offset, length, encoding) {
  // Buffer#write(string)
  if (offset === undefined) {
    encoding = 'utf8'
    length = this.length
    offset = 0
  // Buffer#write(string, encoding)
  } else if (length === undefined && typeof offset === 'string') {
    encoding = offset
    length = this.length
    offset = 0
  // Buffer#write(string, offset[, length][, encoding])
  } else if (isFinite(offset)) {
    offset = offset | 0
    if (isFinite(length)) {
      length = length | 0
      if (encoding === undefined) encoding = 'utf8'
    } else {
      encoding = length
      length = undefined
    }
  // legacy write(string, encoding, offset, length) - remove in v0.13
  } else {
    throw new Error(
      'Buffer.write(string, encoding, offset[, length]) is no longer supported'
    )
  }

  var remaining = this.length - offset
  if (length === undefined || length > remaining) length = remaining

  if ((string.length > 0 && (length < 0 || offset < 0)) || offset > this.length) {
    throw new RangeError('Attempt to write outside buffer bounds')
  }

  if (!encoding) encoding = 'utf8'

  var loweredCase = false
  for (;;) {
    switch (encoding) {
      case 'hex':
        return hexWrite(this, string, offset, length)

      case 'utf8':
      case 'utf-8':
        return utf8Write(this, string, offset, length)

      case 'ascii':
        return asciiWrite(this, string, offset, length)

      case 'latin1':
      case 'binary':
        return latin1Write(this, string, offset, length)

      case 'base64':
        // Warning: maxLength not taken into account in base64Write
        return base64Write(this, string, offset, length)

      case 'ucs2':
      case 'ucs-2':
      case 'utf16le':
      case 'utf-16le':
        return ucs2Write(this, string, offset, length)

      default:
        if (loweredCase) throw new TypeError('Unknown encoding: ' + encoding)
        encoding = ('' + encoding).toLowerCase()
        loweredCase = true
    }
  }
}

Buffer.prototype.toJSON = function toJSON () {
  return {
    type: 'Buffer',
    data: Array.prototype.slice.call(this._arr || this, 0)
  }
}

function base64Slice (buf, start, end) {
  if (start === 0 && end === buf.length) {
    return base64.fromByteArray(buf)
  } else {
    return base64.fromByteArray(buf.slice(start, end))
  }
}

function utf8Slice (buf, start, end) {
  end = Math.min(buf.length, end)
  var res = []

  var i = start
  while (i < end) {
    var firstByte = buf[i]
    var codePoint = null
    var bytesPerSequence = (firstByte > 0xEF) ? 4
      : (firstByte > 0xDF) ? 3
      : (firstByte > 0xBF) ? 2
      : 1

    if (i + bytesPerSequence <= end) {
      var secondByte, thirdByte, fourthByte, tempCodePoint

      switch (bytesPerSequence) {
        case 1:
          if (firstByte < 0x80) {
            codePoint = firstByte
          }
          break
        case 2:
          secondByte = buf[i + 1]
          if ((secondByte & 0xC0) === 0x80) {
            tempCodePoint = (firstByte & 0x1F) << 0x6 | (secondByte & 0x3F)
            if (tempCodePoint > 0x7F) {
              codePoint = tempCodePoint
            }
          }
          break
        case 3:
          secondByte = buf[i + 1]
          thirdByte = buf[i + 2]
          if ((secondByte & 0xC0) === 0x80 && (thirdByte & 0xC0) === 0x80) {
            tempCodePoint = (firstByte & 0xF) << 0xC | (secondByte & 0x3F) << 0x6 | (thirdByte & 0x3F)
            if (tempCodePoint > 0x7FF && (tempCodePoint < 0xD800 || tempCodePoint > 0xDFFF)) {
              codePoint = tempCodePoint
            }
          }
          break
        case 4:
          secondByte = buf[i + 1]
          thirdByte = buf[i + 2]
          fourthByte = buf[i + 3]
          if ((secondByte & 0xC0) === 0x80 && (thirdByte & 0xC0) === 0x80 && (fourthByte & 0xC0) === 0x80) {
            tempCodePoint = (firstByte & 0xF) << 0x12 | (secondByte & 0x3F) << 0xC | (thirdByte & 0x3F) << 0x6 | (fourthByte & 0x3F)
            if (tempCodePoint > 0xFFFF && tempCodePoint < 0x110000) {
              codePoint = tempCodePoint
            }
          }
      }
    }

    if (codePoint === null) {
      // we did not generate a valid codePoint so insert a
      // replacement char (U+FFFD) and advance only 1 byte
      codePoint = 0xFFFD
      bytesPerSequence = 1
    } else if (codePoint > 0xFFFF) {
      // encode to utf16 (surrogate pair dance)
      codePoint -= 0x10000
      res.push(codePoint >>> 10 & 0x3FF | 0xD800)
      codePoint = 0xDC00 | codePoint & 0x3FF
    }

    res.push(codePoint)
    i += bytesPerSequence
  }

  return decodeCodePointsArray(res)
}

// Based on http://stackoverflow.com/a/22747272/680742, the browser with
// the lowest limit is Chrome, with 0x10000 args.
// We go 1 magnitude less, for safety
var MAX_ARGUMENTS_LENGTH = 0x1000

function decodeCodePointsArray (codePoints) {
  var len = codePoints.length
  if (len <= MAX_ARGUMENTS_LENGTH) {
    return String.fromCharCode.apply(String, codePoints) // avoid extra slice()
  }

  // Decode in chunks to avoid "call stack size exceeded".
  var res = ''
  var i = 0
  while (i < len) {
    res += String.fromCharCode.apply(
      String,
      codePoints.slice(i, i += MAX_ARGUMENTS_LENGTH)
    )
  }
  return res
}

function asciiSlice (buf, start, end) {
  var ret = ''
  end = Math.min(buf.length, end)

  for (var i = start; i < end; ++i) {
    ret += String.fromCharCode(buf[i] & 0x7F)
  }
  return ret
}

function latin1Slice (buf, start, end) {
  var ret = ''
  end = Math.min(buf.length, end)

  for (var i = start; i < end; ++i) {
    ret += String.fromCharCode(buf[i])
  }
  return ret
}

function hexSlice (buf, start, end) {
  var len = buf.length

  if (!start || start < 0) start = 0
  if (!end || end < 0 || end > len) end = len

  var out = ''
  for (var i = start; i < end; ++i) {
    out += toHex(buf[i])
  }
  return out
}

function utf16leSlice (buf, start, end) {
  var bytes = buf.slice(start, end)
  var res = ''
  for (var i = 0; i < bytes.length; i += 2) {
    res += String.fromCharCode(bytes[i] + bytes[i + 1] * 256)
  }
  return res
}

Buffer.prototype.slice = function slice (start, end) {
  var len = this.length
  start = ~~start
  end = end === undefined ? len : ~~end

  if (start < 0) {
    start += len
    if (start < 0) start = 0
  } else if (start > len) {
    start = len
  }

  if (end < 0) {
    end += len
    if (end < 0) end = 0
  } else if (end > len) {
    end = len
  }

  if (end < start) end = start

  var newBuf
  if (Buffer.TYPED_ARRAY_SUPPORT) {
    newBuf = this.subarray(start, end)
    newBuf.__proto__ = Buffer.prototype
  } else {
    var sliceLen = end - start
    newBuf = new Buffer(sliceLen, undefined)
    for (var i = 0; i < sliceLen; ++i) {
      newBuf[i] = this[i + start]
    }
  }

  return newBuf
}

/*
 * Need to make sure that buffer isn't trying to write out of bounds.
 */
function checkOffset (offset, ext, length) {
  if ((offset % 1) !== 0 || offset < 0) throw new RangeError('offset is not uint')
  if (offset + ext > length) throw new RangeError('Trying to access beyond buffer length')
}

Buffer.prototype.readUIntLE = function readUIntLE (offset, byteLength, noAssert) {
  offset = offset | 0
  byteLength = byteLength | 0
  if (!noAssert) checkOffset(offset, byteLength, this.length)

  var val = this[offset]
  var mul = 1
  var i = 0
  while (++i < byteLength && (mul *= 0x100)) {
    val += this[offset + i] * mul
  }

  return val
}

Buffer.prototype.readUIntBE = function readUIntBE (offset, byteLength, noAssert) {
  offset = offset | 0
  byteLength = byteLength | 0
  if (!noAssert) {
    checkOffset(offset, byteLength, this.length)
  }

  var val = this[offset + --byteLength]
  var mul = 1
  while (byteLength > 0 && (mul *= 0x100)) {
    val += this[offset + --byteLength] * mul
  }

  return val
}

Buffer.prototype.readUInt8 = function readUInt8 (offset, noAssert) {
  if (!noAssert) checkOffset(offset, 1, this.length)
  return this[offset]
}

Buffer.prototype.readUInt16LE = function readUInt16LE (offset, noAssert) {
  if (!noAssert) checkOffset(offset, 2, this.length)
  return this[offset] | (this[offset + 1] << 8)
}

Buffer.prototype.readUInt16BE = function readUInt16BE (offset, noAssert) {
  if (!noAssert) checkOffset(offset, 2, this.length)
  return (this[offset] << 8) | this[offset + 1]
}

Buffer.prototype.readUInt32LE = function readUInt32LE (offset, noAssert) {
  if (!noAssert) checkOffset(offset, 4, this.length)

  return ((this[offset]) |
      (this[offset + 1] << 8) |
      (this[offset + 2] << 16)) +
      (this[offset + 3] * 0x1000000)
}

Buffer.prototype.readUInt32BE = function readUInt32BE (offset, noAssert) {
  if (!noAssert) checkOffset(offset, 4, this.length)

  return (this[offset] * 0x1000000) +
    ((this[offset + 1] << 16) |
    (this[offset + 2] << 8) |
    this[offset + 3])
}

Buffer.prototype.readIntLE = function readIntLE (offset, byteLength, noAssert) {
  offset = offset | 0
  byteLength = byteLength | 0
  if (!noAssert) checkOffset(offset, byteLength, this.length)

  var val = this[offset]
  var mul = 1
  var i = 0
  while (++i < byteLength && (mul *= 0x100)) {
    val += this[offset + i] * mul
  }
  mul *= 0x80

  if (val >= mul) val -= Math.pow(2, 8 * byteLength)

  return val
}

Buffer.prototype.readIntBE = function readIntBE (offset, byteLength, noAssert) {
  offset = offset | 0
  byteLength = byteLength | 0
  if (!noAssert) checkOffset(offset, byteLength, this.length)

  var i = byteLength
  var mul = 1
  var val = this[offset + --i]
  while (i > 0 && (mul *= 0x100)) {
    val += this[offset + --i] * mul
  }
  mul *= 0x80

  if (val >= mul) val -= Math.pow(2, 8 * byteLength)

  return val
}

Buffer.prototype.readInt8 = function readInt8 (offset, noAssert) {
  if (!noAssert) checkOffset(offset, 1, this.length)
  if (!(this[offset] & 0x80)) return (this[offset])
  return ((0xff - this[offset] + 1) * -1)
}

Buffer.prototype.readInt16LE = function readInt16LE (offset, noAssert) {
  if (!noAssert) checkOffset(offset, 2, this.length)
  var val = this[offset] | (this[offset + 1] << 8)
  return (val & 0x8000) ? val | 0xFFFF0000 : val
}

Buffer.prototype.readInt16BE = function readInt16BE (offset, noAssert) {
  if (!noAssert) checkOffset(offset, 2, this.length)
  var val = this[offset + 1] | (this[offset] << 8)
  return (val & 0x8000) ? val | 0xFFFF0000 : val
}

Buffer.prototype.readInt32LE = function readInt32LE (offset, noAssert) {
  if (!noAssert) checkOffset(offset, 4, this.length)

  return (this[offset]) |
    (this[offset + 1] << 8) |
    (this[offset + 2] << 16) |
    (this[offset + 3] << 24)
}

Buffer.prototype.readInt32BE = function readInt32BE (offset, noAssert) {
  if (!noAssert) checkOffset(offset, 4, this.length)

  return (this[offset] << 24) |
    (this[offset + 1] << 16) |
    (this[offset + 2] << 8) |
    (this[offset + 3])
}

Buffer.prototype.readFloatLE = function readFloatLE (offset, noAssert) {
  if (!noAssert) checkOffset(offset, 4, this.length)
  return ieee754.read(this, offset, true, 23, 4)
}

Buffer.prototype.readFloatBE = function readFloatBE (offset, noAssert) {
  if (!noAssert) checkOffset(offset, 4, this.length)
  return ieee754.read(this, offset, false, 23, 4)
}

Buffer.prototype.readDoubleLE = function readDoubleLE (offset, noAssert) {
  if (!noAssert) checkOffset(offset, 8, this.length)
  return ieee754.read(this, offset, true, 52, 8)
}

Buffer.prototype.readDoubleBE = function readDoubleBE (offset, noAssert) {
  if (!noAssert) checkOffset(offset, 8, this.length)
  return ieee754.read(this, offset, false, 52, 8)
}

function checkInt (buf, value, offset, ext, max, min) {
  if (!Buffer.isBuffer(buf)) throw new TypeError('"buffer" argument must be a Buffer instance')
  if (value > max || value < min) throw new RangeError('"value" argument is out of bounds')
  if (offset + ext > buf.length) throw new RangeError('Index out of range')
}

Buffer.prototype.writeUIntLE = function writeUIntLE (value, offset, byteLength, noAssert) {
  value = +value
  offset = offset | 0
  byteLength = byteLength | 0
  if (!noAssert) {
    var maxBytes = Math.pow(2, 8 * byteLength) - 1
    checkInt(this, value, offset, byteLength, maxBytes, 0)
  }

  var mul = 1
  var i = 0
  this[offset] = value & 0xFF
  while (++i < byteLength && (mul *= 0x100)) {
    this[offset + i] = (value / mul) & 0xFF
  }

  return offset + byteLength
}

Buffer.prototype.writeUIntBE = function writeUIntBE (value, offset, byteLength, noAssert) {
  value = +value
  offset = offset | 0
  byteLength = byteLength | 0
  if (!noAssert) {
    var maxBytes = Math.pow(2, 8 * byteLength) - 1
    checkInt(this, value, offset, byteLength, maxBytes, 0)
  }

  var i = byteLength - 1
  var mul = 1
  this[offset + i] = value & 0xFF
  while (--i >= 0 && (mul *= 0x100)) {
    this[offset + i] = (value / mul) & 0xFF
  }

  return offset + byteLength
}

Buffer.prototype.writeUInt8 = function writeUInt8 (value, offset, noAssert) {
  value = +value
  offset = offset | 0
  if (!noAssert) checkInt(this, value, offset, 1, 0xff, 0)
  if (!Buffer.TYPED_ARRAY_SUPPORT) value = Math.floor(value)
  this[offset] = (value & 0xff)
  return offset + 1
}

function objectWriteUInt16 (buf, value, offset, littleEndian) {
  if (value < 0) value = 0xffff + value + 1
  for (var i = 0, j = Math.min(buf.length - offset, 2); i < j; ++i) {
    buf[offset + i] = (value & (0xff << (8 * (littleEndian ? i : 1 - i)))) >>>
      (littleEndian ? i : 1 - i) * 8
  }
}

Buffer.prototype.writeUInt16LE = function writeUInt16LE (value, offset, noAssert) {
  value = +value
  offset = offset | 0
  if (!noAssert) checkInt(this, value, offset, 2, 0xffff, 0)
  if (Buffer.TYPED_ARRAY_SUPPORT) {
    this[offset] = (value & 0xff)
    this[offset + 1] = (value >>> 8)
  } else {
    objectWriteUInt16(this, value, offset, true)
  }
  return offset + 2
}

Buffer.prototype.writeUInt16BE = function writeUInt16BE (value, offset, noAssert) {
  value = +value
  offset = offset | 0
  if (!noAssert) checkInt(this, value, offset, 2, 0xffff, 0)
  if (Buffer.TYPED_ARRAY_SUPPORT) {
    this[offset] = (value >>> 8)
    this[offset + 1] = (value & 0xff)
  } else {
    objectWriteUInt16(this, value, offset, false)
  }
  return offset + 2
}

function objectWriteUInt32 (buf, value, offset, littleEndian) {
  if (value < 0) value = 0xffffffff + value + 1
  for (var i = 0, j = Math.min(buf.length - offset, 4); i < j; ++i) {
    buf[offset + i] = (value >>> (littleEndian ? i : 3 - i) * 8) & 0xff
  }
}

Buffer.prototype.writeUInt32LE = function writeUInt32LE (value, offset, noAssert) {
  value = +value
  offset = offset | 0
  if (!noAssert) checkInt(this, value, offset, 4, 0xffffffff, 0)
  if (Buffer.TYPED_ARRAY_SUPPORT) {
    this[offset + 3] = (value >>> 24)
    this[offset + 2] = (value >>> 16)
    this[offset + 1] = (value >>> 8)
    this[offset] = (value & 0xff)
  } else {
    objectWriteUInt32(this, value, offset, true)
  }
  return offset + 4
}

Buffer.prototype.writeUInt32BE = function writeUInt32BE (value, offset, noAssert) {
  value = +value
  offset = offset | 0
  if (!noAssert) checkInt(this, value, offset, 4, 0xffffffff, 0)
  if (Buffer.TYPED_ARRAY_SUPPORT) {
    this[offset] = (value >>> 24)
    this[offset + 1] = (value >>> 16)
    this[offset + 2] = (value >>> 8)
    this[offset + 3] = (value & 0xff)
  } else {
    objectWriteUInt32(this, value, offset, false)
  }
  return offset + 4
}

Buffer.prototype.writeIntLE = function writeIntLE (value, offset, byteLength, noAssert) {
  value = +value
  offset = offset | 0
  if (!noAssert) {
    var limit = Math.pow(2, 8 * byteLength - 1)

    checkInt(this, value, offset, byteLength, limit - 1, -limit)
  }

  var i = 0
  var mul = 1
  var sub = 0
  this[offset] = value & 0xFF
  while (++i < byteLength && (mul *= 0x100)) {
    if (value < 0 && sub === 0 && this[offset + i - 1] !== 0) {
      sub = 1
    }
    this[offset + i] = ((value / mul) >> 0) - sub & 0xFF
  }

  return offset + byteLength
}

Buffer.prototype.writeIntBE = function writeIntBE (value, offset, byteLength, noAssert) {
  value = +value
  offset = offset | 0
  if (!noAssert) {
    var limit = Math.pow(2, 8 * byteLength - 1)

    checkInt(this, value, offset, byteLength, limit - 1, -limit)
  }

  var i = byteLength - 1
  var mul = 1
  var sub = 0
  this[offset + i] = value & 0xFF
  while (--i >= 0 && (mul *= 0x100)) {
    if (value < 0 && sub === 0 && this[offset + i + 1] !== 0) {
      sub = 1
    }
    this[offset + i] = ((value / mul) >> 0) - sub & 0xFF
  }

  return offset + byteLength
}

Buffer.prototype.writeInt8 = function writeInt8 (value, offset, noAssert) {
  value = +value
  offset = offset | 0
  if (!noAssert) checkInt(this, value, offset, 1, 0x7f, -0x80)
  if (!Buffer.TYPED_ARRAY_SUPPORT) value = Math.floor(value)
  if (value < 0) value = 0xff + value + 1
  this[offset] = (value & 0xff)
  return offset + 1
}

Buffer.prototype.writeInt16LE = function writeInt16LE (value, offset, noAssert) {
  value = +value
  offset = offset | 0
  if (!noAssert) checkInt(this, value, offset, 2, 0x7fff, -0x8000)
  if (Buffer.TYPED_ARRAY_SUPPORT) {
    this[offset] = (value & 0xff)
    this[offset + 1] = (value >>> 8)
  } else {
    objectWriteUInt16(this, value, offset, true)
  }
  return offset + 2
}

Buffer.prototype.writeInt16BE = function writeInt16BE (value, offset, noAssert) {
  value = +value
  offset = offset | 0
  if (!noAssert) checkInt(this, value, offset, 2, 0x7fff, -0x8000)
  if (Buffer.TYPED_ARRAY_SUPPORT) {
    this[offset] = (value >>> 8)
    this[offset + 1] = (value & 0xff)
  } else {
    objectWriteUInt16(this, value, offset, false)
  }
  return offset + 2
}

Buffer.prototype.writeInt32LE = function writeInt32LE (value, offset, noAssert) {
  value = +value
  offset = offset | 0
  if (!noAssert) checkInt(this, value, offset, 4, 0x7fffffff, -0x80000000)
  if (Buffer.TYPED_ARRAY_SUPPORT) {
    this[offset] = (value & 0xff)
    this[offset + 1] = (value >>> 8)
    this[offset + 2] = (value >>> 16)
    this[offset + 3] = (value >>> 24)
  } else {
    objectWriteUInt32(this, value, offset, true)
  }
  return offset + 4
}

Buffer.prototype.writeInt32BE = function writeInt32BE (value, offset, noAssert) {
  value = +value
  offset = offset | 0
  if (!noAssert) checkInt(this, value, offset, 4, 0x7fffffff, -0x80000000)
  if (value < 0) value = 0xffffffff + value + 1
  if (Buffer.TYPED_ARRAY_SUPPORT) {
    this[offset] = (value >>> 24)
    this[offset + 1] = (value >>> 16)
    this[offset + 2] = (value >>> 8)
    this[offset + 3] = (value & 0xff)
  } else {
    objectWriteUInt32(this, value, offset, false)
  }
  return offset + 4
}

function checkIEEE754 (buf, value, offset, ext, max, min) {
  if (offset + ext > buf.length) throw new RangeError('Index out of range')
  if (offset < 0) throw new RangeError('Index out of range')
}

function writeFloat (buf, value, offset, littleEndian, noAssert) {
  if (!noAssert) {
    checkIEEE754(buf, value, offset, 4, 3.4028234663852886e+38, -3.4028234663852886e+38)
  }
  ieee754.write(buf, value, offset, littleEndian, 23, 4)
  return offset + 4
}

Buffer.prototype.writeFloatLE = function writeFloatLE (value, offset, noAssert) {
  return writeFloat(this, value, offset, true, noAssert)
}

Buffer.prototype.writeFloatBE = function writeFloatBE (value, offset, noAssert) {
  return writeFloat(this, value, offset, false, noAssert)
}

function writeDouble (buf, value, offset, littleEndian, noAssert) {
  if (!noAssert) {
    checkIEEE754(buf, value, offset, 8, 1.7976931348623157E+308, -1.7976931348623157E+308)
  }
  ieee754.write(buf, value, offset, littleEndian, 52, 8)
  return offset + 8
}

Buffer.prototype.writeDoubleLE = function writeDoubleLE (value, offset, noAssert) {
  return writeDouble(this, value, offset, true, noAssert)
}

Buffer.prototype.writeDoubleBE = function writeDoubleBE (value, offset, noAssert) {
  return writeDouble(this, value, offset, false, noAssert)
}

// copy(targetBuffer, targetStart=0, sourceStart=0, sourceEnd=buffer.length)
Buffer.prototype.copy = function copy (target, targetStart, start, end) {
  if (!start) start = 0
  if (!end && end !== 0) end = this.length
  if (targetStart >= target.length) targetStart = target.length
  if (!targetStart) targetStart = 0
  if (end > 0 && end < start) end = start

  // Copy 0 bytes; we're done
  if (end === start) return 0
  if (target.length === 0 || this.length === 0) return 0

  // Fatal error conditions
  if (targetStart < 0) {
    throw new RangeError('targetStart out of bounds')
  }
  if (start < 0 || start >= this.length) throw new RangeError('sourceStart out of bounds')
  if (end < 0) throw new RangeError('sourceEnd out of bounds')

  // Are we oob?
  if (end > this.length) end = this.length
  if (target.length - targetStart < end - start) {
    end = target.length - targetStart + start
  }

  var len = end - start
  var i

  if (this === target && start < targetStart && targetStart < end) {
    // descending copy from end
    for (i = len - 1; i >= 0; --i) {
      target[i + targetStart] = this[i + start]
    }
  } else if (len < 1000 || !Buffer.TYPED_ARRAY_SUPPORT) {
    // ascending copy from start
    for (i = 0; i < len; ++i) {
      target[i + targetStart] = this[i + start]
    }
  } else {
    Uint8Array.prototype.set.call(
      target,
      this.subarray(start, start + len),
      targetStart
    )
  }

  return len
}

// Usage:
//    buffer.fill(number[, offset[, end]])
//    buffer.fill(buffer[, offset[, end]])
//    buffer.fill(string[, offset[, end]][, encoding])
Buffer.prototype.fill = function fill (val, start, end, encoding) {
  // Handle string cases:
  if (typeof val === 'string') {
    if (typeof start === 'string') {
      encoding = start
      start = 0
      end = this.length
    } else if (typeof end === 'string') {
      encoding = end
      end = this.length
    }
    if (val.length === 1) {
      var code = val.charCodeAt(0)
      if (code < 256) {
        val = code
      }
    }
    if (encoding !== undefined && typeof encoding !== 'string') {
      throw new TypeError('encoding must be a string')
    }
    if (typeof encoding === 'string' && !Buffer.isEncoding(encoding)) {
      throw new TypeError('Unknown encoding: ' + encoding)
    }
  } else if (typeof val === 'number') {
    val = val & 255
  }

  // Invalid ranges are not set to a default, so can range check early.
  if (start < 0 || this.length < start || this.length < end) {
    throw new RangeError('Out of range index')
  }

  if (end <= start) {
    return this
  }

  start = start >>> 0
  end = end === undefined ? this.length : end >>> 0

  if (!val) val = 0

  var i
  if (typeof val === 'number') {
    for (i = start; i < end; ++i) {
      this[i] = val
    }
  } else {
    var bytes = Buffer.isBuffer(val)
      ? val
      : utf8ToBytes(new Buffer(val, encoding).toString())
    var len = bytes.length
    for (i = 0; i < end - start; ++i) {
      this[i + start] = bytes[i % len]
    }
  }

  return this
}

// HELPER FUNCTIONS
// ================

var INVALID_BASE64_RE = /[^+\/0-9A-Za-z-_]/g

function base64clean (str) {
  // Node strips out invalid characters like \n and \t from the string, base64-js does not
  str = stringtrim(str).replace(INVALID_BASE64_RE, '')
  // Node converts strings with length < 2 to ''
  if (str.length < 2) return ''
  // Node allows for non-padded base64 strings (missing trailing ===), base64-js does not
  while (str.length % 4 !== 0) {
    str = str + '='
  }
  return str
}

function stringtrim (str) {
  if (str.trim) return str.trim()
  return str.replace(/^\s+|\s+$/g, '')
}

function toHex (n) {
  if (n < 16) return '0' + n.toString(16)
  return n.toString(16)
}

function utf8ToBytes (string, units) {
  units = units || Infinity
  var codePoint
  var length = string.length
  var leadSurrogate = null
  var bytes = []

  for (var i = 0; i < length; ++i) {
    codePoint = string.charCodeAt(i)

    // is surrogate component
    if (codePoint > 0xD7FF && codePoint < 0xE000) {
      // last char was a lead
      if (!leadSurrogate) {
        // no lead yet
        if (codePoint > 0xDBFF) {
          // unexpected trail
          if ((units -= 3) > -1) bytes.push(0xEF, 0xBF, 0xBD)
          continue
        } else if (i + 1 === length) {
          // unpaired lead
          if ((units -= 3) > -1) bytes.push(0xEF, 0xBF, 0xBD)
          continue
        }

        // valid lead
        leadSurrogate = codePoint

        continue
      }

      // 2 leads in a row
      if (codePoint < 0xDC00) {
        if ((units -= 3) > -1) bytes.push(0xEF, 0xBF, 0xBD)
        leadSurrogate = codePoint
        continue
      }

      // valid surrogate pair
      codePoint = (leadSurrogate - 0xD800 << 10 | codePoint - 0xDC00) + 0x10000
    } else if (leadSurrogate) {
      // valid bmp char, but last char was a lead
      if ((units -= 3) > -1) bytes.push(0xEF, 0xBF, 0xBD)
    }

    leadSurrogate = null

    // encode utf8
    if (codePoint < 0x80) {
      if ((units -= 1) < 0) break
      bytes.push(codePoint)
    } else if (codePoint < 0x800) {
      if ((units -= 2) < 0) break
      bytes.push(
        codePoint >> 0x6 | 0xC0,
        codePoint & 0x3F | 0x80
      )
    } else if (codePoint < 0x10000) {
      if ((units -= 3) < 0) break
      bytes.push(
        codePoint >> 0xC | 0xE0,
        codePoint >> 0x6 & 0x3F | 0x80,
        codePoint & 0x3F | 0x80
      )
    } else if (codePoint < 0x110000) {
      if ((units -= 4) < 0) break
      bytes.push(
        codePoint >> 0x12 | 0xF0,
        codePoint >> 0xC & 0x3F | 0x80,
        codePoint >> 0x6 & 0x3F | 0x80,
        codePoint & 0x3F | 0x80
      )
    } else {
      throw new Error('Invalid code point')
    }
  }

  return bytes
}

function asciiToBytes (str) {
  var byteArray = []
  for (var i = 0; i < str.length; ++i) {
    // Node's code seems to be doing this and not & 0x7F..
    byteArray.push(str.charCodeAt(i) & 0xFF)
  }
  return byteArray
}

function utf16leToBytes (str, units) {
  var c, hi, lo
  var byteArray = []
  for (var i = 0; i < str.length; ++i) {
    if ((units -= 2) < 0) break

    c = str.charCodeAt(i)
    hi = c >> 8
    lo = c % 256
    byteArray.push(lo)
    byteArray.push(hi)
  }

  return byteArray
}

function base64ToBytes (str) {
  return base64.toByteArray(base64clean(str))
}

function blitBuffer (src, dst, offset, length) {
  for (var i = 0; i < length; ++i) {
    if ((i + offset >= dst.length) || (i >= src.length)) break
    dst[i + offset] = src[i]
  }
  return i
}

function isnan (val) {
  return val !== val // eslint-disable-line no-self-compare
}

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {},require("buffer").Buffer)

},{"base64-js":1,"buffer":3,"ieee754":5,"isarray":6}],4:[function(require,module,exports){
!function(t,e){"object"==typeof exports&&"undefined"!=typeof module?module.exports=e():"function"==typeof define&&define.amd?define(e):(t="undefined"!=typeof globalThis?globalThis:t||self).dayjs=e()}(this,(function(){"use strict";var t=1e3,e=6e4,n=36e5,r="millisecond",i="second",s="minute",u="hour",a="day",o="week",f="month",h="quarter",c="year",d="date",$="Invalid Date",l=/^(\d{4})[-/]?(\d{1,2})?[-/]?(\d{0,2})[Tt\s]*(\d{1,2})?:?(\d{1,2})?:?(\d{1,2})?[.:]?(\d+)?$/,y=/\[([^\]]+)]|Y{1,4}|M{1,4}|D{1,2}|d{1,4}|H{1,2}|h{1,2}|a|A|m{1,2}|s{1,2}|Z{1,2}|SSS/g,M={name:"en",weekdays:"Sunday_Monday_Tuesday_Wednesday_Thursday_Friday_Saturday".split("_"),months:"January_February_March_April_May_June_July_August_September_October_November_December".split("_")},m=function(t,e,n){var r=String(t);return!r||r.length>=e?t:""+Array(e+1-r.length).join(n)+t},g={s:m,z:function(t){var e=-t.utcOffset(),n=Math.abs(e),r=Math.floor(n/60),i=n%60;return(e<=0?"+":"-")+m(r,2,"0")+":"+m(i,2,"0")},m:function t(e,n){if(e.date()<n.date())return-t(n,e);var r=12*(n.year()-e.year())+(n.month()-e.month()),i=e.clone().add(r,f),s=n-i<0,u=e.clone().add(r+(s?-1:1),f);return+(-(r+(n-i)/(s?i-u:u-i))||0)},a:function(t){return t<0?Math.ceil(t)||0:Math.floor(t)},p:function(t){return{M:f,y:c,w:o,d:a,D:d,h:u,m:s,s:i,ms:r,Q:h}[t]||String(t||"").toLowerCase().replace(/s$/,"")},u:function(t){return void 0===t}},D="en",v={};v[D]=M;var p=function(t){return t instanceof _},S=function(t,e,n){var r;if(!t)return D;if("string"==typeof t)v[t]&&(r=t),e&&(v[t]=e,r=t);else{var i=t.name;v[i]=t,r=i}return!n&&r&&(D=r),r||!n&&D},w=function(t,e){if(p(t))return t.clone();var n="object"==typeof e?e:{};return n.date=t,n.args=arguments,new _(n)},O=g;O.l=S,O.i=p,O.w=function(t,e){return w(t,{locale:e.$L,utc:e.$u,x:e.$x,$offset:e.$offset})};var _=function(){function M(t){this.$L=S(t.locale,null,!0),this.parse(t)}var m=M.prototype;return m.parse=function(t){this.$d=function(t){var e=t.date,n=t.utc;if(null===e)return new Date(NaN);if(O.u(e))return new Date;if(e instanceof Date)return new Date(e);if("string"==typeof e&&!/Z$/i.test(e)){var r=e.match(l);if(r){var i=r[2]-1||0,s=(r[7]||"0").substring(0,3);return n?new Date(Date.UTC(r[1],i,r[3]||1,r[4]||0,r[5]||0,r[6]||0,s)):new Date(r[1],i,r[3]||1,r[4]||0,r[5]||0,r[6]||0,s)}}return new Date(e)}(t),this.$x=t.x||{},this.init()},m.init=function(){var t=this.$d;this.$y=t.getFullYear(),this.$M=t.getMonth(),this.$D=t.getDate(),this.$W=t.getDay(),this.$H=t.getHours(),this.$m=t.getMinutes(),this.$s=t.getSeconds(),this.$ms=t.getMilliseconds()},m.$utils=function(){return O},m.isValid=function(){return!(this.$d.toString()===$)},m.isSame=function(t,e){var n=w(t);return this.startOf(e)<=n&&n<=this.endOf(e)},m.isAfter=function(t,e){return w(t)<this.startOf(e)},m.isBefore=function(t,e){return this.endOf(e)<w(t)},m.$g=function(t,e,n){return O.u(t)?this[e]:this.set(n,t)},m.unix=function(){return Math.floor(this.valueOf()/1e3)},m.valueOf=function(){return this.$d.getTime()},m.startOf=function(t,e){var n=this,r=!!O.u(e)||e,h=O.p(t),$=function(t,e){var i=O.w(n.$u?Date.UTC(n.$y,e,t):new Date(n.$y,e,t),n);return r?i:i.endOf(a)},l=function(t,e){return O.w(n.toDate()[t].apply(n.toDate("s"),(r?[0,0,0,0]:[23,59,59,999]).slice(e)),n)},y=this.$W,M=this.$M,m=this.$D,g="set"+(this.$u?"UTC":"");switch(h){case c:return r?$(1,0):$(31,11);case f:return r?$(1,M):$(0,M+1);case o:var D=this.$locale().weekStart||0,v=(y<D?y+7:y)-D;return $(r?m-v:m+(6-v),M);case a:case d:return l(g+"Hours",0);case u:return l(g+"Minutes",1);case s:return l(g+"Seconds",2);case i:return l(g+"Milliseconds",3);default:return this.clone()}},m.endOf=function(t){return this.startOf(t,!1)},m.$set=function(t,e){var n,o=O.p(t),h="set"+(this.$u?"UTC":""),$=(n={},n[a]=h+"Date",n[d]=h+"Date",n[f]=h+"Month",n[c]=h+"FullYear",n[u]=h+"Hours",n[s]=h+"Minutes",n[i]=h+"Seconds",n[r]=h+"Milliseconds",n)[o],l=o===a?this.$D+(e-this.$W):e;if(o===f||o===c){var y=this.clone().set(d,1);y.$d[$](l),y.init(),this.$d=y.set(d,Math.min(this.$D,y.daysInMonth())).$d}else $&&this.$d[$](l);return this.init(),this},m.set=function(t,e){return this.clone().$set(t,e)},m.get=function(t){return this[O.p(t)]()},m.add=function(r,h){var d,$=this;r=Number(r);var l=O.p(h),y=function(t){var e=w($);return O.w(e.date(e.date()+Math.round(t*r)),$)};if(l===f)return this.set(f,this.$M+r);if(l===c)return this.set(c,this.$y+r);if(l===a)return y(1);if(l===o)return y(7);var M=(d={},d[s]=e,d[u]=n,d[i]=t,d)[l]||1,m=this.$d.getTime()+r*M;return O.w(m,this)},m.subtract=function(t,e){return this.add(-1*t,e)},m.format=function(t){var e=this,n=this.$locale();if(!this.isValid())return n.invalidDate||$;var r=t||"YYYY-MM-DDTHH:mm:ssZ",i=O.z(this),s=this.$H,u=this.$m,a=this.$M,o=n.weekdays,f=n.months,h=function(t,n,i,s){return t&&(t[n]||t(e,r))||i[n].substr(0,s)},c=function(t){return O.s(s%12||12,t,"0")},d=n.meridiem||function(t,e,n){var r=t<12?"AM":"PM";return n?r.toLowerCase():r},l={YY:String(this.$y).slice(-2),YYYY:this.$y,M:a+1,MM:O.s(a+1,2,"0"),MMM:h(n.monthsShort,a,f,3),MMMM:h(f,a),D:this.$D,DD:O.s(this.$D,2,"0"),d:String(this.$W),dd:h(n.weekdaysMin,this.$W,o,2),ddd:h(n.weekdaysShort,this.$W,o,3),dddd:o[this.$W],H:String(s),HH:O.s(s,2,"0"),h:c(1),hh:c(2),a:d(s,u,!0),A:d(s,u,!1),m:String(u),mm:O.s(u,2,"0"),s:String(this.$s),ss:O.s(this.$s,2,"0"),SSS:O.s(this.$ms,3,"0"),Z:i};return r.replace(y,(function(t,e){return e||l[t]||i.replace(":","")}))},m.utcOffset=function(){return 15*-Math.round(this.$d.getTimezoneOffset()/15)},m.diff=function(r,d,$){var l,y=O.p(d),M=w(r),m=(M.utcOffset()-this.utcOffset())*e,g=this-M,D=O.m(this,M);return D=(l={},l[c]=D/12,l[f]=D,l[h]=D/3,l[o]=(g-m)/6048e5,l[a]=(g-m)/864e5,l[u]=g/n,l[s]=g/e,l[i]=g/t,l)[y]||g,$?D:O.a(D)},m.daysInMonth=function(){return this.endOf(f).$D},m.$locale=function(){return v[this.$L]},m.locale=function(t,e){if(!t)return this.$L;var n=this.clone(),r=S(t,e,!0);return r&&(n.$L=r),n},m.clone=function(){return O.w(this.$d,this)},m.toDate=function(){return new Date(this.valueOf())},m.toJSON=function(){return this.isValid()?this.toISOString():null},m.toISOString=function(){return this.$d.toISOString()},m.toString=function(){return this.$d.toUTCString()},M}(),b=_.prototype;return w.prototype=b,[["$ms",r],["$s",i],["$m",s],["$H",u],["$W",a],["$M",f],["$y",c],["$D",d]].forEach((function(t){b[t[1]]=function(e){return this.$g(e,t[0],t[1])}})),w.extend=function(t,e){return t.$i||(t(e,_,w),t.$i=!0),w},w.locale=S,w.isDayjs=p,w.unix=function(t){return w(1e3*t)},w.en=v[D],w.Ls=v,w.p={},w}));
},{}],5:[function(require,module,exports){
/*! ieee754. BSD-3-Clause License. Feross Aboukhadijeh <https://feross.org/opensource> */
exports.read = function (buffer, offset, isLE, mLen, nBytes) {
  var e, m
  var eLen = (nBytes * 8) - mLen - 1
  var eMax = (1 << eLen) - 1
  var eBias = eMax >> 1
  var nBits = -7
  var i = isLE ? (nBytes - 1) : 0
  var d = isLE ? -1 : 1
  var s = buffer[offset + i]

  i += d

  e = s & ((1 << (-nBits)) - 1)
  s >>= (-nBits)
  nBits += eLen
  for (; nBits > 0; e = (e * 256) + buffer[offset + i], i += d, nBits -= 8) {}

  m = e & ((1 << (-nBits)) - 1)
  e >>= (-nBits)
  nBits += mLen
  for (; nBits > 0; m = (m * 256) + buffer[offset + i], i += d, nBits -= 8) {}

  if (e === 0) {
    e = 1 - eBias
  } else if (e === eMax) {
    return m ? NaN : ((s ? -1 : 1) * Infinity)
  } else {
    m = m + Math.pow(2, mLen)
    e = e - eBias
  }
  return (s ? -1 : 1) * m * Math.pow(2, e - mLen)
}

exports.write = function (buffer, value, offset, isLE, mLen, nBytes) {
  var e, m, c
  var eLen = (nBytes * 8) - mLen - 1
  var eMax = (1 << eLen) - 1
  var eBias = eMax >> 1
  var rt = (mLen === 23 ? Math.pow(2, -24) - Math.pow(2, -77) : 0)
  var i = isLE ? 0 : (nBytes - 1)
  var d = isLE ? 1 : -1
  var s = value < 0 || (value === 0 && 1 / value < 0) ? 1 : 0

  value = Math.abs(value)

  if (isNaN(value) || value === Infinity) {
    m = isNaN(value) ? 1 : 0
    e = eMax
  } else {
    e = Math.floor(Math.log(value) / Math.LN2)
    if (value * (c = Math.pow(2, -e)) < 1) {
      e--
      c *= 2
    }
    if (e + eBias >= 1) {
      value += rt / c
    } else {
      value += rt * Math.pow(2, 1 - eBias)
    }
    if (value * c >= 2) {
      e++
      c /= 2
    }

    if (e + eBias >= eMax) {
      m = 0
      e = eMax
    } else if (e + eBias >= 1) {
      m = ((value * c) - 1) * Math.pow(2, mLen)
      e = e + eBias
    } else {
      m = value * Math.pow(2, eBias - 1) * Math.pow(2, mLen)
      e = 0
    }
  }

  for (; mLen >= 8; buffer[offset + i] = m & 0xff, i += d, m /= 256, mLen -= 8) {}

  e = (e << mLen) | m
  eLen += mLen
  for (; eLen > 0; buffer[offset + i] = e & 0xff, i += d, e /= 256, eLen -= 8) {}

  buffer[offset + i - d] |= s * 128
}

},{}],6:[function(require,module,exports){
var toString = {}.toString;

module.exports = Array.isArray || function (arr) {
  return toString.call(arr) == '[object Array]';
};

},{}],7:[function(require,module,exports){
(function (process,global,Buffer,__argument0,__argument1,__argument2,__argument3,setImmediate){
/*!

JSZip v3.10.1 - A JavaScript class for generating and reading zip files
<http://stuartk.com/jszip>

(c) 2009-2016 Stuart Knightley <stuart [at] stuartk.com>
Dual licenced under the MIT license or GPLv3. See https://raw.github.com/Stuk/jszip/main/LICENSE.markdown.

JSZip uses the library pako released under the MIT license :
https://github.com/nodeca/pako/blob/main/LICENSE
*/

! function(e) {
	if ("object" == typeof exports && "undefined" != typeof module) module.exports = e();
	else if ("function" == typeof define && define.amd) define([], e);
	else {
		("undefined" != typeof window ? window : "undefined" != typeof global ? global : "undefined" != typeof self ? self : this)
		.JSZip = e()
	}
}(function() {
	return function s(a, o, h) {
		function u(r, e) {
			if (!o[r]) {
				if (!a[r]) {
					var t = "function" == typeof require && require;
					if (!e && t) return t(r, !0);
					if (l) return l(r, !0);
					var n = new Error("Cannot find module '" + r + "'");
					throw n.code = "MODULE_NOT_FOUND", n
				}
				var i = o[r] = {
					exports: {}
				};
				a[r][0].call(i.exports, function(e) {
					var t = a[r][1][e];
					return u(t || e)
				}, i, i.exports, s, a, o, h)
			}
			return o[r].exports
		}
		for (var l = "function" == typeof require && require, e = 0; e < h.length; e++) u(h[e]);
		return u
	}({
		1: [function(e, t, r) {
			"use strict";
			var d = e("./utils"),
				c = e("./support"),
				p = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
			r.encode = function(e) {
				for (var t, r, n, i, s, a, o, h = [], u = 0, l = e.length, f = l, c = "string" !== d.getTypeOf(e); u < e.length;) f = l - u, n = c ? (t = e[u++], r = u < l ? e[u++] : 0, u < l ? e[u++] : 0) : (t = e.charCodeAt(u++), r = u < l ? e.charCodeAt(u++) : 0, u < l ? e.charCodeAt(u++) : 0), i = t >> 2, s = (3 & t) << 4 | r >> 4, a = 1 < f ? (15 & r) << 2 | n >> 6 : 64, o = 2 < f ? 63 & n : 64, h.push(p.charAt(i) + p.charAt(s) + p.charAt(a) + p.charAt(o));
				return h.join("")
			}, r.decode = function(e) {
				var t, r, n, i, s, a, o = 0,
					h = 0,
					u = "data:";
				if (e.substr(0, u.length) === u) throw new Error("Invalid base64 input, it looks like a data url.");
				var l, f = 3 * (e = e.replace(/[^A-Za-z0-9+/=]/g, ""))
					.length / 4;
				if (e.charAt(e.length - 1) === p.charAt(64) && f--, e.charAt(e.length - 2) === p.charAt(64) && f--, f % 1 != 0) throw new Error("Invalid base64 input, bad content length.");
				for (l = c.uint8array ? new Uint8Array(0 | f) : new Array(0 | f); o < e.length;) t = p.indexOf(e.charAt(o++)) << 2 | (i = p.indexOf(e.charAt(o++))) >> 4, r = (15 & i) << 4 | (s = p.indexOf(e.charAt(o++))) >> 2, n = (3 & s) << 6 | (a = p.indexOf(e.charAt(o++))), l[h++] = t, 64 !== s && (l[h++] = r), 64 !== a && (l[h++] = n);
				return l
			}
		}, {
			"./support": 30,
			"./utils": 32
		}],
		2: [function(e, t, r) {
			"use strict";
			var n = e("./external"),
				i = e("./stream/DataWorker"),
				s = e("./stream/Crc32Probe"),
				a = e("./stream/DataLengthProbe");

			function o(e, t, r, n, i) {
				this.compressedSize = e, this.uncompressedSize = t, this.crc32 = r, this.compression = n, this.compressedContent = i
			}
			o.prototype = {
				getContentWorker: function() {
					var e = new i(n.Promise.resolve(this.compressedContent))
						.pipe(this.compression.uncompressWorker())
						.pipe(new a("data_length")),
						t = this;
					return e.on("end", function() {
						if (this.streamInfo.data_length !== t.uncompressedSize) throw new Error("Bug : uncompressed data size mismatch")
					}), e
				},
				getCompressedWorker: function() {
					return new i(n.Promise.resolve(this.compressedContent))
						.withStreamInfo("compressedSize", this.compressedSize)
						.withStreamInfo("uncompressedSize", this.uncompressedSize)
						.withStreamInfo("crc32", this.crc32)
						.withStreamInfo("compression", this.compression)
				}
			}, o.createWorkerFrom = function(e, t, r) {
				return e.pipe(new s)
					.pipe(new a("uncompressedSize"))
					.pipe(t.compressWorker(r))
					.pipe(new a("compressedSize"))
					.withStreamInfo("compression", t)
			}, t.exports = o
		}, {
			"./external": 6,
			"./stream/Crc32Probe": 25,
			"./stream/DataLengthProbe": 26,
			"./stream/DataWorker": 27
		}],
		3: [function(e, t, r) {
			"use strict";
			var n = e("./stream/GenericWorker");
			r.STORE = {
				magic: "\0\0",
				compressWorker: function() {
					return new n("STORE compression")
				},
				uncompressWorker: function() {
					return new n("STORE decompression")
				}
			}, r.DEFLATE = e("./flate")
		}, {
			"./flate": 7,
			"./stream/GenericWorker": 28
		}],
		4: [function(e, t, r) {
			"use strict";
			var n = e("./utils");
			var o = function() {
				for (var e, t = [], r = 0; r < 256; r++) {
					e = r;
					for (var n = 0; n < 8; n++) e = 1 & e ? 3988292384 ^ e >>> 1 : e >>> 1;
					t[r] = e
				}
				return t
			}();
			t.exports = function(e, t) {
				return void 0 !== e && e.length ? "string" !== n.getTypeOf(e) ? function(e, t, r, n) {
					var i = o,
						s = n + r;
					e ^= -1;
					for (var a = n; a < s; a++) e = e >>> 8 ^ i[255 & (e ^ t[a])];
					return -1 ^ e
				}(0 | t, e, e.length, 0) : function(e, t, r, n) {
					var i = o,
						s = n + r;
					e ^= -1;
					for (var a = n; a < s; a++) e = e >>> 8 ^ i[255 & (e ^ t.charCodeAt(a))];
					return -1 ^ e
				}(0 | t, e, e.length, 0) : 0
			}
		}, {
			"./utils": 32
		}],
		5: [function(e, t, r) {
			"use strict";
			r.base64 = !1, r.binary = !1, r.dir = !1, r.createFolders = !0, r.date = null, r.compression = null, r.compressionOptions = null, r.comment = null, r.unixPermissions = null, r.dosPermissions = null
		}, {}],
		6: [function(e, t, r) {
			"use strict";
			var n = null;
			n = "undefined" != typeof Promise ? Promise : e("lie"), t.exports = {
				Promise: n
			}
		}, {
			lie: 37
		}],
		7: [function(e, t, r) {
			"use strict";
			var n = "undefined" != typeof Uint8Array && "undefined" != typeof Uint16Array && "undefined" != typeof Uint32Array,
				i = e("pako"),
				s = e("./utils"),
				a = e("./stream/GenericWorker"),
				o = n ? "uint8array" : "array";

			function h(e, t) {
				a.call(this, "FlateWorker/" + e), this._pako = null, this._pakoAction = e, this._pakoOptions = t, this.meta = {}
			}
			r.magic = "\b\0", s.inherits(h, a), h.prototype.processChunk = function(e) {
				this.meta = e.meta, null === this._pako && this._createPako(), this._pako.push(s.transformTo(o, e.data), !1)
			}, h.prototype.flush = function() {
				a.prototype.flush.call(this), null === this._pako && this._createPako(), this._pako.push([], !0)
			}, h.prototype.cleanUp = function() {
				a.prototype.cleanUp.call(this), this._pako = null
			}, h.prototype._createPako = function() {
				this._pako = new i[this._pakoAction]({
					raw: !0,
					level: this._pakoOptions.level || -1
				});
				var t = this;
				this._pako.onData = function(e) {
					t.push({
						data: e,
						meta: t.meta
					})
				}
			}, r.compressWorker = function(e) {
				return new h("Deflate", e)
			}, r.uncompressWorker = function() {
				return new h("Inflate", {})
			}
		}, {
			"./stream/GenericWorker": 28,
			"./utils": 32,
			pako: 38
		}],
		8: [function(e, t, r) {
			"use strict";

			function A(e, t) {
				var r, n = "";
				for (r = 0; r < t; r++) n += String.fromCharCode(255 & e), e >>>= 8;
				return n
			}

			function n(e, t, r, n, i, s) {
				var a, o, h = e.file,
					u = e.compression,
					l = s !== O.utf8encode,
					f = I.transformTo("string", s(h.name)),
					c = I.transformTo("string", O.utf8encode(h.name)),
					d = h.comment,
					p = I.transformTo("string", s(d)),
					m = I.transformTo("string", O.utf8encode(d)),
					_ = c.length !== h.name.length,
					g = m.length !== d.length,
					b = "",
					v = "",
					y = "",
					w = h.dir,
					k = h.date,
					x = {
						crc32: 0,
						compressedSize: 0,
						uncompressedSize: 0
					};
				t && !r || (x.crc32 = e.crc32, x.compressedSize = e.compressedSize, x.uncompressedSize = e.uncompressedSize);
				var S = 0;
				t && (S |= 8), l || !_ && !g || (S |= 2048);
				var z = 0,
					C = 0;
				w && (z |= 16), "UNIX" === i ? (C = 798, z |= function(e, t) {
					var r = e;
					return e || (r = t ? 16893 : 33204), (65535 & r) << 16
				}(h.unixPermissions, w)) : (C = 20, z |= function(e) {
					return 63 & (e || 0)
				}(h.dosPermissions)), a = k.getUTCHours(), a <<= 6, a |= k.getUTCMinutes(), a <<= 5, a |= k.getUTCSeconds() / 2, o = k.getUTCFullYear() - 1980, o <<= 4, o |= k.getUTCMonth() + 1, o <<= 5, o |= k.getUTCDate(), _ && (v = A(1, 1) + A(B(f), 4) + c, b += "up" + A(v.length, 2) + v), g && (y = A(1, 1) + A(B(p), 4) + m, b += "uc" + A(y.length, 2) + y);
				var E = "";
				return E += "\n\0", E += A(S, 2), E += u.magic, E += A(a, 2), E += A(o, 2), E += A(x.crc32, 4), E += A(x.compressedSize, 4), E += A(x.uncompressedSize, 4), E += A(f.length, 2), E += A(b.length, 2), {
					fileRecord: R.LOCAL_FILE_HEADER + E + f + b,
					dirRecord: R.CENTRAL_FILE_HEADER + A(C, 2) + E + A(p.length, 2) + "\0\0\0\0" + A(z, 4) + A(n, 4) + f + b + p
				}
			}
			var I = e("../utils"),
				i = e("../stream/GenericWorker"),
				O = e("../utf8"),
				B = e("../crc32"),
				R = e("../signature");

			function s(e, t, r, n) {
				i.call(this, "ZipFileWorker"), this.bytesWritten = 0, this.zipComment = t, this.zipPlatform = r, this.encodeFileName = n, this.streamFiles = e, this.accumulate = !1, this.contentBuffer = [], this.dirRecords = [], this.currentSourceOffset = 0, this.entriesCount = 0, this.currentFile = null, this._sources = []
			}
			I.inherits(s, i), s.prototype.push = function(e) {
				var t = e.meta.percent || 0,
					r = this.entriesCount,
					n = this._sources.length;
				this.accumulate ? this.contentBuffer.push(e) : (this.bytesWritten += e.data.length, i.prototype.push.call(this, {
					data: e.data,
					meta: {
						currentFile: this.currentFile,
						percent: r ? (t + 100 * (r - n - 1)) / r : 100
					}
				}))
			}, s.prototype.openedSource = function(e) {
				this.currentSourceOffset = this.bytesWritten, this.currentFile = e.file.name;
				var t = this.streamFiles && !e.file.dir;
				if (t) {
					var r = n(e, t, !1, this.currentSourceOffset, this.zipPlatform, this.encodeFileName);
					this.push({
						data: r.fileRecord,
						meta: {
							percent: 0
						}
					})
				} else this.accumulate = !0
			}, s.prototype.closedSource = function(e) {
				this.accumulate = !1;
				var t = this.streamFiles && !e.file.dir,
					r = n(e, t, !0, this.currentSourceOffset, this.zipPlatform, this.encodeFileName);
				if (this.dirRecords.push(r.dirRecord), t) this.push({
					data: function(e) {
						return R.DATA_DESCRIPTOR + A(e.crc32, 4) + A(e.compressedSize, 4) + A(e.uncompressedSize, 4)
					}(e),
					meta: {
						percent: 100
					}
				});
				else
					for (this.push({
						data: r.fileRecord,
						meta: {
							percent: 0
						}
					}); this.contentBuffer.length;) this.push(this.contentBuffer.shift());
				this.currentFile = null
			}, s.prototype.flush = function() {
				for (var e = this.bytesWritten, t = 0; t < this.dirRecords.length; t++) this.push({
					data: this.dirRecords[t],
					meta: {
						percent: 100
					}
				});
				var r = this.bytesWritten - e,
					n = function(e, t, r, n, i) {
						var s = I.transformTo("string", i(n));
						return R.CENTRAL_DIRECTORY_END + "\0\0\0\0" + A(e, 2) + A(e, 2) + A(t, 4) + A(r, 4) + A(s.length, 2) + s
					}(this.dirRecords.length, r, e, this.zipComment, this.encodeFileName);
				this.push({
					data: n,
					meta: {
						percent: 100
					}
				})
			}, s.prototype.prepareNextSource = function() {
				this.previous = this._sources.shift(), this.openedSource(this.previous.streamInfo), this.isPaused ? this.previous.pause() : this.previous.resume()
			}, s.prototype.registerPrevious = function(e) {
				this._sources.push(e);
				var t = this;
				return e.on("data", function(e) {
					t.processChunk(e)
				}), e.on("end", function() {
					t.closedSource(t.previous.streamInfo), t._sources.length ? t.prepareNextSource() : t.end()
				}), e.on("error", function(e) {
					t.error(e)
				}), this
			}, s.prototype.resume = function() {
				return !!i.prototype.resume.call(this) && (!this.previous && this._sources.length ? (this.prepareNextSource(), !0) : this.previous || this._sources.length || this.generatedError ? void 0 : (this.end(), !0))
			}, s.prototype.error = function(e) {
				var t = this._sources;
				if (!i.prototype.error.call(this, e)) return !1;
				for (var r = 0; r < t.length; r++) try {
					t[r].error(e)
				} catch (e) {}
				return !0
			}, s.prototype.lock = function() {
				i.prototype.lock.call(this);
				for (var e = this._sources, t = 0; t < e.length; t++) e[t].lock()
			}, t.exports = s
		}, {
			"../crc32": 4,
			"../signature": 23,
			"../stream/GenericWorker": 28,
			"../utf8": 31,
			"../utils": 32
		}],
		9: [function(e, t, r) {
			"use strict";
			var u = e("../compressions"),
				n = e("./ZipFileWorker");
			r.generateWorker = function(e, a, t) {
				var o = new n(a.streamFiles, t, a.platform, a.encodeFileName),
					h = 0;
				try {
					e.forEach(function(e, t) {
						h++;
						var r = function(e, t) {
								var r = e || t,
									n = u[r];
								if (!n) throw new Error(r + " is not a valid compression method !");
								return n
							}(t.options.compression, a.compression),
							n = t.options.compressionOptions || a.compressionOptions || {},
							i = t.dir,
							s = t.date;
						t._compressWorker(r, n)
							.withStreamInfo("file", {
								name: e,
								dir: i,
								date: s,
								comment: t.comment || "",
								unixPermissions: t.unixPermissions,
								dosPermissions: t.dosPermissions
							})
							.pipe(o)
					}), o.entriesCount = h
				} catch (e) {
					o.error(e)
				}
				return o
			}
		}, {
			"../compressions": 3,
			"./ZipFileWorker": 8
		}],
		10: [function(e, t, r) {
			"use strict";

			function n() {
				if (!(this instanceof n)) return new n;
				if (arguments.length) throw new Error("The constructor with parameters has been removed in JSZip 3.0, please check the upgrade guide.");
				this.files = Object.create(null), this.comment = null, this.root = "", this.clone = function() {
					var e = new n;
					for (var t in this) "function" != typeof this[t] && (e[t] = this[t]);
					return e
				}
			}(n.prototype = e("./object"))
			.loadAsync = e("./load"), n.support = e("./support"), n.defaults = e("./defaults"), n.version = "3.10.1", n.loadAsync = function(e, t) {
				return (new n)
					.loadAsync(e, t)
			}, n.external = e("./external"), t.exports = n
		}, {
			"./defaults": 5,
			"./external": 6,
			"./load": 11,
			"./object": 15,
			"./support": 30
		}],
		11: [function(e, t, r) {
			"use strict";
			var u = e("./utils"),
				i = e("./external"),
				n = e("./utf8"),
				s = e("./zipEntries"),
				a = e("./stream/Crc32Probe"),
				l = e("./nodejsUtils");

			function f(n) {
				return new i.Promise(function(e, t) {
					var r = n.decompressed.getContentWorker()
						.pipe(new a);
					r.on("error", function(e) {
							t(e)
						})
						.on("end", function() {
							r.streamInfo.crc32 !== n.decompressed.crc32 ? t(new Error("Corrupted zip : CRC32 mismatch")) : e()
						})
						.resume()
				})
			}
			t.exports = function(e, o) {
				var h = this;
				return o = u.extend(o || {}, {
						base64: !1,
						checkCRC32: !1,
						optimizedBinaryString: !1,
						createFolders: !1,
						decodeFileName: n.utf8decode
					}), l.isNode && l.isStream(e) ? i.Promise.reject(new Error("JSZip can't accept a stream when loading a zip file.")) : u.prepareContent("the loaded zip file", e, !0, o.optimizedBinaryString, o.base64)
					.then(function(e) {
						var t = new s(o);
						return t.load(e), t
					})
					.then(function(e) {
						var t = [i.Promise.resolve(e)],
							r = e.files;
						if (o.checkCRC32)
							for (var n = 0; n < r.length; n++) t.push(f(r[n]));
						return i.Promise.all(t)
					})
					.then(function(e) {
						for (var t = e.shift(), r = t.files, n = 0; n < r.length; n++) {
							var i = r[n],
								s = i.fileNameStr,
								a = u.resolve(i.fileNameStr);
							h.file(a, i.decompressed, {
								binary: !0,
								optimizedBinaryString: !0,
								date: i.date,
								dir: i.dir,
								comment: i.fileCommentStr.length ? i.fileCommentStr : null,
								unixPermissions: i.unixPermissions,
								dosPermissions: i.dosPermissions,
								createFolders: o.createFolders
							}), i.dir || (h.file(a)
								.unsafeOriginalName = s)
						}
						return t.zipComment.length && (h.comment = t.zipComment), h
					})
			}
		}, {
			"./external": 6,
			"./nodejsUtils": 14,
			"./stream/Crc32Probe": 25,
			"./utf8": 31,
			"./utils": 32,
			"./zipEntries": 33
		}],
		12: [function(e, t, r) {
			"use strict";
			var n = e("../utils"),
				i = e("../stream/GenericWorker");

			function s(e, t) {
				i.call(this, "Nodejs stream input adapter for " + e), this._upstreamEnded = !1, this._bindStream(t)
			}
			n.inherits(s, i), s.prototype._bindStream = function(e) {
				var t = this;
				(this._stream = e)
				.pause(), e.on("data", function(e) {
						t.push({
							data: e,
							meta: {
								percent: 0
							}
						})
					})
					.on("error", function(e) {
						t.isPaused ? this.generatedError = e : t.error(e)
					})
					.on("end", function() {
						t.isPaused ? t._upstreamEnded = !0 : t.end()
					})
			}, s.prototype.pause = function() {
				return !!i.prototype.pause.call(this) && (this._stream.pause(), !0)
			}, s.prototype.resume = function() {
				return !!i.prototype.resume.call(this) && (this._upstreamEnded ? this.end() : this._stream.resume(), !0)
			}, t.exports = s
		}, {
			"../stream/GenericWorker": 28,
			"../utils": 32
		}],
		13: [function(e, t, r) {
			"use strict";
			var i = e("readable-stream")
				.Readable;

			function n(e, t, r) {
				i.call(this, t), this._helper = e;
				var n = this;
				e.on("data", function(e, t) {
						n.push(e) || n._helper.pause(), r && r(t)
					})
					.on("error", function(e) {
						n.emit("error", e)
					})
					.on("end", function() {
						n.push(null)
					})
			}
			e("../utils")
				.inherits(n, i), n.prototype._read = function() {
					this._helper.resume()
				}, t.exports = n
		}, {
			"../utils": 32,
			"readable-stream": 16
		}],
		14: [function(e, t, r) {
			"use strict";
			t.exports = {
				isNode: "undefined" != typeof Buffer,
				newBufferFrom: function(e, t) {
					if (Buffer.from && Buffer.from !== Uint8Array.from) return Buffer.from(e, t);
					if ("number" == typeof e) throw new Error('The "data" argument must not be a number');
					return new Buffer(e, t)
				},
				allocBuffer: function(e) {
					if (Buffer.alloc) return Buffer.alloc(e);
					var t = new Buffer(e);
					return t.fill(0), t
				},
				isBuffer: function(e) {
					return Buffer.isBuffer(e)
				},
				isStream: function(e) {
					return e && "function" == typeof e.on && "function" == typeof e.pause && "function" == typeof e.resume
				}
			}
		}, {}],
		15: [function(e, t, r) {
			"use strict";

			function s(e, t, r) {
				var n, i = u.getTypeOf(t),
					s = u.extend(r || {}, f);
				s.date = s.date || new Date, null !== s.compression && (s.compression = s.compression.toUpperCase()), "string" == typeof s.unixPermissions && (s.unixPermissions = parseInt(s.unixPermissions, 8)), s.unixPermissions && 16384 & s.unixPermissions && (s.dir = !0), s.dosPermissions && 16 & s.dosPermissions && (s.dir = !0), s.dir && (e = g(e)), s.createFolders && (n = _(e)) && b.call(this, n, !0);
				var a = "string" === i && !1 === s.binary && !1 === s.base64;
				r && void 0 !== r.binary || (s.binary = !a), (t instanceof c && 0 === t.uncompressedSize || s.dir || !t || 0 === t.length) && (s.base64 = !1, s.binary = !0, t = "", s.compression = "STORE", i = "string");
				var o = null;
				o = t instanceof c || t instanceof l ? t : p.isNode && p.isStream(t) ? new m(e, t) : u.prepareContent(e, t, s.binary, s.optimizedBinaryString, s.base64);
				var h = new d(e, o, s);
				this.files[e] = h
			}
			var i = e("./utf8"),
				u = e("./utils"),
				l = e("./stream/GenericWorker"),
				a = e("./stream/StreamHelper"),
				f = e("./defaults"),
				c = e("./compressedObject"),
				d = e("./zipObject"),
				o = e("./generate"),
				p = e("./nodejsUtils"),
				m = e("./nodejs/NodejsStreamInputAdapter"),
				_ = function(e) {
					"/" === e.slice(-1) && (e = e.substring(0, e.length - 1));
					var t = e.lastIndexOf("/");
					return 0 < t ? e.substring(0, t) : ""
				},
				g = function(e) {
					return "/" !== e.slice(-1) && (e += "/"), e
				},
				b = function(e, t) {
					return t = void 0 !== t ? t : f.createFolders, e = g(e), this.files[e] || s.call(this, e, null, {
						dir: !0,
						createFolders: t
					}), this.files[e]
				};

			function h(e) {
				return "[object RegExp]" === Object.prototype.toString.call(e)
			}
			var n = {
				load: function() {
					throw new Error("This method has been removed in JSZip 3.0, please check the upgrade guide.")
				},
				forEach: function(e) {
					var t, r, n;
					for (t in this.files) n = this.files[t], (r = t.slice(this.root.length, t.length)) && t.slice(0, this.root.length) === this.root && e(r, n)
				},
				filter: function(r) {
					var n = [];
					return this.forEach(function(e, t) {
						r(e, t) && n.push(t)
					}), n
				},
				file: function(e, t, r) {
					if (1 !== arguments.length) return e = this.root + e, s.call(this, e, t, r), this;
					if (h(e)) {
						var n = e;
						return this.filter(function(e, t) {
							return !t.dir && n.test(e)
						})
					}
					var i = this.files[this.root + e];
					return i && !i.dir ? i : null
				},
				folder: function(r) {
					if (!r) return this;
					if (h(r)) return this.filter(function(e, t) {
						return t.dir && r.test(e)
					});
					var e = this.root + r,
						t = b.call(this, e),
						n = this.clone();
					return n.root = t.name, n
				},
				remove: function(r) {
					r = this.root + r;
					var e = this.files[r];
					if (e || ("/" !== r.slice(-1) && (r += "/"), e = this.files[r]), e && !e.dir) delete this.files[r];
					else
						for (var t = this.filter(function(e, t) {
							return t.name.slice(0, r.length) === r
						}), n = 0; n < t.length; n++) delete this.files[t[n].name];
					return this
				},
				generate: function() {
					throw new Error("This method has been removed in JSZip 3.0, please check the upgrade guide.")
				},
				generateInternalStream: function(e) {
					var t, r = {};
					try {
						if ((r = u.extend(e || {}, {
								streamFiles: !1,
								compression: "STORE",
								compressionOptions: null,
								type: "",
								platform: "DOS",
								comment: null,
								mimeType: "application/zip",
								encodeFileName: i.utf8encode
							}))
							.type = r.type.toLowerCase(), r.compression = r.compression.toUpperCase(), "binarystring" === r.type && (r.type = "string"), !r.type) throw new Error("No output type specified.");
						u.checkSupport(r.type), "darwin" !== r.platform && "freebsd" !== r.platform && "linux" !== r.platform && "sunos" !== r.platform || (r.platform = "UNIX"), "win32" === r.platform && (r.platform = "DOS");
						var n = r.comment || this.comment || "";
						t = o.generateWorker(this, r, n)
					} catch (e) {
						(t = new l("error"))
						.error(e)
					}
					return new a(t, r.type || "string", r.mimeType)
				},
				generateAsync: function(e, t) {
					return this.generateInternalStream(e)
						.accumulate(t)
				},
				generateNodeStream: function(e, t) {
					return (e = e || {})
						.type || (e.type = "nodebuffer"), this.generateInternalStream(e)
						.toNodejsStream(t)
				}
			};
			t.exports = n
		}, {
			"./compressedObject": 2,
			"./defaults": 5,
			"./generate": 9,
			"./nodejs/NodejsStreamInputAdapter": 12,
			"./nodejsUtils": 14,
			"./stream/GenericWorker": 28,
			"./stream/StreamHelper": 29,
			"./utf8": 31,
			"./utils": 32,
			"./zipObject": 35
		}],
		16: [function(e, t, r) {
			"use strict";
			t.exports = e("stream")
		}, {
			stream: void 0
		}],
		17: [function(e, t, r) {
			"use strict";
			var n = e("./DataReader");

			function i(e) {
				n.call(this, e);
				for (var t = 0; t < this.data.length; t++) e[t] = 255 & e[t]
			}
			e("../utils")
				.inherits(i, n), i.prototype.byteAt = function(e) {
					return this.data[this.zero + e]
				}, i.prototype.lastIndexOfSignature = function(e) {
					for (var t = e.charCodeAt(0), r = e.charCodeAt(1), n = e.charCodeAt(2), i = e.charCodeAt(3), s = this.length - 4; 0 <= s; --s)
						if (this.data[s] === t && this.data[s + 1] === r && this.data[s + 2] === n && this.data[s + 3] === i) return s - this.zero;
					return -1
				}, i.prototype.readAndCheckSignature = function(e) {
					var t = e.charCodeAt(0),
						r = e.charCodeAt(1),
						n = e.charCodeAt(2),
						i = e.charCodeAt(3),
						s = this.readData(4);
					return t === s[0] && r === s[1] && n === s[2] && i === s[3]
				}, i.prototype.readData = function(e) {
					if (this.checkOffset(e), 0 === e) return [];
					var t = this.data.slice(this.zero + this.index, this.zero + this.index + e);
					return this.index += e, t
				}, t.exports = i
		}, {
			"../utils": 32,
			"./DataReader": 18
		}],
		18: [function(e, t, r) {
			"use strict";
			var n = e("../utils");

			function i(e) {
				this.data = e, this.length = e.length, this.index = 0, this.zero = 0
			}
			i.prototype = {
				checkOffset: function(e) {
					this.checkIndex(this.index + e)
				},
				checkIndex: function(e) {
					if (this.length < this.zero + e || e < 0) throw new Error("End of data reached (data length = " + this.length + ", asked index = " + e + "). Corrupted zip ?")
				},
				setIndex: function(e) {
					this.checkIndex(e), this.index = e
				},
				skip: function(e) {
					this.setIndex(this.index + e)
				},
				byteAt: function() {},
				readInt: function(e) {
					var t, r = 0;
					for (this.checkOffset(e), t = this.index + e - 1; t >= this.index; t--) r = (r << 8) + this.byteAt(t);
					return this.index += e, r
				},
				readString: function(e) {
					return n.transformTo("string", this.readData(e))
				},
				readData: function() {},
				lastIndexOfSignature: function() {},
				readAndCheckSignature: function() {},
				readDate: function() {
					var e = this.readInt(4);
					return new Date(Date.UTC(1980 + (e >> 25 & 127), (e >> 21 & 15) - 1, e >> 16 & 31, e >> 11 & 31, e >> 5 & 63, (31 & e) << 1))
				}
			}, t.exports = i
		}, {
			"../utils": 32
		}],
		19: [function(e, t, r) {
			"use strict";
			var n = e("./Uint8ArrayReader");

			function i(e) {
				n.call(this, e)
			}
			e("../utils")
				.inherits(i, n), i.prototype.readData = function(e) {
					this.checkOffset(e);
					var t = this.data.slice(this.zero + this.index, this.zero + this.index + e);
					return this.index += e, t
				}, t.exports = i
		}, {
			"../utils": 32,
			"./Uint8ArrayReader": 21
		}],
		20: [function(e, t, r) {
			"use strict";
			var n = e("./DataReader");

			function i(e) {
				n.call(this, e)
			}
			e("../utils")
				.inherits(i, n), i.prototype.byteAt = function(e) {
					return this.data.charCodeAt(this.zero + e)
				}, i.prototype.lastIndexOfSignature = function(e) {
					return this.data.lastIndexOf(e) - this.zero
				}, i.prototype.readAndCheckSignature = function(e) {
					return e === this.readData(4)
				}, i.prototype.readData = function(e) {
					this.checkOffset(e);
					var t = this.data.slice(this.zero + this.index, this.zero + this.index + e);
					return this.index += e, t
				}, t.exports = i
		}, {
			"../utils": 32,
			"./DataReader": 18
		}],
		21: [function(e, t, r) {
			"use strict";
			var n = e("./ArrayReader");

			function i(e) {
				n.call(this, e)
			}
			e("../utils")
				.inherits(i, n), i.prototype.readData = function(e) {
					if (this.checkOffset(e), 0 === e) return new Uint8Array(0);
					var t = this.data.subarray(this.zero + this.index, this.zero + this.index + e);
					return this.index += e, t
				}, t.exports = i
		}, {
			"../utils": 32,
			"./ArrayReader": 17
		}],
		22: [function(e, t, r) {
			"use strict";
			var n = e("../utils"),
				i = e("../support"),
				s = e("./ArrayReader"),
				a = e("./StringReader"),
				o = e("./NodeBufferReader"),
				h = e("./Uint8ArrayReader");
			t.exports = function(e) {
				var t = n.getTypeOf(e);
				return n.checkSupport(t), "string" !== t || i.uint8array ? "nodebuffer" === t ? new o(e) : i.uint8array ? new h(n.transformTo("uint8array", e)) : new s(n.transformTo("array", e)) : new a(e)
			}
		}, {
			"../support": 30,
			"../utils": 32,
			"./ArrayReader": 17,
			"./NodeBufferReader": 19,
			"./StringReader": 20,
			"./Uint8ArrayReader": 21
		}],
		23: [function(e, t, r) {
			"use strict";
			r.LOCAL_FILE_HEADER = "PK", r.CENTRAL_FILE_HEADER = "PK", r.CENTRAL_DIRECTORY_END = "PK", r.ZIP64_CENTRAL_DIRECTORY_LOCATOR = "PK", r.ZIP64_CENTRAL_DIRECTORY_END = "PK", r.DATA_DESCRIPTOR = "PK\b"
		}, {}],
		24: [function(e, t, r) {
			"use strict";
			var n = e("./GenericWorker"),
				i = e("../utils");

			function s(e) {
				n.call(this, "ConvertWorker to " + e), this.destType = e
			}
			i.inherits(s, n), s.prototype.processChunk = function(e) {
				this.push({
					data: i.transformTo(this.destType, e.data),
					meta: e.meta
				})
			}, t.exports = s
		}, {
			"../utils": 32,
			"./GenericWorker": 28
		}],
		25: [function(e, t, r) {
			"use strict";
			var n = e("./GenericWorker"),
				i = e("../crc32");

			function s() {
				n.call(this, "Crc32Probe"), this.withStreamInfo("crc32", 0)
			}
			e("../utils")
				.inherits(s, n), s.prototype.processChunk = function(e) {
					this.streamInfo.crc32 = i(e.data, this.streamInfo.crc32 || 0), this.push(e)
				}, t.exports = s
		}, {
			"../crc32": 4,
			"../utils": 32,
			"./GenericWorker": 28
		}],
		26: [function(e, t, r) {
			"use strict";
			var n = e("../utils"),
				i = e("./GenericWorker");

			function s(e) {
				i.call(this, "DataLengthProbe for " + e), this.propName = e, this.withStreamInfo(e, 0)
			}
			n.inherits(s, i), s.prototype.processChunk = function(e) {
				if (e) {
					var t = this.streamInfo[this.propName] || 0;
					this.streamInfo[this.propName] = t + e.data.length
				}
				i.prototype.processChunk.call(this, e)
			}, t.exports = s
		}, {
			"../utils": 32,
			"./GenericWorker": 28
		}],
		27: [function(e, t, r) {
			"use strict";
			var n = e("../utils"),
				i = e("./GenericWorker");

			function s(e) {
				i.call(this, "DataWorker");
				var t = this;
				this.dataIsReady = !1, this.index = 0, this.max = 0, this.data = null, this.type = "", this._tickScheduled = !1, e.then(function(e) {
					t.dataIsReady = !0, t.data = e, t.max = e && e.length || 0, t.type = n.getTypeOf(e), t.isPaused || t._tickAndRepeat()
				}, function(e) {
					t.error(e)
				})
			}
			n.inherits(s, i), s.prototype.cleanUp = function() {
				i.prototype.cleanUp.call(this), this.data = null
			}, s.prototype.resume = function() {
				return !!i.prototype.resume.call(this) && (!this._tickScheduled && this.dataIsReady && (this._tickScheduled = !0, n.delay(this._tickAndRepeat, [], this)), !0)
			}, s.prototype._tickAndRepeat = function() {
				this._tickScheduled = !1, this.isPaused || this.isFinished || (this._tick(), this.isFinished || (n.delay(this._tickAndRepeat, [], this), this._tickScheduled = !0))
			}, s.prototype._tick = function() {
				if (this.isPaused || this.isFinished) return !1;
				var e = null,
					t = Math.min(this.max, this.index + 16384);
				if (this.index >= this.max) return this.end();
				switch (this.type) {
					case "string":
						e = this.data.substring(this.index, t);
						break;
					case "uint8array":
						e = this.data.subarray(this.index, t);
						break;
					case "array":
					case "nodebuffer":
						e = this.data.slice(this.index, t)
				}
				return this.index = t, this.push({
					data: e,
					meta: {
						percent: this.max ? this.index / this.max * 100 : 0
					}
				})
			}, t.exports = s
		}, {
			"../utils": 32,
			"./GenericWorker": 28
		}],
		28: [function(e, t, r) {
			"use strict";

			function n(e) {
				this.name = e || "default", this.streamInfo = {}, this.generatedError = null, this.extraStreamInfo = {}, this.isPaused = !0, this.isFinished = !1, this.isLocked = !1, this._listeners = {
					data: [],
					end: [],
					error: []
				}, this.previous = null
			}
			n.prototype = {
				push: function(e) {
					this.emit("data", e)
				},
				end: function() {
					if (this.isFinished) return !1;
					this.flush();
					try {
						this.emit("end"), this.cleanUp(), this.isFinished = !0
					} catch (e) {
						this.emit("error", e)
					}
					return !0
				},
				error: function(e) {
					return !this.isFinished && (this.isPaused ? this.generatedError = e : (this.isFinished = !0, this.emit("error", e), this.previous && this.previous.error(e), this.cleanUp()), !0)
				},
				on: function(e, t) {
					return this._listeners[e].push(t), this
				},
				cleanUp: function() {
					this.streamInfo = this.generatedError = this.extraStreamInfo = null, this._listeners = []
				},
				emit: function(e, t) {
					if (this._listeners[e])
						for (var r = 0; r < this._listeners[e].length; r++) this._listeners[e][r].call(this, t)
				},
				pipe: function(e) {
					return e.registerPrevious(this)
				},
				registerPrevious: function(e) {
					if (this.isLocked) throw new Error("The stream '" + this + "' has already been used.");
					this.streamInfo = e.streamInfo, this.mergeStreamInfo(), this.previous = e;
					var t = this;
					return e.on("data", function(e) {
						t.processChunk(e)
					}), e.on("end", function() {
						t.end()
					}), e.on("error", function(e) {
						t.error(e)
					}), this
				},
				pause: function() {
					return !this.isPaused && !this.isFinished && (this.isPaused = !0, this.previous && this.previous.pause(), !0)
				},
				resume: function() {
					if (!this.isPaused || this.isFinished) return !1;
					var e = this.isPaused = !1;
					return this.generatedError && (this.error(this.generatedError), e = !0), this.previous && this.previous.resume(), !e
				},
				flush: function() {},
				processChunk: function(e) {
					this.push(e)
				},
				withStreamInfo: function(e, t) {
					return this.extraStreamInfo[e] = t, this.mergeStreamInfo(), this
				},
				mergeStreamInfo: function() {
					for (var e in this.extraStreamInfo) Object.prototype.hasOwnProperty.call(this.extraStreamInfo, e) && (this.streamInfo[e] = this.extraStreamInfo[e])
				},
				lock: function() {
					if (this.isLocked) throw new Error("The stream '" + this + "' has already been used.");
					this.isLocked = !0, this.previous && this.previous.lock()
				},
				toString: function() {
					var e = "Worker " + this.name;
					return this.previous ? this.previous + " -> " + e : e
				}
			}, t.exports = n
		}, {}],
		29: [function(e, t, r) {
			"use strict";
			var h = e("../utils"),
				i = e("./ConvertWorker"),
				s = e("./GenericWorker"),
				u = e("../base64"),
				n = e("../support"),
				a = e("../external"),
				o = null;
			if (n.nodestream) try {
				o = e("../nodejs/NodejsStreamOutputAdapter")
			} catch (e) {}

			function l(e, o) {
				return new a.Promise(function(t, r) {
					var n = [],
						i = e._internalType,
						s = e._outputType,
						a = e._mimeType;
					e.on("data", function(e, t) {
							n.push(e), o && o(t)
						})
						.on("error", function(e) {
							n = [], r(e)
						})
						.on("end", function() {
							try {
								var e = function(e, t, r) {
									switch (e) {
										case "blob":
											return h.newBlob(h.transformTo("arraybuffer", t), r);
										case "base64":
											return u.encode(t);
										default:
											return h.transformTo(e, t)
									}
								}(s, function(e, t) {
									var r, n = 0,
										i = null,
										s = 0;
									for (r = 0; r < t.length; r++) s += t[r].length;
									switch (e) {
										case "string":
											return t.join("");
										case "array":
											return Array.prototype.concat.apply([], t);
										case "uint8array":
											for (i = new Uint8Array(s), r = 0; r < t.length; r++) i.set(t[r], n), n += t[r].length;
											return i;
										case "nodebuffer":
											return Buffer.concat(t);
										default:
											throw new Error("concat : unsupported type '" + e + "'")
									}
								}(i, n), a);
								t(e)
							} catch (e) {
								r(e)
							}
							n = []
						})
						.resume()
				})
			}

			function f(e, t, r) {
				var n = t;
				switch (t) {
					case "blob":
					case "arraybuffer":
						n = "uint8array";
						break;
					case "base64":
						n = "string"
				}
				try {
					this._internalType = n, this._outputType = t, this._mimeType = r, h.checkSupport(n), this._worker = e.pipe(new i(n)), e.lock()
				} catch (e) {
					this._worker = new s("error"), this._worker.error(e)
				}
			}
			f.prototype = {
				accumulate: function(e) {
					return l(this, e)
				},
				on: function(e, t) {
					var r = this;
					return "data" === e ? this._worker.on(e, function(e) {
						t.call(r, e.data, e.meta)
					}) : this._worker.on(e, function() {
						h.delay(t, arguments, r)
					}), this
				},
				resume: function() {
					return h.delay(this._worker.resume, [], this._worker), this
				},
				pause: function() {
					return this._worker.pause(), this
				},
				toNodejsStream: function(e) {
					if (h.checkSupport("nodestream"), "nodebuffer" !== this._outputType) throw new Error(this._outputType + " is not supported by this method");
					return new o(this, {
						objectMode: "nodebuffer" !== this._outputType
					}, e)
				}
			}, t.exports = f
		}, {
			"../base64": 1,
			"../external": 6,
			"../nodejs/NodejsStreamOutputAdapter": 13,
			"../support": 30,
			"../utils": 32,
			"./ConvertWorker": 24,
			"./GenericWorker": 28
		}],
		30: [function(e, t, r) {
			"use strict";
			if (r.base64 = !0, r.array = !0, r.string = !0, r.arraybuffer = "undefined" != typeof ArrayBuffer && "undefined" != typeof Uint8Array, r.nodebuffer = "undefined" != typeof Buffer, r.uint8array = "undefined" != typeof Uint8Array, "undefined" == typeof ArrayBuffer) r.blob = !1;
			else {
				var n = new ArrayBuffer(0);
				try {
					r.blob = 0 === new Blob([n], {
							type: "application/zip"
						})
						.size
				} catch (e) {
					try {
						var i = new(self.BlobBuilder || self.WebKitBlobBuilder || self.MozBlobBuilder || self.MSBlobBuilder);
						i.append(n), r.blob = 0 === i.getBlob("application/zip")
							.size
					} catch (e) {
						r.blob = !1
					}
				}
			}
			try {
				r.nodestream = !!e("readable-stream")
					.Readable
			} catch (e) {
				r.nodestream = !1
			}
		}, {
			"readable-stream": 16
		}],
		31: [function(e, t, s) {
			"use strict";
			for (var o = e("./utils"), h = e("./support"), r = e("./nodejsUtils"), n = e("./stream/GenericWorker"), u = new Array(256), i = 0; i < 256; i++) u[i] = 252 <= i ? 6 : 248 <= i ? 5 : 240 <= i ? 4 : 224 <= i ? 3 : 192 <= i ? 2 : 1;
			u[254] = u[254] = 1;

			function a() {
				n.call(this, "utf-8 decode"), this.leftOver = null
			}

			function l() {
				n.call(this, "utf-8 encode")
			}
			s.utf8encode = function(e) {
				return h.nodebuffer ? r.newBufferFrom(e, "utf-8") : function(e) {
					var t, r, n, i, s, a = e.length,
						o = 0;
					for (i = 0; i < a; i++) 55296 == (64512 & (r = e.charCodeAt(i))) && i + 1 < a && 56320 == (64512 & (n = e.charCodeAt(i + 1))) && (r = 65536 + (r - 55296 << 10) + (n - 56320), i++), o += r < 128 ? 1 : r < 2048 ? 2 : r < 65536 ? 3 : 4;
					for (t = h.uint8array ? new Uint8Array(o) : new Array(o), i = s = 0; s < o; i++) 55296 == (64512 & (r = e.charCodeAt(i))) && i + 1 < a && 56320 == (64512 & (n = e.charCodeAt(i + 1))) && (r = 65536 + (r - 55296 << 10) + (n - 56320), i++), r < 128 ? t[s++] = r : (r < 2048 ? t[s++] = 192 | r >>> 6 : (r < 65536 ? t[s++] = 224 | r >>> 12 : (t[s++] = 240 | r >>> 18, t[s++] = 128 | r >>> 12 & 63), t[s++] = 128 | r >>> 6 & 63), t[s++] = 128 | 63 & r);
					return t
				}(e)
			}, s.utf8decode = function(e) {
				return h.nodebuffer ? o.transformTo("nodebuffer", e)
					.toString("utf-8") : function(e) {
						var t, r, n, i, s = e.length,
							a = new Array(2 * s);
						for (t = r = 0; t < s;)
							if ((n = e[t++]) < 128) a[r++] = n;
							else if (4 < (i = u[n])) a[r++] = 65533, t += i - 1;
						else {
							for (n &= 2 === i ? 31 : 3 === i ? 15 : 7; 1 < i && t < s;) n = n << 6 | 63 & e[t++], i--;
							1 < i ? a[r++] = 65533 : n < 65536 ? a[r++] = n : (n -= 65536, a[r++] = 55296 | n >> 10 & 1023, a[r++] = 56320 | 1023 & n)
						}
						return a.length !== r && (a.subarray ? a = a.subarray(0, r) : a.length = r), o.applyFromCharCode(a)
					}(e = o.transformTo(h.uint8array ? "uint8array" : "array", e))
			}, o.inherits(a, n), a.prototype.processChunk = function(e) {
				var t = o.transformTo(h.uint8array ? "uint8array" : "array", e.data);
				if (this.leftOver && this.leftOver.length) {
					if (h.uint8array) {
						var r = t;
						(t = new Uint8Array(r.length + this.leftOver.length))
						.set(this.leftOver, 0), t.set(r, this.leftOver.length)
					} else t = this.leftOver.concat(t);
					this.leftOver = null
				}
				var n = function(e, t) {
						var r;
						for ((t = t || e.length) > e.length && (t = e.length), r = t - 1; 0 <= r && 128 == (192 & e[r]);) r--;
						return r < 0 ? t : 0 === r ? t : r + u[e[r]] > t ? r : t
					}(t),
					i = t;
				n !== t.length && (h.uint8array ? (i = t.subarray(0, n), this.leftOver = t.subarray(n, t.length)) : (i = t.slice(0, n), this.leftOver = t.slice(n, t.length))), this.push({
					data: s.utf8decode(i),
					meta: e.meta
				})
			}, a.prototype.flush = function() {
				this.leftOver && this.leftOver.length && (this.push({
					data: s.utf8decode(this.leftOver),
					meta: {}
				}), this.leftOver = null)
			}, s.Utf8DecodeWorker = a, o.inherits(l, n), l.prototype.processChunk = function(e) {
				this.push({
					data: s.utf8encode(e.data),
					meta: e.meta
				})
			}, s.Utf8EncodeWorker = l
		}, {
			"./nodejsUtils": 14,
			"./stream/GenericWorker": 28,
			"./support": 30,
			"./utils": 32
		}],
		32: [function(e, t, a) {
			"use strict";
			var o = e("./support"),
				h = e("./base64"),
				r = e("./nodejsUtils"),
				u = e("./external");

			function n(e) {
				return e
			}

			function l(e, t) {
				for (var r = 0; r < e.length; ++r) t[r] = 255 & e.charCodeAt(r);
				return t
			}
			e("setimmediate"), a.newBlob = function(t, r) {
				a.checkSupport("blob");
				try {
					return new Blob([t], {
						type: r
					})
				} catch (e) {
					try {
						var n = new(self.BlobBuilder || self.WebKitBlobBuilder || self.MozBlobBuilder || self.MSBlobBuilder);
						return n.append(t), n.getBlob(r)
					} catch (e) {
						throw new Error("Bug : can't construct the Blob.")
					}
				}
			};
			var i = {
				stringifyByChunk: function(e, t, r) {
					var n = [],
						i = 0,
						s = e.length;
					if (s <= r) return String.fromCharCode.apply(null, e);
					for (; i < s;) "array" === t || "nodebuffer" === t ? n.push(String.fromCharCode.apply(null, e.slice(i, Math.min(i + r, s)))) : n.push(String.fromCharCode.apply(null, e.subarray(i, Math.min(i + r, s)))), i += r;
					return n.join("")
				},
				stringifyByChar: function(e) {
					for (var t = "", r = 0; r < e.length; r++) t += String.fromCharCode(e[r]);
					return t
				},
				applyCanBeUsed: {
					uint8array: function() {
						try {
							return o.uint8array && 1 === String.fromCharCode.apply(null, new Uint8Array(1))
								.length
						} catch (e) {
							return !1
						}
					}(),
					nodebuffer: function() {
						try {
							return o.nodebuffer && 1 === String.fromCharCode.apply(null, r.allocBuffer(1))
								.length
						} catch (e) {
							return !1
						}
					}()
				}
			};

			function s(e) {
				var t = 65536,
					r = a.getTypeOf(e),
					n = !0;
				if ("uint8array" === r ? n = i.applyCanBeUsed.uint8array : "nodebuffer" === r && (n = i.applyCanBeUsed.nodebuffer), n)
					for (; 1 < t;) try {
						return i.stringifyByChunk(e, r, t)
					} catch (e) {
						t = Math.floor(t / 2)
					}
				return i.stringifyByChar(e)
			}

			function f(e, t) {
				for (var r = 0; r < e.length; r++) t[r] = e[r];
				return t
			}
			a.applyFromCharCode = s;
			var c = {};
			c.string = {
				string: n,
				array: function(e) {
					return l(e, new Array(e.length))
				},
				arraybuffer: function(e) {
					return c.string.uint8array(e)
						.buffer
				},
				uint8array: function(e) {
					return l(e, new Uint8Array(e.length))
				},
				nodebuffer: function(e) {
					return l(e, r.allocBuffer(e.length))
				}
			}, c.array = {
				string: s,
				array: n,
				arraybuffer: function(e) {
					return new Uint8Array(e)
						.buffer
				},
				uint8array: function(e) {
					return new Uint8Array(e)
				},
				nodebuffer: function(e) {
					return r.newBufferFrom(e)
				}
			}, c.arraybuffer = {
				string: function(e) {
					return s(new Uint8Array(e))
				},
				array: function(e) {
					return f(new Uint8Array(e), new Array(e.byteLength))
				},
				arraybuffer: n,
				uint8array: function(e) {
					return new Uint8Array(e)
				},
				nodebuffer: function(e) {
					return r.newBufferFrom(new Uint8Array(e))
				}
			}, c.uint8array = {
				string: s,
				array: function(e) {
					return f(e, new Array(e.length))
				},
				arraybuffer: function(e) {
					return e.buffer
				},
				uint8array: n,
				nodebuffer: function(e) {
					return r.newBufferFrom(e)
				}
			}, c.nodebuffer = {
				string: s,
				array: function(e) {
					return f(e, new Array(e.length))
				},
				arraybuffer: function(e) {
					return c.nodebuffer.uint8array(e)
						.buffer
				},
				uint8array: function(e) {
					return f(e, new Uint8Array(e.length))
				},
				nodebuffer: n
			}, a.transformTo = function(e, t) {
				if (t = t || "", !e) return t;
				a.checkSupport(e);
				var r = a.getTypeOf(t);
				return c[r][e](t)
			}, a.resolve = function(e) {
				for (var t = e.split("/"), r = [], n = 0; n < t.length; n++) {
					var i = t[n];
					"." === i || "" === i && 0 !== n && n !== t.length - 1 || (".." === i ? r.pop() : r.push(i))
				}
				return r.join("/")
			}, a.getTypeOf = function(e) {
				return "string" == typeof e ? "string" : "[object Array]" === Object.prototype.toString.call(e) ? "array" : o.nodebuffer && r.isBuffer(e) ? "nodebuffer" : o.uint8array && e instanceof Uint8Array ? "uint8array" : o.arraybuffer && e instanceof ArrayBuffer ? "arraybuffer" : void 0
			}, a.checkSupport = function(e) {
				if (!o[e.toLowerCase()]) throw new Error(e + " is not supported by this platform")
			}, a.MAX_VALUE_16BITS = 65535, a.MAX_VALUE_32BITS = -1, a.pretty = function(e) {
				var t, r, n = "";
				for (r = 0; r < (e || "")
					.length; r++) n += "\\x" + ((t = e.charCodeAt(r)) < 16 ? "0" : "") + t.toString(16)
					.toUpperCase();
				return n
			}, a.delay = function(e, t, r) {
				setImmediate(function() {
					e.apply(r || null, t || [])
				})
			}, a.inherits = function(e, t) {
				function r() {}
				r.prototype = t.prototype, e.prototype = new r
			}, a.extend = function() {
				var e, t, r = {};
				for (e = 0; e < arguments.length; e++)
					for (t in arguments[e]) Object.prototype.hasOwnProperty.call(arguments[e], t) && void 0 === r[t] && (r[t] = arguments[e][t]);
				return r
			}, a.prepareContent = function(r, e, n, i, s) {
				return u.Promise.resolve(e)
					.then(function(n) {
						return o.blob && (n instanceof Blob || -1 !== ["[object File]", "[object Blob]"].indexOf(Object.prototype.toString.call(n))) && "undefined" != typeof FileReader ? new u.Promise(function(t, r) {
							var e = new FileReader;
							e.onload = function(e) {
								t(e.target.result)
							}, e.onerror = function(e) {
								r(e.target.error)
							}, e.readAsArrayBuffer(n)
						}) : n
					})
					.then(function(e) {
						var t = a.getTypeOf(e);
						return t ? ("arraybuffer" === t ? e = a.transformTo("uint8array", e) : "string" === t && (s ? e = h.decode(e) : n && !0 !== i && (e = function(e) {
							return l(e, o.uint8array ? new Uint8Array(e.length) : new Array(e.length))
						}(e))), e) : u.Promise.reject(new Error("Can't read the data of '" + r + "'. Is it in a supported JavaScript type (String, Blob, ArrayBuffer, etc) ?"))
					})
			}
		}, {
			"./base64": 1,
			"./external": 6,
			"./nodejsUtils": 14,
			"./support": 30,
			setimmediate: 54
		}],
		33: [function(e, t, r) {
			"use strict";
			var n = e("./reader/readerFor"),
				i = e("./utils"),
				s = e("./signature"),
				a = e("./zipEntry"),
				o = e("./support");

			function h(e) {
				this.files = [], this.loadOptions = e
			}
			h.prototype = {
				checkSignature: function(e) {
					if (!this.reader.readAndCheckSignature(e)) {
						this.reader.index -= 4;
						var t = this.reader.readString(4);
						throw new Error("Corrupted zip or bug: unexpected signature (" + i.pretty(t) + ", expected " + i.pretty(e) + ")")
					}
				},
				isSignature: function(e, t) {
					var r = this.reader.index;
					this.reader.setIndex(e);
					var n = this.reader.readString(4) === t;
					return this.reader.setIndex(r), n
				},
				readBlockEndOfCentral: function() {
					this.diskNumber = this.reader.readInt(2), this.diskWithCentralDirStart = this.reader.readInt(2), this.centralDirRecordsOnThisDisk = this.reader.readInt(2), this.centralDirRecords = this.reader.readInt(2), this.centralDirSize = this.reader.readInt(4), this.centralDirOffset = this.reader.readInt(4), this.zipCommentLength = this.reader.readInt(2);
					var e = this.reader.readData(this.zipCommentLength),
						t = o.uint8array ? "uint8array" : "array",
						r = i.transformTo(t, e);
					this.zipComment = this.loadOptions.decodeFileName(r)
				},
				readBlockZip64EndOfCentral: function() {
					this.zip64EndOfCentralSize = this.reader.readInt(8), this.reader.skip(4), this.diskNumber = this.reader.readInt(4), this.diskWithCentralDirStart = this.reader.readInt(4), this.centralDirRecordsOnThisDisk = this.reader.readInt(8), this.centralDirRecords = this.reader.readInt(8), this.centralDirSize = this.reader.readInt(8), this.centralDirOffset = this.reader.readInt(8), this.zip64ExtensibleData = {};
					for (var e, t, r, n = this.zip64EndOfCentralSize - 44; 0 < n;) e = this.reader.readInt(2), t = this.reader.readInt(4), r = this.reader.readData(t), this.zip64ExtensibleData[e] = {
						id: e,
						length: t,
						value: r
					}
				},
				readBlockZip64EndOfCentralLocator: function() {
					if (this.diskWithZip64CentralDirStart = this.reader.readInt(4), this.relativeOffsetEndOfZip64CentralDir = this.reader.readInt(8), this.disksCount = this.reader.readInt(4), 1 < this.disksCount) throw new Error("Multi-volumes zip are not supported")
				},
				readLocalFiles: function() {
					var e, t;
					for (e = 0; e < this.files.length; e++) t = this.files[e], this.reader.setIndex(t.localHeaderOffset), this.checkSignature(s.LOCAL_FILE_HEADER), t.readLocalPart(this.reader), t.handleUTF8(), t.processAttributes()
				},
				readCentralDir: function() {
					var e;
					for (this.reader.setIndex(this.centralDirOffset); this.reader.readAndCheckSignature(s.CENTRAL_FILE_HEADER);)(e = new a({
							zip64: this.zip64
						}, this.loadOptions))
						.readCentralPart(this.reader), this.files.push(e);
					if (this.centralDirRecords !== this.files.length && 0 !== this.centralDirRecords && 0 === this.files.length) throw new Error("Corrupted zip or bug: expected " + this.centralDirRecords + " records in central dir, got " + this.files.length)
				},
				readEndOfCentral: function() {
					var e = this.reader.lastIndexOfSignature(s.CENTRAL_DIRECTORY_END);
					if (e < 0) throw !this.isSignature(0, s.LOCAL_FILE_HEADER) ? new Error("Can't find end of central directory : is this a zip file ? If it is, see https://stuk.github.io/jszip/documentation/howto/read_zip.html") : new Error("Corrupted zip: can't find end of central directory");
					this.reader.setIndex(e);
					var t = e;
					if (this.checkSignature(s.CENTRAL_DIRECTORY_END), this.readBlockEndOfCentral(), this.diskNumber === i.MAX_VALUE_16BITS || this.diskWithCentralDirStart === i.MAX_VALUE_16BITS || this.centralDirRecordsOnThisDisk === i.MAX_VALUE_16BITS || this.centralDirRecords === i.MAX_VALUE_16BITS || this.centralDirSize === i.MAX_VALUE_32BITS || this.centralDirOffset === i.MAX_VALUE_32BITS) {
						if (this.zip64 = !0, (e = this.reader.lastIndexOfSignature(s.ZIP64_CENTRAL_DIRECTORY_LOCATOR)) < 0) throw new Error("Corrupted zip: can't find the ZIP64 end of central directory locator");
						if (this.reader.setIndex(e), this.checkSignature(s.ZIP64_CENTRAL_DIRECTORY_LOCATOR), this.readBlockZip64EndOfCentralLocator(), !this.isSignature(this.relativeOffsetEndOfZip64CentralDir, s.ZIP64_CENTRAL_DIRECTORY_END) && (this.relativeOffsetEndOfZip64CentralDir = this.reader.lastIndexOfSignature(s.ZIP64_CENTRAL_DIRECTORY_END), this.relativeOffsetEndOfZip64CentralDir < 0)) throw new Error("Corrupted zip: can't find the ZIP64 end of central directory");
						this.reader.setIndex(this.relativeOffsetEndOfZip64CentralDir), this.checkSignature(s.ZIP64_CENTRAL_DIRECTORY_END), this.readBlockZip64EndOfCentral()
					}
					var r = this.centralDirOffset + this.centralDirSize;
					this.zip64 && (r += 20, r += 12 + this.zip64EndOfCentralSize);
					var n = t - r;
					if (0 < n) this.isSignature(t, s.CENTRAL_FILE_HEADER) || (this.reader.zero = n);
					else if (n < 0) throw new Error("Corrupted zip: missing " + Math.abs(n) + " bytes.")
				},
				prepareReader: function(e) {
					this.reader = n(e)
				},
				load: function(e) {
					this.prepareReader(e), this.readEndOfCentral(), this.readCentralDir(), this.readLocalFiles()
				}
			}, t.exports = h
		}, {
			"./reader/readerFor": 22,
			"./signature": 23,
			"./support": 30,
			"./utils": 32,
			"./zipEntry": 34
		}],
		34: [function(e, t, r) {
			"use strict";
			var n = e("./reader/readerFor"),
				s = e("./utils"),
				i = e("./compressedObject"),
				a = e("./crc32"),
				o = e("./utf8"),
				h = e("./compressions"),
				u = e("./support");

			function l(e, t) {
				this.options = e, this.loadOptions = t
			}
			l.prototype = {
				isEncrypted: function() {
					return 1 == (1 & this.bitFlag)
				},
				useUTF8: function() {
					return 2048 == (2048 & this.bitFlag)
				},
				readLocalPart: function(e) {
					var t, r;
					if (e.skip(22), this.fileNameLength = e.readInt(2), r = e.readInt(2), this.fileName = e.readData(this.fileNameLength), e.skip(r), -1 === this.compressedSize || -1 === this.uncompressedSize) throw new Error("Bug or corrupted zip : didn't get enough information from the central directory (compressedSize === -1 || uncompressedSize === -1)");
					if (null === (t = function(e) {
						for (var t in h)
							if (Object.prototype.hasOwnProperty.call(h, t) && h[t].magic === e) return h[t];
						return null
					}(this.compressionMethod))) throw new Error("Corrupted zip : compression " + s.pretty(this.compressionMethod) + " unknown (inner file : " + s.transformTo("string", this.fileName) + ")");
					this.decompressed = new i(this.compressedSize, this.uncompressedSize, this.crc32, t, e.readData(this.compressedSize))
				},
				readCentralPart: function(e) {
					this.versionMadeBy = e.readInt(2), e.skip(2), this.bitFlag = e.readInt(2), this.compressionMethod = e.readString(2), this.date = e.readDate(), this.crc32 = e.readInt(4), this.compressedSize = e.readInt(4), this.uncompressedSize = e.readInt(4);
					var t = e.readInt(2);
					if (this.extraFieldsLength = e.readInt(2), this.fileCommentLength = e.readInt(2), this.diskNumberStart = e.readInt(2), this.internalFileAttributes = e.readInt(2), this.externalFileAttributes = e.readInt(4), this.localHeaderOffset = e.readInt(4), this.isEncrypted()) throw new Error("Encrypted zip are not supported");
					e.skip(t), this.readExtraFields(e), this.parseZIP64ExtraField(e), this.fileComment = e.readData(this.fileCommentLength)
				},
				processAttributes: function() {
					this.unixPermissions = null, this.dosPermissions = null;
					var e = this.versionMadeBy >> 8;
					this.dir = !!(16 & this.externalFileAttributes), 0 == e && (this.dosPermissions = 63 & this.externalFileAttributes), 3 == e && (this.unixPermissions = this.externalFileAttributes >> 16 & 65535), this.dir || "/" !== this.fileNameStr.slice(-1) || (this.dir = !0)
				},
				parseZIP64ExtraField: function() {
					if (this.extraFields[1]) {
						var e = n(this.extraFields[1].value);
						this.uncompressedSize === s.MAX_VALUE_32BITS && (this.uncompressedSize = e.readInt(8)), this.compressedSize === s.MAX_VALUE_32BITS && (this.compressedSize = e.readInt(8)), this.localHeaderOffset === s.MAX_VALUE_32BITS && (this.localHeaderOffset = e.readInt(8)), this.diskNumberStart === s.MAX_VALUE_32BITS && (this.diskNumberStart = e.readInt(4))
					}
				},
				readExtraFields: function(e) {
					var t, r, n, i = e.index + this.extraFieldsLength;
					for (this.extraFields || (this.extraFields = {}); e.index + 4 < i;) t = e.readInt(2), r = e.readInt(2), n = e.readData(r), this.extraFields[t] = {
						id: t,
						length: r,
						value: n
					};
					e.setIndex(i)
				},
				handleUTF8: function() {
					var e = u.uint8array ? "uint8array" : "array";
					if (this.useUTF8()) this.fileNameStr = o.utf8decode(this.fileName), this.fileCommentStr = o.utf8decode(this.fileComment);
					else {
						var t = this.findExtraFieldUnicodePath();
						if (null !== t) this.fileNameStr = t;
						else {
							var r = s.transformTo(e, this.fileName);
							this.fileNameStr = this.loadOptions.decodeFileName(r)
						}
						var n = this.findExtraFieldUnicodeComment();
						if (null !== n) this.fileCommentStr = n;
						else {
							var i = s.transformTo(e, this.fileComment);
							this.fileCommentStr = this.loadOptions.decodeFileName(i)
						}
					}
				},
				findExtraFieldUnicodePath: function() {
					var e = this.extraFields[28789];
					if (e) {
						var t = n(e.value);
						return 1 !== t.readInt(1) ? null : a(this.fileName) !== t.readInt(4) ? null : o.utf8decode(t.readData(e.length - 5))
					}
					return null
				},
				findExtraFieldUnicodeComment: function() {
					var e = this.extraFields[25461];
					if (e) {
						var t = n(e.value);
						return 1 !== t.readInt(1) ? null : a(this.fileComment) !== t.readInt(4) ? null : o.utf8decode(t.readData(e.length - 5))
					}
					return null
				}
			}, t.exports = l
		}, {
			"./compressedObject": 2,
			"./compressions": 3,
			"./crc32": 4,
			"./reader/readerFor": 22,
			"./support": 30,
			"./utf8": 31,
			"./utils": 32
		}],
		35: [function(e, t, r) {
			"use strict";

			function n(e, t, r) {
				this.name = e, this.dir = r.dir, this.date = r.date, this.comment = r.comment, this.unixPermissions = r.unixPermissions, this.dosPermissions = r.dosPermissions, this._data = t, this._dataBinary = r.binary, this.options = {
					compression: r.compression,
					compressionOptions: r.compressionOptions
				}
			}
			var s = e("./stream/StreamHelper"),
				i = e("./stream/DataWorker"),
				a = e("./utf8"),
				o = e("./compressedObject"),
				h = e("./stream/GenericWorker");
			n.prototype = {
				internalStream: function(e) {
					var t = null,
						r = "string";
					try {
						if (!e) throw new Error("No output type specified.");
						var n = "string" === (r = e.toLowerCase()) || "text" === r;
						"binarystring" !== r && "text" !== r || (r = "string"), t = this._decompressWorker();
						var i = !this._dataBinary;
						i && !n && (t = t.pipe(new a.Utf8EncodeWorker)), !i && n && (t = t.pipe(new a.Utf8DecodeWorker))
					} catch (e) {
						(t = new h("error"))
						.error(e)
					}
					return new s(t, r, "")
				},
				async: function(e, t) {
					return this.internalStream(e)
						.accumulate(t)
				},
				nodeStream: function(e, t) {
					return this.internalStream(e || "nodebuffer")
						.toNodejsStream(t)
				},
				_compressWorker: function(e, t) {
					if (this._data instanceof o && this._data.compression.magic === e.magic) return this._data.getCompressedWorker();
					var r = this._decompressWorker();
					return this._dataBinary || (r = r.pipe(new a.Utf8EncodeWorker)), o.createWorkerFrom(r, e, t)
				},
				_decompressWorker: function() {
					return this._data instanceof o ? this._data.getContentWorker() : this._data instanceof h ? this._data : new i(this._data)
				}
			};
			for (var u = ["asText", "asBinary", "asNodeBuffer", "asUint8Array", "asArrayBuffer"], l = function() {
				throw new Error("This method has been removed in JSZip 3.0, please check the upgrade guide.")
			}, f = 0; f < u.length; f++) n.prototype[u[f]] = l;
			t.exports = n
		}, {
			"./compressedObject": 2,
			"./stream/DataWorker": 27,
			"./stream/GenericWorker": 28,
			"./stream/StreamHelper": 29,
			"./utf8": 31
		}],
		36: [function(e, l, t) {
			(function(t) {
				"use strict";
				var r, n, e = t.MutationObserver || t.WebKitMutationObserver;
				if (e) {
					var i = 0,
						s = new e(u),
						a = t.document.createTextNode("");
					s.observe(a, {
						characterData: !0
					}), r = function() {
						a.data = i = ++i % 2
					}
				} else if (t.setImmediate || void 0 === t.MessageChannel) r = "document" in t && "onreadystatechange" in t.document.createElement("script") ? function() {
					var e = t.document.createElement("script");
					e.onreadystatechange = function() {
						u(), e.onreadystatechange = null, e.parentNode.removeChild(e), e = null
					}, t.document.documentElement.appendChild(e)
				} : function() {
					setTimeout(u, 0)
				};
				else {
					var o = new t.MessageChannel;
					o.port1.onmessage = u, r = function() {
						o.port2.postMessage(0)
					}
				}
				var h = [];

				function u() {
					var e, t;
					n = !0;
					for (var r = h.length; r;) {
						for (t = h, h = [], e = -1; ++e < r;) t[e]();
						r = h.length
					}
					n = !1
				}
				l.exports = function(e) {
					1 !== h.push(e) || n || r()
				}
			})
			.call(this, "undefined" != typeof global ? global : "undefined" != typeof self ? self : "undefined" != typeof window ? window : {})
		}, {}],
		37: [function(e, t, r) {
			"use strict";
			var i = e("immediate");

			function u() {}
			var l = {},
				s = ["REJECTED"],
				a = ["FULFILLED"],
				n = ["PENDING"];

			function o(e) {
				if ("function" != typeof e) throw new TypeError("resolver must be a function");
				this.state = n, this.queue = [], this.outcome = void 0, e !== u && d(this, e)
			}

			function h(e, t, r) {
				this.promise = e, "function" == typeof t && (this.onFulfilled = t, this.callFulfilled = this.otherCallFulfilled), "function" == typeof r && (this.onRejected = r, this.callRejected = this.otherCallRejected)
			}

			function f(t, r, n) {
				i(function() {
					var e;
					try {
						e = r(n)
					} catch (e) {
						return l.reject(t, e)
					}
					e === t ? l.reject(t, new TypeError("Cannot resolve promise with itself")) : l.resolve(t, e)
				})
			}

			function c(e) {
				var t = e && e.then;
				if (e && ("object" == typeof e || "function" == typeof e) && "function" == typeof t) return function() {
					t.apply(e, arguments)
				}
			}

			function d(t, e) {
				var r = !1;

				function n(e) {
					r || (r = !0, l.reject(t, e))
				}

				function i(e) {
					r || (r = !0, l.resolve(t, e))
				}
				var s = p(function() {
					e(i, n)
				});
				"error" === s.status && n(s.value)
			}

			function p(e, t) {
				var r = {};
				try {
					r.value = e(t), r.status = "success"
				} catch (e) {
					r.status = "error", r.value = e
				}
				return r
			}(t.exports = o)
			.prototype.finally = function(t) {
				if ("function" != typeof t) return this;
				var r = this.constructor;
				return this.then(function(e) {
					return r.resolve(t())
						.then(function() {
							return e
						})
				}, function(e) {
					return r.resolve(t())
						.then(function() {
							throw e
						})
				})
			}, o.prototype.catch = function(e) {
				return this.then(null, e)
			}, o.prototype.then = function(e, t) {
				if ("function" != typeof e && this.state === a || "function" != typeof t && this.state === s) return this;
				var r = new this.constructor(u);
				this.state !== n ? f(r, this.state === a ? e : t, this.outcome) : this.queue.push(new h(r, e, t));
				return r
			}, h.prototype.callFulfilled = function(e) {
				l.resolve(this.promise, e)
			}, h.prototype.otherCallFulfilled = function(e) {
				f(this.promise, this.onFulfilled, e)
			}, h.prototype.callRejected = function(e) {
				l.reject(this.promise, e)
			}, h.prototype.otherCallRejected = function(e) {
				f(this.promise, this.onRejected, e)
			}, l.resolve = function(e, t) {
				var r = p(c, t);
				if ("error" === r.status) return l.reject(e, r.value);
				var n = r.value;
				if (n) d(e, n);
				else {
					e.state = a, e.outcome = t;
					for (var i = -1, s = e.queue.length; ++i < s;) e.queue[i].callFulfilled(t)
				}
				return e
			}, l.reject = function(e, t) {
				e.state = s, e.outcome = t;
				for (var r = -1, n = e.queue.length; ++r < n;) e.queue[r].callRejected(t);
				return e
			}, o.resolve = function(e) {
				if (e instanceof this) return e;
				return l.resolve(new this(u), e)
			}, o.reject = function(e) {
				var t = new this(u);
				return l.reject(t, e)
			}, o.all = function(e) {
				var r = this;
				if ("[object Array]" !== Object.prototype.toString.call(e)) return this.reject(new TypeError("must be an array"));
				var n = e.length,
					i = !1;
				if (!n) return this.resolve([]);
				var s = new Array(n),
					a = 0,
					t = -1,
					o = new this(u);
				for (; ++t < n;) h(e[t], t);
				return o;

				function h(e, t) {
					r.resolve(e)
						.then(function(e) {
							s[t] = e, ++a !== n || i || (i = !0, l.resolve(o, s))
						}, function(e) {
							i || (i = !0, l.reject(o, e))
						})
				}
			}, o.race = function(e) {
				var t = this;
				if ("[object Array]" !== Object.prototype.toString.call(e)) return this.reject(new TypeError("must be an array"));
				var r = e.length,
					n = !1;
				if (!r) return this.resolve([]);
				var i = -1,
					s = new this(u);
				for (; ++i < r;) a = e[i], t.resolve(a)
					.then(function(e) {
						n || (n = !0, l.resolve(s, e))
					}, function(e) {
						n || (n = !0, l.reject(s, e))
					});
				var a;
				return s
			}
		}, {
			immediate: 36
		}],
		38: [function(e, t, r) {
			"use strict";
			var n = {};
			(0, e("./lib/utils/common")
				.assign)(n, e("./lib/deflate"), e("./lib/inflate"), e("./lib/zlib/constants")), t.exports = n
		}, {
			"./lib/deflate": 39,
			"./lib/inflate": 40,
			"./lib/utils/common": 41,
			"./lib/zlib/constants": 44
		}],
		39: [function(e, t, r) {
			"use strict";
			var a = e("./zlib/deflate"),
				o = e("./utils/common"),
				h = e("./utils/strings"),
				i = e("./zlib/messages"),
				s = e("./zlib/zstream"),
				u = Object.prototype.toString,
				l = 0,
				f = -1,
				c = 0,
				d = 8;

			function p(e) {
				if (!(this instanceof p)) return new p(e);
				this.options = o.assign({
					level: f,
					method: d,
					chunkSize: 16384,
					windowBits: 15,
					memLevel: 8,
					strategy: c,
					to: ""
				}, e || {});
				var t = this.options;
				t.raw && 0 < t.windowBits ? t.windowBits = -t.windowBits : t.gzip && 0 < t.windowBits && t.windowBits < 16 && (t.windowBits += 16), this.err = 0, this.msg = "", this.ended = !1, this.chunks = [], this.strm = new s, this.strm.avail_out = 0;
				var r = a.deflateInit2(this.strm, t.level, t.method, t.windowBits, t.memLevel, t.strategy);
				if (r !== l) throw new Error(i[r]);
				if (t.header && a.deflateSetHeader(this.strm, t.header), t.dictionary) {
					var n;
					if (n = "string" == typeof t.dictionary ? h.string2buf(t.dictionary) : "[object ArrayBuffer]" === u.call(t.dictionary) ? new Uint8Array(t.dictionary) : t.dictionary, (r = a.deflateSetDictionary(this.strm, n)) !== l) throw new Error(i[r]);
					this._dict_set = !0
				}
			}

			function n(e, t) {
				var r = new p(t);
				if (r.push(e, !0), r.err) throw r.msg || i[r.err];
				return r.result
			}
			p.prototype.push = function(e, t) {
				var r, n, i = this.strm,
					s = this.options.chunkSize;
				if (this.ended) return !1;
				n = t === ~~t ? t : !0 === t ? 4 : 0, "string" == typeof e ? i.input = h.string2buf(e) : "[object ArrayBuffer]" === u.call(e) ? i.input = new Uint8Array(e) : i.input = e, i.next_in = 0, i.avail_in = i.input.length;
				do {
					if (0 === i.avail_out && (i.output = new o.Buf8(s), i.next_out = 0, i.avail_out = s), 1 !== (r = a.deflate(i, n)) && r !== l) return this.onEnd(r), !(this.ended = !0);
					0 !== i.avail_out && (0 !== i.avail_in || 4 !== n && 2 !== n) || ("string" === this.options.to ? this.onData(h.buf2binstring(o.shrinkBuf(i.output, i.next_out))) : this.onData(o.shrinkBuf(i.output, i.next_out)))
				} while ((0 < i.avail_in || 0 === i.avail_out) && 1 !== r);
				return 4 === n ? (r = a.deflateEnd(this.strm), this.onEnd(r), this.ended = !0, r === l) : 2 !== n || (this.onEnd(l), !(i.avail_out = 0))
			}, p.prototype.onData = function(e) {
				this.chunks.push(e)
			}, p.prototype.onEnd = function(e) {
				e === l && ("string" === this.options.to ? this.result = this.chunks.join("") : this.result = o.flattenChunks(this.chunks)), this.chunks = [], this.err = e, this.msg = this.strm.msg
			}, r.Deflate = p, r.deflate = n, r.deflateRaw = function(e, t) {
				return (t = t || {})
					.raw = !0, n(e, t)
			}, r.gzip = function(e, t) {
				return (t = t || {})
					.gzip = !0, n(e, t)
			}
		}, {
			"./utils/common": 41,
			"./utils/strings": 42,
			"./zlib/deflate": 46,
			"./zlib/messages": 51,
			"./zlib/zstream": 53
		}],
		40: [function(e, t, r) {
			"use strict";
			var c = e("./zlib/inflate"),
				d = e("./utils/common"),
				p = e("./utils/strings"),
				m = e("./zlib/constants"),
				n = e("./zlib/messages"),
				i = e("./zlib/zstream"),
				s = e("./zlib/gzheader"),
				_ = Object.prototype.toString;

			function a(e) {
				if (!(this instanceof a)) return new a(e);
				this.options = d.assign({
					chunkSize: 16384,
					windowBits: 0,
					to: ""
				}, e || {});
				var t = this.options;
				t.raw && 0 <= t.windowBits && t.windowBits < 16 && (t.windowBits = -t.windowBits, 0 === t.windowBits && (t.windowBits = -15)), !(0 <= t.windowBits && t.windowBits < 16) || e && e.windowBits || (t.windowBits += 32), 15 < t.windowBits && t.windowBits < 48 && 0 == (15 & t.windowBits) && (t.windowBits |= 15), this.err = 0, this.msg = "", this.ended = !1, this.chunks = [], this.strm = new i, this.strm.avail_out = 0;
				var r = c.inflateInit2(this.strm, t.windowBits);
				if (r !== m.Z_OK) throw new Error(n[r]);
				this.header = new s, c.inflateGetHeader(this.strm, this.header)
			}

			function o(e, t) {
				var r = new a(t);
				if (r.push(e, !0), r.err) throw r.msg || n[r.err];
				return r.result
			}
			a.prototype.push = function(e, t) {
				var r, n, i, s, a, o, h = this.strm,
					u = this.options.chunkSize,
					l = this.options.dictionary,
					f = !1;
				if (this.ended) return !1;
				n = t === ~~t ? t : !0 === t ? m.Z_FINISH : m.Z_NO_FLUSH, "string" == typeof e ? h.input = p.binstring2buf(e) : "[object ArrayBuffer]" === _.call(e) ? h.input = new Uint8Array(e) : h.input = e, h.next_in = 0, h.avail_in = h.input.length;
				do {
					if (0 === h.avail_out && (h.output = new d.Buf8(u), h.next_out = 0, h.avail_out = u), (r = c.inflate(h, m.Z_NO_FLUSH)) === m.Z_NEED_DICT && l && (o = "string" == typeof l ? p.string2buf(l) : "[object ArrayBuffer]" === _.call(l) ? new Uint8Array(l) : l, r = c.inflateSetDictionary(this.strm, o)), r === m.Z_BUF_ERROR && !0 === f && (r = m.Z_OK, f = !1), r !== m.Z_STREAM_END && r !== m.Z_OK) return this.onEnd(r), !(this.ended = !0);
					h.next_out && (0 !== h.avail_out && r !== m.Z_STREAM_END && (0 !== h.avail_in || n !== m.Z_FINISH && n !== m.Z_SYNC_FLUSH) || ("string" === this.options.to ? (i = p.utf8border(h.output, h.next_out), s = h.next_out - i, a = p.buf2string(h.output, i), h.next_out = s, h.avail_out = u - s, s && d.arraySet(h.output, h.output, i, s, 0), this.onData(a)) : this.onData(d.shrinkBuf(h.output, h.next_out)))), 0 === h.avail_in && 0 === h.avail_out && (f = !0)
				} while ((0 < h.avail_in || 0 === h.avail_out) && r !== m.Z_STREAM_END);
				return r === m.Z_STREAM_END && (n = m.Z_FINISH), n === m.Z_FINISH ? (r = c.inflateEnd(this.strm), this.onEnd(r), this.ended = !0, r === m.Z_OK) : n !== m.Z_SYNC_FLUSH || (this.onEnd(m.Z_OK), !(h.avail_out = 0))
			}, a.prototype.onData = function(e) {
				this.chunks.push(e)
			}, a.prototype.onEnd = function(e) {
				e === m.Z_OK && ("string" === this.options.to ? this.result = this.chunks.join("") : this.result = d.flattenChunks(this.chunks)), this.chunks = [], this.err = e, this.msg = this.strm.msg
			}, r.Inflate = a, r.inflate = o, r.inflateRaw = function(e, t) {
				return (t = t || {})
					.raw = !0, o(e, t)
			}, r.ungzip = o
		}, {
			"./utils/common": 41,
			"./utils/strings": 42,
			"./zlib/constants": 44,
			"./zlib/gzheader": 47,
			"./zlib/inflate": 49,
			"./zlib/messages": 51,
			"./zlib/zstream": 53
		}],
		41: [function(e, t, r) {
			"use strict";
			var n = "undefined" != typeof Uint8Array && "undefined" != typeof Uint16Array && "undefined" != typeof Int32Array;
			r.assign = function(e) {
				for (var t = Array.prototype.slice.call(arguments, 1); t.length;) {
					var r = t.shift();
					if (r) {
						if ("object" != typeof r) throw new TypeError(r + "must be non-object");
						for (var n in r) r.hasOwnProperty(n) && (e[n] = r[n])
					}
				}
				return e
			}, r.shrinkBuf = function(e, t) {
				return e.length === t ? e : e.subarray ? e.subarray(0, t) : (e.length = t, e)
			};
			var i = {
					arraySet: function(e, t, r, n, i) {
						if (t.subarray && e.subarray) e.set(t.subarray(r, r + n), i);
						else
							for (var s = 0; s < n; s++) e[i + s] = t[r + s]
					},
					flattenChunks: function(e) {
						var t, r, n, i, s, a;
						for (t = n = 0, r = e.length; t < r; t++) n += e[t].length;
						for (a = new Uint8Array(n), t = i = 0, r = e.length; t < r; t++) s = e[t], a.set(s, i), i += s.length;
						return a
					}
				},
				s = {
					arraySet: function(e, t, r, n, i) {
						for (var s = 0; s < n; s++) e[i + s] = t[r + s]
					},
					flattenChunks: function(e) {
						return [].concat.apply([], e)
					}
				};
			r.setTyped = function(e) {
				e ? (r.Buf8 = Uint8Array, r.Buf16 = Uint16Array, r.Buf32 = Int32Array, r.assign(r, i)) : (r.Buf8 = Array, r.Buf16 = Array, r.Buf32 = Array, r.assign(r, s))
			}, r.setTyped(n)
		}, {}],
		42: [function(e, t, r) {
			"use strict";
			var h = e("./common"),
				i = !0,
				s = !0;
			try {
				String.fromCharCode.apply(null, [0])
			} catch (e) {
				i = !1
			}
			try {
				String.fromCharCode.apply(null, new Uint8Array(1))
			} catch (e) {
				s = !1
			}
			for (var u = new h.Buf8(256), n = 0; n < 256; n++) u[n] = 252 <= n ? 6 : 248 <= n ? 5 : 240 <= n ? 4 : 224 <= n ? 3 : 192 <= n ? 2 : 1;

			function l(e, t) {
				if (t < 65537 && (e.subarray && s || !e.subarray && i)) return String.fromCharCode.apply(null, h.shrinkBuf(e, t));
				for (var r = "", n = 0; n < t; n++) r += String.fromCharCode(e[n]);
				return r
			}
			u[254] = u[254] = 1, r.string2buf = function(e) {
				var t, r, n, i, s, a = e.length,
					o = 0;
				for (i = 0; i < a; i++) 55296 == (64512 & (r = e.charCodeAt(i))) && i + 1 < a && 56320 == (64512 & (n = e.charCodeAt(i + 1))) && (r = 65536 + (r - 55296 << 10) + (n - 56320), i++), o += r < 128 ? 1 : r < 2048 ? 2 : r < 65536 ? 3 : 4;
				for (t = new h.Buf8(o), i = s = 0; s < o; i++) 55296 == (64512 & (r = e.charCodeAt(i))) && i + 1 < a && 56320 == (64512 & (n = e.charCodeAt(i + 1))) && (r = 65536 + (r - 55296 << 10) + (n - 56320), i++), r < 128 ? t[s++] = r : (r < 2048 ? t[s++] = 192 | r >>> 6 : (r < 65536 ? t[s++] = 224 | r >>> 12 : (t[s++] = 240 | r >>> 18, t[s++] = 128 | r >>> 12 & 63), t[s++] = 128 | r >>> 6 & 63), t[s++] = 128 | 63 & r);
				return t
			}, r.buf2binstring = function(e) {
				return l(e, e.length)
			}, r.binstring2buf = function(e) {
				for (var t = new h.Buf8(e.length), r = 0, n = t.length; r < n; r++) t[r] = e.charCodeAt(r);
				return t
			}, r.buf2string = function(e, t) {
				var r, n, i, s, a = t || e.length,
					o = new Array(2 * a);
				for (r = n = 0; r < a;)
					if ((i = e[r++]) < 128) o[n++] = i;
					else if (4 < (s = u[i])) o[n++] = 65533, r += s - 1;
				else {
					for (i &= 2 === s ? 31 : 3 === s ? 15 : 7; 1 < s && r < a;) i = i << 6 | 63 & e[r++], s--;
					1 < s ? o[n++] = 65533 : i < 65536 ? o[n++] = i : (i -= 65536, o[n++] = 55296 | i >> 10 & 1023, o[n++] = 56320 | 1023 & i)
				}
				return l(o, n)
			}, r.utf8border = function(e, t) {
				var r;
				for ((t = t || e.length) > e.length && (t = e.length), r = t - 1; 0 <= r && 128 == (192 & e[r]);) r--;
				return r < 0 ? t : 0 === r ? t : r + u[e[r]] > t ? r : t
			}
		}, {
			"./common": 41
		}],
		43: [function(e, t, r) {
			"use strict";
			t.exports = function(e, t, r, n) {
				for (var i = 65535 & e | 0, s = e >>> 16 & 65535 | 0, a = 0; 0 !== r;) {
					for (r -= a = 2e3 < r ? 2e3 : r; s = s + (i = i + t[n++] | 0) | 0, --a;);
					i %= 65521, s %= 65521
				}
				return i | s << 16 | 0
			}
		}, {}],
		44: [function(e, t, r) {
			"use strict";
			t.exports = {
				Z_NO_FLUSH: 0,
				Z_PARTIAL_FLUSH: 1,
				Z_SYNC_FLUSH: 2,
				Z_FULL_FLUSH: 3,
				Z_FINISH: 4,
				Z_BLOCK: 5,
				Z_TREES: 6,
				Z_OK: 0,
				Z_STREAM_END: 1,
				Z_NEED_DICT: 2,
				Z_ERRNO: -1,
				Z_STREAM_ERROR: -2,
				Z_DATA_ERROR: -3,
				Z_BUF_ERROR: -5,
				Z_NO_COMPRESSION: 0,
				Z_BEST_SPEED: 1,
				Z_BEST_COMPRESSION: 9,
				Z_DEFAULT_COMPRESSION: -1,
				Z_FILTERED: 1,
				Z_HUFFMAN_ONLY: 2,
				Z_RLE: 3,
				Z_FIXED: 4,
				Z_DEFAULT_STRATEGY: 0,
				Z_BINARY: 0,
				Z_TEXT: 1,
				Z_UNKNOWN: 2,
				Z_DEFLATED: 8
			}
		}, {}],
		45: [function(e, t, r) {
			"use strict";
			var o = function() {
				for (var e, t = [], r = 0; r < 256; r++) {
					e = r;
					for (var n = 0; n < 8; n++) e = 1 & e ? 3988292384 ^ e >>> 1 : e >>> 1;
					t[r] = e
				}
				return t
			}();
			t.exports = function(e, t, r, n) {
				var i = o,
					s = n + r;
				e ^= -1;
				for (var a = n; a < s; a++) e = e >>> 8 ^ i[255 & (e ^ t[a])];
				return -1 ^ e
			}
		}, {}],
		46: [function(e, t, r) {
			"use strict";
			var h, c = e("../utils/common"),
				u = e("./trees"),
				d = e("./adler32"),
				p = e("./crc32"),
				n = e("./messages"),
				l = 0,
				f = 4,
				m = 0,
				_ = -2,
				g = -1,
				b = 4,
				i = 2,
				v = 8,
				y = 9,
				s = 286,
				a = 30,
				o = 19,
				w = 2 * s + 1,
				k = 15,
				x = 3,
				S = 258,
				z = S + x + 1,
				C = 42,
				E = 113,
				A = 1,
				I = 2,
				O = 3,
				B = 4;

			function R(e, t) {
				return e.msg = n[t], t
			}

			function T(e) {
				return (e << 1) - (4 < e ? 9 : 0)
			}

			function D(e) {
				for (var t = e.length; 0 <= --t;) e[t] = 0
			}

			function F(e) {
				var t = e.state,
					r = t.pending;
				r > e.avail_out && (r = e.avail_out), 0 !== r && (c.arraySet(e.output, t.pending_buf, t.pending_out, r, e.next_out), e.next_out += r, t.pending_out += r, e.total_out += r, e.avail_out -= r, t.pending -= r, 0 === t.pending && (t.pending_out = 0))
			}

			function N(e, t) {
				u._tr_flush_block(e, 0 <= e.block_start ? e.block_start : -1, e.strstart - e.block_start, t), e.block_start = e.strstart, F(e.strm)
			}

			function U(e, t) {
				e.pending_buf[e.pending++] = t
			}

			function P(e, t) {
				e.pending_buf[e.pending++] = t >>> 8 & 255, e.pending_buf[e.pending++] = 255 & t
			}

			function L(e, t) {
				var r, n, i = e.max_chain_length,
					s = e.strstart,
					a = e.prev_length,
					o = e.nice_match,
					h = e.strstart > e.w_size - z ? e.strstart - (e.w_size - z) : 0,
					u = e.window,
					l = e.w_mask,
					f = e.prev,
					c = e.strstart + S,
					d = u[s + a - 1],
					p = u[s + a];
				e.prev_length >= e.good_match && (i >>= 2), o > e.lookahead && (o = e.lookahead);
				do {
					if (u[(r = t) + a] === p && u[r + a - 1] === d && u[r] === u[s] && u[++r] === u[s + 1]) {
						s += 2, r++;
						do {} while (u[++s] === u[++r] && u[++s] === u[++r] && u[++s] === u[++r] && u[++s] === u[++r] && u[++s] === u[++r] && u[++s] === u[++r] && u[++s] === u[++r] && u[++s] === u[++r] && s < c);
						if (n = S - (c - s), s = c - S, a < n) {
							if (e.match_start = t, o <= (a = n)) break;
							d = u[s + a - 1], p = u[s + a]
						}
					}
				} while ((t = f[t & l]) > h && 0 != --i);
				return a <= e.lookahead ? a : e.lookahead
			}

			function j(e) {
				var t, r, n, i, s, a, o, h, u, l, f = e.w_size;
				do {
					if (i = e.window_size - e.lookahead - e.strstart, e.strstart >= f + (f - z)) {
						for (c.arraySet(e.window, e.window, f, f, 0), e.match_start -= f, e.strstart -= f, e.block_start -= f, t = r = e.hash_size; n = e.head[--t], e.head[t] = f <= n ? n - f : 0, --r;);
						for (t = r = f; n = e.prev[--t], e.prev[t] = f <= n ? n - f : 0, --r;);
						i += f
					}
					if (0 === e.strm.avail_in) break;
					if (a = e.strm, o = e.window, h = e.strstart + e.lookahead, u = i, l = void 0, l = a.avail_in, u < l && (l = u), r = 0 === l ? 0 : (a.avail_in -= l, c.arraySet(o, a.input, a.next_in, l, h), 1 === a.state.wrap ? a.adler = d(a.adler, o, l, h) : 2 === a.state.wrap && (a.adler = p(a.adler, o, l, h)), a.next_in += l, a.total_in += l, l), e.lookahead += r, e.lookahead + e.insert >= x)
						for (s = e.strstart - e.insert, e.ins_h = e.window[s], e.ins_h = (e.ins_h << e.hash_shift ^ e.window[s + 1]) & e.hash_mask; e.insert && (e.ins_h = (e.ins_h << e.hash_shift ^ e.window[s + x - 1]) & e.hash_mask, e.prev[s & e.w_mask] = e.head[e.ins_h], e.head[e.ins_h] = s, s++, e.insert--, !(e.lookahead + e.insert < x)););
				} while (e.lookahead < z && 0 !== e.strm.avail_in)
			}

			function Z(e, t) {
				for (var r, n;;) {
					if (e.lookahead < z) {
						if (j(e), e.lookahead < z && t === l) return A;
						if (0 === e.lookahead) break
					}
					if (r = 0, e.lookahead >= x && (e.ins_h = (e.ins_h << e.hash_shift ^ e.window[e.strstart + x - 1]) & e.hash_mask, r = e.prev[e.strstart & e.w_mask] = e.head[e.ins_h], e.head[e.ins_h] = e.strstart), 0 !== r && e.strstart - r <= e.w_size - z && (e.match_length = L(e, r)), e.match_length >= x)
						if (n = u._tr_tally(e, e.strstart - e.match_start, e.match_length - x), e.lookahead -= e.match_length, e.match_length <= e.max_lazy_match && e.lookahead >= x) {
							for (e.match_length--; e.strstart++, e.ins_h = (e.ins_h << e.hash_shift ^ e.window[e.strstart + x - 1]) & e.hash_mask, r = e.prev[e.strstart & e.w_mask] = e.head[e.ins_h], e.head[e.ins_h] = e.strstart, 0 != --e.match_length;);
							e.strstart++
						} else e.strstart += e.match_length, e.match_length = 0, e.ins_h = e.window[e.strstart], e.ins_h = (e.ins_h << e.hash_shift ^ e.window[e.strstart + 1]) & e.hash_mask;
					else n = u._tr_tally(e, 0, e.window[e.strstart]), e.lookahead--, e.strstart++;
					if (n && (N(e, !1), 0 === e.strm.avail_out)) return A
				}
				return e.insert = e.strstart < x - 1 ? e.strstart : x - 1, t === f ? (N(e, !0), 0 === e.strm.avail_out ? O : B) : e.last_lit && (N(e, !1), 0 === e.strm.avail_out) ? A : I
			}

			function W(e, t) {
				for (var r, n, i;;) {
					if (e.lookahead < z) {
						if (j(e), e.lookahead < z && t === l) return A;
						if (0 === e.lookahead) break
					}
					if (r = 0, e.lookahead >= x && (e.ins_h = (e.ins_h << e.hash_shift ^ e.window[e.strstart + x - 1]) & e.hash_mask, r = e.prev[e.strstart & e.w_mask] = e.head[e.ins_h], e.head[e.ins_h] = e.strstart), e.prev_length = e.match_length, e.prev_match = e.match_start, e.match_length = x - 1, 0 !== r && e.prev_length < e.max_lazy_match && e.strstart - r <= e.w_size - z && (e.match_length = L(e, r), e.match_length <= 5 && (1 === e.strategy || e.match_length === x && 4096 < e.strstart - e.match_start) && (e.match_length = x - 1)), e.prev_length >= x && e.match_length <= e.prev_length) {
						for (i = e.strstart + e.lookahead - x, n = u._tr_tally(e, e.strstart - 1 - e.prev_match, e.prev_length - x), e.lookahead -= e.prev_length - 1, e.prev_length -= 2; ++e.strstart <= i && (e.ins_h = (e.ins_h << e.hash_shift ^ e.window[e.strstart + x - 1]) & e.hash_mask, r = e.prev[e.strstart & e.w_mask] = e.head[e.ins_h], e.head[e.ins_h] = e.strstart), 0 != --e.prev_length;);
						if (e.match_available = 0, e.match_length = x - 1, e.strstart++, n && (N(e, !1), 0 === e.strm.avail_out)) return A
					} else if (e.match_available) {
						if ((n = u._tr_tally(e, 0, e.window[e.strstart - 1])) && N(e, !1), e.strstart++, e.lookahead--, 0 === e.strm.avail_out) return A
					} else e.match_available = 1, e.strstart++, e.lookahead--
				}
				return e.match_available && (n = u._tr_tally(e, 0, e.window[e.strstart - 1]), e.match_available = 0), e.insert = e.strstart < x - 1 ? e.strstart : x - 1, t === f ? (N(e, !0), 0 === e.strm.avail_out ? O : B) : e.last_lit && (N(e, !1), 0 === e.strm.avail_out) ? A : I
			}

			function M(e, t, r, n, i) {
				this.good_length = e, this.max_lazy = t, this.nice_length = r, this.max_chain = n, this.func = i
			}

			function H() {
				this.strm = null, this.status = 0, this.pending_buf = null, this.pending_buf_size = 0, this.pending_out = 0, this.pending = 0, this.wrap = 0, this.gzhead = null, this.gzindex = 0, this.method = v, this.last_flush = -1, this.w_size = 0, this.w_bits = 0, this.w_mask = 0, this.window = null, this.window_size = 0, this.prev = null, this.head = null, this.ins_h = 0, this.hash_size = 0, this.hash_bits = 0, this.hash_mask = 0, this.hash_shift = 0, this.block_start = 0, this.match_length = 0, this.prev_match = 0, this.match_available = 0, this.strstart = 0, this.match_start = 0, this.lookahead = 0, this.prev_length = 0, this.max_chain_length = 0, this.max_lazy_match = 0, this.level = 0, this.strategy = 0, this.good_match = 0, this.nice_match = 0, this.dyn_ltree = new c.Buf16(2 * w), this.dyn_dtree = new c.Buf16(2 * (2 * a + 1)), this.bl_tree = new c.Buf16(2 * (2 * o + 1)), D(this.dyn_ltree), D(this.dyn_dtree), D(this.bl_tree), this.l_desc = null, this.d_desc = null, this.bl_desc = null, this.bl_count = new c.Buf16(k + 1), this.heap = new c.Buf16(2 * s + 1), D(this.heap), this.heap_len = 0, this.heap_max = 0, this.depth = new c.Buf16(2 * s + 1), D(this.depth), this.l_buf = 0, this.lit_bufsize = 0, this.last_lit = 0, this.d_buf = 0, this.opt_len = 0, this.static_len = 0, this.matches = 0, this.insert = 0, this.bi_buf = 0, this.bi_valid = 0
			}

			function G(e) {
				var t;
				return e && e.state ? (e.total_in = e.total_out = 0, e.data_type = i, (t = e.state)
					.pending = 0, t.pending_out = 0, t.wrap < 0 && (t.wrap = -t.wrap), t.status = t.wrap ? C : E, e.adler = 2 === t.wrap ? 0 : 1, t.last_flush = l, u._tr_init(t), m) : R(e, _)
			}

			function K(e) {
				var t = G(e);
				return t === m && function(e) {
					e.window_size = 2 * e.w_size, D(e.head), e.max_lazy_match = h[e.level].max_lazy, e.good_match = h[e.level].good_length, e.nice_match = h[e.level].nice_length, e.max_chain_length = h[e.level].max_chain, e.strstart = 0, e.block_start = 0, e.lookahead = 0, e.insert = 0, e.match_length = e.prev_length = x - 1, e.match_available = 0, e.ins_h = 0
				}(e.state), t
			}

			function Y(e, t, r, n, i, s) {
				if (!e) return _;
				var a = 1;
				if (t === g && (t = 6), n < 0 ? (a = 0, n = -n) : 15 < n && (a = 2, n -= 16), i < 1 || y < i || r !== v || n < 8 || 15 < n || t < 0 || 9 < t || s < 0 || b < s) return R(e, _);
				8 === n && (n = 9);
				var o = new H;
				return (e.state = o)
					.strm = e, o.wrap = a, o.gzhead = null, o.w_bits = n, o.w_size = 1 << o.w_bits, o.w_mask = o.w_size - 1, o.hash_bits = i + 7, o.hash_size = 1 << o.hash_bits, o.hash_mask = o.hash_size - 1, o.hash_shift = ~~((o.hash_bits + x - 1) / x), o.window = new c.Buf8(2 * o.w_size), o.head = new c.Buf16(o.hash_size), o.prev = new c.Buf16(o.w_size), o.lit_bufsize = 1 << i + 6, o.pending_buf_size = 4 * o.lit_bufsize, o.pending_buf = new c.Buf8(o.pending_buf_size), o.d_buf = 1 * o.lit_bufsize, o.l_buf = 3 * o.lit_bufsize, o.level = t, o.strategy = s, o.method = r, K(e)
			}
			h = [new M(0, 0, 0, 0, function(e, t) {
				var r = 65535;
				for (r > e.pending_buf_size - 5 && (r = e.pending_buf_size - 5);;) {
					if (e.lookahead <= 1) {
						if (j(e), 0 === e.lookahead && t === l) return A;
						if (0 === e.lookahead) break
					}
					e.strstart += e.lookahead, e.lookahead = 0;
					var n = e.block_start + r;
					if ((0 === e.strstart || e.strstart >= n) && (e.lookahead = e.strstart - n, e.strstart = n, N(e, !1), 0 === e.strm.avail_out)) return A;
					if (e.strstart - e.block_start >= e.w_size - z && (N(e, !1), 0 === e.strm.avail_out)) return A
				}
				return e.insert = 0, t === f ? (N(e, !0), 0 === e.strm.avail_out ? O : B) : (e.strstart > e.block_start && (N(e, !1), e.strm.avail_out), A)
			}), new M(4, 4, 8, 4, Z), new M(4, 5, 16, 8, Z), new M(4, 6, 32, 32, Z), new M(4, 4, 16, 16, W), new M(8, 16, 32, 32, W), new M(8, 16, 128, 128, W), new M(8, 32, 128, 256, W), new M(32, 128, 258, 1024, W), new M(32, 258, 258, 4096, W)], r.deflateInit = function(e, t) {
				return Y(e, t, v, 15, 8, 0)
			}, r.deflateInit2 = Y, r.deflateReset = K, r.deflateResetKeep = G, r.deflateSetHeader = function(e, t) {
				return e && e.state ? 2 !== e.state.wrap ? _ : (e.state.gzhead = t, m) : _
			}, r.deflate = function(e, t) {
				var r, n, i, s;
				if (!e || !e.state || 5 < t || t < 0) return e ? R(e, _) : _;
				if (n = e.state, !e.output || !e.input && 0 !== e.avail_in || 666 === n.status && t !== f) return R(e, 0 === e.avail_out ? -5 : _);
				if (n.strm = e, r = n.last_flush, n.last_flush = t, n.status === C)
					if (2 === n.wrap) e.adler = 0, U(n, 31), U(n, 139), U(n, 8), n.gzhead ? (U(n, (n.gzhead.text ? 1 : 0) + (n.gzhead.hcrc ? 2 : 0) + (n.gzhead.extra ? 4 : 0) + (n.gzhead.name ? 8 : 0) + (n.gzhead.comment ? 16 : 0)), U(n, 255 & n.gzhead.time), U(n, n.gzhead.time >> 8 & 255), U(n, n.gzhead.time >> 16 & 255), U(n, n.gzhead.time >> 24 & 255), U(n, 9 === n.level ? 2 : 2 <= n.strategy || n.level < 2 ? 4 : 0), U(n, 255 & n.gzhead.os), n.gzhead.extra && n.gzhead.extra.length && (U(n, 255 & n.gzhead.extra.length), U(n, n.gzhead.extra.length >> 8 & 255)), n.gzhead.hcrc && (e.adler = p(e.adler, n.pending_buf, n.pending, 0)), n.gzindex = 0, n.status = 69) : (U(n, 0), U(n, 0), U(n, 0), U(n, 0), U(n, 0), U(n, 9 === n.level ? 2 : 2 <= n.strategy || n.level < 2 ? 4 : 0), U(n, 3), n.status = E);
					else {
						var a = v + (n.w_bits - 8 << 4) << 8;
						a |= (2 <= n.strategy || n.level < 2 ? 0 : n.level < 6 ? 1 : 6 === n.level ? 2 : 3) << 6, 0 !== n.strstart && (a |= 32), a += 31 - a % 31, n.status = E, P(n, a), 0 !== n.strstart && (P(n, e.adler >>> 16), P(n, 65535 & e.adler)), e.adler = 1
					} if (69 === n.status)
					if (n.gzhead.extra) {
						for (i = n.pending; n.gzindex < (65535 & n.gzhead.extra.length) && (n.pending !== n.pending_buf_size || (n.gzhead.hcrc && n.pending > i && (e.adler = p(e.adler, n.pending_buf, n.pending - i, i)), F(e), i = n.pending, n.pending !== n.pending_buf_size));) U(n, 255 & n.gzhead.extra[n.gzindex]), n.gzindex++;
						n.gzhead.hcrc && n.pending > i && (e.adler = p(e.adler, n.pending_buf, n.pending - i, i)), n.gzindex === n.gzhead.extra.length && (n.gzindex = 0, n.status = 73)
					} else n.status = 73;
				if (73 === n.status)
					if (n.gzhead.name) {
						i = n.pending;
						do {
							if (n.pending === n.pending_buf_size && (n.gzhead.hcrc && n.pending > i && (e.adler = p(e.adler, n.pending_buf, n.pending - i, i)), F(e), i = n.pending, n.pending === n.pending_buf_size)) {
								s = 1;
								break
							}
							s = n.gzindex < n.gzhead.name.length ? 255 & n.gzhead.name.charCodeAt(n.gzindex++) : 0, U(n, s)
						} while (0 !== s);
						n.gzhead.hcrc && n.pending > i && (e.adler = p(e.adler, n.pending_buf, n.pending - i, i)), 0 === s && (n.gzindex = 0, n.status = 91)
					} else n.status = 91;
				if (91 === n.status)
					if (n.gzhead.comment) {
						i = n.pending;
						do {
							if (n.pending === n.pending_buf_size && (n.gzhead.hcrc && n.pending > i && (e.adler = p(e.adler, n.pending_buf, n.pending - i, i)), F(e), i = n.pending, n.pending === n.pending_buf_size)) {
								s = 1;
								break
							}
							s = n.gzindex < n.gzhead.comment.length ? 255 & n.gzhead.comment.charCodeAt(n.gzindex++) : 0, U(n, s)
						} while (0 !== s);
						n.gzhead.hcrc && n.pending > i && (e.adler = p(e.adler, n.pending_buf, n.pending - i, i)), 0 === s && (n.status = 103)
					} else n.status = 103;
				if (103 === n.status && (n.gzhead.hcrc ? (n.pending + 2 > n.pending_buf_size && F(e), n.pending + 2 <= n.pending_buf_size && (U(n, 255 & e.adler), U(n, e.adler >> 8 & 255), e.adler = 0, n.status = E)) : n.status = E), 0 !== n.pending) {
					if (F(e), 0 === e.avail_out) return n.last_flush = -1, m
				} else if (0 === e.avail_in && T(t) <= T(r) && t !== f) return R(e, -5);
				if (666 === n.status && 0 !== e.avail_in) return R(e, -5);
				if (0 !== e.avail_in || 0 !== n.lookahead || t !== l && 666 !== n.status) {
					var o = 2 === n.strategy ? function(e, t) {
						for (var r;;) {
							if (0 === e.lookahead && (j(e), 0 === e.lookahead)) {
								if (t === l) return A;
								break
							}
							if (e.match_length = 0, r = u._tr_tally(e, 0, e.window[e.strstart]), e.lookahead--, e.strstart++, r && (N(e, !1), 0 === e.strm.avail_out)) return A
						}
						return e.insert = 0, t === f ? (N(e, !0), 0 === e.strm.avail_out ? O : B) : e.last_lit && (N(e, !1), 0 === e.strm.avail_out) ? A : I
					}(n, t) : 3 === n.strategy ? function(e, t) {
						for (var r, n, i, s, a = e.window;;) {
							if (e.lookahead <= S) {
								if (j(e), e.lookahead <= S && t === l) return A;
								if (0 === e.lookahead) break
							}
							if (e.match_length = 0, e.lookahead >= x && 0 < e.strstart && (n = a[i = e.strstart - 1]) === a[++i] && n === a[++i] && n === a[++i]) {
								s = e.strstart + S;
								do {} while (n === a[++i] && n === a[++i] && n === a[++i] && n === a[++i] && n === a[++i] && n === a[++i] && n === a[++i] && n === a[++i] && i < s);
								e.match_length = S - (s - i), e.match_length > e.lookahead && (e.match_length = e.lookahead)
							}
							if (e.match_length >= x ? (r = u._tr_tally(e, 1, e.match_length - x), e.lookahead -= e.match_length, e.strstart += e.match_length, e.match_length = 0) : (r = u._tr_tally(e, 0, e.window[e.strstart]), e.lookahead--, e.strstart++), r && (N(e, !1), 0 === e.strm.avail_out)) return A
						}
						return e.insert = 0, t === f ? (N(e, !0), 0 === e.strm.avail_out ? O : B) : e.last_lit && (N(e, !1), 0 === e.strm.avail_out) ? A : I
					}(n, t) : h[n.level].func(n, t);
					if (o !== O && o !== B || (n.status = 666), o === A || o === O) return 0 === e.avail_out && (n.last_flush = -1), m;
					if (o === I && (1 === t ? u._tr_align(n) : 5 !== t && (u._tr_stored_block(n, 0, 0, !1), 3 === t && (D(n.head), 0 === n.lookahead && (n.strstart = 0, n.block_start = 0, n.insert = 0))), F(e), 0 === e.avail_out)) return n.last_flush = -1, m
				}
				return t !== f ? m : n.wrap <= 0 ? 1 : (2 === n.wrap ? (U(n, 255 & e.adler), U(n, e.adler >> 8 & 255), U(n, e.adler >> 16 & 255), U(n, e.adler >> 24 & 255), U(n, 255 & e.total_in), U(n, e.total_in >> 8 & 255), U(n, e.total_in >> 16 & 255), U(n, e.total_in >> 24 & 255)) : (P(n, e.adler >>> 16), P(n, 65535 & e.adler)), F(e), 0 < n.wrap && (n.wrap = -n.wrap), 0 !== n.pending ? m : 1)
			}, r.deflateEnd = function(e) {
				var t;
				return e && e.state ? (t = e.state.status) !== C && 69 !== t && 73 !== t && 91 !== t && 103 !== t && t !== E && 666 !== t ? R(e, _) : (e.state = null, t === E ? R(e, -3) : m) : _
			}, r.deflateSetDictionary = function(e, t) {
				var r, n, i, s, a, o, h, u, l = t.length;
				if (!e || !e.state) return _;
				if (2 === (s = (r = e.state)
					.wrap) || 1 === s && r.status !== C || r.lookahead) return _;
				for (1 === s && (e.adler = d(e.adler, t, l, 0)), r.wrap = 0, l >= r.w_size && (0 === s && (D(r.head), r.strstart = 0, r.block_start = 0, r.insert = 0), u = new c.Buf8(r.w_size), c.arraySet(u, t, l - r.w_size, r.w_size, 0), t = u, l = r.w_size), a = e.avail_in, o = e.next_in, h = e.input, e.avail_in = l, e.next_in = 0, e.input = t, j(r); r.lookahead >= x;) {
					for (n = r.strstart, i = r.lookahead - (x - 1); r.ins_h = (r.ins_h << r.hash_shift ^ r.window[n + x - 1]) & r.hash_mask, r.prev[n & r.w_mask] = r.head[r.ins_h], r.head[r.ins_h] = n, n++, --i;);
					r.strstart = n, r.lookahead = x - 1, j(r)
				}
				return r.strstart += r.lookahead, r.block_start = r.strstart, r.insert = r.lookahead, r.lookahead = 0, r.match_length = r.prev_length = x - 1, r.match_available = 0, e.next_in = o, e.input = h, e.avail_in = a, r.wrap = s, m
			}, r.deflateInfo = "pako deflate (from Nodeca project)"
		}, {
			"../utils/common": 41,
			"./adler32": 43,
			"./crc32": 45,
			"./messages": 51,
			"./trees": 52
		}],
		47: [function(e, t, r) {
			"use strict";
			t.exports = function() {
				this.text = 0, this.time = 0, this.xflags = 0, this.os = 0, this.extra = null, this.extra_len = 0, this.name = "", this.comment = "", this.hcrc = 0, this.done = !1
			}
		}, {}],
		48: [function(e, t, r) {
			"use strict";
			t.exports = function(e, t) {
				var r, n, i, s, a, o, h, u, l, f, c, d, p, m, _, g, b, v, y, w, k, x, S, z, C;
				r = e.state, n = e.next_in, z = e.input, i = n + (e.avail_in - 5), s = e.next_out, C = e.output, a = s - (t - e.avail_out), o = s + (e.avail_out - 257), h = r.dmax, u = r.wsize, l = r.whave, f = r.wnext, c = r.window, d = r.hold, p = r.bits, m = r.lencode, _ = r.distcode, g = (1 << r.lenbits) - 1, b = (1 << r.distbits) - 1;
				e: do {
					p < 15 && (d += z[n++] << p, p += 8, d += z[n++] << p, p += 8), v = m[d & g];
					t: for (;;) {
						if (d >>>= y = v >>> 24, p -= y, 0 === (y = v >>> 16 & 255)) C[s++] = 65535 & v;
						else {
							if (!(16 & y)) {
								if (0 == (64 & y)) {
									v = m[(65535 & v) + (d & (1 << y) - 1)];
									continue t
								}
								if (32 & y) {
									r.mode = 12;
									break e
								}
								e.msg = "invalid literal/length code", r.mode = 30;
								break e
							}
							w = 65535 & v, (y &= 15) && (p < y && (d += z[n++] << p, p += 8), w += d & (1 << y) - 1, d >>>= y, p -= y), p < 15 && (d += z[n++] << p, p += 8, d += z[n++] << p, p += 8), v = _[d & b];
							r: for (;;) {
								if (d >>>= y = v >>> 24, p -= y, !(16 & (y = v >>> 16 & 255))) {
									if (0 == (64 & y)) {
										v = _[(65535 & v) + (d & (1 << y) - 1)];
										continue r
									}
									e.msg = "invalid distance code", r.mode = 30;
									break e
								}
								if (k = 65535 & v, p < (y &= 15) && (d += z[n++] << p, (p += 8) < y && (d += z[n++] << p, p += 8)), h < (k += d & (1 << y) - 1)) {
									e.msg = "invalid distance too far back", r.mode = 30;
									break e
								}
								if (d >>>= y, p -= y, (y = s - a) < k) {
									if (l < (y = k - y) && r.sane) {
										e.msg = "invalid distance too far back", r.mode = 30;
										break e
									}
									if (S = c, (x = 0) === f) {
										if (x += u - y, y < w) {
											for (w -= y; C[s++] = c[x++], --y;);
											x = s - k, S = C
										}
									} else if (f < y) {
										if (x += u + f - y, (y -= f) < w) {
											for (w -= y; C[s++] = c[x++], --y;);
											if (x = 0, f < w) {
												for (w -= y = f; C[s++] = c[x++], --y;);
												x = s - k, S = C
											}
										}
									} else if (x += f - y, y < w) {
										for (w -= y; C[s++] = c[x++], --y;);
										x = s - k, S = C
									}
									for (; 2 < w;) C[s++] = S[x++], C[s++] = S[x++], C[s++] = S[x++], w -= 3;
									w && (C[s++] = S[x++], 1 < w && (C[s++] = S[x++]))
								} else {
									for (x = s - k; C[s++] = C[x++], C[s++] = C[x++], C[s++] = C[x++], 2 < (w -= 3););
									w && (C[s++] = C[x++], 1 < w && (C[s++] = C[x++]))
								}
								break
							}
						}
						break
					}
				} while (n < i && s < o);
				n -= w = p >> 3, d &= (1 << (p -= w << 3)) - 1, e.next_in = n, e.next_out = s, e.avail_in = n < i ? i - n + 5 : 5 - (n - i), e.avail_out = s < o ? o - s + 257 : 257 - (s - o), r.hold = d, r.bits = p
			}
		}, {}],
		49: [function(e, t, r) {
			"use strict";
			var I = e("../utils/common"),
				O = e("./adler32"),
				B = e("./crc32"),
				R = e("./inffast"),
				T = e("./inftrees"),
				D = 1,
				F = 2,
				N = 0,
				U = -2,
				P = 1,
				n = 852,
				i = 592;

			function L(e) {
				return (e >>> 24 & 255) + (e >>> 8 & 65280) + ((65280 & e) << 8) + ((255 & e) << 24)
			}

			function s() {
				this.mode = 0, this.last = !1, this.wrap = 0, this.havedict = !1, this.flags = 0, this.dmax = 0, this.check = 0, this.total = 0, this.head = null, this.wbits = 0, this.wsize = 0, this.whave = 0, this.wnext = 0, this.window = null, this.hold = 0, this.bits = 0, this.length = 0, this.offset = 0, this.extra = 0, this.lencode = null, this.distcode = null, this.lenbits = 0, this.distbits = 0, this.ncode = 0, this.nlen = 0, this.ndist = 0, this.have = 0, this.next = null, this.lens = new I.Buf16(320), this.work = new I.Buf16(288), this.lendyn = null, this.distdyn = null, this.sane = 0, this.back = 0, this.was = 0
			}

			function a(e) {
				var t;
				return e && e.state ? (t = e.state, e.total_in = e.total_out = t.total = 0, e.msg = "", t.wrap && (e.adler = 1 & t.wrap), t.mode = P, t.last = 0, t.havedict = 0, t.dmax = 32768, t.head = null, t.hold = 0, t.bits = 0, t.lencode = t.lendyn = new I.Buf32(n), t.distcode = t.distdyn = new I.Buf32(i), t.sane = 1, t.back = -1, N) : U
			}

			function o(e) {
				var t;
				return e && e.state ? ((t = e.state)
					.wsize = 0, t.whave = 0, t.wnext = 0, a(e)) : U
			}

			function h(e, t) {
				var r, n;
				return e && e.state ? (n = e.state, t < 0 ? (r = 0, t = -t) : (r = 1 + (t >> 4), t < 48 && (t &= 15)), t && (t < 8 || 15 < t) ? U : (null !== n.window && n.wbits !== t && (n.window = null), n.wrap = r, n.wbits = t, o(e))) : U
			}

			function u(e, t) {
				var r, n;
				return e ? (n = new s, (e.state = n)
					.window = null, (r = h(e, t)) !== N && (e.state = null), r) : U
			}
			var l, f, c = !0;

			function j(e) {
				if (c) {
					var t;
					for (l = new I.Buf32(512), f = new I.Buf32(32), t = 0; t < 144;) e.lens[t++] = 8;
					for (; t < 256;) e.lens[t++] = 9;
					for (; t < 280;) e.lens[t++] = 7;
					for (; t < 288;) e.lens[t++] = 8;
					for (T(D, e.lens, 0, 288, l, 0, e.work, {
						bits: 9
					}), t = 0; t < 32;) e.lens[t++] = 5;
					T(F, e.lens, 0, 32, f, 0, e.work, {
						bits: 5
					}), c = !1
				}
				e.lencode = l, e.lenbits = 9, e.distcode = f, e.distbits = 5
			}

			function Z(e, t, r, n) {
				var i, s = e.state;
				return null === s.window && (s.wsize = 1 << s.wbits, s.wnext = 0, s.whave = 0, s.window = new I.Buf8(s.wsize)), n >= s.wsize ? (I.arraySet(s.window, t, r - s.wsize, s.wsize, 0), s.wnext = 0, s.whave = s.wsize) : (n < (i = s.wsize - s.wnext) && (i = n), I.arraySet(s.window, t, r - n, i, s.wnext), (n -= i) ? (I.arraySet(s.window, t, r - n, n, 0), s.wnext = n, s.whave = s.wsize) : (s.wnext += i, s.wnext === s.wsize && (s.wnext = 0), s.whave < s.wsize && (s.whave += i))), 0
			}
			r.inflateReset = o, r.inflateReset2 = h, r.inflateResetKeep = a, r.inflateInit = function(e) {
				return u(e, 15)
			}, r.inflateInit2 = u, r.inflate = function(e, t) {
				var r, n, i, s, a, o, h, u, l, f, c, d, p, m, _, g, b, v, y, w, k, x, S, z, C = 0,
					E = new I.Buf8(4),
					A = [16, 17, 18, 0, 8, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 14, 1, 15];
				if (!e || !e.state || !e.output || !e.input && 0 !== e.avail_in) return U;
				12 === (r = e.state)
					.mode && (r.mode = 13), a = e.next_out, i = e.output, h = e.avail_out, s = e.next_in, n = e.input, o = e.avail_in, u = r.hold, l = r.bits, f = o, c = h, x = N;
				e: for (;;) switch (r.mode) {
					case P:
						if (0 === r.wrap) {
							r.mode = 13;
							break
						}
						for (; l < 16;) {
							if (0 === o) break e;
							o--, u += n[s++] << l, l += 8
						}
						if (2 & r.wrap && 35615 === u) {
							E[r.check = 0] = 255 & u, E[1] = u >>> 8 & 255, r.check = B(r.check, E, 2, 0), l = u = 0, r.mode = 2;
							break
						}
						if (r.flags = 0, r.head && (r.head.done = !1), !(1 & r.wrap) || (((255 & u) << 8) + (u >> 8)) % 31) {
							e.msg = "incorrect header check", r.mode = 30;
							break
						}
						if (8 != (15 & u)) {
							e.msg = "unknown compression method", r.mode = 30;
							break
						}
						if (l -= 4, k = 8 + (15 & (u >>>= 4)), 0 === r.wbits) r.wbits = k;
						else if (k > r.wbits) {
							e.msg = "invalid window size", r.mode = 30;
							break
						}
						r.dmax = 1 << k, e.adler = r.check = 1, r.mode = 512 & u ? 10 : 12, l = u = 0;
						break;
					case 2:
						for (; l < 16;) {
							if (0 === o) break e;
							o--, u += n[s++] << l, l += 8
						}
						if (r.flags = u, 8 != (255 & r.flags)) {
							e.msg = "unknown compression method", r.mode = 30;
							break
						}
						if (57344 & r.flags) {
							e.msg = "unknown header flags set", r.mode = 30;
							break
						}
						r.head && (r.head.text = u >> 8 & 1), 512 & r.flags && (E[0] = 255 & u, E[1] = u >>> 8 & 255, r.check = B(r.check, E, 2, 0)), l = u = 0, r.mode = 3;
					case 3:
						for (; l < 32;) {
							if (0 === o) break e;
							o--, u += n[s++] << l, l += 8
						}
						r.head && (r.head.time = u), 512 & r.flags && (E[0] = 255 & u, E[1] = u >>> 8 & 255, E[2] = u >>> 16 & 255, E[3] = u >>> 24 & 255, r.check = B(r.check, E, 4, 0)), l = u = 0, r.mode = 4;
					case 4:
						for (; l < 16;) {
							if (0 === o) break e;
							o--, u += n[s++] << l, l += 8
						}
						r.head && (r.head.xflags = 255 & u, r.head.os = u >> 8), 512 & r.flags && (E[0] = 255 & u, E[1] = u >>> 8 & 255, r.check = B(r.check, E, 2, 0)), l = u = 0, r.mode = 5;
					case 5:
						if (1024 & r.flags) {
							for (; l < 16;) {
								if (0 === o) break e;
								o--, u += n[s++] << l, l += 8
							}
							r.length = u, r.head && (r.head.extra_len = u), 512 & r.flags && (E[0] = 255 & u, E[1] = u >>> 8 & 255, r.check = B(r.check, E, 2, 0)), l = u = 0
						} else r.head && (r.head.extra = null);
						r.mode = 6;
					case 6:
						if (1024 & r.flags && (o < (d = r.length) && (d = o), d && (r.head && (k = r.head.extra_len - r.length, r.head.extra || (r.head.extra = new Array(r.head.extra_len)), I.arraySet(r.head.extra, n, s, d, k)), 512 & r.flags && (r.check = B(r.check, n, d, s)), o -= d, s += d, r.length -= d), r.length)) break e;
						r.length = 0, r.mode = 7;
					case 7:
						if (2048 & r.flags) {
							if (0 === o) break e;
							for (d = 0; k = n[s + d++], r.head && k && r.length < 65536 && (r.head.name += String.fromCharCode(k)), k && d < o;);
							if (512 & r.flags && (r.check = B(r.check, n, d, s)), o -= d, s += d, k) break e
						} else r.head && (r.head.name = null);
						r.length = 0, r.mode = 8;
					case 8:
						if (4096 & r.flags) {
							if (0 === o) break e;
							for (d = 0; k = n[s + d++], r.head && k && r.length < 65536 && (r.head.comment += String.fromCharCode(k)), k && d < o;);
							if (512 & r.flags && (r.check = B(r.check, n, d, s)), o -= d, s += d, k) break e
						} else r.head && (r.head.comment = null);
						r.mode = 9;
					case 9:
						if (512 & r.flags) {
							for (; l < 16;) {
								if (0 === o) break e;
								o--, u += n[s++] << l, l += 8
							}
							if (u !== (65535 & r.check)) {
								e.msg = "header crc mismatch", r.mode = 30;
								break
							}
							l = u = 0
						}
						r.head && (r.head.hcrc = r.flags >> 9 & 1, r.head.done = !0), e.adler = r.check = 0, r.mode = 12;
						break;
					case 10:
						for (; l < 32;) {
							if (0 === o) break e;
							o--, u += n[s++] << l, l += 8
						}
						e.adler = r.check = L(u), l = u = 0, r.mode = 11;
					case 11:
						if (0 === r.havedict) return e.next_out = a, e.avail_out = h, e.next_in = s, e.avail_in = o, r.hold = u, r.bits = l, 2;
						e.adler = r.check = 1, r.mode = 12;
					case 12:
						if (5 === t || 6 === t) break e;
					case 13:
						if (r.last) {
							u >>>= 7 & l, l -= 7 & l, r.mode = 27;
							break
						}
						for (; l < 3;) {
							if (0 === o) break e;
							o--, u += n[s++] << l, l += 8
						}
						switch (r.last = 1 & u, l -= 1, 3 & (u >>>= 1)) {
							case 0:
								r.mode = 14;
								break;
							case 1:
								if (j(r), r.mode = 20, 6 !== t) break;
								u >>>= 2, l -= 2;
								break e;
							case 2:
								r.mode = 17;
								break;
							case 3:
								e.msg = "invalid block type", r.mode = 30
						}
						u >>>= 2, l -= 2;
						break;
					case 14:
						for (u >>>= 7 & l, l -= 7 & l; l < 32;) {
							if (0 === o) break e;
							o--, u += n[s++] << l, l += 8
						}
						if ((65535 & u) != (u >>> 16 ^ 65535)) {
							e.msg = "invalid stored block lengths", r.mode = 30;
							break
						}
						if (r.length = 65535 & u, l = u = 0, r.mode = 15, 6 === t) break e;
					case 15:
						r.mode = 16;
					case 16:
						if (d = r.length) {
							if (o < d && (d = o), h < d && (d = h), 0 === d) break e;
							I.arraySet(i, n, s, d, a), o -= d, s += d, h -= d, a += d, r.length -= d;
							break
						}
						r.mode = 12;
						break;
					case 17:
						for (; l < 14;) {
							if (0 === o) break e;
							o--, u += n[s++] << l, l += 8
						}
						if (r.nlen = 257 + (31 & u), u >>>= 5, l -= 5, r.ndist = 1 + (31 & u), u >>>= 5, l -= 5, r.ncode = 4 + (15 & u), u >>>= 4, l -= 4, 286 < r.nlen || 30 < r.ndist) {
							e.msg = "too many length or distance symbols", r.mode = 30;
							break
						}
						r.have = 0, r.mode = 18;
					case 18:
						for (; r.have < r.ncode;) {
							for (; l < 3;) {
								if (0 === o) break e;
								o--, u += n[s++] << l, l += 8
							}
							r.lens[A[r.have++]] = 7 & u, u >>>= 3, l -= 3
						}
						for (; r.have < 19;) r.lens[A[r.have++]] = 0;
						if (r.lencode = r.lendyn, r.lenbits = 7, S = {
							bits: r.lenbits
						}, x = T(0, r.lens, 0, 19, r.lencode, 0, r.work, S), r.lenbits = S.bits, x) {
							e.msg = "invalid code lengths set", r.mode = 30;
							break
						}
						r.have = 0, r.mode = 19;
					case 19:
						for (; r.have < r.nlen + r.ndist;) {
							for (; g = (C = r.lencode[u & (1 << r.lenbits) - 1]) >>> 16 & 255, b = 65535 & C, !((_ = C >>> 24) <= l);) {
								if (0 === o) break e;
								o--, u += n[s++] << l, l += 8
							}
							if (b < 16) u >>>= _, l -= _, r.lens[r.have++] = b;
							else {
								if (16 === b) {
									for (z = _ + 2; l < z;) {
										if (0 === o) break e;
										o--, u += n[s++] << l, l += 8
									}
									if (u >>>= _, l -= _, 0 === r.have) {
										e.msg = "invalid bit length repeat", r.mode = 30;
										break
									}
									k = r.lens[r.have - 1], d = 3 + (3 & u), u >>>= 2, l -= 2
								} else if (17 === b) {
									for (z = _ + 3; l < z;) {
										if (0 === o) break e;
										o--, u += n[s++] << l, l += 8
									}
									l -= _, k = 0, d = 3 + (7 & (u >>>= _)), u >>>= 3, l -= 3
								} else {
									for (z = _ + 7; l < z;) {
										if (0 === o) break e;
										o--, u += n[s++] << l, l += 8
									}
									l -= _, k = 0, d = 11 + (127 & (u >>>= _)), u >>>= 7, l -= 7
								}
								if (r.have + d > r.nlen + r.ndist) {
									e.msg = "invalid bit length repeat", r.mode = 30;
									break
								}
								for (; d--;) r.lens[r.have++] = k
							}
						}
						if (30 === r.mode) break;
						if (0 === r.lens[256]) {
							e.msg = "invalid code -- missing end-of-block", r.mode = 30;
							break
						}
						if (r.lenbits = 9, S = {
							bits: r.lenbits
						}, x = T(D, r.lens, 0, r.nlen, r.lencode, 0, r.work, S), r.lenbits = S.bits, x) {
							e.msg = "invalid literal/lengths set", r.mode = 30;
							break
						}
						if (r.distbits = 6, r.distcode = r.distdyn, S = {
							bits: r.distbits
						}, x = T(F, r.lens, r.nlen, r.ndist, r.distcode, 0, r.work, S), r.distbits = S.bits, x) {
							e.msg = "invalid distances set", r.mode = 30;
							break
						}
						if (r.mode = 20, 6 === t) break e;
					case 20:
						r.mode = 21;
					case 21:
						if (6 <= o && 258 <= h) {
							e.next_out = a, e.avail_out = h, e.next_in = s, e.avail_in = o, r.hold = u, r.bits = l, R(e, c), a = e.next_out, i = e.output, h = e.avail_out, s = e.next_in, n = e.input, o = e.avail_in, u = r.hold, l = r.bits, 12 === r.mode && (r.back = -1);
							break
						}
						for (r.back = 0; g = (C = r.lencode[u & (1 << r.lenbits) - 1]) >>> 16 & 255, b = 65535 & C, !((_ = C >>> 24) <= l);) {
							if (0 === o) break e;
							o--, u += n[s++] << l, l += 8
						}
						if (g && 0 == (240 & g)) {
							for (v = _, y = g, w = b; g = (C = r.lencode[w + ((u & (1 << v + y) - 1) >> v)]) >>> 16 & 255, b = 65535 & C, !(v + (_ = C >>> 24) <= l);) {
								if (0 === o) break e;
								o--, u += n[s++] << l, l += 8
							}
							u >>>= v, l -= v, r.back += v
						}
						if (u >>>= _, l -= _, r.back += _, r.length = b, 0 === g) {
							r.mode = 26;
							break
						}
						if (32 & g) {
							r.back = -1, r.mode = 12;
							break
						}
						if (64 & g) {
							e.msg = "invalid literal/length code", r.mode = 30;
							break
						}
						r.extra = 15 & g, r.mode = 22;
					case 22:
						if (r.extra) {
							for (z = r.extra; l < z;) {
								if (0 === o) break e;
								o--, u += n[s++] << l, l += 8
							}
							r.length += u & (1 << r.extra) - 1, u >>>= r.extra, l -= r.extra, r.back += r.extra
						}
						r.was = r.length, r.mode = 23;
					case 23:
						for (; g = (C = r.distcode[u & (1 << r.distbits) - 1]) >>> 16 & 255, b = 65535 & C, !((_ = C >>> 24) <= l);) {
							if (0 === o) break e;
							o--, u += n[s++] << l, l += 8
						}
						if (0 == (240 & g)) {
							for (v = _, y = g, w = b; g = (C = r.distcode[w + ((u & (1 << v + y) - 1) >> v)]) >>> 16 & 255, b = 65535 & C, !(v + (_ = C >>> 24) <= l);) {
								if (0 === o) break e;
								o--, u += n[s++] << l, l += 8
							}
							u >>>= v, l -= v, r.back += v
						}
						if (u >>>= _, l -= _, r.back += _, 64 & g) {
							e.msg = "invalid distance code", r.mode = 30;
							break
						}
						r.offset = b, r.extra = 15 & g, r.mode = 24;
					case 24:
						if (r.extra) {
							for (z = r.extra; l < z;) {
								if (0 === o) break e;
								o--, u += n[s++] << l, l += 8
							}
							r.offset += u & (1 << r.extra) - 1, u >>>= r.extra, l -= r.extra, r.back += r.extra
						}
						if (r.offset > r.dmax) {
							e.msg = "invalid distance too far back", r.mode = 30;
							break
						}
						r.mode = 25;
					case 25:
						if (0 === h) break e;
						if (d = c - h, r.offset > d) {
							if ((d = r.offset - d) > r.whave && r.sane) {
								e.msg = "invalid distance too far back", r.mode = 30;
								break
							}
							p = d > r.wnext ? (d -= r.wnext, r.wsize - d) : r.wnext - d, d > r.length && (d = r.length), m = r.window
						} else m = i, p = a - r.offset, d = r.length;
						for (h < d && (d = h), h -= d, r.length -= d; i[a++] = m[p++], --d;);
						0 === r.length && (r.mode = 21);
						break;
					case 26:
						if (0 === h) break e;
						i[a++] = r.length, h--, r.mode = 21;
						break;
					case 27:
						if (r.wrap) {
							for (; l < 32;) {
								if (0 === o) break e;
								o--, u |= n[s++] << l, l += 8
							}
							if (c -= h, e.total_out += c, r.total += c, c && (e.adler = r.check = r.flags ? B(r.check, i, c, a - c) : O(r.check, i, c, a - c)), c = h, (r.flags ? u : L(u)) !== r.check) {
								e.msg = "incorrect data check", r.mode = 30;
								break
							}
							l = u = 0
						}
						r.mode = 28;
					case 28:
						if (r.wrap && r.flags) {
							for (; l < 32;) {
								if (0 === o) break e;
								o--, u += n[s++] << l, l += 8
							}
							if (u !== (4294967295 & r.total)) {
								e.msg = "incorrect length check", r.mode = 30;
								break
							}
							l = u = 0
						}
						r.mode = 29;
					case 29:
						x = 1;
						break e;
					case 30:
						x = -3;
						break e;
					case 31:
						return -4;
					case 32:
					default:
						return U
				}
				return e.next_out = a, e.avail_out = h, e.next_in = s, e.avail_in = o, r.hold = u, r.bits = l, (r.wsize || c !== e.avail_out && r.mode < 30 && (r.mode < 27 || 4 !== t)) && Z(e, e.output, e.next_out, c - e.avail_out) ? (r.mode = 31, -4) : (f -= e.avail_in, c -= e.avail_out, e.total_in += f, e.total_out += c, r.total += c, r.wrap && c && (e.adler = r.check = r.flags ? B(r.check, i, c, e.next_out - c) : O(r.check, i, c, e.next_out - c)), e.data_type = r.bits + (r.last ? 64 : 0) + (12 === r.mode ? 128 : 0) + (20 === r.mode || 15 === r.mode ? 256 : 0), (0 == f && 0 === c || 4 === t) && x === N && (x = -5), x)
			}, r.inflateEnd = function(e) {
				if (!e || !e.state) return U;
				var t = e.state;
				return t.window && (t.window = null), e.state = null, N
			}, r.inflateGetHeader = function(e, t) {
				var r;
				return e && e.state ? 0 == (2 & (r = e.state)
					.wrap) ? U : ((r.head = t)
					.done = !1, N) : U
			}, r.inflateSetDictionary = function(e, t) {
				var r, n = t.length;
				return e && e.state ? 0 !== (r = e.state)
					.wrap && 11 !== r.mode ? U : 11 === r.mode && O(1, t, n, 0) !== r.check ? -3 : Z(e, t, n, n) ? (r.mode = 31, -4) : (r.havedict = 1, N) : U
			}, r.inflateInfo = "pako inflate (from Nodeca project)"
		}, {
			"../utils/common": 41,
			"./adler32": 43,
			"./crc32": 45,
			"./inffast": 48,
			"./inftrees": 50
		}],
		50: [function(e, t, r) {
			"use strict";
			var D = e("../utils/common"),
				F = [3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 15, 17, 19, 23, 27, 31, 35, 43, 51, 59, 67, 83, 99, 115, 131, 163, 195, 227, 258, 0, 0],
				N = [16, 16, 16, 16, 16, 16, 16, 16, 17, 17, 17, 17, 18, 18, 18, 18, 19, 19, 19, 19, 20, 20, 20, 20, 21, 21, 21, 21, 16, 72, 78],
				U = [1, 2, 3, 4, 5, 7, 9, 13, 17, 25, 33, 49, 65, 97, 129, 193, 257, 385, 513, 769, 1025, 1537, 2049, 3073, 4097, 6145, 8193, 12289, 16385, 24577, 0, 0],
				P = [16, 16, 16, 16, 17, 17, 18, 18, 19, 19, 20, 20, 21, 21, 22, 22, 23, 23, 24, 24, 25, 25, 26, 26, 27, 27, 28, 28, 29, 29, 64, 64];
			t.exports = function(e, t, r, n, i, s, a, o) {
				var h, u, l, f, c, d, p, m, _, g = o.bits,
					b = 0,
					v = 0,
					y = 0,
					w = 0,
					k = 0,
					x = 0,
					S = 0,
					z = 0,
					C = 0,
					E = 0,
					A = null,
					I = 0,
					O = new D.Buf16(16),
					B = new D.Buf16(16),
					R = null,
					T = 0;
				for (b = 0; b <= 15; b++) O[b] = 0;
				for (v = 0; v < n; v++) O[t[r + v]]++;
				for (k = g, w = 15; 1 <= w && 0 === O[w]; w--);
				if (w < k && (k = w), 0 === w) return i[s++] = 20971520, i[s++] = 20971520, o.bits = 1, 0;
				for (y = 1; y < w && 0 === O[y]; y++);
				for (k < y && (k = y), b = z = 1; b <= 15; b++)
					if (z <<= 1, (z -= O[b]) < 0) return -1;
				if (0 < z && (0 === e || 1 !== w)) return -1;
				for (B[1] = 0, b = 1; b < 15; b++) B[b + 1] = B[b] + O[b];
				for (v = 0; v < n; v++) 0 !== t[r + v] && (a[B[t[r + v]]++] = v);
				if (d = 0 === e ? (A = R = a, 19) : 1 === e ? (A = F, I -= 257, R = N, T -= 257, 256) : (A = U, R = P, -1), b = y, c = s, S = v = E = 0, l = -1, f = (C = 1 << (x = k)) - 1, 1 === e && 852 < C || 2 === e && 592 < C) return 1;
				for (;;) {
					for (p = b - S, _ = a[v] < d ? (m = 0, a[v]) : a[v] > d ? (m = R[T + a[v]], A[I + a[v]]) : (m = 96, 0), h = 1 << b - S, y = u = 1 << x; i[c + (E >> S) + (u -= h)] = p << 24 | m << 16 | _ | 0, 0 !== u;);
					for (h = 1 << b - 1; E & h;) h >>= 1;
					if (0 !== h ? (E &= h - 1, E += h) : E = 0, v++, 0 == --O[b]) {
						if (b === w) break;
						b = t[r + a[v]]
					}
					if (k < b && (E & f) !== l) {
						for (0 === S && (S = k), c += y, z = 1 << (x = b - S); x + S < w && !((z -= O[x + S]) <= 0);) x++, z <<= 1;
						if (C += 1 << x, 1 === e && 852 < C || 2 === e && 592 < C) return 1;
						i[l = E & f] = k << 24 | x << 16 | c - s | 0
					}
				}
				return 0 !== E && (i[c + E] = b - S << 24 | 64 << 16 | 0), o.bits = k, 0
			}
		}, {
			"../utils/common": 41
		}],
		51: [function(e, t, r) {
			"use strict";
			t.exports = {
				2: "need dictionary",
				1: "stream end",
				0: "",
				"-1": "file error",
				"-2": "stream error",
				"-3": "data error",
				"-4": "insufficient memory",
				"-5": "buffer error",
				"-6": "incompatible version"
			}
		}, {}],
		52: [function(e, t, r) {
			"use strict";
			var i = e("../utils/common"),
				o = 0,
				h = 1;

			function n(e) {
				for (var t = e.length; 0 <= --t;) e[t] = 0
			}
			var s = 0,
				a = 29,
				u = 256,
				l = u + 1 + a,
				f = 30,
				c = 19,
				_ = 2 * l + 1,
				g = 15,
				d = 16,
				p = 7,
				m = 256,
				b = 16,
				v = 17,
				y = 18,
				w = [0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 0],
				k = [0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13],
				x = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 3, 7],
				S = [16, 17, 18, 0, 8, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 14, 1, 15],
				z = new Array(2 * (l + 2));
			n(z);
			var C = new Array(2 * f);
			n(C);
			var E = new Array(512);
			n(E);
			var A = new Array(256);
			n(A);
			var I = new Array(a);
			n(I);
			var O, B, R, T = new Array(f);

			function D(e, t, r, n, i) {
				this.static_tree = e, this.extra_bits = t, this.extra_base = r, this.elems = n, this.max_length = i, this.has_stree = e && e.length
			}

			function F(e, t) {
				this.dyn_tree = e, this.max_code = 0, this.stat_desc = t
			}

			function N(e) {
				return e < 256 ? E[e] : E[256 + (e >>> 7)]
			}

			function U(e, t) {
				e.pending_buf[e.pending++] = 255 & t, e.pending_buf[e.pending++] = t >>> 8 & 255
			}

			function P(e, t, r) {
				e.bi_valid > d - r ? (e.bi_buf |= t << e.bi_valid & 65535, U(e, e.bi_buf), e.bi_buf = t >> d - e.bi_valid, e.bi_valid += r - d) : (e.bi_buf |= t << e.bi_valid & 65535, e.bi_valid += r)
			}

			function L(e, t, r) {
				P(e, r[2 * t], r[2 * t + 1])
			}

			function j(e, t) {
				for (var r = 0; r |= 1 & e, e >>>= 1, r <<= 1, 0 < --t;);
				return r >>> 1
			}

			function Z(e, t, r) {
				var n, i, s = new Array(g + 1),
					a = 0;
				for (n = 1; n <= g; n++) s[n] = a = a + r[n - 1] << 1;
				for (i = 0; i <= t; i++) {
					var o = e[2 * i + 1];
					0 !== o && (e[2 * i] = j(s[o]++, o))
				}
			}

			function W(e) {
				var t;
				for (t = 0; t < l; t++) e.dyn_ltree[2 * t] = 0;
				for (t = 0; t < f; t++) e.dyn_dtree[2 * t] = 0;
				for (t = 0; t < c; t++) e.bl_tree[2 * t] = 0;
				e.dyn_ltree[2 * m] = 1, e.opt_len = e.static_len = 0, e.last_lit = e.matches = 0
			}

			function M(e) {
				8 < e.bi_valid ? U(e, e.bi_buf) : 0 < e.bi_valid && (e.pending_buf[e.pending++] = e.bi_buf), e.bi_buf = 0, e.bi_valid = 0
			}

			function H(e, t, r, n) {
				var i = 2 * t,
					s = 2 * r;
				return e[i] < e[s] || e[i] === e[s] && n[t] <= n[r]
			}

			function G(e, t, r) {
				for (var n = e.heap[r], i = r << 1; i <= e.heap_len && (i < e.heap_len && H(t, e.heap[i + 1], e.heap[i], e.depth) && i++, !H(t, n, e.heap[i], e.depth));) e.heap[r] = e.heap[i], r = i, i <<= 1;
				e.heap[r] = n
			}

			function K(e, t, r) {
				var n, i, s, a, o = 0;
				if (0 !== e.last_lit)
					for (; n = e.pending_buf[e.d_buf + 2 * o] << 8 | e.pending_buf[e.d_buf + 2 * o + 1], i = e.pending_buf[e.l_buf + o], o++, 0 === n ? L(e, i, t) : (L(e, (s = A[i]) + u + 1, t), 0 !== (a = w[s]) && P(e, i -= I[s], a), L(e, s = N(--n), r), 0 !== (a = k[s]) && P(e, n -= T[s], a)), o < e.last_lit;);
				L(e, m, t)
			}

			function Y(e, t) {
				var r, n, i, s = t.dyn_tree,
					a = t.stat_desc.static_tree,
					o = t.stat_desc.has_stree,
					h = t.stat_desc.elems,
					u = -1;
				for (e.heap_len = 0, e.heap_max = _, r = 0; r < h; r++) 0 !== s[2 * r] ? (e.heap[++e.heap_len] = u = r, e.depth[r] = 0) : s[2 * r + 1] = 0;
				for (; e.heap_len < 2;) s[2 * (i = e.heap[++e.heap_len] = u < 2 ? ++u : 0)] = 1, e.depth[i] = 0, e.opt_len--, o && (e.static_len -= a[2 * i + 1]);
				for (t.max_code = u, r = e.heap_len >> 1; 1 <= r; r--) G(e, s, r);
				for (i = h; r = e.heap[1], e.heap[1] = e.heap[e.heap_len--], G(e, s, 1), n = e.heap[1], e.heap[--e.heap_max] = r, e.heap[--e.heap_max] = n, s[2 * i] = s[2 * r] + s[2 * n], e.depth[i] = (e.depth[r] >= e.depth[n] ? e.depth[r] : e.depth[n]) + 1, s[2 * r + 1] = s[2 * n + 1] = i, e.heap[1] = i++, G(e, s, 1), 2 <= e.heap_len;);
				e.heap[--e.heap_max] = e.heap[1],
					function(e, t) {
						var r, n, i, s, a, o, h = t.dyn_tree,
							u = t.max_code,
							l = t.stat_desc.static_tree,
							f = t.stat_desc.has_stree,
							c = t.stat_desc.extra_bits,
							d = t.stat_desc.extra_base,
							p = t.stat_desc.max_length,
							m = 0;
						for (s = 0; s <= g; s++) e.bl_count[s] = 0;
						for (h[2 * e.heap[e.heap_max] + 1] = 0, r = e.heap_max + 1; r < _; r++) p < (s = h[2 * h[2 * (n = e.heap[r]) + 1] + 1] + 1) && (s = p, m++), h[2 * n + 1] = s, u < n || (e.bl_count[s]++, a = 0, d <= n && (a = c[n - d]), o = h[2 * n], e.opt_len += o * (s + a), f && (e.static_len += o * (l[2 * n + 1] + a)));
						if (0 !== m) {
							do {
								for (s = p - 1; 0 === e.bl_count[s];) s--;
								e.bl_count[s]--, e.bl_count[s + 1] += 2, e.bl_count[p]--, m -= 2
							} while (0 < m);
							for (s = p; 0 !== s; s--)
								for (n = e.bl_count[s]; 0 !== n;) u < (i = e.heap[--r]) || (h[2 * i + 1] !== s && (e.opt_len += (s - h[2 * i + 1]) * h[2 * i], h[2 * i + 1] = s), n--)
						}
					}(e, t), Z(s, u, e.bl_count)
			}

			function X(e, t, r) {
				var n, i, s = -1,
					a = t[1],
					o = 0,
					h = 7,
					u = 4;
				for (0 === a && (h = 138, u = 3), t[2 * (r + 1) + 1] = 65535, n = 0; n <= r; n++) i = a, a = t[2 * (n + 1) + 1], ++o < h && i === a || (o < u ? e.bl_tree[2 * i] += o : 0 !== i ? (i !== s && e.bl_tree[2 * i]++, e.bl_tree[2 * b]++) : o <= 10 ? e.bl_tree[2 * v]++ : e.bl_tree[2 * y]++, s = i, u = (o = 0) === a ? (h = 138, 3) : i === a ? (h = 6, 3) : (h = 7, 4))
			}

			function V(e, t, r) {
				var n, i, s = -1,
					a = t[1],
					o = 0,
					h = 7,
					u = 4;
				for (0 === a && (h = 138, u = 3), n = 0; n <= r; n++)
					if (i = a, a = t[2 * (n + 1) + 1], !(++o < h && i === a)) {
						if (o < u)
							for (; L(e, i, e.bl_tree), 0 != --o;);
						else 0 !== i ? (i !== s && (L(e, i, e.bl_tree), o--), L(e, b, e.bl_tree), P(e, o - 3, 2)) : o <= 10 ? (L(e, v, e.bl_tree), P(e, o - 3, 3)) : (L(e, y, e.bl_tree), P(e, o - 11, 7));
						s = i, u = (o = 0) === a ? (h = 138, 3) : i === a ? (h = 6, 3) : (h = 7, 4)
					}
			}
			n(T);
			var q = !1;

			function J(e, t, r, n) {
				P(e, (s << 1) + (n ? 1 : 0), 3),
					function(e, t, r, n) {
						M(e), n && (U(e, r), U(e, ~r)), i.arraySet(e.pending_buf, e.window, t, r, e.pending), e.pending += r
					}(e, t, r, !0)
			}
			r._tr_init = function(e) {
				q || (function() {
					var e, t, r, n, i, s = new Array(g + 1);
					for (n = r = 0; n < a - 1; n++)
						for (I[n] = r, e = 0; e < 1 << w[n]; e++) A[r++] = n;
					for (A[r - 1] = n, n = i = 0; n < 16; n++)
						for (T[n] = i, e = 0; e < 1 << k[n]; e++) E[i++] = n;
					for (i >>= 7; n < f; n++)
						for (T[n] = i << 7, e = 0; e < 1 << k[n] - 7; e++) E[256 + i++] = n;
					for (t = 0; t <= g; t++) s[t] = 0;
					for (e = 0; e <= 143;) z[2 * e + 1] = 8, e++, s[8]++;
					for (; e <= 255;) z[2 * e + 1] = 9, e++, s[9]++;
					for (; e <= 279;) z[2 * e + 1] = 7, e++, s[7]++;
					for (; e <= 287;) z[2 * e + 1] = 8, e++, s[8]++;
					for (Z(z, l + 1, s), e = 0; e < f; e++) C[2 * e + 1] = 5, C[2 * e] = j(e, 5);
					O = new D(z, w, u + 1, l, g), B = new D(C, k, 0, f, g), R = new D(new Array(0), x, 0, c, p)
				}(), q = !0), e.l_desc = new F(e.dyn_ltree, O), e.d_desc = new F(e.dyn_dtree, B), e.bl_desc = new F(e.bl_tree, R), e.bi_buf = 0, e.bi_valid = 0, W(e)
			}, r._tr_stored_block = J, r._tr_flush_block = function(e, t, r, n) {
				var i, s, a = 0;
				0 < e.level ? (2 === e.strm.data_type && (e.strm.data_type = function(e) {
					var t, r = 4093624447;
					for (t = 0; t <= 31; t++, r >>>= 1)
						if (1 & r && 0 !== e.dyn_ltree[2 * t]) return o;
					if (0 !== e.dyn_ltree[18] || 0 !== e.dyn_ltree[20] || 0 !== e.dyn_ltree[26]) return h;
					for (t = 32; t < u; t++)
						if (0 !== e.dyn_ltree[2 * t]) return h;
					return o
				}(e)), Y(e, e.l_desc), Y(e, e.d_desc), a = function(e) {
					var t;
					for (X(e, e.dyn_ltree, e.l_desc.max_code), X(e, e.dyn_dtree, e.d_desc.max_code), Y(e, e.bl_desc), t = c - 1; 3 <= t && 0 === e.bl_tree[2 * S[t] + 1]; t--);
					return e.opt_len += 3 * (t + 1) + 5 + 5 + 4, t
				}(e), i = e.opt_len + 3 + 7 >>> 3, (s = e.static_len + 3 + 7 >>> 3) <= i && (i = s)) : i = s = r + 5, r + 4 <= i && -1 !== t ? J(e, t, r, n) : 4 === e.strategy || s === i ? (P(e, 2 + (n ? 1 : 0), 3), K(e, z, C)) : (P(e, 4 + (n ? 1 : 0), 3), function(e, t, r, n) {
					var i;
					for (P(e, t - 257, 5), P(e, r - 1, 5), P(e, n - 4, 4), i = 0; i < n; i++) P(e, e.bl_tree[2 * S[i] + 1], 3);
					V(e, e.dyn_ltree, t - 1), V(e, e.dyn_dtree, r - 1)
				}(e, e.l_desc.max_code + 1, e.d_desc.max_code + 1, a + 1), K(e, e.dyn_ltree, e.dyn_dtree)), W(e), n && M(e)
			}, r._tr_tally = function(e, t, r) {
				return e.pending_buf[e.d_buf + 2 * e.last_lit] = t >>> 8 & 255, e.pending_buf[e.d_buf + 2 * e.last_lit + 1] = 255 & t, e.pending_buf[e.l_buf + e.last_lit] = 255 & r, e.last_lit++, 0 === t ? e.dyn_ltree[2 * r]++ : (e.matches++, t--, e.dyn_ltree[2 * (A[r] + u + 1)]++, e.dyn_dtree[2 * N(t)]++), e.last_lit === e.lit_bufsize - 1
			}, r._tr_align = function(e) {
				P(e, 2, 3), L(e, m, z),
					function(e) {
						16 === e.bi_valid ? (U(e, e.bi_buf), e.bi_buf = 0, e.bi_valid = 0) : 8 <= e.bi_valid && (e.pending_buf[e.pending++] = 255 & e.bi_buf, e.bi_buf >>= 8, e.bi_valid -= 8)
					}(e)
			}
		}, {
			"../utils/common": 41
		}],
		53: [function(e, t, r) {
			"use strict";
			t.exports = function() {
				this.input = null, this.next_in = 0, this.avail_in = 0, this.total_in = 0, this.output = null, this.next_out = 0, this.avail_out = 0, this.total_out = 0, this.msg = "", this.state = null, this.data_type = 2, this.adler = 0
			}
		}, {}],
		54: [function(e, t, r) {
			(function(e) {
				! function(r, n) {
					"use strict";
					if (!r.setImmediate) {
						var i, s, t, a, o = 1,
							h = {},
							u = !1,
							l = r.document,
							e = Object.getPrototypeOf && Object.getPrototypeOf(r);
						e = e && e.setTimeout ? e : r, i = "[object process]" === {}.toString.call(r.process) ? function(e) {
							process.nextTick(function() {
								c(e)
							})
						} : function() {
							if (r.postMessage && !r.importScripts) {
								var e = !0,
									t = r.onmessage;
								return r.onmessage = function() {
									e = !1
								}, r.postMessage("", "*"), r.onmessage = t, e
							}
						}() ? (a = "setImmediate$" + Math.random() + "$", r.addEventListener ? r.addEventListener("message", d, !1) : r.attachEvent("onmessage", d), function(e) {
							r.postMessage(a + e, "*")
						}) : r.MessageChannel ? ((t = new MessageChannel)
							.port1.onmessage = function(e) {
								c(e.data)
							},
							function(e) {
								t.port2.postMessage(e)
							}) : l && "onreadystatechange" in l.createElement("script") ? (s = l.documentElement, function(e) {
							var t = l.createElement("script");
							t.onreadystatechange = function() {
								c(e), t.onreadystatechange = null, s.removeChild(t), t = null
							}, s.appendChild(t)
						}) : function(e) {
							setTimeout(c, 0, e)
						}, e.setImmediate = function(e) {
							"function" != typeof e && (e = new Function("" + e));
							for (var t = new Array(arguments.length - 1), r = 0; r < t.length; r++) t[r] = arguments[r + 1];
							var n = {
								callback: e,
								args: t
							};
							return h[o] = n, i(o), o++
						}, e.clearImmediate = f
					}

					function f(e) {
						delete h[e]
					}

					function c(e) {
						if (u) setTimeout(c, 0, e);
						else {
							var t = h[e];
							if (t) {
								u = !0;
								try {
									! function(e) {
										var t = e.callback,
											r = e.args;
										switch (r.length) {
											case 0:
												t();
												break;
											case 1:
												t(r[0]);
												break;
											case 2:
												t(r[0], r[1]);
												break;
											case 3:
												t(r[0], r[1], r[2]);
												break;
											default:
												t.apply(n, r)
										}
									}(t)
								} finally {
									f(e), u = !1
								}
							}
						}
					}

					function d(e) {
						e.source === r && "string" == typeof e.data && 0 === e.data.indexOf(a) && c(+e.data.slice(a.length))
					}
				}("undefined" == typeof self ? void 0 === e ? this : e : self)
			})
			.call(this, "undefined" != typeof global ? global : "undefined" != typeof self ? self : "undefined" != typeof window ? window : {})
		}, {}]
	}, {}, [10])(10)
});
}).call(this,require('_process'),typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {},require("buffer").Buffer,arguments[3],arguments[4],arguments[5],arguments[6],require("timers").setImmediate)

},{"_process":8,"buffer":3,"timers":9}],8:[function(require,module,exports){
// shim for using process in browser
var process = module.exports = {};

// cached from whatever global is present so that test runners that stub it
// don't break things.  But we need to wrap it in a try catch in case it is
// wrapped in strict mode code which doesn't define any globals.  It's inside a
// function because try/catches deoptimize in certain engines.

var cachedSetTimeout;
var cachedClearTimeout;

function defaultSetTimout() {
    throw new Error('setTimeout has not been defined');
}
function defaultClearTimeout () {
    throw new Error('clearTimeout has not been defined');
}
(function () {
    try {
        if (typeof setTimeout === 'function') {
            cachedSetTimeout = setTimeout;
        } else {
            cachedSetTimeout = defaultSetTimout;
        }
    } catch (e) {
        cachedSetTimeout = defaultSetTimout;
    }
    try {
        if (typeof clearTimeout === 'function') {
            cachedClearTimeout = clearTimeout;
        } else {
            cachedClearTimeout = defaultClearTimeout;
        }
    } catch (e) {
        cachedClearTimeout = defaultClearTimeout;
    }
} ())
function runTimeout(fun) {
    if (cachedSetTimeout === setTimeout) {
        //normal enviroments in sane situations
        return setTimeout(fun, 0);
    }
    // if setTimeout wasn't available but was latter defined
    if ((cachedSetTimeout === defaultSetTimout || !cachedSetTimeout) && setTimeout) {
        cachedSetTimeout = setTimeout;
        return setTimeout(fun, 0);
    }
    try {
        // when when somebody has screwed with setTimeout but no I.E. maddness
        return cachedSetTimeout(fun, 0);
    } catch(e){
        try {
            // When we are in I.E. but the script has been evaled so I.E. doesn't trust the global object when called normally
            return cachedSetTimeout.call(null, fun, 0);
        } catch(e){
            // same as above but when it's a version of I.E. that must have the global object for 'this', hopfully our context correct otherwise it will throw a global error
            return cachedSetTimeout.call(this, fun, 0);
        }
    }


}
function runClearTimeout(marker) {
    if (cachedClearTimeout === clearTimeout) {
        //normal enviroments in sane situations
        return clearTimeout(marker);
    }
    // if clearTimeout wasn't available but was latter defined
    if ((cachedClearTimeout === defaultClearTimeout || !cachedClearTimeout) && clearTimeout) {
        cachedClearTimeout = clearTimeout;
        return clearTimeout(marker);
    }
    try {
        // when when somebody has screwed with setTimeout but no I.E. maddness
        return cachedClearTimeout(marker);
    } catch (e){
        try {
            // When we are in I.E. but the script has been evaled so I.E. doesn't  trust the global object when called normally
            return cachedClearTimeout.call(null, marker);
        } catch (e){
            // same as above but when it's a version of I.E. that must have the global object for 'this', hopfully our context correct otherwise it will throw a global error.
            // Some versions of I.E. have different rules for clearTimeout vs setTimeout
            return cachedClearTimeout.call(this, marker);
        }
    }



}
var queue = [];
var draining = false;
var currentQueue;
var queueIndex = -1;

function cleanUpNextTick() {
    if (!draining || !currentQueue) {
        return;
    }
    draining = false;
    if (currentQueue.length) {
        queue = currentQueue.concat(queue);
    } else {
        queueIndex = -1;
    }
    if (queue.length) {
        drainQueue();
    }
}

function drainQueue() {
    if (draining) {
        return;
    }
    var timeout = runTimeout(cleanUpNextTick);
    draining = true;

    var len = queue.length;
    while(len) {
        currentQueue = queue;
        queue = [];
        while (++queueIndex < len) {
            if (currentQueue) {
                currentQueue[queueIndex].run();
            }
        }
        queueIndex = -1;
        len = queue.length;
    }
    currentQueue = null;
    draining = false;
    runClearTimeout(timeout);
}

process.nextTick = function (fun) {
    var args = new Array(arguments.length - 1);
    if (arguments.length > 1) {
        for (var i = 1; i < arguments.length; i++) {
            args[i - 1] = arguments[i];
        }
    }
    queue.push(new Item(fun, args));
    if (queue.length === 1 && !draining) {
        runTimeout(drainQueue);
    }
};

// v8 likes predictible objects
function Item(fun, array) {
    this.fun = fun;
    this.array = array;
}
Item.prototype.run = function () {
    this.fun.apply(null, this.array);
};
process.title = 'browser';
process.browser = true;
process.env = {};
process.argv = [];
process.version = ''; // empty string to avoid regexp issues
process.versions = {};

function noop() {}

process.on = noop;
process.addListener = noop;
process.once = noop;
process.off = noop;
process.removeListener = noop;
process.removeAllListeners = noop;
process.emit = noop;
process.prependListener = noop;
process.prependOnceListener = noop;

process.listeners = function (name) { return [] }

process.binding = function (name) {
    throw new Error('process.binding is not supported');
};

process.cwd = function () { return '/' };
process.chdir = function (dir) {
    throw new Error('process.chdir is not supported');
};
process.umask = function() { return 0; };

},{}],9:[function(require,module,exports){
(function (setImmediate,clearImmediate){
var nextTick = require('process/browser.js').nextTick;
var apply = Function.prototype.apply;
var slice = Array.prototype.slice;
var immediateIds = {};
var nextImmediateId = 0;

// DOM APIs, for completeness

exports.setTimeout = function() {
  return new Timeout(apply.call(setTimeout, window, arguments), clearTimeout);
};
exports.setInterval = function() {
  return new Timeout(apply.call(setInterval, window, arguments), clearInterval);
};
exports.clearTimeout =
exports.clearInterval = function(timeout) { timeout.close(); };

function Timeout(id, clearFn) {
  this._id = id;
  this._clearFn = clearFn;
}
Timeout.prototype.unref = Timeout.prototype.ref = function() {};
Timeout.prototype.close = function() {
  this._clearFn.call(window, this._id);
};

// Does not start the time, just sets up the members needed.
exports.enroll = function(item, msecs) {
  clearTimeout(item._idleTimeoutId);
  item._idleTimeout = msecs;
};

exports.unenroll = function(item) {
  clearTimeout(item._idleTimeoutId);
  item._idleTimeout = -1;
};

exports._unrefActive = exports.active = function(item) {
  clearTimeout(item._idleTimeoutId);

  var msecs = item._idleTimeout;
  if (msecs >= 0) {
    item._idleTimeoutId = setTimeout(function onTimeout() {
      if (item._onTimeout)
        item._onTimeout();
    }, msecs);
  }
};

// That's not how node.js implements it but the exposed api is the same.
exports.setImmediate = typeof setImmediate === "function" ? setImmediate : function(fn) {
  var id = nextImmediateId++;
  var args = arguments.length < 2 ? false : slice.call(arguments, 1);

  immediateIds[id] = true;

  nextTick(function onNextTick() {
    if (immediateIds[id]) {
      // fn.call() is faster so we optimize for the common use-case
      // @see http://jsperf.com/call-apply-segu
      if (args) {
        fn.apply(null, args);
      } else {
        fn.call(null);
      }
      // Prevent ids from leaking
      exports.clearImmediate(id);
    }
  });

  return id;
};

exports.clearImmediate = typeof clearImmediate === "function" ? clearImmediate : function(id) {
  delete immediateIds[id];
};
}).call(this,require("timers").setImmediate,require("timers").clearImmediate)

},{"process/browser.js":8,"timers":9}],10:[function(require,module,exports){
(function (Buffer){
/*! cpexcel.js (C) 2013-present SheetJS -- http://sheetjs.com */
/*jshint -W100 */
var cptable = {version:"1.15.0"};
cptable[437] = (function(){ var d = "\u0000\u0001\u0002\u0003\u0004\u0005\u0006\u0007\b\t\n\u000b\f\r\u000e\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~ÇüéâäàåçêëèïîìÄÅÉæÆôöòûùÿÖÜ¢£¥₧ƒáíóúñÑªº¿⌐¬½¼¡«»░▒▓│┤╡╢╖╕╣║╗╝╜╛┐└┴┬├─┼╞╟╚╔╩╦╠═╬╧╨╤╥╙╘╒╓╫╪┘┌█▄▌▐▀αßΓπΣσµτΦΘΩδ∞φε∩≡±≥≤⌠⌡÷≈°∙·√ⁿ²■ ", D = [], e = {}; for(var i=0;i!=d.length;++i) { if(d.charCodeAt(i) !== 0xFFFD) e[d.charAt(i)] = i; D[i] = d.charAt(i); } return {"enc": e, "dec": D }; })();
cptable[620] = (function(){ var d = "\u0000\u0001\u0002\u0003\u0004\u0005\u0006\u0007\b\t\n\u000b\f\r\u000e\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~ÇüéâäàąçêëèïîćÄĄĘęłôöĆûùŚÖÜ¢Ł¥śƒŹŻóÓńŃźż¿⌐¬½¼¡«»░▒▓│┤╡╢╖╕╣║╗╝╜╛┐└┴┬├─┼╞╟╚╔╩╦╠═╬╧╨╤╥╙╘╒╓╫╪┘┌█▄▌▐▀αßΓπΣσµτΦΘΩδ∞φε∩≡±≥≤⌠⌡÷≈°∙·√ⁿ²■ ", D = [], e = {}; for(var i=0;i!=d.length;++i) { if(d.charCodeAt(i) !== 0xFFFD) e[d.charAt(i)] = i; D[i] = d.charAt(i); } return {"enc": e, "dec": D }; })();
cptable[737] = (function(){ var d = "\u0000\u0001\u0002\u0003\u0004\u0005\u0006\u0007\b\t\n\u000b\f\r\u000e\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγδεζηθικλμνξοπρσςτυφχψ░▒▓│┤╡╢╖╕╣║╗╝╜╛┐└┴┬├─┼╞╟╚╔╩╦╠═╬╧╨╤╥╙╘╒╓╫╪┘┌█▄▌▐▀ωάέήϊίόύϋώΆΈΉΊΌΎΏ±≥≤ΪΫ÷≈°∙·√ⁿ²■ ", D = [], e = {}; for(var i=0;i!=d.length;++i) { if(d.charCodeAt(i) !== 0xFFFD) e[d.charAt(i)] = i; D[i] = d.charAt(i); } return {"enc": e, "dec": D }; })();
cptable[850] = (function(){ var d = "\u0000\u0001\u0002\u0003\u0004\u0005\u0006\u0007\b\t\n\u000b\f\r\u000e\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~ÇüéâäàåçêëèïîìÄÅÉæÆôöòûùÿÖÜø£Ø×ƒáíóúñÑªº¿®¬½¼¡«»░▒▓│┤ÁÂÀ©╣║╗╝¢¥┐└┴┬├─┼ãÃ╚╔╩╦╠═╬¤ðÐÊËÈıÍÎÏ┘┌█▄¦Ì▀ÓßÔÒõÕµþÞÚÛÙýÝ¯´­±‗¾¶§÷¸°¨·¹³²■ ", D = [], e = {}; for(var i=0;i!=d.length;++i) { if(d.charCodeAt(i) !== 0xFFFD) e[d.charAt(i)] = i; D[i] = d.charAt(i); } return {"enc": e, "dec": D }; })();
cptable[852] = (function(){ var d = "\u0000\u0001\u0002\u0003\u0004\u0005\u0006\u0007\b\t\n\u000b\f\r\u000e\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~ÇüéâäůćçłëŐőîŹÄĆÉĹĺôöĽľŚśÖÜŤťŁ×čáíóúĄąŽžĘę¬źČş«»░▒▓│┤ÁÂĚŞ╣║╗╝Żż┐└┴┬├─┼Ăă╚╔╩╦╠═╬¤đĐĎËďŇÍÎě┘┌█▄ŢŮ▀ÓßÔŃńňŠšŔÚŕŰýÝţ´­˝˛ˇ˘§÷¸°¨˙űŘř■ ", D = [], e = {}; for(var i=0;i!=d.length;++i) { if(d.charCodeAt(i) !== 0xFFFD) e[d.charAt(i)] = i; D[i] = d.charAt(i); } return {"enc": e, "dec": D }; })();
cptable[857] = (function(){ var d = "\u0000\u0001\u0002\u0003\u0004\u0005\u0006\u0007\b\t\n\u000b\f\r\u000e\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~ÇüéâäàåçêëèïîıÄÅÉæÆôöòûùİÖÜø£ØŞşáíóúñÑĞğ¿®¬½¼¡«»░▒▓│┤ÁÂÀ©╣║╗╝¢¥┐└┴┬├─┼ãÃ╚╔╩╦╠═╬¤ºªÊËÈ�ÍÎÏ┘┌█▄¦Ì▀ÓßÔÒõÕµ�×ÚÛÙìÿ¯´­±�¾¶§÷¸°¨·¹³²■ ", D = [], e = {}; for(var i=0;i!=d.length;++i) { if(d.charCodeAt(i) !== 0xFFFD) e[d.charAt(i)] = i; D[i] = d.charAt(i); } return {"enc": e, "dec": D }; })();
cptable[861] = (function(){ var d = "\u0000\u0001\u0002\u0003\u0004\u0005\u0006\u0007\b\t\n\u000b\f\r\u000e\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~ÇüéâäàåçêëèÐðÞÄÅÉæÆôöþûÝýÖÜø£Ø₧ƒáíóúÁÍÓÚ¿⌐¬½¼¡«»░▒▓│┤╡╢╖╕╣║╗╝╜╛┐└┴┬├─┼╞╟╚╔╩╦╠═╬╧╨╤╥╙╘╒╓╫╪┘┌█▄▌▐▀αßΓπΣσµτΦΘΩδ∞φε∩≡±≥≤⌠⌡÷≈°∙·√ⁿ²■ ", D = [], e = {}; for(var i=0;i!=d.length;++i) { if(d.charCodeAt(i) !== 0xFFFD) e[d.charAt(i)] = i; D[i] = d.charAt(i); } return {"enc": e, "dec": D }; })();
cptable[865] = (function(){ var d = "\u0000\u0001\u0002\u0003\u0004\u0005\u0006\u0007\b\t\n\u000b\f\r\u000e\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~ÇüéâäàåçêëèïîìÄÅÉæÆôöòûùÿÖÜø£Ø₧ƒáíóúñÑªº¿⌐¬½¼¡«¤░▒▓│┤╡╢╖╕╣║╗╝╜╛┐└┴┬├─┼╞╟╚╔╩╦╠═╬╧╨╤╥╙╘╒╓╫╪┘┌█▄▌▐▀αßΓπΣσµτΦΘΩδ∞φε∩≡±≥≤⌠⌡÷≈°∙·√ⁿ²■ ", D = [], e = {}; for(var i=0;i!=d.length;++i) { if(d.charCodeAt(i) !== 0xFFFD) e[d.charAt(i)] = i; D[i] = d.charAt(i); } return {"enc": e, "dec": D }; })();
cptable[866] = (function(){ var d = "\u0000\u0001\u0002\u0003\u0004\u0005\u0006\u0007\b\t\n\u000b\f\r\u000e\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~АБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдежзийклмноп░▒▓│┤╡╢╖╕╣║╗╝╜╛┐└┴┬├─┼╞╟╚╔╩╦╠═╬╧╨╤╥╙╘╒╓╫╪┘┌█▄▌▐▀рстуфхцчшщъыьэюяЁёЄєЇїЎў°∙·√№¤■ ", D = [], e = {}; for(var i=0;i!=d.length;++i) { if(d.charCodeAt(i) !== 0xFFFD) e[d.charAt(i)] = i; D[i] = d.charAt(i); } return {"enc": e, "dec": D }; })();
cptable[874] = (function(){ var d = "\u0000\u0001\u0002\u0003\u0004\u0005\u0006\u0007\b\t\n\u000b\f\r\u000e\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~€����…�����������‘’“”•–—�������� กขฃคฅฆงจฉชซฌญฎฏฐฑฒณดตถทธนบปผฝพฟภมยรฤลฦวศษสหฬอฮฯะัาำิีึืฺุู����฿เแโใไๅๆ็่้๊๋์ํ๎๏๐๑๒๓๔๕๖๗๘๙๚๛����", D = [], e = {}; for(var i=0;i!=d.length;++i) { if(d.charCodeAt(i) !== 0xFFFD) e[d.charAt(i)] = i; D[i] = d.charAt(i); } return {"enc": e, "dec": D }; })();
cptable[895] = (function(){ var d = "\u0000\u0001\u0002\u0003\u0004\u0005\u0006\u0007\b\t\n\u000b\f\r\u000e\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~ČüéďäĎŤčěĚĹÍľǪÄÁÉžŽôöÓůÚýÖÜŠĽÝŘťáíóúňŇŮÔšřŕŔ¼§«»░▒▓│┤╡╢╖╕╣║╗╝╜╛┐└┴┬├─┼╞╟╚╔╩╦╠═╬╧╨╤╥╙╘╒╓╫╪┘┌█▄▌▐▀αßΓπΣσµτΦΘΩδ∞φε∩≡±≥≤⌠⌡÷≈°∙·√ⁿ²■ ", D = [], e = {}; for(var i=0;i!=d.length;++i) { if(d.charCodeAt(i) !== 0xFFFD) e[d.charAt(i)] = i; D[i] = d.charAt(i); } return {"enc": e, "dec": D }; })();
cptable[932] = (function(){ var d = [], e = {}, D = [], j;
D[0] = "\u0000\u0001\u0002\u0003\u0004\u0005\u0006\u0007\b\t\n\u000b\f\r\u000e\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~���������������������������������｡｢｣､･ｦｧｨｩｪｫｬｭｮｯｰｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝﾞﾟ��������������������������������".split("");
for(j = 0; j != D[0].length; ++j) if(D[0][j].charCodeAt(0) !== 0xFFFD) { e[D[0][j]] = 0 + j; d[0 + j] = D[0][j];}
D[129] = "����������������������������������������������������������������　、。，．・：；？！゛゜´｀¨＾￣＿ヽヾゝゞ〃仝々〆〇ー―‐／＼～∥｜…‥‘’“”（）〔〕［］｛｝〈〉《》「」『』【】＋－±×�÷＝≠＜＞≦≧∞∴♂♀°′″℃￥＄￠￡％＃＆＊＠§☆★○●◎◇◆□■△▲▽▼※〒→←↑↓〓�����������∈∋⊆⊇⊂⊃∪∩��������∧∨￢⇒⇔∀∃�����������∠⊥⌒∂∇≡≒≪≫√∽∝∵∫∬�������Å‰♯♭♪†‡¶����◯���".split("");
for(j = 0; j != D[129].length; ++j) if(D[129][j].charCodeAt(0) !== 0xFFFD) { e[D[129][j]] = 33024 + j; d[33024 + j] = D[129][j];}
D[130] = "�������������������������������������������������������������������������������０１２３４５６７８９�������ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ�������ａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ����ぁあぃいぅうぇえぉおかがきぎくぐけげこごさざしじすずせぜそぞただちぢっつづてでとどなにぬねのはばぱひびぴふぶぷへべぺほぼぽまみむめもゃやゅゆょよらりるれろゎわゐゑをん��������������".split("");
for(j = 0; j != D[130].length; ++j) if(D[130][j].charCodeAt(0) !== 0xFFFD) { e[D[130][j]] = 33280 + j; d[33280 + j] = D[130][j];}
D[131] = "����������������������������������������������������������������ァアィイゥウェエォオカガキギクグケゲコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミ�ムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶ��������ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩ��������αβγδεζηθικλμνξοπρστυφχψω�����������������������������������������".split("");
for(j = 0; j != D[131].length; ++j) if(D[131][j].charCodeAt(0) !== 0xFFFD) { e[D[131][j]] = 33536 + j; d[33536 + j] = D[131][j];}
D[132] = "����������������������������������������������������������������АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ���������������абвгдеёжзийклмн�опрстуфхцчшщъыьэюя�������������─│┌┐┘└├┬┤┴┼━┃┏┓┛┗┣┳┫┻╋┠┯┨┷┿┝┰┥┸╂�����������������������������������������������������������������".split("");
for(j = 0; j != D[132].length; ++j) if(D[132][j].charCodeAt(0) !== 0xFFFD) { e[D[132][j]] = 33792 + j; d[33792 + j] = D[132][j];}
D[135] = "����������������������������������������������������������������①②③④⑤⑥⑦⑧⑨⑩⑪⑫⑬⑭⑮⑯⑰⑱⑲⑳ⅠⅡⅢⅣⅤⅥⅦⅧⅨⅩ�㍉㌔㌢㍍㌘㌧㌃㌶㍑㍗㌍㌦㌣㌫㍊㌻㎜㎝㎞㎎㎏㏄㎡��������㍻�〝〟№㏍℡㊤㊥㊦㊧㊨㈱㈲㈹㍾㍽㍼≒≡∫∮∑√⊥∠∟⊿∵∩∪���������������������������������������������������������������������������������������������������".split("");
for(j = 0; j != D[135].length; ++j) if(D[135][j].charCodeAt(0) !== 0xFFFD) { e[D[135][j]] = 34560 + j; d[34560 + j] = D[135][j];}
D[136] = "���������������������������������������������������������������������������������������������������������������������������������������������������������������亜唖娃阿哀愛挨姶逢葵茜穐悪握渥旭葦芦鯵梓圧斡扱宛姐虻飴絢綾鮎或粟袷安庵按暗案闇鞍杏以伊位依偉囲夷委威尉惟意慰易椅為畏異移維緯胃萎衣謂違遺医井亥域育郁磯一壱溢逸稲茨芋鰯允印咽員因姻引飲淫胤蔭���".split("");
for(j = 0; j != D[136].length; ++j) if(D[136][j].charCodeAt(0) !== 0xFFFD) { e[D[136][j]] = 34816 + j; d[34816 + j] = D[136][j];}
D[137] = "����������������������������������������������������������������院陰隠韻吋右宇烏羽迂雨卯鵜窺丑碓臼渦嘘唄欝蔚鰻姥厩浦瓜閏噂云運雲荏餌叡営嬰影映曳栄永泳洩瑛盈穎頴英衛詠鋭液疫益駅悦謁越閲榎厭円�園堰奄宴延怨掩援沿演炎焔煙燕猿縁艶苑薗遠鉛鴛塩於汚甥凹央奥往応押旺横欧殴王翁襖鴬鴎黄岡沖荻億屋憶臆桶牡乙俺卸恩温穏音下化仮何伽価佳加可嘉夏嫁家寡科暇果架歌河火珂禍禾稼箇花苛茄荷華菓蝦課嘩貨迦過霞蚊俄峨我牙画臥芽蛾賀雅餓駕介会解回塊壊廻快怪悔恢懐戒拐改���".split("");
for(j = 0; j != D[137].length; ++j) if(D[137][j].charCodeAt(0) !== 0xFFFD) { e[D[137][j]] = 35072 + j; d[35072 + j] = D[137][j];}
D[138] = "����������������������������������������������������������������魁晦械海灰界皆絵芥蟹開階貝凱劾外咳害崖慨概涯碍蓋街該鎧骸浬馨蛙垣柿蛎鈎劃嚇各廓拡撹格核殻獲確穫覚角赫較郭閣隔革学岳楽額顎掛笠樫�橿梶鰍潟割喝恰括活渇滑葛褐轄且鰹叶椛樺鞄株兜竃蒲釜鎌噛鴨栢茅萱粥刈苅瓦乾侃冠寒刊勘勧巻喚堪姦完官寛干幹患感慣憾換敢柑桓棺款歓汗漢澗潅環甘監看竿管簡緩缶翰肝艦莞観諌貫還鑑間閑関陥韓館舘丸含岸巌玩癌眼岩翫贋雁頑顔願企伎危喜器基奇嬉寄岐希幾忌揮机旗既期棋棄���".split("");
for(j = 0; j != D[138].length; ++j) if(D[138][j].charCodeAt(0) !== 0xFFFD) { e[D[138][j]] = 35328 + j; d[35328 + j] = D[138][j];}
D[139] = "����������������������������������������������������������������機帰毅気汽畿祈季稀紀徽規記貴起軌輝飢騎鬼亀偽儀妓宜戯技擬欺犠疑祇義蟻誼議掬菊鞠吉吃喫桔橘詰砧杵黍却客脚虐逆丘久仇休及吸宮弓急救�朽求汲泣灸球究窮笈級糾給旧牛去居巨拒拠挙渠虚許距鋸漁禦魚亨享京供侠僑兇競共凶協匡卿叫喬境峡強彊怯恐恭挟教橋況狂狭矯胸脅興蕎郷鏡響饗驚仰凝尭暁業局曲極玉桐粁僅勤均巾錦斤欣欽琴禁禽筋緊芹菌衿襟謹近金吟銀九倶句区狗玖矩苦躯駆駈駒具愚虞喰空偶寓遇隅串櫛釧屑屈���".split("");
for(j = 0; j != D[139].length; ++j) if(D[139][j].charCodeAt(0) !== 0xFFFD) { e[D[139][j]] = 35584 + j; d[35584 + j] = D[139][j];}
D[140] = "����������������������������������������������������������������掘窟沓靴轡窪熊隈粂栗繰桑鍬勲君薫訓群軍郡卦袈祁係傾刑兄啓圭珪型契形径恵慶慧憩掲携敬景桂渓畦稽系経継繋罫茎荊蛍計詣警軽頚鶏芸迎鯨�劇戟撃激隙桁傑欠決潔穴結血訣月件倹倦健兼券剣喧圏堅嫌建憲懸拳捲検権牽犬献研硯絹県肩見謙賢軒遣鍵険顕験鹸元原厳幻弦減源玄現絃舷言諺限乎個古呼固姑孤己庫弧戸故枯湖狐糊袴股胡菰虎誇跨鈷雇顧鼓五互伍午呉吾娯後御悟梧檎瑚碁語誤護醐乞鯉交佼侯候倖光公功効勾厚口向���".split("");
for(j = 0; j != D[140].length; ++j) if(D[140][j].charCodeAt(0) !== 0xFFFD) { e[D[140][j]] = 35840 + j; d[35840 + j] = D[140][j];}
D[141] = "����������������������������������������������������������������后喉坑垢好孔孝宏工巧巷幸広庚康弘恒慌抗拘控攻昂晃更杭校梗構江洪浩港溝甲皇硬稿糠紅紘絞綱耕考肯肱腔膏航荒行衡講貢購郊酵鉱砿鋼閤降�項香高鴻剛劫号合壕拷濠豪轟麹克刻告国穀酷鵠黒獄漉腰甑忽惚骨狛込此頃今困坤墾婚恨懇昏昆根梱混痕紺艮魂些佐叉唆嵯左差査沙瑳砂詐鎖裟坐座挫債催再最哉塞妻宰彩才採栽歳済災采犀砕砦祭斎細菜裁載際剤在材罪財冴坂阪堺榊肴咲崎埼碕鷺作削咋搾昨朔柵窄策索錯桜鮭笹匙冊刷���".split("");
for(j = 0; j != D[141].length; ++j) if(D[141][j].charCodeAt(0) !== 0xFFFD) { e[D[141][j]] = 36096 + j; d[36096 + j] = D[141][j];}
D[142] = "����������������������������������������������������������������察拶撮擦札殺薩雑皐鯖捌錆鮫皿晒三傘参山惨撒散桟燦珊産算纂蚕讃賛酸餐斬暫残仕仔伺使刺司史嗣四士始姉姿子屍市師志思指支孜斯施旨枝止�死氏獅祉私糸紙紫肢脂至視詞詩試誌諮資賜雌飼歯事似侍児字寺慈持時次滋治爾璽痔磁示而耳自蒔辞汐鹿式識鴫竺軸宍雫七叱執失嫉室悉湿漆疾質実蔀篠偲柴芝屡蕊縞舎写射捨赦斜煮社紗者謝車遮蛇邪借勺尺杓灼爵酌釈錫若寂弱惹主取守手朱殊狩珠種腫趣酒首儒受呪寿授樹綬需囚収周���".split("");
for(j = 0; j != D[142].length; ++j) if(D[142][j].charCodeAt(0) !== 0xFFFD) { e[D[142][j]] = 36352 + j; d[36352 + j] = D[142][j];}
D[143] = "����������������������������������������������������������������宗就州修愁拾洲秀秋終繍習臭舟蒐衆襲讐蹴輯週酋酬集醜什住充十従戎柔汁渋獣縦重銃叔夙宿淑祝縮粛塾熟出術述俊峻春瞬竣舜駿准循旬楯殉淳�準潤盾純巡遵醇順処初所暑曙渚庶緒署書薯藷諸助叙女序徐恕鋤除傷償勝匠升召哨商唱嘗奨妾娼宵将小少尚庄床廠彰承抄招掌捷昇昌昭晶松梢樟樵沼消渉湘焼焦照症省硝礁祥称章笑粧紹肖菖蒋蕉衝裳訟証詔詳象賞醤鉦鍾鐘障鞘上丈丞乗冗剰城場壌嬢常情擾条杖浄状畳穣蒸譲醸錠嘱埴飾���".split("");
for(j = 0; j != D[143].length; ++j) if(D[143][j].charCodeAt(0) !== 0xFFFD) { e[D[143][j]] = 36608 + j; d[36608 + j] = D[143][j];}
D[144] = "����������������������������������������������������������������拭植殖燭織職色触食蝕辱尻伸信侵唇娠寝審心慎振新晋森榛浸深申疹真神秦紳臣芯薪親診身辛進針震人仁刃塵壬尋甚尽腎訊迅陣靭笥諏須酢図厨�逗吹垂帥推水炊睡粋翠衰遂酔錐錘随瑞髄崇嵩数枢趨雛据杉椙菅頗雀裾澄摺寸世瀬畝是凄制勢姓征性成政整星晴棲栖正清牲生盛精聖声製西誠誓請逝醒青静斉税脆隻席惜戚斥昔析石積籍績脊責赤跡蹟碩切拙接摂折設窃節説雪絶舌蝉仙先千占宣専尖川戦扇撰栓栴泉浅洗染潜煎煽旋穿箭線���".split("");
for(j = 0; j != D[144].length; ++j) if(D[144][j].charCodeAt(0) !== 0xFFFD) { e[D[144][j]] = 36864 + j; d[36864 + j] = D[144][j];}
D[145] = "����������������������������������������������������������������繊羨腺舛船薦詮賎践選遷銭銑閃鮮前善漸然全禅繕膳糎噌塑岨措曾曽楚狙疏疎礎祖租粗素組蘇訴阻遡鼠僧創双叢倉喪壮奏爽宋層匝惣想捜掃挿掻�操早曹巣槍槽漕燥争痩相窓糟総綜聡草荘葬蒼藻装走送遭鎗霜騒像増憎臓蔵贈造促側則即息捉束測足速俗属賊族続卒袖其揃存孫尊損村遜他多太汰詑唾堕妥惰打柁舵楕陀駄騨体堆対耐岱帯待怠態戴替泰滞胎腿苔袋貸退逮隊黛鯛代台大第醍題鷹滝瀧卓啄宅托択拓沢濯琢託鐸濁諾茸凧蛸只���".split("");
for(j = 0; j != D[145].length; ++j) if(D[145][j].charCodeAt(0) !== 0xFFFD) { e[D[145][j]] = 37120 + j; d[37120 + j] = D[145][j];}
D[146] = "����������������������������������������������������������������叩但達辰奪脱巽竪辿棚谷狸鱈樽誰丹単嘆坦担探旦歎淡湛炭短端箪綻耽胆蛋誕鍛団壇弾断暖檀段男談値知地弛恥智池痴稚置致蜘遅馳築畜竹筑蓄�逐秩窒茶嫡着中仲宙忠抽昼柱注虫衷註酎鋳駐樗瀦猪苧著貯丁兆凋喋寵帖帳庁弔張彫徴懲挑暢朝潮牒町眺聴脹腸蝶調諜超跳銚長頂鳥勅捗直朕沈珍賃鎮陳津墜椎槌追鎚痛通塚栂掴槻佃漬柘辻蔦綴鍔椿潰坪壷嬬紬爪吊釣鶴亭低停偵剃貞呈堤定帝底庭廷弟悌抵挺提梯汀碇禎程締艇訂諦蹄逓���".split("");
for(j = 0; j != D[146].length; ++j) if(D[146][j].charCodeAt(0) !== 0xFFFD) { e[D[146][j]] = 37376 + j; d[37376 + j] = D[146][j];}
D[147] = "����������������������������������������������������������������邸鄭釘鼎泥摘擢敵滴的笛適鏑溺哲徹撤轍迭鉄典填天展店添纏甜貼転顛点伝殿澱田電兎吐堵塗妬屠徒斗杜渡登菟賭途都鍍砥砺努度土奴怒倒党冬�凍刀唐塔塘套宕島嶋悼投搭東桃梼棟盗淘湯涛灯燈当痘祷等答筒糖統到董蕩藤討謄豆踏逃透鐙陶頭騰闘働動同堂導憧撞洞瞳童胴萄道銅峠鴇匿得徳涜特督禿篤毒独読栃橡凸突椴届鳶苫寅酉瀞噸屯惇敦沌豚遁頓呑曇鈍奈那内乍凪薙謎灘捺鍋楢馴縄畷南楠軟難汝二尼弐迩匂賑肉虹廿日乳入���".split("");
for(j = 0; j != D[147].length; ++j) if(D[147][j].charCodeAt(0) !== 0xFFFD) { e[D[147][j]] = 37632 + j; d[37632 + j] = D[147][j];}
D[148] = "����������������������������������������������������������������如尿韮任妊忍認濡禰祢寧葱猫熱年念捻撚燃粘乃廼之埜嚢悩濃納能脳膿農覗蚤巴把播覇杷波派琶破婆罵芭馬俳廃拝排敗杯盃牌背肺輩配倍培媒梅�楳煤狽買売賠陪這蝿秤矧萩伯剥博拍柏泊白箔粕舶薄迫曝漠爆縛莫駁麦函箱硲箸肇筈櫨幡肌畑畠八鉢溌発醗髪伐罰抜筏閥鳩噺塙蛤隼伴判半反叛帆搬斑板氾汎版犯班畔繁般藩販範釆煩頒飯挽晩番盤磐蕃蛮匪卑否妃庇彼悲扉批披斐比泌疲皮碑秘緋罷肥被誹費避非飛樋簸備尾微枇毘琵眉美���".split("");
for(j = 0; j != D[148].length; ++j) if(D[148][j].charCodeAt(0) !== 0xFFFD) { e[D[148][j]] = 37888 + j; d[37888 + j] = D[148][j];}
D[149] = "����������������������������������������������������������������鼻柊稗匹疋髭彦膝菱肘弼必畢筆逼桧姫媛紐百謬俵彪標氷漂瓢票表評豹廟描病秒苗錨鋲蒜蛭鰭品彬斌浜瀕貧賓頻敏瓶不付埠夫婦富冨布府怖扶敷�斧普浮父符腐膚芙譜負賦赴阜附侮撫武舞葡蕪部封楓風葺蕗伏副復幅服福腹複覆淵弗払沸仏物鮒分吻噴墳憤扮焚奮粉糞紛雰文聞丙併兵塀幣平弊柄並蔽閉陛米頁僻壁癖碧別瞥蔑箆偏変片篇編辺返遍便勉娩弁鞭保舗鋪圃捕歩甫補輔穂募墓慕戊暮母簿菩倣俸包呆報奉宝峰峯崩庖抱捧放方朋���".split("");
for(j = 0; j != D[149].length; ++j) if(D[149][j].charCodeAt(0) !== 0xFFFD) { e[D[149][j]] = 38144 + j; d[38144 + j] = D[149][j];}
D[150] = "����������������������������������������������������������������法泡烹砲縫胞芳萌蓬蜂褒訪豊邦鋒飽鳳鵬乏亡傍剖坊妨帽忘忙房暴望某棒冒紡肪膨謀貌貿鉾防吠頬北僕卜墨撲朴牧睦穆釦勃没殆堀幌奔本翻凡盆�摩磨魔麻埋妹昧枚毎哩槙幕膜枕鮪柾鱒桝亦俣又抹末沫迄侭繭麿万慢満漫蔓味未魅巳箕岬密蜜湊蓑稔脈妙粍民眠務夢無牟矛霧鵡椋婿娘冥名命明盟迷銘鳴姪牝滅免棉綿緬面麺摸模茂妄孟毛猛盲網耗蒙儲木黙目杢勿餅尤戻籾貰問悶紋門匁也冶夜爺耶野弥矢厄役約薬訳躍靖柳薮鑓愉愈油癒���".split("");
for(j = 0; j != D[150].length; ++j) if(D[150][j].charCodeAt(0) !== 0xFFFD) { e[D[150][j]] = 38400 + j; d[38400 + j] = D[150][j];}
D[151] = "����������������������������������������������������������������諭輸唯佑優勇友宥幽悠憂揖有柚湧涌猶猷由祐裕誘遊邑郵雄融夕予余与誉輿預傭幼妖容庸揚揺擁曜楊様洋溶熔用窯羊耀葉蓉要謡踊遥陽養慾抑欲�沃浴翌翼淀羅螺裸来莱頼雷洛絡落酪乱卵嵐欄濫藍蘭覧利吏履李梨理璃痢裏裡里離陸律率立葎掠略劉流溜琉留硫粒隆竜龍侶慮旅虜了亮僚両凌寮料梁涼猟療瞭稜糧良諒遼量陵領力緑倫厘林淋燐琳臨輪隣鱗麟瑠塁涙累類令伶例冷励嶺怜玲礼苓鈴隷零霊麗齢暦歴列劣烈裂廉恋憐漣煉簾練聯���".split("");
for(j = 0; j != D[151].length; ++j) if(D[151][j].charCodeAt(0) !== 0xFFFD) { e[D[151][j]] = 38656 + j; d[38656 + j] = D[151][j];}
D[152] = "����������������������������������������������������������������蓮連錬呂魯櫓炉賂路露労婁廊弄朗楼榔浪漏牢狼篭老聾蝋郎六麓禄肋録論倭和話歪賄脇惑枠鷲亙亘鰐詫藁蕨椀湾碗腕��������������������������������������������弌丐丕个丱丶丼丿乂乖乘亂亅豫亊舒弍于亞亟亠亢亰亳亶从仍仄仆仂仗仞仭仟价伉佚估佛佝佗佇佶侈侏侘佻佩佰侑佯來侖儘俔俟俎俘俛俑俚俐俤俥倚倨倔倪倥倅伜俶倡倩倬俾俯們倆偃假會偕偐偈做偖偬偸傀傚傅傴傲���".split("");
for(j = 0; j != D[152].length; ++j) if(D[152][j].charCodeAt(0) !== 0xFFFD) { e[D[152][j]] = 38912 + j; d[38912 + j] = D[152][j];}
D[153] = "����������������������������������������������������������������僉僊傳僂僖僞僥僭僣僮價僵儉儁儂儖儕儔儚儡儺儷儼儻儿兀兒兌兔兢竸兩兪兮冀冂囘册冉冏冑冓冕冖冤冦冢冩冪冫决冱冲冰况冽凅凉凛几處凩凭�凰凵凾刄刋刔刎刧刪刮刳刹剏剄剋剌剞剔剪剴剩剳剿剽劍劔劒剱劈劑辨辧劬劭劼劵勁勍勗勞勣勦飭勠勳勵勸勹匆匈甸匍匐匏匕匚匣匯匱匳匸區卆卅丗卉卍凖卞卩卮夘卻卷厂厖厠厦厥厮厰厶參簒雙叟曼燮叮叨叭叺吁吽呀听吭吼吮吶吩吝呎咏呵咎呟呱呷呰咒呻咀呶咄咐咆哇咢咸咥咬哄哈咨���".split("");
for(j = 0; j != D[153].length; ++j) if(D[153][j].charCodeAt(0) !== 0xFFFD) { e[D[153][j]] = 39168 + j; d[39168 + j] = D[153][j];}
D[154] = "����������������������������������������������������������������咫哂咤咾咼哘哥哦唏唔哽哮哭哺哢唹啀啣啌售啜啅啖啗唸唳啝喙喀咯喊喟啻啾喘喞單啼喃喩喇喨嗚嗅嗟嗄嗜嗤嗔嘔嗷嘖嗾嗽嘛嗹噎噐營嘴嘶嘲嘸�噫噤嘯噬噪嚆嚀嚊嚠嚔嚏嚥嚮嚶嚴囂嚼囁囃囀囈囎囑囓囗囮囹圀囿圄圉圈國圍圓團圖嗇圜圦圷圸坎圻址坏坩埀垈坡坿垉垓垠垳垤垪垰埃埆埔埒埓堊埖埣堋堙堝塲堡塢塋塰毀塒堽塹墅墹墟墫墺壞墻墸墮壅壓壑壗壙壘壥壜壤壟壯壺壹壻壼壽夂夊夐夛梦夥夬夭夲夸夾竒奕奐奎奚奘奢奠奧奬奩���".split("");
for(j = 0; j != D[154].length; ++j) if(D[154][j].charCodeAt(0) !== 0xFFFD) { e[D[154][j]] = 39424 + j; d[39424 + j] = D[154][j];}
D[155] = "����������������������������������������������������������������奸妁妝佞侫妣妲姆姨姜妍姙姚娥娟娑娜娉娚婀婬婉娵娶婢婪媚媼媾嫋嫂媽嫣嫗嫦嫩嫖嫺嫻嬌嬋嬖嬲嫐嬪嬶嬾孃孅孀孑孕孚孛孥孩孰孳孵學斈孺宀�它宦宸寃寇寉寔寐寤實寢寞寥寫寰寶寳尅將專對尓尠尢尨尸尹屁屆屎屓屐屏孱屬屮乢屶屹岌岑岔妛岫岻岶岼岷峅岾峇峙峩峽峺峭嶌峪崋崕崗嵜崟崛崑崔崢崚崙崘嵌嵒嵎嵋嵬嵳嵶嶇嶄嶂嶢嶝嶬嶮嶽嶐嶷嶼巉巍巓巒巖巛巫已巵帋帚帙帑帛帶帷幄幃幀幎幗幔幟幢幤幇幵并幺麼广庠廁廂廈廐廏���".split("");
for(j = 0; j != D[155].length; ++j) if(D[155][j].charCodeAt(0) !== 0xFFFD) { e[D[155][j]] = 39680 + j; d[39680 + j] = D[155][j];}
D[156] = "����������������������������������������������������������������廖廣廝廚廛廢廡廨廩廬廱廳廰廴廸廾弃弉彝彜弋弑弖弩弭弸彁彈彌彎弯彑彖彗彙彡彭彳彷徃徂彿徊很徑徇從徙徘徠徨徭徼忖忻忤忸忱忝悳忿怡恠�怙怐怩怎怱怛怕怫怦怏怺恚恁恪恷恟恊恆恍恣恃恤恂恬恫恙悁悍惧悃悚悄悛悖悗悒悧悋惡悸惠惓悴忰悽惆悵惘慍愕愆惶惷愀惴惺愃愡惻惱愍愎慇愾愨愧慊愿愼愬愴愽慂慄慳慷慘慙慚慫慴慯慥慱慟慝慓慵憙憖憇憬憔憚憊憑憫憮懌懊應懷懈懃懆憺懋罹懍懦懣懶懺懴懿懽懼懾戀戈戉戍戌戔戛���".split("");
for(j = 0; j != D[156].length; ++j) if(D[156][j].charCodeAt(0) !== 0xFFFD) { e[D[156][j]] = 39936 + j; d[39936 + j] = D[156][j];}
D[157] = "����������������������������������������������������������������戞戡截戮戰戲戳扁扎扞扣扛扠扨扼抂抉找抒抓抖拔抃抔拗拑抻拏拿拆擔拈拜拌拊拂拇抛拉挌拮拱挧挂挈拯拵捐挾捍搜捏掖掎掀掫捶掣掏掉掟掵捫�捩掾揩揀揆揣揉插揶揄搖搴搆搓搦搶攝搗搨搏摧摯摶摎攪撕撓撥撩撈撼據擒擅擇撻擘擂擱擧舉擠擡抬擣擯攬擶擴擲擺攀擽攘攜攅攤攣攫攴攵攷收攸畋效敖敕敍敘敞敝敲數斂斃變斛斟斫斷旃旆旁旄旌旒旛旙无旡旱杲昊昃旻杳昵昶昴昜晏晄晉晁晞晝晤晧晨晟晢晰暃暈暎暉暄暘暝曁暹曉暾暼���".split("");
for(j = 0; j != D[157].length; ++j) if(D[157][j].charCodeAt(0) !== 0xFFFD) { e[D[157][j]] = 40192 + j; d[40192 + j] = D[157][j];}
D[158] = "����������������������������������������������������������������曄暸曖曚曠昿曦曩曰曵曷朏朖朞朦朧霸朮朿朶杁朸朷杆杞杠杙杣杤枉杰枩杼杪枌枋枦枡枅枷柯枴柬枳柩枸柤柞柝柢柮枹柎柆柧檜栞框栩桀桍栲桎�梳栫桙档桷桿梟梏梭梔條梛梃檮梹桴梵梠梺椏梍桾椁棊椈棘椢椦棡椌棍棔棧棕椶椒椄棗棣椥棹棠棯椨椪椚椣椡棆楹楷楜楸楫楔楾楮椹楴椽楙椰楡楞楝榁楪榲榮槐榿槁槓榾槎寨槊槝榻槃榧樮榑榠榜榕榴槞槨樂樛槿權槹槲槧樅榱樞槭樔槫樊樒櫁樣樓橄樌橲樶橸橇橢橙橦橈樸樢檐檍檠檄檢檣���".split("");
for(j = 0; j != D[158].length; ++j) if(D[158][j].charCodeAt(0) !== 0xFFFD) { e[D[158][j]] = 40448 + j; d[40448 + j] = D[158][j];}
D[159] = "����������������������������������������������������������������檗蘗檻櫃櫂檸檳檬櫞櫑櫟檪櫚櫪櫻欅蘖櫺欒欖鬱欟欸欷盜欹飮歇歃歉歐歙歔歛歟歡歸歹歿殀殄殃殍殘殕殞殤殪殫殯殲殱殳殷殼毆毋毓毟毬毫毳毯�麾氈氓气氛氤氣汞汕汢汪沂沍沚沁沛汾汨汳沒沐泄泱泓沽泗泅泝沮沱沾沺泛泯泙泪洟衍洶洫洽洸洙洵洳洒洌浣涓浤浚浹浙涎涕濤涅淹渕渊涵淇淦涸淆淬淞淌淨淒淅淺淙淤淕淪淮渭湮渮渙湲湟渾渣湫渫湶湍渟湃渺湎渤滿渝游溂溪溘滉溷滓溽溯滄溲滔滕溏溥滂溟潁漑灌滬滸滾漿滲漱滯漲滌���".split("");
for(j = 0; j != D[159].length; ++j) if(D[159][j].charCodeAt(0) !== 0xFFFD) { e[D[159][j]] = 40704 + j; d[40704 + j] = D[159][j];}
D[224] = "����������������������������������������������������������������漾漓滷澆潺潸澁澀潯潛濳潭澂潼潘澎澑濂潦澳澣澡澤澹濆澪濟濕濬濔濘濱濮濛瀉瀋濺瀑瀁瀏濾瀛瀚潴瀝瀘瀟瀰瀾瀲灑灣炙炒炯烱炬炸炳炮烟烋烝�烙焉烽焜焙煥煕熈煦煢煌煖煬熏燻熄熕熨熬燗熹熾燒燉燔燎燠燬燧燵燼燹燿爍爐爛爨爭爬爰爲爻爼爿牀牆牋牘牴牾犂犁犇犒犖犢犧犹犲狃狆狄狎狒狢狠狡狹狷倏猗猊猜猖猝猴猯猩猥猾獎獏默獗獪獨獰獸獵獻獺珈玳珎玻珀珥珮珞璢琅瑯琥珸琲琺瑕琿瑟瑙瑁瑜瑩瑰瑣瑪瑶瑾璋璞璧瓊瓏瓔珱���".split("");
for(j = 0; j != D[224].length; ++j) if(D[224][j].charCodeAt(0) !== 0xFFFD) { e[D[224][j]] = 57344 + j; d[57344 + j] = D[224][j];}
D[225] = "����������������������������������������������������������������瓠瓣瓧瓩瓮瓲瓰瓱瓸瓷甄甃甅甌甎甍甕甓甞甦甬甼畄畍畊畉畛畆畚畩畤畧畫畭畸當疆疇畴疊疉疂疔疚疝疥疣痂疳痃疵疽疸疼疱痍痊痒痙痣痞痾痿�痼瘁痰痺痲痳瘋瘍瘉瘟瘧瘠瘡瘢瘤瘴瘰瘻癇癈癆癜癘癡癢癨癩癪癧癬癰癲癶癸發皀皃皈皋皎皖皓皙皚皰皴皸皹皺盂盍盖盒盞盡盥盧盪蘯盻眈眇眄眩眤眞眥眦眛眷眸睇睚睨睫睛睥睿睾睹瞎瞋瞑瞠瞞瞰瞶瞹瞿瞼瞽瞻矇矍矗矚矜矣矮矼砌砒礦砠礪硅碎硴碆硼碚碌碣碵碪碯磑磆磋磔碾碼磅磊磬���".split("");
for(j = 0; j != D[225].length; ++j) if(D[225][j].charCodeAt(0) !== 0xFFFD) { e[D[225][j]] = 57600 + j; d[57600 + j] = D[225][j];}
D[226] = "����������������������������������������������������������������磧磚磽磴礇礒礑礙礬礫祀祠祗祟祚祕祓祺祿禊禝禧齋禪禮禳禹禺秉秕秧秬秡秣稈稍稘稙稠稟禀稱稻稾稷穃穗穉穡穢穩龝穰穹穽窈窗窕窘窖窩竈窰�窶竅竄窿邃竇竊竍竏竕竓站竚竝竡竢竦竭竰笂笏笊笆笳笘笙笞笵笨笶筐筺笄筍笋筌筅筵筥筴筧筰筱筬筮箝箘箟箍箜箚箋箒箏筝箙篋篁篌篏箴篆篝篩簑簔篦篥籠簀簇簓篳篷簗簍篶簣簧簪簟簷簫簽籌籃籔籏籀籐籘籟籤籖籥籬籵粃粐粤粭粢粫粡粨粳粲粱粮粹粽糀糅糂糘糒糜糢鬻糯糲糴糶糺紆���".split("");
for(j = 0; j != D[226].length; ++j) if(D[226][j].charCodeAt(0) !== 0xFFFD) { e[D[226][j]] = 57856 + j; d[57856 + j] = D[226][j];}
D[227] = "����������������������������������������������������������������紂紜紕紊絅絋紮紲紿紵絆絳絖絎絲絨絮絏絣經綉絛綏絽綛綺綮綣綵緇綽綫總綢綯緜綸綟綰緘緝緤緞緻緲緡縅縊縣縡縒縱縟縉縋縢繆繦縻縵縹繃縷�縲縺繧繝繖繞繙繚繹繪繩繼繻纃緕繽辮繿纈纉續纒纐纓纔纖纎纛纜缸缺罅罌罍罎罐网罕罔罘罟罠罨罩罧罸羂羆羃羈羇羌羔羞羝羚羣羯羲羹羮羶羸譱翅翆翊翕翔翡翦翩翳翹飜耆耄耋耒耘耙耜耡耨耿耻聊聆聒聘聚聟聢聨聳聲聰聶聹聽聿肄肆肅肛肓肚肭冐肬胛胥胙胝胄胚胖脉胯胱脛脩脣脯腋���".split("");
for(j = 0; j != D[227].length; ++j) if(D[227][j].charCodeAt(0) !== 0xFFFD) { e[D[227][j]] = 58112 + j; d[58112 + j] = D[227][j];}
D[228] = "����������������������������������������������������������������隋腆脾腓腑胼腱腮腥腦腴膃膈膊膀膂膠膕膤膣腟膓膩膰膵膾膸膽臀臂膺臉臍臑臙臘臈臚臟臠臧臺臻臾舁舂舅與舊舍舐舖舩舫舸舳艀艙艘艝艚艟艤�艢艨艪艫舮艱艷艸艾芍芒芫芟芻芬苡苣苟苒苴苳苺莓范苻苹苞茆苜茉苙茵茴茖茲茱荀茹荐荅茯茫茗茘莅莚莪莟莢莖茣莎莇莊荼莵荳荵莠莉莨菴萓菫菎菽萃菘萋菁菷萇菠菲萍萢萠莽萸蔆菻葭萪萼蕚蒄葷葫蒭葮蒂葩葆萬葯葹萵蓊葢蒹蒿蒟蓙蓍蒻蓚蓐蓁蓆蓖蒡蔡蓿蓴蔗蔘蔬蔟蔕蔔蓼蕀蕣蕘蕈���".split("");
for(j = 0; j != D[228].length; ++j) if(D[228][j].charCodeAt(0) !== 0xFFFD) { e[D[228][j]] = 58368 + j; d[58368 + j] = D[228][j];}
D[229] = "����������������������������������������������������������������蕁蘂蕋蕕薀薤薈薑薊薨蕭薔薛藪薇薜蕷蕾薐藉薺藏薹藐藕藝藥藜藹蘊蘓蘋藾藺蘆蘢蘚蘰蘿虍乕虔號虧虱蚓蚣蚩蚪蚋蚌蚶蚯蛄蛆蚰蛉蠣蚫蛔蛞蛩蛬�蛟蛛蛯蜒蜆蜈蜀蜃蛻蜑蜉蜍蛹蜊蜴蜿蜷蜻蜥蜩蜚蝠蝟蝸蝌蝎蝴蝗蝨蝮蝙蝓蝣蝪蠅螢螟螂螯蟋螽蟀蟐雖螫蟄螳蟇蟆螻蟯蟲蟠蠏蠍蟾蟶蟷蠎蟒蠑蠖蠕蠢蠡蠱蠶蠹蠧蠻衄衂衒衙衞衢衫袁衾袞衵衽袵衲袂袗袒袮袙袢袍袤袰袿袱裃裄裔裘裙裝裹褂裼裴裨裲褄褌褊褓襃褞褥褪褫襁襄褻褶褸襌褝襠襞���".split("");
for(j = 0; j != D[229].length; ++j) if(D[229][j].charCodeAt(0) !== 0xFFFD) { e[D[229][j]] = 58624 + j; d[58624 + j] = D[229][j];}
D[230] = "����������������������������������������������������������������襦襤襭襪襯襴襷襾覃覈覊覓覘覡覩覦覬覯覲覺覽覿觀觚觜觝觧觴觸訃訖訐訌訛訝訥訶詁詛詒詆詈詼詭詬詢誅誂誄誨誡誑誥誦誚誣諄諍諂諚諫諳諧�諤諱謔諠諢諷諞諛謌謇謚諡謖謐謗謠謳鞫謦謫謾謨譁譌譏譎證譖譛譚譫譟譬譯譴譽讀讌讎讒讓讖讙讚谺豁谿豈豌豎豐豕豢豬豸豺貂貉貅貊貍貎貔豼貘戝貭貪貽貲貳貮貶賈賁賤賣賚賽賺賻贄贅贊贇贏贍贐齎贓賍贔贖赧赭赱赳趁趙跂趾趺跏跚跖跌跛跋跪跫跟跣跼踈踉跿踝踞踐踟蹂踵踰踴蹊���".split("");
for(j = 0; j != D[230].length; ++j) if(D[230][j].charCodeAt(0) !== 0xFFFD) { e[D[230][j]] = 58880 + j; d[58880 + j] = D[230][j];}
D[231] = "����������������������������������������������������������������蹇蹉蹌蹐蹈蹙蹤蹠踪蹣蹕蹶蹲蹼躁躇躅躄躋躊躓躑躔躙躪躡躬躰軆躱躾軅軈軋軛軣軼軻軫軾輊輅輕輒輙輓輜輟輛輌輦輳輻輹轅轂輾轌轉轆轎轗轜�轢轣轤辜辟辣辭辯辷迚迥迢迪迯邇迴逅迹迺逑逕逡逍逞逖逋逧逶逵逹迸遏遐遑遒逎遉逾遖遘遞遨遯遶隨遲邂遽邁邀邊邉邏邨邯邱邵郢郤扈郛鄂鄒鄙鄲鄰酊酖酘酣酥酩酳酲醋醉醂醢醫醯醪醵醴醺釀釁釉釋釐釖釟釡釛釼釵釶鈞釿鈔鈬鈕鈑鉞鉗鉅鉉鉤鉈銕鈿鉋鉐銜銖銓銛鉚鋏銹銷鋩錏鋺鍄錮���".split("");
for(j = 0; j != D[231].length; ++j) if(D[231][j].charCodeAt(0) !== 0xFFFD) { e[D[231][j]] = 59136 + j; d[59136 + j] = D[231][j];}
D[232] = "����������������������������������������������������������������錙錢錚錣錺錵錻鍜鍠鍼鍮鍖鎰鎬鎭鎔鎹鏖鏗鏨鏥鏘鏃鏝鏐鏈鏤鐚鐔鐓鐃鐇鐐鐶鐫鐵鐡鐺鑁鑒鑄鑛鑠鑢鑞鑪鈩鑰鑵鑷鑽鑚鑼鑾钁鑿閂閇閊閔閖閘閙�閠閨閧閭閼閻閹閾闊濶闃闍闌闕闔闖關闡闥闢阡阨阮阯陂陌陏陋陷陜陞陝陟陦陲陬隍隘隕隗險隧隱隲隰隴隶隸隹雎雋雉雍襍雜霍雕雹霄霆霈霓霎霑霏霖霙霤霪霰霹霽霾靄靆靈靂靉靜靠靤靦靨勒靫靱靹鞅靼鞁靺鞆鞋鞏鞐鞜鞨鞦鞣鞳鞴韃韆韈韋韜韭齏韲竟韶韵頏頌頸頤頡頷頽顆顏顋顫顯顰���".split("");
for(j = 0; j != D[232].length; ++j) if(D[232][j].charCodeAt(0) !== 0xFFFD) { e[D[232][j]] = 59392 + j; d[59392 + j] = D[232][j];}
D[233] = "����������������������������������������������������������������顱顴顳颪颯颱颶飄飃飆飩飫餃餉餒餔餘餡餝餞餤餠餬餮餽餾饂饉饅饐饋饑饒饌饕馗馘馥馭馮馼駟駛駝駘駑駭駮駱駲駻駸騁騏騅駢騙騫騷驅驂驀驃�騾驕驍驛驗驟驢驥驤驩驫驪骭骰骼髀髏髑髓體髞髟髢髣髦髯髫髮髴髱髷髻鬆鬘鬚鬟鬢鬣鬥鬧鬨鬩鬪鬮鬯鬲魄魃魏魍魎魑魘魴鮓鮃鮑鮖鮗鮟鮠鮨鮴鯀鯊鮹鯆鯏鯑鯒鯣鯢鯤鯔鯡鰺鯲鯱鯰鰕鰔鰉鰓鰌鰆鰈鰒鰊鰄鰮鰛鰥鰤鰡鰰鱇鰲鱆鰾鱚鱠鱧鱶鱸鳧鳬鳰鴉鴈鳫鴃鴆鴪鴦鶯鴣鴟鵄鴕鴒鵁鴿鴾鵆鵈���".split("");
for(j = 0; j != D[233].length; ++j) if(D[233][j].charCodeAt(0) !== 0xFFFD) { e[D[233][j]] = 59648 + j; d[59648 + j] = D[233][j];}
D[234] = "����������������������������������������������������������������鵝鵞鵤鵑鵐鵙鵲鶉鶇鶫鵯鵺鶚鶤鶩鶲鷄鷁鶻鶸鶺鷆鷏鷂鷙鷓鷸鷦鷭鷯鷽鸚鸛鸞鹵鹹鹽麁麈麋麌麒麕麑麝麥麩麸麪麭靡黌黎黏黐黔黜點黝黠黥黨黯�黴黶黷黹黻黼黽鼇鼈皷鼕鼡鼬鼾齊齒齔齣齟齠齡齦齧齬齪齷齲齶龕龜龠堯槇遙瑤凜熙�������������������������������������������������������������������������������������������".split("");
for(j = 0; j != D[234].length; ++j) if(D[234][j].charCodeAt(0) !== 0xFFFD) { e[D[234][j]] = 59904 + j; d[59904 + j] = D[234][j];}
D[237] = "����������������������������������������������������������������纊褜鍈銈蓜俉炻昱棈鋹曻彅丨仡仼伀伃伹佖侒侊侚侔俍偀倢俿倞偆偰偂傔僴僘兊兤冝冾凬刕劜劦勀勛匀匇匤卲厓厲叝﨎咜咊咩哿喆坙坥垬埈埇﨏�塚增墲夋奓奛奝奣妤妺孖寀甯寘寬尞岦岺峵崧嵓﨑嵂嵭嶸嶹巐弡弴彧德忞恝悅悊惞惕愠惲愑愷愰憘戓抦揵摠撝擎敎昀昕昻昉昮昞昤晥晗晙晴晳暙暠暲暿曺朎朗杦枻桒柀栁桄棏﨓楨﨔榘槢樰橫橆橳橾櫢櫤毖氿汜沆汯泚洄涇浯涖涬淏淸淲淼渹湜渧渼溿澈澵濵瀅瀇瀨炅炫焏焄煜煆煇凞燁燾犱���".split("");
for(j = 0; j != D[237].length; ++j) if(D[237][j].charCodeAt(0) !== 0xFFFD) { e[D[237][j]] = 60672 + j; d[60672 + j] = D[237][j];}
D[238] = "����������������������������������������������������������������犾猤猪獷玽珉珖珣珒琇珵琦琪琩琮瑢璉璟甁畯皂皜皞皛皦益睆劯砡硎硤硺礰礼神祥禔福禛竑竧靖竫箞精絈絜綷綠緖繒罇羡羽茁荢荿菇菶葈蒴蕓蕙�蕫﨟薰蘒﨡蠇裵訒訷詹誧誾諟諸諶譓譿賰賴贒赶﨣軏﨤逸遧郞都鄕鄧釚釗釞釭釮釤釥鈆鈐鈊鈺鉀鈼鉎鉙鉑鈹鉧銧鉷鉸鋧鋗鋙鋐﨧鋕鋠鋓錥錡鋻﨨錞鋿錝錂鍰鍗鎤鏆鏞鏸鐱鑅鑈閒隆﨩隝隯霳霻靃靍靏靑靕顗顥飯飼餧館馞驎髙髜魵魲鮏鮱鮻鰀鵰鵫鶴鸙黑��ⅰⅱⅲⅳⅴⅵⅶⅷⅸⅹ￢￤＇＂���".split("");
for(j = 0; j != D[238].length; ++j) if(D[238][j].charCodeAt(0) !== 0xFFFD) { e[D[238][j]] = 60928 + j; d[60928 + j] = D[238][j];}
D[250] = "����������������������������������������������������������������ⅰⅱⅲⅳⅴⅵⅶⅷⅸⅹⅠⅡⅢⅣⅤⅥⅦⅧⅨⅩ￢￤＇＂㈱№℡∵纊褜鍈銈蓜俉炻昱棈鋹曻彅丨仡仼伀伃伹佖侒侊侚侔俍偀倢俿倞偆偰偂傔僴僘兊�兤冝冾凬刕劜劦勀勛匀匇匤卲厓厲叝﨎咜咊咩哿喆坙坥垬埈埇﨏塚增墲夋奓奛奝奣妤妺孖寀甯寘寬尞岦岺峵崧嵓﨑嵂嵭嶸嶹巐弡弴彧德忞恝悅悊惞惕愠惲愑愷愰憘戓抦揵摠撝擎敎昀昕昻昉昮昞昤晥晗晙晴晳暙暠暲暿曺朎朗杦枻桒柀栁桄棏﨓楨﨔榘槢樰橫橆橳橾櫢櫤毖氿汜沆汯泚洄涇浯���".split("");
for(j = 0; j != D[250].length; ++j) if(D[250][j].charCodeAt(0) !== 0xFFFD) { e[D[250][j]] = 64000 + j; d[64000 + j] = D[250][j];}
D[251] = "����������������������������������������������������������������涖涬淏淸淲淼渹湜渧渼溿澈澵濵瀅瀇瀨炅炫焏焄煜煆煇凞燁燾犱犾猤猪獷玽珉珖珣珒琇珵琦琪琩琮瑢璉璟甁畯皂皜皞皛皦益睆劯砡硎硤硺礰礼神�祥禔福禛竑竧靖竫箞精絈絜綷綠緖繒罇羡羽茁荢荿菇菶葈蒴蕓蕙蕫﨟薰蘒﨡蠇裵訒訷詹誧誾諟諸諶譓譿賰賴贒赶﨣軏﨤逸遧郞都鄕鄧釚釗釞釭釮釤釥鈆鈐鈊鈺鉀鈼鉎鉙鉑鈹鉧銧鉷鉸鋧鋗鋙鋐﨧鋕鋠鋓錥錡鋻﨨錞鋿錝錂鍰鍗鎤鏆鏞鏸鐱鑅鑈閒隆﨩隝隯霳霻靃靍靏靑靕顗顥飯飼餧館馞驎髙���".split("");
for(j = 0; j != D[251].length; ++j) if(D[251][j].charCodeAt(0) !== 0xFFFD) { e[D[251][j]] = 64256 + j; d[64256 + j] = D[251][j];}
D[252] = "����������������������������������������������������������������髜魵魲鮏鮱鮻鰀鵰鵫鶴鸙黑������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������".split("");
for(j = 0; j != D[252].length; ++j) if(D[252][j].charCodeAt(0) !== 0xFFFD) { e[D[252][j]] = 64512 + j; d[64512 + j] = D[252][j];}
return {"enc": e, "dec": d }; })();
cptable[936] = (function(){ var d = [], e = {}, D = [], j;
D[0] = "\u0000\u0001\u0002\u0003\u0004\u0005\u0006\u0007\b\t\n\u000b\f\r\u000e\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~€�������������������������������������������������������������������������������������������������������������������������������".split("");
for(j = 0; j != D[0].length; ++j) if(D[0][j].charCodeAt(0) !== 0xFFFD) { e[D[0][j]] = 0 + j; d[0 + j] = D[0][j];}
D[129] = "����������������������������������������������������������������丂丄丅丆丏丒丗丟丠両丣並丩丮丯丱丳丵丷丼乀乁乂乄乆乊乑乕乗乚乛乢乣乤乥乧乨乪乫乬乭乮乯乲乴乵乶乷乸乹乺乻乼乽乿亀亁亂亃亄亅亇亊�亐亖亗亙亜亝亞亣亪亯亰亱亴亶亷亸亹亼亽亾仈仌仏仐仒仚仛仜仠仢仦仧仩仭仮仯仱仴仸仹仺仼仾伀伂伃伄伅伆伇伈伋伌伒伓伔伕伖伜伝伡伣伨伩伬伭伮伱伳伵伷伹伻伾伿佀佁佂佄佅佇佈佉佊佋佌佒佔佖佡佢佦佨佪佫佭佮佱佲併佷佸佹佺佽侀侁侂侅來侇侊侌侎侐侒侓侕侖侘侙侚侜侞侟価侢�".split("");
for(j = 0; j != D[129].length; ++j) if(D[129][j].charCodeAt(0) !== 0xFFFD) { e[D[129][j]] = 33024 + j; d[33024 + j] = D[129][j];}
D[130] = "����������������������������������������������������������������侤侫侭侰侱侲侳侴侶侷侸侹侺侻侼侽侾俀俁係俆俇俈俉俋俌俍俒俓俔俕俖俙俛俠俢俤俥俧俫俬俰俲俴俵俶俷俹俻俼俽俿倀倁倂倃倄倅倆倇倈倉倊�個倎倐們倓倕倖倗倛倝倞倠倢倣値倧倫倯倰倱倲倳倴倵倶倷倸倹倻倽倿偀偁偂偄偅偆偉偊偋偍偐偑偒偓偔偖偗偘偙偛偝偞偟偠偡偢偣偤偦偧偨偩偪偫偭偮偯偰偱偲偳側偵偸偹偺偼偽傁傂傃傄傆傇傉傊傋傌傎傏傐傑傒傓傔傕傖傗傘備傚傛傜傝傞傟傠傡傢傤傦傪傫傭傮傯傰傱傳傴債傶傷傸傹傼�".split("");
for(j = 0; j != D[130].length; ++j) if(D[130][j].charCodeAt(0) !== 0xFFFD) { e[D[130][j]] = 33280 + j; d[33280 + j] = D[130][j];}
D[131] = "����������������������������������������������������������������傽傾傿僀僁僂僃僄僅僆僇僈僉僊僋僌働僎僐僑僒僓僔僕僗僘僙僛僜僝僞僟僠僡僢僣僤僥僨僩僪僫僯僰僱僲僴僶僷僸價僺僼僽僾僿儀儁儂儃億儅儈�儉儊儌儍儎儏儐儑儓儔儕儖儗儘儙儚儛儜儝儞償儠儢儣儤儥儦儧儨儩優儫儬儭儮儯儰儱儲儳儴儵儶儷儸儹儺儻儼儽儾兂兇兊兌兎兏児兒兓兗兘兙兛兝兞兟兠兡兣兤兦內兩兪兯兲兺兾兿冃冄円冇冊冋冎冏冐冑冓冔冘冚冝冞冟冡冣冦冧冨冩冪冭冮冴冸冹冺冾冿凁凂凃凅凈凊凍凎凐凒凓凔凕凖凗�".split("");
for(j = 0; j != D[131].length; ++j) if(D[131][j].charCodeAt(0) !== 0xFFFD) { e[D[131][j]] = 33536 + j; d[33536 + j] = D[131][j];}
D[132] = "����������������������������������������������������������������凘凙凚凜凞凟凢凣凥処凧凨凩凪凬凮凱凲凴凷凾刄刅刉刋刌刏刐刓刔刕刜刞刟刡刢刣別刦刧刪刬刯刱刲刴刵刼刾剄剅剆則剈剉剋剎剏剒剓剕剗剘�剙剚剛剝剟剠剢剣剤剦剨剫剬剭剮剰剱剳剴創剶剷剸剹剺剻剼剾劀劃劄劅劆劇劉劊劋劌劍劎劏劑劒劔劕劖劗劘劙劚劜劤劥劦劧劮劯劰労劵劶劷劸効劺劻劼劽勀勁勂勄勅勆勈勊勌勍勎勏勑勓勔動勗務勚勛勜勝勞勠勡勢勣勥勦勧勨勩勪勫勬勭勮勯勱勲勳勴勵勶勷勸勻勼勽匁匂匃匄匇匉匊匋匌匎�".split("");
for(j = 0; j != D[132].length; ++j) if(D[132][j].charCodeAt(0) !== 0xFFFD) { e[D[132][j]] = 33792 + j; d[33792 + j] = D[132][j];}
D[133] = "����������������������������������������������������������������匑匒匓匔匘匛匜匞匟匢匤匥匧匨匩匫匬匭匯匰匱匲匳匴匵匶匷匸匼匽區卂卄卆卋卌卍卐協単卙卛卝卥卨卪卬卭卲卶卹卻卼卽卾厀厁厃厇厈厊厎厏�厐厑厒厓厔厖厗厙厛厜厞厠厡厤厧厪厫厬厭厯厰厱厲厳厴厵厷厸厹厺厼厽厾叀參叄叅叆叇収叏叐叒叓叕叚叜叝叞叡叢叧叴叺叾叿吀吂吅吇吋吔吘吙吚吜吢吤吥吪吰吳吶吷吺吽吿呁呂呄呅呇呉呌呍呎呏呑呚呝呞呟呠呡呣呥呧呩呪呫呬呭呮呯呰呴呹呺呾呿咁咃咅咇咈咉咊咍咑咓咗咘咜咞咟咠咡�".split("");
for(j = 0; j != D[133].length; ++j) if(D[133][j].charCodeAt(0) !== 0xFFFD) { e[D[133][j]] = 34048 + j; d[34048 + j] = D[133][j];}
D[134] = "����������������������������������������������������������������咢咥咮咰咲咵咶咷咹咺咼咾哃哅哊哋哖哘哛哠員哢哣哤哫哬哯哰哱哴哵哶哷哸哹哻哾唀唂唃唄唅唈唊唋唌唍唎唒唓唕唖唗唘唙唚唜唝唞唟唡唥唦�唨唩唫唭唲唴唵唶唸唹唺唻唽啀啂啅啇啈啋啌啍啎問啑啒啓啔啗啘啙啚啛啝啞啟啠啢啣啨啩啫啯啰啱啲啳啴啹啺啽啿喅喆喌喍喎喐喒喓喕喖喗喚喛喞喠喡喢喣喤喥喦喨喩喪喫喬喭單喯喰喲喴営喸喺喼喿嗀嗁嗂嗃嗆嗇嗈嗊嗋嗎嗏嗐嗕嗗嗘嗙嗚嗛嗞嗠嗢嗧嗩嗭嗮嗰嗱嗴嗶嗸嗹嗺嗻嗼嗿嘂嘃嘄嘅�".split("");
for(j = 0; j != D[134].length; ++j) if(D[134][j].charCodeAt(0) !== 0xFFFD) { e[D[134][j]] = 34304 + j; d[34304 + j] = D[134][j];}
D[135] = "����������������������������������������������������������������嘆嘇嘊嘋嘍嘐嘑嘒嘓嘔嘕嘖嘗嘙嘚嘜嘝嘠嘡嘢嘥嘦嘨嘩嘪嘫嘮嘯嘰嘳嘵嘷嘸嘺嘼嘽嘾噀噁噂噃噄噅噆噇噈噉噊噋噏噐噑噒噓噕噖噚噛噝噞噟噠噡�噣噥噦噧噭噮噯噰噲噳噴噵噷噸噹噺噽噾噿嚀嚁嚂嚃嚄嚇嚈嚉嚊嚋嚌嚍嚐嚑嚒嚔嚕嚖嚗嚘嚙嚚嚛嚜嚝嚞嚟嚠嚡嚢嚤嚥嚦嚧嚨嚩嚪嚫嚬嚭嚮嚰嚱嚲嚳嚴嚵嚶嚸嚹嚺嚻嚽嚾嚿囀囁囂囃囄囅囆囇囈囉囋囌囍囎囏囐囑囒囓囕囖囘囙囜団囥囦囧囨囩囪囬囮囯囲図囶囷囸囻囼圀圁圂圅圇國圌圍圎圏圐圑�".split("");
for(j = 0; j != D[135].length; ++j) if(D[135][j].charCodeAt(0) !== 0xFFFD) { e[D[135][j]] = 34560 + j; d[34560 + j] = D[135][j];}
D[136] = "����������������������������������������������������������������園圓圔圕圖圗團圙圚圛圝圞圠圡圢圤圥圦圧圫圱圲圴圵圶圷圸圼圽圿坁坃坄坅坆坈坉坋坒坓坔坕坖坘坙坢坣坥坧坬坮坰坱坲坴坵坸坹坺坽坾坿垀�垁垇垈垉垊垍垎垏垐垑垔垕垖垗垘垙垚垜垝垞垟垥垨垪垬垯垰垱垳垵垶垷垹垺垻垼垽垾垿埀埁埄埅埆埇埈埉埊埌埍埐埑埓埖埗埛埜埞埡埢埣埥埦埧埨埩埪埫埬埮埰埱埲埳埵埶執埻埼埾埿堁堃堄堅堈堉堊堌堎堏堐堒堓堔堖堗堘堚堛堜堝堟堢堣堥堦堧堨堩堫堬堭堮堯報堲堳場堶堷堸堹堺堻堼堽�".split("");
for(j = 0; j != D[136].length; ++j) if(D[136][j].charCodeAt(0) !== 0xFFFD) { e[D[136][j]] = 34816 + j; d[34816 + j] = D[136][j];}
D[137] = "����������������������������������������������������������������堾堿塀塁塂塃塅塆塇塈塉塊塋塎塏塐塒塓塕塖塗塙塚塛塜塝塟塠塡塢塣塤塦塧塨塩塪塭塮塯塰塱塲塳塴塵塶塷塸塹塺塻塼塽塿墂墄墆墇墈墊墋墌�墍墎墏墐墑墔墕墖増墘墛墜墝墠墡墢墣墤墥墦墧墪墫墬墭墮墯墰墱墲墳墴墵墶墷墸墹墺墻墽墾墿壀壂壃壄壆壇壈壉壊壋壌壍壎壏壐壒壓壔壖壗壘壙壚壛壜壝壞壟壠壡壢壣壥壦壧壨壩壪壭壯壱売壴壵壷壸壺壻壼壽壾壿夀夁夃夅夆夈変夊夋夌夎夐夑夒夓夗夘夛夝夞夠夡夢夣夦夨夬夰夲夳夵夶夻�".split("");
for(j = 0; j != D[137].length; ++j) if(D[137][j].charCodeAt(0) !== 0xFFFD) { e[D[137][j]] = 35072 + j; d[35072 + j] = D[137][j];}
D[138] = "����������������������������������������������������������������夽夾夿奀奃奅奆奊奌奍奐奒奓奙奛奜奝奞奟奡奣奤奦奧奨奩奪奫奬奭奮奯奰奱奲奵奷奺奻奼奾奿妀妅妉妋妌妎妏妐妑妔妕妘妚妛妜妝妟妠妡妢妦�妧妬妭妰妱妳妴妵妶妷妸妺妼妽妿姀姁姂姃姄姅姇姈姉姌姍姎姏姕姖姙姛姞姟姠姡姢姤姦姧姩姪姫姭姮姯姰姱姲姳姴姵姶姷姸姺姼姽姾娀娂娊娋娍娎娏娐娒娔娕娖娗娙娚娛娝娞娡娢娤娦娧娨娪娫娬娭娮娯娰娳娵娷娸娹娺娻娽娾娿婁婂婃婄婅婇婈婋婌婍婎婏婐婑婒婓婔婖婗婘婙婛婜婝婞婟婠�".split("");
for(j = 0; j != D[138].length; ++j) if(D[138][j].charCodeAt(0) !== 0xFFFD) { e[D[138][j]] = 35328 + j; d[35328 + j] = D[138][j];}
D[139] = "����������������������������������������������������������������婡婣婤婥婦婨婩婫婬婭婮婯婰婱婲婳婸婹婻婼婽婾媀媁媂媃媄媅媆媇媈媉媊媋媌媍媎媏媐媑媓媔媕媖媗媘媙媜媝媞媟媠媡媢媣媤媥媦媧媨媩媫媬�媭媮媯媰媱媴媶媷媹媺媻媼媽媿嫀嫃嫄嫅嫆嫇嫈嫊嫋嫍嫎嫏嫐嫑嫓嫕嫗嫙嫚嫛嫝嫞嫟嫢嫤嫥嫧嫨嫪嫬嫭嫮嫯嫰嫲嫳嫴嫵嫶嫷嫸嫹嫺嫻嫼嫽嫾嫿嬀嬁嬂嬃嬄嬅嬆嬇嬈嬊嬋嬌嬍嬎嬏嬐嬑嬒嬓嬔嬕嬘嬙嬚嬛嬜嬝嬞嬟嬠嬡嬢嬣嬤嬥嬦嬧嬨嬩嬪嬫嬬嬭嬮嬯嬰嬱嬳嬵嬶嬸嬹嬺嬻嬼嬽嬾嬿孁孂孃孄孅孆孇�".split("");
for(j = 0; j != D[139].length; ++j) if(D[139][j].charCodeAt(0) !== 0xFFFD) { e[D[139][j]] = 35584 + j; d[35584 + j] = D[139][j];}
D[140] = "����������������������������������������������������������������孈孉孊孋孌孍孎孏孒孖孞孠孡孧孨孫孭孮孯孲孴孶孷學孹孻孼孾孿宂宆宊宍宎宐宑宒宔宖実宧宨宩宬宭宮宯宱宲宷宺宻宼寀寁寃寈寉寊寋寍寎寏�寑寔寕寖寗寘寙寚寛寜寠寢寣實寧審寪寫寬寭寯寱寲寳寴寵寶寷寽対尀専尃尅將專尋尌對導尐尒尓尗尙尛尞尟尠尡尣尦尨尩尪尫尭尮尯尰尲尳尵尶尷屃屄屆屇屌屍屒屓屔屖屗屘屚屛屜屝屟屢層屧屨屩屪屫屬屭屰屲屳屴屵屶屷屸屻屼屽屾岀岃岄岅岆岇岉岊岋岎岏岒岓岕岝岞岟岠岡岤岥岦岧岨�".split("");
for(j = 0; j != D[140].length; ++j) if(D[140][j].charCodeAt(0) !== 0xFFFD) { e[D[140][j]] = 35840 + j; d[35840 + j] = D[140][j];}
D[141] = "����������������������������������������������������������������岪岮岯岰岲岴岶岹岺岻岼岾峀峂峃峅峆峇峈峉峊峌峍峎峏峐峑峓峔峕峖峗峘峚峛峜峝峞峟峠峢峣峧峩峫峬峮峯峱峲峳峴峵島峷峸峹峺峼峽峾峿崀�崁崄崅崈崉崊崋崌崍崏崐崑崒崓崕崗崘崙崚崜崝崟崠崡崢崣崥崨崪崫崬崯崰崱崲崳崵崶崷崸崹崺崻崼崿嵀嵁嵂嵃嵄嵅嵆嵈嵉嵍嵎嵏嵐嵑嵒嵓嵔嵕嵖嵗嵙嵚嵜嵞嵟嵠嵡嵢嵣嵤嵥嵦嵧嵨嵪嵭嵮嵰嵱嵲嵳嵵嵶嵷嵸嵹嵺嵻嵼嵽嵾嵿嶀嶁嶃嶄嶅嶆嶇嶈嶉嶊嶋嶌嶍嶎嶏嶐嶑嶒嶓嶔嶕嶖嶗嶘嶚嶛嶜嶞嶟嶠�".split("");
for(j = 0; j != D[141].length; ++j) if(D[141][j].charCodeAt(0) !== 0xFFFD) { e[D[141][j]] = 36096 + j; d[36096 + j] = D[141][j];}
D[142] = "����������������������������������������������������������������嶡嶢嶣嶤嶥嶦嶧嶨嶩嶪嶫嶬嶭嶮嶯嶰嶱嶲嶳嶴嶵嶶嶸嶹嶺嶻嶼嶽嶾嶿巀巁巂巃巄巆巇巈巉巊巋巌巎巏巐巑巒巓巔巕巖巗巘巙巚巜巟巠巣巤巪巬巭�巰巵巶巸巹巺巻巼巿帀帄帇帉帊帋帍帎帒帓帗帞帟帠帡帢帣帤帥帨帩帪師帬帯帰帲帳帴帵帶帹帺帾帿幀幁幃幆幇幈幉幊幋幍幎幏幐幑幒幓幖幗幘幙幚幜幝幟幠幣幤幥幦幧幨幩幪幫幬幭幮幯幰幱幵幷幹幾庁庂広庅庈庉庌庍庎庒庘庛庝庡庢庣庤庨庩庪庫庬庮庯庰庱庲庴庺庻庼庽庿廀廁廂廃廄廅�".split("");
for(j = 0; j != D[142].length; ++j) if(D[142][j].charCodeAt(0) !== 0xFFFD) { e[D[142][j]] = 36352 + j; d[36352 + j] = D[142][j];}
D[143] = "����������������������������������������������������������������廆廇廈廋廌廍廎廏廐廔廕廗廘廙廚廜廝廞廟廠廡廢廣廤廥廦廧廩廫廬廭廮廯廰廱廲廳廵廸廹廻廼廽弅弆弇弉弌弍弎弐弒弔弖弙弚弜弝弞弡弢弣弤�弨弫弬弮弰弲弳弴張弶強弸弻弽弾弿彁彂彃彄彅彆彇彈彉彊彋彌彍彎彏彑彔彙彚彛彜彞彟彠彣彥彧彨彫彮彯彲彴彵彶彸彺彽彾彿徃徆徍徎徏徑従徔徖徚徛徝從徟徠徢徣徤徥徦徧復徫徬徯徰徱徲徳徴徶徸徹徺徻徾徿忀忁忂忇忈忊忋忎忓忔忕忚忛応忞忟忢忣忥忦忨忩忬忯忰忲忳忴忶忷忹忺忼怇�".split("");
for(j = 0; j != D[143].length; ++j) if(D[143][j].charCodeAt(0) !== 0xFFFD) { e[D[143][j]] = 36608 + j; d[36608 + j] = D[143][j];}
D[144] = "����������������������������������������������������������������怈怉怋怌怐怑怓怗怘怚怞怟怢怣怤怬怭怮怰怱怲怳怴怶怷怸怹怺怽怾恀恄恅恆恇恈恉恊恌恎恏恑恓恔恖恗恘恛恜恞恟恠恡恥恦恮恱恲恴恵恷恾悀�悁悂悅悆悇悈悊悋悎悏悐悑悓悕悗悘悙悜悞悡悢悤悥悧悩悪悮悰悳悵悶悷悹悺悽悾悿惀惁惂惃惄惇惈惉惌惍惎惏惐惒惓惔惖惗惙惛惞惡惢惣惤惥惪惱惲惵惷惸惻惼惽惾惿愂愃愄愅愇愊愋愌愐愑愒愓愔愖愗愘愙愛愜愝愞愡愢愥愨愩愪愬愭愮愯愰愱愲愳愴愵愶愷愸愹愺愻愼愽愾慀慁慂慃慄慅慆�".split("");
for(j = 0; j != D[144].length; ++j) if(D[144][j].charCodeAt(0) !== 0xFFFD) { e[D[144][j]] = 36864 + j; d[36864 + j] = D[144][j];}
D[145] = "����������������������������������������������������������������慇慉態慍慏慐慒慓慔慖慗慘慙慚慛慜慞慟慠慡慣慤慥慦慩慪慫慬慭慮慯慱慲慳慴慶慸慹慺慻慼慽慾慿憀憁憂憃憄憅憆憇憈憉憊憌憍憏憐憑憒憓憕�憖憗憘憙憚憛憜憞憟憠憡憢憣憤憥憦憪憫憭憮憯憰憱憲憳憴憵憶憸憹憺憻憼憽憿懀懁懃懄懅懆懇應懌懍懎懏懐懓懕懖懗懘懙懚懛懜懝懞懟懠懡懢懣懤懥懧懨懩懪懫懬懭懮懯懰懱懲懳懴懶懷懸懹懺懻懼懽懾戀戁戂戃戄戅戇戉戓戔戙戜戝戞戠戣戦戧戨戩戫戭戯戰戱戲戵戶戸戹戺戻戼扂扄扅扆扊�".split("");
for(j = 0; j != D[145].length; ++j) if(D[145][j].charCodeAt(0) !== 0xFFFD) { e[D[145][j]] = 37120 + j; d[37120 + j] = D[145][j];}
D[146] = "����������������������������������������������������������������扏扐払扖扗扙扚扜扝扞扟扠扡扢扤扥扨扱扲扴扵扷扸扺扻扽抁抂抃抅抆抇抈抋抌抍抎抏抐抔抙抜抝択抣抦抧抩抪抭抮抯抰抲抳抴抶抷抸抺抾拀拁�拃拋拏拑拕拝拞拠拡拤拪拫拰拲拵拸拹拺拻挀挃挄挅挆挊挋挌挍挏挐挒挓挔挕挗挘挙挜挦挧挩挬挭挮挰挱挳挴挵挶挷挸挻挼挾挿捀捁捄捇捈捊捑捒捓捔捖捗捘捙捚捛捜捝捠捤捥捦捨捪捫捬捯捰捲捳捴捵捸捹捼捽捾捿掁掃掄掅掆掋掍掑掓掔掕掗掙掚掛掜掝掞掟採掤掦掫掯掱掲掵掶掹掻掽掿揀�".split("");
for(j = 0; j != D[146].length; ++j) if(D[146][j].charCodeAt(0) !== 0xFFFD) { e[D[146][j]] = 37376 + j; d[37376 + j] = D[146][j];}
D[147] = "����������������������������������������������������������������揁揂揃揅揇揈揊揋揌揑揓揔揕揗揘揙揚換揜揝揟揢揤揥揦揧揨揫揬揮揯揰揱揳揵揷揹揺揻揼揾搃搄搆搇搈搉搊損搎搑搒搕搖搗搘搙搚搝搟搢搣搤�搥搧搨搩搫搮搯搰搱搲搳搵搶搷搸搹搻搼搾摀摂摃摉摋摌摍摎摏摐摑摓摕摖摗摙摚摛摜摝摟摠摡摢摣摤摥摦摨摪摫摬摮摯摰摱摲摳摴摵摶摷摻摼摽摾摿撀撁撃撆撈撉撊撋撌撍撎撏撐撓撔撗撘撚撛撜撝撟撠撡撢撣撥撦撧撨撪撫撯撱撲撳撴撶撹撻撽撾撿擁擃擄擆擇擈擉擊擋擌擏擑擓擔擕擖擙據�".split("");
for(j = 0; j != D[147].length; ++j) if(D[147][j].charCodeAt(0) !== 0xFFFD) { e[D[147][j]] = 37632 + j; d[37632 + j] = D[147][j];}
D[148] = "����������������������������������������������������������������擛擜擝擟擠擡擣擥擧擨擩擪擫擬擭擮擯擰擱擲擳擴擵擶擷擸擹擺擻擼擽擾擿攁攂攃攄攅攆攇攈攊攋攌攍攎攏攐攑攓攔攕攖攗攙攚攛攜攝攞攟攠攡�攢攣攤攦攧攨攩攪攬攭攰攱攲攳攷攺攼攽敀敁敂敃敄敆敇敊敋敍敎敐敒敓敔敗敘敚敜敟敠敡敤敥敧敨敩敪敭敮敯敱敳敵敶數敹敺敻敼敽敾敿斀斁斂斃斄斅斆斈斉斊斍斎斏斒斔斕斖斘斚斝斞斠斢斣斦斨斪斬斮斱斲斳斴斵斶斷斸斺斻斾斿旀旂旇旈旉旊旍旐旑旓旔旕旘旙旚旛旜旝旞旟旡旣旤旪旫�".split("");
for(j = 0; j != D[148].length; ++j) if(D[148][j].charCodeAt(0) !== 0xFFFD) { e[D[148][j]] = 37888 + j; d[37888 + j] = D[148][j];}
D[149] = "����������������������������������������������������������������旲旳旴旵旸旹旻旼旽旾旿昁昄昅昇昈昉昋昍昐昑昒昖昗昘昚昛昜昞昡昢昣昤昦昩昪昫昬昮昰昲昳昷昸昹昺昻昽昿晀時晄晅晆晇晈晉晊晍晎晐晑晘�晙晛晜晝晞晠晢晣晥晧晩晪晫晬晭晱晲晳晵晸晹晻晼晽晿暀暁暃暅暆暈暉暊暋暍暎暏暐暒暓暔暕暘暙暚暛暜暞暟暠暡暢暣暤暥暦暩暪暫暬暭暯暰暱暲暳暵暶暷暸暺暻暼暽暿曀曁曂曃曄曅曆曇曈曉曊曋曌曍曎曏曐曑曒曓曔曕曖曗曘曚曞曟曠曡曢曣曤曥曧曨曪曫曬曭曮曯曱曵曶書曺曻曽朁朂會�".split("");
for(j = 0; j != D[149].length; ++j) if(D[149][j].charCodeAt(0) !== 0xFFFD) { e[D[149][j]] = 38144 + j; d[38144 + j] = D[149][j];}
D[150] = "����������������������������������������������������������������朄朅朆朇朌朎朏朑朒朓朖朘朙朚朜朞朠朡朢朣朤朥朧朩朮朰朲朳朶朷朸朹朻朼朾朿杁杄杅杇杊杋杍杒杔杕杗杘杙杚杛杝杢杣杤杦杧杫杬杮東杴杶�杸杹杺杻杽枀枂枃枅枆枈枊枌枍枎枏枑枒枓枔枖枙枛枟枠枡枤枦枩枬枮枱枲枴枹枺枻枼枽枾枿柀柂柅柆柇柈柉柊柋柌柍柎柕柖柗柛柟柡柣柤柦柧柨柪柫柭柮柲柵柶柷柸柹柺査柼柾栁栂栃栄栆栍栐栒栔栕栘栙栚栛栜栞栟栠栢栣栤栥栦栧栨栫栬栭栮栯栰栱栴栵栶栺栻栿桇桋桍桏桒桖桗桘桙桚桛�".split("");
for(j = 0; j != D[150].length; ++j) if(D[150][j].charCodeAt(0) !== 0xFFFD) { e[D[150][j]] = 38400 + j; d[38400 + j] = D[150][j];}
D[151] = "����������������������������������������������������������������桜桝桞桟桪桬桭桮桯桰桱桲桳桵桸桹桺桻桼桽桾桿梀梂梄梇梈梉梊梋梌梍梎梐梑梒梔梕梖梘梙梚梛梜條梞梟梠梡梣梤梥梩梪梫梬梮梱梲梴梶梷梸�梹梺梻梼梽梾梿棁棃棄棅棆棇棈棊棌棎棏棐棑棓棔棖棗棙棛棜棝棞棟棡棢棤棥棦棧棨棩棪棫棬棭棯棲棳棴棶棷棸棻棽棾棿椀椂椃椄椆椇椈椉椊椌椏椑椓椔椕椖椗椘椙椚椛検椝椞椡椢椣椥椦椧椨椩椪椫椬椮椯椱椲椳椵椶椷椸椺椻椼椾楀楁楃楄楅楆楇楈楉楊楋楌楍楎楏楐楑楒楓楕楖楘楙楛楜楟�".split("");
for(j = 0; j != D[151].length; ++j) if(D[151][j].charCodeAt(0) !== 0xFFFD) { e[D[151][j]] = 38656 + j; d[38656 + j] = D[151][j];}
D[152] = "����������������������������������������������������������������楡楢楤楥楧楨楩楪楬業楯楰楲楳楴極楶楺楻楽楾楿榁榃榅榊榋榌榎榏榐榑榒榓榖榗榙榚榝榞榟榠榡榢榣榤榥榦榩榪榬榮榯榰榲榳榵榶榸榹榺榼榽�榾榿槀槂槃槄槅槆槇槈槉構槍槏槑槒槓槕槖槗様槙槚槜槝槞槡槢槣槤槥槦槧槨槩槪槫槬槮槯槰槱槳槴槵槶槷槸槹槺槻槼槾樀樁樂樃樄樅樆樇樈樉樋樌樍樎樏樐樑樒樓樔樕樖標樚樛樜樝樞樠樢樣樤樥樦樧権樫樬樭樮樰樲樳樴樶樷樸樹樺樻樼樿橀橁橂橃橅橆橈橉橊橋橌橍橎橏橑橒橓橔橕橖橗橚�".split("");
for(j = 0; j != D[152].length; ++j) if(D[152][j].charCodeAt(0) !== 0xFFFD) { e[D[152][j]] = 38912 + j; d[38912 + j] = D[152][j];}
D[153] = "����������������������������������������������������������������橜橝橞機橠橢橣橤橦橧橨橩橪橫橬橭橮橯橰橲橳橴橵橶橷橸橺橻橽橾橿檁檂檃檅檆檇檈檉檊檋檌檍檏檒檓檔檕檖檘檙檚檛檜檝檞檟檡檢檣檤檥檦�檧檨檪檭檮檯檰檱檲檳檴檵檶檷檸檹檺檻檼檽檾檿櫀櫁櫂櫃櫄櫅櫆櫇櫈櫉櫊櫋櫌櫍櫎櫏櫐櫑櫒櫓櫔櫕櫖櫗櫘櫙櫚櫛櫜櫝櫞櫟櫠櫡櫢櫣櫤櫥櫦櫧櫨櫩櫪櫫櫬櫭櫮櫯櫰櫱櫲櫳櫴櫵櫶櫷櫸櫹櫺櫻櫼櫽櫾櫿欀欁欂欃欄欅欆欇欈欉權欋欌欍欎欏欐欑欒欓欔欕欖欗欘欙欚欛欜欝欞欟欥欦欨欩欪欫欬欭欮�".split("");
for(j = 0; j != D[153].length; ++j) if(D[153][j].charCodeAt(0) !== 0xFFFD) { e[D[153][j]] = 39168 + j; d[39168 + j] = D[153][j];}
D[154] = "����������������������������������������������������������������欯欰欱欳欴欵欶欸欻欼欽欿歀歁歂歄歅歈歊歋歍歎歏歐歑歒歓歔歕歖歗歘歚歛歜歝歞歟歠歡歨歩歫歬歭歮歯歰歱歲歳歴歵歶歷歸歺歽歾歿殀殅殈�殌殎殏殐殑殔殕殗殘殙殜殝殞殟殠殢殣殤殥殦殧殨殩殫殬殭殮殯殰殱殲殶殸殹殺殻殼殽殾毀毃毄毆毇毈毉毊毌毎毐毑毘毚毜毝毞毟毠毢毣毤毥毦毧毨毩毬毭毮毰毱毲毴毶毷毸毺毻毼毾毿氀氁氂氃氄氈氉氊氋氌氎氒気氜氝氞氠氣氥氫氬氭氱氳氶氷氹氺氻氼氾氿汃汄汅汈汋汌汍汎汏汑汒汓汖汘�".split("");
for(j = 0; j != D[154].length; ++j) if(D[154][j].charCodeAt(0) !== 0xFFFD) { e[D[154][j]] = 39424 + j; d[39424 + j] = D[154][j];}
D[155] = "����������������������������������������������������������������汙汚汢汣汥汦汧汫汬汭汮汯汱汳汵汷汸決汻汼汿沀沄沇沊沋沍沎沑沒沕沖沗沘沚沜沝沞沠沢沨沬沯沰沴沵沶沷沺泀況泂泃泆泇泈泋泍泎泏泑泒泘�泙泚泜泝泟泤泦泧泩泬泭泲泴泹泿洀洂洃洅洆洈洉洊洍洏洐洑洓洔洕洖洘洜洝洟洠洡洢洣洤洦洨洩洬洭洯洰洴洶洷洸洺洿浀浂浄浉浌浐浕浖浗浘浛浝浟浡浢浤浥浧浨浫浬浭浰浱浲浳浵浶浹浺浻浽浾浿涀涁涃涄涆涇涊涋涍涏涐涒涖涗涘涙涚涜涢涥涬涭涰涱涳涴涶涷涹涺涻涼涽涾淁淂淃淈淉淊�".split("");
for(j = 0; j != D[155].length; ++j) if(D[155][j].charCodeAt(0) !== 0xFFFD) { e[D[155][j]] = 39680 + j; d[39680 + j] = D[155][j];}
D[156] = "����������������������������������������������������������������淍淎淏淐淒淓淔淕淗淚淛淜淟淢淣淥淧淨淩淪淭淯淰淲淴淵淶淸淺淽淾淿渀渁渂渃渄渆渇済渉渋渏渒渓渕渘渙減渜渞渟渢渦渧渨渪測渮渰渱渳渵�渶渷渹渻渼渽渾渿湀湁湂湅湆湇湈湉湊湋湌湏湐湑湒湕湗湙湚湜湝湞湠湡湢湣湤湥湦湧湨湩湪湬湭湯湰湱湲湳湴湵湶湷湸湹湺湻湼湽満溁溂溄溇溈溊溋溌溍溎溑溒溓溔溕準溗溙溚溛溝溞溠溡溣溤溦溨溩溫溬溭溮溰溳溵溸溹溼溾溿滀滃滄滅滆滈滉滊滌滍滎滐滒滖滘滙滛滜滝滣滧滪滫滬滭滮滯�".split("");
for(j = 0; j != D[156].length; ++j) if(D[156][j].charCodeAt(0) !== 0xFFFD) { e[D[156][j]] = 39936 + j; d[39936 + j] = D[156][j];}
D[157] = "����������������������������������������������������������������滰滱滲滳滵滶滷滸滺滻滼滽滾滿漀漁漃漄漅漇漈漊漋漌漍漎漐漑漒漖漗漘漙漚漛漜漝漞漟漡漢漣漥漦漧漨漬漮漰漲漴漵漷漸漹漺漻漼漽漿潀潁潂�潃潄潅潈潉潊潌潎潏潐潑潒潓潔潕潖潗潙潚潛潝潟潠潡潣潤潥潧潨潩潪潫潬潯潰潱潳潵潶潷潹潻潽潾潿澀澁澂澃澅澆澇澊澋澏澐澑澒澓澔澕澖澗澘澙澚澛澝澞澟澠澢澣澤澥澦澨澩澪澫澬澭澮澯澰澱澲澴澵澷澸澺澻澼澽澾澿濁濃濄濅濆濇濈濊濋濌濍濎濏濐濓濔濕濖濗濘濙濚濛濜濝濟濢濣濤濥�".split("");
for(j = 0; j != D[157].length; ++j) if(D[157][j].charCodeAt(0) !== 0xFFFD) { e[D[157][j]] = 40192 + j; d[40192 + j] = D[157][j];}
D[158] = "����������������������������������������������������������������濦濧濨濩濪濫濬濭濰濱濲濳濴濵濶濷濸濹濺濻濼濽濾濿瀀瀁瀂瀃瀄瀅瀆瀇瀈瀉瀊瀋瀌瀍瀎瀏瀐瀒瀓瀔瀕瀖瀗瀘瀙瀜瀝瀞瀟瀠瀡瀢瀤瀥瀦瀧瀨瀩瀪�瀫瀬瀭瀮瀯瀰瀱瀲瀳瀴瀶瀷瀸瀺瀻瀼瀽瀾瀿灀灁灂灃灄灅灆灇灈灉灊灋灍灎灐灑灒灓灔灕灖灗灘灙灚灛灜灝灟灠灡灢灣灤灥灦灧灨灩灪灮灱灲灳灴灷灹灺灻災炁炂炃炄炆炇炈炋炌炍炏炐炑炓炗炘炚炛炞炟炠炡炢炣炤炥炦炧炨炩炪炰炲炴炵炶為炾炿烄烅烆烇烉烋烌烍烎烏烐烑烒烓烔烕烖烗烚�".split("");
for(j = 0; j != D[158].length; ++j) if(D[158][j].charCodeAt(0) !== 0xFFFD) { e[D[158][j]] = 40448 + j; d[40448 + j] = D[158][j];}
D[159] = "����������������������������������������������������������������烜烝烞烠烡烢烣烥烪烮烰烱烲烳烴烵烶烸烺烻烼烾烿焀焁焂焃焄焅焆焇焈焋焌焍焎焏焑焒焔焗焛焜焝焞焟焠無焢焣焤焥焧焨焩焪焫焬焭焮焲焳焴�焵焷焸焹焺焻焼焽焾焿煀煁煂煃煄煆煇煈煉煋煍煏煐煑煒煓煔煕煖煗煘煙煚煛煝煟煠煡煢煣煥煩煪煫煬煭煯煰煱煴煵煶煷煹煻煼煾煿熀熁熂熃熅熆熇熈熉熋熌熍熎熐熑熒熓熕熖熗熚熛熜熝熞熡熢熣熤熥熦熧熩熪熫熭熮熯熰熱熲熴熶熷熸熺熻熼熽熾熿燀燁燂燄燅燆燇燈燉燊燋燌燍燏燐燑燒燓�".split("");
for(j = 0; j != D[159].length; ++j) if(D[159][j].charCodeAt(0) !== 0xFFFD) { e[D[159][j]] = 40704 + j; d[40704 + j] = D[159][j];}
D[160] = "����������������������������������������������������������������燖燗燘燙燚燛燜燝燞營燡燢燣燤燦燨燩燪燫燬燭燯燰燱燲燳燴燵燶燷燸燺燻燼燽燾燿爀爁爂爃爄爅爇爈爉爊爋爌爍爎爏爐爑爒爓爔爕爖爗爘爙爚�爛爜爞爟爠爡爢爣爤爥爦爧爩爫爭爮爯爲爳爴爺爼爾牀牁牂牃牄牅牆牉牊牋牎牏牐牑牓牔牕牗牘牚牜牞牠牣牤牥牨牪牫牬牭牰牱牳牴牶牷牸牻牼牽犂犃犅犆犇犈犉犌犎犐犑犓犔犕犖犗犘犙犚犛犜犝犞犠犡犢犣犤犥犦犧犨犩犪犫犮犱犲犳犵犺犻犼犽犾犿狀狅狆狇狉狊狋狌狏狑狓狔狕狖狘狚狛�".split("");
for(j = 0; j != D[160].length; ++j) if(D[160][j].charCodeAt(0) !== 0xFFFD) { e[D[160][j]] = 40960 + j; d[40960 + j] = D[160][j];}
D[161] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������　、。·ˉˇ¨〃々—～‖…‘’“”〔〕〈〉《》「」『』〖〗【】±×÷∶∧∨∑∏∪∩∈∷√⊥∥∠⌒⊙∫∮≡≌≈∽∝≠≮≯≤≥∞∵∴♂♀°′″℃＄¤￠￡‰§№☆★○●◎◇◆□■△▲※→←↑↓〓�".split("");
for(j = 0; j != D[161].length; ++j) if(D[161][j].charCodeAt(0) !== 0xFFFD) { e[D[161][j]] = 41216 + j; d[41216 + j] = D[161][j];}
D[162] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������ⅰⅱⅲⅳⅴⅵⅶⅷⅸⅹ������⒈⒉⒊⒋⒌⒍⒎⒏⒐⒑⒒⒓⒔⒕⒖⒗⒘⒙⒚⒛⑴⑵⑶⑷⑸⑹⑺⑻⑼⑽⑾⑿⒀⒁⒂⒃⒄⒅⒆⒇①②③④⑤⑥⑦⑧⑨⑩��㈠㈡㈢㈣㈤㈥㈦㈧㈨㈩��ⅠⅡⅢⅣⅤⅥⅦⅧⅨⅩⅪⅫ���".split("");
for(j = 0; j != D[162].length; ++j) if(D[162][j].charCodeAt(0) !== 0xFFFD) { e[D[162][j]] = 41472 + j; d[41472 + j] = D[162][j];}
D[163] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������！＂＃￥％＆＇（）＊＋，－．／０１２３４５６７８９：；＜＝＞？＠ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ［＼］＾＿｀ａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ｛｜｝￣�".split("");
for(j = 0; j != D[163].length; ++j) if(D[163][j].charCodeAt(0) !== 0xFFFD) { e[D[163][j]] = 41728 + j; d[41728 + j] = D[163][j];}
D[164] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������ぁあぃいぅうぇえぉおかがきぎくぐけげこごさざしじすずせぜそぞただちぢっつづてでとどなにぬねのはばぱひびぴふぶぷへべぺほぼぽまみむめもゃやゅゆょよらりるれろゎわゐゑをん������������".split("");
for(j = 0; j != D[164].length; ++j) if(D[164][j].charCodeAt(0) !== 0xFFFD) { e[D[164][j]] = 41984 + j; d[41984 + j] = D[164][j];}
D[165] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������ァアィイゥウェエォオカガキギクグケゲコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶ���������".split("");
for(j = 0; j != D[165].length; ++j) if(D[165][j].charCodeAt(0) !== 0xFFFD) { e[D[165][j]] = 42240 + j; d[42240 + j] = D[165][j];}
D[166] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩ��������αβγδεζηθικλμνξοπρστυφχψω�������︵︶︹︺︿﹀︽︾﹁﹂﹃﹄��︻︼︷︸︱�︳︴����������".split("");
for(j = 0; j != D[166].length; ++j) if(D[166][j].charCodeAt(0) !== 0xFFFD) { e[D[166][j]] = 42496 + j; d[42496 + j] = D[166][j];}
D[167] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ���������������абвгдеёжзийклмнопрстуфхцчшщъыьэюя��������������".split("");
for(j = 0; j != D[167].length; ++j) if(D[167][j].charCodeAt(0) !== 0xFFFD) { e[D[167][j]] = 42752 + j; d[42752 + j] = D[167][j];}
D[168] = "����������������������������������������������������������������ˊˋ˙–―‥‵℅℉↖↗↘↙∕∟∣≒≦≧⊿═║╒╓╔╕╖╗╘╙╚╛╜╝╞╟╠╡╢╣╤╥╦╧╨╩╪╫╬╭╮╯╰╱╲╳▁▂▃▄▅▆▇�█▉▊▋▌▍▎▏▓▔▕▼▽◢◣◤◥☉⊕〒〝〞�����������āáǎàēéěèīíǐìōóǒòūúǔùǖǘǚǜüêɑ�ńň�ɡ����ㄅㄆㄇㄈㄉㄊㄋㄌㄍㄎㄏㄐㄑㄒㄓㄔㄕㄖㄗㄘㄙㄚㄛㄜㄝㄞㄟㄠㄡㄢㄣㄤㄥㄦㄧㄨㄩ����������������������".split("");
for(j = 0; j != D[168].length; ++j) if(D[168][j].charCodeAt(0) !== 0xFFFD) { e[D[168][j]] = 43008 + j; d[43008 + j] = D[168][j];}
D[169] = "����������������������������������������������������������������〡〢〣〤〥〦〧〨〩㊣㎎㎏㎜㎝㎞㎡㏄㏎㏑㏒㏕︰￢￤�℡㈱�‐���ー゛゜ヽヾ〆ゝゞ﹉﹊﹋﹌﹍﹎﹏﹐﹑﹒﹔﹕﹖﹗﹙﹚﹛﹜﹝﹞﹟﹠﹡�﹢﹣﹤﹥﹦﹨﹩﹪﹫�������������〇�������������─━│┃┄┅┆┇┈┉┊┋┌┍┎┏┐┑┒┓└┕┖┗┘┙┚┛├┝┞┟┠┡┢┣┤┥┦┧┨┩┪┫┬┭┮┯┰┱┲┳┴┵┶┷┸┹┺┻┼┽┾┿╀╁╂╃╄╅╆╇╈╉╊╋����������������".split("");
for(j = 0; j != D[169].length; ++j) if(D[169][j].charCodeAt(0) !== 0xFFFD) { e[D[169][j]] = 43264 + j; d[43264 + j] = D[169][j];}
D[170] = "����������������������������������������������������������������狜狝狟狢狣狤狥狦狧狪狫狵狶狹狽狾狿猀猂猄猅猆猇猈猉猋猌猍猏猐猑猒猔猘猙猚猟猠猣猤猦猧猨猭猯猰猲猳猵猶猺猻猼猽獀獁獂獃獄獅獆獇獈�獉獊獋獌獎獏獑獓獔獕獖獘獙獚獛獜獝獞獟獡獢獣獤獥獦獧獨獩獪獫獮獰獱�����������������������������������������������������������������������������������������������".split("");
for(j = 0; j != D[170].length; ++j) if(D[170][j].charCodeAt(0) !== 0xFFFD) { e[D[170][j]] = 43520 + j; d[43520 + j] = D[170][j];}
D[171] = "����������������������������������������������������������������獲獳獴獵獶獷獸獹獺獻獼獽獿玀玁玂玃玅玆玈玊玌玍玏玐玒玓玔玕玗玘玙玚玜玝玞玠玡玣玤玥玦玧玨玪玬玭玱玴玵玶玸玹玼玽玾玿珁珃珄珅珆珇�珋珌珎珒珓珔珕珖珗珘珚珛珜珝珟珡珢珣珤珦珨珪珫珬珮珯珰珱珳珴珵珶珷�����������������������������������������������������������������������������������������������".split("");
for(j = 0; j != D[171].length; ++j) if(D[171][j].charCodeAt(0) !== 0xFFFD) { e[D[171][j]] = 43776 + j; d[43776 + j] = D[171][j];}
D[172] = "����������������������������������������������������������������珸珹珺珻珼珽現珿琀琁琂琄琇琈琋琌琍琎琑琒琓琔琕琖琗琘琙琜琝琞琟琠琡琣琤琧琩琫琭琯琱琲琷琸琹琺琻琽琾琿瑀瑂瑃瑄瑅瑆瑇瑈瑉瑊瑋瑌瑍�瑎瑏瑐瑑瑒瑓瑔瑖瑘瑝瑠瑡瑢瑣瑤瑥瑦瑧瑨瑩瑪瑫瑬瑮瑯瑱瑲瑳瑴瑵瑸瑹瑺�����������������������������������������������������������������������������������������������".split("");
for(j = 0; j != D[172].length; ++j) if(D[172][j].charCodeAt(0) !== 0xFFFD) { e[D[172][j]] = 44032 + j; d[44032 + j] = D[172][j];}
D[173] = "����������������������������������������������������������������瑻瑼瑽瑿璂璄璅璆璈璉璊璌璍璏璑璒璓璔璕璖璗璘璙璚璛璝璟璠璡璢璣璤璥璦璪璫璬璭璮璯環璱璲璳璴璵璶璷璸璹璻璼璽璾璿瓀瓁瓂瓃瓄瓅瓆瓇�瓈瓉瓊瓋瓌瓍瓎瓏瓐瓑瓓瓔瓕瓖瓗瓘瓙瓚瓛瓝瓟瓡瓥瓧瓨瓩瓪瓫瓬瓭瓰瓱瓲�����������������������������������������������������������������������������������������������".split("");
for(j = 0; j != D[173].length; ++j) if(D[173][j].charCodeAt(0) !== 0xFFFD) { e[D[173][j]] = 44288 + j; d[44288 + j] = D[173][j];}
D[174] = "����������������������������������������������������������������瓳瓵瓸瓹瓺瓻瓼瓽瓾甀甁甂甃甅甆甇甈甉甊甋甌甎甐甒甔甕甖甗甛甝甞甠甡產産甤甦甧甪甮甴甶甹甼甽甿畁畂畃畄畆畇畉畊畍畐畑畒畓畕畖畗畘�畝畞畟畠畡畢畣畤畧畨畩畫畬畭畮畯異畱畳畵當畷畺畻畼畽畾疀疁疂疄疅疇�����������������������������������������������������������������������������������������������".split("");
for(j = 0; j != D[174].length; ++j) if(D[174][j].charCodeAt(0) !== 0xFFFD) { e[D[174][j]] = 44544 + j; d[44544 + j] = D[174][j];}
D[175] = "����������������������������������������������������������������疈疉疊疌疍疎疐疓疕疘疛疜疞疢疦疧疨疩疪疭疶疷疺疻疿痀痁痆痋痌痎痏痐痑痓痗痙痚痜痝痟痠痡痥痩痬痭痮痯痲痳痵痶痷痸痺痻痽痾瘂瘄瘆瘇�瘈瘉瘋瘍瘎瘏瘑瘒瘓瘔瘖瘚瘜瘝瘞瘡瘣瘧瘨瘬瘮瘯瘱瘲瘶瘷瘹瘺瘻瘽癁療癄�����������������������������������������������������������������������������������������������".split("");
for(j = 0; j != D[175].length; ++j) if(D[175][j].charCodeAt(0) !== 0xFFFD) { e[D[175][j]] = 44800 + j; d[44800 + j] = D[175][j];}
D[176] = "����������������������������������������������������������������癅癆癇癈癉癊癋癎癏癐癑癒癓癕癗癘癙癚癛癝癟癠癡癢癤癥癦癧癨癩癪癬癭癮癰癱癲癳癴癵癶癷癹発發癿皀皁皃皅皉皊皌皍皏皐皒皔皕皗皘皚皛�皜皝皞皟皠皡皢皣皥皦皧皨皩皪皫皬皭皯皰皳皵皶皷皸皹皺皻皼皽皾盀盁盃啊阿埃挨哎唉哀皑癌蔼矮艾碍爱隘鞍氨安俺按暗岸胺案肮昂盎凹敖熬翱袄傲奥懊澳芭捌扒叭吧笆八疤巴拔跋靶把耙坝霸罢爸白柏百摆佰败拜稗斑班搬扳般颁板版扮拌伴瓣半办绊邦帮梆榜膀绑棒磅蚌镑傍谤苞胞包褒剥�".split("");
for(j = 0; j != D[176].length; ++j) if(D[176][j].charCodeAt(0) !== 0xFFFD) { e[D[176][j]] = 45056 + j; d[45056 + j] = D[176][j];}
D[177] = "����������������������������������������������������������������盄盇盉盋盌盓盕盙盚盜盝盞盠盡盢監盤盦盧盨盩盪盫盬盭盰盳盵盶盷盺盻盽盿眀眂眃眅眆眊県眎眏眐眑眒眓眔眕眖眗眘眛眜眝眞眡眣眤眥眧眪眫�眬眮眰眱眲眳眴眹眻眽眾眿睂睄睅睆睈睉睊睋睌睍睎睏睒睓睔睕睖睗睘睙睜薄雹保堡饱宝抱报暴豹鲍爆杯碑悲卑北辈背贝钡倍狈备惫焙被奔苯本笨崩绷甭泵蹦迸逼鼻比鄙笔彼碧蓖蔽毕毙毖币庇痹闭敝弊必辟壁臂避陛鞭边编贬扁便变卞辨辩辫遍标彪膘表鳖憋别瘪彬斌濒滨宾摈兵冰柄丙秉饼炳�".split("");
for(j = 0; j != D[177].length; ++j) if(D[177][j].charCodeAt(0) !== 0xFFFD) { e[D[177][j]] = 45312 + j; d[45312 + j] = D[177][j];}
D[178] = "����������������������������������������������������������������睝睞睟睠睤睧睩睪睭睮睯睰睱睲睳睴睵睶睷睸睺睻睼瞁瞂瞃瞆瞇瞈瞉瞊瞋瞏瞐瞓瞔瞕瞖瞗瞘瞙瞚瞛瞜瞝瞞瞡瞣瞤瞦瞨瞫瞭瞮瞯瞱瞲瞴瞶瞷瞸瞹瞺�瞼瞾矀矁矂矃矄矅矆矇矈矉矊矋矌矎矏矐矑矒矓矔矕矖矘矙矚矝矞矟矠矡矤病并玻菠播拨钵波博勃搏铂箔伯帛舶脖膊渤泊驳捕卜哺补埠不布步簿部怖擦猜裁材才财睬踩采彩菜蔡餐参蚕残惭惨灿苍舱仓沧藏操糙槽曹草厕策侧册测层蹭插叉茬茶查碴搽察岔差诧拆柴豺搀掺蝉馋谗缠铲产阐颤昌猖�".split("");
for(j = 0; j != D[178].length; ++j) if(D[178][j].charCodeAt(0) !== 0xFFFD) { e[D[178][j]] = 45568 + j; d[45568 + j] = D[178][j];}
D[179] = "����������������������������������������������������������������矦矨矪矯矰矱矲矴矵矷矹矺矻矼砃砄砅砆砇砈砊砋砎砏砐砓砕砙砛砞砠砡砢砤砨砪砫砮砯砱砲砳砵砶砽砿硁硂硃硄硆硈硉硊硋硍硏硑硓硔硘硙硚�硛硜硞硟硠硡硢硣硤硥硦硧硨硩硯硰硱硲硳硴硵硶硸硹硺硻硽硾硿碀碁碂碃场尝常长偿肠厂敞畅唱倡超抄钞朝嘲潮巢吵炒车扯撤掣彻澈郴臣辰尘晨忱沉陈趁衬撑称城橙成呈乘程惩澄诚承逞骋秤吃痴持匙池迟弛驰耻齿侈尺赤翅斥炽充冲虫崇宠抽酬畴踌稠愁筹仇绸瞅丑臭初出橱厨躇锄雏滁除楚�".split("");
for(j = 0; j != D[179].length; ++j) if(D[179][j].charCodeAt(0) !== 0xFFFD) { e[D[179][j]] = 45824 + j; d[45824 + j] = D[179][j];}
D[180] = "����������������������������������������������������������������碄碅碆碈碊碋碏碐碒碔碕碖碙碝碞碠碢碤碦碨碩碪碫碬碭碮碯碵碶碷碸確碻碼碽碿磀磂磃磄磆磇磈磌磍磎磏磑磒磓磖磗磘磚磛磜磝磞磟磠磡磢磣�磤磥磦磧磩磪磫磭磮磯磰磱磳磵磶磸磹磻磼磽磾磿礀礂礃礄礆礇礈礉礊礋礌础储矗搐触处揣川穿椽传船喘串疮窗幢床闯创吹炊捶锤垂春椿醇唇淳纯蠢戳绰疵茨磁雌辞慈瓷词此刺赐次聪葱囱匆从丛凑粗醋簇促蹿篡窜摧崔催脆瘁粹淬翠村存寸磋撮搓措挫错搭达答瘩打大呆歹傣戴带殆代贷袋待逮�".split("");
for(j = 0; j != D[180].length; ++j) if(D[180][j].charCodeAt(0) !== 0xFFFD) { e[D[180][j]] = 46080 + j; d[46080 + j] = D[180][j];}
D[181] = "����������������������������������������������������������������礍礎礏礐礑礒礔礕礖礗礘礙礚礛礜礝礟礠礡礢礣礥礦礧礨礩礪礫礬礭礮礯礰礱礲礳礵礶礷礸礹礽礿祂祃祄祅祇祊祋祌祍祎祏祐祑祒祔祕祘祙祡祣�祤祦祩祪祫祬祮祰祱祲祳祴祵祶祹祻祼祽祾祿禂禃禆禇禈禉禋禌禍禎禐禑禒怠耽担丹单郸掸胆旦氮但惮淡诞弹蛋当挡党荡档刀捣蹈倒岛祷导到稻悼道盗德得的蹬灯登等瞪凳邓堤低滴迪敌笛狄涤翟嫡抵底地蒂第帝弟递缔颠掂滇碘点典靛垫电佃甸店惦奠淀殿碉叼雕凋刁掉吊钓调跌爹碟蝶迭谍叠�".split("");
for(j = 0; j != D[181].length; ++j) if(D[181][j].charCodeAt(0) !== 0xFFFD) { e[D[181][j]] = 46336 + j; d[46336 + j] = D[181][j];}
D[182] = "����������������������������������������������������������������禓禔禕禖禗禘禙禛禜禝禞禟禠禡禢禣禤禥禦禨禩禪禫禬禭禮禯禰禱禲禴禵禶禷禸禼禿秂秄秅秇秈秊秌秎秏秐秓秔秖秗秙秚秛秜秝秞秠秡秢秥秨秪�秬秮秱秲秳秴秵秶秷秹秺秼秾秿稁稄稅稇稈稉稊稌稏稐稑稒稓稕稖稘稙稛稜丁盯叮钉顶鼎锭定订丢东冬董懂动栋侗恫冻洞兜抖斗陡豆逗痘都督毒犊独读堵睹赌杜镀肚度渡妒端短锻段断缎堆兑队对墩吨蹲敦顿囤钝盾遁掇哆多夺垛躲朵跺舵剁惰堕蛾峨鹅俄额讹娥恶厄扼遏鄂饿恩而儿耳尔饵洱二�".split("");
for(j = 0; j != D[182].length; ++j) if(D[182][j].charCodeAt(0) !== 0xFFFD) { e[D[182][j]] = 46592 + j; d[46592 + j] = D[182][j];}
D[183] = "����������������������������������������������������������������稝稟稡稢稤稥稦稧稨稩稪稫稬稭種稯稰稱稲稴稵稶稸稺稾穀穁穂穃穄穅穇穈穉穊穋穌積穎穏穐穒穓穔穕穖穘穙穚穛穜穝穞穟穠穡穢穣穤穥穦穧穨�穩穪穫穬穭穮穯穱穲穳穵穻穼穽穾窂窅窇窉窊窋窌窎窏窐窓窔窙窚窛窞窡窢贰发罚筏伐乏阀法珐藩帆番翻樊矾钒繁凡烦反返范贩犯饭泛坊芳方肪房防妨仿访纺放菲非啡飞肥匪诽吠肺废沸费芬酚吩氛分纷坟焚汾粉奋份忿愤粪丰封枫蜂峰锋风疯烽逢冯缝讽奉凤佛否夫敷肤孵扶拂辐幅氟符伏俘服�".split("");
for(j = 0; j != D[183].length; ++j) if(D[183][j].charCodeAt(0) !== 0xFFFD) { e[D[183][j]] = 46848 + j; d[46848 + j] = D[183][j];}
D[184] = "����������������������������������������������������������������窣窤窧窩窪窫窮窯窰窱窲窴窵窶窷窸窹窺窻窼窽窾竀竁竂竃竄竅竆竇竈竉竊竌竍竎竏竐竑竒竓竔竕竗竘竚竛竜竝竡竢竤竧竨竩竪竫竬竮竰竱竲竳�竴竵競竷竸竻竼竾笀笁笂笅笇笉笌笍笎笐笒笓笖笗笘笚笜笝笟笡笢笣笧笩笭浮涪福袱弗甫抚辅俯釜斧脯腑府腐赴副覆赋复傅付阜父腹负富讣附妇缚咐噶嘎该改概钙盖溉干甘杆柑竿肝赶感秆敢赣冈刚钢缸肛纲岗港杠篙皋高膏羔糕搞镐稿告哥歌搁戈鸽胳疙割革葛格蛤阁隔铬个各给根跟耕更庚羹�".split("");
for(j = 0; j != D[184].length; ++j) if(D[184][j].charCodeAt(0) !== 0xFFFD) { e[D[184][j]] = 47104 + j; d[47104 + j] = D[184][j];}
D[185] = "����������������������������������������������������������������笯笰笲笴笵笶笷笹笻笽笿筀筁筂筃筄筆筈筊筍筎筓筕筗筙筜筞筟筡筣筤筥筦筧筨筩筪筫筬筭筯筰筳筴筶筸筺筼筽筿箁箂箃箄箆箇箈箉箊箋箌箎箏�箑箒箓箖箘箙箚箛箞箟箠箣箤箥箮箯箰箲箳箵箶箷箹箺箻箼箽箾箿節篂篃範埂耿梗工攻功恭龚供躬公宫弓巩汞拱贡共钩勾沟苟狗垢构购够辜菇咕箍估沽孤姑鼓古蛊骨谷股故顾固雇刮瓜剐寡挂褂乖拐怪棺关官冠观管馆罐惯灌贯光广逛瑰规圭硅归龟闺轨鬼诡癸桂柜跪贵刽辊滚棍锅郭国果裹过哈�".split("");
for(j = 0; j != D[185].length; ++j) if(D[185][j].charCodeAt(0) !== 0xFFFD) { e[D[185][j]] = 47360 + j; d[47360 + j] = D[185][j];}
D[186] = "����������������������������������������������������������������篅篈築篊篋篍篎篏篐篒篔篕篖篗篘篛篜篞篟篠篢篣篤篧篨篩篫篬篭篯篰篲篳篴篵篶篸篹篺篻篽篿簀簁簂簃簄簅簆簈簉簊簍簎簐簑簒簓簔簕簗簘簙�簚簛簜簝簞簠簡簢簣簤簥簨簩簫簬簭簮簯簰簱簲簳簴簵簶簷簹簺簻簼簽簾籂骸孩海氦亥害骇酣憨邯韩含涵寒函喊罕翰撼捍旱憾悍焊汗汉夯杭航壕嚎豪毫郝好耗号浩呵喝荷菏核禾和何合盒貉阂河涸赫褐鹤贺嘿黑痕很狠恨哼亨横衡恒轰哄烘虹鸿洪宏弘红喉侯猴吼厚候后呼乎忽瑚壶葫胡蝴狐糊湖�".split("");
for(j = 0; j != D[186].length; ++j) if(D[186][j].charCodeAt(0) !== 0xFFFD) { e[D[186][j]] = 47616 + j; d[47616 + j] = D[186][j];}
D[187] = "����������������������������������������������������������������籃籄籅籆籇籈籉籊籋籌籎籏籐籑籒籓籔籕籖籗籘籙籚籛籜籝籞籟籠籡籢籣籤籥籦籧籨籩籪籫籬籭籮籯籰籱籲籵籶籷籸籹籺籾籿粀粁粂粃粄粅粆粇�粈粊粋粌粍粎粏粐粓粔粖粙粚粛粠粡粣粦粧粨粩粫粬粭粯粰粴粵粶粷粸粺粻弧虎唬护互沪户花哗华猾滑画划化话槐徊怀淮坏欢环桓还缓换患唤痪豢焕涣宦幻荒慌黄磺蝗簧皇凰惶煌晃幌恍谎灰挥辉徽恢蛔回毁悔慧卉惠晦贿秽会烩汇讳诲绘荤昏婚魂浑混豁活伙火获或惑霍货祸击圾基机畸稽积箕�".split("");
for(j = 0; j != D[187].length; ++j) if(D[187][j].charCodeAt(0) !== 0xFFFD) { e[D[187][j]] = 47872 + j; d[47872 + j] = D[187][j];}
D[188] = "����������������������������������������������������������������粿糀糂糃糄糆糉糋糎糏糐糑糒糓糔糘糚糛糝糞糡糢糣糤糥糦糧糩糪糫糬糭糮糰糱糲糳糴糵糶糷糹糺糼糽糾糿紀紁紂紃約紅紆紇紈紉紋紌納紎紏紐�紑紒紓純紕紖紗紘紙級紛紜紝紞紟紡紣紤紥紦紨紩紪紬紭紮細紱紲紳紴紵紶肌饥迹激讥鸡姬绩缉吉极棘辑籍集及急疾汲即嫉级挤几脊己蓟技冀季伎祭剂悸济寄寂计记既忌际妓继纪嘉枷夹佳家加荚颊贾甲钾假稼价架驾嫁歼监坚尖笺间煎兼肩艰奸缄茧检柬碱硷拣捡简俭剪减荐槛鉴践贱见键箭件�".split("");
for(j = 0; j != D[188].length; ++j) if(D[188][j].charCodeAt(0) !== 0xFFFD) { e[D[188][j]] = 48128 + j; d[48128 + j] = D[188][j];}
D[189] = "����������������������������������������������������������������紷紸紹紺紻紼紽紾紿絀絁終絃組絅絆絇絈絉絊絋経絍絎絏結絑絒絓絔絕絖絗絘絙絚絛絜絝絞絟絠絡絢絣絤絥給絧絨絩絪絫絬絭絯絰統絲絳絴絵絶�絸絹絺絻絼絽絾絿綀綁綂綃綄綅綆綇綈綉綊綋綌綍綎綏綐綑綒經綔綕綖綗綘健舰剑饯渐溅涧建僵姜将浆江疆蒋桨奖讲匠酱降蕉椒礁焦胶交郊浇骄娇嚼搅铰矫侥脚狡角饺缴绞剿教酵轿较叫窖揭接皆秸街阶截劫节桔杰捷睫竭洁结解姐戒藉芥界借介疥诫届巾筋斤金今津襟紧锦仅谨进靳晋禁近烬浸�".split("");
for(j = 0; j != D[189].length; ++j) if(D[189][j].charCodeAt(0) !== 0xFFFD) { e[D[189][j]] = 48384 + j; d[48384 + j] = D[189][j];}
D[190] = "����������������������������������������������������������������継続綛綜綝綞綟綠綡綢綣綤綥綧綨綩綪綫綬維綯綰綱網綳綴綵綶綷綸綹綺綻綼綽綾綿緀緁緂緃緄緅緆緇緈緉緊緋緌緍緎総緐緑緒緓緔緕緖緗緘緙�線緛緜緝緞緟締緡緢緣緤緥緦緧編緩緪緫緬緭緮緯緰緱緲緳練緵緶緷緸緹緺尽劲荆兢茎睛晶鲸京惊精粳经井警景颈静境敬镜径痉靖竟竞净炯窘揪究纠玖韭久灸九酒厩救旧臼舅咎就疚鞠拘狙疽居驹菊局咀矩举沮聚拒据巨具距踞锯俱句惧炬剧捐鹃娟倦眷卷绢撅攫抉掘倔爵觉决诀绝均菌钧军君峻�".split("");
for(j = 0; j != D[190].length; ++j) if(D[190][j].charCodeAt(0) !== 0xFFFD) { e[D[190][j]] = 48640 + j; d[48640 + j] = D[190][j];}
D[191] = "����������������������������������������������������������������緻緼緽緾緿縀縁縂縃縄縅縆縇縈縉縊縋縌縍縎縏縐縑縒縓縔縕縖縗縘縙縚縛縜縝縞縟縠縡縢縣縤縥縦縧縨縩縪縫縬縭縮縯縰縱縲縳縴縵縶縷縸縹�縺縼總績縿繀繂繃繄繅繆繈繉繊繋繌繍繎繏繐繑繒繓織繕繖繗繘繙繚繛繜繝俊竣浚郡骏喀咖卡咯开揩楷凯慨刊堪勘坎砍看康慷糠扛抗亢炕考拷烤靠坷苛柯棵磕颗科壳咳可渴克刻客课肯啃垦恳坑吭空恐孔控抠口扣寇枯哭窟苦酷库裤夸垮挎跨胯块筷侩快宽款匡筐狂框矿眶旷况亏盔岿窥葵奎魁傀�".split("");
for(j = 0; j != D[191].length; ++j) if(D[191][j].charCodeAt(0) !== 0xFFFD) { e[D[191][j]] = 48896 + j; d[48896 + j] = D[191][j];}
D[192] = "����������������������������������������������������������������繞繟繠繡繢繣繤繥繦繧繨繩繪繫繬繭繮繯繰繱繲繳繴繵繶繷繸繹繺繻繼繽繾繿纀纁纃纄纅纆纇纈纉纊纋續纍纎纏纐纑纒纓纔纕纖纗纘纙纚纜纝纞�纮纴纻纼绖绤绬绹缊缐缞缷缹缻缼缽缾缿罀罁罃罆罇罈罉罊罋罌罍罎罏罒罓馈愧溃坤昆捆困括扩廓阔垃拉喇蜡腊辣啦莱来赖蓝婪栏拦篮阑兰澜谰揽览懒缆烂滥琅榔狼廊郎朗浪捞劳牢老佬姥酪烙涝勒乐雷镭蕾磊累儡垒擂肋类泪棱楞冷厘梨犁黎篱狸离漓理李里鲤礼莉荔吏栗丽厉励砾历利傈例俐�".split("");
for(j = 0; j != D[192].length; ++j) if(D[192][j].charCodeAt(0) !== 0xFFFD) { e[D[192][j]] = 49152 + j; d[49152 + j] = D[192][j];}
D[193] = "����������������������������������������������������������������罖罙罛罜罝罞罠罣罤罥罦罧罫罬罭罯罰罳罵罶罷罸罺罻罼罽罿羀羂羃羄羅羆羇羈羉羋羍羏羐羑羒羓羕羖羗羘羙羛羜羠羢羣羥羦羨義羪羫羬羭羮羱�羳羴羵羶羷羺羻羾翀翂翃翄翆翇翈翉翋翍翏翐翑習翓翖翗翙翚翛翜翝翞翢翣痢立粒沥隶力璃哩俩联莲连镰廉怜涟帘敛脸链恋炼练粮凉梁粱良两辆量晾亮谅撩聊僚疗燎寥辽潦了撂镣廖料列裂烈劣猎琳林磷霖临邻鳞淋凛赁吝拎玲菱零龄铃伶羚凌灵陵岭领另令溜琉榴硫馏留刘瘤流柳六龙聋咙笼窿�".split("");
for(j = 0; j != D[193].length; ++j) if(D[193][j].charCodeAt(0) !== 0xFFFD) { e[D[193][j]] = 49408 + j; d[49408 + j] = D[193][j];}
D[194] = "����������������������������������������������������������������翤翧翨翪翫翬翭翯翲翴翵翶翷翸翹翺翽翾翿耂耇耈耉耊耎耏耑耓耚耛耝耞耟耡耣耤耫耬耭耮耯耰耲耴耹耺耼耾聀聁聄聅聇聈聉聎聏聐聑聓聕聖聗�聙聛聜聝聞聟聠聡聢聣聤聥聦聧聨聫聬聭聮聯聰聲聳聴聵聶職聸聹聺聻聼聽隆垄拢陇楼娄搂篓漏陋芦卢颅庐炉掳卤虏鲁麓碌露路赂鹿潞禄录陆戮驴吕铝侣旅履屡缕虑氯律率滤绿峦挛孪滦卵乱掠略抡轮伦仑沦纶论萝螺罗逻锣箩骡裸落洛骆络妈麻玛码蚂马骂嘛吗埋买麦卖迈脉瞒馒蛮满蔓曼慢漫�".split("");
for(j = 0; j != D[194].length; ++j) if(D[194][j].charCodeAt(0) !== 0xFFFD) { e[D[194][j]] = 49664 + j; d[49664 + j] = D[194][j];}
D[195] = "����������������������������������������������������������������聾肁肂肅肈肊肍肎肏肐肑肒肔肕肗肙肞肣肦肧肨肬肰肳肵肶肸肹肻胅胇胈胉胊胋胏胐胑胒胓胔胕胘胟胠胢胣胦胮胵胷胹胻胾胿脀脁脃脄脅脇脈脋�脌脕脗脙脛脜脝脟脠脡脢脣脤脥脦脧脨脩脪脫脭脮脰脳脴脵脷脹脺脻脼脽脿谩芒茫盲氓忙莽猫茅锚毛矛铆卯茂冒帽貌贸么玫枚梅酶霉煤没眉媒镁每美昧寐妹媚门闷们萌蒙檬盟锰猛梦孟眯醚靡糜迷谜弥米秘觅泌蜜密幂棉眠绵冕免勉娩缅面苗描瞄藐秒渺庙妙蔑灭民抿皿敏悯闽明螟鸣铭名命谬摸�".split("");
for(j = 0; j != D[195].length; ++j) if(D[195][j].charCodeAt(0) !== 0xFFFD) { e[D[195][j]] = 49920 + j; d[49920 + j] = D[195][j];}
D[196] = "����������������������������������������������������������������腀腁腂腃腄腅腇腉腍腎腏腒腖腗腘腛腜腝腞腟腡腢腣腤腦腨腪腫腬腯腲腳腵腶腷腸膁膃膄膅膆膇膉膋膌膍膎膐膒膓膔膕膖膗膙膚膞膟膠膡膢膤膥�膧膩膫膬膭膮膯膰膱膲膴膵膶膷膸膹膼膽膾膿臄臅臇臈臉臋臍臎臏臐臑臒臓摹蘑模膜磨摩魔抹末莫墨默沫漠寞陌谋牟某拇牡亩姆母墓暮幕募慕木目睦牧穆拿哪呐钠那娜纳氖乃奶耐奈南男难囊挠脑恼闹淖呢馁内嫩能妮霓倪泥尼拟你匿腻逆溺蔫拈年碾撵捻念娘酿鸟尿捏聂孽啮镊镍涅您柠狞凝宁�".split("");
for(j = 0; j != D[196].length; ++j) if(D[196][j].charCodeAt(0) !== 0xFFFD) { e[D[196][j]] = 50176 + j; d[50176 + j] = D[196][j];}
D[197] = "����������������������������������������������������������������臔臕臖臗臘臙臚臛臜臝臞臟臠臡臢臤臥臦臨臩臫臮臯臰臱臲臵臶臷臸臹臺臽臿舃與興舉舊舋舎舏舑舓舕舖舗舘舙舚舝舠舤舥舦舧舩舮舲舺舼舽舿�艀艁艂艃艅艆艈艊艌艍艎艐艑艒艓艔艕艖艗艙艛艜艝艞艠艡艢艣艤艥艦艧艩拧泞牛扭钮纽脓浓农弄奴努怒女暖虐疟挪懦糯诺哦欧鸥殴藕呕偶沤啪趴爬帕怕琶拍排牌徘湃派攀潘盘磐盼畔判叛乓庞旁耪胖抛咆刨炮袍跑泡呸胚培裴赔陪配佩沛喷盆砰抨烹澎彭蓬棚硼篷膨朋鹏捧碰坯砒霹批披劈琵毗�".split("");
for(j = 0; j != D[197].length; ++j) if(D[197][j].charCodeAt(0) !== 0xFFFD) { e[D[197][j]] = 50432 + j; d[50432 + j] = D[197][j];}
D[198] = "����������������������������������������������������������������艪艫艬艭艱艵艶艷艸艻艼芀芁芃芅芆芇芉芌芐芓芔芕芖芚芛芞芠芢芣芧芲芵芶芺芻芼芿苀苂苃苅苆苉苐苖苙苚苝苢苧苨苩苪苬苭苮苰苲苳苵苶苸�苺苼苽苾苿茀茊茋茍茐茒茓茖茘茙茝茞茟茠茡茢茣茤茥茦茩茪茮茰茲茷茻茽啤脾疲皮匹痞僻屁譬篇偏片骗飘漂瓢票撇瞥拼频贫品聘乒坪苹萍平凭瓶评屏坡泼颇婆破魄迫粕剖扑铺仆莆葡菩蒲埔朴圃普浦谱曝瀑期欺栖戚妻七凄漆柒沏其棋奇歧畦崎脐齐旗祈祁骑起岂乞企启契砌器气迄弃汽泣讫掐�".split("");
for(j = 0; j != D[198].length; ++j) if(D[198][j].charCodeAt(0) !== 0xFFFD) { e[D[198][j]] = 50688 + j; d[50688 + j] = D[198][j];}
D[199] = "����������������������������������������������������������������茾茿荁荂荄荅荈荊荋荌荍荎荓荕荖荗荘荙荝荢荰荱荲荳荴荵荶荹荺荾荿莀莁莂莃莄莇莈莊莋莌莍莏莐莑莔莕莖莗莙莚莝莟莡莢莣莤莥莦莧莬莭莮�莯莵莻莾莿菂菃菄菆菈菉菋菍菎菐菑菒菓菕菗菙菚菛菞菢菣菤菦菧菨菫菬菭恰洽牵扦钎铅千迁签仟谦乾黔钱钳前潜遣浅谴堑嵌欠歉枪呛腔羌墙蔷强抢橇锹敲悄桥瞧乔侨巧鞘撬翘峭俏窍切茄且怯窃钦侵亲秦琴勤芹擒禽寝沁青轻氢倾卿清擎晴氰情顷请庆琼穷秋丘邱球求囚酋泅趋区蛆曲躯屈驱渠�".split("");
for(j = 0; j != D[199].length; ++j) if(D[199][j].charCodeAt(0) !== 0xFFFD) { e[D[199][j]] = 50944 + j; d[50944 + j] = D[199][j];}
D[200] = "����������������������������������������������������������������菮華菳菴菵菶菷菺菻菼菾菿萀萂萅萇萈萉萊萐萒萓萔萕萖萗萙萚萛萞萟萠萡萢萣萩萪萫萬萭萮萯萰萲萳萴萵萶萷萹萺萻萾萿葀葁葂葃葄葅葇葈葉�葊葋葌葍葎葏葐葒葓葔葕葖葘葝葞葟葠葢葤葥葦葧葨葪葮葯葰葲葴葷葹葻葼取娶龋趣去圈颧权醛泉全痊拳犬券劝缺炔瘸却鹊榷确雀裙群然燃冉染瓤壤攘嚷让饶扰绕惹热壬仁人忍韧任认刃妊纫扔仍日戎茸蓉荣融熔溶容绒冗揉柔肉茹蠕儒孺如辱乳汝入褥软阮蕊瑞锐闰润若弱撒洒萨腮鳃塞赛三叁�".split("");
for(j = 0; j != D[200].length; ++j) if(D[200][j].charCodeAt(0) !== 0xFFFD) { e[D[200][j]] = 51200 + j; d[51200 + j] = D[200][j];}
D[201] = "����������������������������������������������������������������葽葾葿蒀蒁蒃蒄蒅蒆蒊蒍蒏蒐蒑蒒蒓蒔蒕蒖蒘蒚蒛蒝蒞蒟蒠蒢蒣蒤蒥蒦蒧蒨蒩蒪蒫蒬蒭蒮蒰蒱蒳蒵蒶蒷蒻蒼蒾蓀蓂蓃蓅蓆蓇蓈蓋蓌蓎蓏蓒蓔蓕蓗�蓘蓙蓚蓛蓜蓞蓡蓢蓤蓧蓨蓩蓪蓫蓭蓮蓯蓱蓲蓳蓴蓵蓶蓷蓸蓹蓺蓻蓽蓾蔀蔁蔂伞散桑嗓丧搔骚扫嫂瑟色涩森僧莎砂杀刹沙纱傻啥煞筛晒珊苫杉山删煽衫闪陕擅赡膳善汕扇缮墒伤商赏晌上尚裳梢捎稍烧芍勺韶少哨邵绍奢赊蛇舌舍赦摄射慑涉社设砷申呻伸身深娠绅神沈审婶甚肾慎渗声生甥牲升绳�".split("");
for(j = 0; j != D[201].length; ++j) if(D[201][j].charCodeAt(0) !== 0xFFFD) { e[D[201][j]] = 51456 + j; d[51456 + j] = D[201][j];}
D[202] = "����������������������������������������������������������������蔃蔄蔅蔆蔇蔈蔉蔊蔋蔍蔎蔏蔐蔒蔔蔕蔖蔘蔙蔛蔜蔝蔞蔠蔢蔣蔤蔥蔦蔧蔨蔩蔪蔭蔮蔯蔰蔱蔲蔳蔴蔵蔶蔾蔿蕀蕁蕂蕄蕅蕆蕇蕋蕌蕍蕎蕏蕐蕑蕒蕓蕔蕕�蕗蕘蕚蕛蕜蕝蕟蕠蕡蕢蕣蕥蕦蕧蕩蕪蕫蕬蕭蕮蕯蕰蕱蕳蕵蕶蕷蕸蕼蕽蕿薀薁省盛剩胜圣师失狮施湿诗尸虱十石拾时什食蚀实识史矢使屎驶始式示士世柿事拭誓逝势是嗜噬适仕侍释饰氏市恃室视试收手首守寿授售受瘦兽蔬枢梳殊抒输叔舒淑疏书赎孰熟薯暑曙署蜀黍鼠属术述树束戍竖墅庶数漱�".split("");
for(j = 0; j != D[202].length; ++j) if(D[202][j].charCodeAt(0) !== 0xFFFD) { e[D[202][j]] = 51712 + j; d[51712 + j] = D[202][j];}
D[203] = "����������������������������������������������������������������薂薃薆薈薉薊薋薌薍薎薐薑薒薓薔薕薖薗薘薙薚薝薞薟薠薡薢薣薥薦薧薩薫薬薭薱薲薳薴薵薶薸薺薻薼薽薾薿藀藂藃藄藅藆藇藈藊藋藌藍藎藑藒�藔藖藗藘藙藚藛藝藞藟藠藡藢藣藥藦藧藨藪藫藬藭藮藯藰藱藲藳藴藵藶藷藸恕刷耍摔衰甩帅栓拴霜双爽谁水睡税吮瞬顺舜说硕朔烁斯撕嘶思私司丝死肆寺嗣四伺似饲巳松耸怂颂送宋讼诵搜艘擞嗽苏酥俗素速粟僳塑溯宿诉肃酸蒜算虽隋随绥髓碎岁穗遂隧祟孙损笋蓑梭唆缩琐索锁所塌他它她塔�".split("");
for(j = 0; j != D[203].length; ++j) if(D[203][j].charCodeAt(0) !== 0xFFFD) { e[D[203][j]] = 51968 + j; d[51968 + j] = D[203][j];}
D[204] = "����������������������������������������������������������������藹藺藼藽藾蘀蘁蘂蘃蘄蘆蘇蘈蘉蘊蘋蘌蘍蘎蘏蘐蘒蘓蘔蘕蘗蘘蘙蘚蘛蘜蘝蘞蘟蘠蘡蘢蘣蘤蘥蘦蘨蘪蘫蘬蘭蘮蘯蘰蘱蘲蘳蘴蘵蘶蘷蘹蘺蘻蘽蘾蘿虀�虁虂虃虄虅虆虇虈虉虊虋虌虒虓處虖虗虘虙虛虜虝號虠虡虣虤虥虦虧虨虩虪獭挞蹋踏胎苔抬台泰酞太态汰坍摊贪瘫滩坛檀痰潭谭谈坦毯袒碳探叹炭汤塘搪堂棠膛唐糖倘躺淌趟烫掏涛滔绦萄桃逃淘陶讨套特藤腾疼誊梯剔踢锑提题蹄啼体替嚏惕涕剃屉天添填田甜恬舔腆挑条迢眺跳贴铁帖厅听烃�".split("");
for(j = 0; j != D[204].length; ++j) if(D[204][j].charCodeAt(0) !== 0xFFFD) { e[D[204][j]] = 52224 + j; d[52224 + j] = D[204][j];}
D[205] = "����������������������������������������������������������������虭虯虰虲虳虴虵虶虷虸蚃蚄蚅蚆蚇蚈蚉蚎蚏蚐蚑蚒蚔蚖蚗蚘蚙蚚蚛蚞蚟蚠蚡蚢蚥蚦蚫蚭蚮蚲蚳蚷蚸蚹蚻蚼蚽蚾蚿蛁蛂蛃蛅蛈蛌蛍蛒蛓蛕蛖蛗蛚蛜�蛝蛠蛡蛢蛣蛥蛦蛧蛨蛪蛫蛬蛯蛵蛶蛷蛺蛻蛼蛽蛿蜁蜄蜅蜆蜋蜌蜎蜏蜐蜑蜔蜖汀廷停亭庭挺艇通桐酮瞳同铜彤童桶捅筒统痛偷投头透凸秃突图徒途涂屠土吐兔湍团推颓腿蜕褪退吞屯臀拖托脱鸵陀驮驼椭妥拓唾挖哇蛙洼娃瓦袜歪外豌弯湾玩顽丸烷完碗挽晚皖惋宛婉万腕汪王亡枉网往旺望忘妄威�".split("");
for(j = 0; j != D[205].length; ++j) if(D[205][j].charCodeAt(0) !== 0xFFFD) { e[D[205][j]] = 52480 + j; d[52480 + j] = D[205][j];}
D[206] = "����������������������������������������������������������������蜙蜛蜝蜟蜠蜤蜦蜧蜨蜪蜫蜬蜭蜯蜰蜲蜳蜵蜶蜸蜹蜺蜼蜽蝀蝁蝂蝃蝄蝅蝆蝊蝋蝍蝏蝐蝑蝒蝔蝕蝖蝘蝚蝛蝜蝝蝞蝟蝡蝢蝦蝧蝨蝩蝪蝫蝬蝭蝯蝱蝲蝳蝵�蝷蝸蝹蝺蝿螀螁螄螆螇螉螊螌螎螏螐螑螒螔螕螖螘螙螚螛螜螝螞螠螡螢螣螤巍微危韦违桅围唯惟为潍维苇萎委伟伪尾纬未蔚味畏胃喂魏位渭谓尉慰卫瘟温蚊文闻纹吻稳紊问嗡翁瓮挝蜗涡窝我斡卧握沃巫呜钨乌污诬屋无芜梧吾吴毋武五捂午舞伍侮坞戊雾晤物勿务悟误昔熙析西硒矽晰嘻吸锡牺�".split("");
for(j = 0; j != D[206].length; ++j) if(D[206][j].charCodeAt(0) !== 0xFFFD) { e[D[206][j]] = 52736 + j; d[52736 + j] = D[206][j];}
D[207] = "����������������������������������������������������������������螥螦螧螩螪螮螰螱螲螴螶螷螸螹螻螼螾螿蟁蟂蟃蟄蟅蟇蟈蟉蟌蟍蟎蟏蟐蟔蟕蟖蟗蟘蟙蟚蟜蟝蟞蟟蟡蟢蟣蟤蟦蟧蟨蟩蟫蟬蟭蟯蟰蟱蟲蟳蟴蟵蟶蟷蟸�蟺蟻蟼蟽蟿蠀蠁蠂蠄蠅蠆蠇蠈蠉蠋蠌蠍蠎蠏蠐蠑蠒蠔蠗蠘蠙蠚蠜蠝蠞蠟蠠蠣稀息希悉膝夕惜熄烯溪汐犀檄袭席习媳喜铣洗系隙戏细瞎虾匣霞辖暇峡侠狭下厦夏吓掀锨先仙鲜纤咸贤衔舷闲涎弦嫌显险现献县腺馅羡宪陷限线相厢镶香箱襄湘乡翔祥详想响享项巷橡像向象萧硝霄削哮嚣销消宵淆晓�".split("");
for(j = 0; j != D[207].length; ++j) if(D[207][j].charCodeAt(0) !== 0xFFFD) { e[D[207][j]] = 52992 + j; d[52992 + j] = D[207][j];}
D[208] = "����������������������������������������������������������������蠤蠥蠦蠧蠨蠩蠪蠫蠬蠭蠮蠯蠰蠱蠳蠴蠵蠶蠷蠸蠺蠻蠽蠾蠿衁衂衃衆衇衈衉衊衋衎衏衐衑衒術衕衖衘衚衛衜衝衞衟衠衦衧衪衭衯衱衳衴衵衶衸衹衺�衻衼袀袃袆袇袉袊袌袎袏袐袑袓袔袕袗袘袙袚袛袝袞袟袠袡袣袥袦袧袨袩袪小孝校肖啸笑效楔些歇蝎鞋协挟携邪斜胁谐写械卸蟹懈泄泻谢屑薪芯锌欣辛新忻心信衅星腥猩惺兴刑型形邢行醒幸杏性姓兄凶胸匈汹雄熊休修羞朽嗅锈秀袖绣墟戌需虚嘘须徐许蓄酗叙旭序畜恤絮婿绪续轩喧宣悬旋玄�".split("");
for(j = 0; j != D[208].length; ++j) if(D[208][j].charCodeAt(0) !== 0xFFFD) { e[D[208][j]] = 53248 + j; d[53248 + j] = D[208][j];}
D[209] = "����������������������������������������������������������������袬袮袯袰袲袳袴袵袶袸袹袺袻袽袾袿裀裃裄裇裈裊裋裌裍裏裐裑裓裖裗裚裛補裝裞裠裡裦裧裩裪裫裬裭裮裯裲裵裶裷裺裻製裿褀褁褃褄褅褆複褈�褉褋褌褍褎褏褑褔褕褖褗褘褜褝褞褟褠褢褣褤褦褧褨褩褬褭褮褯褱褲褳褵褷选癣眩绚靴薛学穴雪血勋熏循旬询寻驯巡殉汛训讯逊迅压押鸦鸭呀丫芽牙蚜崖衙涯雅哑亚讶焉咽阉烟淹盐严研蜒岩延言颜阎炎沿奄掩眼衍演艳堰燕厌砚雁唁彦焰宴谚验殃央鸯秧杨扬佯疡羊洋阳氧仰痒养样漾邀腰妖瑶�".split("");
for(j = 0; j != D[209].length; ++j) if(D[209][j].charCodeAt(0) !== 0xFFFD) { e[D[209][j]] = 53504 + j; d[53504 + j] = D[209][j];}
D[210] = "����������������������������������������������������������������褸褹褺褻褼褽褾褿襀襂襃襅襆襇襈襉襊襋襌襍襎襏襐襑襒襓襔襕襖襗襘襙襚襛襜襝襠襡襢襣襤襥襧襨襩襪襫襬襭襮襯襰襱襲襳襴襵襶襷襸襹襺襼�襽襾覀覂覄覅覇覈覉覊見覌覍覎規覐覑覒覓覔覕視覗覘覙覚覛覜覝覞覟覠覡摇尧遥窑谣姚咬舀药要耀椰噎耶爷野冶也页掖业叶曳腋夜液一壹医揖铱依伊衣颐夷遗移仪胰疑沂宜姨彝椅蚁倚已乙矣以艺抑易邑屹亿役臆逸肄疫亦裔意毅忆义益溢诣议谊译异翼翌绎茵荫因殷音阴姻吟银淫寅饮尹引隐�".split("");
for(j = 0; j != D[210].length; ++j) if(D[210][j].charCodeAt(0) !== 0xFFFD) { e[D[210][j]] = 53760 + j; d[53760 + j] = D[210][j];}
D[211] = "����������������������������������������������������������������覢覣覤覥覦覧覨覩親覫覬覭覮覯覰覱覲観覴覵覶覷覸覹覺覻覼覽覾覿觀觃觍觓觔觕觗觘觙觛觝觟觠觡觢觤觧觨觩觪觬觭觮觰觱觲觴觵觶觷觸觹觺�觻觼觽觾觿訁訂訃訄訅訆計訉訊訋訌訍討訏訐訑訒訓訔訕訖託記訙訚訛訜訝印英樱婴鹰应缨莹萤营荧蝇迎赢盈影颖硬映哟拥佣臃痈庸雍踊蛹咏泳涌永恿勇用幽优悠忧尤由邮铀犹油游酉有友右佑釉诱又幼迂淤于盂榆虞愚舆余俞逾鱼愉渝渔隅予娱雨与屿禹宇语羽玉域芋郁吁遇喻峪御愈欲狱育誉�".split("");
for(j = 0; j != D[211].length; ++j) if(D[211][j].charCodeAt(0) !== 0xFFFD) { e[D[211][j]] = 54016 + j; d[54016 + j] = D[211][j];}
D[212] = "����������������������������������������������������������������訞訟訠訡訢訣訤訥訦訧訨訩訪訫訬設訮訯訰許訲訳訴訵訶訷訸訹診註証訽訿詀詁詂詃詄詅詆詇詉詊詋詌詍詎詏詐詑詒詓詔評詖詗詘詙詚詛詜詝詞�詟詠詡詢詣詤詥試詧詨詩詪詫詬詭詮詯詰話該詳詴詵詶詷詸詺詻詼詽詾詿誀浴寓裕预豫驭鸳渊冤元垣袁原援辕园员圆猿源缘远苑愿怨院曰约越跃钥岳粤月悦阅耘云郧匀陨允运蕴酝晕韵孕匝砸杂栽哉灾宰载再在咱攒暂赞赃脏葬遭糟凿藻枣早澡蚤躁噪造皂灶燥责择则泽贼怎增憎曾赠扎喳渣札轧�".split("");
for(j = 0; j != D[212].length; ++j) if(D[212][j].charCodeAt(0) !== 0xFFFD) { e[D[212][j]] = 54272 + j; d[54272 + j] = D[212][j];}
D[213] = "����������������������������������������������������������������誁誂誃誄誅誆誇誈誋誌認誎誏誐誑誒誔誕誖誗誘誙誚誛誜誝語誟誠誡誢誣誤誥誦誧誨誩說誫説読誮誯誰誱課誳誴誵誶誷誸誹誺誻誼誽誾調諀諁諂�諃諄諅諆談諈諉諊請諌諍諎諏諐諑諒諓諔諕論諗諘諙諚諛諜諝諞諟諠諡諢諣铡闸眨栅榨咋乍炸诈摘斋宅窄债寨瞻毡詹粘沾盏斩辗崭展蘸栈占战站湛绽樟章彰漳张掌涨杖丈帐账仗胀瘴障招昭找沼赵照罩兆肇召遮折哲蛰辙者锗蔗这浙珍斟真甄砧臻贞针侦枕疹诊震振镇阵蒸挣睁征狰争怔整拯正政�".split("");
for(j = 0; j != D[213].length; ++j) if(D[213][j].charCodeAt(0) !== 0xFFFD) { e[D[213][j]] = 54528 + j; d[54528 + j] = D[213][j];}
D[214] = "����������������������������������������������������������������諤諥諦諧諨諩諪諫諬諭諮諯諰諱諲諳諴諵諶諷諸諹諺諻諼諽諾諿謀謁謂謃謄謅謆謈謉謊謋謌謍謎謏謐謑謒謓謔謕謖謗謘謙謚講謜謝謞謟謠謡謢謣�謤謥謧謨謩謪謫謬謭謮謯謰謱謲謳謴謵謶謷謸謹謺謻謼謽謾謿譀譁譂譃譄譅帧症郑证芝枝支吱蜘知肢脂汁之织职直植殖执值侄址指止趾只旨纸志挚掷至致置帜峙制智秩稚质炙痔滞治窒中盅忠钟衷终种肿重仲众舟周州洲诌粥轴肘帚咒皱宙昼骤珠株蛛朱猪诸诛逐竹烛煮拄瞩嘱主著柱助蛀贮铸筑�".split("");
for(j = 0; j != D[214].length; ++j) if(D[214][j].charCodeAt(0) !== 0xFFFD) { e[D[214][j]] = 54784 + j; d[54784 + j] = D[214][j];}
D[215] = "����������������������������������������������������������������譆譇譈證譊譋譌譍譎譏譐譑譒譓譔譕譖譗識譙譚譛譜譝譞譟譠譡譢譣譤譥譧譨譩譪譫譭譮譯議譱譲譳譴譵譶護譸譹譺譻譼譽譾譿讀讁讂讃讄讅讆�讇讈讉變讋讌讍讎讏讐讑讒讓讔讕讖讗讘讙讚讛讜讝讞讟讬讱讻诇诐诪谉谞住注祝驻抓爪拽专砖转撰赚篆桩庄装妆撞壮状椎锥追赘坠缀谆准捉拙卓桌琢茁酌啄着灼浊兹咨资姿滋淄孜紫仔籽滓子自渍字鬃棕踪宗综总纵邹走奏揍租足卒族祖诅阻组钻纂嘴醉最罪尊遵昨左佐柞做作坐座������".split("");
for(j = 0; j != D[215].length; ++j) if(D[215][j].charCodeAt(0) !== 0xFFFD) { e[D[215][j]] = 55040 + j; d[55040 + j] = D[215][j];}
D[216] = "����������������������������������������������������������������谸谹谺谻谼谽谾谿豀豂豃豄豅豈豊豋豍豎豏豐豑豒豓豔豖豗豘豙豛豜豝豞豟豠豣豤豥豦豧豨豩豬豭豮豯豰豱豲豴豵豶豷豻豼豽豾豿貀貁貃貄貆貇�貈貋貍貎貏貐貑貒貓貕貖貗貙貚貛貜貝貞貟負財貢貣貤貥貦貧貨販貪貫責貭亍丌兀丐廿卅丕亘丞鬲孬噩丨禺丿匕乇夭爻卮氐囟胤馗毓睾鼗丶亟鼐乜乩亓芈孛啬嘏仄厍厝厣厥厮靥赝匚叵匦匮匾赜卦卣刂刈刎刭刳刿剀剌剞剡剜蒯剽劂劁劐劓冂罔亻仃仉仂仨仡仫仞伛仳伢佤仵伥伧伉伫佞佧攸佚佝�".split("");
for(j = 0; j != D[216].length; ++j) if(D[216][j].charCodeAt(0) !== 0xFFFD) { e[D[216][j]] = 55296 + j; d[55296 + j] = D[216][j];}
D[217] = "����������������������������������������������������������������貮貯貰貱貲貳貴貵貶買貸貹貺費貼貽貾貿賀賁賂賃賄賅賆資賈賉賊賋賌賍賎賏賐賑賒賓賔賕賖賗賘賙賚賛賜賝賞賟賠賡賢賣賤賥賦賧賨賩質賫賬�賭賮賯賰賱賲賳賴賵賶賷賸賹賺賻購賽賾賿贀贁贂贃贄贅贆贇贈贉贊贋贌贍佟佗伲伽佶佴侑侉侃侏佾佻侪佼侬侔俦俨俪俅俚俣俜俑俟俸倩偌俳倬倏倮倭俾倜倌倥倨偾偃偕偈偎偬偻傥傧傩傺僖儆僭僬僦僮儇儋仝氽佘佥俎龠汆籴兮巽黉馘冁夔勹匍訇匐凫夙兕亠兖亳衮袤亵脔裒禀嬴蠃羸冫冱冽冼�".split("");
for(j = 0; j != D[217].length; ++j) if(D[217][j].charCodeAt(0) !== 0xFFFD) { e[D[217][j]] = 55552 + j; d[55552 + j] = D[217][j];}
D[218] = "����������������������������������������������������������������贎贏贐贑贒贓贔贕贖贗贘贙贚贛贜贠赑赒赗赟赥赨赩赪赬赮赯赱赲赸赹赺赻赼赽赾赿趀趂趃趆趇趈趉趌趍趎趏趐趒趓趕趖趗趘趙趚趛趜趝趞趠趡�趢趤趥趦趧趨趩趪趫趬趭趮趯趰趲趶趷趹趻趽跀跁跂跅跇跈跉跊跍跐跒跓跔凇冖冢冥讠讦讧讪讴讵讷诂诃诋诏诎诒诓诔诖诘诙诜诟诠诤诨诩诮诰诳诶诹诼诿谀谂谄谇谌谏谑谒谔谕谖谙谛谘谝谟谠谡谥谧谪谫谮谯谲谳谵谶卩卺阝阢阡阱阪阽阼陂陉陔陟陧陬陲陴隈隍隗隰邗邛邝邙邬邡邴邳邶邺�".split("");
for(j = 0; j != D[218].length; ++j) if(D[218][j].charCodeAt(0) !== 0xFFFD) { e[D[218][j]] = 55808 + j; d[55808 + j] = D[218][j];}
D[219] = "����������������������������������������������������������������跕跘跙跜跠跡跢跥跦跧跩跭跮跰跱跲跴跶跼跾跿踀踁踂踃踄踆踇踈踋踍踎踐踑踒踓踕踖踗踘踙踚踛踜踠踡踤踥踦踧踨踫踭踰踲踳踴踶踷踸踻踼踾�踿蹃蹅蹆蹌蹍蹎蹏蹐蹓蹔蹕蹖蹗蹘蹚蹛蹜蹝蹞蹟蹠蹡蹢蹣蹤蹥蹧蹨蹪蹫蹮蹱邸邰郏郅邾郐郄郇郓郦郢郜郗郛郫郯郾鄄鄢鄞鄣鄱鄯鄹酃酆刍奂劢劬劭劾哿勐勖勰叟燮矍廴凵凼鬯厶弁畚巯坌垩垡塾墼壅壑圩圬圪圳圹圮圯坜圻坂坩垅坫垆坼坻坨坭坶坳垭垤垌垲埏垧垴垓垠埕埘埚埙埒垸埴埯埸埤埝�".split("");
for(j = 0; j != D[219].length; ++j) if(D[219][j].charCodeAt(0) !== 0xFFFD) { e[D[219][j]] = 56064 + j; d[56064 + j] = D[219][j];}
D[220] = "����������������������������������������������������������������蹳蹵蹷蹸蹹蹺蹻蹽蹾躀躂躃躄躆躈躉躊躋躌躍躎躑躒躓躕躖躗躘躙躚躛躝躟躠躡躢躣躤躥躦躧躨躩躪躭躮躰躱躳躴躵躶躷躸躹躻躼躽躾躿軀軁軂�軃軄軅軆軇軈軉車軋軌軍軏軐軑軒軓軔軕軖軗軘軙軚軛軜軝軞軟軠軡転軣軤堋堍埽埭堀堞堙塄堠塥塬墁墉墚墀馨鼙懿艹艽艿芏芊芨芄芎芑芗芙芫芸芾芰苈苊苣芘芷芮苋苌苁芩芴芡芪芟苄苎芤苡茉苷苤茏茇苜苴苒苘茌苻苓茑茚茆茔茕苠苕茜荑荛荜茈莒茼茴茱莛荞茯荏荇荃荟荀茗荠茭茺茳荦荥�".split("");
for(j = 0; j != D[220].length; ++j) if(D[220][j].charCodeAt(0) !== 0xFFFD) { e[D[220][j]] = 56320 + j; d[56320 + j] = D[220][j];}
D[221] = "����������������������������������������������������������������軥軦軧軨軩軪軫軬軭軮軯軰軱軲軳軴軵軶軷軸軹軺軻軼軽軾軿輀輁輂較輄輅輆輇輈載輊輋輌輍輎輏輐輑輒輓輔輕輖輗輘輙輚輛輜輝輞輟輠輡輢輣�輤輥輦輧輨輩輪輫輬輭輮輯輰輱輲輳輴輵輶輷輸輹輺輻輼輽輾輿轀轁轂轃轄荨茛荩荬荪荭荮莰荸莳莴莠莪莓莜莅荼莶莩荽莸荻莘莞莨莺莼菁萁菥菘堇萘萋菝菽菖萜萸萑萆菔菟萏萃菸菹菪菅菀萦菰菡葜葑葚葙葳蒇蒈葺蒉葸萼葆葩葶蒌蒎萱葭蓁蓍蓐蓦蒽蓓蓊蒿蒺蓠蒡蒹蒴蒗蓥蓣蔌甍蔸蓰蔹蔟蔺�".split("");
for(j = 0; j != D[221].length; ++j) if(D[221][j].charCodeAt(0) !== 0xFFFD) { e[D[221][j]] = 56576 + j; d[56576 + j] = D[221][j];}
D[222] = "����������������������������������������������������������������轅轆轇轈轉轊轋轌轍轎轏轐轑轒轓轔轕轖轗轘轙轚轛轜轝轞轟轠轡轢轣轤轥轪辀辌辒辝辠辡辢辤辥辦辧辪辬辭辮辯農辳辴辵辷辸辺辻込辿迀迃迆�迉迊迋迌迍迏迒迖迗迚迠迡迣迧迬迯迱迲迴迵迶迺迻迼迾迿逇逈逌逎逓逕逘蕖蔻蓿蓼蕙蕈蕨蕤蕞蕺瞢蕃蕲蕻薤薨薇薏蕹薮薜薅薹薷薰藓藁藜藿蘧蘅蘩蘖蘼廾弈夼奁耷奕奚奘匏尢尥尬尴扌扪抟抻拊拚拗拮挢拶挹捋捃掭揶捱捺掎掴捭掬掊捩掮掼揲揸揠揿揄揞揎摒揆掾摅摁搋搛搠搌搦搡摞撄摭撖�".split("");
for(j = 0; j != D[222].length; ++j) if(D[222][j].charCodeAt(0) !== 0xFFFD) { e[D[222][j]] = 56832 + j; d[56832 + j] = D[222][j];}
D[223] = "����������������������������������������������������������������這逜連逤逥逧逨逩逪逫逬逰週進逳逴逷逹逺逽逿遀遃遅遆遈遉遊運遌過達違遖遙遚遜遝遞遟遠遡遤遦遧適遪遫遬遯遰遱遲遳遶遷選遹遺遻遼遾邁�還邅邆邇邉邊邌邍邎邏邐邒邔邖邘邚邜邞邟邠邤邥邧邨邩邫邭邲邷邼邽邿郀摺撷撸撙撺擀擐擗擤擢攉攥攮弋忒甙弑卟叱叽叩叨叻吒吖吆呋呒呓呔呖呃吡呗呙吣吲咂咔呷呱呤咚咛咄呶呦咝哐咭哂咴哒咧咦哓哔呲咣哕咻咿哌哙哚哜咩咪咤哝哏哞唛哧唠哽唔哳唢唣唏唑唧唪啧喏喵啉啭啁啕唿啐唼�".split("");
for(j = 0; j != D[223].length; ++j) if(D[223][j].charCodeAt(0) !== 0xFFFD) { e[D[223][j]] = 57088 + j; d[57088 + j] = D[223][j];}
D[224] = "����������������������������������������������������������������郂郃郆郈郉郋郌郍郒郔郕郖郘郙郚郞郟郠郣郤郥郩郪郬郮郰郱郲郳郵郶郷郹郺郻郼郿鄀鄁鄃鄅鄆鄇鄈鄉鄊鄋鄌鄍鄎鄏鄐鄑鄒鄓鄔鄕鄖鄗鄘鄚鄛鄜�鄝鄟鄠鄡鄤鄥鄦鄧鄨鄩鄪鄫鄬鄭鄮鄰鄲鄳鄴鄵鄶鄷鄸鄺鄻鄼鄽鄾鄿酀酁酂酄唷啖啵啶啷唳唰啜喋嗒喃喱喹喈喁喟啾嗖喑啻嗟喽喾喔喙嗪嗷嗉嘟嗑嗫嗬嗔嗦嗝嗄嗯嗥嗲嗳嗌嗍嗨嗵嗤辔嘞嘈嘌嘁嘤嘣嗾嘀嘧嘭噘嘹噗嘬噍噢噙噜噌噔嚆噤噱噫噻噼嚅嚓嚯囔囗囝囡囵囫囹囿圄圊圉圜帏帙帔帑帱帻帼�".split("");
for(j = 0; j != D[224].length; ++j) if(D[224][j].charCodeAt(0) !== 0xFFFD) { e[D[224][j]] = 57344 + j; d[57344 + j] = D[224][j];}
D[225] = "����������������������������������������������������������������酅酇酈酑酓酔酕酖酘酙酛酜酟酠酦酧酨酫酭酳酺酻酼醀醁醂醃醄醆醈醊醎醏醓醔醕醖醗醘醙醜醝醞醟醠醡醤醥醦醧醨醩醫醬醰醱醲醳醶醷醸醹醻�醼醽醾醿釀釁釂釃釄釅釆釈釋釐釒釓釔釕釖釗釘釙釚釛針釞釟釠釡釢釣釤釥帷幄幔幛幞幡岌屺岍岐岖岈岘岙岑岚岜岵岢岽岬岫岱岣峁岷峄峒峤峋峥崂崃崧崦崮崤崞崆崛嵘崾崴崽嵬嵛嵯嵝嵫嵋嵊嵩嵴嶂嶙嶝豳嶷巅彳彷徂徇徉後徕徙徜徨徭徵徼衢彡犭犰犴犷犸狃狁狎狍狒狨狯狩狲狴狷猁狳猃狺�".split("");
for(j = 0; j != D[225].length; ++j) if(D[225][j].charCodeAt(0) !== 0xFFFD) { e[D[225][j]] = 57600 + j; d[57600 + j] = D[225][j];}
D[226] = "����������������������������������������������������������������釦釧釨釩釪釫釬釭釮釯釰釱釲釳釴釵釶釷釸釹釺釻釼釽釾釿鈀鈁鈂鈃鈄鈅鈆鈇鈈鈉鈊鈋鈌鈍鈎鈏鈐鈑鈒鈓鈔鈕鈖鈗鈘鈙鈚鈛鈜鈝鈞鈟鈠鈡鈢鈣鈤�鈥鈦鈧鈨鈩鈪鈫鈬鈭鈮鈯鈰鈱鈲鈳鈴鈵鈶鈷鈸鈹鈺鈻鈼鈽鈾鈿鉀鉁鉂鉃鉄鉅狻猗猓猡猊猞猝猕猢猹猥猬猸猱獐獍獗獠獬獯獾舛夥飧夤夂饣饧饨饩饪饫饬饴饷饽馀馄馇馊馍馐馑馓馔馕庀庑庋庖庥庠庹庵庾庳赓廒廑廛廨廪膺忄忉忖忏怃忮怄忡忤忾怅怆忪忭忸怙怵怦怛怏怍怩怫怊怿怡恸恹恻恺恂�".split("");
for(j = 0; j != D[226].length; ++j) if(D[226][j].charCodeAt(0) !== 0xFFFD) { e[D[226][j]] = 57856 + j; d[57856 + j] = D[226][j];}
D[227] = "����������������������������������������������������������������鉆鉇鉈鉉鉊鉋鉌鉍鉎鉏鉐鉑鉒鉓鉔鉕鉖鉗鉘鉙鉚鉛鉜鉝鉞鉟鉠鉡鉢鉣鉤鉥鉦鉧鉨鉩鉪鉫鉬鉭鉮鉯鉰鉱鉲鉳鉵鉶鉷鉸鉹鉺鉻鉼鉽鉾鉿銀銁銂銃銄銅�銆銇銈銉銊銋銌銍銏銐銑銒銓銔銕銖銗銘銙銚銛銜銝銞銟銠銡銢銣銤銥銦銧恪恽悖悚悭悝悃悒悌悛惬悻悱惝惘惆惚悴愠愦愕愣惴愀愎愫慊慵憬憔憧憷懔懵忝隳闩闫闱闳闵闶闼闾阃阄阆阈阊阋阌阍阏阒阕阖阗阙阚丬爿戕氵汔汜汊沣沅沐沔沌汨汩汴汶沆沩泐泔沭泷泸泱泗沲泠泖泺泫泮沱泓泯泾�".split("");
for(j = 0; j != D[227].length; ++j) if(D[227][j].charCodeAt(0) !== 0xFFFD) { e[D[227][j]] = 58112 + j; d[58112 + j] = D[227][j];}
D[228] = "����������������������������������������������������������������銨銩銪銫銬銭銯銰銱銲銳銴銵銶銷銸銹銺銻銼銽銾銿鋀鋁鋂鋃鋄鋅鋆鋇鋉鋊鋋鋌鋍鋎鋏鋐鋑鋒鋓鋔鋕鋖鋗鋘鋙鋚鋛鋜鋝鋞鋟鋠鋡鋢鋣鋤鋥鋦鋧鋨�鋩鋪鋫鋬鋭鋮鋯鋰鋱鋲鋳鋴鋵鋶鋷鋸鋹鋺鋻鋼鋽鋾鋿錀錁錂錃錄錅錆錇錈錉洹洧洌浃浈洇洄洙洎洫浍洮洵洚浏浒浔洳涑浯涞涠浞涓涔浜浠浼浣渚淇淅淞渎涿淠渑淦淝淙渖涫渌涮渫湮湎湫溲湟溆湓湔渲渥湄滟溱溘滠漭滢溥溧溽溻溷滗溴滏溏滂溟潢潆潇漤漕滹漯漶潋潴漪漉漩澉澍澌潸潲潼潺濑�".split("");
for(j = 0; j != D[228].length; ++j) if(D[228][j].charCodeAt(0) !== 0xFFFD) { e[D[228][j]] = 58368 + j; d[58368 + j] = D[228][j];}
D[229] = "����������������������������������������������������������������錊錋錌錍錎錏錐錑錒錓錔錕錖錗錘錙錚錛錜錝錞錟錠錡錢錣錤錥錦錧錨錩錪錫錬錭錮錯錰錱録錳錴錵錶錷錸錹錺錻錼錽錿鍀鍁鍂鍃鍄鍅鍆鍇鍈鍉�鍊鍋鍌鍍鍎鍏鍐鍑鍒鍓鍔鍕鍖鍗鍘鍙鍚鍛鍜鍝鍞鍟鍠鍡鍢鍣鍤鍥鍦鍧鍨鍩鍫濉澧澹澶濂濡濮濞濠濯瀚瀣瀛瀹瀵灏灞宀宄宕宓宥宸甯骞搴寤寮褰寰蹇謇辶迓迕迥迮迤迩迦迳迨逅逄逋逦逑逍逖逡逵逶逭逯遄遑遒遐遨遘遢遛暹遴遽邂邈邃邋彐彗彖彘尻咫屐屙孱屣屦羼弪弩弭艴弼鬻屮妁妃妍妩妪妣�".split("");
for(j = 0; j != D[229].length; ++j) if(D[229][j].charCodeAt(0) !== 0xFFFD) { e[D[229][j]] = 58624 + j; d[58624 + j] = D[229][j];}
D[230] = "����������������������������������������������������������������鍬鍭鍮鍯鍰鍱鍲鍳鍴鍵鍶鍷鍸鍹鍺鍻鍼鍽鍾鍿鎀鎁鎂鎃鎄鎅鎆鎇鎈鎉鎊鎋鎌鎍鎎鎐鎑鎒鎓鎔鎕鎖鎗鎘鎙鎚鎛鎜鎝鎞鎟鎠鎡鎢鎣鎤鎥鎦鎧鎨鎩鎪鎫�鎬鎭鎮鎯鎰鎱鎲鎳鎴鎵鎶鎷鎸鎹鎺鎻鎼鎽鎾鎿鏀鏁鏂鏃鏄鏅鏆鏇鏈鏉鏋鏌鏍妗姊妫妞妤姒妲妯姗妾娅娆姝娈姣姘姹娌娉娲娴娑娣娓婀婧婊婕娼婢婵胬媪媛婷婺媾嫫媲嫒嫔媸嫠嫣嫱嫖嫦嫘嫜嬉嬗嬖嬲嬷孀尕尜孚孥孳孑孓孢驵驷驸驺驿驽骀骁骅骈骊骐骒骓骖骘骛骜骝骟骠骢骣骥骧纟纡纣纥纨纩�".split("");
for(j = 0; j != D[230].length; ++j) if(D[230][j].charCodeAt(0) !== 0xFFFD) { e[D[230][j]] = 58880 + j; d[58880 + j] = D[230][j];}
D[231] = "����������������������������������������������������������������鏎鏏鏐鏑鏒鏓鏔鏕鏗鏘鏙鏚鏛鏜鏝鏞鏟鏠鏡鏢鏣鏤鏥鏦鏧鏨鏩鏪鏫鏬鏭鏮鏯鏰鏱鏲鏳鏴鏵鏶鏷鏸鏹鏺鏻鏼鏽鏾鏿鐀鐁鐂鐃鐄鐅鐆鐇鐈鐉鐊鐋鐌鐍�鐎鐏鐐鐑鐒鐓鐔鐕鐖鐗鐘鐙鐚鐛鐜鐝鐞鐟鐠鐡鐢鐣鐤鐥鐦鐧鐨鐩鐪鐫鐬鐭鐮纭纰纾绀绁绂绉绋绌绐绔绗绛绠绡绨绫绮绯绱绲缍绶绺绻绾缁缂缃缇缈缋缌缏缑缒缗缙缜缛缟缡缢缣缤缥缦缧缪缫缬缭缯缰缱缲缳缵幺畿巛甾邕玎玑玮玢玟珏珂珑玷玳珀珉珈珥珙顼琊珩珧珞玺珲琏琪瑛琦琥琨琰琮琬�".split("");
for(j = 0; j != D[231].length; ++j) if(D[231][j].charCodeAt(0) !== 0xFFFD) { e[D[231][j]] = 59136 + j; d[59136 + j] = D[231][j];}
D[232] = "����������������������������������������������������������������鐯鐰鐱鐲鐳鐴鐵鐶鐷鐸鐹鐺鐻鐼鐽鐿鑀鑁鑂鑃鑄鑅鑆鑇鑈鑉鑊鑋鑌鑍鑎鑏鑐鑑鑒鑓鑔鑕鑖鑗鑘鑙鑚鑛鑜鑝鑞鑟鑠鑡鑢鑣鑤鑥鑦鑧鑨鑩鑪鑬鑭鑮鑯�鑰鑱鑲鑳鑴鑵鑶鑷鑸鑹鑺鑻鑼鑽鑾鑿钀钁钂钃钄钑钖钘铇铏铓铔铚铦铻锜锠琛琚瑁瑜瑗瑕瑙瑷瑭瑾璜璎璀璁璇璋璞璨璩璐璧瓒璺韪韫韬杌杓杞杈杩枥枇杪杳枘枧杵枨枞枭枋杷杼柰栉柘栊柩枰栌柙枵柚枳柝栀柃枸柢栎柁柽栲栳桠桡桎桢桄桤梃栝桕桦桁桧桀栾桊桉栩梵梏桴桷梓桫棂楮棼椟椠棹�".split("");
for(j = 0; j != D[232].length; ++j) if(D[232][j].charCodeAt(0) !== 0xFFFD) { e[D[232][j]] = 59392 + j; d[59392 + j] = D[232][j];}
D[233] = "����������������������������������������������������������������锧锳锽镃镈镋镕镚镠镮镴镵長镸镹镺镻镼镽镾門閁閂閃閄閅閆閇閈閉閊開閌閍閎閏閐閑閒間閔閕閖閗閘閙閚閛閜閝閞閟閠閡関閣閤閥閦閧閨閩閪�閫閬閭閮閯閰閱閲閳閴閵閶閷閸閹閺閻閼閽閾閿闀闁闂闃闄闅闆闇闈闉闊闋椤棰椋椁楗棣椐楱椹楠楂楝榄楫榀榘楸椴槌榇榈槎榉楦楣楹榛榧榻榫榭槔榱槁槊槟榕槠榍槿樯槭樗樘橥槲橄樾檠橐橛樵檎橹樽樨橘橼檑檐檩檗檫猷獒殁殂殇殄殒殓殍殚殛殡殪轫轭轱轲轳轵轶轸轷轹轺轼轾辁辂辄辇辋�".split("");
for(j = 0; j != D[233].length; ++j) if(D[233][j].charCodeAt(0) !== 0xFFFD) { e[D[233][j]] = 59648 + j; d[59648 + j] = D[233][j];}
D[234] = "����������������������������������������������������������������闌闍闎闏闐闑闒闓闔闕闖闗闘闙闚闛關闝闞闟闠闡闢闣闤闥闦闧闬闿阇阓阘阛阞阠阣阤阥阦阧阨阩阫阬阭阯阰阷阸阹阺阾陁陃陊陎陏陑陒陓陖陗�陘陙陚陜陝陞陠陣陥陦陫陭陮陯陰陱陳陸陹険陻陼陽陾陿隀隁隂隃隄隇隉隊辍辎辏辘辚軎戋戗戛戟戢戡戥戤戬臧瓯瓴瓿甏甑甓攴旮旯旰昊昙杲昃昕昀炅曷昝昴昱昶昵耆晟晔晁晏晖晡晗晷暄暌暧暝暾曛曜曦曩贲贳贶贻贽赀赅赆赈赉赇赍赕赙觇觊觋觌觎觏觐觑牮犟牝牦牯牾牿犄犋犍犏犒挈挲掰�".split("");
for(j = 0; j != D[234].length; ++j) if(D[234][j].charCodeAt(0) !== 0xFFFD) { e[D[234][j]] = 59904 + j; d[59904 + j] = D[234][j];}
D[235] = "����������������������������������������������������������������隌階隑隒隓隕隖隚際隝隞隟隠隡隢隣隤隥隦隨隩險隫隬隭隮隯隱隲隴隵隷隸隺隻隿雂雃雈雊雋雐雑雓雔雖雗雘雙雚雛雜雝雞雟雡離難雤雥雦雧雫�雬雭雮雰雱雲雴雵雸雺電雼雽雿霂霃霅霊霋霌霐霑霒霔霕霗霘霙霚霛霝霟霠搿擘耄毪毳毽毵毹氅氇氆氍氕氘氙氚氡氩氤氪氲攵敕敫牍牒牖爰虢刖肟肜肓肼朊肽肱肫肭肴肷胧胨胩胪胛胂胄胙胍胗朐胝胫胱胴胭脍脎胲胼朕脒豚脶脞脬脘脲腈腌腓腴腙腚腱腠腩腼腽腭腧塍媵膈膂膑滕膣膪臌朦臊膻�".split("");
for(j = 0; j != D[235].length; ++j) if(D[235][j].charCodeAt(0) !== 0xFFFD) { e[D[235][j]] = 60160 + j; d[60160 + j] = D[235][j];}
D[236] = "����������������������������������������������������������������霡霢霣霤霥霦霧霨霩霫霬霮霯霱霳霴霵霶霷霺霻霼霽霿靀靁靂靃靄靅靆靇靈靉靊靋靌靍靎靏靐靑靔靕靗靘靚靜靝靟靣靤靦靧靨靪靫靬靭靮靯靰靱�靲靵靷靸靹靺靻靽靾靿鞀鞁鞂鞃鞄鞆鞇鞈鞉鞊鞌鞎鞏鞐鞓鞕鞖鞗鞙鞚鞛鞜鞝臁膦欤欷欹歃歆歙飑飒飓飕飙飚殳彀毂觳斐齑斓於旆旄旃旌旎旒旖炀炜炖炝炻烀炷炫炱烨烊焐焓焖焯焱煳煜煨煅煲煊煸煺熘熳熵熨熠燠燔燧燹爝爨灬焘煦熹戾戽扃扈扉礻祀祆祉祛祜祓祚祢祗祠祯祧祺禅禊禚禧禳忑忐�".split("");
for(j = 0; j != D[236].length; ++j) if(D[236][j].charCodeAt(0) !== 0xFFFD) { e[D[236][j]] = 60416 + j; d[60416 + j] = D[236][j];}
D[237] = "����������������������������������������������������������������鞞鞟鞡鞢鞤鞥鞦鞧鞨鞩鞪鞬鞮鞰鞱鞳鞵鞶鞷鞸鞹鞺鞻鞼鞽鞾鞿韀韁韂韃韄韅韆韇韈韉韊韋韌韍韎韏韐韑韒韓韔韕韖韗韘韙韚韛韜韝韞韟韠韡韢韣�韤韥韨韮韯韰韱韲韴韷韸韹韺韻韼韽韾響頀頁頂頃頄項順頇須頉頊頋頌頍頎怼恝恚恧恁恙恣悫愆愍慝憩憝懋懑戆肀聿沓泶淼矶矸砀砉砗砘砑斫砭砜砝砹砺砻砟砼砥砬砣砩硎硭硖硗砦硐硇硌硪碛碓碚碇碜碡碣碲碹碥磔磙磉磬磲礅磴礓礤礞礴龛黹黻黼盱眄眍盹眇眈眚眢眙眭眦眵眸睐睑睇睃睚睨�".split("");
for(j = 0; j != D[237].length; ++j) if(D[237][j].charCodeAt(0) !== 0xFFFD) { e[D[237][j]] = 60672 + j; d[60672 + j] = D[237][j];}
D[238] = "����������������������������������������������������������������頏預頑頒頓頔頕頖頗領頙頚頛頜頝頞頟頠頡頢頣頤頥頦頧頨頩頪頫頬頭頮頯頰頱頲頳頴頵頶頷頸頹頺頻頼頽頾頿顀顁顂顃顄顅顆顇顈顉顊顋題額�顎顏顐顑顒顓顔顕顖顗願顙顚顛顜顝類顟顠顡顢顣顤顥顦顧顨顩顪顫顬顭顮睢睥睿瞍睽瞀瞌瞑瞟瞠瞰瞵瞽町畀畎畋畈畛畲畹疃罘罡罟詈罨罴罱罹羁罾盍盥蠲钅钆钇钋钊钌钍钏钐钔钗钕钚钛钜钣钤钫钪钭钬钯钰钲钴钶钷钸钹钺钼钽钿铄铈铉铊铋铌铍铎铐铑铒铕铖铗铙铘铛铞铟铠铢铤铥铧铨铪�".split("");
for(j = 0; j != D[238].length; ++j) if(D[238][j].charCodeAt(0) !== 0xFFFD) { e[D[238][j]] = 60928 + j; d[60928 + j] = D[238][j];}
D[239] = "����������������������������������������������������������������顯顰顱顲顳顴颋颎颒颕颙颣風颩颪颫颬颭颮颯颰颱颲颳颴颵颶颷颸颹颺颻颼颽颾颿飀飁飂飃飄飅飆飇飈飉飊飋飌飍飏飐飔飖飗飛飜飝飠飡飢飣飤�飥飦飩飪飫飬飭飮飯飰飱飲飳飴飵飶飷飸飹飺飻飼飽飾飿餀餁餂餃餄餅餆餇铩铫铮铯铳铴铵铷铹铼铽铿锃锂锆锇锉锊锍锎锏锒锓锔锕锖锘锛锝锞锟锢锪锫锩锬锱锲锴锶锷锸锼锾锿镂锵镄镅镆镉镌镎镏镒镓镔镖镗镘镙镛镞镟镝镡镢镤镥镦镧镨镩镪镫镬镯镱镲镳锺矧矬雉秕秭秣秫稆嵇稃稂稞稔�".split("");
for(j = 0; j != D[239].length; ++j) if(D[239][j].charCodeAt(0) !== 0xFFFD) { e[D[239][j]] = 61184 + j; d[61184 + j] = D[239][j];}
D[240] = "����������������������������������������������������������������餈餉養餋餌餎餏餑餒餓餔餕餖餗餘餙餚餛餜餝餞餟餠餡餢餣餤餥餦餧館餩餪餫餬餭餯餰餱餲餳餴餵餶餷餸餹餺餻餼餽餾餿饀饁饂饃饄饅饆饇饈饉�饊饋饌饍饎饏饐饑饒饓饖饗饘饙饚饛饜饝饞饟饠饡饢饤饦饳饸饹饻饾馂馃馉稹稷穑黏馥穰皈皎皓皙皤瓞瓠甬鸠鸢鸨鸩鸪鸫鸬鸲鸱鸶鸸鸷鸹鸺鸾鹁鹂鹄鹆鹇鹈鹉鹋鹌鹎鹑鹕鹗鹚鹛鹜鹞鹣鹦鹧鹨鹩鹪鹫鹬鹱鹭鹳疒疔疖疠疝疬疣疳疴疸痄疱疰痃痂痖痍痣痨痦痤痫痧瘃痱痼痿瘐瘀瘅瘌瘗瘊瘥瘘瘕瘙�".split("");
for(j = 0; j != D[240].length; ++j) if(D[240][j].charCodeAt(0) !== 0xFFFD) { e[D[240][j]] = 61440 + j; d[61440 + j] = D[240][j];}
D[241] = "����������������������������������������������������������������馌馎馚馛馜馝馞馟馠馡馢馣馤馦馧馩馪馫馬馭馮馯馰馱馲馳馴馵馶馷馸馹馺馻馼馽馾馿駀駁駂駃駄駅駆駇駈駉駊駋駌駍駎駏駐駑駒駓駔駕駖駗駘�駙駚駛駜駝駞駟駠駡駢駣駤駥駦駧駨駩駪駫駬駭駮駯駰駱駲駳駴駵駶駷駸駹瘛瘼瘢瘠癀瘭瘰瘿瘵癃瘾瘳癍癞癔癜癖癫癯翊竦穸穹窀窆窈窕窦窠窬窨窭窳衤衩衲衽衿袂袢裆袷袼裉裢裎裣裥裱褚裼裨裾裰褡褙褓褛褊褴褫褶襁襦襻疋胥皲皴矜耒耔耖耜耠耢耥耦耧耩耨耱耋耵聃聆聍聒聩聱覃顸颀颃�".split("");
for(j = 0; j != D[241].length; ++j) if(D[241][j].charCodeAt(0) !== 0xFFFD) { e[D[241][j]] = 61696 + j; d[61696 + j] = D[241][j];}
D[242] = "����������������������������������������������������������������駺駻駼駽駾駿騀騁騂騃騄騅騆騇騈騉騊騋騌騍騎騏騐騑騒験騔騕騖騗騘騙騚騛騜騝騞騟騠騡騢騣騤騥騦騧騨騩騪騫騬騭騮騯騰騱騲騳騴騵騶騷騸�騹騺騻騼騽騾騿驀驁驂驃驄驅驆驇驈驉驊驋驌驍驎驏驐驑驒驓驔驕驖驗驘驙颉颌颍颏颔颚颛颞颟颡颢颥颦虍虔虬虮虿虺虼虻蚨蚍蚋蚬蚝蚧蚣蚪蚓蚩蚶蛄蚵蛎蚰蚺蚱蚯蛉蛏蚴蛩蛱蛲蛭蛳蛐蜓蛞蛴蛟蛘蛑蜃蜇蛸蜈蜊蜍蜉蜣蜻蜞蜥蜮蜚蜾蝈蜴蜱蜩蜷蜿螂蜢蝽蝾蝻蝠蝰蝌蝮螋蝓蝣蝼蝤蝙蝥螓螯螨蟒�".split("");
for(j = 0; j != D[242].length; ++j) if(D[242][j].charCodeAt(0) !== 0xFFFD) { e[D[242][j]] = 61952 + j; d[61952 + j] = D[242][j];}
D[243] = "����������������������������������������������������������������驚驛驜驝驞驟驠驡驢驣驤驥驦驧驨驩驪驫驲骃骉骍骎骔骕骙骦骩骪骫骬骭骮骯骲骳骴骵骹骻骽骾骿髃髄髆髇髈髉髊髍髎髏髐髒體髕髖髗髙髚髛髜�髝髞髠髢髣髤髥髧髨髩髪髬髮髰髱髲髳髴髵髶髷髸髺髼髽髾髿鬀鬁鬂鬄鬅鬆蟆螈螅螭螗螃螫蟥螬螵螳蟋蟓螽蟑蟀蟊蟛蟪蟠蟮蠖蠓蟾蠊蠛蠡蠹蠼缶罂罄罅舐竺竽笈笃笄笕笊笫笏筇笸笪笙笮笱笠笥笤笳笾笞筘筚筅筵筌筝筠筮筻筢筲筱箐箦箧箸箬箝箨箅箪箜箢箫箴篑篁篌篝篚篥篦篪簌篾篼簏簖簋�".split("");
for(j = 0; j != D[243].length; ++j) if(D[243][j].charCodeAt(0) !== 0xFFFD) { e[D[243][j]] = 62208 + j; d[62208 + j] = D[243][j];}
D[244] = "����������������������������������������������������������������鬇鬉鬊鬋鬌鬍鬎鬐鬑鬒鬔鬕鬖鬗鬘鬙鬚鬛鬜鬝鬞鬠鬡鬢鬤鬥鬦鬧鬨鬩鬪鬫鬬鬭鬮鬰鬱鬳鬴鬵鬶鬷鬸鬹鬺鬽鬾鬿魀魆魊魋魌魎魐魒魓魕魖魗魘魙魚�魛魜魝魞魟魠魡魢魣魤魥魦魧魨魩魪魫魬魭魮魯魰魱魲魳魴魵魶魷魸魹魺魻簟簪簦簸籁籀臾舁舂舄臬衄舡舢舣舭舯舨舫舸舻舳舴舾艄艉艋艏艚艟艨衾袅袈裘裟襞羝羟羧羯羰羲籼敉粑粝粜粞粢粲粼粽糁糇糌糍糈糅糗糨艮暨羿翎翕翥翡翦翩翮翳糸絷綦綮繇纛麸麴赳趄趔趑趱赧赭豇豉酊酐酎酏酤�".split("");
for(j = 0; j != D[244].length; ++j) if(D[244][j].charCodeAt(0) !== 0xFFFD) { e[D[244][j]] = 62464 + j; d[62464 + j] = D[244][j];}
D[245] = "����������������������������������������������������������������魼魽魾魿鮀鮁鮂鮃鮄鮅鮆鮇鮈鮉鮊鮋鮌鮍鮎鮏鮐鮑鮒鮓鮔鮕鮖鮗鮘鮙鮚鮛鮜鮝鮞鮟鮠鮡鮢鮣鮤鮥鮦鮧鮨鮩鮪鮫鮬鮭鮮鮯鮰鮱鮲鮳鮴鮵鮶鮷鮸鮹鮺�鮻鮼鮽鮾鮿鯀鯁鯂鯃鯄鯅鯆鯇鯈鯉鯊鯋鯌鯍鯎鯏鯐鯑鯒鯓鯔鯕鯖鯗鯘鯙鯚鯛酢酡酰酩酯酽酾酲酴酹醌醅醐醍醑醢醣醪醭醮醯醵醴醺豕鹾趸跫踅蹙蹩趵趿趼趺跄跖跗跚跞跎跏跛跆跬跷跸跣跹跻跤踉跽踔踝踟踬踮踣踯踺蹀踹踵踽踱蹉蹁蹂蹑蹒蹊蹰蹶蹼蹯蹴躅躏躔躐躜躞豸貂貊貅貘貔斛觖觞觚觜�".split("");
for(j = 0; j != D[245].length; ++j) if(D[245][j].charCodeAt(0) !== 0xFFFD) { e[D[245][j]] = 62720 + j; d[62720 + j] = D[245][j];}
D[246] = "����������������������������������������������������������������鯜鯝鯞鯟鯠鯡鯢鯣鯤鯥鯦鯧鯨鯩鯪鯫鯬鯭鯮鯯鯰鯱鯲鯳鯴鯵鯶鯷鯸鯹鯺鯻鯼鯽鯾鯿鰀鰁鰂鰃鰄鰅鰆鰇鰈鰉鰊鰋鰌鰍鰎鰏鰐鰑鰒鰓鰔鰕鰖鰗鰘鰙鰚�鰛鰜鰝鰞鰟鰠鰡鰢鰣鰤鰥鰦鰧鰨鰩鰪鰫鰬鰭鰮鰯鰰鰱鰲鰳鰴鰵鰶鰷鰸鰹鰺鰻觥觫觯訾謦靓雩雳雯霆霁霈霏霎霪霭霰霾龀龃龅龆龇龈龉龊龌黾鼋鼍隹隼隽雎雒瞿雠銎銮鋈錾鍪鏊鎏鐾鑫鱿鲂鲅鲆鲇鲈稣鲋鲎鲐鲑鲒鲔鲕鲚鲛鲞鲟鲠鲡鲢鲣鲥鲦鲧鲨鲩鲫鲭鲮鲰鲱鲲鲳鲴鲵鲶鲷鲺鲻鲼鲽鳄鳅鳆鳇鳊鳋�".split("");
for(j = 0; j != D[246].length; ++j) if(D[246][j].charCodeAt(0) !== 0xFFFD) { e[D[246][j]] = 62976 + j; d[62976 + j] = D[246][j];}
D[247] = "����������������������������������������������������������������鰼鰽鰾鰿鱀鱁鱂鱃鱄鱅鱆鱇鱈鱉鱊鱋鱌鱍鱎鱏鱐鱑鱒鱓鱔鱕鱖鱗鱘鱙鱚鱛鱜鱝鱞鱟鱠鱡鱢鱣鱤鱥鱦鱧鱨鱩鱪鱫鱬鱭鱮鱯鱰鱱鱲鱳鱴鱵鱶鱷鱸鱹鱺�鱻鱽鱾鲀鲃鲄鲉鲊鲌鲏鲓鲖鲗鲘鲙鲝鲪鲬鲯鲹鲾鲿鳀鳁鳂鳈鳉鳑鳒鳚鳛鳠鳡鳌鳍鳎鳏鳐鳓鳔鳕鳗鳘鳙鳜鳝鳟鳢靼鞅鞑鞒鞔鞯鞫鞣鞲鞴骱骰骷鹘骶骺骼髁髀髅髂髋髌髑魅魃魇魉魈魍魑飨餍餮饕饔髟髡髦髯髫髻髭髹鬈鬏鬓鬟鬣麽麾縻麂麇麈麋麒鏖麝麟黛黜黝黠黟黢黩黧黥黪黯鼢鼬鼯鼹鼷鼽鼾齄�".split("");
for(j = 0; j != D[247].length; ++j) if(D[247][j].charCodeAt(0) !== 0xFFFD) { e[D[247][j]] = 63232 + j; d[63232 + j] = D[247][j];}
D[248] = "����������������������������������������������������������������鳣鳤鳥鳦鳧鳨鳩鳪鳫鳬鳭鳮鳯鳰鳱鳲鳳鳴鳵鳶鳷鳸鳹鳺鳻鳼鳽鳾鳿鴀鴁鴂鴃鴄鴅鴆鴇鴈鴉鴊鴋鴌鴍鴎鴏鴐鴑鴒鴓鴔鴕鴖鴗鴘鴙鴚鴛鴜鴝鴞鴟鴠鴡�鴢鴣鴤鴥鴦鴧鴨鴩鴪鴫鴬鴭鴮鴯鴰鴱鴲鴳鴴鴵鴶鴷鴸鴹鴺鴻鴼鴽鴾鴿鵀鵁鵂�����������������������������������������������������������������������������������������������".split("");
for(j = 0; j != D[248].length; ++j) if(D[248][j].charCodeAt(0) !== 0xFFFD) { e[D[248][j]] = 63488 + j; d[63488 + j] = D[248][j];}
D[249] = "����������������������������������������������������������������鵃鵄鵅鵆鵇鵈鵉鵊鵋鵌鵍鵎鵏鵐鵑鵒鵓鵔鵕鵖鵗鵘鵙鵚鵛鵜鵝鵞鵟鵠鵡鵢鵣鵤鵥鵦鵧鵨鵩鵪鵫鵬鵭鵮鵯鵰鵱鵲鵳鵴鵵鵶鵷鵸鵹鵺鵻鵼鵽鵾鵿鶀鶁�鶂鶃鶄鶅鶆鶇鶈鶉鶊鶋鶌鶍鶎鶏鶐鶑鶒鶓鶔鶕鶖鶗鶘鶙鶚鶛鶜鶝鶞鶟鶠鶡鶢�����������������������������������������������������������������������������������������������".split("");
for(j = 0; j != D[249].length; ++j) if(D[249][j].charCodeAt(0) !== 0xFFFD) { e[D[249][j]] = 63744 + j; d[63744 + j] = D[249][j];}
D[250] = "����������������������������������������������������������������鶣鶤鶥鶦鶧鶨鶩鶪鶫鶬鶭鶮鶯鶰鶱鶲鶳鶴鶵鶶鶷鶸鶹鶺鶻鶼鶽鶾鶿鷀鷁鷂鷃鷄鷅鷆鷇鷈鷉鷊鷋鷌鷍鷎鷏鷐鷑鷒鷓鷔鷕鷖鷗鷘鷙鷚鷛鷜鷝鷞鷟鷠鷡�鷢鷣鷤鷥鷦鷧鷨鷩鷪鷫鷬鷭鷮鷯鷰鷱鷲鷳鷴鷵鷶鷷鷸鷹鷺鷻鷼鷽鷾鷿鸀鸁鸂�����������������������������������������������������������������������������������������������".split("");
for(j = 0; j != D[250].length; ++j) if(D[250][j].charCodeAt(0) !== 0xFFFD) { e[D[250][j]] = 64000 + j; d[64000 + j] = D[250][j];}
D[251] = "����������������������������������������������������������������鸃鸄鸅鸆鸇鸈鸉鸊鸋鸌鸍鸎鸏鸐鸑鸒鸓鸔鸕鸖鸗鸘鸙鸚鸛鸜鸝鸞鸤鸧鸮鸰鸴鸻鸼鹀鹍鹐鹒鹓鹔鹖鹙鹝鹟鹠鹡鹢鹥鹮鹯鹲鹴鹵鹶鹷鹸鹹鹺鹻鹼鹽麀�麁麃麄麅麆麉麊麌麍麎麏麐麑麔麕麖麗麘麙麚麛麜麞麠麡麢麣麤麥麧麨麩麪�����������������������������������������������������������������������������������������������".split("");
for(j = 0; j != D[251].length; ++j) if(D[251][j].charCodeAt(0) !== 0xFFFD) { e[D[251][j]] = 64256 + j; d[64256 + j] = D[251][j];}
D[252] = "����������������������������������������������������������������麫麬麭麮麯麰麱麲麳麵麶麷麹麺麼麿黀黁黂黃黅黆黇黈黊黋黌黐黒黓黕黖黗黙黚點黡黣黤黦黨黫黬黭黮黰黱黲黳黴黵黶黷黸黺黽黿鼀鼁鼂鼃鼄鼅�鼆鼇鼈鼉鼊鼌鼏鼑鼒鼔鼕鼖鼘鼚鼛鼜鼝鼞鼟鼡鼣鼤鼥鼦鼧鼨鼩鼪鼫鼭鼮鼰鼱�����������������������������������������������������������������������������������������������".split("");
for(j = 0; j != D[252].length; ++j) if(D[252][j].charCodeAt(0) !== 0xFFFD) { e[D[252][j]] = 64512 + j; d[64512 + j] = D[252][j];}
D[253] = "����������������������������������������������������������������鼲鼳鼴鼵鼶鼸鼺鼼鼿齀齁齂齃齅齆齇齈齉齊齋齌齍齎齏齒齓齔齕齖齗齘齙齚齛齜齝齞齟齠齡齢齣齤齥齦齧齨齩齪齫齬齭齮齯齰齱齲齳齴齵齶齷齸�齹齺齻齼齽齾龁龂龍龎龏龐龑龒龓龔龕龖龗龘龜龝龞龡龢龣龤龥郎凉秊裏隣�����������������������������������������������������������������������������������������������".split("");
for(j = 0; j != D[253].length; ++j) if(D[253][j].charCodeAt(0) !== 0xFFFD) { e[D[253][j]] = 64768 + j; d[64768 + j] = D[253][j];}
D[254] = "����������������������������������������������������������������兀嗀﨎﨏﨑﨓﨔礼﨟蘒﨡﨣﨤﨧﨨﨩��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������".split("");
for(j = 0; j != D[254].length; ++j) if(D[254][j].charCodeAt(0) !== 0xFFFD) { e[D[254][j]] = 65024 + j; d[65024 + j] = D[254][j];}
return {"enc": e, "dec": d }; })();
cptable[949] = (function(){ var d = [], e = {}, D = [], j;
D[0] = "\u0000\u0001\u0002\u0003\u0004\u0005\u0006\u0007\b\t\n\u000b\f\r\u000e\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~��������������������������������������������������������������������������������������������������������������������������������".split("");
for(j = 0; j != D[0].length; ++j) if(D[0][j].charCodeAt(0) !== 0xFFFD) { e[D[0][j]] = 0 + j; d[0 + j] = D[0][j];}
D[129] = "�����������������������������������������������������������������갂갃갅갆갋갌갍갎갏갘갞갟갡갢갣갥갦갧갨갩갪갫갮갲갳갴������갵갶갷갺갻갽갾갿걁걂걃걄걅걆걇걈걉걊걌걎걏걐걑걒걓걕������걖걗걙걚걛걝걞걟걠걡걢걣걤걥걦걧걨걩걪걫걬걭걮걯걲걳걵걶걹걻걼걽걾걿겂겇겈겍겎겏겑겒겓겕겖겗겘겙겚겛겞겢겣겤겥겦겧겫겭겮겱겲겳겴겵겶겷겺겾겿곀곂곃곅곆곇곉곊곋곍곎곏곐곑곒곓곔곖곘곙곚곛곜곝곞곟곢곣곥곦곩곫곭곮곲곴곷곸곹곺곻곾곿괁괂괃괅괇괈괉괊괋괎괐괒괓�".split("");
for(j = 0; j != D[129].length; ++j) if(D[129][j].charCodeAt(0) !== 0xFFFD) { e[D[129][j]] = 33024 + j; d[33024 + j] = D[129][j];}
D[130] = "�����������������������������������������������������������������괔괕괖괗괙괚괛괝괞괟괡괢괣괤괥괦괧괨괪괫괮괯괰괱괲괳������괶괷괹괺괻괽괾괿굀굁굂굃굆굈굊굋굌굍굎굏굑굒굓굕굖굗������굙굚굛굜굝굞굟굠굢굤굥굦굧굨굩굪굫굮굯굱굲굷굸굹굺굾궀궃궄궅궆궇궊궋궍궎궏궑궒궓궔궕궖궗궘궙궚궛궞궟궠궡궢궣궥궦궧궨궩궪궫궬궭궮궯궰궱궲궳궴궵궶궸궹궺궻궼궽궾궿귂귃귅귆귇귉귊귋귌귍귎귏귒귔귕귖귗귘귙귚귛귝귞귟귡귢귣귥귦귧귨귩귪귫귬귭귮귯귰귱귲귳귴귵귶귷�".split("");
for(j = 0; j != D[130].length; ++j) if(D[130][j].charCodeAt(0) !== 0xFFFD) { e[D[130][j]] = 33280 + j; d[33280 + j] = D[130][j];}
D[131] = "�����������������������������������������������������������������귺귻귽귾긂긃긄긅긆긇긊긌긎긏긐긑긒긓긕긖긗긘긙긚긛긜������긝긞긟긠긡긢긣긤긥긦긧긨긩긪긫긬긭긮긯긲긳긵긶긹긻긼������긽긾긿깂깄깇깈깉깋깏깑깒깓깕깗깘깙깚깛깞깢깣깤깦깧깪깫깭깮깯깱깲깳깴깵깶깷깺깾깿꺀꺁꺂꺃꺆꺇꺈꺉꺊꺋꺍꺎꺏꺐꺑꺒꺓꺔꺕꺖꺗꺘꺙꺚꺛꺜꺝꺞꺟꺠꺡꺢꺣꺤꺥꺦꺧꺨꺩꺪꺫꺬꺭꺮꺯꺰꺱꺲꺳꺴꺵꺶꺷꺸꺹꺺꺻꺿껁껂껃껅껆껇껈껉껊껋껎껒껓껔껕껖껗껚껛껝껞껟껠껡껢껣껤껥�".split("");
for(j = 0; j != D[131].length; ++j) if(D[131][j].charCodeAt(0) !== 0xFFFD) { e[D[131][j]] = 33536 + j; d[33536 + j] = D[131][j];}
D[132] = "�����������������������������������������������������������������껦껧껩껪껬껮껯껰껱껲껳껵껶껷껹껺껻껽껾껿꼀꼁꼂꼃꼄꼅������꼆꼉꼊꼋꼌꼎꼏꼑꼒꼓꼔꼕꼖꼗꼘꼙꼚꼛꼜꼝꼞꼟꼠꼡꼢꼣������꼤꼥꼦꼧꼨꼩꼪꼫꼮꼯꼱꼳꼵꼶꼷꼸꼹꼺꼻꼾꽀꽄꽅꽆꽇꽊꽋꽌꽍꽎꽏꽑꽒꽓꽔꽕꽖꽗꽘꽙꽚꽛꽞꽟꽠꽡꽢꽣꽦꽧꽨꽩꽪꽫꽬꽭꽮꽯꽰꽱꽲꽳꽴꽵꽶꽷꽸꽺꽻꽼꽽꽾꽿꾁꾂꾃꾅꾆꾇꾉꾊꾋꾌꾍꾎꾏꾒꾓꾔꾖꾗꾘꾙꾚꾛꾝꾞꾟꾠꾡꾢꾣꾤꾥꾦꾧꾨꾩꾪꾫꾬꾭꾮꾯꾰꾱꾲꾳꾴꾵꾶꾷꾺꾻꾽꾾�".split("");
for(j = 0; j != D[132].length; ++j) if(D[132][j].charCodeAt(0) !== 0xFFFD) { e[D[132][j]] = 33792 + j; d[33792 + j] = D[132][j];}
D[133] = "�����������������������������������������������������������������꾿꿁꿂꿃꿄꿅꿆꿊꿌꿏꿐꿑꿒꿓꿕꿖꿗꿘꿙꿚꿛꿝꿞꿟꿠꿡������꿢꿣꿤꿥꿦꿧꿪꿫꿬꿭꿮꿯꿲꿳꿵꿶꿷꿹꿺꿻꿼꿽꿾꿿뀂뀃������뀅뀆뀇뀈뀉뀊뀋뀍뀎뀏뀑뀒뀓뀕뀖뀗뀘뀙뀚뀛뀞뀟뀠뀡뀢뀣뀤뀥뀦뀧뀩뀪뀫뀬뀭뀮뀯뀰뀱뀲뀳뀴뀵뀶뀷뀸뀹뀺뀻뀼뀽뀾뀿끀끁끂끃끆끇끉끋끍끏끐끑끒끖끘끚끛끜끞끟끠끡끢끣끤끥끦끧끨끩끪끫끬끭끮끯끰끱끲끳끴끵끶끷끸끹끺끻끾끿낁낂낃낅낆낇낈낉낊낋낎낐낒낓낔낕낖낗낛낝낞낣낤�".split("");
for(j = 0; j != D[133].length; ++j) if(D[133][j].charCodeAt(0) !== 0xFFFD) { e[D[133][j]] = 34048 + j; d[34048 + j] = D[133][j];}
D[134] = "�����������������������������������������������������������������낥낦낧낪낰낲낶낷낹낺낻낽낾낿냀냁냂냃냆냊냋냌냍냎냏냒������냓냕냖냗냙냚냛냜냝냞냟냡냢냣냤냦냧냨냩냪냫냬냭냮냯냰������냱냲냳냴냵냶냷냸냹냺냻냼냽냾냿넀넁넂넃넄넅넆넇넊넍넎넏넑넔넕넖넗넚넞넟넠넡넢넦넧넩넪넫넭넮넯넰넱넲넳넶넺넻넼넽넾넿녂녃녅녆녇녉녊녋녌녍녎녏녒녓녖녗녙녚녛녝녞녟녡녢녣녤녥녦녧녨녩녪녫녬녭녮녯녰녱녲녳녴녵녶녷녺녻녽녾녿놁놃놄놅놆놇놊놌놎놏놐놑놕놖놗놙놚놛놝�".split("");
for(j = 0; j != D[134].length; ++j) if(D[134][j].charCodeAt(0) !== 0xFFFD) { e[D[134][j]] = 34304 + j; d[34304 + j] = D[134][j];}
D[135] = "�����������������������������������������������������������������놞놟놠놡놢놣놤놥놦놧놩놪놫놬놭놮놯놰놱놲놳놴놵놶놷놸������놹놺놻놼놽놾놿뇀뇁뇂뇃뇄뇅뇆뇇뇈뇉뇊뇋뇍뇎뇏뇑뇒뇓뇕������뇖뇗뇘뇙뇚뇛뇞뇠뇡뇢뇣뇤뇥뇦뇧뇪뇫뇭뇮뇯뇱뇲뇳뇴뇵뇶뇷뇸뇺뇼뇾뇿눀눁눂눃눆눇눉눊눍눎눏눐눑눒눓눖눘눚눛눜눝눞눟눡눢눣눤눥눦눧눨눩눪눫눬눭눮눯눰눱눲눳눵눶눷눸눹눺눻눽눾눿뉀뉁뉂뉃뉄뉅뉆뉇뉈뉉뉊뉋뉌뉍뉎뉏뉐뉑뉒뉓뉔뉕뉖뉗뉙뉚뉛뉝뉞뉟뉡뉢뉣뉤뉥뉦뉧뉪뉫뉬뉭뉮�".split("");
for(j = 0; j != D[135].length; ++j) if(D[135][j].charCodeAt(0) !== 0xFFFD) { e[D[135][j]] = 34560 + j; d[34560 + j] = D[135][j];}
D[136] = "�����������������������������������������������������������������뉯뉰뉱뉲뉳뉶뉷뉸뉹뉺뉻뉽뉾뉿늀늁늂늃늆늇늈늊늋늌늍늎������늏늒늓늕늖늗늛늜늝늞늟늢늤늧늨늩늫늭늮늯늱늲늳늵늶늷������늸늹늺늻늼늽늾늿닀닁닂닃닄닅닆닇닊닋닍닎닏닑닓닔닕닖닗닚닜닞닟닠닡닣닧닩닪닰닱닲닶닼닽닾댂댃댅댆댇댉댊댋댌댍댎댏댒댖댗댘댙댚댛댝댞댟댠댡댢댣댤댥댦댧댨댩댪댫댬댭댮댯댰댱댲댳댴댵댶댷댸댹댺댻댼댽댾댿덀덁덂덃덄덅덆덇덈덉덊덋덌덍덎덏덐덑덒덓덗덙덚덝덠덡덢덣�".split("");
for(j = 0; j != D[136].length; ++j) if(D[136][j].charCodeAt(0) !== 0xFFFD) { e[D[136][j]] = 34816 + j; d[34816 + j] = D[136][j];}
D[137] = "�����������������������������������������������������������������덦덨덪덬덭덯덲덳덵덶덷덹덺덻덼덽덾덿뎂뎆뎇뎈뎉뎊뎋뎍������뎎뎏뎑뎒뎓뎕뎖뎗뎘뎙뎚뎛뎜뎝뎞뎟뎢뎣뎤뎥뎦뎧뎩뎪뎫뎭������뎮뎯뎰뎱뎲뎳뎴뎵뎶뎷뎸뎹뎺뎻뎼뎽뎾뎿돀돁돂돃돆돇돉돊돍돏돑돒돓돖돘돚돜돞돟돡돢돣돥돦돧돩돪돫돬돭돮돯돰돱돲돳돴돵돶돷돸돹돺돻돽돾돿됀됁됂됃됄됅됆됇됈됉됊됋됌됍됎됏됑됒됓됔됕됖됗됙됚됛됝됞됟됡됢됣됤됥됦됧됪됬됭됮됯됰됱됲됳됵됶됷됸됹됺됻됼됽됾됿둀둁둂둃둄�".split("");
for(j = 0; j != D[137].length; ++j) if(D[137][j].charCodeAt(0) !== 0xFFFD) { e[D[137][j]] = 35072 + j; d[35072 + j] = D[137][j];}
D[138] = "�����������������������������������������������������������������둅둆둇둈둉둊둋둌둍둎둏둒둓둕둖둗둙둚둛둜둝둞둟둢둤둦������둧둨둩둪둫둭둮둯둰둱둲둳둴둵둶둷둸둹둺둻둼둽둾둿뒁뒂������뒃뒄뒅뒆뒇뒉뒊뒋뒌뒍뒎뒏뒐뒑뒒뒓뒔뒕뒖뒗뒘뒙뒚뒛뒜뒞뒟뒠뒡뒢뒣뒥뒦뒧뒩뒪뒫뒭뒮뒯뒰뒱뒲뒳뒴뒶뒸뒺뒻뒼뒽뒾뒿듁듂듃듅듆듇듉듊듋듌듍듎듏듑듒듓듔듖듗듘듙듚듛듞듟듡듢듥듧듨듩듪듫듮듰듲듳듴듵듶듷듹듺듻듼듽듾듿딀딁딂딃딄딅딆딇딈딉딊딋딌딍딎딏딐딑딒딓딖딗딙딚딝�".split("");
for(j = 0; j != D[138].length; ++j) if(D[138][j].charCodeAt(0) !== 0xFFFD) { e[D[138][j]] = 35328 + j; d[35328 + j] = D[138][j];}
D[139] = "�����������������������������������������������������������������딞딟딠딡딢딣딦딫딬딭딮딯딲딳딵딶딷딹딺딻딼딽딾딿땂땆������땇땈땉땊땎땏땑땒땓땕땖땗땘땙땚땛땞땢땣땤땥땦땧땨땩땪������땫땬땭땮땯땰땱땲땳땴땵땶땷땸땹땺땻땼땽땾땿떀떁떂떃떄떅떆떇떈떉떊떋떌떍떎떏떐떑떒떓떔떕떖떗떘떙떚떛떜떝떞떟떢떣떥떦떧떩떬떭떮떯떲떶떷떸떹떺떾떿뗁뗂뗃뗅뗆뗇뗈뗉뗊뗋뗎뗒뗓뗔뗕뗖뗗뗙뗚뗛뗜뗝뗞뗟뗠뗡뗢뗣뗤뗥뗦뗧뗨뗩뗪뗫뗭뗮뗯뗰뗱뗲뗳뗴뗵뗶뗷뗸뗹뗺뗻뗼뗽뗾뗿�".split("");
for(j = 0; j != D[139].length; ++j) if(D[139][j].charCodeAt(0) !== 0xFFFD) { e[D[139][j]] = 35584 + j; d[35584 + j] = D[139][j];}
D[140] = "�����������������������������������������������������������������똀똁똂똃똄똅똆똇똈똉똊똋똌똍똎똏똒똓똕똖똗똙똚똛똜똝������똞똟똠똡똢똣똤똦똧똨똩똪똫똭똮똯똰똱똲똳똵똶똷똸똹똺������똻똼똽똾똿뙀뙁뙂뙃뙄뙅뙆뙇뙉뙊뙋뙌뙍뙎뙏뙐뙑뙒뙓뙔뙕뙖뙗뙘뙙뙚뙛뙜뙝뙞뙟뙠뙡뙢뙣뙥뙦뙧뙩뙪뙫뙬뙭뙮뙯뙰뙱뙲뙳뙴뙵뙶뙷뙸뙹뙺뙻뙼뙽뙾뙿뚀뚁뚂뚃뚄뚅뚆뚇뚈뚉뚊뚋뚌뚍뚎뚏뚐뚑뚒뚓뚔뚕뚖뚗뚘뚙뚚뚛뚞뚟뚡뚢뚣뚥뚦뚧뚨뚩뚪뚭뚮뚯뚰뚲뚳뚴뚵뚶뚷뚸뚹뚺뚻뚼뚽뚾뚿뛀뛁뛂�".split("");
for(j = 0; j != D[140].length; ++j) if(D[140][j].charCodeAt(0) !== 0xFFFD) { e[D[140][j]] = 35840 + j; d[35840 + j] = D[140][j];}
D[141] = "�����������������������������������������������������������������뛃뛄뛅뛆뛇뛈뛉뛊뛋뛌뛍뛎뛏뛐뛑뛒뛓뛕뛖뛗뛘뛙뛚뛛뛜뛝������뛞뛟뛠뛡뛢뛣뛤뛥뛦뛧뛨뛩뛪뛫뛬뛭뛮뛯뛱뛲뛳뛵뛶뛷뛹뛺������뛻뛼뛽뛾뛿뜂뜃뜄뜆뜇뜈뜉뜊뜋뜌뜍뜎뜏뜐뜑뜒뜓뜔뜕뜖뜗뜘뜙뜚뜛뜜뜝뜞뜟뜠뜡뜢뜣뜤뜥뜦뜧뜪뜫뜭뜮뜱뜲뜳뜴뜵뜶뜷뜺뜼뜽뜾뜿띀띁띂띃띅띆띇띉띊띋띍띎띏띐띑띒띓띖띗띘띙띚띛띜띝띞띟띡띢띣띥띦띧띩띪띫띬띭띮띯띲띴띶띷띸띹띺띻띾띿랁랂랃랅랆랇랈랉랊랋랎랓랔랕랚랛랝랞�".split("");
for(j = 0; j != D[141].length; ++j) if(D[141][j].charCodeAt(0) !== 0xFFFD) { e[D[141][j]] = 36096 + j; d[36096 + j] = D[141][j];}
D[142] = "�����������������������������������������������������������������랟랡랢랣랤랥랦랧랪랮랯랰랱랲랳랶랷랹랺랻랼랽랾랿럀럁������럂럃럄럅럆럈럊럋럌럍럎럏럐럑럒럓럔럕럖럗럘럙럚럛럜럝������럞럟럠럡럢럣럤럥럦럧럨럩럪럫럮럯럱럲럳럵럶럷럸럹럺럻럾렂렃렄렅렆렊렋렍렎렏렑렒렓렔렕렖렗렚렜렞렟렠렡렢렣렦렧렩렪렫렭렮렯렰렱렲렳렶렺렻렼렽렾렿롁롂롃롅롆롇롈롉롊롋롌롍롎롏롐롒롔롕롖롗롘롙롚롛롞롟롡롢롣롥롦롧롨롩롪롫롮롰롲롳롴롵롶롷롹롺롻롽롾롿뢀뢁뢂뢃뢄�".split("");
for(j = 0; j != D[142].length; ++j) if(D[142][j].charCodeAt(0) !== 0xFFFD) { e[D[142][j]] = 36352 + j; d[36352 + j] = D[142][j];}
D[143] = "�����������������������������������������������������������������뢅뢆뢇뢈뢉뢊뢋뢌뢎뢏뢐뢑뢒뢓뢔뢕뢖뢗뢘뢙뢚뢛뢜뢝뢞뢟������뢠뢡뢢뢣뢤뢥뢦뢧뢩뢪뢫뢬뢭뢮뢯뢱뢲뢳뢵뢶뢷뢹뢺뢻뢼뢽������뢾뢿룂룄룆룇룈룉룊룋룍룎룏룑룒룓룕룖룗룘룙룚룛룜룞룠룢룣룤룥룦룧룪룫룭룮룯룱룲룳룴룵룶룷룺룼룾룿뤀뤁뤂뤃뤅뤆뤇뤈뤉뤊뤋뤌뤍뤎뤏뤐뤑뤒뤓뤔뤕뤖뤗뤙뤚뤛뤜뤝뤞뤟뤡뤢뤣뤤뤥뤦뤧뤨뤩뤪뤫뤬뤭뤮뤯뤰뤱뤲뤳뤴뤵뤶뤷뤸뤹뤺뤻뤾뤿륁륂륃륅륆륇륈륉륊륋륍륎륐륒륓륔륕륖륗�".split("");
for(j = 0; j != D[143].length; ++j) if(D[143][j].charCodeAt(0) !== 0xFFFD) { e[D[143][j]] = 36608 + j; d[36608 + j] = D[143][j];}
D[144] = "�����������������������������������������������������������������륚륛륝륞륟륡륢륣륤륥륦륧륪륬륮륯륰륱륲륳륶륷륹륺륻륽������륾륿릀릁릂릃릆릈릋릌릏릐릑릒릓릔릕릖릗릘릙릚릛릜릝릞������릟릠릡릢릣릤릥릦릧릨릩릪릫릮릯릱릲릳릵릶릷릸릹릺릻릾맀맂맃맄맅맆맇맊맋맍맓맔맕맖맗맚맜맟맠맢맦맧맩맪맫맭맮맯맰맱맲맳맶맻맼맽맾맿먂먃먄먅먆먇먉먊먋먌먍먎먏먐먑먒먓먔먖먗먘먙먚먛먜먝먞먟먠먡먢먣먤먥먦먧먨먩먪먫먬먭먮먯먰먱먲먳먴먵먶먷먺먻먽먾먿멁멃멄멅멆�".split("");
for(j = 0; j != D[144].length; ++j) if(D[144][j].charCodeAt(0) !== 0xFFFD) { e[D[144][j]] = 36864 + j; d[36864 + j] = D[144][j];}
D[145] = "�����������������������������������������������������������������멇멊멌멏멐멑멒멖멗멙멚멛멝멞멟멠멡멢멣멦멪멫멬멭멮멯������멲멳멵멶멷멹멺멻멼멽멾멿몀몁몂몆몈몉몊몋몍몎몏몐몑몒������몓몔몕몖몗몘몙몚몛몜몝몞몟몠몡몢몣몤몥몦몧몪몭몮몯몱몳몴몵몶몷몺몼몾몿뫀뫁뫂뫃뫅뫆뫇뫉뫊뫋뫌뫍뫎뫏뫐뫑뫒뫓뫔뫕뫖뫗뫚뫛뫜뫝뫞뫟뫠뫡뫢뫣뫤뫥뫦뫧뫨뫩뫪뫫뫬뫭뫮뫯뫰뫱뫲뫳뫴뫵뫶뫷뫸뫹뫺뫻뫽뫾뫿묁묂묃묅묆묇묈묉묊묋묌묎묐묒묓묔묕묖묗묙묚묛묝묞묟묡묢묣묤묥묦묧�".split("");
for(j = 0; j != D[145].length; ++j) if(D[145][j].charCodeAt(0) !== 0xFFFD) { e[D[145][j]] = 37120 + j; d[37120 + j] = D[145][j];}
D[146] = "�����������������������������������������������������������������묨묪묬묭묮묯묰묱묲묳묷묹묺묿뭀뭁뭂뭃뭆뭈뭊뭋뭌뭎뭑뭒������뭓뭕뭖뭗뭙뭚뭛뭜뭝뭞뭟뭠뭢뭤뭥뭦뭧뭨뭩뭪뭫뭭뭮뭯뭰뭱������뭲뭳뭴뭵뭶뭷뭸뭹뭺뭻뭼뭽뭾뭿뮀뮁뮂뮃뮄뮅뮆뮇뮉뮊뮋뮍뮎뮏뮑뮒뮓뮔뮕뮖뮗뮘뮙뮚뮛뮜뮝뮞뮟뮠뮡뮢뮣뮥뮦뮧뮩뮪뮫뮭뮮뮯뮰뮱뮲뮳뮵뮶뮸뮹뮺뮻뮼뮽뮾뮿믁믂믃믅믆믇믉믊믋믌믍믎믏믑믒믔믕믖믗믘믙믚믛믜믝믞믟믠믡믢믣믤믥믦믧믨믩믪믫믬믭믮믯믰믱믲믳믴믵믶믷믺믻믽믾밁�".split("");
for(j = 0; j != D[146].length; ++j) if(D[146][j].charCodeAt(0) !== 0xFFFD) { e[D[146][j]] = 37376 + j; d[37376 + j] = D[146][j];}
D[147] = "�����������������������������������������������������������������밃밄밅밆밇밊밎밐밒밓밙밚밠밡밢밣밦밨밪밫밬밮밯밲밳밵������밶밷밹밺밻밼밽밾밿뱂뱆뱇뱈뱊뱋뱎뱏뱑뱒뱓뱔뱕뱖뱗뱘뱙������뱚뱛뱜뱞뱟뱠뱡뱢뱣뱤뱥뱦뱧뱨뱩뱪뱫뱬뱭뱮뱯뱰뱱뱲뱳뱴뱵뱶뱷뱸뱹뱺뱻뱼뱽뱾뱿벀벁벂벃벆벇벉벊벍벏벐벑벒벓벖벘벛벜벝벞벟벢벣벥벦벩벪벫벬벭벮벯벲벶벷벸벹벺벻벾벿볁볂볃볅볆볇볈볉볊볋볌볎볒볓볔볖볗볙볚볛볝볞볟볠볡볢볣볤볥볦볧볨볩볪볫볬볭볮볯볰볱볲볳볷볹볺볻볽�".split("");
for(j = 0; j != D[147].length; ++j) if(D[147][j].charCodeAt(0) !== 0xFFFD) { e[D[147][j]] = 37632 + j; d[37632 + j] = D[147][j];}
D[148] = "�����������������������������������������������������������������볾볿봀봁봂봃봆봈봊봋봌봍봎봏봑봒봓봕봖봗봘봙봚봛봜봝������봞봟봠봡봢봣봥봦봧봨봩봪봫봭봮봯봰봱봲봳봴봵봶봷봸봹������봺봻봼봽봾봿뵁뵂뵃뵄뵅뵆뵇뵊뵋뵍뵎뵏뵑뵒뵓뵔뵕뵖뵗뵚뵛뵜뵝뵞뵟뵠뵡뵢뵣뵥뵦뵧뵩뵪뵫뵬뵭뵮뵯뵰뵱뵲뵳뵴뵵뵶뵷뵸뵹뵺뵻뵼뵽뵾뵿붂붃붅붆붋붌붍붎붏붒붔붖붗붘붛붝붞붟붠붡붢붣붥붦붧붨붩붪붫붬붭붮붯붱붲붳붴붵붶붷붹붺붻붼붽붾붿뷀뷁뷂뷃뷄뷅뷆뷇뷈뷉뷊뷋뷌뷍뷎뷏뷐뷑�".split("");
for(j = 0; j != D[148].length; ++j) if(D[148][j].charCodeAt(0) !== 0xFFFD) { e[D[148][j]] = 37888 + j; d[37888 + j] = D[148][j];}
D[149] = "�����������������������������������������������������������������뷒뷓뷖뷗뷙뷚뷛뷝뷞뷟뷠뷡뷢뷣뷤뷥뷦뷧뷨뷪뷫뷬뷭뷮뷯뷱������뷲뷳뷵뷶뷷뷹뷺뷻뷼뷽뷾뷿븁븂븄븆븇븈븉븊븋븎븏븑븒븓������븕븖븗븘븙븚븛븞븠븡븢븣븤븥븦븧븨븩븪븫븬븭븮븯븰븱븲븳븴븵븶븷븸븹븺븻븼븽븾븿빀빁빂빃빆빇빉빊빋빍빏빐빑빒빓빖빘빜빝빞빟빢빣빥빦빧빩빫빬빭빮빯빲빶빷빸빹빺빾빿뺁뺂뺃뺅뺆뺇뺈뺉뺊뺋뺎뺒뺓뺔뺕뺖뺗뺚뺛뺜뺝뺞뺟뺠뺡뺢뺣뺤뺥뺦뺧뺩뺪뺫뺬뺭뺮뺯뺰뺱뺲뺳뺴뺵뺶뺷�".split("");
for(j = 0; j != D[149].length; ++j) if(D[149][j].charCodeAt(0) !== 0xFFFD) { e[D[149][j]] = 38144 + j; d[38144 + j] = D[149][j];}
D[150] = "�����������������������������������������������������������������뺸뺹뺺뺻뺼뺽뺾뺿뻀뻁뻂뻃뻄뻅뻆뻇뻈뻉뻊뻋뻌뻍뻎뻏뻒뻓������뻕뻖뻙뻚뻛뻜뻝뻞뻟뻡뻢뻦뻧뻨뻩뻪뻫뻭뻮뻯뻰뻱뻲뻳뻴뻵������뻶뻷뻸뻹뻺뻻뻼뻽뻾뻿뼀뼂뼃뼄뼅뼆뼇뼊뼋뼌뼍뼎뼏뼐뼑뼒뼓뼔뼕뼖뼗뼚뼞뼟뼠뼡뼢뼣뼤뼥뼦뼧뼨뼩뼪뼫뼬뼭뼮뼯뼰뼱뼲뼳뼴뼵뼶뼷뼸뼹뼺뼻뼼뼽뼾뼿뽂뽃뽅뽆뽇뽉뽊뽋뽌뽍뽎뽏뽒뽓뽔뽖뽗뽘뽙뽚뽛뽜뽝뽞뽟뽠뽡뽢뽣뽤뽥뽦뽧뽨뽩뽪뽫뽬뽭뽮뽯뽰뽱뽲뽳뽴뽵뽶뽷뽸뽹뽺뽻뽼뽽뽾뽿뾀뾁뾂�".split("");
for(j = 0; j != D[150].length; ++j) if(D[150][j].charCodeAt(0) !== 0xFFFD) { e[D[150][j]] = 38400 + j; d[38400 + j] = D[150][j];}
D[151] = "�����������������������������������������������������������������뾃뾄뾅뾆뾇뾈뾉뾊뾋뾌뾍뾎뾏뾐뾑뾒뾓뾕뾖뾗뾘뾙뾚뾛뾜뾝������뾞뾟뾠뾡뾢뾣뾤뾥뾦뾧뾨뾩뾪뾫뾬뾭뾮뾯뾱뾲뾳뾴뾵뾶뾷뾸������뾹뾺뾻뾼뾽뾾뾿뿀뿁뿂뿃뿄뿆뿇뿈뿉뿊뿋뿎뿏뿑뿒뿓뿕뿖뿗뿘뿙뿚뿛뿝뿞뿠뿢뿣뿤뿥뿦뿧뿨뿩뿪뿫뿬뿭뿮뿯뿰뿱뿲뿳뿴뿵뿶뿷뿸뿹뿺뿻뿼뿽뿾뿿쀀쀁쀂쀃쀄쀅쀆쀇쀈쀉쀊쀋쀌쀍쀎쀏쀐쀑쀒쀓쀔쀕쀖쀗쀘쀙쀚쀛쀜쀝쀞쀟쀠쀡쀢쀣쀤쀥쀦쀧쀨쀩쀪쀫쀬쀭쀮쀯쀰쀱쀲쀳쀴쀵쀶쀷쀸쀹쀺쀻쀽쀾쀿�".split("");
for(j = 0; j != D[151].length; ++j) if(D[151][j].charCodeAt(0) !== 0xFFFD) { e[D[151][j]] = 38656 + j; d[38656 + j] = D[151][j];}
D[152] = "�����������������������������������������������������������������쁀쁁쁂쁃쁄쁅쁆쁇쁈쁉쁊쁋쁌쁍쁎쁏쁐쁒쁓쁔쁕쁖쁗쁙쁚쁛������쁝쁞쁟쁡쁢쁣쁤쁥쁦쁧쁪쁫쁬쁭쁮쁯쁰쁱쁲쁳쁴쁵쁶쁷쁸쁹������쁺쁻쁼쁽쁾쁿삀삁삂삃삄삅삆삇삈삉삊삋삌삍삎삏삒삓삕삖삗삙삚삛삜삝삞삟삢삤삦삧삨삩삪삫삮삱삲삷삸삹삺삻삾샂샃샄샆샇샊샋샍샎샏샑샒샓샔샕샖샗샚샞샟샠샡샢샣샦샧샩샪샫샭샮샯샰샱샲샳샶샸샺샻샼샽샾샿섁섂섃섅섆섇섉섊섋섌섍섎섏섑섒섓섔섖섗섘섙섚섛섡섢섥섨섩섪섫섮�".split("");
for(j = 0; j != D[152].length; ++j) if(D[152][j].charCodeAt(0) !== 0xFFFD) { e[D[152][j]] = 38912 + j; d[38912 + j] = D[152][j];}
D[153] = "�����������������������������������������������������������������섲섳섴섵섷섺섻섽섾섿셁셂셃셄셅셆셇셊셎셏셐셑셒셓셖셗������셙셚셛셝셞셟셠셡셢셣셦셪셫셬셭셮셯셱셲셳셵셶셷셹셺셻������셼셽셾셿솀솁솂솃솄솆솇솈솉솊솋솏솑솒솓솕솗솘솙솚솛솞솠솢솣솤솦솧솪솫솭솮솯솱솲솳솴솵솶솷솸솹솺솻솼솾솿쇀쇁쇂쇃쇅쇆쇇쇉쇊쇋쇍쇎쇏쇐쇑쇒쇓쇕쇖쇙쇚쇛쇜쇝쇞쇟쇡쇢쇣쇥쇦쇧쇩쇪쇫쇬쇭쇮쇯쇲쇴쇵쇶쇷쇸쇹쇺쇻쇾쇿숁숂숃숅숆숇숈숉숊숋숎숐숒숓숔숕숖숗숚숛숝숞숡숢숣�".split("");
for(j = 0; j != D[153].length; ++j) if(D[153][j].charCodeAt(0) !== 0xFFFD) { e[D[153][j]] = 39168 + j; d[39168 + j] = D[153][j];}
D[154] = "�����������������������������������������������������������������숤숥숦숧숪숬숮숰숳숵숶숷숸숹숺숻숼숽숾숿쉀쉁쉂쉃쉄쉅������쉆쉇쉉쉊쉋쉌쉍쉎쉏쉒쉓쉕쉖쉗쉙쉚쉛쉜쉝쉞쉟쉡쉢쉣쉤쉦������쉧쉨쉩쉪쉫쉮쉯쉱쉲쉳쉵쉶쉷쉸쉹쉺쉻쉾슀슂슃슄슅슆슇슊슋슌슍슎슏슑슒슓슔슕슖슗슙슚슜슞슟슠슡슢슣슦슧슩슪슫슮슯슰슱슲슳슶슸슺슻슼슽슾슿싀싁싂싃싄싅싆싇싈싉싊싋싌싍싎싏싐싑싒싓싔싕싖싗싘싙싚싛싞싟싡싢싥싦싧싨싩싪싮싰싲싳싴싵싷싺싽싾싿쌁쌂쌃쌄쌅쌆쌇쌊쌋쌎쌏�".split("");
for(j = 0; j != D[154].length; ++j) if(D[154][j].charCodeAt(0) !== 0xFFFD) { e[D[154][j]] = 39424 + j; d[39424 + j] = D[154][j];}
D[155] = "�����������������������������������������������������������������쌐쌑쌒쌖쌗쌙쌚쌛쌝쌞쌟쌠쌡쌢쌣쌦쌧쌪쌫쌬쌭쌮쌯쌰쌱쌲������쌳쌴쌵쌶쌷쌸쌹쌺쌻쌼쌽쌾쌿썀썁썂썃썄썆썇썈썉썊썋썌썍������썎썏썐썑썒썓썔썕썖썗썘썙썚썛썜썝썞썟썠썡썢썣썤썥썦썧썪썫썭썮썯썱썳썴썵썶썷썺썻썾썿쎀쎁쎂쎃쎅쎆쎇쎉쎊쎋쎍쎎쎏쎐쎑쎒쎓쎔쎕쎖쎗쎘쎙쎚쎛쎜쎝쎞쎟쎠쎡쎢쎣쎤쎥쎦쎧쎨쎩쎪쎫쎬쎭쎮쎯쎰쎱쎲쎳쎴쎵쎶쎷쎸쎹쎺쎻쎼쎽쎾쎿쏁쏂쏃쏄쏅쏆쏇쏈쏉쏊쏋쏌쏍쏎쏏쏐쏑쏒쏓쏔쏕쏖쏗쏚�".split("");
for(j = 0; j != D[155].length; ++j) if(D[155][j].charCodeAt(0) !== 0xFFFD) { e[D[155][j]] = 39680 + j; d[39680 + j] = D[155][j];}
D[156] = "�����������������������������������������������������������������쏛쏝쏞쏡쏣쏤쏥쏦쏧쏪쏫쏬쏮쏯쏰쏱쏲쏳쏶쏷쏹쏺쏻쏼쏽쏾������쏿쐀쐁쐂쐃쐄쐅쐆쐇쐉쐊쐋쐌쐍쐎쐏쐑쐒쐓쐔쐕쐖쐗쐘쐙쐚������쐛쐜쐝쐞쐟쐠쐡쐢쐣쐥쐦쐧쐨쐩쐪쐫쐭쐮쐯쐱쐲쐳쐵쐶쐷쐸쐹쐺쐻쐾쐿쑀쑁쑂쑃쑄쑅쑆쑇쑉쑊쑋쑌쑍쑎쑏쑐쑑쑒쑓쑔쑕쑖쑗쑘쑙쑚쑛쑜쑝쑞쑟쑠쑡쑢쑣쑦쑧쑩쑪쑫쑭쑮쑯쑰쑱쑲쑳쑶쑷쑸쑺쑻쑼쑽쑾쑿쒁쒂쒃쒄쒅쒆쒇쒈쒉쒊쒋쒌쒍쒎쒏쒐쒑쒒쒓쒕쒖쒗쒘쒙쒚쒛쒝쒞쒟쒠쒡쒢쒣쒤쒥쒦쒧쒨쒩�".split("");
for(j = 0; j != D[156].length; ++j) if(D[156][j].charCodeAt(0) !== 0xFFFD) { e[D[156][j]] = 39936 + j; d[39936 + j] = D[156][j];}
D[157] = "�����������������������������������������������������������������쒪쒫쒬쒭쒮쒯쒰쒱쒲쒳쒴쒵쒶쒷쒹쒺쒻쒽쒾쒿쓀쓁쓂쓃쓄쓅������쓆쓇쓈쓉쓊쓋쓌쓍쓎쓏쓐쓑쓒쓓쓔쓕쓖쓗쓘쓙쓚쓛쓜쓝쓞쓟������쓠쓡쓢쓣쓤쓥쓦쓧쓨쓪쓫쓬쓭쓮쓯쓲쓳쓵쓶쓷쓹쓻쓼쓽쓾씂씃씄씅씆씇씈씉씊씋씍씎씏씑씒씓씕씖씗씘씙씚씛씝씞씟씠씡씢씣씤씥씦씧씪씫씭씮씯씱씲씳씴씵씶씷씺씼씾씿앀앁앂앃앆앇앋앏앐앑앒앖앚앛앜앟앢앣앥앦앧앩앪앫앬앭앮앯앲앶앷앸앹앺앻앾앿얁얂얃얅얆얈얉얊얋얎얐얒얓얔�".split("");
for(j = 0; j != D[157].length; ++j) if(D[157][j].charCodeAt(0) !== 0xFFFD) { e[D[157][j]] = 40192 + j; d[40192 + j] = D[157][j];}
D[158] = "�����������������������������������������������������������������얖얙얚얛얝얞얟얡얢얣얤얥얦얧얨얪얫얬얭얮얯얰얱얲얳얶������얷얺얿엀엁엂엃엋엍엏엒엓엕엖엗엙엚엛엜엝엞엟엢엤엦엧������엨엩엪엫엯엱엲엳엵엸엹엺엻옂옃옄옉옊옋옍옎옏옑옒옓옔옕옖옗옚옝옞옟옠옡옢옣옦옧옩옪옫옯옱옲옶옸옺옼옽옾옿왂왃왅왆왇왉왊왋왌왍왎왏왒왖왗왘왙왚왛왞왟왡왢왣왤왥왦왧왨왩왪왫왭왮왰왲왳왴왵왶왷왺왻왽왾왿욁욂욃욄욅욆욇욊욌욎욏욐욑욒욓욖욗욙욚욛욝욞욟욠욡욢욣욦�".split("");
for(j = 0; j != D[158].length; ++j) if(D[158][j].charCodeAt(0) !== 0xFFFD) { e[D[158][j]] = 40448 + j; d[40448 + j] = D[158][j];}
D[159] = "�����������������������������������������������������������������욨욪욫욬욭욮욯욲욳욵욶욷욻욼욽욾욿웂웄웆웇웈웉웊웋웎������웏웑웒웓웕웖웗웘웙웚웛웞웟웢웣웤웥웦웧웪웫웭웮웯웱웲������웳웴웵웶웷웺웻웼웾웿윀윁윂윃윆윇윉윊윋윍윎윏윐윑윒윓윖윘윚윛윜윝윞윟윢윣윥윦윧윩윪윫윬윭윮윯윲윴윶윸윹윺윻윾윿읁읂읃읅읆읇읈읉읋읎읐읙읚읛읝읞읟읡읢읣읤읥읦읧읩읪읬읭읮읯읰읱읲읳읶읷읹읺읻읿잀잁잂잆잋잌잍잏잒잓잕잙잛잜잝잞잟잢잧잨잩잪잫잮잯잱잲잳잵잶잷�".split("");
for(j = 0; j != D[159].length; ++j) if(D[159][j].charCodeAt(0) !== 0xFFFD) { e[D[159][j]] = 40704 + j; d[40704 + j] = D[159][j];}
D[160] = "�����������������������������������������������������������������잸잹잺잻잾쟂쟃쟄쟅쟆쟇쟊쟋쟍쟏쟑쟒쟓쟔쟕쟖쟗쟙쟚쟛쟜������쟞쟟쟠쟡쟢쟣쟥쟦쟧쟩쟪쟫쟭쟮쟯쟰쟱쟲쟳쟴쟵쟶쟷쟸쟹쟺������쟻쟼쟽쟾쟿젂젃젅젆젇젉젋젌젍젎젏젒젔젗젘젙젚젛젞젟젡젢젣젥젦젧젨젩젪젫젮젰젲젳젴젵젶젷젹젺젻젽젾젿졁졂졃졄졅졆졇졊졋졎졏졐졑졒졓졕졖졗졘졙졚졛졜졝졞졟졠졡졢졣졤졥졦졧졨졩졪졫졬졭졮졯졲졳졵졶졷졹졻졼졽졾졿좂좄좈좉좊좎좏좐좑좒좓좕좖좗좘좙좚좛좜좞좠좢좣좤�".split("");
for(j = 0; j != D[160].length; ++j) if(D[160][j].charCodeAt(0) !== 0xFFFD) { e[D[160][j]] = 40960 + j; d[40960 + j] = D[160][j];}
D[161] = "�����������������������������������������������������������������좥좦좧좩좪좫좬좭좮좯좰좱좲좳좴좵좶좷좸좹좺좻좾좿죀죁������죂죃죅죆죇죉죊죋죍죎죏죐죑죒죓죖죘죚죛죜죝죞죟죢죣죥������죦죧죨죩죪죫죬죭죮죯죰죱죲죳죴죶죷죸죹죺죻죾죿줁줂줃줇줈줉줊줋줎　、。·‥…¨〃­―∥＼∼‘’“”〔〕〈〉《》「」『』【】±×÷≠≤≥∞∴°′″℃Å￠￡￥♂♀∠⊥⌒∂∇≡≒§※☆★○●◎◇◆□■△▲▽▼→←↑↓↔〓≪≫√∽∝∵∫∬∈∋⊆⊇⊂⊃∪∩∧∨￢�".split("");
for(j = 0; j != D[161].length; ++j) if(D[161][j].charCodeAt(0) !== 0xFFFD) { e[D[161][j]] = 41216 + j; d[41216 + j] = D[161][j];}
D[162] = "�����������������������������������������������������������������줐줒줓줔줕줖줗줙줚줛줜줝줞줟줠줡줢줣줤줥줦줧줨줩줪줫������줭줮줯줰줱줲줳줵줶줷줸줹줺줻줼줽줾줿쥀쥁쥂쥃쥄쥅쥆쥇������쥈쥉쥊쥋쥌쥍쥎쥏쥒쥓쥕쥖쥗쥙쥚쥛쥜쥝쥞쥟쥢쥤쥥쥦쥧쥨쥩쥪쥫쥭쥮쥯⇒⇔∀∃´～ˇ˘˝˚˙¸˛¡¿ː∮∑∏¤℉‰◁◀▷▶♤♠♡♥♧♣⊙◈▣◐◑▒▤▥▨▧▦▩♨☏☎☜☞¶†‡↕↗↙↖↘♭♩♪♬㉿㈜№㏇™㏂㏘℡€®������������������������".split("");
for(j = 0; j != D[162].length; ++j) if(D[162][j].charCodeAt(0) !== 0xFFFD) { e[D[162][j]] = 41472 + j; d[41472 + j] = D[162][j];}
D[163] = "�����������������������������������������������������������������쥱쥲쥳쥵쥶쥷쥸쥹쥺쥻쥽쥾쥿즀즁즂즃즄즅즆즇즊즋즍즎즏������즑즒즓즔즕즖즗즚즜즞즟즠즡즢즣즤즥즦즧즨즩즪즫즬즭즮������즯즰즱즲즳즴즵즶즷즸즹즺즻즼즽즾즿짂짃짅짆짉짋짌짍짎짏짒짔짗짘짛！＂＃＄％＆＇（）＊＋，－．／０１２３４５６７８９：；＜＝＞？＠ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ［￦］＾＿｀ａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ｛｜｝￣�".split("");
for(j = 0; j != D[163].length; ++j) if(D[163][j].charCodeAt(0) !== 0xFFFD) { e[D[163][j]] = 41728 + j; d[41728 + j] = D[163][j];}
D[164] = "�����������������������������������������������������������������짞짟짡짣짥짦짨짩짪짫짮짲짳짴짵짶짷짺짻짽짾짿쨁쨂쨃쨄������쨅쨆쨇쨊쨎쨏쨐쨑쨒쨓쨕쨖쨗쨙쨚쨛쨜쨝쨞쨟쨠쨡쨢쨣쨤쨥������쨦쨧쨨쨪쨫쨬쨭쨮쨯쨰쨱쨲쨳쨴쨵쨶쨷쨸쨹쨺쨻쨼쨽쨾쨿쩀쩁쩂쩃쩄쩅쩆ㄱㄲㄳㄴㄵㄶㄷㄸㄹㄺㄻㄼㄽㄾㄿㅀㅁㅂㅃㅄㅅㅆㅇㅈㅉㅊㅋㅌㅍㅎㅏㅐㅑㅒㅓㅔㅕㅖㅗㅘㅙㅚㅛㅜㅝㅞㅟㅠㅡㅢㅣㅤㅥㅦㅧㅨㅩㅪㅫㅬㅭㅮㅯㅰㅱㅲㅳㅴㅵㅶㅷㅸㅹㅺㅻㅼㅽㅾㅿㆀㆁㆂㆃㆄㆅㆆㆇㆈㆉㆊㆋㆌㆍㆎ�".split("");
for(j = 0; j != D[164].length; ++j) if(D[164][j].charCodeAt(0) !== 0xFFFD) { e[D[164][j]] = 41984 + j; d[41984 + j] = D[164][j];}
D[165] = "�����������������������������������������������������������������쩇쩈쩉쩊쩋쩎쩏쩑쩒쩓쩕쩖쩗쩘쩙쩚쩛쩞쩢쩣쩤쩥쩦쩧쩩쩪������쩫쩬쩭쩮쩯쩰쩱쩲쩳쩴쩵쩶쩷쩸쩹쩺쩻쩼쩾쩿쪀쪁쪂쪃쪅쪆������쪇쪈쪉쪊쪋쪌쪍쪎쪏쪐쪑쪒쪓쪔쪕쪖쪗쪙쪚쪛쪜쪝쪞쪟쪠쪡쪢쪣쪤쪥쪦쪧ⅰⅱⅲⅳⅴⅵⅶⅷⅸⅹ�����ⅠⅡⅢⅣⅤⅥⅦⅧⅨⅩ�������ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩ��������αβγδεζηθικλμνξοπρστυφχψω�������".split("");
for(j = 0; j != D[165].length; ++j) if(D[165][j].charCodeAt(0) !== 0xFFFD) { e[D[165][j]] = 42240 + j; d[42240 + j] = D[165][j];}
D[166] = "�����������������������������������������������������������������쪨쪩쪪쪫쪬쪭쪮쪯쪰쪱쪲쪳쪴쪵쪶쪷쪸쪹쪺쪻쪾쪿쫁쫂쫃쫅������쫆쫇쫈쫉쫊쫋쫎쫐쫒쫔쫕쫖쫗쫚쫛쫜쫝쫞쫟쫡쫢쫣쫤쫥쫦쫧������쫨쫩쫪쫫쫭쫮쫯쫰쫱쫲쫳쫵쫶쫷쫸쫹쫺쫻쫼쫽쫾쫿쬀쬁쬂쬃쬄쬅쬆쬇쬉쬊─│┌┐┘└├┬┤┴┼━┃┏┓┛┗┣┳┫┻╋┠┯┨┷┿┝┰┥┸╂┒┑┚┙┖┕┎┍┞┟┡┢┦┧┩┪┭┮┱┲┵┶┹┺┽┾╀╁╃╄╅╆╇╈╉╊���������������������������".split("");
for(j = 0; j != D[166].length; ++j) if(D[166][j].charCodeAt(0) !== 0xFFFD) { e[D[166][j]] = 42496 + j; d[42496 + j] = D[166][j];}
D[167] = "�����������������������������������������������������������������쬋쬌쬍쬎쬏쬑쬒쬓쬕쬖쬗쬙쬚쬛쬜쬝쬞쬟쬢쬣쬤쬥쬦쬧쬨쬩������쬪쬫쬬쬭쬮쬯쬰쬱쬲쬳쬴쬵쬶쬷쬸쬹쬺쬻쬼쬽쬾쬿쭀쭂쭃쭄������쭅쭆쭇쭊쭋쭍쭎쭏쭑쭒쭓쭔쭕쭖쭗쭚쭛쭜쭞쭟쭠쭡쭢쭣쭥쭦쭧쭨쭩쭪쭫쭬㎕㎖㎗ℓ㎘㏄㎣㎤㎥㎦㎙㎚㎛㎜㎝㎞㎟㎠㎡㎢㏊㎍㎎㎏㏏㎈㎉㏈㎧㎨㎰㎱㎲㎳㎴㎵㎶㎷㎸㎹㎀㎁㎂㎃㎄㎺㎻㎼㎽㎾㎿㎐㎑㎒㎓㎔Ω㏀㏁㎊㎋㎌㏖㏅㎭㎮㎯㏛㎩㎪㎫㎬㏝㏐㏓㏃㏉㏜㏆����������������".split("");
for(j = 0; j != D[167].length; ++j) if(D[167][j].charCodeAt(0) !== 0xFFFD) { e[D[167][j]] = 42752 + j; d[42752 + j] = D[167][j];}
D[168] = "�����������������������������������������������������������������쭭쭮쭯쭰쭱쭲쭳쭴쭵쭶쭷쭺쭻쭼쭽쭾쭿쮀쮁쮂쮃쮄쮅쮆쮇쮈������쮉쮊쮋쮌쮍쮎쮏쮐쮑쮒쮓쮔쮕쮖쮗쮘쮙쮚쮛쮝쮞쮟쮠쮡쮢쮣������쮤쮥쮦쮧쮨쮩쮪쮫쮬쮭쮮쮯쮰쮱쮲쮳쮴쮵쮶쮷쮹쮺쮻쮼쮽쮾쮿쯀쯁쯂쯃쯄ÆÐªĦ�Ĳ�ĿŁØŒºÞŦŊ�㉠㉡㉢㉣㉤㉥㉦㉧㉨㉩㉪㉫㉬㉭㉮㉯㉰㉱㉲㉳㉴㉵㉶㉷㉸㉹㉺㉻ⓐⓑⓒⓓⓔⓕⓖⓗⓘⓙⓚⓛⓜⓝⓞⓟⓠⓡⓢⓣⓤⓥⓦⓧⓨⓩ①②③④⑤⑥⑦⑧⑨⑩⑪⑫⑬⑭⑮½⅓⅔¼¾⅛⅜⅝⅞�".split("");
for(j = 0; j != D[168].length; ++j) if(D[168][j].charCodeAt(0) !== 0xFFFD) { e[D[168][j]] = 43008 + j; d[43008 + j] = D[168][j];}
D[169] = "�����������������������������������������������������������������쯅쯆쯇쯈쯉쯊쯋쯌쯍쯎쯏쯐쯑쯒쯓쯕쯖쯗쯘쯙쯚쯛쯜쯝쯞쯟������쯠쯡쯢쯣쯥쯦쯨쯪쯫쯬쯭쯮쯯쯰쯱쯲쯳쯴쯵쯶쯷쯸쯹쯺쯻쯼������쯽쯾쯿찀찁찂찃찄찅찆찇찈찉찊찋찎찏찑찒찓찕찖찗찘찙찚찛찞찟찠찣찤æđðħıĳĸŀłøœßþŧŋŉ㈀㈁㈂㈃㈄㈅㈆㈇㈈㈉㈊㈋㈌㈍㈎㈏㈐㈑㈒㈓㈔㈕㈖㈗㈘㈙㈚㈛⒜⒝⒞⒟⒠⒡⒢⒣⒤⒥⒦⒧⒨⒩⒪⒫⒬⒭⒮⒯⒰⒱⒲⒳⒴⒵⑴⑵⑶⑷⑸⑹⑺⑻⑼⑽⑾⑿⒀⒁⒂¹²³⁴ⁿ₁₂₃₄�".split("");
for(j = 0; j != D[169].length; ++j) if(D[169][j].charCodeAt(0) !== 0xFFFD) { e[D[169][j]] = 43264 + j; d[43264 + j] = D[169][j];}
D[170] = "�����������������������������������������������������������������찥찦찪찫찭찯찱찲찳찴찵찶찷찺찿챀챁챂챃챆챇챉챊챋챍챎������챏챐챑챒챓챖챚챛챜챝챞챟챡챢챣챥챧챩챪챫챬챭챮챯챱챲������챳챴챶챷챸챹챺챻챼챽챾챿첀첁첂첃첄첅첆첇첈첉첊첋첌첍첎첏첐첑첒첓ぁあぃいぅうぇえぉおかがきぎくぐけげこごさざしじすずせぜそぞただちぢっつづてでとどなにぬねのはばぱひびぴふぶぷへべぺほぼぽまみむめもゃやゅゆょよらりるれろゎわゐゑをん������������".split("");
for(j = 0; j != D[170].length; ++j) if(D[170][j].charCodeAt(0) !== 0xFFFD) { e[D[170][j]] = 43520 + j; d[43520 + j] = D[170][j];}
D[171] = "�����������������������������������������������������������������첔첕첖첗첚첛첝첞첟첡첢첣첤첥첦첧첪첮첯첰첱첲첳첶첷첹������첺첻첽첾첿쳀쳁쳂쳃쳆쳈쳊쳋쳌쳍쳎쳏쳑쳒쳓쳕쳖쳗쳘쳙쳚������쳛쳜쳝쳞쳟쳠쳡쳢쳣쳥쳦쳧쳨쳩쳪쳫쳭쳮쳯쳱쳲쳳쳴쳵쳶쳷쳸쳹쳺쳻쳼쳽ァアィイゥウェエォオカガキギクグケゲコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶ���������".split("");
for(j = 0; j != D[171].length; ++j) if(D[171][j].charCodeAt(0) !== 0xFFFD) { e[D[171][j]] = 43776 + j; d[43776 + j] = D[171][j];}
D[172] = "�����������������������������������������������������������������쳾쳿촀촂촃촄촅촆촇촊촋촍촎촏촑촒촓촔촕촖촗촚촜촞촟촠������촡촢촣촥촦촧촩촪촫촭촮촯촰촱촲촳촴촵촶촷촸촺촻촼촽촾������촿쵀쵁쵂쵃쵄쵅쵆쵇쵈쵉쵊쵋쵌쵍쵎쵏쵐쵑쵒쵓쵔쵕쵖쵗쵘쵙쵚쵛쵝쵞쵟АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ���������������абвгдеёжзийклмнопрстуфхцчшщъыьэюя��������������".split("");
for(j = 0; j != D[172].length; ++j) if(D[172][j].charCodeAt(0) !== 0xFFFD) { e[D[172][j]] = 44032 + j; d[44032 + j] = D[172][j];}
D[173] = "�����������������������������������������������������������������쵡쵢쵣쵥쵦쵧쵨쵩쵪쵫쵮쵰쵲쵳쵴쵵쵶쵷쵹쵺쵻쵼쵽쵾쵿춀������춁춂춃춄춅춆춇춉춊춋춌춍춎춏춐춑춒춓춖춗춙춚춛춝춞춟������춠춡춢춣춦춨춪춫춬춭춮춯춱춲춳춴춵춶춷춸춹춺춻춼춽춾춿췀췁췂췃췅�����������������������������������������������������������������������������������������������".split("");
for(j = 0; j != D[173].length; ++j) if(D[173][j].charCodeAt(0) !== 0xFFFD) { e[D[173][j]] = 44288 + j; d[44288 + j] = D[173][j];}
D[174] = "�����������������������������������������������������������������췆췇췈췉췊췋췍췎췏췑췒췓췔췕췖췗췘췙췚췛췜췝췞췟췠췡������췢췣췤췥췦췧췩췪췫췭췮췯췱췲췳췴췵췶췷췺췼췾췿츀츁츂������츃츅츆츇츉츊츋츍츎츏츐츑츒츓츕츖츗츘츚츛츜츝츞츟츢츣츥츦츧츩츪츫�����������������������������������������������������������������������������������������������".split("");
for(j = 0; j != D[174].length; ++j) if(D[174][j].charCodeAt(0) !== 0xFFFD) { e[D[174][j]] = 44544 + j; d[44544 + j] = D[174][j];}
D[175] = "�����������������������������������������������������������������츬츭츮츯츲츴츶츷츸츹츺츻츼츽츾츿칀칁칂칃칄칅칆칇칈칉������칊칋칌칍칎칏칐칑칒칓칔칕칖칗칚칛칝칞칢칣칤칥칦칧칪칬������칮칯칰칱칲칳칶칷칹칺칻칽칾칿캀캁캂캃캆캈캊캋캌캍캎캏캒캓캕캖캗캙�����������������������������������������������������������������������������������������������".split("");
for(j = 0; j != D[175].length; ++j) if(D[175][j].charCodeAt(0) !== 0xFFFD) { e[D[175][j]] = 44800 + j; d[44800 + j] = D[175][j];}
D[176] = "�����������������������������������������������������������������캚캛캜캝캞캟캢캦캧캨캩캪캫캮캯캰캱캲캳캴캵캶캷캸캹캺������캻캼캽캾캿컀컂컃컄컅컆컇컈컉컊컋컌컍컎컏컐컑컒컓컔컕������컖컗컘컙컚컛컜컝컞컟컠컡컢컣컦컧컩컪컭컮컯컰컱컲컳컶컺컻컼컽컾컿가각간갇갈갉갊감갑값갓갔강갖갗같갚갛개객갠갤갬갭갯갰갱갸갹갼걀걋걍걔걘걜거걱건걷걸걺검겁것겄겅겆겉겊겋게겐겔겜겝겟겠겡겨격겪견겯결겸겹겻겼경곁계곈곌곕곗고곡곤곧골곪곬곯곰곱곳공곶과곽관괄괆�".split("");
for(j = 0; j != D[176].length; ++j) if(D[176][j].charCodeAt(0) !== 0xFFFD) { e[D[176][j]] = 45056 + j; d[45056 + j] = D[176][j];}
D[177] = "�����������������������������������������������������������������켂켃켅켆켇켉켊켋켌켍켎켏켒켔켖켗켘켙켚켛켝켞켟켡켢켣������켥켦켧켨켩켪켫켮켲켳켴켵켶켷켹켺켻켼켽켾켿콀콁콂콃콄������콅콆콇콈콉콊콋콌콍콎콏콐콑콒콓콖콗콙콚콛콝콞콟콠콡콢콣콦콨콪콫콬괌괍괏광괘괜괠괩괬괭괴괵괸괼굄굅굇굉교굔굘굡굣구국군굳굴굵굶굻굼굽굿궁궂궈궉권궐궜궝궤궷귀귁귄귈귐귑귓규균귤그극근귿글긁금급긋긍긔기긱긴긷길긺김깁깃깅깆깊까깍깎깐깔깖깜깝깟깠깡깥깨깩깬깰깸�".split("");
for(j = 0; j != D[177].length; ++j) if(D[177][j].charCodeAt(0) !== 0xFFFD) { e[D[177][j]] = 45312 + j; d[45312 + j] = D[177][j];}
D[178] = "�����������������������������������������������������������������콭콮콯콲콳콵콶콷콹콺콻콼콽콾콿쾁쾂쾃쾄쾆쾇쾈쾉쾊쾋쾍������쾎쾏쾐쾑쾒쾓쾔쾕쾖쾗쾘쾙쾚쾛쾜쾝쾞쾟쾠쾢쾣쾤쾥쾦쾧쾩������쾪쾫쾬쾭쾮쾯쾱쾲쾳쾴쾵쾶쾷쾸쾹쾺쾻쾼쾽쾾쾿쿀쿁쿂쿃쿅쿆쿇쿈쿉쿊쿋깹깻깼깽꺄꺅꺌꺼꺽꺾껀껄껌껍껏껐껑께껙껜껨껫껭껴껸껼꼇꼈꼍꼐꼬꼭꼰꼲꼴꼼꼽꼿꽁꽂꽃꽈꽉꽐꽜꽝꽤꽥꽹꾀꾄꾈꾐꾑꾕꾜꾸꾹꾼꿀꿇꿈꿉꿋꿍꿎꿔꿜꿨꿩꿰꿱꿴꿸뀀뀁뀄뀌뀐뀔뀜뀝뀨끄끅끈끊끌끎끓끔끕끗끙�".split("");
for(j = 0; j != D[178].length; ++j) if(D[178][j].charCodeAt(0) !== 0xFFFD) { e[D[178][j]] = 45568 + j; d[45568 + j] = D[178][j];}
D[179] = "�����������������������������������������������������������������쿌쿍쿎쿏쿐쿑쿒쿓쿔쿕쿖쿗쿘쿙쿚쿛쿜쿝쿞쿟쿢쿣쿥쿦쿧쿩������쿪쿫쿬쿭쿮쿯쿲쿴쿶쿷쿸쿹쿺쿻쿽쿾쿿퀁퀂퀃퀅퀆퀇퀈퀉퀊������퀋퀌퀍퀎퀏퀐퀒퀓퀔퀕퀖퀗퀙퀚퀛퀜퀝퀞퀟퀠퀡퀢퀣퀤퀥퀦퀧퀨퀩퀪퀫퀬끝끼끽낀낄낌낍낏낑나낙낚난낟날낡낢남납낫났낭낮낯낱낳내낵낸낼냄냅냇냈냉냐냑냔냘냠냥너넉넋넌널넒넓넘넙넛넜넝넣네넥넨넬넴넵넷넸넹녀녁년녈념녑녔녕녘녜녠노녹논놀놂놈놉놋농높놓놔놘놜놨뇌뇐뇔뇜뇝�".split("");
for(j = 0; j != D[179].length; ++j) if(D[179][j].charCodeAt(0) !== 0xFFFD) { e[D[179][j]] = 45824 + j; d[45824 + j] = D[179][j];}
D[180] = "�����������������������������������������������������������������퀮퀯퀰퀱퀲퀳퀶퀷퀹퀺퀻퀽퀾퀿큀큁큂큃큆큈큊큋큌큍큎큏������큑큒큓큕큖큗큙큚큛큜큝큞큟큡큢큣큤큥큦큧큨큩큪큫큮큯������큱큲큳큵큶큷큸큹큺큻큾큿킀킂킃킄킅킆킇킈킉킊킋킌킍킎킏킐킑킒킓킔뇟뇨뇩뇬뇰뇹뇻뇽누눅눈눋눌눔눕눗눙눠눴눼뉘뉜뉠뉨뉩뉴뉵뉼늄늅늉느늑는늘늙늚늠늡늣능늦늪늬늰늴니닉닌닐닒님닙닛닝닢다닥닦단닫달닭닮닯닳담답닷닸당닺닻닿대댁댄댈댐댑댓댔댕댜더덕덖던덛덜덞덟덤덥�".split("");
for(j = 0; j != D[180].length; ++j) if(D[180][j].charCodeAt(0) !== 0xFFFD) { e[D[180][j]] = 46080 + j; d[46080 + j] = D[180][j];}
D[181] = "�����������������������������������������������������������������킕킖킗킘킙킚킛킜킝킞킟킠킡킢킣킦킧킩킪킫킭킮킯킰킱킲������킳킶킸킺킻킼킽킾킿탂탃탅탆탇탊탋탌탍탎탏탒탖탗탘탙탚������탛탞탟탡탢탣탥탦탧탨탩탪탫탮탲탳탴탵탶탷탹탺탻탼탽탾탿턀턁턂턃턄덧덩덫덮데덱덴델뎀뎁뎃뎄뎅뎌뎐뎔뎠뎡뎨뎬도독돈돋돌돎돐돔돕돗동돛돝돠돤돨돼됐되된될됨됩됫됴두둑둔둘둠둡둣둥둬뒀뒈뒝뒤뒨뒬뒵뒷뒹듀듄듈듐듕드득든듣들듦듬듭듯등듸디딕딘딛딜딤딥딧딨딩딪따딱딴딸�".split("");
for(j = 0; j != D[181].length; ++j) if(D[181][j].charCodeAt(0) !== 0xFFFD) { e[D[181][j]] = 46336 + j; d[46336 + j] = D[181][j];}
D[182] = "�����������������������������������������������������������������턅턆턇턈턉턊턋턌턎턏턐턑턒턓턔턕턖턗턘턙턚턛턜턝턞턟������턠턡턢턣턤턥턦턧턨턩턪턫턬턭턮턯턲턳턵턶턷턹턻턼턽턾������턿텂텆텇텈텉텊텋텎텏텑텒텓텕텖텗텘텙텚텛텞텠텢텣텤텥텦텧텩텪텫텭땀땁땃땄땅땋때땍땐땔땜땝땟땠땡떠떡떤떨떪떫떰떱떳떴떵떻떼떽뗀뗄뗌뗍뗏뗐뗑뗘뗬또똑똔똘똥똬똴뙈뙤뙨뚜뚝뚠뚤뚫뚬뚱뛔뛰뛴뛸뜀뜁뜅뜨뜩뜬뜯뜰뜸뜹뜻띄띈띌띔띕띠띤띨띰띱띳띵라락란랄람랍랏랐랑랒랖랗�".split("");
for(j = 0; j != D[182].length; ++j) if(D[182][j].charCodeAt(0) !== 0xFFFD) { e[D[182][j]] = 46592 + j; d[46592 + j] = D[182][j];}
D[183] = "�����������������������������������������������������������������텮텯텰텱텲텳텴텵텶텷텸텹텺텻텽텾텿톀톁톂톃톅톆톇톉톊������톋톌톍톎톏톐톑톒톓톔톕톖톗톘톙톚톛톜톝톞톟톢톣톥톦톧������톩톪톫톬톭톮톯톲톴톶톷톸톹톻톽톾톿퇁퇂퇃퇄퇅퇆퇇퇈퇉퇊퇋퇌퇍퇎퇏래랙랜랠램랩랫랬랭랴략랸럇량러럭런럴럼럽럿렀렁렇레렉렌렐렘렙렛렝려력련렬렴렵렷렸령례롄롑롓로록론롤롬롭롯롱롸롼뢍뢨뢰뢴뢸룀룁룃룅료룐룔룝룟룡루룩룬룰룸룹룻룽뤄뤘뤠뤼뤽륀륄륌륏륑류륙륜률륨륩�".split("");
for(j = 0; j != D[183].length; ++j) if(D[183][j].charCodeAt(0) !== 0xFFFD) { e[D[183][j]] = 46848 + j; d[46848 + j] = D[183][j];}
D[184] = "�����������������������������������������������������������������퇐퇑퇒퇓퇔퇕퇖퇗퇙퇚퇛퇜퇝퇞퇟퇠퇡퇢퇣퇤퇥퇦퇧퇨퇩퇪������퇫퇬퇭퇮퇯퇰퇱퇲퇳퇵퇶퇷퇹퇺퇻퇼퇽퇾퇿툀툁툂툃툄툅툆������툈툊툋툌툍툎툏툑툒툓툔툕툖툗툘툙툚툛툜툝툞툟툠툡툢툣툤툥툦툧툨툩륫륭르륵른를름릅릇릉릊릍릎리릭린릴림립릿링마막만많맏말맑맒맘맙맛망맞맡맣매맥맨맬맴맵맷맸맹맺먀먁먈먕머먹먼멀멂멈멉멋멍멎멓메멕멘멜멤멥멧멨멩며멱면멸몃몄명몇몌모목몫몬몰몲몸몹못몽뫄뫈뫘뫙뫼�".split("");
for(j = 0; j != D[184].length; ++j) if(D[184][j].charCodeAt(0) !== 0xFFFD) { e[D[184][j]] = 47104 + j; d[47104 + j] = D[184][j];}
D[185] = "�����������������������������������������������������������������툪툫툮툯툱툲툳툵툶툷툸툹툺툻툾퉀퉂퉃퉄퉅퉆퉇퉉퉊퉋퉌������퉍퉎퉏퉐퉑퉒퉓퉔퉕퉖퉗퉘퉙퉚퉛퉝퉞퉟퉠퉡퉢퉣퉥퉦퉧퉨������퉩퉪퉫퉬퉭퉮퉯퉰퉱퉲퉳퉴퉵퉶퉷퉸퉹퉺퉻퉼퉽퉾퉿튂튃튅튆튇튉튊튋튌묀묄묍묏묑묘묜묠묩묫무묵묶문묻물묽묾뭄뭅뭇뭉뭍뭏뭐뭔뭘뭡뭣뭬뮈뮌뮐뮤뮨뮬뮴뮷므믄믈믐믓미믹민믿밀밂밈밉밋밌밍및밑바박밖밗반받발밝밞밟밤밥밧방밭배백밴밸뱀뱁뱃뱄뱅뱉뱌뱍뱐뱝버벅번벋벌벎범법벗�".split("");
for(j = 0; j != D[185].length; ++j) if(D[185][j].charCodeAt(0) !== 0xFFFD) { e[D[185][j]] = 47360 + j; d[47360 + j] = D[185][j];}
D[186] = "�����������������������������������������������������������������튍튎튏튒튓튔튖튗튘튙튚튛튝튞튟튡튢튣튥튦튧튨튩튪튫튭������튮튯튰튲튳튴튵튶튷튺튻튽튾틁틃틄틅틆틇틊틌틍틎틏틐틑������틒틓틕틖틗틙틚틛틝틞틟틠틡틢틣틦틧틨틩틪틫틬틭틮틯틲틳틵틶틷틹틺벙벚베벡벤벧벨벰벱벳벴벵벼벽변별볍볏볐병볕볘볜보복볶본볼봄봅봇봉봐봔봤봬뵀뵈뵉뵌뵐뵘뵙뵤뵨부북분붇불붉붊붐붑붓붕붙붚붜붤붰붸뷔뷕뷘뷜뷩뷰뷴뷸븀븃븅브븍븐블븜븝븟비빅빈빌빎빔빕빗빙빚빛빠빡빤�".split("");
for(j = 0; j != D[186].length; ++j) if(D[186][j].charCodeAt(0) !== 0xFFFD) { e[D[186][j]] = 47616 + j; d[47616 + j] = D[186][j];}
D[187] = "�����������������������������������������������������������������틻틼틽틾틿팂팄팆팇팈팉팊팋팏팑팒팓팕팗팘팙팚팛팞팢팣������팤팦팧팪팫팭팮팯팱팲팳팴팵팶팷팺팾팿퍀퍁퍂퍃퍆퍇퍈퍉������퍊퍋퍌퍍퍎퍏퍐퍑퍒퍓퍔퍕퍖퍗퍘퍙퍚퍛퍜퍝퍞퍟퍠퍡퍢퍣퍤퍥퍦퍧퍨퍩빨빪빰빱빳빴빵빻빼빽뺀뺄뺌뺍뺏뺐뺑뺘뺙뺨뻐뻑뻔뻗뻘뻠뻣뻤뻥뻬뼁뼈뼉뼘뼙뼛뼜뼝뽀뽁뽄뽈뽐뽑뽕뾔뾰뿅뿌뿍뿐뿔뿜뿟뿡쀼쁑쁘쁜쁠쁨쁩삐삑삔삘삠삡삣삥사삭삯산삳살삵삶삼삽삿샀상샅새색샌샐샘샙샛샜생샤�".split("");
for(j = 0; j != D[187].length; ++j) if(D[187][j].charCodeAt(0) !== 0xFFFD) { e[D[187][j]] = 47872 + j; d[47872 + j] = D[187][j];}
D[188] = "�����������������������������������������������������������������퍪퍫퍬퍭퍮퍯퍰퍱퍲퍳퍴퍵퍶퍷퍸퍹퍺퍻퍾퍿펁펂펃펅펆펇������펈펉펊펋펎펒펓펔펕펖펗펚펛펝펞펟펡펢펣펤펥펦펧펪펬펮������펯펰펱펲펳펵펶펷펹펺펻펽펾펿폀폁폂폃폆폇폊폋폌폍폎폏폑폒폓폔폕폖샥샨샬샴샵샷샹섀섄섈섐섕서석섞섟선섣설섦섧섬섭섯섰성섶세섹센셀셈셉셋셌셍셔셕션셜셤셥셧셨셩셰셴셸솅소속솎손솔솖솜솝솟송솥솨솩솬솰솽쇄쇈쇌쇔쇗쇘쇠쇤쇨쇰쇱쇳쇼쇽숀숄숌숍숏숑수숙순숟술숨숩숫숭�".split("");
for(j = 0; j != D[188].length; ++j) if(D[188][j].charCodeAt(0) !== 0xFFFD) { e[D[188][j]] = 48128 + j; d[48128 + j] = D[188][j];}
D[189] = "�����������������������������������������������������������������폗폙폚폛폜폝폞폟폠폢폤폥폦폧폨폩폪폫폮폯폱폲폳폵폶폷������폸폹폺폻폾퐀퐂퐃퐄퐅퐆퐇퐉퐊퐋퐌퐍퐎퐏퐐퐑퐒퐓퐔퐕퐖������퐗퐘퐙퐚퐛퐜퐞퐟퐠퐡퐢퐣퐤퐥퐦퐧퐨퐩퐪퐫퐬퐭퐮퐯퐰퐱퐲퐳퐴퐵퐶퐷숯숱숲숴쉈쉐쉑쉔쉘쉠쉥쉬쉭쉰쉴쉼쉽쉿슁슈슉슐슘슛슝스슥슨슬슭슴습슷승시식신싣실싫심십싯싱싶싸싹싻싼쌀쌈쌉쌌쌍쌓쌔쌕쌘쌜쌤쌥쌨쌩썅써썩썬썰썲썸썹썼썽쎄쎈쎌쏀쏘쏙쏜쏟쏠쏢쏨쏩쏭쏴쏵쏸쐈쐐쐤쐬쐰�".split("");
for(j = 0; j != D[189].length; ++j) if(D[189][j].charCodeAt(0) !== 0xFFFD) { e[D[189][j]] = 48384 + j; d[48384 + j] = D[189][j];}
D[190] = "�����������������������������������������������������������������퐸퐹퐺퐻퐼퐽퐾퐿푁푂푃푅푆푇푈푉푊푋푌푍푎푏푐푑푒푓������푔푕푖푗푘푙푚푛푝푞푟푡푢푣푥푦푧푨푩푪푫푬푮푰푱푲������푳푴푵푶푷푺푻푽푾풁풃풄풅풆풇풊풌풎풏풐풑풒풓풕풖풗풘풙풚풛풜풝쐴쐼쐽쑈쑤쑥쑨쑬쑴쑵쑹쒀쒔쒜쒸쒼쓩쓰쓱쓴쓸쓺쓿씀씁씌씐씔씜씨씩씬씰씸씹씻씽아악안앉않알앍앎앓암압앗았앙앝앞애액앤앨앰앱앳앴앵야약얀얄얇얌얍얏양얕얗얘얜얠얩어억언얹얻얼얽얾엄업없엇었엉엊엌엎�".split("");
for(j = 0; j != D[190].length; ++j) if(D[190][j].charCodeAt(0) !== 0xFFFD) { e[D[190][j]] = 48640 + j; d[48640 + j] = D[190][j];}
D[191] = "�����������������������������������������������������������������풞풟풠풡풢풣풤풥풦풧풨풪풫풬풭풮풯풰풱풲풳풴풵풶풷풸������풹풺풻풼풽풾풿퓀퓁퓂퓃퓄퓅퓆퓇퓈퓉퓊퓋퓍퓎퓏퓑퓒퓓퓕������퓖퓗퓘퓙퓚퓛퓝퓞퓠퓡퓢퓣퓤퓥퓦퓧퓩퓪퓫퓭퓮퓯퓱퓲퓳퓴퓵퓶퓷퓹퓺퓼에엑엔엘엠엡엣엥여역엮연열엶엷염엽엾엿였영옅옆옇예옌옐옘옙옛옜오옥온올옭옮옰옳옴옵옷옹옻와왁완왈왐왑왓왔왕왜왝왠왬왯왱외왹왼욀욈욉욋욍요욕욘욜욤욥욧용우욱운울욹욺움웁웃웅워웍원월웜웝웠웡웨�".split("");
for(j = 0; j != D[191].length; ++j) if(D[191][j].charCodeAt(0) !== 0xFFFD) { e[D[191][j]] = 48896 + j; d[48896 + j] = D[191][j];}
D[192] = "�����������������������������������������������������������������퓾퓿픀픁픂픃픅픆픇픉픊픋픍픎픏픐픑픒픓픖픘픙픚픛픜픝������픞픟픠픡픢픣픤픥픦픧픨픩픪픫픬픭픮픯픰픱픲픳픴픵픶픷������픸픹픺픻픾픿핁핂핃핅핆핇핈핉핊핋핎핐핒핓핔핕핖핗핚핛핝핞핟핡핢핣웩웬웰웸웹웽위윅윈윌윔윕윗윙유육윤율윰윱윳융윷으윽은을읊음읍읏응읒읓읔읕읖읗의읜읠읨읫이익인일읽읾잃임입잇있잉잊잎자작잔잖잗잘잚잠잡잣잤장잦재잭잰잴잼잽잿쟀쟁쟈쟉쟌쟎쟐쟘쟝쟤쟨쟬저적전절젊�".split("");
for(j = 0; j != D[192].length; ++j) if(D[192][j].charCodeAt(0) !== 0xFFFD) { e[D[192][j]] = 49152 + j; d[49152 + j] = D[192][j];}
D[193] = "�����������������������������������������������������������������핤핦핧핪핬핮핯핰핱핲핳핶핷핹핺핻핽핾핿햀햁햂햃햆햊햋������햌햍햎햏햑햒햓햔햕햖햗햘햙햚햛햜햝햞햟햠햡햢햣햤햦햧������햨햩햪햫햬햭햮햯햰햱햲햳햴햵햶햷햸햹햺햻햼햽햾햿헀헁헂헃헄헅헆헇점접젓정젖제젝젠젤젬젭젯젱져젼졀졈졉졌졍졔조족존졸졺좀좁좃종좆좇좋좌좍좔좝좟좡좨좼좽죄죈죌죔죕죗죙죠죡죤죵주죽준줄줅줆줌줍줏중줘줬줴쥐쥑쥔쥘쥠쥡쥣쥬쥰쥴쥼즈즉즌즐즘즙즛증지직진짇질짊짐집짓�".split("");
for(j = 0; j != D[193].length; ++j) if(D[193][j].charCodeAt(0) !== 0xFFFD) { e[D[193][j]] = 49408 + j; d[49408 + j] = D[193][j];}
D[194] = "�����������������������������������������������������������������헊헋헍헎헏헑헓헔헕헖헗헚헜헞헟헠헡헢헣헦헧헩헪헫헭헮������헯헰헱헲헳헶헸헺헻헼헽헾헿혂혃혅혆혇혉혊혋혌혍혎혏혒������혖혗혘혙혚혛혝혞혟혡혢혣혥혦혧혨혩혪혫혬혮혯혰혱혲혳혴혵혶혷혺혻징짖짙짚짜짝짠짢짤짧짬짭짯짰짱째짹짼쨀쨈쨉쨋쨌쨍쨔쨘쨩쩌쩍쩐쩔쩜쩝쩟쩠쩡쩨쩽쪄쪘쪼쪽쫀쫄쫌쫍쫏쫑쫓쫘쫙쫠쫬쫴쬈쬐쬔쬘쬠쬡쭁쭈쭉쭌쭐쭘쭙쭝쭤쭸쭹쮜쮸쯔쯤쯧쯩찌찍찐찔찜찝찡찢찧차착찬찮찰참찹찻�".split("");
for(j = 0; j != D[194].length; ++j) if(D[194][j].charCodeAt(0) !== 0xFFFD) { e[D[194][j]] = 49664 + j; d[49664 + j] = D[194][j];}
D[195] = "�����������������������������������������������������������������혽혾혿홁홂홃홄홆홇홊홌홎홏홐홒홓홖홗홙홚홛홝홞홟홠홡������홢홣홤홥홦홨홪홫홬홭홮홯홲홳홵홶홷홸홹홺홻홼홽홾홿횀������횁횂횄횆횇횈횉횊횋횎횏횑횒횓횕횖횗횘횙횚횛횜횞횠횢횣횤횥횦횧횩횪찼창찾채책챈챌챔챕챗챘챙챠챤챦챨챰챵처척천철첨첩첫첬청체첵첸첼쳄쳅쳇쳉쳐쳔쳤쳬쳰촁초촉촌촐촘촙촛총촤촨촬촹최쵠쵤쵬쵭쵯쵱쵸춈추축춘출춤춥춧충춰췄췌췐취췬췰췸췹췻췽츄츈츌츔츙츠측츤츨츰츱츳층�".split("");
for(j = 0; j != D[195].length; ++j) if(D[195][j].charCodeAt(0) !== 0xFFFD) { e[D[195][j]] = 49920 + j; d[49920 + j] = D[195][j];}
D[196] = "�����������������������������������������������������������������횫횭횮횯횱횲횳횴횵횶횷횸횺횼횽횾횿훀훁훂훃훆훇훉훊훋������훍훎훏훐훒훓훕훖훘훚훛훜훝훞훟훡훢훣훥훦훧훩훪훫훬훭������훮훯훱훲훳훴훶훷훸훹훺훻훾훿휁휂휃휅휆휇휈휉휊휋휌휍휎휏휐휒휓휔치칙친칟칠칡침칩칫칭카칵칸칼캄캅캇캉캐캑캔캘캠캡캣캤캥캬캭컁커컥컨컫컬컴컵컷컸컹케켁켄켈켐켑켓켕켜켠켤켬켭켯켰켱켸코콕콘콜콤콥콧콩콰콱콴콸쾀쾅쾌쾡쾨쾰쿄쿠쿡쿤쿨쿰쿱쿳쿵쿼퀀퀄퀑퀘퀭퀴퀵퀸퀼�".split("");
for(j = 0; j != D[196].length; ++j) if(D[196][j].charCodeAt(0) !== 0xFFFD) { e[D[196][j]] = 50176 + j; d[50176 + j] = D[196][j];}
D[197] = "�����������������������������������������������������������������휕휖휗휚휛휝휞휟휡휢휣휤휥휦휧휪휬휮휯휰휱휲휳휶휷휹������휺휻휽휾휿흀흁흂흃흅흆흈흊흋흌흍흎흏흒흓흕흚흛흜흝흞������흟흢흤흦흧흨흪흫흭흮흯흱흲흳흵흶흷흸흹흺흻흾흿힀힂힃힄힅힆힇힊힋큄큅큇큉큐큔큘큠크큭큰클큼큽킁키킥킨킬킴킵킷킹타탁탄탈탉탐탑탓탔탕태택탠탤탬탭탯탰탱탸턍터턱턴털턺텀텁텃텄텅테텍텐텔템텝텟텡텨텬텼톄톈토톡톤톨톰톱톳통톺톼퇀퇘퇴퇸툇툉툐투툭툰툴툼툽툿퉁퉈퉜�".split("");
for(j = 0; j != D[197].length; ++j) if(D[197][j].charCodeAt(0) !== 0xFFFD) { e[D[197][j]] = 50432 + j; d[50432 + j] = D[197][j];}
D[198] = "�����������������������������������������������������������������힍힎힏힑힒힓힔힕힖힗힚힜힞힟힠힡힢힣������������������������������������������������������������������������������퉤튀튁튄튈튐튑튕튜튠튤튬튱트특튼튿틀틂틈틉틋틔틘틜틤틥티틱틴틸팀팁팃팅파팍팎판팔팖팜팝팟팠팡팥패팩팬팰팸팹팻팼팽퍄퍅퍼퍽펀펄펌펍펏펐펑페펙펜펠펨펩펫펭펴편펼폄폅폈평폐폘폡폣포폭폰폴폼폽폿퐁�".split("");
for(j = 0; j != D[198].length; ++j) if(D[198][j].charCodeAt(0) !== 0xFFFD) { e[D[198][j]] = 50688 + j; d[50688 + j] = D[198][j];}
D[199] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������퐈퐝푀푄표푠푤푭푯푸푹푼푿풀풂품풉풋풍풔풩퓌퓐퓔퓜퓟퓨퓬퓰퓸퓻퓽프픈플픔픕픗피픽핀필핌핍핏핑하학한할핥함합핫항해핵핸핼햄햅햇했행햐향허헉헌헐헒험헙헛헝헤헥헨헬헴헵헷헹혀혁현혈혐협혓혔형혜혠�".split("");
for(j = 0; j != D[199].length; ++j) if(D[199][j].charCodeAt(0) !== 0xFFFD) { e[D[199][j]] = 50944 + j; d[50944 + j] = D[199][j];}
D[200] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������혤혭호혹혼홀홅홈홉홋홍홑화확환활홧황홰홱홴횃횅회획횐횔횝횟횡효횬횰횹횻후훅훈훌훑훔훗훙훠훤훨훰훵훼훽휀휄휑휘휙휜휠휨휩휫휭휴휵휸휼흄흇흉흐흑흔흖흗흘흙흠흡흣흥흩희흰흴흼흽힁히힉힌힐힘힙힛힝�".split("");
for(j = 0; j != D[200].length; ++j) if(D[200][j].charCodeAt(0) !== 0xFFFD) { e[D[200][j]] = 51200 + j; d[51200 + j] = D[200][j];}
D[202] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������伽佳假價加可呵哥嘉嫁家暇架枷柯歌珂痂稼苛茄街袈訶賈跏軻迦駕刻却各恪慤殼珏脚覺角閣侃刊墾奸姦干幹懇揀杆柬桿澗癎看磵稈竿簡肝艮艱諫間乫喝曷渴碣竭葛褐蝎鞨勘坎堪嵌感憾戡敢柑橄減甘疳監瞰紺邯鑑鑒龕�".split("");
for(j = 0; j != D[202].length; ++j) if(D[202][j].charCodeAt(0) !== 0xFFFD) { e[D[202][j]] = 51712 + j; d[51712 + j] = D[202][j];}
D[203] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������匣岬甲胛鉀閘剛堈姜岡崗康强彊慷江畺疆糠絳綱羌腔舡薑襁講鋼降鱇介价個凱塏愷愾慨改槪漑疥皆盖箇芥蓋豈鎧開喀客坑更粳羹醵倨去居巨拒据據擧渠炬祛距踞車遽鉅鋸乾件健巾建愆楗腱虔蹇鍵騫乞傑杰桀儉劍劒檢�".split("");
for(j = 0; j != D[203].length; ++j) if(D[203][j].charCodeAt(0) !== 0xFFFD) { e[D[203][j]] = 51968 + j; d[51968 + j] = D[203][j];}
D[204] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������瞼鈐黔劫怯迲偈憩揭擊格檄激膈覡隔堅牽犬甄絹繭肩見譴遣鵑抉決潔結缺訣兼慊箝謙鉗鎌京俓倞傾儆勁勍卿坰境庚徑慶憬擎敬景暻更梗涇炅烱璟璥瓊痙硬磬竟競絅經耕耿脛莖警輕逕鏡頃頸驚鯨係啓堺契季屆悸戒桂械�".split("");
for(j = 0; j != D[204].length; ++j) if(D[204][j].charCodeAt(0) !== 0xFFFD) { e[D[204][j]] = 52224 + j; d[52224 + j] = D[204][j];}
D[205] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������棨溪界癸磎稽系繫繼計誡谿階鷄古叩告呱固姑孤尻庫拷攷故敲暠枯槁沽痼皐睾稿羔考股膏苦苽菰藁蠱袴誥賈辜錮雇顧高鼓哭斛曲梏穀谷鵠困坤崑昆梱棍滾琨袞鯤汨滑骨供公共功孔工恐恭拱控攻珙空蚣貢鞏串寡戈果瓜�".split("");
for(j = 0; j != D[205].length; ++j) if(D[205][j].charCodeAt(0) !== 0xFFFD) { e[D[205][j]] = 52480 + j; d[52480 + j] = D[205][j];}
D[206] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������科菓誇課跨過鍋顆廓槨藿郭串冠官寬慣棺款灌琯瓘管罐菅觀貫關館刮恝括适侊光匡壙廣曠洸炚狂珖筐胱鑛卦掛罫乖傀塊壞怪愧拐槐魁宏紘肱轟交僑咬喬嬌嶠巧攪敎校橋狡皎矯絞翹膠蕎蛟較轎郊餃驕鮫丘久九仇俱具勾�".split("");
for(j = 0; j != D[206].length; ++j) if(D[206][j].charCodeAt(0) !== 0xFFFD) { e[D[206][j]] = 52736 + j; d[52736 + j] = D[206][j];}
D[207] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������區口句咎嘔坵垢寇嶇廐懼拘救枸柩構歐毆毬求溝灸狗玖球瞿矩究絿耉臼舅舊苟衢謳購軀逑邱鉤銶駒驅鳩鷗龜國局菊鞠鞫麴君窘群裙軍郡堀屈掘窟宮弓穹窮芎躬倦券勸卷圈拳捲權淃眷厥獗蕨蹶闕机櫃潰詭軌饋句晷歸貴�".split("");
for(j = 0; j != D[207].length; ++j) if(D[207][j].charCodeAt(0) !== 0xFFFD) { e[D[207][j]] = 52992 + j; d[52992 + j] = D[207][j];}
D[208] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������鬼龜叫圭奎揆槻珪硅窺竅糾葵規赳逵閨勻均畇筠菌鈞龜橘克剋劇戟棘極隙僅劤勤懃斤根槿瑾筋芹菫覲謹近饉契今妗擒昑檎琴禁禽芩衾衿襟金錦伋及急扱汲級給亘兢矜肯企伎其冀嗜器圻基埼夔奇妓寄岐崎己幾忌技旗旣�".split("");
for(j = 0; j != D[208].length; ++j) if(D[208][j].charCodeAt(0) !== 0xFFFD) { e[D[208][j]] = 53248 + j; d[53248 + j] = D[208][j];}
D[209] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������朞期杞棋棄機欺氣汽沂淇玘琦琪璂璣畸畿碁磯祁祇祈祺箕紀綺羈耆耭肌記譏豈起錡錤飢饑騎騏驥麒緊佶吉拮桔金喫儺喇奈娜懦懶拏拿癩羅蘿螺裸邏那樂洛烙珞落諾酪駱亂卵暖欄煖爛蘭難鸞捏捺南嵐枏楠湳濫男藍襤拉�".split("");
for(j = 0; j != D[209].length; ++j) if(D[209][j].charCodeAt(0) !== 0xFFFD) { e[D[209][j]] = 53504 + j; d[53504 + j] = D[209][j];}
D[210] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������納臘蠟衲囊娘廊朗浪狼郎乃來內奈柰耐冷女年撚秊念恬拈捻寧寗努勞奴弩怒擄櫓爐瑙盧老蘆虜路露駑魯鷺碌祿綠菉錄鹿論壟弄濃籠聾膿農惱牢磊腦賂雷尿壘屢樓淚漏累縷陋嫩訥杻紐勒肋凜凌稜綾能菱陵尼泥匿溺多茶�".split("");
for(j = 0; j != D[210].length; ++j) if(D[210][j].charCodeAt(0) !== 0xFFFD) { e[D[210][j]] = 53760 + j; d[53760 + j] = D[210][j];}
D[211] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������丹亶但單團壇彖斷旦檀段湍短端簞緞蛋袒鄲鍛撻澾獺疸達啖坍憺擔曇淡湛潭澹痰聃膽蕁覃談譚錟沓畓答踏遝唐堂塘幢戇撞棠當糖螳黨代垈坮大對岱帶待戴擡玳臺袋貸隊黛宅德悳倒刀到圖堵塗導屠島嶋度徒悼挑掉搗桃�".split("");
for(j = 0; j != D[211].length; ++j) if(D[211][j].charCodeAt(0) !== 0xFFFD) { e[D[211][j]] = 54016 + j; d[54016 + j] = D[211][j];}
D[212] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������棹櫂淘渡滔濤燾盜睹禱稻萄覩賭跳蹈逃途道都鍍陶韜毒瀆牘犢獨督禿篤纛讀墩惇敦旽暾沌焞燉豚頓乭突仝冬凍動同憧東桐棟洞潼疼瞳童胴董銅兜斗杜枓痘竇荳讀豆逗頭屯臀芚遁遯鈍得嶝橙燈登等藤謄鄧騰喇懶拏癩羅�".split("");
for(j = 0; j != D[212].length; ++j) if(D[212][j].charCodeAt(0) !== 0xFFFD) { e[D[212][j]] = 54272 + j; d[54272 + j] = D[212][j];}
D[213] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������蘿螺裸邏樂洛烙珞絡落諾酪駱丹亂卵欄欒瀾爛蘭鸞剌辣嵐擥攬欖濫籃纜藍襤覽拉臘蠟廊朗浪狼琅瑯螂郞來崍徠萊冷掠略亮倆兩凉梁樑粮粱糧良諒輛量侶儷勵呂廬慮戾旅櫚濾礪藜蠣閭驢驪麗黎力曆歷瀝礫轢靂憐戀攣漣�".split("");
for(j = 0; j != D[213].length; ++j) if(D[213][j].charCodeAt(0) !== 0xFFFD) { e[D[213][j]] = 54528 + j; d[54528 + j] = D[213][j];}
D[214] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������煉璉練聯蓮輦連鍊冽列劣洌烈裂廉斂殮濂簾獵令伶囹寧岺嶺怜玲笭羚翎聆逞鈴零靈領齡例澧禮醴隷勞怒撈擄櫓潞瀘爐盧老蘆虜路輅露魯鷺鹵碌祿綠菉錄鹿麓論壟弄朧瀧瓏籠聾儡瀨牢磊賂賚賴雷了僚寮廖料燎療瞭聊蓼�".split("");
for(j = 0; j != D[214].length; ++j) if(D[214][j].charCodeAt(0) !== 0xFFFD) { e[D[214][j]] = 54784 + j; d[54784 + j] = D[214][j];}
D[215] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������遼鬧龍壘婁屢樓淚漏瘻累縷蔞褸鏤陋劉旒柳榴流溜瀏琉瑠留瘤硫謬類六戮陸侖倫崙淪綸輪律慄栗率隆勒肋凜凌楞稜綾菱陵俚利厘吏唎履悧李梨浬犁狸理璃異痢籬罹羸莉裏裡里釐離鯉吝潾燐璘藺躪隣鱗麟林淋琳臨霖砬�".split("");
for(j = 0; j != D[215].length; ++j) if(D[215][j].charCodeAt(0) !== 0xFFFD) { e[D[215][j]] = 55040 + j; d[55040 + j] = D[215][j];}
D[216] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������立笠粒摩瑪痲碼磨馬魔麻寞幕漠膜莫邈万卍娩巒彎慢挽晩曼滿漫灣瞞萬蔓蠻輓饅鰻唜抹末沫茉襪靺亡妄忘忙望網罔芒茫莽輞邙埋妹媒寐昧枚梅每煤罵買賣邁魅脈貊陌驀麥孟氓猛盲盟萌冪覓免冕勉棉沔眄眠綿緬面麵滅�".split("");
for(j = 0; j != D[216].length; ++j) if(D[216][j].charCodeAt(0) !== 0xFFFD) { e[D[216][j]] = 55296 + j; d[55296 + j] = D[216][j];}
D[217] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������蔑冥名命明暝椧溟皿瞑茗蓂螟酩銘鳴袂侮冒募姆帽慕摸摹暮某模母毛牟牡瑁眸矛耗芼茅謀謨貌木沐牧目睦穆鶩歿沒夢朦蒙卯墓妙廟描昴杳渺猫竗苗錨務巫憮懋戊拇撫无楙武毋無珷畝繆舞茂蕪誣貿霧鵡墨默們刎吻問文�".split("");
for(j = 0; j != D[217].length; ++j) if(D[217][j].charCodeAt(0) !== 0xFFFD) { e[D[217][j]] = 55552 + j; d[55552 + j] = D[217][j];}
D[218] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������汶紊紋聞蚊門雯勿沕物味媚尾嵋彌微未梶楣渼湄眉米美薇謎迷靡黴岷悶愍憫敏旻旼民泯玟珉緡閔密蜜謐剝博拍搏撲朴樸泊珀璞箔粕縛膊舶薄迫雹駁伴半反叛拌搬攀斑槃泮潘班畔瘢盤盼磐磻礬絆般蟠返頒飯勃拔撥渤潑�".split("");
for(j = 0; j != D[218].length; ++j) if(D[218][j].charCodeAt(0) !== 0xFFFD) { e[D[218][j]] = 55808 + j; d[55808 + j] = D[218][j];}
D[219] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������發跋醱鉢髮魃倣傍坊妨尨幇彷房放方旁昉枋榜滂磅紡肪膀舫芳蒡蚌訪謗邦防龐倍俳北培徘拜排杯湃焙盃背胚裴裵褙賠輩配陪伯佰帛柏栢白百魄幡樊煩燔番磻繁蕃藩飜伐筏罰閥凡帆梵氾汎泛犯範范法琺僻劈壁擘檗璧癖�".split("");
for(j = 0; j != D[219].length; ++j) if(D[219][j].charCodeAt(0) !== 0xFFFD) { e[D[219][j]] = 56064 + j; d[56064 + j] = D[219][j];}
D[220] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������碧蘗闢霹便卞弁變辨辯邊別瞥鱉鼈丙倂兵屛幷昞昺柄棅炳甁病秉竝輧餠騈保堡報寶普步洑湺潽珤甫菩補褓譜輔伏僕匐卜宓復服福腹茯蔔複覆輹輻馥鰒本乶俸奉封峯峰捧棒烽熢琫縫蓬蜂逢鋒鳳不付俯傅剖副否咐埠夫婦�".split("");
for(j = 0; j != D[220].length; ++j) if(D[220][j].charCodeAt(0) !== 0xFFFD) { e[D[220][j]] = 56320 + j; d[56320 + j] = D[220][j];}
D[221] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������孚孵富府復扶敷斧浮溥父符簿缶腐腑膚艀芙莩訃負賦賻赴趺部釜阜附駙鳧北分吩噴墳奔奮忿憤扮昐汾焚盆粉糞紛芬賁雰不佛弗彿拂崩朋棚硼繃鵬丕備匕匪卑妃婢庇悲憊扉批斐枇榧比毖毗毘沸泌琵痺砒碑秕秘粃緋翡肥�".split("");
for(j = 0; j != D[221].length; ++j) if(D[221][j].charCodeAt(0) !== 0xFFFD) { e[D[221][j]] = 56576 + j; d[56576 + j] = D[221][j];}
D[222] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������脾臂菲蜚裨誹譬費鄙非飛鼻嚬嬪彬斌檳殯浜濱瀕牝玭貧賓頻憑氷聘騁乍事些仕伺似使俟僿史司唆嗣四士奢娑寫寺射巳師徙思捨斜斯柶査梭死沙泗渣瀉獅砂社祀祠私篩紗絲肆舍莎蓑蛇裟詐詞謝賜赦辭邪飼駟麝削數朔索�".split("");
for(j = 0; j != D[222].length; ++j) if(D[222][j].charCodeAt(0) !== 0xFFFD) { e[D[222][j]] = 56832 + j; d[56832 + j] = D[222][j];}
D[223] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������傘刪山散汕珊産疝算蒜酸霰乷撒殺煞薩三參杉森渗芟蔘衫揷澁鈒颯上傷像償商喪嘗孀尙峠常床庠廂想桑橡湘爽牀狀相祥箱翔裳觴詳象賞霜塞璽賽嗇塞穡索色牲生甥省笙墅壻嶼序庶徐恕抒捿敍暑曙書栖棲犀瑞筮絮緖署�".split("");
for(j = 0; j != D[223].length; ++j) if(D[223][j].charCodeAt(0) !== 0xFFFD) { e[D[223][j]] = 57088 + j; d[57088 + j] = D[223][j];}
D[224] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������胥舒薯西誓逝鋤黍鼠夕奭席惜昔晳析汐淅潟石碩蓆釋錫仙僊先善嬋宣扇敾旋渲煽琁瑄璇璿癬禪線繕羨腺膳船蘚蟬詵跣選銑鐥饍鮮卨屑楔泄洩渫舌薛褻設說雪齧剡暹殲纖蟾贍閃陝攝涉燮葉城姓宬性惺成星晟猩珹盛省筬�".split("");
for(j = 0; j != D[224].length; ++j) if(D[224][j].charCodeAt(0) !== 0xFFFD) { e[D[224][j]] = 57344 + j; d[57344 + j] = D[224][j];}
D[225] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������聖聲腥誠醒世勢歲洗稅笹細說貰召嘯塑宵小少巢所掃搔昭梳沼消溯瀟炤燒甦疏疎瘙笑篠簫素紹蔬蕭蘇訴逍遡邵銷韶騷俗屬束涑粟續謖贖速孫巽損蓀遜飡率宋悚松淞訟誦送頌刷殺灑碎鎖衰釗修受嗽囚垂壽嫂守岫峀帥愁�".split("");
for(j = 0; j != D[225].length; ++j) if(D[225][j].charCodeAt(0) !== 0xFFFD) { e[D[225][j]] = 57600 + j; d[57600 + j] = D[225][j];}
D[226] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������戍手授搜收數樹殊水洙漱燧狩獸琇璲瘦睡秀穗竪粹綏綬繡羞脩茱蒐蓚藪袖誰讐輸遂邃酬銖銹隋隧隨雖需須首髓鬚叔塾夙孰宿淑潚熟琡璹肅菽巡徇循恂旬栒楯橓殉洵淳珣盾瞬筍純脣舜荀蓴蕣詢諄醇錞順馴戌術述鉥崇崧�".split("");
for(j = 0; j != D[226].length; ++j) if(D[226][j].charCodeAt(0) !== 0xFFFD) { e[D[226][j]] = 57856 + j; d[57856 + j] = D[226][j];}
D[227] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������嵩瑟膝蝨濕拾習褶襲丞乘僧勝升承昇繩蠅陞侍匙嘶始媤尸屎屍市弑恃施是時枾柴猜矢示翅蒔蓍視試詩諡豕豺埴寔式息拭植殖湜熄篒蝕識軾食飾伸侁信呻娠宸愼新晨燼申神紳腎臣莘薪藎蜃訊身辛辰迅失室實悉審尋心沁�".split("");
for(j = 0; j != D[227].length; ++j) if(D[227][j].charCodeAt(0) !== 0xFFFD) { e[D[227][j]] = 58112 + j; d[58112 + j] = D[227][j];}
D[228] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������沈深瀋甚芯諶什十拾雙氏亞俄兒啞娥峨我牙芽莪蛾衙訝阿雅餓鴉鵝堊岳嶽幄惡愕握樂渥鄂鍔顎鰐齷安岸按晏案眼雁鞍顔鮟斡謁軋閼唵岩巖庵暗癌菴闇壓押狎鴨仰央怏昻殃秧鴦厓哀埃崖愛曖涯碍艾隘靄厄扼掖液縊腋額�".split("");
for(j = 0; j != D[228].length; ++j) if(D[228][j].charCodeAt(0) !== 0xFFFD) { e[D[228][j]] = 58368 + j; d[58368 + j] = D[228][j];}
D[229] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������櫻罌鶯鸚也倻冶夜惹揶椰爺耶若野弱掠略約若葯蒻藥躍亮佯兩凉壤孃恙揚攘敭暘梁楊樣洋瀁煬痒瘍禳穰糧羊良襄諒讓釀陽量養圄御於漁瘀禦語馭魚齬億憶抑檍臆偃堰彦焉言諺孼蘖俺儼嚴奄掩淹嶪業円予余勵呂女如廬�".split("");
for(j = 0; j != D[229].length; ++j) if(D[229][j].charCodeAt(0) !== 0xFFFD) { e[D[229][j]] = 58624 + j; d[58624 + j] = D[229][j];}
D[230] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������旅歟汝濾璵礖礪與艅茹輿轝閭餘驪麗黎亦力域役易曆歷疫繹譯轢逆驛嚥堧姸娟宴年延憐戀捐挻撚椽沇沿涎涓淵演漣烟然煙煉燃燕璉硏硯秊筵緣練縯聯衍軟輦蓮連鉛鍊鳶列劣咽悅涅烈熱裂說閱厭廉念捻染殮炎焰琰艶苒�".split("");
for(j = 0; j != D[230].length; ++j) if(D[230][j].charCodeAt(0) !== 0xFFFD) { e[D[230][j]] = 58880 + j; d[58880 + j] = D[230][j];}
D[231] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������簾閻髥鹽曄獵燁葉令囹塋寧嶺嶸影怜映暎楹榮永泳渶潁濚瀛瀯煐營獰玲瑛瑩瓔盈穎纓羚聆英詠迎鈴鍈零霙靈領乂倪例刈叡曳汭濊猊睿穢芮藝蘂禮裔詣譽豫醴銳隸霓預五伍俉傲午吾吳嗚塢墺奧娛寤悟惡懊敖旿晤梧汚澳�".split("");
for(j = 0; j != D[231].length; ++j) if(D[231][j].charCodeAt(0) !== 0xFFFD) { e[D[231][j]] = 59136 + j; d[59136 + j] = D[231][j];}
D[232] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������烏熬獒筽蜈誤鰲鼇屋沃獄玉鈺溫瑥瘟穩縕蘊兀壅擁瓮甕癰翁邕雍饔渦瓦窩窪臥蛙蝸訛婉完宛梡椀浣玩琓琬碗緩翫脘腕莞豌阮頑曰往旺枉汪王倭娃歪矮外嵬巍猥畏了僚僥凹堯夭妖姚寥寮尿嶢拗搖撓擾料曜樂橈燎燿瑤療�".split("");
for(j = 0; j != D[232].length; ++j) if(D[232][j].charCodeAt(0) !== 0xFFFD) { e[D[232][j]] = 59392 + j; d[59392 + j] = D[232][j];}
D[233] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������窈窯繇繞耀腰蓼蟯要謠遙遼邀饒慾欲浴縟褥辱俑傭冗勇埇墉容庸慂榕涌湧溶熔瑢用甬聳茸蓉踊鎔鏞龍于佑偶優又友右宇寓尤愚憂旴牛玗瑀盂祐禑禹紆羽芋藕虞迂遇郵釪隅雨雩勖彧旭昱栯煜稶郁頊云暈橒殞澐熉耘芸蕓�".split("");
for(j = 0; j != D[233].length; ++j) if(D[233][j].charCodeAt(0) !== 0xFFFD) { e[D[233][j]] = 59648 + j; d[59648 + j] = D[233][j];}
D[234] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������運隕雲韻蔚鬱亐熊雄元原員圓園垣媛嫄寃怨愿援沅洹湲源爰猿瑗苑袁轅遠阮院願鴛月越鉞位偉僞危圍委威尉慰暐渭爲瑋緯胃萎葦蔿蝟衛褘謂違韋魏乳侑儒兪劉唯喩孺宥幼幽庾悠惟愈愉揄攸有杻柔柚柳楡楢油洧流游溜�".split("");
for(j = 0; j != D[234].length; ++j) if(D[234][j].charCodeAt(0) !== 0xFFFD) { e[D[234][j]] = 59904 + j; d[59904 + j] = D[234][j];}
D[235] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������濡猶猷琉瑜由留癒硫紐維臾萸裕誘諛諭踰蹂遊逾遺酉釉鍮類六堉戮毓肉育陸倫允奫尹崙淪潤玧胤贇輪鈗閏律慄栗率聿戎瀜絨融隆垠恩慇殷誾銀隱乙吟淫蔭陰音飮揖泣邑凝應膺鷹依倚儀宜意懿擬椅毅疑矣義艤薏蟻衣誼�".split("");
for(j = 0; j != D[235].length; ++j) if(D[235][j].charCodeAt(0) !== 0xFFFD) { e[D[235][j]] = 60160 + j; d[60160 + j] = D[235][j];}
D[236] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������議醫二以伊利吏夷姨履已弛彛怡易李梨泥爾珥理異痍痢移罹而耳肄苡荑裏裡貽貳邇里離飴餌匿溺瀷益翊翌翼謚人仁刃印吝咽因姻寅引忍湮燐璘絪茵藺蚓認隣靭靷鱗麟一佚佾壹日溢逸鎰馹任壬妊姙恁林淋稔臨荏賃入卄�".split("");
for(j = 0; j != D[236].length; ++j) if(D[236][j].charCodeAt(0) !== 0xFFFD) { e[D[236][j]] = 60416 + j; d[60416 + j] = D[236][j];}
D[237] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������立笠粒仍剩孕芿仔刺咨姉姿子字孜恣慈滋炙煮玆瓷疵磁紫者自茨蔗藉諮資雌作勺嚼斫昨灼炸爵綽芍酌雀鵲孱棧殘潺盞岑暫潛箴簪蠶雜丈仗匠場墻壯奬將帳庄張掌暲杖樟檣欌漿牆狀獐璋章粧腸臟臧莊葬蔣薔藏裝贓醬長�".split("");
for(j = 0; j != D[237].length; ++j) if(D[237][j].charCodeAt(0) !== 0xFFFD) { e[D[237][j]] = 60672 + j; d[60672 + j] = D[237][j];}
D[238] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������障再哉在宰才材栽梓渽滓災縡裁財載齋齎爭箏諍錚佇低儲咀姐底抵杵楮樗沮渚狙猪疽箸紵苧菹著藷詛貯躇這邸雎齟勣吊嫡寂摘敵滴狄炙的積笛籍績翟荻謫賊赤跡蹟迪迹適鏑佃佺傳全典前剪塡塼奠專展廛悛戰栓殿氈澱�".split("");
for(j = 0; j != D[238].length; ++j) if(D[238][j].charCodeAt(0) !== 0xFFFD) { e[D[238][j]] = 60928 + j; d[60928 + j] = D[238][j];}
D[239] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������煎琠田甸畑癲筌箋箭篆纏詮輾轉鈿銓錢鐫電顚顫餞切截折浙癤竊節絶占岾店漸点粘霑鮎點接摺蝶丁井亭停偵呈姃定幀庭廷征情挺政整旌晶晸柾楨檉正汀淀淨渟湞瀞炡玎珽町睛碇禎程穽精綎艇訂諪貞鄭酊釘鉦鋌錠霆靖�".split("");
for(j = 0; j != D[239].length; ++j) if(D[239][j].charCodeAt(0) !== 0xFFFD) { e[D[239][j]] = 61184 + j; d[61184 + j] = D[239][j];}
D[240] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������靜頂鼎制劑啼堤帝弟悌提梯濟祭第臍薺製諸蹄醍除際霽題齊俎兆凋助嘲弔彫措操早晁曺曹朝條棗槽漕潮照燥爪璪眺祖祚租稠窕粗糟組繰肇藻蚤詔調趙躁造遭釣阻雕鳥族簇足鏃存尊卒拙猝倧宗從悰慫棕淙琮種終綜縱腫�".split("");
for(j = 0; j != D[240].length; ++j) if(D[240][j].charCodeAt(0) !== 0xFFFD) { e[D[240][j]] = 61440 + j; d[61440 + j] = D[240][j];}
D[241] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������踪踵鍾鐘佐坐左座挫罪主住侏做姝胄呪周嗾奏宙州廚晝朱柱株注洲湊澍炷珠疇籌紂紬綢舟蛛註誅走躊輳週酎酒鑄駐竹粥俊儁准埈寯峻晙樽浚準濬焌畯竣蠢逡遵雋駿茁中仲衆重卽櫛楫汁葺增憎曾拯烝甑症繒蒸證贈之只�".split("");
for(j = 0; j != D[241].length; ++j) if(D[241][j].charCodeAt(0) !== 0xFFFD) { e[D[241][j]] = 61696 + j; d[61696 + j] = D[241][j];}
D[242] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������咫地址志持指摯支旨智枝枳止池沚漬知砥祉祗紙肢脂至芝芷蜘誌識贄趾遲直稙稷織職唇嗔塵振搢晉晋桭榛殄津溱珍瑨璡畛疹盡眞瞋秦縉縝臻蔯袗診賑軫辰進鎭陣陳震侄叱姪嫉帙桎瓆疾秩窒膣蛭質跌迭斟朕什執潗緝輯�".split("");
for(j = 0; j != D[242].length; ++j) if(D[242][j].charCodeAt(0) !== 0xFFFD) { e[D[242][j]] = 61952 + j; d[61952 + j] = D[242][j];}
D[243] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������鏶集徵懲澄且侘借叉嗟嵯差次此磋箚茶蹉車遮捉搾着窄錯鑿齪撰澯燦璨瓚竄簒纂粲纘讚贊鑽餐饌刹察擦札紮僭參塹慘慙懺斬站讒讖倉倡創唱娼廠彰愴敞昌昶暢槍滄漲猖瘡窓脹艙菖蒼債埰寀寨彩採砦綵菜蔡采釵冊柵策�".split("");
for(j = 0; j != D[243].length; ++j) if(D[243][j].charCodeAt(0) !== 0xFFFD) { e[D[243][j]] = 62208 + j; d[62208 + j] = D[243][j];}
D[244] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������責凄妻悽處倜刺剔尺慽戚拓擲斥滌瘠脊蹠陟隻仟千喘天川擅泉淺玔穿舛薦賤踐遷釧闡阡韆凸哲喆徹撤澈綴輟轍鐵僉尖沾添甛瞻簽籤詹諂堞妾帖捷牒疊睫諜貼輒廳晴淸聽菁請靑鯖切剃替涕滯締諦逮遞體初剿哨憔抄招梢�".split("");
for(j = 0; j != D[244].length; ++j) if(D[244][j].charCodeAt(0) !== 0xFFFD) { e[D[244][j]] = 62464 + j; d[62464 + j] = D[244][j];}
D[245] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������椒楚樵炒焦硝礁礎秒稍肖艸苕草蕉貂超酢醋醮促囑燭矗蜀觸寸忖村邨叢塚寵悤憁摠總聰蔥銃撮催崔最墜抽推椎楸樞湫皺秋芻萩諏趨追鄒酋醜錐錘鎚雛騶鰍丑畜祝竺筑築縮蓄蹙蹴軸逐春椿瑃出朮黜充忠沖蟲衝衷悴膵萃�".split("");
for(j = 0; j != D[245].length; ++j) if(D[245][j].charCodeAt(0) !== 0xFFFD) { e[D[245][j]] = 62720 + j; d[62720 + j] = D[245][j];}
D[246] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������贅取吹嘴娶就炊翠聚脆臭趣醉驟鷲側仄厠惻測層侈値嗤峙幟恥梔治淄熾痔痴癡稚穉緇緻置致蚩輜雉馳齒則勅飭親七柒漆侵寢枕沈浸琛砧針鍼蟄秤稱快他咤唾墮妥惰打拖朶楕舵陀馱駝倬卓啄坼度托拓擢晫柝濁濯琢琸託�".split("");
for(j = 0; j != D[246].length; ++j) if(D[246][j].charCodeAt(0) !== 0xFFFD) { e[D[246][j]] = 62976 + j; d[62976 + j] = D[246][j];}
D[247] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������鐸呑嘆坦彈憚歎灘炭綻誕奪脫探眈耽貪塔搭榻宕帑湯糖蕩兌台太怠態殆汰泰笞胎苔跆邰颱宅擇澤撑攄兎吐土討慟桶洞痛筒統通堆槌腿褪退頹偸套妬投透鬪慝特闖坡婆巴把播擺杷波派爬琶破罷芭跛頗判坂板版瓣販辦鈑�".split("");
for(j = 0; j != D[247].length; ++j) if(D[247][j].charCodeAt(0) !== 0xFFFD) { e[D[247][j]] = 63232 + j; d[63232 + j] = D[247][j];}
D[248] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������阪八叭捌佩唄悖敗沛浿牌狽稗覇貝彭澎烹膨愎便偏扁片篇編翩遍鞭騙貶坪平枰萍評吠嬖幣廢弊斃肺蔽閉陛佈包匍匏咆哺圃布怖抛抱捕暴泡浦疱砲胞脯苞葡蒲袍褒逋鋪飽鮑幅暴曝瀑爆輻俵剽彪慓杓標漂瓢票表豹飇飄驃�".split("");
for(j = 0; j != D[248].length; ++j) if(D[248][j].charCodeAt(0) !== 0xFFFD) { e[D[248][j]] = 63488 + j; d[63488 + j] = D[248][j];}
D[249] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������品稟楓諷豊風馮彼披疲皮被避陂匹弼必泌珌畢疋筆苾馝乏逼下何厦夏廈昰河瑕荷蝦賀遐霞鰕壑學虐謔鶴寒恨悍旱汗漢澣瀚罕翰閑閒限韓割轄函含咸啣喊檻涵緘艦銜陷鹹合哈盒蛤閤闔陜亢伉姮嫦巷恒抗杭桁沆港缸肛航�".split("");
for(j = 0; j != D[249].length; ++j) if(D[249][j].charCodeAt(0) !== 0xFFFD) { e[D[249][j]] = 63744 + j; d[63744 + j] = D[249][j];}
D[250] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������行降項亥偕咳垓奚孩害懈楷海瀣蟹解該諧邂駭骸劾核倖幸杏荇行享向嚮珦鄕響餉饗香噓墟虛許憲櫶獻軒歇險驗奕爀赫革俔峴弦懸晛泫炫玄玹現眩睍絃絢縣舷衒見賢鉉顯孑穴血頁嫌俠協夾峽挾浹狹脅脇莢鋏頰亨兄刑型�".split("");
for(j = 0; j != D[250].length; ++j) if(D[250][j].charCodeAt(0) !== 0xFFFD) { e[D[250][j]] = 64000 + j; d[64000 + j] = D[250][j];}
D[251] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������形泂滎瀅灐炯熒珩瑩荊螢衡逈邢鎣馨兮彗惠慧暳蕙蹊醯鞋乎互呼壕壺好岵弧戶扈昊晧毫浩淏湖滸澔濠濩灝狐琥瑚瓠皓祜糊縞胡芦葫蒿虎號蝴護豪鎬頀顥惑或酷婚昏混渾琿魂忽惚笏哄弘汞泓洪烘紅虹訌鴻化和嬅樺火畵�".split("");
for(j = 0; j != D[251].length; ++j) if(D[251][j].charCodeAt(0) !== 0xFFFD) { e[D[251][j]] = 64256 + j; d[64256 + j] = D[251][j];}
D[252] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������禍禾花華話譁貨靴廓擴攫確碻穫丸喚奐宦幻患換歡晥桓渙煥環紈還驩鰥活滑猾豁闊凰幌徨恍惶愰慌晃晄榥況湟滉潢煌璜皇篁簧荒蝗遑隍黃匯回廻徊恢悔懷晦會檜淮澮灰獪繪膾茴蛔誨賄劃獲宖橫鐄哮嚆孝效斅曉梟涍淆�".split("");
for(j = 0; j != D[252].length; ++j) if(D[252][j].charCodeAt(0) !== 0xFFFD) { e[D[252][j]] = 64512 + j; d[64512 + j] = D[252][j];}
D[253] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������爻肴酵驍侯候厚后吼喉嗅帿後朽煦珝逅勛勳塤壎焄熏燻薰訓暈薨喧暄煊萱卉喙毁彙徽揮暉煇諱輝麾休携烋畦虧恤譎鷸兇凶匈洶胸黑昕欣炘痕吃屹紇訖欠欽歆吸恰洽翕興僖凞喜噫囍姬嬉希憙憘戱晞曦熙熹熺犧禧稀羲詰�".split("");
for(j = 0; j != D[253].length; ++j) if(D[253][j].charCodeAt(0) !== 0xFFFD) { e[D[253][j]] = 64768 + j; d[64768 + j] = D[253][j];}
return {"enc": e, "dec": d }; })();
cptable[950] = (function(){ var d = [], e = {}, D = [], j;
D[0] = "\u0000\u0001\u0002\u0003\u0004\u0005\u0006\u0007\b\t\n\u000b\f\r\u000e\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~��������������������������������������������������������������������������������������������������������������������������������".split("");
for(j = 0; j != D[0].length; ++j) if(D[0][j].charCodeAt(0) !== 0xFFFD) { e[D[0][j]] = 0 + j; d[0 + j] = D[0][j];}
D[161] = "����������������������������������������������������������������　，、。．‧；：？！︰…‥﹐﹑﹒·﹔﹕﹖﹗｜–︱—︳╴︴﹏（）︵︶｛｝︷︸〔〕︹︺【】︻︼《》︽︾〈〉︿﹀「」﹁﹂『』﹃﹄﹙﹚����������������������������������﹛﹜﹝﹞‘’“”〝〞‵′＃＆＊※§〃○●△▲◎☆★◇◆□■▽▼㊣℅¯￣＿ˍ﹉﹊﹍﹎﹋﹌﹟﹠﹡＋－×÷±√＜＞＝≦≧≠∞≒≡﹢﹣﹤﹥﹦～∩∪⊥∠∟⊿㏒㏑∫∮∵∴♀♂⊕⊙↑↓←→↖↗↙↘∥∣／�".split("");
for(j = 0; j != D[161].length; ++j) if(D[161][j].charCodeAt(0) !== 0xFFFD) { e[D[161][j]] = 41216 + j; d[41216 + j] = D[161][j];}
D[162] = "����������������������������������������������������������������＼∕﹨＄￥〒￠￡％＠℃℉﹩﹪﹫㏕㎜㎝㎞㏎㎡㎎㎏㏄°兙兛兞兝兡兣嗧瓩糎▁▂▃▄▅▆▇█▏▎▍▌▋▊▉┼┴┬┤├▔─│▕┌┐└┘╭����������������������������������╮╰╯═╞╪╡◢◣◥◤╱╲╳０１２３４５６７８９ⅠⅡⅢⅣⅤⅥⅦⅧⅨⅩ〡〢〣〤〥〦〧〨〩十卄卅ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖ�".split("");
for(j = 0; j != D[162].length; ++j) if(D[162][j].charCodeAt(0) !== 0xFFFD) { e[D[162][j]] = 41472 + j; d[41472 + j] = D[162][j];}
D[163] = "����������������������������������������������������������������ｗｘｙｚΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγδεζηθικλμνξοπρστυφχψωㄅㄆㄇㄈㄉㄊㄋㄌㄍㄎㄏ����������������������������������ㄐㄑㄒㄓㄔㄕㄖㄗㄘㄙㄚㄛㄜㄝㄞㄟㄠㄡㄢㄣㄤㄥㄦㄧㄨㄩ˙ˉˊˇˋ���������������������������������€������������������������������".split("");
for(j = 0; j != D[163].length; ++j) if(D[163][j].charCodeAt(0) !== 0xFFFD) { e[D[163][j]] = 41728 + j; d[41728 + j] = D[163][j];}
D[164] = "����������������������������������������������������������������一乙丁七乃九了二人儿入八几刀刁力匕十卜又三下丈上丫丸凡久么也乞于亡兀刃勺千叉口土士夕大女子孑孓寸小尢尸山川工己已巳巾干廾弋弓才����������������������������������丑丐不中丰丹之尹予云井互五亢仁什仃仆仇仍今介仄元允內六兮公冗凶分切刈勻勾勿化匹午升卅卞厄友及反壬天夫太夭孔少尤尺屯巴幻廿弔引心戈戶手扎支文斗斤方日曰月木欠止歹毋比毛氏水火爪父爻片牙牛犬王丙�".split("");
for(j = 0; j != D[164].length; ++j) if(D[164][j].charCodeAt(0) !== 0xFFFD) { e[D[164][j]] = 41984 + j; d[41984 + j] = D[164][j];}
D[165] = "����������������������������������������������������������������世丕且丘主乍乏乎以付仔仕他仗代令仙仞充兄冉冊冬凹出凸刊加功包匆北匝仟半卉卡占卯卮去可古右召叮叩叨叼司叵叫另只史叱台句叭叻四囚外����������������������������������央失奴奶孕它尼巨巧左市布平幼弁弘弗必戊打扔扒扑斥旦朮本未末札正母民氐永汁汀氾犯玄玉瓜瓦甘生用甩田由甲申疋白皮皿目矛矢石示禾穴立丞丟乒乓乩亙交亦亥仿伉伙伊伕伍伐休伏仲件任仰仳份企伋光兇兆先全�".split("");
for(j = 0; j != D[165].length; ++j) if(D[165][j].charCodeAt(0) !== 0xFFFD) { e[D[165][j]] = 42240 + j; d[42240 + j] = D[165][j];}
D[166] = "����������������������������������������������������������������共再冰列刑划刎刖劣匈匡匠印危吉吏同吊吐吁吋各向名合吃后吆吒因回囝圳地在圭圬圯圩夙多夷夸妄奸妃好她如妁字存宇守宅安寺尖屹州帆并年����������������������������������式弛忙忖戎戌戍成扣扛托收早旨旬旭曲曳有朽朴朱朵次此死氖汝汗汙江池汐汕污汛汍汎灰牟牝百竹米糸缶羊羽老考而耒耳聿肉肋肌臣自至臼舌舛舟艮色艾虫血行衣西阡串亨位住佇佗佞伴佛何估佐佑伽伺伸佃佔似但佣�".split("");
for(j = 0; j != D[166].length; ++j) if(D[166][j].charCodeAt(0) !== 0xFFFD) { e[D[166][j]] = 42496 + j; d[42496 + j] = D[166][j];}
D[167] = "����������������������������������������������������������������作你伯低伶余佝佈佚兌克免兵冶冷別判利刪刨劫助努劬匣即卵吝吭吞吾否呎吧呆呃吳呈呂君吩告吹吻吸吮吵吶吠吼呀吱含吟听囪困囤囫坊坑址坍����������������������������������均坎圾坐坏圻壯夾妝妒妨妞妣妙妖妍妤妓妊妥孝孜孚孛完宋宏尬局屁尿尾岐岑岔岌巫希序庇床廷弄弟彤形彷役忘忌志忍忱快忸忪戒我抄抗抖技扶抉扭把扼找批扳抒扯折扮投抓抑抆改攻攸旱更束李杏材村杜杖杞杉杆杠�".split("");
for(j = 0; j != D[167].length; ++j) if(D[167][j].charCodeAt(0) !== 0xFFFD) { e[D[167][j]] = 42752 + j; d[42752 + j] = D[167][j];}
D[168] = "����������������������������������������������������������������杓杗步每求汞沙沁沈沉沅沛汪決沐汰沌汨沖沒汽沃汲汾汴沆汶沍沔沘沂灶灼災灸牢牡牠狄狂玖甬甫男甸皂盯矣私秀禿究系罕肖肓肝肘肛肚育良芒����������������������������������芋芍見角言谷豆豕貝赤走足身車辛辰迂迆迅迄巡邑邢邪邦那酉釆里防阮阱阪阬並乖乳事些亞享京佯依侍佳使佬供例來侃佰併侈佩佻侖佾侏侑佺兔兒兕兩具其典冽函刻券刷刺到刮制剁劾劻卒協卓卑卦卷卸卹取叔受味呵�".split("");
for(j = 0; j != D[168].length; ++j) if(D[168][j].charCodeAt(0) !== 0xFFFD) { e[D[168][j]] = 43008 + j; d[43008 + j] = D[168][j];}
D[169] = "����������������������������������������������������������������咖呸咕咀呻呷咄咒咆呼咐呱呶和咚呢周咋命咎固垃坷坪坩坡坦坤坼夜奉奇奈奄奔妾妻委妹妮姑姆姐姍始姓姊妯妳姒姅孟孤季宗定官宜宙宛尚屈居����������������������������������屆岷岡岸岩岫岱岳帘帚帖帕帛帑幸庚店府底庖延弦弧弩往征彿彼忝忠忽念忿怏怔怯怵怖怪怕怡性怩怫怛或戕房戾所承拉拌拄抿拂抹拒招披拓拔拋拈抨抽押拐拙拇拍抵拚抱拘拖拗拆抬拎放斧於旺昔易昌昆昂明昀昏昕昊�".split("");
for(j = 0; j != D[169].length; ++j) if(D[169][j].charCodeAt(0) !== 0xFFFD) { e[D[169][j]] = 43264 + j; d[43264 + j] = D[169][j];}
D[170] = "����������������������������������������������������������������昇服朋杭枋枕東果杳杷枇枝林杯杰板枉松析杵枚枓杼杪杲欣武歧歿氓氛泣注泳沱泌泥河沽沾沼波沫法泓沸泄油況沮泗泅泱沿治泡泛泊沬泯泜泖泠����������������������������������炕炎炒炊炙爬爭爸版牧物狀狎狙狗狐玩玨玟玫玥甽疝疙疚的盂盲直知矽社祀祁秉秈空穹竺糾罔羌羋者肺肥肢肱股肫肩肴肪肯臥臾舍芳芝芙芭芽芟芹花芬芥芯芸芣芰芾芷虎虱初表軋迎返近邵邸邱邶采金長門阜陀阿阻附�".split("");
for(j = 0; j != D[170].length; ++j) if(D[170][j].charCodeAt(0) !== 0xFFFD) { e[D[170][j]] = 43520 + j; d[43520 + j] = D[170][j];}
D[171] = "����������������������������������������������������������������陂隹雨青非亟亭亮信侵侯便俠俑俏保促侶俘俟俊俗侮俐俄係俚俎俞侷兗冒冑冠剎剃削前剌剋則勇勉勃勁匍南卻厚叛咬哀咨哎哉咸咦咳哇哂咽咪品����������������������������������哄哈咯咫咱咻咩咧咿囿垂型垠垣垢城垮垓奕契奏奎奐姜姘姿姣姨娃姥姪姚姦威姻孩宣宦室客宥封屎屏屍屋峙峒巷帝帥帟幽庠度建弈弭彥很待徊律徇後徉怒思怠急怎怨恍恰恨恢恆恃恬恫恪恤扁拜挖按拼拭持拮拽指拱拷�".split("");
for(j = 0; j != D[171].length; ++j) if(D[171][j].charCodeAt(0) !== 0xFFFD) { e[D[171][j]] = 43776 + j; d[43776 + j] = D[171][j];}
D[172] = "����������������������������������������������������������������拯括拾拴挑挂政故斫施既春昭映昧是星昨昱昤曷柿染柱柔某柬架枯柵柩柯柄柑枴柚查枸柏柞柳枰柙柢柝柒歪殃殆段毒毗氟泉洋洲洪流津洌洱洞洗����������������������������������活洽派洶洛泵洹洧洸洩洮洵洎洫炫為炳炬炯炭炸炮炤爰牲牯牴狩狠狡玷珊玻玲珍珀玳甚甭畏界畎畋疫疤疥疢疣癸皆皇皈盈盆盃盅省盹相眉看盾盼眇矜砂研砌砍祆祉祈祇禹禺科秒秋穿突竿竽籽紂紅紀紉紇約紆缸美羿耄�".split("");
for(j = 0; j != D[172].length; ++j) if(D[172][j].charCodeAt(0) !== 0xFFFD) { e[D[172][j]] = 44032 + j; d[44032 + j] = D[172][j];}
D[173] = "����������������������������������������������������������������耐耍耑耶胖胥胚胃胄背胡胛胎胞胤胝致舢苧范茅苣苛苦茄若茂茉苒苗英茁苜苔苑苞苓苟苯茆虐虹虻虺衍衫要觔計訂訃貞負赴赳趴軍軌述迦迢迪迥����������������������������������迭迫迤迨郊郎郁郃酋酊重閂限陋陌降面革韋韭音頁風飛食首香乘亳倌倍倣俯倦倥俸倩倖倆值借倚倒們俺倀倔倨俱倡個候倘俳修倭倪俾倫倉兼冤冥冢凍凌准凋剖剜剔剛剝匪卿原厝叟哨唐唁唷哼哥哲唆哺唔哩哭員唉哮哪�".split("");
for(j = 0; j != D[173].length; ++j) if(D[173][j].charCodeAt(0) !== 0xFFFD) { e[D[173][j]] = 44288 + j; d[44288 + j] = D[173][j];}
D[174] = "����������������������������������������������������������������哦唧唇哽唏圃圄埂埔埋埃堉夏套奘奚娑娘娜娟娛娓姬娠娣娩娥娌娉孫屘宰害家宴宮宵容宸射屑展屐峭峽峻峪峨峰島崁峴差席師庫庭座弱徒徑徐恙����������������������������������恣恥恐恕恭恩息悄悟悚悍悔悌悅悖扇拳挈拿捎挾振捕捂捆捏捉挺捐挽挪挫挨捍捌效敉料旁旅時晉晏晃晒晌晅晁書朔朕朗校核案框桓根桂桔栩梳栗桌桑栽柴桐桀格桃株桅栓栘桁殊殉殷氣氧氨氦氤泰浪涕消涇浦浸海浙涓�".split("");
for(j = 0; j != D[174].length; ++j) if(D[174][j].charCodeAt(0) !== 0xFFFD) { e[D[174][j]] = 44544 + j; d[44544 + j] = D[174][j];}
D[175] = "����������������������������������������������������������������浬涉浮浚浴浩涌涊浹涅浥涔烊烘烤烙烈烏爹特狼狹狽狸狷玆班琉珮珠珪珞畔畝畜畚留疾病症疲疳疽疼疹痂疸皋皰益盍盎眩真眠眨矩砰砧砸砝破砷����������������������������������砥砭砠砟砲祕祐祠祟祖神祝祗祚秤秣秧租秦秩秘窄窈站笆笑粉紡紗紋紊素索純紐紕級紜納紙紛缺罟羔翅翁耆耘耕耙耗耽耿胱脂胰脅胭胴脆胸胳脈能脊胼胯臭臬舀舐航舫舨般芻茫荒荔荊茸荐草茵茴荏茲茹茶茗荀茱茨荃�".split("");
for(j = 0; j != D[175].length; ++j) if(D[175][j].charCodeAt(0) !== 0xFFFD) { e[D[175][j]] = 44800 + j; d[44800 + j] = D[175][j];}
D[176] = "����������������������������������������������������������������虔蚊蚪蚓蚤蚩蚌蚣蚜衰衷袁袂衽衹記訐討訌訕訊託訓訖訏訑豈豺豹財貢起躬軒軔軏辱送逆迷退迺迴逃追逅迸邕郡郝郢酒配酌釘針釗釜釙閃院陣陡����������������������������������陛陝除陘陞隻飢馬骨高鬥鬲鬼乾偺偽停假偃偌做偉健偶偎偕偵側偷偏倏偯偭兜冕凰剪副勒務勘動匐匏匙匿區匾參曼商啪啦啄啞啡啃啊唱啖問啕唯啤唸售啜唬啣唳啁啗圈國圉域堅堊堆埠埤基堂堵執培夠奢娶婁婉婦婪婀�".split("");
for(j = 0; j != D[176].length; ++j) if(D[176][j].charCodeAt(0) !== 0xFFFD) { e[D[176][j]] = 45056 + j; d[45056 + j] = D[176][j];}
D[177] = "����������������������������������������������������������������娼婢婚婆婊孰寇寅寄寂宿密尉專將屠屜屝崇崆崎崛崖崢崑崩崔崙崤崧崗巢常帶帳帷康庸庶庵庾張強彗彬彩彫得徙從徘御徠徜恿患悉悠您惋悴惦悽����������������������������������情悻悵惜悼惘惕惆惟悸惚惇戚戛扈掠控捲掖探接捷捧掘措捱掩掉掃掛捫推掄授掙採掬排掏掀捻捩捨捺敝敖救教敗啟敏敘敕敔斜斛斬族旋旌旎晝晚晤晨晦晞曹勗望梁梯梢梓梵桿桶梱梧梗械梃棄梭梆梅梔條梨梟梡梂欲殺�".split("");
for(j = 0; j != D[177].length; ++j) if(D[177][j].charCodeAt(0) !== 0xFFFD) { e[D[177][j]] = 45312 + j; d[45312 + j] = D[177][j];}
D[178] = "����������������������������������������������������������������毫毬氫涎涼淳淙液淡淌淤添淺清淇淋涯淑涮淞淹涸混淵淅淒渚涵淚淫淘淪深淮淨淆淄涪淬涿淦烹焉焊烽烯爽牽犁猜猛猖猓猙率琅琊球理現琍瓠瓶����������������������������������瓷甜產略畦畢異疏痔痕疵痊痍皎盔盒盛眷眾眼眶眸眺硫硃硎祥票祭移窒窕笠笨笛第符笙笞笮粒粗粕絆絃統紮紹紼絀細紳組累終紲紱缽羞羚翌翎習耜聊聆脯脖脣脫脩脰脤舂舵舷舶船莎莞莘荸莢莖莽莫莒莊莓莉莠荷荻荼�".split("");
for(j = 0; j != D[178].length; ++j) if(D[178][j].charCodeAt(0) !== 0xFFFD) { e[D[178][j]] = 45568 + j; d[45568 + j] = D[178][j];}
D[179] = "����������������������������������������������������������������莆莧處彪蛇蛀蚶蛄蚵蛆蛋蚱蚯蛉術袞袈被袒袖袍袋覓規訪訝訣訥許設訟訛訢豉豚販責貫貨貪貧赧赦趾趺軛軟這逍通逗連速逝逐逕逞造透逢逖逛途����������������������������������部郭都酗野釵釦釣釧釭釩閉陪陵陳陸陰陴陶陷陬雀雪雩章竟頂頃魚鳥鹵鹿麥麻傢傍傅備傑傀傖傘傚最凱割剴創剩勞勝勛博厥啻喀喧啼喊喝喘喂喜喪喔喇喋喃喳單喟唾喲喚喻喬喱啾喉喫喙圍堯堪場堤堰報堡堝堠壹壺奠�".split("");
for(j = 0; j != D[179].length; ++j) if(D[179][j].charCodeAt(0) !== 0xFFFD) { e[D[179][j]] = 45824 + j; d[45824 + j] = D[179][j];}
D[180] = "����������������������������������������������������������������婷媚婿媒媛媧孳孱寒富寓寐尊尋就嵌嵐崴嵇巽幅帽幀幃幾廊廁廂廄弼彭復循徨惑惡悲悶惠愜愣惺愕惰惻惴慨惱愎惶愉愀愒戟扉掣掌描揀揩揉揆揍����������������������������������插揣提握揖揭揮捶援揪換摒揚揹敞敦敢散斑斐斯普晰晴晶景暑智晾晷曾替期朝棺棕棠棘棗椅棟棵森棧棹棒棲棣棋棍植椒椎棉棚楮棻款欺欽殘殖殼毯氮氯氬港游湔渡渲湧湊渠渥渣減湛湘渤湖湮渭渦湯渴湍渺測湃渝渾滋�".split("");
for(j = 0; j != D[180].length; ++j) if(D[180][j].charCodeAt(0) !== 0xFFFD) { e[D[180][j]] = 46080 + j; d[46080 + j] = D[180][j];}
D[181] = "����������������������������������������������������������������溉渙湎湣湄湲湩湟焙焚焦焰無然煮焜牌犄犀猶猥猴猩琺琪琳琢琥琵琶琴琯琛琦琨甥甦畫番痢痛痣痙痘痞痠登發皖皓皴盜睏短硝硬硯稍稈程稅稀窘����������������������������������窗窖童竣等策筆筐筒答筍筋筏筑粟粥絞結絨絕紫絮絲絡給絢絰絳善翔翕耋聒肅腕腔腋腑腎脹腆脾腌腓腴舒舜菩萃菸萍菠菅萋菁華菱菴著萊菰萌菌菽菲菊萸萎萄菜萇菔菟虛蛟蛙蛭蛔蛛蛤蛐蛞街裁裂袱覃視註詠評詞証詁�".split("");
for(j = 0; j != D[181].length; ++j) if(D[181][j].charCodeAt(0) !== 0xFFFD) { e[D[181][j]] = 46336 + j; d[46336 + j] = D[181][j];}
D[182] = "����������������������������������������������������������������詔詛詐詆訴診訶詖象貂貯貼貳貽賁費賀貴買貶貿貸越超趁跎距跋跚跑跌跛跆軻軸軼辜逮逵週逸進逶鄂郵鄉郾酣酥量鈔鈕鈣鈉鈞鈍鈐鈇鈑閔閏開閑����������������������������������間閒閎隊階隋陽隅隆隍陲隄雁雅雄集雇雯雲韌項順須飧飪飯飩飲飭馮馭黃黍黑亂傭債傲傳僅傾催傷傻傯僇剿剷剽募勦勤勢勣匯嗟嗨嗓嗦嗎嗜嗇嗑嗣嗤嗯嗚嗡嗅嗆嗥嗉園圓塞塑塘塗塚塔填塌塭塊塢塒塋奧嫁嫉嫌媾媽媼�".split("");
for(j = 0; j != D[182].length; ++j) if(D[182][j].charCodeAt(0) !== 0xFFFD) { e[D[182][j]] = 46592 + j; d[46592 + j] = D[182][j];}
D[183] = "����������������������������������������������������������������媳嫂媲嵩嵯幌幹廉廈弒彙徬微愚意慈感想愛惹愁愈慎慌慄慍愾愴愧愍愆愷戡戢搓搾搞搪搭搽搬搏搜搔損搶搖搗搆敬斟新暗暉暇暈暖暄暘暍會榔業����������������������������������楚楷楠楔極椰概楊楨楫楞楓楹榆楝楣楛歇歲毀殿毓毽溢溯滓溶滂源溝滇滅溥溘溼溺溫滑準溜滄滔溪溧溴煎煙煩煤煉照煜煬煦煌煥煞煆煨煖爺牒猷獅猿猾瑯瑚瑕瑟瑞瑁琿瑙瑛瑜當畸瘀痰瘁痲痱痺痿痴痳盞盟睛睫睦睞督�".split("");
for(j = 0; j != D[183].length; ++j) if(D[183][j].charCodeAt(0) !== 0xFFFD) { e[D[183][j]] = 46848 + j; d[46848 + j] = D[183][j];}
D[184] = "����������������������������������������������������������������睹睪睬睜睥睨睢矮碎碰碗碘碌碉硼碑碓硿祺祿禁萬禽稜稚稠稔稟稞窟窠筷節筠筮筧粱粳粵經絹綑綁綏絛置罩罪署義羨群聖聘肆肄腱腰腸腥腮腳腫����������������������������������腹腺腦舅艇蒂葷落萱葵葦葫葉葬葛萼萵葡董葩葭葆虞虜號蛹蜓蜈蜇蜀蛾蛻蜂蜃蜆蜊衙裟裔裙補裘裝裡裊裕裒覜解詫該詳試詩詰誇詼詣誠話誅詭詢詮詬詹詻訾詨豢貊貉賊資賈賄貲賃賂賅跡跟跨路跳跺跪跤跦躲較載軾輊�".split("");
for(j = 0; j != D[184].length; ++j) if(D[184][j].charCodeAt(0) !== 0xFFFD) { e[D[184][j]] = 47104 + j; d[47104 + j] = D[184][j];}
D[185] = "����������������������������������������������������������������辟農運遊道遂達逼違遐遇遏過遍遑逾遁鄒鄗酬酪酩釉鈷鉗鈸鈽鉀鈾鉛鉋鉤鉑鈴鉉鉍鉅鈹鈿鉚閘隘隔隕雍雋雉雊雷電雹零靖靴靶預頑頓頊頒頌飼飴����������������������������������飽飾馳馱馴髡鳩麂鼎鼓鼠僧僮僥僖僭僚僕像僑僱僎僩兢凳劃劂匱厭嗾嘀嘛嘗嗽嘔嘆嘉嘍嘎嗷嘖嘟嘈嘐嗶團圖塵塾境墓墊塹墅塽壽夥夢夤奪奩嫡嫦嫩嫗嫖嫘嫣孵寞寧寡寥實寨寢寤察對屢嶄嶇幛幣幕幗幔廓廖弊彆彰徹慇�".split("");
for(j = 0; j != D[185].length; ++j) if(D[185][j].charCodeAt(0) !== 0xFFFD) { e[D[185][j]] = 47360 + j; d[47360 + j] = D[185][j];}
D[186] = "����������������������������������������������������������������愿態慷慢慣慟慚慘慵截撇摘摔撤摸摟摺摑摧搴摭摻敲斡旗旖暢暨暝榜榨榕槁榮槓構榛榷榻榫榴槐槍榭槌榦槃榣歉歌氳漳演滾漓滴漩漾漠漬漏漂漢����������������������������������滿滯漆漱漸漲漣漕漫漯澈漪滬漁滲滌滷熔熙煽熊熄熒爾犒犖獄獐瑤瑣瑪瑰瑭甄疑瘧瘍瘋瘉瘓盡監瞄睽睿睡磁碟碧碳碩碣禎福禍種稱窪窩竭端管箕箋筵算箝箔箏箸箇箄粹粽精綻綰綜綽綾綠緊綴網綱綺綢綿綵綸維緒緇綬�".split("");
for(j = 0; j != D[186].length; ++j) if(D[186][j].charCodeAt(0) !== 0xFFFD) { e[D[186][j]] = 47616 + j; d[47616 + j] = D[186][j];}
D[187] = "����������������������������������������������������������������罰翠翡翟聞聚肇腐膀膏膈膊腿膂臧臺與舔舞艋蓉蒿蓆蓄蒙蒞蒲蒜蓋蒸蓀蓓蒐蒼蓑蓊蜿蜜蜻蜢蜥蜴蜘蝕蜷蜩裳褂裴裹裸製裨褚裯誦誌語誣認誡誓誤����������������������������������說誥誨誘誑誚誧豪貍貌賓賑賒赫趙趕跼輔輒輕輓辣遠遘遜遣遙遞遢遝遛鄙鄘鄞酵酸酷酴鉸銀銅銘銖鉻銓銜銨鉼銑閡閨閩閣閥閤隙障際雌雒需靼鞅韶頗領颯颱餃餅餌餉駁骯骰髦魁魂鳴鳶鳳麼鼻齊億儀僻僵價儂儈儉儅凜�".split("");
for(j = 0; j != D[187].length; ++j) if(D[187][j].charCodeAt(0) !== 0xFFFD) { e[D[187][j]] = 47872 + j; d[47872 + j] = D[187][j];}
D[188] = "����������������������������������������������������������������劇劈劉劍劊勰厲嘮嘻嘹嘲嘿嘴嘩噓噎噗噴嘶嘯嘰墀墟增墳墜墮墩墦奭嬉嫻嬋嫵嬌嬈寮寬審寫層履嶝嶔幢幟幡廢廚廟廝廣廠彈影德徵慶慧慮慝慕憂����������������������������������慼慰慫慾憧憐憫憎憬憚憤憔憮戮摩摯摹撞撲撈撐撰撥撓撕撩撒撮播撫撚撬撙撢撳敵敷數暮暫暴暱樣樟槨樁樞標槽模樓樊槳樂樅槭樑歐歎殤毅毆漿潼澄潑潦潔澆潭潛潸潮澎潺潰潤澗潘滕潯潠潟熟熬熱熨牖犛獎獗瑩璋璃�".split("");
for(j = 0; j != D[188].length; ++j) if(D[188][j].charCodeAt(0) !== 0xFFFD) { e[D[188][j]] = 48128 + j; d[48128 + j] = D[188][j];}
D[189] = "����������������������������������������������������������������瑾璀畿瘠瘩瘟瘤瘦瘡瘢皚皺盤瞎瞇瞌瞑瞋磋磅確磊碾磕碼磐稿稼穀稽稷稻窯窮箭箱範箴篆篇篁箠篌糊締練緯緻緘緬緝編緣線緞緩綞緙緲緹罵罷羯����������������������������������翩耦膛膜膝膠膚膘蔗蔽蔚蓮蔬蔭蔓蔑蔣蔡蔔蓬蔥蓿蔆螂蝴蝶蝠蝦蝸蝨蝙蝗蝌蝓衛衝褐複褒褓褕褊誼諒談諄誕請諸課諉諂調誰論諍誶誹諛豌豎豬賠賞賦賤賬賭賢賣賜質賡赭趟趣踫踐踝踢踏踩踟踡踞躺輝輛輟輩輦輪輜輞�".split("");
for(j = 0; j != D[189].length; ++j) if(D[189][j].charCodeAt(0) !== 0xFFFD) { e[D[189][j]] = 48384 + j; d[48384 + j] = D[189][j];}
D[190] = "����������������������������������������������������������������輥適遮遨遭遷鄰鄭鄧鄱醇醉醋醃鋅銻銷鋪銬鋤鋁銳銼鋒鋇鋰銲閭閱霄霆震霉靠鞍鞋鞏頡頫頜颳養餓餒餘駝駐駟駛駑駕駒駙骷髮髯鬧魅魄魷魯鴆鴉����������������������������������鴃麩麾黎墨齒儒儘儔儐儕冀冪凝劑劓勳噙噫噹噩噤噸噪器噥噱噯噬噢噶壁墾壇壅奮嬝嬴學寰導彊憲憑憩憊懍憶憾懊懈戰擅擁擋撻撼據擄擇擂操撿擒擔撾整曆曉暹曄曇暸樽樸樺橙橫橘樹橄橢橡橋橇樵機橈歙歷氅濂澱澡�".split("");
for(j = 0; j != D[190].length; ++j) if(D[190][j].charCodeAt(0) !== 0xFFFD) { e[D[190][j]] = 48640 + j; d[48640 + j] = D[190][j];}
D[191] = "����������������������������������������������������������������濃澤濁澧澳激澹澶澦澠澴熾燉燐燒燈燕熹燎燙燜燃燄獨璜璣璘璟璞瓢甌甍瘴瘸瘺盧盥瞠瞞瞟瞥磨磚磬磧禦積穎穆穌穋窺篙簑築篤篛篡篩篦糕糖縊����������������������������������縑縈縛縣縞縝縉縐罹羲翰翱翮耨膳膩膨臻興艘艙蕊蕙蕈蕨蕩蕃蕉蕭蕪蕞螃螟螞螢融衡褪褲褥褫褡親覦諦諺諫諱謀諜諧諮諾謁謂諷諭諳諶諼豫豭貓賴蹄踱踴蹂踹踵輻輯輸輳辨辦遵遴選遲遼遺鄴醒錠錶鋸錳錯錢鋼錫錄錚�".split("");
for(j = 0; j != D[191].length; ++j) if(D[191][j].charCodeAt(0) !== 0xFFFD) { e[D[191][j]] = 48896 + j; d[48896 + j] = D[191][j];}
D[192] = "����������������������������������������������������������������錐錦錡錕錮錙閻隧隨險雕霎霑霖霍霓霏靛靜靦鞘頰頸頻頷頭頹頤餐館餞餛餡餚駭駢駱骸骼髻髭鬨鮑鴕鴣鴦鴨鴒鴛默黔龍龜優償儡儲勵嚎嚀嚐嚅嚇����������������������������������嚏壕壓壑壎嬰嬪嬤孺尷屨嶼嶺嶽嶸幫彌徽應懂懇懦懋戲戴擎擊擘擠擰擦擬擱擢擭斂斃曙曖檀檔檄檢檜櫛檣橾檗檐檠歜殮毚氈濘濱濟濠濛濤濫濯澀濬濡濩濕濮濰燧營燮燦燥燭燬燴燠爵牆獰獲璩環璦璨癆療癌盪瞳瞪瞰瞬�".split("");
for(j = 0; j != D[192].length; ++j) if(D[192][j].charCodeAt(0) !== 0xFFFD) { e[D[192][j]] = 49152 + j; d[49152 + j] = D[192][j];}
D[193] = "����������������������������������������������������������������瞧瞭矯磷磺磴磯礁禧禪穗窿簇簍篾篷簌篠糠糜糞糢糟糙糝縮績繆縷縲繃縫總縱繅繁縴縹繈縵縿縯罄翳翼聱聲聰聯聳臆臃膺臂臀膿膽臉膾臨舉艱薪����������������������������������薄蕾薜薑薔薯薛薇薨薊虧蟀蟑螳蟒蟆螫螻螺蟈蟋褻褶襄褸褽覬謎謗謙講謊謠謝謄謐豁谿豳賺賽購賸賻趨蹉蹋蹈蹊轄輾轂轅輿避遽還邁邂邀鄹醣醞醜鍍鎂錨鍵鍊鍥鍋錘鍾鍬鍛鍰鍚鍔闊闋闌闈闆隱隸雖霜霞鞠韓顆颶餵騁�".split("");
for(j = 0; j != D[193].length; ++j) if(D[193][j].charCodeAt(0) !== 0xFFFD) { e[D[193][j]] = 49408 + j; d[49408 + j] = D[193][j];}
D[194] = "����������������������������������������������������������������駿鮮鮫鮪鮭鴻鴿麋黏點黜黝黛鼾齋叢嚕嚮壙壘嬸彝懣戳擴擲擾攆擺擻擷斷曜朦檳檬櫃檻檸櫂檮檯歟歸殯瀉瀋濾瀆濺瀑瀏燻燼燾燸獷獵璧璿甕癖癘����������������������������������癒瞽瞿瞻瞼礎禮穡穢穠竄竅簫簧簪簞簣簡糧織繕繞繚繡繒繙罈翹翻職聶臍臏舊藏薩藍藐藉薰薺薹薦蟯蟬蟲蟠覆覲觴謨謹謬謫豐贅蹙蹣蹦蹤蹟蹕軀轉轍邇邃邈醫醬釐鎔鎊鎖鎢鎳鎮鎬鎰鎘鎚鎗闔闖闐闕離雜雙雛雞霤鞣鞦�".split("");
for(j = 0; j != D[194].length; ++j) if(D[194][j].charCodeAt(0) !== 0xFFFD) { e[D[194][j]] = 49664 + j; d[49664 + j] = D[194][j];}
D[195] = "����������������������������������������������������������������鞭韹額顏題顎顓颺餾餿餽餮馥騎髁鬃鬆魏魎魍鯊鯉鯽鯈鯀鵑鵝鵠黠鼕鼬儳嚥壞壟壢寵龐廬懲懷懶懵攀攏曠曝櫥櫝櫚櫓瀛瀟瀨瀚瀝瀕瀘爆爍牘犢獸����������������������������������獺璽瓊瓣疇疆癟癡矇礙禱穫穩簾簿簸簽簷籀繫繭繹繩繪羅繳羶羹羸臘藩藝藪藕藤藥藷蟻蠅蠍蟹蟾襠襟襖襞譁譜識證譚譎譏譆譙贈贊蹼蹲躇蹶蹬蹺蹴轔轎辭邊邋醱醮鏡鏑鏟鏃鏈鏜鏝鏖鏢鏍鏘鏤鏗鏨關隴難霪霧靡韜韻類�".split("");
for(j = 0; j != D[195].length; ++j) if(D[195][j].charCodeAt(0) !== 0xFFFD) { e[D[195][j]] = 49920 + j; d[49920 + j] = D[195][j];}
D[196] = "����������������������������������������������������������������願顛颼饅饉騖騙鬍鯨鯧鯖鯛鶉鵡鵲鵪鵬麒麗麓麴勸嚨嚷嚶嚴嚼壤孀孃孽寶巉懸懺攘攔攙曦朧櫬瀾瀰瀲爐獻瓏癢癥礦礪礬礫竇競籌籃籍糯糰辮繽繼����������������������������������纂罌耀臚艦藻藹蘑藺蘆蘋蘇蘊蠔蠕襤覺觸議譬警譯譟譫贏贍躉躁躅躂醴釋鐘鐃鏽闡霰飄饒饑馨騫騰騷騵鰓鰍鹹麵黨鼯齟齣齡儷儸囁囀囂夔屬巍懼懾攝攜斕曩櫻欄櫺殲灌爛犧瓖瓔癩矓籐纏續羼蘗蘭蘚蠣蠢蠡蠟襪襬覽譴�".split("");
for(j = 0; j != D[196].length; ++j) if(D[196][j].charCodeAt(0) !== 0xFFFD) { e[D[196][j]] = 50176 + j; d[50176 + j] = D[196][j];}
D[197] = "����������������������������������������������������������������護譽贓躊躍躋轟辯醺鐮鐳鐵鐺鐸鐲鐫闢霸霹露響顧顥饗驅驃驀騾髏魔魑鰭鰥鶯鶴鷂鶸麝黯鼙齜齦齧儼儻囈囊囉孿巔巒彎懿攤權歡灑灘玀瓤疊癮癬����������������������������������禳籠籟聾聽臟襲襯觼讀贖贗躑躓轡酈鑄鑑鑒霽霾韃韁顫饕驕驍髒鬚鱉鰱鰾鰻鷓鷗鼴齬齪龔囌巖戀攣攫攪曬欐瓚竊籤籣籥纓纖纔臢蘸蘿蠱變邐邏鑣鑠鑤靨顯饜驚驛驗髓體髑鱔鱗鱖鷥麟黴囑壩攬灞癱癲矗罐羈蠶蠹衢讓讒�".split("");
for(j = 0; j != D[197].length; ++j) if(D[197][j].charCodeAt(0) !== 0xFFFD) { e[D[197][j]] = 50432 + j; d[50432 + j] = D[197][j];}
D[198] = "����������������������������������������������������������������讖艷贛釀鑪靂靈靄韆顰驟鬢魘鱟鷹鷺鹼鹽鼇齷齲廳欖灣籬籮蠻觀躡釁鑲鑰顱饞髖鬣黌灤矚讚鑷韉驢驥纜讜躪釅鑽鑾鑼鱷鱸黷豔鑿鸚爨驪鬱鸛鸞籲���������������������������������������������������������������������������������������������������������������������������������".split("");
for(j = 0; j != D[198].length; ++j) if(D[198][j].charCodeAt(0) !== 0xFFFD) { e[D[198][j]] = 50688 + j; d[50688 + j] = D[198][j];}
D[201] = "����������������������������������������������������������������乂乜凵匚厂万丌乇亍囗兀屮彳丏冇与丮亓仂仉仈冘勼卬厹圠夃夬尐巿旡殳毌气爿丱丼仨仜仩仡仝仚刌匜卌圢圣夗夯宁宄尒尻屴屳帄庀庂忉戉扐氕����������������������������������氶汃氿氻犮犰玊禸肊阞伎优伬仵伔仱伀价伈伝伂伅伢伓伄仴伒冱刓刉刐劦匢匟卍厊吇囡囟圮圪圴夼妀奼妅奻奾奷奿孖尕尥屼屺屻屾巟幵庄异弚彴忕忔忏扜扞扤扡扦扢扙扠扚扥旯旮朾朹朸朻机朿朼朳氘汆汒汜汏汊汔汋�".split("");
for(j = 0; j != D[201].length; ++j) if(D[201][j].charCodeAt(0) !== 0xFFFD) { e[D[201][j]] = 51456 + j; d[51456 + j] = D[201][j];}
D[202] = "����������������������������������������������������������������汌灱牞犴犵玎甪癿穵网艸艼芀艽艿虍襾邙邗邘邛邔阢阤阠阣佖伻佢佉体佤伾佧佒佟佁佘伭伳伿佡冏冹刜刞刡劭劮匉卣卲厎厏吰吷吪呔呅吙吜吥吘����������������������������������吽呏呁吨吤呇囮囧囥坁坅坌坉坋坒夆奀妦妘妠妗妎妢妐妏妧妡宎宒尨尪岍岏岈岋岉岒岊岆岓岕巠帊帎庋庉庌庈庍弅弝彸彶忒忑忐忭忨忮忳忡忤忣忺忯忷忻怀忴戺抃抌抎抏抔抇扱扻扺扰抁抈扷扽扲扴攷旰旴旳旲旵杅杇�".split("");
for(j = 0; j != D[202].length; ++j) if(D[202][j].charCodeAt(0) !== 0xFFFD) { e[D[202][j]] = 51712 + j; d[51712 + j] = D[202][j];}
D[203] = "����������������������������������������������������������������杙杕杌杈杝杍杚杋毐氙氚汸汧汫沄沋沏汱汯汩沚汭沇沕沜汦汳汥汻沎灴灺牣犿犽狃狆狁犺狅玕玗玓玔玒町甹疔疕皁礽耴肕肙肐肒肜芐芏芅芎芑芓����������������������������������芊芃芄豸迉辿邟邡邥邞邧邠阰阨阯阭丳侘佼侅佽侀侇佶佴侉侄佷佌侗佪侚佹侁佸侐侜侔侞侒侂侕佫佮冞冼冾刵刲刳剆刱劼匊匋匼厒厔咇呿咁咑咂咈呫呺呾呥呬呴呦咍呯呡呠咘呣呧呤囷囹坯坲坭坫坱坰坶垀坵坻坳坴坢�".split("");
for(j = 0; j != D[203].length; ++j) if(D[203][j].charCodeAt(0) !== 0xFFFD) { e[D[203][j]] = 51968 + j; d[51968 + j] = D[203][j];}
D[204] = "����������������������������������������������������������������坨坽夌奅妵妺姏姎妲姌姁妶妼姃姖妱妽姀姈妴姇孢孥宓宕屄屇岮岤岠岵岯岨岬岟岣岭岢岪岧岝岥岶岰岦帗帔帙弨弢弣弤彔徂彾彽忞忥怭怦怙怲怋����������������������������������怴怊怗怳怚怞怬怢怍怐怮怓怑怌怉怜戔戽抭抴拑抾抪抶拊抮抳抯抻抩抰抸攽斨斻昉旼昄昒昈旻昃昋昍昅旽昑昐曶朊枅杬枎枒杶杻枘枆构杴枍枌杺枟枑枙枃杽极杸杹枔欥殀歾毞氝沓泬泫泮泙沶泔沭泧沷泐泂沺泃泆泭泲�".split("");
for(j = 0; j != D[204].length; ++j) if(D[204][j].charCodeAt(0) !== 0xFFFD) { e[D[204][j]] = 52224 + j; d[52224 + j] = D[204][j];}
D[205] = "����������������������������������������������������������������泒泝沴沊沝沀泞泀洰泍泇沰泹泏泩泑炔炘炅炓炆炄炑炖炂炚炃牪狖狋狘狉狜狒狔狚狌狑玤玡玭玦玢玠玬玝瓝瓨甿畀甾疌疘皯盳盱盰盵矸矼矹矻矺����������������������������������矷祂礿秅穸穻竻籵糽耵肏肮肣肸肵肭舠芠苀芫芚芘芛芵芧芮芼芞芺芴芨芡芩苂芤苃芶芢虰虯虭虮豖迒迋迓迍迖迕迗邲邴邯邳邰阹阽阼阺陃俍俅俓侲俉俋俁俔俜俙侻侳俛俇俖侺俀侹俬剄剉勀勂匽卼厗厖厙厘咺咡咭咥哏�".split("");
for(j = 0; j != D[205].length; ++j) if(D[205][j].charCodeAt(0) !== 0xFFFD) { e[D[205][j]] = 52480 + j; d[52480 + j] = D[205][j];}
D[206] = "����������������������������������������������������������������哃茍咷咮哖咶哅哆咠呰咼咢咾呲哞咰垵垞垟垤垌垗垝垛垔垘垏垙垥垚垕壴复奓姡姞姮娀姱姝姺姽姼姶姤姲姷姛姩姳姵姠姾姴姭宨屌峐峘峌峗峋峛����������������������������������峞峚峉峇峊峖峓峔峏峈峆峎峟峸巹帡帢帣帠帤庰庤庢庛庣庥弇弮彖徆怷怹恔恲恞恅恓恇恉恛恌恀恂恟怤恄恘恦恮扂扃拏挍挋拵挎挃拫拹挏挌拸拶挀挓挔拺挕拻拰敁敃斪斿昶昡昲昵昜昦昢昳昫昺昝昴昹昮朏朐柁柲柈枺�".split("");
for(j = 0; j != D[206].length; ++j) if(D[206][j].charCodeAt(0) !== 0xFFFD) { e[D[206][j]] = 52736 + j; d[52736 + j] = D[206][j];}
D[207] = "����������������������������������������������������������������柜枻柸柘柀枷柅柫柤柟枵柍枳柷柶柮柣柂枹柎柧柰枲柼柆柭柌枮柦柛柺柉柊柃柪柋欨殂殄殶毖毘毠氠氡洨洴洭洟洼洿洒洊泚洳洄洙洺洚洑洀洝浂����������������������������������洁洘洷洃洏浀洇洠洬洈洢洉洐炷炟炾炱炰炡炴炵炩牁牉牊牬牰牳牮狊狤狨狫狟狪狦狣玅珌珂珈珅玹玶玵玴珫玿珇玾珃珆玸珋瓬瓮甮畇畈疧疪癹盄眈眃眄眅眊盷盻盺矧矨砆砑砒砅砐砏砎砉砃砓祊祌祋祅祄秕种秏秖秎窀�".split("");
for(j = 0; j != D[207].length; ++j) if(D[207][j].charCodeAt(0) !== 0xFFFD) { e[D[207][j]] = 52992 + j; d[52992 + j] = D[207][j];}
D[208] = "����������������������������������������������������������������穾竑笀笁籺籸籹籿粀粁紃紈紁罘羑羍羾耇耎耏耔耷胘胇胠胑胈胂胐胅胣胙胜胊胕胉胏胗胦胍臿舡芔苙苾苹茇苨茀苕茺苫苖苴苬苡苲苵茌苻苶苰苪����������������������������������苤苠苺苳苭虷虴虼虳衁衎衧衪衩觓訄訇赲迣迡迮迠郱邽邿郕郅邾郇郋郈釔釓陔陏陑陓陊陎倞倅倇倓倢倰倛俵俴倳倷倬俶俷倗倜倠倧倵倯倱倎党冔冓凊凄凅凈凎剡剚剒剞剟剕剢勍匎厞唦哢唗唒哧哳哤唚哿唄唈哫唑唅哱�".split("");
for(j = 0; j != D[208].length; ++j) if(D[208][j].charCodeAt(0) !== 0xFFFD) { e[D[208][j]] = 53248 + j; d[53248 + j] = D[208][j];}
D[209] = "����������������������������������������������������������������唊哻哷哸哠唎唃唋圁圂埌堲埕埒垺埆垽垼垸垶垿埇埐垹埁夎奊娙娖娭娮娕娏娗娊娞娳孬宧宭宬尃屖屔峬峿峮峱峷崀峹帩帨庨庮庪庬弳弰彧恝恚恧����������������������������������恁悢悈悀悒悁悝悃悕悛悗悇悜悎戙扆拲挐捖挬捄捅挶捃揤挹捋捊挼挩捁挴捘捔捙挭捇挳捚捑挸捗捀捈敊敆旆旃旄旂晊晟晇晑朒朓栟栚桉栲栳栻桋桏栖栱栜栵栫栭栯桎桄栴栝栒栔栦栨栮桍栺栥栠欬欯欭欱欴歭肂殈毦毤�".split("");
for(j = 0; j != D[209].length; ++j) if(D[209][j].charCodeAt(0) !== 0xFFFD) { e[D[209][j]] = 53504 + j; d[53504 + j] = D[209][j];}
D[210] = "����������������������������������������������������������������毨毣毢毧氥浺浣浤浶洍浡涒浘浢浭浯涑涍淯浿涆浞浧浠涗浰浼浟涂涘洯浨涋浾涀涄洖涃浻浽浵涐烜烓烑烝烋缹烢烗烒烞烠烔烍烅烆烇烚烎烡牂牸����������������������������������牷牶猀狺狴狾狶狳狻猁珓珙珥珖玼珧珣珩珜珒珛珔珝珚珗珘珨瓞瓟瓴瓵甡畛畟疰痁疻痄痀疿疶疺皊盉眝眛眐眓眒眣眑眕眙眚眢眧砣砬砢砵砯砨砮砫砡砩砳砪砱祔祛祏祜祓祒祑秫秬秠秮秭秪秜秞秝窆窉窅窋窌窊窇竘笐�".split("");
for(j = 0; j != D[210].length; ++j) if(D[210][j].charCodeAt(0) !== 0xFFFD) { e[D[210][j]] = 53760 + j; d[53760 + j] = D[210][j];}
D[211] = "����������������������������������������������������������������笄笓笅笏笈笊笎笉笒粄粑粊粌粈粍粅紞紝紑紎紘紖紓紟紒紏紌罜罡罞罠罝罛羖羒翃翂翀耖耾耹胺胲胹胵脁胻脀舁舯舥茳茭荄茙荑茥荖茿荁茦茜茢����������������������������������荂荎茛茪茈茼荍茖茤茠茷茯茩荇荅荌荓茞茬荋茧荈虓虒蚢蚨蚖蚍蚑蚞蚇蚗蚆蚋蚚蚅蚥蚙蚡蚧蚕蚘蚎蚝蚐蚔衃衄衭衵衶衲袀衱衿衯袃衾衴衼訒豇豗豻貤貣赶赸趵趷趶軑軓迾迵适迿迻逄迼迶郖郠郙郚郣郟郥郘郛郗郜郤酐�".split("");
for(j = 0; j != D[211].length; ++j) if(D[211][j].charCodeAt(0) !== 0xFFFD) { e[D[211][j]] = 54016 + j; d[54016 + j] = D[211][j];}
D[212] = "����������������������������������������������������������������酎酏釕釢釚陜陟隼飣髟鬯乿偰偪偡偞偠偓偋偝偲偈偍偁偛偊偢倕偅偟偩偫偣偤偆偀偮偳偗偑凐剫剭剬剮勖勓匭厜啵啶唼啍啐唴唪啑啢唶唵唰啒啅����������������������������������唌唲啥啎唹啈唭唻啀啋圊圇埻堔埢埶埜埴堀埭埽堈埸堋埳埏堇埮埣埲埥埬埡堎埼堐埧堁堌埱埩埰堍堄奜婠婘婕婧婞娸娵婭婐婟婥婬婓婤婗婃婝婒婄婛婈媎娾婍娹婌婰婩婇婑婖婂婜孲孮寁寀屙崞崋崝崚崠崌崨崍崦崥崏�".split("");
for(j = 0; j != D[212].length; ++j) if(D[212][j].charCodeAt(0) !== 0xFFFD) { e[D[212][j]] = 54272 + j; d[54272 + j] = D[212][j];}
D[213] = "����������������������������������������������������������������崰崒崣崟崮帾帴庱庴庹庲庳弶弸徛徖徟悊悐悆悾悰悺惓惔惏惤惙惝惈悱惛悷惊悿惃惍惀挲捥掊掂捽掽掞掭掝掗掫掎捯掇掐据掯捵掜捭掮捼掤挻掟����������������������������������捸掅掁掑掍捰敓旍晥晡晛晙晜晢朘桹梇梐梜桭桮梮梫楖桯梣梬梩桵桴梲梏桷梒桼桫桲梪梀桱桾梛梖梋梠梉梤桸桻梑梌梊桽欶欳欷欸殑殏殍殎殌氪淀涫涴涳湴涬淩淢涷淶淔渀淈淠淟淖涾淥淜淝淛淴淊涽淭淰涺淕淂淏淉�".split("");
for(j = 0; j != D[213].length; ++j) if(D[213][j].charCodeAt(0) !== 0xFFFD) { e[D[213][j]] = 54528 + j; d[54528 + j] = D[213][j];}
D[214] = "����������������������������������������������������������������淐淲淓淽淗淍淣涻烺焍烷焗烴焌烰焄烳焐烼烿焆焓焀烸烶焋焂焎牾牻牼牿猝猗猇猑猘猊猈狿猏猞玈珶珸珵琄琁珽琇琀珺珼珿琌琋珴琈畤畣痎痒痏����������������������������������痋痌痑痐皏皉盓眹眯眭眱眲眴眳眽眥眻眵硈硒硉硍硊硌砦硅硐祤祧祩祪祣祫祡离秺秸秶秷窏窔窐笵筇笴笥笰笢笤笳笘笪笝笱笫笭笯笲笸笚笣粔粘粖粣紵紽紸紶紺絅紬紩絁絇紾紿絊紻紨罣羕羜羝羛翊翋翍翐翑翇翏翉耟�".split("");
for(j = 0; j != D[214].length; ++j) if(D[214][j].charCodeAt(0) !== 0xFFFD) { e[D[214][j]] = 54784 + j; d[54784 + j] = D[214][j];}
D[215] = "����������������������������������������������������������������耞耛聇聃聈脘脥脙脛脭脟脬脞脡脕脧脝脢舑舸舳舺舴舲艴莐莣莨莍荺荳莤荴莏莁莕莙荵莔莩荽莃莌莝莛莪莋荾莥莯莈莗莰荿莦莇莮荶莚虙虖蚿蚷����������������������������������蛂蛁蛅蚺蚰蛈蚹蚳蚸蛌蚴蚻蚼蛃蚽蚾衒袉袕袨袢袪袚袑袡袟袘袧袙袛袗袤袬袌袓袎覂觖觙觕訰訧訬訞谹谻豜豝豽貥赽赻赹趼跂趹趿跁軘軞軝軜軗軠軡逤逋逑逜逌逡郯郪郰郴郲郳郔郫郬郩酖酘酚酓酕釬釴釱釳釸釤釹釪�".split("");
for(j = 0; j != D[215].length; ++j) if(D[215][j].charCodeAt(0) !== 0xFFFD) { e[D[215][j]] = 55040 + j; d[55040 + j] = D[215][j];}
D[216] = "����������������������������������������������������������������釫釷釨釮镺閆閈陼陭陫陱陯隿靪頄飥馗傛傕傔傞傋傣傃傌傎傝偨傜傒傂傇兟凔匒匑厤厧喑喨喥喭啷噅喢喓喈喏喵喁喣喒喤啽喌喦啿喕喡喎圌堩堷����������������������������������堙堞堧堣堨埵塈堥堜堛堳堿堶堮堹堸堭堬堻奡媯媔媟婺媢媞婸媦婼媥媬媕媮娷媄媊媗媃媋媩婻婽媌媜媏媓媝寪寍寋寔寑寊寎尌尰崷嵃嵫嵁嵋崿崵嵑嵎嵕崳崺嵒崽崱嵙嵂崹嵉崸崼崲崶嵀嵅幄幁彘徦徥徫惉悹惌惢惎惄愔�".split("");
for(j = 0; j != D[216].length; ++j) if(D[216][j].charCodeAt(0) !== 0xFFFD) { e[D[216][j]] = 55296 + j; d[55296 + j] = D[216][j];}
D[217] = "����������������������������������������������������������������惲愊愖愅惵愓惸惼惾惁愃愘愝愐惿愄愋扊掔掱掰揎揥揨揯揃撝揳揊揠揶揕揲揵摡揟掾揝揜揄揘揓揂揇揌揋揈揰揗揙攲敧敪敤敜敨敥斌斝斞斮旐旒����������������������������������晼晬晻暀晱晹晪晲朁椌棓椄棜椪棬棪棱椏棖棷棫棤棶椓椐棳棡椇棌椈楰梴椑棯棆椔棸棐棽棼棨椋椊椗棎棈棝棞棦棴棑椆棔棩椕椥棇欹欻欿欼殔殗殙殕殽毰毲毳氰淼湆湇渟湉溈渼渽湅湢渫渿湁湝湳渜渳湋湀湑渻渃渮湞�".split("");
for(j = 0; j != D[217].length; ++j) if(D[217][j].charCodeAt(0) !== 0xFFFD) { e[D[217][j]] = 55552 + j; d[55552 + j] = D[217][j];}
D[218] = "����������������������������������������������������������������湨湜湡渱渨湠湱湫渹渢渰湓湥渧湸湤湷湕湹湒湦渵渶湚焠焞焯烻焮焱焣焥焢焲焟焨焺焛牋牚犈犉犆犅犋猒猋猰猢猱猳猧猲猭猦猣猵猌琮琬琰琫琖����������������������������������琚琡琭琱琤琣琝琩琠琲瓻甯畯畬痧痚痡痦痝痟痤痗皕皒盚睆睇睄睍睅睊睎睋睌矞矬硠硤硥硜硭硱硪确硰硩硨硞硢祴祳祲祰稂稊稃稌稄窙竦竤筊笻筄筈筌筎筀筘筅粢粞粨粡絘絯絣絓絖絧絪絏絭絜絫絒絔絩絑絟絎缾缿罥�".split("");
for(j = 0; j != D[218].length; ++j) if(D[218][j].charCodeAt(0) !== 0xFFFD) { e[D[218][j]] = 55808 + j; d[55808 + j] = D[218][j];}
D[219] = "����������������������������������������������������������������罦羢羠羡翗聑聏聐胾胔腃腊腒腏腇脽腍脺臦臮臷臸臹舄舼舽舿艵茻菏菹萣菀菨萒菧菤菼菶萐菆菈菫菣莿萁菝菥菘菿菡菋菎菖菵菉萉萏菞萑萆菂菳����������������������������������菕菺菇菑菪萓菃菬菮菄菻菗菢萛菛菾蛘蛢蛦蛓蛣蛚蛪蛝蛫蛜蛬蛩蛗蛨蛑衈衖衕袺裗袹袸裀袾袶袼袷袽袲褁裉覕覘覗觝觚觛詎詍訹詙詀詗詘詄詅詒詈詑詊詌詏豟貁貀貺貾貰貹貵趄趀趉跘跓跍跇跖跜跏跕跙跈跗跅軯軷軺�".split("");
for(j = 0; j != D[219].length; ++j) if(D[219][j].charCodeAt(0) !== 0xFFFD) { e[D[219][j]] = 56064 + j; d[56064 + j] = D[219][j];}
D[220] = "����������������������������������������������������������������軹軦軮軥軵軧軨軶軫軱軬軴軩逭逴逯鄆鄬鄄郿郼鄈郹郻鄁鄀鄇鄅鄃酡酤酟酢酠鈁鈊鈥鈃鈚鈦鈏鈌鈀鈒釿釽鈆鈄鈧鈂鈜鈤鈙鈗鈅鈖镻閍閌閐隇陾隈����������������������������������隉隃隀雂雈雃雱雰靬靰靮頇颩飫鳦黹亃亄亶傽傿僆傮僄僊傴僈僂傰僁傺傱僋僉傶傸凗剺剸剻剼嗃嗛嗌嗐嗋嗊嗝嗀嗔嗄嗩喿嗒喍嗏嗕嗢嗖嗈嗲嗍嗙嗂圔塓塨塤塏塍塉塯塕塎塝塙塥塛堽塣塱壼嫇嫄嫋媺媸媱媵媰媿嫈媻嫆�".split("");
for(j = 0; j != D[220].length; ++j) if(D[220][j].charCodeAt(0) !== 0xFFFD) { e[D[220][j]] = 56320 + j; d[56320 + j] = D[220][j];}
D[221] = "����������������������������������������������������������������媷嫀嫊媴媶嫍媹媐寖寘寙尟尳嵱嵣嵊嵥嵲嵬嵞嵨嵧嵢巰幏幎幊幍幋廅廌廆廋廇彀徯徭惷慉慊愫慅愶愲愮慆愯慏愩慀戠酨戣戥戤揅揱揫搐搒搉搠搤����������������������������������搳摃搟搕搘搹搷搢搣搌搦搰搨摁搵搯搊搚摀搥搧搋揧搛搮搡搎敯斒旓暆暌暕暐暋暊暙暔晸朠楦楟椸楎楢楱椿楅楪椹楂楗楙楺楈楉椵楬椳椽楥棰楸椴楩楀楯楄楶楘楁楴楌椻楋椷楜楏楑椲楒椯楻椼歆歅歃歂歈歁殛嗀毻毼�".split("");
for(j = 0; j != D[221].length; ++j) if(D[221][j].charCodeAt(0) !== 0xFFFD) { e[D[221][j]] = 56576 + j; d[56576 + j] = D[221][j];}
D[222] = "����������������������������������������������������������������毹毷毸溛滖滈溏滀溟溓溔溠溱溹滆滒溽滁溞滉溷溰滍溦滏溲溾滃滜滘溙溒溎溍溤溡溿溳滐滊溗溮溣煇煔煒煣煠煁煝煢煲煸煪煡煂煘煃煋煰煟煐煓����������������������������������煄煍煚牏犍犌犑犐犎猼獂猻猺獀獊獉瑄瑊瑋瑒瑑瑗瑀瑏瑐瑎瑂瑆瑍瑔瓡瓿瓾瓽甝畹畷榃痯瘏瘃痷痾痼痹痸瘐痻痶痭痵痽皙皵盝睕睟睠睒睖睚睩睧睔睙睭矠碇碚碔碏碄碕碅碆碡碃硹碙碀碖硻祼禂祽祹稑稘稙稒稗稕稢稓�".split("");
for(j = 0; j != D[222].length; ++j) if(D[222][j].charCodeAt(0) !== 0xFFFD) { e[D[222][j]] = 56832 + j; d[56832 + j] = D[222][j];}
D[223] = "����������������������������������������������������������������稛稐窣窢窞竫筦筤筭筴筩筲筥筳筱筰筡筸筶筣粲粴粯綈綆綀綍絿綅絺綎絻綃絼綌綔綄絽綒罭罫罧罨罬羦羥羧翛翜耡腤腠腷腜腩腛腢腲朡腞腶腧腯����������������������������������腄腡舝艉艄艀艂艅蓱萿葖葶葹蒏蒍葥葑葀蒆葧萰葍葽葚葙葴葳葝蔇葞萷萺萴葺葃葸萲葅萩菙葋萯葂萭葟葰萹葎葌葒葯蓅蒎萻葇萶萳葨葾葄萫葠葔葮葐蜋蜄蛷蜌蛺蛖蛵蝍蛸蜎蜉蜁蛶蜍蜅裖裋裍裎裞裛裚裌裐覅覛觟觥觤�".split("");
for(j = 0; j != D[223].length; ++j) if(D[223][j].charCodeAt(0) !== 0xFFFD) { e[D[223][j]] = 57088 + j; d[57088 + j] = D[223][j];}
D[224] = "����������������������������������������������������������������觡觠觢觜触詶誆詿詡訿詷誂誄詵誃誁詴詺谼豋豊豥豤豦貆貄貅賌赨赩趑趌趎趏趍趓趔趐趒跰跠跬跱跮跐跩跣跢跧跲跫跴輆軿輁輀輅輇輈輂輋遒逿����������������������������������遄遉逽鄐鄍鄏鄑鄖鄔鄋鄎酮酯鉈鉒鈰鈺鉦鈳鉥鉞銃鈮鉊鉆鉭鉬鉏鉠鉧鉯鈶鉡鉰鈱鉔鉣鉐鉲鉎鉓鉌鉖鈲閟閜閞閛隒隓隑隗雎雺雽雸雵靳靷靸靲頏頍頎颬飶飹馯馲馰馵骭骫魛鳪鳭鳧麀黽僦僔僗僨僳僛僪僝僤僓僬僰僯僣僠�".split("");
for(j = 0; j != D[224].length; ++j) if(D[224][j].charCodeAt(0) !== 0xFFFD) { e[D[224][j]] = 57344 + j; d[57344 + j] = D[224][j];}
D[225] = "����������������������������������������������������������������凘劀劁勩勫匰厬嘧嘕嘌嘒嗼嘏嘜嘁嘓嘂嗺嘝嘄嗿嗹墉塼墐墘墆墁塿塴墋塺墇墑墎塶墂墈塻墔墏壾奫嫜嫮嫥嫕嫪嫚嫭嫫嫳嫢嫠嫛嫬嫞嫝嫙嫨嫟孷寠����������������������������������寣屣嶂嶀嵽嶆嵺嶁嵷嶊嶉嶈嵾嵼嶍嵹嵿幘幙幓廘廑廗廎廜廕廙廒廔彄彃彯徶愬愨慁慞慱慳慒慓慲慬憀慴慔慺慛慥愻慪慡慖戩戧戫搫摍摛摝摴摶摲摳摽摵摦撦摎撂摞摜摋摓摠摐摿搿摬摫摙摥摷敳斠暡暠暟朅朄朢榱榶槉�".split("");
for(j = 0; j != D[225].length; ++j) if(D[225][j].charCodeAt(0) !== 0xFFFD) { e[D[225][j]] = 57600 + j; d[57600 + j] = D[225][j];}
D[226] = "����������������������������������������������������������������榠槎榖榰榬榼榑榙榎榧榍榩榾榯榿槄榽榤槔榹槊榚槏榳榓榪榡榞槙榗榐槂榵榥槆歊歍歋殞殟殠毃毄毾滎滵滱漃漥滸漷滻漮漉潎漙漚漧漘漻漒滭漊����������������������������������漶潳滹滮漭潀漰漼漵滫漇漎潃漅滽滶漹漜滼漺漟漍漞漈漡熇熐熉熀熅熂熏煻熆熁熗牄牓犗犕犓獃獍獑獌瑢瑳瑱瑵瑲瑧瑮甀甂甃畽疐瘖瘈瘌瘕瘑瘊瘔皸瞁睼瞅瞂睮瞀睯睾瞃碲碪碴碭碨硾碫碞碥碠碬碢碤禘禊禋禖禕禔禓�".split("");
for(j = 0; j != D[226].length; ++j) if(D[226][j].charCodeAt(0) !== 0xFFFD) { e[D[226][j]] = 57856 + j; d[57856 + j] = D[226][j];}
D[227] = "����������������������������������������������������������������禗禈禒禐稫穊稰稯稨稦窨窫窬竮箈箜箊箑箐箖箍箌箛箎箅箘劄箙箤箂粻粿粼粺綧綷緂綣綪緁緀緅綝緎緄緆緋緌綯綹綖綼綟綦綮綩綡緉罳翢翣翥翞����������������������������������耤聝聜膉膆膃膇膍膌膋舕蒗蒤蒡蒟蒺蓎蓂蒬蒮蒫蒹蒴蓁蓍蒪蒚蒱蓐蒝蒧蒻蒢蒔蓇蓌蒛蒩蒯蒨蓖蒘蒶蓏蒠蓗蓔蓒蓛蒰蒑虡蜳蜣蜨蝫蝀蜮蜞蜡蜙蜛蝃蜬蝁蜾蝆蜠蜲蜪蜭蜼蜒蜺蜱蜵蝂蜦蜧蜸蜤蜚蜰蜑裷裧裱裲裺裾裮裼裶裻�".split("");
for(j = 0; j != D[227].length; ++j) if(D[227][j].charCodeAt(0) !== 0xFFFD) { e[D[227][j]] = 58112 + j; d[58112 + j] = D[227][j];}
D[228] = "����������������������������������������������������������������裰裬裫覝覡覟覞觩觫觨誫誙誋誒誏誖谽豨豩賕賏賗趖踉踂跿踍跽踊踃踇踆踅跾踀踄輐輑輎輍鄣鄜鄠鄢鄟鄝鄚鄤鄡鄛酺酲酹酳銥銤鉶銛鉺銠銔銪銍����������������������������������銦銚銫鉹銗鉿銣鋮銎銂銕銢鉽銈銡銊銆銌銙銧鉾銇銩銝銋鈭隞隡雿靘靽靺靾鞃鞀鞂靻鞄鞁靿韎韍頖颭颮餂餀餇馝馜駃馹馻馺駂馽駇骱髣髧鬾鬿魠魡魟鳱鳲鳵麧僿儃儰僸儆儇僶僾儋儌僽儊劋劌勱勯噈噂噌嘵噁噊噉噆噘�".split("");
for(j = 0; j != D[228].length; ++j) if(D[228][j].charCodeAt(0) !== 0xFFFD) { e[D[228][j]] = 58368 + j; d[58368 + j] = D[228][j];}
D[229] = "����������������������������������������������������������������噚噀嘳嘽嘬嘾嘸嘪嘺圚墫墝墱墠墣墯墬墥墡壿嫿嫴嫽嫷嫶嬃嫸嬂嫹嬁嬇嬅嬏屧嶙嶗嶟嶒嶢嶓嶕嶠嶜嶡嶚嶞幩幝幠幜緳廛廞廡彉徲憋憃慹憱憰憢憉����������������������������������憛憓憯憭憟憒憪憡憍慦憳戭摮摰撖撠撅撗撜撏撋撊撌撣撟摨撱撘敶敺敹敻斲斳暵暰暩暲暷暪暯樀樆樗槥槸樕槱槤樠槿槬槢樛樝槾樧槲槮樔槷槧橀樈槦槻樍槼槫樉樄樘樥樏槶樦樇槴樖歑殥殣殢殦氁氀毿氂潁漦潾澇濆澒�".split("");
for(j = 0; j != D[229].length; ++j) if(D[229][j].charCodeAt(0) !== 0xFFFD) { e[D[229][j]] = 58624 + j; d[58624 + j] = D[229][j];}
D[230] = "����������������������������������������������������������������澍澉澌潢潏澅潚澖潶潬澂潕潲潒潐潗澔澓潝漀潡潫潽潧澐潓澋潩潿澕潣潷潪潻熲熯熛熰熠熚熩熵熝熥熞熤熡熪熜熧熳犘犚獘獒獞獟獠獝獛獡獚獙����������������������������������獢璇璉璊璆璁瑽璅璈瑼瑹甈甇畾瘥瘞瘙瘝瘜瘣瘚瘨瘛皜皝皞皛瞍瞏瞉瞈磍碻磏磌磑磎磔磈磃磄磉禚禡禠禜禢禛歶稹窲窴窳箷篋箾箬篎箯箹篊箵糅糈糌糋緷緛緪緧緗緡縃緺緦緶緱緰緮緟罶羬羰羭翭翫翪翬翦翨聤聧膣膟�".split("");
for(j = 0; j != D[230].length; ++j) if(D[230][j].charCodeAt(0) !== 0xFFFD) { e[D[230][j]] = 58880 + j; d[58880 + j] = D[230][j];}
D[231] = "����������������������������������������������������������������膞膕膢膙膗舖艏艓艒艐艎艑蔤蔻蔏蔀蔩蔎蔉蔍蔟蔊蔧蔜蓻蔫蓺蔈蔌蓴蔪蓲蔕蓷蓫蓳蓼蔒蓪蓩蔖蓾蔨蔝蔮蔂蓽蔞蓶蔱蔦蓧蓨蓰蓯蓹蔘蔠蔰蔋蔙蔯虢����������������������������������蝖蝣蝤蝷蟡蝳蝘蝔蝛蝒蝡蝚蝑蝞蝭蝪蝐蝎蝟蝝蝯蝬蝺蝮蝜蝥蝏蝻蝵蝢蝧蝩衚褅褌褔褋褗褘褙褆褖褑褎褉覢覤覣觭觰觬諏諆誸諓諑諔諕誻諗誾諀諅諘諃誺誽諙谾豍貏賥賟賙賨賚賝賧趠趜趡趛踠踣踥踤踮踕踛踖踑踙踦踧�".split("");
for(j = 0; j != D[231].length; ++j) if(D[231][j].charCodeAt(0) !== 0xFFFD) { e[D[231][j]] = 59136 + j; d[59136 + j] = D[231][j];}
D[232] = "����������������������������������������������������������������踔踒踘踓踜踗踚輬輤輘輚輠輣輖輗遳遰遯遧遫鄯鄫鄩鄪鄲鄦鄮醅醆醊醁醂醄醀鋐鋃鋄鋀鋙銶鋏鋱鋟鋘鋩鋗鋝鋌鋯鋂鋨鋊鋈鋎鋦鋍鋕鋉鋠鋞鋧鋑鋓����������������������������������銵鋡鋆銴镼閬閫閮閰隤隢雓霅霈霂靚鞊鞎鞈韐韏頞頝頦頩頨頠頛頧颲餈飺餑餔餖餗餕駜駍駏駓駔駎駉駖駘駋駗駌骳髬髫髳髲髱魆魃魧魴魱魦魶魵魰魨魤魬鳼鳺鳽鳿鳷鴇鴀鳹鳻鴈鴅鴄麃黓鼏鼐儜儓儗儚儑凞匴叡噰噠噮�".split("");
for(j = 0; j != D[232].length; ++j) if(D[232][j].charCodeAt(0) !== 0xFFFD) { e[D[232][j]] = 59392 + j; d[59392 + j] = D[232][j];}
D[233] = "����������������������������������������������������������������噳噦噣噭噲噞噷圜圛壈墽壉墿墺壂墼壆嬗嬙嬛嬡嬔嬓嬐嬖嬨嬚嬠嬞寯嶬嶱嶩嶧嶵嶰嶮嶪嶨嶲嶭嶯嶴幧幨幦幯廩廧廦廨廥彋徼憝憨憖懅憴懆懁懌憺����������������������������������憿憸憌擗擖擐擏擉撽撉擃擛擳擙攳敿敼斢曈暾曀曊曋曏暽暻暺曌朣樴橦橉橧樲橨樾橝橭橶橛橑樨橚樻樿橁橪橤橐橏橔橯橩橠樼橞橖橕橍橎橆歕歔歖殧殪殫毈毇氄氃氆澭濋澣濇澼濎濈潞濄澽澞濊澨瀄澥澮澺澬澪濏澿澸�".split("");
for(j = 0; j != D[233].length; ++j) if(D[233][j].charCodeAt(0) !== 0xFFFD) { e[D[233][j]] = 59648 + j; d[59648 + j] = D[233][j];}
D[234] = "����������������������������������������������������������������澢濉澫濍澯澲澰燅燂熿熸燖燀燁燋燔燊燇燏熽燘熼燆燚燛犝犞獩獦獧獬獥獫獪瑿璚璠璔璒璕璡甋疀瘯瘭瘱瘽瘳瘼瘵瘲瘰皻盦瞚瞝瞡瞜瞛瞢瞣瞕瞙����������������������������������瞗磝磩磥磪磞磣磛磡磢磭磟磠禤穄穈穇窶窸窵窱窷篞篣篧篝篕篥篚篨篹篔篪篢篜篫篘篟糒糔糗糐糑縒縡縗縌縟縠縓縎縜縕縚縢縋縏縖縍縔縥縤罃罻罼罺羱翯耪耩聬膱膦膮膹膵膫膰膬膴膲膷膧臲艕艖艗蕖蕅蕫蕍蕓蕡蕘�".split("");
for(j = 0; j != D[234].length; ++j) if(D[234][j].charCodeAt(0) !== 0xFFFD) { e[D[234][j]] = 59904 + j; d[59904 + j] = D[234][j];}
D[235] = "����������������������������������������������������������������蕀蕆蕤蕁蕢蕄蕑蕇蕣蔾蕛蕱蕎蕮蕵蕕蕧蕠薌蕦蕝蕔蕥蕬虣虥虤螛螏螗螓螒螈螁螖螘蝹螇螣螅螐螑螝螄螔螜螚螉褞褦褰褭褮褧褱褢褩褣褯褬褟觱諠����������������������������������諢諲諴諵諝謔諤諟諰諈諞諡諨諿諯諻貑貒貐賵賮賱賰賳赬赮趥趧踳踾踸蹀蹅踶踼踽蹁踰踿躽輶輮輵輲輹輷輴遶遹遻邆郺鄳鄵鄶醓醐醑醍醏錧錞錈錟錆錏鍺錸錼錛錣錒錁鍆錭錎錍鋋錝鋺錥錓鋹鋷錴錂錤鋿錩錹錵錪錔錌�".split("");
for(j = 0; j != D[235].length; ++j) if(D[235][j].charCodeAt(0) !== 0xFFFD) { e[D[235][j]] = 60160 + j; d[60160 + j] = D[235][j];}
D[236] = "����������������������������������������������������������������錋鋾錉錀鋻錖閼闍閾閹閺閶閿閵閽隩雔霋霒霐鞙鞗鞔韰韸頵頯頲餤餟餧餩馞駮駬駥駤駰駣駪駩駧骹骿骴骻髶髺髹髷鬳鮀鮅鮇魼魾魻鮂鮓鮒鮐魺鮕����������������������������������魽鮈鴥鴗鴠鴞鴔鴩鴝鴘鴢鴐鴙鴟麈麆麇麮麭黕黖黺鼒鼽儦儥儢儤儠儩勴嚓嚌嚍嚆嚄嚃噾嚂噿嚁壖壔壏壒嬭嬥嬲嬣嬬嬧嬦嬯嬮孻寱寲嶷幬幪徾徻懃憵憼懧懠懥懤懨懞擯擩擣擫擤擨斁斀斶旚曒檍檖檁檥檉檟檛檡檞檇檓檎�".split("");
for(j = 0; j != D[236].length; ++j) if(D[236][j].charCodeAt(0) !== 0xFFFD) { e[D[236][j]] = 60416 + j; d[60416 + j] = D[236][j];}
D[237] = "����������������������������������������������������������������檕檃檨檤檑橿檦檚檅檌檒歛殭氉濌澩濴濔濣濜濭濧濦濞濲濝濢濨燡燱燨燲燤燰燢獳獮獯璗璲璫璐璪璭璱璥璯甐甑甒甏疄癃癈癉癇皤盩瞵瞫瞲瞷瞶����������������������������������瞴瞱瞨矰磳磽礂磻磼磲礅磹磾礄禫禨穜穛穖穘穔穚窾竀竁簅簏篲簀篿篻簎篴簋篳簂簉簃簁篸篽簆篰篱簐簊糨縭縼繂縳顈縸縪繉繀繇縩繌縰縻縶繄縺罅罿罾罽翴翲耬膻臄臌臊臅臇膼臩艛艚艜薃薀薏薧薕薠薋薣蕻薤薚薞�".split("");
for(j = 0; j != D[237].length; ++j) if(D[237][j].charCodeAt(0) !== 0xFFFD) { e[D[237][j]] = 60672 + j; d[60672 + j] = D[237][j];}
D[238] = "����������������������������������������������������������������蕷蕼薉薡蕺蕸蕗薎薖薆薍薙薝薁薢薂薈薅蕹蕶薘薐薟虨螾螪螭蟅螰螬螹螵螼螮蟉蟃蟂蟌螷螯蟄蟊螴螶螿螸螽蟞螲褵褳褼褾襁襒褷襂覭覯覮觲觳謞����������������������������������謘謖謑謅謋謢謏謒謕謇謍謈謆謜謓謚豏豰豲豱豯貕貔賹赯蹎蹍蹓蹐蹌蹇轃轀邅遾鄸醚醢醛醙醟醡醝醠鎡鎃鎯鍤鍖鍇鍼鍘鍜鍶鍉鍐鍑鍠鍭鎏鍌鍪鍹鍗鍕鍒鍏鍱鍷鍻鍡鍞鍣鍧鎀鍎鍙闇闀闉闃闅閷隮隰隬霠霟霘霝霙鞚鞡鞜�".split("");
for(j = 0; j != D[238].length; ++j) if(D[238][j].charCodeAt(0) !== 0xFFFD) { e[D[238][j]] = 60928 + j; d[60928 + j] = D[238][j];}
D[239] = "����������������������������������������������������������������鞞鞝韕韔韱顁顄顊顉顅顃餥餫餬餪餳餲餯餭餱餰馘馣馡騂駺駴駷駹駸駶駻駽駾駼騃骾髾髽鬁髼魈鮚鮨鮞鮛鮦鮡鮥鮤鮆鮢鮠鮯鴳鵁鵧鴶鴮鴯鴱鴸鴰����������������������������������鵅鵂鵃鴾鴷鵀鴽翵鴭麊麉麍麰黈黚黻黿鼤鼣鼢齔龠儱儭儮嚘嚜嚗嚚嚝嚙奰嬼屩屪巀幭幮懘懟懭懮懱懪懰懫懖懩擿攄擽擸攁攃擼斔旛曚曛曘櫅檹檽櫡櫆檺檶檷櫇檴檭歞毉氋瀇瀌瀍瀁瀅瀔瀎濿瀀濻瀦濼濷瀊爁燿燹爃燽獶�".split("");
for(j = 0; j != D[239].length; ++j) if(D[239][j].charCodeAt(0) !== 0xFFFD) { e[D[239][j]] = 61184 + j; d[61184 + j] = D[239][j];}
D[240] = "����������������������������������������������������������������璸瓀璵瓁璾璶璻瓂甔甓癜癤癙癐癓癗癚皦皽盬矂瞺磿礌礓礔礉礐礒礑禭禬穟簜簩簙簠簟簭簝簦簨簢簥簰繜繐繖繣繘繢繟繑繠繗繓羵羳翷翸聵臑臒����������������������������������臐艟艞薴藆藀藃藂薳薵薽藇藄薿藋藎藈藅薱薶藒蘤薸薷薾虩蟧蟦蟢蟛蟫蟪蟥蟟蟳蟤蟔蟜蟓蟭蟘蟣螤蟗蟙蠁蟴蟨蟝襓襋襏襌襆襐襑襉謪謧謣謳謰謵譇謯謼謾謱謥謷謦謶謮謤謻謽謺豂豵貙貘貗賾贄贂贀蹜蹢蹠蹗蹖蹞蹥蹧�".split("");
for(j = 0; j != D[240].length; ++j) if(D[240][j].charCodeAt(0) !== 0xFFFD) { e[D[240][j]] = 61440 + j; d[61440 + j] = D[240][j];}
D[241] = "����������������������������������������������������������������蹛蹚蹡蹝蹩蹔轆轇轈轋鄨鄺鄻鄾醨醥醧醯醪鎵鎌鎒鎷鎛鎝鎉鎧鎎鎪鎞鎦鎕鎈鎙鎟鎍鎱鎑鎲鎤鎨鎴鎣鎥闒闓闑隳雗雚巂雟雘雝霣霢霥鞬鞮鞨鞫鞤鞪����������������������������������鞢鞥韗韙韖韘韺顐顑顒颸饁餼餺騏騋騉騍騄騑騊騅騇騆髀髜鬈鬄鬅鬩鬵魊魌魋鯇鯆鯃鮿鯁鮵鮸鯓鮶鯄鮹鮽鵜鵓鵏鵊鵛鵋鵙鵖鵌鵗鵒鵔鵟鵘鵚麎麌黟鼁鼀鼖鼥鼫鼪鼩鼨齌齕儴儵劖勷厴嚫嚭嚦嚧嚪嚬壚壝壛夒嬽嬾嬿巃幰�".split("");
for(j = 0; j != D[241].length; ++j) if(D[241][j].charCodeAt(0) !== 0xFFFD) { e[D[241][j]] = 61696 + j; d[61696 + j] = D[241][j];}
D[242] = "����������������������������������������������������������������徿懻攇攐攍攉攌攎斄旞旝曞櫧櫠櫌櫑櫙櫋櫟櫜櫐櫫櫏櫍櫞歠殰氌瀙瀧瀠瀖瀫瀡瀢瀣瀩瀗瀤瀜瀪爌爊爇爂爅犥犦犤犣犡瓋瓅璷瓃甖癠矉矊矄矱礝礛����������������������������������礡礜礗礞禰穧穨簳簼簹簬簻糬糪繶繵繸繰繷繯繺繲繴繨罋罊羃羆羷翽翾聸臗臕艤艡艣藫藱藭藙藡藨藚藗藬藲藸藘藟藣藜藑藰藦藯藞藢蠀蟺蠃蟶蟷蠉蠌蠋蠆蟼蠈蟿蠊蠂襢襚襛襗襡襜襘襝襙覈覷覶觶譐譈譊譀譓譖譔譋譕�".split("");
for(j = 0; j != D[242].length; ++j) if(D[242][j].charCodeAt(0) !== 0xFFFD) { e[D[242][j]] = 61952 + j; d[61952 + j] = D[242][j];}
D[243] = "����������������������������������������������������������������譑譂譒譗豃豷豶貚贆贇贉趬趪趭趫蹭蹸蹳蹪蹯蹻軂轒轑轏轐轓辴酀鄿醰醭鏞鏇鏏鏂鏚鏐鏹鏬鏌鏙鎩鏦鏊鏔鏮鏣鏕鏄鏎鏀鏒鏧镽闚闛雡霩霫霬霨霦����������������������������������鞳鞷鞶韝韞韟顜顙顝顗颿颽颻颾饈饇饃馦馧騚騕騥騝騤騛騢騠騧騣騞騜騔髂鬋鬊鬎鬌鬷鯪鯫鯠鯞鯤鯦鯢鯰鯔鯗鯬鯜鯙鯥鯕鯡鯚鵷鶁鶊鶄鶈鵱鶀鵸鶆鶋鶌鵽鵫鵴鵵鵰鵩鶅鵳鵻鶂鵯鵹鵿鶇鵨麔麑黀黼鼭齀齁齍齖齗齘匷嚲�".split("");
for(j = 0; j != D[243].length; ++j) if(D[243][j].charCodeAt(0) !== 0xFFFD) { e[D[243][j]] = 62208 + j; d[62208 + j] = D[243][j];}
D[244] = "����������������������������������������������������������������嚵嚳壣孅巆巇廮廯忀忁懹攗攖攕攓旟曨曣曤櫳櫰櫪櫨櫹櫱櫮櫯瀼瀵瀯瀷瀴瀱灂瀸瀿瀺瀹灀瀻瀳灁爓爔犨獽獼璺皫皪皾盭矌矎矏矍矲礥礣礧礨礤礩����������������������������������禲穮穬穭竷籉籈籊籇籅糮繻繾纁纀羺翿聹臛臙舋艨艩蘢藿蘁藾蘛蘀藶蘄蘉蘅蘌藽蠙蠐蠑蠗蠓蠖襣襦覹觷譠譪譝譨譣譥譧譭趮躆躈躄轙轖轗轕轘轚邍酃酁醷醵醲醳鐋鐓鏻鐠鐏鐔鏾鐕鐐鐨鐙鐍鏵鐀鏷鐇鐎鐖鐒鏺鐉鏸鐊鏿�".split("");
for(j = 0; j != D[244].length; ++j) if(D[244][j].charCodeAt(0) !== 0xFFFD) { e[D[244][j]] = 62464 + j; d[62464 + j] = D[244][j];}
D[245] = "����������������������������������������������������������������鏼鐌鏶鐑鐆闞闠闟霮霯鞹鞻韽韾顠顢顣顟飁飂饐饎饙饌饋饓騲騴騱騬騪騶騩騮騸騭髇髊髆鬐鬒鬑鰋鰈鯷鰅鰒鯸鱀鰇鰎鰆鰗鰔鰉鶟鶙鶤鶝鶒鶘鶐鶛����������������������������������鶠鶔鶜鶪鶗鶡鶚鶢鶨鶞鶣鶿鶩鶖鶦鶧麙麛麚黥黤黧黦鼰鼮齛齠齞齝齙龑儺儹劘劗囃嚽嚾孈孇巋巏廱懽攛欂櫼欃櫸欀灃灄灊灈灉灅灆爝爚爙獾甗癪矐礭礱礯籔籓糲纊纇纈纋纆纍罍羻耰臝蘘蘪蘦蘟蘣蘜蘙蘧蘮蘡蘠蘩蘞蘥�".split("");
for(j = 0; j != D[245].length; ++j) if(D[245][j].charCodeAt(0) !== 0xFFFD) { e[D[245][j]] = 62720 + j; d[62720 + j] = D[245][j];}
D[246] = "����������������������������������������������������������������蠩蠝蠛蠠蠤蠜蠫衊襭襩襮襫觺譹譸譅譺譻贐贔趯躎躌轞轛轝酆酄酅醹鐿鐻鐶鐩鐽鐼鐰鐹鐪鐷鐬鑀鐱闥闤闣霵霺鞿韡顤飉飆飀饘饖騹騽驆驄驂驁騺����������������������������������騿髍鬕鬗鬘鬖鬺魒鰫鰝鰜鰬鰣鰨鰩鰤鰡鶷鶶鶼鷁鷇鷊鷏鶾鷅鷃鶻鶵鷎鶹鶺鶬鷈鶱鶭鷌鶳鷍鶲鹺麜黫黮黭鼛鼘鼚鼱齎齥齤龒亹囆囅囋奱孋孌巕巑廲攡攠攦攢欋欈欉氍灕灖灗灒爞爟犩獿瓘瓕瓙瓗癭皭礵禴穰穱籗籜籙籛籚�".split("");
for(j = 0; j != D[246].length; ++j) if(D[246][j].charCodeAt(0) !== 0xFFFD) { e[D[246][j]] = 62976 + j; d[62976 + j] = D[246][j];}
D[247] = "����������������������������������������������������������������糴糱纑罏羇臞艫蘴蘵蘳蘬蘲蘶蠬蠨蠦蠪蠥襱覿覾觻譾讄讂讆讅譿贕躕躔躚躒躐躖躗轠轢酇鑌鑐鑊鑋鑏鑇鑅鑈鑉鑆霿韣顪顩飋饔饛驎驓驔驌驏驈驊����������������������������������驉驒驐髐鬙鬫鬻魖魕鱆鱈鰿鱄鰹鰳鱁鰼鰷鰴鰲鰽鰶鷛鷒鷞鷚鷋鷐鷜鷑鷟鷩鷙鷘鷖鷵鷕鷝麶黰鼵鼳鼲齂齫龕龢儽劙壨壧奲孍巘蠯彏戁戃戄攩攥斖曫欑欒欏毊灛灚爢玂玁玃癰矔籧籦纕艬蘺虀蘹蘼蘱蘻蘾蠰蠲蠮蠳襶襴襳觾�".split("");
for(j = 0; j != D[247].length; ++j) if(D[247][j].charCodeAt(0) !== 0xFFFD) { e[D[247][j]] = 63232 + j; d[63232 + j] = D[247][j];}
D[248] = "����������������������������������������������������������������讌讎讋讈豅贙躘轤轣醼鑢鑕鑝鑗鑞韄韅頀驖驙鬞鬟鬠鱒鱘鱐鱊鱍鱋鱕鱙鱌鱎鷻鷷鷯鷣鷫鷸鷤鷶鷡鷮鷦鷲鷰鷢鷬鷴鷳鷨鷭黂黐黲黳鼆鼜鼸鼷鼶齃齏����������������������������������齱齰齮齯囓囍孎屭攭曭曮欓灟灡灝灠爣瓛瓥矕礸禷禶籪纗羉艭虃蠸蠷蠵衋讔讕躞躟躠躝醾醽釂鑫鑨鑩雥靆靃靇韇韥驞髕魙鱣鱧鱦鱢鱞鱠鸂鷾鸇鸃鸆鸅鸀鸁鸉鷿鷽鸄麠鼞齆齴齵齶囔攮斸欘欙欗欚灢爦犪矘矙礹籩籫糶纚�".split("");
for(j = 0; j != D[248].length; ++j) if(D[248][j].charCodeAt(0) !== 0xFFFD) { e[D[248][j]] = 63488 + j; d[63488 + j] = D[248][j];}
D[249] = "����������������������������������������������������������������纘纛纙臠臡虆虇虈襹襺襼襻觿讘讙躥躤躣鑮鑭鑯鑱鑳靉顲饟鱨鱮鱭鸋鸍鸐鸏鸒鸑麡黵鼉齇齸齻齺齹圞灦籯蠼趲躦釃鑴鑸鑶鑵驠鱴鱳鱱鱵鸔鸓黶鼊����������������������������������龤灨灥糷虪蠾蠽蠿讞貜躩軉靋顳顴飌饡馫驤驦驧鬤鸕鸗齈戇欞爧虌躨钂钀钁驩驨鬮鸙爩虋讟钃鱹麷癵驫鱺鸝灩灪麤齾齉龘碁銹裏墻恒粧嫺╔╦╗╠╬╣╚╩╝╒╤╕╞╪╡╘╧╛╓╥╖╟╫╢╙╨╜║═╭╮╰╯▓�".split("");
for(j = 0; j != D[249].length; ++j) if(D[249][j].charCodeAt(0) !== 0xFFFD) { e[D[249][j]] = 63744 + j; d[63744 + j] = D[249][j];}
return {"enc": e, "dec": d }; })();
cptable[1250] = (function(){ var d = "\u0000\u0001\u0002\u0003\u0004\u0005\u0006\u0007\b\t\n\u000b\f\r\u000e\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~€�‚�„…†‡�‰Š‹ŚŤŽŹ�‘’“”•–—�™š›śťžź ˇ˘Ł¤Ą¦§¨©Ş«¬­®Ż°±˛ł´µ¶·¸ąş»Ľ˝ľżŔÁÂĂÄĹĆÇČÉĘËĚÍÎĎĐŃŇÓÔŐÖ×ŘŮÚŰÜÝŢßŕáâăäĺćçčéęëěíîďđńňóôőö÷řůúűüýţ˙", D = [], e = {}; for(var i=0;i!=d.length;++i) { if(d.charCodeAt(i) !== 0xFFFD) e[d.charAt(i)] = i; D[i] = d.charAt(i); } return {"enc": e, "dec": D }; })();
cptable[1251] = (function(){ var d = "\u0000\u0001\u0002\u0003\u0004\u0005\u0006\u0007\b\t\n\u000b\f\r\u000e\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~ЂЃ‚ѓ„…†‡€‰Љ‹ЊЌЋЏђ‘’“”•–—�™љ›њќћџ ЎўЈ¤Ґ¦§Ё©Є«¬­®Ї°±Ііґµ¶·ё№є»јЅѕїАБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдежзийклмнопрстуфхцчшщъыьэюя", D = [], e = {}; for(var i=0;i!=d.length;++i) { if(d.charCodeAt(i) !== 0xFFFD) e[d.charAt(i)] = i; D[i] = d.charAt(i); } return {"enc": e, "dec": D }; })();
cptable[1252] = (function(){ var d = "\u0000\u0001\u0002\u0003\u0004\u0005\u0006\u0007\b\t\n\u000b\f\r\u000e\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~€�‚ƒ„…†‡ˆ‰Š‹Œ�Ž��‘’“”•–—˜™š›œ�žŸ ¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ", D = [], e = {}; for(var i=0;i!=d.length;++i) { if(d.charCodeAt(i) !== 0xFFFD) e[d.charAt(i)] = i; D[i] = d.charAt(i); } return {"enc": e, "dec": D }; })();
cptable[1253] = (function(){ var d = "\u0000\u0001\u0002\u0003\u0004\u0005\u0006\u0007\b\t\n\u000b\f\r\u000e\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~€�‚ƒ„…†‡�‰�‹�����‘’“”•–—�™�›���� ΅Ά£¤¥¦§¨©�«¬­®―°±²³΄µ¶·ΈΉΊ»Ό½ΎΏΐΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡ�ΣΤΥΦΧΨΩΪΫάέήίΰαβγδεζηθικλμνξοπρςστυφχψωϊϋόύώ�", D = [], e = {}; for(var i=0;i!=d.length;++i) { if(d.charCodeAt(i) !== 0xFFFD) e[d.charAt(i)] = i; D[i] = d.charAt(i); } return {"enc": e, "dec": D }; })();
cptable[1254] = (function(){ var d = "\u0000\u0001\u0002\u0003\u0004\u0005\u0006\u0007\b\t\n\u000b\f\r\u000e\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~€�‚ƒ„…†‡ˆ‰Š‹Œ����‘’“”•–—˜™š›œ��Ÿ ¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏĞÑÒÓÔÕÖ×ØÙÚÛÜİŞßàáâãäåæçèéêëìíîïğñòóôõö÷øùúûüışÿ", D = [], e = {}; for(var i=0;i!=d.length;++i) { if(d.charCodeAt(i) !== 0xFFFD) e[d.charAt(i)] = i; D[i] = d.charAt(i); } return {"enc": e, "dec": D }; })();
cptable[1255] = (function(){ var d = "\u0000\u0001\u0002\u0003\u0004\u0005\u0006\u0007\b\t\n\u000b\f\r\u000e\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~€�‚ƒ„…†‡ˆ‰�‹�����‘’“”•–—˜™�›���� ¡¢£₪¥¦§¨©×«¬­®¯°±²³´µ¶·¸¹÷»¼½¾¿ְֱֲֳִֵֶַָֹ�ֻּֽ־ֿ׀ׁׂ׃װױײ׳״�������אבגדהוזחטיךכלםמןנסעףפץצקרשת��‎‏�", D = [], e = {}; for(var i=0;i!=d.length;++i) { if(d.charCodeAt(i) !== 0xFFFD) e[d.charAt(i)] = i; D[i] = d.charAt(i); } return {"enc": e, "dec": D }; })();
cptable[1256] = (function(){ var d = "\u0000\u0001\u0002\u0003\u0004\u0005\u0006\u0007\b\t\n\u000b\f\r\u000e\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~€پ‚ƒ„…†‡ˆ‰ٹ‹Œچژڈگ‘’“”•–—ک™ڑ›œ‌‍ں ،¢£¤¥¦§¨©ھ«¬­®¯°±²³´µ¶·¸¹؛»¼½¾؟ہءآأؤإئابةتثجحخدذرزسشصض×طظعغـفقكàلâمنهوçèéêëىيîïًٌٍَôُِ÷ّùْûü‎‏ے", D = [], e = {}; for(var i=0;i!=d.length;++i) { if(d.charCodeAt(i) !== 0xFFFD) e[d.charAt(i)] = i; D[i] = d.charAt(i); } return {"enc": e, "dec": D }; })();
cptable[1257] = (function(){ var d = "\u0000\u0001\u0002\u0003\u0004\u0005\u0006\u0007\b\t\n\u000b\f\r\u000e\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~€�‚�„…†‡�‰�‹�¨ˇ¸�‘’“”•–—�™�›�¯˛� �¢£¤�¦§Ø©Ŗ«¬­®Æ°±²³´µ¶·ø¹ŗ»¼½¾æĄĮĀĆÄÅĘĒČÉŹĖĢĶĪĻŠŃŅÓŌÕÖ×ŲŁŚŪÜŻŽßąįāćäåęēčéźėģķīļšńņóōõö÷ųłśūüżž˙", D = [], e = {}; for(var i=0;i!=d.length;++i) { if(d.charCodeAt(i) !== 0xFFFD) e[d.charAt(i)] = i; D[i] = d.charAt(i); } return {"enc": e, "dec": D }; })();
cptable[1258] = (function(){ var d = "\u0000\u0001\u0002\u0003\u0004\u0005\u0006\u0007\b\t\n\u000b\f\r\u000e\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~€�‚ƒ„…†‡ˆ‰�‹Œ����‘’“”•–—˜™�›œ��Ÿ ¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂĂÄÅÆÇÈÉÊË̀ÍÎÏĐÑ̉ÓÔƠÖ×ØÙÚÛÜỮßàáâăäåæçèéêë́íîïđṇ̃óôơö÷øùúûüư₫ÿ", D = [], e = {}; for(var i=0;i!=d.length;++i) { if(d.charCodeAt(i) !== 0xFFFD) e[d.charAt(i)] = i; D[i] = d.charAt(i); } return {"enc": e, "dec": D }; })();
cptable[10000] = (function(){ var d = "\u0000\u0001\u0002\u0003\u0004\u0005\u0006\u0007\b\t\n\u000b\f\r\u000e\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~ÄÅÇÉÑÖÜáàâäãåçéèêëíìîïñóòôöõúùûü†°¢£§•¶ß®©™´¨≠ÆØ∞±≤≥¥µ∂∑∏π∫ªºΩæø¿¡¬√ƒ≈∆«»… ÀÃÕŒœ–—“”‘’÷◊ÿŸ⁄¤‹›ﬁﬂ‡·‚„‰ÂÊÁËÈÍÎÏÌÓÔ�ÒÚÛÙıˆ˜¯˘˙˚¸˝˛ˇ", D = [], e = {}; for(var i=0;i!=d.length;++i) { if(d.charCodeAt(i) !== 0xFFFD) e[d.charAt(i)] = i; D[i] = d.charAt(i); } return {"enc": e, "dec": D }; })();
cptable[10006] = (function(){ var d = "\u0000\u0001\u0002\u0003\u0004\u0005\u0006\u0007\b\t\n\u000b\f\r\u000e\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~Ä¹²É³ÖÜ΅àâä΄¨çéèêë£™îï•½‰ôö¦­ùûü†ΓΔΘΛΞΠß®©ΣΪ§≠°·Α±≤≥¥ΒΕΖΗΙΚΜΦΫΨΩάΝ¬ΟΡ≈Τ«»… ΥΧΆΈœ–―“”‘’÷ΉΊΌΎέήίόΏύαβψδεφγηιξκλμνοπώρστθωςχυζϊϋΐΰ�", D = [], e = {}; for(var i=0;i!=d.length;++i) { if(d.charCodeAt(i) !== 0xFFFD) e[d.charAt(i)] = i; D[i] = d.charAt(i); } return {"enc": e, "dec": D }; })();
cptable[10007] = (function(){ var d = "\u0000\u0001\u0002\u0003\u0004\u0005\u0006\u0007\b\t\n\u000b\f\r\u000e\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~АБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ†°¢£§•¶І®©™Ђђ≠Ѓѓ∞±≤≥іµ∂ЈЄєЇїЉљЊњјЅ¬√ƒ≈∆«»… ЋћЌќѕ–—“”‘’÷„ЎўЏџ№Ёёяабвгдежзийклмнопрстуфхцчшщъыьэю¤", D = [], e = {}; for(var i=0;i!=d.length;++i) { if(d.charCodeAt(i) !== 0xFFFD) e[d.charAt(i)] = i; D[i] = d.charAt(i); } return {"enc": e, "dec": D }; })();
cptable[10008] = (function(){ var d = [], e = {}, D = [], j;
D[0] = "\u0000\u0001\u0002\u0003\u0004\u0005\u0006\u0007\b\t\n\u000b\f\r\u000e\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~���������������������������������������������������������������������������������������".split("");
for(j = 0; j != D[0].length; ++j) if(D[0][j].charCodeAt(0) !== 0xFFFD) { e[D[0][j]] = 0 + j; d[0 + j] = D[0][j];}
D[161] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������　、。・ˉˇ¨〃々―～�…‘’“”〔〕〈〉《》「」『』〖〗【】±×÷∶∧∨∑∏∪∩∈∷√⊥∥∠⌒⊙∫∮≡≌≈∽∝≠≮≯≤≥∞∵∴♂♀°′″℃＄¤￠￡‰§№☆★○●◎◇◆□■△▲※→←↑↓〓�".split("");
for(j = 0; j != D[161].length; ++j) if(D[161][j].charCodeAt(0) !== 0xFFFD) { e[D[161][j]] = 41216 + j; d[41216 + j] = D[161][j];}
D[162] = "���������������������������������������������������������������������������������������������������������������������������������������������������������������������������������⒈⒉⒊⒋⒌⒍⒎⒏⒐⒑⒒⒓⒔⒕⒖⒗⒘⒙⒚⒛⑴⑵⑶⑷⑸⑹⑺⑻⑼⑽⑾⑿⒀⒁⒂⒃⒄⒅⒆⒇①②③④⑤⑥⑦⑧⑨⑩��㈠㈡㈢㈣㈤㈥㈦㈧㈨㈩��ⅠⅡⅢⅣⅤⅥⅦⅧⅨⅩⅪⅫ���".split("");
for(j = 0; j != D[162].length; ++j) if(D[162][j].charCodeAt(0) !== 0xFFFD) { e[D[162][j]] = 41472 + j; d[41472 + j] = D[162][j];}
D[163] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������！＂＃￥％＆＇（）＊＋，－．／０１２３４５６７８９：；＜＝＞？＠ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ［＼］＾＿｀ａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ｛｜｝￣�".split("");
for(j = 0; j != D[163].length; ++j) if(D[163][j].charCodeAt(0) !== 0xFFFD) { e[D[163][j]] = 41728 + j; d[41728 + j] = D[163][j];}
D[164] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������ぁあぃいぅうぇえぉおかがきぎくぐけげこごさざしじすずせぜそぞただちぢっつづてでとどなにぬねのはばぱひびぴふぶぷへべぺほぼぽまみむめもゃやゅゆょよらりるれろゎわゐゑをん������������".split("");
for(j = 0; j != D[164].length; ++j) if(D[164][j].charCodeAt(0) !== 0xFFFD) { e[D[164][j]] = 41984 + j; d[41984 + j] = D[164][j];}
D[165] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������ァアィイゥウェエォオカガキギクグケゲコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶ���������".split("");
for(j = 0; j != D[165].length; ++j) if(D[165][j].charCodeAt(0) !== 0xFFFD) { e[D[165][j]] = 42240 + j; d[42240 + j] = D[165][j];}
D[166] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩ��������αβγδεζηθικλμνξοπρστυφχψω���������������������������������������".split("");
for(j = 0; j != D[166].length; ++j) if(D[166][j].charCodeAt(0) !== 0xFFFD) { e[D[166][j]] = 42496 + j; d[42496 + j] = D[166][j];}
D[167] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ���������������абвгдеёжзийклмнопрстуфхцчшщъыьэюя��������������".split("");
for(j = 0; j != D[167].length; ++j) if(D[167][j].charCodeAt(0) !== 0xFFFD) { e[D[167][j]] = 42752 + j; d[42752 + j] = D[167][j];}
D[168] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������āáǎàēéěèīíǐìōóǒòūúǔùǖǘǚǜüê����������ㄅㄆㄇㄈㄉㄊㄋㄌㄍㄎㄏㄐㄑㄒㄓㄔㄕㄖㄗㄘㄙㄚㄛㄜㄝㄞㄟㄠㄡㄢㄣㄤㄥㄦㄧㄨㄩ����������������������".split("");
for(j = 0; j != D[168].length; ++j) if(D[168][j].charCodeAt(0) !== 0xFFFD) { e[D[168][j]] = 43008 + j; d[43008 + j] = D[168][j];}
D[169] = "��������������������������������������������������������������������������������������������������������������������������������������������������������������������─━│┃┄┅┆┇┈┉┊┋┌┍┎┏┐┑┒┓└┕┖┗┘┙┚┛├┝┞┟┠┡┢┣┤┥┦┧┨┩┪┫┬┭┮┯┰┱┲┳┴┵┶┷┸┹┺┻┼┽┾┿╀╁╂╃╄╅╆╇╈╉╊╋����������������".split("");
for(j = 0; j != D[169].length; ++j) if(D[169][j].charCodeAt(0) !== 0xFFFD) { e[D[169][j]] = 43264 + j; d[43264 + j] = D[169][j];}
D[176] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������啊阿埃挨哎唉哀皑癌蔼矮艾碍爱隘鞍氨安俺按暗岸胺案肮昂盎凹敖熬翱袄傲奥懊澳芭捌扒叭吧笆八疤巴拔跋靶把耙坝霸罢爸白柏百摆佰败拜稗斑班搬扳般颁板版扮拌伴瓣半办绊邦帮梆榜膀绑棒磅蚌镑傍谤苞胞包褒剥�".split("");
for(j = 0; j != D[176].length; ++j) if(D[176][j].charCodeAt(0) !== 0xFFFD) { e[D[176][j]] = 45056 + j; d[45056 + j] = D[176][j];}
D[177] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������薄雹保堡饱宝抱报暴豹鲍爆杯碑悲卑北辈背贝钡倍狈备惫焙被奔苯本笨崩绷甭泵蹦迸逼鼻比鄙笔彼碧蓖蔽毕毙毖币庇痹闭敝弊必辟壁臂避陛鞭边编贬扁便变卞辨辩辫遍标彪膘表鳖憋别瘪彬斌濒滨宾摈兵冰柄丙秉饼炳�".split("");
for(j = 0; j != D[177].length; ++j) if(D[177][j].charCodeAt(0) !== 0xFFFD) { e[D[177][j]] = 45312 + j; d[45312 + j] = D[177][j];}
D[178] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������病并玻菠播拨钵波博勃搏铂箔伯帛舶脖膊渤泊驳捕卜哺补埠不布步簿部怖擦猜裁材才财睬踩采彩菜蔡餐参蚕残惭惨灿苍舱仓沧藏操糙槽曹草厕策侧册测层蹭插叉茬茶查碴搽察岔差诧拆柴豺搀掺蝉馋谗缠铲产阐颤昌猖�".split("");
for(j = 0; j != D[178].length; ++j) if(D[178][j].charCodeAt(0) !== 0xFFFD) { e[D[178][j]] = 45568 + j; d[45568 + j] = D[178][j];}
D[179] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������场尝常长偿肠厂敞畅唱倡超抄钞朝嘲潮巢吵炒车扯撤掣彻澈郴臣辰尘晨忱沉陈趁衬撑称城橙成呈乘程惩澄诚承逞骋秤吃痴持匙池迟弛驰耻齿侈尺赤翅斥炽充冲虫崇宠抽酬畴踌稠愁筹仇绸瞅丑臭初出橱厨躇锄雏滁除楚�".split("");
for(j = 0; j != D[179].length; ++j) if(D[179][j].charCodeAt(0) !== 0xFFFD) { e[D[179][j]] = 45824 + j; d[45824 + j] = D[179][j];}
D[180] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������础储矗搐触处揣川穿椽传船喘串疮窗幢床闯创吹炊捶锤垂春椿醇唇淳纯蠢戳绰疵茨磁雌辞慈瓷词此刺赐次聪葱囱匆从丛凑粗醋簇促蹿篡窜摧崔催脆瘁粹淬翠村存寸磋撮搓措挫错搭达答瘩打大呆歹傣戴带殆代贷袋待逮�".split("");
for(j = 0; j != D[180].length; ++j) if(D[180][j].charCodeAt(0) !== 0xFFFD) { e[D[180][j]] = 46080 + j; d[46080 + j] = D[180][j];}
D[181] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������怠耽担丹单郸掸胆旦氮但惮淡诞弹蛋当挡党荡档刀捣蹈倒岛祷导到稻悼道盗德得的蹬灯登等瞪凳邓堤低滴迪敌笛狄涤翟嫡抵底地蒂第帝弟递缔颠掂滇碘点典靛垫电佃甸店惦奠淀殿碉叼雕凋刁掉吊钓调跌爹碟蝶迭谍叠�".split("");
for(j = 0; j != D[181].length; ++j) if(D[181][j].charCodeAt(0) !== 0xFFFD) { e[D[181][j]] = 46336 + j; d[46336 + j] = D[181][j];}
D[182] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������丁盯叮钉顶鼎锭定订丢东冬董懂动栋侗恫冻洞兜抖斗陡豆逗痘都督毒犊独读堵睹赌杜镀肚度渡妒端短锻段断缎堆兑队对墩吨蹲敦顿囤钝盾遁掇哆多夺垛躲朵跺舵剁惰堕蛾峨鹅俄额讹娥恶厄扼遏鄂饿恩而儿耳尔饵洱二�".split("");
for(j = 0; j != D[182].length; ++j) if(D[182][j].charCodeAt(0) !== 0xFFFD) { e[D[182][j]] = 46592 + j; d[46592 + j] = D[182][j];}
D[183] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������贰发罚筏伐乏阀法珐藩帆番翻樊矾钒繁凡烦反返范贩犯饭泛坊芳方肪房防妨仿访纺放菲非啡飞肥匪诽吠肺废沸费芬酚吩氛分纷坟焚汾粉奋份忿愤粪丰封枫蜂峰锋风疯烽逢冯缝讽奉凤佛否夫敷肤孵扶拂辐幅氟符伏俘服�".split("");
for(j = 0; j != D[183].length; ++j) if(D[183][j].charCodeAt(0) !== 0xFFFD) { e[D[183][j]] = 46848 + j; d[46848 + j] = D[183][j];}
D[184] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������浮涪福袱弗甫抚辅俯釜斧脯腑府腐赴副覆赋复傅付阜父腹负富讣附妇缚咐噶嘎该改概钙盖溉干甘杆柑竿肝赶感秆敢赣冈刚钢缸肛纲岗港杠篙皋高膏羔糕搞镐稿告哥歌搁戈鸽胳疙割革葛格蛤阁隔铬个各给根跟耕更庚羹�".split("");
for(j = 0; j != D[184].length; ++j) if(D[184][j].charCodeAt(0) !== 0xFFFD) { e[D[184][j]] = 47104 + j; d[47104 + j] = D[184][j];}
D[185] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������埂耿梗工攻功恭龚供躬公宫弓巩汞拱贡共钩勾沟苟狗垢构购够辜菇咕箍估沽孤姑鼓古蛊骨谷股故顾固雇刮瓜剐寡挂褂乖拐怪棺关官冠观管馆罐惯灌贯光广逛瑰规圭硅归龟闺轨鬼诡癸桂柜跪贵刽辊滚棍锅郭国果裹过哈�".split("");
for(j = 0; j != D[185].length; ++j) if(D[185][j].charCodeAt(0) !== 0xFFFD) { e[D[185][j]] = 47360 + j; d[47360 + j] = D[185][j];}
D[186] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������骸孩海氦亥害骇酣憨邯韩含涵寒函喊罕翰撼捍旱憾悍焊汗汉夯杭航壕嚎豪毫郝好耗号浩呵喝荷菏核禾和何合盒貉阂河涸赫褐鹤贺嘿黑痕很狠恨哼亨横衡恒轰哄烘虹鸿洪宏弘红喉侯猴吼厚候后呼乎忽瑚壶葫胡蝴狐糊湖�".split("");
for(j = 0; j != D[186].length; ++j) if(D[186][j].charCodeAt(0) !== 0xFFFD) { e[D[186][j]] = 47616 + j; d[47616 + j] = D[186][j];}
D[187] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������弧虎唬护互沪户花哗华猾滑画划化话槐徊怀淮坏欢环桓还缓换患唤痪豢焕涣宦幻荒慌黄磺蝗簧皇凰惶煌晃幌恍谎灰挥辉徽恢蛔回毁悔慧卉惠晦贿秽会烩汇讳诲绘荤昏婚魂浑混豁活伙火获或惑霍货祸击圾基机畸稽积箕�".split("");
for(j = 0; j != D[187].length; ++j) if(D[187][j].charCodeAt(0) !== 0xFFFD) { e[D[187][j]] = 47872 + j; d[47872 + j] = D[187][j];}
D[188] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������肌饥迹激讥鸡姬绩缉吉极棘辑籍集及急疾汲即嫉级挤几脊己蓟技冀季伎祭剂悸济寄寂计记既忌际妓继纪嘉枷夹佳家加荚颊贾甲钾假稼价架驾嫁歼监坚尖笺间煎兼肩艰奸缄茧检柬碱硷拣捡简俭剪减荐槛鉴践贱见键箭件�".split("");
for(j = 0; j != D[188].length; ++j) if(D[188][j].charCodeAt(0) !== 0xFFFD) { e[D[188][j]] = 48128 + j; d[48128 + j] = D[188][j];}
D[189] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������健舰剑饯渐溅涧建僵姜将浆江疆蒋桨奖讲匠酱降蕉椒礁焦胶交郊浇骄娇嚼搅铰矫侥脚狡角饺缴绞剿教酵轿较叫窖揭接皆秸街阶截劫节桔杰捷睫竭洁结解姐戒藉芥界借介疥诫届巾筋斤金今津襟紧锦仅谨进靳晋禁近烬浸�".split("");
for(j = 0; j != D[189].length; ++j) if(D[189][j].charCodeAt(0) !== 0xFFFD) { e[D[189][j]] = 48384 + j; d[48384 + j] = D[189][j];}
D[190] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������尽劲荆兢茎睛晶鲸京惊精粳经井警景颈静境敬镜径痉靖竟竞净炯窘揪究纠玖韭久灸九酒厩救旧臼舅咎就疚鞠拘狙疽居驹菊局咀矩举沮聚拒据巨具距踞锯俱句惧炬剧捐鹃娟倦眷卷绢撅攫抉掘倔爵觉决诀绝均菌钧军君峻�".split("");
for(j = 0; j != D[190].length; ++j) if(D[190][j].charCodeAt(0) !== 0xFFFD) { e[D[190][j]] = 48640 + j; d[48640 + j] = D[190][j];}
D[191] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������俊竣浚郡骏喀咖卡咯开揩楷凯慨刊堪勘坎砍看康慷糠扛抗亢炕考拷烤靠坷苛柯棵磕颗科壳咳可渴克刻客课肯啃垦恳坑吭空恐孔控抠口扣寇枯哭窟苦酷库裤夸垮挎跨胯块筷侩快宽款匡筐狂框矿眶旷况亏盔岿窥葵奎魁傀�".split("");
for(j = 0; j != D[191].length; ++j) if(D[191][j].charCodeAt(0) !== 0xFFFD) { e[D[191][j]] = 48896 + j; d[48896 + j] = D[191][j];}
D[192] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������馈愧溃坤昆捆困括扩廓阔垃拉喇蜡腊辣啦莱来赖蓝婪栏拦篮阑兰澜谰揽览懒缆烂滥琅榔狼廊郎朗浪捞劳牢老佬姥酪烙涝勒乐雷镭蕾磊累儡垒擂肋类泪棱楞冷厘梨犁黎篱狸离漓理李里鲤礼莉荔吏栗丽厉励砾历利傈例俐�".split("");
for(j = 0; j != D[192].length; ++j) if(D[192][j].charCodeAt(0) !== 0xFFFD) { e[D[192][j]] = 49152 + j; d[49152 + j] = D[192][j];}
D[193] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������痢立粒沥隶力璃哩俩联莲连镰廉怜涟帘敛脸链恋炼练粮凉梁粱良两辆量晾亮谅撩聊僚疗燎寥辽潦了撂镣廖料列裂烈劣猎琳林磷霖临邻鳞淋凛赁吝拎玲菱零龄铃伶羚凌灵陵岭领另令溜琉榴硫馏留刘瘤流柳六龙聋咙笼窿�".split("");
for(j = 0; j != D[193].length; ++j) if(D[193][j].charCodeAt(0) !== 0xFFFD) { e[D[193][j]] = 49408 + j; d[49408 + j] = D[193][j];}
D[194] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������隆垄拢陇楼娄搂篓漏陋芦卢颅庐炉掳卤虏鲁麓碌露路赂鹿潞禄录陆戮驴吕铝侣旅履屡缕虑氯律率滤绿峦挛孪滦卵乱掠略抡轮伦仑沦纶论萝螺罗逻锣箩骡裸落洛骆络妈麻玛码蚂马骂嘛吗埋买麦卖迈脉瞒馒蛮满蔓曼慢漫�".split("");
for(j = 0; j != D[194].length; ++j) if(D[194][j].charCodeAt(0) !== 0xFFFD) { e[D[194][j]] = 49664 + j; d[49664 + j] = D[194][j];}
D[195] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������谩芒茫盲氓忙莽猫茅锚毛矛铆卯茂冒帽貌贸么玫枚梅酶霉煤没眉媒镁每美昧寐妹媚门闷们萌蒙檬盟锰猛梦孟眯醚靡糜迷谜弥米秘觅泌蜜密幂棉眠绵冕免勉娩缅面苗描瞄藐秒渺庙妙蔑灭民抿皿敏悯闽明螟鸣铭名命谬摸�".split("");
for(j = 0; j != D[195].length; ++j) if(D[195][j].charCodeAt(0) !== 0xFFFD) { e[D[195][j]] = 49920 + j; d[49920 + j] = D[195][j];}
D[196] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������摹蘑模膜磨摩魔抹末莫墨默沫漠寞陌谋牟某拇牡亩姆母墓暮幕募慕木目睦牧穆拿哪呐钠那娜纳氖乃奶耐奈南男难囊挠脑恼闹淖呢馁内嫩能妮霓倪泥尼拟你匿腻逆溺蔫拈年碾撵捻念娘酿鸟尿捏聂孽啮镊镍涅您柠狞凝宁�".split("");
for(j = 0; j != D[196].length; ++j) if(D[196][j].charCodeAt(0) !== 0xFFFD) { e[D[196][j]] = 50176 + j; d[50176 + j] = D[196][j];}
D[197] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������拧泞牛扭钮纽脓浓农弄奴努怒女暖虐疟挪懦糯诺哦欧鸥殴藕呕偶沤啪趴爬帕怕琶拍排牌徘湃派攀潘盘磐盼畔判叛乓庞旁耪胖抛咆刨炮袍跑泡呸胚培裴赔陪配佩沛喷盆砰抨烹澎彭蓬棚硼篷膨朋鹏捧碰坯砒霹批披劈琵毗�".split("");
for(j = 0; j != D[197].length; ++j) if(D[197][j].charCodeAt(0) !== 0xFFFD) { e[D[197][j]] = 50432 + j; d[50432 + j] = D[197][j];}
D[198] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������啤脾疲皮匹痞僻屁譬篇偏片骗飘漂瓢票撇瞥拼频贫品聘乒坪苹萍平凭瓶评屏坡泼颇婆破魄迫粕剖扑铺仆莆葡菩蒲埔朴圃普浦谱曝瀑期欺栖戚妻七凄漆柒沏其棋奇歧畦崎脐齐旗祈祁骑起岂乞企启契砌器气迄弃汽泣讫掐�".split("");
for(j = 0; j != D[198].length; ++j) if(D[198][j].charCodeAt(0) !== 0xFFFD) { e[D[198][j]] = 50688 + j; d[50688 + j] = D[198][j];}
D[199] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������恰洽牵扦钎铅千迁签仟谦乾黔钱钳前潜遣浅谴堑嵌欠歉枪呛腔羌墙蔷强抢橇锹敲悄桥瞧乔侨巧鞘撬翘峭俏窍切茄且怯窃钦侵亲秦琴勤芹擒禽寝沁青轻氢倾卿清擎晴氰情顷请庆琼穷秋丘邱球求囚酋泅趋区蛆曲躯屈驱渠�".split("");
for(j = 0; j != D[199].length; ++j) if(D[199][j].charCodeAt(0) !== 0xFFFD) { e[D[199][j]] = 50944 + j; d[50944 + j] = D[199][j];}
D[200] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������取娶龋趣去圈颧权醛泉全痊拳犬券劝缺炔瘸却鹊榷确雀裙群然燃冉染瓤壤攘嚷让饶扰绕惹热壬仁人忍韧任认刃妊纫扔仍日戎茸蓉荣融熔溶容绒冗揉柔肉茹蠕儒孺如辱乳汝入褥软阮蕊瑞锐闰润若弱撒洒萨腮鳃塞赛三叁�".split("");
for(j = 0; j != D[200].length; ++j) if(D[200][j].charCodeAt(0) !== 0xFFFD) { e[D[200][j]] = 51200 + j; d[51200 + j] = D[200][j];}
D[201] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������伞散桑嗓丧搔骚扫嫂瑟色涩森僧莎砂杀刹沙纱傻啥煞筛晒珊苫杉山删煽衫闪陕擅赡膳善汕扇缮墒伤商赏晌上尚裳梢捎稍烧芍勺韶少哨邵绍奢赊蛇舌舍赦摄射慑涉社设砷申呻伸身深娠绅神沈审婶甚肾慎渗声生甥牲升绳�".split("");
for(j = 0; j != D[201].length; ++j) if(D[201][j].charCodeAt(0) !== 0xFFFD) { e[D[201][j]] = 51456 + j; d[51456 + j] = D[201][j];}
D[202] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������省盛剩胜圣师失狮施湿诗尸虱十石拾时什食蚀实识史矢使屎驶始式示士世柿事拭誓逝势是嗜噬适仕侍释饰氏市恃室视试收手首守寿授售受瘦兽蔬枢梳殊抒输叔舒淑疏书赎孰熟薯暑曙署蜀黍鼠属术述树束戍竖墅庶数漱�".split("");
for(j = 0; j != D[202].length; ++j) if(D[202][j].charCodeAt(0) !== 0xFFFD) { e[D[202][j]] = 51712 + j; d[51712 + j] = D[202][j];}
D[203] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������恕刷耍摔衰甩帅栓拴霜双爽谁水睡税吮瞬顺舜说硕朔烁斯撕嘶思私司丝死肆寺嗣四伺似饲巳松耸怂颂送宋讼诵搜艘擞嗽苏酥俗素速粟僳塑溯宿诉肃酸蒜算虽隋随绥髓碎岁穗遂隧祟孙损笋蓑梭唆缩琐索锁所塌他它她塔�".split("");
for(j = 0; j != D[203].length; ++j) if(D[203][j].charCodeAt(0) !== 0xFFFD) { e[D[203][j]] = 51968 + j; d[51968 + j] = D[203][j];}
D[204] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������獭挞蹋踏胎苔抬台泰酞太态汰坍摊贪瘫滩坛檀痰潭谭谈坦毯袒碳探叹炭汤塘搪堂棠膛唐糖倘躺淌趟烫掏涛滔绦萄桃逃淘陶讨套特藤腾疼誊梯剔踢锑提题蹄啼体替嚏惕涕剃屉天添填田甜恬舔腆挑条迢眺跳贴铁帖厅听烃�".split("");
for(j = 0; j != D[204].length; ++j) if(D[204][j].charCodeAt(0) !== 0xFFFD) { e[D[204][j]] = 52224 + j; d[52224 + j] = D[204][j];}
D[205] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������汀廷停亭庭挺艇通桐酮瞳同铜彤童桶捅筒统痛偷投头透凸秃突图徒途涂屠土吐兔湍团推颓腿蜕褪退吞屯臀拖托脱鸵陀驮驼椭妥拓唾挖哇蛙洼娃瓦袜歪外豌弯湾玩顽丸烷完碗挽晚皖惋宛婉万腕汪王亡枉网往旺望忘妄威�".split("");
for(j = 0; j != D[205].length; ++j) if(D[205][j].charCodeAt(0) !== 0xFFFD) { e[D[205][j]] = 52480 + j; d[52480 + j] = D[205][j];}
D[206] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������巍微危韦违桅围唯惟为潍维苇萎委伟伪尾纬未蔚味畏胃喂魏位渭谓尉慰卫瘟温蚊文闻纹吻稳紊问嗡翁瓮挝蜗涡窝我斡卧握沃巫呜钨乌污诬屋无芜梧吾吴毋武五捂午舞伍侮坞戊雾晤物勿务悟误昔熙析西硒矽晰嘻吸锡牺�".split("");
for(j = 0; j != D[206].length; ++j) if(D[206][j].charCodeAt(0) !== 0xFFFD) { e[D[206][j]] = 52736 + j; d[52736 + j] = D[206][j];}
D[207] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������稀息希悉膝夕惜熄烯溪汐犀檄袭席习媳喜铣洗系隙戏细瞎虾匣霞辖暇峡侠狭下厦夏吓掀锨先仙鲜纤咸贤衔舷闲涎弦嫌显险现献县腺馅羡宪陷限线相厢镶香箱襄湘乡翔祥详想响享项巷橡像向象萧硝霄削哮嚣销消宵淆晓�".split("");
for(j = 0; j != D[207].length; ++j) if(D[207][j].charCodeAt(0) !== 0xFFFD) { e[D[207][j]] = 52992 + j; d[52992 + j] = D[207][j];}
D[208] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������小孝校肖啸笑效楔些歇蝎鞋协挟携邪斜胁谐写械卸蟹懈泄泻谢屑薪芯锌欣辛新忻心信衅星腥猩惺兴刑型形邢行醒幸杏性姓兄凶胸匈汹雄熊休修羞朽嗅锈秀袖绣墟戌需虚嘘须徐许蓄酗叙旭序畜恤絮婿绪续轩喧宣悬旋玄�".split("");
for(j = 0; j != D[208].length; ++j) if(D[208][j].charCodeAt(0) !== 0xFFFD) { e[D[208][j]] = 53248 + j; d[53248 + j] = D[208][j];}
D[209] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������选癣眩绚靴薛学穴雪血勋熏循旬询寻驯巡殉汛训讯逊迅压押鸦鸭呀丫芽牙蚜崖衙涯雅哑亚讶焉咽阉烟淹盐严研蜒岩延言颜阎炎沿奄掩眼衍演艳堰燕厌砚雁唁彦焰宴谚验殃央鸯秧杨扬佯疡羊洋阳氧仰痒养样漾邀腰妖瑶�".split("");
for(j = 0; j != D[209].length; ++j) if(D[209][j].charCodeAt(0) !== 0xFFFD) { e[D[209][j]] = 53504 + j; d[53504 + j] = D[209][j];}
D[210] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������摇尧遥窑谣姚咬舀药要耀椰噎耶爷野冶也页掖业叶曳腋夜液一壹医揖铱依伊衣颐夷遗移仪胰疑沂宜姨彝椅蚁倚已乙矣以艺抑易邑屹亿役臆逸肄疫亦裔意毅忆义益溢诣议谊译异翼翌绎茵荫因殷音阴姻吟银淫寅饮尹引隐�".split("");
for(j = 0; j != D[210].length; ++j) if(D[210][j].charCodeAt(0) !== 0xFFFD) { e[D[210][j]] = 53760 + j; d[53760 + j] = D[210][j];}
D[211] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������印英樱婴鹰应缨莹萤营荧蝇迎赢盈影颖硬映哟拥佣臃痈庸雍踊蛹咏泳涌永恿勇用幽优悠忧尤由邮铀犹油游酉有友右佑釉诱又幼迂淤于盂榆虞愚舆余俞逾鱼愉渝渔隅予娱雨与屿禹宇语羽玉域芋郁吁遇喻峪御愈欲狱育誉�".split("");
for(j = 0; j != D[211].length; ++j) if(D[211][j].charCodeAt(0) !== 0xFFFD) { e[D[211][j]] = 54016 + j; d[54016 + j] = D[211][j];}
D[212] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������浴寓裕预豫驭鸳渊冤元垣袁原援辕园员圆猿源缘远苑愿怨院曰约越跃钥岳粤月悦阅耘云郧匀陨允运蕴酝晕韵孕匝砸杂栽哉灾宰载再在咱攒暂赞赃脏葬遭糟凿藻枣早澡蚤躁噪造皂灶燥责择则泽贼怎增憎曾赠扎喳渣札轧�".split("");
for(j = 0; j != D[212].length; ++j) if(D[212][j].charCodeAt(0) !== 0xFFFD) { e[D[212][j]] = 54272 + j; d[54272 + j] = D[212][j];}
D[213] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������铡闸眨栅榨咋乍炸诈摘斋宅窄债寨瞻毡詹粘沾盏斩辗崭展蘸栈占战站湛绽樟章彰漳张掌涨杖丈帐账仗胀瘴障招昭找沼赵照罩兆肇召遮折哲蛰辙者锗蔗这浙珍斟真甄砧臻贞针侦枕疹诊震振镇阵蒸挣睁征狰争怔整拯正政�".split("");
for(j = 0; j != D[213].length; ++j) if(D[213][j].charCodeAt(0) !== 0xFFFD) { e[D[213][j]] = 54528 + j; d[54528 + j] = D[213][j];}
D[214] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������帧症郑证芝枝支吱蜘知肢脂汁之织职直植殖执值侄址指止趾只旨纸志挚掷至致置帜峙制智秩稚质炙痔滞治窒中盅忠钟衷终种肿重仲众舟周州洲诌粥轴肘帚咒皱宙昼骤珠株蛛朱猪诸诛逐竹烛煮拄瞩嘱主著柱助蛀贮铸筑�".split("");
for(j = 0; j != D[214].length; ++j) if(D[214][j].charCodeAt(0) !== 0xFFFD) { e[D[214][j]] = 54784 + j; d[54784 + j] = D[214][j];}
D[215] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������住注祝驻抓爪拽专砖转撰赚篆桩庄装妆撞壮状椎锥追赘坠缀谆准捉拙卓桌琢茁酌啄着灼浊兹咨资姿滋淄孜紫仔籽滓子自渍字鬃棕踪宗综总纵邹走奏揍租足卒族祖诅阻组钻纂嘴醉最罪尊遵昨左佐柞做作坐座������".split("");
for(j = 0; j != D[215].length; ++j) if(D[215][j].charCodeAt(0) !== 0xFFFD) { e[D[215][j]] = 55040 + j; d[55040 + j] = D[215][j];}
D[216] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������亍丌兀丐廿卅丕亘丞鬲孬噩丨禺丿匕乇夭爻卮氐囟胤馗毓睾鼗丶亟鼐乜乩亓芈孛啬嘏仄厍厝厣厥厮靥赝匚叵匦匮匾赜卦卣刂刈刎刭刳刿剀剌剞剡剜蒯剽劂劁劐劓冂罔亻仃仉仂仨仡仫仞伛仳伢佤仵伥伧伉伫佞佧攸佚佝�".split("");
for(j = 0; j != D[216].length; ++j) if(D[216][j].charCodeAt(0) !== 0xFFFD) { e[D[216][j]] = 55296 + j; d[55296 + j] = D[216][j];}
D[217] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������佟佗伲伽佶佴侑侉侃侏佾佻侪佼侬侔俦俨俪俅俚俣俜俑俟俸倩偌俳倬倏倮倭俾倜倌倥倨偾偃偕偈偎偬偻傥傧傩傺僖儆僭僬僦僮儇儋仝氽佘佥俎龠汆籴兮巽黉馘冁夔勹匍訇匐凫夙兕亠兖亳衮袤亵脔裒禀嬴蠃羸冫冱冽冼�".split("");
for(j = 0; j != D[217].length; ++j) if(D[217][j].charCodeAt(0) !== 0xFFFD) { e[D[217][j]] = 55552 + j; d[55552 + j] = D[217][j];}
D[218] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������凇冖冢冥讠讦讧讪讴讵讷诂诃诋诏诎诒诓诔诖诘诙诜诟诠诤诨诩诮诰诳诶诹诼诿谀谂谄谇谌谏谑谒谔谕谖谙谛谘谝谟谠谡谥谧谪谫谮谯谲谳谵谶卩卺阝阢阡阱阪阽阼陂陉陔陟陧陬陲陴隈隍隗隰邗邛邝邙邬邡邴邳邶邺�".split("");
for(j = 0; j != D[218].length; ++j) if(D[218][j].charCodeAt(0) !== 0xFFFD) { e[D[218][j]] = 55808 + j; d[55808 + j] = D[218][j];}
D[219] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������邸邰郏郅邾郐郄郇郓郦郢郜郗郛郫郯郾鄄鄢鄞鄣鄱鄯鄹酃酆刍奂劢劬劭劾哿勐勖勰叟燮矍廴凵凼鬯厶弁畚巯坌垩垡塾墼壅壑圩圬圪圳圹圮圯坜圻坂坩垅坫垆坼坻坨坭坶坳垭垤垌垲埏垧垴垓垠埕埘埚埙埒垸埴埯埸埤埝�".split("");
for(j = 0; j != D[219].length; ++j) if(D[219][j].charCodeAt(0) !== 0xFFFD) { e[D[219][j]] = 56064 + j; d[56064 + j] = D[219][j];}
D[220] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������堋堍埽埭堀堞堙塄堠塥塬墁墉墚墀馨鼙懿艹艽艿芏芊芨芄芎芑芗芙芫芸芾芰苈苊苣芘芷芮苋苌苁芩芴芡芪芟苄苎芤苡茉苷苤茏茇苜苴苒苘茌苻苓茑茚茆茔茕苠苕茜荑荛荜茈莒茼茴茱莛荞茯荏荇荃荟荀茗荠茭茺茳荦荥�".split("");
for(j = 0; j != D[220].length; ++j) if(D[220][j].charCodeAt(0) !== 0xFFFD) { e[D[220][j]] = 56320 + j; d[56320 + j] = D[220][j];}
D[221] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������荨茛荩荬荪荭荮莰荸莳莴莠莪莓莜莅荼莶莩荽莸荻莘莞莨莺莼菁萁菥菘堇萘萋菝菽菖萜萸萑萆菔菟萏萃菸菹菪菅菀萦菰菡葜葑葚葙葳蒇蒈葺蒉葸萼葆葩葶蒌蒎萱葭蓁蓍蓐蓦蒽蓓蓊蒿蒺蓠蒡蒹蒴蒗蓥蓣蔌甍蔸蓰蔹蔟蔺�".split("");
for(j = 0; j != D[221].length; ++j) if(D[221][j].charCodeAt(0) !== 0xFFFD) { e[D[221][j]] = 56576 + j; d[56576 + j] = D[221][j];}
D[222] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������蕖蔻蓿蓼蕙蕈蕨蕤蕞蕺瞢蕃蕲蕻薤薨薇薏蕹薮薜薅薹薷薰藓藁藜藿蘧蘅蘩蘖蘼廾弈夼奁耷奕奚奘匏尢尥尬尴扌扪抟抻拊拚拗拮挢拶挹捋捃掭揶捱捺掎掴捭掬掊捩掮掼揲揸揠揿揄揞揎摒揆掾摅摁搋搛搠搌搦搡摞撄摭撖�".split("");
for(j = 0; j != D[222].length; ++j) if(D[222][j].charCodeAt(0) !== 0xFFFD) { e[D[222][j]] = 56832 + j; d[56832 + j] = D[222][j];}
D[223] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������摺撷撸撙撺擀擐擗擤擢攉攥攮弋忒甙弑卟叱叽叩叨叻吒吖吆呋呒呓呔呖呃吡呗呙吣吲咂咔呷呱呤咚咛咄呶呦咝哐咭哂咴哒咧咦哓哔呲咣哕咻咿哌哙哚哜咩咪咤哝哏哞唛哧唠哽唔哳唢唣唏唑唧唪啧喏喵啉啭啁啕唿啐唼�".split("");
for(j = 0; j != D[223].length; ++j) if(D[223][j].charCodeAt(0) !== 0xFFFD) { e[D[223][j]] = 57088 + j; d[57088 + j] = D[223][j];}
D[224] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������唷啖啵啶啷唳唰啜喋嗒喃喱喹喈喁喟啾嗖喑啻嗟喽喾喔喙嗪嗷嗉嘟嗑嗫嗬嗔嗦嗝嗄嗯嗥嗲嗳嗌嗍嗨嗵嗤辔嘞嘈嘌嘁嘤嘣嗾嘀嘧嘭噘嘹噗嘬噍噢噙噜噌噔嚆噤噱噫噻噼嚅嚓嚯囔囗囝囡囵囫囹囿圄圊圉圜帏帙帔帑帱帻帼�".split("");
for(j = 0; j != D[224].length; ++j) if(D[224][j].charCodeAt(0) !== 0xFFFD) { e[D[224][j]] = 57344 + j; d[57344 + j] = D[224][j];}
D[225] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������帷幄幔幛幞幡岌屺岍岐岖岈岘岙岑岚岜岵岢岽岬岫岱岣峁岷峄峒峤峋峥崂崃崧崦崮崤崞崆崛嵘崾崴崽嵬嵛嵯嵝嵫嵋嵊嵩嵴嶂嶙嶝豳嶷巅彳彷徂徇徉後徕徙徜徨徭徵徼衢彡犭犰犴犷犸狃狁狎狍狒狨狯狩狲狴狷猁狳猃狺�".split("");
for(j = 0; j != D[225].length; ++j) if(D[225][j].charCodeAt(0) !== 0xFFFD) { e[D[225][j]] = 57600 + j; d[57600 + j] = D[225][j];}
D[226] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������狻猗猓猡猊猞猝猕猢猹猥猬猸猱獐獍獗獠獬獯獾舛夥飧夤夂饣饧饨饩饪饫饬饴饷饽馀馄馇馊馍馐馑馓馔馕庀庑庋庖庥庠庹庵庾庳赓廒廑廛廨廪膺忄忉忖忏怃忮怄忡忤忾怅怆忪忭忸怙怵怦怛怏怍怩怫怊怿怡恸恹恻恺恂�".split("");
for(j = 0; j != D[226].length; ++j) if(D[226][j].charCodeAt(0) !== 0xFFFD) { e[D[226][j]] = 57856 + j; d[57856 + j] = D[226][j];}
D[227] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������恪恽悖悚悭悝悃悒悌悛惬悻悱惝惘惆惚悴愠愦愕愣惴愀愎愫慊慵憬憔憧憷懔懵忝隳闩闫闱闳闵闶闼闾阃阄阆阈阊阋阌阍阏阒阕阖阗阙阚丬爿戕氵汔汜汊沣沅沐沔沌汨汩汴汶沆沩泐泔沭泷泸泱泗沲泠泖泺泫泮沱泓泯泾�".split("");
for(j = 0; j != D[227].length; ++j) if(D[227][j].charCodeAt(0) !== 0xFFFD) { e[D[227][j]] = 58112 + j; d[58112 + j] = D[227][j];}
D[228] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������洹洧洌浃浈洇洄洙洎洫浍洮洵洚浏浒浔洳涑浯涞涠浞涓涔浜浠浼浣渚淇淅淞渎涿淠渑淦淝淙渖涫渌涮渫湮湎湫溲湟溆湓湔渲渥湄滟溱溘滠漭滢溥溧溽溻溷滗溴滏溏滂溟潢潆潇漤漕滹漯漶潋潴漪漉漩澉澍澌潸潲潼潺濑�".split("");
for(j = 0; j != D[228].length; ++j) if(D[228][j].charCodeAt(0) !== 0xFFFD) { e[D[228][j]] = 58368 + j; d[58368 + j] = D[228][j];}
D[229] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������濉澧澹澶濂濡濮濞濠濯瀚瀣瀛瀹瀵灏灞宀宄宕宓宥宸甯骞搴寤寮褰寰蹇謇辶迓迕迥迮迤迩迦迳迨逅逄逋逦逑逍逖逡逵逶逭逯遄遑遒遐遨遘遢遛暹遴遽邂邈邃邋彐彗彖彘尻咫屐屙孱屣屦羼弪弩弭艴弼鬻屮妁妃妍妩妪妣�".split("");
for(j = 0; j != D[229].length; ++j) if(D[229][j].charCodeAt(0) !== 0xFFFD) { e[D[229][j]] = 58624 + j; d[58624 + j] = D[229][j];}
D[230] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������妗姊妫妞妤姒妲妯姗妾娅娆姝娈姣姘姹娌娉娲娴娑娣娓婀婧婊婕娼婢婵胬媪媛婷婺媾嫫媲嫒嫔媸嫠嫣嫱嫖嫦嫘嫜嬉嬗嬖嬲嬷孀尕尜孚孥孳孑孓孢驵驷驸驺驿驽骀骁骅骈骊骐骒骓骖骘骛骜骝骟骠骢骣骥骧纟纡纣纥纨纩�".split("");
for(j = 0; j != D[230].length; ++j) if(D[230][j].charCodeAt(0) !== 0xFFFD) { e[D[230][j]] = 58880 + j; d[58880 + j] = D[230][j];}
D[231] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������纭纰纾绀绁绂绉绋绌绐绔绗绛绠绡绨绫绮绯绱绲缍绶绺绻绾缁缂缃缇缈缋缌缏缑缒缗缙缜缛缟缡缢缣缤缥缦缧缪缫缬缭缯缰缱缲缳缵幺畿巛甾邕玎玑玮玢玟珏珂珑玷玳珀珉珈珥珙顼琊珩珧珞玺珲琏琪瑛琦琥琨琰琮琬�".split("");
for(j = 0; j != D[231].length; ++j) if(D[231][j].charCodeAt(0) !== 0xFFFD) { e[D[231][j]] = 59136 + j; d[59136 + j] = D[231][j];}
D[232] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������琛琚瑁瑜瑗瑕瑙瑷瑭瑾璜璎璀璁璇璋璞璨璩璐璧瓒璺韪韫韬杌杓杞杈杩枥枇杪杳枘枧杵枨枞枭枋杷杼柰栉柘栊柩枰栌柙枵柚枳柝栀柃枸柢栎柁柽栲栳桠桡桎桢桄桤梃栝桕桦桁桧桀栾桊桉栩梵梏桴桷梓桫棂楮棼椟椠棹�".split("");
for(j = 0; j != D[232].length; ++j) if(D[232][j].charCodeAt(0) !== 0xFFFD) { e[D[232][j]] = 59392 + j; d[59392 + j] = D[232][j];}
D[233] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������椤棰椋椁楗棣椐楱椹楠楂楝榄楫榀榘楸椴槌榇榈槎榉楦楣楹榛榧榻榫榭槔榱槁槊槟榕槠榍槿樯槭樗樘橥槲橄樾檠橐橛樵檎橹樽樨橘橼檑檐檩檗檫猷獒殁殂殇殄殒殓殍殚殛殡殪轫轭轱轲轳轵轶轸轷轹轺轼轾辁辂辄辇辋�".split("");
for(j = 0; j != D[233].length; ++j) if(D[233][j].charCodeAt(0) !== 0xFFFD) { e[D[233][j]] = 59648 + j; d[59648 + j] = D[233][j];}
D[234] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������辍辎辏辘辚軎戋戗戛戟戢戡戥戤戬臧瓯瓴瓿甏甑甓攴旮旯旰昊昙杲昃昕昀炅曷昝昴昱昶昵耆晟晔晁晏晖晡晗晷暄暌暧暝暾曛曜曦曩贲贳贶贻贽赀赅赆赈赉赇赍赕赙觇觊觋觌觎觏觐觑牮犟牝牦牯牾牿犄犋犍犏犒挈挲掰�".split("");
for(j = 0; j != D[234].length; ++j) if(D[234][j].charCodeAt(0) !== 0xFFFD) { e[D[234][j]] = 59904 + j; d[59904 + j] = D[234][j];}
D[235] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������搿擘耄毪毳毽毵毹氅氇氆氍氕氘氙氚氡氩氤氪氲攵敕敫牍牒牖爰虢刖肟肜肓肼朊肽肱肫肭肴肷胧胨胩胪胛胂胄胙胍胗朐胝胫胱胴胭脍脎胲胼朕脒豚脶脞脬脘脲腈腌腓腴腙腚腱腠腩腼腽腭腧塍媵膈膂膑滕膣膪臌朦臊膻�".split("");
for(j = 0; j != D[235].length; ++j) if(D[235][j].charCodeAt(0) !== 0xFFFD) { e[D[235][j]] = 60160 + j; d[60160 + j] = D[235][j];}
D[236] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������臁膦欤欷欹歃歆歙飑飒飓飕飙飚殳彀毂觳斐齑斓於旆旄旃旌旎旒旖炀炜炖炝炻烀炷炫炱烨烊焐焓焖焯焱煳煜煨煅煲煊煸煺熘熳熵熨熠燠燔燧燹爝爨灬焘煦熹戾戽扃扈扉礻祀祆祉祛祜祓祚祢祗祠祯祧祺禅禊禚禧禳忑忐�".split("");
for(j = 0; j != D[236].length; ++j) if(D[236][j].charCodeAt(0) !== 0xFFFD) { e[D[236][j]] = 60416 + j; d[60416 + j] = D[236][j];}
D[237] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������怼恝恚恧恁恙恣悫愆愍慝憩憝懋懑戆肀聿沓泶淼矶矸砀砉砗砘砑斫砭砜砝砹砺砻砟砼砥砬砣砩硎硭硖硗砦硐硇硌硪碛碓碚碇碜碡碣碲碹碥磔磙磉磬磲礅磴礓礤礞礴龛黹黻黼盱眄眍盹眇眈眚眢眙眭眦眵眸睐睑睇睃睚睨�".split("");
for(j = 0; j != D[237].length; ++j) if(D[237][j].charCodeAt(0) !== 0xFFFD) { e[D[237][j]] = 60672 + j; d[60672 + j] = D[237][j];}
D[238] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������睢睥睿瞍睽瞀瞌瞑瞟瞠瞰瞵瞽町畀畎畋畈畛畲畹疃罘罡罟詈罨罴罱罹羁罾盍盥蠲钅钆钇钋钊钌钍钏钐钔钗钕钚钛钜钣钤钫钪钭钬钯钰钲钴钶钷钸钹钺钼钽钿铄铈铉铊铋铌铍铎铐铑铒铕铖铗铙铘铛铞铟铠铢铤铥铧铨铪�".split("");
for(j = 0; j != D[238].length; ++j) if(D[238][j].charCodeAt(0) !== 0xFFFD) { e[D[238][j]] = 60928 + j; d[60928 + j] = D[238][j];}
D[239] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������铩铫铮铯铳铴铵铷铹铼铽铿锃锂锆锇锉锊锍锎锏锒锓锔锕锖锘锛锝锞锟锢锪锫锩锬锱锲锴锶锷锸锼锾锿镂锵镄镅镆镉镌镎镏镒镓镔镖镗镘镙镛镞镟镝镡镢镤镥镦镧镨镩镪镫镬镯镱镲镳锺矧矬雉秕秭秣秫稆嵇稃稂稞稔�".split("");
for(j = 0; j != D[239].length; ++j) if(D[239][j].charCodeAt(0) !== 0xFFFD) { e[D[239][j]] = 61184 + j; d[61184 + j] = D[239][j];}
D[240] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������稹稷穑黏馥穰皈皎皓皙皤瓞瓠甬鸠鸢鸨鸩鸪鸫鸬鸲鸱鸶鸸鸷鸹鸺鸾鹁鹂鹄鹆鹇鹈鹉鹋鹌鹎鹑鹕鹗鹚鹛鹜鹞鹣鹦鹧鹨鹩鹪鹫鹬鹱鹭鹳疒疔疖疠疝疬疣疳疴疸痄疱疰痃痂痖痍痣痨痦痤痫痧瘃痱痼痿瘐瘀瘅瘌瘗瘊瘥瘘瘕瘙�".split("");
for(j = 0; j != D[240].length; ++j) if(D[240][j].charCodeAt(0) !== 0xFFFD) { e[D[240][j]] = 61440 + j; d[61440 + j] = D[240][j];}
D[241] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������瘛瘼瘢瘠癀瘭瘰瘿瘵癃瘾瘳癍癞癔癜癖癫癯翊竦穸穹窀窆窈窕窦窠窬窨窭窳衤衩衲衽衿袂袢裆袷袼裉裢裎裣裥裱褚裼裨裾裰褡褙褓褛褊褴褫褶襁襦襻疋胥皲皴矜耒耔耖耜耠耢耥耦耧耩耨耱耋耵聃聆聍聒聩聱覃顸颀颃�".split("");
for(j = 0; j != D[241].length; ++j) if(D[241][j].charCodeAt(0) !== 0xFFFD) { e[D[241][j]] = 61696 + j; d[61696 + j] = D[241][j];}
D[242] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������颉颌颍颏颔颚颛颞颟颡颢颥颦虍虔虬虮虿虺虼虻蚨蚍蚋蚬蚝蚧蚣蚪蚓蚩蚶蛄蚵蛎蚰蚺蚱蚯蛉蛏蚴蛩蛱蛲蛭蛳蛐蜓蛞蛴蛟蛘蛑蜃蜇蛸蜈蜊蜍蜉蜣蜻蜞蜥蜮蜚蜾蝈蜴蜱蜩蜷蜿螂蜢蝽蝾蝻蝠蝰蝌蝮螋蝓蝣蝼蝤蝙蝥螓螯螨蟒�".split("");
for(j = 0; j != D[242].length; ++j) if(D[242][j].charCodeAt(0) !== 0xFFFD) { e[D[242][j]] = 61952 + j; d[61952 + j] = D[242][j];}
D[243] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������蟆螈螅螭螗螃螫蟥螬螵螳蟋蟓螽蟑蟀蟊蟛蟪蟠蟮蠖蠓蟾蠊蠛蠡蠹蠼缶罂罄罅舐竺竽笈笃笄笕笊笫笏筇笸笪笙笮笱笠笥笤笳笾笞筘筚筅筵筌筝筠筮筻筢筲筱箐箦箧箸箬箝箨箅箪箜箢箫箴篑篁篌篝篚篥篦篪簌篾篼簏簖簋�".split("");
for(j = 0; j != D[243].length; ++j) if(D[243][j].charCodeAt(0) !== 0xFFFD) { e[D[243][j]] = 62208 + j; d[62208 + j] = D[243][j];}
D[244] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������簟簪簦簸籁籀臾舁舂舄臬衄舡舢舣舭舯舨舫舸舻舳舴舾艄艉艋艏艚艟艨衾袅袈裘裟襞羝羟羧羯羰羲籼敉粑粝粜粞粢粲粼粽糁糇糌糍糈糅糗糨艮暨羿翎翕翥翡翦翩翮翳糸絷綦綮繇纛麸麴赳趄趔趑趱赧赭豇豉酊酐酎酏酤�".split("");
for(j = 0; j != D[244].length; ++j) if(D[244][j].charCodeAt(0) !== 0xFFFD) { e[D[244][j]] = 62464 + j; d[62464 + j] = D[244][j];}
D[245] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������酢酡酰酩酯酽酾酲酴酹醌醅醐醍醑醢醣醪醭醮醯醵醴醺豕鹾趸跫踅蹙蹩趵趿趼趺跄跖跗跚跞跎跏跛跆跬跷跸跣跹跻跤踉跽踔踝踟踬踮踣踯踺蹀踹踵踽踱蹉蹁蹂蹑蹒蹊蹰蹶蹼蹯蹴躅躏躔躐躜躞豸貂貊貅貘貔斛觖觞觚觜�".split("");
for(j = 0; j != D[245].length; ++j) if(D[245][j].charCodeAt(0) !== 0xFFFD) { e[D[245][j]] = 62720 + j; d[62720 + j] = D[245][j];}
D[246] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������觥觫觯訾謦靓雩雳雯霆霁霈霏霎霪霭霰霾龀龃龅龆龇龈龉龊龌黾鼋鼍隹隼隽雎雒瞿雠銎銮鋈錾鍪鏊鎏鐾鑫鱿鲂鲅鲆鲇鲈稣鲋鲎鲐鲑鲒鲔鲕鲚鲛鲞鲟鲠鲡鲢鲣鲥鲦鲧鲨鲩鲫鲭鲮鲰鲱鲲鲳鲴鲵鲶鲷鲺鲻鲼鲽鳄鳅鳆鳇鳊鳋�".split("");
for(j = 0; j != D[246].length; ++j) if(D[246][j].charCodeAt(0) !== 0xFFFD) { e[D[246][j]] = 62976 + j; d[62976 + j] = D[246][j];}
D[247] = "�����������������������������������������������������������������������������������������������������������������������������������������������������������������鳌鳍鳎鳏鳐鳓鳔鳕鳗鳘鳙鳜鳝鳟鳢靼鞅鞑鞒鞔鞯鞫鞣鞲鞴骱骰骷鹘骶骺骼髁髀髅髂髋髌髑魅魃魇魉魈魍魑飨餍餮饕饔髟髡髦髯髫髻髭髹鬈鬏鬓鬟鬣麽麾縻麂麇麈麋麒鏖麝麟黛黜黝黠黟黢黩黧黥黪黯鼢鼬鼯鼹鼷鼽鼾齄�".split("");
for(j = 0; j != D[247].length; ++j) if(D[247][j].charCodeAt(0) !== 0xFFFD) { e[D[247][j]] = 63232 + j; d[63232 + j] = D[247][j];}
return {"enc": e, "dec": d }; })();
cptable[10029] = (function(){ var d = "\u0000\u0001\u0002\u0003\u0004\u0005\u0006\u0007\b\t\n\u000b\f\r\u000e\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~ÄĀāÉĄÖÜáąČäčĆćéŹźĎíďĒēĖóėôöõúĚěü†°Ę£§•¶ß®©™ę¨≠ģĮįĪ≤≥īĶ∂∑łĻļĽľĹĺŅņŃ¬√ńŇ∆«»… ňŐÕőŌ–—“”‘’÷◊ōŔŕŘ‹›řŖŗŠ‚„šŚśÁŤťÍŽžŪÓÔūŮÚůŰűŲųÝýķŻŁżĢˇ", D = [], e = {}; for(var i=0;i!=d.length;++i) { if(d.charCodeAt(i) !== 0xFFFD) e[d.charAt(i)] = i; D[i] = d.charAt(i); } return {"enc": e, "dec": D }; })();
cptable[10079] = (function(){ var d = "\u0000\u0001\u0002\u0003\u0004\u0005\u0006\u0007\b\t\n\u000b\f\r\u000e\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~ÄÅÇÉÑÖÜáàâäãåçéèêëíìîïñóòôöõúùûüÝ°¢£§•¶ß®©™´¨≠ÆØ∞±≤≥¥µ∂∑∏π∫ªºΩæø¿¡¬√ƒ≈∆«»… ÀÃÕŒœ–—“”‘’÷◊ÿŸ⁄¤ÐðÞþý·‚„‰ÂÊÁËÈÍÎÏÌÓÔ�ÒÚÛÙıˆ˜¯˘˙˚¸˝˛ˇ", D = [], e = {}; for(var i=0;i!=d.length;++i) { if(d.charCodeAt(i) !== 0xFFFD) e[d.charAt(i)] = i; D[i] = d.charAt(i); } return {"enc": e, "dec": D }; })();
cptable[10081] = (function(){ var d = "\u0000\u0001\u0002\u0003\u0004\u0005\u0006\u0007\b\t\n\u000b\f\r\u000e\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~ÄÅÇÉÑÖÜáàâäãåçéèêëíìîïñóòôöõúùûü†°¢£§•¶ß®©™´¨≠ÆØ∞±≤≥¥µ∂∑∏π∫ªºΩæø¿¡¬√ƒ≈∆«»… ÀÃÕŒœ–—“”‘’÷◊ÿŸĞğİıŞş‡·‚„‰ÂÊÁËÈÍÎÏÌÓÔ�ÒÚÛÙ�ˆ˜¯˘˙˚¸˝˛ˇ", D = [], e = {}; for(var i=0;i!=d.length;++i) { if(d.charCodeAt(i) !== 0xFFFD) e[d.charAt(i)] = i; D[i] = d.charAt(i); } return {"enc": e, "dec": D }; })();
cptable[28591] = (function(){ var d = "\u0000\u0001\u0002\u0003\u0004\u0005\u0006\u0007\b\t\n\u000b\f\r\u000e\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~ ¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ", D = [], e = {}; for(var i=0;i!=d.length;++i) { if(d.charCodeAt(i) !== 0xFFFD) e[d.charAt(i)] = i; D[i] = d.charAt(i); } return {"enc": e, "dec": D }; })();
// eslint-disable-next-line no-undef
if (typeof module !== 'undefined' && module.exports && typeof DO_NOT_EXPORT_CODEPAGE === 'undefined') module.exports = cptable;
/*! cputils.js (C) 2013-present SheetJS -- http://sheetjs.com */
/* vim: set ft=javascript: */
/*jshint newcap: false */
(function(root, factory) {
  /*jshint ignore:start */
  /*eslint-disable */
  "use strict";
  if(typeof cptable === "undefined") {
    if(typeof require !== "undefined"){
      var cpt = cptable;
      if (typeof module !== 'undefined' && module.exports && typeof DO_NOT_EXPORT_CODEPAGE === 'undefined') module.exports = factory(cpt);
      else root.cptable = factory(cpt);
    } else throw new Error("cptable not found");
  } else cptable = factory(cptable);
  /*eslint-enable */
  /*jshint ignore:end */
}(this, function(cpt){
  "use strict";
  /*global module, Buffer */
  var magic = {
    "1200":"utf16le",
    "1201":"utf16be",
    "12000":"utf32le",
    "12001":"utf32be",
    "16969":"utf64le",
    "20127":"ascii",
    "65000":"utf7",
    "65001":"utf8"
  };

  var sbcs_cache = [874,1250,1251,1252,1253,1254,1255,1256,10000];
  var dbcs_cache = [932,936,949,950];
  var magic_cache = [65001];
  var magic_decode = {};
  var magic_encode = {};
  var cpdcache = {};
  var cpecache = {};

  var sfcc = function sfcc(x) { return String.fromCharCode(x); };
  var cca = function cca(x) { return x.charCodeAt(0); };

  var has_buf = (typeof Buffer !== 'undefined');
  var Buffer_from = function(){};
  if(has_buf) {
    var nbfs = !Buffer.from;
    if(!nbfs) try { Buffer.from("foo", "utf8"); } catch(e) { nbfs = true; }
    Buffer_from = nbfs ? function(buf, enc) { return (enc) ? new Buffer(buf, enc) : new Buffer(buf); } : Buffer.from.bind(Buffer);
    // $FlowIgnore
    if(!Buffer.allocUnsafe) Buffer.allocUnsafe = function(n) { return new Buffer(n); };

    var mdl = 1024, mdb = Buffer.allocUnsafe(mdl);
    var make_EE = function make_EE(E){
      var EE = Buffer.allocUnsafe(65536);
      for(var i = 0; i < 65536;++i) EE[i] = 0;
      var keys = Object.keys(E), len = keys.length;
      for(var ee = 0, e = keys[ee]; ee < len; ++ee) {
        if(!(e = keys[ee])) continue;
        EE[e.charCodeAt(0)] = E[e];
      }
      return EE;
    };
    var sbcs_encode = function make_sbcs_encode(cp) {
      var EE = make_EE(cpt[cp].enc);
      return function sbcs_e(data, ofmt) {
        var len = data.length;
        var out, i=0, j=0, D=0, w=0;
        if(typeof data === 'string') {
          out = Buffer.allocUnsafe(len);
          for(i = 0; i < len; ++i) out[i] = EE[data.charCodeAt(i)];
        } else if(Buffer.isBuffer(data)) {
          out = Buffer.allocUnsafe(2*len);
          j = 0;
          for(i = 0; i < len; ++i) {
            D = data[i];
            if(D < 128) out[j++] = EE[D];
            else if(D < 224) { out[j++] = EE[((D&31)<<6)+(data[i+1]&63)]; ++i; }
            else if(D < 240) { out[j++] = EE[((D&15)<<12)+((data[i+1]&63)<<6)+(data[i+2]&63)]; i+=2; }
            else {
              w = ((D&7)<<18)+((data[i+1]&63)<<12)+((data[i+2]&63)<<6)+(data[i+3]&63); i+=3;
              if(w < 65536) out[j++] = EE[w];
              else { w -= 65536; out[j++] = EE[0xD800 + ((w>>10)&1023)]; out[j++] = EE[0xDC00 + (w&1023)]; }
            }
          }
          out = out.slice(0,j);
        } else {
          out = Buffer.allocUnsafe(len);
          for(i = 0; i < len; ++i) out[i] = EE[data[i].charCodeAt(0)];
        }
        if(!ofmt || ofmt === 'buf') return out;
        if(ofmt !== 'arr') return out.toString('binary');
        return [].slice.call(out);
      };
    };
    var sbcs_decode = function make_sbcs_decode(cp) {
      var D = cpt[cp].dec;
      var DD = Buffer.allocUnsafe(131072), d=0, c="";
      for(d=0;d<D.length;++d) {
        if(!(c=D[d])) continue;
        var w = c.charCodeAt(0);
        DD[2*d] = w&255; DD[2*d+1] = w>>8;
      }
      return function sbcs_d(data) {
        var len = data.length, i=0, j=0;
        if(2 * len > mdl) { mdl = 2 * len; mdb = Buffer.allocUnsafe(mdl); }
        if(Buffer.isBuffer(data)) {
          for(i = 0; i < len; i++) {
            j = 2*data[i];
            mdb[2*i] = DD[j]; mdb[2*i+1] = DD[j+1];
          }
        } else if(typeof data === "string") {
          for(i = 0; i < len; i++) {
            j = 2*data.charCodeAt(i);
            mdb[2*i] = DD[j]; mdb[2*i+1] = DD[j+1];
          }
        } else {
          for(i = 0; i < len; i++) {
            j = 2*data[i];
            mdb[2*i] = DD[j]; mdb[2*i+1] = DD[j+1];
          }
        }
        return mdb.slice(0, 2 * len).toString('ucs2');
      };
    };
    var dbcs_encode = function make_dbcs_encode(cp) {
      var E = cpt[cp].enc;
      var EE = Buffer.allocUnsafe(131072);
      for(var i = 0; i < 131072; ++i) EE[i] = 0;
      var keys = Object.keys(E);
      for(var ee = 0, e = keys[ee]; ee < keys.length; ++ee) {
        if(!(e = keys[ee])) continue;
        var f = e.charCodeAt(0);
        EE[2*f] = E[e] & 255; EE[2*f+1] = E[e]>>8;
      }
      return function dbcs_e(data, ofmt) {
        var len = data.length, out = Buffer.allocUnsafe(2*len), i=0, j=0, jj=0, k=0, D=0;
        if(typeof data === 'string') {
          for(i = k = 0; i < len; ++i) {
            j = data.charCodeAt(i)*2;
            out[k++] = EE[j+1] || EE[j]; if(EE[j+1] > 0) out[k++] = EE[j];
          }
          out = out.slice(0,k);
        } else if(Buffer.isBuffer(data)) {
          for(i = k = 0; i < len; ++i) {
            D = data[i];
            if(D < 128) j = D;
            else if(D < 224) { j = ((D&31)<<6)+(data[i+1]&63); ++i; }
            else if(D < 240) { j = ((D&15)<<12)+((data[i+1]&63)<<6)+(data[i+2]&63); i+=2; }
            else { j = ((D&7)<<18)+((data[i+1]&63)<<12)+((data[i+2]&63)<<6)+(data[i+3]&63); i+=3; }
            if(j<65536) { j*=2; out[k++] = EE[j+1] || EE[j]; if(EE[j+1] > 0) out[k++] = EE[j]; }
            else { jj = j-65536;
              j=2*(0xD800 + ((jj>>10)&1023)); out[k++] = EE[j+1] || EE[j]; if(EE[j+1] > 0) out[k++] = EE[j];
              j=2*(0xDC00 + (jj&1023)); out[k++] = EE[j+1] || EE[j]; if(EE[j+1] > 0) out[k++] = EE[j];
            }
          }
          out = out.slice(0,k);
        } else {
          for(i = k = 0; i < len; i++) {
            j = data[i].charCodeAt(0)*2;
            out[k++] = EE[j+1] || EE[j]; if(EE[j+1] > 0) out[k++] = EE[j];
          }
        }
        if(!ofmt || ofmt === 'buf') return out;
        if(ofmt !== 'arr') return out.toString('binary');
        return [].slice.call(out);
      };
    };
    var dbcs_decode = function make_dbcs_decode(cp) {
      var D = cpt[cp].dec;
      var DD = Buffer.allocUnsafe(131072), d=0, c, w=0, j=0, i=0;
      for(i = 0; i < 65536; ++i) { DD[2*i] = 0xFF; DD[2*i+1] = 0xFD;}
      for(d = 0; d < D.length; ++d) {
        if(!(c=D[d])) continue;
        w = c.charCodeAt(0);
        j = 2*d;
        DD[j] = w&255; DD[j+1] = w>>8;
      }
      return function dbcs_d(data) {
        var len = data.length, out = Buffer.allocUnsafe(2*len), i=0, j=0, k=0;
        if(Buffer.isBuffer(data)) {
          for(i = 0; i < len; i++) {
            j = 2*data[i];
            if(DD[j]===0xFF && DD[j+1]===0xFD) { j=2*((data[i]<<8)+data[i+1]); ++i; }
            out[k++] = DD[j]; out[k++] = DD[j+1];
          }
        } else if(typeof data === "string") {
          for(i = 0; i < len; i++) {
            j = 2*data.charCodeAt(i);
            if(DD[j]===0xFF && DD[j+1]===0xFD) { j=2*((data.charCodeAt(i)<<8)+data.charCodeAt(i+1)); ++i; }
            out[k++] = DD[j]; out[k++] = DD[j+1];
          }
        } else {
          for(i = 0; i < len; i++) {
            j = 2*data[i];
            if(DD[j]===0xFF && DD[j+1]===0xFD) { j=2*((data[i]<<8)+data[i+1]); ++i; }
            out[k++] = DD[j]; out[k++] = DD[j+1];
          }
        }
        return out.slice(0,k).toString('ucs2');
      };
    };
    magic_decode[65001] = function utf8_d(data) {
      if(typeof data === "string") return utf8_d(data.split("").map(cca));
      var len = data.length, w = 0, ww = 0;
      if(4 * len > mdl) { mdl = 4 * len; mdb = Buffer.allocUnsafe(mdl); }
      var i = 0;
      if(len >= 3 && data[0] == 0xEF) if(data[1] == 0xBB && data[2] == 0xBF) i = 3;
      for(var j = 1, k = 0, D = 0; i < len; i+=j) {
        j = 1; D = data[i];
        if(D < 128) w = D;
        else if(D < 224) { w=(D&31)*64+(data[i+1]&63); j=2; }
        else if(D < 240) { w=((D&15)<<12)+(data[i+1]&63)*64+(data[i+2]&63); j=3; }
        else { w=(D&7)*262144+((data[i+1]&63)<<12)+(data[i+2]&63)*64+(data[i+3]&63); j=4; }
        if(w < 65536) { mdb[k++] = w&255; mdb[k++] = w>>8; }
        else {
          w -= 65536; ww = 0xD800 + ((w>>10)&1023); w = 0xDC00 + (w&1023);
          mdb[k++] = ww&255; mdb[k++] = ww>>>8; mdb[k++] = w&255; mdb[k++] = (w>>>8)&255;
        }
      }
      return mdb.slice(0,k).toString('ucs2');
    };
    magic_encode[65001] = function utf8_e(data, ofmt) {
      if(has_buf && Buffer.isBuffer(data)) {
        if(!ofmt || ofmt === 'buf') return data;
        if(ofmt !== 'arr') return data.toString('binary');
        return [].slice.call(data);
      }
      var len = data.length, w = 0, ww = 0, j = 0;
      var direct = typeof data === "string";
      if(4 * len > mdl) { mdl = 4 * len; mdb = Buffer.allocUnsafe(mdl); }
      for(var i = 0; i < len; ++i) {
        w = direct ? data.charCodeAt(i) : data[i].charCodeAt(0);
        if(w <= 0x007F) mdb[j++] = w;
        else if(w <= 0x07FF) {
          mdb[j++] = 192 + (w >> 6);
          mdb[j++] = 128 + (w&63);
        } else if(w >= 0xD800 && w <= 0xDFFF) {
          w -= 0xD800; ++i;
          ww = (direct ? data.charCodeAt(i) : data[i].charCodeAt(0)) - 0xDC00 + (w << 10);
          mdb[j++] = 240 + ((ww>>>18) & 0x07);
          mdb[j++] = 144 + ((ww>>>12) & 0x3F);
          mdb[j++] = 128 + ((ww>>>6) & 0x3F);
          mdb[j++] = 128 + (ww & 0x3F);
        } else {
          mdb[j++] = 224 + (w >> 12);
          mdb[j++] = 128 + ((w >> 6)&63);
          mdb[j++] = 128 + (w&63);
        }
      }
      if(!ofmt || ofmt === 'buf') return mdb.slice(0,j);
      if(ofmt !== 'arr') return mdb.slice(0,j).toString('binary');
      return [].slice.call(mdb, 0, j);
    };
  }

  var encache = function encache() {
    if(has_buf) {
      if(cpdcache[sbcs_cache[0]]) return;
      var i=0, s=0;
      for(i = 0; i < sbcs_cache.length; ++i) {
        s = sbcs_cache[i];
        if(cpt[s]) {
          cpdcache[s] = sbcs_decode(s);
          cpecache[s] = sbcs_encode(s);
        }
      }
      for(i = 0; i < dbcs_cache.length; ++i) {
        s = dbcs_cache[i];
        if(cpt[s]) {
          cpdcache[s] = dbcs_decode(s);
          cpecache[s] = dbcs_encode(s);
        }
      }
      for(i = 0; i < magic_cache.length; ++i) {
        s = magic_cache[i];
        if(magic_decode[s]) cpdcache[s] = magic_decode[s];
        if(magic_encode[s]) cpecache[s] = magic_encode[s];
      }
    }
  };
  var null_enc = function(data, ofmt) { void ofmt; return ""; };
  var cp_decache = function cp_decache(cp) { delete cpdcache[cp]; delete cpecache[cp]; };
  var decache = function decache() {
    if(has_buf) {
      if(!cpdcache[sbcs_cache[0]]) return;
      sbcs_cache.forEach(cp_decache);
      dbcs_cache.forEach(cp_decache);
      magic_cache.forEach(cp_decache);
    }
    last_enc = null_enc; last_cp = 0;
  };
  var cache = {
    encache: encache,
    decache: decache,
    sbcs: sbcs_cache,
    dbcs: dbcs_cache
  };

  encache();

  var BM = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
  var SetD = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'(),-./:?";
  var last_enc = null_enc, last_cp = 0;
  var encode = function encode(cp, data, ofmt) {
    if(cp === last_cp && last_enc) { return last_enc(data, ofmt); }
    if(cpecache[cp]) { last_enc = cpecache[last_cp=cp]; return last_enc(data, ofmt); }
    if(has_buf && Buffer.isBuffer(data)) data = data.toString('utf8');
    var len = data.length;
    var out = has_buf ? Buffer.allocUnsafe(4*len) : [], w=0, i=0, j = 0, ww=0;
    var C = cpt[cp], E, M = "";
    var isstr = typeof data === 'string';
    if(C && (E=C.enc)) for(i = 0; i < len; ++i, ++j) {
      w = E[isstr? data.charAt(i) : data[i]];
      if(w > 255) {
        out[j] = w>>8;
        out[++j] = w&255;
      } else out[j] = w&255;
    }
    else if((M=magic[cp])) switch(M) {
      case "utf8":
        if(has_buf && isstr) { out = Buffer_from(data, M); j = out.length; break; }
        for(i = 0; i < len; ++i, ++j) {
          w = isstr ? data.charCodeAt(i) : data[i].charCodeAt(0);
          if(w <= 0x007F) out[j] = w;
          else if(w <= 0x07FF) {
            out[j]   = 192 + (w >> 6);
            out[++j] = 128 + (w&63);
          } else if(w >= 0xD800 && w <= 0xDFFF) {
            w -= 0xD800;
            ww = (isstr ? data.charCodeAt(++i) : data[++i].charCodeAt(0)) - 0xDC00 + (w << 10);
            out[j]   = 240 + ((ww>>>18) & 0x07);
            out[++j] = 144 + ((ww>>>12) & 0x3F);
            out[++j] = 128 + ((ww>>>6) & 0x3F);
            out[++j] = 128 + (ww & 0x3F);
          } else {
            out[j]   = 224 + (w >> 12);
            out[++j] = 128 + ((w >> 6)&63);
            out[++j] = 128 + (w&63);
          }
        }
        break;
      case "ascii":
        if(has_buf && typeof data === "string") { out = Buffer_from(data, M); j = out.length; break; }
        for(i = 0; i < len; ++i, ++j) {
          w = isstr ? data.charCodeAt(i) : data[i].charCodeAt(0);
          if(w <= 0x007F) out[j] = w;
          else throw new Error("bad ascii " + w);
        }
        break;
      case "utf16le":
        if(has_buf && typeof data === "string") { out = Buffer_from(data, M); j = out.length; break; }
        for(i = 0; i < len; ++i) {
          w = isstr ? data.charCodeAt(i) : data[i].charCodeAt(0);
          out[j++] = w&255;
          out[j++] = w>>8;
        }
        break;
      case "utf16be":
        for(i = 0; i < len; ++i) {
          w = isstr ? data.charCodeAt(i) : data[i].charCodeAt(0);
          out[j++] = w>>8;
          out[j++] = w&255;
        }
        break;
      case "utf32le":
        for(i = 0; i < len; ++i) {
          w = isstr ? data.charCodeAt(i) : data[i].charCodeAt(0);
          if(w >= 0xD800 && w <= 0xDFFF) w = 0x10000 + ((w - 0xD800) << 10) + (data[++i].charCodeAt(0) - 0xDC00);
          out[j++] = w&255; w >>= 8;
          out[j++] = w&255; w >>= 8;
          out[j++] = w&255; w >>= 8;
          out[j++] = w&255;
        }
        break;
      case "utf32be":
        for(i = 0; i < len; ++i) {
          w = isstr ? data.charCodeAt(i) : data[i].charCodeAt(0);
          if(w >= 0xD800 && w <= 0xDFFF) w = 0x10000 + ((w - 0xD800) << 10) + (data[++i].charCodeAt(0) - 0xDC00);
          out[j+3] = w&255; w >>= 8;
          out[j+2] = w&255; w >>= 8;
          out[j+1] = w&255; w >>= 8;
          out[j] = w&255;
          j+=4;
        }
        break;
      case "utf7":
        for(i = 0; i < len; i++) {
          var c = isstr ? data.charAt(i) : data[i].charAt(0);
          if(c === "+") { out[j++] = 0x2b; out[j++] = 0x2d; continue; }
          if(SetD.indexOf(c) > -1) { out[j++] = c.charCodeAt(0); continue; }
          var tt = encode(1201, c);
          out[j++] = 0x2b;
          out[j++] = BM.charCodeAt(tt[0]>>2);
          out[j++] = BM.charCodeAt(((tt[0]&0x03)<<4) + ((tt[1]||0)>>4));
          out[j++] = BM.charCodeAt(((tt[1]&0x0F)<<2) + ((tt[2]||0)>>6));
          out[j++] = 0x2d;
        }
        break;
      default: throw new Error("Unsupported magic: " + cp + " " + magic[cp]);
    }
    else throw new Error("Unrecognized CP: " + cp);
    out = out.slice(0,j);
    if(!has_buf) return (ofmt == 'str') ? (out).map(sfcc).join("") : out;
    if(!ofmt || ofmt === 'buf') return out;
    if(ofmt !== 'arr') return out.toString('binary');
    return [].slice.call(out);
  };
  var decode = function decode(cp, data) {
    var F; if((F=cpdcache[cp])) return F(data);
    if(typeof data === "string") return decode(cp, data.split("").map(cca));
    var len = data.length, out = new Array(len), s="", w=0, i=0, j=1, k=0, ww=0;
    var C = cpt[cp], D, M="";
    if(C && (D=C.dec)) {
      for(i = 0; i < len; i+=j) {
        j = 2;
        s = D[(data[i]<<8)+ data[i+1]];
        if(!s) {
          j = 1;
          s = D[data[i]];
        }
        if(!s) throw new Error('Unrecognized code: ' + data[i] + ' ' + data[i+j-1] + ' ' + i + ' ' + j + ' ' + D[data[i]]);
        out[k++] = s;
      }
    }
    else if((M=magic[cp])) switch(M) {
      case "utf8":
        if(len >= 3 && data[0] == 0xEF) if(data[1] == 0xBB && data[2] == 0xBF) i = 3;
        for(; i < len; i+=j) {
          j = 1;
          if(data[i] < 128) w = data[i];
          else if(data[i] < 224) { w=(data[i]&31)*64+(data[i+1]&63); j=2; }
          else if(data[i] < 240) { w=((data[i]&15)<<12)+(data[i+1]&63)*64+(data[i+2]&63); j=3; }
          else { w=(data[i]&7)*262144+((data[i+1]&63)<<12)+(data[i+2]&63)*64+(data[i+3]&63); j=4; }
          if(w < 65536) { out[k++] = String.fromCharCode(w); }
          else {
            w -= 65536; ww = 0xD800 + ((w>>10)&1023); w = 0xDC00 + (w&1023);
            out[k++] = String.fromCharCode(ww); out[k++] = String.fromCharCode(w);
          }
        }
        break;
      case "ascii":
        if(has_buf && Buffer.isBuffer(data)) return data.toString(M);
        for(i = 0; i < len; i++) out[i] = String.fromCharCode(data[i]);
        k = len; break;
      case "utf16le":
        if(len >= 2 && data[0] == 0xFF) if(data[1] == 0xFE) i = 2;
        if(has_buf && Buffer.isBuffer(data)) return data.toString(M);
        j = 2;
        for(; i+1 < len; i+=j) {
          out[k++] = String.fromCharCode((data[i+1]<<8) + data[i]);
        }
        break;
      case "utf16be":
        if(len >= 2 && data[0] == 0xFE) if(data[1] == 0xFF) i = 2;
        j = 2;
        for(; i+1 < len; i+=j) {
          out[k++] = String.fromCharCode((data[i]<<8) + data[i+1]);
        }
        break;
      case "utf32le":
        if(len >= 4 && data[0] == 0xFF) if(data[1] == 0xFE && data[2] === 0 && data[3] === 0) i = 4;
        j = 4;
        for(; i < len; i+=j) {
          w = (data[i+3]<<24) + (data[i+2]<<16) + (data[i+1]<<8) + (data[i]);
          if(w > 0xFFFF) {
            w -= 0x10000;
            out[k++] = String.fromCharCode(0xD800 + ((w >> 10) & 0x3FF));
            out[k++] = String.fromCharCode(0xDC00 + (w & 0x3FF));
          }
          else out[k++] = String.fromCharCode(w);
        }
        break;
      case "utf32be":
        if(len >= 4 && data[3] == 0xFF) if(data[2] == 0xFE && data[1] === 0 && data[0] === 0) i = 4;
        j = 4;
        for(; i < len; i+=j) {
          w = (data[i]<<24) + (data[i+1]<<16) + (data[i+2]<<8) + (data[i+3]);
          if(w > 0xFFFF) {
            w -= 0x10000;
            out[k++] = String.fromCharCode(0xD800 + ((w >> 10) & 0x3FF));
            out[k++] = String.fromCharCode(0xDC00 + (w & 0x3FF));
          }
          else out[k++] = String.fromCharCode(w);
        }
        break;
      case "utf7":
        if(len >= 4 && data[0] == 0x2B && data[1] == 0x2F && data[2] == 0x76) {
          if(len >= 5 && data[3] == 0x38 && data[4] == 0x2D) i = 5;
          else if(data[3] == 0x38 || data[3] == 0x39 || data[3] == 0x2B || data[3] == 0x2F) i = 4;
        }
        for(; i < len; i+=j) {
          if(data[i] !== 0x2b) { j=1; out[k++] = String.fromCharCode(data[i]); continue; }
          j=1;
          if(data[i+1] === 0x2d) { j = 2; out[k++] = "+"; continue; }
          // eslint-disable-next-line no-useless-escape
          while(String.fromCharCode(data[i+j]).match(/[A-Za-z0-9+\/]/)) j++;
          var dash = 0;
          if(data[i+j] === 0x2d) { ++j; dash=1; }
          var tt = [];
          var o64 = "";
          var c1=0, c2=0, c3=0;
          var e1=0, e2=0, e3=0, e4=0;
          for(var l = 1; l < j - dash;) {
            e1 = BM.indexOf(String.fromCharCode(data[i+l++]));
            e2 = BM.indexOf(String.fromCharCode(data[i+l++]));
            c1 = e1 << 2 | e2 >> 4;
            tt.push(c1);
            e3 = BM.indexOf(String.fromCharCode(data[i+l++]));
            if(e3 === -1) break;
            c2 = (e2 & 15) << 4 | e3 >> 2;
            tt.push(c2);
            e4 = BM.indexOf(String.fromCharCode(data[i+l++]));
            if(e4 === -1) break;
            c3 = (e3 & 3) << 6 | e4;
            if(e4 < 64) tt.push(c3);
          }
          o64 = decode(1201, tt);
          for(l = 0; l < o64.length; ++l) out[k++] = o64.charAt(l);
        }
        break;
      default: throw new Error("Unsupported magic: " + cp + " " + magic[cp]);
    }
    else throw new Error("Unrecognized CP: " + cp);
    return out.slice(0,k).join("");
  };
  var hascp = function hascp(cp) { return !!(cpt[cp] || magic[cp]); };
  cpt.utils = { decode: decode, encode: encode, hascp: hascp, magic: magic, cache:cache };
  return cpt;
}));

}).call(this,require("buffer").Buffer)

},{"buffer":2}],11:[function(require,module,exports){
(function (process,Buffer){
/* xlsx-js-style 1.2.0-beta @ 2022-04-05T01:40:40.843Z */
var XLSX={};function make_xlsx_lib(a){a.version="0.18.5",a.style_version="1.2.0";var re,f=1200,_=1252;"undefined"!=typeof cptable?re=cptable:"undefined"!=typeof module&&"undefined"!=typeof require&&(re=require("./cpexcel.js"));var t=[874,932,936,949,950,1250,1251,1252,1253,1254,1255,1256,1257,1258,1e4],l={0:1252,1:65001,2:65001,77:1e4,128:932,129:949,130:1361,134:936,136:950,161:1253,162:1254,163:1258,177:1255,178:1256,186:1257,204:1251,222:874,238:1250,255:1252,69:6969},c=function(e){-1!=t.indexOf(e)&&(_=l[0]=e)};var ie=function(e){c(f=e)};function h(){ie(1200),c(1252)}function ae(e){for(var t=[],r=0,a=e.length;r<a;++r)t[r]=e.charCodeAt(r);return t}function s(e){for(var t=[],r=0;r<e.length>>1;++r)t[r]=String.fromCharCode(e.charCodeAt(2*r+1)+(e.charCodeAt(2*r)<<8));return t.join("")}var ne=function(e){var t=e.charCodeAt(0),r=e.charCodeAt(1);return 255==t&&254==r?function(e){for(var t=[],r=0;r<e.length>>1;++r)t[r]=String.fromCharCode(e.charCodeAt(2*r)+(e.charCodeAt(2*r+1)<<8));return t.join("")}(e.slice(2)):254==t&&255==r?s(e.slice(2)):65279==t?e.slice(1):e},u=function(e){return String.fromCharCode(e)},n=function(e){return String.fromCharCode(e)};void 0!==re&&(ie=function(e){c(f=e)},ne=function(e){return 255===e.charCodeAt(0)&&254===e.charCodeAt(1)?re.utils.decode(1200,ae(e.slice(2))):e},u=function(e){return 1200===f?String.fromCharCode(e):re.utils.decode(f,[255&e,e>>8])[0]},n=function(e){return re.utils.decode(_,[e])[0]});var oe=null,d=!0,p="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";function ee(e){for(var t,r,a,n,s,i="",o=0,c=0,l=0;l<e.length;)n=(t=e.charCodeAt(l++))>>2,s=(3&t)<<4|(r=e.charCodeAt(l++))>>4,o=(15&r)<<2|(a=e.charCodeAt(l++))>>6,c=63&a,isNaN(r)?o=c=64:isNaN(a)&&(c=64),i+=p.charAt(n)+p.charAt(s)+p.charAt(o)+p.charAt(c);return i}function te(e){var t,r,a,n,s,i,o="";e=e.replace(/[^\w\+\/\=]/g,"");for(var c=0;c<e.length;)t=p.indexOf(e.charAt(c++))<<2|(n=p.indexOf(e.charAt(c++)))>>4,o+=String.fromCharCode(t),r=(15&n)<<4|(s=p.indexOf(e.charAt(c++)))>>2,64!==s&&(o+=String.fromCharCode(r)),a=(3&s)<<6|(i=p.indexOf(e.charAt(c++))),64!==i&&(o+=String.fromCharCode(a));return o}var se="undefined"!=typeof Buffer&&"undefined"!=typeof process&&void 0!==process.versions&&!!process.versions.node,ce=function(){if("undefined"==typeof Buffer)return function(){};var t=!Buffer.from;if(!t)try{Buffer.from("foo","utf8")}catch(e){t=!0}return t?function(e,t){return t?new Buffer(e,t):new Buffer(e)}:Buffer.from.bind(Buffer)}();function le(e){return se?Buffer.alloc?Buffer.alloc(e):new Buffer(e):new("undefined"!=typeof Uint8Array?Uint8Array:Array)(e)}function fe(e){return se?Buffer.allocUnsafe?Buffer.allocUnsafe(e):new Buffer(e):new("undefined"!=typeof Uint8Array?Uint8Array:Array)(e)}var he=function(e){return se?ce(e,"binary"):e.split("").map(function(e){return 255&e.charCodeAt(0)})};function o(e){if("undefined"==typeof ArrayBuffer)return he(e);for(var t=new ArrayBuffer(e.length),r=new Uint8Array(t),a=0;a!=e.length;++a)r[a]=255&e.charCodeAt(a);return t}function i(e){if(Array.isArray(e))return e.map(function(e){return String.fromCharCode(e)}).join("");for(var t=[],r=0;r<e.length;++r)t[r]=String.fromCharCode(e[r]);return t.join("")}function m(e){if("undefined"==typeof ArrayBuffer)throw new Error("Unsupported");if(e instanceof ArrayBuffer)return m(new Uint8Array(e));for(var t=new Array(e.length),r=0;r<e.length;++r)t[r]=e[r];return t}var ue=se?function(e){return Buffer.concat(e.map(function(e){return Buffer.isBuffer(e)?e:ce(e)}))}:function(e){if("undefined"==typeof Uint8Array)return[].concat.apply([],e.map(function(e){return Array.isArray(e)?e:[].slice.call(e)}));for(var t=0,r=0,t=0;t<e.length;++t)r+=e[t].length;for(var a,n=new Uint8Array(r),r=t=0;t<e.length;r+=a,++t)if(a=e[t].length,e[t]instanceof Uint8Array)n.set(e[t],r);else{if("string"==typeof e[t])throw"wtf";n.set(new Uint8Array(e[t]),r)}return n};var de=/\u0000/g,pe=/[\u0001-\u0006]/g;function v(e){for(var t="",r=e.length-1;0<=r;)t+=e.charAt(r--);return t}function x(e,t){e=""+e;return t<=e.length?e:Ge("0",t-e.length)+e}function w(e,t){e=""+e;return t<=e.length?e:Ge(" ",t-e.length)+e}function T(e,t){e=""+e;return t<=e.length?e:e+Ge(" ",t-e.length)}var g=Math.pow(2,32);function E(e,t){if(g<e||e<-g)return r=e,a=t,r=""+Math.round(r),a<=r.length?r:Ge("0",a-r.length)+r;var r,a,e=Math.round(e);return(t=t)<=(e=""+(e=e)).length?e:Ge("0",t-e.length)+e}function A(e,t){return t=t||0,e.length>=7+t&&103==(32|e.charCodeAt(t))&&101==(32|e.charCodeAt(t+1))&&110==(32|e.charCodeAt(t+2))&&101==(32|e.charCodeAt(t+3))&&114==(32|e.charCodeAt(t+4))&&97==(32|e.charCodeAt(t+5))&&108==(32|e.charCodeAt(t+6))}var C=[["Sun","Sunday"],["Mon","Monday"],["Tue","Tuesday"],["Wed","Wednesday"],["Thu","Thursday"],["Fri","Friday"],["Sat","Saturday"]],R=[["J","Jan","January"],["F","Feb","February"],["M","Mar","March"],["A","Apr","April"],["M","May","May"],["J","Jun","June"],["J","Jul","July"],["A","Aug","August"],["S","Sep","September"],["O","Oct","October"],["N","Nov","November"],["D","Dec","December"]];var me={0:"General",1:"0",2:"0.00",3:"#,##0",4:"#,##0.00",9:"0%",10:"0.00%",11:"0.00E+00",12:"# ?/?",13:"# ??/??",14:"m/d/yy",15:"d-mmm-yy",16:"d-mmm",17:"mmm-yy",18:"h:mm AM/PM",19:"h:mm:ss AM/PM",20:"h:mm",21:"h:mm:ss",22:"m/d/yy h:mm",37:"#,##0 ;(#,##0)",38:"#,##0 ;[Red](#,##0)",39:"#,##0.00;(#,##0.00)",40:"#,##0.00;[Red](#,##0.00)",45:"mm:ss",46:"[h]:mm:ss",47:"mmss.0",48:"##0.0E+0",49:"@",56:'"上午/下午 "hh"時"mm"分"ss"秒 "'},b={5:37,6:38,7:39,8:40,23:0,24:0,25:0,26:0,27:14,28:14,29:14,30:14,31:14,50:14,51:14,52:14,53:14,54:14,55:14,56:14,57:14,58:14,59:1,60:2,61:3,62:4,67:9,68:10,69:12,70:13,71:14,72:14,73:15,74:16,75:17,76:20,77:21,78:22,79:45,80:46,81:47,82:0},k={5:'"$"#,##0_);\\("$"#,##0\\)',63:'"$"#,##0_);\\("$"#,##0\\)',6:'"$"#,##0_);[Red]\\("$"#,##0\\)',64:'"$"#,##0_);[Red]\\("$"#,##0\\)',7:'"$"#,##0.00_);\\("$"#,##0.00\\)',65:'"$"#,##0.00_);\\("$"#,##0.00\\)',8:'"$"#,##0.00_);[Red]\\("$"#,##0.00\\)',66:'"$"#,##0.00_);[Red]\\("$"#,##0.00\\)',41:'_(* #,##0_);_(* \\(#,##0\\);_(* "-"_);_(@_)',42:'_("$"* #,##0_);_("$"* \\(#,##0\\);_("$"* "-"_);_(@_)',43:'_(* #,##0.00_);_(* \\(#,##0.00\\);_(* "-"??_);_(@_)',44:'_("$"* #,##0.00_);_("$"* \\(#,##0.00\\);_("$"* "-"??_);_(@_)'};function y(e,t,r){for(var a=e<0?-1:1,n=e*a,s=0,i=1,o=0,c=1,l=0,f=0,h=Math.floor(n);l<t&&(o=(h=Math.floor(n))*i+s,f=h*l+c,!(n-h<5e-8));)n=1/(n-h),s=i,i=o,c=l,l=f;if(t<f&&(o=t<l?(f=c,s):(f=l,i)),!r)return[0,a*o,f];r=Math.floor(a*o/f);return[r,a*o-r*f,f]}function L(e,t,r){if(2958465<e||e<0)return null;var a=0|e,n=Math.floor(86400*(e-a)),s=0,i=[],e={D:a,T:n,u:86400*(e-a)-n,y:0,m:0,d:0,H:0,M:0,S:0,q:0};return Math.abs(e.u)<1e-6&&(e.u=0),t&&t.date1904&&(a+=1462),.9999<e.u&&(e.u=0,86400==++n&&(e.T=n=0,++a,++e.D)),60===a?(i=r?[1317,10,29]:[1900,2,29],s=3):0===a?(i=r?[1317,8,29]:[1900,1,0],s=6):(60<a&&--a,(t=new Date(1900,0,1)).setDate(t.getDate()+a-1),i=[t.getFullYear(),t.getMonth()+1,t.getDate()],s=t.getDay(),a<60&&(s=(s+6)%7),r&&(s=function(e,t){t[0]-=581;t=e.getDay();e<60&&(t=(t+6)%7);return t}(t,i))),e.y=i[0],e.m=i[1],e.d=i[2],e.S=n%60,n=Math.floor(n/60),e.M=n%60,n=Math.floor(n/60),e.H=n,e.q=s,e}var S=new Date(1899,11,31,0,0,0),O=S.getTime(),I=new Date(1900,2,1,0,0,0);function N(e,t){var r=e.getTime();return t?r-=1262304e5:I<=e&&(r+=864e5),(r-(O+6e4*(e.getTimezoneOffset()-S.getTimezoneOffset())))/864e5}function F(e){return-1==e.indexOf(".")?e:e.replace(/(?:\.0*|(\.\d*[1-9])0+)$/,"$1")}function D(e){var t,r,a,n=Math.floor(Math.log(Math.abs(e))*Math.LOG10E),s=-4<=n&&n<=-1?e.toPrecision(10+n):Math.abs(n)<=9?(r=(t=e)<0?12:11,(a=F(t.toFixed(12))).length<=r||(a=t.toPrecision(10)).length<=r?a:t.toExponential(5)):10===n?e.toFixed(10).substr(0,12):(s=F((e=e).toFixed(11))).length>(e<0?12:11)||"0"===s||"-0"===s?e.toPrecision(6):s;return F(-1==(s=s.toUpperCase()).indexOf("E")?s:s.replace(/(?:\.0*|(\.\d*[1-9])0+)[Ee]/,"$1E").replace(/(E[+-])(\d)$/,"$10$2"))}function P(e,t){switch(typeof e){case"string":return e;case"boolean":return e?"TRUE":"FALSE";case"number":return(0|e)===e?e.toString(10):D(e);case"undefined":return"";case"object":if(null==e)return"";if(e instanceof Date)return ve(14,N(e,t&&t.date1904),t)}throw new Error("unsupported value in General format: "+e)}function M(e){if(e.length<=3)return e;for(var t=e.length%3,r=e.substr(0,t);t!=e.length;t+=3)r+=(0<r.length?",":"")+e.substr(t,3);return r}var U=/%/g;var B=/# (\?+)( ?)\/( ?)(\d+)/;var W=/^#*0*\.([0#]+)/,H=/\).*[0#]/,z=/\(###\) ###\\?-####/;function V(e){for(var t,r="",a=0;a!=e.length;++a)switch(t=e.charCodeAt(a)){case 35:break;case 63:r+=" ";break;case 48:r+="0";break;default:r+=String.fromCharCode(t)}return r}function G(e,t){t=Math.pow(10,t);return""+Math.round(e*t)/t}function j(e,t){var r=e-Math.floor(e),e=Math.pow(10,t);return t<(""+Math.round(r*e)).length?0:Math.round(r*e)}function X(e,t,r){if(40===e.charCodeAt(0)&&!t.match(H)){var a=t.replace(/\( */,"").replace(/ \)/,"").replace(/\)/,"");return 0<=r?X("n",a,r):"("+X("n",a,-r)+")"}if(44===t.charCodeAt(t.length-1))return function(e,t,r){for(var a=t.length-1;44===t.charCodeAt(a-1);)--a;return K(e,t.substr(0,a),r/Math.pow(10,3*(t.length-a)))}(e,t,r);if(-1!==t.indexOf("%"))return o=e,l=r,c=(f=t).replace(U,""),f=f.length-c.length,K(o,c,l*Math.pow(10,2*f))+Ge("%",f);var n;if(-1!==t.indexOf("E"))return function e(t,r){var a,n=t.indexOf("E")-t.indexOf(".")-1;if(t.match(/^#+0.0E\+0$/)){if(0==r)return"0.0E+0";if(r<0)return"-"+e(t,-r);var s=t.indexOf(".");-1===s&&(s=t.indexOf("E"));var i=Math.floor(Math.log(r)*Math.LOG10E)%s;if(i<0&&(i+=s),-1===(a=(r/Math.pow(10,i)).toPrecision(1+n+(s+i)%s)).indexOf("e")){var o=Math.floor(Math.log(r)*Math.LOG10E);for(-1===a.indexOf(".")?a=a.charAt(0)+"."+a.substr(1)+"E+"+(o-a.length+i):a+="E+"+(o-i);"0."===a.substr(0,2);)a=(a=a.charAt(0)+a.substr(2,s)+"."+a.substr(2+s)).replace(/^0+([1-9])/,"$1").replace(/^0+\./,"0.");a=a.replace(/\+-/,"-")}a=a.replace(/^([+-]?)(\d*)\.(\d*)[Ee]/,function(e,t,r,a){return t+r+a.substr(0,(s+i)%s)+"."+a.substr(i)+"E"})}else a=r.toExponential(n);return t.match(/E\+00$/)&&a.match(/e[+-]\d$/)&&(a=a.substr(0,a.length-1)+"0"+a.charAt(a.length-1)),(a=t.match(/E\-/)&&a.match(/e\+/)?a.replace(/e\+/,"e"):a).replace("e","E")}(t,r);if(36===t.charCodeAt(0))return"$"+X(e,t.substr(" "==t.charAt(1)?2:1),r);var s,i,o,c,l,f,h,u=Math.abs(r),d=r<0?"-":"";if(t.match(/^00+$/))return d+E(u,t.length);if(t.match(/^[#?]+$/))return(n="0"===(n=E(r,0))?"":n).length>t.length?n:V(t.substr(0,t.length-n.length))+n;if(s=t.match(B))return h=s,o=u,c=d,l=parseInt(h[4],10),f=Math.round(o*l),o=Math.floor(f/l),l,c+(0===o?"":""+o)+" "+(0==(f-=o*l)?Ge(" ",h[1].length+1+h[4].length):w(f,h[1].length)+h[2]+"/"+h[3]+x(l,h[4].length));if(t.match(/^#+0+$/))return d+E(u,t.length-t.indexOf("0"));if(s=t.match(W))return n=G(r,s[1].length).replace(/^([^\.]+)$/,"$1."+V(s[1])).replace(/\.$/,"."+V(s[1])).replace(/\.(\d*)$/,function(e,t){return"."+t+Ge("0",V(s[1]).length-t.length)}),-1!==t.indexOf("0.")?n:n.replace(/^0\./,".");if(t=t.replace(/^#+([0.])/,"$1"),s=t.match(/^(0*)\.(#*)$/))return d+G(u,s[2].length).replace(/\.(\d*[1-9])0*$/,".$1").replace(/^(-?\d*)$/,"$1.").replace(/^0\./,s[1].length?"0.":".");if(s=t.match(/^#{1,3},##0(\.?)$/))return d+M(E(u,0));if(s=t.match(/^#,##0\.([#0]*0)$/))return r<0?"-"+X(e,t,-r):M(""+(Math.floor(r)+(h=r,(p=s[1].length)<(""+Math.round((h-Math.floor(h))*Math.pow(10,p))).length?1:0)))+"."+x(j(r,s[1].length),s[1].length);if(s=t.match(/^#,#*,#0/))return X(e,t.replace(/^#,#*,/,""),r);if(s=t.match(/^([0#]+)(\\?-([0#]+))+$/))return n=v(X(e,t.replace(/[\\-]/g,""),r)),i=0,v(v(t.replace(/\\/g,"")).replace(/[0#]/g,function(e){return i<n.length?n.charAt(i++):"0"===e?"0":""}));if(t.match(z))return"("+(n=X(e,"##########",r)).substr(0,3)+") "+n.substr(3,3)+"-"+n.substr(6);var p="";if(s=t.match(/^([#0?]+)( ?)\/( ?)([#0?]+)/))return i=Math.min(s[4].length,7),m=y(u,Math.pow(10,i)-1,!1),n=d," "==(p=K("n",s[1],m[1])).charAt(p.length-1)&&(p=p.substr(0,p.length-1)+"0"),n+=p+s[2]+"/"+s[3],(p=T(m[2],i)).length<s[4].length&&(p=V(s[4].substr(s[4].length-p.length))+p),n+=p;if(s=t.match(/^# ([#0?]+)( ?)\/( ?)([#0?]+)/))return i=Math.min(Math.max(s[1].length,s[4].length),7),d+((m=y(u,Math.pow(10,i)-1,!0))[0]||(m[1]?"":"0"))+" "+(m[1]?w(m[1],i)+s[2]+"/"+s[3]+T(m[2],i):Ge(" ",2*i+1+s[2].length+s[3].length));if(s=t.match(/^[#0?]+$/))return n=E(r,0),t.length<=n.length?n:V(t.substr(0,t.length-n.length))+n;if(s=t.match(/^([#0?]+)\.([#0]+)$/)){n=""+r.toFixed(Math.min(s[2].length,10)).replace(/([^0])0+$/,"$1"),i=n.indexOf(".");var m=t.indexOf(".")-i,g=t.length-n.length-m;return V(t.substr(0,m)+n+t.substr(t.length-g))}if(s=t.match(/^00,000\.([#0]*0)$/))return i=j(r,s[1].length),r<0?"-"+X(e,t,-r):M((g=r)<2147483647&&-2147483648<g?""+(0<=g?0|g:g-1|0):""+Math.floor(g)).replace(/^\d,\d{3}$/,"0$&").replace(/^\d*$/,function(e){return"00,"+(e.length<3?x(0,3-e.length):"")+e})+"."+x(i,s[1].length);switch(t){case"###,##0.00":return X(e,"#,##0.00",r);case"###,###":case"##,###":case"#,###":var b=M(E(u,0));return"0"!==b?d+b:"";case"###,###.00":return X(e,"###,##0.00",r).replace(/^0\./,".");case"#,###.00":return X(e,"#,##0.00",r).replace(/^0\./,".")}throw new Error("unsupported format |"+t+"|")}function Y(e,t,r){if(40===e.charCodeAt(0)&&!t.match(H)){var a=t.replace(/\( */,"").replace(/ \)/,"").replace(/\)/,"");return 0<=r?Y("n",a,r):"("+Y("n",a,-r)+")"}if(44===t.charCodeAt(t.length-1))return function(e,t,r){for(var a=t.length-1;44===t.charCodeAt(a-1);)--a;return K(e,t.substr(0,a),r/Math.pow(10,3*(t.length-a)))}(e,t,r);if(-1!==t.indexOf("%"))return n=e,i=r,a=(s=t).replace(U,""),s=s.length-a.length,K(n,a,i*Math.pow(10,2*s))+Ge("%",s);var n,s,i,o;if(-1!==t.indexOf("E"))return function e(t,r){var a,n=t.indexOf("E")-t.indexOf(".")-1;if(t.match(/^#+0.0E\+0$/)){if(0==r)return"0.0E+0";if(r<0)return"-"+e(t,-r);var s=t.indexOf(".");-1===s&&(s=t.indexOf("E"));var i,o=Math.floor(Math.log(r)*Math.LOG10E)%s;o<0&&(o+=s),(a=(r/Math.pow(10,o)).toPrecision(1+n+(s+o)%s)).match(/[Ee]/)||(i=Math.floor(Math.log(r)*Math.LOG10E),-1===a.indexOf(".")?a=a.charAt(0)+"."+a.substr(1)+"E+"+(i-a.length+o):a+="E+"+(i-o),a=a.replace(/\+-/,"-")),a=a.replace(/^([+-]?)(\d*)\.(\d*)[Ee]/,function(e,t,r,a){return t+r+a.substr(0,(s+o)%s)+"."+a.substr(o)+"E"})}else a=r.toExponential(n);return t.match(/E\+00$/)&&a.match(/e[+-]\d$/)&&(a=a.substr(0,a.length-1)+"0"+a.charAt(a.length-1)),(a=t.match(/E\-/)&&a.match(/e\+/)?a.replace(/e\+/,"e"):a).replace("e","E")}(t,r);if(36===t.charCodeAt(0))return"$"+Y(e,t.substr(" "==t.charAt(1)?2:1),r);var c,l,f=Math.abs(r),h=r<0?"-":"";if(t.match(/^00+$/))return h+x(f,t.length);if(t.match(/^[#?]+$/))return(o=0===r?"":""+r).length>t.length?o:V(t.substr(0,t.length-o.length))+o;if(c=t.match(B))return h+(0===(u=f)?"":""+u)+Ge(" ",(u=c)[1].length+2+u[4].length);if(t.match(/^#+0+$/))return h+x(f,t.length-t.indexOf("0"));if(c=t.match(W))return o=(o=(""+r).replace(/^([^\.]+)$/,"$1."+V(c[1])).replace(/\.$/,"."+V(c[1]))).replace(/\.(\d*)$/,function(e,t){return"."+t+Ge("0",V(c[1]).length-t.length)}),-1!==t.indexOf("0.")?o:o.replace(/^0\./,".");if(t=t.replace(/^#+([0.])/,"$1"),c=t.match(/^(0*)\.(#*)$/))return h+(""+f).replace(/\.(\d*[1-9])0*$/,".$1").replace(/^(-?\d*)$/,"$1.").replace(/^0\./,c[1].length?"0.":".");if(c=t.match(/^#{1,3},##0(\.?)$/))return h+M(""+f);if(c=t.match(/^#,##0\.([#0]*0)$/))return r<0?"-"+Y(e,t,-r):M(""+r)+"."+Ge("0",c[1].length);if(c=t.match(/^#,#*,#0/))return Y(e,t.replace(/^#,#*,/,""),r);if(c=t.match(/^([0#]+)(\\?-([0#]+))+$/))return o=v(Y(e,t.replace(/[\\-]/g,""),r)),l=0,v(v(t.replace(/\\/g,"")).replace(/[0#]/g,function(e){return l<o.length?o.charAt(l++):"0"===e?"0":""}));if(t.match(z))return"("+(o=Y(e,"##########",r)).substr(0,3)+") "+o.substr(3,3)+"-"+o.substr(6);var u="";if(c=t.match(/^([#0?]+)( ?)\/( ?)([#0?]+)/))return l=Math.min(c[4].length,7),d=y(f,Math.pow(10,l)-1,!1),o=h," "==(u=K("n",c[1],d[1])).charAt(u.length-1)&&(u=u.substr(0,u.length-1)+"0"),o+=u+c[2]+"/"+c[3],(u=T(d[2],l)).length<c[4].length&&(u=V(c[4].substr(c[4].length-u.length))+u),o+=u;if(c=t.match(/^# ([#0?]+)( ?)\/( ?)([#0?]+)/))return l=Math.min(Math.max(c[1].length,c[4].length),7),h+((d=y(f,Math.pow(10,l)-1,!0))[0]||(d[1]?"":"0"))+" "+(d[1]?w(d[1],l)+c[2]+"/"+c[3]+T(d[2],l):Ge(" ",2*l+1+c[2].length+c[3].length));if(c=t.match(/^[#0?]+$/))return o=""+r,t.length<=o.length?o:V(t.substr(0,t.length-o.length))+o;if(c=t.match(/^([#0]+)\.([#0]+)$/)){o=""+r.toFixed(Math.min(c[2].length,10)).replace(/([^0])0+$/,"$1"),l=o.indexOf(".");var u=t.indexOf(".")-l,d=t.length-o.length-u;return V(t.substr(0,u)+o+t.substr(t.length-d))}if(c=t.match(/^00,000\.([#0]*0)$/))return r<0?"-"+Y(e,t,-r):M(""+r).replace(/^\d,\d{3}$/,"0$&").replace(/^\d*$/,function(e){return"00,"+(e.length<3?x(0,3-e.length):"")+e})+"."+x(0,c[1].length);switch(t){case"###,###":case"##,###":case"#,###":var p=M(""+f);return"0"!==p?h+p:"";default:if(t.match(/\.[0#?]*$/))return Y(e,t.slice(0,t.lastIndexOf(".")),r)+V(t.slice(t.lastIndexOf(".")))}throw new Error("unsupported format |"+t+"|")}function K(e,t,r){return((0|r)===r?Y:X)(e,t,r)}var J=/\[[HhMmSs\u0E0A\u0E19\u0E17]*\]/;function q(e){for(var t=0,r="",a="";t<e.length;)switch(r=e.charAt(t)){case"G":A(e,t)&&(t+=6),t++;break;case'"':for(;34!==e.charCodeAt(++t)&&t<e.length;);++t;break;case"\\":case"_":t+=2;break;case"@":++t;break;case"B":case"b":if("1"===e.charAt(t+1)||"2"===e.charAt(t+1))return!0;case"M":case"D":case"Y":case"H":case"S":case"E":case"m":case"d":case"y":case"h":case"s":case"e":case"g":return!0;case"A":case"a":case"上":if("A/P"===e.substr(t,3).toUpperCase())return!0;if("AM/PM"===e.substr(t,5).toUpperCase())return!0;if("上午/下午"===e.substr(t,5).toUpperCase())return!0;++t;break;case"[":for(a=r;"]"!==e.charAt(t++)&&t<e.length;)a+=e.charAt(t);if(a.match(J))return!0;break;case".":case"0":case"#":for(;t<e.length&&(-1<"0#?.,E+-%".indexOf(r=e.charAt(++t))||"\\"==r&&"-"==e.charAt(t+1)&&-1<"0#".indexOf(e.charAt(t+2))););break;case"?":for(;e.charAt(++t)===r;);break;case"*":++t," "!=e.charAt(t)&&"*"!=e.charAt(t)||++t;break;case"(":case")":++t;break;case"1":case"2":case"3":case"4":case"5":case"6":case"7":case"8":case"9":for(;t<e.length&&-1<"0123456789".indexOf(e.charAt(++t)););break;case" ":default:++t}return!1}function Z(e,t,r,a){for(var n,s,i,o=[],c="",l=0,f="",h="t",u="H";l<e.length;)switch(f=e.charAt(l)){case"G":if(!A(e,l))throw new Error("unrecognized character "+f+" in "+e);o[o.length]={t:"G",v:"General"},l+=7;break;case'"':for(c="";34!==(i=e.charCodeAt(++l))&&l<e.length;)c+=String.fromCharCode(i);o[o.length]={t:"t",v:c},++l;break;case"\\":var d=e.charAt(++l),p="("===d||")"===d?d:"t";o[o.length]={t:p,v:d},++l;break;case"_":o[o.length]={t:"t",v:" "},l+=2;break;case"@":o[o.length]={t:"T",v:t},++l;break;case"B":case"b":if("1"===e.charAt(l+1)||"2"===e.charAt(l+1)){if(null==n&&null==(n=L(t,r,"2"===e.charAt(l+1))))return"";o[o.length]={t:"X",v:e.substr(l,2)},h=f,l+=2;break}case"M":case"D":case"Y":case"H":case"S":case"E":f=f.toLowerCase();case"m":case"d":case"y":case"h":case"s":case"e":case"g":if(t<0)return"";if(null==n&&null==(n=L(t,r)))return"";for(c=f;++l<e.length&&e.charAt(l).toLowerCase()===f;)c+=f;"h"===(f="m"===f&&"h"===h.toLowerCase()?"M":f)&&(f=u),o[o.length]={t:f,v:c},h=f;break;case"A":case"a":case"上":d={t:f,v:f};if(null==n&&(n=L(t,r)),"A/P"===e.substr(l,3).toUpperCase()?(null!=n&&(d.v=12<=n.H?"P":"A"),d.t="T",u="h",l+=3):"AM/PM"===e.substr(l,5).toUpperCase()?(null!=n&&(d.v=12<=n.H?"PM":"AM"),d.t="T",l+=5,u="h"):"上午/下午"===e.substr(l,5).toUpperCase()?(null!=n&&(d.v=12<=n.H?"下午":"上午"),d.t="T",l+=5,u="h"):(d.t="t",++l),null==n&&"T"===d.t)return"";o[o.length]=d,h=f;break;case"[":for(c=f;"]"!==e.charAt(l++)&&l<e.length;)c+=e.charAt(l);if("]"!==c.slice(-1))throw'unterminated "[" block: |'+c+"|";if(c.match(J)){if(null==n&&null==(n=L(t,r)))return"";o[o.length]={t:"Z",v:c.toLowerCase()},h=c.charAt(1)}else-1<c.indexOf("$")&&(c=(c.match(/\$([^-\[\]]*)/)||[])[1]||"$",q(e)||(o[o.length]={t:"t",v:c}));break;case".":if(null!=n){for(c=f;++l<e.length&&"0"===(f=e.charAt(l));)c+=f;o[o.length]={t:"s",v:c};break}case"0":case"#":for(c=f;++l<e.length&&-1<"0#?.,E+-%".indexOf(f=e.charAt(l));)c+=f;o[o.length]={t:"n",v:c};break;case"?":for(c=f;e.charAt(++l)===f;)c+=f;o[o.length]={t:f,v:c},h=f;break;case"*":++l," "!=e.charAt(l)&&"*"!=e.charAt(l)||++l;break;case"(":case")":o[o.length]={t:1===a?"t":f,v:f},++l;break;case"1":case"2":case"3":case"4":case"5":case"6":case"7":case"8":case"9":for(c=f;l<e.length&&-1<"0123456789".indexOf(e.charAt(++l));)c+=e.charAt(l);o[o.length]={t:"D",v:c};break;case" ":o[o.length]={t:f,v:f},++l;break;case"$":o[o.length]={t:"t",v:"$"},++l;break;default:if(-1===",$-+/():!^&'~{}<>=€acfijklopqrtuvwxzP".indexOf(f))throw new Error("unrecognized character "+f+" in "+e);o[o.length]={t:"t",v:f},++l}var m,g=0,b=0;for(l=o.length-1,h="t";0<=l;--l)switch(o[l].t){case"h":case"H":o[l].t=u,h="h",g<1&&(g=1);break;case"s":(m=o[l].v.match(/\.0+$/))&&(b=Math.max(b,m[0].length-1)),g<3&&(g=3);case"d":case"y":case"M":case"e":h=o[l].t;break;case"m":"s"===h&&(o[l].t="M",g<2&&(g=2));break;case"X":break;case"Z":(g=(g=g<1&&o[l].v.match(/[Hh]/)?1:g)<2&&o[l].v.match(/[Mm]/)?2:g)<3&&o[l].v.match(/[Ss]/)&&(g=3)}switch(g){case 0:break;case 1:.5<=n.u&&(n.u=0,++n.S),60<=n.S&&(n.S=0,++n.M),60<=n.M&&(n.M=0,++n.H);break;case 2:.5<=n.u&&(n.u=0,++n.S),60<=n.S&&(n.S=0,++n.M)}var v,w="";for(l=0;l<o.length;++l)switch(o[l].t){case"t":case"T":case" ":case"D":break;case"X":o[l].v="",o[l].t=";";break;case"d":case"m":case"y":case"h":case"H":case"M":case"s":case"e":case"b":case"Z":o[l].v=function(e,t,r,a){var n,s="",i=0,o=0,c=r.y,l=0;switch(e){case 98:c=r.y+543;case 121:switch(t.length){case 1:case 2:n=c%100,l=2;break;default:n=c%1e4,l=4}break;case 109:switch(t.length){case 1:case 2:n=r.m,l=t.length;break;case 3:return R[r.m-1][1];case 5:return R[r.m-1][0];default:return R[r.m-1][2]}break;case 100:switch(t.length){case 1:case 2:n=r.d,l=t.length;break;case 3:return C[r.q][0];default:return C[r.q][1]}break;case 104:switch(t.length){case 1:case 2:n=1+(r.H+11)%12,l=t.length;break;default:throw"bad hour format: "+t}break;case 72:switch(t.length){case 1:case 2:n=r.H,l=t.length;break;default:throw"bad hour format: "+t}break;case 77:switch(t.length){case 1:case 2:n=r.M,l=t.length;break;default:throw"bad minute format: "+t}break;case 115:if("s"!=t&&"ss"!=t&&".0"!=t&&".00"!=t&&".000"!=t)throw"bad second format: "+t;return 0!==r.u||"s"!=t&&"ss"!=t?(60*(o=2<=a?3===a?1e3:100:1===a?10:1)<=(i=Math.round(o*(r.S+r.u)))&&(i=0),"s"===t?0===i?"0":""+i/o:(s=x(i,2+a),"ss"===t?s.substr(0,2):"."+s.substr(2,t.length-1))):x(r.S,t.length);case 90:switch(t){case"[h]":case"[hh]":n=24*r.D+r.H;break;case"[m]":case"[mm]":n=60*(24*r.D+r.H)+r.M;break;case"[s]":case"[ss]":n=60*(60*(24*r.D+r.H)+r.M)+Math.round(r.S+r.u);break;default:throw"bad abstime format: "+t}l=3===t.length?1:2;break;case 101:n=c,l=1}return 0<l?x(n,l):""}(o[l].t.charCodeAt(0),o[l].v,n,b),o[l].t="t";break;case"n":case"?":for(v=l+1;null!=o[v]&&("?"===(f=o[v].t)||"D"===f||(" "===f||"t"===f)&&null!=o[v+1]&&("?"===o[v+1].t||"t"===o[v+1].t&&"/"===o[v+1].v)||"("===o[l].t&&(" "===f||"n"===f||")"===f)||"t"===f&&("/"===o[v].v||" "===o[v].v&&null!=o[v+1]&&"?"==o[v+1].t));)o[l].v+=o[v].v,o[v]={v:"",t:";"},++v;w+=o[l].v,l=v-1;break;case"G":o[l].t="t",o[l].v=P(t,r)}var T,E,k="";if(0<w.length){40==w.charCodeAt(0)?(T=t<0&&45===w.charCodeAt(0)?-t:t,E=K("n",w,T)):(E=K("n",w,T=t<0&&1<a?-t:t),T<0&&o[0]&&"t"==o[0].t&&(E=E.substr(1),o[0].v="-"+o[0].v)),v=E.length-1;for(var y=o.length,l=0;l<o.length;++l)if(null!=o[l]&&"t"!=o[l].t&&-1<o[l].v.indexOf(".")){y=l;break}var S=o.length;if(y===o.length&&-1===E.indexOf("E")){for(l=o.length-1;0<=l;--l)null!=o[l]&&-1!=="n?".indexOf(o[l].t)&&(v>=o[l].v.length-1?(v-=o[l].v.length,o[l].v=E.substr(v+1,o[l].v.length)):v<0?o[l].v="":(o[l].v=E.substr(0,v+1),v=-1),o[l].t="t",S=l);0<=v&&S<o.length&&(o[S].v=E.substr(0,v+1)+o[S].v)}else if(y!==o.length&&-1===E.indexOf("E")){for(v=E.indexOf(".")-1,l=y;0<=l;--l)if(null!=o[l]&&-1!=="n?".indexOf(o[l].t)){for(s=-1<o[l].v.indexOf(".")&&l===y?o[l].v.indexOf(".")-1:o[l].v.length-1,k=o[l].v.substr(s+1);0<=s;--s)0<=v&&("0"===o[l].v.charAt(s)||"#"===o[l].v.charAt(s))&&(k=E.charAt(v--)+k);o[l].v=k,o[l].t="t",S=l}for(0<=v&&S<o.length&&(o[S].v=E.substr(0,v+1)+o[S].v),v=E.indexOf(".")+1,l=y;l<o.length;++l)if(null!=o[l]&&(-1!=="n?(".indexOf(o[l].t)||l===y)){for(s=-1<o[l].v.indexOf(".")&&l===y?o[l].v.indexOf(".")+1:0,k=o[l].v.substr(0,s);s<o[l].v.length;++s)v<E.length&&(k+=E.charAt(v++));o[l].v=k,o[l].t="t",S=l}}}for(l=0;l<o.length;++l)null!=o[l]&&-1<"n?".indexOf(o[l].t)&&(T=1<a&&t<0&&0<l&&"-"===o[l-1].v?-t:t,o[l].v=K(o[l].t,o[l].v,T),o[l].t="t");var _="";for(l=0;l!==o.length;++l)null!=o[l]&&(_+=o[l].v);return _}var Q=/\[(=|>[=]?|<[>=]?)(-?\d+(?:\.\d*)?)\]/;function ge(e,t){if(null!=t){var r=parseFloat(t[2]);switch(t[1]){case"=":if(e==r)return 1;break;case">":if(r<e)return 1;break;case"<":if(e<r)return 1;break;case"<>":if(e!=r)return 1;break;case">=":if(r<=e)return 1;break;case"<=":if(e<=r)return 1}}}function be(e,t){var r=function(e){for(var t=[],r=!1,a=0,n=0;a<e.length;++a)switch(e.charCodeAt(a)){case 34:r=!r;break;case 95:case 42:case 92:++a;break;case 59:t[t.length]=e.substr(n,a-n),n=a+1}if(t[t.length]=e.substr(n),!0===r)throw new Error("Format |"+e+"| unterminated string ");return t}(e),a=r.length,n=r[a-1].indexOf("@");if(a<4&&-1<n&&--a,4<r.length)throw new Error("cannot find right format for |"+r.join("|")+"|");if("number"!=typeof t)return[4,4===r.length||-1<n?r[r.length-1]:"@"];switch(r.length){case 1:r=-1<n?["General","General","General",r[0]]:[r[0],r[0],r[0],"@"];break;case 2:r=-1<n?[r[0],r[0],r[0],r[1]]:[r[0],r[1],r[0],"@"];break;case 3:r=-1<n?[r[0],r[1],r[0],r[2]]:[r[0],r[1],r[2],"@"]}var s=0<t?r[0]:t<0?r[1]:r[2];if(-1===r[0].indexOf("[")&&-1===r[1].indexOf("["))return[a,s];if(null==r[0].match(/\[[=<>]/)&&null==r[1].match(/\[[=<>]/))return[a,s];e=r[0].match(Q),s=r[1].match(Q);return ge(t,e)?[a,r[0]]:ge(t,s)?[a,r[1]]:[a,r[null!=e&&null!=s?2:1]]}function ve(e,t,r){null==r&&(r={});var a="";switch(typeof e){case"string":a="m/d/yy"==e&&r.dateNF?r.dateNF:e;break;case"number":null==(a=null==(a=14==e&&r.dateNF?r.dateNF:(null!=r.table?r.table:me)[e])?r.table&&r.table[b[e]]||me[b[e]]:a)&&(a=k[e]||"General")}if(A(a,0))return P(t,r);var n=be(a,t=t instanceof Date?N(t,r.date1904):t);if(A(n[1]))return P(t,r);if(!0===t)t="TRUE";else if(!1===t)t="FALSE";else if(""===t||null==t)return"";return Z(n[1],t,r,n[0])}function we(e,t){if("number"!=typeof t){t=+t||-1;for(var r=0;r<392;++r)if(null!=me[r]){if(me[r]==e){t=r;break}}else t<0&&(t=r);t<0&&(t=391)}return me[t]=e,t}function Te(e){for(var t=0;392!=t;++t)void 0!==e[t]&&we(e[t],t)}function Ee(){var e;(e=e||{})[0]="General",e[1]="0",e[2]="0.00",e[3]="#,##0",e[4]="#,##0.00",e[9]="0%",e[10]="0.00%",e[11]="0.00E+00",e[12]="# ?/?",e[13]="# ??/??",e[14]="m/d/yy",e[15]="d-mmm-yy",e[16]="d-mmm",e[17]="mmm-yy",e[18]="h:mm AM/PM",e[19]="h:mm:ss AM/PM",e[20]="h:mm",e[21]="h:mm:ss",e[22]="m/d/yy h:mm",e[37]="#,##0 ;(#,##0)",e[38]="#,##0 ;[Red](#,##0)",e[39]="#,##0.00;(#,##0.00)",e[40]="#,##0.00;[Red](#,##0.00)",e[45]="mm:ss",e[46]="[h]:mm:ss",e[47]="mmss.0",e[48]="##0.0E+0",e[49]="@",e[56]='"上午/下午 "hh"時"mm"分"ss"秒 "',me=e}var e={format:ve,load:we,_table:me,load_table:Te,parse_date_code:L,is_date:q,get_table:function(){return e._table=me}},ke={5:'"$"#,##0_);\\("$"#,##0\\)',6:'"$"#,##0_);[Red]\\("$"#,##0\\)',7:'"$"#,##0.00_);\\("$"#,##0.00\\)',8:'"$"#,##0.00_);[Red]\\("$"#,##0.00\\)',23:"General",24:"General",25:"General",26:"General",27:"m/d/yy",28:"m/d/yy",29:"m/d/yy",30:"m/d/yy",31:"m/d/yy",32:"h:mm:ss",33:"h:mm:ss",34:"h:mm:ss",35:"h:mm:ss",36:"m/d/yy",41:'_(* #,##0_);_(* (#,##0);_(* "-"_);_(@_)',42:'_("$"* #,##0_);_("$"* (#,##0);_("$"* "-"_);_(@_)',43:'_(* #,##0.00_);_(* (#,##0.00);_(* "-"??_);_(@_)',44:'_("$"* #,##0.00_);_("$"* (#,##0.00);_("$"* "-"??_);_(@_)',50:"m/d/yy",51:"m/d/yy",52:"m/d/yy",53:"m/d/yy",54:"m/d/yy",55:"m/d/yy",56:"m/d/yy",57:"m/d/yy",58:"m/d/yy",59:"0",60:"0.00",61:"#,##0",62:"#,##0.00",63:'"$"#,##0_);\\("$"#,##0\\)',64:'"$"#,##0_);[Red]\\("$"#,##0\\)',65:'"$"#,##0.00_);\\("$"#,##0.00\\)',66:'"$"#,##0.00_);[Red]\\("$"#,##0.00\\)',67:"0%",68:"0.00%",69:"# ?/?",70:"# ??/??",71:"m/d/yy",72:"m/d/yy",73:"d-mmm-yy",74:"d-mmm",75:"mmm-yy",76:"h:mm",77:"h:mm:ss",78:"m/d/yy h:mm",79:"mm:ss",80:"[h]:mm:ss",81:"mmss.0"},ye=/[dD]+|[mM]+|[yYeE]+|[Hh]+|[Ss]+/g;var Se,_e=function(){var e={};e.version="1.2.0";var o=function(){for(var e=0,t=new Array(256),r=0;256!=r;++r)e=1&(e=1&(e=1&(e=1&(e=1&(e=1&(e=1&(e=1&(e=r)?-306674912^e>>>1:e>>>1)?-306674912^e>>>1:e>>>1)?-306674912^e>>>1:e>>>1)?-306674912^e>>>1:e>>>1)?-306674912^e>>>1:e>>>1)?-306674912^e>>>1:e>>>1)?-306674912^e>>>1:e>>>1)?-306674912^e>>>1:e>>>1,t[r]=e;return"undefined"!=typeof Int32Array?new Int32Array(t):t}();var t=function(e){for(var t=0,r=0,a=0,n=new("undefined"!=typeof Int32Array?Int32Array:Array)(4096),a=0;256!=a;++a)n[a]=e[a];for(a=0;256!=a;++a)for(r=e[a],t=256+a;t<4096;t+=256)r=n[t]=r>>>8^e[255&r];var s=[];for(a=1;16!=a;++a)s[a-1]="undefined"!=typeof Int32Array?n.subarray(256*a,256*a+256):n.slice(256*a,256*a+256);return s}(o),s=t[0],i=t[1],c=t[2],l=t[3],f=t[4],h=t[5],u=t[6],d=t[7],p=t[8],m=t[9],g=t[10],b=t[11],v=t[12],w=t[13],T=t[14];return e.table=o,e.bstr=function(e,t){for(var r=-1^t,a=0,n=e.length;a<n;)r=r>>>8^o[255&(r^e.charCodeAt(a++))];return~r},e.buf=function(e,t){for(var r=-1^t,a=e.length-15,n=0;n<a;)r=T[e[n++]^255&r]^w[e[n++]^r>>8&255]^v[e[n++]^r>>16&255]^b[e[n++]^r>>>24]^g[e[n++]]^m[e[n++]]^p[e[n++]]^d[e[n++]]^u[e[n++]]^h[e[n++]]^f[e[n++]]^l[e[n++]]^c[e[n++]]^i[e[n++]]^s[e[n++]]^o[e[n++]];for(a+=15;n<a;)r=r>>>8^o[255&(r^e[n++])];return~r},e.str=function(e,t){for(var r,a=-1^t,n=0,s=e.length,i=0;n<s;)a=(i=e.charCodeAt(n++))<128?a>>>8^o[255&(a^i)]:i<2048?(a=a>>>8^o[255&(a^(192|i>>6&31))])>>>8^o[255&(a^(128|63&i))]:55296<=i&&i<57344?(i=64+(1023&i),r=1023&e.charCodeAt(n++),(a=(a=(a=a>>>8^o[255&(a^(240|i>>8&7))])>>>8^o[255&(a^(128|i>>2&63))])>>>8^o[255&(a^(128|r>>6&15|(3&i)<<4))])>>>8^o[255&(a^(128|63&r))]):(a=(a=a>>>8^o[255&(a^(224|i>>12&15))])>>>8^o[255&(a^(128|i>>6&63))])>>>8^o[255&(a^(128|63&i))];return~a},e}(),xe=function(){var s,e={};function d(e){if("/"==e.charAt(e.length-1))return-1===e.slice(0,-1).indexOf("/")?e:d(e.slice(0,-1));var t=e.lastIndexOf("/");return-1===t?e:e.slice(0,t+1)}function p(e){if("/"==e.charAt(e.length-1))return p(e.slice(0,-1));var t=e.lastIndexOf("/");return-1===t?e:e.slice(t+1)}function g(e){Dr(e,0);for(var t,r={};e.l<=e.length-4;){var a=e.read_shift(2),n=e.read_shift(2),s=e.l+n,i={};21589===a&&(1&(t=e.read_shift(1))&&(i.mtime=e.read_shift(4)),5<n&&(2&t&&(i.atime=e.read_shift(4)),4&t&&(i.ctime=e.read_shift(4))),i.mtime&&(i.mt=new Date(1e3*i.mtime))),e.l=s,r[a]=i}return r}function i(){return s=s||require("fs")}function o(e,t){if(80==e[0]&&75==e[1])return q(e,t);if(109==(32|e[0])&&105==(32|e[1]))return function(e,t){if("mime-version:"!=_(e.slice(0,13)).toLowerCase())throw new Error("Unsupported MAD header");var r=t&&t.root||"",a=(se&&Buffer.isBuffer(e)?e.toString("binary"):_(e)).split("\r\n"),n=0,s="";for(n=0;n<a.length;++n)if(s=a[n],/^Content-Location:/i.test(s)&&(s=s.slice(s.indexOf("file")),r=r||s.slice(0,s.lastIndexOf("/")+1),s.slice(0,r.length)!=r))for(;0<r.length&&(r=(r=r.slice(0,r.length-1)).slice(0,r.lastIndexOf("/")+1),s.slice(0,r.length)!=r););e=(a[1]||"").match(/boundary="(.*?)"/);if(!e)throw new Error("MAD cannot find boundary");var i="--"+(e[1]||""),o={FileIndex:[],FullPaths:[]};w(o);var c,l=0;for(n=0;n<a.length;++n){var f=a[n];f!==i&&f!==i+"--"||(l++&&function(e,t,r){for(var a,n="",s="",i="",o=0;o<10;++o){var c=t[o];if(!c||c.match(/^\s*$/))break;var l=c.match(/^(.*?):\s*([^\s].*)$/);if(l)switch(l[1].toLowerCase()){case"content-location":n=l[2].trim();break;case"content-type":i=l[2].trim();break;case"content-transfer-encoding":s=l[2].trim()}}switch(++o,s.toLowerCase()){case"base64":a=he(te(t.slice(o).join("")));break;case"quoted-printable":a=function(e){for(var t=[],r=0;r<e.length;++r){for(var a=e[r];r<=e.length&&"="==a.charAt(a.length-1);)a=a.slice(0,a.length-1)+e[++r];t.push(a)}for(var n=0;n<t.length;++n)t[n]=t[n].replace(/[=][0-9A-Fa-f]{2}/g,function(e){return String.fromCharCode(parseInt(e.slice(1),16))});return he(t.join("\r\n"))}(t.slice(o));break;default:throw new Error("Unsupported Content-Transfer-Encoding "+s)}r=Q(e,n.slice(r.length),a,{unsafe:!0}),i&&(r.ctype=i)}(o,a.slice(c,n),r),c=n)}return o}(e,t);if(e.length<512)throw new Error("CFB file size "+e.length+" < 512");var r,m,a,n=3,s=512,i=0,o=[],c=e.slice(0,512);Dr(c,0);var l=function(e){if(80==e[e.l]&&75==e[e.l+1])return[0,0];e.chk(y,"Header Signature: "),e.l+=16;var t=e.read_shift(2,"u");return[e.read_shift(2,"u"),t]}(c);switch(n=l[0]){case 3:s=512;break;case 4:s=4096;break;case 0:if(0==l[1])return q(e,t);default:throw new Error("Major Version: Expected 3 or 4 saw "+n)}512!==s&&Dr(c=e.slice(0,s),28);var f=e.slice(0,s);!function(e,t){var r=9;switch(e.l+=2,r=e.read_shift(2)){case 9:if(3!=t)throw new Error("Sector Shift: Expected 9 saw "+r);break;case 12:if(4!=t)throw new Error("Sector Shift: Expected 12 saw "+r);break;default:throw new Error("Sector Shift: Expected 9 or 12 saw "+r)}e.chk("0600","Mini Sector Shift: "),e.chk("000000000000","Reserved: ")}(c,n);var h=c.read_shift(4,"i");if(3===n&&0!==h)throw new Error("# Directory Sectors: Expected 0 saw "+h);c.l+=4,m=c.read_shift(4,"i"),c.l+=4,c.chk("00100000","Mini Stream Cutoff Size: "),a=c.read_shift(4,"i"),r=c.read_shift(4,"i"),b=c.read_shift(4,"i"),i=c.read_shift(4,"i");for(var u,d=0;d<109&&!((u=c.read_shift(4,"i"))<0);++d)o[d]=u;var p=function(e,t){for(var r=Math.ceil(e.length/t)-1,a=[],n=1;n<r;++n)a[n-1]=e.slice(n*t,(n+1)*t);return a[r-1]=e.slice(r*t),a}(e,s);!function e(t,r,a,n,s){var i=k;if(t===k){if(0!==r)throw new Error("DIFAT chain shorter than expected")}else if(-1!==t){var o=a[t],c=(n>>>2)-1;if(o){for(var l=0;l<c&&(i=xr(o,4*l))!==k;++l)s.push(i);e(xr(o,n-4),r-1,a,n,s)}}}(b,i,p,s,o);var g=function(e,t,r,a){var n=e.length,s=[],i=[],o=[],c=[],l=a-1,f=0,h=0,u=0,d=0;for(f=0;f<n;++f)if(o=[],n<=(u=f+t)&&(u-=n),!i[u]){c=[];var p=[];for(h=u;0<=h;){p[h]=!0,i[h]=!0,o[o.length]=h,c.push(e[h]);var m=r[Math.floor(4*h/a)];if(a<4+(d=4*h&l))throw new Error("FAT boundary crossed: "+h+" 4 "+a);if(!e[m])break;if(h=xr(e[m],d),p[h])break}s[u]={nodes:o,data:hr([c])}}return s}(p,m,o,s);g[m].name="!Directory",0<r&&a!==k&&(g[a].name="!MiniFAT"),g[o[0]].name="!FAT",g.fat_addrs=o,g.ssz=s;var h=[],b=[],i=[];!function(e,t,r,a,n,s,i){for(var o,c=0,l=r.length?2:0,f=e[m].data,h=0,u=0;h<f.length;h+=128){var d=f.slice(h,h+128);Dr(d,64),u=d.read_shift(2),o=ur(d,0,u-l),r.push(o);var p={name:o,type:d.read_shift(1),color:d.read_shift(1),L:d.read_shift(4,"i"),R:d.read_shift(4,"i"),C:d.read_shift(4,"i"),clsid:d.read_shift(16),state:d.read_shift(4,"i"),start:0,size:0};0!==d.read_shift(2)+d.read_shift(2)+d.read_shift(2)+d.read_shift(2)&&(p.ct=v(d,d.l-8)),0!==d.read_shift(2)+d.read_shift(2)+d.read_shift(2)+d.read_shift(2)&&(p.mt=v(d,d.l-8)),p.start=d.read_shift(4,"i"),p.size=d.read_shift(4,"i"),p.size<0&&p.start<0&&(p.size=p.type=0,p.start=k,p.name=""),5===p.type?(c=p.start,0<a&&c!==k&&(e[c].name="!StreamData")):4096<=p.size?(p.storage="fat",void 0===e[p.start]&&(e[p.start]=function(e,t,r,a,n){var s=[],i=[];n=n||[];var o=a-1,c=0,l=0;for(c=t;0<=c;){n[c]=!0,s[s.length]=c,i.push(e[c]);var f=r[Math.floor(4*c/a)];if(a<4+(l=4*c&o))throw new Error("FAT boundary crossed: "+c+" 4 "+a);if(!e[f])break;c=xr(e[f],l)}return{nodes:s,data:hr([i])}}(t,p.start,e.fat_addrs,e.ssz)),e[p.start].name=p.name,p.content=e[p.start].data.slice(0,p.size)):(p.storage="minifat",p.size<0?p.size=0:c!==k&&p.start!==k&&e[c]&&(p.content=function(e,t,r){var a=e.start,n=e.size,s=[],i=a;for(;r&&0<n&&0<=i;)s.push(t.slice(i*E,i*E+E)),n-=E,i=xr(r,4*i);return 0===s.length?Lr(0):ue(s).slice(0,e.size)}(p,e[c].data,(e[i]||{}).data))),p.content&&Dr(p.content,0),n[o]=p,s.push(p)}}(g,p,h,r,{},b,a),function(e,t,r){for(var a=0,n=0,s=0,i=0,o=0,c=r.length,l=[],f=[];a<c;++a)l[a]=f[a]=a,t[a]=r[a];for(;o<f.length;++o)a=f[o],n=e[a].L,s=e[a].R,i=e[a].C,l[a]===a&&(-1!==n&&l[n]!==n&&(l[a]=l[n]),-1!==s&&l[s]!==s&&(l[a]=l[s])),-1!==i&&(l[i]=a),-1!==n&&a!=l[a]&&(l[n]=l[a],f.lastIndexOf(n)<o&&f.push(n)),-1!==s&&a!=l[a]&&(l[s]=l[a],f.lastIndexOf(s)<o&&f.push(s));for(a=1;a<c;++a)l[a]===a&&(-1!==s&&l[s]!==s?l[a]=l[s]:-1!==n&&l[n]!==n&&(l[a]=l[n]));for(a=1;a<c;++a)if(0!==e[a].type){if((o=a)!=l[o])for(;o=l[o],t[a]=t[o]+"/"+t[a],0!==o&&-1!==l[o]&&o!=l[o];);l[a]=-1}for(t[0]+="/",a=1;a<c;++a)2!==e[a].type&&(t[a]+="/")}(b,i,h),h.shift();i={FileIndex:b,FullPaths:i};return t&&t.raw&&(i.raw={header:f,sectors:p}),i}function v(e,t){return new Date(1e3*(_r(e,t+4)/1e7*Math.pow(2,32)+_r(e,t)/1e7-11644473600))}function w(e,t){var r=t||{},t=r.root||"Root Entry";if(e.FullPaths||(e.FullPaths=[]),e.FileIndex||(e.FileIndex=[]),e.FullPaths.length!==e.FileIndex.length)throw new Error("inconsistent CFB structure");0===e.FullPaths.length&&(e.FullPaths[0]=t+"/",e.FileIndex[0]={name:t,type:5}),r.CLSID&&(e.FileIndex[0].clsid=r.CLSID),t=e,r="Sh33tJ5",xe.find(t,"/"+r)||((e=Lr(4))[0]=55,e[1]=e[3]=50,e[2]=54,t.FileIndex.push({name:r,type:2,content:e,size:4,L:69,R:69,C:69}),t.FullPaths.push(t.FullPaths[0]+r),u(t))}function u(e,t){w(e);for(var r=!1,a=!1,n=e.FullPaths.length-1;0<=n;--n){var s=e.FileIndex[n];switch(s.type){case 0:a?r=!0:(e.FileIndex.pop(),e.FullPaths.pop());break;case 1:case 2:case 5:a=!0,isNaN(s.R*s.L*s.C)&&(r=!0),-1<s.R&&-1<s.L&&s.R==s.L&&(r=!0);break;default:r=!0}}if(r||t){for(var i=new Date(1987,1,19),o=0,c=Object.create?Object.create(null):{},l=[],n=0;n<e.FullPaths.length;++n)c[e.FullPaths[n]]=!0,0!==e.FileIndex[n].type&&l.push([e.FullPaths[n],e.FileIndex[n]]);for(n=0;n<l.length;++n){var f=d(l[n][0]);(a=c[f])||(l.push([f,{name:p(f).replace("/",""),type:1,clsid:b,ct:i,mt:i,content:null}]),c[f]=!0)}for(l.sort(function(e,t){return function(e,t){for(var r,a=e.split("/"),n=t.split("/"),s=0,i=Math.min(a.length,n.length);s<i;++s){if(r=a[s].length-n[s].length)return r;if(a[s]!=n[s])return a[s]<n[s]?-1:1}return a.length-n.length}(e[0],t[0])}),e.FullPaths=[],e.FileIndex=[],n=0;n<l.length;++n)e.FullPaths[n]=l[n][0],e.FileIndex[n]=l[n][1];for(n=0;n<l.length;++n){var h=e.FileIndex[n],u=e.FullPaths[n];if(h.name=p(u).replace("/",""),h.L=h.R=h.C=-(h.color=1),h.size=h.content?h.content.length:0,h.start=0,h.clsid=h.clsid||b,0===n)h.C=1<l.length?1:-1,h.size=0,h.type=5;else if("/"==u.slice(-1)){for(o=n+1;o<l.length&&d(e.FullPaths[o])!=u;++o);for(h.C=o>=l.length?-1:o,o=n+1;o<l.length&&d(e.FullPaths[o])!=d(u);++o);h.R=o>=l.length?-1:o,h.type=1}else d(e.FullPaths[n+1]||"")==d(u)&&(h.R=n+1),h.type=2}}}function a(e,t){var r=t||{};if("mad"==r.fileType)return function(e,t){for(var r=t||{},a=r.boundary||"SheetJS",n=["MIME-Version: 1.0",'Content-Type: multipart/related; boundary="'+(a="------="+a).slice(2)+'"',"","",""],s=e.FullPaths[0],i=s,o=e.FileIndex[0],c=1;c<e.FullPaths.length;++c)if(i=e.FullPaths[c].slice(s.length),(o=e.FileIndex[c]).size&&o.content&&"Sh33tJ5"!=i){i=i.replace(/[\x00-\x08\x0B\x0C\x0E-\x1F\x7E-\xFF]/g,function(e){return"_x"+e.charCodeAt(0).toString(16)+"_"}).replace(/[\u0080-\uFFFF]/g,function(e){return"_u"+e.charCodeAt(0).toString(16)+"_"});for(var l=o.content,f=se&&Buffer.isBuffer(l)?l.toString("binary"):_(l),h=0,u=Math.min(1024,f.length),d=0,p=0;p<=u;++p)32<=(d=f.charCodeAt(p))&&d<128&&++h;l=4*u/5<=h;n.push(a),n.push("Content-Location: "+(r.root||"file:///C:/SheetJS/")+i),n.push("Content-Transfer-Encoding: "+(l?"quoted-printable":"base64")),n.push("Content-Type: "+function(e,t){if(e.ctype)return e.ctype;var r=e.name||"",e=r.match(/\.([^\.]+)$/);if(e&&Z[e[1]])return Z[e[1]];if(t&&(e=(r=t).match(/[\.\\]([^\.\\])+$/))&&Z[e[1]])return Z[e[1]];return"application/octet-stream"}(o,i)),n.push(""),n.push((l?function(e){e=e.replace(/[\x00-\x08\x0B\x0C\x0E-\x1F\x7E-\xFF=]/g,function(e){e=e.charCodeAt(0).toString(16).toUpperCase();return"="+(1==e.length?"0"+e:e)});"\n"==(e=e.replace(/ $/gm,"=20").replace(/\t$/gm,"=09")).charAt(0)&&(e="=0D"+e.slice(1));e=e.replace(/\r(?!\n)/gm,"=0D").replace(/\n\n/gm,"\n=0A").replace(/([^\r\n])\n/gm,"$1=0A");for(var t=[],r=e.split("\r\n"),a=0;a<r.length;++a){var n=r[a];if(0!=n.length)for(var s=0;s<n.length;){var i=76,o=n.slice(s,s+i);"="==o.charAt(i-1)?i--:"="==o.charAt(i-2)?i-=2:"="==o.charAt(i-3)&&(i-=3),o=n.slice(s,s+i),(s+=i)<n.length&&(o+="="),t.push(o)}else t.push("")}return t.join("\r\n")}:function(e){for(var t=ee(e),r=[],a=0;a<t.length;a+=76)r.push(t.slice(a,a+76));return r.join("\r\n")+"\r\n"})(f))}return n.push(a+"--\r\n"),n.join("\r\n")}(e,r);if(u(e),"zip"===r.fileType)return function(e,t){var t=t||{},r=[],a=[],n=Lr(1),s=t.compression?8:0,i=0;0;var o=0,c=0,l=0,f=0,h=e.FullPaths[0],u=h,d=e.FileIndex[0],p=[],m=0;for(o=1;o<e.FullPaths.length;++o)if(u=e.FullPaths[o].slice(h.length),(d=e.FileIndex[o]).size&&d.content&&"Sh33tJ5"!=u){var g=l,b=Lr(u.length);for(c=0;c<u.length;++c)b.write_shift(1,127&u.charCodeAt(c));b=b.slice(0,b.l),p[f]=_e.buf(d.content,0);var v=d.content;8==s&&(v=function(e){return T?T.deflateRawSync(e):V(e)}(v)),(n=Lr(30)).write_shift(4,67324752),n.write_shift(2,20),n.write_shift(2,i),n.write_shift(2,s),d.mt?function(e,t){var r=(t="string"==typeof t?new Date(t):t).getHours();r=(r=r<<6|t.getMinutes())<<5|t.getSeconds()>>>1,e.write_shift(2,r),r=(r=(r=t.getFullYear()-1980)<<4|t.getMonth()+1)<<5|t.getDate(),e.write_shift(2,r)}(n,d.mt):n.write_shift(4,0),n.write_shift(-4,8&i?0:p[f]),n.write_shift(4,8&i?0:v.length),n.write_shift(4,8&i?0:d.content.length),n.write_shift(2,b.length),n.write_shift(2,0),l+=n.length,r.push(n),l+=b.length,r.push(b),l+=v.length,r.push(v),8&i&&((n=Lr(12)).write_shift(-4,p[f]),n.write_shift(4,v.length),n.write_shift(4,d.content.length),l+=n.l,r.push(n)),(n=Lr(46)).write_shift(4,33639248),n.write_shift(2,0),n.write_shift(2,20),n.write_shift(2,i),n.write_shift(2,s),n.write_shift(4,0),n.write_shift(-4,p[f]),n.write_shift(4,v.length),n.write_shift(4,d.content.length),n.write_shift(2,b.length),n.write_shift(2,0),n.write_shift(2,0),n.write_shift(2,0),n.write_shift(2,0),n.write_shift(4,0),n.write_shift(4,g),m+=n.l,a.push(n),m+=b.length,a.push(b),++f}return(n=Lr(22)).write_shift(4,101010256),n.write_shift(2,0),n.write_shift(2,0),n.write_shift(2,f),n.write_shift(2,f),n.write_shift(4,m),n.write_shift(4,l),n.write_shift(2,0),ue([ue(r),ue(a),n])}(e,r);for(var a=function(e){for(var t=0,r=0,a=0;a<e.FileIndex.length;++a){var n=e.FileIndex[a];n.content&&(0<(n=n.content.length)&&(n<4096?t+=n+63>>6:r+=n+511>>9))}for(var s=e.FullPaths.length+3>>2,i=t+127>>7,o=(t+7>>3)+r+s+i,c=o+127>>7,l=c<=109?0:Math.ceil((c-109)/127);c<o+c+l+127>>7;)l=++c<=109?0:Math.ceil((c-109)/127);s=[1,l,c,i,s,r,t,0];return e.FileIndex[0].size=t<<6,s[7]=(e.FileIndex[0].start=s[0]+s[1]+s[2]+s[3]+s[4]+s[5])+(s[6]+7>>3),s}(e),n=Lr(a[7]<<9),s=0,i=0,s=0;s<8;++s)n.write_shift(1,m[s]);for(s=0;s<8;++s)n.write_shift(2,0);for(n.write_shift(2,62),n.write_shift(2,3),n.write_shift(2,65534),n.write_shift(2,9),n.write_shift(2,6),s=0;s<3;++s)n.write_shift(2,0);for(n.write_shift(4,0),n.write_shift(4,a[2]),n.write_shift(4,a[0]+a[1]+a[2]+a[3]-1),n.write_shift(4,0),n.write_shift(4,4096),n.write_shift(4,a[3]?a[0]+a[1]+a[2]-1:k),n.write_shift(4,a[3]),n.write_shift(-4,a[1]?a[0]-1:k),n.write_shift(4,a[1]),s=0;s<109;++s)n.write_shift(-4,s<a[2]?a[1]+s:-1);if(a[1])for(i=0;i<a[1];++i){for(;s<236+127*i;++s)n.write_shift(-4,s<a[2]?a[1]+s:-1);n.write_shift(-4,i===a[1]-1?k:i+1)}function o(e){for(i+=e;s<i-1;++s)n.write_shift(-4,s+1);e&&(++s,n.write_shift(-4,k))}i=s=0;for(i+=a[1];s<i;++s)n.write_shift(-4,S.DIFSECT);for(i+=a[2];s<i;++s)n.write_shift(-4,S.FATSECT);o(a[3]),o(a[4]);for(var c=0,l=0,f=e.FileIndex[0];c<e.FileIndex.length;++c)(f=e.FileIndex[c]).content&&((l=f.content.length)<4096||(f.start=i,o(l+511>>9)));for(o(a[6]+7>>3);511&n.l;)n.write_shift(-4,S.ENDOFCHAIN);for(c=i=s=0;c<e.FileIndex.length;++c)(f=e.FileIndex[c]).content&&(!(l=f.content.length)||4096<=l||(f.start=i,o(l+63>>6)));for(;511&n.l;)n.write_shift(-4,S.ENDOFCHAIN);for(s=0;s<a[4]<<2;++s){var h=e.FullPaths[s];if(h&&0!==h.length){f=e.FileIndex[s],0===s&&(f.start=f.size?f.start-1:k);h=0===s&&r.root||f.name,l=2*(h.length+1);if(n.write_shift(64,h,"utf16le"),n.write_shift(2,l),n.write_shift(1,f.type),n.write_shift(1,f.color),n.write_shift(-4,f.L),n.write_shift(-4,f.R),n.write_shift(-4,f.C),f.clsid)n.write_shift(16,f.clsid,"hex");else for(c=0;c<4;++c)n.write_shift(4,0);n.write_shift(4,f.state||0),n.write_shift(4,0),n.write_shift(4,0),n.write_shift(4,0),n.write_shift(4,0),n.write_shift(4,f.start),n.write_shift(4,f.size),n.write_shift(4,0)}else{for(c=0;c<17;++c)n.write_shift(4,0);for(c=0;c<3;++c)n.write_shift(4,-1);for(c=0;c<12;++c)n.write_shift(4,0)}}for(s=1;s<e.FileIndex.length;++s)if(4096<=(f=e.FileIndex[s]).size)if(n.l=f.start+1<<9,se&&Buffer.isBuffer(f.content))f.content.copy(n,n.l,0,f.size),n.l+=f.size+511&-512;else{for(c=0;c<f.size;++c)n.write_shift(1,f.content[c]);for(;511&c;++c)n.write_shift(1,0)}for(s=1;s<e.FileIndex.length;++s)if(0<(f=e.FileIndex[s]).size&&f.size<4096)if(se&&Buffer.isBuffer(f.content))f.content.copy(n,n.l,0,f.size),n.l+=f.size+63&-64;else{for(c=0;c<f.size;++c)n.write_shift(1,f.content[c]);for(;63&c;++c)n.write_shift(1,0)}if(se)n.l=n.length;else for(;n.l<n.length;)n.write_shift(1,0);return n}e.version="1.2.1";var T,E=64,k=-2,y="d0cf11e0a1b11ae1",m=[208,207,17,224,161,177,26,225],b="00000000000000000000000000000000",S={MAXREGSECT:-6,DIFSECT:-4,FATSECT:-3,ENDOFCHAIN:k,FREESECT:-1,HEADER_SIGNATURE:y,HEADER_MINOR_VERSION:"3e00",MAXREGSID:-6,NOSTREAM:-1,HEADER_CLSID:b,EntryTypes:["unknown","storage","stream","lockbytes","property","root"]};function _(e){for(var t=new Array(e.length),r=0;r<e.length;++r)t[r]=String.fromCharCode(e[r]);return t.join("")}var x=[16,17,18,0,8,7,9,6,10,5,11,4,12,3,13,2,14,1,15],A=[3,4,5,6,7,8,9,10,11,13,15,17,19,23,27,31,35,43,51,59,67,83,99,115,131,163,195,227,258],C=[1,2,3,4,5,7,9,13,17,25,33,49,65,97,129,193,257,385,513,769,1025,1537,2049,3073,4097,6145,8193,12289,16385,24577];for(var t,R="undefined"!=typeof Uint8Array,O=R?new Uint8Array(256):[],r=0;r<256;++r)O[r]=255&((t=139536&((t=r)<<1|t<<11)|558144&(t<<5|t<<15))>>16|t>>8|t);function I(e,t){var r=7&t,t=t>>>3;return(e[t]|(r<=5?0:e[1+t]<<8))>>>r&7}function N(e,t){var r=7&t,t=t>>>3;return(e[t]|(r<=3?0:e[1+t]<<8))>>>r&31}function F(e,t){var r=7&t,t=t>>>3;return(e[t]|(r<=1?0:e[1+t]<<8))>>>r&127}function D(e,t,r){var a=7&t,n=t>>>3,s=(1<<r)-1,t=e[n]>>>a;return r<8-a?t&s:(t|=e[1+n]<<8-a,r<16-a?t&s:(t|=e[2+n]<<16-a,r<24-a?t&s:(t|=e[3+n]<<24-a)&s))}function P(e,t,r){var a=7&t,n=t>>>3;return a<=5?e[n]|=(7&r)<<a:(e[n]|=r<<a&255,e[1+n]=(7&r)>>8-a),t+3}function L(e,t,r){var a=t>>>3;return r<<=7&t,e[a]|=255&r,r>>>=8,e[1+a]=r,t+8}function M(e,t,r){var a=t>>>3;return r<<=7&t,e[a]|=255&r,r>>>=8,e[1+a]=255&r,e[2+a]=r>>>8,t+16}function U(e,t){var r=e.length,a=t<2*r?2*r:t+5,n=0;if(t<=r)return e;if(se){var s=fe(a);if(e.copy)e.copy(s);else for(;n<e.length;++n)s[n]=e[n];return s}if(R){var i=new Uint8Array(a);if(i.set)i.set(e);else for(;n<r;++n)i[n]=e[n];return i}return e.length=a,e}function B(e){for(var t=new Array(e),r=0;r<e;++r)t[r]=0;return t}function W(e,t,r){for(var a,n=1,s=0,i=0,o=0,c=e.length,l=R?new Uint16Array(32):B(32),s=0;s<32;++s)l[s]=0;for(s=c;s<r;++s)e[s]=0;c=e.length;var f=R?new Uint16Array(c):B(c);for(s=0;s<c;++s)l[a=e[s]]++,n<a&&(n=a),f[s]=0;for(l[0]=0,s=1;s<=n;++s)l[s+16]=o=o+l[s-1]<<1;for(s=0;s<c;++s)0!=(o=e[s])&&(f[s]=l[o+16]++);var h,u,d,p;for(s=0;s<c;++s)if(0!=(h=e[s]))for(u=f[s],d=n,p=void 0,p=O[255&u],o=(d<=8?p>>>8-d:(p=p<<8|O[u>>8&255],d<=16?p>>>16-d:(p=p<<8|O[u>>16&255])>>>24-d))>>n-h,i=(1<<n+4-h)-1;0<=i;--i)t[o|i<<h]=15&h|s<<4;return n}var H=R?new Uint16Array(512):B(512),z=R?new Uint16Array(32):B(32);if(!R){for(var n=0;n<512;++n)H[n]=0;for(n=0;n<32;++n)z[n]=0}!function(){for(var e=[],t=0;t<32;t++)e.push(5);W(e,z,32);for(var r=[],t=0;t<=143;t++)r.push(8);for(;t<=255;t++)r.push(9);for(;t<=279;t++)r.push(7);for(;t<=287;t++)r.push(8);W(r,H,288)}();var c=function(){for(var d=R?new Uint8Array(32768):[],e=0,t=0;e<C.length-1;++e)for(;t<C[e+1];++t)d[t]=e;for(;t<32768;++t)d[t]=29;for(var p=R?new Uint8Array(259):[],e=0,t=0;e<A.length-1;++e)for(;t<A[e+1];++t)p[t]=e;return function(e,t){return(e.length<8?function(e,t){for(var r=0;r<e.length;){var a=Math.min(65535,e.length-r),n=r+a==e.length;for(t.write_shift(1,+n),t.write_shift(2,a),t.write_shift(2,65535&~a);0<a--;)t[t.l++]=e[r++]}return t.l}:function(e,t){for(var r=0,a=0,n=R?new Uint16Array(32768):[];a<e.length;){var s=Math.min(65535,e.length-a);if(s<10){for(7&(r=P(t,r,+!(a+s!=e.length)))&&(r+=8-(7&r)),t.l=r/8|0,t.write_shift(2,s),t.write_shift(2,65535&~s);0<s--;)t[t.l++]=e[a++];r=8*t.l}else{r=P(t,r,+!(a+s!=e.length)+2);for(var i=0;0<s--;){var o=e[a],i=32767&(i<<5^o),c=-1,l=0;if((c=n[i])&&(a<(c|=-32768&a)&&(c-=32768),c<a))for(;e[c+l]==e[a+l]&&l<250;)++l;if(2<l){(o=p[l])<=22?r=L(t,r,O[o+1]>>1)-1:(L(t,r,3),L(t,r+=5,O[o-23]>>5),r+=3);var f=o<8?0:o-4>>2;0<f&&(M(t,r,l-A[o]),r+=f),o=d[a-c],r=L(t,r,O[o]>>3),r-=3;var h=o<4?0:o-2>>1;0<h&&(M(t,r,a-c-C[o]),r+=h);for(var u=0;u<l;++u)n[i]=32767&a,i=32767&(i<<5^e[a]),++a;s-=l-1}else o<=143?o+=48:(f=((f=1)&f)<<(7&(h=r)),t[h>>>3]|=f,r=h+1),r=L(t,r,O[o]),n[i]=32767&a,++a}r=L(t,r,0)-1}}return t.l=(r+7)/8|0,t.l})(e,t)}}();function V(e){var t=Lr(50+Math.floor(1.1*e.length)),e=c(e,t);return t.slice(0,e)}var G=R?new Uint16Array(32768):B(32768),j=R?new Uint16Array(32768):B(32768),$=R?new Uint16Array(128):B(128),X=1,Y=1;function l(e,t){if(3==e[0]&&!(3&e[1]))return[le(t),2];for(var r=0,a=0,n=fe(t||1<<18),s=0,i=n.length>>>0,o=0,c=0;0==(1&a);)if(a=I(e,r),r+=3,a>>>1!=0)for(c=a>>1==1?(o=9,5):(r=function(e,t){var r,a,n,s=N(e,t)+257,i=N(e,t+=5)+1,o=(n=7&(a=t+=5),4+(((r=e)[a=a>>>3]|(n<=4?0:r[1+a]<<8))>>>n&15));t+=4;for(var c=0,l=R?new Uint8Array(19):B(19),f=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],h=1,u=R?new Uint8Array(8):B(8),d=R?new Uint8Array(8):B(8),p=l.length,m=0;m<o;++m)l[x[m]]=c=I(e,t),h<c&&(h=c),u[c]++,t+=3;var g=0;for(u[0]=0,m=1;m<=h;++m)d[m]=g=g+u[m-1]<<1;for(m=0;m<p;++m)0!=(g=l[m])&&(f[m]=d[g]++);for(var b,m=0;m<p;++m)if(0!=(b=l[m])){g=O[f[m]]>>8-b;for(var v=(1<<7-b)-1;0<=v;--v)$[g|v<<b]=7&b|m<<3}for(var w,T,E,k=[],h=1;k.length<s+i;)switch(t+=7&(g=$[F(e,t)]),g>>>=3){case 16:for(c=3+(E=void 0,E=7&(T=t),((w=e)[T=T>>>3]|(E<=6?0:w[1+T]<<8))>>>E&3),t+=2,g=k[k.length-1];0<c--;)k.push(g);break;case 17:for(c=3+I(e,t),t+=3;0<c--;)k.push(0);break;case 18:for(c=11+F(e,t),t+=7;0<c--;)k.push(0);break;default:k.push(g),h<g&&(h=g)}var y=k.slice(0,s),S=k.slice(s);for(m=s;m<286;++m)y[m]=0;for(m=i;m<30;++m)S[m]=0;return X=W(y,G,286),Y=W(S,j,30),t}(e,r),o=X,Y);;){!t&&i<s+32767&&(i=(n=U(n,s+32767)).length);var l=D(e,r,o),f=(a>>>1==1?H:G)[l];if(r+=15&f,0==((f>>>=4)>>>8&255))n[s++]=f;else{if(256==f)break;var h=(f-=257)<8?0:f-4>>2;5<h&&(h=0);var u=s+A[f];0<h&&(u+=D(e,r,h),r+=h),l=D(e,r,c),r+=15&(f=(a>>>1==1?z:j)[l]);var l=(f>>>=4)<4?0:f-2>>1,d=C[f];for(0<l&&(d+=D(e,r,l),r+=l),!t&&i<u&&(i=(n=U(n,u+100)).length);s<u;)n[s]=n[s-d],++s}}else{7&r&&(r+=8-(7&r));var p=e[r>>>3]|e[1+(r>>>3)]<<8;if(r+=32,0<p)for(!t&&i<s+p&&(i=(n=U(n,s+p)).length);0<p--;)n[s++]=e[r>>>3],r+=8}return t?[n,r+7>>>3]:[n.slice(0,s),r+7>>>3]}function K(e,t){t=l(e.slice(e.l||0),t);return e.l+=t[1],t[0]}function J(e,t){if(!e)throw new Error(t);"undefined"!=typeof console&&console.error(t)}function q(e,t){var r=e;Dr(r,0);var a={FileIndex:[],FullPaths:[]};w(a,{root:t.root});for(var n=r.length-4;(80!=r[n]||75!=r[n+1]||5!=r[n+2]||6!=r[n+3])&&0<=n;)--n;r.l=n+4,r.l+=4;var s=r.read_shift(2);r.l+=6;t=r.read_shift(4);for(r.l=t,n=0;n<s;++n){r.l+=20;var i=r.read_shift(4),o=r.read_shift(4),c=r.read_shift(2),l=r.read_shift(2),f=r.read_shift(2);r.l+=8;var h=r.read_shift(4),u=g(r.slice(r.l+c,r.l+c+l));r.l+=c+l+f;f=r.l;r.l=h+4,function(e,t,r,a,n){e.l+=2;var s=e.read_shift(2),i=e.read_shift(2),o=function(e){var t=65535&e.read_shift(2),r=65535&e.read_shift(2),a=new Date,n=31&r,e=15&(r>>>=5);return r>>>=4,a.setMilliseconds(0),a.setFullYear(1980+r),a.setMonth(e-1),a.setDate(n),e=31&t,n=63&(t>>>=5),t>>>=6,a.setHours(t),a.setMinutes(n),a.setSeconds(e<<1),a}(e);if(8257&s)throw new Error("Unsupported ZIP encryption");e.read_shift(4);for(var c,l=e.read_shift(4),f=e.read_shift(4),h=e.read_shift(2),u=e.read_shift(2),d="",p=0;p<h;++p)d+=String.fromCharCode(e[e.l++]);u&&(((c=g(e.slice(e.l,e.l+u)))[21589]||{}).mt&&(o=c[21589].mt),((n||{})[21589]||{}).mt&&(o=n[21589].mt)),e.l+=u;var m=e.slice(e.l,e.l+l);switch(i){case 8:m=function(e,t){if(!T)return K(e,t);var r=new T.InflateRaw,t=r._processChunk(e.slice(e.l),r._finishFlushFlag);return e.l+=r.bytesRead,t}(e,f);break;case 0:break;default:throw new Error("Unsupported ZIP Compression method "+i)}u=!1,8&s&&(134695760==e.read_shift(4)&&(e.read_shift(4),u=!0),l=e.read_shift(4),f=e.read_shift(4)),l!=t&&J(u,"Bad compressed size: "+t+" != "+l),f!=r&&J(u,"Bad uncompressed size: "+r+" != "+f),Q(a,d,m,{unsafe:!0,mt:o})}(r,i,o,a,u),r.l=f}return a}var Z={htm:"text/html",xml:"text/xml",gif:"image/gif",jpg:"image/jpeg",png:"image/png",mso:"application/x-mso",thmx:"application/vnd.ms-officetheme",sh33tj5:"application/octet-stream"};function Q(e,t,r,a){var n=a&&a.unsafe;n||w(e);var s,i=!n&&xe.find(e,t);return i||(s=e.FullPaths[0],s=t.slice(0,s.length)==s?t:("/"!=s.slice(-1)&&(s+="/"),(s+t).replace("//","/")),i={name:p(t),type:2},e.FileIndex.push(i),e.FullPaths.push(s),n||xe.utils.cfb_gc(e)),i.content=r,i.size=r?r.length:0,a&&(a.CLSID&&(i.clsid=a.CLSID),a.mt&&(i.mt=a.mt),a.ct&&(i.ct=a.ct)),i}return e.find=function(e,t){var r=e.FullPaths.map(function(e){return e.toUpperCase()}),a=r.map(function(e){var t=e.split("/");return t[t.length-("/"==e.slice(-1)?2:1)]}),n=!1;47===t.charCodeAt(0)?(n=!0,t=r[0].slice(0,-1)+t):n=-1!==t.indexOf("/");var s=t.toUpperCase(),i=(!0===n?r:a).indexOf(s);if(-1!==i)return e.FileIndex[i];var o=!s.match(pe),s=s.replace(de,"");for(o&&(s=s.replace(pe,"!")),i=0;i<r.length;++i){if((o?r[i].replace(pe,"!"):r[i]).replace(de,"")==s)return e.FileIndex[i];if((o?a[i].replace(pe,"!"):a[i]).replace(de,"")==s)return e.FileIndex[i]}return null},e.read=function(e,t){var r,a,n=t&&t.type;switch(n||se&&Buffer.isBuffer(e)&&(n="buffer"),n||"base64"){case"file":return r=e,a=t,i(),o(s.readFileSync(r),a);case"base64":return o(he(te(e)),t);case"binary":return o(he(e),t)}return o(e,t)},e.parse=o,e.write=function(e,t){var r=a(e,t);switch(t&&t.type||"buffer"){case"file":return i(),s.writeFileSync(t.filename,r),r;case"binary":return"string"==typeof r?r:_(r);case"base64":return ee("string"==typeof r?r:_(r));case"buffer":if(se)return Buffer.isBuffer(r)?r:ce(r);case"array":return"string"==typeof r?he(r):r}return r},e.writeFile=function(e,t,r){i(),r=a(e,r),s.writeFileSync(t,r)},e.utils={cfb_new:function(e){var t={};return w(t,e),t},cfb_add:Q,cfb_del:function(e,t){w(e);var r=xe.find(e,t);if(r)for(var a=0;a<e.FileIndex.length;++a)if(e.FileIndex[a]==r)return e.FileIndex.splice(a,1),e.FullPaths.splice(a,1),!0;return!1},cfb_mov:function(e,t,r){w(e);var a=xe.find(e,t);if(a)for(var n=0;n<e.FileIndex.length;++n)if(e.FileIndex[n]==a)return e.FileIndex[n].name=p(r),e.FullPaths[n]=r,!0;return!1},cfb_gc:function(e){u(e,!0)},ReadShift:Cr,CheckField:Fr,prep_blob:Dr,bconcat:ue,use_zlib:function(e){try{var t=new e.InflateRaw;if(t._processChunk(new Uint8Array([3,0]),t._finishFlushFlag),!t.bytesRead)throw new Error("zlib does not expose bytesRead");T=e}catch(e){console.error("cannot use native zlib: "+(e.message||e))}},_deflateRaw:V,_inflateRaw:K,consts:S},e}();if("undefined"!=typeof require)try{Se=require("fs")}catch(e){}function Ae(e){return"string"==typeof e?o(e):Array.isArray(e)?function(e){if("undefined"==typeof Uint8Array)throw new Error("Unsupported");return new Uint8Array(e)}(e):e}function Ce(e,t,r){if(void 0!==Se&&Se.writeFileSync)return r?Se.writeFileSync(e,t,r):Se.writeFileSync(e,t);if("undefined"!=typeof Deno){if(r&&"string"==typeof t)switch(r){case"utf8":t=new TextEncoder(r).encode(t);break;case"binary":t=o(t);break;default:throw new Error("Unsupported encoding "+r)}return Deno.writeFileSync(e,t)}var a="utf8"==r?Ut(t):t;if("undefined"!=typeof IE_SaveFile)return IE_SaveFile(a,e);if("undefined"!=typeof Blob){a=new Blob([Ae(a)],{type:"application/octet-stream"});if("undefined"!=typeof navigator&&navigator.msSaveBlob)return navigator.msSaveBlob(a,e);if("undefined"!=typeof saveAs)return saveAs(a,e);if("undefined"!=typeof URL&&"undefined"!=typeof document&&document.createElement&&URL.createObjectURL){var n=URL.createObjectURL(a);if("object"==typeof chrome&&"function"==typeof(chrome.downloads||{}).download)return URL.revokeObjectURL&&"undefined"!=typeof setTimeout&&setTimeout(function(){URL.revokeObjectURL(n)},6e4),chrome.downloads.download({url:n,filename:e,saveAs:!0});a=document.createElement("a");if(null!=a.download)return a.download=e,a.href=n,document.body.appendChild(a),a.click(),document.body.removeChild(a),URL.revokeObjectURL&&"undefined"!=typeof setTimeout&&setTimeout(function(){URL.revokeObjectURL(n)},6e4),n}}if("undefined"!=typeof $&&"undefined"!=typeof File&&"undefined"!=typeof Folder)try{var s=File(e);return s.open("w"),s.encoding="binary",Array.isArray(t)&&(t=i(t)),s.write(t),s.close(),t}catch(e){if(!e.message||!e.message.match(/onstruct/))throw e}throw new Error("cannot save file "+e)}function Re(e){for(var t=Object.keys(e),r=[],a=0;a<t.length;++a)Object.prototype.hasOwnProperty.call(e,t[a])&&r.push(t[a]);return r}function Oe(e,t){for(var r=[],a=Re(e),n=0;n!==a.length;++n)null==r[e[a[n]][t]]&&(r[e[a[n]][t]]=a[n]);return r}function Ie(e){for(var t=[],r=Re(e),a=0;a!==r.length;++a)t[e[r[a]]]=r[a];return t}function Ne(e){for(var t=[],r=Re(e),a=0;a!==r.length;++a)t[e[r[a]]]=parseInt(r[a],10);return t}var Fe=new Date(1899,11,30,0,0,0);function De(e,t){var r=e.getTime();return t&&(r-=1263168e5),(r-(Fe.getTime()+6e4*(e.getTimezoneOffset()-Fe.getTimezoneOffset())))/864e5}var r=new Date,Pe=Fe.getTime()+6e4*(r.getTimezoneOffset()-Fe.getTimezoneOffset()),Le=r.getTimezoneOffset();function Me(e){var t=new Date;return t.setTime(24*e*60*60*1e3+Pe),t.getTimezoneOffset()!==Le&&t.setTime(t.getTime()+6e4*(t.getTimezoneOffset()-Le)),t}var Ue=new Date("2017-02-19T19:06:09.000Z"),Be=isNaN(Ue.getFullYear())?new Date("2/19/17"):Ue,We=2017==Be.getFullYear();function He(e,t){var r=new Date(e);if(We)return 0<t?r.setTime(r.getTime()+60*r.getTimezoneOffset()*1e3):t<0&&r.setTime(r.getTime()-60*r.getTimezoneOffset()*1e3),r;if(e instanceof Date)return e;if(1917==Be.getFullYear()&&!isNaN(r.getFullYear())){t=r.getFullYear();return-1<e.indexOf(""+t)?r:(r.setFullYear(r.getFullYear()+100),r)}r=e.match(/\d+/g)||["2017","2","19","0","0","0"],r=new Date(+r[0],+r[1]-1,+r[2],+r[3]||0,+r[4]||0,+r[5]||0);return r=-1<e.indexOf("Z")?new Date(r.getTime()-60*r.getTimezoneOffset()*1e3):r}function ze(e,t){if(se&&Buffer.isBuffer(e)){if(t){if(255==e[0]&&254==e[1])return Ut(e.slice(2).toString("utf16le"));if(254==e[1]&&255==e[2])return Ut(s(e.slice(2).toString("binary")))}return e.toString("binary")}if("undefined"!=typeof TextDecoder)try{if(t){if(255==e[0]&&254==e[1])return Ut(new TextDecoder("utf-16le").decode(e.slice(2)));if(254==e[0]&&255==e[1])return Ut(new TextDecoder("utf-16be").decode(e.slice(2)))}var r={"€":"","‚":"","ƒ":"","„":"","…":"","†":"","‡":"","ˆ":"","‰":"","Š":"","‹":"","Œ":"","Ž":"","‘":"","’":"","“":"","”":"","•":"","–":"","—":"","˜":"","™":"","š":"","›":"","œ":"","ž":"","Ÿ":""};return Array.isArray(e)&&(e=new Uint8Array(e)),new TextDecoder("latin1").decode(e).replace(/[€‚ƒ„…†‡ˆ‰Š‹ŒŽ‘’“”•–—˜™š›œžŸ]/g,function(e){return r[e]||e})}catch(e){}for(var a=[],n=0;n!=e.length;++n)a.push(String.fromCharCode(e[n]));return a.join("")}function Ve(e){if("undefined"!=typeof JSON&&!Array.isArray(e))return JSON.parse(JSON.stringify(e));if("object"!=typeof e||null==e)return e;if(e instanceof Date)return new Date(e.getTime());var t,r={};for(t in e)Object.prototype.hasOwnProperty.call(e,t)&&(r[t]=Ve(e[t]));return r}function Ge(e,t){for(var r="";r.length<t;)r+=e;return r}function je(e){var t=Number(e);if(!isNaN(t))return isFinite(t)?t:NaN;if(!/\d/.test(e))return t;var r=1,e=e.replace(/([\d]),([\d])/g,"$1$2").replace(/[$]/g,"").replace(/[%]/g,function(){return r*=100,""});return isNaN(t=Number(e))?(e=e.replace(/[(](.*)[)]/,function(e,t){return r=-r,t}),isNaN(t=Number(e))?t:t/r):t/r}var $e=["january","february","march","april","may","june","july","august","september","october","november","december"];function Xe(e){var t=new Date(e),r=new Date(NaN),a=t.getYear(),n=t.getMonth(),s=t.getDate();if(isNaN(s))return r;var i=e.toLowerCase();if(i.match(/jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec/)){if(3<(i=i.replace(/[^a-z]/g,"").replace(/([^a-z]|^)[ap]m?([^a-z]|$)/,"")).length&&-1==$e.indexOf(i))return r}else if(i.match(/[a-z]/))return r;return a<0||8099<a||(!(0<n||1<s)||101==a)&&e.match(/[^-0-9:,\/\\]/)?r:t}var Ye,Ke=(Ye=5=="abacaba".split(/(:?b)/i).length,function(e,t,r){if(Ye||"string"==typeof t)return e.split(t);for(var a=e.split(t),n=[a[0]],s=1;s<a.length;++s)n.push(r),n.push(a[s]);return n});function Je(e){return e?e.content&&e.type?ze(e.content,!0):e.data?ne(e.data):e.asNodeBuffer&&se?ne(e.asNodeBuffer().toString("binary")):e.asBinary?ne(e.asBinary()):e._data&&e._data.getContent?ne(ze(Array.prototype.slice.call(e._data.getContent(),0))):null:null}function qe(e){if(!e)return null;if(e.data)return ae(e.data);if(e.asNodeBuffer&&se)return e.asNodeBuffer();if(e._data&&e._data.getContent){var t=e._data.getContent();return"string"==typeof t?ae(t):Array.prototype.slice.call(t)}return e.content&&e.type?e.content:null}function Ze(e,t){for(var r=e.FullPaths||Re(e.files),a=t.toLowerCase().replace(/[\/]/g,"\\"),n=a.replace(/\\/g,"/"),s=0;s<r.length;++s){var i=r[s].replace(/^Root Entry[\/]/,"").toLowerCase();if(a==i||n==i)return e.files?e.files[r[s]]:e.FileIndex[s]}return null}function Qe(e,t){e=Ze(e,t);if(null==e)throw new Error("Cannot find file "+t+" in zip");return e}function et(e,t,r){if(!r)return((r=Qe(e,t))&&".bin"===r.name.slice(-4)?qe:Je)(r);if(!t)return null;try{return et(e,t)}catch(e){return null}}function tt(e,t,r){if(!r)return Je(Qe(e,t));if(!t)return null;try{return tt(e,t)}catch(e){return null}}function rt(e){for(var t=e.FullPaths||Re(e.files),r=[],a=0;a<t.length;++a)"/"!=t[a].slice(-1)&&r.push(t[a].replace(/^Root Entry[\/]/,""));return r.sort()}function at(e,t,r){if(e.FullPaths){if("string"==typeof r){var a=(se?ce:function(e){for(var t=[],r=0,a=e.length+250,n=le(e.length+255),s=0;s<e.length;++s){var i,o=e.charCodeAt(s);o<128?n[r++]=o:o<2048?(n[r++]=192|o>>6&31,n[r++]=128|63&o):55296<=o&&o<57344?(o=64+(1023&o),i=1023&e.charCodeAt(++s),n[r++]=240|o>>8&7,n[r++]=128|o>>2&63,n[r++]=128|i>>6&15|(3&o)<<4,n[r++]=128|63&i):(n[r++]=224|o>>12&15,n[r++]=128|o>>6&63,n[r++]=128|63&o),a<r&&(t.push(n.slice(0,r)),r=0,n=le(65535),a=65530)}return t.push(n.slice(0,r)),ue(t)})(r);return xe.utils.cfb_add(e,t,a)}xe.utils.cfb_add(e,t,r)}else e.file(t,r)}function nt(){return xe.utils.cfb_new()}function st(e,t){switch(t.type){case"base64":return xe.read(e,{type:"base64"});case"binary":return xe.read(e,{type:"binary"});case"buffer":case"array":return xe.read(e,{type:"buffer"})}throw new Error("Unrecognized type "+t.type)}function it(e,t){if("/"==e.charAt(0))return e.slice(1);var r=t.split("/");"/"!=t.slice(-1)&&r.pop();for(var a=e.split("/");0!==a.length;){var n=a.shift();".."===n?r.pop():"."!==n&&r.push(n)}return r.join("/")}var ot='<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\r\n',ct=/([^"\s?>\/]+)\s*=\s*((?:")([^"]*)(?:")|(?:')([^']*)(?:')|([^'">\s]+))/g,lt=/<[\/\?]?[a-zA-Z0-9:_-]+(?:\s+[^"\s?>\/]+\s*=\s*(?:"[^"]*"|'[^']*'|[^'">\s=]+))*\s*[\/\?]?>/gm,ft=ot.match(lt)?lt:/<[^>]*>/g,ht=/<\w*:/,ut=/<(\/?)\w+:/;function dt(e,t,r){for(var a={},n=0,s=0;n!==e.length&&(32!==(s=e.charCodeAt(n))&&10!==s&&13!==s);++n);if(t||(a[0]=e.slice(0,n)),n===e.length)return a;var i,o,c,l=e.match(ct),f=0,h=0,u="",d="";if(l)for(h=0;h!=l.length;++h){for(d=l[h],s=0;s!=d.length&&61!==d.charCodeAt(s);++s);for(u=d.slice(0,s).trim();32==d.charCodeAt(s+1);)++s;for(o=34==(n=d.charCodeAt(s+1))||39==n?1:0,i=d.slice(s+1+o,d.length-o),f=0;f!=u.length&&58!==u.charCodeAt(f);++f);f===u.length?(a[u=0<u.indexOf("_")?u.slice(0,u.indexOf("_")):u]=i,r||(a[u.toLowerCase()]=i)):a[c=(5===f&&"xmlns"===u.slice(0,5)?"xmlns":"")+u.slice(f+1)]&&"ext"==u.slice(f-3,f)||(a[c]=i,r||(a[c.toLowerCase()]=i))}return a}function pt(e){return e.replace(ut,"<$1")}var mt,gt,bt={"&quot;":'"',"&apos;":"'","&gt;":">","&lt;":"<","&amp;":"&"},vt=Ie(bt),wt=(mt=/&(?:quot|apos|gt|lt|amp|#x?([\da-fA-F]+));/gi,gt=/_x([\da-fA-F]{4})_/gi,function e(t){var r=t+"",a=r.indexOf("<![CDATA[");if(-1==a)return r.replace(mt,function(e,t){return bt[e]||String.fromCharCode(parseInt(t,-1<e.indexOf("x")?16:10))||e}).replace(gt,function(e,t){return String.fromCharCode(parseInt(t,16))});t=r.indexOf("]]>");return e(r.slice(0,a))+r.slice(a+9,t)+e(r.slice(t+3))}),Tt=/[&<>'"]/g,Et=/[\u0000-\u0008\u000b-\u001f]/g;function kt(e){return(e+"").replace(Tt,function(e){return vt[e]}).replace(Et,function(e){return"_x"+("000"+e.charCodeAt(0).toString(16)).slice(-4)+"_"})}function yt(e){return kt(e).replace(/ /g,"_x0020_")}var St=/[\u0000-\u001f]/g;function _t(e){return(e+"").replace(Tt,function(e){return vt[e]}).replace(/\n/g,"<br/>").replace(St,function(e){return"&#x"+("000"+e.charCodeAt(0).toString(16)).slice(-4)+";"})}var xt,At=(xt=/&#(\d+);/g,function(e){return e.replace(xt,Ct)});function Ct(e,t){return String.fromCharCode(parseInt(t,10))}function Rt(e){switch(e){case 1:case!0:case"1":case"true":case"TRUE":return!0;default:return!1}}function Ot(e){for(var t,r,a,n,s="",i=0,o=0;i<e.length;)(t=e.charCodeAt(i++))<128?s+=String.fromCharCode(t):(r=e.charCodeAt(i++),191<t&&t<224?(o=(31&t)<<6,o|=63&r,s+=String.fromCharCode(o)):(a=e.charCodeAt(i++),t<240?s+=String.fromCharCode((15&t)<<12|(63&r)<<6|63&a):(n=((7&t)<<18|(63&r)<<12|(63&a)<<6|63&(o=e.charCodeAt(i++)))-65536,s+=String.fromCharCode(55296+(n>>>10&1023)),s+=String.fromCharCode(56320+(1023&n)))));return s}function It(e){for(var t,r,a=le(2*e.length),n=1,s=0,i=0,o=0;o<e.length;o+=n)n=1,(r=e.charCodeAt(o))<128?t=r:r<224?(t=64*(31&r)+(63&e.charCodeAt(o+1)),n=2):r<240?(t=4096*(15&r)+64*(63&e.charCodeAt(o+1))+(63&e.charCodeAt(o+2)),n=3):(n=4,t=262144*(7&r)+4096*(63&e.charCodeAt(o+1))+64*(63&e.charCodeAt(o+2))+(63&e.charCodeAt(o+3)),i=55296+((t-=65536)>>>10&1023),t=56320+(1023&t)),0!==i&&(a[s++]=255&i,a[s++]=i>>>8,i=0),a[s++]=t%256,a[s++]=t>>>8;return a.slice(0,s).toString("ucs2")}function Nt(e){return ce(e,"binary").toString("utf8")}var Ft,Dt,Pt,Lt="foo bar bazâð£",Mt=se&&(Nt(Lt)==Ot(Lt)?Nt:It(Lt)==Ot(Lt)&&It)||Ot,Ut=se?function(e){return ce(e,"utf8").toString("binary")}:function(e){for(var t,r=[],a=0,n=0;a<e.length;)switch(!0){case(n=e.charCodeAt(a++))<128:r.push(String.fromCharCode(n));break;case n<2048:r.push(String.fromCharCode(192+(n>>6))),r.push(String.fromCharCode(128+(63&n)));break;case 55296<=n&&n<57344:n-=55296,t=e.charCodeAt(a++)-56320+(n<<10),r.push(String.fromCharCode(240+(t>>18&7))),r.push(String.fromCharCode(144+(t>>12&63))),r.push(String.fromCharCode(128+(t>>6&63))),r.push(String.fromCharCode(128+(63&t)));break;default:r.push(String.fromCharCode(224+(n>>12))),r.push(String.fromCharCode(128+(n>>6&63))),r.push(String.fromCharCode(128+(63&n)))}return r.join("")},Bt=(Ft={},function(e,t){var r=e+"|"+(t||"");return Ft[r]||(Ft[r]=new RegExp("<(?:\\w+:)?"+e+'(?: xml:space="preserve")?(?:[^>]*)>([\\s\\S]*?)</(?:\\w+:)?'+e+">",t||""))}),Wt=(Dt=[["nbsp"," "],["middot","·"],["quot",'"'],["apos","'"],["gt",">"],["lt","<"],["amp","&"]].map(function(e){return[new RegExp("&"+e[0]+";","ig"),e[1]]}),function(e){for(var t=e.replace(/^[\t\n\r ]+/,"").replace(/[\t\n\r ]+$/,"").replace(/>\s+/g,">").replace(/\s+</g,"<").replace(/[\t\n\r ]+/g," ").replace(/<\s*[bB][rR]\s*\/?>/g,"\n").replace(/<[^>]*>/g,""),r=0;r<Dt.length;++r)t=t.replace(Dt[r][0],Dt[r][1]);return t}),Ht=(Pt={},function(e){return void 0!==Pt[e]?Pt[e]:Pt[e]=new RegExp("<(?:vt:)?"+e+">([\\s\\S]*?)</(?:vt:)?"+e+">","g")}),zt=/<\/?(?:vt:)?variant>/g,Vt=/<(?:vt:)([^>]*)>([\s\S]*)</;function Gt(e,t){var r=dt(e),e=e.match(Ht(r.baseType))||[],a=[];if(e.length==r.size)return e.forEach(function(e){e=e.replace(zt,"").match(Vt);e&&a.push({v:Mt(e[2]),t:e[1]})}),a;if(t.WTF)throw new Error("unexpected vector length "+e.length+" != "+r.size);return a}var jt=/(^\s|\s$|\n)/;function $t(e,t){return"<"+e+(t.match(jt)?' xml:space="preserve"':"")+">"+t+"</"+e+">"}function Xt(t){return Re(t).map(function(e){return" "+e+'="'+t[e]+'"'}).join("")}function Yt(e,t,r){return"<"+e+(null!=r?Xt(r):"")+(null!=t?(t.match(jt)?' xml:space="preserve"':"")+">"+t+"</"+e:"/")+">"}function Kt(e,t){try{return e.toISOString().replace(/\.\d*/,"")}catch(e){if(t)throw e}return""}function Jt(e){if(se&&Buffer.isBuffer(e))return e.toString("utf8");if("string"==typeof e)return e;if("undefined"!=typeof Uint8Array&&e instanceof Uint8Array)return Mt(i(m(e)));throw new Error("Bad input format: expected Buffer or string")}var qt=/<(\/?)([^\s?><!\/:]*:|)([^\s?<>:\/]+)(?:[\s?:\/][^>]*)?>/gm,Zt={CORE_PROPS:"http://schemas.openxmlformats.org/package/2006/metadata/core-properties",CUST_PROPS:"http://schemas.openxmlformats.org/officeDocument/2006/custom-properties",EXT_PROPS:"http://schemas.openxmlformats.org/officeDocument/2006/extended-properties",CT:"http://schemas.openxmlformats.org/package/2006/content-types",RELS:"http://schemas.openxmlformats.org/package/2006/relationships",TCMNT:"http://schemas.microsoft.com/office/spreadsheetml/2018/threadedcomments",dc:"http://purl.org/dc/elements/1.1/",dcterms:"http://purl.org/dc/terms/",dcmitype:"http://purl.org/dc/dcmitype/",mx:"http://schemas.microsoft.com/office/mac/excel/2008/main",r:"http://schemas.openxmlformats.org/officeDocument/2006/relationships",sjs:"http://schemas.openxmlformats.org/package/2006/sheetjs/core-properties",vt:"http://schemas.openxmlformats.org/officeDocument/2006/docPropsVTypes",xsi:"http://www.w3.org/2001/XMLSchema-instance",xsd:"http://www.w3.org/2001/XMLSchema"},Qt=["http://schemas.openxmlformats.org/spreadsheetml/2006/main","http://purl.oclc.org/ooxml/spreadsheetml/main","http://schemas.microsoft.com/office/excel/2006/main","http://schemas.microsoft.com/office/excel/2006/2"],er={o:"urn:schemas-microsoft-com:office:office",x:"urn:schemas-microsoft-com:office:excel",ss:"urn:schemas-microsoft-com:office:spreadsheet",dt:"uuid:C2F41010-65B3-11d1-A29F-00AA00C14882",mv:"http://macVmlSchemaUri",v:"urn:schemas-microsoft-com:vml",html:"http://www.w3.org/TR/REC-html40"};function tr(e){for(var t=[],r=0;r<e[0].length;++r)if(e[0][r])for(var a=0,n=e[0][r].length;a<n;a+=10240)t.push.apply(t,e[0][r].slice(a,a+10240));return t}function rr(e,t,r){for(var a=[],n=t;n<r;n+=2)a.push(String.fromCharCode(yr(e,n)));return a.join("").replace(de,"")}function ar(e,t,r){for(var a=[],n=t;n<t+r;++n)a.push(("0"+e[n].toString(16)).slice(-2));return a.join("")}function nr(e,t,r){for(var a=[],n=t;n<r;n++)a.push(String.fromCharCode(kr(e,n)));return a.join("")}function sr(e,t){var r=_r(e,t);return 0<r?pr(e,t+4,t+4+r-1):""}function ir(e,t){var r=_r(e,t);return 0<r?pr(e,t+4,t+4+r-1):""}function or(e,t){var r=2*_r(e,t);return 0<r?pr(e,t+4,t+4+r-1):""}function cr(e,t){var r=_r(e,t);return 0<r?ur(e,t+4,t+4+r):""}function lr(e,t){var r=_r(e,t);return 0<r?pr(e,t+4,t+4+r):""}function fr(e,t){for(var r=1-2*(e[t+7]>>>7),a=((127&e[t+7])<<4)+(e[t+6]>>>4&15),n=15&e[t+6],s=5;0<=s;--s)n=256*n+e[t+s];return 2047==a?0==n?1/0*r:NaN:(0==a?a=-1022:(a-=1023,n+=Math.pow(2,52)),r*Math.pow(2,a-52)*n)}var hr=se?function(e){return 0<e[0].length&&Buffer.isBuffer(e[0][0])?Buffer.concat(e[0].map(function(e){return Buffer.isBuffer(e)?e:ce(e)})):tr(e)}:tr,ur=se?function(e,t,r){return Buffer.isBuffer(e)?e.toString("utf16le",t,r).replace(de,""):rr(e,t,r)}:rr,dr=se?function(e,t,r){return Buffer.isBuffer(e)?e.toString("hex",t,t+r):ar(e,t,r)}:ar,pr=se?function(e,t,r){return Buffer.isBuffer(e)?e.toString("utf8",t,r):nr(e,t,r)}:nr,mr=sr,gr=ir,br=or,vr=cr,wr=lr,Tr=fr,Er=function(e){return Array.isArray(e)||"undefined"!=typeof Uint8Array&&e instanceof Uint8Array};se&&(mr=function(e,t){if(!Buffer.isBuffer(e))return sr(e,t);var r=e.readUInt32LE(t);return 0<r?e.toString("utf8",t+4,t+4+r-1):""},gr=function(e,t){if(!Buffer.isBuffer(e))return ir(e,t);var r=e.readUInt32LE(t);return 0<r?e.toString("utf8",t+4,t+4+r-1):""},br=function(e,t){if(!Buffer.isBuffer(e))return or(e,t);var r=2*e.readUInt32LE(t);return e.toString("utf16le",t+4,t+4+r-1)},vr=function(e,t){if(!Buffer.isBuffer(e))return cr(e,t);var r=e.readUInt32LE(t);return e.toString("utf16le",t+4,t+4+r)},wr=function(e,t){if(!Buffer.isBuffer(e))return lr(e,t);var r=e.readUInt32LE(t);return e.toString("utf8",t+4,t+4+r)},Tr=function(e,t){return Buffer.isBuffer(e)?e.readDoubleLE(t):fr(e,t)},Er=function(e){return Buffer.isBuffer(e)||Array.isArray(e)||"undefined"!=typeof Uint8Array&&e instanceof Uint8Array}),void 0!==re&&(ur=function(e,t,r){return re.utils.decode(1200,e.slice(t,r)).replace(de,"")},pr=function(e,t,r){return re.utils.decode(65001,e.slice(t,r))},mr=function(e,t){var r=_r(e,t);return 0<r?re.utils.decode(_,e.slice(t+4,t+4+r-1)):""},gr=function(e,t){var r=_r(e,t);return 0<r?re.utils.decode(f,e.slice(t+4,t+4+r-1)):""},br=function(e,t){var r=2*_r(e,t);return 0<r?re.utils.decode(1200,e.slice(t+4,t+4+r-1)):""},vr=function(e,t){var r=_r(e,t);return 0<r?re.utils.decode(1200,e.slice(t+4,t+4+r)):""},wr=function(e,t){var r=_r(e,t);return 0<r?re.utils.decode(65001,e.slice(t+4,t+4+r)):""});var kr=function(e,t){return e[t]},yr=function(e,t){return 256*e[t+1]+e[t]},Sr=function(e,t){t=256*e[t+1]+e[t];return t<32768?t:-1*(65535-t+1)},_r=function(e,t){return e[t+3]*(1<<24)+(e[t+2]<<16)+(e[t+1]<<8)+e[t]},xr=function(e,t){return e[t+3]<<24|e[t+2]<<16|e[t+1]<<8|e[t]},Ar=function(e,t){return e[t]<<24|e[t+1]<<16|e[t+2]<<8|e[t+3]};function Cr(e,t){var r,a,n,s,i,o,c="",l=[];switch(t){case"dbcs":if(o=this.l,se&&Buffer.isBuffer(this))c=this.slice(this.l,this.l+2*e).toString("utf16le");else for(i=0;i<e;++i)c+=String.fromCharCode(yr(this,o)),o+=2;e*=2;break;case"utf8":c=pr(this,this.l,this.l+e);break;case"utf16le":e*=2,c=ur(this,this.l,this.l+e);break;case"wstr":if(void 0===re)return Cr.call(this,e,"dbcs");c=re.utils.decode(f,this.slice(this.l,this.l+2*e)),e*=2;break;case"lpstr-ansi":c=mr(this,this.l),e=4+_r(this,this.l);break;case"lpstr-cp":c=gr(this,this.l),e=4+_r(this,this.l);break;case"lpwstr":c=br(this,this.l),e=4+2*_r(this,this.l);break;case"lpp4":e=4+_r(this,this.l),c=vr(this,this.l),2&e&&(e+=2);break;case"8lpp4":e=4+_r(this,this.l),c=wr(this,this.l),3&e&&(e+=4-(3&e));break;case"cstr":for(e=0,c="";0!==(n=kr(this,this.l+e++));)l.push(u(n));c=l.join("");break;case"_wstr":for(e=0,c="";0!==(n=yr(this,this.l+e));)l.push(u(n)),e+=2;e+=2,c=l.join("");break;case"dbcs-cont":for(c="",o=this.l,i=0;i<e;++i){if(this.lens&&-1!==this.lens.indexOf(o))return n=kr(this,o),this.l=o+1,s=Cr.call(this,e-i,n?"dbcs-cont":"sbcs-cont"),l.join("")+s;l.push(u(yr(this,o))),o+=2}c=l.join(""),e*=2;break;case"cpstr":if(void 0!==re){c=re.utils.decode(f,this.slice(this.l,this.l+e));break}case"sbcs-cont":for(c="",o=this.l,i=0;i!=e;++i){if(this.lens&&-1!==this.lens.indexOf(o))return n=kr(this,o),this.l=o+1,s=Cr.call(this,e-i,n?"dbcs-cont":"sbcs-cont"),l.join("")+s;l.push(u(kr(this,o))),o+=1}c=l.join("");break;default:switch(e){case 1:return r=kr(this,this.l),this.l++,r;case 2:return r=("i"===t?Sr:yr)(this,this.l),this.l+=2,r;case 4:case-4:return"i"===t||0==(128&this[this.l+3])?(r=(0<e?xr:Ar)(this,this.l),this.l+=4,r):(a=_r(this,this.l),this.l+=4,a);case 8:case-8:if("f"===t)return a=8==e?Tr(this,this.l):Tr([this[this.l+7],this[this.l+6],this[this.l+5],this[this.l+4],this[this.l+3],this[this.l+2],this[this.l+1],this[this.l+0]],0),this.l+=8,a;e=8;case 16:c=dr(this,this.l,e)}}return this.l+=e,c}var Rr=function(e,t,r){e[r]=255&t,e[r+1]=t>>>8&255,e[r+2]=t>>>16&255,e[r+3]=t>>>24&255},Or=function(e,t,r){e[r]=255&t,e[r+1]=t>>8&255,e[r+2]=t>>16&255,e[r+3]=t>>24&255},Ir=function(e,t,r){e[r]=255&t,e[r+1]=t>>>8&255};function Nr(e,t,r){var a=0,n=0;if("dbcs"===r){for(n=0;n!=t.length;++n)Ir(this,t.charCodeAt(n),this.l+2*n);a=2*t.length}else if("sbcs"===r){if(void 0!==re&&874==_)for(n=0;n!=t.length;++n){var s=re.utils.encode(_,t.charAt(n));this[this.l+n]=s[0]}else for(t=t.replace(/[^\x00-\x7F]/g,"_"),n=0;n!=t.length;++n)this[this.l+n]=255&t.charCodeAt(n);a=t.length}else{if("hex"===r){for(;n<e;++n)this[this.l++]=parseInt(t.slice(2*n,2*n+2),16)||0;return this}if("utf16le"===r){for(var i=Math.min(this.l+e,this.length),n=0;n<Math.min(t.length,e);++n){var o=t.charCodeAt(n);this[this.l++]=255&o,this[this.l++]=o>>8}for(;this.l<i;)this[this.l++]=0;return this}switch(e){case 1:a=1,this[this.l]=255&t;break;case 2:a=2,this[this.l]=255&t,t>>>=8,this[this.l+1]=255&t;break;case 3:a=3,this[this.l]=255&t,t>>>=8,this[this.l+1]=255&t,t>>>=8,this[this.l+2]=255&t;break;case 4:a=4,Rr(this,t,this.l);break;case 8:if(a=8,"f"===r){!function(e,t,r){var a=(t<0||1/t==-1/0?1:0)<<7,n=0,s=0,i=a?-t:t;isFinite(i)?0==i?n=s=0:(n=Math.floor(Math.log(i)/Math.LN2),s=i*Math.pow(2,52-n),n<=-1023&&(!isFinite(s)||s<Math.pow(2,52))?n=-1022:(s-=Math.pow(2,52),n+=1023)):(n=2047,s=isNaN(t)?26985:0);for(var o=0;o<=5;++o,s/=256)e[r+o]=255&s;e[r+6]=(15&n)<<4|15&s,e[r+7]=n>>4|a}(this,t,this.l);break}case 16:break;case-4:a=4,Or(this,t,this.l)}}return this.l+=a,this}function Fr(e,t){var r=dr(this,this.l,e.length>>1);if(r!==e)throw new Error(t+"Expected "+e+" saw "+r);this.l+=e.length>>1}function Dr(e,t){e.l=t,e.read_shift=Cr,e.chk=Fr,e.write_shift=Nr}function Pr(e,t){e.l+=t}function Lr(e){e=le(e);return Dr(e,0),e}function Mr(e,t,r){if(e){Dr(e,e.l||0);for(var a,n=e.length,s=0;e.l<n;){128&(s=e.read_shift(1))&&(s=(127&s)+((127&e.read_shift(1))<<7));for(var i,o=Df[s]||Df[65535],c=127&(i=e.read_shift(1)),l=1;l<4&&128&i;++l)c+=(127&(i=e.read_shift(1)))<<7*l;a=e.l+c;var f=o.f&&o.f(e,c,r);if(e.l=a,t(f,o,s))return}}}function Ur(){function t(e){return Dr(e=Lr(e),0),e}function r(){s&&(s.length>s.l&&((s=s.slice(0,s.l)).l=s.length),0<s.length&&e.push(s),s=null)}function a(e){return s&&e<s.length-s.l?s:(r(),s=t(Math.max(e+1,n)))}var e=[],n=se?256:2048,s=t(n);return{next:a,push:function(e){r(),null==(s=e).l&&(s.l=s.length),a(n)},end:function(){return r(),ue(e)},_bufs:e}}function Br(e,t,r,a){var n=+t;if(!isNaN(n)){t=1+(128<=n?1:0)+1,128<=(a=a||(Df[n].p||(r||[]).length||0))&&++t,16384<=a&&++t,2097152<=a&&++t;var s=e.next(t);n<=127?s.write_shift(1,n):(s.write_shift(1,128+(127&n)),s.write_shift(1,n>>7));for(var i=0;4!=i;++i){if(!(128<=a)){s.write_shift(1,a);break}s.write_shift(1,128+(127&a)),a>>=7}0<a&&Er(r)&&e.push(r)}}function Wr(e,t,r){var a=Ve(e);if(t.s?(a.cRel&&(a.c+=t.s.c),a.rRel&&(a.r+=t.s.r)):(a.cRel&&(a.c+=t.c),a.rRel&&(a.r+=t.r)),!r||r.biff<12){for(;256<=a.c;)a.c-=256;for(;65536<=a.r;)a.r-=65536}return a}function Hr(e,t,r){e=Ve(e);return e.s=Wr(e.s,t.s,r),e.e=Wr(e.e,t.s,r),e}function zr(e,t){if(e.cRel&&e.c<0)for(e=Ve(e);e.c<0;)e.c+=8<t?16384:256;if(e.rRel&&e.r<0)for(e=Ve(e);e.r<0;)e.r+=8<t?1048576:5<t?65536:16384;var r=Kr(e);return e.cRel||null==e.cRel||(r=r.replace(/^([A-Z])/,"$$$1")),r=!e.rRel&&null!=e.rRel?r.replace(/([A-Z]|^)(\d+)$/,"$1$$$2"):r}function Vr(e,t){return 0!=e.s.r||e.s.rRel||e.e.r!=(12<=t.biff?1048575:8<=t.biff?65536:16384)||e.e.rRel?0!=e.s.c||e.s.cRel||e.e.c!=(12<=t.biff?16383:255)||e.e.cRel?zr(e.s,t.biff)+":"+zr(e.e,t.biff):(e.s.rRel?"":"$")+jr(e.s.r)+":"+(e.e.rRel?"":"$")+jr(e.e.r):(e.s.cRel?"":"$")+Xr(e.s.c)+":"+(e.e.cRel?"":"$")+Xr(e.e.c)}function Gr(e){return parseInt(e.replace(/\$(\d+)$/,"$1"),10)-1}function jr(e){return""+(e+1)}function $r(e){for(var t=e.replace(/^\$([A-Z])/,"$1"),r=0,a=0;a!==t.length;++a)r=26*r+t.charCodeAt(a)-64;return r-1}function Xr(e){if(e<0)throw new Error("invalid column "+e);var t="";for(++e;e;e=Math.floor((e-1)/26))t=String.fromCharCode((e-1)%26+65)+t;return t}function Yr(e){for(var t=0,r=0,a=0;a<e.length;++a){var n=e.charCodeAt(a);48<=n&&n<=57?t=10*t+(n-48):65<=n&&n<=90&&(r=26*r+(n-64))}return{c:r-1,r:t-1}}function Kr(e){for(var t=e.c+1,r="";t;t=(t-1)/26|0)r=String.fromCharCode((t-1)%26+65)+r;return r+(e.r+1)}function Jr(e){var t=e.indexOf(":");return-1==t?{s:Yr(e),e:Yr(e)}:{s:Yr(e.slice(0,t)),e:Yr(e.slice(t+1))}}function qr(e,t){return void 0===t||"number"==typeof t?qr(e.s,e.e):(e="string"!=typeof e?Kr(e):e)==(t="string"!=typeof t?Kr(t):t)?e:e+":"+t}function Zr(e){for(var t={s:{c:0,r:0},e:{c:0,r:0}},r=0,a=0,n=0,s=e.length,r=0;a<s&&!((n=e.charCodeAt(a)-64)<1||26<n);++a)r=26*r+n;for(t.s.c=--r,r=0;a<s&&!((n=e.charCodeAt(a)-48)<0||9<n);++a)r=10*r+n;if(t.s.r=--r,a===s||10!=n)return t.e.c=t.s.c,t.e.r=t.s.r,t;for(++a,r=0;a!=s&&!((n=e.charCodeAt(a)-64)<1||26<n);++a)r=26*r+n;for(t.e.c=--r,r=0;a!=s&&!((n=e.charCodeAt(a)-48)<0||9<n);++a)r=10*r+n;return t.e.r=--r,t}function Qr(e,t){var r="d"==e.t&&t instanceof Date;if(null!=e.z)try{return e.w=ve(e.z,r?De(t):t)}catch(e){}try{return e.w=ve((e.XF||{}).numFmtId||(r?14:0),r?De(t):t)}catch(e){return""+t}}function ea(e,t,r){return null==e||null==e.t||"z"==e.t?"":void 0!==e.w?e.w:("d"==e.t&&!e.z&&r&&r.dateNF&&(e.z=r.dateNF),"e"==e.t?Wa[e.v]||e.v:Qr(e,null==t?e.v:t))}function ta(e,t){var r=t&&t.sheet?t.sheet:"Sheet1",t={};return t[r]=e,{SheetNames:[r],Sheets:t}}function ra(e,t,r){var a=r||{},n=e?Array.isArray(e):a.dense;null!=oe&&null==n&&(n=oe);var s=e||(n?[]:{}),i=0,o=0;s&&null!=a.origin&&("number"==typeof a.origin?i=a.origin:(i=(c="string"==typeof a.origin?Yr(a.origin):a.origin).r,o=c.c),s["!ref"]||(s["!ref"]="A1:A1"));var c,l={s:{c:1e7,r:1e7},e:{c:0,r:0}};s["!ref"]&&(c=Zr(s["!ref"]),l.s.c=c.s.c,l.s.r=c.s.r,l.e.c=Math.max(l.e.c,c.e.c),l.e.r=Math.max(l.e.r,c.e.r),-1==i&&(l.e.r=i=c.e.r+1));for(var f=0;f!=t.length;++f)if(t[f]){if(!Array.isArray(t[f]))throw new Error("aoa_to_sheet expects an array of arrays");for(var h=0;h!=t[f].length;++h)if(void 0!==t[f][h]){var u={v:t[f][h]},d=i+f,p=o+h;if(l.s.r>d&&(l.s.r=d),l.s.c>p&&(l.s.c=p),l.e.r<d&&(l.e.r=d),l.e.c<p&&(l.e.c=p),!t[f][h]||"object"!=typeof t[f][h]||Array.isArray(t[f][h])||t[f][h]instanceof Date)if(Array.isArray(u.v)&&(u.f=t[f][h][1],u.v=u.v[0]),null===u.v)if(u.f)u.t="n";else if(a.nullError)u.t="e",u.v=0;else{if(!a.sheetStubs)continue;u.t="z"}else"number"==typeof u.v?u.t="n":"boolean"==typeof u.v?u.t="b":u.v instanceof Date?(u.z=a.dateNF||me[14],a.cellDates?(u.t="d",u.w=ve(u.z,De(u.v))):(u.t="n",u.v=De(u.v),u.w=ve(u.z,u.v))):u.t="s";else u=t[f][h];n?(s[d]||(s[d]=[]),s[d][p]&&s[d][p].z&&(u.z=s[d][p].z),s[d][p]=u):(s[d=Kr({c:p,r:d})]&&s[d].z&&(u.z=s[d].z),s[d]=u)}}return l.s.c<1e7&&(s["!ref"]=qr(l)),s}function aa(e,t){return ra(null,e,t)}function na(e,t){return(t=t||Lr(4)).write_shift(4,e),t}function sa(e){var t=e.read_shift(4);return 0===t?"":e.read_shift(t,"dbcs")}function ia(e,t){var r=!1;return null==t&&(r=!0,t=Lr(4+2*e.length)),t.write_shift(4,e.length),0<e.length&&t.write_shift(0,e,"dbcs"),r?t.slice(0,t.l):t}function oa(e,t){var r,a=e.l,n=e.read_shift(1),s=sa(e),i=[],s={t:s,h:s};if(0!=(1&n)){for(var o=e.read_shift(4),c=0;c!=o;++c)i.push({ich:(r=e).read_shift(2),ifnt:r.read_shift(2)});s.r=i}else s.r=[{ich:0,ifnt:0}];return e.l=a+t,s}var ca=oa;function la(e,t){var r,a=!1;return null==t&&(a=!0,t=Lr(23+4*e.t.length)),t.write_shift(1,1),ia(e.t,t),t.write_shift(4,1),r={ich:0,ifnt:0},(e=(e=t)||Lr(4)).write_shift(2,r.ich||0),e.write_shift(2,r.ifnt||0),a?t.slice(0,t.l):t}function fa(e){var t=e.read_shift(4),r=e.read_shift(2);return r+=e.read_shift(1)<<16,e.l++,{c:t,iStyleRef:r}}function ha(e,t){return(t=null==t?Lr(8):t).write_shift(-4,e.c),t.write_shift(3,e.iStyleRef||e.s),t.write_shift(1,0),t}function ua(e){var t=e.read_shift(2);return t+=e.read_shift(1)<<16,e.l++,{c:-1,iStyleRef:t}}function da(e,t){return(t=null==t?Lr(4):t).write_shift(3,e.iStyleRef||e.s),t.write_shift(1,0),t}var pa=sa,ma=ia;function ga(e){var t=e.read_shift(4);return 0===t||4294967295===t?"":e.read_shift(t,"dbcs")}function ba(e,t){var r=!1;return null==t&&(r=!0,t=Lr(127)),t.write_shift(4,0<e.length?e.length:4294967295),0<e.length&&t.write_shift(0,e,"dbcs"),r?t.slice(0,t.l):t}var va=sa,wa=ga,Ta=ba;function Ea(e){var t=e.slice(e.l,e.l+4),r=1&t[0],a=2&t[0];e.l+=4;t=0==a?Tr([0,0,0,0,252&t[0],t[1],t[2],t[3]],0):xr(t,0)>>2;return r?t/100:t}function ka(e,t){null==t&&(t=Lr(4));var r=0,a=0,n=100*e;if(e==(0|e)&&-(1<<29)<=e&&e<1<<29?a=1:n==(0|n)&&-(1<<29)<=n&&n<1<<29&&(r=a=1),!a)throw new Error("unsupported RkNumber "+e);t.write_shift(-4,((r?n:e)<<2)+(r+2))}function ya(e){var t={s:{},e:{}};return t.s.r=e.read_shift(4),t.e.r=e.read_shift(4),t.s.c=e.read_shift(4),t.e.c=e.read_shift(4),t}var Sa=ya,_a=function(e,t){return(t=t||Lr(16)).write_shift(4,e.s.r),t.write_shift(4,e.e.r),t.write_shift(4,e.s.c),t.write_shift(4,e.e.c),t};function xa(e){if(e.length-e.l<8)throw"XLS Xnum Buffer underflow";return e.read_shift(8,"f")}function Aa(e,t){return(t||Lr(8)).write_shift(8,e,"f")}function Ca(e,t){if(t=t||Lr(8),!e||e.auto)return t.write_shift(4,0),t.write_shift(4,0),t;null!=e.index?(t.write_shift(1,2),t.write_shift(1,e.index)):null!=e.theme?(t.write_shift(1,6),t.write_shift(1,e.theme)):(t.write_shift(1,5),t.write_shift(1,0));var r=e.tint||0;return 0<r?r*=32767:r<0&&(r*=32768),t.write_shift(2,r),e.rgb&&null==e.theme?("number"==typeof(e=e.rgb||"FFFFFF")&&(e=("000000"+e.toString(16)).slice(-6)),t.write_shift(1,parseInt(e.slice(0,2),16)),t.write_shift(1,parseInt(e.slice(2,4),16)),t.write_shift(1,parseInt(e.slice(4,6),16)),t.write_shift(1,255)):(t.write_shift(2,0),t.write_shift(1,0),t.write_shift(1,0)),t}function Ra(e,t){var r=e.read_shift(4);switch(r){case 0:return"";case 4294967295:case 4294967294:return{2:"BITMAP",3:"METAFILEPICT",8:"DIB",14:"ENHMETAFILE"}[e.read_shift(4)]||""}if(400<r)throw new Error("Unsupported Clipboard: "+r.toString(16));return e.l-=4,e.read_shift(0,1==t?"lpstr":"lpwstr")}var Oa=2,Ia=3,Na=12,Fa=81,Da=[80,Fa],Pa={1:{n:"CodePage",t:Oa},2:{n:"Category",t:80},3:{n:"PresentationFormat",t:80},4:{n:"ByteCount",t:Ia},5:{n:"LineCount",t:Ia},6:{n:"ParagraphCount",t:Ia},7:{n:"SlideCount",t:Ia},8:{n:"NoteCount",t:Ia},9:{n:"HiddenCount",t:Ia},10:{n:"MultimediaClipCount",t:Ia},11:{n:"ScaleCrop",t:11},12:{n:"HeadingPairs",t:4108},13:{n:"TitlesOfParts",t:4126},14:{n:"Manager",t:80},15:{n:"Company",t:80},16:{n:"LinksUpToDate",t:11},17:{n:"CharacterCount",t:Ia},19:{n:"SharedDoc",t:11},22:{n:"HyperlinksChanged",t:11},23:{n:"AppVersion",t:Ia,p:"version"},24:{n:"DigSig",t:65},26:{n:"ContentType",t:80},27:{n:"ContentStatus",t:80},28:{n:"Language",t:80},29:{n:"Version",t:80},255:{},2147483648:{n:"Locale",t:19},2147483651:{n:"Behavior",t:19},1919054434:{}},La={1:{n:"CodePage",t:Oa},2:{n:"Title",t:80},3:{n:"Subject",t:80},4:{n:"Author",t:80},5:{n:"Keywords",t:80},6:{n:"Comments",t:80},7:{n:"Template",t:80},8:{n:"LastAuthor",t:80},9:{n:"RevNumber",t:80},10:{n:"EditTime",t:64},11:{n:"LastPrinted",t:64},12:{n:"CreatedDate",t:64},13:{n:"ModifiedDate",t:64},14:{n:"PageCount",t:Ia},15:{n:"WordCount",t:Ia},16:{n:"CharCount",t:Ia},17:{n:"Thumbnail",t:71},18:{n:"Application",t:80},19:{n:"DocSecurity",t:Ia},255:{},2147483648:{n:"Locale",t:19},2147483651:{n:"Behavior",t:19},1919054434:{}},Ma={1:"US",2:"CA",3:"",7:"RU",20:"EG",30:"GR",31:"NL",32:"BE",33:"FR",34:"ES",36:"HU",39:"IT",41:"CH",43:"AT",44:"GB",45:"DK",46:"SE",47:"NO",48:"PL",49:"DE",52:"MX",55:"BR",61:"AU",64:"NZ",66:"TH",81:"JP",82:"KR",84:"VN",86:"CN",90:"TR",105:"JS",213:"DZ",216:"MA",218:"LY",351:"PT",354:"IS",358:"FI",420:"CZ",886:"TW",961:"LB",962:"JO",963:"SY",964:"IQ",965:"KW",966:"SA",971:"AE",972:"IL",974:"QA",981:"IR",65535:"US"},Ua=[null,"solid","mediumGray","darkGray","lightGray","darkHorizontal","darkVertical","darkDown","darkUp","darkGrid","darkTrellis","lightHorizontal","lightVertical","lightDown","lightUp","lightGrid","lightTrellis","gray125","gray0625"];var Ba=Ve([0,16777215,16711680,65280,255,16776960,16711935,65535,0,16777215,16711680,65280,255,16776960,16711935,65535,8388608,32768,128,8421376,8388736,32896,12632256,8421504,10066431,10040166,16777164,13434879,6684774,16744576,26316,13421823,128,16711935,16776960,65535,8388736,8388608,32896,255,52479,13434879,13434828,16777113,10079487,16751052,13408767,16764057,3368703,3394764,10079232,16763904,16750848,16737792,6710937,9868950,13158,3381606,13056,3355392,10040064,10040166,3355545,3355443,16777215,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0].map(function(e){return[e>>16&255,e>>8&255,255&e]})),Wa={0:"#NULL!",7:"#DIV/0!",15:"#VALUE!",23:"#REF!",29:"#NAME?",36:"#NUM!",42:"#N/A",43:"#GETTING_DATA",255:"#WTF?"},Ha={"#NULL!":0,"#DIV/0!":7,"#VALUE!":15,"#REF!":23,"#NAME?":29,"#NUM!":36,"#N/A":42,"#GETTING_DATA":43,"#WTF?":255},za={"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml":"workbooks","application/vnd.ms-excel.sheet.macroEnabled.main+xml":"workbooks","application/vnd.ms-excel.sheet.binary.macroEnabled.main":"workbooks","application/vnd.ms-excel.addin.macroEnabled.main+xml":"workbooks","application/vnd.openxmlformats-officedocument.spreadsheetml.template.main+xml":"workbooks","application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml":"sheets","application/vnd.ms-excel.worksheet":"sheets","application/vnd.ms-excel.binIndexWs":"TODO","application/vnd.openxmlformats-officedocument.spreadsheetml.chartsheet+xml":"charts","application/vnd.ms-excel.chartsheet":"charts","application/vnd.ms-excel.macrosheet+xml":"macros","application/vnd.ms-excel.macrosheet":"macros","application/vnd.ms-excel.intlmacrosheet":"TODO","application/vnd.ms-excel.binIndexMs":"TODO","application/vnd.openxmlformats-officedocument.spreadsheetml.dialogsheet+xml":"dialogs","application/vnd.ms-excel.dialogsheet":"dialogs","application/vnd.openxmlformats-officedocument.spreadsheetml.sharedStrings+xml":"strs","application/vnd.ms-excel.sharedStrings":"strs","application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml":"styles","application/vnd.ms-excel.styles":"styles","application/vnd.openxmlformats-package.core-properties+xml":"coreprops","application/vnd.openxmlformats-officedocument.custom-properties+xml":"custprops","application/vnd.openxmlformats-officedocument.extended-properties+xml":"extprops","application/vnd.openxmlformats-officedocument.customXmlProperties+xml":"TODO","application/vnd.openxmlformats-officedocument.spreadsheetml.customProperty":"TODO","application/vnd.openxmlformats-officedocument.spreadsheetml.comments+xml":"comments","application/vnd.ms-excel.comments":"comments","application/vnd.ms-excel.threadedcomments+xml":"threadedcomments","application/vnd.ms-excel.person+xml":"people","application/vnd.openxmlformats-officedocument.spreadsheetml.sheetMetadata+xml":"metadata","application/vnd.ms-excel.sheetMetadata":"metadata","application/vnd.ms-excel.pivotTable":"TODO","application/vnd.openxmlformats-officedocument.spreadsheetml.pivotTable+xml":"TODO","application/vnd.openxmlformats-officedocument.drawingml.chart+xml":"TODO","application/vnd.ms-office.chartcolorstyle+xml":"TODO","application/vnd.ms-office.chartstyle+xml":"TODO","application/vnd.ms-office.chartex+xml":"TODO","application/vnd.ms-excel.calcChain":"calcchains","application/vnd.openxmlformats-officedocument.spreadsheetml.calcChain+xml":"calcchains","application/vnd.openxmlformats-officedocument.spreadsheetml.printerSettings":"TODO","application/vnd.ms-office.activeX":"TODO","application/vnd.ms-office.activeX+xml":"TODO","application/vnd.ms-excel.attachedToolbars":"TODO","application/vnd.ms-excel.connections":"TODO","application/vnd.openxmlformats-officedocument.spreadsheetml.connections+xml":"TODO","application/vnd.ms-excel.externalLink":"links","application/vnd.openxmlformats-officedocument.spreadsheetml.externalLink+xml":"links","application/vnd.ms-excel.pivotCacheDefinition":"TODO","application/vnd.ms-excel.pivotCacheRecords":"TODO","application/vnd.openxmlformats-officedocument.spreadsheetml.pivotCacheDefinition+xml":"TODO","application/vnd.openxmlformats-officedocument.spreadsheetml.pivotCacheRecords+xml":"TODO","application/vnd.ms-excel.queryTable":"TODO","application/vnd.openxmlformats-officedocument.spreadsheetml.queryTable+xml":"TODO","application/vnd.ms-excel.userNames":"TODO","application/vnd.ms-excel.revisionHeaders":"TODO","application/vnd.ms-excel.revisionLog":"TODO","application/vnd.openxmlformats-officedocument.spreadsheetml.revisionHeaders+xml":"TODO","application/vnd.openxmlformats-officedocument.spreadsheetml.revisionLog+xml":"TODO","application/vnd.openxmlformats-officedocument.spreadsheetml.userNames+xml":"TODO","application/vnd.ms-excel.tableSingleCells":"TODO","application/vnd.openxmlformats-officedocument.spreadsheetml.tableSingleCells+xml":"TODO","application/vnd.ms-excel.slicer":"TODO","application/vnd.ms-excel.slicerCache":"TODO","application/vnd.ms-excel.slicer+xml":"TODO","application/vnd.ms-excel.slicerCache+xml":"TODO","application/vnd.ms-excel.wsSortMap":"TODO","application/vnd.ms-excel.table":"TODO","application/vnd.openxmlformats-officedocument.spreadsheetml.table+xml":"TODO","application/vnd.openxmlformats-officedocument.theme+xml":"themes","application/vnd.openxmlformats-officedocument.themeOverride+xml":"TODO","application/vnd.ms-excel.Timeline+xml":"TODO","application/vnd.ms-excel.TimelineCache+xml":"TODO","application/vnd.ms-office.vbaProject":"vba","application/vnd.ms-office.vbaProjectSignature":"TODO","application/vnd.ms-office.volatileDependencies":"TODO","application/vnd.openxmlformats-officedocument.spreadsheetml.volatileDependencies+xml":"TODO","application/vnd.ms-excel.controlproperties+xml":"TODO","application/vnd.openxmlformats-officedocument.model+data":"TODO","application/vnd.ms-excel.Survey+xml":"TODO","application/vnd.openxmlformats-officedocument.drawing+xml":"drawings","application/vnd.openxmlformats-officedocument.drawingml.chartshapes+xml":"TODO","application/vnd.openxmlformats-officedocument.drawingml.diagramColors+xml":"TODO","application/vnd.openxmlformats-officedocument.drawingml.diagramData+xml":"TODO","application/vnd.openxmlformats-officedocument.drawingml.diagramLayout+xml":"TODO","application/vnd.openxmlformats-officedocument.drawingml.diagramStyle+xml":"TODO","application/vnd.openxmlformats-officedocument.vmlDrawing":"TODO","application/vnd.openxmlformats-package.relationships+xml":"rels","application/vnd.openxmlformats-officedocument.oleObject":"TODO","image/png":"TODO",sheet:"js"},Va={workbooks:{xlsx:"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml",xlsm:"application/vnd.ms-excel.sheet.macroEnabled.main+xml",xlsb:"application/vnd.ms-excel.sheet.binary.macroEnabled.main",xlam:"application/vnd.ms-excel.addin.macroEnabled.main+xml",xltx:"application/vnd.openxmlformats-officedocument.spreadsheetml.template.main+xml"},strs:{xlsx:"application/vnd.openxmlformats-officedocument.spreadsheetml.sharedStrings+xml",xlsb:"application/vnd.ms-excel.sharedStrings"},comments:{xlsx:"application/vnd.openxmlformats-officedocument.spreadsheetml.comments+xml",xlsb:"application/vnd.ms-excel.comments"},sheets:{xlsx:"application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml",xlsb:"application/vnd.ms-excel.worksheet"},charts:{xlsx:"application/vnd.openxmlformats-officedocument.spreadsheetml.chartsheet+xml",xlsb:"application/vnd.ms-excel.chartsheet"},dialogs:{xlsx:"application/vnd.openxmlformats-officedocument.spreadsheetml.dialogsheet+xml",xlsb:"application/vnd.ms-excel.dialogsheet"},macros:{xlsx:"application/vnd.ms-excel.macrosheet+xml",xlsb:"application/vnd.ms-excel.macrosheet"},metadata:{xlsx:"application/vnd.openxmlformats-officedocument.spreadsheetml.sheetMetadata+xml",xlsb:"application/vnd.ms-excel.sheetMetadata"},styles:{xlsx:"application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml",xlsb:"application/vnd.ms-excel.styles"}};function Ga(){return{workbooks:[],sheets:[],charts:[],dialogs:[],macros:[],rels:[],strs:[],comments:[],threadedcomments:[],links:[],coreprops:[],extprops:[],custprops:[],themes:[],styles:[],calcchains:[],vba:[],drawings:[],metadata:[],people:[],TODO:[],xmlns:""}}function ja(r,a){var t,n=function(e){for(var t=[],r=Re(e),a=0;a!==r.length;++a)null==t[e[r[a]]]&&(t[e[r[a]]]=[]),t[e[r[a]]].push(r[a]);return t}(za),s=[];s[s.length]=ot,s[s.length]=Yt("Types",null,{xmlns:Zt.CT,"xmlns:xsd":Zt.xsd,"xmlns:xsi":Zt.xsi}),s=s.concat([["xml","application/xml"],["bin","application/vnd.ms-excel.sheet.binary.macroEnabled.main"],["vml","application/vnd.openxmlformats-officedocument.vmlDrawing"],["data","application/vnd.openxmlformats-officedocument.model+data"],["bmp","image/bmp"],["png","image/png"],["gif","image/gif"],["emf","image/x-emf"],["wmf","image/x-wmf"],["jpg","image/jpeg"],["jpeg","image/jpeg"],["tif","image/tiff"],["tiff","image/tiff"],["pdf","application/pdf"],["rels","application/vnd.openxmlformats-package.relationships+xml"]].map(function(e){return Yt("Default",null,{Extension:e[0],ContentType:e[1]})}));function e(e){r[e]&&0<r[e].length&&(t=r[e][0],s[s.length]=Yt("Override",null,{PartName:("/"==t[0]?"":"/")+t,ContentType:Va[e][a.bookType]||Va[e].xlsx}))}function i(t){(r[t]||[]).forEach(function(e){s[s.length]=Yt("Override",null,{PartName:("/"==e[0]?"":"/")+e,ContentType:Va[t][a.bookType]||Va[t].xlsx})})}function o(t){(r[t]||[]).forEach(function(e){s[s.length]=Yt("Override",null,{PartName:("/"==e[0]?"":"/")+e,ContentType:n[t][0]})})}return e("workbooks"),i("sheets"),i("charts"),o("themes"),["strs","styles"].forEach(e),["coreprops","extprops","custprops"].forEach(o),o("vba"),o("comments"),o("threadedcomments"),o("drawings"),i("metadata"),o("people"),2<s.length&&(s[s.length]="</Types>",s[1]=s[1].replace("/>",">")),s.join("")}var $a={WB:"http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument",SHEET:"http://sheetjs.openxmlformats.org/officeDocument/2006/relationships/officeDocument",HLINK:"http://schemas.openxmlformats.org/officeDocument/2006/relationships/hyperlink",VML:"http://schemas.openxmlformats.org/officeDocument/2006/relationships/vmlDrawing",XPATH:"http://schemas.openxmlformats.org/officeDocument/2006/relationships/externalLinkPath",XMISS:"http://schemas.microsoft.com/office/2006/relationships/xlExternalLinkPath/xlPathMissing",XLINK:"http://schemas.openxmlformats.org/officeDocument/2006/relationships/externalLink",CXML:"http://schemas.openxmlformats.org/officeDocument/2006/relationships/customXml",CXMLP:"http://schemas.openxmlformats.org/officeDocument/2006/relationships/customXmlProps",CMNT:"http://schemas.openxmlformats.org/officeDocument/2006/relationships/comments",CORE_PROPS:"http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties",EXT_PROPS:"http://schemas.openxmlformats.org/officeDocument/2006/relationships/extended-properties",CUST_PROPS:"http://schemas.openxmlformats.org/officeDocument/2006/relationships/custom-properties",SST:"http://schemas.openxmlformats.org/officeDocument/2006/relationships/sharedStrings",STY:"http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles",THEME:"http://schemas.openxmlformats.org/officeDocument/2006/relationships/theme",CHART:"http://schemas.openxmlformats.org/officeDocument/2006/relationships/chart",CHARTEX:"http://schemas.microsoft.com/office/2014/relationships/chartEx",CS:"http://schemas.openxmlformats.org/officeDocument/2006/relationships/chartsheet",WS:["http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet","http://purl.oclc.org/ooxml/officeDocument/relationships/worksheet"],DS:"http://schemas.openxmlformats.org/officeDocument/2006/relationships/dialogsheet",MS:"http://schemas.microsoft.com/office/2006/relationships/xlMacrosheet",IMG:"http://schemas.openxmlformats.org/officeDocument/2006/relationships/image",DRAW:"http://schemas.openxmlformats.org/officeDocument/2006/relationships/drawing",XLMETA:"http://schemas.openxmlformats.org/officeDocument/2006/relationships/sheetMetadata",TCMNT:"http://schemas.microsoft.com/office/2017/10/relationships/threadedComment",PEOPLE:"http://schemas.microsoft.com/office/2017/10/relationships/person",VBA:"http://schemas.microsoft.com/office/2006/relationships/vbaProject"};function Xa(e){var t=e.lastIndexOf("/");return e.slice(0,t+1)+"_rels/"+e.slice(t+1)+".rels"}function Ya(e,a){var n={"!id":{}};if(!e)return n;"/"!==a.charAt(0)&&(a="/"+a);var s={};return(e.match(ft)||[]).forEach(function(e){var t,r=dt(e);"<Relationship"===r[0]&&((t={}).Type=r.Type,t.Target=r.Target,t.Id=r.Id,r.TargetMode&&(t.TargetMode=r.TargetMode),e="External"===r.TargetMode?r.Target:it(r.Target,a),n[e]=t,s[r.Id]=t)}),n["!id"]=s,n}function Ka(t){var r=[ot,Yt("Relationships",null,{xmlns:Zt.RELS})];return Re(t["!id"]).forEach(function(e){r[r.length]=Yt("Relationship",null,t["!id"][e])}),2<r.length&&(r[r.length]="</Relationships>",r[1]=r[1].replace("/>",">")),r.join("")}function Ja(e,t,r,a,n,s){if(n=n||{},e["!id"]||(e["!id"]={}),e["!idx"]||(e["!idx"]=1),t<0)for(t=e["!idx"];e["!id"]["rId"+t];++t);if(e["!idx"]=t+1,n.Id="rId"+t,n.Type=a,n.Target=r,s?n.TargetMode=s:-1<[$a.HLINK,$a.XPATH,$a.XMISS].indexOf(n.Type)&&(n.TargetMode="External"),e["!id"][n.Id])throw new Error("Cannot rewrite rId "+t);return e["!id"][n.Id]=n,e[("/"+n.Target).replace("//","/")]=n,t}var qa="application/vnd.oasis.opendocument.spreadsheet";function Za(e,t,r){return['  <rdf:Description rdf:about="'+e+'">\n','    <rdf:type rdf:resource="http://docs.oasis-open.org/ns/office/1.2/meta/'+(r||"odf")+"#"+t+'"/>\n',"  </rdf:Description>\n"].join("")}function Qa(){return'<office:document-meta xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xlink="http://www.w3.org/1999/xlink" office:version="1.2"><office:meta><meta:generator>SheetJS '+a.version+"</meta:generator></office:meta></office:document-meta>"}var en=[["cp:category","Category"],["cp:contentStatus","ContentStatus"],["cp:keywords","Keywords"],["cp:lastModifiedBy","LastAuthor"],["cp:lastPrinted","LastPrinted"],["cp:revision","RevNumber"],["cp:version","Version"],["dc:creator","Author"],["dc:description","Comments"],["dc:identifier","Identifier"],["dc:language","Language"],["dc:subject","Subject"],["dc:title","Title"],["dcterms:created","CreatedDate","date"],["dcterms:modified","ModifiedDate","date"]],tn=function(){for(var e=new Array(en.length),t=0;t<en.length;++t){var r=en[t],r="(?:"+r[0].slice(0,r[0].indexOf(":"))+":)"+r[0].slice(r[0].indexOf(":")+1);e[t]=new RegExp("<"+r+"[^>]*>([\\s\\S]*?)</"+r+">")}return e}();function rn(e){var t={};e=Mt(e);for(var r=0;r<en.length;++r){var a=en[r],n=e.match(tn[r]);null!=n&&0<n.length&&(t[a[1]]=wt(n[1])),"date"===a[2]&&t[a[1]]&&(t[a[1]]=He(t[a[1]]))}return t}function an(e,t,r,a,n){null==n[e]&&null!=t&&""!==t&&(t=kt(n[e]=t),a[a.length]=r?Yt(e,t,r):$t(e,t))}function nn(e,t){var r=t||{},a=[ot,Yt("cp:coreProperties",null,{"xmlns:cp":Zt.CORE_PROPS,"xmlns:dc":Zt.dc,"xmlns:dcterms":Zt.dcterms,"xmlns:dcmitype":Zt.dcmitype,"xmlns:xsi":Zt.xsi})],n={};if(!e&&!r.Props)return a.join("");e&&(null!=e.CreatedDate&&an("dcterms:created","string"==typeof e.CreatedDate?e.CreatedDate:Kt(e.CreatedDate,r.WTF),{"xsi:type":"dcterms:W3CDTF"},a,n),null!=e.ModifiedDate&&an("dcterms:modified","string"==typeof e.ModifiedDate?e.ModifiedDate:Kt(e.ModifiedDate,r.WTF),{"xsi:type":"dcterms:W3CDTF"},a,n));for(var s=0;s!=en.length;++s){var i=en[s],o=r.Props&&null!=r.Props[i[1]]?r.Props[i[1]]:e?e[i[1]]:null;!0===o?o="1":!1===o?o="0":"number"==typeof o&&(o=String(o)),null!=o&&an(i[0],o,null,a,n)}return 2<a.length&&(a[a.length]="</cp:coreProperties>",a[1]=a[1].replace("/>",">")),a.join("")}var sn=[["Application","Application","string"],["AppVersion","AppVersion","string"],["Company","Company","string"],["DocSecurity","DocSecurity","string"],["Manager","Manager","string"],["HyperlinksChanged","HyperlinksChanged","bool"],["SharedDoc","SharedDoc","bool"],["LinksUpToDate","LinksUpToDate","bool"],["ScaleCrop","ScaleCrop","bool"],["HeadingPairs","HeadingPairs","raw"],["TitlesOfParts","TitlesOfParts","raw"]],on=["Worksheets","SheetNames","NamedRanges","DefinedNames","Chartsheets","ChartNames"];function cn(e,t,r,a){var n=[];if("string"==typeof e)n=Gt(e,a);else for(var s=0;s<e.length;++s)n=n.concat(e[s].map(function(e){return{v:e}}));var i,o="string"==typeof t?Gt(t,a).map(function(e){return e.v}):t,c=0;if(0<o.length)for(var l=0;l!==n.length;l+=2){switch(i=+n[l+1].v,n[l].v){case"Worksheets":case"工作表":case"Листы":case"أوراق العمل":case"ワークシート":case"גליונות עבודה":case"Arbeitsblätter":case"Çalışma Sayfaları":case"Feuilles de calcul":case"Fogli di lavoro":case"Folhas de cálculo":case"Planilhas":case"Regneark":case"Hojas de cálculo":case"Werkbladen":r.Worksheets=i,r.SheetNames=o.slice(c,c+i);break;case"Named Ranges":case"Rangos con nombre":case"名前付き一覧":case"Benannte Bereiche":case"Navngivne områder":r.NamedRanges=i,r.DefinedNames=o.slice(c,c+i);break;case"Charts":case"Diagramme":r.Chartsheets=i,r.ChartNames=o.slice(c,c+i)}c+=i}}function ln(r){var a=[],n=Yt;return(r=r||{}).Application="SheetJS",a[a.length]=ot,a[a.length]=Yt("Properties",null,{xmlns:Zt.EXT_PROPS,"xmlns:vt":Zt.vt}),sn.forEach(function(e){if(void 0!==r[e[1]]){var t;switch(e[2]){case"string":t=kt(String(r[e[1]]));break;case"bool":t=r[e[1]]?"true":"false"}void 0!==t&&(a[a.length]=n(e[0],t))}}),a[a.length]=n("HeadingPairs",n("vt:vector",n("vt:variant","<vt:lpstr>Worksheets</vt:lpstr>")+n("vt:variant",n("vt:i4",String(r.Worksheets))),{size:2,baseType:"variant"})),a[a.length]=n("TitlesOfParts",n("vt:vector",r.SheetNames.map(function(e){return"<vt:lpstr>"+kt(e)+"</vt:lpstr>"}).join(""),{size:r.Worksheets,baseType:"lpstr"})),2<a.length&&(a[a.length]="</Properties>",a[1]=a[1].replace("/>",">")),a.join("")}var fn=/<[^>]+>[^<]*/g;function hn(t){var r=[ot,Yt("Properties",null,{xmlns:Zt.CUST_PROPS,"xmlns:vt":Zt.vt})];if(!t)return r.join("");var a=1;return Re(t).forEach(function(e){++a,r[r.length]=Yt("property",function(e,t){switch(typeof e){case"string":var r=Yt("vt:lpwstr",kt(e));return r=t?r.replace(/&quot;/g,"_x0022_"):r;case"number":return Yt((0|e)==e?"vt:i4":"vt:r8",kt(String(e)));case"boolean":return Yt("vt:bool",e?"true":"false")}if(e instanceof Date)return Yt("vt:filetime",Kt(e));throw new Error("Unable to serialize "+e)}(t[e],!0),{fmtid:"{D5CDD505-2E9C-101B-9397-08002B2CF9AE}",pid:a,name:kt(e)})}),2<r.length&&(r[r.length]="</Properties>",r[1]=r[1].replace("/>",">")),r.join("")}var un,dn={Title:"Title",Subject:"Subject",Author:"Author",Keywords:"Keywords",Comments:"Description",LastAuthor:"LastAuthor",RevNumber:"Revision",Application:"AppName",LastPrinted:"LastPrinted",CreatedDate:"Created",ModifiedDate:"LastSaved",Category:"Category",Manager:"Manager",Company:"Company",AppVersion:"Version",ContentStatus:"ContentStatus",Identifier:"Identifier",Language:"Language"};function pn(e){var t=e.read_shift(4),e=e.read_shift(4);return new Date(1e3*(e/1e7*Math.pow(2,32)+t/1e7-11644473600)).toISOString().replace(/\.000/,"")}function mn(e,t,r){var a=e.l,n=e.read_shift(0,"lpstr-cp");if(r)for(;e.l-a&3;)++e.l;return n}function gn(e,t,r){var a=e.read_shift(0,"lpwstr");return r&&(e.l+=4-(a.length+1&3)&3),a}function bn(e,t,r){return 31===t?gn(e):mn(e,0,r)}function vn(e,t,r){return bn(e,t,!1===r?0:4)}function wn(e){for(var t,r,a,n=e.read_shift(4),s=[],i=0;i<n/2;++i)s.push((a=r=void 0,r=(t=e).l,a=kn(t,Fa),0==t[t.l]&&0==t[t.l+1]&&t.l-r&2&&(t.l+=2),[a,kn(t,Ia)]));return s}function Tn(e,t){for(var r=e.read_shift(4),a={},n=0;n!=r;++n){var s=e.read_shift(4),i=e.read_shift(4);a[s]=e.read_shift(i,1200===t?"utf16le":"utf8").replace(de,"").replace(pe,"!"),1200===t&&i%2&&(e.l+=2)}return 3&e.l&&(e.l=e.l>>3<<2),a}function En(e){var t=e.read_shift(4),r=e.slice(e.l,e.l+t);return e.l+=t,0<(3&t)&&(e.l+=4-(3&t)&3),r}function kn(e,t,r){var a,n,s=e.read_shift(2),i=r||{};if(e.l+=2,t!==Na&&s!==t&&-1===Da.indexOf(t)&&(4126!=(65534&t)||4126!=(65534&s)))throw new Error("Expected type "+t+" saw "+s);switch(t===Na?s:t){case 2:return a=e.read_shift(2,"i"),i.raw||(e.l+=2),a;case 3:return a=e.read_shift(4,"i");case 11:return 0!==e.read_shift(4);case 19:return a=e.read_shift(4);case 30:return mn(e,0,4).replace(de,"");case 31:return gn(e);case 64:return pn(e);case 65:return En(e);case 71:return(n={}).Size=(a=e).read_shift(4),a.l+=n.Size+3-(n.Size-1)%4,n;case 80:return vn(e,s,!i.raw).replace(de,"");case 81:return function(e,t){if(!t)throw new Error("VtUnalignedString must have positive length");return bn(e,t,0)}(e,s).replace(de,"");case 4108:return wn(e);case 4126:case 4127:return(4127==s?function(e){for(var t=e.read_shift(4),r=[],a=0;a!=t;++a){var n=e.l;r[a]=e.read_shift(0,"lpwstr").replace(de,""),e.l-n&2&&(e.l+=2)}return r}:function(e){for(var t=e.read_shift(4),r=[],a=0;a!=t;++a)r[a]=e.read_shift(0,"lpstr-cp").replace(de,"");return r})(e);default:throw new Error("TypedPropertyValue unrecognized type "+t+" "+s)}}function yn(e,t){var r,a,n,s=Lr(4),i=Lr(4);switch(s.write_shift(4,80==e?31:e),e){case 3:i.write_shift(-4,t);break;case 5:(i=Lr(8)).write_shift(8,t,"f");break;case 11:i.write_shift(4,t?1:0);break;case 64:a=("string"==typeof(r=t)?new Date(Date.parse(r)):r).getTime()/1e3+11644473600,n=a%Math.pow(2,32),r=(a-n)/Math.pow(2,32),r*=1e7,0<(a=(n*=1e7)/Math.pow(2,32)|0)&&(n%=Math.pow(2,32),r+=a),(a=Lr(8)).write_shift(4,n),a.write_shift(4,r),i=a;break;case 31:case 80:for((i=Lr(4+2*(t.length+1)+(t.length%2?0:2))).write_shift(4,t.length+1),i.write_shift(0,t,"dbcs");i.l!=i.length;)i.write_shift(1,0);break;default:throw new Error("TypedPropertyValue unrecognized type "+e+" "+t)}return ue([s,i])}function Sn(e,t){for(var r=e.l,a=e.read_shift(4),n=e.read_shift(4),s=[],i=0,o=0,c=-1,l={},i=0;i!=n;++i){var f=e.read_shift(4),h=e.read_shift(4);s[i]=[f,h+r]}s.sort(function(e,t){return e[1]-t[1]});var u={};for(i=0;i!=n;++i){if(e.l!==s[i][1]){var d=!0;if(0<i&&t)switch(t[s[i-1][0]].t){case 2:e.l+2===s[i][1]&&(e.l+=2,d=!1);break;case 80:case 4108:e.l<=s[i][1]&&(e.l=s[i][1],d=!1)}if((!t||0==i)&&e.l<=s[i][1]&&(d=!1,e.l=s[i][1]),d)throw new Error("Read Error: Expected address "+s[i][1]+" at "+e.l+" :"+i)}if(t){var p=t[s[i][0]];if(u[p.n]=kn(e,p.t,{raw:!0}),"version"===p.p&&(u[p.n]=String(u[p.n]>>16)+"."+("0000"+String(65535&u[p.n])).slice(-4)),"CodePage"==p.n)switch(u[p.n]){case 0:u[p.n]=1252;case 874:case 932:case 936:case 949:case 950:case 1250:case 1251:case 1253:case 1254:case 1255:case 1256:case 1257:case 1258:case 1e4:case 1200:case 1201:case 1252:case 65e3:case-536:case 65001:case-535:ie(o=u[p.n]>>>0&65535);break;default:throw new Error("Unsupported CodePage: "+u[p.n])}}else if(1===s[i][0]){o=u.CodePage=kn(e,Oa);ie(o),-1!==c&&(g=e.l,e.l=s[c][1],l=Tn(e,o),e.l=g)}else if(0===s[i][0])0!==o?l=Tn(e,o):(c=i,e.l=s[i+1][1]);else{var m,g=l[s[i][0]];switch(e[e.l]){case 65:e.l+=4,m=En(e);break;case 30:case 31:e.l+=4,m=vn(e,e[e.l-4]).replace(/\u0000+$/,"");break;case 3:e.l+=4,m=e.read_shift(4,"i");break;case 19:e.l+=4,m=e.read_shift(4);break;case 5:e.l+=4,m=e.read_shift(8,"f");break;case 11:e.l+=4,m=On(e,4);break;case 64:e.l+=4,m=He(pn(e));break;default:throw new Error("unparsed value: "+e[e.l])}u[g]=m}}return e.l=r+a,u}var _n=["CodePage","Thumbnail","_PID_LINKBASE","_PID_HLINKS","SystemIdentifier","FMTID"];function xn(e,t,r){var a,n,s,i,o=Lr(8),c=[],l=[],f=8,h=0,u=Lr(8),d=Lr(8);if(u.write_shift(4,2),u.write_shift(4,1200),d.write_shift(4,1),l.push(u),c.push(d),f+=8+u.length,!t){(d=Lr(8)).write_shift(4,0),c.unshift(d);var p=[Lr(4)];for(p[0].write_shift(4,e.length),h=0;h<e.length;++h){var m=e[h][0];for((u=Lr(8+2*(m.length+1)+(m.length%2?0:2))).write_shift(4,h+2),u.write_shift(4,m.length+1),u.write_shift(0,m,"dbcs");u.l!=u.length;)u.write_shift(1,0);p.push(u)}u=ue(p),l.unshift(u),f+=8+u.length}for(h=0;h<e.length;++h)t&&!t[e[h][0]]||-1<_n.indexOf(e[h][0])||-1<on.indexOf(e[h][0])||null!=e[h][1]&&(s=e[h][1],a=0,u=t?("version"==(i=r[a=+t[e[h][0]]]).p&&"string"==typeof s&&(s=(+(n=s.split("."))[0]<<16)+(+n[1]||0)),yn(i.t,s)):(-1==(i=function(e){switch(typeof e){case"boolean":return 11;case"number":return(0|e)==e?3:5;case"string":return 31;case"object":if(e instanceof Date)return 64}return-1}(s))&&(i=31,s=String(s)),yn(i,s)),l.push(u),(d=Lr(8)).write_shift(4,t?a:2+h),c.push(d),f+=8+u.length);for(var g=8*(l.length+1),h=0;h<l.length;++h)c[h].write_shift(4,g),g+=l[h].length;return o.write_shift(4,f),o.write_shift(4,l.length),ue([o].concat(c).concat(l))}function An(e,t,r){var a=e.content;if(!a)return{};Dr(a,0);var n,s=0;a.chk("feff","Byte Order: "),a.read_shift(2);var i=a.read_shift(4),o=a.read_shift(16);if(o!==xe.utils.consts.HEADER_CLSID&&o!==r)throw new Error("Bad PropertySet CLSID "+o);if(1!==(e=a.read_shift(4))&&2!==e)throw new Error("Unrecognized #Sets: "+e);if(r=a.read_shift(16),o=a.read_shift(4),1===e&&o!==a.l)throw new Error("Length mismatch: "+o+" !== "+a.l);2===e&&(n=a.read_shift(16),s=a.read_shift(4));var c,l,f=Sn(a,t),h={SystemIdentifier:i};for(c in f)h[c]=f[c];if(h.FMTID=r,1===e)return h;if(s-a.l==2&&(a.l+=2),a.l!==s)throw new Error("Length mismatch 2: "+a.l+" !== "+s);try{l=Sn(a,null)}catch(e){}for(c in l)h[c]=l[c];return h.FMTID=[r,n],h}function Cn(e,t,r,a,n,s){var i=Lr(n?68:48),o=[i];i.write_shift(2,65534),i.write_shift(2,0),i.write_shift(4,842412599),i.write_shift(16,xe.utils.consts.HEADER_CLSID,"hex"),i.write_shift(4,n?2:1),i.write_shift(16,t,"hex"),i.write_shift(4,n?68:48);a=xn(e,r,a);return o.push(a),n&&(n=xn(n,null,null),i.write_shift(16,s,"hex"),i.write_shift(4,68+a.length),o.push(n)),ue(o)}function Rn(e,t){return e.read_shift(t),null}function On(e,t){return 1===e.read_shift(t)}function In(e,t){return(t=t||Lr(2)).write_shift(2,+!!e),t}function Nn(e){return e.read_shift(2,"u")}function Fn(e,t){return(t=t||Lr(2)).write_shift(2,e),t}function Dn(e,t){return function(e,t,r){for(var a=[],n=e.l+t;e.l<n;)a.push(r(e,n-e.l));if(n!==e.l)throw new Error("Slurp error");return a}(e,t,Nn)}function Pn(e,t,r){return(r=r||Lr(2)).write_shift(1,"e"==t?+e:+!!e),r.write_shift(1,"e"==t?1:0),r}function Ln(e,t,r){var a=e.read_shift(r&&12<=r.biff?2:1),n="sbcs-cont",s=f;r&&8<=r.biff&&(f=1200),r&&8!=r.biff?12==r.biff&&(n="wstr"):e.read_shift(1)&&(n="dbcs-cont"),2<=r.biff&&r.biff<=5&&(n="cpstr");n=a?e.read_shift(a,n):"";return f=s,n}function Mn(e,t,r){if(r){if(2<=r.biff&&r.biff<=5)return e.read_shift(t,"cpstr");if(12<=r.biff)return e.read_shift(t,"dbcs-cont")}return 0===e.read_shift(1)?e.read_shift(t,"sbcs-cont"):e.read_shift(t,"dbcs-cont")}function Un(e,t,r){var a=e.read_shift(r&&2==r.biff?1:2);return 0===a?(e.l++,""):Mn(e,a,r)}function Bn(e,t,r){if(5<r.biff)return Un(e,0,r);var a=e.read_shift(1);return 0===a?(e.l++,""):e.read_shift(a,r.biff<=4||!e.lens?"cpstr":"sbcs-cont")}function Wn(e,t,r){return(r=r||Lr(3+2*e.length)).write_shift(2,e.length),r.write_shift(1,1),r.write_shift(31,e,"utf16le"),r}function Hn(e){var t,r,a,n,s=e.read_shift(16);switch(s){case"e0c9ea79f9bace118c8200aa004ba90b":return r=(t=e).read_shift(4),a=t.l,n=!1,24<r&&(t.l+=r-24,"795881f43b1d7f48af2c825dc4852763"===t.read_shift(16)&&(n=!0),t.l=a),r=t.read_shift((n?r-24:r)>>1,"utf16le").replace(de,""),n&&(t.l+=24),r;case"0303000000000000c000000000000046":return function(e){for(var t=e.read_shift(2),r="";0<t--;)r+="../";var a=e.read_shift(0,"lpstr-ansi");if(e.l+=2,57005!=e.read_shift(2))throw new Error("Bad FileMoniker");if(0===e.read_shift(4))return r+a.replace(/\\/g,"/");if(a=e.read_shift(4),3!=e.read_shift(2))throw new Error("Bad FileMoniker");return r+e.read_shift(a>>1,"utf16le").replace(de,"")}(e);default:throw new Error("Unsupported Moniker "+s)}}function zn(e){var t=e.read_shift(4);return 0<t?e.read_shift(t,"utf16le").replace(de,""):""}function Vn(e,t){(t=t||Lr(6+2*e.length)).write_shift(4,1+e.length);for(var r=0;r<e.length;++r)t.write_shift(2,e.charCodeAt(r));return t.write_shift(2,0),t}function Gn(e){return[e.read_shift(1),e.read_shift(1),e.read_shift(1),e.read_shift(1)]}function jn(e){e=Gn(e);return e[3]=0,e}function $n(e){return{r:e.read_shift(2),c:e.read_shift(2),ixfe:e.read_shift(2)}}function Xn(e,t,r,a){return(a=a||Lr(6)).write_shift(2,e),a.write_shift(2,t),a.write_shift(2,r||0),a}function Yn(e){return[e.read_shift(2),Ea(e)]}function Kn(e){var t=e.read_shift(2),r=e.read_shift(2);return{s:{c:e.read_shift(2),r:t},e:{c:e.read_shift(2),r:r}}}function Jn(e,t){return(t=t||Lr(8)).write_shift(2,e.s.r),t.write_shift(2,e.e.r),t.write_shift(2,e.s.c),t.write_shift(2,e.e.c),t}function qn(e){var t=e.read_shift(2),r=e.read_shift(2);return{s:{c:e.read_shift(1),r:t},e:{c:e.read_shift(1),r:r}}}var Zn=qn;function Qn(e){e.l+=4;var t=e.read_shift(2),r=e.read_shift(2),a=e.read_shift(2);return e.l+=12,[r,t,a]}function es(e){e.l+=2,e.l+=e.read_shift(2)}var ts={0:es,4:es,5:es,6:es,7:function(e){return e.l+=4,e.cf=e.read_shift(2),{}},8:es,9:es,10:es,11:es,12:es,13:function(e){var t={};return e.l+=4,e.l+=16,t.fSharedNote=e.read_shift(2),e.l+=4,t},14:es,15:es,16:es,17:es,18:es,19:es,20:es,21:Qn};function rs(e,t){var r={BIFFVer:0,dt:0};switch(r.BIFFVer=e.read_shift(2),2<=(t-=2)&&(r.dt=e.read_shift(2),e.l-=2),r.BIFFVer){case 1536:case 1280:case 1024:case 768:case 512:case 2:case 7:break;default:if(6<t)throw new Error("Unexpected BIFF Ver "+r.BIFFVer)}return e.read_shift(t),r}function as(e,t,r){var a=1536,n=16;switch(r.bookType){case"biff8":break;case"biff5":a=1280,n=8;break;case"biff4":a=4,n=6;break;case"biff3":a=3,n=6;break;case"biff2":a=2,n=4;break;case"xla":break;default:throw new Error("unsupported BIFF version")}r=Lr(n);return r.write_shift(2,a),r.write_shift(2,t),4<n&&r.write_shift(2,29282),6<n&&r.write_shift(2,1997),8<n&&(r.write_shift(2,49161),r.write_shift(2,1),r.write_shift(2,1798),r.write_shift(2,0)),r}function ns(e){var t=Lr(8);t.write_shift(4,e.Count),t.write_shift(4,e.Unique);for(var r,a,n,s=[],i=0;i<e.length;++i)s[i]=(r=e[i],n=a=void 0,a=r.t||"",(n=Lr(3)).write_shift(2,a.length),n.write_shift(1,1),(r=Lr(2*a.length)).write_shift(2*a.length,a,"utf16le"),ue([n,r]));var o=ue([t].concat(s));return o.parts=[t.length].concat(s.map(function(e){return e.length})),o}function ss(e,t,r){var a=0;r&&2==r.biff||(a=e.read_shift(2));e=e.read_shift(2);return r&&2==r.biff&&(a=1-(e>>15),e&=32767),[{Unsynced:1&a,DyZero:(2&a)>>1,ExAsc:(4&a)>>2,ExDsc:(8&a)>>3},e]}var is=Bn;function os(e,t,r){var a=e.l+t,n=8!=r.biff&&r.biff?2:4,s=e.read_shift(n),t=e.read_shift(n),r=e.read_shift(2),n=e.read_shift(2);return e.l=a,{s:{r:s,c:r},e:{r:t,c:n}}}function cs(e,t,r,a){r=r&&5==r.biff;(a=a||Lr(r?16:20)).write_shift(2,0),e.style?(a.write_shift(2,e.numFmtId||0),a.write_shift(2,65524)):(a.write_shift(2,e.numFmtId||0),a.write_shift(2,t<<4));t=0;return 0<e.numFmtId&&r&&(t|=1024),a.write_shift(4,t),a.write_shift(4,0),r||a.write_shift(4,0),a.write_shift(2,0),a}function ls(e,t,r){var a=$n(e);2!=r.biff&&9!=t||++e.l;e=(t=e).read_shift(1),e=1===t.read_shift(1)?e:1===e;return a.val=e,a.t=!0===e||!1===e?"b":"e",a}function fs(e,t,r){return 0===t?"":Bn(e,0,r)}function hs(e,t,r){var a,n=e.read_shift(2),n={fBuiltIn:1&n,fWantAdvise:n>>>1&1,fWantPict:n>>>2&1,fOle:n>>>3&1,fOleLink:n>>>4&1,cf:n>>>5&1023,fIcon:n>>>15&1};return 14849===r.sbcch&&(a=function(e,t,r){e.l+=4,t-=4;var a=e.l+t,t=Ln(e,0,r);if((r=e.read_shift(2))!==(a-=e.l))throw new Error("Malformed AddinUdf: padding = "+a+" != "+r);return e.l+=r,t}(e,t-2,r)),n.body=a||e.read_shift(t-2),"string"==typeof a&&(n.Name=a),n}var us=["_xlnm.Consolidate_Area","_xlnm.Auto_Open","_xlnm.Auto_Close","_xlnm.Extract","_xlnm.Database","_xlnm.Criteria","_xlnm.Print_Area","_xlnm.Print_Titles","_xlnm.Recorder","_xlnm.Data_Form","_xlnm.Auto_Activate","_xlnm.Auto_Deactivate","_xlnm.Sheet_Title","_xlnm._FilterDatabase"];function ds(e,t,r){var a=e.l+t,n=e.read_shift(2),s=e.read_shift(1),i=e.read_shift(1),o=e.read_shift(r&&2==r.biff?1:2),t=0;(!r||5<=r.biff)&&(5!=r.biff&&(e.l+=2),t=e.read_shift(2),5==r.biff&&(e.l+=2),e.l+=4);i=Mn(e,i,r);32&n&&(i=us[i.charCodeAt(0)]);n=a-e.l;return r&&2==r.biff&&--n,{chKey:s,Name:i,itab:t,rgce:a!=e.l&&0!==o&&0<n?function(e,t,r,a){var n,t=e.l+t,a=Ic(e,a,r);t!==e.l&&(n=Oc(e,t-e.l,a,r));return[a,n]}(e,n,r,o):[]}}function ps(e,t,r){if(r.biff<8)return function(e,t){3==e[e.l+1]&&e[e.l]++;t=Ln(e,0,t);return 3==t.charCodeAt(0)?t.slice(1):t}(e,r);for(var a,n,s=[],t=e.l+t,i=e.read_shift(8<r.biff?4:2);0!=i--;)s.push((a=e,r.biff,n=8<(n=r).biff?4:2,[a.read_shift(n),a.read_shift(n,"i"),a.read_shift(n,"i")]));if(e.l!=t)throw new Error("Bad ExternSheet: "+e.l+" != "+t);return s}function ms(e,t,r){var a=Zn(e,6);switch(r.biff){case 2:e.l++,t-=7;break;case 3:case 4:e.l+=2,t-=8;break;default:e.l+=6,t-=12}return[a,function(e,t,r){var a,n=e.l+t,s=2==r.biff?1:2,i=e.read_shift(s);if(65535==i)return[[],Pr(e,t-2)];var o=Ic(e,i,r);t!==i+s&&(a=Oc(e,t-i-s,o,r));return e.l=n,[o,a]}(e,t,r)]}var gs={8:function(e,t){var r=e.l+t;e.l+=10;var a=e.read_shift(2);e.l+=4,e.l+=2,e.l+=2,e.l+=2,e.l+=4;t=e.read_shift(1);return e.l+=t,e.l=r,{fmt:a}}};function bs(e){var t=Lr(24),r=Yr(e[0]);t.write_shift(2,r.r),t.write_shift(2,r.r),t.write_shift(2,r.c),t.write_shift(2,r.c);for(var a="d0 c9 ea 79 f9 ba ce 11 8c 82 00 aa 00 4b a9 0b".split(" "),n=0;n<16;++n)t.write_shift(1,parseInt(a[n],16));return ue([t,function(e){var t=Lr(512),r=0,a=e.Target,n=-1<(e=(a="file://"==a.slice(0,7)?a.slice(7):a).indexOf("#"))?31:23;switch(a.charAt(0)){case"#":n=28;break;case".":n&=-3}t.write_shift(4,2),t.write_shift(4,n);for(var s=[8,6815827,6619237,4849780,83],r=0;r<s.length;++r)t.write_shift(4,s[r]);if(28==n)Vn(a=a.slice(1),t);else if(2&n){for(s="e0 c9 ea 79 f9 ba ce 11 8c 82 00 aa 00 4b a9 0b".split(" "),r=0;r<s.length;++r)t.write_shift(1,parseInt(s[r],16));var i=-1<e?a.slice(0,e):a;for(t.write_shift(4,2*(i.length+1)),r=0;r<i.length;++r)t.write_shift(2,i.charCodeAt(r));t.write_shift(2,0),8&n&&Vn(-1<e?a.slice(e+1):"",t)}else{for(s="03 03 00 00 00 00 00 00 c0 00 00 00 00 00 00 46".split(" "),r=0;r<s.length;++r)t.write_shift(1,parseInt(s[r],16));for(var o=0;"../"==a.slice(3*o,3*o+3)||"..\\"==a.slice(3*o,3*o+3);)++o;for(t.write_shift(2,o),t.write_shift(4,a.length-3*o+1),r=0;r<a.length-3*o;++r)t.write_shift(1,255&a.charCodeAt(r+3*o));for(t.write_shift(1,0),t.write_shift(2,65535),t.write_shift(2,57005),r=0;r<6;++r)t.write_shift(4,0)}return t.slice(0,t.l)}(e[1])])}function vs(e,t,r){if(!r.cellStyles)return Pr(e,t);var a=r&&12<=r.biff?4:2,n=e.read_shift(a),s=e.read_shift(a),i=e.read_shift(a),o=e.read_shift(a),t=e.read_shift(2);2==a&&(e.l+=2);o={s:n,e:s,w:i,ixfe:o,flags:t};return(5<=r.biff||!r.biff)&&(o.level=t>>8&7),o}var ws=$n,Ts=Dn,Es=Un;var ks,ys,Ss,_s=[2,3,48,49,131,139,140,245],xs=(ks={1:437,2:850,3:1252,4:1e4,100:852,101:866,102:865,103:861,104:895,105:620,106:737,107:857,120:950,121:949,122:936,123:932,124:874,125:1255,126:1256,150:10007,151:10029,152:10006,200:1250,201:1251,202:1254,203:1253,0:20127,8:865,9:437,10:850,11:437,13:437,14:850,15:437,16:850,17:437,18:850,19:932,20:850,21:437,22:850,23:865,24:437,25:437,26:850,27:437,28:863,29:850,31:852,34:852,35:852,36:860,37:850,38:866,55:850,64:852,77:936,78:949,79:950,80:874,87:1252,88:1252,89:1252,108:863,134:737,135:852,136:857,204:1257,255:16969},ys=Ie({1:437,2:850,3:1252,4:1e4,100:852,101:866,102:865,103:861,104:895,105:620,106:737,107:857,120:950,121:949,122:936,123:932,124:874,125:1255,126:1256,150:10007,151:10029,152:10006,200:1250,201:1251,202:1254,203:1253,0:20127}),Ss={B:8,C:250,L:1,D:8,"?":0,"":0},{to_workbook:function(e,t){try{return ta(As(e,t),t)}catch(e){if(t&&t.WTF)throw e}return{SheetNames:[],Sheets:{}}},to_sheet:As,from_sheet:function(e,t){if(0<=+(t=t||{}).codepage&&ie(+t.codepage),"string"==t.type)throw new Error("Cannot write DBF to JS string");for(var r=Ur(),a=(t=iu(e,{header:1,raw:!0,cellDates:!0}))[0],n=t.slice(1),s=e["!cols"]||[],i=0,o=0,c=0,l=1,i=0;i<a.length;++i)if(((s[i]||{}).DBF||{}).name)a[i]=s[i].DBF.name,++c;else if(null!=a[i]){if(++c,"number"==typeof a[i]&&(a[i]=a[i].toString(10)),"string"!=typeof a[i])throw new Error("DBF Invalid column name "+a[i]+" |"+typeof a[i]+"|");if(a.indexOf(a[i])!==i)for(o=0;o<1024;++o)if(-1==a.indexOf(a[i]+"_"+o)){a[i]+="_"+o;break}}var f=Zr(e["!ref"]),h=[],u=[],d=[];for(i=0;i<=f.e.c-f.s.c;++i){for(var p="",m="",g=0,b=[],o=0;o<n.length;++o)null!=n[o][i]&&b.push(n[o][i]);if(0!=b.length&&null!=a[i]){for(o=0;o<b.length;++o){switch(typeof b[o]){case"number":m="B";break;case"string":m="C";break;case"boolean":m="L";break;case"object":m=b[o]instanceof Date?"D":"C";break;default:m="C"}g=Math.max(g,String(b[o]).length),p=p&&p!=m?"C":m}250<g&&(g=250),"C"==(m=((s[i]||{}).DBF||{}).type)&&s[i].DBF.len>g&&(g=s[i].DBF.len),"B"==p&&"N"==m&&(p="N",d[i]=s[i].DBF.dec,g=s[i].DBF.len),u[i]="C"==p||"N"==m?g:Ss[p]||0,l+=u[i],h[i]=p}else h[i]="?"}var v,w,T=r.next(32);for(T.write_shift(4,318902576),T.write_shift(4,n.length),T.write_shift(2,296+32*c),T.write_shift(2,l),i=0;i<4;++i)T.write_shift(4,0);for(T.write_shift(4,0|(+ys[_]||3)<<8),o=i=0;i<a.length;++i)null!=a[i]&&(v=r.next(32),w=(a[i].slice(-10)+"\0\0\0\0\0\0\0\0\0\0\0").slice(0,11),v.write_shift(1,w,"sbcs"),v.write_shift(1,"?"==h[i]?"C":h[i],"sbcs"),v.write_shift(4,o),v.write_shift(1,u[i]||Ss[h[i]]||0),v.write_shift(1,d[i]||0),v.write_shift(1,2),v.write_shift(4,0),v.write_shift(1,0),v.write_shift(4,0),v.write_shift(4,0),o+=u[i]||Ss[h[i]]||0);var E=r.next(264);for(E.write_shift(4,13),i=0;i<65;++i)E.write_shift(4,0);for(i=0;i<n.length;++i){var k=r.next(l);for(k.write_shift(1,0),o=0;o<a.length;++o)if(null!=a[o])switch(h[o]){case"L":k.write_shift(1,null==n[i][o]?63:n[i][o]?84:70);break;case"B":k.write_shift(8,n[i][o]||0,"f");break;case"N":var y="0";for("number"==typeof n[i][o]&&(y=n[i][o].toFixed(d[o]||0)),c=0;c<u[o]-y.length;++c)k.write_shift(1,32);k.write_shift(1,y,"sbcs");break;case"D":n[i][o]?(k.write_shift(4,("0000"+n[i][o].getFullYear()).slice(-4),"sbcs"),k.write_shift(2,("00"+(n[i][o].getMonth()+1)).slice(-2),"sbcs"),k.write_shift(2,("00"+n[i][o].getDate()).slice(-2),"sbcs")):k.write_shift(8,"00000000","sbcs");break;case"C":var S=String(null!=n[i][o]?n[i][o]:"").slice(0,u[o]);for(k.write_shift(1,S,"sbcs"),c=0;c<u[o]-S.length;++c)k.write_shift(1,32)}}return r.next(1).write_shift(1,26),r.end()}});function As(e,t){t=t||{};t.dateNF||(t.dateNF="yyyymmdd");e=aa(function(e,t){var r=[],a=le(1);switch(t.type){case"base64":a=he(te(e));break;case"binary":a=he(e);break;case"buffer":case"array":a=e}Dr(a,0);var n=a.read_shift(1),s=!!(136&n),i=!1,o=!1;switch(n){case 2:case 3:break;case 48:case 49:s=i=!0;break;case 131:case 139:break;case 140:o=!0;break;case 245:break;default:throw new Error("DBF Unsupported Version: "+n.toString(16))}var c=0,l=521;2==n&&(c=a.read_shift(2)),a.l+=3,1048576<(c=2!=n?a.read_shift(4):c)&&(c=1e6),2!=n&&(l=a.read_shift(2));var f=a.read_shift(2),h=t.codepage||1252;2!=n&&(a.l+=16,a.read_shift(1),0!==a[a.l]&&(h=ks[a[a.l]]),a.l+=1,a.l+=2),o&&(a.l+=36);for(var u=[],d={},p=Math.min(a.length,2==n?521:l-10-(i?264:0)),m=o?32:11;a.l<p&&13!=a[a.l];)switch((d={}).name=re.utils.decode(h,a.slice(a.l,a.l+m)).replace(/[\u0000\r\n].*$/g,""),a.l+=m,d.type=String.fromCharCode(a.read_shift(1)),2==n||o||(d.offset=a.read_shift(4)),d.len=a.read_shift(1),2==n&&(d.offset=a.read_shift(2)),d.dec=a.read_shift(1),d.name.length&&u.push(d),2!=n&&(a.l+=o?13:14),d.type){case"B":i&&8==d.len||!t.WTF||console.log("Skipping "+d.name+":"+d.type);break;case"G":case"P":t.WTF&&console.log("Skipping "+d.name+":"+d.type);break;case"+":case"0":case"@":case"C":case"D":case"F":case"I":case"L":case"M":case"N":case"O":case"T":case"Y":break;default:throw new Error("Unknown Field Type: "+d.type)}if(13!==a[a.l]&&(a.l=l-1),13!==a.read_shift(1))throw new Error("DBF Terminator not found "+a.l+" "+a[a.l]);a.l=l;var g=0,b=0;for(r[0]=[],b=0;b!=u.length;++b)r[0][b]=u[b].name;for(;0<c--;)if(42!==a[a.l])for(++a.l,r[++g]=[],b=b=0;b!=u.length;++b){var v=a.slice(a.l,a.l+u[b].len);a.l+=u[b].len,Dr(v,0);var w=re.utils.decode(h,v);switch(u[b].type){case"C":w.trim().length&&(r[g][b]=w.replace(/\s+$/,""));break;case"D":8===w.length?r[g][b]=new Date(+w.slice(0,4),+w.slice(4,6)-1,+w.slice(6,8)):r[g][b]=w;break;case"F":r[g][b]=parseFloat(w.trim());break;case"+":case"I":r[g][b]=o?2147483648^v.read_shift(-4,"i"):v.read_shift(4,"i");break;case"L":switch(w.trim().toUpperCase()){case"Y":case"T":r[g][b]=!0;break;case"N":case"F":r[g][b]=!1;break;case"":case"?":break;default:throw new Error("DBF Unrecognized L:|"+w+"|")}break;case"M":if(!s)throw new Error("DBF Unexpected MEMO for type "+n.toString(16));r[g][b]="##MEMO##"+(o?parseInt(w.trim(),10):v.read_shift(4));break;case"N":(w=w.replace(/\u0000/g,"").trim())&&"."!=w&&(r[g][b]=+w||0);break;case"@":r[g][b]=new Date(v.read_shift(-8,"f")-621356832e5);break;case"T":r[g][b]=new Date(864e5*(v.read_shift(4)-2440588)+v.read_shift(4));break;case"Y":r[g][b]=v.read_shift(4,"i")/1e4+v.read_shift(4,"i")/1e4*Math.pow(2,32);break;case"O":r[g][b]=-v.read_shift(-8,"f");break;case"B":if(i&&8==u[b].len){r[g][b]=v.read_shift(8,"f");break}case"G":case"P":v.l+=u[b].len;break;case"0":if("_NullFlags"===u[b].name)break;default:throw new Error("DBF Unsupported data type "+u[b].type)}}else a.l+=f;if(2!=n&&a.l<a.length&&26!=a[a.l++])throw new Error("DBF EOF Marker missing "+(a.l-1)+" of "+a.length+" "+a[a.l-1].toString(16));return t&&t.sheetRows&&(r=r.slice(0,t.sheetRows)),t.DBF=u,r}(e,t),t);return e["!cols"]=t.DBF.map(function(e){return{wch:e.len,DBF:e}}),delete t.DBF,e}var Cs,Rs,Os,Is,Ns=(Cs={AA:"À",BA:"Á",CA:"Â",DA:195,HA:"Ä",JA:197,AE:"È",BE:"É",CE:"Ê",HE:"Ë",AI:"Ì",BI:"Í",CI:"Î",HI:"Ï",AO:"Ò",BO:"Ó",CO:"Ô",DO:213,HO:"Ö",AU:"Ù",BU:"Ú",CU:"Û",HU:"Ü",Aa:"à",Ba:"á",Ca:"â",Da:227,Ha:"ä",Ja:229,Ae:"è",Be:"é",Ce:"ê",He:"ë",Ai:"ì",Bi:"í",Ci:"î",Hi:"ï",Ao:"ò",Bo:"ó",Co:"ô",Do:245,Ho:"ö",Au:"ù",Bu:"ú",Cu:"û",Hu:"ü",KC:"Ç",Kc:"ç",q:"æ",z:"œ",a:"Æ",j:"Œ",DN:209,Dn:241,Hy:255,S:169,c:170,R:174,"B ":180,0:176,1:177,2:178,3:179,5:181,6:182,7:183,Q:185,k:186,b:208,i:216,l:222,s:240,y:248,"!":161,'"':162,"#":163,"(":164,"%":165,"'":167,"H ":168,"+":171,";":187,"<":188,"=":189,">":190,"?":191,"{":223},Rs=new RegExp("N("+Re(Cs).join("|").replace(/\|\|\|/,"|\\||").replace(/([?()+])/g,"\\$1")+"|\\|)","gm"),Os=function(e,t){t=Cs[t];return"number"==typeof t?n(t):t},Is=function(e,t,r){r=t.charCodeAt(0)-32<<4|r.charCodeAt(0)-48;return 59==r?e:n(r)},Cs["|"]=254,{to_workbook:function(e,t){return ta(Ds(e,t),t)},to_sheet:Ds,from_sheet:function(e,t){var r,a,n=["ID;PWXL;N;E"],s=[],i=Zr(e["!ref"]),o=Array.isArray(e),c="\r\n";n.push("P;PGeneral"),n.push("F;P0;DG0G8;M255"),e["!cols"]&&(r=n,e["!cols"].forEach(function(e,t){t="F;W"+(t+1)+" "+(t+1)+" ";e.hidden?t+="0":("number"!=typeof e.width||e.wpx||(e.wpx=so(e.width)),"number"!=typeof e.wpx||e.wch||(e.wch=io(e.wpx)),"number"==typeof e.wch&&(t+=Math.round(e.wch)))," "!=t.charAt(t.length-1)&&r.push(t)})),e["!rows"]&&(a=n,e["!rows"].forEach(function(e,t){var r="F;";e.hidden?r+="M0;":e.hpt?r+="M"+20*e.hpt+";":e.hpx&&(r+="M"+20*uo(e.hpx)+";"),2<r.length&&a.push(r+"R"+(t+1))})),n.push("B;Y"+(i.e.r-i.s.r+1)+";X"+(i.e.c-i.s.c+1)+";D"+[i.s.c,i.s.r,i.e.c,i.e.r].join(" "));for(var l=i.s.r;l<=i.e.r;++l)for(var f=i.s.c;f<=i.e.c;++f){var h=Kr({r:l,c:f});(h=o?(e[l]||[])[f]:e[h])&&(null!=h.v||h.f&&!h.F)&&s.push(function(e,t,r){var a="C;Y"+(t+1)+";X"+(r+1)+";K";switch(e.t){case"n":a+=e.v||0,e.f&&!e.F&&(a+=";E"+fc(e.f,{r:t,c:r}));break;case"b":a+=e.v?"TRUE":"FALSE";break;case"e":a+=e.w||e.v;break;case"d":a+='"'+(e.w||e.v)+'"';break;case"s":a+='"'+e.v.replace(/"/g,"").replace(/;/g,";;")+'"'}return a}(h,l,f))}return n.join(c)+c+s.join(c)+c+"E"+c}});function Fs(e,t){var r,a,n=e.split(/[\n\r]+/),s=-1,i=-1,o=0,c=0,l=[],f=[],h=null,e={},u=[],d=[],p=0;for(0<=+t.codepage&&ie(+t.codepage);o!==n.length;++o){p=0;var m,g=n[o].trim().replace(/\x1B([\x20-\x2F])([\x30-\x3F])/g,Is).replace(Rs,Os),b=g.replace(/;;/g,"\0").split(";").map(function(e){return e.replace(/\u0000/g,";")}),v=b[0];if(0<g.length)switch(v){case"ID":case"E":case"B":case"O":case"W":break;case"P":"P"==b[1].charAt(0)&&f.push(g.slice(3).replace(/;;/g,";"));break;case"C":for(var w=!1,T=!1,E=!1,k=!1,y=-1,S=-1,c=1;c<b.length;++c)switch(b[c].charAt(0)){case"A":break;case"X":i=parseInt(b[c].slice(1))-1,T=!0;break;case"Y":for(s=parseInt(b[c].slice(1))-1,T||(i=0),a=l.length;a<=s;++a)l[a]=[];break;case"K":'"'===(m=b[c].slice(1)).charAt(0)?m=m.slice(1,m.length-1):"TRUE"===m?m=!0:"FALSE"===m?m=!1:isNaN(je(m))?isNaN(Xe(m).getDate())||(m=He(m)):(m=je(m),null!==h&&q(h)&&(m=Me(m))),void 0!==re&&"string"==typeof m&&"string"!=(t||{}).type&&(t||{}).codepage&&(m=re.utils.decode(t.codepage,m)),w=!0;break;case"E":k=!0;var _=oc(b[c].slice(1),{r:s,c:i});l[s][i]=[l[s][i],_];break;case"S":E=!0,l[s][i]=[l[s][i],"S5S"];break;case"G":break;case"R":y=parseInt(b[c].slice(1))-1;break;case"C":S=parseInt(b[c].slice(1))-1;break;default:if(t&&t.WTF)throw new Error("SYLK bad record "+g)}if(w&&(l[s][i]&&2==l[s][i].length?l[s][i][0]=m:l[s][i]=m,h=null),E){if(k)throw new Error("SYLK shared formula cannot have own formula");var x=-1<y&&l[y][S];if(!x||!x[1])throw new Error("SYLK shared formula cannot find base");l[s][i][1]=hc(x[1],{r:s-y,c:i-S})}break;case"F":var A=0;for(c=1;c<b.length;++c)switch(b[c].charAt(0)){case"X":i=parseInt(b[c].slice(1))-1,++A;break;case"Y":for(s=parseInt(b[c].slice(1))-1,a=l.length;a<=s;++a)l[a]=[];break;case"M":p=parseInt(b[c].slice(1))/20;break;case"F":case"G":break;case"P":h=f[parseInt(b[c].slice(1))];break;case"S":case"D":case"N":break;case"W":for(r=b[c].slice(1).split(" "),a=parseInt(r[0],10);a<=parseInt(r[1],10);++a)p=parseInt(r[2],10),d[a-1]=0===p?{hidden:!0}:{wch:p},fo(d[a-1]);break;case"C":d[i=parseInt(b[c].slice(1))-1]||(d[i]={});break;case"R":u[s=parseInt(b[c].slice(1))-1]||(u[s]={}),0<p?(u[s].hpt=p,u[s].hpx=po(p)):0===p&&(u[s].hidden=!0);break;default:if(t&&t.WTF)throw new Error("SYLK bad record "+g)}A<1&&(h=null);break;default:if(t&&t.WTF)throw new Error("SYLK bad record "+g)}}return 0<u.length&&(e["!rows"]=u),0<d.length&&(e["!cols"]=d),[l=t&&t.sheetRows?l.slice(0,t.sheetRows):l,e]}function Ds(e,t){var r=function(e,t){switch(t.type){case"base64":return Fs(te(e),t);case"binary":return Fs(e,t);case"buffer":return Fs(se&&Buffer.isBuffer(e)?e.toString("binary"):i(e),t);case"array":return Fs(ze(e),t)}throw new Error("Unrecognized type "+t.type)}(e,t),e=r[0],a=r[1],n=aa(e,t);return Re(a).forEach(function(e){n[e]=a[e]}),n}var Ps={to_workbook:function(e,t){return ta(Ms(e,t),t)},to_sheet:Ms,from_sheet:function(e){var t=[],r=Zr(e["!ref"]),a=Array.isArray(e);Us(t,"TABLE",0,1,"sheetjs"),Us(t,"VECTORS",0,r.e.r-r.s.r+1,""),Us(t,"TUPLES",0,r.e.c-r.s.c+1,""),Us(t,"DATA",0,0,"");for(var n=r.s.r;n<=r.e.r;++n){Bs(t,-1,0,"BOT");for(var s=r.s.c;s<=r.e.c;++s){var i,o=Kr({r:n,c:s});if(i=a?(e[n]||[])[s]:e[o])switch(i.t){case"n":var c=d?i.w:i.v;null==(c=!c&&null!=i.v?i.v:c)?d&&i.f&&!i.F?Bs(t,1,0,"="+i.f):Bs(t,1,0,""):Bs(t,0,c,"V");break;case"b":Bs(t,0,i.v?1:0,i.v?"TRUE":"FALSE");break;case"s":Bs(t,1,0,!d||isNaN(i.v)?i.v:'="'+i.v+'"');break;case"d":i.w||(i.w=ve(i.z||me[14],De(He(i.v)))),d?Bs(t,0,i.w,"V"):Bs(t,1,0,i.w);break;default:Bs(t,1,0,"")}else Bs(t,1,0,"")}}Bs(t,-1,0,"EOD");return t.join("\r\n")}};function Ls(e,t){for(var r=e.split("\n"),a=-1,n=-1,s=0,i=[];s!==r.length;++s)if("BOT"!==r[s].trim()){if(!(a<0)){for(var o=r[s].trim().split(","),c=o[0],l=o[1],f=r[++s]||"";1&(f.match(/["]/g)||[]).length&&s<r.length-1;)f+="\n"+r[++s];switch(f=f.trim(),+c){case-1:if("BOT"===f){i[++a]=[],n=0;continue}if("EOD"!==f)throw new Error("Unrecognized DIF special command "+f);break;case 0:"TRUE"===f?i[a][n]=!0:"FALSE"===f?i[a][n]=!1:isNaN(je(l))?isNaN(Xe(l).getDate())?i[a][n]=l:i[a][n]=He(l):i[a][n]=je(l),++n;break;case 1:f=(f=f.slice(1,f.length-1)).replace(/""/g,'"'),d&&f&&f.match(/^=".*"$/)&&(f=f.slice(2,-1)),i[a][n++]=""!==f?f:null}if("EOD"===f)break}}else i[++a]=[],n=0;return i=t&&t.sheetRows?i.slice(0,t.sheetRows):i}function Ms(e,t){return aa(function(e,t){switch(t.type){case"base64":return Ls(te(e),t);case"binary":return Ls(e,t);case"buffer":return Ls(se&&Buffer.isBuffer(e)?e.toString("binary"):i(e),t);case"array":return Ls(ze(e),t)}throw new Error("Unrecognized type "+t.type)}(e,t),t)}function Us(e,t,r,a,n){e.push(t),e.push(r+","+a),e.push('"'+n.replace(/"/g,'""')+'"')}function Bs(e,t,r,a){e.push(t+","+r),e.push(1==t?'"'+a.replace(/"/g,'""')+'"':a)}var Ws,Hs,zs,Vs,Gs=(Ws=["socialcalc:version:1.5","MIME-Version: 1.0","Content-Type: multipart/mixed; boundary=SocialCalcSpreadsheetControlSave"].join("\n"),Hs=["--SocialCalcSpreadsheetControlSave","Content-type: text/plain; charset=UTF-8"].join("\n")+"\n",zs=["# SocialCalc Spreadsheet Control Save","part:sheet"].join("\n"),Vs="--SocialCalcSpreadsheetControlSave--",{to_workbook:function(e,t){return ta($s(e,t),t)},to_sheet:$s,from_sheet:function(e){return[Ws,Hs,zs,Hs,function(e){if(!e||!e["!ref"])return"";for(var t,r,a=[],n=[],s=Jr(e["!ref"]),i=Array.isArray(e),o=s.s.r;o<=s.e.r;++o)for(var c=s.s.c;c<=s.e.c;++c)if(r=Kr({r:o,c:c}),(t=i?(e[o]||[])[c]:e[r])&&null!=t.v&&"z"!==t.t){switch(n=["cell",r,"t"],t.t){case"s":case"str":n.push(js(t.v));break;case"n":t.f?(n[2]="vtf",n[3]="n",n[4]=t.v,n[5]=js(t.f)):(n[2]="v",n[3]=t.v);break;case"b":n[2]="vt"+(t.f?"f":"c"),n[3]="nl",n[4]=t.v?"1":"0",n[5]=js(t.f||(t.v?"TRUE":"FALSE"));break;case"d":var l=De(He(t.v));n[2]="vtc",n[3]="nd",n[4]=""+l,n[5]=t.w||ve(t.z||me[14],l);break;case"e":continue}a.push(n.join(":"))}return a.push("sheet:c:"+(s.e.c-s.s.c+1)+":r:"+(s.e.r-s.s.r+1)+":tvf:1"),a.push("valueformat:1:text-wiki"),a.join("\n")}(e),Vs].join("\n")}});function js(e){return e.replace(/\\/g,"\\b").replace(/:/g,"\\c").replace(/\n/g,"\\n")}function $s(e,t){return aa(function(e,t){for(var r,a=e.split("\n"),n=-1,s=0,i=[];s!==a.length;++s){var o=a[s].trim().split(":");if("cell"===o[0]){var c=Yr(o[1]);if(i.length<=c.r)for(n=i.length;n<=c.r;++n)i[n]||(i[n]=[]);switch(n=c.r,r=c.c,o[2]){case"t":i[n][r]=o[3].replace(/\\b/g,"\\").replace(/\\c/g,":").replace(/\\n/g,"\n");break;case"v":i[n][r]=+o[3];break;case"vtf":var l=o[o.length-1];case"vtc":"nl"===o[3]?i[n][r]=!!+o[4]:i[n][r]=+o[4],"vtf"==o[2]&&(i[n][r]=[i[n][r],l])}}}return i=t&&t.sheetRows?i.slice(0,t.sheetRows):i}(e,t),t)}var Xs,Ys,Ks=(Xs={44:",",9:"\t",59:";",124:"|"},Ys={44:3,9:2,59:1,124:0},{to_workbook:function(e,t){return ta(ei(e,t),t)},to_sheet:ei,from_sheet:function(e){for(var t=[],r=Zr(e["!ref"]),a=Array.isArray(e),n=r.s.r;n<=r.e.r;++n){for(var s=[],i=r.s.c;i<=r.e.c;++i){var o=Kr({r:n,c:i});if((o=a?(e[n]||[])[i]:e[o])&&null!=o.v){for(var c=(o.w||(ea(o),o.w)||"").slice(0,10);c.length<10;)c+=" ";s.push(c+(0===i?" ":""))}else s.push("          ")}t.push(s.join(""))}return t.join("\n")}});function Js(e,t,r,a,n){n.raw?t[r][a]=e:""===e||("TRUE"===e?t[r][a]=!0:"FALSE"===e?t[r][a]=!1:isNaN(je(e))?isNaN(Xe(e).getDate())?t[r][a]=e:t[r][a]=He(e):t[r][a]=je(e))}function qs(e){for(var t={},r=!1,a=0,n=0;a<e.length;++a)34==(n=e.charCodeAt(a))?r=!r:!r&&n in Xs&&(t[n]=(t[n]||0)+1);for(a in n=[],t)Object.prototype.hasOwnProperty.call(t,a)&&n.push([t[a],a]);if(!n.length)for(a in t=Ys)Object.prototype.hasOwnProperty.call(t,a)&&n.push([t[a],a]);return n.sort(function(e,t){return e[0]-t[0]||Ys[e[1]]-Ys[t[1]]}),Xs[n.pop()[1]]||44}function Zs(a,e){var n=e||{},e="";null!=oe&&null==n.dense&&(n.dense=oe);var s=n.dense?[]:{},i={s:{c:0,r:0},e:{c:0,r:0}};"sep="==a.slice(0,4)?13==a.charCodeAt(5)&&10==a.charCodeAt(6)?(e=a.charAt(4),a=a.slice(7)):13==a.charCodeAt(5)||10==a.charCodeAt(5)?(e=a.charAt(4),a=a.slice(6)):e=qs(a.slice(0,1024)):e=n&&n.FS?n.FS:qs(a.slice(0,1024));var o=0,c=0,l=0,f=0,h=0,u=e.charCodeAt(0),t=!1,d=0,p=a.charCodeAt(0);a=a.replace(/\r\n/gm,"\n");var m=null!=n.dateNF?(e=(e="number"==typeof(e=n.dateNF)?me[e]:e).replace(ye,"(\\d+)"),new RegExp("^"+e+"$")):null;function r(){var e,t=a.slice(f,h),r={};if(0===(t='"'==t.charAt(0)&&'"'==t.charAt(t.length-1)?t.slice(1,-1).replace(/""/g,'"'):t).length?r.t="z":n.raw||0===t.trim().length?(r.t="s",r.v=t):61==t.charCodeAt(0)?34==t.charCodeAt(1)&&34==t.charCodeAt(t.length-1)?(r.t="s",r.v=t.slice(2,-1).replace(/""/g,'"')):1!=t.length?(r.t="n",r.f=t.slice(1)):(r.t="s",r.v=t):"TRUE"==t?(r.t="b",r.v=!0):"FALSE"==t?(r.t="b",r.v=!1):isNaN(l=je(t))?!isNaN(Xe(t).getDate())||m&&t.match(m)?(r.z=n.dateNF||me[14],e=0,m&&t.match(m)&&(t=function(e,a){var n=-1,s=-1,i=-1,o=-1,c=-1,l=-1;(e.match(ye)||[]).forEach(function(e,t){var r=parseInt(a[t+1],10);switch(e.toLowerCase().charAt(0)){case"y":n=r;break;case"d":i=r;break;case"h":o=r;break;case"s":l=r;break;case"m":0<=o?c=r:s=r}}),0<=l&&-1==c&&0<=s&&(c=s,s=-1);var t=(""+(0<=n?n:(new Date).getFullYear())).slice(-4)+"-"+("00"+(1<=s?s:1)).slice(-2)+"-"+("00"+(1<=i?i:1)).slice(-2);return 8==(t=7==t.length?"0"+t:t).length&&(t="20"+t),e=("00"+(0<=o?o:0)).slice(-2)+":"+("00"+(0<=c?c:0)).slice(-2)+":"+("00"+(0<=l?l:0)).slice(-2),-1==o&&-1==c&&-1==l?t:-1==n&&-1==s&&-1==i?e:t+"T"+e}(n.dateNF,t.match(m)||[]),e=1),n.cellDates?(r.t="d",r.v=He(t,e)):(r.t="n",r.v=De(He(t,e))),!1!==n.cellText&&(r.w=ve(r.z,r.v instanceof Date?De(r.v):r.v)),n.cellNF||delete r.z):(r.t="s",r.v=t):(!(r.t="n")!==n.cellText&&(r.w=t),r.v=l),"z"==r.t||(n.dense?(s[o]||(s[o]=[]),s[o][c]=r):s[Kr({c:c,r:o})]=r),f=h+1,p=a.charCodeAt(f),i.e.c<c&&(i.e.c=c),i.e.r<o&&(i.e.r=o),d!=u)return c=0,++o,n.sheetRows&&n.sheetRows<=o?1:void 0;++c}e:for(;h<a.length;++h)switch(d=a.charCodeAt(h)){case 34:34===p&&(t=!t);break;case u:case 10:case 13:if(!t&&r())break e}return 0<h-f&&r(),s["!ref"]=qr(i),s}function Qs(e,t){return!t||!t.PRN||t.FS||"sep="==e.slice(0,4)||0<=e.indexOf("\t")||0<=e.indexOf(",")||0<=e.indexOf(";")?Zs(e,t):aa(function(e,t){var r=t||{},a=[];if(!e||0===e.length)return a;for(var n=e.split(/[\r\n]/),s=n.length-1;0<=s&&0===n[s].length;)--s;for(var i=10,o=0,c=0;c<=s;++c)-1==(o=n[c].indexOf(" "))?o=n[c].length:o++,i=Math.max(i,o);for(c=0;c<=s;++c){a[c]=[];var l=0;for(Js(n[c].slice(0,i).trim(),a,c,l,r),l=1;l<=(n[c].length-i)/10+1;++l)Js(n[c].slice(i+10*(l-1),i+10*l).trim(),a,c,l,r)}return a=r.sheetRows?a.slice(0,r.sheetRows):a}(e,t),t)}function ei(e,t){var r="",a="string"==t.type?[0,0,0,0]:$h(e,t);switch(t.type){case"base64":r=te(e);break;case"binary":r=e;break;case"buffer":r=65001==t.codepage?e.toString("utf8"):t.codepage&&void 0!==re?re.utils.decode(t.codepage,e):se&&Buffer.isBuffer(e)?e.toString("binary"):i(e);break;case"array":r=ze(e);break;case"string":r=e;break;default:throw new Error("Unrecognized type "+t.type)}return 239==a[0]&&187==a[1]&&191==a[2]?r=Mt(r.slice(3)):"string"!=t.type&&"buffer"!=t.type&&65001==t.codepage?r=Mt(r):"binary"==t.type&&void 0!==re&&t.codepage&&(r=re.utils.decode(t.codepage,re.utils.encode(28591,r))),"socialcalc:version:"==r.slice(0,19)?Gs.to_sheet("string"==t.type?r:Mt(r),t):Qs(r,t)}var ti,ri,ai,ni,si=(ti={51:["FALSE",0],52:["TRUE",0],70:["LEN",1],80:["SUM",69],81:["AVERAGEA",69],82:["COUNTA",69],83:["MINA",69],84:["MAXA",69],111:["T",1]},ri=["","","","","","","","","","+","-","*","/","^","=","<>","<=",">=","<",">","","","","","&","","","","","","",""],ai={0:{n:"BOF",f:Nn},1:{n:"EOF"},2:{n:"CALCMODE"},3:{n:"CALCORDER"},4:{n:"SPLIT"},5:{n:"SYNC"},6:{n:"RANGE",f:function(e,t,r){var a={s:{c:0,r:0},e:{c:0,r:0}};return 8==t&&r.qpro?(a.s.c=e.read_shift(1),e.l++,a.s.r=e.read_shift(2),a.e.c=e.read_shift(1),e.l++,a.e.r=e.read_shift(2)):(a.s.c=e.read_shift(2),a.s.r=e.read_shift(2),12==t&&r.qpro&&(e.l+=2),a.e.c=e.read_shift(2),a.e.r=e.read_shift(2),12==t&&r.qpro&&(e.l+=2),65535==a.s.c&&(a.s.c=a.e.c=a.s.r=a.e.r=0)),a}},7:{n:"WINDOW1"},8:{n:"COLW1"},9:{n:"WINTWO"},10:{n:"COLW2"},11:{n:"NAME"},12:{n:"BLANK"},13:{n:"INTEGER",f:function(e,t,r){return(r=ci(e,0,r))[1].v=e.read_shift(2,"i"),r}},14:{n:"NUMBER",f:function(e,t,r){return(r=ci(e,0,r))[1].v=e.read_shift(8,"f"),r}},15:{n:"LABEL",f:li},16:{n:"FORMULA",f:function(e,t,r){var a=e.l+t;return(t=ci(e,0,r))[1].v=e.read_shift(8,"f"),r.qpro?e.l=a:(a=e.read_shift(2),function(e,t){Dr(e,0);for(var r=[],a=0,n="",s="",i="",o="";e.l<e.length;){var c=e[e.l++];switch(c){case 0:r.push(e.read_shift(8,"f"));break;case 1:s=fi(t[0].c,e.read_shift(2),!0),n=fi(t[0].r,e.read_shift(2),!1),r.push(s+n);break;case 2:var l=fi(t[0].c,e.read_shift(2),!0),f=fi(t[0].r,e.read_shift(2),!1);s=fi(t[0].c,e.read_shift(2),!0),n=fi(t[0].r,e.read_shift(2),!1),r.push(l+f+":"+s+n);break;case 3:if(e.l<e.length)return console.error("WK1 premature formula end");break;case 4:r.push("("+r.pop()+")");break;case 5:r.push(e.read_shift(2));break;case 6:for(var h="";c=e[e.l++];)h+=String.fromCharCode(c);r.push('"'+h.replace(/"/g,'""')+'"');break;case 8:r.push("-"+r.pop());break;case 23:r.push("+"+r.pop());break;case 22:r.push("NOT("+r.pop()+")");break;case 20:case 21:o=r.pop(),i=r.pop(),r.push(["AND","OR"][c-20]+"("+i+","+o+")");break;default:if(c<32&&ri[c])o=r.pop(),i=r.pop(),r.push(i+ri[c]+o);else{if(!ti[c])return c<=7?console.error("WK1 invalid opcode "+c.toString(16)):c<=24?console.error("WK1 unsupported op "+c.toString(16)):c<=30?console.error("WK1 invalid opcode "+c.toString(16)):c<=115?console.error("WK1 unsupported function opcode "+c.toString(16)):console.error("WK1 unrecognized opcode "+c.toString(16));if((a=69==(a=ti[c][1])?e[e.l++]:a)>r.length)return console.error("WK1 bad formula parse 0x"+c.toString(16)+":|"+r.join("|")+"|");f=r.slice(-a);r.length-=a,r.push(ti[c][0]+"("+f.join(",")+")")}}}1==r.length?t[1].f=""+r[0]:console.error("WK1 bad formula parse |"+r.join("|")+"|")}(e.slice(e.l,e.l+a),t),e.l+=a),t}},24:{n:"TABLE"},25:{n:"ORANGE"},26:{n:"PRANGE"},27:{n:"SRANGE"},28:{n:"FRANGE"},29:{n:"KRANGE1"},32:{n:"HRANGE"},35:{n:"KRANGE2"},36:{n:"PROTEC"},37:{n:"FOOTER"},38:{n:"HEADER"},39:{n:"SETUP"},40:{n:"MARGINS"},41:{n:"LABELFMT"},42:{n:"TITLES"},43:{n:"SHEETJS"},45:{n:"GRAPH"},46:{n:"NGRAPH"},47:{n:"CALCCOUNT"},48:{n:"UNFORMATTED"},49:{n:"CURSORW12"},50:{n:"WINDOW"},51:{n:"STRING",f:li},55:{n:"PASSWORD"},56:{n:"LOCKED"},60:{n:"QUERY"},61:{n:"QUERYNAME"},62:{n:"PRINT"},63:{n:"PRINTNAME"},64:{n:"GRAPH2"},65:{n:"GRAPHNAME"},66:{n:"ZOOM"},67:{n:"SYMSPLIT"},68:{n:"NSROWS"},69:{n:"NSCOLS"},70:{n:"RULER"},71:{n:"NNAME"},72:{n:"ACOMM"},73:{n:"AMACRO"},74:{n:"PARSE"},102:{n:"PRANGES??"},103:{n:"RRANGES??"},104:{n:"FNAME??"},105:{n:"MRANGES??"},204:{n:"SHEETNAMECS",f:pi},222:{n:"SHEETNAMELP",f:function(e,t){var r=e[e.l++];t-1<r&&(r=t-1);for(var a="";a.length<r;)a+=String.fromCharCode(e[e.l++]);return a}},65535:{n:""}},ni={0:{n:"BOF"},1:{n:"EOF"},2:{n:"PASSWORD"},3:{n:"CALCSET"},4:{n:"WINDOWSET"},5:{n:"SHEETCELLPTR"},6:{n:"SHEETLAYOUT"},7:{n:"COLUMNWIDTH"},8:{n:"HIDDENCOLUMN"},9:{n:"USERRANGE"},10:{n:"SYSTEMRANGE"},11:{n:"ZEROFORCE"},12:{n:"SORTKEYDIR"},13:{n:"FILESEAL"},14:{n:"DATAFILLNUMS"},15:{n:"PRINTMAIN"},16:{n:"PRINTSTRING"},17:{n:"GRAPHMAIN"},18:{n:"GRAPHSTRING"},19:{n:"??"},20:{n:"ERRCELL"},21:{n:"NACELL"},22:{n:"LABEL16",f:function(e,t){var r=hi(e);return r[1].t="s",r[1].v=e.read_shift(t-4,"cstr"),r}},23:{n:"NUMBER17",f:ui},24:{n:"NUMBER18",f:function(e,t){var r=hi(e);r[1].v=e.read_shift(2);var a=r[1].v>>1;if(1&r[1].v)switch(7&a){case 0:a=5e3*(a>>3);break;case 1:a=500*(a>>3);break;case 2:a=(a>>3)/20;break;case 3:a=(a>>3)/200;break;case 4:a=(a>>3)/2e3;break;case 5:a=(a>>3)/2e4;break;case 6:a=(a>>3)/16;break;case 7:a=(a>>3)/64}return r[1].v=a,r}},25:{n:"FORMULA19",f:function(e,t){var r=ui(e);return e.l+=t-14,r}},26:{n:"FORMULA1A"},27:{n:"XFORMAT",f:function(e,t){for(var r={},a=e.l+t;e.l<a;){var n=e.read_shift(2);if(14e3==n){for(r[n]=[0,""],r[n][0]=e.read_shift(2);e[e.l];)r[n][1]+=String.fromCharCode(e[e.l]),e.l++;e.l++}}return r}},28:{n:"DTLABELMISC"},29:{n:"DTLABELCELL"},30:{n:"GRAPHWINDOW"},31:{n:"CPA"},32:{n:"LPLAUTO"},33:{n:"QUERY"},34:{n:"HIDDENSHEET"},35:{n:"??"},37:{n:"NUMBER25",f:function(e,t){var r=hi(e),e=e.read_shift(4);return r[1].v=e>>6,r}},38:{n:"??"},39:{n:"NUMBER27",f:di},40:{n:"FORMULA28",f:function(e,t){var r=di(e);return e.l+=t-10,r}},142:{n:"??"},147:{n:"??"},150:{n:"??"},151:{n:"??"},152:{n:"??"},153:{n:"??"},154:{n:"??"},155:{n:"??"},156:{n:"??"},163:{n:"??"},174:{n:"??"},175:{n:"??"},176:{n:"??"},177:{n:"??"},184:{n:"??"},185:{n:"??"},186:{n:"??"},187:{n:"??"},188:{n:"??"},195:{n:"??"},201:{n:"??"},204:{n:"SHEETNAMECS",f:pi},205:{n:"??"},206:{n:"??"},207:{n:"??"},208:{n:"??"},256:{n:"??"},259:{n:"??"},260:{n:"??"},261:{n:"??"},262:{n:"??"},263:{n:"??"},265:{n:"??"},266:{n:"??"},267:{n:"??"},268:{n:"??"},270:{n:"??"},271:{n:"??"},384:{n:"??"},389:{n:"??"},390:{n:"??"},393:{n:"??"},396:{n:"??"},512:{n:"??"},514:{n:"??"},513:{n:"??"},516:{n:"??"},517:{n:"??"},640:{n:"??"},641:{n:"??"},642:{n:"??"},643:{n:"??"},644:{n:"??"},645:{n:"??"},646:{n:"??"},647:{n:"??"},648:{n:"??"},658:{n:"??"},659:{n:"??"},660:{n:"??"},661:{n:"??"},662:{n:"??"},665:{n:"??"},666:{n:"??"},768:{n:"??"},772:{n:"??"},1537:{n:"SHEETINFOQP",f:function(e,t,r){if(r.qpro&&!(t<21)){r=e.read_shift(1);return e.l+=17,e.l+=1,e.l+=2,[r,e.read_shift(t-21,"cstr")]}}},1600:{n:"??"},1602:{n:"??"},1793:{n:"??"},1794:{n:"??"},1795:{n:"??"},1796:{n:"??"},1920:{n:"??"},2048:{n:"??"},2049:{n:"??"},2052:{n:"??"},2688:{n:"??"},10998:{n:"??"},12849:{n:"??"},28233:{n:"??"},28484:{n:"??"},65535:{n:""}},{sheet_to_wk1:function(e,t){var r=t||{};if(0<=+r.codepage&&ie(+r.codepage),"string"==r.type)throw new Error("Cannot write WK1 to JS string");var a=Ur(),n=Zr(e["!ref"]),s=Array.isArray(e),i=[];Lf(a,0,(t=1030,(r=Lr(2)).write_shift(2,t),r)),Lf(a,6,(t=n,(r=Lr(8)).write_shift(2,t.s.c),r.write_shift(2,t.s.r),r.write_shift(2,t.e.c),r.write_shift(2,t.e.r),r));for(var o,c,l,f,h=Math.min(n.e.r,8191),u=n.s.r;u<=h;++u)for(var d=jr(u),p=n.s.c;p<=n.e.c;++p){u===n.s.r&&(i[p]=Xr(p));var m=i[p]+d,m=s?(e[u]||[])[p]:e[m];m&&"z"!=m.t&&("n"==m.t?(0|m.v)==m.v&&-32768<=m.v&&m.v<=32767?Lf(a,13,(o=u,c=p,l=m.v,f=void 0,(f=Lr(7)).write_shift(1,255),f.write_shift(2,c),f.write_shift(2,o),f.write_shift(2,l,"i"),f)):Lf(a,14,(c=u,o=p,l=m.v,f=void 0,(f=Lr(13)).write_shift(1,255),f.write_shift(2,o),f.write_shift(2,c),f.write_shift(8,l,"f"),f)):Lf(a,15,function(e,t,r){var a=Lr(7+r.length);a.write_shift(1,255),a.write_shift(2,t),a.write_shift(2,e),a.write_shift(1,39);for(var n=0;n<a.length;++n){var s=r.charCodeAt(n);a.write_shift(1,128<=s?95:s)}return a.write_shift(1,0),a}(u,p,ea(m).slice(0,239))))}return Lf(a,1),a.end()},book_to_wk3:function(e,t){if(0<=+(t=t||{}).codepage&&ie(+t.codepage),"string"==t.type)throw new Error("Cannot write WK3 to JS string");var r=Ur();Lf(r,0,function(e){var t=Lr(26);t.write_shift(2,4096),t.write_shift(2,4),t.write_shift(4,0);for(var r=0,a=0,n=0,s=0;s<e.SheetNames.length;++s){var i=e.SheetNames[s],i=e.Sheets[i];i&&i["!ref"]&&(++n,i=Jr(i["!ref"]),r<i.e.r&&(r=i.e.r),a<i.e.c&&(a=i.e.c))}8191<r&&(r=8191);return t.write_shift(2,r),t.write_shift(1,n),t.write_shift(1,a),t.write_shift(2,0),t.write_shift(2,0),t.write_shift(1,1),t.write_shift(1,2),t.write_shift(4,0),t.write_shift(4,0),t}(e));for(var a=0,n=0;a<e.SheetNames.length;++a)(e.Sheets[e.SheetNames[a]]||{})["!ref"]&&Lf(r,27,function(e,t){var r=Lr(5+e.length);r.write_shift(2,14e3),r.write_shift(2,t);for(var a=0;a<e.length;++a){var n=e.charCodeAt(a);r[r.l++]=127<n?95:n}return r[r.l++]=0,r}(e.SheetNames[a],n++));for(var s=0,a=0;a<e.SheetNames.length;++a){var i=e.Sheets[e.SheetNames[a]];if(i&&i["!ref"]){for(var o=Zr(i["!ref"]),c=Array.isArray(i),l=[],f=Math.min(o.e.r,8191),h=o.s.r;h<=f;++h)for(var u=jr(h),d=o.s.c;d<=o.e.c;++d){h===o.s.r&&(l[d]=Xr(d));var p=l[d]+u,p=c?(i[h]||[])[d]:i[p];p&&"z"!=p.t&&("n"==p.t?Lf(r,23,function(e,t,r,a){var n=Lr(14);if(n.write_shift(2,e),n.write_shift(1,r),n.write_shift(1,t),0==a)return n.write_shift(4,0),n.write_shift(4,0),n.write_shift(2,65535),n;var s=0,e=0,r=0,t=0;a<0&&(s=1,a=-a);e=0|Math.log2(a),a/=Math.pow(2,e-31),0==(2147483648&(t=a>>>0))&&(++e,t=(a/=2)>>>0);return a-=t,t|=2147483648,t>>>=0,a*=Math.pow(2,32),r=a>>>0,n.write_shift(4,r),n.write_shift(4,t),e+=16383+(s?32768:0),n.write_shift(2,e),n}(h,d,s,p.v)):Lf(r,22,function(e,t,r,a){var n=Lr(6+a.length);n.write_shift(2,e),n.write_shift(1,r),n.write_shift(1,t),n.write_shift(1,39);for(var s=0;s<a.length;++s){var i=a.charCodeAt(s);n.write_shift(1,128<=i?95:i)}return n.write_shift(1,0),n}(h,d,s,ea(p).slice(0,239))))}++s}}return Lf(r,1),r.end()},to_workbook:function(e,t){switch(t.type){case"base64":return oi(he(te(e)),t);case"binary":return oi(he(e),t);case"buffer":case"array":return oi(e,t)}throw"Unsupported type "+t.type}});function ii(e,t,r){if(e){Dr(e,e.l||0);for(var a=r.Enum||ai;e.l<e.length;){var n=e.read_shift(2),s=a[n]||a[65535],i=e.read_shift(2),o=e.l+i,i=s.f&&s.f(e,i,r);if(e.l=o,t(i,s,n))return}}}function oi(e,t){if(!e)return e;var n=t||{};null!=oe&&null==n.dense&&(n.dense=oe);var s=n.dense?[]:{},i="Sheet1",o="",c=0,l={},f=[],a=[],h={s:{r:0,c:0},e:{r:0,c:0}},u=n.sheetRows||0;if(0==e[2]&&(8==e[3]||9==e[3])&&16<=e.length&&5==e[14]&&108===e[15])throw new Error("Unsupported Works 3 for Mac file");if(2==e[2])n.Enum=ai,ii(e,function(e,t,r){switch(r){case 0:4096<=(n.vers=e)&&(n.qpro=!0);break;case 6:h=e;break;case 204:e&&(o=e);break;case 222:o=e;break;case 15:case 51:n.qpro||(e[1].v=e[1].v.slice(1));case 13:case 14:case 16:14==r&&112==(112&e[2])&&1<(15&e[2])&&(15&e[2])<15&&(e[1].z=n.dateNF||me[14],n.cellDates&&(e[1].t="d",e[1].v=Me(e[1].v))),n.qpro&&e[3]>c&&(s["!ref"]=qr(h),l[i]=s,f.push(i),s=n.dense?[]:{},h={s:{r:0,c:0},e:{r:0,c:0}},c=e[3],i=o||"Sheet"+(c+1),o="");var a=n.dense?(s[e[0].r]||[])[e[0].c]:s[Kr(e[0])];if(a){a.t=e[1].t,a.v=e[1].v,null!=e[1].z&&(a.z=e[1].z),null!=e[1].f&&(a.f=e[1].f);break}n.dense?(s[e[0].r]||(s[e[0].r]=[]),s[e[0].r][e[0].c]=e[1]):s[Kr(e[0])]=e[1]}},n);else{if(26!=e[2]&&14!=e[2])throw new Error("Unrecognized LOTUS BOF "+e[2]);n.Enum=ni,14==e[2]&&(n.qpro=!0,e.l=0),ii(e,function(e,t,r){switch(r){case 204:i=e;break;case 22:e[1].v=e[1].v.slice(1);case 23:case 24:case 25:case 37:case 39:case 40:if(e[3]>c&&(s["!ref"]=qr(h),l[i]=s,f.push(i),s=n.dense?[]:{},h={s:{r:0,c:0},e:{r:0,c:0}},c=e[3],i="Sheet"+(c+1)),0<u&&e[0].r>=u)break;n.dense?(s[e[0].r]||(s[e[0].r]=[]),s[e[0].r][e[0].c]=e[1]):s[Kr(e[0])]=e[1],h.e.c<e[0].c&&(h.e.c=e[0].c),h.e.r<e[0].r&&(h.e.r=e[0].r);break;case 27:e[14e3]&&(a[e[14e3][0]]=e[14e3][1]);break;case 1537:a[e[0]]=e[1],e[0]==c&&(i=e[1])}},n)}if(s["!ref"]=qr(h),l[o||i]=s,f.push(o||i),!a.length)return{SheetNames:f,Sheets:l};for(var r={},d=[],p=0;p<a.length;++p)l[f[p]]?(d.push(a[p]||f[p]),r[a[p]]=l[a[p]]||l[f[p]]):(d.push(a[p]),r[a[p]]={"!ref":"A1"});return{SheetNames:d,Sheets:r}}function ci(e,t,r){var a=[{c:0,r:0},{t:"n",v:0},0,0];return r.qpro&&20768!=r.vers?(a[0].c=e.read_shift(1),a[3]=e.read_shift(1),a[0].r=e.read_shift(2),e.l+=2):(a[2]=e.read_shift(1),a[0].c=e.read_shift(2),a[0].r=e.read_shift(2)),a}function li(e,t,r){var a=e.l+t,t=ci(e,0,r);if(t[1].t="s",20768!=r.vers)return r.qpro&&e.l++,t[1].v=e.read_shift(a-e.l,"cstr"),t;e.l++;a=e.read_shift(1);return t[1].v=e.read_shift(a,"utf8"),t}function fi(e,t,r){var a=32768&t;return(a?"":"$")+(r?Xr:jr)(t=(a?e:0)+(8192<=(t&=-32769)?t-16384:t))}function hi(e){var t=[{c:0,r:0},{t:"n",v:0},0];return t[0].r=e.read_shift(2),t[3]=e[e.l++],t[0].c=e[e.l++],t}function ui(e,t){var r=hi(e),a=e.read_shift(4),n=e.read_shift(4);if(65535==(s=e.read_shift(2)))return 0===a&&3221225472===n?(r[1].t="e",r[1].v=15):0===a&&3489660928===n?(r[1].t="e",r[1].v=42):r[1].v=0,r;var e=32768&s,s=(32767&s)-16446;return r[1].v=(1-2*e)*(n*Math.pow(2,32+s)+a*Math.pow(2,s)),r}function di(e,t){var r=hi(e),e=e.read_shift(8,"f");return r[1].v=e,r}function pi(e,t){return 0==e[e.l+t-1]?e.read_shift(t,"cstr"):""}var mi,gi,bi,vi,wi=(mi=Bt("t"),gi=Bt("rPr"),bi=/<(?:\w+:)?r>/g,vi=/<\/(?:\w+:)?r>/,function(e){return e.replace(bi,"").split(vi).map(Ti).filter(function(e){return e.v})});function Ti(e){var t=e.match(mi);if(!t)return{t:"s",v:""};t={t:"s",v:wt(t[1])},e=e.match(gi);return e&&(t.s=function(e){var t={},r=e.match(ft),a=0,n=!1;if(r)for(;a!=r.length;++a){var s=dt(r[a]);switch(s[0].replace(/\w*:/g,"")){case"<condense":case"<extend":break;case"<shadow":if(!s.val)break;case"<shadow>":case"<shadow/>":t.shadow=1;break;case"</shadow>":break;case"<charset":if("1"==s.val)break;t.cp=l[parseInt(s.val,10)];break;case"<outline":if(!s.val)break;case"<outline>":case"<outline/>":t.outline=1;break;case"</outline>":break;case"<rFont":t.name=s.val;break;case"<sz":t.sz=s.val;break;case"<strike":if(!s.val)break;case"<strike>":case"<strike/>":t.strike=1;break;case"</strike>":break;case"<u":if(!s.val)break;switch(s.val){case"double":t.uval="double";break;case"singleAccounting":t.uval="single-accounting";break;case"doubleAccounting":t.uval="double-accounting"}case"<u>":case"<u/>":t.u=1;break;case"</u>":break;case"<b":if("0"==s.val)break;case"<b>":case"<b/>":t.b=1;break;case"</b>":break;case"<i":if("0"==s.val)break;case"<i>":case"<i/>":t.i=1;break;case"</i>":break;case"<color":s.rgb&&(t.color=s.rgb.slice(2,8));break;case"<color>":case"<color/>":case"</color>":break;case"<family":t.family=s.val;break;case"<family>":case"<family/>":case"</family>":break;case"<vertAlign":t.valign=s.val;break;case"<vertAlign>":case"<vertAlign/>":case"</vertAlign>":case"<scheme":break;case"<scheme>":case"<scheme/>":case"</scheme>":break;case"<extLst":case"<extLst>":case"</extLst>":break;case"<ext":n=!0;break;case"</ext>":n=!1;break;default:if(47!==s[0].charCodeAt(1)&&!n)throw new Error("Unrecognized rich format "+s[0])}}return t}(e[1])),t}var Ei,ki=(Ei=/(\r\n|\n)/g,function(e){return e.map(yi).join("")});function yi(e){var t,r,a,n=[[],e.v,[]];return e.v?(e.s&&(t=e.s,r=n[0],a=n[2],e=[],t.u&&e.push("text-decoration: underline;"),t.uval&&e.push("text-underline-style:"+t.uval+";"),t.sz&&e.push("font-size:"+t.sz+"pt;"),t.outline&&e.push("text-effect: outline;"),t.shadow&&e.push("text-shadow: auto;"),r.push('<span style="'+e.join("")+'">'),t.b&&(r.push("<b>"),a.push("</b>")),t.i&&(r.push("<i>"),a.push("</i>")),t.strike&&(r.push("<s>"),a.push("</s>")),"superscript"==(e=t.valign||"")||"super"==e?e="sup":"subscript"==e&&(e="sub"),""!=e&&(r.push("<"+e+">"),a.push("</"+e+">")),a.push("</span>")),n[0].join("")+n[1].replace(Ei,"<br/>")+n[2].join("")):""}var Si=/<(?:\w+:)?t[^>]*>([^<]*)<\/(?:\w+:)?t>/g,_i=/<(?:\w+:)?r>/,xi=/<(?:\w+:)?rPh.*?>([\s\S]*?)<\/(?:\w+:)?rPh>/g;function Ai(e,t){var r=!t||t.cellHTML,t={};return e?(e.match(/^\s*<(?:\w+:)?t[^>]*>/)?(t.t=wt(Mt(e.slice(e.indexOf(">")+1).split(/<\/(?:\w+:)?t>/)[0]||"")),t.r=Mt(e),r&&(t.h=_t(t.t))):e.match(_i)&&(t.r=Mt(e),t.t=wt(Mt((e.replace(xi,"").match(Si)||[]).join("").replace(ft,""))),r&&(t.h=ki(wi(t.r)))),t):{t:""}}var Ci=/<(?:\w+:)?sst([^>]*)>([\s\S]*)<\/(?:\w+:)?sst>/,Ri=/<(?:\w+:)?(?:si|sstItem)>/g,Oi=/<\/(?:\w+:)?(?:si|sstItem)>/;var Ii=/^\s|\s$|[\t\n\r]/;function Ni(e,t){if(!t.bookSST)return"";var r=[ot];r[r.length]=Yt("sst",null,{xmlns:Qt[0],count:e.Count,uniqueCount:e.Unique});for(var a,n,s=0;s!=e.length;++s)null!=e[s]&&(n="<si>",(a=e[s]).r?n+=a.r:(n+="<t",a.t||(a.t=""),a.t.match(Ii)&&(n+=' xml:space="preserve"'),n+=">"+kt(a.t)+"</t>"),n+="</si>",r[r.length]=n);return 2<r.length&&(r[r.length]="</sst>",r[1]=r[1].replace("/>",">")),r.join("")}var Fi=function(e,t){var r=!1;return null==t&&(r=!0,t=Lr(15+4*e.t.length)),t.write_shift(1,0),ia(e.t,t),r?t.slice(0,t.l):t};function Di(e){var t,r,a=Ur();Br(a,159,(t=e,(r=r||Lr(8)).write_shift(4,t.Count),r.write_shift(4,t.Unique),r));for(var n=0;n<e.length;++n)Br(a,19,Fi(e[n]));return Br(a,160),a.end()}function Pi(e){if(void 0!==re)return re.utils.encode(_,e);for(var t=[],r=e.split(""),a=0;a<r.length;++a)t[a]=r[a].charCodeAt(0);return t}function Li(e,t){var r={};return r.Major=e.read_shift(2),r.Minor=e.read_shift(2),4<=t&&(e.l+=t-4),r}function Mi(e){var t=[];e.l+=4;for(var r=e.read_shift(4);0<r--;)t.push(function(e){for(var t=e.read_shift(4),r=e.l+t-4,t={},a=e.read_shift(4),n=[];0<a--;)n.push({t:e.read_shift(4),v:e.read_shift(0,"lpp4")});if(t.name=e.read_shift(0,"lpp4"),t.comps=n,e.l!=r)throw new Error("Bad DataSpaceMapEntry: "+e.l+" != "+r);return t}(e));return t}function Ui(e){var t,r,r=(r={},(t=e).read_shift(4),t.l+=4,r.id=t.read_shift(0,"lpp4"),r.name=t.read_shift(0,"lpp4"),r.R=Li(t,4),r.U=Li(t,4),r.W=Li(t,4),r);if(r.ename=e.read_shift(0,"8lpp4"),r.blksz=e.read_shift(4),r.cmode=e.read_shift(4),4!=e.read_shift(4))throw new Error("Bad !Primary record");return r}function Bi(e,t){var t=e.l+t,r={};r.Flags=63&e.read_shift(4),e.l+=4,r.AlgID=e.read_shift(4);var a=!1;switch(r.AlgID){case 26126:case 26127:case 26128:a=36==r.Flags;break;case 26625:a=4==r.Flags;break;case 0:a=16==r.Flags||4==r.Flags||36==r.Flags;break;default:throw"Unrecognized encryption algorithm: "+r.AlgID}if(!a)throw new Error("Encryption Flags/AlgID mismatch");return r.AlgIDHash=e.read_shift(4),r.KeySize=e.read_shift(4),r.ProviderType=e.read_shift(4),e.l+=8,r.CSPName=e.read_shift(t-e.l>>1,"utf16le"),e.l=t,r}function Wi(e,t){var r={},t=e.l+t;return e.l+=4,r.Salt=e.slice(e.l,e.l+16),e.l+=16,r.Verifier=e.slice(e.l,e.l+16),e.l+=16,e.read_shift(4),r.VerifierHash=e.slice(e.l,t),e.l=t,r}function Hi(e){var t=Li(e);switch(t.Minor){case 2:return[t.Minor,function(e){if(36!=(63&e.read_shift(4)))throw new Error("EncryptionInfo mismatch");var t=e.read_shift(4),t=Bi(e,t),e=Wi(e,e.length-e.l);return{t:"Std",h:t,v:e}}(e)];case 3:return[t.Minor,function(){throw new Error("File is password-protected: ECMA-376 Extensible")}()];case 4:return[t.Minor,function(e){var r=["saltSize","blockSize","keyBits","hashSize","cipherAlgorithm","cipherChaining","hashAlgorithm","saltValue"];e.l+=4;var e=e.read_shift(e.length-e.l,"utf8"),a={};return e.replace(ft,function(e){var t=dt(e);switch(pt(t[0])){case"<?xml":break;case"<encryption":case"</encryption>":break;case"<keyData":r.forEach(function(e){a[e]=t[e]});break;case"<dataIntegrity":a.encryptedHmacKey=t.encryptedHmacKey,a.encryptedHmacValue=t.encryptedHmacValue;break;case"<keyEncryptors>":case"<keyEncryptors":a.encs=[];break;case"</keyEncryptors>":break;case"<keyEncryptor":a.uri=t.uri;break;case"</keyEncryptor>":break;case"<encryptedKey":a.encs.push(t);break;default:throw t[0]}}),a}(e)]}throw new Error("ECMA-376 Encrypted file unrecognized Version: "+t.Minor)}function zi(e){var t,r=0,a=Pi(e),n=a.length+1,s=le(n);for(s[0]=a.length,t=1;t!=n;++t)s[t]=a[t-1];for(t=n-1;0<=t;--t)r=((0==(16384&r)?0:1)|r<<1&32767)^s[t];return 52811^r}var Vi,Gi,ji,$i=(Vi=[187,255,255,186,255,255,185,128,0,190,15,0,191,15,0],Gi=[57840,7439,52380,33984,4364,3600,61902,12606,6258,57657,54287,34041,10252,43370,20163],ji=[44796,19929,39858,10053,20106,40212,10761,31585,63170,64933,60267,50935,40399,11199,17763,35526,1453,2906,5812,11624,23248,885,1770,3540,7080,14160,28320,56640,55369,41139,20807,41614,21821,43642,17621,28485,56970,44341,19019,38038,14605,29210,60195,50791,40175,10751,21502,43004,24537,18387,36774,3949,7898,15796,31592,63184,47201,24803,49606,37805,14203,28406,56812,17824,35648,1697,3394,6788,13576,27152,43601,17539,35078,557,1114,2228,4456,30388,60776,51953,34243,7079,14158,28316,14128,28256,56512,43425,17251,34502,7597,13105,26210,52420,35241,883,1766,3532,4129,8258,16516,33032,4657,9314,18628],function(e){for(var t,r,a=Pi(e),n=function(e){for(var t=Gi[e.length-1],r=104,a=e.length-1;0<=a;--a)for(var n=e[a],s=0;7!=s;++s)64&n&&(t^=ji[r]),n*=2,--r;return t}(a),s=a.length,i=le(16),o=0;16!=o;++o)i[o]=0;for(1==(1&s)&&(t=n>>8,i[s]=Xi(Vi[0],t),--s,t=255&n,e=a[a.length-1],i[s]=Xi(e,t));0<s;)t=n>>8,i[--s]=Xi(a[s],t),t=255&n,i[--s]=Xi(a[s],t);for(r=(s=15)-a.length;0<r;)t=n>>8,i[s]=Xi(Vi[r],t),--r,t=255&n,i[--s]=Xi(a[s],t),--s,--r;return i});function Xi(e,t){return 255&((t=e^t)/2|128*t)}var Yi=function(e){var t=0,r=$i(e);return function(e){e=function(e,t,r,a,n){var s,i;for(n=n||t,a=a||$i(e),s=0;s!=t.length;++s)i=t[s],i=255&((i^=a[r])>>5|i<<3),n[s]=i,++r;return[n,r,a]}("",e,t,r);return t=e[1],e[0]}};function Ki(e,t,r){r=r||{};return r.Info=e.read_shift(2),e.l-=2,1===r.Info?r.Data=function(e){var t={},r=t.EncryptionVersionInfo=Li(e,4);if(1!=r.Major||1!=r.Minor)throw"unrecognized version code "+r.Major+" : "+r.Minor;return t.Salt=e.read_shift(16),t.EncryptedVerifier=e.read_shift(16),t.EncryptedVerifierHash=e.read_shift(16),t}(e):r.Data=function(e,t){var r={},a=r.EncryptionVersionInfo=Li(e,4);if(t-=4,2!=a.Minor)throw new Error("unrecognized minor version code: "+a.Minor);if(4<a.Major||a.Major<2)throw new Error("unrecognized major version code: "+a.Major);return r.Flags=e.read_shift(4),t-=4,a=e.read_shift(4),t-=4,r.EncryptionHeader=Bi(e,a),t-=a,r.EncryptionVerifier=Wi(e,t),r}(e,t),r}var Ji={to_workbook:function(e,t){return ta(qi(e,t),t)},to_sheet:qi,from_sheet:function(e){for(var t=["{\\rtf1\\ansi"],r=Zr(e["!ref"]),a=Array.isArray(e),n=r.s.r;n<=r.e.r;++n){t.push("\\trowd\\trautofit1");for(var s=r.s.c;s<=r.e.c;++s)t.push("\\cellx"+(s+1));for(t.push("\\pard\\intbl"),s=r.s.c;s<=r.e.c;++s){var i=Kr({r:n,c:s});(i=a?(e[n]||[])[s]:e[i])&&(null!=i.v||i.f&&!i.F)&&(t.push(" "+(i.w||(ea(i),i.w))),t.push("\\cell"))}t.push("\\pard\\intbl\\row")}return t.join("")+"}"}};function qi(e,t){switch(t.type){case"base64":return Zi(te(e),t);case"binary":return Zi(e,t);case"buffer":return Zi(se&&Buffer.isBuffer(e)?e.toString("binary"):i(e),t);case"array":return Zi(ze(e),t)}throw new Error("Unrecognized type "+t.type)}function Zi(e,t){var i=(t||{}).dense?[]:{},e=e.match(/\\trowd.*?\\row\b/g);if(!e.length)throw new Error("RTF missing table");var o={s:{c:0,r:0},e:{c:0,r:e.length-1}};return e.forEach(function(e,t){Array.isArray(i)&&(i[t]=[]);for(var r,a=/\\\w+\b/g,n=0,s=-1;r=a.exec(e);)"\\cell"===r[0]&&(++s,(r=" "==(r=e.slice(n,a.lastIndex-r[0].length))[0]?r.slice(1):r).length&&(r={v:r,t:"s"},Array.isArray(i)?i[t][s]=r:i[Kr({r:t,c:s})]=r)),n=a.lastIndex;s>o.e.c&&(o.e.c=s)}),i["!ref"]=qr(o),i}function Qi(e){for(var t=0,r=1;3!=t;++t)r=256*r+(255<e[t]?255:e[t]<0?0:e[t]);return r.toString(16).toUpperCase().slice(1)}function eo(e,t){if(0===t)return e;e=function(e){var t=e[0]/255,r=e[1]/255,a=e[2]/255,n=Math.max(t,r,a),s=Math.min(t,r,a),i=n-s;if(0==i)return[0,0,t];var o=0,e=0,e=i/(1<(s=n+s)?2-s:s);switch(n){case t:o=((r-a)/i+6)%6;break;case r:o=(a-t)/i+2;break;case a:o=(t-r)/i+4}return[o/6,e,s/2]}((e=(e=e).slice("#"===e[0]?1:0).slice(0,6),[parseInt(e.slice(0,2),16),parseInt(e.slice(2,4),16),parseInt(e.slice(4,6),16)]));return e[2]=t<0?e[2]*(1+t):1-(1-e[2])*(1-t),Qi(function(e){var t,r=e[0],a=e[1],e=e[2],n=2*a*(e<.5?e:1-e),s=[e=e-n/2,e,e],i=6*r;if(0!==a)switch(0|i){case 0:case 6:t=n*i,s[0]+=n,s[1]+=t;break;case 1:t=n*(2-i),s[0]+=t,s[1]+=n;break;case 2:t=n*(i-2),s[1]+=n,s[2]+=t;break;case 3:t=n*(4-i),s[1]+=t,s[2]+=n;break;case 4:t=n*(i-4),s[2]+=n,s[0]+=t;break;case 5:t=n*(6-i),s[2]+=t,s[0]+=n}for(var o=0;3!=o;++o)s[o]=Math.round(255*s[o]);return s}(e))}var to=6,ro=15,ao=1,no=to;function so(e){return Math.floor((e+Math.round(128/no)/256)*no)}function io(e){return Math.floor((e-5)/no*100+.5)/100}function oo(e){return Math.round((e*no+5)/no*256)/256}function co(e){return oo(io(so(e)))}function lo(e){var t=Math.abs(e-co(e)),r=no;if(.005<t)for(no=ao;no<ro;++no)Math.abs(e-co(e))<=t&&(t=Math.abs(e-co(e)),r=no);no=r}function fo(e){e.width?(e.wpx=so(e.width),e.wch=io(e.wpx),e.MDW=no):e.wpx?(e.wch=io(e.wpx),e.width=oo(e.wch),e.MDW=no):"number"==typeof e.wch&&(e.width=oo(e.wch),e.wpx=so(e.width),e.MDW=no),e.customWidth&&delete e.customWidth}var ho=96;function uo(e){return 96*e/ho}function po(e){return e*ho/96}var mo={None:"none",Solid:"solid",Gray50:"mediumGray",Gray75:"darkGray",Gray25:"lightGray",HorzStripe:"darkHorizontal",VertStripe:"darkVertical",ReverseDiagStripe:"darkDown",DiagStripe:"darkUp",DiagCross:"darkGrid",ThickDiagCross:"darkTrellis",ThinHorzStripe:"lightHorizontal",ThinVertStripe:"lightVertical",ThinReverseDiagStripe:"lightDown",ThinHorzCross:"lightGrid"};var go=["numFmtId","fillId","fontId","borderId","xfId"],bo=["applyAlignment","applyBorder","applyFill","applyFont","applyNumberFormat","applyProtection","pivotButton","quotePrefix"];var vo,wo,To,Eo,ko,yo,So=(vo=/<(?:\w+:)?numFmts([^>]*)>[\S\s]*?<\/(?:\w+:)?numFmts>/,wo=/<(?:\w+:)?cellXfs([^>]*)>[\S\s]*?<\/(?:\w+:)?cellXfs>/,To=/<(?:\w+:)?fills([^>]*)>[\S\s]*?<\/(?:\w+:)?fills>/,Eo=/<(?:\w+:)?fonts([^>]*)>[\S\s]*?<\/(?:\w+:)?fonts>/,ko=/<(?:\w+:)?borders([^>]*)>[\S\s]*?<\/(?:\w+:)?borders>/,function(e,t,r){var a,n,s,i,o,c={};return e&&((a=(e=e.replace(/<!--([\s\S]*?)-->/gm,"").replace(/<!DOCTYPE[^\[]*\[[^\]]*\]>/gm,"")).match(vo))&&function(e,t,r){t.NumberFmt=[];for(var a=Re(me),n=0;n<a.length;++n)t.NumberFmt[a[n]]=me[a[n]];var s=e[0].match(ft);if(s)for(n=0;n<s.length;++n){var i=dt(s[n]);switch(pt(i[0])){case"<numFmts":case"</numFmts>":case"<numFmts/>":case"<numFmts>":break;case"<numFmt":var o=wt(Mt(i.formatCode)),c=parseInt(i.numFmtId,10);if(t.NumberFmt[c]=o,0<c){if(392<c){for(c=392;60<c&&null!=t.NumberFmt[c];--c);t.NumberFmt[c]=o}we(o,c)}break;case"</numFmt>":break;default:if(r.WTF)throw new Error("unrecognized "+i[0]+" in numFmts")}}}(a,c,r),(a=e.match(Eo))&&function(e,a,n,s){a.Fonts=[];var i={},o=!1;(e[0].match(ft)||[]).forEach(function(e){var t,r=dt(e);switch(pt(r[0])){case"<fonts":case"<fonts>":case"</fonts>":break;case"<font":case"<font>":break;case"</font>":case"<font/>":a.Fonts.push(i),i={};break;case"<name":r.val&&(i.name=Mt(r.val));break;case"<name/>":case"</name>":break;case"<b":i.bold=r.val?Rt(r.val):1;break;case"<b/>":i.bold=1;break;case"<i":i.italic=r.val?Rt(r.val):1;break;case"<i/>":i.italic=1;break;case"<u":switch(r.val){case"none":i.underline=0;break;case"single":i.underline=1;break;case"double":i.underline=2;break;case"singleAccounting":i.underline=33;break;case"doubleAccounting":i.underline=34}break;case"<u/>":i.underline=1;break;case"<strike":i.strike=r.val?Rt(r.val):1;break;case"<strike/>":i.strike=1;break;case"<outline":i.outline=r.val?Rt(r.val):1;break;case"<outline/>":i.outline=1;break;case"<shadow":i.shadow=r.val?Rt(r.val):1;break;case"<shadow/>":i.shadow=1;break;case"<condense":i.condense=r.val?Rt(r.val):1;break;case"<condense/>":i.condense=1;break;case"<extend":i.extend=r.val?Rt(r.val):1;break;case"<extend/>":i.extend=1;break;case"<sz":r.val&&(i.sz=+r.val);break;case"<sz/>":case"</sz>":break;case"<vertAlign":r.val&&(i.vertAlign=r.val);break;case"<vertAlign/>":case"</vertAlign>":break;case"<family":r.val&&(i.family=parseInt(r.val,10));break;case"<family/>":case"</family>":break;case"<scheme":r.val&&(i.scheme=r.val);break;case"<scheme/>":case"</scheme>":break;case"<charset":if("1"==r.val)break;r.codepage=l[parseInt(r.val,10)];break;case"<color":i.color||(i.color={}),r.auto&&(i.color.auto=Rt(r.auto)),r.rgb?i.color.rgb=r.rgb.slice(-6):r.indexed?(i.color.index=parseInt(r.indexed,10),t=Ba[i.color.index],t=(t=81==i.color.index?Ba[1]:t)||Ba[1],i.color.rgb=t[0].toString(16)+t[1].toString(16)+t[2].toString(16)):r.theme&&(i.color.theme=parseInt(r.theme,10),r.tint&&(i.color.tint=parseFloat(r.tint)),r.theme&&n.themeElements&&n.themeElements.clrScheme&&(i.color.rgb=eo(n.themeElements.clrScheme[i.color.theme].rgb,i.color.tint||0)));break;case"<color/>":case"</color>":break;case"<AlternateContent":o=!0;break;case"</AlternateContent>":o=!1;break;case"<extLst":case"<extLst>":case"</extLst>":break;case"<ext":o=!0;break;case"</ext>":o=!1;break;default:if(s&&s.WTF&&!o)throw new Error("unrecognized "+r[0]+" in fonts")}})}(a,c,t,r),(a=e.match(To))&&function(e,r,a){r.Fills=[];var n={},s=!1;(e[0].match(ft)||[]).forEach(function(e){var t=dt(e);switch(pt(t[0])){case"<fills":case"<fills>":case"</fills>":break;case"<fill>":case"<fill":case"<fill/>":n={},r.Fills.push(n);break;case"</fill>":case"<gradientFill>":break;case"<gradientFill":case"</gradientFill>":r.Fills.push(n),n={};break;case"<patternFill":case"<patternFill>":t.patternType&&(n.patternType=t.patternType);break;case"<patternFill/>":case"</patternFill>":break;case"<bgColor":n.bgColor||(n.bgColor={}),t.indexed&&(n.bgColor.indexed=parseInt(t.indexed,10)),t.theme&&(n.bgColor.theme=parseInt(t.theme,10)),t.tint&&(n.bgColor.tint=parseFloat(t.tint)),t.rgb&&(n.bgColor.rgb=t.rgb.slice(-6));break;case"<bgColor/>":case"</bgColor>":break;case"<fgColor":n.fgColor||(n.fgColor={}),t.theme&&(n.fgColor.theme=parseInt(t.theme,10)),t.tint&&(n.fgColor.tint=parseFloat(t.tint)),null!=t.rgb&&(n.fgColor.rgb=t.rgb.slice(-6));break;case"<fgColor/>":case"</fgColor>":break;case"<stop":case"<stop/>":case"</stop>":break;case"<color":case"<color/>":case"</color>":break;case"<extLst":case"<extLst>":case"</extLst>":break;case"<ext":s=!0;break;case"</ext>":s=!1;break;default:if(a&&a.WTF&&!s)throw new Error("unrecognized "+t[0]+" in fills")}})}(a,c,r),(a=e.match(ko))&&function(e,r,a){r.Borders=[];var n={},s=!1;(e[0].match(ft)||[]).forEach(function(e){var t=dt(e);switch(pt(t[0])){case"<borders":case"<borders>":case"</borders>":break;case"<border":case"<border>":case"<border/>":n={},t.diagonalUp&&(n.diagonalUp=Rt(t.diagonalUp)),t.diagonalDown&&(n.diagonalDown=Rt(t.diagonalDown)),r.Borders.push(n);break;case"</border>":case"<left/>":break;case"<left":case"<left>":case"</left>":case"<right/>":break;case"<right":case"<right>":case"</right>":case"<top/>":break;case"<top":case"<top>":case"</top>":case"<bottom/>":break;case"<bottom":case"<bottom>":case"</bottom>":break;case"<diagonal":case"<diagonal>":case"<diagonal/>":case"</diagonal>":break;case"<horizontal":case"<horizontal>":case"<horizontal/>":case"</horizontal>":break;case"<vertical":case"<vertical>":case"<vertical/>":case"</vertical>":break;case"<start":case"<start>":case"<start/>":case"</start>":break;case"<end":case"<end>":case"<end/>":case"</end>":break;case"<color":case"<color>":break;case"<color/>":case"</color>":break;case"<extLst":case"<extLst>":case"</extLst>":break;case"<ext":s=!0;break;case"</ext>":s=!1;break;default:if(a&&a.WTF&&!s)throw new Error("unrecognized "+t[0]+" in borders")}})}(a,c,r),(a=e.match(wo))&&(a=a,s=r,o=!((n=c).CellXf=[]),(a[0].match(ft)||[]).forEach(function(e){var t=dt(e),r=0;switch(pt(t[0])){case"<cellXfs":case"<cellXfs>":case"<cellXfs/>":case"</cellXfs>":break;case"<xf":case"<xf/>":for(delete(i=t)[0],r=0;r<go.length;++r)i[go[r]]&&(i[go[r]]=parseInt(i[go[r]],10));for(r=0;r<bo.length;++r)i[bo[r]]&&(i[bo[r]]=Rt(i[bo[r]]));if(n.NumberFmt&&392<i.numFmtId)for(r=392;60<r;--r)if(n.NumberFmt[i.numFmtId]==n.NumberFmt[r]){i.numFmtId=r;break}n.CellXf.push(i);break;case"</xf>":break;case"<alignment":case"<alignment/>":var a={};t.vertical&&(a.vertical=t.vertical),t.horizontal&&(a.horizontal=t.horizontal),null!=t.textRotation&&(a.textRotation=t.textRotation),t.indent&&(a.indent=t.indent),t.wrapText&&(a.wrapText=Rt(t.wrapText)),i.alignment=a;break;case"</alignment>":case"<protection":break;case"</protection>":case"<protection/>":break;case"<AlternateContent":o=!0;break;case"</AlternateContent>":o=!1;break;case"<extLst":case"<extLst>":case"</extLst>":break;case"<ext":o=!0;break;case"</ext>":o=!1;break;default:if(s&&s.WTF&&!o)throw new Error("unrecognized "+t[0]+" in cellXfs")}}))),c});function _o(e,t){if(void 0!==yo)return yo.toXml();var r,a,n,s,i=[ot,Yt("styleSheet",null,{xmlns:Qt[0],"xmlns:vt":Zt.vt})];return e.SSF&&null!=(a=e.SSF,n=["<numFmts>"],[[5,8],[23,26],[41,44],[50,392]].forEach(function(e){for(var t=e[0];t<=e[1];++t)null!=a[t]&&(n[n.length]=Yt("numFmt",null,{numFmtId:t,formatCode:kt(a[t])}))}),r=1===n.length?"":(n[n.length]="</numFmts>",n[0]=Yt("numFmts",null,{count:n.length-2}).replace("/>",">"),n.join("")))&&(i[i.length]=r),i[i.length]='<fonts count="1"><font><sz val="12"/><color theme="1"/><name val="Calibri"/><family val="2"/><scheme val="minor"/></font></fonts>',i[i.length]='<fills count="2"><fill><patternFill patternType="none"/></fill><fill><patternFill patternType="gray125"/></fill></fills>',i[i.length]='<borders count="1"><border><left/><right/><top/><bottom/><diagonal/></border></borders>',i[i.length]='<cellStyleXfs count="1"><xf numFmtId="0" fontId="0" fillId="0" borderId="0"/></cellStyleXfs>',t=t.cellXfs,(s=[])[s.length]="<cellXfs/>",t.forEach(function(e){s[s.length]=Yt("xf",null,e)}),s[s.length]="</cellXfs>",(r=2===s.length?"":(s[0]=Yt("cellXfs",null,{count:s.length-2}).replace("/>",">"),s.join("")))&&(i[i.length]=r),i[i.length]='<cellStyles count="1"><cellStyle name="Normal" xfId="0" builtinId="0"/></cellStyles>',i[i.length]='<dxfs count="0"/>',i[i.length]='<tableStyles count="0" defaultTableStyle="TableStyleMedium9" defaultPivotStyle="PivotStyleMedium4"/>',2<i.length&&(i[i.length]="</styleSheet>",i[1]=i[1].replace("/>",">")),i.join("")}function xo(e,t){var r;(t=t||Lr(153)).write_shift(2,20*e.sz),r=e,a=(a=t)||Lr(2),r=(r.italic?2:0)|(r.strike?8:0)|(r.outline?16:0)|(r.shadow?32:0)|(r.condense?64:0)|(r.extend?128:0),a.write_shift(1,r),a.write_shift(1,0),t.write_shift(2,e.bold?700:400);var a=0;"superscript"==e.vertAlign?a=1:"subscript"==e.vertAlign&&(a=2),t.write_shift(2,a),t.write_shift(1,e.underline||0),t.write_shift(1,e.family||0),t.write_shift(1,e.charset||0),t.write_shift(1,0),Ca(e.color,t);a=0;return"major"==e.scheme&&(a=1),"minor"==e.scheme&&(a=2),t.write_shift(1,a),ia(e.name,t),t.length>t.l?t.slice(0,t.l):t}var Ao,Co=["none","solid","mediumGray","darkGray","lightGray","darkHorizontal","darkVertical","darkDown","darkUp","darkGrid","darkTrellis","lightHorizontal","lightVertical","lightDown","lightUp","lightGrid","lightTrellis","gray125","gray0625"],Ro=Pr;function Oo(e,t){t=t||Lr(84);e=(Ao=Ao||Ie(Co))[e.patternType];null==e&&(e=40),t.write_shift(4,e);var r=0;if(40!=e)for(Ca({auto:1},t),Ca({auto:1},t);r<12;++r)t.write_shift(4,0);else{for(;r<4;++r)t.write_shift(4,0);for(;r<12;++r)t.write_shift(4,0)}return t.length>t.l?t.slice(0,t.l):t}function Io(e,t,r){(r=r||Lr(16)).write_shift(2,t||0),r.write_shift(2,e.numFmtId||0),r.write_shift(2,0),r.write_shift(2,0),r.write_shift(2,0),r.write_shift(1,0),r.write_shift(1,0);return r.write_shift(1,0),r.write_shift(1,0),r.write_shift(1,0),r.write_shift(1,0),r}function No(e,t){return(t=t||Lr(10)).write_shift(1,0),t.write_shift(1,0),t.write_shift(4,0),t.write_shift(4,0),t}r=Pr;function Fo(s,i){var r;i&&(r=0,[[5,8],[23,26],[41,44],[50,392]].forEach(function(e){for(var t=e[0];t<=e[1];++t)null!=i[t]&&++r}),0!=r&&(Br(s,615,na(r)),[[5,8],[23,26],[41,44],[50,392]].forEach(function(e){for(var t,r,a,n=e[0];n<=e[1];++n)null!=i[n]&&Br(s,44,(t=n,r=i[n],(a=(a=void 0)||Lr(6+4*r.length)).write_shift(2,t),ia(r,a),r=a.length>a.l?a.slice(0,a.l):a,null==a.l&&(a.l=a.length),r))}),Br(s,616)))}function Do(e){var t;Br(e,613,na(1)),Br(e,46,((t=t||Lr(51)).write_shift(1,0),No(0,t),No(0,t),No(0,t),No(0,t),No(0,t),t.length>t.l?t.slice(0,t.l):t)),Br(e,614)}function Po(e){var t,r;Br(e,619,na(1)),Br(e,48,(t={xfId:0,builtinId:0,name:"Normal"},(r=r||Lr(52)).write_shift(4,t.xfId),r.write_shift(2,1),r.write_shift(1,+t.builtinId),r.write_shift(1,0),ba(t.name||"",r),r.length>r.l?r.slice(0,r.l):r)),Br(e,620)}function Lo(e){var t,r,a,n;Br(e,508,(t=0,r="TableStyleMedium9",a="PivotStyleMedium4",(n=Lr(2052)).write_shift(4,t),ba(r,n),ba(a,n),n.length>n.l?n.slice(0,n.l):n)),Br(e,509)}function Mo(e,t){var r,a=Ur();return Br(a,278),Fo(a,e.SSF),Br(e=a,611,na(1)),Br(e,43,xo({sz:12,color:{theme:1},name:"Calibri",family:2,scheme:"minor"})),Br(e,612),Br(e=a,603,na(2)),Br(e,45,Oo({patternType:"none"})),Br(e,45,Oo({patternType:"gray125"})),Br(e,604),Do(a),Br(e=a,626,na(1)),Br(e,47,Io({numFmtId:0,fontId:0,fillId:0,borderId:0},65535)),Br(e,627),r=a,t=t.cellXfs,Br(r,617,na(t.length)),t.forEach(function(e){Br(r,47,Io(e,0))}),Br(r,618),Po(a),Br(t=a,505,na(0)),Br(t,506),Lo(a),Br(a,279),a.end()}var Uo=["</a:lt1>","</a:dk1>","</a:lt2>","</a:dk2>","</a:accent1>","</a:accent2>","</a:accent3>","</a:accent4>","</a:accent5>","</a:accent6>","</a:hlink>","</a:folHlink>"];function Bo(e,r,a){r.themeElements.clrScheme=[];var n={};(e[0].match(ft)||[]).forEach(function(e){var t=dt(e);switch(t[0]){case"<a:clrScheme":case"</a:clrScheme>":break;case"<a:srgbClr":n.rgb=t.val;break;case"<a:sysClr":n.rgb=t.lastClr;break;case"<a:dk1>":case"</a:dk1>":case"<a:lt1>":case"</a:lt1>":case"<a:dk2>":case"</a:dk2>":case"<a:lt2>":case"</a:lt2>":case"<a:accent1>":case"</a:accent1>":case"<a:accent2>":case"</a:accent2>":case"<a:accent3>":case"</a:accent3>":case"<a:accent4>":case"</a:accent4>":case"<a:accent5>":case"</a:accent5>":case"<a:accent6>":case"</a:accent6>":case"<a:hlink>":case"</a:hlink>":case"<a:folHlink>":case"</a:folHlink>":"/"===t[0].charAt(1)?(r.themeElements.clrScheme[Uo.indexOf(t[0])]=n,n={}):n.name=t[0].slice(3,t[0].length-1);break;default:if(a&&a.WTF)throw new Error("Unrecognized "+t[0]+" in clrScheme")}})}function Wo(){}function Ho(){}var zo=/<a:clrScheme([^>]*)>[\s\S]*<\/a:clrScheme>/,Vo=/<a:fontScheme([^>]*)>[\s\S]*<\/a:fontScheme>/,Go=/<a:fmtScheme([^>]*)>[\s\S]*<\/a:fmtScheme>/;var jo=/<a:themeElements([^>]*)>[\s\S]*<\/a:themeElements>/;function $o(e,t){var r,a,n,s,i,o={};if(!(r=(e=!e||0===e.length?Xo():e).match(jo)))throw new Error("themeElements not found in theme");return a=r[0],s=t,(n=o).themeElements={},[["clrScheme",zo,Bo],["fontScheme",Vo,Wo],["fmtScheme",Go,Ho]].forEach(function(e){if(!(i=a.match(e[1])))throw new Error(e[0]+" not found in themeElements");e[2](i,n,s)}),o.raw=e,o}function Xo(e,t){if(t&&t.themeXLSX)return t.themeXLSX;if(e&&"string"==typeof e.raw)return e.raw;e=[ot];return e[e.length]='<a:theme xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" name="Office Theme">',e[e.length]="<a:themeElements>",e[e.length]='<a:clrScheme name="Office">',e[e.length]='<a:dk1><a:sysClr val="windowText" lastClr="000000"/></a:dk1>',e[e.length]='<a:lt1><a:sysClr val="window" lastClr="FFFFFF"/></a:lt1>',e[e.length]='<a:dk2><a:srgbClr val="1F497D"/></a:dk2>',e[e.length]='<a:lt2><a:srgbClr val="EEECE1"/></a:lt2>',e[e.length]='<a:accent1><a:srgbClr val="4F81BD"/></a:accent1>',e[e.length]='<a:accent2><a:srgbClr val="C0504D"/></a:accent2>',e[e.length]='<a:accent3><a:srgbClr val="9BBB59"/></a:accent3>',e[e.length]='<a:accent4><a:srgbClr val="8064A2"/></a:accent4>',e[e.length]='<a:accent5><a:srgbClr val="4BACC6"/></a:accent5>',e[e.length]='<a:accent6><a:srgbClr val="F79646"/></a:accent6>',e[e.length]='<a:hlink><a:srgbClr val="0000FF"/></a:hlink>',e[e.length]='<a:folHlink><a:srgbClr val="800080"/></a:folHlink>',e[e.length]="</a:clrScheme>",e[e.length]='<a:fontScheme name="Office">',e[e.length]="<a:majorFont>",e[e.length]='<a:latin typeface="Cambria"/>',e[e.length]='<a:ea typeface=""/>',e[e.length]='<a:cs typeface=""/>',e[e.length]='<a:font script="Jpan" typeface="ＭＳ Ｐゴシック"/>',e[e.length]='<a:font script="Hang" typeface="맑은 고딕"/>',e[e.length]='<a:font script="Hans" typeface="宋体"/>',e[e.length]='<a:font script="Hant" typeface="新細明體"/>',e[e.length]='<a:font script="Arab" typeface="Times New Roman"/>',e[e.length]='<a:font script="Hebr" typeface="Times New Roman"/>',e[e.length]='<a:font script="Thai" typeface="Tahoma"/>',e[e.length]='<a:font script="Ethi" typeface="Nyala"/>',e[e.length]='<a:font script="Beng" typeface="Vrinda"/>',e[e.length]='<a:font script="Gujr" typeface="Shruti"/>',e[e.length]='<a:font script="Khmr" typeface="MoolBoran"/>',e[e.length]='<a:font script="Knda" typeface="Tunga"/>',e[e.length]='<a:font script="Guru" typeface="Raavi"/>',e[e.length]='<a:font script="Cans" typeface="Euphemia"/>',e[e.length]='<a:font script="Cher" typeface="Plantagenet Cherokee"/>',e[e.length]='<a:font script="Yiii" typeface="Microsoft Yi Baiti"/>',e[e.length]='<a:font script="Tibt" typeface="Microsoft Himalaya"/>',e[e.length]='<a:font script="Thaa" typeface="MV Boli"/>',e[e.length]='<a:font script="Deva" typeface="Mangal"/>',e[e.length]='<a:font script="Telu" typeface="Gautami"/>',e[e.length]='<a:font script="Taml" typeface="Latha"/>',e[e.length]='<a:font script="Syrc" typeface="Estrangelo Edessa"/>',e[e.length]='<a:font script="Orya" typeface="Kalinga"/>',e[e.length]='<a:font script="Mlym" typeface="Kartika"/>',e[e.length]='<a:font script="Laoo" typeface="DokChampa"/>',e[e.length]='<a:font script="Sinh" typeface="Iskoola Pota"/>',e[e.length]='<a:font script="Mong" typeface="Mongolian Baiti"/>',e[e.length]='<a:font script="Viet" typeface="Times New Roman"/>',e[e.length]='<a:font script="Uigh" typeface="Microsoft Uighur"/>',e[e.length]='<a:font script="Geor" typeface="Sylfaen"/>',e[e.length]="</a:majorFont>",e[e.length]="<a:minorFont>",e[e.length]='<a:latin typeface="Calibri"/>',e[e.length]='<a:ea typeface=""/>',e[e.length]='<a:cs typeface=""/>',e[e.length]='<a:font script="Jpan" typeface="ＭＳ Ｐゴシック"/>',e[e.length]='<a:font script="Hang" typeface="맑은 고딕"/>',e[e.length]='<a:font script="Hans" typeface="宋体"/>',e[e.length]='<a:font script="Hant" typeface="新細明體"/>',e[e.length]='<a:font script="Arab" typeface="Arial"/>',e[e.length]='<a:font script="Hebr" typeface="Arial"/>',e[e.length]='<a:font script="Thai" typeface="Tahoma"/>',e[e.length]='<a:font script="Ethi" typeface="Nyala"/>',e[e.length]='<a:font script="Beng" typeface="Vrinda"/>',e[e.length]='<a:font script="Gujr" typeface="Shruti"/>',e[e.length]='<a:font script="Khmr" typeface="DaunPenh"/>',e[e.length]='<a:font script="Knda" typeface="Tunga"/>',e[e.length]='<a:font script="Guru" typeface="Raavi"/>',e[e.length]='<a:font script="Cans" typeface="Euphemia"/>',e[e.length]='<a:font script="Cher" typeface="Plantagenet Cherokee"/>',e[e.length]='<a:font script="Yiii" typeface="Microsoft Yi Baiti"/>',e[e.length]='<a:font script="Tibt" typeface="Microsoft Himalaya"/>',e[e.length]='<a:font script="Thaa" typeface="MV Boli"/>',e[e.length]='<a:font script="Deva" typeface="Mangal"/>',e[e.length]='<a:font script="Telu" typeface="Gautami"/>',e[e.length]='<a:font script="Taml" typeface="Latha"/>',e[e.length]='<a:font script="Syrc" typeface="Estrangelo Edessa"/>',e[e.length]='<a:font script="Orya" typeface="Kalinga"/>',e[e.length]='<a:font script="Mlym" typeface="Kartika"/>',e[e.length]='<a:font script="Laoo" typeface="DokChampa"/>',e[e.length]='<a:font script="Sinh" typeface="Iskoola Pota"/>',e[e.length]='<a:font script="Mong" typeface="Mongolian Baiti"/>',e[e.length]='<a:font script="Viet" typeface="Arial"/>',e[e.length]='<a:font script="Uigh" typeface="Microsoft Uighur"/>',e[e.length]='<a:font script="Geor" typeface="Sylfaen"/>',e[e.length]="</a:minorFont>",e[e.length]="</a:fontScheme>",e[e.length]='<a:fmtScheme name="Office">',e[e.length]="<a:fillStyleLst>",e[e.length]='<a:solidFill><a:schemeClr val="phClr"/></a:solidFill>',e[e.length]='<a:gradFill rotWithShape="1">',e[e.length]="<a:gsLst>",e[e.length]='<a:gs pos="0"><a:schemeClr val="phClr"><a:tint val="50000"/><a:satMod val="300000"/></a:schemeClr></a:gs>',e[e.length]='<a:gs pos="35000"><a:schemeClr val="phClr"><a:tint val="37000"/><a:satMod val="300000"/></a:schemeClr></a:gs>',e[e.length]='<a:gs pos="100000"><a:schemeClr val="phClr"><a:tint val="15000"/><a:satMod val="350000"/></a:schemeClr></a:gs>',e[e.length]="</a:gsLst>",e[e.length]='<a:lin ang="16200000" scaled="1"/>',e[e.length]="</a:gradFill>",e[e.length]='<a:gradFill rotWithShape="1">',e[e.length]="<a:gsLst>",e[e.length]='<a:gs pos="0"><a:schemeClr val="phClr"><a:tint val="100000"/><a:shade val="100000"/><a:satMod val="130000"/></a:schemeClr></a:gs>',e[e.length]='<a:gs pos="100000"><a:schemeClr val="phClr"><a:tint val="50000"/><a:shade val="100000"/><a:satMod val="350000"/></a:schemeClr></a:gs>',e[e.length]="</a:gsLst>",e[e.length]='<a:lin ang="16200000" scaled="0"/>',e[e.length]="</a:gradFill>",e[e.length]="</a:fillStyleLst>",e[e.length]="<a:lnStyleLst>",e[e.length]='<a:ln w="9525" cap="flat" cmpd="sng" algn="ctr"><a:solidFill><a:schemeClr val="phClr"><a:shade val="95000"/><a:satMod val="105000"/></a:schemeClr></a:solidFill><a:prstDash val="solid"/></a:ln>',e[e.length]='<a:ln w="25400" cap="flat" cmpd="sng" algn="ctr"><a:solidFill><a:schemeClr val="phClr"/></a:solidFill><a:prstDash val="solid"/></a:ln>',e[e.length]='<a:ln w="38100" cap="flat" cmpd="sng" algn="ctr"><a:solidFill><a:schemeClr val="phClr"/></a:solidFill><a:prstDash val="solid"/></a:ln>',e[e.length]="</a:lnStyleLst>",e[e.length]="<a:effectStyleLst>",e[e.length]="<a:effectStyle>",e[e.length]="<a:effectLst>",e[e.length]='<a:outerShdw blurRad="40000" dist="20000" dir="5400000" rotWithShape="0"><a:srgbClr val="000000"><a:alpha val="38000"/></a:srgbClr></a:outerShdw>',e[e.length]="</a:effectLst>",e[e.length]="</a:effectStyle>",e[e.length]="<a:effectStyle>",e[e.length]="<a:effectLst>",e[e.length]='<a:outerShdw blurRad="40000" dist="23000" dir="5400000" rotWithShape="0"><a:srgbClr val="000000"><a:alpha val="35000"/></a:srgbClr></a:outerShdw>',e[e.length]="</a:effectLst>",e[e.length]="</a:effectStyle>",e[e.length]="<a:effectStyle>",e[e.length]="<a:effectLst>",e[e.length]='<a:outerShdw blurRad="40000" dist="23000" dir="5400000" rotWithShape="0"><a:srgbClr val="000000"><a:alpha val="35000"/></a:srgbClr></a:outerShdw>',e[e.length]="</a:effectLst>",e[e.length]='<a:scene3d><a:camera prst="orthographicFront"><a:rot lat="0" lon="0" rev="0"/></a:camera><a:lightRig rig="threePt" dir="t"><a:rot lat="0" lon="0" rev="1200000"/></a:lightRig></a:scene3d>',e[e.length]='<a:sp3d><a:bevelT w="63500" h="25400"/></a:sp3d>',e[e.length]="</a:effectStyle>",e[e.length]="</a:effectStyleLst>",e[e.length]="<a:bgFillStyleLst>",e[e.length]='<a:solidFill><a:schemeClr val="phClr"/></a:solidFill>',e[e.length]='<a:gradFill rotWithShape="1">',e[e.length]="<a:gsLst>",e[e.length]='<a:gs pos="0"><a:schemeClr val="phClr"><a:tint val="40000"/><a:satMod val="350000"/></a:schemeClr></a:gs>',e[e.length]='<a:gs pos="40000"><a:schemeClr val="phClr"><a:tint val="45000"/><a:shade val="99000"/><a:satMod val="350000"/></a:schemeClr></a:gs>',e[e.length]='<a:gs pos="100000"><a:schemeClr val="phClr"><a:shade val="20000"/><a:satMod val="255000"/></a:schemeClr></a:gs>',e[e.length]="</a:gsLst>",e[e.length]='<a:path path="circle"><a:fillToRect l="50000" t="-80000" r="50000" b="180000"/></a:path>',e[e.length]="</a:gradFill>",e[e.length]='<a:gradFill rotWithShape="1">',e[e.length]="<a:gsLst>",e[e.length]='<a:gs pos="0"><a:schemeClr val="phClr"><a:tint val="80000"/><a:satMod val="300000"/></a:schemeClr></a:gs>',e[e.length]='<a:gs pos="100000"><a:schemeClr val="phClr"><a:shade val="30000"/><a:satMod val="200000"/></a:schemeClr></a:gs>',e[e.length]="</a:gsLst>",e[e.length]='<a:path path="circle"><a:fillToRect l="50000" t="50000" r="50000" b="50000"/></a:path>',e[e.length]="</a:gradFill>",e[e.length]="</a:bgFillStyleLst>",e[e.length]="</a:fmtScheme>",e[e.length]="</a:themeElements>",e[e.length]="<a:objectDefaults>",e[e.length]="<a:spDef>",e[e.length]='<a:spPr/><a:bodyPr/><a:lstStyle/><a:style><a:lnRef idx="1"><a:schemeClr val="accent1"/></a:lnRef><a:fillRef idx="3"><a:schemeClr val="accent1"/></a:fillRef><a:effectRef idx="2"><a:schemeClr val="accent1"/></a:effectRef><a:fontRef idx="minor"><a:schemeClr val="lt1"/></a:fontRef></a:style>',e[e.length]="</a:spDef>",e[e.length]="<a:lnDef>",e[e.length]='<a:spPr/><a:bodyPr/><a:lstStyle/><a:style><a:lnRef idx="2"><a:schemeClr val="accent1"/></a:lnRef><a:fillRef idx="0"><a:schemeClr val="accent1"/></a:fillRef><a:effectRef idx="1"><a:schemeClr val="accent1"/></a:effectRef><a:fontRef idx="minor"><a:schemeClr val="tx1"/></a:fontRef></a:style>',e[e.length]="</a:lnDef>",e[e.length]="</a:objectDefaults>",e[e.length]="<a:extraClrSchemeLst/>",e[e.length]="</a:theme>",e.join("")}function Yo(e){var t={};switch(t.xclrType=e.read_shift(2),t.nTintShade=e.read_shift(2),t.xclrType){case 0:e.l+=4;break;case 1:t.xclrValue=Pr(e,4);break;case 2:t.xclrValue=Gn(e);break;case 3:t.xclrValue=e.read_shift(4);break;case 4:e.l+=4}return e.l+=8,t}function Ko(e){var t=e.read_shift(2),r=e.read_shift(2)-4,a=[t];switch(t){case 4:case 5:case 7:case 8:case 9:case 10:case 11:case 13:a[1]=Yo(e);break;case 6:a[1]=Pr(e,r);break;case 14:case 15:a[1]=e.read_shift(1==r?1:2);break;default:throw new Error("Unrecognized ExtProp type: "+t+" "+r)}return a}function Jo(){var e,t,r,a=Ur();return Br(a,332),Br(a,334,na(1)),Br(a,335,((r=Lr(12+2*(t={name:"XLDAPR",version:12e4,flags:3496657072}).name.length)).write_shift(4,t.flags),r.write_shift(4,t.version),ia(t.name,r),r.slice(0,r.l))),Br(a,336),Br(a,339,(e=1,(r=Lr(8+2*(t="XLDAPR").length)).write_shift(4,e),ia(t,r),r.slice(0,r.l))),Br(a,52),Br(a,35,na(514)),Br(a,4096,na(0)),Br(a,4097,Fn(1)),Br(a,36),Br(a,53),Br(a,340),Br(a,337,(e=1,t=!0,(r=Lr(8)).write_shift(4,e),r.write_shift(4,t?1:0),r)),Br(a,51,function(e){var t=Lr(4+8*e.length);t.write_shift(4,e.length);for(var r=0;r<e.length;++r)t.write_shift(4,e[r][0]),t.write_shift(4,e[r][1]);return t}([[1,0]])),Br(a,338),Br(a,333),a.end()}function qo(){var e=[ot];return e.push('<metadata xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:xlrd="http://schemas.microsoft.com/office/spreadsheetml/2017/richdata" xmlns:xda="http://schemas.microsoft.com/office/spreadsheetml/2017/dynamicarray">\n  <metadataTypes count="1">\n    <metadataType name="XLDAPR" minSupportedVersion="120000" copy="1" pasteAll="1" pasteValues="1" merge="1" splitFirst="1" rowColShift="1" clearFormats="1" clearComments="1" assign="1" coerce="1" cellMeta="1"/>\n  </metadataTypes>\n  <futureMetadata name="XLDAPR" count="1">\n    <bk>\n      <extLst>\n        <ext uri="{bdbb8cdc-fa1e-496e-a857-3c3f30c029c3}">\n          <xda:dynamicArrayProperties fDynamic="1" fCollapsed="0"/>\n        </ext>\n      </extLst>\n    </bk>\n  </futureMetadata>\n  <cellMetadata count="1">\n    <bk>\n      <rc t="1" v="0"/>\n    </bk>\n  </cellMetadata>\n</metadata>'),e.join("")}var Zo=1024;function Qo(e,t){for(var r=[21600,21600],a=["m0,0l0",r[1],r[0],r[1],r[0],"0xe"].join(","),n=[Yt("xml",null,{"xmlns:v":er.v,"xmlns:o":er.o,"xmlns:x":er.x,"xmlns:mv":er.mv}).replace(/\/>/,">"),Yt("o:shapelayout",Yt("o:idmap",null,{"v:ext":"edit",data:e}),{"v:ext":"edit"}),Yt("v:shapetype",[Yt("v:stroke",null,{joinstyle:"miter"}),Yt("v:path",null,{gradientshapeok:"t","o:connecttype":"rect"})].join(""),{id:"_x0000_t202","o:spt":202,coordsize:r.join(","),path:a})];Zo<1e3*e;)Zo+=1e3;return t.forEach(function(e){var t=Yr(e[0]),r={color2:"#BEFF82",type:"gradient"};"gradient"==r.type&&(r.angle="-180");var a="gradient"==r.type?Yt("o:fill",null,{type:"gradientUnscaled","v:ext":"view"}):null,r=Yt("v:fill",a,r);++Zo,n=n.concat(["<v:shape"+Xt({id:"_x0000_s"+Zo,type:"#_x0000_t202",style:"position:absolute; margin-left:80pt;margin-top:5pt;width:104pt;height:64pt;z-index:10"+(e[1].hidden?";visibility:hidden":""),fillcolor:"#ECFAD4",strokecolor:"#edeaa1"})+">",r,Yt("v:shadow",null,{on:"t",obscured:"t"}),Yt("v:path",null,{"o:connecttype":"none"}),'<v:textbox><div style="text-align:left"></div></v:textbox>','<x:ClientData ObjectType="Note">',"<x:MoveWithCells/>","<x:SizeWithCells/>",$t("x:Anchor",[t.c+1,0,t.r+1,0,t.c+3,20,t.r+5,20].join(",")),$t("x:AutoFill","False"),$t("x:Row",String(t.r)),$t("x:Column",String(t.c)),e[1].hidden?"":"<x:Visible/>","</x:ClientData>","</v:shape>"])}),n.push("</xml>"),n.join("")}function ec(s,e,i,o){var c,l=Array.isArray(s);e.forEach(function(e){var t,r=Yr(e.ref);(c=l?(s[r.r]||(s[r.r]=[]),s[r.r][r.c]):s[e.ref])||(c={t:"z"},l?s[r.r][r.c]=c:s[e.ref]=c,(t=Zr(s["!ref"]||"BDWGO1000001:A1")).s.r>r.r&&(t.s.r=r.r),t.e.r<r.r&&(t.e.r=r.r),t.s.c>r.c&&(t.s.c=r.c),t.e.c<r.c&&(t.e.c=r.c),(t=qr(t))!==s["!ref"]&&(s["!ref"]=t)),c.c||(c.c=[]);var a={a:e.author,t:e.t,r:e.r,T:i};e.h&&(a.h=e.h);for(var n=c.c.length-1;0<=n;--n){if(!i&&c.c[n].T)return;i&&!c.c[n].T&&c.c.splice(n,1)}if(i&&o)for(n=0;n<o.length;++n)if(a.a==o[n].id){a.a=o[n].name||a.a;break}c.c.push(a)})}function tc(e){var s=[ot,Yt("comments",null,{xmlns:Qt[0]})],i=[];return s.push("<authors>"),e.forEach(function(e){e[1].forEach(function(e){var t=kt(e.a);-1==i.indexOf(t)&&(i.push(t),s.push("<author>"+t+"</author>")),e.T&&e.ID&&-1==i.indexOf("tc="+e.ID)&&(i.push("tc="+e.ID),s.push("<author>tc="+e.ID+"</author>"))})}),0==i.length&&(i.push("SheetJ5"),s.push("<author>SheetJ5</author>")),s.push("</authors>"),s.push("<commentList>"),e.forEach(function(e){var t=0,r=[];if(e[1][0]&&e[1][0].T&&e[1][0].ID?t=i.indexOf("tc="+e[1][0].ID):e[1].forEach(function(e){e.a&&(t=i.indexOf(kt(e.a))),r.push(e.t||"")}),s.push('<comment ref="'+e[0]+'" authorId="'+t+'"><text>'),r.length<=1)s.push($t("t",kt(r[0]||"")));else{for(var a="Comment:\n    "+r[0]+"\n",n=1;n<r.length;++n)a+="Reply:\n    "+r[n]+"\n";s.push($t("t",kt(a)))}s.push("</text></comment>")}),s.push("</commentList>"),2<s.length&&(s[s.length]="</comments>",s[1]=s[1].replace("/>",">")),s.join("")}Ue=sa;function rc(e){var n=Ur(),s=[];return Br(n,628),Br(n,630),e.forEach(function(e){e[1].forEach(function(e){-1<s.indexOf(e.a)||(s.push(e.a.slice(0,54)),Br(n,632,ia(e.a.slice(0,54))))})}),Br(n,631),Br(n,633),e.forEach(function(a){a[1].forEach(function(e){e.iauthor=s.indexOf(e.a);var t,r={s:Yr(a[0]),e:Yr(a[0])};Br(n,635,(r=[r,e],(t=null==t?Lr(36):t).write_shift(4,r[1].iauthor),_a(r[0],t),t.write_shift(4,0),t.write_shift(4,0),t.write_shift(4,0),t.write_shift(4,0),t)),e.t&&0<e.t.length&&Br(n,637,la(e)),Br(n,636),delete e.iauthor})}),Br(n,634),Br(n,629),n.end()}var ac="application/vnd.ms-office.vbaProject";var nc=["xlsb","xlsm","xlam","biff8","xla"];var sc,ic,oc=(ic=/(^|[^A-Za-z_])R(\[?-?\d+\]|[1-9]\d*|)C(\[?-?\d+\]|[1-9]\d*|)(?![A-Za-z0-9_])/g,function(e,t){return sc=t,e.replace(ic,cc)});function cc(e,t,r,a){var n=!1,s=!1;0==r.length?s=!0:"["==r.charAt(0)&&(s=!0,r=r.slice(1,-1)),0==a.length?n=!0:"["==a.charAt(0)&&(n=!0,a=a.slice(1,-1));r=0<r.length?0|parseInt(r,10):0,a=0<a.length?0|parseInt(a,10):0;return n?a+=sc.c:--a,s?r+=sc.r:--r,t+(n?"":"$")+Xr(a)+(s?"":"$")+jr(r)}var lc=/(^|[^._A-Z0-9])([$]?)([A-Z]{1,2}|[A-W][A-Z]{2}|X[A-E][A-Z]|XF[A-D])([$]?)(10[0-3]\d{4}|104[0-7]\d{3}|1048[0-4]\d{2}|10485[0-6]\d|104857[0-6]|[1-9]\d{0,5})(?![_.\(A-Za-z0-9])/g,fc=function(e,i){return e.replace(lc,function(e,t,r,a,n,s){a=$r(a)-(r?0:i.c),s=Gr(s)-(n?0:i.r);return t+"R"+(0==s?"":n?1+s:"["+s+"]")+"C"+(0==a?"":r?1+a:"["+a+"]")})};function hc(e,i){return e.replace(lc,function(e,t,r,a,n,s){return t+("$"==r?r+a:Xr($r(a)+i.c))+("$"==n?n+s:jr(Gr(s)+i.r))})}function uc(e){return e.replace(/_xlfn\./g,"")}function dc(e){e.l+=1}function pc(e,t){t=e.read_shift(1==t?1:2);return[16383&t,t>>14&1,t>>15&1]}function mc(e,t,r){var a=2;if(r){if(2<=r.biff&&r.biff<=5)return gc(e);12==r.biff&&(a=4)}var n=e.read_shift(a),r=e.read_shift(a),a=pc(e,2),e=pc(e,2);return{s:{r:n,c:a[0],cRel:a[1],rRel:a[2]},e:{r:r,c:e[0],cRel:e[1],rRel:e[2]}}}function gc(e){var t=pc(e,2),r=pc(e,2),a=e.read_shift(1),e=e.read_shift(1);return{s:{r:t[0],c:a,cRel:t[1],rRel:t[2]},e:{r:r[0],c:e,cRel:r[1],rRel:r[2]}}}function bc(e,t,r){if(r&&2<=r.biff&&r.biff<=5)return n=pc(a=e,2),a=a.read_shift(1),{r:n[0],c:a,cRel:n[1],rRel:n[2]};var a,n,r=e.read_shift(r&&12==r.biff?4:2),e=pc(e,2);return{r:r,c:e[0],cRel:e[1],rRel:e[2]}}function vc(e,t,r){r=r&&r.biff?r.biff:8;if(2<=r&&r<=5)return function(e){var t=e.read_shift(2),r=e.read_shift(1),a=(32768&t)>>15,e=(16384&t)>>14;t&=16383,1==a&&8192<=t&&(t-=16384);1==e&&128<=r&&(r-=256);return{r:t,c:r,cRel:e,rRel:a}}(e);var a=e.read_shift(12<=r?4:2),n=e.read_shift(2),r=(16384&n)>>14,e=(32768&n)>>15;if(n&=16383,1==e)for(;524287<a;)a-=1048576;if(1==r)for(;8191<n;)n-=16384;return{r:a,c:n,cRel:r,rRel:e}}function wc(e){var t=1&e[e.l+1];return e.l+=4,[t,1]}function Tc(e){return[e.read_shift(1),e.read_shift(1)]}function Ec(e,t,r){var a=0,n=0;12==r.biff?(a=e.read_shift(4),n=e.read_shift(4)):(n=1+e.read_shift(1),a=1+e.read_shift(2)),2<=r.biff&&r.biff<8&&(--a,0==--n&&(n=256));for(var s=0,i=[];s!=a&&(i[s]=[]);++s)for(var o=0;o!=n;++o)i[s][o]=function(e,t){var r=[e.read_shift(1)];if(12==t)switch(r[0]){case 2:r[0]=4;break;case 4:r[0]=16;break;case 0:r[0]=1;break;case 1:r[0]=2}switch(r[0]){case 4:r[1]=On(e,1)?"TRUE":"FALSE",12!=t&&(e.l+=7);break;case 37:case 16:r[1]=Wa[e[e.l]],e.l+=12==t?4:8;break;case 0:e.l+=8;break;case 1:r[1]=xa(e);break;case 2:r[1]=Bn(e,0,{biff:0<t&&t<8?2:t});break;default:throw new Error("Bad SerAr: "+r[0])}return r}(e,r.biff);return i}function kc(e,t,r){return e.l+=2,[(e=(a=e).read_shift(2),a=a.read_shift(2),{r:e,c:255&a,fQuoted:!!(16384&a),cRel:a>>15,rRel:a>>15})];var a}function yc(e){return e.l+=6,[]}function Sc(e){return e.l+=2,[Nn(e),1&e.read_shift(2)]}var _c=["Data","All","Headers","??","?Data2","??","?DataHeaders","??","Totals","??","??","??","?DataTotals","??","??","??","?Current"];var xc={1:{n:"PtgExp",f:function(e,t,r){return e.l++,r&&12==r.biff?[e.read_shift(4,"i"),0]:[e.read_shift(2),e.read_shift(r&&2==r.biff?1:2)]}},2:{n:"PtgTbl",f:Pr},3:{n:"PtgAdd",f:dc},4:{n:"PtgSub",f:dc},5:{n:"PtgMul",f:dc},6:{n:"PtgDiv",f:dc},7:{n:"PtgPower",f:dc},8:{n:"PtgConcat",f:dc},9:{n:"PtgLt",f:dc},10:{n:"PtgLe",f:dc},11:{n:"PtgEq",f:dc},12:{n:"PtgGe",f:dc},13:{n:"PtgGt",f:dc},14:{n:"PtgNe",f:dc},15:{n:"PtgIsect",f:dc},16:{n:"PtgUnion",f:dc},17:{n:"PtgRange",f:dc},18:{n:"PtgUplus",f:dc},19:{n:"PtgUminus",f:dc},20:{n:"PtgPercent",f:dc},21:{n:"PtgParen",f:dc},22:{n:"PtgMissArg",f:dc},23:{n:"PtgStr",f:function(e,t,r){return e.l++,Ln(e,0,r)}},26:{n:"PtgSheet",f:function(e,t,r){return e.l+=5,e.l+=2,e.l+=2==r.biff?1:4,["PTGSHEET"]}},27:{n:"PtgEndSheet",f:function(e,t,r){return e.l+=2==r.biff?4:5,["PTGENDSHEET"]}},28:{n:"PtgErr",f:function(e){return e.l++,Wa[e.read_shift(1)]}},29:{n:"PtgBool",f:function(e){return e.l++,0!==e.read_shift(1)}},30:{n:"PtgInt",f:function(e){return e.l++,e.read_shift(2)}},31:{n:"PtgNum",f:function(e){return e.l++,xa(e)}},32:{n:"PtgArray",f:function(e,t,r){var a=(96&e[e.l++])>>5;return e.l+=2==r.biff?6:12==r.biff?14:7,[a]}},33:{n:"PtgFunc",f:function(e,t,r){var a=(96&e[e.l])>>5;return e.l+=1,r=e.read_shift(r&&r.biff<=3?1:2),[jc[r],Gc[r],a]}},34:{n:"PtgFuncVar",f:function(e,t,r){var a=e[e.l++],n=e.read_shift(1),s=r&&r.biff<=3?[88==a?-1:0,e.read_shift(1)]:[(s=e)[s.l+1]>>7,32767&s.read_shift(2)];return[n,(0===s[0]?Gc:Vc)[s[1]]]}},35:{n:"PtgName",f:function(e,t,r){var a=e.read_shift(1)>>>5&3,n=!r||8<=r.biff?4:2,n=e.read_shift(n);switch(r.biff){case 2:e.l+=5;break;case 3:case 4:e.l+=8;break;case 5:e.l+=12}return[a,0,n]}},36:{n:"PtgRef",f:function(e,t,r){var a=(96&e[e.l])>>5;return e.l+=1,[a,bc(e,0,r)]}},37:{n:"PtgArea",f:function(e,t,r){return[(96&e[e.l++])>>5,mc(e,2<=r.biff&&r.biff,r)]}},38:{n:"PtgMemArea",f:function(e,t,r){var a=e.read_shift(1)>>>5&3;return e.l+=r&&2==r.biff?3:4,[a,e.read_shift(r&&2==r.biff?1:2)]}},39:{n:"PtgMemErr",f:Pr},40:{n:"PtgMemNoMem",f:Pr},41:{n:"PtgMemFunc",f:function(e,t,r){return[e.read_shift(1)>>>5&3,e.read_shift(r&&2==r.biff?1:2)]}},42:{n:"PtgRefErr",f:function(e,t,r){var a=e.read_shift(1)>>>5&3;return e.l+=4,r.biff<8&&e.l--,12==r.biff&&(e.l+=2),[a]}},43:{n:"PtgAreaErr",f:function(e,t,r){var a=(96&e[e.l++])>>5;return e.l+=r&&8<r.biff?12:r.biff<8?6:8,[a]}},44:{n:"PtgRefN",f:function(e,t,r){var a=(96&e[e.l])>>5;return e.l+=1,[a,vc(e,0,r)]}},45:{n:"PtgAreaN",f:function(e,t,r){return[(96&e[e.l++])>>5,function(e,t){if(t.biff<8)return gc(e);var r=e.read_shift(12==t.biff?4:2),a=e.read_shift(12==t.biff?4:2),t=pc(e,2),e=pc(e,2);return{s:{r:r,c:t[0],cRel:t[1],rRel:t[2]},e:{r:a,c:e[0],cRel:e[1],rRel:e[2]}}}(e,r)]}},46:{n:"PtgMemAreaN",f:function(e){return[e.read_shift(1)>>>5&3,e.read_shift(2)]}},47:{n:"PtgMemNoMemN",f:function(e){return[e.read_shift(1)>>>5&3,e.read_shift(2)]}},57:{n:"PtgNameX",f:function(e,t,r){return 5==r.biff?function(e){var t=e.read_shift(1)>>>5&3,r=e.read_shift(2,"i");e.l+=8;var a=e.read_shift(2);return e.l+=12,[t,r,a]}(e):[e.read_shift(1)>>>5&3,e.read_shift(2),e.read_shift(4)]}},58:{n:"PtgRef3d",f:function(e,t,r){var a=(96&e[e.l])>>5;e.l+=1;var n=e.read_shift(2);return r&&5==r.biff&&(e.l+=12),[a,n,bc(e,0,r)]}},59:{n:"PtgArea3d",f:function(e,t,r){var a=(96&e[e.l++])>>5,n=e.read_shift(2,"i");if(r)switch(r.biff){case 5:e.l+=12,0;break;case 12:0}return[a,n,mc(e,0,r)]}},60:{n:"PtgRefErr3d",f:function(e,t,r){var a=(96&e[e.l++])>>5,n=e.read_shift(2),s=4;if(r)switch(r.biff){case 5:s=15;break;case 12:s=6}return e.l+=s,[a,n]}},61:{n:"PtgAreaErr3d",f:function(e,t,r){var a=(96&e[e.l++])>>5,n=e.read_shift(2),s=8;if(r)switch(r.biff){case 5:e.l+=12,s=6;break;case 12:s=12}return e.l+=s,[a,n]}},255:{}},Ac={64:32,96:32,65:33,97:33,66:34,98:34,67:35,99:35,68:36,100:36,69:37,101:37,70:38,102:38,71:39,103:39,72:40,104:40,73:41,105:41,74:42,106:42,75:43,107:43,76:44,108:44,77:45,109:45,78:46,110:46,79:47,111:47,88:34,120:34,89:57,121:57,90:58,122:58,91:59,123:59,92:60,124:60,93:61,125:61},Cc={1:{n:"PtgElfLel",f:Sc},2:{n:"PtgElfRw",f:kc},3:{n:"PtgElfCol",f:kc},6:{n:"PtgElfRwV",f:kc},7:{n:"PtgElfColV",f:kc},10:{n:"PtgElfRadical",f:kc},11:{n:"PtgElfRadicalS",f:yc},13:{n:"PtgElfColS",f:yc},15:{n:"PtgElfColSV",f:yc},16:{n:"PtgElfRadicalLel",f:Sc},25:{n:"PtgList",f:function(e){e.l+=2;var t=e.read_shift(2),r=e.read_shift(2),a=e.read_shift(4),n=e.read_shift(2),e=e.read_shift(2);return{ixti:t,coltype:3&r,rt:_c[r>>2&31],idx:a,c:n,C:e}}},29:{n:"PtgSxName",f:function(e){return e.l+=2,[e.read_shift(4)]}},255:{}},Rc={0:{n:"PtgAttrNoop",f:function(e){return e.l+=4,[0,0]}},1:{n:"PtgAttrSemi",f:function(e,t,r){var a=255&e[e.l+1]?1:0;return e.l+=r&&2==r.biff?3:4,[a]}},2:{n:"PtgAttrIf",f:function(e,t,r){var a=255&e[e.l+1]?1:0;return e.l+=2,[a,e.read_shift(r&&2==r.biff?1:2)]}},4:{n:"PtgAttrChoose",f:function(e,t,r){e.l+=2;for(var a=e.read_shift(r&&2==r.biff?1:2),n=[],s=0;s<=a;++s)n.push(e.read_shift(r&&2==r.biff?1:2));return n}},8:{n:"PtgAttrGoto",f:function(e,t,r){var a=255&e[e.l+1]?1:0;return e.l+=2,[a,e.read_shift(r&&2==r.biff?1:2)]}},16:{n:"PtgAttrSum",f:function(e,t,r){e.l+=r&&2==r.biff?3:4}},32:{n:"PtgAttrBaxcel",f:wc},33:{n:"PtgAttrBaxcel",f:wc},64:{n:"PtgAttrSpace",f:function(e){return e.read_shift(2),Tc(e)}},65:{n:"PtgAttrSpaceSemi",f:function(e){return e.read_shift(2),Tc(e)}},128:{n:"PtgAttrIfError",f:function(e){var t=255&e[e.l+1]?1:0;return e.l+=2,[t,e.read_shift(2)]}},255:{}};function Oc(e,t,r,a){if(a.biff<8)return Pr(e,t);for(var n=e.l+t,s=[],i=0;i!==r.length;++i)switch(r[i][0]){case"PtgArray":r[i][1]=Ec(e,0,a),s.push(r[i][1]);break;case"PtgMemArea":r[i][2]=function(e,t){for(var r=e.read_shift(12==t.biff?4:2),a=[],n=0;n!=r;++n)a.push((12==t.biff?Sa:Kn)(e,8));return a}(e,(r[i][1],a)),s.push(r[i][2]);break;case"PtgExp":a&&12==a.biff&&(r[i][1][1]=e.read_shift(4),s.push(r[i][1]));break;case"PtgList":case"PtgElfRadicalS":case"PtgElfColS":case"PtgElfColSV":throw"Unsupported "+r[i][0]}return 0!==(t=n-e.l)&&s.push(Pr(e,t)),s}function Ic(e,t,r){for(var a,n,s=e.l+t,i=[];s!=e.l;)t=s-e.l,n=e[e.l],a=xc[n]||xc[Ac[n]],(a=24===n||25===n?(24===n?Cc:Rc)[e[e.l+1]]:a)&&a.f?i.push([a.n,a.f(e,t,r)]):Pr(e,t);return i}var Nc={PtgAdd:"+",PtgConcat:"&",PtgDiv:"/",PtgEq:"=",PtgGe:">=",PtgGt:">",PtgLe:"<=",PtgLt:"<",PtgMul:"*",PtgNe:"<>",PtgPower:"^",PtgSub:"-"};function Fc(e,t,r){if(!e)return"SH33TJSERR0";if(8<r.biff&&(!e.XTI||!e.XTI[t]))return e.SheetNames[t];if(!e.XTI)return"SH33TJSERR6";var a=e.XTI[t];if(r.biff<8)return 1e4<t&&(t-=65536),0==(t=t<0?-t:t)?"":e.XTI[t-1];if(!a)return"SH33TJSERR1";var n="";if(8<r.biff)switch(e[a[0]][0]){case 357:return n=-1==a[1]?"#REF":e.SheetNames[a[1]],a[1]==a[2]?n:n+":"+e.SheetNames[a[2]];case 358:return null!=r.SID?e.SheetNames[r.SID]:"SH33TJSSAME"+e[a[0]][0];case 355:default:return"SH33TJSSRC"+e[a[0]][0]}switch(e[a[0]][0][0]){case 1025:return n=-1==a[1]?"#REF":e.SheetNames[a[1]]||"SH33TJSERR3",a[1]==a[2]?n:n+":"+e.SheetNames[a[2]];case 14849:return e[a[0]].slice(1).map(function(e){return e.Name}).join(";;");default:return e[a[0]][0][3]?(n=-1==a[1]?"#REF":e[a[0]][0][3][a[1]]||"SH33TJSERR4",a[1]==a[2]?n:n+":"+e[a[0]][0][3][a[2]]):"SH33TJSERR2"}}function Dc(e,t,r){t=Fc(e,t,r);return"#REF"==t?t:function(e,t){if(!(e||t&&t.biff<=5&&2<=t.biff))throw new Error("empty sheet name");return/[^\w\u4E00-\u9FFF\u3040-\u30FF]/.test(e)?"'"+e+"'":e}(t,r)}function Pc(e,t,r,a,n){var s,i,o,c=n&&n.biff||8,l={s:{c:0,r:0},e:{c:0,r:0}},f=[],h=0,u=0,d="";if(!e[0]||!e[0][0])return"";for(var p=-1,m="",g=0,b=e[0].length;g<b;++g){var v=e[0][g];switch(v[0]){case"PtgUminus":f.push("-"+f.pop());break;case"PtgUplus":f.push("+"+f.pop());break;case"PtgPercent":f.push(f.pop()+"%");break;case"PtgAdd":case"PtgConcat":case"PtgDiv":case"PtgEq":case"PtgGe":case"PtgGt":case"PtgLe":case"PtgLt":case"PtgMul":case"PtgNe":case"PtgPower":case"PtgSub":if(O=f.pop(),s=f.pop(),0<=p){switch(e[0][p][1][0]){case 0:m=Ge(" ",e[0][p][1][1]);break;case 1:m=Ge("\r",e[0][p][1][1]);break;default:if(m="",n.WTF)throw new Error("Unexpected PtgAttrSpaceType "+e[0][p][1][0])}s+=m,p=-1}f.push(s+Nc[v[0]]+O);break;case"PtgIsect":O=f.pop(),s=f.pop(),f.push(s+" "+O);break;case"PtgUnion":O=f.pop(),s=f.pop(),f.push(s+","+O);break;case"PtgRange":O=f.pop(),s=f.pop(),f.push(s+":"+O);break;case"PtgAttrChoose":case"PtgAttrGoto":case"PtgAttrIf":case"PtgAttrIfError":break;case"PtgRef":i=Wr(v[1][1],l,n),f.push(zr(i,c));break;case"PtgRefN":i=r?Wr(v[1][1],r,n):v[1][1],f.push(zr(i,c));break;case"PtgRef3d":h=v[1][1],i=Wr(v[1][2],l,n);d=Dc(a,h,n);f.push(d+"!"+zr(i,c));break;case"PtgFunc":case"PtgFuncVar":var w=v[1][0],T=v[1][1],w=w||0,E=0==(w&=127)?[]:f.slice(-w);f.length-=w,"User"===T&&(T=E.shift()),f.push(T+"("+E.join(",")+")");break;case"PtgBool":f.push(v[1]?"TRUE":"FALSE");break;case"PtgInt":f.push(v[1]);break;case"PtgNum":f.push(String(v[1]));break;case"PtgStr":f.push('"'+v[1].replace(/"/g,'""')+'"');break;case"PtgErr":f.push(v[1]);break;case"PtgAreaN":o=Hr(v[1][1],r?{s:r}:l,n),f.push(Vr(o,n));break;case"PtgArea":o=Hr(v[1][1],l,n),f.push(Vr(o,n));break;case"PtgArea3d":h=v[1][1],o=v[1][2],d=Dc(a,h,n),f.push(d+"!"+Vr(o,n));break;case"PtgAttrSum":f.push("SUM("+f.pop()+")");break;case"PtgAttrBaxcel":case"PtgAttrSemi":break;case"PtgName":u=v[1][2];var k=(a.names||[])[u-1]||(a[0]||[])[u],y=k?k.Name:"SH33TJSNAME"+String(u);y&&"_xlfn."==y.slice(0,6)&&!n.xlfn&&(y=y.slice(6)),f.push(y);break;case"PtgNameX":var S,_=v[1][1],u=v[1][2];if(!(n.biff<=5)){k="";14849==((a[_]||[])[0]||[])[0]||(1025==((a[_]||[])[0]||[])[0]?a[_][u]&&0<a[_][u].itab&&(k=a.SheetNames[a[_][u].itab-1]+"!"):k=a.SheetNames[u-1]+"!"),a[_]&&a[_][u]?k+=a[_][u].Name:a[0]&&a[0][u]?k+=a[0][u].Name:(y=(Fc(a,_,n)||"").split(";;"))[u-1]?k=y[u-1]:k+="SH33TJSERRX",f.push(k);break}S=(S=a[_=_<0?-_:_]?a[_][u]:S)||{Name:"SH33TJSERRY"},f.push(S.Name);break;case"PtgParen":var x="(",A=")";if(0<=p){switch(m="",e[0][p][1][0]){case 2:x=Ge(" ",e[0][p][1][1])+x;break;case 3:x=Ge("\r",e[0][p][1][1])+x;break;case 4:A=Ge(" ",e[0][p][1][1])+A;break;case 5:A=Ge("\r",e[0][p][1][1])+A;break;default:if(n.WTF)throw new Error("Unexpected PtgAttrSpaceType "+e[0][p][1][0])}p=-1}f.push(x+f.pop()+A);break;case"PtgRefErr":case"PtgRefErr3d":f.push("#REF!");break;case"PtgExp":i={c:v[1][1],r:v[1][0]};var C={c:r.c,r:r.r};if(a.sharedf[Kr(i)]){_=a.sharedf[Kr(i)];f.push(Pc(_,0,C,a,n))}else{for(var R=!1,O=0;O!=a.arrayf.length;++O)if(s=a.arrayf[O],!(i.c<s[0].s.c||i.c>s[0].e.c||i.r<s[0].s.r||i.r>s[0].e.r)){f.push(Pc(s[1],0,C,a,n)),R=!0;break}R||f.push(v[1])}break;case"PtgArray":f.push("{"+function(e){for(var t=[],r=0;r<e.length;++r){for(var a=e[r],n=[],s=0;s<a.length;++s){var i=a[s];i?2===i[0]?n.push('"'+i[1].replace(/"/g,'""')+'"'):n.push(i[1]):n.push("")}t.push(n.join(","))}return t.join(";")}(v[1])+"}");break;case"PtgMemArea":break;case"PtgAttrSpace":case"PtgAttrSpaceSemi":p=g;break;case"PtgTbl":case"PtgMemErr":break;case"PtgMissArg":f.push("");break;case"PtgAreaErr":case"PtgAreaErr3d":f.push("#REF!");break;case"PtgList":f.push("Table"+v[1].idx+"[#"+v[1].rt+"]");break;case"PtgMemAreaN":case"PtgMemNoMemN":case"PtgAttrNoop":case"PtgSheet":case"PtgEndSheet":case"PtgMemFunc":case"PtgMemNoMem":break;case"PtgElfCol":case"PtgElfColS":case"PtgElfColSV":case"PtgElfColV":case"PtgElfLel":case"PtgElfRadical":case"PtgElfRadicalLel":case"PtgElfRadicalS":case"PtgElfRw":case"PtgElfRwV":throw new Error("Unsupported ELFs");case"PtgSxName":default:throw new Error("Unrecognized Formula Token: "+String(v))}if(3!=n.biff&&0<=p&&-1==["PtgAttrSpace","PtgAttrSpaceSemi","PtgAttrGoto"].indexOf(e[0][g][0])){var I=!0;switch((v=e[0][p])[1][0]){case 4:I=!1;case 0:m=Ge(" ",v[1][1]);break;case 5:I=!1;case 1:m=Ge("\r",v[1][1]);break;default:if(m="",n.WTF)throw new Error("Unexpected PtgAttrSpaceType "+v[1][0])}f.push((I?m:"")+f.pop()+(I?"":m)),p=-1}}if(1<f.length&&n.WTF)throw new Error("bad formula stack");return f[0]}function Lc(e,t,r){var a=e.l+t,n=$n(e);2==r.biff&&++e.l;var s=function(e){var t;if(65535!==yr(e,e.l+6))return[xa(e),"n"];switch(e[e.l]){case 0:return e.l+=8,["String","s"];case 1:return t=1===e[e.l+2],e.l+=8,[t,"b"];case 2:return t=e[e.l+2],e.l+=8,[t,"e"];case 3:return e.l+=8,["","s"]}return[]}(e),t=e.read_shift(1);2!=r.biff&&(e.read_shift(1),5<=r.biff&&e.read_shift(4));r=function(e,t,r){var a,n=e.l+t,s=2==r.biff?1:2,i=e.read_shift(s);if(65535==i)return[[],Pr(e,t-2)];var o=Ic(e,i,r);return t!==i+s&&(a=Oc(e,t-i-s,o,r)),e.l=n,[o,a]}(e,a-e.l,r);return{cell:n,val:s[0],formula:r,shared:t>>3&1,tt:s[1]}}function Mc(e,t,r,a,n){t=Xn(t,r,n),n=null!=(r=e.v)?Aa("number"==typeof r?r:0):((r=Lr(8)).write_shift(1,3),r.write_shift(1,0),r.write_shift(2,0),r.write_shift(2,0),r.write_shift(2,65535),r),r=Lr(6);r.write_shift(2,33),r.write_shift(4,0);for(var s=Lr(e.bf.length),i=0;i<e.bf.length;++i)s[i]=e.bf[i];return ue([t,n,r,s])}function Uc(e,t,r){var a=e.read_shift(4),n=Ic(e,a,r),a=e.read_shift(4);return[n,0<a?Oc(e,a,n,r):null]}var Bc=Uc,Wc=Uc,Hc=Uc,zc=Uc,Vc={0:"BEEP",1:"OPEN",2:"OPEN.LINKS",3:"CLOSE.ALL",4:"SAVE",5:"SAVE.AS",6:"FILE.DELETE",7:"PAGE.SETUP",8:"PRINT",9:"PRINTER.SETUP",10:"QUIT",11:"NEW.WINDOW",12:"ARRANGE.ALL",13:"WINDOW.SIZE",14:"WINDOW.MOVE",15:"FULL",16:"CLOSE",17:"RUN",22:"SET.PRINT.AREA",23:"SET.PRINT.TITLES",24:"SET.PAGE.BREAK",25:"REMOVE.PAGE.BREAK",26:"FONT",27:"DISPLAY",28:"PROTECT.DOCUMENT",29:"PRECISION",30:"A1.R1C1",31:"CALCULATE.NOW",32:"CALCULATION",34:"DATA.FIND",35:"EXTRACT",36:"DATA.DELETE",37:"SET.DATABASE",38:"SET.CRITERIA",39:"SORT",40:"DATA.SERIES",41:"TABLE",42:"FORMAT.NUMBER",43:"ALIGNMENT",44:"STYLE",45:"BORDER",46:"CELL.PROTECTION",47:"COLUMN.WIDTH",48:"UNDO",49:"CUT",50:"COPY",51:"PASTE",52:"CLEAR",53:"PASTE.SPECIAL",54:"EDIT.DELETE",55:"INSERT",56:"FILL.RIGHT",57:"FILL.DOWN",61:"DEFINE.NAME",62:"CREATE.NAMES",63:"FORMULA.GOTO",64:"FORMULA.FIND",65:"SELECT.LAST.CELL",66:"SHOW.ACTIVE.CELL",67:"GALLERY.AREA",68:"GALLERY.BAR",69:"GALLERY.COLUMN",70:"GALLERY.LINE",71:"GALLERY.PIE",72:"GALLERY.SCATTER",73:"COMBINATION",74:"PREFERRED",75:"ADD.OVERLAY",76:"GRIDLINES",77:"SET.PREFERRED",78:"AXES",79:"LEGEND",80:"ATTACH.TEXT",81:"ADD.ARROW",82:"SELECT.CHART",83:"SELECT.PLOT.AREA",84:"PATTERNS",85:"MAIN.CHART",86:"OVERLAY",87:"SCALE",88:"FORMAT.LEGEND",89:"FORMAT.TEXT",90:"EDIT.REPEAT",91:"PARSE",92:"JUSTIFY",93:"HIDE",94:"UNHIDE",95:"WORKSPACE",96:"FORMULA",97:"FORMULA.FILL",98:"FORMULA.ARRAY",99:"DATA.FIND.NEXT",100:"DATA.FIND.PREV",101:"FORMULA.FIND.NEXT",102:"FORMULA.FIND.PREV",103:"ACTIVATE",104:"ACTIVATE.NEXT",105:"ACTIVATE.PREV",106:"UNLOCKED.NEXT",107:"UNLOCKED.PREV",108:"COPY.PICTURE",109:"SELECT",110:"DELETE.NAME",111:"DELETE.FORMAT",112:"VLINE",113:"HLINE",114:"VPAGE",115:"HPAGE",116:"VSCROLL",117:"HSCROLL",118:"ALERT",119:"NEW",120:"CANCEL.COPY",121:"SHOW.CLIPBOARD",122:"MESSAGE",124:"PASTE.LINK",125:"APP.ACTIVATE",126:"DELETE.ARROW",127:"ROW.HEIGHT",128:"FORMAT.MOVE",129:"FORMAT.SIZE",130:"FORMULA.REPLACE",131:"SEND.KEYS",132:"SELECT.SPECIAL",133:"APPLY.NAMES",134:"REPLACE.FONT",135:"FREEZE.PANES",136:"SHOW.INFO",137:"SPLIT",138:"ON.WINDOW",139:"ON.DATA",140:"DISABLE.INPUT",142:"OUTLINE",143:"LIST.NAMES",144:"FILE.CLOSE",145:"SAVE.WORKBOOK",146:"DATA.FORM",147:"COPY.CHART",148:"ON.TIME",149:"WAIT",150:"FORMAT.FONT",151:"FILL.UP",152:"FILL.LEFT",153:"DELETE.OVERLAY",155:"SHORT.MENUS",159:"SET.UPDATE.STATUS",161:"COLOR.PALETTE",162:"DELETE.STYLE",163:"WINDOW.RESTORE",164:"WINDOW.MAXIMIZE",166:"CHANGE.LINK",167:"CALCULATE.DOCUMENT",168:"ON.KEY",169:"APP.RESTORE",170:"APP.MOVE",171:"APP.SIZE",172:"APP.MINIMIZE",173:"APP.MAXIMIZE",174:"BRING.TO.FRONT",175:"SEND.TO.BACK",185:"MAIN.CHART.TYPE",186:"OVERLAY.CHART.TYPE",187:"SELECT.END",188:"OPEN.MAIL",189:"SEND.MAIL",190:"STANDARD.FONT",191:"CONSOLIDATE",192:"SORT.SPECIAL",193:"GALLERY.3D.AREA",194:"GALLERY.3D.COLUMN",195:"GALLERY.3D.LINE",196:"GALLERY.3D.PIE",197:"VIEW.3D",198:"GOAL.SEEK",199:"WORKGROUP",200:"FILL.GROUP",201:"UPDATE.LINK",202:"PROMOTE",203:"DEMOTE",204:"SHOW.DETAIL",206:"UNGROUP",207:"OBJECT.PROPERTIES",208:"SAVE.NEW.OBJECT",209:"SHARE",210:"SHARE.NAME",211:"DUPLICATE",212:"APPLY.STYLE",213:"ASSIGN.TO.OBJECT",214:"OBJECT.PROTECTION",215:"HIDE.OBJECT",216:"SET.EXTRACT",217:"CREATE.PUBLISHER",218:"SUBSCRIBE.TO",219:"ATTRIBUTES",220:"SHOW.TOOLBAR",222:"PRINT.PREVIEW",223:"EDIT.COLOR",224:"SHOW.LEVELS",225:"FORMAT.MAIN",226:"FORMAT.OVERLAY",227:"ON.RECALC",228:"EDIT.SERIES",229:"DEFINE.STYLE",240:"LINE.PRINT",243:"ENTER.DATA",249:"GALLERY.RADAR",250:"MERGE.STYLES",251:"EDITION.OPTIONS",252:"PASTE.PICTURE",253:"PASTE.PICTURE.LINK",254:"SPELLING",256:"ZOOM",259:"INSERT.OBJECT",260:"WINDOW.MINIMIZE",265:"SOUND.NOTE",266:"SOUND.PLAY",267:"FORMAT.SHAPE",268:"EXTEND.POLYGON",269:"FORMAT.AUTO",272:"GALLERY.3D.BAR",273:"GALLERY.3D.SURFACE",274:"FILL.AUTO",276:"CUSTOMIZE.TOOLBAR",277:"ADD.TOOL",278:"EDIT.OBJECT",279:"ON.DOUBLECLICK",280:"ON.ENTRY",281:"WORKBOOK.ADD",282:"WORKBOOK.MOVE",283:"WORKBOOK.COPY",284:"WORKBOOK.OPTIONS",285:"SAVE.WORKSPACE",288:"CHART.WIZARD",289:"DELETE.TOOL",290:"MOVE.TOOL",291:"WORKBOOK.SELECT",292:"WORKBOOK.ACTIVATE",293:"ASSIGN.TO.TOOL",295:"COPY.TOOL",296:"RESET.TOOL",297:"CONSTRAIN.NUMERIC",298:"PASTE.TOOL",302:"WORKBOOK.NEW",305:"SCENARIO.CELLS",306:"SCENARIO.DELETE",307:"SCENARIO.ADD",308:"SCENARIO.EDIT",309:"SCENARIO.SHOW",310:"SCENARIO.SHOW.NEXT",311:"SCENARIO.SUMMARY",312:"PIVOT.TABLE.WIZARD",313:"PIVOT.FIELD.PROPERTIES",314:"PIVOT.FIELD",315:"PIVOT.ITEM",316:"PIVOT.ADD.FIELDS",318:"OPTIONS.CALCULATION",319:"OPTIONS.EDIT",320:"OPTIONS.VIEW",321:"ADDIN.MANAGER",322:"MENU.EDITOR",323:"ATTACH.TOOLBARS",324:"VBAActivate",325:"OPTIONS.CHART",328:"VBA.INSERT.FILE",330:"VBA.PROCEDURE.DEFINITION",336:"ROUTING.SLIP",338:"ROUTE.DOCUMENT",339:"MAIL.LOGON",342:"INSERT.PICTURE",343:"EDIT.TOOL",344:"GALLERY.DOUGHNUT",350:"CHART.TREND",352:"PIVOT.ITEM.PROPERTIES",354:"WORKBOOK.INSERT",355:"OPTIONS.TRANSITION",356:"OPTIONS.GENERAL",370:"FILTER.ADVANCED",373:"MAIL.ADD.MAILER",374:"MAIL.DELETE.MAILER",375:"MAIL.REPLY",376:"MAIL.REPLY.ALL",377:"MAIL.FORWARD",378:"MAIL.NEXT.LETTER",379:"DATA.LABEL",380:"INSERT.TITLE",381:"FONT.PROPERTIES",382:"MACRO.OPTIONS",383:"WORKBOOK.HIDE",384:"WORKBOOK.UNHIDE",385:"WORKBOOK.DELETE",386:"WORKBOOK.NAME",388:"GALLERY.CUSTOM",390:"ADD.CHART.AUTOFORMAT",391:"DELETE.CHART.AUTOFORMAT",392:"CHART.ADD.DATA",393:"AUTO.OUTLINE",394:"TAB.ORDER",395:"SHOW.DIALOG",396:"SELECT.ALL",397:"UNGROUP.SHEETS",398:"SUBTOTAL.CREATE",399:"SUBTOTAL.REMOVE",400:"RENAME.OBJECT",412:"WORKBOOK.SCROLL",413:"WORKBOOK.NEXT",414:"WORKBOOK.PREV",415:"WORKBOOK.TAB.SPLIT",416:"FULL.SCREEN",417:"WORKBOOK.PROTECT",420:"SCROLLBAR.PROPERTIES",421:"PIVOT.SHOW.PAGES",422:"TEXT.TO.COLUMNS",423:"FORMAT.CHARTTYPE",424:"LINK.FORMAT",425:"TRACER.DISPLAY",430:"TRACER.NAVIGATE",431:"TRACER.CLEAR",432:"TRACER.ERROR",433:"PIVOT.FIELD.GROUP",434:"PIVOT.FIELD.UNGROUP",435:"CHECKBOX.PROPERTIES",436:"LABEL.PROPERTIES",437:"LISTBOX.PROPERTIES",438:"EDITBOX.PROPERTIES",439:"PIVOT.REFRESH",440:"LINK.COMBO",441:"OPEN.TEXT",442:"HIDE.DIALOG",443:"SET.DIALOG.FOCUS",444:"ENABLE.OBJECT",445:"PUSHBUTTON.PROPERTIES",446:"SET.DIALOG.DEFAULT",447:"FILTER",448:"FILTER.SHOW.ALL",449:"CLEAR.OUTLINE",450:"FUNCTION.WIZARD",451:"ADD.LIST.ITEM",452:"SET.LIST.ITEM",453:"REMOVE.LIST.ITEM",454:"SELECT.LIST.ITEM",455:"SET.CONTROL.VALUE",456:"SAVE.COPY.AS",458:"OPTIONS.LISTS.ADD",459:"OPTIONS.LISTS.DELETE",460:"SERIES.AXES",461:"SERIES.X",462:"SERIES.Y",463:"ERRORBAR.X",464:"ERRORBAR.Y",465:"FORMAT.CHART",466:"SERIES.ORDER",467:"MAIL.LOGOFF",468:"CLEAR.ROUTING.SLIP",469:"APP.ACTIVATE.MICROSOFT",470:"MAIL.EDIT.MAILER",471:"ON.SHEET",472:"STANDARD.WIDTH",473:"SCENARIO.MERGE",474:"SUMMARY.INFO",475:"FIND.FILE",476:"ACTIVE.CELL.FONT",477:"ENABLE.TIPWIZARD",478:"VBA.MAKE.ADDIN",480:"INSERTDATATABLE",481:"WORKGROUP.OPTIONS",482:"MAIL.SEND.MAILER",485:"AUTOCORRECT",489:"POST.DOCUMENT",491:"PICKLIST",493:"VIEW.SHOW",494:"VIEW.DEFINE",495:"VIEW.DELETE",509:"SHEET.BACKGROUND",510:"INSERT.MAP.OBJECT",511:"OPTIONS.MENONO",517:"MSOCHECKS",518:"NORMAL",519:"LAYOUT",520:"RM.PRINT.AREA",521:"CLEAR.PRINT.AREA",522:"ADD.PRINT.AREA",523:"MOVE.BRK",545:"HIDECURR.NOTE",546:"HIDEALL.NOTES",547:"DELETE.NOTE",548:"TRAVERSE.NOTES",549:"ACTIVATE.NOTES",620:"PROTECT.REVISIONS",621:"UNPROTECT.REVISIONS",647:"OPTIONS.ME",653:"WEB.PUBLISH",667:"NEWWEBQUERY",673:"PIVOT.TABLE.CHART",753:"OPTIONS.SAVE",755:"OPTIONS.SPELL",808:"HIDEALL.INKANNOTS"},Gc={0:"COUNT",1:"IF",2:"ISNA",3:"ISERROR",4:"SUM",5:"AVERAGE",6:"MIN",7:"MAX",8:"ROW",9:"COLUMN",10:"NA",11:"NPV",12:"STDEV",13:"DOLLAR",14:"FIXED",15:"SIN",16:"COS",17:"TAN",18:"ATAN",19:"PI",20:"SQRT",21:"EXP",22:"LN",23:"LOG10",24:"ABS",25:"INT",26:"SIGN",27:"ROUND",28:"LOOKUP",29:"INDEX",30:"REPT",31:"MID",32:"LEN",33:"VALUE",34:"TRUE",35:"FALSE",36:"AND",37:"OR",38:"NOT",39:"MOD",40:"DCOUNT",41:"DSUM",42:"DAVERAGE",43:"DMIN",44:"DMAX",45:"DSTDEV",46:"VAR",47:"DVAR",48:"TEXT",49:"LINEST",50:"TREND",51:"LOGEST",52:"GROWTH",53:"GOTO",54:"HALT",55:"RETURN",56:"PV",57:"FV",58:"NPER",59:"PMT",60:"RATE",61:"MIRR",62:"IRR",63:"RAND",64:"MATCH",65:"DATE",66:"TIME",67:"DAY",68:"MONTH",69:"YEAR",70:"WEEKDAY",71:"HOUR",72:"MINUTE",73:"SECOND",74:"NOW",75:"AREAS",76:"ROWS",77:"COLUMNS",78:"OFFSET",79:"ABSREF",80:"RELREF",81:"ARGUMENT",82:"SEARCH",83:"TRANSPOSE",84:"ERROR",85:"STEP",86:"TYPE",87:"ECHO",88:"SET.NAME",89:"CALLER",90:"DEREF",91:"WINDOWS",92:"SERIES",93:"DOCUMENTS",94:"ACTIVE.CELL",95:"SELECTION",96:"RESULT",97:"ATAN2",98:"ASIN",99:"ACOS",100:"CHOOSE",101:"HLOOKUP",102:"VLOOKUP",103:"LINKS",104:"INPUT",105:"ISREF",106:"GET.FORMULA",107:"GET.NAME",108:"SET.VALUE",109:"LOG",110:"EXEC",111:"CHAR",112:"LOWER",113:"UPPER",114:"PROPER",115:"LEFT",116:"RIGHT",117:"EXACT",118:"TRIM",119:"REPLACE",120:"SUBSTITUTE",121:"CODE",122:"NAMES",123:"DIRECTORY",124:"FIND",125:"CELL",126:"ISERR",127:"ISTEXT",128:"ISNUMBER",129:"ISBLANK",130:"T",131:"N",132:"FOPEN",133:"FCLOSE",134:"FSIZE",135:"FREADLN",136:"FREAD",137:"FWRITELN",138:"FWRITE",139:"FPOS",140:"DATEVALUE",141:"TIMEVALUE",142:"SLN",143:"SYD",144:"DDB",145:"GET.DEF",146:"REFTEXT",147:"TEXTREF",148:"INDIRECT",149:"REGISTER",150:"CALL",151:"ADD.BAR",152:"ADD.MENU",153:"ADD.COMMAND",154:"ENABLE.COMMAND",155:"CHECK.COMMAND",156:"RENAME.COMMAND",157:"SHOW.BAR",158:"DELETE.MENU",159:"DELETE.COMMAND",160:"GET.CHART.ITEM",161:"DIALOG.BOX",162:"CLEAN",163:"MDETERM",164:"MINVERSE",165:"MMULT",166:"FILES",167:"IPMT",168:"PPMT",169:"COUNTA",170:"CANCEL.KEY",171:"FOR",172:"WHILE",173:"BREAK",174:"NEXT",175:"INITIATE",176:"REQUEST",177:"POKE",178:"EXECUTE",179:"TERMINATE",180:"RESTART",181:"HELP",182:"GET.BAR",183:"PRODUCT",184:"FACT",185:"GET.CELL",186:"GET.WORKSPACE",187:"GET.WINDOW",188:"GET.DOCUMENT",189:"DPRODUCT",190:"ISNONTEXT",191:"GET.NOTE",192:"NOTE",193:"STDEVP",194:"VARP",195:"DSTDEVP",196:"DVARP",197:"TRUNC",198:"ISLOGICAL",199:"DCOUNTA",200:"DELETE.BAR",201:"UNREGISTER",204:"USDOLLAR",205:"FINDB",206:"SEARCHB",207:"REPLACEB",208:"LEFTB",209:"RIGHTB",210:"MIDB",211:"LENB",212:"ROUNDUP",213:"ROUNDDOWN",214:"ASC",215:"DBCS",216:"RANK",219:"ADDRESS",220:"DAYS360",221:"TODAY",222:"VDB",223:"ELSE",224:"ELSE.IF",225:"END.IF",226:"FOR.CELL",227:"MEDIAN",228:"SUMPRODUCT",229:"SINH",230:"COSH",231:"TANH",232:"ASINH",233:"ACOSH",234:"ATANH",235:"DGET",236:"CREATE.OBJECT",237:"VOLATILE",238:"LAST.ERROR",239:"CUSTOM.UNDO",240:"CUSTOM.REPEAT",241:"FORMULA.CONVERT",242:"GET.LINK.INFO",243:"TEXT.BOX",244:"INFO",245:"GROUP",246:"GET.OBJECT",247:"DB",248:"PAUSE",251:"RESUME",252:"FREQUENCY",253:"ADD.TOOLBAR",254:"DELETE.TOOLBAR",255:"User",256:"RESET.TOOLBAR",257:"EVALUATE",258:"GET.TOOLBAR",259:"GET.TOOL",260:"SPELLING.CHECK",261:"ERROR.TYPE",262:"APP.TITLE",263:"WINDOW.TITLE",264:"SAVE.TOOLBAR",265:"ENABLE.TOOL",266:"PRESS.TOOL",267:"REGISTER.ID",268:"GET.WORKBOOK",269:"AVEDEV",270:"BETADIST",271:"GAMMALN",272:"BETAINV",273:"BINOMDIST",274:"CHIDIST",275:"CHIINV",276:"COMBIN",277:"CONFIDENCE",278:"CRITBINOM",279:"EVEN",280:"EXPONDIST",281:"FDIST",282:"FINV",283:"FISHER",284:"FISHERINV",285:"FLOOR",286:"GAMMADIST",287:"GAMMAINV",288:"CEILING",289:"HYPGEOMDIST",290:"LOGNORMDIST",291:"LOGINV",292:"NEGBINOMDIST",293:"NORMDIST",294:"NORMSDIST",295:"NORMINV",296:"NORMSINV",297:"STANDARDIZE",298:"ODD",299:"PERMUT",300:"POISSON",301:"TDIST",302:"WEIBULL",303:"SUMXMY2",304:"SUMX2MY2",305:"SUMX2PY2",306:"CHITEST",307:"CORREL",308:"COVAR",309:"FORECAST",310:"FTEST",311:"INTERCEPT",312:"PEARSON",313:"RSQ",314:"STEYX",315:"SLOPE",316:"TTEST",317:"PROB",318:"DEVSQ",319:"GEOMEAN",320:"HARMEAN",321:"SUMSQ",322:"KURT",323:"SKEW",324:"ZTEST",325:"LARGE",326:"SMALL",327:"QUARTILE",328:"PERCENTILE",329:"PERCENTRANK",330:"MODE",331:"TRIMMEAN",332:"TINV",334:"MOVIE.COMMAND",335:"GET.MOVIE",336:"CONCATENATE",337:"POWER",338:"PIVOT.ADD.DATA",339:"GET.PIVOT.TABLE",340:"GET.PIVOT.FIELD",341:"GET.PIVOT.ITEM",342:"RADIANS",343:"DEGREES",344:"SUBTOTAL",345:"SUMIF",346:"COUNTIF",347:"COUNTBLANK",348:"SCENARIO.GET",349:"OPTIONS.LISTS.GET",350:"ISPMT",351:"DATEDIF",352:"DATESTRING",353:"NUMBERSTRING",354:"ROMAN",355:"OPEN.DIALOG",356:"SAVE.DIALOG",357:"VIEW.GET",358:"GETPIVOTDATA",359:"HYPERLINK",360:"PHONETIC",361:"AVERAGEA",362:"MAXA",363:"MINA",364:"STDEVPA",365:"VARPA",366:"STDEVA",367:"VARA",368:"BAHTTEXT",369:"THAIDAYOFWEEK",370:"THAIDIGIT",371:"THAIMONTHOFYEAR",372:"THAINUMSOUND",373:"THAINUMSTRING",374:"THAISTRINGLENGTH",375:"ISTHAIDIGIT",376:"ROUNDBAHTDOWN",377:"ROUNDBAHTUP",378:"THAIYEAR",379:"RTD",380:"CUBEVALUE",381:"CUBEMEMBER",382:"CUBEMEMBERPROPERTY",383:"CUBERANKEDMEMBER",384:"HEX2BIN",385:"HEX2DEC",386:"HEX2OCT",387:"DEC2BIN",388:"DEC2HEX",389:"DEC2OCT",390:"OCT2BIN",391:"OCT2HEX",392:"OCT2DEC",393:"BIN2DEC",394:"BIN2OCT",395:"BIN2HEX",396:"IMSUB",397:"IMDIV",398:"IMPOWER",399:"IMABS",400:"IMSQRT",401:"IMLN",402:"IMLOG2",403:"IMLOG10",404:"IMSIN",405:"IMCOS",406:"IMEXP",407:"IMARGUMENT",408:"IMCONJUGATE",409:"IMAGINARY",410:"IMREAL",411:"COMPLEX",412:"IMSUM",413:"IMPRODUCT",414:"SERIESSUM",415:"FACTDOUBLE",416:"SQRTPI",417:"QUOTIENT",418:"DELTA",419:"GESTEP",420:"ISEVEN",421:"ISODD",422:"MROUND",423:"ERF",424:"ERFC",425:"BESSELJ",426:"BESSELK",427:"BESSELY",428:"BESSELI",429:"XIRR",430:"XNPV",431:"PRICEMAT",432:"YIELDMAT",433:"INTRATE",434:"RECEIVED",435:"DISC",436:"PRICEDISC",437:"YIELDDISC",438:"TBILLEQ",439:"TBILLPRICE",440:"TBILLYIELD",441:"PRICE",442:"YIELD",443:"DOLLARDE",444:"DOLLARFR",445:"NOMINAL",446:"EFFECT",447:"CUMPRINC",448:"CUMIPMT",449:"EDATE",450:"EOMONTH",451:"YEARFRAC",452:"COUPDAYBS",453:"COUPDAYS",454:"COUPDAYSNC",455:"COUPNCD",456:"COUPNUM",457:"COUPPCD",458:"DURATION",459:"MDURATION",460:"ODDLPRICE",461:"ODDLYIELD",462:"ODDFPRICE",463:"ODDFYIELD",464:"RANDBETWEEN",465:"WEEKNUM",466:"AMORDEGRC",467:"AMORLINC",468:"CONVERT",724:"SHEETJS",469:"ACCRINT",470:"ACCRINTM",471:"WORKDAY",472:"NETWORKDAYS",473:"GCD",474:"MULTINOMIAL",475:"LCM",476:"FVSCHEDULE",477:"CUBEKPIMEMBER",478:"CUBESET",479:"CUBESETCOUNT",480:"IFERROR",481:"COUNTIFS",482:"SUMIFS",483:"AVERAGEIF",484:"AVERAGEIFS"},jc={2:1,3:1,10:0,15:1,16:1,17:1,18:1,19:0,20:1,21:1,22:1,23:1,24:1,25:1,26:1,27:2,30:2,31:3,32:1,33:1,34:0,35:0,38:1,39:2,40:3,41:3,42:3,43:3,44:3,45:3,47:3,48:2,53:1,61:3,63:0,65:3,66:3,67:1,68:1,69:1,70:1,71:1,72:1,73:1,74:0,75:1,76:1,77:1,79:2,80:2,83:1,85:0,86:1,89:0,90:1,94:0,95:0,97:2,98:1,99:1,101:3,102:3,105:1,106:1,108:2,111:1,112:1,113:1,114:1,117:2,118:1,119:4,121:1,126:1,127:1,128:1,129:1,130:1,131:1,133:1,134:1,135:1,136:2,137:2,138:2,140:1,141:1,142:3,143:4,144:4,161:1,162:1,163:1,164:1,165:2,172:1,175:2,176:2,177:3,178:2,179:1,184:1,186:1,189:3,190:1,195:3,196:3,197:1,198:1,199:3,201:1,207:4,210:3,211:1,212:2,213:2,214:1,215:1,225:0,229:1,230:1,231:1,232:1,233:1,234:1,235:3,244:1,247:4,252:2,257:1,261:1,271:1,273:4,274:2,275:2,276:2,277:3,278:3,279:1,280:3,281:3,282:3,283:1,284:1,285:2,286:4,287:3,288:2,289:4,290:3,291:3,292:3,293:4,294:1,295:3,296:1,297:3,298:1,299:2,300:3,301:3,302:4,303:2,304:2,305:2,306:2,307:2,308:2,309:3,310:2,311:2,312:2,313:2,314:2,315:2,316:4,325:2,326:2,327:2,328:2,331:2,332:2,337:2,342:1,343:1,346:2,347:1,350:4,351:3,352:1,353:2,360:1,368:1,369:1,370:1,371:1,372:1,373:1,374:1,375:1,376:1,377:1,378:1,382:3,385:1,392:1,393:1,396:2,397:2,398:2,399:1,400:1,401:1,402:1,403:1,404:1,405:1,406:1,407:1,408:1,409:1,410:1,414:4,415:1,416:1,417:2,420:1,421:1,422:2,424:1,425:2,426:2,427:2,428:2,430:3,438:3,439:3,440:3,443:2,444:2,445:2,446:2,447:6,448:6,449:2,450:2,464:2,468:3,476:2,479:1,480:2,65535:0};function $c(e){return(e=(e=(e=(e=61==(e="of:"==e.slice(0,3)?e.slice(3):e).charCodeAt(0)&&61==(e=e.slice(1)).charCodeAt(0)?e.slice(1):e).replace(/COM\.MICROSOFT\./g,"")).replace(/\[((?:\.[A-Z]+[0-9]+)(?::\.[A-Z]+[0-9]+)?)\]/g,function(e,t){return t.replace(/\./g,"")})).replace(/\[.(#[A-Z]*[?!])\]/g,"$1")).replace(/[;~]/g,",").replace(/\|/g,";")}function Xc(e){e=e.split(":");return[e[0].split(".")[0],e[0].split(".")[1]+(1<e.length?":"+(e[1].split(".")[1]||e[1].split(".")[0]):"")]}var Yc={},Kc={},Jc="undefined"!=typeof Map;function qc(e,t,r){var a=0,n=e.length;if(r){if(Jc?r.has(t):Object.prototype.hasOwnProperty.call(r,t))for(var s=Jc?r.get(t):r[t];a<s.length;++a)if(e[s[a]].t===t)return e.Count++,s[a]}else for(;a<n;++a)if(e[a].t===t)return e.Count++,a;return e[n]={t:t},e.Count++,e.Unique++,r&&(Jc?(r.has(t)||r.set(t,[]),r.get(t).push(n)):(Object.prototype.hasOwnProperty.call(r,t)||(r[t]=[]),r[t].push(n))),n}function Zc(e,t){var r={min:e+1,max:e+1},e=-1;return t.MDW&&(no=t.MDW),null!=t.width?r.customWidth=1:null!=t.wpx?e=io(t.wpx):null!=t.wch&&(e=t.wch),-1<e?(r.width=oo(e),r.customWidth=1):null!=t.width&&(r.width=t.width),t.hidden&&(r.hidden=!0),null!=t.level&&(r.outlineLevel=r.level=t.level),r}function Qc(e,t){e&&(t="xlml"==t?[1,1,1,1,.5,.5]:[.7,.7,.75,.75,.3,.3],null==e.left&&(e.left=t[0]),null==e.right&&(e.right=t[1]),null==e.top&&(e.top=t[2]),null==e.bottom&&(e.bottom=t[3]),null==e.header&&(e.header=t[4]),null==e.footer&&(e.footer=t[5]))}function el(e,t,r){if(void 0!==yo){if(/^\d+$/.exec(t.s))return t.s;if(t.s&&t.s==+t.s)return t.s;var a=t.s||{};return t.z&&(a.numFmt=t.z),yo.addStyle(a)}var n=r.revssf[null!=t.z?t.z:"General"],s=60,i=e.length;if(null==n&&r.ssf)for(;s<392;++s)if(null==r.ssf[s]){we(t.z,s),r.ssf[s]=t.z,r.revssf[t.z]=n=s;break}for(s=0;s!=i;++s)if(e[s].numFmtId===n)return s;return e[i]={numFmtId:n,fontId:0,fillId:0,borderId:0,xfId:0,applyNumberFormat:1},i}function tl(e,t,r,a,n,s){try{a.cellNF&&(e.z=me[t])}catch(e){if(a.WTF)throw e}if("z"!==e.t||a.cellStyles){if("d"===e.t&&"string"==typeof e.v&&(e.v=He(e.v)),(!a||!1!==a.cellText)&&"z"!==e.t)try{if(null==me[t]&&we(ke[t]||"General",t),"e"===e.t)e.w=e.w||Wa[e.v];else if(0===t)if("n"===e.t)(0|e.v)===e.v?e.w=e.v.toString(10):e.w=D(e.v);else if("d"===e.t){var i=De(e.v);e.w=(0|i)===i?i.toString(10):D(i)}else{if(void 0===e.v)return;e.w=P(e.v,Kc)}else"d"===e.t?e.w=ve(t,De(e.v),Kc):e.w=ve(t,e.v,Kc)}catch(e){if(a.WTF)throw e}if(a.cellStyles&&null!=r)try{e.s=s.Fills[r],e.s.fgColor&&e.s.fgColor.theme&&!e.s.fgColor.rgb&&(e.s.fgColor.rgb=eo(n.themeElements.clrScheme[e.s.fgColor.theme].rgb,e.s.fgColor.tint||0),a.WTF&&(e.s.fgColor.raw_rgb=n.themeElements.clrScheme[e.s.fgColor.theme].rgb)),e.s.bgColor&&e.s.bgColor.theme&&(e.s.bgColor.rgb=eo(n.themeElements.clrScheme[e.s.bgColor.theme].rgb,e.s.bgColor.tint||0),a.WTF&&(e.s.bgColor.raw_rgb=n.themeElements.clrScheme[e.s.bgColor.theme].rgb))}catch(e){if(a.WTF&&s.Fills)throw e}}}var rl=/<(?:\w:)?mergeCell ref="[A-Z0-9:]+"\s*[\/]?>/g,al=/<(?:\w+:)?sheetData[^>]*>([\s\S]*)<\/(?:\w+:)?sheetData>/,nl=/<(?:\w:)?hyperlink [^>]*>/gm,sl=/"(\w*:\w*)"/,il=/<(?:\w:)?col\b[^>]*[\/]?>/g,ol=/<(?:\w:)?autoFilter[^>]*([\/]|>([\s\S]*)<\/(?:\w:)?autoFilter)>/g,cl=/<(?:\w:)?pageMargins[^>]*\/>/g,ll=/<(?:\w:)?sheetPr\b(?:[^>a-z][^>]*)?\/>/,fl=/<(?:\w:)?sheetPr[^>]*(?:[\/]|>([\s\S]*)<\/(?:\w:)?sheetPr)>/,hl=/<(?:\w:)?sheetViews[^>]*(?:[\/]|>([\s\S]*)<\/(?:\w:)?sheetViews)>/;function ul(e,t,r,a,n,s,i){if(!e)return e;a=a||{"!id":{}},null!=oe&&null==t.dense&&(t.dense=oe);var o=t.dense?[]:{},c={s:{r:2e6,c:2e6},e:{r:0,c:0}},l="",f="",h=e.match(al);h?(l=e.slice(0,h.index),f=e.slice(h.index+h[0].length)):l=f=e;var u=l.match(ll);u?dl(u[0],0,n,r):(u=l.match(fl))&&(e=u[0],u[1],u=o,d=n,p=r,dl(e.slice(0,e.indexOf(">")),0,d,p));var d,p,m=(l.match(/<(?:\w*:)?dimension/)||{index:-1}).index;0<m&&((d=l.slice(m,m+50).match(sl))&&(p=o,(b=Zr(b=d[1])).s.r<=b.e.r&&b.s.c<=b.e.c&&0<=b.s.r&&0<=b.s.c&&(p["!ref"]=qr(b))));var g,b=l.match(hl);b&&b[1]&&(w=b[1],(g=n).Views||(g.Views=[{}]),(w.match(gl)||[]).forEach(function(e,t){e=dt(e);g.Views[t]||(g.Views[t]={}),+e.zoomScale&&(g.Views[t].zoom=+e.zoomScale),Rt(e.rightToLeft)&&(g.Views[t].RTL=!0)}));var v,w=[];t.cellStyles&&(v=l.match(il))&&function(e,t){for(var r=!1,a=0;a!=t.length;++a){var n=dt(t[a],!0);n.hidden&&(n.hidden=Rt(n.hidden));var s=parseInt(n.min,10)-1,i=parseInt(n.max,10)-1;for(n.outlineLevel&&(n.level=+n.outlineLevel||0),delete n.min,delete n.max,n.width=+n.width,!r&&n.width&&(r=!0,lo(n.width)),fo(n);s<=i;)e[s++]=Ve(n)}}(w,v),h&&Sl(h[1],o,t,c,s,i);i=f.match(ol);i&&(o["!autofilter"]={ref:(i[0].match(/ref="([^"]*)"/)||[])[1]});var T=[],E=f.match(rl);if(E)for(m=0;m!=E.length;++m)T[m]=Zr(E[m].slice(E[m].indexOf('"')+1));i=f.match(nl);i&&function(e,t,r){for(var a=Array.isArray(e),n=0;n!=t.length;++n){var s=dt(Mt(t[n]),!0);if(!s.ref)return;var i=((r||{})["!id"]||[])[s.id];i?(s.Target=i.Target,s.location&&(s.Target+="#"+wt(s.location))):(s.Target="#"+wt(s.location),i={Target:s.Target,TargetMode:"Internal"}),s.Rel=i,s.tooltip&&(s.Tooltip=s.tooltip,delete s.tooltip);for(var o=Zr(s.ref),c=o.s.r;c<=o.e.r;++c)for(var l=o.s.c;l<=o.e.c;++l){var f=Kr({c:l,r:c});a?(e[c]||(e[c]=[]),e[c][l]||(e[c][l]={t:"z",v:void 0}),e[c][l].l=s):(e[f]||(e[f]={t:"z",v:void 0}),e[f].l=s)}}}(o,i,a);var k,y,f=f.match(cl);return f&&(o["!margins"]=(k=dt(f[0]),y={},["left","right","top","bottom","header","footer"].forEach(function(e){k[e]&&(y[e]=parseFloat(k[e]))}),y)),!o["!ref"]&&c.e.c>=c.s.c&&c.e.r>=c.s.r&&(o["!ref"]=qr(c)),0<t.sheetRows&&o["!ref"]&&(f=Zr(o["!ref"]),t.sheetRows<=+f.e.r&&(f.e.r=t.sheetRows-1,f.e.r>c.e.r&&(f.e.r=c.e.r),f.e.r<f.s.r&&(f.s.r=f.e.r),f.e.c>c.e.c&&(f.e.c=c.e.c),f.e.c<f.s.c&&(f.s.c=f.e.c),o["!fullref"]=o["!ref"],o["!ref"]=qr(f))),0<w.length&&(o["!cols"]=w),0<T.length&&(o["!merges"]=T),o}function dl(e,t,r,a){e=dt(e);r.Sheets[a]||(r.Sheets[a]={}),e.codeName&&(r.Sheets[a].CodeName=wt(Mt(e.codeName)))}var pl=["objects","scenarios","selectLockedCells","selectUnlockedCells"],ml=["formatColumns","formatRows","formatCells","insertColumns","insertRows","insertHyperlinks","deleteColumns","deleteRows","sort","autoFilter","pivotTables"];var gl=/<(?:\w:)?sheetView(?:[^>a-z][^>]*)?\/?>/;var bl,vl,wl,Tl,El,kl,yl,Sl=(bl=/<(?:\w+:)?c[ \/>]/,vl=/<\/(?:\w+:)?row>/,wl=/r=["']([^"']*)["']/,Tl=/<(?:\w+:)?is>([\S\s]*?)<\/(?:\w+:)?is>/,El=/ref=["']([^"']*)["']/,kl=Bt("v"),yl=Bt("f"),function(e,t,r,a,n,s){for(var i,o,c,l,f,h,u=0,d="",p=[],m=[],g=0,b=0,v="",w=0,T=0,E=0,k=0,y=Array.isArray(s.CellXf),S=[],_=[],x=Array.isArray(t),A=[],C={},R=!1,O=!!r.sheetStubs,I=e.split(vl),N=0,F=I.length;N!=F;++N){var D=(d=I[N].trim()).length;if(0!==D){var P=0;e:for(u=0;u<D;++u)switch(d[u]){case">":if("/"!=d[u-1]){++u;break e}if(r&&r.cellStyles){if(w=null!=(c=dt(d.slice(P,u),!0)).r?parseInt(c.r,10):w+1,T=-1,r.sheetRows&&r.sheetRows<w)continue;R=!(C={}),c.ht&&(R=!0,C.hpt=parseFloat(c.ht),C.hpx=po(C.hpt)),"1"==c.hidden&&(R=!0,C.hidden=!0),null!=c.outlineLevel&&(R=!0,C.level=+c.outlineLevel),R&&(A[w-1]=C)}break;case"<":P=u}if(u<=P)break;if(w=null!=(c=dt(d.slice(P,u),!0)).r?parseInt(c.r,10):w+1,T=-1,!(r.sheetRows&&r.sheetRows<w)){a.s.r>w-1&&(a.s.r=w-1),a.e.r<w-1&&(a.e.r=w-1),r&&r.cellStyles&&(R=!(C={}),c.ht&&(R=!0,C.hpt=parseFloat(c.ht),C.hpx=po(C.hpt)),"1"==c.hidden&&(R=!0,C.hidden=!0),null!=c.outlineLevel&&(R=!0,C.level=+c.outlineLevel),R&&(A[w-1]=C)),p=d.slice(u).split(bl);for(var L,M=0;M!=p.length&&"<"==p[M].trim().charAt(0);++M);for(p=p.slice(M),u=0;u!=p.length;++u)if(0!==(d=p[u].trim()).length){if(m=d.match(wl),g=u,b=0,d="<c "+("<"==d.slice(0,1)?">":"")+d,null!=m&&2===m.length){for(g=0,v=m[1],b=0;b!=v.length&&!((i=v.charCodeAt(b)-64)<1||26<i);++b)g=26*g+i;T=--g}else++T;for(b=0;b!=d.length&&62!==d.charCodeAt(b);++b);if(++b,(c=dt(d.slice(0,b),!0)).r||(c.r=Kr({r:w-1,c:T})),o={t:""},null!=(m=(v=d.slice(b)).match(kl))&&""!==m[1]&&(o.v=wt(m[1])),r.cellFormula){null!=(m=v.match(yl))&&""!==m[1]?(o.f=wt(Mt(m[1])).replace(/\r\n/g,"\n"),r.xlfn||(o.f=uc(o.f)),-1<m[0].indexOf('t="array"')?(o.F=(v.match(El)||[])[1],-1<o.F.indexOf(":")&&S.push([Zr(o.F),o.F])):-1<m[0].indexOf('t="shared"')&&(f=dt(m[0]),L=wt(Mt(m[1])),r.xlfn||(L=uc(L)),_[parseInt(f.si,10)]=[f,L,c.r])):(m=v.match(/<f[^>]*\/>/))&&_[(f=dt(m[0])).si]&&(o.f=(h=_[f.si][1],W=_[f.si][2],L=c.r,W=Jr(W).s,L=Yr(L),hc(h,{r:L.r-W.r,c:L.c-W.c})));for(var U=Yr(c.r),b=0;b<S.length;++b)U.r>=S[b][0].s.r&&U.r<=S[b][0].e.r&&U.c>=S[b][0].s.c&&U.c<=S[b][0].e.c&&(o.F=S[b][1])}if(null==c.t&&void 0===o.v)if(o.f||o.F)o.v=0,o.t="n";else{if(!O)continue;o.t="z"}else o.t=c.t||"n";switch(a.s.c>T&&(a.s.c=T),a.e.c<T&&(a.e.c=T),o.t){case"n":if(""==o.v||null==o.v){if(!O)continue;o.t="z"}else o.v=parseFloat(o.v);break;case"s":if(void 0===o.v){if(!O)continue;o.t="z"}else l=Yc[parseInt(o.v,10)],o.v=l.t,o.r=l.r,r.cellHTML&&(o.h=l.h);break;case"str":o.t="s",o.v=null!=o.v?Mt(o.v):"",r.cellHTML&&(o.h=_t(o.v));break;case"inlineStr":m=v.match(Tl),o.t="s",null!=m&&(l=Ai(m[1]))?(o.v=l.t,r.cellHTML&&(o.h=l.h)):o.v="";break;case"b":o.v=Rt(o.v);break;case"d":r.cellDates?o.v=He(o.v,1):(o.v=De(He(o.v,1)),o.t="n");break;case"e":r&&!1===r.cellText||(o.w=o.v),o.v=Ha[o.v]}var B,E=k=0,W=null;y&&void 0!==c.s&&null!=(W=s.CellXf[c.s])&&(null!=W.numFmtId&&(E=W.numFmtId),r.cellStyles&&null!=W.fillId&&(k=W.fillId)),tl(o,E,k,r,n,s),r.cellDates&&y&&"n"==o.t&&q(me[E])&&(o.t="d",o.v=Me(o.v)),c.cm&&r.xlmeta&&((B=(r.xlmeta.Cell||[])[+c.cm-1])&&"XLDAPR"==B.type&&(o.D=!0)),x?(t[(B=Yr(c.r)).r]||(t[B.r]=[]),t[B.r][B.c]=o):t[c.r]=o}}}}0<A.length&&(t["!rows"]=A)});function _l(e,t){for(var r,a,n,s,i=[],o=[],c=Zr(e["!ref"]),l=[],f=0,h=0,u=e["!rows"],d=Array.isArray(e),p={r:""},m=-1,h=c.s.c;h<=c.e.c;++h)l[h]=Xr(h);for(f=c.s.r;f<=c.e.r;++f){for(o=[],n=jr(f),h=c.s.c;h<=c.e.c;++h){a=l[h]+n;var g=d?(e[f]||[])[h]:e[a];void 0!==g&&null!=(r=function(e,t,r,a){if(e.c&&r["!comments"].push([t,e.c]),void 0===e.v&&"string"!=typeof e.f||"z"===e.t&&!e.f)return"";var n="",s=e.t,i=e.v;if("z"!==e.t)switch(e.t){case"b":n=e.v?"1":"0";break;case"n":n=""+e.v;break;case"e":n=Wa[e.v];break;case"d":n=a&&a.cellDates?He(e.v,-1).toISOString():((e=Ve(e)).t="n",""+(e.v=De(He(e.v)))),void 0===e.z&&(e.z=me[14]);break;default:n=e.v}var o=$t("v",kt(n)),c={r:t},l=el(a.cellXfs,e,a);switch(0!==l&&(c.s=l),e.t){case"n":break;case"d":c.t="d";break;case"b":c.t="b";break;case"e":c.t="e";break;case"z":break;default:if(null==e.v){delete e.t;break}if(32767<e.v.length)throw new Error("Text length must not exceed 32767 characters");if(a&&a.bookSST){o=$t("v",""+qc(a.Strings,e.v,a.revStrings)),c.t="s";break}c.t="str"}return e.t!=s&&(e.t=s,e.v=i),"string"==typeof e.f&&e.f&&(i=e.F&&e.F.slice(0,t.length)==t?{t:"array",ref:e.F}:null,o=Yt("f",kt(e.f),i)+(null!=e.v?o:"")),e.l&&r["!links"].push([t,e.l]),e.D&&(c.cm=1),Yt("c",o,c)}(g,a,e,t))&&o.push(r)}(0<o.length||u&&u[f])&&(p={r:n},u&&u[f]&&((s=u[f]).hidden&&(p.hidden=1),m=-1,s.hpx?m=uo(s.hpx):s.hpt&&(m=s.hpt),-1<m&&(p.ht=m,p.customHeight=1),s.level&&(p.outlineLevel=s.level)),i[i.length]=Yt("row",o.join(""),p))}if(u)for(;f<u.length;++f)u&&u[f]&&(p={r:f+1},(s=u[f]).hidden&&(p.hidden=1),m=-1,s.hpx?m=uo(s.hpx):s.hpt&&(m=s.hpt),-1<m&&(p.ht=m,p.customHeight=1),s.level&&(p.outlineLevel=s.level),i[i.length]=Yt("row","",p));return i.join("")}function xl(e,t,r,a){var n,s,i=[ot,Yt("worksheet",null,{xmlns:Qt[0],"xmlns:r":Zt.r})],o=r.SheetNames[e],c=r.Sheets[o],l=(c=null==c?{}:c)["!ref"]||"A1",f=Zr(l);if(16383<f.e.c||1048575<f.e.r){if(t.WTF)throw new Error("Range "+l+" exceeds format limit A1:XFD1048576");f.e.c=Math.min(f.e.c,16383),f.e.r=Math.min(f.e.c,1048575),l=qr(f)}a=a||{},c["!comments"]=[];var h,u,d=[];!function(e,t,r,a,n){var s=!1,i={},o=null;if("xlsx"!==a.bookType&&t.vbaraw){var c=t.SheetNames[r];try{t.Workbook&&(c=t.Workbook.Sheets[r].CodeName||c)}catch(e){}s=!0,i.codeName=Ut(kt(c))}e&&e["!outline"]&&(a={summaryBelow:1,summaryRight:1},e["!outline"].above&&(a.summaryBelow=0),e["!outline"].left&&(a.summaryRight=0),o=(o||"")+Yt("outlinePr",null,a)),(s||o)&&(n[n.length]=Yt("sheetPr",o,i))}(c,r,e,t,i),i[i.length]=Yt("dimension",null,{ref:l}),i[i.length]=(o={workbookViewId:"0"},((((f=r)||{}).Workbook||{}).Views||[])[0]&&(o.rightToLeft=f.Workbook.Views[0].RTL?"1":"0"),Yt("sheetViews",Yt("sheetView",null,o),{})),t.sheetFormat&&(i[i.length]=Yt("sheetFormatPr",null,{defaultRowHeight:t.sheetFormat.defaultRowHeight||"16",baseColWidth:t.sheetFormat.baseColWidth||"10",outlineLevelRow:t.sheetFormat.outlineLevelRow||"7"})),null!=c["!cols"]&&0<c["!cols"].length&&(i[i.length]=function(e){for(var t,r=["<cols>"],a=0;a!=e.length;++a)(t=e[a])&&(r[r.length]=Yt("col",null,Zc(a,t)));return r[r.length]="</cols>",r.join("")}(c["!cols"])),i[n=i.length]="<sheetData/>",c["!links"]=[],null!=c["!ref"]&&0<(s=_l(c,t)).length&&(i[i.length]=s),i.length>n+1&&(i[i.length]="</sheetData>",i[n]=i[n].replace("/>",">")),c["!protect"]&&(i[i.length]=(h=c["!protect"],u={sheet:1},pl.forEach(function(e){null!=h[e]&&h[e]&&(u[e]="1")}),ml.forEach(function(e){null==h[e]||h[e]||(u[e]="0")}),h.password&&(u.password=zi(h.password).toString(16).toUpperCase()),Yt("sheetProtection",null,u))),null!=c["!autofilter"]&&(i[i.length]=function(e,t,r,a){var n="string"==typeof e.ref?e.ref:qr(e.ref);r.Workbook||(r.Workbook={Sheets:[]}),r.Workbook.Names||(r.Workbook.Names=[]);var s=r.Workbook.Names;(e=Jr(n)).s.r==e.e.r&&(e.e.r=Jr(t["!ref"]).e.r,n=qr(e));for(var i=0;i<s.length;++i){var o=s[i];if("_xlnm._FilterDatabase"==o.Name&&o.Sheet==a){o.Ref="'"+r.SheetNames[a]+"'!"+n;break}}return i==s.length&&s.push({Name:"_xlnm._FilterDatabase",Sheet:a,Ref:"'"+r.SheetNames[a]+"'!"+n}),Yt("autoFilter",null,{ref:n})}(c["!autofilter"],c,r,e)),null!=c["!merges"]&&0<c["!merges"].length&&(i[i.length]=function(e){if(0===e.length)return"";for(var t='<mergeCells count="'+e.length+'">',r=0;r!=e.length;++r)t+='<mergeCell ref="'+qr(e[r])+'"/>';return t+"</mergeCells>"}(c["!merges"]));var p,m,g=-1;return 0<c["!links"].length&&(i[i.length]="<hyperlinks>",c["!links"].forEach(function(e){e[1].Target&&(m={ref:e[0]},"#"!=e[1].Target.charAt(0)&&(g=Ja(a,-1,kt(e[1].Target).replace(/#.*$/,""),$a.HLINK),m["r:id"]="rId"+g),-1<(p=e[1].Target.indexOf("#"))&&(m.location=kt(e[1].Target.slice(p+1))),e[1].Tooltip&&(m.tooltip=kt(e[1].Tooltip)),i[i.length]=Yt("hyperlink",null,m))}),i[i.length]="</hyperlinks>"),delete c["!links"],null!=c["!margins"]&&(i[i.length]=(Qc(r=c["!margins"]),Yt("pageMargins",null,r))),t&&!t.ignoreEC&&null!=t.ignoreEC||(i[i.length]=$t("ignoredErrors",Yt("ignoredError",null,{numberStoredAsText:1,sqref:l}))),0<d.length&&(g=Ja(a,-1,"../drawings/drawing"+(e+1)+".xml",$a.DRAW),i[i.length]=Yt("drawing",null,{"r:id":"rId"+g}),c["!drawing"]=d),0<c["!comments"].length&&(g=Ja(a,-1,"../drawings/vmlDrawing"+(e+1)+".vml",$a.VML),i[i.length]=Yt("legacyDrawing",null,{"r:id":"rId"+g}),c["!legacy"]=g),1<i.length&&(i[i.length]="</worksheet>",i[1]=i[1].replace("/>",">")),i.join("")}function Al(e,t,r,a){r=function(e,t,r){var a=Lr(145),n=(r["!rows"]||[])[e]||{};a.write_shift(4,e),a.write_shift(4,0);var s=320;n.hpx?s=20*uo(n.hpx):n.hpt&&(s=20*n.hpt),a.write_shift(2,s),a.write_shift(1,0),s=0,n.level&&(s|=n.level),n.hidden&&(s|=16),(n.hpx||n.hpt)&&(s|=32),a.write_shift(1,s),a.write_shift(1,0);var i=0,s=a.l;a.l+=4;for(var o={r:e,c:0},c=0;c<16;++c)if(!(t.s.c>c+1<<10||t.e.c<c<<10)){for(var l=-1,f=-1,h=c<<10;h<c+1<<10;++h)o.c=h,(Array.isArray(r)?(r[o.r]||[])[o.c]:r[Kr(o)])&&(l<0&&(l=h),f=h);l<0||(++i,a.write_shift(4,l),a.write_shift(4,f))}return e=a.l,a.l=s,a.write_shift(4,i),a.l=e,a.length>a.l?a.slice(0,a.l):a}(a,r,t);(17<r.length||(t["!rows"]||[])[a])&&Br(e,0,r)}var lt=Sa,Cl=_a;function Rl(e){return[ua(e),xa(e),"n"]}var Lt=Sa,Ol=_a;var Il=["left","right","top","bottom","header","footer"];function Nl(e,t,r,a,n,s,i){if(void 0===t.v)return!1;var o="";switch(t.t){case"b":o=t.v?"1":"0";break;case"d":(t=Ve(t)).z=t.z||me[14],t.v=De(He(t.v)),t.t="n";break;case"n":case"e":o=""+t.v;break;default:o=t.v}var c,l,f,h,u,d,p,m,g,b,v,w,T,E,k,y,S,_,x,A,C={r:r,c:a};switch(C.s=el(n.cellXfs,t,n),t.l&&s["!links"].push([Kr(C),t.l]),t.c&&s["!comments"].push([Kr(C),t.c]),t.t){case"s":case"str":return n.bookSST?(o=qc(n.Strings,t.v,n.revStrings),C.t="s",C.v=o,i?Br(e,18,(da(S=C,_=null==_?Lr(8):_),_.write_shift(4,S.v),_)):Br(e,7,(ha(S=C,y=null==y?Lr(12):y),y.write_shift(4,S.v),y))):(C.t="str",i?Br(e,17,(E=t,da(C,k=null==k?Lr(8+4*E.v.length):k),ia(E.v,k),k.length>k.l?k.slice(0,k.l):k)):Br(e,6,(E=t,ha(C,T=null==T?Lr(12+4*E.v.length):T),ia(E.v,T),T.length>T.l?T.slice(0,T.l):T))),!0;case"n":return t.v==(0|t.v)&&-1e3<t.v&&t.v<1e3?i?Br(e,13,(v=t,da(C,w=null==w?Lr(8):w),ka(v.v,w),w)):Br(e,2,(v=t,ha(C,b=null==b?Lr(12):b),ka(v.v,b),b)):i?Br(e,16,(m=t,da(C,g=null==g?Lr(12):g),Aa(m.v,g),g)):Br(e,5,(m=t,ha(C,p=null==p?Lr(16):p),Aa(m.v,p),p)),!0;case"b":return C.t="b",i?Br(e,15,(u=t,da(C,d=null==d?Lr(5):d),d.write_shift(1,u.v?1:0),d)):Br(e,4,(u=t,ha(C,h=null==h?Lr(9):h),h.write_shift(1,u.v?1:0),h)),!0;case"e":return C.t="e",i?Br(e,14,(l=t,da(C,f=null==f?Lr(8):f),f.write_shift(1,l.v),f.write_shift(2,0),f.write_shift(1,0),f)):Br(e,3,(l=t,ha(C,c=null==c?Lr(9):c),c.write_shift(1,l.v),c)),!0}return i?Br(e,12,da(C,A=null==A?Lr(4):A)):Br(e,1,ha(C,x=null==x?Lr(8):x)),!0}function Fl(t,e){var r,a;e&&e["!merges"]&&(Br(t,177,(r=e["!merges"].length,(a=null==a?Lr(4):a).write_shift(4,r),a)),e["!merges"].forEach(function(e){Br(t,176,Ol(e))}),Br(t,178))}function Dl(r,e){e&&e["!cols"]&&(Br(r,390),e["!cols"].forEach(function(e,t){e&&Br(r,60,function(e,t,r){null==r&&(r=Lr(18));var a=Zc(e,t);return r.write_shift(-4,e),r.write_shift(-4,e),r.write_shift(4,256*(a.width||10)),r.write_shift(4,0),e=0,t.hidden&&(e|=1),"number"==typeof a.width&&(e|=2),t.level&&(e|=t.level<<8),r.write_shift(2,e),r}(t,e))}),Br(r,391))}function Pl(e,t){var r;t&&t["!ref"]&&(Br(e,648),Br(e,649,(r=Zr(t["!ref"]),(t=Lr(24)).write_shift(4,4),t.write_shift(4,1),_a(r,t),t)),Br(e,650))}function Ll(a,e,n){e["!links"].forEach(function(e){var t,r;e[1].Target&&(t=Ja(n,-1,e[1].Target.replace(/#.*$/,""),$a.HLINK),Br(a,494,(r=t,e=Lr(50+4*((t=e)[1].Target.length+(t[1].Tooltip||"").length)),_a({s:Yr(t[0]),e:Yr(t[0])},e),Ta("rId"+r,e),ia((-1==(r=t[1].Target.indexOf("#"))?"":t[1].Target.slice(r+1))||"",e),ia(t[1].Tooltip||"",e),ia("",e),e.slice(0,e.l))))}),delete e["!links"]}function Ml(e,t,r){Br(e,133),Br(e,137,function(e,t){null==t&&(t=Lr(30));var r=924;return(((e||{}).Views||[])[0]||{}).RTL&&(r|=32),t.write_shift(2,r),t.write_shift(4,0),t.write_shift(4,0),t.write_shift(4,0),t.write_shift(1,0),t.write_shift(1,0),t.write_shift(2,0),t.write_shift(2,100),t.write_shift(2,0),t.write_shift(2,0),t.write_shift(2,0),t.write_shift(4,0),t}(r)),Br(e,138),Br(e,134)}function Ul(e,t){var r,a;t["!protect"]&&Br(e,535,(r=t["!protect"],(a=null==a?Lr(66):a).write_shift(2,r.password?zi(r.password):0),a.write_shift(4,1),[["objects",!1],["scenarios",!1],["formatCells",!0],["formatColumns",!0],["formatRows",!0],["insertColumns",!0],["insertRows",!0],["insertHyperlinks",!0],["deleteColumns",!0],["deleteRows",!0],["selectLockedCells",!1],["sort",!0],["autoFilter",!0],["pivotTables",!0],["selectUnlockedCells",!1]].forEach(function(e){e[1]?a.write_shift(4,null==r[e[0]]||r[e[0]]?0:1):a.write_shift(4,null!=r[e[0]]&&r[e[0]]?0:1)}),a))}function Bl(e,t,r,a){var n=Ur(),s=r.SheetNames[e],i=r.Sheets[s]||{},o=s;try{r&&r.Workbook&&(o=r.Workbook.Sheets[e].CodeName||o)}catch(e){}var c,l,s=Zr(i["!ref"]||"A1");if(16383<s.e.c||1048575<s.e.r){if(t.WTF)throw new Error("Range "+(i["!ref"]||"A1")+" exceeds format limit A1:XFD1048576");s.e.c=Math.min(s.e.c,16383),s.e.r=Math.min(s.e.c,1048575)}return i["!links"]=[],i["!comments"]=[],Br(n,129),(r.vbaraw||i["!outline"])&&Br(n,147,function(e,t,r){null==r&&(r=Lr(84+4*e.length));var a=192;t&&(t.above&&(a&=-65),t.left&&(a&=-129)),r.write_shift(1,a);for(var n=1;n<3;++n)r.write_shift(1,0);return Ca({auto:1},r),r.write_shift(-4,-1),r.write_shift(-4,-1),ma(e,r),r.slice(0,r.l)}(o,i["!outline"])),Br(n,148,Cl(s)),Ml(n,0,r.Workbook),Dl(n,i),function(e,t,r){var a,n=Zr(t["!ref"]||"A1"),s=[];Br(e,145);var i=Array.isArray(t),o=n.e.r;t["!rows"]&&(o=Math.max(n.e.r,t["!rows"].length-1));for(var c=n.s.r;c<=o;++c){a=jr(c),Al(e,t,n,c);var l=!1;if(c<=n.e.r)for(var f=n.s.c;f<=n.e.c;++f){c===n.s.r&&(s[f]=Xr(f)),h=s[f]+a;var h=i?(t[c]||[])[f]:t[h];h?l=Nl(e,h,c,f,r,t,l):l=!1}}Br(e,146)}(n,i,t),Ul(n,i),function(e,t,r,a){if(t["!autofilter"]){var n=t["!autofilter"],s="string"==typeof n.ref?n.ref:qr(n.ref);r.Workbook||(r.Workbook={Sheets:[]}),r.Workbook.Names||(r.Workbook.Names=[]);var i=r.Workbook.Names,n=Jr(s);n.s.r==n.e.r&&(n.e.r=Jr(t["!ref"]).e.r,s=qr(n));for(var o=0;o<i.length;++o){var c=i[o];if("_xlnm._FilterDatabase"==c.Name&&c.Sheet==a){c.Ref="'"+r.SheetNames[a]+"'!"+s;break}}o==i.length&&i.push({Name:"_xlnm._FilterDatabase",Sheet:a,Ref:"'"+r.SheetNames[a]+"'!"+s}),Br(e,161,_a(Zr(s))),Br(e,162)}}(n,i,r,e),Fl(n,i),Ll(n,i,a),i["!margins"]&&Br(n,476,(c=i["!margins"],null==l&&(l=Lr(48)),Qc(c),Il.forEach(function(e){Aa(c[e],l)}),l)),t&&!t.ignoreEC&&null!=t.ignoreEC||Pl(n,i),s=n,t=e,a=a,0<(i=i)["!comments"].length&&(t=Ja(a,-1,"../drawings/vmlDrawing"+(t+1)+".vml",$a.VML),Br(s,551,Ta("rId"+t)),i["!legacy"]=t),Br(n,130),n.end()}function Wl(e,t,r,a,n,s){var i=s||{"!type":"chart"};if(!e)return s;var o,c=0,l=0,f={s:{r:2e6,c:2e6},e:{r:0,c:0}};return(e.match(/<c:numCache>[\s\S]*?<\/c:numCache>/gm)||[]).forEach(function(e){var r=function(e){var t,r=[],a=e.match(/^<c:numCache>/);(e.match(/<c:pt idx="(\d*)">(.*?)<\/c:pt>/gm)||[]).forEach(function(e){e=e.match(/<c:pt idx="(\d*?)"><c:v>(.*)<\/c:v><\/c:pt>/);e&&(r[+e[1]]=a?+e[2]:e[2])});var n=wt((e.match(/<c:formatCode>([\s\S]*?)<\/c:formatCode>/)||["","General"])[1]);return(e.match(/<c:f>(.*?)<\/c:f>/gm)||[]).forEach(function(e){t=e.replace(/<.*?>/g,"")}),[r,n,t]}(e);f.s.r=f.s.c=0,f.e.c=c,o=Xr(c),r[0].forEach(function(e,t){i[o+jr(t)]={t:"n",v:e,z:r[1]},l=t}),f.e.r<l&&(f.e.r=l),++c}),0<c&&(i["!ref"]=qr(f)),i}var Hl=[["allowRefreshQuery",!1,"bool"],["autoCompressPictures",!0,"bool"],["backupFile",!1,"bool"],["checkCompatibility",!1,"bool"],["CodeName",""],["date1904",!1,"bool"],["defaultThemeVersion",0,"int"],["filterPrivacy",!1,"bool"],["hidePivotFieldList",!1,"bool"],["promptedSolutions",!1,"bool"],["publishItems",!1,"bool"],["refreshAllConnections",!1,"bool"],["saveExternalLinkValues",!0,"bool"],["showBorderUnselectedTables",!0,"bool"],["showInkAnnotation",!0,"bool"],["showObjects","all"],["showPivotChartFilter",!1,"bool"],["updateLinks","userSet"]],zl=[["activeTab",0,"int"],["autoFilterDateGrouping",!0,"bool"],["firstSheet",0,"int"],["minimized",!1,"bool"],["showHorizontalScroll",!0,"bool"],["showSheetTabs",!0,"bool"],["showVerticalScroll",!0,"bool"],["tabRatio",600,"int"],["visibility","visible"]],Vl=[],Gl=[["calcCompleted","true"],["calcMode","auto"],["calcOnSave","true"],["concurrentCalc","true"],["fullCalcOnLoad","false"],["fullPrecision","true"],["iterate","false"],["iterateCount","100"],["iterateDelta","0.001"],["refMode","A1"]];function jl(e,t){for(var r=0;r!=e.length;++r)for(var a=e[r],n=0;n!=t.length;++n){var s=t[n];if(null==a[s[0]])a[s[0]]=s[1];else switch(s[2]){case"bool":"string"==typeof a[s[0]]&&(a[s[0]]=Rt(a[s[0]]));break;case"int":"string"==typeof a[s[0]]&&(a[s[0]]=parseInt(a[s[0]],10))}}}function $l(e,t){for(var r=0;r!=t.length;++r){var a=t[r];if(null==e[a[0]])e[a[0]]=a[1];else switch(a[2]){case"bool":"string"==typeof e[a[0]]&&(e[a[0]]=Rt(e[a[0]]));break;case"int":"string"==typeof e[a[0]]&&(e[a[0]]=parseInt(e[a[0]],10))}}}function Xl(e){$l(e.WBProps,Hl),$l(e.CalcPr,Gl),jl(e.WBView,zl),jl(e.Sheets,Vl),Kc.date1904=Rt(e.WBProps.date1904)}var Yl="][*?/\\".split("");function Kl(t,r){if(31<t.length){if(r)return;throw new Error("Sheet names cannot exceed 31 chars")}var a=!0;return Yl.forEach(function(e){if(-1!=t.indexOf(e)){if(!r)throw new Error("Sheet name cannot contain : \\ / ? * [ ]");a=!1}}),a}function Jl(e){if(!e||!e.SheetNames||!e.Sheets)throw new Error("Invalid Workbook");if(!e.SheetNames.length)throw new Error("Workbook is empty");var n,s,i,t=e.Workbook&&e.Workbook.Sheets||[];n=e.SheetNames,s=t,i=!!e.vbaraw,n.forEach(function(e,t){Kl(e);for(var r=0;r<t;++r)if(e==n[r])throw new Error("Duplicate Sheet Name: "+e);if(i){var a=s&&s[t]&&s[t].CodeName||e;if(95==a.charCodeAt(0)&&22<a.length)throw new Error("Bad Code Name: Worksheet"+a)}});for(var r=0;r<e.SheetNames.length;++r)!function(e,t){if(e&&e["!ref"]){var r=Zr(e["!ref"]);if(r.e.c<r.s.c||r.e.r<r.s.r)throw new Error("Bad range ("+t+"): "+e["!ref"])}}(e.Sheets[e.SheetNames[r]],(e.SheetNames[r],r))}var ql=/<\w+:workbook/;function Zl(t){var r=[ot];r[r.length]=Yt("workbook",null,{xmlns:Qt[0],"xmlns:r":Zt.r});var e=t.Workbook&&0<(t.Workbook.Names||[]).length,a={codeName:"ThisWorkbook"};t.Workbook&&t.Workbook.WBProps&&(Hl.forEach(function(e){null!=t.Workbook.WBProps[e[0]]&&t.Workbook.WBProps[e[0]]!=e[1]&&(a[e[0]]=t.Workbook.WBProps[e[0]])}),t.Workbook.WBProps.CodeName&&(a.codeName=t.Workbook.WBProps.CodeName,delete a.CodeName)),r[r.length]=Yt("workbookPr",null,a);var n=t.Workbook&&t.Workbook.Sheets||[],s=0;if(n&&n[0]&&n[0].Hidden){for(r[r.length]="<bookViews>",s=0;s!=t.SheetNames.length&&n[s]&&n[s].Hidden;++s);s==t.SheetNames.length&&(s=0),r[r.length]='<workbookView firstSheet="'+s+'" activeTab="'+s+'"/>',r[r.length]="</bookViews>"}for(r[r.length]="<sheets>",s=0;s!=t.SheetNames.length;++s){var i={name:kt(t.SheetNames[s].slice(0,31))};if(i.sheetId=""+(s+1),i["r:id"]="rId"+(s+1),n[s])switch(n[s].Hidden){case 1:i.state="hidden";break;case 2:i.state="veryHidden"}r[r.length]=Yt("sheet",null,i)}return r[r.length]="</sheets>",e&&(r[r.length]="<definedNames>",t.Workbook&&t.Workbook.Names&&t.Workbook.Names.forEach(function(e){var t={name:e.Name};e.Comment&&(t.comment=e.Comment),null!=e.Sheet&&(t.localSheetId=""+e.Sheet),e.Hidden&&(t.hidden="1"),e.Ref&&(r[r.length]=Yt("definedName",kt(e.Ref),t))}),r[r.length]="</definedNames>"),2<r.length&&(r[r.length]="</workbook>",r[1]=r[1].replace("/>",">")),r.join("")}function Ql(e,t){var r={};return e.read_shift(4),r.ArchID=e.read_shift(4),e.l+=t-8,r}function ef(e,t){Br(e,143);for(var r,a=0;a!=t.SheetNames.length;++a){var n={Hidden:t.Workbook&&t.Workbook.Sheets&&t.Workbook.Sheets[a]&&t.Workbook.Sheets[a].Hidden||0,iTabID:a+1,strRelID:"rId"+(a+1),name:t.SheetNames[a]};Br(e,156,(r=n,(n=(n=void 0)||Lr(127)).write_shift(4,r.Hidden),n.write_shift(4,r.iTabID),Ta(r.strRelID,n),ia(r.name.slice(0,31),n),n.length>n.l?n.slice(0,n.l):n))}Br(e,144)}function tf(e,t){if(t.Workbook&&t.Workbook.Sheets){for(var r,a=t.Workbook.Sheets,n=0,s=-1,i=-1;n<a.length;++n)!a[n]||!a[n].Hidden&&-1==s?s=n:1==a[n].Hidden&&-1==i&&(i=n);s<i||(Br(e,135),Br(e,158,(t=s,(r=r||Lr(29)).write_shift(-4,0),r.write_shift(-4,460),r.write_shift(4,28800),r.write_shift(4,17600),r.write_shift(4,500),r.write_shift(4,t),r.write_shift(4,t),r.write_shift(1,120),r.length>r.l?r.slice(0,r.l):r)),Br(e,136))}}function rf(e,t){var r=Ur();return Br(r,131),Br(r,128,function(e){e=e||Lr(127);for(var t=0;4!=t;++t)e.write_shift(4,0);return ia("SheetJS",e),ia(a.version,e),ia(a.version,e),ia("7262",e),e.length>e.l?e.slice(0,e.l):e}()),Br(r,153,function(e,t){t=t||Lr(72);var r=0;return e&&e.filterPrivacy&&(r|=8),t.write_shift(4,r),t.write_shift(4,0),ma(e&&e.CodeName||"ThisWorkbook",t),t.slice(0,t.l)}(e.Workbook&&e.Workbook.WBProps||null)),tf(r,e),ef(r,e),Br(r,132),r.end()}function af(e,t,r){return(".bin"===t.slice(-4)?function(e,a){var n={AppVersion:{},WBProps:{},WBView:[],Sheets:[],CalcPr:{},xmlns:""},s=[],i=!1;(a=a||{}).biff=12;var o=[],c=[[]];return c.SheetNames=[],c.XTI=[],Df[16]={n:"BrtFRTArchID$",f:Ql},Mr(e,function(e,t,r){switch(r){case 156:c.SheetNames.push(e.name),n.Sheets.push(e);break;case 153:n.WBProps=e;break;case 39:null!=e.Sheet&&(a.SID=e.Sheet),e.Ref=Pc(e.Ptg,0,null,c,a),delete a.SID,delete e.Ptg,o.push(e);break;case 1036:break;case 357:case 358:case 355:case 667:c[0].length?c.push([r,e]):c[0]=[r,e],c[c.length-1].XTI=[];break;case 362:0===c.length&&(c[0]=[],c[0].XTI=[]),c[c.length-1].XTI=c[c.length-1].XTI.concat(e),c.XTI=c.XTI.concat(e);break;case 361:break;case 2071:case 158:case 143:case 664:case 353:break;case 3072:case 3073:case 534:case 677:case 157:case 610:case 2050:case 155:case 548:case 676:case 128:case 665:case 2128:case 2125:case 549:case 2053:case 596:case 2076:case 2075:case 2082:case 397:case 154:case 1117:case 553:case 2091:break;case 35:s.push(r),i=!0;break;case 36:s.pop(),i=!1;break;case 37:s.push(r),i=!0;break;case 38:s.pop(),i=!1;break;case 16:break;default:if(!t.T&&(!i||a.WTF&&37!=s[s.length-1]&&35!=s[s.length-1]))throw new Error("Unexpected record 0x"+r.toString(16))}},a),Xl(n),n.Names=o,n.supbooks=c,n}:function(a,n){if(!a)throw new Error("Could not find file");var s={AppVersion:{},WBProps:{},WBView:[],Sheets:[],CalcPr:{},Names:[],xmlns:""},i=!1,o="xmlns",c={},l=0;if(a.replace(ft,function(e,t){var r=dt(e);switch(pt(r[0])){case"<?xml":break;case"<workbook":e.match(ql)&&(o="xmlns"+e.match(/<(\w+):/)[1]),s.xmlns=r[o];break;case"</workbook>":break;case"<fileVersion":delete r[0],s.AppVersion=r;break;case"<fileVersion/>":case"</fileVersion>":case"<fileSharing":case"<fileSharing/>":break;case"<workbookPr":case"<workbookPr/>":Hl.forEach(function(e){if(null!=r[e[0]])switch(e[2]){case"bool":s.WBProps[e[0]]=Rt(r[e[0]]);break;case"int":s.WBProps[e[0]]=parseInt(r[e[0]],10);break;default:s.WBProps[e[0]]=r[e[0]]}}),r.codeName&&(s.WBProps.CodeName=Mt(r.codeName));break;case"</workbookPr>":case"<workbookProtection":case"<workbookProtection/>":break;case"<bookViews":case"<bookViews>":case"</bookViews>":break;case"<workbookView":case"<workbookView/>":delete r[0],s.WBView.push(r);break;case"</workbookView>":break;case"<sheets":case"<sheets>":case"</sheets>":break;case"<sheet":switch(r.state){case"hidden":r.Hidden=1;break;case"veryHidden":r.Hidden=2;break;default:r.Hidden=0}delete r.state,r.name=wt(Mt(r.name)),delete r[0],s.Sheets.push(r);break;case"</sheet>":break;case"<functionGroups":case"<functionGroups/>":case"<functionGroup":break;case"<externalReferences":case"</externalReferences>":case"<externalReferences>":case"<externalReference":case"<definedNames/>":break;case"<definedNames>":case"<definedNames":i=!0;break;case"</definedNames>":i=!1;break;case"<definedName":(c={}).Name=Mt(r.name),r.comment&&(c.Comment=r.comment),r.localSheetId&&(c.Sheet=+r.localSheetId),Rt(r.hidden||"0")&&(c.Hidden=!0),l=t+e.length;break;case"</definedName>":c.Ref=wt(Mt(a.slice(l,t))),s.Names.push(c);break;case"<definedName/>":break;case"<calcPr":case"<calcPr/>":delete r[0],s.CalcPr=r;break;case"</calcPr>":case"<oleSize":break;case"<customWorkbookViews>":case"</customWorkbookViews>":case"<customWorkbookViews":break;case"<customWorkbookView":case"</customWorkbookView>":break;case"<pivotCaches>":case"</pivotCaches>":case"<pivotCaches":case"<pivotCache":break;case"<smartTagPr":case"<smartTagPr/>":break;case"<smartTagTypes":case"<smartTagTypes>":case"</smartTagTypes>":case"<smartTagType":break;case"<webPublishing":case"<webPublishing/>":break;case"<fileRecoveryPr":case"<fileRecoveryPr/>":break;case"<webPublishObjects>":case"<webPublishObjects":case"</webPublishObjects>":case"<webPublishObject":break;case"<extLst":case"<extLst>":case"</extLst>":case"<extLst/>":break;case"<ext":i=!0;break;case"</ext>":i=!1;break;case"<ArchID":break;case"<AlternateContent":case"<AlternateContent>":i=!0;break;case"</AlternateContent>":i=!1;break;case"<revisionPtr":break;default:if(!i&&n.WTF)throw new Error("unrecognized "+r[0]+" in workbook")}return e}),-1===Qt.indexOf(s.xmlns))throw new Error("Unknown Namespace: "+s.xmlns);return Xl(s),s})(e,r)}function nf(e,t,r,a,n,s,i,o){return(".bin"===t.slice(-4)?function(e,t,s,i,o,c,l){if(!e)return e;var f=t||{};i=i||{"!id":{}},null!=oe&&null==f.dense&&(f.dense=oe);var h,u,d,p,m,g,b,v,w,T,E=f.dense?[]:{},k={s:{r:2e6,c:2e6},e:{r:0,c:0}},y=[],S=!1,_=!1,x=[];f.biff=12;var A=f["!row"]=0,C=!1,R=[],O={},I=f.supbooks||o.supbooks||[[]];if(I.sharedf=O,I.arrayf=R,I.SheetNames=o.SheetNames||o.Sheets.map(function(e){return e.name}),!f.supbooks&&(f.supbooks=I,o.Names))for(var r=0;r<o.Names.length;++r)I[0][r+1]=o.Names[r];var N,F=[],D=[],P=!1;return Df[16]={n:"BrtShortReal",f:Rl},Mr(e,function(e,t,r){if(!_)switch(r){case 148:h=e;break;case 0:u=e,f.sheetRows&&f.sheetRows<=u.r&&(_=!0),w=jr(m=u.r),f["!row"]=u.r,(e.hidden||e.hpt||null!=e.level)&&(e.hpt&&(e.hpx=po(e.hpt)),D[e.r]=e);break;case 2:case 3:case 4:case 5:case 6:case 7:case 8:case 9:case 10:case 11:case 13:case 14:case 15:case 16:case 17:case 18:case 62:switch(d={t:e[2]},e[2]){case"n":d.v=e[1];break;case"s":v=Yc[e[1]],d.v=v.t,d.r=v.r;break;case"b":d.v=!!e[1];break;case"e":d.v=e[1],!1!==f.cellText&&(d.w=Wa[d.v]);break;case"str":d.t="s",d.v=e[1];break;case"is":d.t="s",d.v=e[1].t}if((p=l.CellXf[e[0].iStyleRef])&&tl(d,p.numFmtId,null,f,c,l),g=-1==e[0].c?g+1:e[0].c,f.dense?(E[m]||(E[m]=[]),E[m][g]=d):E[Xr(g)+w]=d,f.cellFormula){for(C=!1,A=0;A<R.length;++A){var a=R[A];u.r>=a[0].s.r&&u.r<=a[0].e.r&&g>=a[0].s.c&&g<=a[0].e.c&&(d.F=qr(a[0]),C=!0)}!C&&3<e.length&&(d.f=e[3])}k.s.r>u.r&&(k.s.r=u.r),k.s.c>g&&(k.s.c=g),k.e.r<u.r&&(k.e.r=u.r),k.e.c<g&&(k.e.c=g),f.cellDates&&p&&"n"==d.t&&q(me[p.numFmtId])&&((n=L(d.v))&&(d.t="d",d.v=new Date(n.y,n.m-1,n.d,n.H,n.M,n.S,n.u))),N&&("XLDAPR"==N.type&&(d.D=!0),N=void 0),0;break;case 1:case 12:if(!f.sheetStubs||S)break;d={t:"z",v:void 0},g=-1==e[0].c?g+1:e[0].c,f.dense?(E[m]||(E[m]=[]),E[m][g]=d):E[Xr(g)+w]=d,k.s.r>u.r&&(k.s.r=u.r),k.s.c>g&&(k.s.c=g),k.e.r<u.r&&(k.e.r=u.r),k.e.c<g&&(k.e.c=g),N&&("XLDAPR"==N.type&&(d.D=!0),N=void 0),0;break;case 176:x.push(e);break;case 49:N=((f.xlmeta||{}).Cell||[])[e-1];break;case 494:var n=i["!id"][e.relId];for(n?(e.Target=n.Target,e.loc&&(e.Target+="#"+e.loc),e.Rel=n):""==e.relId&&(e.Target="#"+e.loc),m=e.rfx.s.r;m<=e.rfx.e.r;++m)for(g=e.rfx.s.c;g<=e.rfx.e.c;++g)f.dense?(E[m]||(E[m]=[]),E[m][g]||(E[m][g]={t:"z",v:void 0}),E[m][g].l=e):(b=Kr({c:g,r:m}),E[b]||(E[b]={t:"z",v:void 0}),E[b].l=e);break;case 426:if(!f.cellFormula)break;R.push(e),(T=f.dense?E[m][g]:E[Xr(g)+w]).f=Pc(e[1],0,{r:u.r,c:g},I,f),T.F=qr(e[0]);break;case 427:if(!f.cellFormula)break;O[Kr(e[0].s)]=e[1],(T=f.dense?E[m][g]:E[Xr(g)+w]).f=Pc(e[1],0,{r:u.r,c:g},I,f);break;case 60:if(!f.cellStyles)break;for(;e.e>=e.s;)F[e.e--]={width:e.w/256,hidden:!!(1&e.flags),level:e.level},P||(P=!0,lo(e.w/256)),fo(F[e.e+1]);break;case 161:E["!autofilter"]={ref:qr(e)};break;case 476:E["!margins"]=e;break;case 147:o.Sheets[s]||(o.Sheets[s]={}),e.name&&(o.Sheets[s].CodeName=e.name),(e.above||e.left)&&(E["!outline"]={above:e.above,left:e.left});break;case 137:o.Views||(o.Views=[{}]),o.Views[0]||(o.Views[0]={}),e.RTL&&(o.Views[0].RTL=!0);break;case 485:break;case 64:case 1053:case 151:break;case 152:case 175:case 644:case 625:case 562:case 396:case 1112:case 1146:case 471:case 1050:case 649:case 1105:case 589:case 607:case 564:case 1055:case 168:case 174:case 1180:case 499:case 507:case 550:case 171:case 167:case 1177:case 169:case 1181:case 551:case 552:case 661:case 639:case 478:case 537:case 477:case 536:case 1103:case 680:case 1104:case 1024:case 663:case 535:case 678:case 504:case 1043:case 428:case 170:case 3072:case 50:case 2070:case 1045:break;case 35:S=!0;break;case 36:S=!1;break;case 37:y.push(r),S=!0;break;case 38:y.pop(),S=!1;break;default:if(!t.T&&(!S||f.WTF))throw new Error("Unexpected record 0x"+r.toString(16))}},f),delete f.supbooks,delete f["!row"],!E["!ref"]&&(k.s.r<2e6||h&&(0<h.e.r||0<h.e.c||0<h.s.r||0<h.s.c))&&(E["!ref"]=qr(h||k)),f.sheetRows&&E["!ref"]&&(e=Zr(E["!ref"]),f.sheetRows<=+e.e.r&&(e.e.r=f.sheetRows-1,e.e.r>k.e.r&&(e.e.r=k.e.r),e.e.r<e.s.r&&(e.s.r=e.e.r),e.e.c>k.e.c&&(e.e.c=k.e.c),e.e.c<e.s.c&&(e.s.c=e.e.c),E["!fullref"]=E["!ref"],E["!ref"]=qr(e))),0<x.length&&(E["!merges"]=x),0<F.length&&(E["!cols"]=F),0<D.length&&(E["!rows"]=D),E}:ul)(e,a,r,n,s,i,o)}function sf(e,t,r,a,n,s){return".bin"===t.slice(-4)?function(e,a,n,t,s){if(!e)return e;t=t||{"!id":{}};var i={"!type":"chart","!drawel":null,"!rel":""},o=[],c=!1;return Mr(e,function(e,t,r){switch(r){case 550:i["!rel"]=e;break;case 651:s.Sheets[n]||(s.Sheets[n]={}),e.name&&(s.Sheets[n].CodeName=e.name);break;case 562:case 652:case 669:case 679:case 551:case 552:case 476:case 3072:break;case 35:c=!0;break;case 36:c=!1;break;case 37:o.push(r);break;case 38:o.pop();break;default:if(0<t.T)o.push(r);else if(t.T<0)o.pop();else if(!c||a.WTF)throw new Error("Unexpected record 0x"+r.toString(16))}},a),t["!id"][i["!rel"]]&&(i["!drawel"]=t["!id"][i["!rel"]]),i}(e,a,r,n,s):function(e,t,r,a){if(!e)return e;r=r||{"!id":{}};var n={"!type":"chart","!drawel":null,"!rel":""},s=e.match(ll);return s&&dl(s[0],0,a,t),(e=e.match(/drawing r:id="(.*?)"/))&&(n["!rel"]=e[1]),r["!id"][n["!rel"]]&&(n["!drawel"]=r["!id"][n["!rel"]]),n}(e,r,n,s)}function of(e,t,r,a){return(".bin"===t.slice(-4)?function(e,a,n){var t,s={NumberFmt:[]};for(t in me)s.NumberFmt[t]=me[t];s.CellXf=[],s.Fonts=[];var i=[],o=!1;return Mr(e,function(e,t,r){switch(r){case 44:s.NumberFmt[e[0]]=e[1],we(e[1],e[0]);break;case 43:s.Fonts.push(e),null!=e.color.theme&&a&&a.themeElements&&a.themeElements.clrScheme&&(e.color.rgb=eo(a.themeElements.clrScheme[e.color.theme].rgb,e.color.tint||0));break;case 1025:case 45:case 46:break;case 47:617==i[i.length-1]&&s.CellXf.push(e);break;case 48:case 507:case 572:case 475:break;case 1171:case 2102:case 1130:case 512:case 2095:case 3072:break;case 35:o=!0;break;case 36:o=!1;break;case 37:i.push(r),o=!0;break;case 38:i.pop(),o=!1;break;default:if(0<t.T)i.push(r);else if(t.T<0)i.pop();else if(!o||n.WTF&&37!=i[i.length-1])throw new Error("Unexpected record 0x"+r.toString(16))}}),s}:So)(e,r,a)}function cf(e,t,r){return".bin"===t.slice(-4)?(a=r,s=!(n=[]),Mr(e,function(e,t,r){switch(r){case 159:n.Count=e[0],n.Unique=e[1];break;case 19:n.push(e);break;case 160:return 1;case 35:s=!0;break;case 36:s=!1;break;default:if(t.T,!s||a.WTF)throw new Error("Unexpected record 0x"+r.toString(16))}}),n):function(e,t){var r=[],a="";if(!e)return r;if(e=e.match(Ci)){a=e[2].replace(Ri,"").split(Oi);for(var n=0;n!=a.length;++n){var s=Ai(a[n].trim(),t);null!=s&&(r[r.length]=s)}e=dt(e[1]),r.Count=e.count,r.Unique=e.uniqueCount}return r}(e,r);var a,n,s}function lf(e,t,r){return".bin"===t.slice(-4)?(a=r,n=[],s=[],o=!(i={}),Mr(e,function(e,t,r){switch(r){case 632:s.push(e);break;case 635:i=e;break;case 637:i.t=e.t,i.h=e.h,i.r=e.r;break;case 636:if(i.author=s[i.iauthor],delete i.iauthor,a.sheetRows&&i.rfx&&a.sheetRows<=i.rfx.r)break;i.t||(i.t=""),delete i.rfx,n.push(i);break;case 3072:break;case 35:o=!0;break;case 36:o=!1;break;case 37:case 38:break;default:if(!t.T&&(!o||a.WTF))throw new Error("Unexpected record 0x"+r.toString(16))}}),n):function(e,a){if(e.match(/<(?:\w+:)?comments *\/>/))return[];var n=[],s=[],t=e.match(/<(?:\w+:)?authors>([\s\S]*)<\/(?:\w+:)?authors>/);return t&&t[1]&&t[1].split(/<\/\w*:?author>/).forEach(function(e){""===e||""===e.trim()||(e=e.match(/<(?:\w+:)?author[^>]*>(.*)/))&&n.push(e[1])}),(e=e.match(/<(?:\w+:)?commentList>([\s\S]*)<\/(?:\w+:)?commentList>/))&&e[1]&&e[1].split(/<\/\w*:?comment>/).forEach(function(e){var t,r;""===e||""===e.trim()||(t=e.match(/<(?:\w+:)?comment[^>]*>/))&&(t={author:(r=dt(t[0])).authorId&&n[r.authorId]||"sheetjsghost",ref:r.ref,guid:r.guid},r=Yr(r.ref),a.sheetRows&&a.sheetRows<=r.r||(e=!!(e=e.match(/<(?:\w+:)?text>([\s\S]*)<\/(?:\w+:)?text>/))&&!!e[1]&&Ai(e[1])||{r:"",t:"",h:""},t.r=e.r,"<t></t>"==e.r&&(e.t=e.h=""),t.t=(e.t||"").replace(/\r\n/g,"\n").replace(/\r/g,"\n"),a.cellHTML&&(t.h=e.h),s.push(t)))}),s}(e,r);var a,n,s,i,o}function ff(e,t){return".bin"===t.slice(-4)?(a=[],Mr(e,function(e,t,r){if(63===r)a.push(e);else if(!t.T)throw new Error("Unexpected record 0x"+r.toString(16))}),a):function(e){var r=[];if(!e)return r;var a=1;return(e.match(ft)||[]).forEach(function(e){var t=dt(e);switch(t[0]){case"<?xml":break;case"<calcChain":case"<calcChain>":case"</calcChain>":break;case"<c":delete t[0],t.i?a=t.i:t.i=a,r.push(t)}}),r}(e);var a}function hf(e,t,r,a){if(".bin"===r.slice(-4))return function(e,t){if(!e)return e;var a=t||{},n=!1;Mr(e,function(e,t,r){switch(0,r){case 359:case 363:case 364:case 366:case 367:case 368:case 369:case 370:case 371:case 472:case 577:case 578:case 579:case 580:case 581:case 582:case 583:case 584:case 585:case 586:case 587:break;case 35:n=!0;break;case 36:n=!1;break;default:if(!t.T&&(!n||a.WTF))throw new Error("Unexpected record 0x"+r.toString(16))}},a)}(e,a)}function uf(e,t,r){return".bin"===t.slice(-4)?(a={Types:[],Cell:[],Value:[]},n=r||{},i=!(s=[]),o=2,Mr(e,function(e,t,r){switch(r){case 335:a.Types.push({name:e.name});break;case 51:e.forEach(function(e){1==o?a.Cell.push({type:a.Types[e[0]-1].name,index:e[1]}):0==o&&a.Value.push({type:a.Types[e[0]-1].name,index:e[1]})});break;case 337:o=e?1:0;break;case 338:o=2;break;case 35:s.push(r),i=!0;break;case 36:s.pop(),i=!1;break;default:if(!t.T&&(!i||n.WTF&&35!=s[s.length-1]))throw new Error("Unexpected record 0x"+r.toString(16))}}),a):function(e,a){var n={Types:[],Cell:[],Value:[]};if(!e)return n;var s,i=!1,o=2;return e.replace(ft,function(e){var t=dt(e);switch(pt(t[0])){case"<?xml":break;case"<metadata":case"</metadata>":break;case"<metadataTypes":case"</metadataTypes>":break;case"<metadataType":n.Types.push({name:t.name});break;case"</metadataType>":break;case"<futureMetadata":for(var r=0;r<n.Types.length;++r)n.Types[r].name==t.name&&(s=n.Types[r]);break;case"</futureMetadata>":case"<bk>":case"</bk>":break;case"<rc":1==o?n.Cell.push({type:n.Types[t.t-1].name,index:+t.v}):0==o&&n.Value.push({type:n.Types[t.t-1].name,index:+t.v});break;case"</rc>":break;case"<cellMetadata":o=1;break;case"</cellMetadata>":o=2;break;case"<valueMetadata":o=0;break;case"</valueMetadata>":o=2;break;case"<extLst":case"<extLst>":case"</extLst>":case"<extLst/>":break;case"<ext":i=!0;break;case"</ext>":i=!1;break;case"<rvb":if(!s)break;s.offsets||(s.offsets=[]),s.offsets.push(+t.i);break;default:if(!i&&a.WTF)throw new Error("unrecognized "+t[0]+" in metadata")}return e}),n}(e,r);var a,n,s,i,o}var df,pf=/([\w:]+)=((?:")([^"]*)(?:")|(?:')([^']*)(?:'))/g,mf=/([\w:]+)=((?:")(?:[^"]*)(?:")|(?:')(?:[^']*)(?:'))/;function gf(e,t){var r=e.split(/\s+/),a=[];if(t||(a[0]=r[0]),1===r.length)return a;var n,s,i,o=e.match(pf);if(o)for(i=0;i!=o.length;++i)-1===(s=(n=o[i].match(mf))[1].indexOf(":"))?a[n[1]]=n[2].slice(1,n[2].length-1):a["xmlns:"===n[1].slice(0,6)?"xmlns"+n[1].slice(6):n[1].slice(s+1)]=n[2].slice(1,n[2].length-1);return a}function bf(e,t,r){if("z"!==e.t){if(!r||!1!==r.cellText)try{"e"===e.t?e.w=e.w||Wa[e.v]:"General"===t?"n"===e.t?(0|e.v)===e.v?e.w=e.v.toString(10):e.w=D(e.v):e.w=P(e.v):e.w=(a=t||"General",n=e.v,"General"===(a=df[a]||wt(a))?P(n):ve(a,n))}catch(e){if(r.WTF)throw e}var a,n;try{var s=df[t]||t||"General";r.cellNF&&(e.z=s),r.cellDates&&"n"==e.t&&q(s)&&((s=L(e.v))&&(e.t="d",e.v=new Date(s.y,s.m-1,s.d,s.H,s.M,s.S,s.u)))}catch(e){if(r.WTF)throw e}}}function vf(e,t){var r=t||{};Ee();var a,n=ne(Jt(e)),s=(n="binary"==r.type||"array"==r.type||"base64"==r.type?void 0!==re?re.utils.decode(65001,ae(n)):Mt(n):n).slice(0,1024).toLowerCase(),i=!1;if((1023&(s=s.replace(/".*?"/g,"")).indexOf(">"))>Math.min(1023&s.indexOf(","),1023&s.indexOf(";"))){var o=Ve(r);return o.type="string",Ks.to_workbook(n,o)}if(-1==s.indexOf("<?xml")&&["html","table","head","meta","script","style","div"].forEach(function(e){0<=s.indexOf("<"+e)&&(i=!0)}),i)return function(e,r){e=e.match(/<table[\s\S]*?>[\s\S]*?<\/table>/gi);if(!e||0==e.length)throw new Error("Invalid HTML: could not find <table>");if(1==e.length)return ta(Yf(e[0],r),r);var a=du();return e.forEach(function(e,t){pu(a,Yf(e,r),"Sheet"+(t+1))}),a}(n,r);df={"General Number":"General","General Date":me[22],"Long Date":"dddd, mmmm dd, yyyy","Medium Date":me[15],"Short Date":me[14],"Long Time":me[19],"Medium Time":me[18],"Short Time":me[20],Currency:'"$"#,##0.00_);[Red]\\("$"#,##0.00\\)',Fixed:me[2],Standard:me[4],Percent:me[10],Scientific:me[11],"Yes/No":'"Yes";"Yes";"No";@',"True/False":'"True";"True";"False";@',"On/Off":'"Yes";"Yes";"No";@'};var c,l=[];null!=oe&&null==r.dense&&(r.dense=oe);var f,h={},u=[],d=r.dense?[]:{},p="",m={},g={},b=gf('<Data ss:Type="String">'),v=0,w=0,T=0,E={s:{r:2e6,c:2e6},e:{r:0,c:0}},k={},y={},S="",_=0,x=[],A={},C={},R=0,O=[],I=[],N={},F=[],D=!1,P=[],L=[],M={},U=0,B=0,W={Sheets:[],WBProps:{date1904:!1}},H={};qt.lastIndex=0,n=n.replace(/<!--([\s\S]*?)-->/gm,"");for(var z,V,G,j,$="";a=qt.exec(n);)switch(a[3]=($=a[3]).toLowerCase()){case"data":if("data"==$){if("/"===a[1]){if((c=l.pop())[0]!==a[3])throw new Error("Bad state: "+c.join("|"))}else"/"!==a[0].charAt(a[0].length-2)&&l.push([a[3],!0]);break}if(l[l.length-1][1])break;"/"===a[1]?function(e,t,r,a,n,s,i,o,c,l){var f="General",h=a.StyleID,u={};l=l||{};var d=[],p=0;for(void 0===(h=void 0===h&&o?o.StyleID:h)&&i&&(h=i.StyleID);void 0!==s[h]&&(s[h].nf&&(f=s[h].nf),s[h].Interior&&d.push(s[h].Interior),s[h].Parent);)h=s[h].Parent;switch(r.Type){case"Boolean":a.t="b",a.v=Rt(e);break;case"String":a.t="s",a.r=At(wt(e)),a.v=-1<e.indexOf("<")?wt(t||e).replace(/<.*?>/g,""):a.r;break;case"DateTime":"Z"!=e.slice(-1)&&(e+="Z"),a.v=(He(e)-new Date(Date.UTC(1899,11,30)))/864e5,a.v!=a.v?a.v=wt(e):a.v<60&&(a.v=a.v-1),f&&"General"!=f||(f="yyyy-mm-dd");case"Number":void 0===a.v&&(a.v=+e),a.t||(a.t="n");break;case"Error":a.t="e",a.v=Ha[e],!1!==l.cellText&&(a.w=e);break;default:""==e&&""==t?a.t="z":(a.t="s",a.v=At(t||e))}if(bf(a,f,l),!1!==l.cellFormula)if(a.Formula){r=wt(a.Formula);61==r.charCodeAt(0)&&(r=r.slice(1)),a.f=oc(r,n),delete a.Formula,"RC"==a.ArrayRange?a.F=oc("RC:RC",n):a.ArrayRange&&(a.F=oc(a.ArrayRange,n),c.push([Zr(a.F),a.F]))}else for(p=0;p<c.length;++p)n.r>=c[p][0].s.r&&n.r<=c[p][0].e.r&&n.c>=c[p][0].s.c&&n.c<=c[p][0].e.c&&(a.F=c[p][1]);l.cellStyles&&(d.forEach(function(e){!u.patternType&&e.patternType&&(u.patternType=e.patternType)}),a.s=u),void 0!==a.StyleID&&(a.ixfe=a.StyleID)}(n.slice(v,a.index),S,b,"comment"==l[l.length-1][0]?N:m,{c:w,r:T},k,F[w],g,P,r):(S="",b=gf(a[0]),v=a.index+a[0].length);break;case"cell":if("/"===a[1])if(0<I.length&&(m.c=I),(!r.sheetRows||r.sheetRows>T)&&void 0!==m.v&&(r.dense?(d[T]||(d[T]=[]),d[T][w]=m):d[Xr(w)+jr(T)]=m),m.HRef&&(m.l={Target:wt(m.HRef)},m.HRefScreenTip&&(m.l.Tooltip=m.HRefScreenTip),delete m.HRef,delete m.HRefScreenTip),(m.MergeAcross||m.MergeDown)&&(U=w+(0|parseInt(m.MergeAcross,10)),B=T+(0|parseInt(m.MergeDown,10)),x.push({s:{c:w,r:T},e:{c:U,r:B}})),r.sheetStubs)if(m.MergeAcross||m.MergeDown){for(var X=w;X<=U;++X)for(var Y=T;Y<=B;++Y)(w<X||T<Y)&&(r.dense?(d[Y]||(d[Y]=[]),d[Y][X]={t:"z"}):d[Xr(X)+jr(Y)]={t:"z"});w=U+1}else++w;else m.MergeAcross?w=U+1:++w;else(w=(m=function(e){var t={};if(1===e.split(/\s+/).length)return t;var r,a,n,s=e.match(pf);if(s)for(n=0;n!=s.length;++n)-1===(a=(r=s[n].match(mf))[1].indexOf(":"))?t[r[1]]=r[2].slice(1,r[2].length-1):t["xmlns:"===r[1].slice(0,6)?"xmlns"+r[1].slice(6):r[1].slice(a+1)]=r[2].slice(1,r[2].length-1);return t}(a[0])).Index?+m.Index-1:w)<E.s.c&&(E.s.c=w),w>E.e.c&&(E.e.c=w),"/>"===a[0].slice(-2)&&++w,I=[];break;case"row":"/"===a[1]||"/>"===a[0].slice(-2)?(T<E.s.r&&(E.s.r=T),T>E.e.r&&(E.e.r=T),"/>"===a[0].slice(-2)&&(g=gf(a[0])).Index&&(T=+g.Index-1),w=0,++T):((g=gf(a[0])).Index&&(T=+g.Index-1),M={},"0"!=g.AutoFitHeight&&!g.Height||(M.hpx=parseInt(g.Height,10),M.hpt=uo(M.hpx),L[T]=M),"1"==g.Hidden&&(M.hidden=!0,L[T]=M));break;case"worksheet":if("/"===a[1]){if((c=l.pop())[0]!==a[3])throw new Error("Bad state: "+c.join("|"));u.push(p),E.s.r<=E.e.r&&E.s.c<=E.e.c&&(d["!ref"]=qr(E),r.sheetRows&&r.sheetRows<=E.e.r&&(d["!fullref"]=d["!ref"],E.e.r=r.sheetRows-1,d["!ref"]=qr(E))),x.length&&(d["!merges"]=x),0<F.length&&(d["!cols"]=F),0<L.length&&(d["!rows"]=L),h[p]=d}else E={s:{r:2e6,c:2e6},e:{r:0,c:0}},T=w=0,l.push([a[3],!1]),c=gf(a[0]),p=wt(c.Name),d=r.dense?[]:{},x=[],P=[],L=[],H={name:p,Hidden:0},W.Sheets.push(H);break;case"table":if("/"===a[1]){if((c=l.pop())[0]!==a[3])throw new Error("Bad state: "+c.join("|"))}else{if("/>"==a[0].slice(-2))break;l.push([a[3],!1]),D=!(F=[])}break;case"style":"/"===a[1]?(V=k,G=y,(j=r).cellStyles&&(!G.Interior||(j=G.Interior).Pattern&&(j.patternType=mo[j.Pattern]||j.Pattern)),V[G.ID]=G):y=gf(a[0]);break;case"numberformat":y.nf=wt(gf(a[0]).Format||"General"),df[y.nf]&&(y.nf=df[y.nf]);for(var K=0;392!=K&&me[K]!=y.nf;++K);if(392==K)for(K=57;392!=K;++K)if(null==me[K]){we(y.nf,K);break}break;case"column":if("table"!==l[l.length-1][0])break;if((f=gf(a[0])).Hidden&&(f.hidden=!0,delete f.Hidden),f.Width&&(f.wpx=parseInt(f.Width,10)),!D&&10<f.wpx){D=!0,no=to;for(var J=0;J<F.length;++J)F[J]&&fo(F[J])}D&&fo(f),F[f.Index-1||F.length]=f;for(var q=0;q<+f.Span;++q)F[F.length]=Ve(f);break;case"namedrange":if("/"===a[1])break;W.Names||(W.Names=[]);var Z=dt(a[0]),Q={Name:Z.Name,Ref:oc(Z.RefersTo.slice(1),{r:0,c:0})};0<W.Sheets.length&&(Q.Sheet=W.Sheets.length-1),W.Names.push(Q);break;case"namedcell":case"b":case"i":case"u":case"s":case"em":case"h2":case"h3":case"sub":case"sup":case"span":case"alignment":case"borders":case"border":break;case"font":if("/>"===a[0].slice(-2))break;"/"===a[1]?S+=n.slice(_,a.index):_=a.index+a[0].length;break;case"interior":if(!r.cellStyles)break;y.Interior=gf(a[0]);break;case"protection":break;case"author":case"title":case"description":case"created":case"keywords":case"subject":case"category":case"company":case"lastauthor":case"lastsaved":case"lastprinted":case"version":case"revision":case"totaltime":case"hyperlinkbase":case"manager":case"contentstatus":case"identifier":case"language":case"appname":if("/>"===a[0].slice(-2))break;"/"===a[1]?(G=A,Z=$,Q=n.slice(R,a.index),G[Z=(un=un||Ie(dn))[Z]||Z]=Q):R=a.index+a[0].length;break;case"paragraphs":break;case"styles":case"workbook":if("/"===a[1]){if((c=l.pop())[0]!==a[3])throw new Error("Bad state: "+c.join("|"))}else l.push([a[3],!1]);break;case"comment":if("/"===a[1]){if((c=l.pop())[0]!==a[3])throw new Error("Bad state: "+c.join("|"));(z=N).t=z.v||"",z.t=z.t.replace(/\r\n/g,"\n").replace(/\r/g,"\n"),z.v=z.w=z.ixfe=void 0,I.push(N)}else l.push([a[3],!1]),N={a:(c=gf(a[0])).Author};break;case"autofilter":if("/"===a[1]){if((c=l.pop())[0]!==a[3])throw new Error("Bad state: "+c.join("|"))}else"/"!==a[0].charAt(a[0].length-2)&&(z=gf(a[0]),d["!autofilter"]={ref:oc(z.Range).replace(/\$/g,"")},l.push([a[3],!0]));break;case"name":break;case"datavalidation":if("/"===a[1]){if((c=l.pop())[0]!==a[3])throw new Error("Bad state: "+c.join("|"))}else"/"!==a[0].charAt(a[0].length-2)&&l.push([a[3],!0]);break;case"pixelsperinch":break;case"componentoptions":case"documentproperties":case"customdocumentproperties":case"officedocumentsettings":case"pivottable":case"pivotcache":case"names":case"mapinfo":case"pagebreaks":case"querytable":case"sorting":case"schema":case"conditionalformatting":case"smarttagtype":case"smarttags":case"excelworkbook":case"workbookoptions":case"worksheetoptions":if("/"===a[1]){if((c=l.pop())[0]!==a[3])throw new Error("Bad state: "+c.join("|"))}else"/"!==a[0].charAt(a[0].length-2)&&l.push([a[3],!0]);break;case"null":break;default:if(0==l.length&&"document"==a[3])return ih(n,r);if(0==l.length&&"uof"==a[3])return ih(n,r);var ee=!0;switch(l[l.length-1][0]){case"officedocumentsettings":switch(a[3]){case"allowpng":case"removepersonalinformation":case"downloadcomponents":case"locationofcomponents":case"colors":case"color":case"index":case"rgb":case"targetscreensize":case"readonlyrecommended":break;default:ee=!1}break;case"componentoptions":switch(a[3]){case"toolbar":case"hideofficelogo":case"spreadsheetautofit":case"label":case"caption":case"maxheight":case"maxwidth":case"nextsheetnumber":break;default:ee=!1}break;case"excelworkbook":switch(a[3]){case"date1904":W.WBProps.date1904=!0;break;case"windowheight":case"windowwidth":case"windowtopx":case"windowtopy":case"tabratio":case"protectstructure":case"protectwindow":case"protectwindows":case"activesheet":case"displayinknotes":case"firstvisiblesheet":case"supbook":case"sheetname":case"sheetindex":case"sheetindexfirst":case"sheetindexlast":case"dll":case"acceptlabelsinformulas":case"donotsavelinkvalues":case"iteration":case"maxiterations":case"maxchange":case"path":case"xct":case"count":case"selectedsheets":case"calculation":case"uncalced":case"startupprompt":case"crn":case"externname":case"formula":case"colfirst":case"collast":case"wantadvise":case"boolean":case"error":case"text":case"ole":case"noautorecover":case"publishobjects":case"donotcalculatebeforesave":case"number":case"refmoder1c1":case"embedsavesmarttags":break;default:ee=!1}break;case"workbookoptions":switch(a[3]){case"owcversion":case"height":case"width":break;default:ee=!1}break;case"worksheetoptions":switch(a[3]){case"visible":if("/>"!==a[0].slice(-2))if("/"===a[1])switch(n.slice(R,a.index)){case"SheetHidden":H.Hidden=1;break;case"SheetVeryHidden":H.Hidden=2}else R=a.index+a[0].length;break;case"header":d["!margins"]||Qc(d["!margins"]={},"xlml"),isNaN(+dt(a[0]).Margin)||(d["!margins"].header=+dt(a[0]).Margin);break;case"footer":d["!margins"]||Qc(d["!margins"]={},"xlml"),isNaN(+dt(a[0]).Margin)||(d["!margins"].footer=+dt(a[0]).Margin);break;case"pagemargins":var te=dt(a[0]);d["!margins"]||Qc(d["!margins"]={},"xlml"),isNaN(+te.Top)||(d["!margins"].top=+te.Top),isNaN(+te.Left)||(d["!margins"].left=+te.Left),isNaN(+te.Right)||(d["!margins"].right=+te.Right),isNaN(+te.Bottom)||(d["!margins"].bottom=+te.Bottom);break;case"displayrighttoleft":W.Views||(W.Views=[]),W.Views[0]||(W.Views[0]={}),W.Views[0].RTL=!0;break;case"freezepanes":case"frozennosplit":break;case"splithorizontal":case"splitvertical":case"donotdisplaygridlines":case"activerow":case"activecol":case"toprowbottompane":case"leftcolumnrightpane":case"unsynced":case"print":case"printerrors":case"panes":case"scale":case"pane":case"number":case"layout":case"pagesetup":case"selected":case"protectobjects":case"enableselection":case"protectscenarios":case"validprinterinfo":case"horizontalresolution":case"verticalresolution":case"numberofcopies":case"activepane":case"toprowvisible":case"leftcolumnvisible":case"fittopage":case"rangeselection":case"papersizeindex":case"pagelayoutzoom":case"pagebreakzoom":case"filteron":case"fitwidth":case"fitheight":case"commentslayout":case"zoom":case"lefttoright":case"gridlines":case"allowsort":case"allowfilter":case"allowinsertrows":case"allowdeleterows":case"allowinsertcols":case"allowdeletecols":case"allowinserthyperlinks":case"allowformatcells":case"allowsizecols":case"allowsizerows":break;case"nosummaryrowsbelowdetail":d["!outline"]||(d["!outline"]={}),d["!outline"].above=!0;break;case"tabcolorindex":case"donotdisplayheadings":case"showpagelayoutzoom":break;case"nosummarycolumnsrightdetail":d["!outline"]||(d["!outline"]={}),d["!outline"].left=!0;break;case"blackandwhite":case"donotdisplayzeros":case"displaypagebreak":case"rowcolheadings":case"donotdisplayoutline":case"noorientation":case"allowusepivottables":case"zeroheight":case"viewablerange":case"selection":case"protectcontents":break;default:ee=!1}break;case"pivottable":case"pivotcache":switch(a[3]){case"immediateitemsondrop":case"showpagemultipleitemlabel":case"compactrowindent":case"location":case"pivotfield":case"orientation":case"layoutform":case"layoutsubtotallocation":case"layoutcompactrow":case"position":case"pivotitem":case"datatype":case"datafield":case"sourcename":case"parentfield":case"ptlineitems":case"ptlineitem":case"countofsameitems":case"item":case"itemtype":case"ptsource":case"cacheindex":case"consolidationreference":case"filename":case"reference":case"nocolumngrand":case"norowgrand":case"blanklineafteritems":case"hidden":case"subtotal":case"basefield":case"mapchilditems":case"function":case"refreshonfileopen":case"printsettitles":case"mergelabels":case"defaultversion":case"refreshname":case"refreshdate":case"refreshdatecopy":case"versionlastrefresh":case"versionlastupdate":case"versionupdateablemin":case"versionrefreshablemin":case"calculation":break;default:ee=!1}break;case"pagebreaks":switch(a[3]){case"colbreaks":case"colbreak":case"rowbreaks":case"rowbreak":case"colstart":case"colend":case"rowend":break;default:ee=!1}break;case"autofilter":switch(a[3]){case"autofiltercolumn":case"autofiltercondition":case"autofilterand":case"autofilteror":break;default:ee=!1}break;case"querytable":switch(a[3]){case"id":case"autoformatfont":case"autoformatpattern":case"querysource":case"querytype":case"enableredirections":case"refreshedinxl9":case"urlstring":case"htmltables":case"connection":case"commandtext":case"refreshinfo":case"notitles":case"nextid":case"columninfo":case"overwritecells":case"donotpromptforfile":case"textwizardsettings":case"source":case"number":case"decimal":case"thousandseparator":case"trailingminusnumbers":case"formatsettings":case"fieldtype":case"delimiters":case"tab":case"comma":case"autoformatname":case"versionlastedit":case"versionlastrefresh":break;default:ee=!1}break;case"datavalidation":switch(a[3]){case"range":case"type":case"min":case"max":case"sort":case"descending":case"order":case"casesensitive":case"value":case"errorstyle":case"errormessage":case"errortitle":case"inputmessage":case"inputtitle":case"combohide":case"inputhide":case"condition":case"qualifier":case"useblank":case"value1":case"value2":case"format":case"cellrangelist":break;default:ee=!1}break;case"sorting":case"conditionalformatting":switch(a[3]){case"range":case"type":case"min":case"max":case"sort":case"descending":case"order":case"casesensitive":case"value":case"errorstyle":case"errormessage":case"errortitle":case"cellrangelist":case"inputmessage":case"inputtitle":case"combohide":case"inputhide":case"condition":case"qualifier":case"useblank":case"value1":case"value2":case"format":break;default:ee=!1}break;case"mapinfo":case"schema":case"data":switch(a[3]){case"map":case"entry":case"range":case"xpath":case"field":case"xsdtype":case"filteron":case"aggregate":case"elementtype":case"attributetype":break;case"schema":case"element":case"complextype":case"datatype":case"all":case"attribute":case"extends":case"row":break;default:ee=!1}break;case"smarttags":break;default:ee=!1}if(ee)break;if(a[3].match(/!\[CDATA/))break;if(!l[l.length-1][1])throw"Unrecognized tag: "+a[3]+"|"+l.join("|");if("customdocumentproperties"===l[l.length-1][0]){if("/>"===a[0].slice(-2))break;"/"===a[1]?function(e,t,r,a){var n=a;switch((r[0].match(/dt:dt="([\w.]+)"/)||["",""])[1]){case"boolean":n=Rt(a);break;case"i2":case"int":n=parseInt(a,10);break;case"r4":case"float":n=parseFloat(a);break;case"date":case"dateTime.tz":n=He(a);break;case"i8":case"string":case"fixed":case"uuid":case"bin.base64":break;default:throw new Error("bad custprop:"+r[0])}e[wt(t)]=n}(C,$,O,n.slice(R,a.index)):R=(O=a).index+a[0].length;break}if(r.WTF)throw"Unrecognized tag: "+a[3]+"|"+l.join("|")}o={};return r.bookSheets||r.bookProps||(o.Sheets=h),o.SheetNames=u,o.Workbook=W,o.SSF=Ve(me),o.Props=A,o.Custprops=C,o}function wf(e,t){switch(Mh(t=t||{}),t.type||"base64"){case"base64":return vf(te(e),t);case"binary":case"buffer":case"file":return vf(e,t);case"array":return vf(i(e),t)}}function Tf(e,t){var r,a,n,s,i,o,c,l=[];return e.Props&&l.push((r=e.Props,a=t,n=[],Re(dn).map(function(e){for(var t=0;t<en.length;++t)if(en[t][1]==e)return en[t];for(t=0;t<sn.length;++t)if(sn[t][1]==e)return sn[t];throw e}).forEach(function(e){var t;null!=r[e[1]]&&(t=(a&&a.Props&&null!=a.Props[e[1]]?a.Props:r)[e[1]],"number"==typeof(t="date"===e[2]?new Date(t).toISOString().replace(/\.\d*Z/,"Z"):t)?t=String(t):!0===t||!1===t?t=t?"1":"0":t instanceof Date&&(t=new Date(t).toISOString().replace(/\.\d*Z/,"")),n.push($t(dn[e[1]]||e[1],t)))}),Yt("DocumentProperties",n.join(""),{xmlns:er.o}))),e.Custprops&&l.push((s=e.Props,i=e.Custprops,o=["Worksheets","SheetNames"],e="CustomDocumentProperties",c=[],s&&Re(s).forEach(function(e){if(Object.prototype.hasOwnProperty.call(s,e)){for(var t=0;t<en.length;++t)if(e==en[t][1])return;for(t=0;t<sn.length;++t)if(e==sn[t][1])return;for(t=0;t<o.length;++t)if(e==o[t])return;var r="string",a="number"==typeof(a=s[e])?(r="float",String(a)):!0===a||!1===a?(r="boolean",a?"1":"0"):String(a);c.push(Yt(yt(e),a,{"dt:dt":r}))}}),i&&Re(i).forEach(function(e){var t,r;Object.prototype.hasOwnProperty.call(i,e)&&(s&&Object.prototype.hasOwnProperty.call(s,e)||(t="string",r="number"==typeof(r=i[e])?(t="float",String(r)):!0===r||!1===r?(t="boolean",r?"1":"0"):r instanceof Date?(t="dateTime.tz",r.toISOString()):String(r),c.push(Yt(yt(e),r,{"dt:dt":t}))))}),"<"+e+' xmlns="'+er.o+'">'+c.join("")+"</"+e+">")),l.join("")}function Ef(e){return Yt("NamedRange",null,{"ss:Name":e.Name,"ss:RefersTo":"="+fc(e.Ref,{r:0,c:0})})}function kf(e,t,r,a,n,s,i){if(!e||null==e.v&&null==e.f)return"";var o={};if(e.f&&(o["ss:Formula"]="="+kt(fc(e.f,i))),e.F&&e.F.slice(0,t.length)==t&&(t=Yr(e.F.slice(t.length+1)),o["ss:ArrayRange"]="RC:R"+(t.r==i.r?"":"["+(t.r-i.r)+"]")+"C"+(t.c==i.c?"":"["+(t.c-i.c)+"]")),e.l&&e.l.Target&&(o["ss:HRef"]=kt(e.l.Target),e.l.Tooltip&&(o["x:HRefScreenTip"]=kt(e.l.Tooltip))),r["!merges"])for(var c=r["!merges"],l=0;l!=c.length;++l)c[l].s.c==i.c&&c[l].s.r==i.r&&(c[l].e.c>c[l].s.c&&(o["ss:MergeAcross"]=c[l].e.c-c[l].s.c),c[l].e.r>c[l].s.r&&(o["ss:MergeDown"]=c[l].e.r-c[l].s.r));var f="",h="";switch(e.t){case"z":if(!a.sheetStubs)return"";break;case"n":f="Number",h=String(e.v);break;case"b":f="Boolean",h=e.v?"1":"0";break;case"e":f="Error",h=Wa[e.v];break;case"d":f="DateTime",h=new Date(e.v).toISOString(),null==e.z&&(e.z=e.z||me[14]);break;case"s":f="String",h=((e.v||"")+"").replace(Tt,function(e){return vt[e]}).replace(St,function(e){return"&#x"+e.charCodeAt(0).toString(16).toUpperCase()+";"})}r=el(a.cellXfs,e,a);o["ss:StyleID"]="s"+(21+r),o["ss:Index"]=i.c+1;r=null!=e.v?h:"",r="z"==e.t?"":'<Data ss:Type="'+f+'">'+r+"</Data>";return 0<(e.c||[]).length&&(r+=e.c.map(function(e){var t=Yt("ss:Data",(e.t||"").replace(/(\r\n|[\r\n])/g,"&#10;"),{xmlns:"http://www.w3.org/TR/REC-html40"});return Yt("Comment",t,{"ss:Author":e.a})}).join("")),Yt("Cell",r,o)}function yf(e,t){if(!e["!ref"])return"";var r=Zr(e["!ref"]),a=e["!merges"]||[],n=0,s=[];e["!cols"]&&e["!cols"].forEach(function(e,t){fo(e);var r=!!e.width,a=Zc(t,e),t={"ss:Index":t+1};r&&(t["ss:Width"]=so(a.width)),e.hidden&&(t["ss:Hidden"]="1"),s.push(Yt("Column",null,t))});for(var i,o,c=Array.isArray(e),l=r.s.r;l<=r.e.r;++l){for(var f=[(i=l,o=(e["!rows"]||[])[l],i='<Row ss:Index="'+(i+1)+'"',o&&(o.hpt&&!o.hpx&&(o.hpx=po(o.hpt)),o.hpx&&(i+=' ss:AutoFitHeight="0" ss:Height="'+o.hpx+'"'),o.hidden&&(i+=' ss:Hidden="1"')),i+">")],h=r.s.c;h<=r.e.c;++h){for(var u,d,p,m=!1,n=0;n!=a.length;++n)if(!(a[n].s.c>h||a[n].s.r>l||a[n].e.c<h||a[n].e.r<l)){a[n].s.c==h&&a[n].s.r==l||(m=!0);break}m||(d=Kr(u={r:l,c:h}),p=c?(e[l]||[])[h]:e[d],f.push(kf(p,d,e,t,0,0,u)))}f.push("</Row>"),2<f.length&&s.push(f.join(""))}return s.join("")}function Sf(e,t,r){var a=[],n=r.SheetNames[e],s=r.Sheets[n],n=s?function(e,t,r){if(!e)return"";if(!((r||{}).Workbook||{}).Names)return"";for(var a=r.Workbook.Names,n=[],s=0;s<a.length;++s){var i=a[s];i.Sheet==t&&(i.Name.match(/^_xlfn\./)||n.push(Ef(i)))}return n.join("")}(s,e,r):"";return 0<n.length&&a.push("<Names>"+n+"</Names>"),0<(n=s?yf(s,t):"").length&&a.push("<Table>"+n+"</Table>"),a.push(function(t,e,r){if(!t)return"";var a=[];if(t["!margins"]&&(a.push("<PageSetup>"),t["!margins"].header&&a.push(Yt("Header",null,{"x:Margin":t["!margins"].header})),t["!margins"].footer&&a.push(Yt("Footer",null,{"x:Margin":t["!margins"].footer})),a.push(Yt("PageMargins",null,{"x:Bottom":t["!margins"].bottom||"0.75","x:Left":t["!margins"].left||"0.7","x:Right":t["!margins"].right||"0.7","x:Top":t["!margins"].top||"0.75"})),a.push("</PageSetup>")),r&&r.Workbook&&r.Workbook.Sheets&&r.Workbook.Sheets[e])if(r.Workbook.Sheets[e].Hidden)a.push(Yt("Visible",1==r.Workbook.Sheets[e].Hidden?"SheetHidden":"SheetVeryHidden",{}));else{for(var n=0;n<e&&(!r.Workbook.Sheets[n]||r.Workbook.Sheets[n].Hidden);++n);n==e&&a.push("<Selected/>")}return((((r||{}).Workbook||{}).Views||[])[0]||{}).RTL&&a.push("<DisplayRightToLeft/>"),t["!protect"]&&(a.push($t("ProtectContents","True")),t["!protect"].objects&&a.push($t("ProtectObjects","True")),t["!protect"].scenarios&&a.push($t("ProtectScenarios","True")),null==t["!protect"].selectLockedCells||t["!protect"].selectLockedCells?null==t["!protect"].selectUnlockedCells||t["!protect"].selectUnlockedCells||a.push($t("EnableSelection","UnlockedCells")):a.push($t("EnableSelection","NoSelection")),[["formatCells","AllowFormatCells"],["formatColumns","AllowSizeCols"],["formatRows","AllowSizeRows"],["insertColumns","AllowInsertCols"],["insertRows","AllowInsertRows"],["insertHyperlinks","AllowInsertHyperlinks"],["deleteColumns","AllowDeleteCols"],["deleteRows","AllowDeleteRows"],["sort","AllowSort"],["autoFilter","AllowFilter"],["pivotTables","AllowUsePivotTables"]].forEach(function(e){t["!protect"][e[0]]&&a.push("<"+e[1]+"/>")})),0==a.length?"":Yt("WorksheetOptions",a.join(""),{xmlns:er.x})}(s,e,r)),a.join("")}function _f(e,t){t=t||{},e.SSF||(e.SSF=Ve(me)),e.SSF&&(Ee(),Te(e.SSF),t.revssf=Ne(e.SSF),t.revssf[e.SSF[65535]]=0,t.ssf=e.SSF,t.cellXfs=[],el(t.cellXfs,{},{revssf:{General:0}}));var r=[];r.push(Tf(e,t)),r.push(""),r.push(""),r.push("");for(var a,n=0;n<e.SheetNames.length;++n)r.push(Yt("Worksheet",Sf(n,t,e),{"ss:Name":kt(e.SheetNames[n])}));return r[2]=(a=['<Style ss:ID="Default" ss:Name="Normal"><NumberFormat/></Style>'],t.cellXfs.forEach(function(e,t){var r=[];r.push(Yt("NumberFormat",null,{"ss:Format":kt(me[e.numFmtId])}));t={"ss:ID":"s"+(21+t)};a.push(Yt("Style",r.join(""),t))}),Yt("Styles",a.join(""))),r[3]=function(e){if(!((e||{}).Workbook||{}).Names)return"";for(var t=e.Workbook.Names,r=[],a=0;a<t.length;++a){var n=t[a];null==n.Sheet&&(n.Name.match(/^_xlfn\./)||r.push(Ef(n)))}return Yt("Names",r.join(""))}(e),ot+Yt("Workbook",r.join(""),{xmlns:er.ss,"xmlns:o":er.o,"xmlns:x":er.x,"xmlns:ss":er.ss,"xmlns:dt":er.dt,"xmlns:html":er.html})}function xf(e){var t={},r=e.content;if(r.l=28,t.AnsiUserType=r.read_shift(0,"lpstr-ansi"),t.AnsiClipboardFormat=Ra(r,1),r.length-r.l<=4)return t;e=r.read_shift(4);return 0==e||40<e?t:(r.l-=4,t.Reserved1=r.read_shift(0,"lpstr-ansi"),r.length-r.l<=4||1907505652!==(e=r.read_shift(4))?t:(t.UnicodeClipboardFormat=Ra(r,2),0==(e=r.read_shift(4))||40<e?t:(r.l-=4,void(t.Reserved2=r.read_shift(0,"lpwstr")))))}var Af=[60,1084,2066,2165,2175];function Cf(e,t,r){if("z"!==e.t&&e.XF){var a,n=0;try{n=e.z||e.XF.numFmtId||0,t.cellNF&&(e.z=me[n])}catch(e){if(t.WTF)throw e}if(!t||!1!==t.cellText)try{"e"===e.t?e.w=e.w||Wa[e.v]:0===n||"General"==n?"n"===e.t?(0|e.v)===e.v?e.w=e.v.toString(10):e.w=D(e.v):e.w=P(e.v):e.w=ve(n,e.v,{date1904:!!r,dateNF:t&&t.dateNF})}catch(e){if(t.WTF)throw e}t.cellDates&&n&&"n"==e.t&&q(me[n]||String(n))&&((a=L(e.v))&&(e.t="d",e.v=new Date(a.y,a.m-1,a.d,a.H,a.M,a.S,a.u)))}}function Rf(e,t,r){return{v:e,ixfe:t,t:r}}function Of(e,t){var r={opts:{}},a={};null!=oe&&null==t.dense&&(t.dense=oe);function o(e){return!(e<8)&&e<64&&k[e-8]||Ba[e]}function n(e,t,r){if(!(1<D||r.sheetRows&&e.r>=r.sheetRows)){var a,n,s;if(r.cellStyles&&t.XF&&t.XF.data&&(n=r,(s=(a=t).XF.data)&&s.patternType&&n&&n.cellStyles&&(a.s={},a.s.patternType=s.patternType,(n=Qi(o(s.icvFore)))&&(a.s.fgColor={rgb:n}),(n=Qi(o(s.icvBack)))&&(a.s.bgColor={rgb:n}))),delete t.ixfe,delete t.XF,v=Kr(c=e),d&&d.s&&d.e||(d={s:{r:0,c:0},e:{r:0,c:0}}),e.r<d.s.r&&(d.s.r=e.r),e.c<d.s.c&&(d.s.c=e.c),e.r+1>d.e.r&&(d.e.r=e.r+1),e.c+1>d.e.c&&(d.e.c=e.c+1),r.cellFormula&&t.f)for(var i=0;i<T.length;++i)if(!(T[i][0].s.c>e.c||T[i][0].s.r>e.r||T[i][0].e.c<e.c||T[i][0].e.r<e.r)){t.F=qr(T[i][0]),T[i][0].s.c==e.c&&T[i][0].s.r==e.r||delete t.f,t.f&&(t.f=""+Pc(T[i][1],0,e,I,_));break}r.dense?(h[e.r]||(h[e.r]=[]),h[e.r][e.c]=t):h[v]=t}}var c,s,i,l,f,h=t.dense?[]:{},u={},d={},p=null,m=[],g="",b={},v="",w={},T=[],E=[],k=[],y={Sheets:[],WBProps:{date1904:!1},Views:[{}]},S={},_={enc:!1,sbcch:0,snames:[],sharedf:w,arrayf:T,rrtabid:[],lastuser:"",biff:8,codepage:0,winlocked:0,cellStyles:!!t&&!!t.cellStyles,WTF:!!t&&!!t.wtf};t.password&&(_.password=t.password);var x=[],A=[],C=[],R=[],O=!1,I=[];I.SheetNames=_.snames,I.sharedf=_.sharedf,I.arrayf=_.arrayf,I.names=[],I.XTI=[];var N,F=0,D=0,P=0,L=[],M=[];_.codepage=1200,ie(1200);for(var U=!1;e.l<e.length-1;){var B=e.l,W=e.read_shift(2);if(0===W&&10===F)break;var H=e.l===e.length?0:e.read_shift(2),z=Pf[W];if(z&&z.f){if(t.bookSheets&&133===F&&133!==W)break;if(F=W,2===z.r||12==z.r){var V=e.read_shift(2);if(H-=2,!_.enc&&V!==W&&((255&V)<<8|V>>8)!==W)throw new Error("rt mismatch: "+V+"!="+W);12==z.r&&(e.l+=10,H-=10)}var G,j,$,X={},X=10===W?z.f(e,H,_):function(e,t,r,a,n){var s=a,i=[],o=r.slice(r.l,r.l+s);if(n&&n.enc&&n.enc.insitu&&0<o.length)switch(e){case 9:case 521:case 1033:case 2057:case 47:case 405:case 225:case 406:case 312:case 404:case 10:case 133:break;default:n.enc.insitu(o)}i.push(o),r.l+=s;for(var c=yr(r,r.l),l=Pf[c],f=0;null!=l&&-1<Af.indexOf(c);)s=yr(r,r.l+2),f=r.l+4,2066==c?f+=4:2165!=c&&2175!=c||(f+=12),o=r.slice(f,r.l+4+s),i.push(o),r.l+=4+s,l=Pf[c=yr(r,r.l)];var h=ue(i);Dr(h,0);var u=0;h.lens=[];for(var d=0;d<i.length;++d)h.lens.push(u),u+=i[d].length;if(h.length<a)throw"XLS Record 0x"+e.toString(16)+" Truncated: "+h.length+" < "+a;return t.f(h,h.length,n)}(W,z,e,H,_);if(0!=D||-1!==[9,521,1033,2057].indexOf(F))switch(W){case 34:r.opts.Date1904=y.WBProps.date1904=X;break;case 134:r.opts.WriteProtect=!0;break;case 47:if(_.enc||(e.l=0),_.enc=X,!t.password)throw new Error("File is password-protected");if(null==X.valid)throw new Error("Encryption scheme unsupported");if(!X.valid)throw new Error("Password is incorrect");break;case 92:_.lastuser=X;break;case 66:var Y=Number(X);switch(Y){case 21010:Y=1200;break;case 32768:Y=1e4;break;case 32769:Y=1252}ie(_.codepage=Y),U=!0;break;case 317:_.rrtabid=X;break;case 25:_.winlocked=X;break;case 439:r.opts.RefreshAll=X;break;case 12:r.opts.CalcCount=X;break;case 16:r.opts.CalcDelta=X;break;case 17:r.opts.CalcIter=X;break;case 13:r.opts.CalcMode=X;break;case 14:r.opts.CalcPrecision=X;break;case 95:r.opts.CalcSaveRecalc=X;break;case 15:_.CalcRefMode=X;break;case 2211:r.opts.FullCalc=X;break;case 129:X.fDialog&&(h["!type"]="dialog"),X.fBelow||((h["!outline"]||(h["!outline"]={})).above=!0),X.fRight||((h["!outline"]||(h["!outline"]={})).left=!0);break;case 224:E.push(X);break;case 430:I.push([X]),I[I.length-1].XTI=[];break;case 35:case 547:I[I.length-1].push(X);break;case 24:case 536:N={Name:X.Name,Ref:Pc(X.rgce,0,null,I,_)},0<X.itab&&(N.Sheet=X.itab-1),I.names.push(N),I[0]||(I[0]=[],I[0].XTI=[]),I[I.length-1].push(X),"_xlnm._FilterDatabase"==X.Name&&0<X.itab&&X.rgce&&X.rgce[0]&&X.rgce[0][0]&&"PtgArea3d"==X.rgce[0][0][0]&&(M[X.itab-1]={ref:qr(X.rgce[0][0][1][2])});break;case 22:_.ExternCount=X;break;case 23:0==I.length&&(I[0]=[],I[0].XTI=[]),I[I.length-1].XTI=I[I.length-1].XTI.concat(X),I.XTI=I.XTI.concat(X);break;case 2196:if(_.biff<8)break;null!=N&&(N.Comment=X[1]);break;case 18:h["!protect"]=X;break;case 19:0!==X&&_.WTF&&console.error("Password verifier: "+X);break;case 133:u[X.pos]=X,_.snames.push(X.name);break;case 10:if(--D)break;d.e&&(0<d.e.r&&0<d.e.c&&(d.e.r--,d.e.c--,h["!ref"]=qr(d),t.sheetRows&&t.sheetRows<=d.e.r&&(K=d.e.r,d.e.r=t.sheetRows-1,h["!fullref"]=h["!ref"],h["!ref"]=qr(d),d.e.r=K),d.e.r++,d.e.c++),0<x.length&&(h["!merges"]=x),0<A.length&&(h["!objects"]=A),0<C.length&&(h["!cols"]=C),0<R.length&&(h["!rows"]=R),y.Sheets.push(S)),""===g?b=h:a[g]=h,h=t.dense?[]:{};break;case 9:case 521:case 1033:case 2057:if(8===_.biff&&(_.biff={9:2,521:3,1033:4}[W]||{512:2,768:3,1024:4,1280:5,1536:8,2:2,7:2}[X.BIFFVer]||8),_.biffguess=0==X.BIFFVer,0==X.BIFFVer&&4096==X.dt&&(_.biff=5,U=!0,ie(_.codepage=28591)),8==_.biff&&0==X.BIFFVer&&16==X.dt&&(_.biff=2),D++)break;var K,h=t.dense?[]:{};_.biff<8&&!U&&(U=!0,ie(_.codepage=t.codepage||1252)),_.biff<5||0==X.BIFFVer&&4096==X.dt?(""===g&&(g="Sheet1"),d={s:{r:0,c:0},e:{r:0,c:0}},K={pos:e.l-H,name:g},u[K.pos]=K,_.snames.push(g)):g=(u[B]||{name:""}).name,32==X.dt&&(h["!type"]="chart"),64==X.dt&&(h["!type"]="macro"),x=[],A=[],_.arrayf=T=[],C=[],O=!(R=[]),S={Hidden:(u[B]||{hs:0}).hs,name:g};break;case 515:case 3:case 2:"chart"==h["!type"]&&(t.dense?(h[X.r]||[])[X.c]:h[Kr({c:X.c,r:X.r})])&&++X.c,Z={ixfe:X.ixfe,XF:E[X.ixfe]||{},v:X.val,t:"n"},0<P&&(Z.z=L[Z.ixfe>>8&63]),Cf(Z,t,r.opts.Date1904),n({c:X.c,r:X.r},Z,t);break;case 5:case 517:Z={ixfe:X.ixfe,XF:E[X.ixfe],v:X.val,t:X.t},0<P&&(Z.z=L[Z.ixfe>>8&63]),Cf(Z,t,r.opts.Date1904),n({c:X.c,r:X.r},Z,t);break;case 638:Z={ixfe:X.ixfe,XF:E[X.ixfe],v:X.rknum,t:"n"},0<P&&(Z.z=L[Z.ixfe>>8&63]),Cf(Z,t,r.opts.Date1904),n({c:X.c,r:X.r},Z,t);break;case 189:for(var J=X.c;J<=X.C;++J){var q=X.rkrec[J-X.c][0],Z={ixfe:q,XF:E[q],v:X.rkrec[J-X.c][1],t:"n"};0<P&&(Z.z=L[Z.ixfe>>8&63]),Cf(Z,t,r.opts.Date1904),n({c:J,r:X.r},Z,t)}break;case 6:case 518:case 1030:if("String"==X.val){p=X;break}(Z=Rf(X.val,X.cell.ixfe,X.tt)).XF=E[Z.ixfe],t.cellFormula&&(!((Q=X.formula)&&Q[0]&&Q[0][0]&&"PtgExp"==Q[0][0][0])||w[$=Kr({r:G=Q[0][0][1][0],c:j=Q[0][0][1][1]})]?Z.f=""+Pc(X.formula,0,X.cell,I,_):Z.F=((t.dense?(h[G]||[])[j]:h[$])||{}).F),0<P&&(Z.z=L[Z.ixfe>>8&63]),Cf(Z,t,r.opts.Date1904),n(X.cell,Z,t),p=X;break;case 7:case 519:if(!p)throw new Error("String record expects Formula");(Z=Rf(p.val=X,p.cell.ixfe,"s")).XF=E[Z.ixfe],t.cellFormula&&(Z.f=""+Pc(p.formula,0,p.cell,I,_)),0<P&&(Z.z=L[Z.ixfe>>8&63]),Cf(Z,t,r.opts.Date1904),n(p.cell,Z,t),p=null;break;case 33:case 545:T.push(X);var Q=Kr(X[0].s),ee=t.dense?(h[X[0].s.r]||[])[X[0].s.c]:h[Q];if(t.cellFormula&&ee){if(!p)break;if(!Q||!ee)break;ee.f=""+Pc(X[1],0,X[0],I,_),ee.F=qr(X[0])}break;case 1212:if(!t.cellFormula)break;if(v){if(!p)break;w[Kr(p.cell)]=X[0],((ee=t.dense?(h[p.cell.r]||[])[p.cell.c]:h[Kr(p.cell)])||{}).f=""+Pc(X[0],0,c,I,_)}break;case 253:Z=Rf(m[X.isst].t,X.ixfe,"s"),m[X.isst].h&&(Z.h=m[X.isst].h),Z.XF=E[Z.ixfe],0<P&&(Z.z=L[Z.ixfe>>8&63]),Cf(Z,t,r.opts.Date1904),n({c:X.c,r:X.r},Z,t);break;case 513:t.sheetStubs&&(Z={ixfe:X.ixfe,XF:E[X.ixfe],t:"z"},0<P&&(Z.z=L[Z.ixfe>>8&63]),Cf(Z,t,r.opts.Date1904),n({c:X.c,r:X.r},Z,t));break;case 190:if(t.sheetStubs)for(var te=X.c;te<=X.C;++te){var re=X.ixfe[te-X.c];Z={ixfe:re,XF:E[re],t:"z"},0<P&&(Z.z=L[Z.ixfe>>8&63]),Cf(Z,t,r.opts.Date1904),n({c:te,r:X.r},Z,t)}break;case 214:case 516:case 4:(Z=Rf(X.val,X.ixfe,"s")).XF=E[Z.ixfe],0<P&&(Z.z=L[Z.ixfe>>8&63]),Cf(Z,t,r.opts.Date1904),n({c:X.c,r:X.r},Z,t);break;case 0:case 512:1===D&&(d=X);break;case 252:m=X;break;case 1054:if(4==_.biff){L[P++]=X[1];for(var ae=0;ae<P+163&&me[ae]!=X[1];++ae);163<=ae&&we(X[1],P+163)}else we(X[1],X[0]);break;case 30:L[P++]=X;for(var ne=0;ne<P+163&&me[ne]!=X;++ne);163<=ne&&we(X,P+163);break;case 229:x=x.concat(X);break;case 93:A[X.cmo[0]]=_.lastobj=X;break;case 438:_.lastobj.TxO=X;break;case 127:_.lastobj.ImData=X;break;case 440:for(i=X[0].s.r;i<=X[0].e.r;++i)for(s=X[0].s.c;s<=X[0].e.c;++s)(ee=t.dense?(h[i]||[])[s]:h[Kr({c:s,r:i})])&&(ee.l=X[1]);break;case 2048:for(i=X[0].s.r;i<=X[0].e.r;++i)for(s=X[0].s.c;s<=X[0].e.c;++s)(ee=t.dense?(h[i]||[])[s]:h[Kr({c:s,r:i})])&&ee.l&&(ee.l.Tooltip=X[1]);break;case 28:if(_.biff<=5&&2<=_.biff)break;ee=t.dense?(h[X[0].r]||[])[X[0].c]:h[Kr(X[0])];var se=A[X[2]];ee||(ee=t.dense?(h[X[0].r]||(h[X[0].r]=[]),h[X[0].r][X[0].c]={t:"z"}):h[Kr(X[0])]={t:"z"},d.e.r=Math.max(d.e.r,X[0].r),d.s.r=Math.min(d.s.r,X[0].r),d.e.c=Math.max(d.e.c,X[0].c),d.s.c=Math.min(d.s.c,X[0].c)),ee.c||(ee.c=[]),se={a:X[1],t:se.TxO.t},ee.c.push(se);break;case 2173:E[X.ixfe],X.ext.forEach(function(e){e[0]});break;case 125:if(!_.cellStyles)break;for(;X.e>=X.s;)C[X.e--]={width:X.w/256,level:X.level||0,hidden:!!(1&X.flags)},O||(O=!0,lo(X.w/256)),fo(C[X.e+1]);break;case 520:se={};null!=X.level&&((R[X.r]=se).level=X.level),X.hidden&&((R[X.r]=se).hidden=!0),X.hpt&&((R[X.r]=se).hpt=X.hpt,se.hpx=po(X.hpt));break;case 38:case 39:case 40:case 41:h["!margins"]||Qc(h["!margins"]={}),h["!margins"][{38:"left",39:"right",40:"top",41:"bottom"}[W]]=X;break;case 161:h["!margins"]||Qc(h["!margins"]={}),h["!margins"].header=X.header,h["!margins"].footer=X.footer;break;case 574:X.RTL&&(y.Views[0].RTL=!0);break;case 146:k=X;break;case 2198:f=X;break;case 140:l=X;break;case 442:g?S.CodeName=X||S.name:y.WBProps.CodeName=X||"ThisWorkbook"}}else z||console.error("Missing Info for XLS Record 0x"+W.toString(16)),e.l+=H}return r.SheetNames=Re(u).sort(function(e,t){return Number(e)-Number(t)}).map(function(e){return u[e].name}),t.bookSheets||(r.Sheets=a),!r.SheetNames.length&&b["!ref"]?(r.SheetNames.push("Sheet1"),r.Sheets&&(r.Sheets.Sheet1=b)):r.Preamble=b,r.Sheets&&M.forEach(function(e,t){r.Sheets[r.SheetNames[t]]["!autofilter"]=e}),r.Strings=m,r.SSF=Ve(me),_.enc&&(r.Encryption=_.enc),f&&(r.Themes=f),r.Metadata={},void 0!==l&&(r.Metadata.Country=l),0<I.names.length&&(y.Names=I.names),r.Workbook=y,r}var If={SI:"e0859ff2f94f6810ab9108002b27b3d9",DSI:"02d5cdd59c2e1b10939708002b2cf9ae",UDI:"05d5cdd59c2e1b10939708002b2cf9ae"};function Nf(e,t){var r,a,n,s,i;if(Mh(t=t||{}),h(),t.codepage&&c(t.codepage),e.FullPaths){if(xe.find(e,"/encryption"))throw new Error("File is password-protected");r=xe.find(e,"!CompObj"),n=xe.find(e,"/Workbook")||xe.find(e,"/Book")}else{switch(t.type){case"base64":e=he(te(e));break;case"binary":e=he(e);break;case"buffer":break;case"array":Array.isArray(e)||(e=Array.prototype.slice.call(e))}Dr(e,0),n={content:e}}if(r&&xf(r),t.bookProps&&!t.bookSheets)a={};else{var o=se?"buffer":"array";if(n&&n.content)a=Of(n.content,t);else if((n=xe.find(e,"PerfectOffice_MAIN"))&&n.content)a=si.to_workbook(n.content,(t.type=o,t));else{if(!(n=xe.find(e,"NativeContent_MAIN"))||!n.content)throw(n=xe.find(e,"MN0"))&&n.content?new Error("Unsupported Works 4 for Mac file"):new Error("Cannot find Workbook stream");a=si.to_workbook(n.content,(t.type=o,t))}t.bookVBA&&e.FullPaths&&xe.find(e,"/_VBA_PROJECT_CUR/VBA/dir")&&(a.vbaraw=(s=e,i=xe.utils.cfb_new({root:"R"}),s.FullPaths.forEach(function(e,t){"/"!==e.slice(-1)&&e.match(/_VBA_PROJECT_CUR/)&&(e=e.replace(/^[^\/]*/,"R").replace(/\/_VBA_PROJECT_CUR\u0000*/,""),xe.utils.cfb_add(i,e,s.FileIndex[t].content))}),xe.write(i)))}o={};return e.FullPaths&&function(e,t,r){var a=xe.find(e,"/!DocumentSummaryInformation");if(a&&0<a.size)try{var n,s=An(a,Pa,If.DSI);for(n in s)t[n]=s[n]}catch(e){if(r.WTF)throw e}var i=xe.find(e,"/!SummaryInformation");if(i&&0<i.size)try{var o,c=An(i,La,If.SI);for(o in c)null==t[o]&&(t[o]=c[o])}catch(e){if(r.WTF)throw e}t.HeadingPairs&&t.TitlesOfParts&&(cn(t.HeadingPairs,t.TitlesOfParts,t,r),delete t.HeadingPairs,delete t.TitlesOfParts)}(e,o,t),a.Props=a.Custprops=o,t.bookFiles&&(a.cfb=e),a}function Ff(e,t){var r,a,n=t||{},t=xe.utils.cfb_new({root:"R"}),s="/Workbook";switch(n.bookType||"xls"){case"xls":n.bookType="biff8";case"xla":n.bookType||(n.bookType="xla");case"biff8":s="/Workbook",n.biff=8;break;case"biff5":s="/Book",n.biff=5;break;default:throw new Error("invalid type "+n.bookType+" for XLS CFB")}return xe.utils.cfb_add(t,s,Xf(e,n)),8==n.biff&&(e.Props||e.Custprops)&&function(e,t){var r,a=[],n=[],s=[],i=0,o=Oe(Pa,"n"),c=Oe(La,"n");if(e.Props)for(r=Re(e.Props),i=0;i<r.length;++i)(Object.prototype.hasOwnProperty.call(o,r[i])?a:Object.prototype.hasOwnProperty.call(c,r[i])?n:s).push([r[i],e.Props[r[i]]]);if(e.Custprops)for(r=Re(e.Custprops),i=0;i<r.length;++i)Object.prototype.hasOwnProperty.call(e.Props||{},r[i])||(Object.prototype.hasOwnProperty.call(o,r[i])?a:Object.prototype.hasOwnProperty.call(c,r[i])?n:s).push([r[i],e.Custprops[r[i]]]);for(var l=[],i=0;i<s.length;++i)-1<_n.indexOf(s[i][0])||-1<on.indexOf(s[i][0])||null!=s[i][1]&&l.push(s[i]);n.length&&xe.utils.cfb_add(t,"/SummaryInformation",Cn(n,If.SI,c,La)),(a.length||l.length)&&xe.utils.cfb_add(t,"/DocumentSummaryInformation",Cn(a,If.DSI,o,Pa,l.length?l:null,If.UDI))}(e,t),8==n.biff&&e.vbaraw&&(r=t,(a=xe.read(e.vbaraw,{type:"string"==typeof e.vbaraw?"binary":"buffer"})).FullPaths.forEach(function(e,t){0==t||"/"!==(e=e.replace(/[^\/]*[\/]/,"/_VBA_PROJECT_CUR/")).slice(-1)&&xe.utils.cfb_add(r,e,a.FileIndex[t].content)})),t}var Df={0:{f:function(e,t){var r={},a=e.l+t;r.r=e.read_shift(4),e.l+=4;var n=e.read_shift(2);return e.l+=1,t=e.read_shift(1),e.l=a,7&t&&(r.level=7&t),16&t&&(r.hidden=!0),32&t&&(r.hpt=n/20),r}},1:{f:function(e){return[fa(e)]}},2:{f:function(e){return[fa(e),Ea(e),"n"]}},3:{f:function(e){return[fa(e),e.read_shift(1),"e"]}},4:{f:function(e){return[fa(e),e.read_shift(1),"b"]}},5:{f:function(e){return[fa(e),xa(e),"n"]}},6:{f:function(e){return[fa(e),sa(e),"str"]}},7:{f:function(e){return[fa(e),e.read_shift(4),"s"]}},8:{f:function(e,t,r){var a=e.l+t,n=fa(e);n.r=r["!row"];var s=[n,sa(e),"str"];return r.cellFormula?(e.l+=2,t=Wc(e,a-e.l,r),s[3]=Pc(t,0,n,r.supbooks,r)):e.l=a,s}},9:{f:function(e,t,r){var a=e.l+t,n=fa(e);n.r=r["!row"];var s=[n,xa(e),"n"];return r.cellFormula?(e.l+=2,t=Wc(e,a-e.l,r),s[3]=Pc(t,0,n,r.supbooks,r)):e.l=a,s}},10:{f:function(e,t,r){var a=e.l+t,n=fa(e);n.r=r["!row"];var s=[n,e.read_shift(1),"b"];return r.cellFormula?(e.l+=2,t=Wc(e,a-e.l,r),s[3]=Pc(t,0,n,r.supbooks,r)):e.l=a,s}},11:{f:function(e,t,r){var a=e.l+t,n=fa(e);n.r=r["!row"];var s=[n,e.read_shift(1),"e"];return r.cellFormula?(e.l+=2,t=Wc(e,a-e.l,r),s[3]=Pc(t,0,n,r.supbooks,r)):e.l=a,s}},12:{f:function(e){return[ua(e)]}},13:{f:function(e){return[ua(e),Ea(e),"n"]}},14:{f:function(e){return[ua(e),e.read_shift(1),"e"]}},15:{f:function(e){return[ua(e),e.read_shift(1),"b"]}},16:{f:Rl},17:{f:function(e){return[ua(e),sa(e),"str"]}},18:{f:function(e){return[ua(e),e.read_shift(4),"s"]}},19:{f:oa},20:{},21:{},22:{},23:{},24:{},25:{},26:{},27:{},28:{},29:{},30:{},31:{},32:{},33:{},34:{},35:{T:1},36:{T:-1},37:{T:1},38:{T:-1},39:{f:function(e,t,r){var a=e.l+t;e.l+=4,e.l+=1;var n=e.read_shift(4),s=va(e),t=Hc(e,0,r),r=ga(e);return e.l=a,t={Name:s,Ptg:t},n<268435455&&(t.Sheet=n),r&&(t.Comment=r),t}},40:{},42:{},43:{f:function(e,t,r){var a={};a.sz=e.read_shift(2)/20;var n,s=(s=(n=e).read_shift(1),n.l++,{fBold:1&s,fItalic:2&s,fUnderline:4&s,fStrikeout:8&s,fOutline:16&s,fShadow:32&s,fCondense:64&s,fExtend:128&s});switch(s.fItalic&&(a.italic=1),s.fCondense&&(a.condense=1),s.fExtend&&(a.extend=1),s.fShadow&&(a.shadow=1),s.fOutline&&(a.outline=1),s.fStrikeout&&(a.strike=1),700===e.read_shift(2)&&(a.bold=1),e.read_shift(2)){case 1:a.vertAlign="superscript";break;case 2:a.vertAlign="subscript"}switch(0!=(s=e.read_shift(1))&&(a.underline=s),0<(s=e.read_shift(1))&&(a.family=s),0<(s=e.read_shift(1))&&(a.charset=s),e.l++,a.color=function(e){var t={},r=e.read_shift(1)>>>1,a=e.read_shift(1),n=e.read_shift(2,"i"),s=e.read_shift(1),i=e.read_shift(1),o=e.read_shift(1);switch(e.l++,r){case 0:t.auto=1;break;case 1:t.index=a;var c=Ba[a];c&&(t.rgb=Qi(c));break;case 2:t.rgb=Qi([s,i,o]);break;case 3:t.theme=a}return 0!=n&&(t.tint=0<n?n/32767:n/32768),t}(e),e.read_shift(1)){case 1:a.scheme="major";break;case 2:a.scheme="minor"}return a.name=sa(e),a}},44:{f:function(e,t){return[e.read_shift(2),sa(e)]}},45:{f:Ro},46:{f:r},47:{f:function(e,t){var r=e.l+t,a=e.read_shift(2),t=e.read_shift(2);return e.l=r,{ixfe:a,numFmtId:t}}},48:{},49:{f:function(e){return e.read_shift(4,"i")}},50:{},51:{f:function(e){for(var t=[],r=e.read_shift(4);0<r--;)t.push([e.read_shift(4),e.read_shift(4)]);return t}},52:{T:1},53:{T:-1},54:{T:1},55:{T:-1},56:{T:1},57:{T:-1},58:{},59:{},60:{f:vs},62:{f:function(e){return[fa(e),oa(e),"is"]}},63:{f:function(e){var t={};t.i=e.read_shift(4);var r={};return r.r=e.read_shift(4),r.c=e.read_shift(4),t.r=Kr(r),2&(e=e.read_shift(1))&&(t.l="1"),8&e&&(t.a="1"),t}},64:{f:function(){}},65:{},66:{},67:{},68:{},69:{},70:{},128:{},129:{T:1},130:{T:-1},131:{T:1,f:Pr,p:0},132:{T:-1},133:{T:1},134:{T:-1},135:{T:1},136:{T:-1},137:{T:1,f:function(e){var t=e.read_shift(2);return e.l+=28,{RTL:32&t}}},138:{T:-1},139:{T:1},140:{T:-1},141:{T:1},142:{T:-1},143:{T:1},144:{T:-1},145:{T:1},146:{T:-1},147:{f:function(e,t){var r={},a=e[e.l];return++e.l,r.above=!(64&a),r.left=!(128&a),e.l+=18,r.name=pa(e,t-19),r}},148:{f:lt,p:16},151:{f:function(){}},152:{},153:{f:function(e,t){var r={},a=e.read_shift(4);return r.defaultThemeVersion=e.read_shift(4),0<(e=8<t?sa(e):"").length&&(r.CodeName=e),r.autoCompressPictures=!!(65536&a),r.backupFile=!!(64&a),r.checkCompatibility=!!(4096&a),r.date1904=!!(1&a),r.filterPrivacy=!!(8&a),r.hidePivotFieldList=!!(1024&a),r.promptedSolutions=!!(16&a),r.publishItems=!!(2048&a),r.refreshAllConnections=!!(262144&a),r.saveExternalLinkValues=!!(128&a),r.showBorderUnselectedTables=!!(4&a),r.showInkAnnotation=!!(32&a),r.showObjects=["all","placeholders","none"][a>>13&3],r.showPivotChartFilter=!!(32768&a),r.updateLinks=["userSet","never","always"][a>>8&3],r}},154:{},155:{},156:{f:function(e,t){var r={};return r.Hidden=e.read_shift(4),r.iTabID=e.read_shift(4),r.strRelID=wa(e,t-8),r.name=sa(e),r}},157:{},158:{},159:{T:1,f:function(e){return[e.read_shift(4),e.read_shift(4)]}},160:{T:-1},161:{T:1,f:Sa},162:{T:-1},163:{T:1},164:{T:-1},165:{T:1},166:{T:-1},167:{},168:{},169:{},170:{},171:{},172:{T:1},173:{T:-1},174:{},175:{},176:{f:Lt},177:{T:1},178:{T:-1},179:{T:1},180:{T:-1},181:{T:1},182:{T:-1},183:{T:1},184:{T:-1},185:{T:1},186:{T:-1},187:{T:1},188:{T:-1},189:{T:1},190:{T:-1},191:{T:1},192:{T:-1},193:{T:1},194:{T:-1},195:{T:1},196:{T:-1},197:{T:1},198:{T:-1},199:{T:1},200:{T:-1},201:{T:1},202:{T:-1},203:{T:1},204:{T:-1},205:{T:1},206:{T:-1},207:{T:1},208:{T:-1},209:{T:1},210:{T:-1},211:{T:1},212:{T:-1},213:{T:1},214:{T:-1},215:{T:1},216:{T:-1},217:{T:1},218:{T:-1},219:{T:1},220:{T:-1},221:{T:1},222:{T:-1},223:{T:1},224:{T:-1},225:{T:1},226:{T:-1},227:{T:1},228:{T:-1},229:{T:1},230:{T:-1},231:{T:1},232:{T:-1},233:{T:1},234:{T:-1},235:{T:1},236:{T:-1},237:{T:1},238:{T:-1},239:{T:1},240:{T:-1},241:{T:1},242:{T:-1},243:{T:1},244:{T:-1},245:{T:1},246:{T:-1},247:{T:1},248:{T:-1},249:{T:1},250:{T:-1},251:{T:1},252:{T:-1},253:{T:1},254:{T:-1},255:{T:1},256:{T:-1},257:{T:1},258:{T:-1},259:{T:1},260:{T:-1},261:{T:1},262:{T:-1},263:{T:1},264:{T:-1},265:{T:1},266:{T:-1},267:{T:1},268:{T:-1},269:{T:1},270:{T:-1},271:{T:1},272:{T:-1},273:{T:1},274:{T:-1},275:{T:1},276:{T:-1},277:{},278:{T:1},279:{T:-1},280:{T:1},281:{T:-1},282:{T:1},283:{T:1},284:{T:-1},285:{T:1},286:{T:-1},287:{T:1},288:{T:-1},289:{T:1},290:{T:-1},291:{T:1},292:{T:-1},293:{T:1},294:{T:-1},295:{T:1},296:{T:-1},297:{T:1},298:{T:-1},299:{T:1},300:{T:-1},301:{T:1},302:{T:-1},303:{T:1},304:{T:-1},305:{T:1},306:{T:-1},307:{T:1},308:{T:-1},309:{T:1},310:{T:-1},311:{T:1},312:{T:-1},313:{T:-1},314:{T:1},315:{T:-1},316:{T:1},317:{T:-1},318:{T:1},319:{T:-1},320:{T:1},321:{T:-1},322:{T:1},323:{T:-1},324:{T:1},325:{T:-1},326:{T:1},327:{T:-1},328:{T:1},329:{T:-1},330:{T:1},331:{T:-1},332:{T:1},333:{T:-1},334:{T:1},335:{f:function(e,t){return{flags:e.read_shift(4),version:e.read_shift(4),name:sa(e)}}},336:{T:-1},337:{f:function(e){return e.l+=4,0!=e.read_shift(4)},T:1},338:{T:-1},339:{T:1},340:{T:-1},341:{T:1},342:{T:-1},343:{T:1},344:{T:-1},345:{T:1},346:{T:-1},347:{T:1},348:{T:-1},349:{T:1},350:{T:-1},351:{},352:{},353:{T:1},354:{T:-1},355:{f:wa},357:{},358:{},359:{},360:{T:1},361:{},362:{f:ps},363:{},364:{},366:{},367:{},368:{},369:{},370:{},371:{},372:{T:1},373:{T:-1},374:{T:1},375:{T:-1},376:{T:1},377:{T:-1},378:{T:1},379:{T:-1},380:{T:1},381:{T:-1},382:{T:1},383:{T:-1},384:{T:1},385:{T:-1},386:{T:1},387:{T:-1},388:{T:1},389:{T:-1},390:{T:1},391:{T:-1},392:{T:1},393:{T:-1},394:{T:1},395:{T:-1},396:{},397:{},398:{},399:{},400:{},401:{T:1},403:{},404:{},405:{},406:{},407:{},408:{},409:{},410:{},411:{},412:{},413:{},414:{},415:{},416:{},417:{},418:{},419:{},420:{},421:{},422:{T:1},423:{T:1},424:{T:-1},425:{T:-1},426:{f:function(e,t,r){var a=e.l+t,n=ya(e),t=e.read_shift(1);return(n=[n])[2]=t,r.cellFormula?(r=Bc(e,a-e.l,r),n[1]=r):e.l=a,n}},427:{f:function(e,t,r){var a=e.l+t,t=[Sa(e,16)];return r.cellFormula&&(r=zc(e,a-e.l,r),t[1]=r),e.l=a,t}},428:{},429:{T:1},430:{T:-1},431:{T:1},432:{T:-1},433:{T:1},434:{T:-1},435:{T:1},436:{T:-1},437:{T:1},438:{T:-1},439:{T:1},440:{T:-1},441:{T:1},442:{T:-1},443:{T:1},444:{T:-1},445:{T:1},446:{T:-1},447:{T:1},448:{T:-1},449:{T:1},450:{T:-1},451:{T:1},452:{T:-1},453:{T:1},454:{T:-1},455:{T:1},456:{T:-1},457:{T:1},458:{T:-1},459:{T:1},460:{T:-1},461:{T:1},462:{T:-1},463:{T:1},464:{T:-1},465:{T:1},466:{T:-1},467:{T:1},468:{T:-1},469:{T:1},470:{T:-1},471:{},472:{},473:{T:1},474:{T:-1},475:{},476:{f:function(t){var r={};return Il.forEach(function(e){r[e]=xa(t)}),r}},477:{},478:{},479:{T:1},480:{T:-1},481:{T:1},482:{T:-1},483:{T:1},484:{T:-1},485:{f:function(){}},486:{T:1},487:{T:-1},488:{T:1},489:{T:-1},490:{T:1},491:{T:-1},492:{T:1},493:{T:-1},494:{f:function(e,t){var r=e.l+t,a=Sa(e,16),n=ga(e),s=sa(e),i=sa(e),t=sa(e);return e.l=r,t={rfx:a,relId:n,loc:s,display:t},i&&(t.Tooltip=i),t}},495:{T:1},496:{T:-1},497:{T:1},498:{T:-1},499:{},500:{T:1},501:{T:-1},502:{T:1},503:{T:-1},504:{},505:{T:1},506:{T:-1},507:{},508:{T:1},509:{T:-1},510:{T:1},511:{T:-1},512:{},513:{},514:{T:1},515:{T:-1},516:{T:1},517:{T:-1},518:{T:1},519:{T:-1},520:{T:1},521:{T:-1},522:{},523:{},524:{},525:{},526:{},527:{},528:{T:1},529:{T:-1},530:{T:1},531:{T:-1},532:{T:1},533:{T:-1},534:{},535:{},536:{},537:{},538:{T:1},539:{T:-1},540:{T:1},541:{T:-1},542:{T:1},548:{},549:{},550:{f:wa},551:{},552:{},553:{},554:{T:1},555:{T:-1},556:{T:1},557:{T:-1},558:{T:1},559:{T:-1},560:{T:1},561:{T:-1},562:{},564:{},565:{T:1},566:{T:-1},569:{T:1},570:{T:-1},572:{},573:{T:1},574:{T:-1},577:{},578:{},579:{},580:{},581:{},582:{},583:{},584:{},585:{},586:{},587:{},588:{T:-1},589:{},590:{T:1},591:{T:-1},592:{T:1},593:{T:-1},594:{T:1},595:{T:-1},596:{},597:{T:1},598:{T:-1},599:{T:1},600:{T:-1},601:{T:1},602:{T:-1},603:{T:1},604:{T:-1},605:{T:1},606:{T:-1},607:{},608:{T:1},609:{T:-1},610:{},611:{T:1},612:{T:-1},613:{T:1},614:{T:-1},615:{T:1},616:{T:-1},617:{T:1},618:{T:-1},619:{T:1},620:{T:-1},625:{},626:{T:1},627:{T:-1},628:{T:1},629:{T:-1},630:{T:1},631:{T:-1},632:{f:Ue},633:{T:1},634:{T:-1},635:{T:1,f:function(e){var t={};t.iauthor=e.read_shift(4);var r=Sa(e,16);return t.rfx=r.s,t.ref=Kr(r.s),e.l+=16,t}},636:{T:-1},637:{f:ca},638:{T:1},639:{},640:{T:-1},641:{T:1},642:{T:-1},643:{T:1},644:{},645:{T:-1},646:{T:1},648:{T:1},649:{},650:{T:-1},651:{f:function(e,t){return e.l+=10,{name:sa(e)}}},652:{},653:{T:1},654:{T:-1},655:{T:1},656:{T:-1},657:{T:1},658:{T:-1},659:{},660:{T:1},661:{},662:{T:-1},663:{},664:{T:1},665:{},666:{T:-1},667:{},668:{},669:{},671:{T:1},672:{T:-1},673:{T:1},674:{T:-1},675:{},676:{},677:{},678:{},679:{},680:{},681:{},1024:{},1025:{},1026:{T:1},1027:{T:-1},1028:{T:1},1029:{T:-1},1030:{},1031:{T:1},1032:{T:-1},1033:{T:1},1034:{T:-1},1035:{},1036:{},1037:{},1038:{T:1},1039:{T:-1},1040:{},1041:{T:1},1042:{T:-1},1043:{},1044:{},1045:{},1046:{T:1},1047:{T:-1},1048:{T:1},1049:{T:-1},1050:{},1051:{T:1},1052:{T:1},1053:{f:function(){}},1054:{T:1},1055:{},1056:{T:1},1057:{T:-1},1058:{T:1},1059:{T:-1},1061:{},1062:{T:1},1063:{T:-1},1064:{T:1},1065:{T:-1},1066:{T:1},1067:{T:-1},1068:{T:1},1069:{T:-1},1070:{T:1},1071:{T:-1},1072:{T:1},1073:{T:-1},1075:{T:1},1076:{T:-1},1077:{T:1},1078:{T:-1},1079:{T:1},1080:{T:-1},1081:{T:1},1082:{T:-1},1083:{T:1},1084:{T:-1},1085:{},1086:{T:1},1087:{T:-1},1088:{T:1},1089:{T:-1},1090:{T:1},1091:{T:-1},1092:{T:1},1093:{T:-1},1094:{T:1},1095:{T:-1},1096:{},1097:{T:1},1098:{},1099:{T:-1},1100:{T:1},1101:{T:-1},1102:{},1103:{},1104:{},1105:{},1111:{},1112:{},1113:{T:1},1114:{T:-1},1115:{T:1},1116:{T:-1},1117:{},1118:{T:1},1119:{T:-1},1120:{T:1},1121:{T:-1},1122:{T:1},1123:{T:-1},1124:{T:1},1125:{T:-1},1126:{},1128:{T:1},1129:{T:-1},1130:{},1131:{T:1},1132:{T:-1},1133:{T:1},1134:{T:-1},1135:{T:1},1136:{T:-1},1137:{T:1},1138:{T:-1},1139:{T:1},1140:{T:-1},1141:{},1142:{T:1},1143:{T:-1},1144:{T:1},1145:{T:-1},1146:{},1147:{T:1},1148:{T:-1},1149:{T:1},1150:{T:-1},1152:{T:1},1153:{T:-1},1154:{T:-1},1155:{T:-1},1156:{T:-1},1157:{T:1},1158:{T:-1},1159:{T:1},1160:{T:-1},1161:{T:1},1162:{T:-1},1163:{T:1},1164:{T:-1},1165:{T:1},1166:{T:-1},1167:{T:1},1168:{T:-1},1169:{T:1},1170:{T:-1},1171:{},1172:{T:1},1173:{T:-1},1177:{},1178:{T:1},1180:{},1181:{},1182:{},2048:{T:1},2049:{T:-1},2050:{},2051:{T:1},2052:{T:-1},2053:{},2054:{},2055:{T:1},2056:{T:-1},2057:{T:1},2058:{T:-1},2060:{},2067:{},2068:{T:1},2069:{T:-1},2070:{},2071:{},2072:{T:1},2073:{T:-1},2075:{},2076:{},2077:{T:1},2078:{T:-1},2079:{},2080:{T:1},2081:{T:-1},2082:{},2083:{T:1},2084:{T:-1},2085:{T:1},2086:{T:-1},2087:{T:1},2088:{T:-1},2089:{T:1},2090:{T:-1},2091:{},2092:{},2093:{T:1},2094:{T:-1},2095:{},2096:{T:1},2097:{T:-1},2098:{T:1},2099:{T:-1},2100:{T:1},2101:{T:-1},2102:{},2103:{T:1},2104:{T:-1},2105:{},2106:{T:1},2107:{T:-1},2108:{},2109:{T:1},2110:{T:-1},2111:{T:1},2112:{T:-1},2113:{T:1},2114:{T:-1},2115:{},2116:{},2117:{},2118:{T:1},2119:{T:-1},2120:{},2121:{T:1},2122:{T:-1},2123:{T:1},2124:{T:-1},2125:{},2126:{T:1},2127:{T:-1},2128:{},2129:{T:1},2130:{T:-1},2131:{T:1},2132:{T:-1},2133:{T:1},2134:{},2135:{},2136:{},2137:{T:1},2138:{T:-1},2139:{T:1},2140:{T:-1},2141:{},3072:{},3073:{},4096:{T:1},4097:{T:-1},5002:{T:1},5003:{T:-1},5081:{T:1},5082:{T:-1},5083:{},5084:{T:1},5085:{T:-1},5086:{T:1},5087:{T:-1},5088:{},5089:{},5090:{},5092:{T:1},5093:{T:-1},5094:{},5095:{T:1},5096:{T:-1},5097:{},5099:{},65535:{n:""}},Pf={6:{f:Lc},10:{f:Rn},12:{f:Nn},13:{f:Nn},14:{f:On},15:{f:On},16:{f:xa},17:{f:On},18:{f:On},19:{f:Nn},20:{f:fs},21:{f:fs},23:{f:ps},24:{f:ds},25:{f:On},26:{},27:{},28:{f:function(e,t,r){return function(e,t){if(!(t.biff<8)){var r=e.read_shift(2),a=e.read_shift(2),n=e.read_shift(2),s=e.read_shift(2),i=Bn(e,0,t);return t.biff<8&&e.read_shift(1),[{r:r,c:a},i,s,n]}}(e,r)}},29:{},34:{f:On},35:{f:hs},38:{f:xa},39:{f:xa},40:{f:xa},41:{f:xa},42:{f:On},43:{f:On},47:{f:function(e,t,r){var a={Type:8<=r.biff?e.read_shift(2):0};return a.Type?Ki(e,t-2,a):(t=e,r.biff,e=r,r=a,t={key:Nn(t),verificationBytes:Nn(t)},e.password&&(t.verifier=zi(e.password)),r.valid=t.verificationBytes===t.verifier,r.valid&&(r.insitu=Yi(e.password))),a}},49:{f:function(e,t,r){var a={dyHeight:e.read_shift(2),fl:e.read_shift(2)};switch(r&&r.biff||8){case 2:break;case 3:case 4:e.l+=2;break;default:e.l+=10}return a.name=Ln(e,0,r),a}},51:{f:Nn},60:{},61:{f:function(e){return{Pos:[e.read_shift(2),e.read_shift(2)],Dim:[e.read_shift(2),e.read_shift(2)],Flags:e.read_shift(2),CurTab:e.read_shift(2),FirstTab:e.read_shift(2),Selected:e.read_shift(2),TabRatio:e.read_shift(2)}}},64:{f:On},65:{f:function(){}},66:{f:Nn},77:{},80:{},81:{},82:{},85:{f:Nn},89:{},90:{},91:{},92:{f:function(e,t,r){if(r.enc)return e.l+=t,"";var a=e.l,r=Bn(e,0,r);return e.read_shift(t+a-e.l),r}},93:{f:function(e,t,r){return r&&r.biff<8?function(e,t,r){e.l+=4;var a=e.read_shift(2),n=e.read_shift(2),s=e.read_shift(2);e.l+=2,e.l+=2,e.l+=2,e.l+=2,e.l+=2,e.l+=2,e.l+=2,e.l+=2,e.l+=2,e.l+=6,t-=36;var i=[];return i.push((gs[a]||Pr)(e,t,r)),{cmo:[n,a,s],ft:i}}(e,t,r):{cmo:r=Qn(e),ft:function(t,e){for(var r=t.l+e,a=[];t.l<r;){var n=t.read_shift(2);t.l-=2;try{a.push(ts[n](t,r-t.l))}catch(e){return t.l=r,a}}return t.l!=r&&(t.l=r),a}(e,t-22,r[1])}}},94:{},95:{f:On},96:{},97:{},99:{f:On},125:{f:vs},128:{f:function(e){if(e.l+=4,0!==(e=[e.read_shift(2),e.read_shift(2)])[0]&&e[0]--,0!==e[1]&&e[1]--,7<e[0]||7<e[1])throw new Error("Bad Gutters: "+e.join("|"));return e}},129:{f:function(e,t,r){return{fDialog:16&(t=r&&8==r.biff||2==t?e.read_shift(2):(e.l+=t,0)),fBelow:64&t,fRight:128&t}}},130:{f:Nn},131:{f:On},132:{f:On},133:{f:function(e,t,r){var a=e.read_shift(4),n=3&e.read_shift(1),s=e.read_shift(1);switch(s){case 0:s="Worksheet";break;case 1:s="Macrosheet";break;case 2:s="Chartsheet";break;case 6:s="VBAModule"}return r=Ln(e,0,r),{pos:a,hs:n,dt:s,name:r=0===r.length?"Sheet1":r}}},134:{},140:{f:function(e){var t=[0,0],r=e.read_shift(2);return t[0]=Ma[r]||r,r=e.read_shift(2),t[1]=Ma[r]||r,t}},141:{f:Nn},144:{},146:{f:function(e){for(var t=e.read_shift(2),r=[];0<t--;)r.push(jn(e));return r}},151:{},152:{},153:{},154:{},155:{},156:{f:Nn},157:{},158:{},160:{f:Ts},161:{f:function(e,t){var r={};return t<32||(e.l+=16,r.header=xa(e),r.footer=xa(e),e.l+=2),r}},174:{},175:{},176:{},177:{},178:{},180:{},181:{},182:{},184:{},185:{},189:{f:function(e,t){for(var r=e.l+t-2,a=e.read_shift(2),n=e.read_shift(2),s=[];e.l<r;)s.push(Yn(e));if(e.l!==r)throw new Error("MulRK read error");if(t=e.read_shift(2),s.length!=t-n+1)throw new Error("MulRK length mismatch");return{r:a,c:n,C:t,rkrec:s}}},190:{f:function(e,t){for(var r=e.l+t-2,a=e.read_shift(2),n=e.read_shift(2),s=[];e.l<r;)s.push(e.read_shift(2));if(e.l!==r)throw new Error("MulBlank read error");if(t=e.read_shift(2),s.length!=t-n+1)throw new Error("MulBlank length mismatch");return{r:a,c:n,C:t,ixfe:s}}},193:{f:Rn},197:{},198:{},199:{},200:{},201:{},202:{f:On},203:{},204:{},205:{},206:{},207:{},208:{},209:{},210:{},211:{},213:{},215:{},216:{},217:{},218:{f:Nn},220:{},221:{f:On},222:{},224:{f:function(e,t,r){var a,n,s,i={};return i.ifnt=e.read_shift(2),i.numFmtId=e.read_shift(2),i.flags=e.read_shift(2),i.fStyle=i.flags>>2&1,t-=6,i.data=(a=e,i.fStyle,n=r,s={},t=a.read_shift(4),e=a.read_shift(4),r=a.read_shift(4),a=a.read_shift(2),s.patternType=Ua[r>>26],n.cellStyles&&(s.alc=7&t,s.fWrap=t>>3&1,s.alcV=t>>4&7,s.fJustLast=t>>7&1,s.trot=t>>8&255,s.cIndent=t>>16&15,s.fShrinkToFit=t>>20&1,s.iReadOrder=t>>22&2,s.fAtrNum=t>>26&1,s.fAtrFnt=t>>27&1,s.fAtrAlc=t>>28&1,s.fAtrBdr=t>>29&1,s.fAtrPat=t>>30&1,s.fAtrProt=t>>31&1,s.dgLeft=15&e,s.dgRight=e>>4&15,s.dgTop=e>>8&15,s.dgBottom=e>>12&15,s.icvLeft=e>>16&127,s.icvRight=e>>23&127,s.grbitDiag=e>>30&3,s.icvTop=127&r,s.icvBottom=r>>7&127,s.icvDiag=r>>14&127,s.dgDiag=r>>21&15,s.icvFore=127&a,s.icvBack=a>>7&127,s.fsxButton=a>>14&1),s),i}},225:{f:function(e,t){return 0===t||e.read_shift(2),1200}},226:{f:Rn},227:{},229:{f:function(e,t){for(var r=[],a=e.read_shift(2);a--;)r.push(Kn(e));return r}},233:{},235:{},236:{},237:{},239:{},240:{},241:{},242:{},244:{},245:{},246:{},247:{},248:{},249:{},251:{},252:{f:function(e,t){for(var r=e.l+t,t=e.read_shift(4),a=e.read_shift(4),n=[],s=0;s!=a&&e.l<r;++s)n.push(function(e){var t=f;f=1200;var r,a=e.read_shift(2),n=4&(c=e.read_shift(1)),s=8&c,i=1+(1&c),o=0,c={};return s&&(o=e.read_shift(2)),n&&(r=e.read_shift(4)),i=2==i?"dbcs-cont":"sbcs-cont",i=0===a?"":e.read_shift(a,i),s&&(e.l+=4*o),n&&(e.l+=r),c.t=i,s||(c.raw="<t>"+c.t+"</t>",c.r=c.t),f=t,c}(e));return n.Count=t,n.Unique=a,n}},253:{f:function(e){var t=$n(e);return t.isst=e.read_shift(4),t}},255:{f:function(e,t){var r={};return r.dsst=e.read_shift(2),e.l+=t-2,r}},256:{},259:{},290:{},311:{},312:{},315:{},317:{f:Dn},318:{},319:{},320:{},330:{},331:{},333:{},334:{},335:{},336:{},337:{},338:{},339:{},340:{},351:{},352:{f:On},353:{f:Rn},401:{},402:{},403:{},404:{},405:{},406:{},407:{},408:{},425:{},426:{},427:{},428:{},429:{},430:{f:function(e,t,r){var a=e.l+t,n=e.read_shift(2),t=e.read_shift(2);if(1025==(r.sbcch=t)||14849==t)return[t,n];if(t<1||255<t)throw new Error("Unexpected SupBook type: "+t);for(var r=Mn(e,t),s=[];a>e.l;)s.push(Un(e));return[t,n,r,s]}},431:{f:On},432:{},433:{},434:{},437:{},438:{f:function(t,r,e){var a=t.l,n="";try{t.l+=4;var s=(e.lastobj||{cmo:[0,0]}).cmo[1];-1==[0,5,7,11,12,14].indexOf(s)?t.l+=6:function(e){var t=e.read_shift(1);e.l++;var r=e.read_shift(2);e.l+=2}(t);var i=t.read_shift(2);t.read_shift(2),Nn(t);s=t.read_shift(2);t.l+=s;for(var o=1;o<t.lens.length-1;++o){if(t.l-a!=t.lens[o])throw new Error("TxO: bad continue record");var c=t[t.l];if((n+=Mn(t,t.lens[o+1]-t.lens[o]-1)).length>=(c?i:2*i))break}if(n.length!==i&&n.length!==2*i)throw new Error("cchText: "+i+" != "+n.length);return t.l=a+r,{t:n}}catch(e){return t.l=a+r,{t:n}}}},439:{f:On},440:{f:function(e,t){var r=Kn(e);return e.l+=16,[r,function(e,t){var r=e.l+t;if(2!==(c=e.read_shift(4)))throw new Error("Unrecognized streamVersion: "+c);t=e.read_shift(2),e.l+=2;var a,n,s,i,o,c="";16&t&&(a=zn(e,e.l)),128&t&&(n=zn(e,e.l)),257==(257&t)&&(s=zn(e,e.l)),1==(257&t)&&(l=Hn(e,e.l)),8&t&&(c=zn(e,e.l)),32&t&&(i=e.read_shift(16)),64&t&&(o=pn(e)),e.l=r;var l=n||s||l||"";return l&&c&&(l+="#"+c),l=l||"#"+c,l={Target:l=2&t&&"/"==l.charAt(0)&&"/"!=l.charAt(1)?"file://"+l:l},i&&(l.guid=i),o&&(l.time=o),a&&(l.Tooltip=a),l}(e,t-24)]}},441:{},442:{f:Un},443:{},444:{f:Nn},445:{},446:{},448:{f:Rn},449:{f:function(e){return e.read_shift(2),e.read_shift(4)},r:2},450:{f:Rn},512:{f:os},513:{f:ws},515:{f:function(e,t,r){return r.biffguess&&2==r.biff&&(r.biff=5),r=$n(e),e=xa(e),r.val=e,r}},516:{f:function(e,t,r){return r.biffguess&&2==r.biff&&(r.biff=5),e.l,t=$n(e),2==r.biff&&e.l++,r=Un(e,e.l,r),t.val=r,t}},517:{f:ls},519:{f:Es},520:{f:function(e){var t={};t.r=e.read_shift(2),t.c=e.read_shift(2),t.cnt=e.read_shift(2)-t.c;var r=e.read_shift(2);e.l+=4;var a=e.read_shift(1);return e.l+=3,7&a&&(t.level=7&a),32&a&&(t.hidden=!0),64&a&&(t.hpt=r/20),t}},523:{},545:{f:ms},549:{f:ss},566:{},574:{f:function(e,t,r){return r&&2<=r.biff&&r.biff<5?{}:{RTL:64&e.read_shift(2)}}},638:{f:function(e){var t=e.read_shift(2),r=e.read_shift(2),e=Yn(e);return{r:t,c:r,ixfe:e[0],rknum:e[1]}}},659:{},1048:{},1054:{f:function(e,t,r){return[e.read_shift(2),Bn(e,0,r)]}},1084:{},1212:{f:function(e,t,r){var a=qn(e);e.l++;var n=e.read_shift(1);return[function(e,t,r){var a,n=e.l+t,s=e.read_shift(2),i=Ic(e,s,r);if(65535==s)return[[],Pr(e,t-2)];t!==s+2&&(a=Oc(e,n-s-2,i,r));return[i,a]}(e,t-=8,r),n,a]}},2048:{f:function(e,t){return e.read_shift(2),[Kn(e),e.read_shift((t-10)/2,"dbcs-cont").replace(de,"")]}},2049:{},2050:{},2051:{},2052:{},2053:{},2054:{},2055:{},2056:{},2057:{f:rs},2058:{},2059:{},2060:{},2061:{},2062:{},2063:{},2064:{},2066:{},2067:{},2128:{},2129:{},2130:{},2131:{},2132:{},2133:{},2134:{},2135:{},2136:{},2137:{},2138:{},2146:{},2147:{r:12},2148:{},2149:{},2150:{},2151:{f:Rn},2152:{},2154:{},2155:{},2156:{},2161:{},2162:{},2164:{},2165:{},2166:{},2167:{},2168:{},2169:{},2170:{},2171:{},2172:{f:function(e){e.l+=2;var t={cxfs:0,crc:0};return t.cxfs=e.read_shift(2),t.crc=e.read_shift(4),t},r:12},2173:{f:function(e,t){e.l,e.l+=2,t=e.read_shift(2),e.l+=2;for(var r=e.read_shift(2),a=[];0<r--;)a.push(Ko(e,e.l));return{ixfe:t,ext:a}},r:12},2174:{},2175:{},2180:{},2181:{},2182:{},2183:{},2184:{},2185:{},2186:{},2187:{},2188:{f:On,r:12},2189:{},2190:{r:12},2191:{},2192:{},2194:{},2195:{},2196:{f:function(e,t,r){if(!(r.biff<8)){var a=e.read_shift(2),n=e.read_shift(2);return[Mn(e,a,r),Mn(e,n,r)]}e.l+=t},r:12},2197:{},2198:{f:function(e,t,r){var a=e.l+t;if(124226!==e.read_shift(4))if(r.cellStyles){var n,s=e.slice(e.l);e.l=a;try{n=st(s,{type:"array"})}catch(e){return}t=tt(n,"theme/theme/theme1.xml",!0);if(t)return $o(t,r)}else e.l=a},r:12},2199:{},2200:{},2201:{},2202:{f:function(e){return[0!==e.read_shift(4),0!==e.read_shift(4),e.read_shift(4)]},r:12},2203:{f:Rn},2204:{},2205:{},2206:{},2207:{},2211:{f:function(e){var t,r,a=(r=(t=e).read_shift(2),a=t.read_shift(2),t.l+=8,{type:r,flags:a});if(2211!=a.type)throw new Error("Invalid Future Record "+a.type);return 0!==e.read_shift(4)}},2212:{},2213:{},2214:{},2215:{},4097:{},4098:{},4099:{},4102:{},4103:{},4105:{},4106:{},4107:{},4108:{},4109:{},4116:{},4117:{},4118:{},4119:{},4120:{},4121:{},4122:{},4123:{},4124:{},4125:{},4126:{},4127:{},4128:{},4129:{},4130:{},4132:{},4133:{},4134:{f:Nn},4135:{},4146:{},4147:{},4148:{},4149:{},4154:{},4156:{},4157:{},4158:{},4159:{},4160:{},4161:{},4163:{},4164:{f:function(e,t,r){var a={area:!1};return 5!=r.biff?e.l+=t:(t=e.read_shift(1),e.l+=3,16&t&&(a.area=!0)),a}},4165:{},4166:{},4168:{},4170:{},4171:{},4174:{},4175:{},4176:{},4177:{},4187:{},4188:{f:function(e){for(var t=e.read_shift(2),r=[];0<t--;)r.push(jn(e));return r}},4189:{},4191:{},4192:{},4193:{},4194:{},4195:{},4196:{},4197:{},4198:{},4199:{},4200:{},0:{f:os},1:{},2:{f:function(e){var t=$n(e);return++e.l,e=e.read_shift(2),t.t="n",t.val=e,t}},3:{f:function(e){var t=$n(e);return++e.l,e=xa(e),t.t="n",t.val=e,t}},4:{f:function(e,t,r){r.biffguess&&5==r.biff&&(r.biff=2);var a=$n(e);return++e.l,r=Bn(e,0,r),a.t="str",a.val=r,a}},5:{f:ls},7:{f:function(e){var t=e.read_shift(1);return 0===t?(e.l++,""):e.read_shift(t,"sbcs-cont")}},8:{},9:{f:rs},11:{},22:{f:Nn},30:{f:is},31:{},32:{},33:{f:ms},36:{},37:{f:ss},50:{f:function(e,t){e.l+=6,e.l+=2,e.l+=1,e.l+=3,e.l+=1,e.l+=t-13}},62:{},52:{},67:{},68:{f:Nn},69:{},86:{},126:{},127:{f:function(e){var t=e.read_shift(2),r=e.read_shift(2),a=e.read_shift(4),r={fmt:t,env:r,len:a,data:e.slice(e.l,e.l+a)};return e.l+=a,r}},135:{},136:{},137:{},145:{},148:{},149:{},150:{},169:{},171:{},188:{},191:{},192:{},194:{},195:{},214:{f:function(e,t,r){var a=e.l+t,n=$n(e),t=e.read_shift(2),r=Mn(e,t,r);return e.l=a,n.t="str",n.val=r,n}},223:{},234:{},354:{},421:{},518:{f:Lc},521:{f:rs},536:{f:ds},547:{f:hs},561:{},579:{},1030:{f:Lc},1033:{f:rs},1091:{},2157:{},2163:{},2177:{},2240:{},2241:{},2242:{},2243:{},2244:{},2245:{},2246:{},2247:{},2248:{},2249:{},2250:{},2251:{},2262:{r:12},29282:{}};function Lf(e,t,r,a){var n=t;isNaN(n)||(t=a||(r||[]).length||0,(a=e.next(4)).write_shift(2,n),a.write_shift(2,t),0<t&&Er(r)&&e.push(r))}function Mf(e,t,r){return(e=e||Lr(7)).write_shift(2,t),e.write_shift(2,r),e.write_shift(2,0),e.write_shift(1,0),e}function Uf(e,t,r,a){if(null!=t.v)switch(t.t){case"d":case"n":var n="d"==t.t?De(He(t.v)):t.v;return void(n==(0|n)&&0<=n&&n<65536?Lf(e,2,(f=r,h=a,u=n,Mf(d=Lr(9),f,h),d.write_shift(2,u),d)):Lf(e,3,(u=r,d=a,n=n,Mf(l=Lr(15),u,d),l.write_shift(8,n,"f"),l)));case"b":case"e":return void Lf(e,5,(l=r,s=a,i=t.v,o=t.t,Mf(c=Lr(9),l,s),Pn(i,o||"b",c),c));case"s":case"str":return void Lf(e,4,(s=r,i=a,o=(t.v||"").slice(0,255),Mf(c=Lr(8+2*o.length),s,i),c.write_shift(1,o.length),c.write_shift(o.length,o,"sbcs"),c.l<c.length?c.slice(0,c.l):c))}var s,i,o,c,l,f,h,u,d;Lf(e,1,Mf(null,r,a))}function Bf(e,t){var r=t||{};null!=oe&&null==r.dense&&(r.dense=oe);for(var t=Ur(),a=0,n=0;n<e.SheetNames.length;++n)e.SheetNames[n]==r.sheet&&(a=n);if(0==a&&r.sheet&&e.SheetNames[0]!=r.sheet)throw new Error("Sheet not found: "+r.sheet);return Lf(t,4==r.biff?1033:3==r.biff?521:9,as(0,16,r)),function(e,t,r){var a,n,s=Array.isArray(t),i=Zr(t["!ref"]||"A1"),o=[];if(255<i.e.c||16383<i.e.r){if(r.WTF)throw new Error("Range "+(t["!ref"]||"A1")+" exceeds format limit A1:IV16384");i.e.c=Math.min(i.e.c,255),i.e.r=Math.min(i.e.c,16383),a=qr(i)}for(var c=i.s.r;c<=i.e.r;++c){n=jr(c);for(var l=i.s.c;l<=i.e.c;++l){c===i.s.r&&(o[l]=Xr(l)),a=o[l]+n;var f=s?(t[c]||[])[l]:t[a];f&&Uf(e,f,c,l)}}}(t,e.Sheets[e.SheetNames[a]],r),Lf(t,10),t.end()}function Wf(e,t,r){var a,n;Lf(e,49,(n=(a={sz:12,color:{theme:1},name:"Arial",family:2,scheme:"minor"}).name||"Arial",(e=Lr((r=(e=r)&&5==e.biff)?15+n.length:16+2*n.length)).write_shift(2,20*(a.sz||12)),e.write_shift(4,0),e.write_shift(2,400),e.write_shift(4,0),e.write_shift(2,0),e.write_shift(1,n.length),r||e.write_shift(1,1),e.write_shift((r?1:2)*n.length,n,r?"sbcs":"utf16le"),e))}function Hf(i,o,c){o&&[[5,8],[23,26],[41,44],[50,392]].forEach(function(e){for(var t,r,a,n,s=e[0];s<=e[1];++s)null!=o[s]&&Lf(i,1054,(t=s,r=o[s],n=void 0,a=(a=c)&&5==a.biff,(n=n||Lr(a?3+r.length:5+2*r.length)).write_shift(2,t),n.write_shift(a?1:2,r.length),a||n.write_shift(1,1),n.write_shift((a?1:2)*r.length,r,a?"sbcs":"utf16le"),null==(n=n.length>n.l?n.slice(0,n.l):n).l&&(n.l=n.length),n))})}function zf(e,t){for(var r=0;r<t["!links"].length;++r){var a=t["!links"][r];Lf(e,440,bs(a)),a[1].Tooltip&&Lf(e,2048,function(e){var t=e[1].Tooltip,r=Lr(10+2*(t.length+1));r.write_shift(2,2048),e=Yr(e[0]),r.write_shift(2,e.r),r.write_shift(2,e.r),r.write_shift(2,e.c),r.write_shift(2,e.c);for(var a=0;a<t.length;++a)r.write_shift(2,t.charCodeAt(a));return r.write_shift(2,0),r}(a))}delete t["!links"]}function Vf(a,e){var n;e&&(n=0,e.forEach(function(e,t){var r;++n<=256&&e&&Lf(a,125,(r=Zc(t,e),e=t,(t=Lr(12)).write_shift(2,e),t.write_shift(2,e),t.write_shift(2,256*r.width),t.write_shift(2,0),e=0,r.hidden&&(e|=1),t.write_shift(1,e),e=r.level||0,t.write_shift(1,e),t.write_shift(2,0),t))}))}function Gf(e,t,r,a,n){var s,i,o,c,l,f,h,u,d,p,m,g=16+el(n.cellXfs,t,n);if(null!=t.v||t.bf)if(t.bf)Lf(e,6,Mc(t,r,a,0,g));else switch(t.t){case"d":case"n":var b="d"==t.t?De(He(t.v)):t.v;Lf(e,515,(f=r,h=a,u=b,d=g,p=Lr(14),Xn(f,h,d,p),Aa(u,p),p));break;case"b":case"e":Lf(e,517,(b=r,f=a,h=t.v,d=g,u=t.t,p=Lr(8),Xn(b,f,d,p),Pn(h,u,p),p));break;case"s":case"str":n.bookSST?(m=qc(n.Strings,t.v,n.revStrings),Lf(e,253,(s=r,i=a,o=m,c=g,l=Lr(10),Xn(s,i,c,l),l.write_shift(4,o),l))):Lf(e,516,(m=r,s=a,i=(t.v||"").slice(0,255),c=g,o=Lr(+(l=!(o=n)||8==o.biff)+8+(1+l)*i.length),Xn(m,s,c,o),o.write_shift(2,i.length),l&&o.write_shift(1,1),o.write_shift((1+l)*i.length,i,l?"utf16le":"sbcs"),o));break;default:Lf(e,513,Xn(r,a,g))}else Lf(e,513,Xn(r,a,g))}function jf(e,t,r){var a,n,s=Ur(),i=r.SheetNames[e],o=r.Sheets[i]||{},c=(r||{}).Workbook||{},l=(c.Sheets||[])[e]||{},f=Array.isArray(o),h=8==t.biff,u=[],d=Zr(o["!ref"]||"A1"),p=h?65536:16384;if(255<d.e.c||d.e.r>=p){if(t.WTF)throw new Error("Range "+(o["!ref"]||"A1")+" exceeds format limit A1:IV16384");d.e.c=Math.min(d.e.c,255),d.e.r=Math.min(d.e.c,p-1)}Lf(s,2057,as(0,16,t)),Lf(s,13,Fn(1)),Lf(s,12,Fn(100)),Lf(s,15,In(!0)),Lf(s,17,In(!1)),Lf(s,16,Aa(.001)),Lf(s,95,In(!0)),Lf(s,42,In(!1)),Lf(s,43,In(!1)),Lf(s,130,Fn(1)),Lf(s,128,(r=[0,0],(e=Lr(8)).write_shift(4,0),e.write_shift(2,r[0]?r[0]+1:0),e.write_shift(2,r[1]?r[1]+1:0),e)),Lf(s,131,In(!1)),Lf(s,132,In(!1)),h&&Vf(s,o["!cols"]),Lf(s,512,(p=d,(r=Lr(2*(e=8!=(r=t).biff&&r.biff?2:4)+6)).write_shift(e,p.s.r),r.write_shift(e,p.e.r+1),r.write_shift(2,p.s.c),r.write_shift(2,p.e.c+1),r.write_shift(2,0),r)),h&&(o["!links"]=[]);for(var m=d.s.r;m<=d.e.r;++m){n=jr(m);for(var g=d.s.c;g<=d.e.c;++g){m===d.s.r&&(u[g]=Xr(g)),a=u[g]+n;var b=f?(o[m]||[])[g]:o[a];b&&(Gf(s,b,m,g,t),h&&b.l&&o["!links"].push([a,b.l]))}}var v,w,i=l.CodeName||l.name||i;return h&&Lf(s,574,(c=(c.Views||[])[0],w=Lr(18),v=1718,c&&c.RTL&&(v|=64),w.write_shift(2,v),w.write_shift(4,0),w.write_shift(4,64),w.write_shift(4,0),w.write_shift(4,0),w)),h&&(o["!merges"]||[]).length&&Lf(s,229,function(e){var t=Lr(2+8*e.length);t.write_shift(2,e.length);for(var r=0;r<e.length;++r)Jn(e[r],t);return t}(o["!merges"])),h&&zf(s,o),Lf(s,442,Wn(i)),h&&(v=s,w=o,(i=Lr(19)).write_shift(4,2151),i.write_shift(4,0),i.write_shift(4,0),i.write_shift(2,3),i.write_shift(1,1),i.write_shift(4,0),Lf(v,2151,i),(i=Lr(39)).write_shift(4,2152),i.write_shift(4,0),i.write_shift(4,0),i.write_shift(2,3),i.write_shift(1,0),i.write_shift(4,0),i.write_shift(2,1),i.write_shift(4,4),i.write_shift(2,0),Jn(Zr(w["!ref"]||"A1"),i),i.write_shift(4,4),Lf(v,2152,i)),Lf(s,10),s.end()}function $f(e,t,r){var a=Ur(),n=(e||{}).Workbook||{},s=n.Sheets||[],i=n.WBProps||{},o=8==r.biff,n=5==r.biff;Lf(a,2057,as(0,5,r)),"xla"==r.bookType&&Lf(a,135),Lf(a,225,o?Fn(1200):null),Lf(a,193,function(e,t){t=t||Lr(e);for(var r=0;r<e;++r)t.write_shift(1,0);return t}(2)),n&&Lf(a,191),n&&Lf(a,192),Lf(a,226),Lf(a,92,function(e){var t=!e||8==e.biff,r=Lr(t?112:54);for(r.write_shift(8==e.biff?2:1,7),t&&r.write_shift(1,0),r.write_shift(4,859007059),r.write_shift(4,5458548|(t?0:536870912));r.l<r.length;)r.write_shift(1,t?0:32);return r}(r)),Lf(a,66,Fn(o?1200:1252)),o&&Lf(a,353,Fn(0)),o&&Lf(a,448),Lf(a,317,function(e){for(var t=Lr(2*e),r=0;r<e;++r)t.write_shift(2,r+1);return t}(e.SheetNames.length)),o&&e.vbaraw&&Lf(a,211),o&&e.vbaraw&&Lf(a,442,Wn(i.CodeName||"ThisWorkbook")),Lf(a,156,Fn(17)),Lf(a,25,In(!1)),Lf(a,18,In(!1)),Lf(a,19,Fn(0)),o&&Lf(a,431,In(!1)),o&&Lf(a,444,Fn(0)),Lf(a,61,((n=Lr(18)).write_shift(2,0),n.write_shift(2,0),n.write_shift(2,29280),n.write_shift(2,17600),n.write_shift(2,56),n.write_shift(2,0),n.write_shift(2,0),n.write_shift(2,1),n.write_shift(2,500),n)),Lf(a,64,In(!1)),Lf(a,141,Fn(0)),Lf(a,34,In("true"==((i=e).Workbook&&i.Workbook.WBProps&&Rt(i.Workbook.WBProps.date1904)?"true":"false"))),Lf(a,14,In(!0)),o&&Lf(a,439,In(!1)),Lf(a,218,Fn(0)),Wf(a,0,r),Hf(a,e.SSF,r),function(t,r){for(var e=0;e<16;++e)Lf(t,224,cs({numFmtId:0,style:!0},0,r));r.cellXfs.forEach(function(e){Lf(t,224,cs(e,0,r))})}(a,r),o&&Lf(a,352,In(!1));n=a.end(),i=Ur();o&&Lf(i,140,((g=g||Lr(4)).write_shift(2,1),g.write_shift(2,1),g)),o&&r.Strings&&function(e,t,r){var a=void 0||(r||[]).length||0;if(a<=8224)return Lf(e,t,r,a);if(!isNaN(t)){for(var n=r.parts||[],s=0,i=0,o=0;o+(n[s]||8224)<=8224;)o+=n[s]||8224,s++;var c=e.next(4);for(c.write_shift(2,t),c.write_shift(2,o),e.push(r.slice(i,i+o)),i+=o;i<a;){for((c=e.next(4)).write_shift(2,60),o=0;o+(n[s]||8224)<=8224;)o+=n[s]||8224,s++;c.write_shift(2,o),e.push(r.slice(i,i+o)),i+=o}}}(i,252,ns(r.Strings)),Lf(i,10);for(var a=i.end(),c=Ur(),l=0,f=0,f=0;f<e.SheetNames.length;++f)l+=(o?12:11)+(o?2:1)*e.SheetNames[f].length;var h,u,d,p,m=n.length+l+a.length;for(f=0;f<e.SheetNames.length;++f)Lf(c,133,(h={pos:m,hs:(s[f]||{}).Hidden||0,dt:0,name:e.SheetNames[f]},p=d=void 0,d=!(u=r)||8<=u.biff?2:1,(p=Lr(8+d*h.name.length)).write_shift(4,h.pos),p.write_shift(1,h.hs||0),p.write_shift(1,h.dt),p.write_shift(1,h.name.length),8<=u.biff&&p.write_shift(1,1),p.write_shift(d*h.name.length,h.name,u.biff<8?"sbcs":"utf16le"),(u=p.slice(0,p.l)).l=p.l,u)),m+=t[f].length;var g=c.end();if(l!=g.length)throw new Error("BS8 "+l+" != "+g.length);i=[];return n.length&&i.push(n),g.length&&i.push(g),a.length&&i.push(a),ue(i)}function Xf(e,t){for(var r=0;r<=e.SheetNames.length;++r){var a=e.Sheets[e.SheetNames[r]];a&&a["!ref"]&&255<Jr(a["!ref"]).e.c&&"undefined"!=typeof console&&console.error&&console.error("Worksheet '"+e.SheetNames[r]+"' extends beyond column IV (255).  Data may be lost.")}var n=t||{};switch(n.biff||2){case 8:case 5:return function(e,t){var r=t||{},a=[];e&&!e.SSF&&(e.SSF=Ve(me)),e&&e.SSF&&(Ee(),Te(e.SSF),r.revssf=Ne(e.SSF),r.revssf[e.SSF[65535]]=0,r.ssf=e.SSF),r.Strings=[],r.Strings.Count=0,r.Strings.Unique=0,Uh(r),r.cellXfs=[],el(r.cellXfs,{},{revssf:{General:0}}),e.Props||(e.Props={});for(var n=0;n<e.SheetNames.length;++n)a[a.length]=jf(n,r,e);return a.unshift($f(e,a,r)),ue(a)}(e,t);case 4:case 3:case 2:return Bf(e,t)}throw new Error("invalid type "+n.bookType+" for BIFF")}function Yf(e,t){var r=t||{};null!=oe&&null==r.dense&&(r.dense=oe);var a=r.dense?[]:{},n=(e=e.replace(/<!--.*?-->/g,"")).match(/<table/i);if(!n)throw new Error("Invalid HTML: could not find <table>");for(var s,t=e.match(/<\/table/i),i=n.index,o=t&&t.index||e.length,c=Ke(e.slice(i,o),/(:?<tr[^>]*>)/i,"<tr>"),l=-1,f=0,h={s:{r:1e7,c:1e7},e:{r:0,c:0}},u=[],i=0;i<c.length;++i){var d=c[i].trim(),p=d.slice(0,3).toLowerCase();if("<tr"!=p){if("<td"==p||"<th"==p)for(var m=d.split(/<\/t[dh]>/i),o=0;o<m.length;++o){var g=m[o].trim();if(g.match(/<t[dh]/i)){for(var b=g,v=0;"<"==b.charAt(0)&&-1<(v=b.indexOf(">"));)b=b.slice(v+1);for(var w=0;w<u.length;++w){var T=u[w];T.s.c==f&&T.s.r<l&&l<=T.e.r&&(f=T.e.c+1,w=-1)}var E=dt(g.slice(0,g.indexOf(">"))),k=E.colspan?+E.colspan:1;(1<(s=+E.rowspan)||1<k)&&u.push({s:{r:l,c:f},e:{r:l+(s||1)-1,c:f+k-1}});g=E.t||E["data-t"]||"";b.length&&(b=Wt(b),h.s.r>l&&(h.s.r=l),h.e.r<l&&(h.e.r=l),h.s.c>f&&(h.s.c=f),h.e.c<f&&(h.e.c=f),b.length&&(E={t:"s",v:b},r.raw||!b.trim().length||"s"==g||("TRUE"===b?E={t:"b",v:!0}:"FALSE"===b?E={t:"b",v:!1}:isNaN(je(b))?isNaN(Xe(b).getDate())||(E={t:"d",v:He(b)},(E=!r.cellDates?{t:"n",v:De(E.v)}:E).z=r.dateNF||me[14]):E={t:"n",v:je(b)}),r.dense?(a[l]||(a[l]=[]),a[l][f]=E):a[Kr({r:l,c:f})]=E)),f+=k}}}else{if(++l,r.sheetRows&&r.sheetRows<=l){--l;break}f=0}}return a["!ref"]=qr(h),u.length&&(a["!merges"]=u),a}function Kf(e,t,r,a){for(var n=e["!merges"]||[],s=[],i=t.s.c;i<=t.e.c;++i){for(var o,c,l,f,h=0,u=0,d=0;d<n.length;++d)if(!(n[d].s.r>r||n[d].s.c>i||n[d].e.r<r||n[d].e.c<i)){if(n[d].s.r<r||n[d].s.c<i){h=-1;break}h=n[d].e.r-n[d].s.r+1,u=n[d].e.c-n[d].s.c+1;break}h<0||(o=Kr({r:r,c:i}),l=(c=a.dense?(e[r]||[])[i]:e[o])&&null!=c.v&&(c.h||_t(c.w||(ea(c),c.w)||""))||"",f={},1<h&&(f.rowspan=h),1<u&&(f.colspan=u),a.editable?l='<span contenteditable="true">'+l+"</span>":c&&(f["data-t"]=c&&c.t||"z",null!=c.v&&(f["data-v"]=c.v),null!=c.z&&(f["data-z"]=c.z),c.l&&"#"!=(c.l.Target||"#").charAt(0)&&(l='<a href="'+c.l.Target+'">'+l+"</a>")),f.id=(a.id||"sjs")+"-"+o,s.push(Yt("td",l,f)))}return"<tr>"+s.join("")+"</tr>"}var Jf='<html><head><meta charset="utf-8"/><title>SheetJS Table Export</title></head><body>',qf="</body></html>";function Zf(e,t,r){return[].join("")+"<table"+(r&&r.id?' id="'+r.id+'"':"")+">"}function Qf(e,t){var r=t||{},a=null!=r.header?r.header:Jf,t=null!=r.footer?r.footer:qf,n=[a],s=Jr(e["!ref"]);r.dense=Array.isArray(e),n.push(Zf(0,0,r));for(var i=s.s.r;i<=s.e.r;++i)n.push(Kf(e,s,i,r));return n.push("</table>"+t),n.join("")}function eh(e,t,r){var a=r||{};null!=oe&&(a.dense=oe);var n=0,s=0;null!=a.origin&&("number"==typeof a.origin?n=a.origin:(n=(r="string"==typeof a.origin?Yr(a.origin):a.origin).r,s=r.c));var i=t.getElementsByTagName("tr"),o=Math.min(a.sheetRows||1e7,i.length),c={s:{r:0,c:0},e:{r:n,c:s}};e["!ref"]&&(t=Jr(e["!ref"]),c.s.r=Math.min(c.s.r,t.s.r),c.s.c=Math.min(c.s.c,t.s.c),c.e.r=Math.max(c.e.r,t.e.r),c.e.c=Math.max(c.e.c,t.e.c),-1==n&&(c.e.r=n=t.e.r+1));var l,f,h=[],u=0,d=e["!rows"]||(e["!rows"]=[]),p=0,m=0,g=0,b=0;for(e["!cols"]||(e["!cols"]=[]);p<i.length&&m<o;++p){var v=i[p];if(rh(v)){if(a.display)continue;d[m]={hidden:!0}}for(var w=v.children,g=b=0;g<w.length;++g){var T=w[g];if(!a.display||!rh(T)){for(var E=T.hasAttribute("data-v")?T.getAttribute("data-v"):T.hasAttribute("v")?T.getAttribute("v"):Wt(T.innerHTML),k=T.getAttribute("data-z")||T.getAttribute("z"),u=0;u<h.length;++u){var y=h[u];y.s.c==b+s&&y.s.r<m+n&&m+n<=y.e.r&&(b=y.e.c+1-s,u=-1)}f=+T.getAttribute("colspan")||1,(1<(l=+T.getAttribute("rowspan")||1)||1<f)&&h.push({s:{r:m+n,c:b+s},e:{r:m+n+(l||1)-1,c:b+s+(f||1)-1}});var S={t:"s",v:E},_=T.getAttribute("data-t")||T.getAttribute("t")||"";null!=E&&(0==E.length?S.t=_||"z":a.raw||0==E.trim().length||"s"==_||("TRUE"===E?S={t:"b",v:!0}:"FALSE"===E?S={t:"b",v:!1}:isNaN(je(E))?isNaN(Xe(E).getDate())||(S={t:"d",v:He(E)},(S=!a.cellDates?{t:"n",v:De(S.v)}:S).z=a.dateNF||me[14]):S={t:"n",v:je(E)})),void 0===S.z&&null!=k&&(S.z=k);var x="",A=T.getElementsByTagName("A");if(A&&A.length)for(var C=0;C<A.length&&(!A[C].hasAttribute("href")||"#"==(x=A[C].getAttribute("href")).charAt(0));++C);x&&"#"!=x.charAt(0)&&(S.l={Target:x}),a.dense?(e[m+n]||(e[m+n]=[]),e[m+n][b+s]=S):e[Kr({c:b+s,r:m+n})]=S,c.e.c<b+s&&(c.e.c=b+s),b+=f}}++m}return h.length&&(e["!merges"]=(e["!merges"]||[]).concat(h)),c.e.r=Math.max(c.e.r,m-1+n),e["!ref"]=qr(c),o<=m&&(e["!fullref"]=qr((c.e.r=i.length-p+m-1+n,c))),e}function th(e,t){return eh((t||{}).dense?[]:{},e,t)}function rh(e){var t,r="",t=(t=e).ownerDocument.defaultView&&"function"==typeof t.ownerDocument.defaultView.getComputedStyle?t.ownerDocument.defaultView.getComputedStyle:"function"==typeof getComputedStyle?getComputedStyle:null;return"none"===(r=(r=t?t(e).getPropertyValue("display"):r)||e.style&&e.style.display)}var ah={day:["d","dd"],month:["m","mm"],year:["y","yy"],hours:["h","hh"],minutes:["m","mm"],seconds:["s","ss"],"am-pm":["A/P","AM/PM"],"day-of-week":["ddd","dddd"],era:["e","ee"],quarter:["\\Qm",'m\\"th quarter"']};function nh(e,t){var r=t||{};null!=oe&&null==r.dense&&(r.dense=oe);var a,n,s,i,o,c=Jt(e),l=[],f={name:""},h="",u=0,d={},p=[],m=r.dense?[]:{},g={value:""},b="",v=0,w=[],T=-1,E=-1,k={s:{r:1e6,c:1e7},e:{r:0,c:0}},y=0,S={},_=[],x={},A=[],C=1,R=1,O=[],I={Names:[]},N={},F=["",""],D=[],P={},L="",M=0,U=!1,B=!1,W=0;for(qt.lastIndex=0,c=c.replace(/<!--([\s\S]*?)-->/gm,"").replace(/<!DOCTYPE[^\[]*\[[^\]]*\]>/gm,"");i=qt.exec(c);)switch(i[3]=i[3].replace(/_.*$/,"")){case"table":case"工作表":"/"===i[1]?(k.e.c>=k.s.c&&k.e.r>=k.s.r?m["!ref"]=qr(k):m["!ref"]="A1:A1",0<r.sheetRows&&r.sheetRows<=k.e.r&&(m["!fullref"]=m["!ref"],k.e.r=r.sheetRows-1,m["!ref"]=qr(k)),_.length&&(m["!merges"]=_),A.length&&(m["!rows"]=A),s.name=s["名称"]||s.name,"undefined"!=typeof JSON&&JSON.stringify(s),p.push(s.name),d[s.name]=m,B=!1):"/"!==i[0].charAt(i[0].length-2)&&(s=dt(i[0],!1),T=E=-1,k.s.r=k.s.c=1e7,k.e.r=k.e.c=0,m=r.dense?[]:{},_=[],A=[],B=!0);break;case"table-row-group":"/"===i[1]?--y:++y;break;case"table-row":case"行":if("/"===i[1]){T+=C,C=1;break}if((H=dt(i[0],!1))["行号"]?T=H["行号"]-1:-1==T&&(T=0),(C=+H["number-rows-repeated"]||1)<10)for(W=0;W<C;++W)0<y&&(A[T+W]={level:y});E=-1;break;case"covered-table-cell":"/"!==i[1]&&++E,r.sheetStubs&&(r.dense?(m[T]||(m[T]=[]),m[T][E]={t:"z"}):m[Kr({r:T,c:E})]={t:"z"}),b="",w=[];break;case"table-cell":case"数据":if("/"===i[0].charAt(i[0].length-2))++E,g=dt(i[0],!1),R=parseInt(g["number-columns-repeated"]||"1",10),o={t:"z",v:null},g.formula&&0!=r.cellFormula&&(o.f=$c(wt(g.formula))),"string"==(g["数据类型"]||g["value-type"])&&(o.t="s",o.v=wt(g["string-value"]||""),r.dense?(m[T]||(m[T]=[]),m[T][E]=o):m[Kr({r:T,c:E})]=o),E+=R-1;else if("/"!==i[1]){b="",v=0,w=[],R=1;var H=C?T+C-1:T;if(++E>k.e.c&&(k.e.c=E),E<k.s.c&&(k.s.c=E),T<k.s.r&&(k.s.r=T),H>k.e.r&&(k.e.r=H),D=[],P={},o={t:(g=dt(i[0],!1))["数据类型"]||g["value-type"],v:null},r.cellFormula)if(g.formula&&(g.formula=wt(g.formula)),g["number-matrix-columns-spanned"]&&g["number-matrix-rows-spanned"]&&(x={s:{r:T,c:E},e:{r:T+(parseInt(g["number-matrix-rows-spanned"],10)||0)-1,c:E+(parseInt(g["number-matrix-columns-spanned"],10)||0)-1}},o.F=qr(x),O.push([x,o.F])),g.formula)o.f=$c(g.formula);else for(W=0;W<O.length;++W)T>=O[W][0].s.r&&T<=O[W][0].e.r&&E>=O[W][0].s.c&&E<=O[W][0].e.c&&(o.F=O[W][1]);switch((g["number-columns-spanned"]||g["number-rows-spanned"])&&(x={s:{r:T,c:E},e:{r:T+(parseInt(g["number-rows-spanned"],10)||0)-1,c:E+(parseInt(g["number-columns-spanned"],10)||0)-1}},_.push(x)),g["number-columns-repeated"]&&(R=parseInt(g["number-columns-repeated"],10)),o.t){case"boolean":o.t="b",o.v=Rt(g["boolean-value"]);break;case"float":case"percentage":case"currency":o.t="n",o.v=parseFloat(g.value);break;case"date":o.t="d",o.v=He(g["date-value"]),r.cellDates||(o.t="n",o.v=De(o.v)),o.z="m/d/yy";break;case"time":o.t="n",o.v=function(e){var t=0,r=0,a=!1,n=e.match(/P([0-9\.]+Y)?([0-9\.]+M)?([0-9\.]+D)?T([0-9\.]+H)?([0-9\.]+M)?([0-9\.]+S)?/);if(!n)throw new Error("|"+e+"| is not an ISO8601 Duration");for(var s=1;s!=n.length;++s)if(n[s]){switch(r=1,3<s&&(a=!0),n[s].slice(n[s].length-1)){case"Y":throw new Error("Unsupported ISO Duration Field: "+n[s].slice(n[s].length-1));case"D":r*=24;case"H":r*=60;case"M":if(!a)throw new Error("Unsupported ISO Duration Field: M");r*=60}t+=r*parseInt(n[s],10)}return t}(g["time-value"])/86400,r.cellDates&&(o.t="d",o.v=Me(o.v)),o.z="HH:MM:SS";break;case"number":o.t="n",o.v=parseFloat(g["数据数值"]);break;default:if("string"!==o.t&&"text"!==o.t&&o.t)throw new Error("Unsupported value type "+o.t);o.t="s",null!=g["string-value"]&&(b=wt(g["string-value"]),w=[])}}else{if(U=!1,"s"===o.t&&(o.v=b||"",w.length&&(o.R=w),U=0==v),N.Target&&(o.l=N),0<D.length&&(o.c=D,D=[]),b&&!1!==r.cellText&&(o.w=b),U&&(o.t="z",delete o.v),(!U||r.sheetStubs)&&!(r.sheetRows&&r.sheetRows<=T))for(var z=0;z<C;++z){if(R=parseInt(g["number-columns-repeated"]||"1",10),r.dense)for(m[T+z]||(m[T+z]=[]),m[T+z][E]=0==z?o:Ve(o);0<--R;)m[T+z][E+R]=Ve(o);else for(m[Kr({r:T+z,c:E})]=o;0<--R;)m[Kr({r:T+z,c:E+R})]=Ve(o);k.e.c<=E&&(k.e.c=E)}E+=(R=parseInt(g["number-columns-repeated"]||"1",10))-1,R=0,o={},b="",w=[]}N={};break;case"document":case"document-content":case"电子表格文档":case"spreadsheet":case"主体":case"scripts":case"styles":case"font-face-decls":case"master-styles":if("/"===i[1]){if((a=l.pop())[0]!==i[3])throw"Bad state: "+a}else"/"!==i[0].charAt(i[0].length-2)&&l.push([i[3],!0]);break;case"annotation":if("/"===i[1]){if((a=l.pop())[0]!==i[3])throw"Bad state: "+a;P.t=b,w.length&&(P.R=w),P.a=L,D.push(P)}else"/"!==i[0].charAt(i[0].length-2)&&l.push([i[3],!1]);b=L="",v=M=0,w=[];break;case"creator":"/"===i[1]?L=c.slice(M,i.index):M=i.index+i[0].length;break;case"meta":case"元数据":case"settings":case"config-item-set":case"config-item-map-indexed":case"config-item-map-entry":case"config-item-map-named":case"shapes":case"frame":case"text-box":case"image":case"data-pilot-tables":case"list-style":case"form":case"dde-links":case"event-listeners":case"chart":if("/"===i[1]){if((a=l.pop())[0]!==i[3])throw"Bad state: "+a}else"/"!==i[0].charAt(i[0].length-2)&&l.push([i[3],!1]);b="",v=0,w=[];break;case"scientific-number":case"currency-symbol":case"currency-style":break;case"number-style":case"percentage-style":case"date-style":case"time-style":if("/"===i[1]){if(S[f.name]=h,(a=l.pop())[0]!==i[3])throw"Bad state: "+a}else"/"!==i[0].charAt(i[0].length-2)&&(h="",f=dt(i[0],!1),l.push([i[3],!0]));break;case"script":case"libraries":case"automatic-styles":break;case"default-style":case"page-layout":case"style":case"map":case"font-face":case"paragraph-properties":case"table-properties":case"table-column-properties":case"table-row-properties":case"table-cell-properties":break;case"number":switch(l[l.length-1][0]){case"time-style":case"date-style":n=dt(i[0],!1),h+=ah[i[3]]["long"===n.style?1:0]}break;case"fraction":break;case"day":case"month":case"year":case"era":case"day-of-week":case"week-of-year":case"quarter":case"hours":case"minutes":case"seconds":case"am-pm":switch(l[l.length-1][0]){case"time-style":case"date-style":n=dt(i[0],!1),h+=ah[i[3]]["long"===n.style?1:0]}break;case"boolean-style":case"boolean":case"text-style":break;case"text":if("/>"===i[0].slice(-2))break;if("/"===i[1])switch(l[l.length-1][0]){case"number-style":case"date-style":case"time-style":h+=c.slice(u,i.index)}else u=i.index+i[0].length;break;case"named-range":F=Xc((n=dt(i[0],!1))["cell-range-address"]);var V={Name:n.name,Ref:F[0]+"!"+F[1]};B&&(V.Sheet=p.length),I.Names.push(V);break;case"text-content":case"text-properties":case"embedded-text":break;case"body":case"电子表格":case"forms":case"table-column":case"table-header-rows":case"table-rows":case"table-column-group":case"table-header-columns":case"table-columns":case"null-date":case"graphic-properties":case"calculation-settings":case"named-expressions":case"label-range":case"label-ranges":case"named-expression":case"sort":case"sort-by":case"sort-groups":case"tab":case"line-break":case"span":break;case"p":case"文本串":if(-1<["master-styles"].indexOf(l[l.length-1][0]))break;"/"!==i[1]||g&&g["string-value"]?(dt(i[0],!1),v=i.index+i[0].length):(V=(V=c.slice(v,i.index)).replace(/[\t\r\n]/g," ").trim().replace(/ +/g," ").replace(/<text:s\/>/g," ").replace(/<text:s text:c="(\d+)"\/>/g,function(e,t){return Array(parseInt(t,10)+1).join(" ")}).replace(/<text:tab[^>]*\/>/g,"\t").replace(/<text:line-break\/>/g,"\n"),V=[wt(V.replace(/<[^>]*>/g,""))],b=(0<b.length?b+"\n":"")+V[0]);break;case"s":break;case"database-range":if("/"===i[1])break;try{d[(F=Xc(dt(i[0])["target-range-address"]))[0]]["!autofilter"]={ref:F[1]}}catch(e){}break;case"date":case"object":break;case"title":case"标题":case"desc":case"binary-data":case"table-source":case"scenario":case"iteration":case"content-validations":case"content-validation":case"help-message":case"error-message":case"database-ranges":case"filter":case"filter-and":case"filter-or":case"filter-condition":case"list-level-style-bullet":case"list-level-style-number":case"list-level-properties":break;case"sender-firstname":case"sender-lastname":case"sender-initials":case"sender-title":case"sender-position":case"sender-email":case"sender-phone-private":case"sender-fax":case"sender-company":case"sender-phone-work":case"sender-street":case"sender-city":case"sender-postal-code":case"sender-country":case"sender-state-or-province":case"author-name":case"author-initials":case"chapter":case"file-name":case"template-name":case"sheet-name":case"event-listener":break;case"initial-creator":case"creation-date":case"print-date":case"generator":case"document-statistic":case"user-defined":case"editing-duration":case"editing-cycles":case"config-item":case"page-number":case"page-count":case"time":case"cell-range-source":case"detective":case"operation":case"highlighted-range":break;case"data-pilot-table":case"source-cell-range":case"source-service":case"data-pilot-field":case"data-pilot-level":case"data-pilot-subtotals":case"data-pilot-subtotal":case"data-pilot-members":case"data-pilot-member":case"data-pilot-display-info":case"data-pilot-sort-info":case"data-pilot-layout-info":case"data-pilot-field-reference":case"data-pilot-groups":case"data-pilot-group":case"data-pilot-group-member":case"rect":break;case"dde-connection-decls":case"dde-connection-decl":case"dde-link":case"dde-source":case"properties":case"property":break;case"a":if("/"!==i[1]){if(!(N=dt(i[0],!1)).href)break;N.Target=wt(N.href),delete N.href,"#"==N.Target.charAt(0)&&-1<N.Target.indexOf(".")?(F=Xc(N.Target.slice(1)),N.Target="#"+F[0]+"!"+F[1]):N.Target.match(/^\.\.[\\\/]/)&&(N.Target=N.Target.slice(3))}break;case"table-protection":case"data-pilot-grand-total":case"office-document-common-attrs":break;default:switch(i[2]){case"dc:":case"calcext:":case"loext:":case"ooo:":case"chartooo:":case"draw:":case"style:":case"chart:":case"form:":case"uof:":case"表:":case"字:":break;default:if(r.WTF)throw new Error(i)}}e={Sheets:d,SheetNames:p,Workbook:I};return r.bookSheets&&delete e.Sheets,e}function sh(e,t){t=t||{},Ze(e,"META-INF/manifest.xml")&&function(e,t){for(var r,a,n=Jt(e);r=qt.exec(n);)switch(r[3]){case"manifest":break;case"file-entry":if("/"==(a=dt(r[0],!1)).path&&a.type!==qa)throw new Error("This OpenDocument is not a spreadsheet");break;case"encryption-data":case"algorithm":case"start-key-generation":case"key-derivation":throw new Error("Unsupported ODS Encryption");default:if(t&&t.WTF)throw r}}(et(e,"META-INF/manifest.xml"),t);var r=tt(e,"content.xml");if(!r)throw new Error("Missing content.xml in ODS / UOF file");t=nh(Mt(r),t);return Ze(e,"meta.xml")&&(t.Props=rn(et(e,"meta.xml"))),t}function ih(e,t){return nh(e,t)}var oh=function(){var e=["<office:master-styles>",'<style:master-page style:name="mp1" style:page-layout-name="mp1">',"<style:header/>",'<style:header-left style:display="false"/>',"<style:footer/>",'<style:footer-left style:display="false"/>',"</style:master-page>","</office:master-styles>"].join(""),t="<office:document-styles "+Xt({"xmlns:office":"urn:oasis:names:tc:opendocument:xmlns:office:1.0","xmlns:table":"urn:oasis:names:tc:opendocument:xmlns:table:1.0","xmlns:style":"urn:oasis:names:tc:opendocument:xmlns:style:1.0","xmlns:text":"urn:oasis:names:tc:opendocument:xmlns:text:1.0","xmlns:draw":"urn:oasis:names:tc:opendocument:xmlns:drawing:1.0","xmlns:fo":"urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0","xmlns:xlink":"http://www.w3.org/1999/xlink","xmlns:dc":"http://purl.org/dc/elements/1.1/","xmlns:number":"urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0","xmlns:svg":"urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0","xmlns:of":"urn:oasis:names:tc:opendocument:xmlns:of:1.2","office:version":"1.2"})+">"+e+"</office:document-styles>";return function(){return ot+t}}(),ch=function(){function i(e,t,r){var a=[];a.push('      <table:table table:name="'+kt(t.SheetNames[r])+'" table:style-name="ta1">\n');var n=0,s=0,i=Jr(e["!ref"]||"A1"),o=e["!merges"]||[],c=0,l=Array.isArray(e);if(e["!cols"])for(s=0;s<=i.e.c;++s)a.push("        <table:table-column"+(e["!cols"][s]?' table:style-name="co'+e["!cols"][s].ods+'"':"")+"></table:table-column>\n");for(var f="",h=e["!rows"]||[],n=0;n<i.s.r;++n)f=h[n]?' table:style-name="ro'+h[n].ods+'"':"",a.push("        <table:table-row"+f+"></table:table-row>\n");for(;n<=i.e.r;++n){for(f=h[n]?' table:style-name="ro'+h[n].ods+'"':"",a.push("        <table:table-row"+f+">\n"),s=0;s<i.s.c;++s)a.push(v);for(;s<=i.e.c;++s){for(var u=!1,d={},p="",c=0;c!=o.length;++c)if(!(o[c].s.c>s||o[c].s.r>n||o[c].e.c<s||o[c].e.r<n)){o[c].s.c==s&&o[c].s.r==n||(u=!0),d["table:number-columns-spanned"]=o[c].e.c-o[c].s.c+1,d["table:number-rows-spanned"]=o[c].e.r-o[c].s.r+1;break}if(u)a.push("          <table:covered-table-cell/>\n");else{var m=Kr({r:n,c:s}),g=l?(e[n]||[])[s]:e[m];if(g&&g.f&&(d["table:formula"]=kt(("of:="+g.f.replace(lc,"$1[.$2$3$4$5]").replace(/\]:\[/g,":")).replace(/;/g,"|").replace(/,/g,";")),g.F&&g.F.slice(0,m.length)==m&&(b=Jr(g.F),d["table:number-matrix-columns-spanned"]=b.e.c-b.s.c+1,d["table:number-matrix-rows-spanned"]=b.e.r-b.s.r+1)),g){switch(g.t){case"b":p=g.v?"TRUE":"FALSE",d["office:value-type"]="boolean",d["office:boolean-value"]=g.v?"true":"false";break;case"n":p=g.w||String(g.v||0),d["office:value-type"]="float",d["office:value"]=g.v||0;break;case"s":case"str":p=null==g.v?"":g.v,d["office:value-type"]="string";break;case"d":p=g.w||He(g.v).toISOString(),d["office:value-type"]="date",d["office:date-value"]=He(g.v).toISOString(),d["table:style-name"]="ce1";break;default:a.push(v);continue}var b,m=kt(p).replace(/  +/g,function(e){return'<text:s text:c="'+e.length+'"/>'}).replace(/\t/g,"<text:tab/>").replace(/\n/g,"</text:p><text:p>").replace(/^ /,"<text:s/>").replace(/ $/,"<text:s/>");g.l&&g.l.Target&&(m=Yt("text:a",m,{"xlink:href":(b="#"!=(b="#"==(b=g.l.Target).charAt(0)?"#"+b.slice(1).replace(/\./,"!"):b).charAt(0)&&!b.match(/^\w+:/)?"../"+b:b).replace(/&/g,"&amp;")})),a.push("          "+Yt("table:table-cell",Yt("text:p",m,{}),d)+"\n")}else a.push(v)}}a.push("        </table:table-row>\n")}return a.push("      </table:table>\n"),a.join("")}var v="          <table:table-cell />\n";return function(e,t){var r=[ot],a=Xt({"xmlns:office":"urn:oasis:names:tc:opendocument:xmlns:office:1.0","xmlns:table":"urn:oasis:names:tc:opendocument:xmlns:table:1.0","xmlns:style":"urn:oasis:names:tc:opendocument:xmlns:style:1.0","xmlns:text":"urn:oasis:names:tc:opendocument:xmlns:text:1.0","xmlns:draw":"urn:oasis:names:tc:opendocument:xmlns:drawing:1.0","xmlns:fo":"urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0","xmlns:xlink":"http://www.w3.org/1999/xlink","xmlns:dc":"http://purl.org/dc/elements/1.1/","xmlns:meta":"urn:oasis:names:tc:opendocument:xmlns:meta:1.0","xmlns:number":"urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0","xmlns:presentation":"urn:oasis:names:tc:opendocument:xmlns:presentation:1.0","xmlns:svg":"urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0","xmlns:chart":"urn:oasis:names:tc:opendocument:xmlns:chart:1.0","xmlns:dr3d":"urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0","xmlns:math":"http://www.w3.org/1998/Math/MathML","xmlns:form":"urn:oasis:names:tc:opendocument:xmlns:form:1.0","xmlns:script":"urn:oasis:names:tc:opendocument:xmlns:script:1.0","xmlns:ooo":"http://openoffice.org/2004/office","xmlns:ooow":"http://openoffice.org/2004/writer","xmlns:oooc":"http://openoffice.org/2004/calc","xmlns:dom":"http://www.w3.org/2001/xml-events","xmlns:xforms":"http://www.w3.org/2002/xforms","xmlns:xsd":"http://www.w3.org/2001/XMLSchema","xmlns:xsi":"http://www.w3.org/2001/XMLSchema-instance","xmlns:sheet":"urn:oasis:names:tc:opendocument:sh33tjs:1.0","xmlns:rpt":"http://openoffice.org/2005/report","xmlns:of":"urn:oasis:names:tc:opendocument:xmlns:of:1.2","xmlns:xhtml":"http://www.w3.org/1999/xhtml","xmlns:grddl":"http://www.w3.org/2003/g/data-view#","xmlns:tableooo":"http://openoffice.org/2009/table","xmlns:drawooo":"http://openoffice.org/2010/draw","xmlns:calcext":"urn:org:documentfoundation:names:experimental:calc:xmlns:calcext:1.0","xmlns:loext":"urn:org:documentfoundation:names:experimental:office:xmlns:loext:1.0","xmlns:field":"urn:openoffice:names:experimental:ooo-ms-interop:xmlns:field:1.0","xmlns:formx":"urn:openoffice:names:experimental:ooxml-odf-interop:xmlns:form:1.0","xmlns:css3t":"http://www.w3.org/TR/css3-text/","office:version":"1.2"}),n=Xt({"xmlns:config":"urn:oasis:names:tc:opendocument:xmlns:config:1.0","office:mimetype":"application/vnd.oasis.opendocument.spreadsheet"});"fods"==t.bookType?(r.push("<office:document"+a+n+">\n"),r.push(Qa().replace(/office:document-meta/g,"office:meta"))):r.push("<office:document-content"+a+">\n"),function(a,t){a.push(" <office:automatic-styles>\n"),a.push('  <number:date-style style:name="N37" number:automatic-order="true">\n'),a.push('   <number:month number:style="long"/>\n'),a.push("   <number:text>/</number:text>\n"),a.push('   <number:day number:style="long"/>\n'),a.push("   <number:text>/</number:text>\n"),a.push("   <number:year/>\n"),a.push("  </number:date-style>\n");var n=0;t.SheetNames.map(function(e){return t.Sheets[e]}).forEach(function(e){if(e&&e["!cols"])for(var t=0;t<e["!cols"].length;++t)if(e["!cols"][t]){var r=e["!cols"][t];if(null==r.width&&null==r.wpx&&null==r.wch)continue;fo(r),r.ods=n;r=e["!cols"][t].wpx+"px";a.push('  <style:style style:name="co'+n+'" style:family="table-column">\n'),a.push('   <style:table-column-properties fo:break-before="auto" style:column-width="'+r+'"/>\n'),a.push("  </style:style>\n"),++n}});var s=0;t.SheetNames.map(function(e){return t.Sheets[e]}).forEach(function(e){if(e&&e["!rows"])for(var t,r=0;r<e["!rows"].length;++r)e["!rows"][r]&&(e["!rows"][r].ods=s,t=e["!rows"][r].hpx+"px",a.push('  <style:style style:name="ro'+s+'" style:family="table-row">\n'),a.push('   <style:table-row-properties fo:break-before="auto" style:row-height="'+t+'"/>\n'),a.push("  </style:style>\n"),++s)}),a.push('  <style:style style:name="ta1" style:family="table" style:master-page-name="mp1">\n'),a.push('   <style:table-properties table:display="true" style:writing-mode="lr-tb"/>\n'),a.push("  </style:style>\n"),a.push('  <style:style style:name="ce1" style:family="table-cell" style:parent-style-name="Default" style:data-style-name="N37"/>\n'),a.push(" </office:automatic-styles>\n")}(r,e),r.push("  <office:body>\n"),r.push("    <office:spreadsheet>\n");for(var s=0;s!=e.SheetNames.length;++s)r.push(i(e.Sheets[e.SheetNames[s]],e,s));return r.push("    </office:spreadsheet>\n"),r.push("  </office:body>\n"),"fods"==t.bookType?r.push("</office:document>"):r.push("</office:document-content>"),r.join("")}}();function lh(e,t){if("fods"==t.bookType)return ch(e,t);var r=nt(),a=[],n=[];return at(r,"mimetype","application/vnd.oasis.opendocument.spreadsheet"),at(r,"content.xml",ch(e,t)),a.push(["content.xml","text/xml"]),n.push(["content.xml","ContentFile"]),at(r,"styles.xml",oh(e,t)),a.push(["styles.xml","text/xml"]),n.push(["styles.xml","StylesFile"]),at(r,"meta.xml",ot+Qa()),a.push(["meta.xml","text/xml"]),n.push(["meta.xml","MetadataFile"]),at(r,"manifest.rdf",function(e){var t=[ot];t.push('<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">\n');for(var r=0;r!=e.length;++r)t.push(Za(e[r][0],e[r][1])),t.push(['  <rdf:Description rdf:about="">\n','    <ns0:hasPart xmlns:ns0="http://docs.oasis-open.org/ns/office/1.2/meta/pkg#" rdf:resource="'+e[r][0]+'"/>\n',"  </rdf:Description>\n"].join(""));return t.push(Za("","Document","pkg")),t.push("</rdf:RDF>"),t.join("")}(n)),a.push(["manifest.rdf","application/rdf+xml"]),at(r,"META-INF/manifest.xml",function(e){var t=[ot];t.push('<manifest:manifest xmlns:manifest="urn:oasis:names:tc:opendocument:xmlns:manifest:1.0" manifest:version="1.2">\n'),t.push('  <manifest:file-entry manifest:full-path="/" manifest:version="1.2" manifest:media-type="application/vnd.oasis.opendocument.spreadsheet"/>\n');for(var r=0;r<e.length;++r)t.push('  <manifest:file-entry manifest:full-path="'+e[r][0]+'" manifest:media-type="'+e[r][1]+'"/>\n');return t.push("</manifest:manifest>"),t.join("")}(a)),r}function fh(e){return new DataView(e.buffer,e.byteOffset,e.byteLength)}function hh(e){return"undefined"!=typeof TextDecoder?(new TextDecoder).decode(e):Mt(i(e))}function uh(e){return"undefined"!=typeof TextEncoder?(new TextEncoder).encode(e):he(Ut(e))}function dh(e){var t=e.reduce(function(e,t){return e+t.length},0),r=new Uint8Array(t),a=0;return e.forEach(function(e){r.set(e,a),a+=e.length}),r}function ph(e){return 16843009*((e=(858993459&(e-=e>>1&1431655765))+(e>>2&858993459))+(e>>4)&252645135)>>>24}function mh(e,t){var r=t?t[0]:0,a=127&e[r];return 128<=e[r++]&&(a|=(127&e[r])<<7,e[r++]<128||(a|=(127&e[r])<<14,e[r++]<128||(a|=(127&e[r])<<21,e[r++]<128||(a+=(127&e[r])*Math.pow(2,28),++r,e[r++]<128||(a+=(127&e[r])*Math.pow(2,35),++r,e[r++]<128||(a+=(127&e[r])*Math.pow(2,42),++r,e[r++])))))),t&&(t[0]=r),a}function gh(e){var t=new Uint8Array(7);t[0]=127&e;var r=1;return 127<e&&(t[r-1]|=128,t[r]=e>>7&127,++r,e<=16383||(t[r-1]|=128,t[r]=e>>14&127,++r,e<=2097151||(t[r-1]|=128,t[r]=e>>21&127,++r,e<=268435455||(t[r-1]|=128,t[r]=e/256>>>21&127,++r,e<=34359738367||(t[r-1]|=128,t[r]=e/65536>>>21&127,++r,e<=4398046511103||(t[r-1]|=128,t[r]=e/16777216>>>21&127,++r)))))),t.slice(0,r)}function bh(e){var t=0,r=127&e[0];return 128<=e[t++]&&(r|=(127&e[1])<<7,e[t++]<128||(r|=(127&e[2])<<14,e[t++]<128||(r|=(127&e[3])<<21,e[+t]<128||(r|=(127&e[4])<<28)))),r}function vh(e){for(var t=[],r=[0];r[0]<e.length;){var a,n=r[0],s=mh(e,r),i=7&s,o=0;if(0==(s=Math.floor(s/8)))break;switch(i){case 0:for(var c=r[0];128<=e[r[0]++];);a=e.slice(c,r[0]);break;case 5:o=4,a=e.slice(r[0],r[0]+o),r[0]+=o;break;case 1:o=8,a=e.slice(r[0],r[0]+o),r[0]+=o;break;case 2:o=mh(e,r),a=e.slice(r[0],r[0]+o),r[0]+=o;break;case 3:case 4:default:throw new Error("PB Type ".concat(i," for Field ").concat(s," at offset ").concat(n))}var l={data:a,type:i};null==t[s]?t[s]=[l]:t[s].push(l)}return t}function wh(e){var r=[];return e.forEach(function(e,t){0!=t&&e.forEach(function(e){e.data&&(r.push(gh(8*t+e.type)),2==e.type&&r.push(gh(e.data.length)),r.push(e.data))})}),dh(r)}function Th(e,t){return(null==e?void 0:e.map(function(e){return t(e.data)}))||[]}function Eh(r){for(var e=[],a=[0];a[0]<r.length;){var t=mh(r,a),n=vh(r.slice(a[0],a[0]+t));a[0]+=t;var s={id:bh(n[1][0].data),messages:[]};n[2].forEach(function(e){var t=vh(e.data),e=bh(t[3][0].data);s.messages.push({meta:t,data:r.slice(a[0],a[0]+e)}),a[0]+=e}),null!=(t=n[3])&&t[0]&&(s.merge=0<bh(n[3][0].data)>>>0),e.push(s)}return e}function kh(e){var a=[];return e.forEach(function(e){var t=[[],[{data:gh(e.id),type:0}],[]];null!=e.merge&&(t[3]=[{data:gh(+!!e.merge),type:0}]);var r=[];e.messages.forEach(function(e){r.push(e.data),e.meta[3]=[{type:0,data:gh(e.data.length)}],t[2].push({data:wh(e.meta),type:2})});e=wh(t);a.push(gh(e.length)),a.push(e),r.forEach(function(e){return a.push(e)})}),dh(a)}function yh(e){for(var t=[],r=0;r<e.length;){var a=e[r++],n=e[r]|e[r+1]<<8|e[r+2]<<16;r+=3,t.push(function(e,t){if(0!=e)throw new Error("Unexpected Snappy chunk type ".concat(e));for(var r=[0],a=mh(t,r),n=[];r[0]<t.length;){var s=3&t[r[0]];if(0!=s){var i=0,o=0;if(1==s?(o=4+(t[r[0]]>>2&7),i=(224&t[r[0]++])<<3,i|=t[r[0]++]):(o=1+(t[r[0]++]>>2),2==s?(i=t[r[0]]|t[r[0]+1]<<8,r[0]+=2):(i=(t[r[0]]|t[r[0]+1]<<8|t[r[0]+2]<<16|t[r[0]+3]<<24)>>>0,r[0]+=4)),n=[dh(n)],0==i)throw new Error("Invalid offset 0");if(i>n[0].length)throw new Error("Invalid offset beyond length");if(i<=o)for(n.push(n[0].slice(-i)),o-=i;o>=n[n.length-1].length;)n.push(n[n.length-1]),o-=n[n.length-1].length;n.push(n[0].slice(-i,-i+o))}else{s=t[r[0]++]>>2;s<60?++s:(i=s-59,s=t[r[0]],1<i&&(s|=t[r[0]+1]<<8),2<i&&(s|=t[r[0]+2]<<16),3<i&&(s|=t[r[0]+3]<<24),s>>>=0,s++,r[0]+=i),n.push(t.slice(r[0],r[0]+s)),r[0]+=s}}if((e=dh(n)).length!=a)throw new Error("Unexpected length: ".concat(e.length," != ").concat(a));return e}(a,e.slice(r,r+n))),r+=n}if(r!==e.length)throw new Error("data is not a valid framed stream!");return dh(t)}function Sh(e){for(var t=[],r=0;r<e.length;){var a=Math.min(e.length-r,268435455),n=new Uint8Array(4);t.push(n);var s=gh(a),i=s.length;t.push(s),a<=60?(i++,t.push(new Uint8Array([a-1<<2]))):a<=256?(i+=2,t.push(new Uint8Array([240,a-1&255]))):a<=65536?(i+=3,t.push(new Uint8Array([244,a-1&255,a-1>>8&255]))):a<=16777216?(i+=4,t.push(new Uint8Array([248,a-1&255,a-1>>8&255,a-1>>16&255]))):a<=4294967296&&(i+=5,t.push(new Uint8Array([252,a-1&255,a-1>>8&255,a-1>>16&255,a-1>>>24&255]))),t.push(e.slice(r,r+a)),i+=a,n[0]=0,n[1]=255&i,n[2]=i>>8&255,n[3]=i>>16&255,r+=a}return dh(t)}function _h(e,t,r){var a,n=fh(e),s=n.getUint32(8,!0),i=12,o=-1,c=-1,l=NaN,f=NaN,h=new Date(2001,0,1);switch(1&s&&(l=function(e,t){for(var r=(127&e[t+15])<<7|e[t+14]>>1,a=1&e[t+14],n=t+13;t<=n;--n)a=256*a+e[n];return(128&e[t+15]?-a:a)*Math.pow(10,r-6176)}(e,i),i+=16),2&s&&(f=n.getFloat64(i,!0),i+=8),4&s&&(h.setTime(h.getTime()+1e3*n.getFloat64(i,!0)),i+=8),8&s&&(c=n.getUint32(i,!0),i+=4),16&s&&(o=n.getUint32(i,!0),i+=4),e[1]){case 0:break;case 2:a={t:"n",v:l};break;case 3:a={t:"s",v:t[c]};break;case 5:a={t:"d",v:h};break;case 6:a={t:"b",v:0<f};break;case 7:a={t:"n",v:f/86400};break;case 8:a={t:"e",v:0};break;case 9:if(!(-1<o))throw new Error("Unsupported cell type ".concat(e[1]," : ").concat(31&s," : ").concat(e.slice(0,4)));a={t:"s",v:r[o]};break;case 10:a={t:"n",v:l};break;default:throw new Error("Unsupported cell type ".concat(e[1]," : ").concat(31&s," : ").concat(e.slice(0,4)))}return a}function xh(e,t){var r=new Uint8Array(32),a=fh(r),n=12,s=0;switch(r[0]=5,e.t){case"n":r[1]=2,function(e,t,r){var a=Math.floor(0==r?0:Math.LOG10E*Math.log(Math.abs(r)))+6176-16,n=r/Math.pow(10,a-6176);e[t+15]|=a>>7,e[t+14]|=(127&a)<<1;for(var s=0;1<=n;++s,n/=256)e[t+s]=255&n;e[t+15]|=0<=r?0:128}(r,n,e.v),s|=1,n+=16;break;case"b":r[1]=6,a.setFloat64(n,e.v?1:0,!0),s|=2,n+=8;break;case"s":if(-1==t.indexOf(e.v))throw new Error("Value ".concat(e.v," missing from SST!"));r[1]=3,a.setUint32(n,t.indexOf(e.v),!0),s|=8,n+=4;break;default:throw"unsupported cell type "+e.t}return a.setUint32(8,s,!0),r.slice(0,n)}function Ah(e,t){var r=new Uint8Array(32),a=fh(r),n=12,s=0;switch(r[0]=3,e.t){case"n":r[2]=2,a.setFloat64(n,e.v,!0),s|=32,n+=8;break;case"b":r[2]=6,a.setFloat64(n,e.v?1:0,!0),s|=32,n+=8;break;case"s":if(-1==t.indexOf(e.v))throw new Error("Value ".concat(e.v," missing from SST!"));r[2]=3,a.setUint32(n,t.indexOf(e.v),!0),s|=16,n+=4;break;default:throw"unsupported cell type "+e.t}return a.setUint32(4,s,!0),r.slice(0,n)}function Ch(e,t,r){switch(e[0]){case 0:case 1:case 2:case 3:return function(e,t,r,a){var n,s=fh(e),i=s.getUint32(4,!0),o=(1<a?12:8)+4*ph(i&(1<a?3470:398)),c=-1,l=-1,f=NaN,h=new Date(2001,0,1);switch(512&i&&(c=s.getUint32(o,!0),o+=4),o+=4*ph(i&(1<a?12288:4096)),16&i&&(l=s.getUint32(o,!0),o+=4),32&i&&(f=s.getFloat64(o,!0),o+=8),64&i&&(h.setTime(h.getTime()+1e3*s.getFloat64(o,!0)),o+=8),e[2]){case 0:break;case 2:n={t:"n",v:f};break;case 3:n={t:"s",v:t[l]};break;case 5:n={t:"d",v:h};break;case 6:n={t:"b",v:0<f};break;case 7:n={t:"n",v:f/86400};break;case 8:n={t:"e",v:0};break;case 9:if(-1<c)n={t:"s",v:r[c]};else if(-1<l)n={t:"s",v:t[l]};else{if(isNaN(f))throw new Error("Unsupported cell type ".concat(e.slice(0,4)));n={t:"n",v:f}}break;default:throw new Error("Unsupported cell type ".concat(e.slice(0,4)))}return n}(e,t,r,e[0]);case 5:return _h(e,t,r);default:throw new Error("Unsupported payload version ".concat(e[0]))}}function Rh(e){return mh(vh(e)[1][0].data)}function Oh(s,e){var e=vh(e.data),i=bh(e[1][0].data),e=e[3],o=[];return(e||[]).forEach(function(e){var t=vh(e.data),r=bh(t[1][0].data)>>>0;switch(i){case 1:o[r]=hh(t[3][0].data);break;case 8:var a=vh(s[Rh(t[9][0].data)][0].data),n=s[Rh(a[1][0].data)][0],a=bh(n.meta[1][0].data);if(2001!=a)throw new Error("2000 unexpected reference to ".concat(a));n=vh(n.data);o[r]=n[3].map(function(e){return hh(e.data)}).join("")}}),o}function Ih(e,t){var r=vh(t.data),a=null!=(t=null==r?void 0:r[7])&&t[0]?0<bh(r[7][0].data)>>>0?1:0:-1,t=Th(r[5],function(e){return function(e,t){var r,a,n,s=vh(e),i=bh(s[1][0].data)>>>0,o=bh(s[2][0].data)>>>0,c=(null==(e=null==(c=s[8])?void 0:c[0])?void 0:e.data)&&0<bh(s[8][0].data)||!1;if(null!=(e=null==(e=s[7])?void 0:e[0])&&e.data&&0!=t)a=null==(r=null==(r=s[7])?void 0:r[0])?void 0:r.data,n=null==(r=null==(r=s[6])?void 0:r[0])?void 0:r.data;else{if(null==(r=null==(r=s[4])?void 0:r[0])||!r.data||1==t)throw"NUMBERS Tile missing ".concat(t," cell storage");a=null==(t=null==(t=s[4])?void 0:t[0])?void 0:t.data,n=null==(s=null==(s=s[3])?void 0:s[0])?void 0:s.data}for(var l=c?4:1,f=fh(a),h=[],u=0;u<a.length/2;++u){var d=f.getUint16(2*u,!0);d<65535&&h.push([u,d])}if(h.length!=o)throw"Expected ".concat(o," cells, found ").concat(h.length);for(var p=[],u=0;u<h.length-1;++u)p[h[u][0]]=n.subarray(h[u][1]*l,h[u+1][1]*l);return 1<=h.length&&(p[h[h.length-1][0]]=n.subarray(h[h.length-1][1]*l)),{R:i,cells:p}}(e,a)});return{nrows:bh(r[4][0].data)>>>0,data:t.reduce(function(r,a){return r[a.R]||(r[a.R]=[]),a.cells.forEach(function(e,t){if(r[a.R][t])throw new Error("Duplicate cell r=".concat(a.R," c=").concat(t));r[a.R][t]=e}),r},[])}}function Nh(e,t){var r={"!ref":"A1"},a=e[Rh(vh(t.data)[2][0].data)],t=bh(a[0].meta[1][0].data);if(6001!=t)throw new Error("6000 unexpected reference to ".concat(t));return function(r,e,a){var t=vh(e.data);if((e={s:{r:0,c:0},e:{r:0,c:0}}).e.r=(bh(t[6][0].data)>>>0)-1,e.e.r<0)throw new Error("Invalid row varint ".concat(t[6][0].data));if(e.e.c=(bh(t[7][0].data)>>>0)-1,e.e.c<0)throw new Error("Invalid col varint ".concat(t[7][0].data));a["!ref"]=qr(e);var e=vh(t[4][0].data),n=Oh(r,r[Rh(e[4][0].data)][0]),s=null!=(t=e[17])&&t[0]?Oh(r,r[Rh(e[17][0].data)][0]):[],t=vh(e[3][0].data),i=0;if(t[1].forEach(function(e){var t=vh(e.data),e=r[Rh(t[2][0].data)][0],t=bh(e.meta[1][0].data);if(6002!=t)throw new Error("6001 unexpected reference to ".concat(t));e=Ih(0,e);e.data.forEach(function(e,r){e.forEach(function(e,t){t=Kr({r:i+r,c:t}),e=Ch(e,n,s);e&&(a[t]=e)})}),i+=e.nrows}),null!=(t=e[13])&&t[0]){t=r[Rh(e[13][0].data)][0],e=bh(t.meta[1][0].data);if(6144!=e)throw new Error("Expected merge type 6144, found ".concat(e));a["!merges"]=null==(t=vh(t.data))?void 0:t[1].map(function(e){var t=vh(e.data),e=fh(vh(t[1][0].data)[1][0].data),t=fh(vh(t[2][0].data)[1][0].data);return{s:{r:e.getUint16(0,!0),c:e.getUint16(2,!0)},e:{r:e.getUint16(0,!0)+t.getUint16(0,!0)-1,c:e.getUint16(2,!0)+t.getUint16(2,!0)-1}}})}}(e,a[0],r),r}function Fh(s,e){var i=du(),t=vh(e.data);if(null!=(e=t[2])&&e[0])throw new Error("Keynote presentations are not supported");if(Th(t[1],Rh).forEach(function(e){s[e].forEach(function(e){var r,t,a,n;2==bh(e.meta[1][0].data)&&(t=s,e=vh((a=e).data),n={name:null!=(a=e[1])&&a[0]?hh(e[1][0].data):"",sheets:[]},Th(e[2],Rh).forEach(function(e){t[e].forEach(function(e){6e3==bh(e.meta[1][0].data)&&n.sheets.push(Nh(t,e))})}),(r=n).sheets.forEach(function(e,t){pu(i,e,0==t?r.name:r.name+"_"+t,!0)}))})}),0==i.SheetNames.length)throw new Error("Empty NUMBERS file");return i}function Dh(e){var a={},n=[];if(e.FullPaths.forEach(function(e){if(e.match(/\.iwpv2/))throw new Error("Unsupported password protection")}),e.FileIndex.forEach(function(t){if(t.name.match(/\.iwa$/)){var e,r;try{e=yh(t.content)}catch(e){return console.log("?? "+t.content.length+" "+(e.message||e))}try{r=Eh(e)}catch(e){return console.log("## "+(e.message||e))}r.forEach(function(e){a[e.id]=e.messages,n.push(e.id)})}}),!n.length)throw new Error("File has no messages");if(null!=(e=null==(e=null==(e=null==(e=null==a?void 0:a[1])?void 0:e[0])?void 0:e.meta)?void 0:e[1])&&e[0].data&&1e4==bh(a[1][0].meta[1][0].data))throw new Error("Pages documents are not supported");var t=(null==(e=null==(e=null==(e=null==(e=null==a?void 0:a[1])?void 0:e[0])?void 0:e.meta)?void 0:e[1])?void 0:e[0].data)&&1==bh(a[1][0].meta[1][0].data)&&a[1][0];if(t||n.forEach(function(e){a[e].forEach(function(e){if(1==bh(e.meta[1][0].data)>>>0){if(t)throw new Error("Document has multiple roots");t=e}})}),!t)throw new Error("Cannot find Document root");return Fh(a,t)}function Ph(e,t){if(!t||!t.numbers)throw new Error("Must pass a `numbers` option -- check the README");var r=e.Sheets[e.SheetNames[0]];1<e.SheetNames.length&&console.error("The Numbers writer currently writes only the first table");var f=Jr(r["!ref"]);f.s.r=f.s.c=0;var a=!1;9<f.e.c&&(a=!0,f.e.c=9),49<f.e.r&&(a=!0,f.e.r=49),a&&console.error("The Numbers writer is currently limited to ".concat(qr(f)));var h=iu(r,{range:f,header:1}),u=["~Sh33tJ5~"];h.forEach(function(e){return e.forEach(function(e){"string"==typeof e&&u.push(e)})});var d={},n=[],p=xe.read(t.numbers,{type:"base64"});p.FileIndex.map(function(e,t){return[e,p.FullPaths[t]]}).forEach(function(e){var t=e[0],r=e[1];2==t.type&&t.name.match(/\.iwa/)&&Eh(yh(t.content)).forEach(function(e){n.push(e.id),d[e.id]={deps:[],location:r,type:bh(e.messages[0].meta[1][0].data)}})}),n.sort(function(e,t){return e-t});var s=n.filter(function(e){return 1<e}).map(function(e){return[e,gh(e)]});p.FileIndex.map(function(e,t){return[e,p.FullPaths[t]]}).forEach(function(e){var t=e[0];e[1];t.name.match(/\.iwa/)&&Eh(yh(t.content)).forEach(function(r){r.messages.forEach(function(e){s.forEach(function(t){r.messages.some(function(e){return 11006!=bh(e.meta[1][0].data)&&function(e,t){e:for(var r=0;r<=e.length-t.length;++r){for(var a=0;a<t.length;++a)if(e[r+a]!=t[a])continue e;return!0}return!1}(e.data,t[1])})&&d[t[0]].deps.push(r.id)})})})});for(var i,o=xe.find(p,d[1].location),c=Eh(yh(o.content)),l=0;l<c.length;++l){var m=c[l];1==m.id&&(i=m)}for(var g=Rh(vh(i.messages[0].data)[1][0].data),c=Eh(yh((o=xe.find(p,d[g].location)).content)),l=0;l<c.length;++l)(m=c[l]).id==g&&(i=m);var b=vh(i.messages[0].data);for(b[1]=[{type:2,data:uh(e.SheetNames[0])}],i.messages[0].data=wh(b),o.content=Sh(kh(c)),o.size=o.content.length,g=Rh(b[2][0].data),c=Eh(yh((o=xe.find(p,d[g].location)).content)),l=0;l<c.length;++l)(m=c[l]).id==g&&(i=m);for(g=Rh(vh(i.messages[0].data)[2][0].data),c=Eh(yh((o=xe.find(p,d[g].location)).content)),l=0;l<c.length;++l)(m=c[l]).id==g&&(i=m);a=vh(i.messages[0].data);a[6][0].data=gh(f.e.r+1),a[7][0].data=gh(f.e.c+1);for(var v=Rh(a[46][0].data),t=xe.find(p,d[v].location),w=Eh(yh(t.content)),T=0;T<w.length&&w[T].id!=v;++T);if(w[T].id!=v)throw"Bad ColumnRowUIDMapArchive";var E=vh(w[T].messages[0].data);E[1]=[],E[2]=[],E[3]=[];for(var k=0;k<=f.e.c;++k)E[1].push({type:2,data:wh([[],[{type:0,data:gh(k+420690)}],[{type:0,data:gh(k+420690)}]])}),E[2].push({type:0,data:gh(k)}),E[3].push({type:0,data:gh(k)});E[4]=[],E[5]=[],E[6]=[];for(var y=0;y<=f.e.r;++y)E[4].push({type:2,data:wh([[],[{type:0,data:gh(y+726270)}],[{type:0,data:gh(y+726270)}]])}),E[5].push({type:0,data:gh(y)}),E[6].push({type:0,data:gh(y)});w[T].messages[0].data=wh(E),t.content=Sh(kh(w)),t.size=t.content.length,delete a[46];e=vh(a[4][0].data);e[7][0].data=gh(f.e.r+1);b=Rh(vh(e[1][0].data)[2][0].data);if((w=Eh(yh((t=xe.find(p,d[b].location)).content)))[0].id!=b)throw"Bad HeaderStorageBucket";for(var S=vh(w[0].messages[0].data),y=0;y<h.length;++y){var _=vh(S[2][0].data);_[1][0].data=gh(y),_[4][0].data=gh(h[y].length),S[2][y]={type:S[2][0].type,data:wh(_)}}w[0].messages[0].data=wh(S),t.content=Sh(kh(w)),t.size=t.content.length;var x,b=Rh(e[2][0].data);if((w=Eh(yh((t=xe.find(p,d[b].location)).content)))[0].id!=b)throw"Bad HeaderStorageBucket";for(S=vh(w[0].messages[0].data),k=0;k<=f.e.c;++k)(_=vh(S[2][0].data))[1][0].data=gh(k),_[4][0].data=gh(f.e.r+1),S[2][k]={type:S[2][0].type,data:wh(_)};w[0].messages[0].data=wh(S),t.content=Sh(kh(w)),t.size=t.content.length,r["!merges"]&&(O=function(e){for(var t=927262;t<2e6;++t)if(!d[t])return d[t]=e,t;throw new Error("Too many messages")}({type:6144,deps:[g],location:d[g].location}),x=[[],[]],r["!merges"].forEach(function(e){x[1].push({type:2,data:wh([[],[{type:2,data:wh([[],[{type:5,data:new Uint8Array(new Uint16Array([e.s.r,e.s.c]).buffer)}]])}],[{type:2,data:wh([[],[{type:5,data:new Uint8Array(new Uint16Array([e.e.r-e.s.r+1,e.e.c-e.s.c+1]).buffer)}]])}]])})}),e[13]=[{type:2,data:wh([[],[{type:0,data:gh(O)}]])}],c.push({id:O,messages:[(R=6144,O=wh(x),{meta:[[],[{type:0,data:gh(R)}]],data:O})]}));var A=Rh(e[4][0].data);!function(){for(var e,t=xe.find(p,d[A].location),r=Eh(yh(t.content)),a=0;a<r.length;++a){var n=r[a];n.id==A&&(e=n)}var s=vh(e.messages[0].data);s[3]=[],u.forEach(function(e,t){s[3].push({type:2,data:wh([[],[{type:0,data:gh(t)}],[{type:0,data:gh(1)}],[{type:2,data:uh(e)}]])})}),e.messages[0].data=wh(s),t.content=Sh(kh(r)),t.size=t.content.length}();var C=vh(e[3][0].data),R=C[1][0];delete C[2];var R,O,O=vh(R.data),I=Rh(O[2][0].data);return function(){for(var e,t=xe.find(p,d[I].location),r=Eh(yh(t.content)),a=0;a<r.length;++a){var n=r[a];n.id==I&&(e=n)}var s=vh(e.messages[0].data);delete s[6],delete C[7];var i=new Uint8Array(s[5][0].data);s[5]=[];for(var o=0,c=0;c<=f.e.r;++c){var l=vh(i);o+=function(e,t,r){var a,n;if(null==(a=e[6])||!a[0]||null==(n=e[7])||!n[0])throw"Mutation only works on post-BNC storages!";if((null==(n=null==(n=e[8])?void 0:n[0])?void 0:n.data)&&0<bh(e[8][0].data)||!1)throw"Math only works with normal offsets";for(var s,i,o=0,c=fh(e[7][0].data),l=0,f=[],h=fh(e[4][0].data),u=0,d=[],p=0;p<t.length;++p)if(null!=t[p]){switch(c.setUint16(2*p,l,!0),h.setUint16(2*p,u,!0),typeof t[p]){case"string":s=xh({t:"s",v:t[p]},r),i=Ah({t:"s",v:t[p]},r);break;case"number":s=xh({t:"n",v:t[p]},r),i=Ah({t:"n",v:t[p]},r);break;case"boolean":s=xh({t:"b",v:t[p]},r),i=Ah({t:"b",v:t[p]},r);break;default:throw new Error("Unsupported value "+t[p])}f.push(s),l+=s.length,d.push(i),u+=i.length,++o}else c.setUint16(2*p,65535,!0),h.setUint16(2*p,65535);for(e[2][0].data=gh(o);p<e[7][0].data.length/2;++p)c.setUint16(2*p,65535,!0),h.setUint16(2*p,65535,!0);return e[6][0].data=dh(f),e[3][0].data=dh(d),o}(l,h[c],u),l[1][0].data=gh(c),s[5].push({data:wh(l),type:2})}s[1]=[{type:0,data:gh(f.e.c+1)}],s[2]=[{type:0,data:gh(f.e.r+1)}],s[3]=[{type:0,data:gh(o)}],s[4]=[{type:0,data:gh(f.e.r+1)}],e.messages[0].data=wh(s),t.content=Sh(kh(r)),t.size=t.content.length}(),R.data=wh(O),e[3][0].data=wh(C),a[4][0].data=wh(e),i.messages[0].data=wh(a),o.content=Sh(kh(c)),o.size=o.content.length,p}function Lh(a){return function(e){for(var t=0;t!=a.length;++t){var r=a[t];void 0===e[r[0]]&&(e[r[0]]=r[1]),"n"===r[2]&&(e[r[0]]=Number(e[r[0]]))}}}function Mh(e){Lh([["cellNF",!1],["cellHTML",!0],["cellFormula",!0],["cellStyles",!1],["cellText",!0],["cellDates",!1],["sheetStubs",!1],["sheetRows",0,"n"],["bookDeps",!1],["bookSheets",!1],["bookProps",!1],["bookFiles",!1],["bookVBA",!1],["password",""],["WTF",!1]])(e)}function Uh(e){Lh([["cellDates",!1],["bookSST",!1],["bookType","xlsx"],["compression",!1],["WTF",!1]])(e)}function Bh(t,e){if(!t)return 0;try{t=e.map(function(e){return e.id||(e.id=e.strRelID),[e.name,t["!id"][e.id].Target,(e=t["!id"][e.id].Type,-1<$a.WS.indexOf(e)?"sheet":$a.CS&&e==$a.CS?"chart":$a.DS&&e==$a.DS?"dialog":$a.MS&&e==$a.MS?"macro":e&&e.length?e:"sheet")]})}catch(e){return null}return t&&0!==t.length?t:null}function Wh(l,f,e,h,t,u,r,a,d,n,s,i){try{u[h]=Ya(tt(l,e,!0),f);var o=et(l,f);switch(a){case"sheet":g=nf(o,f,t,d,u[h],n,s,i);break;case"chart":if(!(g=sf(o,f,t,d,u[h],n))||!g["!drawel"])break;var c=it(g["!drawel"].Target,f),p=Xa(c),m=it((m=tt(l,c,!0),p=Ya(tt(l,p,!0),c),m?(m=(m.match(/<c:chart [^>]*r:id="([^"]*)"/)||["",""])[1],p["!id"][m].Target):"??"),c),c=Xa(m),g=Wl(tt(l,m,!0),0,0,Ya(tt(l,c,!0),m),0,g);break;case"macro":v=f,u[h],v.slice(-4),g={"!type":"macro"};break;case"dialog":v=f,u[h],v.slice(-4),g={"!type":"dialog"};break;default:throw new Error("Unrecognized sheet type "+a)}r[h]=g;var b=[];u&&u[h]&&Re(u[h]).forEach(function(e){var a,n,s,i,o,c,t="";if(u[h][e].Type==$a.CMNT){t=it(u[h][e].Target,f);var r=lf(et(l,t,!0),t,d);if(!r||!r.length)return;ec(g,r,!1)}u[h][e].Type==$a.TCMNT&&(t=it(u[h][e].Target,f),b=b.concat((a=et(l,t,!0),n=d,i=!(s=[]),o={},c=0,a.replace(ft,function(e,t){var r=dt(e);switch(pt(r[0])){case"<?xml":case"<ThreadedComments":case"</ThreadedComments>":break;case"<threadedComment":o={author:r.personId,guid:r.id,ref:r.ref,T:1};break;case"</threadedComment>":null!=o.t&&s.push(o);break;case"<text>":case"<text":c=t+e.length;break;case"</text>":o.t=a.slice(c,t).replace(/\r\n/g,"\n").replace(/\r/g,"\n");break;case"<mentions":case"<mentions>":i=!0;break;case"</mentions>":i=!1;break;case"<extLst":case"<extLst>":case"</extLst>":case"<extLst/>":break;case"<ext":i=!0;break;case"</ext>":i=!1;break;default:if(!i&&n.WTF)throw new Error("unrecognized "+r[0]+" in threaded comments")}return e}),s)))}),b&&b.length&&ec(g,b,!0,d.people||[])}catch(e){if(d.WTF)throw e}var v,m}function Hh(e){return"/"==e.charAt(0)?e.slice(1):e}function zh(r,t){if(Ee(),Mh(t=t||{}),Ze(r,"META-INF/manifest.xml"))return sh(r,t);if(Ze(r,"objectdata.xml"))return sh(r,t);if(Ze(r,"Index/Document.iwa")){if("undefined"==typeof Uint8Array)throw new Error("NUMBERS file parsing requires Uint8Array support");if(0,r.FileIndex)return Dh(r);var a=xe.utils.cfb_new();return rt(r).forEach(function(e){at(a,e,function e(t,r,a){if(!a)return qe(Qe(t,r));if(!r)return null;try{return e(t,r)}catch(e){return null}}(r,e))}),Dh(a)}if(!Ze(r,"[Content_Types].xml")){if(Ze(r,"index.xml.gz"))throw new Error("Unsupported NUMBERS 08 file");if(Ze(r,"index.xml"))throw new Error("Unsupported NUMBERS 09 file");throw new Error("Unsupported ZIP file")}var e,n,s=rt(r),i=function(e){var r=Ga();if(!e||!e.match)return r;var a={};if((e.match(ft)||[]).forEach(function(e){var t=dt(e);switch(t[0].replace(ht,"<")){case"<?xml":break;case"<Types":r.xmlns=t["xmlns"+(t[0].match(/<(\w+):/)||["",""])[1]];break;case"<Default":a[t.Extension]=t.ContentType;break;case"<Override":void 0!==r[za[t.ContentType]]&&r[za[t.ContentType]].push(t.PartName)}}),r.xmlns!==Zt.CT)throw new Error("Unknown Namespace: "+r.xmlns);return r.calcchain=0<r.calcchains.length?r.calcchains[0]:"",r.sst=0<r.strs.length?r.strs[0]:"",r.style=0<r.styles.length?r.styles[0]:"",r.defaults=a,delete r.calcchains,r}(tt(r,"[Content_Types].xml")),o=!1;if(0===i.workbooks.length&&et(r,n="xl/workbook.xml",!0)&&i.workbooks.push(n),0===i.workbooks.length){if(!et(r,n="xl/workbook.bin",!0))throw new Error("Could not find workbook");i.workbooks.push(n),o=!0}"bin"==i.workbooks[0].slice(-3)&&(o=!0);var c={},l={};if(!t.bookSheets&&!t.bookProps){if(Yc=[],i.sst)try{Yc=cf(et(r,Hh(i.sst)),i.sst,t)}catch(e){if(t.WTF)throw e}t.cellStyles&&i.themes.length&&(m=tt(r,i.themes[0].replace(/^\//,""),!0)||"",i.themes[0],c=$o(m,t)),i.style&&(l=of(et(r,Hh(i.style)),i.style,c,t))}i.links.map(function(e){try{Ya(tt(r,Xa(Hh(e))),e);return hf(et(r,Hh(e)),0,e,t)}catch(e){}});var f,h,u,d=af(et(r,Hh(i.workbooks[0])),i.workbooks[0],t),p={},m="";i.coreprops.length&&((m=et(r,Hh(i.coreprops[0]),!0))&&(p=rn(m)),0!==i.extprops.length&&(m=et(r,Hh(i.extprops[0]),!0))&&(g=t,u={},h=(h=p)||{},f=Mt(f=m),sn.forEach(function(e){var t=(f.match(Bt(e[0]))||[])[1];switch(e[2]){case"string":t&&(h[e[1]]=wt(t));break;case"bool":h[e[1]]="true"===t;break;case"raw":var r=f.match(new RegExp("<"+e[0]+"[^>]*>([\\s\\S]*?)</"+e[0]+">"));r&&0<r.length&&(u[e[1]]=r[1])}}),u.HeadingPairs&&u.TitlesOfParts&&cn(u.HeadingPairs,u.TitlesOfParts,h,g)));var g={};t.bookSheets&&!t.bookProps||0!==i.custprops.length&&(m=tt(r,Hh(i.custprops[0]),!0))&&(g=function(e,t){var r={},a="",n=e.match(fn);if(n)for(var s=0;s!=n.length;++s){var i=n[s],o=dt(i);switch(o[0]){case"<?xml":case"<Properties":break;case"<property":a=wt(o.name);break;case"</property>":a=null;break;default:if(0===i.indexOf("<vt:")){var c=i.split(">"),l=c[0].slice(4),f=c[1];switch(l){case"lpstr":case"bstr":case"lpwstr":r[a]=wt(f);break;case"bool":r[a]=Rt(f);break;case"i1":case"i2":case"i4":case"i8":case"int":case"uint":r[a]=parseInt(f,10);break;case"r4":case"r8":case"decimal":r[a]=parseFloat(f);break;case"filetime":case"date":r[a]=He(f);break;case"cy":case"error":r[a]=wt(f);break;default:if("/"==l.slice(-1))break;t.WTF&&"undefined"!=typeof console&&console.warn("Unexpected",i,l,c)}}else if("</"!==i.slice(0,2)&&t.WTF)throw new Error(i)}}return r}(m,t));var b={};if((t.bookSheets||t.bookProps)&&(d.Sheets?e=d.Sheets.map(function(e){return e.name}):p.Worksheets&&0<p.SheetNames.length&&(e=p.SheetNames),t.bookProps&&(b.Props=p,b.Custprops=g),t.bookSheets&&void 0!==e&&(b.SheetNames=e),t.bookSheets?b.SheetNames:t.bookProps))return b;e={};m={};t.bookDeps&&i.calcchain&&(m=ff(et(r,Hh(i.calcchain)),i.calcchain));var v,w,T=0,E={},k=d.Sheets;p.Worksheets=k.length,p.SheetNames=[];for(var y=0;y!=k.length;++y)p.SheetNames[y]=k[y].name;var S=o?"bin":"xml",o=i.workbooks[0].lastIndexOf("/"),_=(i.workbooks[0].slice(0,o+1)+"_rels/"+i.workbooks[0].slice(o+1)+".rels").replace(/^\//,"");Ze(r,_)||(_="xl/_rels/workbook."+S+".rels");var x,A,C,R=Ya(tt(r,_,!0),_.replace(/_rels.*/,"s5s"));1<=(i.metadata||[]).length&&(t.xlmeta=uf(et(r,Hh(i.metadata[0])),i.metadata[0],t)),1<=(i.people||[]).length&&(t.people=(o=et(r,Hh(i.people[0])),x=t,C=!(A=[]),o.replace(ft,function(e){var t=dt(e);switch(pt(t[0])){case"<?xml":case"<personList":case"</personList>":break;case"<person":A.push({name:t.displayname,id:t.id});break;case"</person>":break;case"<extLst":case"<extLst>":case"</extLst>":case"<extLst/>":break;case"<ext":C=!0;break;case"</ext>":C=!1;break;default:if(!C&&x.WTF)throw new Error("unrecognized "+t[0]+" in threaded comments")}return e}),A)),R=R&&Bh(R,d.Sheets);var O=et(r,"xl/worksheets/sheet.xml",!0)?1:0;e:for(T=0;T!=p.Worksheets;++T){var I="sheet";if(R&&R[T]?(v="xl/"+R[T][1].replace(/[\/]?xl\//,""),Ze(r,v)||(v=R[T][1]),Ze(r,v)||(v=_.replace(/_rels\/.*$/,"")+R[T][1]),I=R[T][2]):v=(v="xl/worksheets/sheet"+(T+1-O)+"."+S).replace(/sheet0\./,"sheet."),w=v.replace(/^(.*)(\/)([^\/]*)$/,"$1/_rels/$3.rels"),t&&null!=t.sheets)switch(typeof t.sheets){case"number":if(T!=t.sheets)continue e;break;case"string":if(p.SheetNames[T].toLowerCase()!=t.sheets.toLowerCase())continue e;break;default:if(Array.isArray&&Array.isArray(t.sheets)){for(var N=!1,F=0;F!=t.sheets.length;++F)"number"==typeof t.sheets[F]&&t.sheets[F]==T&&(N=1),"string"==typeof t.sheets[F]&&t.sheets[F].toLowerCase()==p.SheetNames[T].toLowerCase()&&(N=1);if(!N)continue e}}Wh(r,v,w,p.SheetNames[T],T,E,e,I,t,d,c,l)}return b={Directory:i,Workbook:d,Props:p,Custprops:g,Deps:m,Sheets:e,SheetNames:p.SheetNames,Strings:Yc,Styles:l,Themes:c,SSF:Ve(me)},t&&t.bookFiles&&(r.files?(b.keys=s,b.files=r.files):(b.keys=[],b.files={},r.FullPaths.forEach(function(e,t){e=e.replace(/^Root Entry[\/]/,""),b.keys.push(e),b.files[e]=r.FileIndex[t]}))),t&&t.bookVBA&&(0<i.vba.length?b.vbaraw=et(r,Hh(i.vba[0]),!0):i.defaults&&i.defaults.bin===ac&&(b.vbaraw=et(r,"xl/vbaProject.bin",!0))),b}function Vh(e,t){var r,a=t||{},n="Workbook",s=xe.find(e,n);try{if(n="/!DataSpaces/Version",!(s=xe.find(e,n))||!s.content)throw new Error("ECMA-376 Encrypted file missing "+n);if(i=s.content,(r={}).id=i.read_shift(0,"lpp4"),r.R=Li(i,4),r.U=Li(i,4),r.W=Li(i,4),n="/!DataSpaces/DataSpaceMap",!(s=xe.find(e,n))||!s.content)throw new Error("ECMA-376 Encrypted file missing "+n);var i=Mi(s.content);if(1!==i.length||1!==i[0].comps.length||0!==i[0].comps[0].t||"StrongEncryptionDataSpace"!==i[0].name||"EncryptedPackage"!==i[0].comps[0].v)throw new Error("ECMA-376 Encrypted file bad "+n);if(n="/!DataSpaces/DataSpaceInfo/StrongEncryptionDataSpace",!(s=xe.find(e,n))||!s.content)throw new Error("ECMA-376 Encrypted file missing "+n);i=function(e){var t=[];e.l+=4;for(var r=e.read_shift(4);0<r--;)t.push(e.read_shift(0,"lpp4"));return t}(s.content);if(1!=i.length||"StrongEncryptionTransform"!=i[0])throw new Error("ECMA-376 Encrypted file bad "+n);if(n="/!DataSpaces/TransformInfo/StrongEncryptionTransform/!Primary",!(s=xe.find(e,n))||!s.content)throw new Error("ECMA-376 Encrypted file missing "+n);Ui(s.content)}catch(e){}if(n="/EncryptionInfo",!(s=xe.find(e,n))||!s.content)throw new Error("ECMA-376 Encrypted file missing "+n);t=Hi(s.content),n="/EncryptedPackage";if(!(s=xe.find(e,n))||!s.content)throw new Error("ECMA-376 Encrypted file missing "+n);if(4==t[0]&&"undefined"!=typeof decrypt_agile)return decrypt_agile(t[1],s.content,a.password||"",a);if(2==t[0]&&"undefined"!=typeof decrypt_std76)return decrypt_std76(t[1],s.content,a.password||"",a);throw new Error("File is password-protected")}function Gh(e,t){return("ods"==t.bookType?lh:"numbers"==t.bookType?Ph:"xlsb"==t.bookType?function(e,t){Zo=1024,e&&!e.SSF&&(e.SSF=Ve(me));e&&e.SSF&&(Ee(),Te(e.SSF),t.revssf=Ne(e.SSF),t.revssf[e.SSF[65535]]=0,t.ssf=e.SSF);t.rels={},t.wbrels={},t.Strings=[],t.Strings.Count=0,t.Strings.Unique=0,Jc?t.revStrings=new Map:(t.revStrings={},t.revStrings.foo=[],delete t.revStrings.foo);var r="xlsb"==t.bookType?"bin":"xml",a=-1<nc.indexOf(t.bookType),n=Ga();Uh(t=t||{});var s=nt(),i="",o=0;t.cellXfs=[],el(t.cellXfs,{},{revssf:{General:0}}),e.Props||(e.Props={});if(at(s,i="docProps/core.xml",nn(e.Props,t)),n.coreprops.push(i),Ja(t.rels,2,i,$a.CORE_PROPS),i="docProps/app.xml",!e.Props||!e.Props.SheetNames)if(e.Workbook&&e.Workbook.Sheets){for(var c=[],l=0;l<e.SheetNames.length;++l)2!=(e.Workbook.Sheets[l]||{}).Hidden&&c.push(e.SheetNames[l]);e.Props.SheetNames=c}else e.Props.SheetNames=e.SheetNames;e.Props.Worksheets=e.Props.SheetNames.length,at(s,i,ln(e.Props)),n.extprops.push(i),Ja(t.rels,3,i,$a.EXT_PROPS),e.Custprops!==e.Props&&0<Re(e.Custprops||{}).length&&(at(s,i="docProps/custom.xml",hn(e.Custprops)),n.custprops.push(i),Ja(t.rels,4,i,$a.CUST_PROPS));for(o=1;o<=e.SheetNames.length;++o){var f,h,u,d={"!id":{}},p=e.Sheets[e.SheetNames[o-1]];at(s,i="xl/worksheets/sheet"+o+"."+r,function(e,t,r,a,n){return(".bin"===t.slice(-4)?Bl:xl)(e,r,a,n)}(o-1,i,t,e,d)),n.sheets.push(i),Ja(t.wbrels,-1,"worksheets/sheet"+o+"."+r,$a.WS[0]),p&&(f=p["!comments"],h=!1,u="",f&&0<f.length&&(at(s,u="xl/comments"+o+"."+r,function(e,t,r){return(".bin"===t.slice(-4)?rc:tc)(e,r)}(f,u,t)),n.comments.push(u),Ja(d,-1,"../comments"+o+"."+r,$a.CMNT),h=!0),p["!legacy"]&&h&&at(s,"xl/drawings/vmlDrawing"+o+".vml",Qo(o,p["!comments"])),delete p["!comments"],delete p["!legacy"]),d["!id"].rId1&&at(s,Xa(i),Ka(d))}null!=t.Strings&&0<t.Strings.length&&(at(s,i="xl/sharedStrings."+r,function(e,t,r){return(".bin"===t.slice(-4)?Di:Ni)(e,r)}(t.Strings,i,t)),n.strs.push(i),Ja(t.wbrels,-1,"sharedStrings."+r,$a.SST));at(s,i="xl/workbook."+r,function(e,t,r){return(".bin"===t.slice(-4)?rf:Zl)(e,r)}(e,i,t)),n.workbooks.push(i),Ja(t.rels,1,i,$a.WB),at(s,i="xl/theme/theme1.xml",Xo(e.Themes,t)),n.themes.push(i),Ja(t.wbrels,-1,"theme/theme1.xml",$a.THEME),at(s,i="xl/styles."+r,function(e,t,r){return(".bin"===t.slice(-4)?Mo:_o)(e,r)}(e,i,t)),n.styles.push(i),Ja(t.wbrels,-1,"styles."+r,$a.STY),e.vbaraw&&a&&(at(s,i="xl/vbaProject.bin",e.vbaraw),n.vba.push(i),Ja(t.wbrels,-1,"vbaProject.bin",$a.VBA));return at(s,i="xl/metadata."+r,function(e){return(".bin"===e.slice(-4)?Jo:qo)()}(i)),n.metadata.push(i),Ja(t.wbrels,-1,"metadata."+r,$a.XLMETA),at(s,"[Content_Types].xml",ja(n,t)),at(s,"_rels/.rels",Ka(t.rels)),at(s,"xl/_rels/workbook."+r+".rels",Ka(t.wbrels)),delete t.revssf,delete t.ssf,s}:jh)(e,t)}function jh(e,t){Zo=1024,e&&!e.SSF&&(e.SSF=Ve(me)),e&&e.SSF&&(Ee(),Te(e.SSF),t.revssf=Ne(e.SSF),t.revssf[e.SSF[65535]]=0,t.ssf=e.SSF),t.rels={},t.wbrels={},t.Strings=[],t.Strings.Count=0,t.Strings.Unique=0,Jc?t.revStrings=new Map:(t.revStrings={},t.revStrings.foo=[],delete t.revStrings.foo);var r="xml",a=-1<nc.indexOf(t.bookType),n=Ga();Uh(t=t||{});var s=nt(),i="",o=0;if(t.cellXfs=[],el(t.cellXfs,{},{revssf:{General:0}}),e.Props||(e.Props={}),i="docProps/core.xml",at(s,i,nn(e.Props,t)),n.coreprops.push(i),Ja(t.rels,2,i,$a.CORE_PROPS),i="docProps/app.xml",!e.Props||!e.Props.SheetNames)if(e.Workbook&&e.Workbook.Sheets){for(var c=[],l=0;l<e.SheetNames.length;++l)2!=(e.Workbook.Sheets[l]||{}).Hidden&&c.push(e.SheetNames[l]);e.Props.SheetNames=c}else e.Props.SheetNames=e.SheetNames;e.Props.Worksheets=e.Props.SheetNames.length,at(s,i,ln(e.Props)),n.extprops.push(i),Ja(t.rels,3,i,$a.EXT_PROPS),e.Custprops!==e.Props&&0<Re(e.Custprops||{}).length&&(at(s,i="docProps/custom.xml",hn(e.Custprops)),n.custprops.push(i),Ja(t.rels,4,i,$a.CUST_PROPS));var f,h=["SheetJ5"];for(t.tcid=0,o=1;o<=e.SheetNames.length;++o){var u,d,p,m,g={"!id":{}},b=e.Sheets[e.SheetNames[o-1]];at(s,i="xl/worksheets/sheet"+o+"."+r,xl(o-1,t,e,g)),n.sheets.push(i),Ja(t.wbrels,-1,"worksheets/sheet"+o+"."+r,$a.WS[0]),b&&(d=!1,p="",(u=b["!comments"])&&0<u.length&&(m=!1,u.forEach(function(e){e[1].forEach(function(e){1==e.T&&(m=!0)})}),m&&(at(s,p="xl/threadedComments/threadedComment"+o+"."+r,function(e,s,i){var o=[ot,Yt("ThreadedComments",null,{xmlns:Zt.TCMNT}).replace(/[\/]>/,">")];return e.forEach(function(a){var n="";(a[1]||[]).forEach(function(e,t){var r;e.T?(e.a&&-1==s.indexOf(e.a)&&s.push(e.a),r={ref:a[0],id:"{54EE7951-7262-4200-6969-"+("000000000000"+i.tcid++).slice(-12)+"}"},0==t?n=r.id:r.parentId=n,e.ID=r.id,e.a&&(r.personId="{54EE7950-7262-4200-6969-"+("000000000000"+s.indexOf(e.a)).slice(-12)+"}"),o.push(Yt("threadedComment",$t("text",e.t||""),r))):delete e.ID})}),o.push("</ThreadedComments>"),o.join("")}(u,h,t)),n.threadedcomments.push(p),Ja(g,-1,"../threadedComments/threadedComment"+o+"."+r,$a.TCMNT)),at(s,p="xl/comments"+o+"."+r,tc(u)),n.comments.push(p),Ja(g,-1,"../comments"+o+"."+r,$a.CMNT),d=!0),b["!legacy"]&&d&&at(s,"xl/drawings/vmlDrawing"+o+".vml",Qo(o,b["!comments"])),delete b["!comments"],delete b["!legacy"]),g["!id"].rId1&&at(s,Xa(i),Ka(g))}return null!=t.Strings&&0<t.Strings.length&&(at(s,i="xl/sharedStrings.xml",Ni(t.Strings,t)),n.strs.push(i),Ja(t.wbrels,-1,"sharedStrings.xml",$a.SST)),at(s,i="xl/workbook.xml",Zl(e)),n.workbooks.push(i),Ja(t.rels,1,i,$a.WB),at(s,i="xl/theme/theme1.xml",Xo(e.Themes,t)),n.themes.push(i),Ja(t.wbrels,-1,"theme/theme1.xml",$a.THEME),at(s,i="xl/styles.xml",_o(e,t)),n.styles.push(i),Ja(t.wbrels,-1,"styles.xml",$a.STY),e.vbaraw&&a&&(at(s,i="xl/vbaProject.bin",e.vbaraw),n.vba.push(i),Ja(t.wbrels,-1,"vbaProject.bin",$a.VBA)),at(s,i="xl/metadata.xml",qo()),n.metadata.push(i),Ja(t.wbrels,-1,"metadata.xml",$a.XLMETA),1<h.length&&(at(s,i="xl/persons/person.xml",(a=h,f=[ot,Yt("personList",null,{xmlns:Zt.TCMNT,"xmlns:x":Qt[0]}).replace(/[\/]>/,">")],a.forEach(function(e,t){f.push(Yt("person",null,{displayName:e,id:"{54EE7950-7262-4200-6969-"+("000000000000"+t).slice(-12)+"}",userId:e,providerId:"None"}))}),f.push("</personList>"),f.join(""))),n.people.push(i),Ja(t.wbrels,-1,"persons/person.xml",$a.PEOPLE)),at(s,"[Content_Types].xml",ja(n,t)),at(s,"_rels/.rels",Ka(t.rels)),at(s,"xl/_rels/workbook.xml.rels",Ka(t.wbrels)),delete t.revssf,delete t.ssf,s}function $h(e,t){var r="";switch((t||{}).type||"base64"){case"buffer":return[e[0],e[1],e[2],e[3],e[4],e[5],e[6],e[7]];case"base64":r=te(e.slice(0,12));break;case"binary":r=e;break;case"array":return[e[0],e[1],e[2],e[3],e[4],e[5],e[6],e[7]];default:throw new Error("Unrecognized type "+(t&&t.type||"undefined"))}return[r.charCodeAt(0),r.charCodeAt(1),r.charCodeAt(2),r.charCodeAt(3),r.charCodeAt(4),r.charCodeAt(5),r.charCodeAt(6),r.charCodeAt(7)]}function Xh(e,t){var r=0;e:for(;r<e.length;)switch(e.charCodeAt(r)){case 10:case 13:case 32:++r;break;case 60:return wf(e.slice(r),t);default:break e}return Ks.to_workbook(e,t)}function Yh(e,t,r,a){return a?(r.type="string",Ks.to_workbook(e,r)):Ks.to_workbook(t,r)}function Kh(e,t){h();var r=t||{};if("undefined"!=typeof ArrayBuffer&&e instanceof ArrayBuffer)return Kh(new Uint8Array(e),((r=Ve(r)).type="array",r));"undefined"!=typeof Uint8Array&&e instanceof Uint8Array&&!r.type&&(r.type="undefined"!=typeof Deno?"buffer":"array");var a,n,s,i,o,c=e,l=!1;if(r.cellStyles&&(r.cellNF=!0,r.sheetStubs=!0),Kc={},r.dateNF&&(Kc.dateNF=r.dateNF),r.type||(r.type=se&&Buffer.isBuffer(e)?"buffer":"base64"),"file"==r.type&&(r.type=se?"buffer":"binary",c=function(e){if(void 0!==Se)return Se.readFileSync(e);if("undefined"!=typeof Deno)return Deno.readFileSync(e);if("undefined"!=typeof $&&"undefined"!=typeof File&&"undefined"!=typeof Folder)try{var t=File(e);t.open("r"),t.encoding="binary";var r=t.read();return t.close(),r}catch(e){if(!e.message||!e.message.match(/onstruct/))throw e}throw new Error("Cannot access file "+e)}(e),"undefined"==typeof Uint8Array||se||(r.type="array")),"string"==r.type&&(l=!0,r.type="binary",r.codepage=65001,c=(f=e).match(/[^\x00-\x7F]/)?Ut(f):f),"array"==r.type&&"undefined"!=typeof Uint8Array&&e instanceof Uint8Array&&"undefined"!=typeof ArrayBuffer){var f=new ArrayBuffer(3),f=new Uint8Array(f);if(f.foo="bar",!f.foo)return(r=Ve(r)).type="array",Kh(m(c),r)}switch((a=$h(c,r))[0]){case 208:if(207===a[1]&&17===a[2]&&224===a[3]&&161===a[4]&&177===a[5]&&26===a[6]&&225===a[7])return i=xe.read(c,r),o=r,(xe.find(i,"EncryptedPackage")?Vh:Nf)(i,o);break;case 9:if(a[1]<=8)return Nf(c,r);break;case 60:return wf(c,r);case 73:if(73===a[1]&&42===a[2]&&0===a[3])throw new Error("TIFF Image File is not a spreadsheet");if(68===a[1])return function(t,r){var a=r||{},n=!!a.WTF;a.WTF=!0;try{var e=Ns.to_workbook(t,a);return a.WTF=n,e}catch(e){if(a.WTF=n,!e.message.match(/SYLK bad record ID/)&&n)throw e;return Ks.to_workbook(t,r)}}(c,r);break;case 84:if(65===a[1]&&66===a[2]&&76===a[3])return Ps.to_workbook(c,r);break;case 80:return 75===a[1]&&a[2]<9&&a[3]<9?(s=o=c,(n=(n=r)||{}).type||(n.type=se&&Buffer.isBuffer(o)?"buffer":"base64"),zh(st(s,n),n)):Yh(e,c,r,l);case 239:return 60===a[3]?wf(c,r):Yh(e,c,r,l);case 255:if(254===a[1])return s=c,"base64"==(n=r).type&&(s=te(s)),s=re.utils.decode(1200,s.slice(2),"str"),n.type="binary",Xh(s,n);if(0===a[1]&&2===a[2]&&0===a[3])return si.to_workbook(c,r);break;case 0:if(0===a[1]){if(2<=a[2]&&0===a[3])return si.to_workbook(c,r);if(0===a[2]&&(8===a[3]||9===a[3]))return si.to_workbook(c,r)}break;case 3:case 131:case 139:case 140:return xs.to_workbook(c,r);case 123:if(92===a[1]&&114===a[2]&&116===a[3])return Ji.to_workbook(c,r);break;case 10:case 13:case 32:return function(e,t){var r="",a=$h(e,t);switch(t.type){case"base64":r=te(e);break;case"binary":r=e;break;case"buffer":r=e.toString("binary");break;case"array":r=ze(e);break;default:throw new Error("Unrecognized type "+t.type)}return 239==a[0]&&187==a[1]&&191==a[2]&&(r=Mt(r)),t.type="binary",Xh(r,t)}(c,r);case 137:if(80===a[1]&&78===a[2]&&71===a[3])throw new Error("PNG Image File is not a spreadsheet")}return-1<_s.indexOf(a[0])&&a[2]<=12&&a[3]<=31?xs.to_workbook(c,r):Yh(e,c,r,l)}function Jh(e,t){t=t||{};return t.type="file",Kh(e,t)}function qh(e,t){switch(t.type){case"base64":case"binary":break;case"buffer":case"array":t.type="";break;case"file":return Ce(t.file,xe.write(e,{type:se?"buffer":""}));case"string":throw new Error("'string' output type invalid for '"+t.bookType+"' files");default:throw new Error("Unrecognized type "+t.type)}return xe.write(e,t)}function Zh(e,t){var r={},a=se?"nodebuffer":"undefined"!=typeof Uint8Array?"array":"string";if(t.compression&&(r.compression="DEFLATE"),t.password)r.type=a;else switch(t.type){case"base64":r.type="base64";break;case"binary":r.type="string";break;case"string":throw new Error("'string' output type invalid for '"+t.bookType+"' files");case"buffer":case"file":r.type=a;break;default:throw new Error("Unrecognized type "+t.type)}e=e.FullPaths?xe.write(e,{fileType:"zip",type:{nodebuffer:"buffer",string:"binary"}[r.type]||r.type,compression:!!t.compression}):e.generate(r);if("undefined"!=typeof Deno&&"string"==typeof e){if("binary"==t.type||"base64"==t.type)return e;e=new Uint8Array(o(e))}return t.password&&"undefined"!=typeof encrypt_agile?qh(encrypt_agile(e,t.password),t):"file"===t.type?Ce(t.file,e):"string"==t.type?Mt(e):e}function Qh(e,t,r){var a=(r=r||"")+e;switch(t.type){case"base64":return ee(Ut(a));case"binary":return Ut(a);case"string":return e;case"file":return Ce(t.file,a,"utf8");case"buffer":return se?ce(a,"utf8"):"undefined"!=typeof TextEncoder?(new TextEncoder).encode(a):Qh(a,{type:"binary"}).split("").map(function(e){return e.charCodeAt(0)})}throw new Error("Unrecognized type "+t.type)}function eu(e,t){switch(t.type){case"string":case"base64":case"binary":for(var r="",a=0;a<e.length;++a)r+=String.fromCharCode(e[a]);return"base64"==t.type?ee(r):"string"==t.type?Mt(r):r;case"file":return Ce(t.file,e);case"buffer":return e;default:throw new Error("Unrecognized type "+t.type)}}function tu(e,t){h(),Jl(e);var r,a=Ve(t||{});if(a.cellStyles&&(a.cellNF=!0,a.sheetStubs=!0),"array"!=a.type)return r=e,t=Ve((t=a)||{}),Zh(jh(r,t),t);a.type="binary";e=tu(e,a);return a.type="array",o(e)}function ru(e,t){h(),Jl(e);var r=Ve(t||{});if(r.cellStyles&&(r.cellNF=!0,r.sheetStubs=!0),"array"==r.type){r.type="binary";t=ru(e,r);return r.type="array",o(t)}var a,n,s,i=0;if(r.sheet&&(i="number"==typeof r.sheet?r.sheet:e.SheetNames.indexOf(r.sheet),!e.SheetNames[i]))throw new Error("Sheet not found: "+r.sheet+" : "+typeof r.sheet);switch(r.bookType||"xlsb"){case"xml":case"xlml":return Qh(_f(e,r),r);case"slk":case"sylk":return Qh(Ns.from_sheet(e.Sheets[e.SheetNames[i]],r),r);case"htm":case"html":return Qh(Qf(e.Sheets[e.SheetNames[i]],r),r);case"txt":return function(e,t){switch(t.type){case"base64":return ee(e);case"binary":case"string":return e;case"file":return Ce(t.file,e,"binary");case"buffer":return se?ce(e,"binary"):e.split("").map(function(e){return e.charCodeAt(0)})}throw new Error("Unrecognized type "+t.type)}(fu(e.Sheets[e.SheetNames[i]],r),r);case"csv":return Qh(lu(e.Sheets[e.SheetNames[i]],r),r,"\ufeff");case"dif":return Qh(Ps.from_sheet(e.Sheets[e.SheetNames[i]],r),r);case"dbf":return eu(xs.from_sheet(e.Sheets[e.SheetNames[i]],r),r);case"prn":return Qh(Ks.from_sheet(e.Sheets[e.SheetNames[i]],r),r);case"rtf":return Qh(Ji.from_sheet(e.Sheets[e.SheetNames[i]],r),r);case"eth":return Qh(Gs.from_sheet(e.Sheets[e.SheetNames[i]],r),r);case"fods":return Qh(lh(e,r),r);case"wk1":return eu(si.sheet_to_wk1(e.Sheets[e.SheetNames[i]],r),r);case"wk3":return eu(si.book_to_wk3(e,r),r);case"biff2":r.biff||(r.biff=2);case"biff3":r.biff||(r.biff=3);case"biff4":return r.biff||(r.biff=4),eu(Xf(e,r),r);case"biff5":r.biff||(r.biff=5);case"biff8":case"xla":case"xls":return r.biff||(r.biff=8),qh(Ff(e,s=(s=r)||{}),s);case"xlsx":case"xlsm":case"xlam":case"xlsb":case"numbers":case"ods":return a=e,s=Ve((n=r)||{}),yo=new wu(n),Zh(Gh(a,s),s);default:throw new Error("Unrecognized bookType |"+r.bookType+"|")}}function au(e){var t;e.bookType||((t=e.file.slice(e.file.lastIndexOf(".")).toLowerCase()).match(/^\.[a-z]+$/)&&(e.bookType=t.slice(1)),e.bookType={xls:"biff8",htm:"html",slk:"sylk",socialcalc:"eth",Sh33tJS:"WTF"}[e.bookType]||e.bookType)}function nu(e,t,r){r=r||{};return r.type="file",r.file=t,au(r),ru(e,r)}function su(e,t,r,a,n,s,i,o){var c=jr(r),l=o.defval,f=o.raw||!Object.prototype.hasOwnProperty.call(o,"raw"),h=!0,u=1===n?[]:{};if(1!==n)if(Object.defineProperty)try{Object.defineProperty(u,"__rowNum__",{value:r,enumerable:!1})}catch(e){u.__rowNum__=r}else u.__rowNum__=r;if(!i||e[r])for(var d=t.s.c;d<=t.e.c;++d){var p=i?e[r][d]:e[a[d]+c];if(void 0!==p&&void 0!==p.t){var m=p.v;switch(p.t){case"z":if(null==m)break;continue;case"e":m=0==m?null:void 0;break;case"s":case"d":case"b":case"n":break;default:throw new Error("unrecognized type "+p.t)}if(null!=s[d]){if(null==m)if("e"==p.t&&null===m)u[s[d]]=null;else if(void 0!==l)u[s[d]]=l;else{if(!f||null!==m)continue;u[s[d]]=null}else u[s[d]]=f&&("n"!==p.t||"n"===p.t&&!1!==o.rawNumbers)?m:ea(p,m,o);null!=m&&(h=!1)}}else void 0!==l&&null!=s[d]&&(u[s[d]]=l)}return{row:u,isempty:h}}function iu(e,t){if(null==e||null==e["!ref"])return[];var r,a={t:"n",v:0},n=0,s=1,i=[],o="",c={s:{r:0,c:0},e:{r:0,c:0}},l=t||{},f=null!=l.range?l.range:e["!ref"];switch(1===l.header?n=1:"A"===l.header?n=2:Array.isArray(l.header)?n=3:null==l.header&&(n=0),typeof f){case"string":c=Zr(f);break;case"number":(c=Zr(e["!ref"])).s.r=f;break;default:c=f}0<n&&(s=0);var h=jr(c.s.r),u=[],d=[],p=0,m=0,g=Array.isArray(e),b=c.s.r,v=0,w={};g&&!e[b]&&(e[b]=[]);for(var T,E=l.skipHidden&&e["!cols"]||[],k=l.skipHidden&&e["!rows"]||[],v=c.s.c;v<=c.e.c;++v)if(!(E[v]||{}).hidden)switch(u[v]=Xr(v),a=g?e[b][v]:e[u[v]+h],n){case 1:i[v]=v-c.s.c;break;case 2:i[v]=u[v];break;case 3:i[v]=l.header[v-c.s.c];break;default:if(o=r=ea(a=null==a?{w:"__EMPTY",t:"s"}:a,null,l),m=w[r]||0){for(;o=r+"_"+m++,w[o];);w[r]=m,w[o]=1}else w[r]=1;i[v]=o}for(b=c.s.r+s;b<=c.e.r;++b)(k[b]||{}).hidden||(!1!==(T=su(e,c,b,u,n,i,g,l)).isempty&&(1===n?!1===l.blankrows:!l.blankrows)||(d[p++]=T.row));return d.length=p,d}var ou=/"/g;function cu(e,t,r,a,n,s,i,o){for(var c=!0,l=[],f="",h=jr(r),u=t.s.c;u<=t.e.c;++u)if(a[u]){var d=o.dense?(e[r]||[])[u]:e[a[u]+h];if(null==d)f="";else if(null!=d.v){c=!1,f=""+(o.rawNumbers&&"n"==d.t?d.v:ea(d,null,o));for(var p,m=0;m!==f.length;++m)if((p=f.charCodeAt(m))===n||p===s||34===p||o.forceQuotes){f='"'+f.replace(ou,'""')+'"';break}"ID"==f&&(f='"ID"')}else null==d.f||d.F?f="":(c=!1,0<=(f="="+d.f).indexOf(",")&&(f='"'+f.replace(ou,'""')+'"'));l.push(f)}return!1===o.blankrows&&c?null:l.join(i)}function lu(e,t){var r=[],a=null==t?{}:t;if(null==e||null==e["!ref"])return"";var n=Zr(e["!ref"]),s=void 0!==a.FS?a.FS:",",i=s.charCodeAt(0),o=void 0!==a.RS?a.RS:"\n",c=o.charCodeAt(0),l=new RegExp(("|"==s?"\\|":s)+"+$"),f="",h=[];a.dense=Array.isArray(e);for(var u=a.skipHidden&&e["!cols"]||[],d=a.skipHidden&&e["!rows"]||[],p=n.s.c;p<=n.e.c;++p)(u[p]||{}).hidden||(h[p]=Xr(p));for(var m=0,g=n.s.r;g<=n.e.r;++g)(d[g]||{}).hidden||null!=(f=cu(e,n,g,h,i,c,s,a))&&(!(f=a.strip?f.replace(l,""):f)&&!1===a.blankrows||r.push((m++?o:"")+f));return delete a.dense,r.join("")}function fu(e,t){(t=t||{}).FS="\t",t.RS="\n";e=lu(e,t);if(void 0===re||"string"==t.type)return e;e=re.utils.encode(1200,e,"str");return String.fromCharCode(255)+String.fromCharCode(254)+e}function hu(e,t,r){var i,o=r||{},c=+!o.skipHeader,l=e||{},f=0,h=0;l&&null!=o.origin&&("number"==typeof o.origin?f=o.origin:(a="string"==typeof o.origin?Yr(o.origin):o.origin,f=a.r,h=a.c));var a,e={s:{c:0,r:0},e:{c:h,r:f+t.length-1+c}};l["!ref"]?(a=Zr(l["!ref"]),e.e.c=Math.max(e.e.c,a.e.c),e.e.r=Math.max(e.e.r,a.e.r),-1==f&&(f=a.e.r+1,e.e.r=f+t.length-1+c)):-1==f&&(f=0,e.e.r=t.length-1+c);var u=o.header||[],d=0;t.forEach(function(n,s){Re(n).forEach(function(e){-1==(d=u.indexOf(e))&&(u[d=u.length]=e);var t=n[e],r="z",a="",e=Kr({c:h+d,r:f+s+c});i=uu(l,e),!t||"object"!=typeof t||t instanceof Date?("number"==typeof t?r="n":"boolean"==typeof t?r="b":"string"==typeof t?r="s":t instanceof Date?(r="d",o.cellDates||(r="n",t=De(t)),a=o.dateNF||me[14]):null===t&&o.nullError&&(r="e",t=0),i?(i.t=r,i.v=t,delete i.w,delete i.R,a&&(i.z=a)):l[e]=i={t:r,v:t},a&&(i.z=a)):l[e]=t})}),e.e.c=Math.max(e.e.c,h+u.length-1);var n=jr(f);if(c)for(d=0;d<u.length;++d)l[Xr(d+h)+n]={t:"s",v:u[d]};return l["!ref"]=qr(e),l}function uu(e,t,r){if("string"!=typeof t)return uu(e,Kr("number"!=typeof t?t:{r:t,c:r||0}));if(Array.isArray(e)){r=Yr(t);return e[r.r]||(e[r.r]=[]),e[r.r][r.c]||(e[r.r][r.c]={t:"z"})}return e[t]||(e[t]={t:"z"})}function du(){return{SheetNames:[],Sheets:{}}}function pu(e,t,r,a){var n=1;if(!r)for(;n<=65535&&-1!=e.SheetNames.indexOf(r="Sheet"+n);++n,r=void 0);if(!r||65535<=e.SheetNames.length)throw new Error("Too many worksheets");if(a&&0<=e.SheetNames.indexOf(r)){var a=r.match(/(^.*?)(\d+)$/),n=a&&+a[2]||0,s=a&&a[1]||r;for(++n;n<=65535&&-1!=e.SheetNames.indexOf(r=s+n);++n);}if(Kl(r),0<=e.SheetNames.indexOf(r))throw new Error("Worksheet with name |"+r+"| already exists!");return e.SheetNames.push(r),e.Sheets[r]=t,r}function mu(e,t,r){return t?(e.l={Target:t},r&&(e.l.Tooltip=r)):delete e.l,e}var gu,Es={encode_col:Xr,encode_row:jr,encode_cell:Kr,encode_range:qr,decode_col:$r,decode_row:Gr,split_cell:function(e){return e.replace(/(\$?[A-Z]*)(\$?\d*)/,"$1,$2").split(",")},decode_cell:Yr,decode_range:Jr,format_cell:ea,sheet_add_aoa:ra,sheet_add_json:hu,sheet_add_dom:eh,aoa_to_sheet:aa,json_to_sheet:function(e,t){return hu(null,e,t)},table_to_sheet:th,table_to_book:function(e,t){return ta(th(e,t),t)},sheet_to_csv:lu,sheet_to_txt:fu,sheet_to_json:iu,sheet_to_html:Qf,sheet_to_formulae:function(e){var t,r="",a="";if(null==e||null==e["!ref"])return[];for(var n,s=Zr(e["!ref"]),i=[],o=[],c=Array.isArray(e),l=s.s.c;l<=s.e.c;++l)i[l]=Xr(l);for(var f=s.s.r;f<=s.e.r;++f)for(n=jr(f),l=s.s.c;l<=s.e.c;++l)if(r=i[l]+n,a="",void 0!==(t=c?(e[f]||[])[l]:e[r])){if(null!=t.F){if(r=t.F,!t.f)continue;a=t.f,-1==r.indexOf(":")&&(r=r+":"+r)}if(null!=t.f)a=t.f;else{if("z"==t.t)continue;if("n"==t.t&&null!=t.v)a=""+t.v;else if("b"==t.t)a=t.v?"TRUE":"FALSE";else if(void 0!==t.w)a="'"+t.w;else{if(void 0===t.v)continue;a="s"==t.t?"'"+t.v:""+t.v}}o[o.length]=r+"="+a}return o},sheet_to_row_object_array:iu,sheet_get_cell:uu,book_new:du,book_append_sheet:pu,book_set_sheet_visibility:function(e,t,r){switch(e.Workbook||(e.Workbook={}),e.Workbook.Sheets||(e.Workbook.Sheets=[]),t=function(e,t){if("number"==typeof t){if(0<=t&&e.SheetNames.length>t)return t;throw new Error("Cannot find sheet # "+t)}if("string"!=typeof t)throw new Error("Cannot find sheet |"+t+"|");if(-1<(e=e.SheetNames.indexOf(t)))return e;throw new Error("Cannot find sheet name |"+t+"|")}(e,t),e.Workbook.Sheets[t]||(e.Workbook.Sheets[t]={}),r){case 0:case 1:case 2:break;default:throw new Error("Bad sheet visibility setting "+r)}e.Workbook.Sheets[t].Hidden=r},cell_set_number_format:function(e,t){return e.z=t,e},cell_set_hyperlink:mu,cell_set_internal_link:function(e,t,r){return mu(e,"#"+t,r)},cell_add_comment:function(e,t,r){e.c||(e.c=[]),e.c.push({t:t,a:r||"SheetJS"})},sheet_set_array_formula:function(e,t,r,a){for(var n="string"!=typeof t?t:Zr(t),s="string"==typeof t?t:qr(t),i=n.s.r;i<=n.e.r;++i)for(var o=n.s.c;o<=n.e.c;++o){var c=uu(e,i,o);c.t="n",c.F=s,delete c.v,i==n.s.r&&o==n.s.c&&(c.f=r,a&&(c.D=!0))}return e},consts:{SHEET_VISIBLE:0,SHEET_HIDDEN:1,SHEET_VERY_HIDDEN:2}};function bu(e){gu=e}var is={to_json:function(t,e){var r=gu({objectMode:!0});if(null==t||null==t["!ref"])return r.push(null),r;var a,n={t:"n",v:0},s=0,i=1,o=[],c="",l={s:{r:0,c:0},e:{r:0,c:0}},f=e||{},h=null!=f.range?f.range:t["!ref"];switch(1===f.header?s=1:"A"===f.header?s=2:Array.isArray(f.header)&&(s=3),typeof h){case"string":l=Zr(h);break;case"number":(l=Zr(t["!ref"])).s.r=h;break;default:l=h}0<s&&(i=0);var u=jr(l.s.r),d=[],p=0,m=Array.isArray(t),g=l.s.r,b=0,v={};m&&!t[g]&&(t[g]=[]);for(var w=f.skipHidden&&t["!cols"]||[],T=f.skipHidden&&t["!rows"]||[],b=l.s.c;b<=l.e.c;++b)if(!(w[b]||{}).hidden)switch(d[b]=Xr(b),n=m?t[g][b]:t[d[b]+u],s){case 1:o[b]=b-l.s.c;break;case 2:o[b]=d[b];break;case 3:o[b]=f.header[b-l.s.c];break;default:if(c=a=ea(n=null==n?{w:"__EMPTY",t:"s"}:n,null,f),p=v[a]||0){for(;c=a+"_"+p++,v[c];);v[a]=p,v[c]=1}else v[a]=1;o[b]=c}return g=l.s.r+i,r._read=function(){for(;g<=l.e.r;)if(!(T[g-1]||{}).hidden){var e=su(t,l,g,d,s,o,m,f);if(++g,!1===e.isempty||(1===s?!1!==f.blankrows:f.blankrows))return void r.push(e.row)}return r.push(null)},r},to_html:function(e,t){var r=gu(),a=t||{},t=null!=a.header?a.header:Jf,n=null!=a.footer?a.footer:qf;r.push(t);var s=Jr(e["!ref"]);a.dense=Array.isArray(e),r.push(Zf(0,0,a));var i=s.s.r,o=!1;return r._read=function(){if(i>s.e.r)return o||(o=!0,r.push("</table>"+n)),r.push(null);for(;i<=s.e.r;){r.push(Kf(e,s,i,a)),++i;break}},r},to_csv:function(e,t){var r=gu(),a=null==t?{}:t;if(null==e||null==e["!ref"])return r.push(null),r;var n=Zr(e["!ref"]),s=void 0!==a.FS?a.FS:",",i=s.charCodeAt(0),o=void 0!==a.RS?a.RS:"\n",c=o.charCodeAt(0),l=new RegExp(("|"==s?"\\|":s)+"+$"),f="",h=[];a.dense=Array.isArray(e);for(var u=a.skipHidden&&e["!cols"]||[],d=a.skipHidden&&e["!rows"]||[],p=n.s.c;p<=n.e.c;++p)(u[p]||{}).hidden||(h[p]=Xr(p));var m=n.s.r,g=!1,b=0;return r._read=function(){if(!g)return g=!0,r.push("\ufeff");for(;m<=n.e.r;)if(++m,!(d[m-1]||{}).hidden&&(f=cu(e,n,m-1,h,i,c,s,a),null!=f&&((f=a.strip?f.replace(l,""):f)||!1!==a.blankrows)))return r.push((b++?o:"")+f);return r.push(null)},r},set_readable:bu},vu=function(){function a(e,t,r){return this instanceof a?(this.tagName=e,this._attributes=t||{},this._children=r||[],this._prefix="",this):new a(e,t,r)}a.prototype.createElement=function(){return new a(arguments)},a.prototype.children=function(){return this._children},a.prototype.append=function(e){return this._children.push(e),this},a.prototype.prefix=function(e){return 0==arguments.length?this._prefix:(this._prefix=e,this)},a.prototype.attr=function(e,t){if(null==t)return delete this._attributes[e],this;if(0==arguments.length)return this._attributes;if("string"==typeof e&&1==arguments.length)return this._attributes.attr[e];if("object"==typeof e&&1==arguments.length)for(var r in e)this._attributes[r]=e[r];else 2==arguments.length&&"string"==typeof e&&(this._attributes[e]=t);return this};return a.prototype.escapeAttributeValue=function(e){return'"'+e.replace(/\"/g,"&quot;")+'"'},a.prototype.toXml=function(e){var t=(e=e||this)._prefix;if(t+="<"+e.tagName,e._attributes)for(var r in e._attributes)t+=" "+r+"="+this.escapeAttributeValue(""+e._attributes[r]);if(e._children&&0<e._children.length){t+=">";for(var a=0;a<e._children.length;a++)t+=this.toXml(e._children[a]);t+="</"+e.tagName+">"}else t+="/>";return t},a}(),wu=function(e){var t,r=164,a={0:"General",1:"0",2:"0.00",3:"#,##0",4:"#,##0.00",9:"0%",10:"0.00%",11:"0.00E+00",12:"# ?/?",13:"# ??/??",14:"m/d/yy",15:"d-mmm-yy",16:"d-mmm",17:"mmm-yy",18:"h:mm AM/PM",19:"h:mm:ss AM/PM",20:"h:mm",21:"h:mm:ss",22:"m/d/yy h:mm",37:"#,##0 ;(#,##0)",38:"#,##0 ;[Red](#,##0)",39:"#,##0.00;(#,##0.00)",40:"#,##0.00;[Red](#,##0.00)",45:"mm:ss",46:"[h]:mm:ss",47:"mmss.0",48:"##0.0E+0",49:"@",56:'"上午/下午 "hh"時"mm"分"ss"秒 "'},n={};for(t in a)n[a[t]]=t;var s={};return{initialize:function(e){this.$fonts=vu("fonts").attr("count",0).attr("x14ac:knownFonts","1"),this.$fills=vu("fills").attr("count",0),this.$borders=vu("borders").attr("count",0),this.$numFmts=vu("numFmts").attr("count",0),this.$cellStyleXfs=vu("cellStyleXfs"),this.$xf=vu("xf").attr("numFmtId",0).attr("fontId",0).attr("fillId",0).attr("borderId",0),this.$cellXfs=vu("cellXfs").attr("count",0),this.$cellStyles=vu("cellStyles").append(vu("cellStyle").attr("name","Normal").attr("xfId",0).attr("builtinId",0)),this.$dxfs=vu("dxfs").attr("count","0"),this.$tableStyles=vu("tableStyles").attr("count","0").attr("defaultTableStyle","TableStyleMedium9").attr("defaultPivotStyle","PivotStyleMedium4"),this.$styles=vu("styleSheet").attr("xmlns:mc","http://schemas.openxmlformats.org/markup-compatibility/2006").attr("xmlns:x14ac","http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac").attr("xmlns","http://schemas.openxmlformats.org/spreadsheetml/2006/main").attr("mc:Ignorable","x14ac").prefix('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>').append(this.$numFmts).append(this.$fonts).append(this.$fills).append(this.$borders).append(this.$cellStyleXfs.append(this.$xf)).append(this.$cellXfs).append(this.$cellStyles).append(this.$dxfs).append(this.$tableStyles);var t=e.defaultCellStyle||{};t.font||(t.font={name:"Calibri",sz:"11"}),t.font.name||(t.font.name="Calibri"),t.font.sz||(t.font.sz=11),t.fill||(t.fill={patternType:"none",fgColor:{}}),t.border||(t.border={}),t.numFmt||(t.numFmt=0),this.defaultStyle=t;e=JSON.parse(JSON.stringify(t));return e.fill={patternType:"gray125",fgColor:{}},this.addStyles([t,e]),this},addStyle:function(e){var t=JSON.stringify(e),r=s[t];return null==r?(r=this._addXf(e),s[t]=r):r=s[t],r},addStyles:function(e){var t=this;return e.map(function(e){return t.addStyle(e)})},_duckTypeStyle:function(e){return"object"==typeof e&&(e.patternFill||e.fgColor)?{fill:e}:e.font||e.numFmt||e.border||e.fill?e:this._getStyleCSS(e)},_getStyleCSS:function(e){return e},_addXf:function(e){var t=this._addFont(e.font),r=this._addFill(e.fill),a=this._addBorder(e.border),n=this._addNumFmt(e.numFmt),s=vu("xf").attr("numFmtId",n).attr("fontId",t).attr("fillId",r).attr("borderId",a).attr("xfId","0");0<t&&s.attr("applyFont","1"),0<r&&s.attr("applyFill","1"),0<a&&s.attr("applyBorder","1"),0<n&&s.attr("applyNumberFormat","1"),e.alignment&&(n=vu("alignment"),e.alignment.horizontal&&n.attr("horizontal",e.alignment.horizontal),e.alignment.vertical&&n.attr("vertical",e.alignment.vertical),e.alignment.indent&&n.attr("indent",e.alignment.indent),e.alignment.readingOrder&&n.attr("readingOrder",e.alignment.readingOrder),e.alignment.wrapText&&n.attr("wrapText",e.alignment.wrapText),null!=e.alignment.textRotation&&n.attr("textRotation",e.alignment.textRotation),s.append(n).attr("applyAlignment",1)),this.$cellXfs.append(s);s=+this.$cellXfs.children().length;return this.$cellXfs.attr("count",s),s-1},_addFont:function(e){if(!e)return 0;var t=vu("font").append(vu("sz").attr("val",e.sz||this.defaultStyle.font.sz)).append(vu("name").attr("val",e.name||this.defaultStyle.font.name));e.bold&&t.append(vu("b")),e.underline&&t.append(vu("u")),e.italic&&t.append(vu("i")),e.strike&&t.append(vu("strike")),e.outline&&t.append(vu("outline")),e.shadow&&t.append(vu("shadow")),e.vertAlign&&t.append(vu("vertAlign").attr("val",e.vertAlign)),e.color&&(e.color.theme?(t.append(vu("color").attr("theme",e.color.theme)),e.color.tint&&t.append(vu("tint").attr("theme",e.color.tint))):e.color.rgb&&t.append(vu("color").attr("rgb",e.color.rgb))),this.$fonts.append(t);t=this.$fonts.children().length;return this.$fonts.attr("count",t),t-1},_addNumFmt:function(e){if(!e)return 0;if("string"==typeof e){var t=n[e];if(0<=t)return t}if(/^[0-9]+$/.exec(e))return e;e=e.replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/"/g,"&quot;").replace(/'/g,"&apos;");e=vu("numFmt").attr("numFmtId",++r).attr("formatCode",e);this.$numFmts.append(e);e=this.$numFmts.children().length;return this.$numFmts.attr("count",e),r},_addFill:function(e){if(!e)return 0;var t,r=vu("patternFill").attr("patternType",e.patternType||"solid");e.fgColor&&(t=vu("fgColor"),e.fgColor.rgb?(6==e.fgColor.rgb.length&&(e.fgColor.rgb="FF"+e.fgColor.rgb),t.attr("rgb",e.fgColor.rgb),r.append(t)):e.fgColor.theme&&(t.attr("theme",e.fgColor.theme),e.fgColor.tint&&t.attr("tint",e.fgColor.tint),r.append(t)),e.bgColor||(e.bgColor={indexed:"64"})),e.bgColor&&(e=vu("bgColor").attr(e.bgColor),r.append(e));r=vu("fill").append(r);this.$fills.append(r);r=this.$fills.children().length;return this.$fills.attr("count",r),r-1},_getSubBorder:function(e,t){var r=vu(e);return t&&(r.attr("style",t.style||"medium"),t.color&&(e=vu("color"),t.color.auto?e.attr("auto",t.color.auto):t.color.rgb?e.attr("rgb",t.color.rgb):(t.color.theme||t.color.tint)&&(e.attr("theme",t.color.theme||"1"),e.attr("tint",t.color.tint||"0")),r.append(e))),r},_addBorder:function(t){if(!t)return 0;var r=this,a=vu("border").attr("diagonalUp",t.diagonalUp).attr("diagonalDown",t.diagonalDown);["left","right","top","bottom","diagonal"].forEach(function(e){a.append(r._getSubBorder(e,t[e]))}),this.$borders.append(a);var e=this.$borders.children().length;return this.$borders.attr("count",e),e-1},toXml:function(){return this.$styles.toXml()}}.initialize(e||{})};void 0!==Nf&&(a.parse_xlscfb=Nf),a.parse_zip=zh,a.read=Kh,a.readFile=Jh,a.readFileSync=Jh,a.write=ru,a.writeFile=nu,a.writeFileSync=nu,a.writeFileAsync=function(e,t,r,a){var n=r||{};return n.type="file",n.file=e,au(n),n.type="buffer",a instanceof Function||(a=r),Se.writeFile(e,ru(t,n),a)},a.utils=Es,a.writeXLSX=tu,a.writeFileXLSX=function(e,t,r){return(r=r||{}).type="file",r.file=t,au(r),tu(e,r)},a.SSF=e,void 0!==is&&(a.stream=is),void 0!==xe&&(a.CFB=xe),"undefined"==typeof require||((is=require("stream"))||{}).Readable&&bu(is.Readable)}if("undefined"!=typeof exports?make_xlsx_lib(exports):"undefined"!=typeof module&&module.exports?make_xlsx_lib(module.exports):"function"==typeof define&&define.amd?define("xlsx",function(){return XLSX.version||make_xlsx_lib(XLSX),XLSX}):make_xlsx_lib(XLSX),"undefined"!=typeof window&&!window.XLSX)try{window.XLSX=XLSX}catch(e){}


}).call(this,require('_process'),require("buffer").Buffer)

},{"./cpexcel.js":10,"_process":8,"buffer":2,"fs":2,"stream":2}],12:[function(require,module,exports){
"use strict";

var __importDefault = void 0 && (void 0).__importDefault || function (mod) {
  return mod && mod.__esModule ? mod : {
    "default": mod
  };
};

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.HandleZip = void 0;

var jszip_1 = __importDefault(require("jszip"));

var method_1 = require("./common/method");

var HandleZip =
/** @class */
function () {
  function HandleZip(file) {
    // Support nodejs fs to read files
    // if(file instanceof File){
    this.uploadFile = file; // }
  }

  HandleZip.prototype.unzipFile = function (successFunc, errorFunc) {
    // var new_zip:JSZip = new JSZip();
    jszip_1["default"].loadAsync(this.uploadFile) // 1) read the Blob
    .then(function (zip) {
      var fileList = {},
          lastIndex = Object.keys(zip.files).length,
          index = 0;
      zip.forEach(function (relativePath, zipEntry) {
        var fileName = zipEntry.name;
        var fileNameArr = fileName.split(".");
        var suffix = fileNameArr[fileNameArr.length - 1].toLowerCase();
        var fileType = "string";

        if (suffix in {
          "png": 1,
          "jpeg": 1,
          "jpg": 1,
          "gif": 1,
          "bmp": 1,
          "tif": 1,
          "webp": 1
        }) {
          fileType = "base64";
        } else if (suffix == "emf") {
          fileType = "arraybuffer";
        }

        zipEntry.async(fileType).then(function (data) {
          if (fileType == "base64") {
            data = "data:image/" + suffix + ";base64," + data;
          }

          fileList[zipEntry.name] = data; // console.log(lastIndex, index);

          if (lastIndex == index + 1) {
            successFunc(fileList);
          }

          index++;
        });
      });
    }, function (e) {
      errorFunc(e);
    });
  };

  HandleZip.prototype.unzipFileByUrl = function (url, successFunc, errorFunc) {
    var new_zip = new jszip_1["default"]();
    method_1.getBinaryContent(url, function (err, data) {
      if (err) {
        throw err; // or handle err
      }

      jszip_1["default"].loadAsync(data).then(function (zip) {
        var fileList = {},
            lastIndex = Object.keys(zip.files).length,
            index = 0;
        zip.forEach(function (relativePath, zipEntry) {
          var fileName = zipEntry.name;
          var fileNameArr = fileName.split(".");
          var suffix = fileNameArr[fileNameArr.length - 1].toLowerCase();
          var fileType = "string";

          if (suffix in {
            "png": 1,
            "jpeg": 1,
            "jpg": 1,
            "gif": 1,
            "bmp": 1,
            "tif": 1,
            "webp": 1
          }) {
            fileType = "base64";
          } else if (suffix == "emf") {
            fileType = "arraybuffer";
          }

          zipEntry.async(fileType).then(function (data) {
            if (fileType == "base64") {
              data = "data:image/" + suffix + ";base64," + data;
            }

            fileList[zipEntry.name] = data; // console.log(lastIndex, index);

            if (lastIndex == index + 1) {
              successFunc(fileList);
            }

            index++;
          });
        });
      }, function (e) {
        errorFunc(e);
      });
    });
  };

  HandleZip.prototype.newZipFile = function () {
    var zip = new jszip_1["default"]();
    this.workBook = zip;
  }; //title:"nested/hello.txt", content:"Hello Worldasdfasfasdfasfasfasfasfasdfas"


  HandleZip.prototype.addToZipFile = function (title, content) {
    if (this.workBook == null) {
      var zip = new jszip_1["default"]();
      this.workBook = zip;
    }

    this.workBook.file(title, content);
  };

  return HandleZip;
}();

exports.HandleZip = HandleZip;

},{"./common/method":21,"jszip":7}],13:[function(require,module,exports){
"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.LuckyImageBase = exports.LuckysheetCalcChain = exports.LuckySheetConfigMerge = exports.LuckySheetborderInfoCellValueStyle = exports.LuckySheetborderInfoCellValue = exports.LuckySheetborderInfoCellForImp = exports.LuckyConfig = exports.LuckyInlineString = exports.LuckySheetCellFormat = exports.LuckySheetCelldataValue = exports.LuckySheetCelldataBase = exports.LuckyFileInfo = exports.LuckySheetBase = exports.LuckyFileBase = void 0;

var LuckyFileBase =
/** @class */
function () {
  function LuckyFileBase() {}

  return LuckyFileBase;
}();

exports.LuckyFileBase = LuckyFileBase;

var LuckySheetBase =
/** @class */
function () {
  function LuckySheetBase() {}

  return LuckySheetBase;
}();

exports.LuckySheetBase = LuckySheetBase;

var LuckyFileInfo =
/** @class */
function () {
  function LuckyFileInfo() {}

  return LuckyFileInfo;
}();

exports.LuckyFileInfo = LuckyFileInfo;

var LuckySheetCelldataBase =
/** @class */
function () {
  function LuckySheetCelldataBase() {}

  return LuckySheetCelldataBase;
}();

exports.LuckySheetCelldataBase = LuckySheetCelldataBase;

var LuckySheetCelldataValue =
/** @class */
function () {
  function LuckySheetCelldataValue() {}

  return LuckySheetCelldataValue;
}();

exports.LuckySheetCelldataValue = LuckySheetCelldataValue;

var LuckySheetCellFormat =
/** @class */
function () {
  function LuckySheetCellFormat() {}

  return LuckySheetCellFormat;
}();

exports.LuckySheetCellFormat = LuckySheetCellFormat;

var LuckyInlineString =
/** @class */
function () {
  function LuckyInlineString() {}

  return LuckyInlineString;
}();

exports.LuckyInlineString = LuckyInlineString;

var LuckyConfig =
/** @class */
function () {
  function LuckyConfig() {}

  return LuckyConfig;
}();

exports.LuckyConfig = LuckyConfig;

var LuckySheetborderInfoCellForImp =
/** @class */
function () {
  function LuckySheetborderInfoCellForImp() {}

  return LuckySheetborderInfoCellForImp;
}();

exports.LuckySheetborderInfoCellForImp = LuckySheetborderInfoCellForImp;

var LuckySheetborderInfoCellValue =
/** @class */
function () {
  function LuckySheetborderInfoCellValue() {}

  return LuckySheetborderInfoCellValue;
}();

exports.LuckySheetborderInfoCellValue = LuckySheetborderInfoCellValue;

var LuckySheetborderInfoCellValueStyle =
/** @class */
function () {
  function LuckySheetborderInfoCellValueStyle() {}

  return LuckySheetborderInfoCellValueStyle;
}();

exports.LuckySheetborderInfoCellValueStyle = LuckySheetborderInfoCellValueStyle;

var LuckySheetConfigMerge =
/** @class */
function () {
  function LuckySheetConfigMerge() {}

  return LuckySheetConfigMerge;
}();

exports.LuckySheetConfigMerge = LuckySheetConfigMerge;

var LuckysheetCalcChain =
/** @class */
function () {
  function LuckysheetCalcChain() {}

  return LuckysheetCalcChain;
}();

exports.LuckysheetCalcChain = LuckysheetCalcChain;

var LuckyImageBase =
/** @class */
function () {
  function LuckyImageBase() {}

  return LuckyImageBase;
}();

exports.LuckyImageBase = LuckyImageBase;

},{}],14:[function(require,module,exports){
"use strict";

var __extends = void 0 && (void 0).__extends || function () {
  var _extendStatics = function extendStatics(d, b) {
    _extendStatics = Object.setPrototypeOf || {
      __proto__: []
    } instanceof Array && function (d, b) {
      d.__proto__ = b;
    } || function (d, b) {
      for (var p in b) {
        if (b.hasOwnProperty(p)) d[p] = b[p];
      }
    };

    return _extendStatics(d, b);
  };

  return function (d, b) {
    _extendStatics(d, b);

    function __() {
      this.constructor = d;
    }

    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
  };
}();

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.LuckySheetCelldata = void 0;

var ReadXml_1 = require("./ReadXml");

var method_1 = require("../common/method");

var constant_1 = require("../common/constant");

var LuckyBase_1 = require("./LuckyBase");

var LuckySheetCelldata =
/** @class */
function (_super) {
  __extends(LuckySheetCelldata, _super);

  function LuckySheetCelldata(cell, styles, sharedStrings, mergeCells, sheetFile, ReadXml) {
    var _this = //Private
    _super.call(this) || this;

    _this.cell = cell;
    _this.sheetFile = sheetFile;
    _this.styles = styles;
    _this.sharedStrings = sharedStrings;
    _this.readXml = ReadXml;
    _this.mergeCells = mergeCells;
    var attrList = cell.attributeList;
    var r = attrList.r,
        s = attrList.s,
        t = attrList.t;
    var range = method_1.getcellrange(r);
    _this.r = range.row[0];
    _this.c = range.column[0];
    _this.v = _this.generateValue(s, t);
    return _this;
  }
  /**
  * @param s Style index ,start 1
  * @param t Cell type, Optional value is ST_CellType, it's found at constat.ts
  */


  LuckySheetCelldata.prototype.generateValue = function (s, t) {
    var _this = this;

    var v = this.cell.getInnerElements("v");
    var f = this.cell.getInnerElements("f");

    if (v == null) {
      v = this.cell.getInnerElements("t");
    }

    var cellXfs = this.styles["cellXfs"];
    var cellStyleXfs = this.styles["cellStyleXfs"];
    var cellStyles = this.styles["cellStyles"];
    var fonts = this.styles["fonts"];
    var fills = this.styles["fills"];
    var borders = this.styles["borders"];
    var numfmts = this.styles["numfmts"];
    var clrScheme = this.styles["clrScheme"];
    var sharedStrings = this.sharedStrings;
    var cellValue = new LuckyBase_1.LuckySheetCelldataValue();

    if (f != null) {
      var formula = f[0],
          attrList = formula.attributeList;
      var t_1 = attrList.t,
          ref = attrList.ref,
          si = attrList.si;
      var formulaValue = f[0].value;

      if (t_1 == "shared") {
        this._fomulaRef = ref;
        this._formulaType = t_1;
        this._formulaSi = si;
      } // console.log(ref, t, si);


      if (ref != null || formulaValue != null && formulaValue.length > 0) {
        formulaValue = method_1.escapeCharacter(formulaValue);
        cellValue.f = "=" + formulaValue;
      }
    }

    var familyFont = null;
    var quotePrefix;

    if (s != null) {
      var sNum = parseInt(s);
      var cellXf = cellXfs[sNum];
      var xfId = cellXf.attributeList.xfId;
      var numFmtId = void 0,
          fontId = void 0,
          fillId = void 0,
          borderId = void 0;
      var horizontal = void 0,
          vertical = void 0,
          wrapText = void 0,
          textRotation = void 0,
          shrinkToFit = void 0,
          indent = void 0,
          applyProtection = void 0;

      if (xfId != null && cellStyleXfs[parseInt(xfId)] != null) {
        var cellStyleXf = cellStyleXfs[parseInt(xfId)];
        var attrList = cellStyleXf.attributeList;
        var applyNumberFormat_1 = attrList.applyNumberFormat;
        var applyFont_1 = attrList.applyFont;
        var applyFill_1 = attrList.applyFill;
        var applyBorder_1 = attrList.applyBorder;
        var applyAlignment_1 = attrList.applyAlignment; // let applyProtection = attrList.applyProtection;

        applyProtection = attrList.applyProtection;
        quotePrefix = attrList.quotePrefix;

        if (applyNumberFormat_1 != "0" && attrList.numFmtId != null) {
          // if(attrList.numFmtId!="0"){
          numFmtId = attrList.numFmtId; // }
        }

        if (applyFont_1 != "0" && attrList.fontId != null) {
          fontId = attrList.fontId;
        }

        if (applyFill_1 != "0" && attrList.fillId != null) {
          fillId = attrList.fillId;
        }

        if (applyBorder_1 != "0" && attrList.borderId != null) {
          borderId = attrList.borderId;
        }

        if (applyAlignment_1 != null && applyAlignment_1 != "0") {
          var alignment = cellStyleXf.getInnerElements("alignment");

          if (alignment != null) {
            var attrList_1 = alignment[0].attributeList;

            if (attrList_1.horizontal != null) {
              horizontal = attrList_1.horizontal;
            }

            if (attrList_1.vertical != null) {
              vertical = attrList_1.vertical;
            }

            if (attrList_1.wrapText != null) {
              wrapText = attrList_1.wrapText;
            }

            if (attrList_1.textRotation != null) {
              textRotation = attrList_1.textRotation;
            }

            if (attrList_1.shrinkToFit != null) {
              shrinkToFit = attrList_1.shrinkToFit;
            }

            if (attrList_1.indent != null) {
              indent = attrList_1.indent;
            }
          }
        }
      }

      var applyNumberFormat = cellXf.attributeList.applyNumberFormat;
      var applyFont = cellXf.attributeList.applyFont;
      var applyFill = cellXf.attributeList.applyFill;
      var applyBorder = cellXf.attributeList.applyBorder;
      var applyAlignment = cellXf.attributeList.applyAlignment;

      if (cellXf.attributeList.applyProtection != null) {
        applyProtection = cellXf.attributeList.applyProtection;
      }

      if (cellXf.attributeList.quotePrefix != null) {
        quotePrefix = cellXf.attributeList.quotePrefix;
      }

      if (applyNumberFormat != "0" && cellXf.attributeList.numFmtId != null) {
        numFmtId = cellXf.attributeList.numFmtId;
      }

      if (applyFont != "0") {
        fontId = cellXf.attributeList.fontId;
      }

      if (applyFill != "0") {
        fillId = cellXf.attributeList.fillId;
      }

      if (applyBorder != "0") {
        borderId = cellXf.attributeList.borderId;
      }

      if (applyAlignment != "0") {
        var alignment = cellXf.getInnerElements("alignment");

        if (alignment != null && alignment.length > 0) {
          var attrList = alignment[0].attributeList;

          if (attrList.horizontal != null) {
            horizontal = attrList.horizontal;
          }

          if (attrList.vertical != null) {
            vertical = attrList.vertical;
          }

          if (attrList.wrapText != null) {
            wrapText = attrList.wrapText;
          }

          if (attrList.textRotation != null) {
            textRotation = attrList.textRotation;
          }

          if (attrList.shrinkToFit != null) {
            shrinkToFit = attrList.shrinkToFit;
          }

          if (attrList.indent != null) {
            indent = attrList.indent;
          }
        }
      }

      if (numFmtId != undefined) {
        var numf = numfmts[parseInt(numFmtId)];
        var cellFormat = new LuckyBase_1.LuckySheetCellFormat();
        cellFormat.fa = method_1.escapeCharacter(numf); // console.log(numf, numFmtId, this.v);

        cellFormat.t = t || 'n';
        cellValue.ct = cellFormat;
      }

      if (fillId != undefined) {
        var fillIdNum = parseInt(fillId);
        var fill = fills[fillIdNum]; // console.log(cellValue.v);

        var bg = this.getBackgroundByFill(fill, clrScheme);

        if (bg != null) {
          cellValue.bg = bg;
        }
      }

      if (fontId != undefined) {
        var fontIdNum = parseInt(fontId);
        var font = fonts[fontIdNum];

        if (font != null) {
          var sz = font.getInnerElements("sz"); //font size

          var colors = font.getInnerElements("color"); //font color

          var family = font.getInnerElements("name"); //font family

          var familyOverrides = font.getInnerElements("family"); //font family will be overrided by name

          var charset = font.getInnerElements("charset"); //font charset

          var bolds = font.getInnerElements("b"); //font bold

          var italics = font.getInnerElements("i"); //font italic

          var strikes = font.getInnerElements("strike"); //font italic

          var underlines = font.getInnerElements("u"); //font italic

          if (sz != null && sz.length > 0) {
            var fs = sz[0].attributeList.val;

            if (fs != null) {
              cellValue.fs = parseInt(fs);
            }
          }

          if (colors != null && colors.length > 0) {
            var color = colors[0];
            var fc = ReadXml_1.getColor(color, this.styles, "t");

            if (fc != null) {
              cellValue.fc = fc;
            }
          }

          if (familyOverrides != null && familyOverrides.length > 0) {
            var val = familyOverrides[0].attributeList.val;

            if (val != null) {
              familyFont = constant_1.fontFamilys[val];
            }
          }

          if (family != null && family.length > 0) {
            var val = family[0].attributeList.val;

            if (val != null) {
              cellValue.ff = val;
            }
          }

          if (bolds != null && bolds.length > 0) {
            var bold = bolds[0].attributeList.val;

            if (bold == "0") {
              cellValue.bl = 0;
            } else {
              cellValue.bl = 1;
            }
          }

          if (italics != null && italics.length > 0) {
            var italic = italics[0].attributeList.val;

            if (italic == "0") {
              cellValue.it = 0;
            } else {
              cellValue.it = 1;
            }
          }

          if (strikes != null && strikes.length > 0) {
            var strike = strikes[0].attributeList.val;

            if (strike == "0") {
              cellValue.cl = 0;
            } else {
              cellValue.cl = 1;
            }
          }

          if (underlines != null && underlines.length > 0) {
            var underline = underlines[0].attributeList.val;

            if (underline == "single") {
              cellValue.un = 1;
            } else if (underline == "double") {
              cellValue.un = 2;
            } else if (underline == "singleAccounting") {
              cellValue.un = 3;
            } else if (underline == "doubleAccounting") {
              cellValue.un = 4;
            } else {
              cellValue.un = 0;
            }
          }
        }
      } // vt: number | undefined//Vertical alignment, 0 middle, 1 up, 2 down, alignment
      // ht: number | undefined//Horizontal alignment,0 center, 1 left, 2 right, alignment
      // tr: number | undefined //Text rotation,0: 0、1: 45 、2: -45、3 Vertical text、4: 90 、5: -90, alignment
      // tb: number | undefined //Text wrap,0 truncation, 1 overflow, 2 word wrap, alignment


      if (horizontal != undefined) {
        //Horizontal alignment
        if (horizontal == "center") {
          cellValue.ht = 0;
        } else if (horizontal == "centerContinuous") {
          cellValue.ht = 0; //luckysheet unsupport
        } else if (horizontal == "left") {
          cellValue.ht = 1;
        } else if (horizontal == "right") {
          cellValue.ht = 2;
        } else if (horizontal == "distributed") {
          cellValue.ht = 0; //luckysheet unsupport
        } else if (horizontal == "fill") {
          cellValue.ht = 1; //luckysheet unsupport
        } else if (horizontal == "general") {
          cellValue.ht = 1; //luckysheet unsupport
        } else if (horizontal == "justify") {
          cellValue.ht = 0; //luckysheet unsupport
        } else {
          cellValue.ht = 1;
        }
      }

      if (vertical != undefined) {
        //Vertical alignment
        if (vertical == "bottom") {
          cellValue.vt = 2;
        } else if (vertical == "center") {
          cellValue.vt = 0;
        } else if (vertical == "distributed") {
          cellValue.vt = 0; //luckysheet unsupport
        } else if (vertical == "justify") {
          cellValue.vt = 0; //luckysheet unsupport
        } else if (vertical == "top") {
          cellValue.vt = 1;
        } else {
          cellValue.vt = 1;
        }
      } else {
        //sometimes bottom style is lost after setting it in excel
        //when vertical is undefined set it to 2.
        cellValue.vt = 2;
      }

      if (wrapText != undefined) {
        if (wrapText == "1") {
          cellValue.tb = 2;
        } else {
          cellValue.tb = 1;
        }
      } else {
        cellValue.tb = 1;
      }

      if (textRotation != undefined) {
        // tr: number | undefined //Text rotation,0: 0、1: 45 、2: -45、3 Vertical text、4: 90 、5: -90, alignment
        if (textRotation == "255") {
          cellValue.tr = 3;
        } // else if(textRotation=="45"){
        //     cellValue.tr = 1;
        // }
        // else if(textRotation=="90"){
        //     cellValue.tr = 4;
        // }
        // else if(textRotation=="135"){
        //     cellValue.tr = 2;
        // }
        // else if(textRotation=="180"){
        //     cellValue.tr = 5;
        // }
        else {
            cellValue.tr = 0;
            cellValue.rt = parseInt(textRotation);
          }
      }

      if (shrinkToFit != undefined) {//luckysheet unsupport
      }

      if (indent != undefined) {//luckysheet unsupport
      }

      if (borderId != undefined) {
        var borderIdNum = parseInt(borderId);
        var border = borders[borderIdNum]; // this._borderId = borderIdNum;

        var borderObject = new LuckyBase_1.LuckySheetborderInfoCellForImp();
        borderObject.rangeType = "cell"; // borderObject.cells = [];

        var borderCellValue = new LuckyBase_1.LuckySheetborderInfoCellValue();
        borderCellValue.row_index = this.r;
        borderCellValue.col_index = this.c;
        var lefts = border.getInnerElements("left");
        var rights = border.getInnerElements("right");
        var tops = border.getInnerElements("top");
        var bottoms = border.getInnerElements("bottom");
        var diagonals = border.getInnerElements("diagonal");
        var starts = border.getInnerElements("start");
        var ends = border.getInnerElements("end");
        var left = this.getBorderInfo(lefts);
        var right = this.getBorderInfo(rights);
        var top_1 = this.getBorderInfo(tops);
        var bottom = this.getBorderInfo(bottoms);
        var diagonal = this.getBorderInfo(diagonals);
        var start = this.getBorderInfo(starts);
        var end = this.getBorderInfo(ends);
        var isAdd = false;

        if (start != null && start.color != null) {
          borderCellValue.l = start;
          isAdd = true;
        }

        if (end != null && end.color != null) {
          borderCellValue.r = end;
          isAdd = true;
        }

        if (left != null && left.color != null) {
          borderCellValue.l = left;
          isAdd = true;
        }

        if (right != null && right.color != null) {
          borderCellValue.r = right;
          isAdd = true;
        }

        if (top_1 != null && top_1.color != null) {
          borderCellValue.t = top_1;
          isAdd = true;
        }

        if (bottom != null && bottom.color != null) {
          borderCellValue.b = bottom;
          isAdd = true;
        }

        if (isAdd) {
          borderObject.value = borderCellValue; // this.config._borderInfo[borderId] = borderObject;

          this._borderObject = borderObject;
        }
      }
    } else {
      cellValue.tb = 1;
    }

    if (v != null) {
      var value = v[0].value;

      if (/&#\d+;/.test(value)) {
        value = this.htmlDecode(value);
      }

      if (t == constant_1.ST_CellType["SharedString"]) {
        var siIndex = parseInt(v[0].value);
        var sharedSI = sharedStrings[siIndex];
        var rFlag = sharedSI.getInnerElements("r");

        if (rFlag == null) {
          var tFlag = sharedSI.getInnerElements("t");

          if (tFlag != null) {
            var text_1 = "";
            tFlag.forEach(function (t) {
              text_1 += t.value;
            });
            text_1 = method_1.escapeCharacter(text_1); //isContainMultiType(text) &&

            if (familyFont == "Roman" && text_1.length > 0) {
              var textArray = text_1.split("");
              var preWordType = null,
                  wordText = "",
                  preWholef = null;
              var wholef = "Times New Roman";

              if (cellValue.ff != null) {
                wholef = cellValue.ff;
              }

              var cellFormat = cellValue.ct;

              if (cellFormat == null) {
                cellFormat = new LuckyBase_1.LuckySheetCellFormat();
              }

              if (cellFormat.s == null) {
                cellFormat.s = [];
              }

              for (var i = 0; i < textArray.length; i++) {
                var w = textArray[i];
                var type = null,
                    ff = wholef;

                if (method_1.isChinese(w)) {
                  type = "c";
                  ff = "宋体";
                } else if (method_1.isJapanese(w)) {
                  type = "j";
                  ff = "Yu Gothic";
                } else if (method_1.isKoera(w)) {
                  type = "k";
                  ff = "Malgun Gothic";
                } else {
                  type = "e";
                }

                if (type != preWordType && preWordType != null || i == textArray.length - 1) {
                  var InlineString = new LuckyBase_1.LuckyInlineString();
                  InlineString.ff = preWholef;

                  if (cellValue.fc != null) {
                    InlineString.fc = cellValue.fc;
                  }

                  if (cellValue.fs != null) {
                    InlineString.fs = cellValue.fs;
                  }

                  if (cellValue.cl != null) {
                    InlineString.cl = cellValue.cl;
                  }

                  if (cellValue.un != null) {
                    InlineString.un = cellValue.un;
                  }

                  if (cellValue.bl != null) {
                    InlineString.bl = cellValue.bl;
                  }

                  if (cellValue.it != null) {
                    InlineString.it = cellValue.it;
                  }

                  if (i == textArray.length - 1) {
                    if (type == preWordType) {
                      InlineString.ff = ff;
                      InlineString.v = wordText + w;
                    } else {
                      InlineString.ff = preWholef;
                      InlineString.v = wordText;
                      cellFormat.s.push(InlineString);
                      var InlineStringLast = new LuckyBase_1.LuckyInlineString();
                      InlineStringLast.ff = ff;
                      InlineStringLast.v = w;

                      if (cellValue.fc != null) {
                        InlineStringLast.fc = cellValue.fc;
                      }

                      if (cellValue.fs != null) {
                        InlineStringLast.fs = cellValue.fs;
                      }

                      if (cellValue.cl != null) {
                        InlineStringLast.cl = cellValue.cl;
                      }

                      if (cellValue.un != null) {
                        InlineStringLast.un = cellValue.un;
                      }

                      if (cellValue.bl != null) {
                        InlineStringLast.bl = cellValue.bl;
                      }

                      if (cellValue.it != null) {
                        InlineStringLast.it = cellValue.it;
                      }

                      cellFormat.s.push(InlineStringLast);
                      break;
                    }
                  } else {
                    InlineString.v = wordText;
                  }

                  cellFormat.s.push(InlineString);
                  wordText = w;
                } else {
                  wordText += w;
                }

                preWordType = type;
                preWholef = ff;
              }

              cellFormat.t = "inlineStr"; // cellFormat.s = [InlineString];

              cellValue.ct = cellFormat; // console.log(cellValue);
            } else {
              text_1 = this.replaceSpecialWrap(text_1);

              if (text_1.indexOf("\r\n") > -1 || text_1.indexOf("\n") > -1) {
                var InlineString = new LuckyBase_1.LuckyInlineString();
                InlineString.v = text_1;
                var cellFormat = cellValue.ct;

                if (cellFormat == null) {
                  cellFormat = new LuckyBase_1.LuckySheetCellFormat();
                }

                if (cellValue.ff != null) {
                  InlineString.ff = cellValue.ff;
                }

                if (cellValue.fc != null) {
                  InlineString.fc = cellValue.fc;
                }

                if (cellValue.fs != null) {
                  InlineString.fs = cellValue.fs;
                }

                if (cellValue.cl != null) {
                  InlineString.cl = cellValue.cl;
                }

                if (cellValue.un != null) {
                  InlineString.un = cellValue.un;
                }

                if (cellValue.bl != null) {
                  InlineString.bl = cellValue.bl;
                }

                if (cellValue.it != null) {
                  InlineString.it = cellValue.it;
                }

                cellFormat.t = "inlineStr";
                cellFormat.s = [InlineString];
                cellValue.ct = cellFormat;
              } else {
                cellValue.v = text_1;
                quotePrefix = "1";
              }
            }
          }
        } else {
          var styles_1 = [];
          rFlag.forEach(function (r) {
            var tFlag = r.getInnerElements("t");
            var rPr = r.getInnerElements("rPr");
            var InlineString = new LuckyBase_1.LuckyInlineString();

            if (tFlag != null && tFlag.length > 0) {
              var text = tFlag[0].value;
              text = _this.replaceSpecialWrap(text);
              text = method_1.escapeCharacter(text);
              InlineString.v = text;
            }

            if (rPr != null && rPr.length > 0) {
              var frpr = rPr[0];
              var sz = ReadXml_1.getlineStringAttr(frpr, "sz"),
                  rFont = ReadXml_1.getlineStringAttr(frpr, "rFont"),
                  family = ReadXml_1.getlineStringAttr(frpr, "family"),
                  charset = ReadXml_1.getlineStringAttr(frpr, "charset"),
                  scheme = ReadXml_1.getlineStringAttr(frpr, "scheme"),
                  b = ReadXml_1.getlineStringAttr(frpr, "b"),
                  i = ReadXml_1.getlineStringAttr(frpr, "i"),
                  u = ReadXml_1.getlineStringAttr(frpr, "u"),
                  strike = ReadXml_1.getlineStringAttr(frpr, "strike"),
                  vertAlign = ReadXml_1.getlineStringAttr(frpr, "vertAlign"),
                  color = void 0;
              var cEle = frpr.getInnerElements("color");

              if (cEle != null && cEle.length > 0) {
                color = ReadXml_1.getColor(cEle[0], _this.styles, "t");
              }

              var ff = void 0; // if(family!=null){
              //     ff = fontFamilys[family];
              // }

              if (rFont != null) {
                ff = rFont;
              }

              if (ff != null) {
                InlineString.ff = ff;
              } else if (cellValue.ff != null) {
                InlineString.ff = cellValue.ff;
              }

              if (color != null) {
                InlineString.fc = color;
              } else if (cellValue.fc != null) {
                InlineString.fc = cellValue.fc;
              }

              if (sz != null) {
                InlineString.fs = parseInt(sz);
              } else if (cellValue.fs != null) {
                InlineString.fs = cellValue.fs;
              }

              if (strike != null) {
                InlineString.cl = parseInt(strike);
              } else if (cellValue.cl != null) {
                InlineString.cl = cellValue.cl;
              }

              if (u != null) {
                InlineString.un = parseInt(u);
              } else if (cellValue.un != null) {
                InlineString.un = cellValue.un;
              }

              if (b != null) {
                InlineString.bl = parseInt(b);
              } else if (cellValue.bl != null) {
                InlineString.bl = cellValue.bl;
              }

              if (i != null) {
                InlineString.it = parseInt(i);
              } else if (cellValue.it != null) {
                InlineString.it = cellValue.it;
              }

              if (vertAlign != null) {
                InlineString.va = parseInt(vertAlign);
              } // ff:string | undefined //font family
              // fc:string | undefined//font color
              // fs:number | undefined//font size
              // cl:number | undefined//strike
              // un:number | undefined//underline
              // bl:number | undefined//blod
              // it:number | undefined//italic
              // v:string | undefined

            } else {
              if (InlineString.ff == null && cellValue.ff != null) {
                InlineString.ff = cellValue.ff;
              }

              if (InlineString.fc == null && cellValue.fc != null) {
                InlineString.fc = cellValue.fc;
              }

              if (InlineString.fs == null && cellValue.fs != null) {
                InlineString.fs = cellValue.fs;
              }

              if (InlineString.cl == null && cellValue.cl != null) {
                InlineString.cl = cellValue.cl;
              }

              if (InlineString.un == null && cellValue.un != null) {
                InlineString.un = cellValue.un;
              }

              if (InlineString.bl == null && cellValue.bl != null) {
                InlineString.bl = cellValue.bl;
              }

              if (InlineString.it == null && cellValue.it != null) {
                InlineString.it = cellValue.it;
              }
            }

            styles_1.push(InlineString);
          });
          var cellFormat = cellValue.ct;

          if (cellFormat == null) {
            cellFormat = new LuckyBase_1.LuckySheetCellFormat();
          }

          cellFormat.t = "inlineStr";
          cellFormat.s = styles_1;
          cellValue.ct = cellFormat;
        }
      } // to be confirmed
      else if (t == constant_1.ST_CellType["InlineString"] && v != null) {
          cellValue.v = "'" + value;
        } else {
          value = method_1.escapeCharacter(value);
          cellValue.v = value;
        }
    }

    if (quotePrefix != null) {
      cellValue.qp = parseInt(quotePrefix);
    }

    return cellValue;
  };

  LuckySheetCelldata.prototype.replaceSpecialWrap = function (text) {
    text = text.replace(/_x000D_/g, "").replace(/&#13;&#10;/g, "\r\n").replace(/&#13;/g, "\r").replace(/&#10;/g, "\n");
    return text;
  };

  LuckySheetCelldata.prototype.getBackgroundByFill = function (fill, clrScheme) {
    var patternFills = fill.getInnerElements("patternFill");

    if (patternFills != null) {
      var patternFill = patternFills[0];
      var fgColors = patternFill.getInnerElements("fgColor");
      var bgColors = patternFill.getInnerElements("bgColor");
      var fg = void 0,
          bg = void 0;

      if (fgColors != null) {
        var fgColor = fgColors[0];
        fg = ReadXml_1.getColor(fgColor, this.styles);
      }

      if (bgColors != null) {
        var bgColor = bgColors[0];
        bg = ReadXml_1.getColor(bgColor, this.styles);
      } // console.log(fgColors,bgColors,clrScheme);


      if (fg != null) {
        return fg;
      } else if (bg != null) {
        return bg;
      }
    } else {
      var gradientfills = fill.getInnerElements("gradientFill");

      if (gradientfills != null) {
        //graient color fill handler
        return null;
      }
    }
  };

  LuckySheetCelldata.prototype.getBorderInfo = function (borders) {
    if (borders == null) {
      return null;
    }

    var border = borders[0],
        attrList = border.attributeList;
    var clrScheme = this.styles["clrScheme"];
    var style = attrList.style;

    if (style == null || style == "none") {
      return null;
    }

    var colors = border.getInnerElements("color");
    var colorRet = "#000000";

    if (colors != null) {
      var color = colors[0];
      colorRet = ReadXml_1.getColor(color, this.styles, "b");

      if (colorRet == null) {
        colorRet = "#000000";
      }
    }

    var ret = new LuckyBase_1.LuckySheetborderInfoCellValueStyle();
    ret.style = constant_1.borderTypes[style];
    ret.color = colorRet;
    return ret;
  };

  LuckySheetCelldata.prototype.htmlDecode = function (str) {
    return str.replace(/&#(x)?([^&]{1,5});/g, function ($, $1, $2) {
      return String.fromCharCode(parseInt($2, $1 ? 16 : 10));
    });
  };

  ;
  return LuckySheetCelldata;
}(LuckyBase_1.LuckySheetCelldataBase);

exports.LuckySheetCelldata = LuckySheetCelldata;

},{"../common/constant":19,"../common/method":21,"./LuckyBase":13,"./ReadXml":18}],15:[function(require,module,exports){
"use strict";

var __extends = void 0 && (void 0).__extends || function () {
  var _extendStatics = function extendStatics(d, b) {
    _extendStatics = Object.setPrototypeOf || {
      __proto__: []
    } instanceof Array && function (d, b) {
      d.__proto__ = b;
    } || function (d, b) {
      for (var p in b) {
        if (b.hasOwnProperty(p)) d[p] = b[p];
      }
    };

    return _extendStatics(d, b);
  };

  return function (d, b) {
    _extendStatics(d, b);

    function __() {
      this.constructor = d;
    }

    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
  };
}();

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.LuckyFile = void 0;

var LuckySheet_1 = require("./LuckySheet");

var constant_1 = require("../common/constant");

var ReadXml_1 = require("./ReadXml");

var method_1 = require("../common/method");

var LuckyBase_1 = require("./LuckyBase");

var LuckyImage_1 = require("./LuckyImage");

var LuckyFile =
/** @class */
function (_super) {
  __extends(LuckyFile, _super);

  function LuckyFile(files, fileName) {
    var _this = _super.call(this) || this;

    _this.columnWidthSet = [];
    _this.rowHeightSet = [];
    _this.files = files;
    _this.fileName = fileName;
    _this.readXml = new ReadXml_1.ReadXml(files);

    _this.getSheetNameList();

    _this.sharedStrings = _this.readXml.getElementsByTagName("sst/si", constant_1.sharedStringsFile);
    _this.calcChain = _this.readXml.getElementsByTagName("calcChain/c", constant_1.calcChainFile);
    _this.styles = {};
    _this.styles["cellXfs"] = _this.readXml.getElementsByTagName("cellXfs/xf", constant_1.stylesFile);
    _this.styles["cellStyleXfs"] = _this.readXml.getElementsByTagName("cellStyleXfs/xf", constant_1.stylesFile);
    _this.styles["cellStyles"] = _this.readXml.getElementsByTagName("cellStyles/cellStyle", constant_1.stylesFile);
    _this.styles["fonts"] = _this.readXml.getElementsByTagName("fonts/font", constant_1.stylesFile);
    _this.styles["fills"] = _this.readXml.getElementsByTagName("fills/fill", constant_1.stylesFile);
    _this.styles["borders"] = _this.readXml.getElementsByTagName("borders/border", constant_1.stylesFile);
    _this.styles["clrScheme"] = _this.readXml.getElementsByTagName("a:clrScheme/a:dk1|a:lt1|a:dk2|a:lt2|a:accent1|a:accent2|a:accent3|a:accent4|a:accent5|a:accent6|a:hlink|a:folHlink", constant_1.theme1File);
    _this.styles["indexedColors"] = _this.readXml.getElementsByTagName("colors/indexedColors/rgbColor", constant_1.stylesFile);
    _this.styles["mruColors"] = _this.readXml.getElementsByTagName("colors/mruColors/color", constant_1.stylesFile);
    _this.imageList = new LuckyImage_1.ImageList(files);

    var numfmts = _this.readXml.getElementsByTagName("numFmt/numFmt", constant_1.stylesFile);

    var numFmtDefaultC = JSON.parse(JSON.stringify(constant_1.numFmtDefault));

    for (var i = 0; i < numfmts.length; i++) {
      var attrList = numfmts[i].attributeList;
      var numfmtid = method_1.getXmlAttibute(attrList, "numFmtId", "49");
      var formatcode = method_1.getXmlAttibute(attrList, "formatCode", "@"); // console.log(numfmtid, formatcode);

      if (!(numfmtid in constant_1.numFmtDefault)) {
        numFmtDefaultC[numfmtid] = constant_1.numFmtDefaultMap[formatcode] || formatcode;
      }
    } // console.log(JSON.stringify(numFmtDefaultC), numfmts);


    _this.styles["numfmts"] = numFmtDefaultC;
    return _this;
  }
  /**
  * @return All sheet name of workbook
  */


  LuckyFile.prototype.getSheetNameList = function () {
    var workbookRelList = this.readXml.getElementsByTagName("Relationships/Relationship", constant_1.workbookRels);

    if (workbookRelList == null) {
      return;
    }

    var regex = new RegExp("worksheets/[^/]*?.xml");
    var sheetNames = {};

    for (var i = 0; i < workbookRelList.length; i++) {
      var rel = workbookRelList[i],
          attrList = rel.attributeList;
      var id = attrList["Id"],
          target = attrList["Target"];

      if (regex.test(target)) {
        if (target.indexOf('/xl') === 0) {
          sheetNames[id] = target.substr(1);
        } else {
          sheetNames[id] = "xl/" + target;
        }
      }
    }

    this.sheetNameList = sheetNames;
  };
  /**
  * @param sheetName WorkSheet'name
  * @return sheet file name and path in zip
  */


  LuckyFile.prototype.getSheetFileBysheetId = function (sheetId) {
    // for(let i=0;i<this.sheetNameList.length;i++){
    //     let sheetFileName = this.sheetNameList[i];
    //     if(sheetFileName.indexOf("sheet"+sheetId)>-1){
    //         return sheetFileName;
    //     }
    // }
    return this.sheetNameList[sheetId];
  };
  /**
  * @return workBook information
  */


  LuckyFile.prototype.getWorkBookInfo = function () {
    var Company = this.readXml.getElementsByTagName("Company", constant_1.appFile);
    var AppVersion = this.readXml.getElementsByTagName("AppVersion", constant_1.appFile);
    var creator = this.readXml.getElementsByTagName("dc:creator", constant_1.coreFile);
    var lastModifiedBy = this.readXml.getElementsByTagName("cp:lastModifiedBy", constant_1.coreFile);
    var created = this.readXml.getElementsByTagName("dcterms:created", constant_1.coreFile);
    var modified = this.readXml.getElementsByTagName("dcterms:modified", constant_1.coreFile);
    this.info = new LuckyBase_1.LuckyFileInfo();
    this.info.name = this.fileName;
    this.info.creator = creator.length > 0 ? creator[0].value : "";
    this.info.lastmodifiedby = lastModifiedBy.length > 0 ? lastModifiedBy[0].value : "";
    this.info.createdTime = created.length > 0 ? created[0].value : "";
    this.info.modifiedTime = modified.length > 0 ? modified[0].value : "";
    this.info.company = Company.length > 0 ? Company[0].value : "";
    this.info.appversion = AppVersion.length > 0 ? AppVersion[0].value : "";
  };
  /**
  * @return All sheet , include whole information
  */


  LuckyFile.prototype.getSheetsFull = function (isInitialCell) {
    if (isInitialCell === void 0) {
      isInitialCell = true;
    }

    var sheets = this.readXml.getElementsByTagName("sheets/sheet", constant_1.workBookFile);
    var sheetList = {};

    for (var key in sheets) {
      var sheet = sheets[key];
      sheetList[sheet.attributeList.name] = sheet.attributeList["sheetId"];
    }

    this.sheets = [];
    var order = 0;

    for (var key in sheets) {
      var sheet = sheets[key];
      var sheetName = sheet.attributeList.name;
      var sheetId = sheet.attributeList["sheetId"];
      var rid = sheet.attributeList["r:id"];
      var sheetFile = this.getSheetFileBysheetId(rid);
      var hide = sheet.attributeList.state === "hidden" ? 1 : 0;
      var drawing = this.readXml.getElementsByTagName("worksheet/drawing", sheetFile),
          drawingFile = void 0,
          drawingRelsFile = void 0;

      if (drawing != null && drawing.length > 0) {
        var attrList = drawing[0].attributeList;
        var rid_1 = method_1.getXmlAttibute(attrList, "r:id", null);

        if (rid_1 != null) {
          drawingFile = this.getDrawingFile(rid_1, sheetFile);
          drawingRelsFile = this.getDrawingRelsFile(drawingFile);
        }
      }

      if (sheetFile != null) {
        var sheet_1 = new LuckySheet_1.LuckySheet(sheetName, sheetId, order, isInitialCell, {
          sheetFile: sheetFile,
          readXml: this.readXml,
          sheetList: sheetList,
          styles: this.styles,
          sharedStrings: this.sharedStrings,
          calcChain: this.calcChain,
          imageList: this.imageList,
          drawingFile: drawingFile,
          drawingRelsFile: drawingRelsFile,
          hide: hide
        });
        this.columnWidthSet = [];
        this.rowHeightSet = [];
        this.imagePositionCaculation(sheet_1);
        this.sheets.push(sheet_1);
        order++;
      }
    }
  };

  LuckyFile.prototype.extendArray = function (index, sets, def, hidden, lens) {
    if (index < sets.length) {
      return;
    }

    var startIndex = sets.length,
        endIndex = index;
    var allGap = 0;

    if (startIndex > 0) {
      allGap = sets[startIndex - 1];
    } // else{
    //     sets.push(0);
    // }


    for (var i = startIndex; i <= endIndex; i++) {
      var gap = def,
          istring = i.toString();

      if (istring in hidden) {
        gap = 0;
      } else if (istring in lens) {
        gap = lens[istring];
      }

      allGap += Math.round(gap + 1);
      sets.push(allGap);
    }
  };

  LuckyFile.prototype.imagePositionCaculation = function (sheet) {
    var images = sheet.images,
        defaultColWidth = sheet.defaultColWidth,
        defaultRowHeight = sheet.defaultRowHeight;
    var colhidden = {};

    if (sheet.config.colhidden) {
      colhidden = sheet.config.colhidden;
    }

    var columnlen = {};

    if (sheet.config.columnlen) {
      columnlen = sheet.config.columnlen;
    }

    var rowhidden = {};

    if (sheet.config.rowhidden) {
      rowhidden = sheet.config.rowhidden;
    }

    var rowlen = {};

    if (sheet.config.rowlen) {
      rowlen = sheet.config.rowlen;
    }

    for (var key in images) {
      var imageObject = images[key]; //Image, luckyImage

      var fromCol = imageObject.fromCol;
      var fromColOff = imageObject.fromColOff;
      var fromRow = imageObject.fromRow;
      var fromRowOff = imageObject.fromRowOff;
      var toCol = imageObject.toCol;
      var toColOff = imageObject.toColOff;
      var toRow = imageObject.toRow;
      var toRowOff = imageObject.toRowOff;
      var x_n = 0,
          y_n = 0;
      var cx_n = 0,
          cy_n = 0;

      if (fromCol >= this.columnWidthSet.length) {
        this.extendArray(fromCol, this.columnWidthSet, defaultColWidth, colhidden, columnlen);
      }

      if (fromCol == 0) {
        x_n = 0;
      } else {
        x_n = this.columnWidthSet[fromCol - 1];
      }

      x_n = x_n + fromColOff;

      if (fromRow >= this.rowHeightSet.length) {
        this.extendArray(fromRow, this.rowHeightSet, defaultRowHeight, rowhidden, rowlen);
      }

      if (fromRow == 0) {
        y_n = 0;
      } else {
        y_n = this.rowHeightSet[fromRow - 1];
      }

      y_n = y_n + fromRowOff;

      if (toCol >= this.columnWidthSet.length) {
        this.extendArray(toCol, this.columnWidthSet, defaultColWidth, colhidden, columnlen);
      }

      if (toCol == 0) {
        cx_n = 0;
      } else {
        cx_n = this.columnWidthSet[toCol - 1];
      }

      cx_n = cx_n + toColOff - x_n;

      if (toRow >= this.rowHeightSet.length) {
        this.extendArray(toRow, this.rowHeightSet, defaultRowHeight, rowhidden, rowlen);
      }

      if (toRow == 0) {
        cy_n = 0;
      } else {
        cy_n = this.rowHeightSet[toRow - 1];
      }

      cy_n = cy_n + toRowOff - y_n;
      console.log(defaultColWidth, colhidden, columnlen);
      console.log(fromCol, this.columnWidthSet[fromCol], fromColOff);
      console.log(toCol, this.columnWidthSet[toCol], toColOff, JSON.stringify(this.columnWidthSet));
      imageObject.originWidth = cx_n;
      imageObject.originHeight = cy_n;
      imageObject.crop.height = cy_n;
      imageObject.crop.width = cx_n;
      imageObject["default"].height = cy_n;
      imageObject["default"].left = x_n;
      imageObject["default"].top = y_n;
      imageObject["default"].width = cx_n;
    } //console.log(this.columnWidthSet, this.rowHeightSet);

  };
  /**
  * @return drawing file string
  */


  LuckyFile.prototype.getDrawingFile = function (rid, sheetFile) {
    var sheetRelsPath = "xl/worksheets/_rels/";
    var sheetFileArr = sheetFile.split("/");
    var sheetRelsName = sheetFileArr[sheetFileArr.length - 1];
    var sheetRelsFile = sheetRelsPath + sheetRelsName + ".rels";
    var drawing = this.readXml.getElementsByTagName("Relationships/Relationship", sheetRelsFile);

    if (drawing.length > 0) {
      for (var i = 0; i < drawing.length; i++) {
        var relationship = drawing[i];
        var attrList = relationship.attributeList;
        var relationshipId = method_1.getXmlAttibute(attrList, "Id", null);

        if (relationshipId == rid) {
          var target = method_1.getXmlAttibute(attrList, "Target", null);

          if (target != null) {
            return target.replace(/\.\.\//g, "");
          }
        }
      }
    }

    return null;
  };

  LuckyFile.prototype.getDrawingRelsFile = function (drawingFile) {
    var drawingRelsPath = "xl/drawings/_rels/";
    var drawingFileArr = drawingFile.split("/");
    var drawingRelsName = drawingFileArr[drawingFileArr.length - 1];
    var drawingRelsFile = drawingRelsPath + drawingRelsName + ".rels";
    return drawingRelsFile;
  };
  /**
  * @return All sheet base information widthout cell and config
  */


  LuckyFile.prototype.getSheetsWithoutCell = function () {
    this.getSheetsFull(false);
  };
  /**
  * @return LuckySheet file json
  */


  LuckyFile.prototype.Parse = function () {
    // let xml = this.readXml;
    // for(let key in this.sheetNameList){
    //     let sheetName=this.sheetNameList[key];
    //     let sheetColumns = xml.getElementsByTagName("row/c/f", sheetName);
    //     console.log(sheetColumns);
    // }
    // return "";
    this.getWorkBookInfo();
    this.getSheetsFull(); // for(let i=0;i<this.sheets.length;i++){
    //     let sheet = this.sheets[i];
    //     let _borderInfo = sheet.config._borderInfo;
    //     if(_borderInfo==null){
    //         continue;
    //     }
    //     let _borderInfoKeys = Object.keys(_borderInfo);
    //     _borderInfoKeys.sort();
    //     for(let a=0;a<_borderInfoKeys.length;a++){
    //         let key = parseInt(_borderInfoKeys[a]);
    //         let b = _borderInfo[key];
    //         if(b.cells.length==0){
    //             continue;
    //         }
    //         if(sheet.config.borderInfo==null){
    //             sheet.config.borderInfo = [];
    //         }
    //         sheet.config.borderInfo.push(b);
    //     }
    // }

    return this.toJsonString(this);
  };

  LuckyFile.prototype.toJsonString = function (file) {
    var LuckyOutPutFile = new LuckyBase_1.LuckyFileBase();
    LuckyOutPutFile.info = file.info;
    LuckyOutPutFile.sheets = [];
    file.sheets.forEach(function (sheet) {
      var sheetout = new LuckyBase_1.LuckySheetBase(); //let attrName = ["name","color","config","index","status","order","row","column","luckysheet_select_save","scrollLeft","scrollTop","zoomRatio","showGridLines","defaultColWidth","defaultRowHeight","celldata","chart","isPivotTable","pivotTable","luckysheet_conditionformat_save","freezen","calcChain"];

      if (sheet.name != null) {
        sheetout.name = sheet.name;
      }

      if (sheet.color != null) {
        sheetout.color = sheet.color;
      }

      if (sheet.config != null) {
        sheetout.config = sheet.config; // if(sheetout.config._borderInfo!=null){
        //     delete sheetout.config._borderInfo;
        // }
      }

      if (sheet.index != null) {
        sheetout.index = sheet.index;
      }

      if (sheet.status != null) {
        sheetout.status = sheet.status;
      }

      if (sheet.order != null) {
        sheetout.order = sheet.order;
      }

      if (sheet.row != null) {
        sheetout.row = sheet.row;
      }

      if (sheet.column != null) {
        sheetout.column = sheet.column;
      }

      if (sheet.luckysheet_select_save != null) {
        sheetout.luckysheet_select_save = sheet.luckysheet_select_save;
      }

      if (sheet.scrollLeft != null) {
        sheetout.scrollLeft = sheet.scrollLeft;
      }

      if (sheet.scrollTop != null) {
        sheetout.scrollTop = sheet.scrollTop;
      }

      if (sheet.zoomRatio != null) {
        sheetout.zoomRatio = sheet.zoomRatio;
      }

      if (sheet.showGridLines != null) {
        sheetout.showGridLines = sheet.showGridLines;
      }

      if (sheet.defaultColWidth != null) {
        sheetout.defaultColWidth = sheet.defaultColWidth;
      }

      if (sheet.defaultRowHeight != null) {
        sheetout.defaultRowHeight = sheet.defaultRowHeight;
      }

      if (sheet.celldata != null) {
        // sheetout.celldata = sheet.celldata;
        sheetout.celldata = [];
        sheet.celldata.forEach(function (cell) {
          var cellout = new LuckyBase_1.LuckySheetCelldataBase();
          cellout.r = cell.r;
          cellout.c = cell.c;
          cellout.v = cell.v;
          sheetout.celldata.push(cellout);
        });
      }

      if (sheet.chart != null) {
        sheetout.chart = sheet.chart;
      }

      if (sheet.isPivotTable != null) {
        sheetout.isPivotTable = sheet.isPivotTable;
      }

      if (sheet.pivotTable != null) {
        sheetout.pivotTable = sheet.pivotTable;
      }

      if (sheet.luckysheet_conditionformat_save != null) {
        sheetout.luckysheet_conditionformat_save = sheet.luckysheet_conditionformat_save;
      }

      if (sheet.freezen != null) {
        sheetout.freezen = sheet.freezen;
      }

      if (sheet.calcChain != null) {
        sheetout.calcChain = sheet.calcChain;
      }

      if (sheet.images != null) {
        sheetout.images = sheet.images;
      }

      if (sheet.dataVerification != null) {
        sheetout.dataVerification = sheet.dataVerification;
      }

      if (sheet.hyperlink != null) {
        sheetout.hyperlink = sheet.hyperlink;
      }

      if (sheet.hide != null) {
        sheetout.hide = sheet.hide;
      }

      LuckyOutPutFile.sheets.push(sheetout);
    });
    return JSON.stringify(LuckyOutPutFile);
  };

  return LuckyFile;
}(LuckyBase_1.LuckyFileBase);

exports.LuckyFile = LuckyFile;

},{"../common/constant":19,"../common/method":21,"./LuckyBase":13,"./LuckyImage":16,"./LuckySheet":17,"./ReadXml":18}],16:[function(require,module,exports){
"use strict";

var __extends = void 0 && (void 0).__extends || function () {
  var _extendStatics = function extendStatics(d, b) {
    _extendStatics = Object.setPrototypeOf || {
      __proto__: []
    } instanceof Array && function (d, b) {
      d.__proto__ = b;
    } || function (d, b) {
      for (var p in b) {
        if (b.hasOwnProperty(p)) d[p] = b[p];
      }
    };

    return _extendStatics(d, b);
  };

  return function (d, b) {
    _extendStatics(d, b);

    function __() {
      this.constructor = d;
    }

    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
  };
}();

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.ImageList = void 0;

var LuckyBase_1 = require("./LuckyBase");

var emf_1 = require("../common/emf");

var ImageList =
/** @class */
function () {
  function ImageList(files) {
    if (files == null) {
      return;
    }

    this.images = {};

    for (var fileKey in files) {
      // let reg = new RegExp("xl/media/image1.png", "g");
      if (fileKey.indexOf("xl/media/") > -1) {
        var fileNameArr = fileKey.split(".");
        var suffix = fileNameArr[fileNameArr.length - 1].toLowerCase();

        if (suffix in {
          "png": 1,
          "jpeg": 1,
          "jpg": 1,
          "gif": 1,
          "bmp": 1,
          "tif": 1,
          "webp": 1,
          "emf": 1
        }) {
          if (suffix == "emf") {
            var pNum = 0; // number of the page, that you want to render

            var scale = 1; // the scale of the document

            var wrt = new emf_1.ToContext2D(pNum, scale);
            var inp, out, stt;
            emf_1.FromEMF.K = [];
            inp = emf_1.FromEMF.C;
            out = emf_1.FromEMF.K;
            stt = 4;

            for (var p in inp) {
              out[inp[p]] = p.slice(stt);
            }

            emf_1.FromEMF.Parse(files[fileKey], wrt);
            this.images[fileKey] = wrt.canvas.toDataURL("image/png");
          } else {
            this.images[fileKey] = files[fileKey];
          }
        }
      }
    }
  }

  ImageList.prototype.getImageByName = function (pathName) {
    if (pathName in this.images) {
      var base64 = this.images[pathName];
      return new Image(pathName, base64);
    }

    return null;
  };

  return ImageList;
}();

exports.ImageList = ImageList;

var Image =
/** @class */
function (_super) {
  __extends(Image, _super);

  function Image(pathName, base64) {
    var _this = _super.call(this) || this;

    _this.src = base64;
    return _this;
  }

  Image.prototype.setDefault = function () {};

  return Image;
}(LuckyBase_1.LuckyImageBase);

},{"../common/emf":20,"./LuckyBase":13}],17:[function(require,module,exports){
"use strict";

var __extends = void 0 && (void 0).__extends || function () {
  var _extendStatics = function extendStatics(d, b) {
    _extendStatics = Object.setPrototypeOf || {
      __proto__: []
    } instanceof Array && function (d, b) {
      d.__proto__ = b;
    } || function (d, b) {
      for (var p in b) {
        if (b.hasOwnProperty(p)) d[p] = b[p];
      }
    };

    return _extendStatics(d, b);
  };

  return function (d, b) {
    _extendStatics(d, b);

    function __() {
      this.constructor = d;
    }

    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
  };
}();

var __importDefault = void 0 && (void 0).__importDefault || function (mod) {
  return mod && mod.__esModule ? mod : {
    "default": mod
  };
};

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.LuckySheet = void 0;

var LuckyCell_1 = require("./LuckyCell");

var method_1 = require("../common/method");

var constant_1 = require("../common/constant");

var ReadXml_1 = require("./ReadXml");

var LuckyBase_1 = require("./LuckyBase");

var dayjs_1 = __importDefault(require("dayjs"));

var LuckySheet =
/** @class */
function (_super) {
  __extends(LuckySheet, _super);

  function LuckySheet(sheetName, sheetId, sheetOrder, isInitialCell, allFileOption) {
    if (isInitialCell === void 0) {
      isInitialCell = false;
    }

    var _this = //Private
    _super.call(this) || this;

    _this.isInitialCell = isInitialCell;
    _this.readXml = allFileOption.readXml;
    _this.sheetFile = allFileOption.sheetFile;
    _this.styles = allFileOption.styles;
    _this.sharedStrings = allFileOption.sharedStrings;
    _this.calcChainEles = allFileOption.calcChain;
    _this.sheetList = allFileOption.sheetList;
    _this.imageList = allFileOption.imageList;
    _this.hide = allFileOption.hide; //Output

    _this.name = sheetName;
    _this.index = sheetId;
    _this.order = sheetOrder.toString();
    _this.config = new LuckyBase_1.LuckyConfig();
    _this.celldata = [];
    _this.mergeCells = _this.readXml.getElementsByTagName("mergeCells/mergeCell", _this.sheetFile);
    var clrScheme = _this.styles["clrScheme"];

    var sheetView = _this.readXml.getElementsByTagName("sheetViews/sheetView", _this.sheetFile);

    var showGridLines = "1",
        tabSelected = "0",
        zoomScale = "100",
        activeCell = "A1";

    if (sheetView.length > 0) {
      var attrList = sheetView[0].attributeList;
      showGridLines = method_1.getXmlAttibute(attrList, "showGridLines", "1");
      tabSelected = method_1.getXmlAttibute(attrList, "tabSelected", "0");
      zoomScale = method_1.getXmlAttibute(attrList, "zoomScale", "100"); // let colorId = getXmlAttibute(attrList, "colorId", "0");

      var selections = sheetView[0].getInnerElements("selection");

      if (selections != null && selections.length > 0) {
        activeCell = method_1.getXmlAttibute(selections[0].attributeList, "activeCell", "A1");
        var range = method_1.getcellrange(activeCell, _this.sheetList, sheetId);
        _this.luckysheet_select_save = [];

        _this.luckysheet_select_save.push(range);
      }
    }

    _this.showGridLines = showGridLines;
    _this.status = tabSelected;
    _this.zoomRatio = parseInt(zoomScale) / 100;

    var tabColors = _this.readXml.getElementsByTagName("sheetPr/tabColor", _this.sheetFile);

    if (tabColors != null && tabColors.length > 0) {
      var tabColor = tabColors[0],
          attrList = tabColor.attributeList; // if(attrList.rgb!=null){

      var tc = ReadXml_1.getColor(tabColor, _this.styles, "b");
      _this.color = tc; // }
    }

    var sheetFormatPr = _this.readXml.getElementsByTagName("sheetFormatPr", _this.sheetFile);

    var defaultColWidth, defaultRowHeight;

    if (sheetFormatPr.length > 0) {
      var attrList = sheetFormatPr[0].attributeList;
      defaultColWidth = method_1.getXmlAttibute(attrList, "defaultColWidth", "9.21");
      defaultRowHeight = method_1.getXmlAttibute(attrList, "defaultRowHeight", "19");
    }

    _this.defaultColWidth = method_1.getColumnWidthPixel(parseFloat(defaultColWidth));
    _this.defaultRowHeight = method_1.getRowHeightPixel(parseFloat(defaultRowHeight));

    _this.generateConfigColumnLenAndHidden();

    var cellOtherInfo = _this.generateConfigRowLenAndHiddenAddCell();

    if (_this.calcChain == null) {
      _this.calcChain = [];
    }

    var formulaListExist = {};

    for (var c = 0; c < _this.calcChainEles.length; c++) {
      var calcChainEle = _this.calcChainEles[c],
          attrList = calcChainEle.attributeList;

      if (attrList.i != sheetId) {
        continue;
      }

      var r = attrList.r,
          i = attrList.i,
          l = attrList.l,
          s = attrList.s,
          a = attrList.a,
          t = attrList.t;
      var range = method_1.getcellrange(r);
      var chain = new LuckyBase_1.LuckysheetCalcChain();
      chain.r = range.row[0];
      chain.c = range.column[0];
      chain.index = _this.index;

      _this.calcChain.push(chain);

      formulaListExist["r" + r + "c" + c] = null;
    }

    if (_this.formulaRefList != null) {
      for (var key in _this.formulaRefList) {
        var funclist = _this.formulaRefList[key];
        var mainFunc = funclist["mainRef"],
            mainCellValue = mainFunc.cellValue;
        var formulaTxt = mainFunc.fv;
        var mainR = mainCellValue.r,
            mainC = mainCellValue.c; // let refRange = getcellrange(ref);

        for (var name_1 in funclist) {
          if (name_1 == "mainRef") {
            continue;
          }

          var funcValue = funclist[name_1],
              cellValue = funcValue.cellValue;

          if (cellValue == null) {
            continue;
          }

          var r = cellValue.r,
              c = cellValue.c;
          var func = formulaTxt;
          var offsetRow = r - mainR,
              offsetCol = c - mainC;

          if (offsetRow > 0) {
            func = "=" + method_1.fromulaRef.functionCopy(func, "down", offsetRow);
          } else if (offsetRow < 0) {
            func = "=" + method_1.fromulaRef.functionCopy(func, "up", Math.abs(offsetRow));
          }

          if (offsetCol > 0) {
            func = "=" + method_1.fromulaRef.functionCopy(func, "right", offsetCol);
          } else if (offsetCol < 0) {
            func = "=" + method_1.fromulaRef.functionCopy(func, "left", Math.abs(offsetCol));
          } // console.log(offsetRow, offsetCol, func);


          cellValue.v.f = func; //添加共享公式链

          var chain = new LuckyBase_1.LuckysheetCalcChain();
          chain.r = cellValue.r;
          chain.c = cellValue.c;
          chain.index = _this.index;

          _this.calcChain.push(chain);
        }
      }
    } //There may be formulas that do not appear in calcChain


    for (var key in cellOtherInfo.formulaList) {
      if (!(key in formulaListExist)) {
        var formulaListItem = cellOtherInfo.formulaList[key];
        var chain = new LuckyBase_1.LuckysheetCalcChain();
        chain.r = formulaListItem.r;
        chain.c = formulaListItem.c;
        chain.index = _this.index;

        _this.calcChain.push(chain);
      }
    } // dataVerification config


    _this.dataVerification = _this.generateConfigDataValidations(); // hyperlink config

    _this.hyperlink = _this.generateConfigHyperlinks(); // sheet hide

    _this.hide = _this.hide;

    if (_this.mergeCells != null) {
      for (var i = 0; i < _this.mergeCells.length; i++) {
        var merge = _this.mergeCells[i],
            attrList = merge.attributeList;
        var ref = attrList.ref;

        if (ref == null) {
          continue;
        }

        var range = method_1.getcellrange(ref, _this.sheetList, sheetId);
        var mergeValue = new LuckyBase_1.LuckySheetConfigMerge();
        mergeValue.r = range.row[0];
        mergeValue.c = range.column[0];
        mergeValue.rs = range.row[1] - range.row[0] + 1;
        mergeValue.cs = range.column[1] - range.column[0] + 1;

        if (_this.config.merge == null) {
          _this.config.merge = {};
        }

        _this.config.merge[range.row[0] + "_" + range.column[0]] = mergeValue;
      }
    }

    var drawingFile = allFileOption.drawingFile,
        drawingRelsFile = allFileOption.drawingRelsFile;

    if (drawingFile != null && drawingRelsFile != null) {
      var twoCellAnchors = _this.readXml.getElementsByTagName("xdr:twoCellAnchor", drawingFile);

      if (twoCellAnchors != null && twoCellAnchors.length > 0) {
        for (var i = 0; i < twoCellAnchors.length; i++) {
          var twoCellAnchor = twoCellAnchors[i];
          var editAs = method_1.getXmlAttibute(twoCellAnchor.attributeList, "editAs", "twoCell");
          var xdrFroms = twoCellAnchor.getInnerElements("xdr:from"),
              xdrTos = twoCellAnchor.getInnerElements("xdr:to");
          var xdr_blipfills = twoCellAnchor.getInnerElements("a:blip");

          if (xdrFroms != null && xdr_blipfills != null && xdrFroms.length > 0 && xdr_blipfills.length > 0) {
            var xdrFrom = xdrFroms[0],
                xdrTo = xdrTos[0],
                xdr_blipfill = xdr_blipfills[0];
            var rembed = method_1.getXmlAttibute(xdr_blipfill.attributeList, "r:embed", null);

            var imageObject = _this.getBase64ByRid(rembed, drawingRelsFile); // let aoff = xdr_xfrm.getInnerElements("a:off"), aext = xdr_xfrm.getInnerElements("a:ext");
            // if(aoff!=null && aext!=null && aoff.length>0 && aext.length>0){
            //     let aoffAttribute = aoff[0].attributeList, aextAttribute = aext[0].attributeList;
            //     let x = getXmlAttibute(aoffAttribute, "x", null);
            //     let y = getXmlAttibute(aoffAttribute, "y", null);
            //     let cx = getXmlAttibute(aextAttribute, "cx", null);
            //     let cy = getXmlAttibute(aextAttribute, "cy", null);
            //     if(x!=null && y!=null && cx!=null && cy!=null && imageObject !=null){
            // let x_n = getPxByEMUs(parseInt(x), "c"),y_n = getPxByEMUs(parseInt(y));
            // let cx_n = getPxByEMUs(parseInt(cx), "c"),cy_n = getPxByEMUs(parseInt(cy));


            var x_n = 0,
                y_n = 0;
            var cx_n = 0,
                cy_n = 0;
            imageObject.fromCol = _this.getXdrValue(xdrFrom.getInnerElements("xdr:col"));
            imageObject.fromColOff = method_1.getPxByEMUs(_this.getXdrValue(xdrFrom.getInnerElements("xdr:colOff")));
            imageObject.fromRow = _this.getXdrValue(xdrFrom.getInnerElements("xdr:row"));
            imageObject.fromRowOff = method_1.getPxByEMUs(_this.getXdrValue(xdrFrom.getInnerElements("xdr:rowOff")));
            imageObject.toCol = _this.getXdrValue(xdrTo.getInnerElements("xdr:col"));
            imageObject.toColOff = method_1.getPxByEMUs(_this.getXdrValue(xdrTo.getInnerElements("xdr:colOff")));
            imageObject.toRow = _this.getXdrValue(xdrTo.getInnerElements("xdr:row"));
            imageObject.toRowOff = method_1.getPxByEMUs(_this.getXdrValue(xdrTo.getInnerElements("xdr:rowOff")));
            imageObject.originWidth = cx_n;
            imageObject.originHeight = cy_n;

            if (editAs == "absolute") {
              imageObject.type = "3";
            } else if (editAs == "oneCell") {
              imageObject.type = "2";
            } else {
              imageObject.type = "1";
            }

            imageObject.isFixedPos = false;
            imageObject.fixedLeft = 0;
            imageObject.fixedTop = 0;
            var imageBorder = {
              color: "#000",
              radius: 0,
              style: "solid",
              width: 0
            };
            imageObject.border = imageBorder;
            var imageCrop = {
              height: cy_n,
              offsetLeft: 0,
              offsetTop: 0,
              width: cx_n
            };
            imageObject.crop = imageCrop;
            var imageDefault = {
              height: cy_n,
              left: x_n,
              top: y_n,
              width: cx_n
            };
            imageObject["default"] = imageDefault;

            if (_this.images == null) {
              _this.images = {};
            }

            _this.images[method_1.generateRandomIndex("image")] = imageObject; //     }
            // }
          }
        }
      }
    }

    return _this;
  }

  LuckySheet.prototype.getXdrValue = function (ele) {
    if (ele == null || ele.length == 0) {
      return null;
    }

    return parseInt(ele[0].value);
  };

  LuckySheet.prototype.getBase64ByRid = function (rid, drawingRelsFile) {
    var Relationships = this.readXml.getElementsByTagName("Relationships/Relationship", drawingRelsFile);

    if (Relationships != null && Relationships.length > 0) {
      for (var i = 0; i < Relationships.length; i++) {
        var Relationship = Relationships[i];
        var attrList = Relationship.attributeList;
        var Id = method_1.getXmlAttibute(attrList, "Id", null);
        var src = method_1.getXmlAttibute(attrList, "Target", null);

        if (Id == rid) {
          src = src.replace(/\.\.\//g, "");
          src = "xl/" + src;
          var imgage = this.imageList.getImageByName(src);
          return imgage;
        }
      }
    }

    return null;
  };
  /**
  * @desc This will convert cols/col to luckysheet config of column'width
  */


  LuckySheet.prototype.generateConfigColumnLenAndHidden = function () {
    var cols = this.readXml.getElementsByTagName("cols/col", this.sheetFile);

    for (var i = 0; i < cols.length; i++) {
      var col = cols[i],
          attrList = col.attributeList;
      var min = method_1.getXmlAttibute(attrList, "min", null);
      var max = method_1.getXmlAttibute(attrList, "max", null);
      var width = method_1.getXmlAttibute(attrList, "width", null);
      var hidden = method_1.getXmlAttibute(attrList, "hidden", null);
      var customWidth = method_1.getXmlAttibute(attrList, "customWidth", null);

      if (min == null || max == null) {
        continue;
      }

      var minNum = parseInt(min) - 1,
          maxNum = parseInt(max) - 1,
          widthNum = parseFloat(width);

      for (var m = minNum; m <= maxNum; m++) {
        if (width != null) {
          if (this.config.columnlen == null) {
            this.config.columnlen = {};
          }

          this.config.columnlen[m] = method_1.getColumnWidthPixel(widthNum);
        }

        if (hidden == "1") {
          if (this.config.colhidden == null) {
            this.config.colhidden = {};
          }

          this.config.colhidden[m] = 0;

          if (this.config.columnlen) {
            delete this.config.columnlen[m];
          }
        }

        if (customWidth != null) {
          if (this.config.customWidth == null) {
            this.config.customWidth = {};
          }

          this.config.customWidth[m] = 1;
        }
      }
    }
  };
  /**
  * @desc This will convert cols/col to luckysheet config of column'width
  */


  LuckySheet.prototype.generateConfigRowLenAndHiddenAddCell = function () {
    var rows = this.readXml.getElementsByTagName("sheetData/row", this.sheetFile);
    var cellOtherInfo = {};
    var formulaList = {};
    cellOtherInfo.formulaList = formulaList;

    for (var i = 0; i < rows.length; i++) {
      var row = rows[i],
          attrList = row.attributeList;
      var rowNo = method_1.getXmlAttibute(attrList, "r", null);
      var height = method_1.getXmlAttibute(attrList, "ht", null);
      var hidden = method_1.getXmlAttibute(attrList, "hidden", null);
      var customHeight = method_1.getXmlAttibute(attrList, "customHeight", null);

      if (rowNo == null) {
        continue;
      }

      var rowNoNum = parseInt(rowNo) - 1;

      if (height != null) {
        var heightNum = parseFloat(height);

        if (this.config.rowlen == null) {
          this.config.rowlen = {};
        }

        this.config.rowlen[rowNoNum] = method_1.getRowHeightPixel(heightNum);
      }

      if (hidden == "1") {
        if (this.config.rowhidden == null) {
          this.config.rowhidden = {};
        }

        this.config.rowhidden[rowNoNum] = 0;

        if (this.config.rowlen) {
          delete this.config.rowlen[rowNoNum];
        }
      }

      if (customHeight != null) {
        if (this.config.customHeight == null) {
          this.config.customHeight = {};
        }

        this.config.customHeight[rowNoNum] = 1;
      }

      if (this.isInitialCell) {
        var cells = row.getInnerElements("c");

        for (var key in cells) {
          var cell = cells[key];
          var cellValue = new LuckyCell_1.LuckySheetCelldata(cell, this.styles, this.sharedStrings, this.mergeCells, this.sheetFile, this.readXml);

          if (cellValue._borderObject != null) {
            if (this.config.borderInfo == null) {
              this.config.borderInfo = [];
            }

            this.config.borderInfo.push(cellValue._borderObject);
            delete cellValue._borderObject;
          } // let borderId = cellValue._borderId;
          // if(borderId!=null){
          //     let borders = this.styles["borders"] as Element[];
          //     if(this.config._borderInfo==null){
          //         this.config._borderInfo = {};
          //     }
          //     if( borderId in this.config._borderInfo){
          //         this.config._borderInfo[borderId].cells.push(cellValue.r + "_" + cellValue.c);
          //     }
          //     else{
          //         let border = borders[borderId];
          //         let borderObject = new LuckySheetborderInfoCellForImp();
          //         borderObject.rangeType = "cellGroup";
          //         borderObject.cells = [];
          //         let borderCellValue = new LuckySheetborderInfoCellValue();
          //         let lefts = border.getInnerElements("left");
          //         let rights = border.getInnerElements("right");
          //         let tops = border.getInnerElements("top");
          //         let bottoms = border.getInnerElements("bottom");
          //         let diagonals = border.getInnerElements("diagonal");
          //         let left = this.getBorderInfo(lefts);
          //         let right = this.getBorderInfo(rights);
          //         let top = this.getBorderInfo(tops);
          //         let bottom = this.getBorderInfo(bottoms);
          //         let diagonal = this.getBorderInfo(diagonals);
          //         let isAdd = false;
          //         if(left!=null && left.color!=null){
          //             borderCellValue.l = left;
          //             isAdd = true;
          //         }
          //         if(right!=null && right.color!=null){
          //             borderCellValue.r = right;
          //             isAdd = true;
          //         }
          //         if(top!=null && top.color!=null){
          //             borderCellValue.t = top;
          //             isAdd = true;
          //         }
          //         if(bottom!=null && bottom.color!=null){
          //             borderCellValue.b = bottom;
          //             isAdd = true;
          //         }
          //         if(isAdd){
          //             borderObject.value = borderCellValue;
          //             this.config._borderInfo[borderId] = borderObject;
          //         }
          //     }
          // }


          if (cellValue._formulaType == "shared") {
            if (this.formulaRefList == null) {
              this.formulaRefList = {};
            }

            if (this.formulaRefList[cellValue._formulaSi] == null) {
              this.formulaRefList[cellValue._formulaSi] = {};
            }

            var fv = void 0;

            if (cellValue.v != null) {
              fv = cellValue.v.f;
            }

            var refValue = {
              t: cellValue._formulaType,
              ref: cellValue._fomulaRef,
              si: cellValue._formulaSi,
              fv: fv,
              cellValue: cellValue
            };

            if (cellValue._fomulaRef != null) {
              this.formulaRefList[cellValue._formulaSi]["mainRef"] = refValue;
            } else {
              this.formulaRefList[cellValue._formulaSi][cellValue.r + "_" + cellValue.c] = refValue;
            } // console.log(refValue, this.formulaRefList);

          } //There may be formulas that do not appear in calcChain


          if (cellValue.v != null && cellValue.v.f != null) {
            var formulaCell = {
              r: cellValue.r,
              c: cellValue.c
            };
            cellOtherInfo.formulaList["r" + cellValue.r + "c" + cellValue.c] = formulaCell;
          }

          this.celldata.push(cellValue);
        }
      }
    }

    return cellOtherInfo;
  };
  /**
   * luckysheet config of dataValidations
   *
   * @returns {IluckysheetDataVerification} - dataValidations config
   */


  LuckySheet.prototype.generateConfigDataValidations = function () {
    var rows = this.readXml.getElementsByTagName("dataValidations/dataValidation", this.sheetFile);
    var extLst = this.readXml.getElementsByTagName("extLst/ext/x14:dataValidations/x14:dataValidation", this.sheetFile) || [];
    rows = rows.concat(extLst);
    var dataVerification = {};

    for (var i = 0; i < rows.length; i++) {
      var row = rows[i];
      var attrList = row.attributeList;
      var formulaValue = row.value;
      var type = method_1.getXmlAttibute(attrList, "type", null);

      if (!type) {
        continue;
      }

      var operator = "",
          sqref = "",
          sqrefIndexArr = [],
          valueArr = [];

      var _prohibitInput = method_1.getXmlAttibute(attrList, "allowBlank", null) !== "1" ? false : true; // x14 processing


      var formulaReg = new RegExp(/<x14:formula1>|<xm:sqref>/g);

      if (formulaReg.test(formulaValue) && (extLst === null || extLst === void 0 ? void 0 : extLst.length) >= 0) {
        operator = method_1.getXmlAttibute(attrList, "operator", null);
        var peelOffData = method_1.getPeelOffX14(formulaValue);
        sqref = peelOffData === null || peelOffData === void 0 ? void 0 : peelOffData.sqref;
        sqrefIndexArr = method_1.getMultiSequenceToNum(sqref);
        valueArr = method_1.getMultiFormulaValue(peelOffData === null || peelOffData === void 0 ? void 0 : peelOffData.formula);
      } else {
        operator = method_1.getXmlAttibute(attrList, "operator", null);
        sqref = method_1.getXmlAttibute(attrList, "sqref", null); // sqrefIndexArr = getMultiSequenceToNum(sqref);

        valueArr = method_1.getMultiFormulaValue(formulaValue);
      }

      var _type = constant_1.DATA_VERIFICATION_MAP[type];
      var _type2 = null;

      var _value1 = (valueArr === null || valueArr === void 0 ? void 0 : valueArr.length) >= 1 ? valueArr[0] : "";

      var _value2 = (valueArr === null || valueArr === void 0 ? void 0 : valueArr.length) === 2 ? valueArr[1] : "";

      var _hint = method_1.getXmlAttibute(attrList, "prompt", null);

      var _hintShow = _hint ? true : false;

      var matchType = constant_1.COMMON_TYPE2.includes(_type) ? "common" : _type;
      _type2 = operator ? constant_1.DATA_VERIFICATION_TYPE2_MAP[matchType][operator] : "bw"; // mobile phone number processing

      if (_type === "text_content" && ((_value1 === null || _value1 === void 0 ? void 0 : _value1.includes("LEN")) || (_value1 === null || _value1 === void 0 ? void 0 : _value1.includes("len"))) && (_value1 === null || _value1 === void 0 ? void 0 : _value1.includes("=11"))) {
        _type = "validity";
        _type2 = "phone";
      } // date processing


      if (_type === "date") {
        var D1900 = new Date(1899, 11, 30, 0, 0, 0);
        _value1 = dayjs_1["default"](D1900).clone().add(Number(_value1), "day").format("YYYY-MM-DD");
        _value2 = dayjs_1["default"](D1900).clone().add(Number(_value2), "day").format("YYYY-MM-DD");
      } // checkbox and dropdown processing


      if (_type === "checkbox" || _type === "dropdown") {
        _type2 = null;
      } // dynamically add dataVerifications


      for (var _i = 0, sqrefIndexArr_1 = sqrefIndexArr; _i < sqrefIndexArr_1.length; _i++) {
        var ref = sqrefIndexArr_1[_i];
        dataVerification[ref] = {
          type: _type,
          type2: _type2,
          value1: _value1,
          value2: _value2,
          checked: false,
          remote: false,
          prohibitInput: _prohibitInput,
          hintShow: _hintShow,
          hintText: _hint
        };
      }
    }

    return dataVerification;
  };
  /**
   * luckysheet config of hyperlink
   *
   * @returns {IluckysheetHyperlink} - hyperlink config
   */


  LuckySheet.prototype.generateConfigHyperlinks = function () {
    var _a;

    var rows = this.readXml.getElementsByTagName("hyperlinks/hyperlink", this.sheetFile);
    var hyperlink = {};

    var _loop_1 = function _loop_1(i) {
      var row = rows[i];
      var attrList = row.attributeList;

      var ref = method_1.getXmlAttibute(attrList, "ref", null),
          refArr = method_1.getMultiSequenceToNum(ref),
          _display = method_1.getXmlAttibute(attrList, "display", null),
          _address = method_1.getXmlAttibute(attrList, "location", null),
          _tooltip = method_1.getXmlAttibute(attrList, "tooltip", null);

      var _type = _address ? "internal" : "external"; // external hyperlink


      if (!_address) {
        var rid_1 = attrList["r:id"];
        var sheetFile = this_1.sheetFile;
        var relationshipList = this_1.readXml.getElementsByTagName("Relationships/Relationship", "xl/worksheets/_rels/" + sheetFile.replace(constant_1.worksheetFilePath, "") + ".rels");
        var findRid = relationshipList === null || relationshipList === void 0 ? void 0 : relationshipList.find(function (e) {
          return e.attributeList["Id"] === rid_1;
        });

        if (findRid) {
          _address = findRid.attributeList["Target"];
          _type = (_a = findRid.attributeList["TargetMode"]) === null || _a === void 0 ? void 0 : _a.toLocaleLowerCase();
        }
      } // match R1C1


      var addressReg = new RegExp(/^.*!R([\d$])+C([\d$])*$/g);

      if (addressReg.test(_address)) {
        _address = method_1.getTransR1C1ToSequence(_address);
      } // dynamically add hyperlinks


      for (var _i = 0, refArr_1 = refArr; _i < refArr_1.length; _i++) {
        var ref_1 = refArr_1[_i];
        hyperlink[ref_1] = {
          linkAddress: _address,
          linkTooltip: _tooltip || "",
          linkType: _type,
          display: _display || ""
        };
      }
    };

    var this_1 = this;

    for (var i = 0; i < rows.length; i++) {
      _loop_1(i);
    }

    return hyperlink;
  };

  return LuckySheet;
}(LuckyBase_1.LuckySheetBase);

exports.LuckySheet = LuckySheet;

},{"../common/constant":19,"../common/method":21,"./LuckyBase":13,"./LuckyCell":14,"./ReadXml":18,"dayjs":4}],18:[function(require,module,exports){
"use strict";

var __extends = void 0 && (void 0).__extends || function () {
  var _extendStatics = function extendStatics(d, b) {
    _extendStatics = Object.setPrototypeOf || {
      __proto__: []
    } instanceof Array && function (d, b) {
      d.__proto__ = b;
    } || function (d, b) {
      for (var p in b) {
        if (b.hasOwnProperty(p)) d[p] = b[p];
      }
    };

    return _extendStatics(d, b);
  };

  return function (d, b) {
    _extendStatics(d, b);

    function __() {
      this.constructor = d;
    }

    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
  };
}();

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.getlineStringAttr = exports.getColor = exports.Element = exports.ReadXml = void 0;

var constant_1 = require("../common/constant");

var method_1 = require("../common/method");

var xmloperation =
/** @class */
function () {
  function xmloperation() {}
  /**
  * @param tag Search xml tag name , div,title etc.
  * @param file Xml string
  * @return Xml element string
  */


  xmloperation.prototype.getElementsByOneTag = function (tag, file) {
    //<a:[^/>: ]+?>.*?</a:[^/>: ]+?>
    var readTagReg;

    if (tag.indexOf("|") > -1) {
      var tags = tag.split("|"),
          tagsRegTxt = "";

      for (var i = 0; i < tags.length; i++) {
        var t = tags[i];
        tagsRegTxt += "|<" + t + " [^>]+?[^/]>[\\s\\S]*?</" + t + ">|<" + t + " [^>]+?/>|<" + t + ">[\\s\\S]*?</" + t + ">|<" + t + "/>";
      }

      tagsRegTxt = tagsRegTxt.substr(1, tagsRegTxt.length);
      readTagReg = new RegExp(tagsRegTxt, "g");
    } else {
      readTagReg = new RegExp("<" + tag + " [^>]+?[^/]>[\\s\\S]*?</" + tag + ">|<" + tag + " [^>]+?/>|<" + tag + ">[\\s\\S]*?</" + tag + ">|<" + tag + "/>", "g");
    }

    var ret = file.match(readTagReg);

    if (ret == null) {
      return [];
    } else {
      return ret;
    }
  };

  return xmloperation;
}();

var ReadXml =
/** @class */
function (_super) {
  __extends(ReadXml, _super);

  function ReadXml(files) {
    var _this = _super.call(this) || this;

    _this.originFile = files;
    return _this;
  }
  /**
  * @param path Search xml tag group , div,title etc.
  * @param fileName One of uploadfileList, uploadfileList is file group, {key:value}
  * @return Xml element calss
  */


  ReadXml.prototype.getElementsByTagName = function (path, fileName) {
    var file = this.getFileByName(fileName);
    var pathArr = path.split("/"),
        ret;

    for (var key in pathArr) {
      var path_1 = pathArr[key];

      if (ret == undefined) {
        ret = this.getElementsByOneTag(path_1, file);
      } else {
        if (ret instanceof Array) {
          var items = [];

          for (var key_1 in ret) {
            var item = ret[key_1];
            items = items.concat(this.getElementsByOneTag(path_1, item));
          }

          ret = items;
        } else {
          ret = this.getElementsByOneTag(path_1, ret);
        }
      }
    }

    var elements = [];

    for (var i = 0; i < ret.length; i++) {
      var ele = new Element(ret[i]);
      elements.push(ele);
    }

    return elements;
  };
  /**
  * @param name One of uploadfileList's name, search for file by this parameter
  * @retrun Select a file from uploadfileList
  */


  ReadXml.prototype.getFileByName = function (name) {
    for (var fileKey in this.originFile) {
      if (fileKey.indexOf(name) > -1) {
        return this.originFile[fileKey];
      }
    }

    return "";
  };

  return ReadXml;
}(xmloperation);

exports.ReadXml = ReadXml;

var Element =
/** @class */
function (_super) {
  __extends(Element, _super);

  function Element(str) {
    var _this = _super.call(this) || this;

    _this.elementString = str;

    _this.setValue();

    var readAttrReg = new RegExp('[a-zA-Z0-9_:]*?=".*?"', "g");

    var attrList = _this.container.match(readAttrReg);

    _this.attributeList = {};

    if (attrList != null) {
      for (var key in attrList) {
        var attrFull = attrList[key]; // let al= attrFull.split("=");

        if (attrFull.length == 0) {
          continue;
        }

        var attrKey = attrFull.substr(0, attrFull.indexOf('='));
        var attrValue = attrFull.substr(attrFull.indexOf('=') + 1);

        if (attrKey == null || attrValue == null || attrKey.length == 0 || attrValue.length == 0) {
          continue;
        }

        _this.attributeList[attrKey] = attrValue.substr(1, attrValue.length - 2);
      }
    }

    return _this;
  }
  /**
  * @param name Get attribute by key in element
  * @return Single attribute
  */


  Element.prototype.get = function (name) {
    return this.attributeList[name];
  };
  /**
  * @param tag Get elements by tag in elementString
  * @return Element group
  */


  Element.prototype.getInnerElements = function (tag) {
    var ret = this.getElementsByOneTag(tag, this.elementString);
    var elements = [];

    for (var i = 0; i < ret.length; i++) {
      var ele = new Element(ret[i]);
      elements.push(ele);
    }

    if (elements.length == 0) {
      return null;
    }

    return elements;
  };
  /**
  * @desc get xml dom value and container, <container>value</container>
  */


  Element.prototype.setValue = function () {
    var str = this.elementString;

    if (str.substr(str.length - 2, 2) == "/>") {
      this.value = "";
      this.container = str;
    } else {
      var firstTag = this.getFirstTag();
      var firstTagReg = new RegExp("(<" + firstTag + " [^>]+?[^/]>)([\\s\\S]*?)</" + firstTag + ">|(<" + firstTag + ">)([\\s\\S]*?)</" + firstTag + ">", "g");
      var result = firstTagReg.exec(str);

      if (result != null) {
        if (result[1] != null) {
          this.container = result[1];
          this.value = result[2];
        } else {
          this.container = result[3];
          this.value = result[4];
        }
      }
    }
  };
  /**
  * @desc get xml dom first tag, <a><b></b></a>, get a
  */


  Element.prototype.getFirstTag = function () {
    var str = this.elementString;
    var firstTag = str.substr(0, str.indexOf(' '));

    if (firstTag == "" || firstTag.indexOf(">") > -1) {
      firstTag = str.substr(0, str.indexOf('>'));
    }

    firstTag = firstTag.substr(1, firstTag.length);
    return firstTag;
  };

  return Element;
}(xmloperation);

exports.Element = Element;

function combineIndexedColor(indexedColorsInner, indexedColors) {
  var ret = {};

  if (indexedColorsInner == null || indexedColorsInner.length == 0) {
    return indexedColors;
  }

  for (var key in indexedColors) {
    var value = indexedColors[key],
        kn = parseInt(key);
    var inner = indexedColorsInner[kn];

    if (inner == null) {
      ret[key] = value;
    } else {
      var rgb = inner.attributeList.rgb;
      ret[key] = rgb;
    }
  }

  return ret;
} //clrScheme:Element[]


function getColor(color, styles, type) {
  if (type === void 0) {
    type = "g";
  }

  var attrList = color.attributeList;
  var clrScheme = styles["clrScheme"];
  var indexedColorsInner = styles["indexedColors"];
  var mruColorsInner = styles["mruColors"];
  var indexedColorsList = combineIndexedColor(indexedColorsInner, constant_1.indexedColors);
  var indexed = attrList.indexed,
      rgb = attrList.rgb,
      theme = attrList.theme,
      tint = attrList.tint;
  var bg;

  if (indexed != null) {
    var indexedNum = parseInt(indexed);
    bg = indexedColorsList[indexedNum];

    if (bg != null) {
      bg = bg.substring(bg.length - 6, bg.length);
      bg = "#" + bg;
    }
  } else if (rgb != null) {
    rgb = rgb.substring(rgb.length - 6, rgb.length);
    bg = "#" + rgb;
  } else if (theme != null) {
    var themeNum = parseInt(theme);

    if (themeNum == 0) {
      themeNum = 1;
    } else if (themeNum == 1) {
      themeNum = 0;
    } else if (themeNum == 2) {
      themeNum = 3;
    } else if (themeNum == 3) {
      themeNum = 2;
    }

    var clrSchemeElement = clrScheme[themeNum];

    if (clrSchemeElement != null) {
      var clrs = clrSchemeElement.getInnerElements("a:sysClr|a:srgbClr");

      if (clrs != null) {
        var clr = clrs[0];
        var clrAttrList = clr.attributeList; // console.log(clr.container, );

        if (clr.container.indexOf("sysClr") > -1) {
          // if(type=="g" && clrAttrList.val=="windowText"){
          //     bg = null;
          // }
          // else if((type=="t" || type=="b") && clrAttrList.val=="window"){
          //     bg = null;
          // }                    
          // else 
          if (clrAttrList.lastClr != null) {
            bg = "#" + clrAttrList.lastClr;
          } else if (clrAttrList.val != null) {
            bg = "#" + clrAttrList.val;
          }
        } else if (clr.container.indexOf("srgbClr") > -1) {
          // console.log(clrAttrList.val);
          bg = "#" + clrAttrList.val;
        }
      }
    }
  }

  if (tint != null) {
    var tintNum = parseFloat(tint);

    if (bg != null) {
      bg = method_1.LightenDarkenColor(bg, tintNum);
    }
  }

  return bg;
}

exports.getColor = getColor;
/**
 * @dom xml attribute object
 * @attr attribute name
 * @d if attribute is null, return default value
 * @return attribute value
*/

function getlineStringAttr(frpr, attr) {
  var attrEle = frpr.getInnerElements(attr),
      value;

  if (attrEle != null && attrEle.length > 0) {
    if (attr == "b" || attr == "i" || attr == "strike") {
      value = "1";
    } else if (attr == "u") {
      var v = attrEle[0].attributeList.val;

      if (v == "double") {
        value = "2";
      } else if (v == "singleAccounting") {
        value = "3";
      } else if (v == "doubleAccounting") {
        value = "4";
      } else {
        value = "1";
      }
    } else if (attr == "vertAlign") {
      var v = attrEle[0].attributeList.val;

      if (v == "subscript") {
        value = "1";
      } else if (v == "superscript") {
        value = "2";
      }
    } else {
      value = attrEle[0].attributeList.val;
    }
  }

  return value;
}

exports.getlineStringAttr = getlineStringAttr;

},{"../common/constant":19,"../common/method":21}],19:[function(require,module,exports){
"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.DATA_VERIFICATION_TYPE2_MAP = exports.COMMON_TYPE2 = exports.DATA_VERIFICATION_MAP = exports.fontFamilys = exports.numFmtDefaultMap = exports.textRotationMap = exports.wrapTextMap = exports.horizontalMap = exports.verticalMap = exports.excelBorderPositions = exports.excelBorderStyles = exports.borderTypes = exports.OEM_CHARSET = exports.indexedColors = exports.numFmtDefault = exports.BuiltInCellStyles = exports.ST_CellType = exports.workbookRels = exports.theme1File = exports.worksheetFilePath = exports.sharedStringsFile = exports.stylesFile = exports.calcChainFile = exports.workBookFile = exports.contentTypesFile = exports.appFile = exports.coreFile = exports.columeHeader_word_index = exports.columeHeader_word = void 0;
exports.columeHeader_word = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];
exports.columeHeader_word_index = {
  'A': 0,
  'B': 1,
  'C': 2,
  'D': 3,
  'E': 4,
  'F': 5,
  'G': 6,
  'H': 7,
  'I': 8,
  'J': 9,
  'K': 10,
  'L': 11,
  'M': 12,
  'N': 13,
  'O': 14,
  'P': 15,
  'Q': 16,
  'R': 17,
  'S': 18,
  'T': 19,
  'U': 20,
  'V': 21,
  'W': 22,
  'X': 23,
  'Y': 24,
  'Z': 25
};
exports.coreFile = "docProps/core.xml";
exports.appFile = "docProps/app.xml";
exports.contentTypesFile = "[Content_Types].xml";
exports.workBookFile = "xl/workbook.xml";
exports.calcChainFile = "xl/calcChain.xml";
exports.stylesFile = "xl/styles.xml";
exports.sharedStringsFile = "xl/sharedStrings.xml";
exports.worksheetFilePath = "xl/worksheets/";
exports.theme1File = "xl/theme/theme1.xml";
exports.workbookRels = "xl/_rels/workbook.xml.rels"; //Excel Built-In cell type

exports.ST_CellType = {
  "Boolean": "b",
  "Date": "d",
  "Error": "e",
  "InlineString": "inlineStr",
  "Number": "n",
  "SharedString": "s",
  "String": "str"
}; //Excel Built-In cell style

exports.BuiltInCellStyles = {
  "0": "Normal"
};
exports.numFmtDefault = {
  "0": 'General',
  "1": '0',
  "2": '0.00',
  "3": '#,##0',
  "4": '#,##0.00',
  "9": '0%',
  "10": '0.00%',
  "11": '0.00E+00',
  "12": '# ?/?',
  "13": '# ??/??',
  "14": 'm/d/yy',
  "15": 'd-mmm-yy',
  "16": 'd-mmm',
  "17": 'mmm-yy',
  "18": 'h:mm AM/PM',
  "19": 'h:mm:ss AM/PM',
  "20": 'h:mm',
  "21": 'h:mm:ss',
  "22": 'm/d/yy h:mm',
  "37": '#,##0 ;(#,##0)',
  "38": '#,##0 ;[Red](#,##0)',
  "39": '#,##0.00;(#,##0.00)',
  "40": '#,##0.00;[Red](#,##0.00)',
  "45": 'mm:ss',
  "46": '[h]:mm:ss',
  "47": 'mmss.0',
  "48": '##0.0E+0',
  "49": '@'
};
exports.indexedColors = {
  "0": '00000000',
  "1": '00FFFFFF',
  "2": '00FF0000',
  "3": '0000FF00',
  "4": '000000FF',
  "5": '00FFFF00',
  "6": '00FF00FF',
  "7": '0000FFFF',
  "8": '00000000',
  "9": '00FFFFFF',
  "10": '00FF0000',
  "11": '0000FF00',
  "12": '000000FF',
  "13": '00FFFF00',
  "14": '00FF00FF',
  "15": '0000FFFF',
  "16": '00800000',
  "17": '00008000',
  "18": '00000080',
  "19": '00808000',
  "20": '00800080',
  "21": '00008080',
  "22": '00C0C0C0',
  "23": '00808080',
  "24": '009999FF',
  "25": '00993366',
  "26": '00FFFFCC',
  "27": '00CCFFFF',
  "28": '00660066',
  "29": '00FF8080',
  "30": '000066CC',
  "31": '00CCCCFF',
  "32": '00000080',
  "33": '00FF00FF',
  "34": '00FFFF00',
  "35": '0000FFFF',
  "36": '00800080',
  "37": '00800000',
  "38": '00008080',
  "39": '000000FF',
  "40": '0000CCFF',
  "41": '00CCFFFF',
  "42": '00CCFFCC',
  "43": '00FFFF99',
  "44": '0099CCFF',
  "45": '00FF99CC',
  "46": '00CC99FF',
  "47": '00FFCC99',
  "48": '003366FF',
  "49": '0033CCCC',
  "50": '0099CC00',
  "51": '00FFCC00',
  "52": '00FF9900',
  "53": '00FF6600',
  "54": '00666699',
  "55": '00969696',
  "56": '00003366',
  "57": '00339966',
  "58": '00003300',
  "59": '00333300',
  "60": '00993300',
  "61": '00993366',
  "62": '00333399',
  "63": '00333333',
  "64": null,
  "65": null
};
exports.OEM_CHARSET = {
  "0": "ANSI_CHARSET",
  "1": "DEFAULT_CHARSET",
  "2": "SYMBOL_CHARSET",
  "77": "MAC_CHARSET",
  "128": "SHIFTJIS_CHARSET",
  "129": "HANGUL_CHARSET",
  "130": "JOHAB_CHARSET",
  "134": "GB2312_CHARSET",
  "136": "CHINESEBIG5_CHARSET",
  "161": "GREEK_CHARSET",
  "162": "TURKISH_CHARSET",
  "163": "VIETNAMESE_CHARSET",
  "177": "HEBREW_CHARSET",
  "178": "ARABIC_CHARSET",
  "186": "BALTIC_CHARSET",
  "204": "RUSSIAN_CHARSET",
  "222": "THAI_CHARSET",
  "238": "EASTEUROPE_CHARSET",
  "255": "OEM_CHARSET"
};
exports.borderTypes = {
  "none": 0,
  "thin": 1,
  "hair": 2,
  "dotted": 3,
  "dashed": 4,
  "dashDot": 5,
  "dashDotDot": 6,
  "double": 7,
  "medium": 8,
  "mediumDashed": 9,
  "mediumDashDot": 10,
  "mediumDashDotDot": 11,
  "slantDashDot": 12,
  "thick": 13
}; // 对齐文档 BORDER_STYLE https://github.com/gitbrent/xlsx-js-style#border_style-string-properties

exports.excelBorderStyles = {
  '1': 'thin',
  '2': 'hair',
  '3': 'dotted',
  '4': 'dashed',
  '5': 'dashDot',
  '6': 'dashDotDot',
  '8': 'medium',
  '9': 'mediumDashed',
  '10': 'mediumDashDot',
  '11': 'mediumDashDotDot',
  '12': 'slantDashDot',
  '13': 'thick'
};
exports.excelBorderPositions = {
  t: "top",
  b: "bottom",
  l: "left",
  r: "right"
};
exports.verticalMap = {
  '0': 'center',
  '1': 'top',
  '2': 'bottom'
};
exports.horizontalMap = {
  '0': 'center',
  '1': 'left',
  '2': 'right'
};
exports.wrapTextMap = {
  '0': false,
  '1': false,
  '2': true
};
exports.textRotationMap = {
  '0': 0,
  '1': 45,
  '2': 135,
  '3': 255,
  '4': 90,
  '5': 180
};
exports.numFmtDefaultMap = {
  "yyyy/m/d;@": "yyyy/MM/dd",
  "yyyy&quot;年&quot;m&quot;月&quot;d&quot;日&quot;;@": "yyyy&quot;年&quot;MM&quot;月&quot;dd&quot;日&quot;",
  "[$-409]yyyy/m/d\\ h:mm\\ AM/PM;@": "yyyy/MM/dd hh:mm AM/PM"
};
exports.fontFamilys = {
  "0": "defualt",
  "1": "Roman",
  "2": "Swiss",
  "3": "Modern",
  "4": "Script",
  "5": "Decorative"
};
exports.DATA_VERIFICATION_MAP = {
  list: "dropdown",
  whole: "number_integer",
  decimal: "number_decimal",
  custom: "text_content",
  textLength: "text_length",
  date: "date",
  "unknown1": "number",
  "unknown2": "checkbox",
  "unknown3": "validity"
};
exports.COMMON_TYPE2 = ["number", "number_integer", "number_decimal", "text_length"];
exports.DATA_VERIFICATION_TYPE2_MAP = {
  common: {
    between: "bw",
    notBetween: "nb",
    equal: "eq",
    notEqualTo: "ne",
    moreThanThe: "gt",
    lessThan: "lt",
    greaterOrEqualTo: "gte",
    lessThanOrEqualTo: "lte"
  },
  text_content: {
    include: "include",
    exclude: "exclude",
    equal: "equal"
  },
  date: {
    between: "bw",
    notBetween: "nb",
    equal: "eq",
    notEqualTo: "ne",
    earlierThan: "bf",
    noEarlierThan: "nbf",
    laterThan: "af",
    noLaterThan: "naf"
  },
  validity: {
    card: "card",
    phone: "phone"
  }
};

},{}],20:[function(require,module,exports){
"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.ToContext2D = exports.FromEMF = exports.UDOC = void 0;
exports.UDOC = {};
exports.UDOC.G = {
  concat: function concat(p, r) {
    for (var i = 0; i < r.cmds.length; i++) {
      p.cmds.push(r.cmds[i]);
    }

    for (var i = 0; i < r.crds.length; i++) {
      p.crds.push(r.crds[i]);
    }
  },
  getBB: function getBB(ps) {
    var x0 = 1e99,
        y0 = 1e99,
        x1 = -x0,
        y1 = -y0;

    for (var i = 0; i < ps.length; i += 2) {
      var x = ps[i],
          y = ps[i + 1];
      if (x < x0) x0 = x;else if (x > x1) x1 = x;
      if (y < y0) y0 = y;else if (y > y1) y1 = y;
    }

    return [x0, y0, x1, y1];
  },
  rectToPath: function rectToPath(r) {
    return {
      cmds: ["M", "L", "L", "L", "Z"],
      crds: [r[0], r[1], r[2], r[1], r[2], r[3], r[0], r[3]]
    };
  },
  // a inside b
  insideBox: function insideBox(a, b) {
    return b[0] <= a[0] && b[1] <= a[1] && a[2] <= b[2] && a[3] <= b[3];
  },
  isBox: function isBox(p, bb) {
    var sameCrd8 = function sameCrd8(pcrd, crds) {
      for (var o = 0; o < 8; o += 2) {
        var eq = true;

        for (var j = 0; j < 8; j++) {
          if (Math.abs(crds[j] - pcrd[j + o & 7]) >= 2) {
            eq = false;
            break;
          }
        }

        if (eq) return true;
      }

      return false;
    };

    if (p.cmds.length > 10) return false;
    var cmds = p.cmds.join(""),
        crds = p.crds;
    var sameRect = false;

    if (cmds == "MLLLZ" && crds.length == 8 || cmds == "MLLLLZ" && crds.length == 10) {
      if (crds.length == 10) crds = crds.slice(0, 8);
      var x0 = bb[0],
          y0 = bb[1],
          x1 = bb[2],
          y1 = bb[3];
      if (!sameRect) sameRect = sameCrd8(crds, [x0, y0, x1, y0, x1, y1, x0, y1]);
      if (!sameRect) sameRect = sameCrd8(crds, [x0, y1, x1, y1, x1, y0, x0, y0]);
    }

    return sameRect;
  },
  boxArea: function boxArea(a) {
    var w = a[2] - a[0],
        h = a[3] - a[1];
    return w * h;
  },
  newPath: function newPath(gst) {
    gst.pth = {
      cmds: [],
      crds: []
    };
  },
  moveTo: function moveTo(gst, x, y) {
    var p = exports.UDOC.M.multPoint(gst.ctm, [x, y]); //if(gst.cpos[0]==p[0] && gst.cpos[1]==p[1]) return;

    gst.pth.cmds.push("M");
    gst.pth.crds.push(p[0], p[1]);
    gst.cpos = p;
  },
  lineTo: function lineTo(gst, x, y) {
    var p = exports.UDOC.M.multPoint(gst.ctm, [x, y]);
    if (gst.cpos[0] == p[0] && gst.cpos[1] == p[1]) return;
    gst.pth.cmds.push("L");
    gst.pth.crds.push(p[0], p[1]);
    gst.cpos = p;
  },
  curveTo: function curveTo(gst, x1, y1, x2, y2, x3, y3) {
    var p;
    p = exports.UDOC.M.multPoint(gst.ctm, [x1, y1]);
    x1 = p[0];
    y1 = p[1];
    p = exports.UDOC.M.multPoint(gst.ctm, [x2, y2]);
    x2 = p[0];
    y2 = p[1];
    p = exports.UDOC.M.multPoint(gst.ctm, [x3, y3]);
    x3 = p[0];
    y3 = p[1];
    gst.cpos = p;
    gst.pth.cmds.push("C");
    gst.pth.crds.push(x1, y1, x2, y2, x3, y3);
  },
  closePath: function closePath(gst) {
    gst.pth.cmds.push("Z");
  },
  arc: function arc(gst, x, y, r, a0, a1, neg) {
    // circle from a0 counter-clock-wise to a1
    if (neg) while (a1 > a0) {
      a1 -= 2 * Math.PI;
    } else while (a1 < a0) {
      a1 += 2 * Math.PI;
    }
    var th = (a1 - a0) / 4;
    var x0 = Math.cos(th / 2),
        y0 = -Math.sin(th / 2);
    var x1 = (4 - x0) / 3,
        y1 = y0 == 0 ? y0 : (1 - x0) * (3 - x0) / (3 * y0);
    var x2 = x1,
        y2 = -y1;
    var x3 = x0,
        y3 = -y0;
    var p0 = [x0, y0],
        p1 = [x1, y1],
        p2 = [x2, y2],
        p3 = [x3, y3];
    var pth = {
      cmds: [gst.pth.cmds.length == 0 ? "M" : "L", "C", "C", "C", "C"],
      crds: [x0, y0, x1, y1, x2, y2, x3, y3]
    };
    var rot = [1, 0, 0, 1, 0, 0];
    exports.UDOC.M.rotate(rot, -th);

    for (var i = 0; i < 3; i++) {
      p1 = exports.UDOC.M.multPoint(rot, p1);
      p2 = exports.UDOC.M.multPoint(rot, p2);
      p3 = exports.UDOC.M.multPoint(rot, p3);
      pth.crds.push(p1[0], p1[1], p2[0], p2[1], p3[0], p3[1]);
    }

    var sc = [r, 0, 0, r, x, y];
    exports.UDOC.M.rotate(rot, -a0 + th / 2);
    exports.UDOC.M.concat(rot, sc);
    exports.UDOC.M.multArray(rot, pth.crds);
    exports.UDOC.M.multArray(gst.ctm, pth.crds);
    exports.UDOC.G.concat(gst.pth, pth);
    var y = pth.crds.pop();
    x = pth.crds.pop();
    gst.cpos = [x, y];
  },
  toPoly: function toPoly(p) {
    if (p.cmds[0] != "M" || p.cmds[p.cmds.length - 1] != "Z") return null;

    for (var i = 1; i < p.cmds.length - 1; i++) {
      if (p.cmds[i] != "L") return null;
    }

    var out = [],
        cl = p.crds.length;
    if (p.crds[0] == p.crds[cl - 2] && p.crds[1] == p.crds[cl - 1]) cl -= 2;

    for (var i = 0; i < cl; i += 2) {
      out.push([p.crds[i], p.crds[i + 1]]);
    }

    if (exports.UDOC.G.polyArea(p.crds) < 0) out.reverse();
    return out;
  },
  fromPoly: function fromPoly(p) {
    var o = {
      cmds: [],
      crds: []
    };

    for (var i = 0; i < p.length; i++) {
      o.crds.push(p[i][0], p[i][1]);
      o.cmds.push(i == 0 ? "M" : "L");
    }

    o.cmds.push("Z");
    return o;
  },
  polyArea: function polyArea(p) {
    if (p.length < 6) return 0;
    var l = p.length - 2;
    var sum = (p[0] - p[l]) * (p[l + 1] + p[1]);

    for (var i = 0; i < l; i += 2) {
      sum += (p[i + 2] - p[i]) * (p[i + 1] + p[i + 3]);
    }

    return -sum * 0.5;
  },
  polyClip: function polyClip(p0, p1) {
    var cp1, cp2, s, e;

    var inside = function inside(p) {
      return (cp2[0] - cp1[0]) * (p[1] - cp1[1]) > (cp2[1] - cp1[1]) * (p[0] - cp1[0]);
    };

    var isc = function isc() {
      var dc = [cp1[0] - cp2[0], cp1[1] - cp2[1]],
          dp = [s[0] - e[0], s[1] - e[1]],
          n1 = cp1[0] * cp2[1] - cp1[1] * cp2[0],
          n2 = s[0] * e[1] - s[1] * e[0],
          n3 = 1.0 / (dc[0] * dp[1] - dc[1] * dp[0]);
      return [(n1 * dp[0] - n2 * dc[0]) * n3, (n1 * dp[1] - n2 * dc[1]) * n3];
    };

    var out = p0;
    cp1 = p1[p1.length - 1];

    for (var j in p1) {
      var cp2 = p1[j];
      var inp = out;
      out = [];
      s = inp[inp.length - 1]; //last on the input list

      for (var i in inp) {
        var e = inp[i];

        if (inside(e)) {
          if (!inside(s)) {
            out.push(isc());
          }

          out.push(e);
        } else if (inside(s)) {
          out.push(isc());
        }

        s = e;
      }

      cp1 = cp2;
    }

    return out;
  }
};
exports.UDOC.M = {
  getScale: function getScale(m) {
    return Math.sqrt(Math.abs(m[0] * m[3] - m[1] * m[2]));
  },
  translate: function translate(m, x, y) {
    exports.UDOC.M.concat(m, [1, 0, 0, 1, x, y]);
  },
  rotate: function rotate(m, a) {
    exports.UDOC.M.concat(m, [Math.cos(a), -Math.sin(a), Math.sin(a), Math.cos(a), 0, 0]);
  },
  scale: function scale(m, x, y) {
    exports.UDOC.M.concat(m, [x, 0, 0, y, 0, 0]);
  },
  concat: function concat(m, w) {
    var a = m[0],
        b = m[1],
        c = m[2],
        d = m[3],
        tx = m[4],
        ty = m[5];
    m[0] = a * w[0] + b * w[2];
    m[1] = a * w[1] + b * w[3];
    m[2] = c * w[0] + d * w[2];
    m[3] = c * w[1] + d * w[3];
    m[4] = tx * w[0] + ty * w[2] + w[4];
    m[5] = tx * w[1] + ty * w[3] + w[5];
  },
  invert: function invert(m) {
    var a = m[0],
        b = m[1],
        c = m[2],
        d = m[3],
        tx = m[4],
        ty = m[5],
        adbc = a * d - b * c;
    m[0] = d / adbc;
    m[1] = -b / adbc;
    m[2] = -c / adbc;
    m[3] = a / adbc;
    m[4] = (c * ty - d * tx) / adbc;
    m[5] = (b * tx - a * ty) / adbc;
  },
  multPoint: function multPoint(m, p) {
    var x = p[0],
        y = p[1];
    return [x * m[0] + y * m[2] + m[4], x * m[1] + y * m[3] + m[5]];
  },
  multArray: function multArray(m, a) {
    for (var i = 0; i < a.length; i += 2) {
      var x = a[i],
          y = a[i + 1];
      a[i] = x * m[0] + y * m[2] + m[4];
      a[i + 1] = x * m[1] + y * m[3] + m[5];
    }
  }
};
exports.UDOC.C = {
  srgbGamma: function srgbGamma(x) {
    return x < 0.0031308 ? 12.92 * x : 1.055 * Math.pow(x, 1.0 / 2.4) - 0.055;
  },
  cmykToRgb: function cmykToRgb(clr) {
    var c = clr[0],
        m = clr[1],
        y = clr[2],
        k = clr[3]; // return [1-Math.min(1,c+k), 1-Math.min(1, m+k), 1-Math.min(1,y+k)];

    var r = 255 + c * (-4.387332384609988 * c + 54.48615194189176 * m + 18.82290502165302 * y + 212.25662451639585 * k + -285.2331026137004) + m * (1.7149763477362134 * m - 5.6096736904047315 * y + -17.873870861415444 * k - 5.497006427196366) + y * (-2.5217340131683033 * y - 21.248923337353073 * k + 17.5119270841813) + k * (-21.86122147463605 * k - 189.48180835922747);
    var g = 255 + c * (8.841041422036149 * c + 60.118027045597366 * m + 6.871425592049007 * y + 31.159100130055922 * k + -79.2970844816548) + m * (-15.310361306967817 * m + 17.575251261109482 * y + 131.35250912493976 * k - 190.9453302588951) + y * (4.444339102852739 * y + 9.8632861493405 * k - 24.86741582555878) + k * (-20.737325471181034 * k - 187.80453709719578);
    var b = 255 + c * (0.8842522430003296 * c + 8.078677503112928 * m + 30.89978309703729 * y - 0.23883238689178934 * k + -14.183576799673286) + m * (10.49593273432072 * m + 63.02378494754052 * y + 50.606957656360734 * k - 112.23884253719248) + y * (0.03296041114873217 * y + 115.60384449646641 * k + -193.58209356861505) + k * (-22.33816807309886 * k - 180.12613974708367);
    return [Math.max(0, Math.min(1, r / 255)), Math.max(0, Math.min(1, g / 255)), Math.max(0, Math.min(1, b / 255))]; //var iK = 1-c[3];  
    //return [(1-c[0])*iK, (1-c[1])*iK, (1-c[2])*iK];  
  },
  labToRgb: function labToRgb(lab) {
    var k = 903.3,
        e = 0.008856,
        L = lab[0],
        a = lab[1],
        b = lab[2];
    var fy = (L + 16) / 116,
        fy3 = fy * fy * fy;
    var fz = fy - b / 200,
        fz3 = fz * fz * fz;
    var fx = a / 500 + fy,
        fx3 = fx * fx * fx;
    var zr = fz3 > e ? fz3 : (116 * fz - 16) / k;
    var yr = fy3 > e ? fy3 : (116 * fy - 16) / k;
    var xr = fx3 > e ? fx3 : (116 * fx - 16) / k;
    var X = xr * 96.72,
        Y = yr * 100,
        Z = zr * 81.427,
        xyz = [X / 100, Y / 100, Z / 100];
    var x2s = [3.1338561, -1.6168667, -0.4906146, -0.9787684, 1.9161415, 0.0334540, 0.0719453, -0.2289914, 1.4052427];
    var rgb = [x2s[0] * xyz[0] + x2s[1] * xyz[1] + x2s[2] * xyz[2], x2s[3] * xyz[0] + x2s[4] * xyz[1] + x2s[5] * xyz[2], x2s[6] * xyz[0] + x2s[7] * xyz[1] + x2s[8] * xyz[2]];

    for (var i = 0; i < 3; i++) {
      rgb[i] = Math.max(0, Math.min(1, exports.UDOC.C.srgbGamma(rgb[i])));
    }

    return rgb;
  }
};

exports.UDOC.getState = function (crds) {
  return {
    font: exports.UDOC.getFont(),
    dd: {
      flat: 1
    },
    space: "/DeviceGray",
    // fill
    ca: 1,
    colr: [0, 0, 0],
    sspace: "/DeviceGray",
    // stroke
    CA: 1,
    COLR: [0, 0, 0],
    bmode: "/Normal",
    SA: false,
    OPM: 0,
    AIS: false,
    OP: false,
    op: false,
    SMask: "/None",
    lwidth: 1,
    lcap: 0,
    ljoin: 0,
    mlimit: 10,
    SM: 0.1,
    doff: 0,
    dash: [],
    ctm: [1, 0, 0, 1, 0, 0],
    cpos: [0, 0],
    pth: {
      cmds: [],
      crds: []
    },
    cpth: crds ? exports.UDOC.G.rectToPath(crds) : null // clipping path

  };
};

exports.UDOC.getFont = function () {
  return {
    Tc: 0,
    Tw: 0,
    Th: 100,
    Tl: 0,
    Tf: "Helvetica-Bold",
    Tfs: 1,
    Tmode: 0,
    Trise: 0,
    Tk: 0,
    Tal: 0,
    Tun: 0,
    Tm: [1, 0, 0, 1, 0, 0],
    Tlm: [1, 0, 0, 1, 0, 0],
    Trm: [1, 0, 0, 1, 0, 0]
  };
};

exports.FromEMF = function () {};

exports.FromEMF.Parse = function (buff, genv) {
  buff = new Uint8Array(buff);
  var off = 0; //console.log(buff.slice(0,32));

  var prms = {
    fill: false,
    strk: false,
    bb: [0, 0, 1, 1],
    wbb: [0, 0, 1, 1],
    fnt: {
      nam: "Arial",
      hgh: 25,
      und: false,
      orn: 0
    },
    tclr: [0, 0, 0],
    talg: 0
  },
      gst,
      tab = [],
      sts = [];
  var rI = exports.FromEMF.B.readShort,
      rU = exports.FromEMF.B.readUshort,
      rI32 = exports.FromEMF.B.readInt,
      rU32 = exports.FromEMF.B.readUint,
      rF32 = exports.FromEMF.B.readFloat;
  var opn = 0;

  while (true) {
    var fnc = rU32(buff, off);
    off += 4;
    var fnm = exports.FromEMF.K[fnc];
    var siz = rU32(buff, off);
    off += 4; //if(gst && isNaN(gst.ctm[0])) throw "e";
    //console.log(fnc,fnm,siz);

    var loff = off; //if(opn++==253) break;

    var obj = null,
        oid = 0; //console.log(fnm, siz);

    if (false) {} else if (fnm == "EOF") {
      break;
    } else if (fnm == "HEADER") {
      prms.bb = exports.FromEMF._readBox(buff, loff);
      loff += 16; //console.log(fnm, prms.bb);

      genv.StartPage(prms.bb[0], prms.bb[1], prms.bb[2], prms.bb[3]);
      gst = exports.UDOC.getState(prms.bb);
    } else if (fnm == "SAVEDC") sts.push(JSON.stringify(gst), JSON.stringify(prms));else if (fnm == "RESTOREDC") {
      var dif = rI32(buff, loff);
      loff += 4;

      while (dif < -1) {
        sts.pop();
        sts.pop();
      }

      prms = JSON.parse(sts.pop());
      gst = JSON.parse(sts.pop());
    } else if (fnm == "SELECTCLIPPATH") {
      gst.cpth = JSON.parse(JSON.stringify(gst.pth));
    } else if (["SETMAPMODE", "SETPOLYFILLMODE", "SETBKMODE"
    /*,"SETVIEWPORTEXTEX"*/
    , "SETICMMODE", "SETROP2", "EXTSELECTCLIPRGN"].indexOf(fnm) != -1) {} //else if(fnm=="INTERSECTCLIPRECT") {  var r=prms.crct=FromEMF._readBox(buff, loff);  /*var y0=r[1],y1=r[3]; if(y0>y1){r[1]=y1; r[3]=y0;}*/ console.log(prms.crct);  }
    else if (fnm == "SETMITERLIMIT") gst.mlimit = rU32(buff, loff);else if (fnm == "SETTEXTCOLOR") prms.tclr = [buff[loff] / 255, buff[loff + 1] / 255, buff[loff + 2] / 255];else if (fnm == "SETTEXTALIGN") prms.talg = rU32(buff, loff);else if (fnm == "SETVIEWPORTEXTEX" || fnm == "SETVIEWPORTORGEX") {
        if (prms.vbb == null) prms.vbb = [];
        var coff = fnm == "SETVIEWPORTORGEX" ? 0 : 2;
        prms.vbb[coff] = rI32(buff, loff);
        loff += 4;
        prms.vbb[coff + 1] = rI32(buff, loff);
        loff += 4; //console.log(prms.vbb);

        if (fnm == "SETVIEWPORTEXTEX") exports.FromEMF._updateCtm(prms, gst);
      } else if (fnm == "SETWINDOWEXTEX" || fnm == "SETWINDOWORGEX") {
        var coff = fnm == "SETWINDOWORGEX" ? 0 : 2;
        prms.wbb[coff] = rI32(buff, loff);
        loff += 4;
        prms.wbb[coff + 1] = rI32(buff, loff);
        loff += 4;
        if (fnm == "SETWINDOWEXTEX") exports.FromEMF._updateCtm(prms, gst);
      } //else if(fnm=="SETMETARGN") {}
      else if (fnm == "COMMENT") {
          var ds = rU32(buff, loff);
          loff += 4;
        } else if (fnm == "SELECTOBJECT") {
          var ind = rU32(buff, loff);
          loff += 4; //console.log(ind.toString(16), tab, tab[ind]);

          if (ind == 0x80000000) {
            prms.fill = true;
            gst.colr = [1, 1, 1];
          } // white brush
          else if (ind == 0x80000005) {
              prms.fill = false;
            } // null brush
            else if (ind == 0x80000007) {
                prms.strk = true;
                prms.lwidth = 1;
                gst.COLR = [0, 0, 0];
              } // black pen
              else if (ind == 0x80000008) {
                  prms.strk = false;
                } // null  pen
                else if (ind == 0x8000000d) {} // system font
                  else if (ind == 0x8000000e) {} // device default font
                    else {
                        var co = tab[ind]; //console.log(ind, co);

                        if (co.t == "b") {
                          prms.fill = co.stl != 1;

                          if (co.stl == 0) {} else if (co.stl == 1) {} else throw co.stl + " e";

                          gst.colr = co.clr;
                        } else if (co.t == "p") {
                          prms.strk = co.stl != 5;
                          gst.lwidth = co.wid;
                          gst.COLR = co.clr;
                        } else if (co.t == "f") {
                          prms.fnt = co;
                          gst.font.Tf = co.nam;
                          gst.font.Tfs = Math.abs(co.hgh);
                          gst.font.Tun = co.und;
                        } else throw "e";
                      }
        } else if (fnm == "DELETEOBJECT") {
          var ind = rU32(buff, loff);
          loff += 4;
          if (tab[ind] != null) tab[ind] = null;else throw "e";
        } else if (fnm == "CREATEBRUSHINDIRECT") {
          oid = rU32(buff, loff);
          loff += 4;
          obj = {
            t: "b"
          };
          obj.stl = rU32(buff, loff);
          loff += 4;
          obj.clr = [buff[loff] / 255, buff[loff + 1] / 255, buff[loff + 2] / 255];
          loff += 4;
          obj.htc = rU32(buff, loff);
          loff += 4; //console.log(oid, obj);
        } else if (fnm == "CREATEPEN" || fnm == "EXTCREATEPEN") {
          oid = rU32(buff, loff);
          loff += 4;
          obj = {
            t: "p"
          };

          if (fnm == "EXTCREATEPEN") {
            loff += 16;
            obj.stl = rU32(buff, loff);
            loff += 4;
            obj.wid = rU32(buff, loff);
            loff += 4; //obj.stl = rU32(buff, loff);  

            loff += 4;
          } else {
            obj.stl = rU32(buff, loff);
            loff += 4;
            obj.wid = rU32(buff, loff);
            loff += 4;
            loff += 4;
          }

          obj.clr = [buff[loff] / 255, buff[loff + 1] / 255, buff[loff + 2] / 255];
          loff += 4;
        } else if (fnm == "EXTCREATEFONTINDIRECTW") {
          oid = rU32(buff, loff);
          loff += 4;
          obj = {
            t: "f",
            nam: ""
          };
          obj.hgh = rI32(buff, loff);
          loff += 4;
          loff += 4 * 2;
          obj.orn = rI32(buff, loff) / 10;
          loff += 4;
          var wgh = rU32(buff, loff);
          loff += 4; //console.log(fnm, obj.orn, wgh);
          //console.log(rU32(buff,loff), rU32(buff,loff+4), buff.slice(loff,loff+8));

          obj.und = buff[loff + 1];
          obj.stk = buff[loff + 2];
          loff += 4 * 2;

          while (rU(buff, loff) != 0) {
            obj.nam += String.fromCharCode(rU(buff, loff));
            loff += 2;
          }

          if (wgh > 500) obj.nam += "-Bold"; //console.log(wgh, obj.nam);
        } else if (fnm == "EXTTEXTOUTW") {
          //console.log(buff.slice(loff-8, loff-8+siz));
          loff += 16;
          var mod = rU32(buff, loff);
          loff += 4; //console.log(mod);

          var scx = rF32(buff, loff);
          loff += 4;
          var scy = rF32(buff, loff);
          loff += 4;
          var rfx = rI32(buff, loff);
          loff += 4;
          var rfy = rI32(buff, loff);
          loff += 4; //console.log(mod, scx, scy,rfx,rfy);

          gst.font.Tm = [1, 0, 0, -1, 0, 0];
          exports.UDOC.M.rotate(gst.font.Tm, prms.fnt.orn * Math.PI / 180);
          exports.UDOC.M.translate(gst.font.Tm, rfx, rfy);
          var alg = prms.talg; //console.log(alg.toString(2));

          if ((alg & 6) == 6) gst.font.Tal = 2;else if ((alg & 7) == 0) gst.font.Tal = 0;else throw alg + " e";

          if ((alg & 24) == 24) {} // baseline
          else if ((alg & 24) == 0) exports.UDOC.M.translate(gst.font.Tm, 0, gst.font.Tfs);else throw "e";

          var crs = rU32(buff, loff);
          loff += 4;
          var ofs = rU32(buff, loff);
          loff += 4;
          var ops = rU32(buff, loff);
          loff += 4; //if(ops!=0) throw "e";
          //console.log(ofs,ops,crs);

          loff += 16;
          var ofD = rU32(buff, loff);
          loff += 4; //console.log(ops, ofD, loff, ofs+off-8);

          ofs += off - 8; //console.log(crs, ops);

          var str = "";

          for (var i = 0; i < crs; i++) {
            var cc = rU(buff, ofs + i * 2);
            str += String.fromCharCode(cc);
          }

          ;
          var oclr = gst.colr;
          gst.colr = prms.tclr; //console.log(str, gst.colr, gst.font.Tm);
          //var otfs = gst.font.Tfs;  gst.font.Tfs *= 1/gst.ctm[0];

          genv.PutText(gst, str, str.length * gst.font.Tfs * 0.5);
          gst.colr = oclr; //gst.font.Tfs = otfs;
          //console.log(rfx, rfy, scx, ops, rcX, rcY, rcW, rcH, offDx, str);
        } else if (fnm == "BEGINPATH") {
          exports.UDOC.G.newPath(gst);
        } else if (fnm == "ENDPATH") {} else if (fnm == "CLOSEFIGURE") exports.UDOC.G.closePath(gst);else if (fnm == "MOVETOEX") {
          exports.UDOC.G.moveTo(gst, rI32(buff, loff), rI32(buff, loff + 4));
        } else if (fnm == "LINETO") {
          if (gst.pth.cmds.length == 0) {
            var im = gst.ctm.slice(0);
            exports.UDOC.M.invert(im);
            var p = exports.UDOC.M.multPoint(im, gst.cpos);
            exports.UDOC.G.moveTo(gst, p[0], p[1]);
          }

          exports.UDOC.G.lineTo(gst, rI32(buff, loff), rI32(buff, loff + 4));
        } else if (fnm == "POLYGON" || fnm == "POLYGON16" || fnm == "POLYLINE" || fnm == "POLYLINE16" || fnm == "POLYLINETO" || fnm == "POLYLINETO16") {
          loff += 16;
          var ndf = fnm.startsWith("POLYGON"),
              isTo = fnm.indexOf("TO") != -1;
          var cnt = rU32(buff, loff);
          loff += 4;
          if (!isTo) exports.UDOC.G.newPath(gst);
          loff = exports.FromEMF._drawPoly(buff, loff, cnt, gst, fnm.endsWith("16") ? 2 : 4, ndf, isTo);
          if (!isTo) exports.FromEMF._draw(genv, gst, prms, ndf); //console.log(prms, gst.lwidth);
          //console.log(JSON.parse(JSON.stringify(gst.pth)));
        } else if (fnm == "POLYPOLYGON16") {
          loff += 16;
          var ndf = fnm.startsWith("POLYPOLYGON"),
              isTo = fnm.indexOf("TO") != -1;
          var nop = rU32(buff, loff);
          loff += 4;
          loff += 4;
          var pi = loff;
          loff += nop * 4;
          if (!isTo) exports.UDOC.G.newPath(gst);

          for (var i = 0; i < nop; i++) {
            var ppp = rU(buff, pi + i * 4);
            loff = exports.FromEMF._drawPoly(buff, loff, ppp, gst, fnm.endsWith("16") ? 2 : 4, ndf, isTo);
          }

          if (!isTo) exports.FromEMF._draw(genv, gst, prms, ndf);
        } else if (fnm == "POLYBEZIER" || fnm == "POLYBEZIER16" || fnm == "POLYBEZIERTO" || fnm == "POLYBEZIERTO16") {
          loff += 16;
          var is16 = fnm.endsWith("16"),
              rC = is16 ? rI : rI32,
              nl = is16 ? 2 : 4;
          var cnt = rU32(buff, loff);
          loff += 4;

          if (fnm.indexOf("TO") == -1) {
            exports.UDOC.G.moveTo(gst, rC(buff, loff), rC(buff, loff + nl));
            loff += 2 * nl;
            cnt--;
          }

          while (cnt > 0) {
            exports.UDOC.G.curveTo(gst, rC(buff, loff), rC(buff, loff + nl), rC(buff, loff + 2 * nl), rC(buff, loff + 3 * nl), rC(buff, loff + 4 * nl), rC(buff, loff + 5 * nl));
            loff += 6 * nl;
            cnt -= 3;
          } //console.log(JSON.parse(JSON.stringify(gst.pth)));

        } else if (fnm == "RECTANGLE" || fnm == "ELLIPSE") {
          exports.UDOC.G.newPath(gst);

          var bx = exports.FromEMF._readBox(buff, loff);

          if (fnm == "RECTANGLE") {
            exports.UDOC.G.moveTo(gst, bx[0], bx[1]);
            exports.UDOC.G.lineTo(gst, bx[2], bx[1]);
            exports.UDOC.G.lineTo(gst, bx[2], bx[3]);
            exports.UDOC.G.lineTo(gst, bx[0], bx[3]);
          } else {
            var x = (bx[0] + bx[2]) / 2,
                y = (bx[1] + bx[3]) / 2;
            exports.UDOC.G.arc(gst, x, y, (bx[2] - bx[0]) / 2, 0, 2 * Math.PI, false);
          }

          exports.UDOC.G.closePath(gst);

          exports.FromEMF._draw(genv, gst, prms, true); //console.log(prms, gst.lwidth);

        } else if (fnm == "FILLPATH") genv.Fill(gst, false);else if (fnm == "STROKEPATH") genv.Stroke(gst);else if (fnm == "STROKEANDFILLPATH") {
          genv.Fill(gst, false);
          genv.Stroke(gst);
        } else if (fnm == "SETWORLDTRANSFORM" || fnm == "MODIFYWORLDTRANSFORM") {
          var mat = [];

          for (var i = 0; i < 6; i++) {
            mat.push(rF32(buff, loff + i * 4));
          }

          loff += 24; //console.log(fnm, gst.ctm.slice(0), mat);

          if (fnm == "SETWORLDTRANSFORM") gst.ctm = mat;else {
            var mod = rU32(buff, loff);
            loff += 4;

            if (mod == 2) {
              var om = gst.ctm;
              gst.ctm = mat;
              exports.UDOC.M.concat(gst.ctm, om);
            } else throw "e";
          }
        } else if (fnm == "SETSTRETCHBLTMODE") {
          var sm = rU32(buff, loff);
          loff += 4;
        } else if (fnm == "STRETCHDIBITS") {
          var bx = exports.FromEMF._readBox(buff, loff);

          loff += 16;
          var xD = rI32(buff, loff);
          loff += 4;
          var yD = rI32(buff, loff);
          loff += 4;
          var xS = rI32(buff, loff);
          loff += 4;
          var yS = rI32(buff, loff);
          loff += 4;
          var wS = rI32(buff, loff);
          loff += 4;
          var hS = rI32(buff, loff);
          loff += 4;
          var ofH = rU32(buff, loff) + off - 8;
          loff += 4;
          var szH = rU32(buff, loff);
          loff += 4;
          var ofB = rU32(buff, loff) + off - 8;
          loff += 4;
          var szB = rU32(buff, loff);
          loff += 4;
          var usg = rU32(buff, loff);
          loff += 4;
          if (usg != 0) throw "e";
          var bop = rU32(buff, loff);
          loff += 4;
          var wD = rI32(buff, loff);
          loff += 4;
          var hD = rI32(buff, loff);
          loff += 4; //console.log(bop, wD, hD);
          //console.log(ofH, szH, ofB, szB, ofH+40);
          //console.log(bx, xD,yD,wD,hD);
          //console.log(xS,yS,wS,hS);
          //console.log(ofH,szH,ofB,szB,usg,bop);

          var hl = rU32(buff, ofH);
          ofH += 4;
          var w = rU32(buff, ofH);
          ofH += 4;
          var h = rU32(buff, ofH);
          ofH += 4;
          if (w != wS || h != hS) throw "e";
          var ps = rU(buff, ofH);
          ofH += 2;
          var bc = rU(buff, ofH);
          ofH += 2;
          if (bc != 8 && bc != 24 && bc != 32) throw bc + " e";
          var cpr = rU32(buff, ofH);
          ofH += 4;
          if (cpr != 0) throw cpr + " e";
          var sz = rU32(buff, ofH);
          ofH += 4;
          var xpm = rU32(buff, ofH);
          ofH += 4;
          var ypm = rU32(buff, ofH);
          ofH += 4;
          var cu = rU32(buff, ofH);
          ofH += 4;
          var ci = rU32(buff, ofH);
          ofH += 4; //console.log(hl, w, h, ps, bc, cpr, sz, xpm, ypm, cu, ci);
          //console.log(hl,w,h,",",xS,yS,wS,hS,",",xD,yD,wD,hD,",",xpm,ypm);

          var rl = Math.floor((w * ps * bc + 31 & ~31) / 8);
          var img = new Uint8Array(w * h * 4);

          if (bc == 8) {
            for (var y = 0; y < h; y++) {
              for (var x = 0; x < w; x++) {
                var qi = y * w + x << 2,
                    ind = buff[ofB + (h - 1 - y) * rl + x] << 2;
                img[qi] = buff[ofH + ind + 2];
                img[qi + 1] = buff[ofH + ind + 1];
                img[qi + 2] = buff[ofH + ind + 0];
                img[qi + 3] = 255;
              }
            }
          }

          if (bc == 24) {
            for (var y = 0; y < h; y++) {
              for (var x = 0; x < w; x++) {
                var qi = y * w + x << 2,
                    ti = ofB + (h - 1 - y) * rl + x * 3;
                img[qi] = buff[ti + 2];
                img[qi + 1] = buff[ti + 1];
                img[qi + 2] = buff[ti + 0];
                img[qi + 3] = 255;
              }
            }
          }

          if (bc == 32) {
            for (var y = 0; y < h; y++) {
              for (var x = 0; x < w; x++) {
                var qi = y * w + x << 2,
                    ti = ofB + (h - 1 - y) * rl + x * 4;
                img[qi] = buff[ti + 2];
                img[qi + 1] = buff[ti + 1];
                img[qi + 2] = buff[ti + 0];
                img[qi + 3] = buff[ti + 3];
              }
            }
          }

          var ctm = gst.ctm.slice(0);
          gst.ctm = [1, 0, 0, 1, 0, 0];
          exports.UDOC.M.scale(gst.ctm, wD, -hD);
          exports.UDOC.M.translate(gst.ctm, xD, yD + hD);
          exports.UDOC.M.concat(gst.ctm, ctm);
          genv.PutImage(gst, img, w, h);
          gst.ctm = ctm;
        } else {
          console.log(fnm, siz);
        }

    if (obj != null) tab[oid] = obj;
    off += siz - 8;
  } //genv.Stroke(gst);


  genv.ShowPage();
  genv.Done();
};

exports.FromEMF._readBox = function (buff, off) {
  var b = [];

  for (var i = 0; i < 4; i++) {
    b[i] = exports.FromEMF.B.readInt(buff, off + i * 4);
  }

  return b;
};

exports.FromEMF._updateCtm = function (prms, gst) {
  var mat = [1, 0, 0, 1, 0, 0];
  var wbb = prms.wbb,
      bb = prms.bb,
      vbb = prms.vbb && prms.vbb.length == 4 ? prms.vbb : prms.bb; //var y0 = bb[1], y1 = bb[3];  bb[1]=Math.min(y0,y1);  bb[3]=Math.max(y0,y1);

  exports.UDOC.M.translate(mat, -wbb[0], -wbb[1]);
  exports.UDOC.M.scale(mat, 1 / wbb[2], 1 / wbb[3]);
  exports.UDOC.M.scale(mat, vbb[2], vbb[3]); //UDOC.M.scale(mat, vbb[2]/(bb[2]-bb[0]), vbb[3]/(bb[3]-bb[1]));
  //UDOC.M.scale(mat, bb[2]-bb[0],bb[3]-bb[1]);

  gst.ctm = mat;
};

exports.FromEMF._draw = function (genv, gst, prms, needFill) {
  if (prms.fill && needFill) genv.Fill(gst, false);
  if (prms.strk && gst.lwidth != 0) genv.Stroke(gst);
};

exports.FromEMF._drawPoly = function (buff, off, ppp, gst, nl, clos, justLine) {
  var rS = nl == 2 ? exports.FromEMF.B.readShort : exports.FromEMF.B.readInt;

  for (var j = 0; j < ppp; j++) {
    var px = rS(buff, off);
    off += nl;
    var py = rS(buff, off);
    off += nl;
    if (j == 0 && !justLine) exports.UDOC.G.moveTo(gst, px, py);else exports.UDOC.G.lineTo(gst, px, py);
  }

  if (clos) exports.UDOC.G.closePath(gst);
  return off;
};

exports.FromEMF.B = {
  uint8: new Uint8Array(4),
  readShort: function readShort(buff, p) {
    var u8 = exports.FromEMF.B.uint8;
    u8[0] = buff[p];
    u8[1] = buff[p + 1];
    return exports.FromEMF.B.int16[0];
  },
  readUshort: function readUshort(buff, p) {
    var u8 = exports.FromEMF.B.uint8;
    u8[0] = buff[p];
    u8[1] = buff[p + 1];
    return exports.FromEMF.B.uint16[0];
  },
  readInt: function readInt(buff, p) {
    var u8 = exports.FromEMF.B.uint8;
    u8[0] = buff[p];
    u8[1] = buff[p + 1];
    u8[2] = buff[p + 2];
    u8[3] = buff[p + 3];
    return exports.FromEMF.B.int32[0];
  },
  readUint: function readUint(buff, p) {
    var u8 = exports.FromEMF.B.uint8;
    u8[0] = buff[p];
    u8[1] = buff[p + 1];
    u8[2] = buff[p + 2];
    u8[3] = buff[p + 3];
    return exports.FromEMF.B.uint32[0];
  },
  readFloat: function readFloat(buff, p) {
    var u8 = exports.FromEMF.B.uint8;
    u8[0] = buff[p];
    u8[1] = buff[p + 1];
    u8[2] = buff[p + 2];
    u8[3] = buff[p + 3];
    return exports.FromEMF.B.flot32[0];
  },
  readASCII: function readASCII(buff, p, l) {
    var s = "";

    for (var i = 0; i < l; i++) {
      s += String.fromCharCode(buff[p + i]);
    }

    return s;
  }
};
exports.FromEMF.B.int16 = new Int16Array(exports.FromEMF.B.uint8.buffer);
exports.FromEMF.B.uint16 = new Uint16Array(exports.FromEMF.B.uint8.buffer);
exports.FromEMF.B.int32 = new Int32Array(exports.FromEMF.B.uint8.buffer);
exports.FromEMF.B.uint32 = new Uint32Array(exports.FromEMF.B.uint8.buffer);
exports.FromEMF.B.flot32 = new Float32Array(exports.FromEMF.B.uint8.buffer);
exports.FromEMF.C = {
  EMR_HEADER: 0x00000001,
  EMR_POLYBEZIER: 0x00000002,
  EMR_POLYGON: 0x00000003,
  EMR_POLYLINE: 0x00000004,
  EMR_POLYBEZIERTO: 0x00000005,
  EMR_POLYLINETO: 0x00000006,
  EMR_POLYPOLYLINE: 0x00000007,
  EMR_POLYPOLYGON: 0x00000008,
  EMR_SETWINDOWEXTEX: 0x00000009,
  EMR_SETWINDOWORGEX: 0x0000000A,
  EMR_SETVIEWPORTEXTEX: 0x0000000B,
  EMR_SETVIEWPORTORGEX: 0x0000000C,
  EMR_SETBRUSHORGEX: 0x0000000D,
  EMR_EOF: 0x0000000E,
  EMR_SETPIXELV: 0x0000000F,
  EMR_SETMAPPERFLAGS: 0x00000010,
  EMR_SETMAPMODE: 0x00000011,
  EMR_SETBKMODE: 0x00000012,
  EMR_SETPOLYFILLMODE: 0x00000013,
  EMR_SETROP2: 0x00000014,
  EMR_SETSTRETCHBLTMODE: 0x00000015,
  EMR_SETTEXTALIGN: 0x00000016,
  EMR_SETCOLORADJUSTMENT: 0x00000017,
  EMR_SETTEXTCOLOR: 0x00000018,
  EMR_SETBKCOLOR: 0x00000019,
  EMR_OFFSETCLIPRGN: 0x0000001A,
  EMR_MOVETOEX: 0x0000001B,
  EMR_SETMETARGN: 0x0000001C,
  EMR_EXCLUDECLIPRECT: 0x0000001D,
  EMR_INTERSECTCLIPRECT: 0x0000001E,
  EMR_SCALEVIEWPORTEXTEX: 0x0000001F,
  EMR_SCALEWINDOWEXTEX: 0x00000020,
  EMR_SAVEDC: 0x00000021,
  EMR_RESTOREDC: 0x00000022,
  EMR_SETWORLDTRANSFORM: 0x00000023,
  EMR_MODIFYWORLDTRANSFORM: 0x00000024,
  EMR_SELECTOBJECT: 0x00000025,
  EMR_CREATEPEN: 0x00000026,
  EMR_CREATEBRUSHINDIRECT: 0x00000027,
  EMR_DELETEOBJECT: 0x00000028,
  EMR_ANGLEARC: 0x00000029,
  EMR_ELLIPSE: 0x0000002A,
  EMR_RECTANGLE: 0x0000002B,
  EMR_ROUNDRECT: 0x0000002C,
  EMR_ARC: 0x0000002D,
  EMR_CHORD: 0x0000002E,
  EMR_PIE: 0x0000002F,
  EMR_SELECTPALETTE: 0x00000030,
  EMR_CREATEPALETTE: 0x00000031,
  EMR_SETPALETTEENTRIES: 0x00000032,
  EMR_RESIZEPALETTE: 0x00000033,
  EMR_REALIZEPALETTE: 0x00000034,
  EMR_EXTFLOODFILL: 0x00000035,
  EMR_LINETO: 0x00000036,
  EMR_ARCTO: 0x00000037,
  EMR_POLYDRAW: 0x00000038,
  EMR_SETARCDIRECTION: 0x00000039,
  EMR_SETMITERLIMIT: 0x0000003A,
  EMR_BEGINPATH: 0x0000003B,
  EMR_ENDPATH: 0x0000003C,
  EMR_CLOSEFIGURE: 0x0000003D,
  EMR_FILLPATH: 0x0000003E,
  EMR_STROKEANDFILLPATH: 0x0000003F,
  EMR_STROKEPATH: 0x00000040,
  EMR_FLATTENPATH: 0x00000041,
  EMR_WIDENPATH: 0x00000042,
  EMR_SELECTCLIPPATH: 0x00000043,
  EMR_ABORTPATH: 0x00000044,
  EMR_COMMENT: 0x00000046,
  EMR_FILLRGN: 0x00000047,
  EMR_FRAMERGN: 0x00000048,
  EMR_INVERTRGN: 0x00000049,
  EMR_PAINTRGN: 0x0000004A,
  EMR_EXTSELECTCLIPRGN: 0x0000004B,
  EMR_BITBLT: 0x0000004C,
  EMR_STRETCHBLT: 0x0000004D,
  EMR_MASKBLT: 0x0000004E,
  EMR_PLGBLT: 0x0000004F,
  EMR_SETDIBITSTODEVICE: 0x00000050,
  EMR_STRETCHDIBITS: 0x00000051,
  EMR_EXTCREATEFONTINDIRECTW: 0x00000052,
  EMR_EXTTEXTOUTA: 0x00000053,
  EMR_EXTTEXTOUTW: 0x00000054,
  EMR_POLYBEZIER16: 0x00000055,
  EMR_POLYGON16: 0x00000056,
  EMR_POLYLINE16: 0x00000057,
  EMR_POLYBEZIERTO16: 0x00000058,
  EMR_POLYLINETO16: 0x00000059,
  EMR_POLYPOLYLINE16: 0x0000005A,
  EMR_POLYPOLYGON16: 0x0000005B,
  EMR_POLYDRAW16: 0x0000005C,
  EMR_CREATEMONOBRUSH: 0x0000005D,
  EMR_CREATEDIBPATTERNBRUSHPT: 0x0000005E,
  EMR_EXTCREATEPEN: 0x0000005F,
  EMR_POLYTEXTOUTA: 0x00000060,
  EMR_POLYTEXTOUTW: 0x00000061,
  EMR_SETICMMODE: 0x00000062,
  EMR_CREATECOLORSPACE: 0x00000063,
  EMR_SETCOLORSPACE: 0x00000064,
  EMR_DELETECOLORSPACE: 0x00000065,
  EMR_GLSRECORD: 0x00000066,
  EMR_GLSBOUNDEDRECORD: 0x00000067,
  EMR_PIXELFORMAT: 0x00000068,
  EMR_DRAWESCAPE: 0x00000069,
  EMR_EXTESCAPE: 0x0000006A,
  EMR_SMALLTEXTOUT: 0x0000006C,
  EMR_FORCEUFIMAPPING: 0x0000006D,
  EMR_NAMEDESCAPE: 0x0000006E,
  EMR_COLORCORRECTPALETTE: 0x0000006F,
  EMR_SETICMPROFILEA: 0x00000070,
  EMR_SETICMPROFILEW: 0x00000071,
  EMR_ALPHABLEND: 0x00000072,
  EMR_SETLAYOUT: 0x00000073,
  EMR_TRANSPARENTBLT: 0x00000074,
  EMR_GRADIENTFILL: 0x00000076,
  EMR_SETLINKEDUFIS: 0x00000077,
  EMR_SETTEXTJUSTIFICATION: 0x00000078,
  EMR_COLORMATCHTOTARGETW: 0x00000079,
  EMR_CREATECOLORSPACEW: 0x0000007A
};
exports.FromEMF.K = []; // (function() {
//     var inp, out, stt;
//     inp = FromEMF.C;   out = FromEMF.K;   stt=4;
//     for(var p in inp) out[inp[p]] = p.slice(stt);
// }  )();

exports.ToContext2D = function (needPage, scale) {
  this.canvas = document.createElement("canvas");
  this.ctx = this.canvas.getContext("2d");
  this.bb = null;
  this.currPage = 0;
  this.needPage = needPage;
  this.scale = scale;
};

exports.ToContext2D.prototype.StartPage = function (x, y, w, h) {
  if (this.currPage != this.needPage) return;
  this.bb = [x, y, w, h];
  var scl = this.scale,
      dpr = window.devicePixelRatio;
  var cnv = this.canvas,
      ctx = this.ctx;
  cnv.width = Math.round(w * scl);
  cnv.height = Math.round(h * scl);
  ctx.translate(0, h * scl);
  ctx.scale(scl, -scl);
  cnv.setAttribute("style", "border:1px solid; width:" + cnv.width / dpr + "px; height:" + cnv.height / dpr + "px");
};

exports.ToContext2D.prototype.Fill = function (gst, evenOdd) {
  if (this.currPage != this.needPage) return;
  var ctx = this.ctx;
  ctx.beginPath();

  this._setStyle(gst, ctx);

  this._draw(gst.pth, ctx);

  ctx.fill();
};

exports.ToContext2D.prototype.Stroke = function (gst) {
  if (this.currPage != this.needPage) return;
  var ctx = this.ctx;
  ctx.beginPath();

  this._setStyle(gst, ctx);

  this._draw(gst.pth, ctx);

  ctx.stroke();
};

exports.ToContext2D.prototype.PutText = function (gst, str, stw) {
  if (this.currPage != this.needPage) return;

  var scl = this._scale(gst.ctm);

  var ctx = this.ctx;

  this._setStyle(gst, ctx);

  ctx.save();
  var m = [1, 0, 0, -1, 0, 0];

  this._concat(m, gst.font.Tm);

  this._concat(m, gst.ctm); //console.log(str, m, gst);  throw "e";


  ctx.transform(m[0], m[1], m[2], m[3], m[4], m[5]);
  ctx.fillText(str, 0, 0);
  ctx.restore();
};

exports.ToContext2D.prototype.PutImage = function (gst, buff, w, h, msk) {
  if (this.currPage != this.needPage) return;
  var ctx = this.ctx;

  if (buff.length == w * h * 4) {
    buff = buff.slice(0);
    if (msk && msk.length == w * h * 4) for (var i = 0; i < buff.length; i += 4) {
      buff[i + 3] = msk[i + 1];
    }
    var cnv = document.createElement("canvas"),
        cctx = cnv.getContext("2d");
    cnv.width = w;
    cnv.height = h;
    var imgd = cctx.createImageData(w, h);

    for (var i = 0; i < buff.length; i++) {
      imgd.data[i] = buff[i];
    }

    cctx.putImageData(imgd, 0, 0);
    ctx.save();
    var m = [1, 0, 0, 1, 0, 0];

    this._concat(m, [1 / w, 0, 0, -1 / h, 0, 1]);

    this._concat(m, gst.ctm);

    ctx.transform(m[0], m[1], m[2], m[3], m[4], m[5]);
    ctx.drawImage(cnv, 0, 0);
    ctx.restore();
  }
};

exports.ToContext2D.prototype.ShowPage = function () {
  this.currPage++;
};

exports.ToContext2D.prototype.Done = function () {};

function _flt(n) {
  return "" + parseFloat(n.toFixed(2));
}

exports.ToContext2D.prototype._setStyle = function (gst, ctx) {
  var scl = this._scale(gst.ctm);

  ctx.fillStyle = this._getFill(gst.colr, gst.ca, ctx);
  ctx.strokeStyle = this._getFill(gst.COLR, gst.CA, ctx);
  ctx.lineCap = ["butt", "round", "square"][gst.lcap];
  ctx.lineJoin = ["miter", "round", "bevel"][gst.ljoin];
  ctx.lineWidth = gst.lwidth * scl;
  var dsh = gst.dash.slice(0);

  for (var i = 0; i < dsh.length; i++) {
    dsh[i] = _flt(dsh[i] * scl);
  }

  ctx.setLineDash(dsh);
  ctx.miterLimit = gst.mlimit * scl;
  var fn = gst.font.Tf,
      ln = fn.toLowerCase();
  var p0 = ln.indexOf("bold") != -1 ? "bold " : "";
  var p1 = ln.indexOf("italic") != -1 || ln.indexOf("oblique") != -1 ? "italic " : "";
  ctx.font = p0 + p1 + gst.font.Tfs + "px \"" + fn + "\"";
};

exports.ToContext2D.prototype._getFill = function (colr, ca, ctx) {
  if (colr.typ == null) return this._colr(colr, ca);else {
    var grd = colr,
        crd = grd.crds,
        mat = grd.mat,
        scl = this._scale(mat),
        gf;

    if (grd.typ == "lin") {
      var p0 = this._multPoint(mat, crd.slice(0, 2)),
          p1 = this._multPoint(mat, crd.slice(2));

      gf = ctx.createLinearGradient(p0[0], p0[1], p1[0], p1[1]);
    } else if (grd.typ == "rad") {
      var p0 = this._multPoint(mat, crd.slice(0, 2)),
          p1 = this._multPoint(mat, crd.slice(3));

      gf = ctx.createRadialGradient(p0[0], p0[1], crd[2] * scl, p1[0], p1[1], crd[5] * scl);
    }

    for (var i = 0; i < grd.grad.length; i++) {
      gf.addColorStop(grd.grad[i][0], this._colr(grd.grad[i][1], ca));
    }

    return gf;
  }
};

exports.ToContext2D.prototype._colr = function (c, a) {
  return "rgba(" + Math.round(c[0] * 255) + "," + Math.round(c[1] * 255) + "," + Math.round(c[2] * 255) + "," + a + ")";
};

exports.ToContext2D.prototype._scale = function (m) {
  return Math.sqrt(Math.abs(m[0] * m[3] - m[1] * m[2]));
};

exports.ToContext2D.prototype._concat = function (m, w) {
  var a = m[0],
      b = m[1],
      c = m[2],
      d = m[3],
      tx = m[4],
      ty = m[5];
  m[0] = a * w[0] + b * w[2];
  m[1] = a * w[1] + b * w[3];
  m[2] = c * w[0] + d * w[2];
  m[3] = c * w[1] + d * w[3];
  m[4] = tx * w[0] + ty * w[2] + w[4];
  m[5] = tx * w[1] + ty * w[3] + w[5];
};

exports.ToContext2D.prototype._multPoint = function (m, p) {
  var x = p[0],
      y = p[1];
  return [x * m[0] + y * m[2] + m[4], x * m[1] + y * m[3] + m[5]];
}, exports.ToContext2D.prototype._draw = function (path, ctx) {
  var c = 0,
      crds = path.crds;

  for (var j = 0; j < path.cmds.length; j++) {
    var cmd = path.cmds[j];

    if (cmd == "M") {
      ctx.moveTo(crds[c], crds[c + 1]);
      c += 2;
    } else if (cmd == "L") {
      ctx.lineTo(crds[c], crds[c + 1]);
      c += 2;
    } else if (cmd == "C") {
      ctx.bezierCurveTo(crds[c], crds[c + 1], crds[c + 2], crds[c + 3], crds[c + 4], crds[c + 5]);
      c += 6;
    } else if (cmd == "Q") {
      ctx.quadraticCurveTo(crds[c], crds[c + 1], crds[c + 2], crds[c + 3]);
      c += 4;
    } else if (cmd == "Z") {
      ctx.closePath();
    }
  }
};

},{}],21:[function(require,module,exports){
"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.checkCellWithinSpecifiedRange = exports.getMultiFormulaValue = exports.getPeelOffX14 = exports.getTransR1C1ToSequence = exports.getSingleSequenceToNum = exports.getSqrefRawArrFormat = exports.getRegionSequence = exports.getMultiSequenceToNum = exports.getBinaryContent = exports.isContainMultiType = exports.isKoera = exports.isJapanese = exports.isChinese = exports.fromulaRef = exports.escapeCharacter = exports.generateRandomIndex = exports.rgbToHex = exports.LightenDarkenColor = exports.getRowHeightPixel = exports.getColumnWidthPixel = exports.getXmlAttibute = exports.getPxByEMUs = exports.getptToPxRatioByDPI = exports.getcellrange = exports.getRangetxt = void 0;

var constant_1 = require("./constant");

function getRangetxt(range, sheettxt) {
  var row0 = range["row"][0],
      row1 = range["row"][1];
  var column0 = range["column"][0],
      column1 = range["column"][1];

  if (row0 == null && row1 == null) {
    return sheettxt + chatatABC(column0) + ":" + chatatABC(column1);
  } else if (column0 == null && column1 == null) {
    return sheettxt + (row0 + 1) + ":" + (row1 + 1);
  } else {
    if (column0 == column1 && row0 == row1) {
      return sheettxt + chatatABC(column0) + (row0 + 1);
    } else {
      return sheettxt + chatatABC(column0) + (row0 + 1) + ":" + chatatABC(column1) + (row1 + 1);
    }
  }
}

exports.getRangetxt = getRangetxt;

function getcellrange(txt, sheets, sheetId) {
  if (sheets === void 0) {
    sheets = {};
  }

  if (sheetId === void 0) {
    sheetId = "1";
  }

  var val = txt.split("!");
  var sheettxt = "",
      rangetxt = "",
      sheetIndex = -1;

  if (val.length > 1) {
    sheettxt = val[0];
    rangetxt = val[1];
    var si = sheets[sheettxt];

    if (si == null) {
      sheetIndex = parseInt(sheetId);
    } else {
      sheetIndex = parseInt(si);
    }
  } else {
    sheetIndex = parseInt(sheetId);
    rangetxt = val[0];
  }

  if (rangetxt.indexOf(":") == -1) {
    var row = parseInt(rangetxt.replace(/[^0-9]/g, "")) - 1;
    var col = ABCatNum(rangetxt.replace(/[^A-Za-z]/g, ""));

    if (!isNaN(row) && !isNaN(col)) {
      return {
        "row": [row, row],
        "column": [col, col],
        "sheetIndex": sheetIndex
      };
    } else {
      return null;
    }
  } else {
    var rangetxtArray = rangetxt.split(":");
    var row = [],
        col = [];
    row[0] = parseInt(rangetxtArray[0].replace(/[^0-9]/g, "")) - 1;
    row[1] = parseInt(rangetxtArray[1].replace(/[^0-9]/g, "")) - 1; // if (isNaN(row[0])) {
    //     row[0] = 0;
    // }
    // if (isNaN(row[1])) {
    //     row[1] = sheetdata.length - 1;
    // }

    if (row[0] > row[1]) {
      return null;
    }

    col[0] = ABCatNum(rangetxtArray[0].replace(/[^A-Za-z]/g, ""));
    col[1] = ABCatNum(rangetxtArray[1].replace(/[^A-Za-z]/g, "")); // if (isNaN(col[0])) {
    //     col[0] = 0;
    // }
    // if (isNaN(col[1])) {
    //     col[1] = sheetdata[0].length - 1;
    // }

    if (col[0] > col[1]) {
      return null;
    }

    return {
      "row": row,
      "column": col,
      "sheetIndex": sheetIndex
    };
  }
}

exports.getcellrange = getcellrange; //列下标  字母转数字

function ABCatNum(abc) {
  abc = abc.toUpperCase();
  var abc_len = abc.length;

  if (abc_len == 0) {
    return NaN;
  }

  var abc_array = abc.split("");
  var wordlen = constant_1.columeHeader_word.length;
  var ret = 0;

  for (var i = abc_len - 1; i >= 0; i--) {
    if (i == abc_len - 1) {
      ret += constant_1.columeHeader_word_index[abc_array[i]];
    } else {
      ret += Math.pow(wordlen, abc_len - i - 1) * (constant_1.columeHeader_word_index[abc_array[i]] + 1);
    }
  }

  return ret;
} //列下标  数字转字母


function chatatABC(index) {
  var wordlen = constant_1.columeHeader_word.length;

  if (index < wordlen) {
    return constant_1.columeHeader_word[index];
  } else {
    var last = 0,
        pre = 0,
        ret = "";
    var i = 1,
        n = 0;

    while (index >= wordlen / (wordlen - 1) * (Math.pow(wordlen, i++) - 1)) {
      n = i;
    }

    var index_ab = index - wordlen / (wordlen - 1) * (Math.pow(wordlen, n - 1) - 1); //970

    last = index_ab + 1;

    for (var x = n; x > 0; x--) {
      var last1 = last,
          x1 = x; //-702=268, 3

      if (x == 1) {
        last1 = last1 % wordlen;

        if (last1 == 0) {
          last1 = 26;
        }

        return ret + constant_1.columeHeader_word[last1 - 1];
      }

      last1 = Math.ceil(last1 / Math.pow(wordlen, x - 1)); //last1 = last1 % wordlen;

      ret += constant_1.columeHeader_word[last1 - 1];

      if (x > 1) {
        last = last - (last1 - 1) * wordlen;
      }
    }
  }
}
/**
 * @return ratio, default 0.75 1in = 2.54cm = 25.4mm = 72pt = 6pc,  pt = 1/72 In, px = 1/dpi In
*/


function getptToPxRatioByDPI() {
  return 72 / 96;
}

exports.getptToPxRatioByDPI = getptToPxRatioByDPI;
/**
 * @emus EMUs, Excel drawing unit
 * @return pixel
*/

function getPxByEMUs(emus) {
  if (emus == null) {
    return 0;
  }

  var inch = emus / 914400;
  var pt = inch * 72;
  var px = pt / getptToPxRatioByDPI();
  return px;
}

exports.getPxByEMUs = getPxByEMUs;
/**
 * @dom xml attribute object
 * @attr attribute name
 * @d if attribute is null, return default value
 * @return attribute value
*/

function getXmlAttibute(dom, attr, d) {
  var value = dom[attr];
  value = value == null ? d : value;
  return value;
}

exports.getXmlAttibute = getXmlAttibute;
/**
 * @columnWidth Excel column width
 * @return pixel column width
*/

function getColumnWidthPixel(columnWidth) {
  var pix = Math.round((columnWidth - 0.83) * 8 + 5);
  return pix;
}

exports.getColumnWidthPixel = getColumnWidthPixel;
/**
 * @rowHeight Excel row height
 * @return pixel row height
*/

function getRowHeightPixel(rowHeight) {
  var pix = Math.round(rowHeight / getptToPxRatioByDPI());
  return pix;
}

exports.getRowHeightPixel = getRowHeightPixel;

function LightenDarkenColor(sixColor, tint) {
  var hex = sixColor.substring(sixColor.length - 6, sixColor.length);
  var rgbArray = hexToRgbArray("#" + hex);
  var hslArray = rgbToHsl(rgbArray[0], rgbArray[1], rgbArray[2]);

  if (tint > 0) {
    hslArray[2] = hslArray[2] * (1.0 - tint) + tint;
  } else if (tint < 0) {
    hslArray[2] = hslArray[2] * (1.0 + tint);
  } else {
    return "#" + hex;
  }

  var newRgbArray = hslToRgb(hslArray[0], hslArray[1], hslArray[2]);
  return rgbToHex("RGB(" + newRgbArray.join(",") + ")");
}

exports.LightenDarkenColor = LightenDarkenColor;

function rgbToHex(rgb) {
  //十六进制颜色值的正则表达式
  var reg = /^#([0-9a-fA-f]{3}|[0-9a-fA-f]{6})$/; // 如果是rgb颜色表示

  if (/^(rgb|RGB)/.test(rgb)) {
    var aColor = rgb.replace(/(?:\(|\)|rgb|RGB)*/g, "").split(",");
    var strHex = "#";

    for (var i = 0; i < aColor.length; i++) {
      var hex = Number(aColor[i]).toString(16);

      if (hex.length < 2) {
        hex = '0' + hex;
      }

      strHex += hex;
    }

    if (strHex.length !== 7) {
      strHex = rgb;
    }

    return strHex;
  } else if (reg.test(rgb)) {
    var aNum = rgb.replace(/#/, "").split("");

    if (aNum.length === 6) {
      return rgb;
    } else if (aNum.length === 3) {
      var numHex = "#";

      for (var i = 0; i < aNum.length; i += 1) {
        numHex += aNum[i] + aNum[i];
      }

      return numHex;
    }
  }

  return rgb;
}

exports.rgbToHex = rgbToHex;

function hexToRgb(hex) {
  var sColor = hex.toLowerCase(); //十六进制颜色值的正则表达式

  var reg = /^#([0-9a-fA-f]{3}|[0-9a-fA-f]{6})$/; // 如果是16进制颜色

  if (sColor && reg.test(sColor)) {
    if (sColor.length === 4) {
      var sColorNew = "#";

      for (var i = 1; i < 4; i += 1) {
        sColorNew += sColor.slice(i, i + 1).concat(sColor.slice(i, i + 1));
      }

      sColor = sColorNew;
    } //处理六位的颜色值


    var sColorChange = [];

    for (var i = 1; i < 7; i += 2) {
      sColorChange.push(parseInt("0x" + sColor.slice(i, i + 2)));
    }

    return "RGB(" + sColorChange.join(",") + ")";
  }

  return sColor;
}

function hexToRgbArray(hex) {
  var sColor = hex.toLowerCase(); //十六进制颜色值的正则表达式

  var reg = /^#([0-9a-fA-f]{3}|[0-9a-fA-f]{6})$/; // 如果是16进制颜色

  if (sColor && reg.test(sColor)) {
    if (sColor.length === 4) {
      var sColorNew = "#";

      for (var i = 1; i < 4; i += 1) {
        sColorNew += sColor.slice(i, i + 1).concat(sColor.slice(i, i + 1));
      }

      sColor = sColorNew;
    } //处理六位的颜色值


    var sColorChange = [];

    for (var i = 1; i < 7; i += 2) {
      sColorChange.push(parseInt("0x" + sColor.slice(i, i + 2)));
    }

    return sColorChange;
  }

  return null;
}
/**
 * HSL颜色值转换为RGB.
 * 换算公式改编自 http://en.wikipedia.org/wiki/HSL_color_space.
 * h, s, 和 l 设定在 [0, 1] 之间
 * 返回的 r, g, 和 b 在 [0, 255]之间
 *
 * @param   Number  h       色相
 * @param   Number  s       饱和度
 * @param   Number  l       亮度
 * @return  Array           RGB色值数值
 */


function hslToRgb(h, s, l) {
  var r, g, b;

  if (s == 0) {
    r = g = b = l; // achromatic
  } else {
    var hue2rgb = function hue2rgb(p, q, t) {
      if (t < 0) t += 1;
      if (t > 1) t -= 1;
      if (t < 1 / 6) return p + (q - p) * 6 * t;
      if (t < 1 / 2) return q;
      if (t < 2 / 3) return p + (q - p) * (2 / 3 - t) * 6;
      return p;
    };

    var q = l < 0.5 ? l * (1 + s) : l + s - l * s;
    var p = 2 * l - q;
    r = hue2rgb(p, q, h + 1 / 3);
    g = hue2rgb(p, q, h);
    b = hue2rgb(p, q, h - 1 / 3);
  }

  return [Math.round(r * 255), Math.round(g * 255), Math.round(b * 255)];
}
/**
 * RGB 颜色值转换为 HSL.
 * 转换公式参考自 http://en.wikipedia.org/wiki/HSL_color_space.
 * r, g, 和 b 需要在 [0, 255] 范围内
 * 返回的 h, s, 和 l 在 [0, 1] 之间
 *
 * @param   Number  r       红色色值
 * @param   Number  g       绿色色值
 * @param   Number  b       蓝色色值
 * @return  Array           HSL各值数组
 */


function rgbToHsl(r, g, b) {
  r /= 255, g /= 255, b /= 255;
  var max = Math.max(r, g, b),
      min = Math.min(r, g, b);
  var h,
      s,
      l = (max + min) / 2;

  if (max == min) {
    h = s = 0; // achromatic
  } else {
    var d = max - min;
    s = l > 0.5 ? d / (2 - max - min) : d / (max + min);

    switch (max) {
      case r:
        h = (g - b) / d + (g < b ? 6 : 0);
        break;

      case g:
        h = (b - r) / d + 2;
        break;

      case b:
        h = (r - g) / d + 4;
        break;
    }

    h /= 6;
  }

  return [h, s, l];
}

function generateRandomIndex(prefix) {
  if (prefix == null) {
    prefix = "Sheet";
  }

  var userAgent = window.navigator.userAgent.replace(/[^a-zA-Z0-9]/g, "").split("");
  var mid = "";

  for (var i = 0; i < 5; i++) {
    mid += userAgent[Math.round(Math.random() * (userAgent.length - 1))];
  }

  var time = new Date().getTime();
  return prefix + "_" + mid + "_" + time;
}

exports.generateRandomIndex = generateRandomIndex;

function escapeCharacter(str) {
  if (str == null || str.length == 0) {
    return str;
  }

  return str.replace(/&amp;/g, "&").replace(/&quot;/g, '"').replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&nbsp;/g, ' ').replace(/&apos;/g, "'").replace(/&iexcl;/g, "¡").replace(/&cent;/g, "¢").replace(/&pound;/g, "£").replace(/&curren;/g, "¤").replace(/&yen;/g, "¥").replace(/&brvbar;/g, "¦").replace(/&sect;/g, "§").replace(/&uml;/g, "¨").replace(/&copy;/g, "©").replace(/&ordf;/g, "ª").replace(/&laquo;/g, "«").replace(/&not;/g, "¬").replace(/&shy;/g, "­").replace(/&reg;/g, "®").replace(/&macr;/g, "¯").replace(/&deg;/g, "°").replace(/&plusmn;/g, "±").replace(/&sup2;/g, "²").replace(/&sup3;/g, "³").replace(/&acute;/g, "´").replace(/&micro;/g, "µ").replace(/&para;/g, "¶").replace(/&middot;/g, "·").replace(/&cedil;/g, "¸").replace(/&sup1;/g, "¹").replace(/&ordm;/g, "º").replace(/&raquo;/g, "»").replace(/&frac14;/g, "¼").replace(/&frac12;/g, "½").replace(/&frac34;/g, "¾").replace(/&iquest;/g, "¿").replace(/&times;/g, "×").replace(/&divide;/g, "÷").replace(/&Agrave;/g, "À").replace(/&Aacute;/g, "Á").replace(/&Acirc;/g, "Â").replace(/&Atilde;/g, "Ã").replace(/&Auml;/g, "Ä").replace(/&Aring;/g, "Å").replace(/&AElig;/g, "Æ").replace(/&Ccedil;/g, "Ç").replace(/&Egrave;/g, "È").replace(/&Eacute;/g, "É").replace(/&Ecirc;/g, "Ê").replace(/&Euml;/g, "Ë").replace(/&Igrave;/g, "Ì").replace(/&Iacute;/g, "Í").replace(/&Icirc;/g, "Î").replace(/&Iuml;/g, "Ï").replace(/&ETH;/g, "Ð").replace(/&Ntilde;/g, "Ñ").replace(/&Ograve;/g, "Ò").replace(/&Oacute;/g, "Ó").replace(/&Ocirc;/g, "Ô").replace(/&Otilde;/g, "Õ").replace(/&Ouml;/g, "Ö").replace(/&Oslash;/g, "Ø").replace(/&Ugrave;/g, "Ù").replace(/&Uacute;/g, "Ú").replace(/&Ucirc;/g, "Û").replace(/&Uuml;/g, "Ü").replace(/&Yacute;/g, "Ý").replace(/&THORN;/g, "Þ").replace(/&szlig;/g, "ß").replace(/&agrave;/g, "à").replace(/&aacute;/g, "á").replace(/&acirc;/g, "â").replace(/&atilde;/g, "ã").replace(/&auml;/g, "ä").replace(/&aring;/g, "å").replace(/&aelig;/g, "æ").replace(/&ccedil;/g, "ç").replace(/&egrave;/g, "è").replace(/&eacute;/g, "é").replace(/&ecirc;/g, "ê").replace(/&euml;/g, "ë").replace(/&igrave;/g, "ì").replace(/&iacute;/g, "í").replace(/&icirc;/g, "î").replace(/&iuml;/g, "ï").replace(/&eth;/g, "ð").replace(/&ntilde;/g, "ñ").replace(/&ograve;/g, "ò").replace(/&oacute;/g, "ó").replace(/&ocirc;/g, "ô").replace(/&otilde;/g, "õ").replace(/&ouml;/g, "ö").replace(/&oslash;/g, "ø").replace(/&ugrave;/g, "ù").replace(/&uacute;/g, "ú").replace(/&ucirc;/g, "û").replace(/&uuml;/g, "ü").replace(/&yacute;/g, "ý").replace(/&thorn;/g, "þ").replace(/&yuml;/g, "ÿ");
}

exports.escapeCharacter = escapeCharacter;

var fromulaRef =
/** @class */
function () {
  function fromulaRef() {}

  fromulaRef.trim = function (str) {
    if (str == null) {
      str = "";
    }

    return str.replace(/(^\s*)|(\s*$)/g, "");
  };

  fromulaRef.functionCopy = function (txt, mode, step) {
    var _this = this;

    if (_this.operatorjson == null) {
      var arr = _this.operator.split("|"),
          op = {};

      for (var i_1 = 0; i_1 < arr.length; i_1++) {
        op[arr[i_1].toString()] = 1;
      }

      _this.operatorjson = op;
    }

    if (mode == null) {
      mode = "down";
    }

    if (step == null) {
      step = 1;
    }

    if (txt.substr(0, 1) == "=") {
      txt = txt.substr(1);
    }

    var funcstack = txt.split("");
    var i = 0,
        str = "",
        function_str = "",
        ispassby = true;
    var matchConfig = {
      "bracket": 0,
      "comma": 0,
      "squote": 0,
      "dquote": 0
    };

    while (i < funcstack.length) {
      var s = funcstack[i];

      if (s == "(" && matchConfig.dquote == 0) {
        matchConfig.bracket += 1;

        if (str.length > 0) {
          function_str += str + "(";
        } else {
          function_str += "(";
        }

        str = "";
      } else if (s == ")" && matchConfig.dquote == 0) {
        matchConfig.bracket -= 1;
        function_str += _this.functionCopy(str, mode, step) + ")";
        str = "";
      } else if (s == '"' && matchConfig.squote == 0) {
        if (matchConfig.dquote > 0) {
          function_str += str + '"';
          matchConfig.dquote -= 1;
          str = "";
        } else {
          matchConfig.dquote += 1;
          str += '"';
        }
      } else if (s == ',' && matchConfig.dquote == 0) {
        function_str += _this.functionCopy(str, mode, step) + ',';
        str = "";
      } else if (s == '&' && matchConfig.dquote == 0) {
        if (str.length > 0) {
          function_str += _this.functionCopy(str, mode, step) + "&";
          str = "";
        } else {
          function_str += "&";
        }
      } else if (s in _this.operatorjson && matchConfig.dquote == 0) {
        var s_next = "";

        if (i + 1 < funcstack.length) {
          s_next = funcstack[i + 1];
        }

        var p = i - 1,
            s_pre = null;

        if (p >= 0) {
          do {
            s_pre = funcstack[p--];
          } while (p >= 0 && s_pre == " ");
        }

        if (s + s_next in _this.operatorjson) {
          if (str.length > 0) {
            function_str += _this.functionCopy(str, mode, step) + s + s_next;
            str = "";
          } else {
            function_str += s + s_next;
          }

          i++;
        } else if (!/[^0-9]/.test(s_next) && s == "-" && (s_pre == "(" || s_pre == null || s_pre == "," || s_pre == " " || s_pre in _this.operatorjson)) {
          str += s;
        } else {
          if (str.length > 0) {
            function_str += _this.functionCopy(str, mode, step) + s;
            str = "";
          } else {
            function_str += s;
          }
        }
      } else {
        str += s;
      }

      if (i == funcstack.length - 1) {
        if (_this.iscelldata(_this.trim(str))) {
          if (mode == "down") {
            function_str += _this.downparam(_this.trim(str), step);
          } else if (mode == "up") {
            function_str += _this.upparam(_this.trim(str), step);
          } else if (mode == "left") {
            function_str += _this.leftparam(_this.trim(str), step);
          } else if (mode == "right") {
            function_str += _this.rightparam(_this.trim(str), step);
          }
        } else {
          function_str += _this.trim(str);
        }
      }

      i++;
    }

    return function_str;
  };

  fromulaRef.downparam = function (txt, step) {
    return this.updateparam("d", txt, step);
  };

  fromulaRef.upparam = function (txt, step) {
    return this.updateparam("u", txt, step);
  };

  fromulaRef.leftparam = function (txt, step) {
    return this.updateparam("l", txt, step);
  };

  fromulaRef.rightparam = function (txt, step) {
    return this.updateparam("r", txt, step);
  };

  fromulaRef.updateparam = function (orient, txt, step) {
    var _this = this;

    var val = txt.split("!"),
        rangetxt,
        prefix = "";

    if (val.length > 1) {
      rangetxt = val[1];
      prefix = val[0] + "!";
    } else {
      rangetxt = val[0];
    }

    if (rangetxt.indexOf(":") == -1) {
      var row = parseInt(rangetxt.replace(/[^0-9]/g, ""));
      var col = ABCatNum(rangetxt.replace(/[^A-Za-z]/g, ""));

      var freezonFuc = _this.isfreezonFuc(rangetxt);

      var $row = freezonFuc[0] ? "$" : "",
          $col = freezonFuc[1] ? "$" : "";

      if (orient == "u" && !freezonFuc[0]) {
        row -= step;
      } else if (orient == "r" && !freezonFuc[1]) {
        col += step;
      } else if (orient == "l" && !freezonFuc[1]) {
        col -= step;
      } else if (!freezonFuc[0]) {
        row += step;
      }

      if (row < 0 || col < 0) {
        return _this.error.r;
      }

      if (!isNaN(row) && !isNaN(col)) {
        return prefix + $col + chatatABC(col) + $row + row;
      } else if (!isNaN(row)) {
        return prefix + $row + row;
      } else if (!isNaN(col)) {
        return prefix + $col + chatatABC(col);
      } else {
        return txt;
      }
    } else {
      rangetxt = rangetxt.split(":");
      var row = [],
          col = [];
      row[0] = parseInt(rangetxt[0].replace(/[^0-9]/g, ""));
      row[1] = parseInt(rangetxt[1].replace(/[^0-9]/g, ""));

      if (row[0] > row[1]) {
        return txt;
      }

      col[0] = ABCatNum(rangetxt[0].replace(/[^A-Za-z]/g, ""));
      col[1] = ABCatNum(rangetxt[1].replace(/[^A-Za-z]/g, ""));

      if (col[0] > col[1]) {
        return txt;
      }

      var freezonFuc0 = _this.isfreezonFuc(rangetxt[0]);

      var freezonFuc1 = _this.isfreezonFuc(rangetxt[1]);

      var $row0 = freezonFuc0[0] ? "$" : "",
          $col0 = freezonFuc0[1] ? "$" : "";
      var $row1 = freezonFuc1[0] ? "$" : "",
          $col1 = freezonFuc1[1] ? "$" : "";

      if (orient == "u") {
        if (!freezonFuc0[0]) {
          row[0] -= step;
        }

        if (!freezonFuc1[0]) {
          row[1] -= step;
        }
      } else if (orient == "r") {
        if (!freezonFuc0[1]) {
          col[0] += step;
        }

        if (!freezonFuc1[1]) {
          col[1] += step;
        }
      } else if (orient == "l") {
        if (!freezonFuc0[1]) {
          col[0] -= step;
        }

        if (!freezonFuc1[1]) {
          col[1] -= step;
        }
      } else {
        if (!freezonFuc0[0]) {
          row[0] += step;
        }

        if (!freezonFuc1[0]) {
          row[1] += step;
        }
      }

      if (row[0] < 0 || col[0] < 0) {
        return _this.error.r;
      }

      if (isNaN(col[0]) && isNaN(col[1])) {
        return prefix + $row0 + row[0] + ":" + $row1 + row[1];
      } else if (isNaN(row[0]) && isNaN(row[1])) {
        return prefix + $col0 + chatatABC(col[0]) + ":" + $col1 + chatatABC(col[1]);
      } else {
        return prefix + $col0 + chatatABC(col[0]) + $row0 + row[0] + ":" + $col1 + chatatABC(col[1]) + $row1 + row[1];
      }
    }
  };

  fromulaRef.iscelldata = function (txt) {
    var val = txt.split("!"),
        rangetxt;

    if (val.length > 1) {
      rangetxt = val[1];
    } else {
      rangetxt = val[0];
    }

    var reg_cell = /^(([a-zA-Z]+)|([$][a-zA-Z]+))(([0-9]+)|([$][0-9]+))$/g; //增加正则判断单元格为字母+数字的格式：如 A1:B3

    var reg_cellRange = /^(((([a-zA-Z]+)|([$][a-zA-Z]+))(([0-9]+)|([$][0-9]+)))|((([a-zA-Z]+)|([$][a-zA-Z]+))))$/g; //增加正则判断单元格为字母+数字或字母的格式：如 A1:B3，A:A

    if (rangetxt.indexOf(":") == -1) {
      var row = parseInt(rangetxt.replace(/[^0-9]/g, "")) - 1;
      var col = ABCatNum(rangetxt.replace(/[^A-Za-z]/g, ""));

      if (!isNaN(row) && !isNaN(col) && rangetxt.toString().match(reg_cell)) {
        return true;
      } else if (!isNaN(row)) {
        return false;
      } else if (!isNaN(col)) {
        return false;
      } else {
        return false;
      }
    } else {
      reg_cellRange = /^(((([a-zA-Z]+)|([$][a-zA-Z]+))(([0-9]+)|([$][0-9]+)))|((([a-zA-Z]+)|([$][a-zA-Z]+)))|((([0-9]+)|([$][0-9]+s))))$/g;
      rangetxt = rangetxt.split(":");
      var row = [],
          col = [];
      row[0] = parseInt(rangetxt[0].replace(/[^0-9]/g, "")) - 1;
      row[1] = parseInt(rangetxt[1].replace(/[^0-9]/g, "")) - 1;

      if (row[0] > row[1]) {
        return false;
      }

      col[0] = ABCatNum(rangetxt[0].replace(/[^A-Za-z]/g, ""));
      col[1] = ABCatNum(rangetxt[1].replace(/[^A-Za-z]/g, ""));

      if (col[0] > col[1]) {
        return false;
      }

      if (rangetxt[0].toString().match(reg_cellRange) && rangetxt[1].toString().match(reg_cellRange)) {
        return true;
      } else {
        return false;
      }
    }
  };

  fromulaRef.isfreezonFuc = function (txt) {
    var row = txt.replace(/[^0-9]/g, "");
    var col = txt.replace(/[^A-Za-z]/g, "");
    var row$ = txt.substr(txt.indexOf(row) - 1, 1);
    var col$ = txt.substr(txt.indexOf(col) - 1, 1);
    var ret = [false, false];

    if (row$ == "$") {
      ret[0] = true;
    }

    if (col$ == "$") {
      ret[1] = true;
    }

    return ret;
  };

  fromulaRef.operator = '==|!=|<>|<=|>=|=|+|-|>|<|/|*|%|&|^';
  fromulaRef.error = {
    v: "#VALUE!",
    n: "#NAME?",
    na: "#N/A",
    r: "#REF!",
    d: "#DIV/0!",
    nm: "#NUM!",
    nl: "#NULL!",
    sp: "#SPILL!" //数组范围有其它值

  };
  fromulaRef.operatorjson = null;
  return fromulaRef;
}();

exports.fromulaRef = fromulaRef;

function isChinese(temp) {
  var re = /[^\u4e00-\u9fa5]/;
  var reg = /[\u3002|\uff1f|\uff01|\uff0c|\u3001|\uff1b|\uff1a|\u201c|\u201d|\u2018|\u2019|\uff08|\uff09|\u300a|\u300b|\u3008|\u3009|\u3010|\u3011|\u300e|\u300f|\u300c|\u300d|\ufe43|\ufe44|\u3014|\u3015|\u2026|\u2014|\uff5e|\ufe4f|\uffe5]/;
  if (reg.test(temp)) return true;
  if (re.test(temp)) return false;
  return true;
}

exports.isChinese = isChinese;

function isJapanese(temp) {
  var re = /[^\u0800-\u4e00]/;
  if (re.test(temp)) return false;
  return true;
}

exports.isJapanese = isJapanese;

function isKoera(chr) {
  if (chr > 0x3130 && chr < 0x318F || chr >= 0xAC00 && chr <= 0xD7A3) {
    return true;
  }

  return false;
}

exports.isKoera = isKoera;

function isContainMultiType(str) {
  var isUnicode = false;

  if (escape(str).indexOf("%u") > -1) {
    isUnicode = true;
  }

  var isNot = false;
  var reg = /[0-9a-z]/gi;

  if (reg.test(str)) {
    isNot = true;
  }

  var reEnSign = /[\x00-\xff]+/g;

  if (reEnSign.test(str)) {
    isNot = true;
  }

  if (isUnicode && isNot) {
    return true;
  }

  return false;
}

exports.isContainMultiType = isContainMultiType;

function getBinaryContent(path, options) {
  var promise, resolve, reject;
  var callback;

  if (!options) {
    options = {};
  } // taken from jQuery


  var createStandardXHR = function createStandardXHR() {
    try {
      return new window.XMLHttpRequest();
    } catch (e) {}
  };

  var createActiveXHR = function createActiveXHR() {
    try {
      return new window.ActiveXObject("Microsoft.XMLHTTP");
    } catch (e) {}
  }; // Create the request object


  var createXHR = typeof window !== "undefined" && window.ActiveXObject ?
  /* Microsoft failed to properly
  * implement the XMLHttpRequest in IE7 (can't request local files),
  * so we use the ActiveXObject when it is available
  * Additionally XMLHttpRequest can be disabled in IE7/IE8 so
  * we need a fallback.
  */
  function () {
    return createStandardXHR() || createActiveXHR();
  } : // For all other browsers, use the standard XMLHttpRequest object
  createStandardXHR; // backward compatible callback

  if (typeof options === "function") {
    callback = options;
    options = {};
  } else if (typeof options.callback === 'function') {
    // callback inside options object
    callback = options.callback;
  }

  resolve = function resolve(data) {
    callback(null, data);
  };

  reject = function reject(err) {
    callback(err, null);
  };

  try {
    var xhr = createXHR();
    xhr.open('GET', path, true); // recent browsers

    if ("responseType" in xhr) {
      xhr.responseType = "arraybuffer";
    } // older browser


    if (xhr.overrideMimeType) {
      xhr.overrideMimeType("text/plain; charset=x-user-defined");
    }

    xhr.onreadystatechange = function (event) {
      // use `xhr` and not `this`... thanks IE
      if (xhr.readyState === 4) {
        if (xhr.status === 200 || xhr.status === 0) {
          try {
            resolve(function (xhr) {
              // for xhr.responseText, the 0xFF mask is applied by JSZip
              return xhr.response || xhr.responseText;
            }(xhr));
          } catch (err) {
            reject(new Error(err));
          }
        } else {
          reject(new Error("Ajax error for " + path + " : " + this.status + " " + this.statusText));
        }
      }
    };

    if (options.progress) {
      xhr.onprogress = function (e) {
        options.progress({
          path: path,
          originalEvent: e,
          percent: e.loaded / e.total * 100,
          loaded: e.loaded,
          total: e.total
        });
      };
    }

    xhr.send();
  } catch (e) {
    reject(new Error(e), null);
  } // returns a promise or undefined depending on whether a callback was
  // provided


  return promise;
}

exports.getBinaryContent = getBinaryContent;
/**
 * multi sequence conversion
 * example:
 *  1、E14 -> 13_4
 *  2、E14 J14 O14 T14 Y14 AD14 AI14 AN14 AS14 AX14 ->
 *     ['13_4', '13_9','13_14', '13_19', '13_24', '13_3', '13_8',  '13_13', '13_18', '13_23']
 *  3、E46:E47 -> ['45_4',  '46_4']
 *
 * @param {string} sqref - before sequence
 * @returns {string[]}
 */

function getMultiSequenceToNum(sqref) {
  if (!sqref || (sqref === null || sqref === void 0 ? void 0 : sqref.length) <= 0) return [];
  sqref = sqref.toUpperCase();
  var sqrefRawArr = sqref.split(" ");
  var sqrefArr = sqrefRawArr.filter(function (e) {
    return e && e.trim();
  });
  var sqrefLastArr = getSqrefRawArrFormat(sqrefArr);
  var resArr = [];

  for (var i = 0; i < sqrefLastArr.length; i++) {
    var _res = getSingleSequenceToNum(sqrefLastArr[i]);

    if (_res) resArr.push(_res);
  }

  return resArr;
}

exports.getMultiSequenceToNum = getMultiSequenceToNum;
/**
 * get region sequence
 * example:
 *  1、[A1:C2'] -> ['A1', 'A2', 'B1', 'B2', 'C1', 'C2']
 *
 * @param {string[]} arr - formats arr
 * @returns {string[]} - after arr
 */

function getRegionSequence(arr) {
  var _a, _b;

  var formatArr = [];
  var regEn = new RegExp(/[A-Z]+|[0-9]+/g);
  var startArr = (_a = arr[0]) === null || _a === void 0 ? void 0 : _a.match(regEn);
  var lastArr = (_b = arr[1]) === null || _b === void 0 ? void 0 : _b.match(regEn);
  var columnMax = Math.max.apply(Math, [ABCatNum(startArr[0]), ABCatNum(lastArr[0])]);
  var columnMin = Math.min.apply(Math, [ABCatNum(startArr[0]), ABCatNum(lastArr[0])]);
  var rowMax = Math.max.apply(Math, [parseInt(startArr[1]), parseInt(lastArr[1])]);
  var rowMin = Math.min.apply(Math, [parseInt(startArr[1]), parseInt(lastArr[1])]);

  for (var i = columnMin; i <= columnMax; i++) {
    for (var j = rowMin; j <= rowMax; j++) {
      formatArr.push("" + chatatABC(i) + j);
    }
  }

  return formatArr;
}

exports.getRegionSequence = getRegionSequence;
/**
 * unified processing of conversion formats
 * example:
 *  1、['E38', 'A1:C2'] -> ['E38', 'A1', 'A2', 'B1', 'B2', 'C1', 'C2']
 *
 * @param {string[]} arr - formats arr
 * @returns {string[]} - after arr
 */

function getSqrefRawArrFormat(arr) {
  arr === null || arr === void 0 ? void 0 : arr.map(function (el) {
    if (el.includes(":")) {
      var tempArr = el.split(":");

      if ((tempArr === null || tempArr === void 0 ? void 0 : tempArr.length) === 2) {
        arr = arr.concat(getRegionSequence(tempArr));
        arr.splice(arr.indexOf(el), 1);
      }
    }
  });
  var resultArr = arr.filter(function (value, index, array) {
    return array.indexOf(value) === index;
  });
  return resultArr;
}

exports.getSqrefRawArrFormat = getSqrefRawArrFormat;
/**
 * single sequence to number
 * example:
 *  1、A1 -> 0_0
 *  2、ES14 -> 13_4
 *
 * @param {string} sqref - before sequence
 * @returns {string} - after sequence
 */

function getSingleSequenceToNum(sqref) {
  var sqrefArray = sqref.match(/[A-Z]+|[0-9]+/g);
  var sqrefLen = sqrefArray.length;
  var regEn = new RegExp("^[A-Z]+$");
  var ret = "";

  for (var i = sqrefLen - 1; i >= 0; i--) {
    var cur = sqrefArray[i];

    if (regEn.test(cur)) {
      ret += ABCatNum(cur) + "_";
    } else {
      ret += parseInt(cur) - 1 + "_";
    }
  }

  return ret.substring(0, ret.length - 1);
}

exports.getSingleSequenceToNum = getSingleSequenceToNum;
/**
 * R1C1 to Sequence
 * example: sheet2!R1C1 => sheet!A1
 *
 * @param {string} value - R1C1 value
 * @returns
 */

function getTransR1C1ToSequence(value) {
  if (!value && (value === null || value === void 0 ? void 0 : value.length) <= 0) return "";
  var len = value.length;
  var index = value.lastIndexOf("!");
  var valueArr = [value.slice(0, index), value.slice(index + 1, len)];
  var repStr = valueArr[1] || "";
  var indexR = repStr.indexOf("R");
  var indexC = repStr.indexOf("C");
  var row = Number(repStr.slice(indexR + 1, indexC));
  var column = chatatABC(Number(repStr.slice(indexC + 1, repStr === null || repStr === void 0 ? void 0 : repStr.length)) - 1);
  return valueArr[0] + "!" + column + row;
}

exports.getTransR1C1ToSequence = getTransR1C1ToSequence;
/**
 * strip x14 format data
 *
 * @param {string} value
 * @returns {Object} - { formula, sqref }
 */

function getPeelOffX14(value) {
  var _a;

  if (!value || (value === null || value === void 0 ? void 0 : value.length) <= 0) return {}; // formula

  var formulaReg = new RegExp("</x14:formula[^]>", "g");
  var lastIndex = (_a = value.match(formulaReg)) === null || _a === void 0 ? void 0 : _a.length;
  var lastValue = "</x14:formula" + lastIndex + ">";
  var lastValueEnd = value.indexOf(lastValue);
  var formulaValue = value.substring(0, lastValueEnd + lastValue.length);
  formulaValue = formulaValue.replace(/<xm:f>/g, "").replace(/<\/xm:f>/g, "").replace(/x14:/g, "").replace(/\/x14:/g, "");
  var formula = formulaValue; // sqref

  var xmSqrefLen = "<xm:sqref>".length;
  var sqrefStart = value.indexOf("<xm:sqref>");
  var sqrefEnd = value.indexOf("</xm:sqref>");
  var sqref = value.substring(sqrefStart + xmSqrefLen, sqrefEnd);
  return {
    formula: formula,
    sqref: sqref
  };
}

exports.getPeelOffX14 = getPeelOffX14;
/**
 * get the value in the formula
 *
 * @param {string} value - extracted value
 * @returns {string[]}
 */

function getMultiFormulaValue(value) {
  var _a, _b;

  if (!value || (value === null || value === void 0 ? void 0 : value.length) <= 0) return [];
  var lenReg = new RegExp("formula", "g");
  var len = (((_a = value.match(lenReg)) === null || _a === void 0 ? void 0 : _a.length) || 0) / 2;
  if (len === 0) return [];
  var retArr = [];

  for (var i = 1; i <= len; i++) {
    var startLen = (_b = "<formula" + i + ">") === null || _b === void 0 ? void 0 : _b.length;
    var start = value.indexOf("<formula" + i + ">");
    var end = value.indexOf("</formula" + i + ">");

    var _value = value.substring(start + startLen, end);

    retArr.push(escapeCharacter(_value.replace(/&quot;|^\"|\"$/g, "")));
  }

  return retArr;
}

exports.getMultiFormulaValue = getMultiFormulaValue;
/**
 * 检查某一单元格是否在指定区域内
 * @param {Number} r 单元格所在行
 * @param {Number} c 单元格所在列
 * @param {Array} specifiedRange 指定区域
 */

function checkCellWithinSpecifiedRange(r, c, specifiedRange) {
  var within = false;

  if (!specifiedRange || specifiedRange.length === 0) {
    return false;
  }

  for (var _i = 0, specifiedRange_1 = specifiedRange; _i < specifiedRange_1.length; _i++) {
    var item = specifiedRange_1[_i];
    var r1 = item.row[0],
        r2 = item.row[1];
    var c1 = item.column[0],
        c2 = item.column[1];

    if (r >= r1 && r <= r2 && c >= c1 && c <= c2) {
      within = true;
      break;
    }
  }

  return within;
}

exports.checkCellWithinSpecifiedRange = checkCellWithinSpecifiedRange;

},{"./constant":19}],22:[function(require,module,exports){
"use strict";

var __importDefault = void 0 && (void 0).__importDefault || function (mod) {
  return mod && mod.__esModule ? mod : {
    "default": mod
  };
};

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.LuckyExcel = void 0;

var LuckyFile_1 = require("./ToLuckySheet/LuckyFile");

var ExcelFile_1 = require("./toExcel/ExcelFile"); // import {SecurityDoor,Car} from './content';


var HandleZip_1 = require("./HandleZip");

var xlsx_js_style_1 = __importDefault(require("xlsx-js-style")); // //demo
// function demoHandler(){
//     let upload = document.getElementById("Luckyexcel-demo-file");
//     let selectADemo = document.getElementById("Luckyexcel-select-demo");
//     let downlodDemo = document.getElementById("Luckyexcel-downlod-file");
//     let mask = document.getElementById("lucky-mask-demo");
//     if(upload){
//         window.onload = () => {
//             upload.addEventListener("change", function(evt){
//                 var files:FileList = (evt.target as any).files;
//                 if(files==null || files.length==0){
//                     alert("No files wait for import");
//                     return;
//                 }
//                 let name = files[0].name;
//                 let suffixArr = name.split("."), suffix = suffixArr[suffixArr.length-1];
//                 if(suffix!="xlsx"){
//                     alert("Currently only supports the import of xlsx files");
//                     return;
//                 }
//                 LuckyExcel.transformExcelToLucky(files[0], function(exportJson:any, luckysheetfile:string){
//                     if(exportJson.sheets==null || exportJson.sheets.length==0){
//                         alert("Failed to read the content of the excel file, currently does not support xls files!");
//                         return;
//                     }
//                     console.log(exportJson, luckysheetfile);
//                     window.luckysheet.destroy();
//                     window.luckysheet.create({
//                         container: 'luckysheet', //luckysheet is the container id
//                         showinfobar:false,
//                         data:exportJson.sheets,
//                         title:exportJson.info.name,
//                         userInfo:exportJson.info.name.creator
//                     });
//                 });
//             });
//             selectADemo.addEventListener("change", function(evt){
//                 var obj:any = selectADemo;
//                 var index = obj.selectedIndex;
//                 var value = obj.options[index].value;
//                 var name = obj.options[index].innerHTML;
//                 if(value==""){
//                     return;
//                 }
//                 mask.style.display = "flex";
//                 LuckyExcel.transformExcelToLuckyByUrl(value, name, function(exportJson:any, luckysheetfile:string){
//                     if(exportJson.sheets==null || exportJson.sheets.length==0){
//                         alert("Failed to read the content of the excel file, currently does not support xls files!");
//                         return;
//                     }
//                     console.log(exportJson, luckysheetfile);
//                     mask.style.display = "none";
//                     window.luckysheet.destroy();
//                     window.luckysheet.create({
//                         container: 'luckysheet', //luckysheet is the container id
//                         showinfobar:false,
//                         data:exportJson.sheets,
//                         title:exportJson.info.name,
//                         userInfo:exportJson.info.name.creator
//                     });
//                 });
//             });
//             downlodDemo.addEventListener("click", function(evt){
//                 var obj:any = selectADemo;
//                 var index = obj.selectedIndex;
//                 var value = obj.options[index].value;
//                 if(value.length==0){
//                     alert("Please select a demo file");
//                     return;
//                 }
//                 var elemIF:any = document.getElementById("Lucky-download-frame");
//                 if(elemIF==null){
//                     elemIF = document.createElement("iframe");
//                     elemIF.style.display = "none";
//                     elemIF.id = "Lucky-download-frame";
//                     document.body.appendChild(elemIF);
//                 }
//                 elemIF.src = value;
//                 // elemIF.parentNode.removeChild(elemIF);
//             });
//         }
//     }
// }
// demoHandler();
// api


var LuckyExcel =
/** @class */
function () {
  function LuckyExcel() {}

  LuckyExcel.transformExcelToLucky = function (excelFile, callback, errorHandler) {
    var handleZip = new HandleZip_1.HandleZip(excelFile);
    handleZip.unzipFile(function (files) {
      var luckyFile = new LuckyFile_1.LuckyFile(files, excelFile.name);
      var luckysheetfile = luckyFile.Parse();
      var exportJson = JSON.parse(luckysheetfile);

      if (callback != undefined) {
        callback(exportJson, luckysheetfile);
      }
    }, function (err) {
      if (errorHandler) {
        errorHandler(err);
      } else {
        console.error(err);
      }
    });
  };

  LuckyExcel.transformExcelToLuckyByUrl = function (url, name, callBack, errorHandler) {
    var handleZip = new HandleZip_1.HandleZip();
    handleZip.unzipFileByUrl(url, function (files) {
      var luckyFile = new LuckyFile_1.LuckyFile(files, name);
      var luckysheetfile = luckyFile.Parse();
      var exportJson = JSON.parse(luckysheetfile);

      if (callBack != undefined) {
        callBack(exportJson, luckysheetfile);
      }
    }, function (err) {
      if (errorHandler) {
        errorHandler(err);
      } else {
        console.error(err);
      }
    });
  };

  LuckyExcel.readExcel = function (data, callBack, errorHandler) {
    var workbook = xlsx_js_style_1["default"].read(data, {
      bookDeps: true,
      cellStyles: true,
      raw: true,
      cellNF: true
    });
  };

  LuckyExcel.transformLuckyToExcel = function (luckysheetJson, callBack, errorHandler) {
    try {
      var excelFile = new ExcelFile_1.ExcelFile(luckysheetJson);
      excelFile["export"]();
      callBack === null || callBack === void 0 ? void 0 : callBack(excelFile);
    } catch (e) {
      errorHandler === null || errorHandler === void 0 ? void 0 : errorHandler(e);
    }
  };

  return LuckyExcel;
}();

exports.LuckyExcel = LuckyExcel;

},{"./HandleZip":12,"./ToLuckySheet/LuckyFile":15,"./toExcel/ExcelFile":25,"xlsx-js-style":11}],23:[function(require,module,exports){
"use strict";

var main_1 = require("./main");

module.exports = main_1.LuckyExcel;

},{"./main":22}],24:[function(require,module,exports){
"use strict";

var __extends = void 0 && (void 0).__extends || function () {
  var _extendStatics = function extendStatics(d, b) {
    _extendStatics = Object.setPrototypeOf || {
      __proto__: []
    } instanceof Array && function (d, b) {
      d.__proto__ = b;
    } || function (d, b) {
      for (var p in b) {
        if (b.hasOwnProperty(p)) d[p] = b[p];
      }
    };

    return _extendStatics(d, b);
  };

  return function (d, b) {
    _extendStatics(d, b);

    function __() {
      this.constructor = d;
    }

    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
  };
}();

var __importDefault = void 0 && (void 0).__importDefault || function (mod) {
  return mod && mod.__esModule ? mod : {
    "default": mod
  };
};

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.BorderInfo = exports.BorderInfoBase = void 0;

var xlsx_js_style_1 = __importDefault(require("xlsx-js-style"));

var constant_1 = require("../common/constant");

var method_1 = require("../common/method");

var BorderInfoBase =
/** @class */
function () {
  function BorderInfoBase() {}

  return BorderInfoBase;
}();

exports.BorderInfoBase = BorderInfoBase;

var BorderInfo =
/** @class */
function (_super) {
  __extends(BorderInfo, _super);

  function BorderInfo(data) {
    var _this = _super.call(this) || this;

    _this.data = {};
    data === null || data === void 0 ? void 0 : data.forEach(function (item) {
      var _a;

      var rangeType = item.rangeType; // 旧版excel导入时生成的borderinfo

      if (rangeType === 'cell') {
        var value_1 = item.value;
        var cellKey_1 = xlsx_js_style_1["default"].utils.encode_cell({
          c: value_1.col_index,
          r: value_1.row_index
        });
        _this.data[cellKey_1] = {};
        ['t', 'b', 'l', 'r'].forEach(function (p) {
          var _a;

          var borderStyle = value_1[p];

          if (borderStyle && constant_1.excelBorderPositions[p]) {
            _this.data[cellKey_1][constant_1.excelBorderPositions[p]] = {
              style: constant_1.excelBorderStyles[borderStyle.style] || 'thin',
              color: {
                rgb: ((_a = method_1.rgbToHex(borderStyle.color)) === null || _a === void 0 ? void 0 : _a.replace('#', '')) || '000000'
              }
            };
          }
        });
      } // 新版luckysheet操作生成的borderinfo


      if (rangeType === 'range') {
        var color = item.color,
            style = item.style,
            _b = item.range,
            range = _b === void 0 ? [] : _b,
            borderType = item.borderType;
        var borderStyle = {
          style: constant_1.excelBorderStyles[style] || 'thin',
          color: {
            rgb: ((_a = method_1.rgbToHex(color)) === null || _a === void 0 ? void 0 : _a.replace('#', '')) || '000000'
          }
        };

        for (var _i = 0, range_1 = range; _i < range_1.length; _i++) {
          var rangeItem = range_1[_i];
          var _c = rangeItem.row,
              rangeStartRow = _c[0],
              rangeEndRow = _c[1];
          var _d = rangeItem.column,
              rangeStartCol = _d[0],
              rangeEndCol = _d[1];

          for (var row = rangeStartRow; row <= rangeEndRow; row++) {
            for (var col = rangeStartCol; col <= rangeEndCol; col++) {
              var cellKey = xlsx_js_style_1["default"].utils.encode_cell({
                c: col,
                r: row
              });
              _this.data[cellKey] = {}; // 检查上下左右边的情况，按需添加边框

              if (borderType === 'border-none') {
                _this.data[cellKey] = null;
              } else if (borderType === 'border-all') {
                _this.data[cellKey].top = borderStyle;
                _this.data[cellKey].bottom = borderStyle;
                _this.data[cellKey].left = borderStyle;
                _this.data[cellKey].right = borderStyle;
              } else {
                var isOnTop = isOnTopBorder({
                  row: row,
                  column: col
                }, rangeItem.row, rangeItem.column);
                var isOnBottom = isOnBottomBorder({
                  row: row,
                  column: col
                }, rangeItem.row, rangeItem.column);
                var isOnRight = isOnRightBorder({
                  row: row,
                  column: col
                }, rangeItem.row, rangeItem.column);
                var isOnLeft = isOnLeftBorder({
                  row: row,
                  column: col
                }, rangeItem.row, rangeItem.column);

                if (['border-top', 'border-outside'].includes(borderType) && isOnTop) {
                  _this.data[cellKey].top = borderStyle;
                }

                if (['border-bottom', 'border-outside'].includes(borderType) && isOnBottom) {
                  _this.data[cellKey].bottom = borderStyle;
                }

                if (['border-right', 'border-outside'].includes(borderType) && isOnRight) {
                  _this.data[cellKey].right = borderStyle;
                }

                if (['border-left', 'border-outside'].includes(borderType) && isOnLeft) {
                  _this.data[cellKey].left = borderStyle;
                }

                if (borderType === 'border-inside') {
                  !isOnTop && (_this.data[cellKey].top = borderStyle);
                  !isOnBottom && (_this.data[cellKey].bottom = borderStyle);
                  !isOnRight && (_this.data[cellKey].right = borderStyle);
                  !isOnLeft && (_this.data[cellKey].left = borderStyle);
                }

                if (borderType === 'border-horizontal') {
                  !isOnTop && (_this.data[cellKey].top = borderStyle);
                  !isOnBottom && (_this.data[cellKey].bottom = borderStyle);
                }

                if (borderType === 'border-vertical') {
                  !isOnRight && (_this.data[cellKey].right = borderStyle);
                  !isOnLeft && (_this.data[cellKey].left = borderStyle);
                }
              }
            }
          }
        }
      }
    });
    return _this;
  }

  BorderInfo.prototype.get = function (key) {
    return this.data[key];
  };

  return BorderInfo;
}(BorderInfoBase);

exports.BorderInfo = BorderInfo;

function isOnTopBorder(cell, rowRange, columnRange) {
  var cellRow = cell.row,
      cellCol = cell.column;
  var rangeStartRow = rowRange[0],
      rangeEndRow = rowRange[1];
  var rangeStartCol = columnRange[0],
      rangeEndCol = columnRange[1];
  return cellRow === rangeStartRow;
}

function isOnBottomBorder(cell, rowRange, columnRange) {
  var cellRow = cell.row,
      cellCol = cell.column;
  var rangeStartRow = rowRange[0],
      rangeEndRow = rowRange[1];
  var rangeStartCol = columnRange[0],
      rangeEndCol = columnRange[1];
  return cellRow === rangeEndRow;
}

function isOnRightBorder(cell, rowRange, columnRange) {
  var cellRow = cell.row,
      cellCol = cell.column;
  var rangeStartRow = rowRange[0],
      rangeEndRow = rowRange[1];
  var rangeStartCol = columnRange[0],
      rangeEndCol = columnRange[1];
  return cellCol === rangeEndCol;
}

function isOnLeftBorder(cell, rowRange, columnRange) {
  var cellRow = cell.row,
      cellCol = cell.column;
  var rangeStartRow = rowRange[0],
      rangeEndRow = rowRange[1];
  var rangeStartCol = columnRange[0],
      rangeEndCol = columnRange[1];
  return cellCol === rangeStartCol;
}

},{"../common/constant":19,"../common/method":21,"xlsx-js-style":11}],25:[function(require,module,exports){
"use strict";

var __extends = void 0 && (void 0).__extends || function () {
  var _extendStatics = function extendStatics(d, b) {
    _extendStatics = Object.setPrototypeOf || {
      __proto__: []
    } instanceof Array && function (d, b) {
      d.__proto__ = b;
    } || function (d, b) {
      for (var p in b) {
        if (b.hasOwnProperty(p)) d[p] = b[p];
      }
    };

    return _extendStatics(d, b);
  };

  return function (d, b) {
    _extendStatics(d, b);

    function __() {
      this.constructor = d;
    }

    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
  };
}();

var __importDefault = void 0 && (void 0).__importDefault || function (mod) {
  return mod && mod.__esModule ? mod : {
    "default": mod
  };
};

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.ExcelFile = exports.ExcelFileBase = void 0;

var xlsx_js_style_1 = __importDefault(require("xlsx-js-style"));

var Worksheet_1 = require("./Worksheet");

var ExcelFileBase =
/** @class */
function () {
  function ExcelFileBase() {}

  return ExcelFileBase;
}();

exports.ExcelFileBase = ExcelFileBase;

var ExcelFile =
/** @class */
function (_super) {
  __extends(ExcelFile, _super);
  /**
   * @param luckysheetJson luckysheet.toJson() 返回数据
   * @param fileName
   */


  function ExcelFile(luckysheetJson, fileName) {
    var _this = _super.call(this) || this;

    var title = luckysheetJson.title,
        data = luckysheetJson.data;
    _this.fileName = fileName || luckysheetJson.title;
    _this.sheets = data === null || data === void 0 ? void 0 : data.map(function (item) {
      return new Worksheet_1.WorkSheet(item);
    });
    return _this;
  }

  ExcelFile.prototype["export"] = function () {
    var _a;

    var wb = xlsx_js_style_1["default"].utils.book_new();
    (_a = this.sheets) === null || _a === void 0 ? void 0 : _a.forEach(function (sheet) {
      xlsx_js_style_1["default"].utils.book_append_sheet(wb, sheet.toData(), sheet.name);
    });
    xlsx_js_style_1["default"].writeFile(wb, this.fileName + ".xlsx");
  };

  return ExcelFile;
}(ExcelFileBase);

exports.ExcelFile = ExcelFile;

},{"./Worksheet":27,"xlsx-js-style":11}],26:[function(require,module,exports){
"use strict";

var __extends = void 0 && (void 0).__extends || function () {
  var _extendStatics = function extendStatics(d, b) {
    _extendStatics = Object.setPrototypeOf || {
      __proto__: []
    } instanceof Array && function (d, b) {
      d.__proto__ = b;
    } || function (d, b) {
      for (var p in b) {
        if (b.hasOwnProperty(p)) d[p] = b[p];
      }
    };

    return _extendStatics(d, b);
  };

  return function (d, b) {
    _extendStatics(d, b);

    function __() {
      this.constructor = d;
    }

    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
  };
}();

var __importDefault = void 0 && (void 0).__importDefault || function (mod) {
  return mod && mod.__esModule ? mod : {
    "default": mod
  };
};

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.WorkCell = exports.WorkCellBase = void 0;

var xlsx_js_style_1 = __importDefault(require("xlsx-js-style"));

var constant_1 = require("../common/constant");

var method_1 = require("../common/method");

var WorkCellBase =
/** @class */
function () {
  function WorkCellBase() {}

  return WorkCellBase;
}();

exports.WorkCellBase = WorkCellBase;

var WorkCell =
/** @class */
function (_super) {
  __extends(WorkCell, _super);

  function WorkCell(data) {
    var _a, _b;

    var _this = _super.call(this) || this;

    var r = data.r,
        c = data.c;

    var _c = data.v || {},
        ct = _c.ct,
        v = _c.v,
        m = _c.m,
        f = _c.f,
        vt = _c.vt,
        ht = _c.ht,
        tb = _c.tb,
        tr = _c.tr,
        bg = _c.bg,
        fc = _c.fc,
        bl = _c.bl,
        it = _c.it,
        cl = _c.cl,
        un = _c.un,
        fs = _c.fs,
        ff = _c.ff;

    _this.key = xlsx_js_style_1["default"].utils.encode_cell({
      c: c,
      r: r
    });
    _this.data = {
      v: '',
      t: 's',
      s: {}
    };

    if (v !== undefined && ct !== undefined) {
      _this.data.v = v;
      _this.data.t = ct.t; // 数字

      if ((ct === null || ct === void 0 ? void 0 : ct.t) === 'n') {
        _this.data.t = 'n';
        _this.data.z = ct.fa;
        f && (_this.data.f = f);
      } // 日期


      if ((ct === null || ct === void 0 ? void 0 : ct.t) === 'd') {
        // 如果类型规定为d 解析日期不对
        _this.data.t = 'n';
        _this.data.z = 'm/d/yy';
        _this.data.s = {
          numFmt: 'm/d/yy'
        };
      } // 字符串


      if ((ct === null || ct === void 0 ? void 0 : ct.t) === 'g') {
        _this.data.t = 's';
        _this.data.w = ct.fa;
      }
    } // 对齐方式 换行 文字方向


    if ([vt, ht, tb, tr].some(function (item) {
      return item !== undefined;
    })) {
      _this.data.s.alignment = {};
      vt !== undefined && (_this.data.s.alignment.vertical = constant_1.verticalMap[vt]);
      ht !== undefined && (_this.data.s.alignment.horizontal = constant_1.horizontalMap[ht]);
      tb !== undefined && (_this.data.s.alignment.wrapText = constant_1.wrapTextMap[tb]);
      tr !== undefined && (_this.data.s.alignment.textRotation = constant_1.textRotationMap[tr]);
    } // 背景色


    if (bg) {
      _this.data.s.fill = {
        fgColor: {
          rgb: ((_a = method_1.rgbToHex(bg)) === null || _a === void 0 ? void 0 : _a.replace('#', '')) || 'ffffff'
        }
      };
    } // 文本样式


    if ([fc, bl, it, cl, un, fs].some(function (item) {
      return item !== undefined;
    })) {
      _this.data.s.font = {};
      fc !== undefined && (_this.data.s.font.color = {
        rgb: ((_b = method_1.rgbToHex(fc)) === null || _b === void 0 ? void 0 : _b.replace('#', '')) || '000000'
      });
      bl !== undefined && (_this.data.s.font.bold = !!bl);
      bl !== undefined && (_this.data.s.font.italic = !!it);
      cl !== undefined && (_this.data.s.font.strike = !!cl);
      un !== undefined && (_this.data.s.font.underline = !!un);
      fs !== undefined && (_this.data.s.font.sz = fs); // 字体种类可能缺失造成不匹配 暂时去掉
      // ff !== undefined && (this.data.s.font.name = ff)
    }

    return _this;
  }

  WorkCell.prototype.toData = function () {
    var data = this.data; // const borderInfo = this.border.get(this.key)
    // if (borderInfo && Object.keys(borderInfo).length !== 0) {
    //   data.s = {border: {...borderInfo}}
    // }

    return data;
  };

  return WorkCell;
}(WorkCellBase);

exports.WorkCell = WorkCell;

},{"../common/constant":19,"../common/method":21,"xlsx-js-style":11}],27:[function(require,module,exports){
"use strict";

var __extends = void 0 && (void 0).__extends || function () {
  var _extendStatics = function extendStatics(d, b) {
    _extendStatics = Object.setPrototypeOf || {
      __proto__: []
    } instanceof Array && function (d, b) {
      d.__proto__ = b;
    } || function (d, b) {
      for (var p in b) {
        if (b.hasOwnProperty(p)) d[p] = b[p];
      }
    };

    return _extendStatics(d, b);
  };

  return function (d, b) {
    _extendStatics(d, b);

    function __() {
      this.constructor = d;
    }

    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
  };
}();

var __assign = void 0 && (void 0).__assign || function () {
  __assign = Object.assign || function (t) {
    for (var s, i = 1, n = arguments.length; i < n; i++) {
      s = arguments[i];

      for (var p in s) {
        if (Object.prototype.hasOwnProperty.call(s, p)) t[p] = s[p];
      }
    }

    return t;
  };

  return __assign.apply(this, arguments);
};

var __importDefault = void 0 && (void 0).__importDefault || function (mod) {
  return mod && mod.__esModule ? mod : {
    "default": mod
  };
};

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.WorkSheet = exports.WorkSheetBase = void 0;

var xlsx_js_style_1 = __importDefault(require("xlsx-js-style"));

var Workcell_1 = require("./Workcell");

var BorderInfo_1 = require("./BorderInfo");

var WorkSheetBase =
/** @class */
function () {
  function WorkSheetBase() {}

  return WorkSheetBase;
}();

exports.WorkSheetBase = WorkSheetBase;

var WorkSheet =
/** @class */
function (_super) {
  __extends(WorkSheet, _super);

  function WorkSheet(sheetData) {
    var _this = _super.call(this) || this;

    var config = sheetData.config,
        column = sheetData.column,
        row = sheetData.row,
        celldata = sheetData.celldata,
        name = sheetData.name,
        data = sheetData.data;

    var _a = config || {},
        columnlen = _a.columnlen,
        rowlen = _a.rowlen,
        merge = _a.merge,
        borderInfo = _a.borderInfo;

    _this.data = {};
    _this.border = {};
    _this.name = name; // 解析borderInfo

    var border = new BorderInfo_1.BorderInfo(borderInfo);

    for (var _i = 0, _b = Object.entries(border.data); _i < _b.length; _i++) {
      var _c = _b[_i],
          key = _c[0],
          borderValue = _c[1];
      _this.data[key] = {};
      _this.border[key] = borderValue;
    } // 解析单元格内容
    // const rowLen = data.length
    // const columnLen = data?.[0]?.length || 0
    // for(let row = 0; row <= rowLen; row++){
    //   for(let col = 0; col <= columnLen; col++){
    //     const cellValue = data[row][col] || {r: row, c: col}
    //     const cell = new WorkCell(cellValue, border)
    //     this.data[cell.key] = cell.toData()
    //   }
    // }


    celldata === null || celldata === void 0 ? void 0 : celldata.forEach(function (data) {
      var _a;

      var cell = new Workcell_1.WorkCell(data);

      if (_this.border[cell.key]) {
        _this.data[cell.key] = __assign(__assign({}, cell.toData() || {}), {
          s: __assign(__assign({}, ((_a = cell.toData()) === null || _a === void 0 ? void 0 : _a.s) || {}), {
            border: _this.border[cell.key] || {}
          })
        });
      } else {
        _this.data[cell.key] = cell.toData();
      }
    }); // 规定数据范围

    var endCellRange = xlsx_js_style_1["default"].utils.encode_cell({
      c: column - 1,
      r: row - 1
    });
    _this.ref = "A1:" + endCellRange; // 规定行列宽高

    _this.cols = [];

    if (columnlen) {
      Object.keys(columnlen).forEach(function (index) {
        _this.cols[Number(index)] = {
          wpx: Math.round(parseFloat(columnlen[index]) * 0.75)
        };
      });
    }

    _this.rows = [];

    if (rowlen) {
      Object.keys(rowlen).forEach(function (index) {
        _this.rows[Number(index)] = {
          hpx: Math.round(parseFloat(rowlen[index]) * 0.75)
        };
      });
    } // 合并单元格范围


    _this.merges = [];

    if (merge) {
      Object.keys(merge).forEach(function (key) {
        // rs cs 为所占行数
        var _a = merge[key],
            r = _a.r,
            c = _a.c,
            rs = _a.rs,
            cs = _a.cs; // s为合并单元格开始行列  e为结束

        var mergeValue = {
          s: {
            r: r,
            c: c
          },
          e: {
            r: r + (rs - 1),
            c: c + (cs - 1)
          }
        };

        _this.merges.push(mergeValue);
      });
    }

    return _this;
  }

  WorkSheet.prototype.toData = function () {
    var result = Object.assign({}, this.data);
    result['!ref'] = this.ref;
    result['!cols'] = this.cols;
    result['!rows'] = this.rows;
    result['!merges'] = this.merges;
    return result;
  };

  return WorkSheet;
}(WorkSheetBase);

exports.WorkSheet = WorkSheet;

},{"./BorderInfo":24,"./Workcell":26,"xlsx-js-style":11}]},{},[23])(23)
});

//# sourceMappingURL=luckyexcel.umd.js.map
