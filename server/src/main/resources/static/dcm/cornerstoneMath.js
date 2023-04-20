/*! cornerstone-math - 0.1.6 - 2017-06-09 | (c) 2017 Chris Hafey | https://github.com/chafey/cornerstoneTools */
(function webpackUniversalModuleDefinition(root, factory) {
	if(typeof exports === 'object' && typeof module === 'object')
		module.exports = factory();
	else if(typeof define === 'function' && define.amd)
		define("cornerstoneMath", [], factory);
	else if(typeof exports === 'object')
		exports["cornerstoneMath"] = factory();
	else
		root["cornerstoneMath"] = factory();
})(this, function() {
return /******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// identity function for calling harmony imports with the correct context
/******/ 	__webpack_require__.i = function(value) { return value; };
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, {
/******/ 				configurable: false,
/******/ 				enumerable: true,
/******/ 				get: getter
/******/ 			});
/******/ 		}
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = 9);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
// Based on THREE.JS
function clamp(x, a, b) {
  return x < a ? a : x > b ? b : x;
}

function degToRad(degrees) {
  var degreeToRadiansFactor = Math.PI / 180;

  return degrees * degreeToRadiansFactor;
}

function radToDeg(radians) {
  var radianToDegreesFactor = 180 / Math.PI;

  return radians * radianToDegreesFactor;
}

// Returns sign of number
function sign(x) {
  return typeof x === 'number' ? x ? x < 0 ? -1 : 1 : x === x ? 0 : NaN : NaN;
}

exports.clamp = clamp;
exports.degToRad = degToRad;
exports.radToDeg = radToDeg;
exports.sign = sign;

/***/ }),
/* 1 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _quaternion = __webpack_require__(3);

var _quaternion2 = _interopRequireDefault(_quaternion);

var _math = __webpack_require__(0);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

// Based on THREE.JS
var Vector3 = function Vector3(x, y, z) {

  this.x = x || 0;
  this.y = y || 0;
  this.z = z || 0;
};

Vector3.prototype = {

  constructor: Vector3,

  set: function set(x, y, z) {

    this.x = x;
    this.y = y;
    this.z = z;

    return this;
  },
  setX: function setX(x) {

    this.x = x;

    return this;
  },
  setY: function setY(y) {

    this.y = y;

    return this;
  },
  setZ: function setZ(z) {

    this.z = z;

    return this;
  },
  setComponent: function setComponent(index, value) {

    switch (index) {

      case 0:
        this.x = value;break;
      case 1:
        this.y = value;break;
      case 2:
        this.z = value;break;
      default:
        throw new Error('index is out of range: ' + index);

    }
  },
  getComponent: function getComponent(index) {

    switch (index) {

      case 0:
        return this.x;
      case 1:
        return this.y;
      case 2:
        return this.z;
      default:
        throw new Error('index is out of range: ' + index);

    }
  },
  copy: function copy(v) {

    this.x = v.x;
    this.y = v.y;
    this.z = v.z;

    return this;
  },
  add: function add(v, w) {

    if (w !== undefined) {

      console.warn('DEPRECATED: Vector3\'s .add() now only accepts one argument. Use .addVectors( a, b ) instead.');

      return this.addVectors(v, w);
    }

    this.x += v.x;
    this.y += v.y;
    this.z += v.z;

    return this;
  },
  addScalar: function addScalar(s) {

    this.x += s;
    this.y += s;
    this.z += s;

    return this;
  },
  addVectors: function addVectors(a, b) {

    this.x = a.x + b.x;
    this.y = a.y + b.y;
    this.z = a.z + b.z;

    return this;
  },
  sub: function sub(v, w) {

    if (w !== undefined) {

      console.warn('DEPRECATED: Vector3\'s .sub() now only accepts one argument. Use .subVectors( a, b ) instead.');

      return this.subVectors(v, w);
    }

    this.x -= v.x;
    this.y -= v.y;
    this.z -= v.z;

    return this;
  },
  subVectors: function subVectors(a, b) {

    this.x = a.x - b.x;
    this.y = a.y - b.y;
    this.z = a.z - b.z;

    return this;
  },
  multiply: function multiply(v, w) {

    if (w !== undefined) {

      console.warn('DEPRECATED: Vector3\'s .multiply() now only accepts one argument. Use .multiplyVectors( a, b ) instead.');

      return this.multiplyVectors(v, w);
    }

    this.x *= v.x;
    this.y *= v.y;
    this.z *= v.z;

    return this;
  },
  multiplyScalar: function multiplyScalar(scalar) {

    this.x *= scalar;
    this.y *= scalar;
    this.z *= scalar;

    return this;
  },
  multiplyVectors: function multiplyVectors(a, b) {

    this.x = a.x * b.x;
    this.y = a.y * b.y;
    this.z = a.z * b.z;

    return this;
  },


  applyAxisAngle: function () {

    var quaternion = void 0;

    return function (axis, angle) {

      if (quaternion === undefined) {
        quaternion = new _quaternion2.default();
      }

      this.applyQuaternion(quaternion.setFromAxisAngle(axis, angle));

      return this;
    };
  }(),

  applyMatrix3: function applyMatrix3(m) {

    var x = this.x;
    var y = this.y;
    var z = this.z;

    var e = m.elements;

    this.x = e[0] * x + e[3] * y + e[6] * z;
    this.y = e[1] * x + e[4] * y + e[7] * z;
    this.z = e[2] * x + e[5] * y + e[8] * z;

    return this;
  },
  applyMatrix4: function applyMatrix4(m) {

    // Input: THREE.Matrix4 affine matrix

    var x = this.x,
        y = this.y,
        z = this.z;

    var e = m.elements;

    this.x = e[0] * x + e[4] * y + e[8] * z + e[12];
    this.y = e[1] * x + e[5] * y + e[9] * z + e[13];
    this.z = e[2] * x + e[6] * y + e[10] * z + e[14];

    return this;
  },
  applyProjection: function applyProjection(m) {

    // Input: THREE.Matrix4 projection matrix

    var x = this.x,
        y = this.y,
        z = this.z;

    var e = m.elements;
    var d = 1 / (e[3] * x + e[7] * y + e[11] * z + e[15]); // Perspective divide

    this.x = (e[0] * x + e[4] * y + e[8] * z + e[12]) * d;
    this.y = (e[1] * x + e[5] * y + e[9] * z + e[13]) * d;
    this.z = (e[2] * x + e[6] * y + e[10] * z + e[14]) * d;

    return this;
  },
  applyQuaternion: function applyQuaternion(q) {

    var x = this.x;
    var y = this.y;
    var z = this.z;

    var qx = q.x;
    var qy = q.y;
    var qz = q.z;
    var qw = q.w;

    // Calculate quat * vector

    var ix = qw * x + qy * z - qz * y;
    var iy = qw * y + qz * x - qx * z;
    var iz = qw * z + qx * y - qy * x;
    var iw = -qx * x - qy * y - qz * z;

    // Calculate result * inverse quat

    this.x = ix * qw + iw * -qx + iy * -qz - iz * -qy;
    this.y = iy * qw + iw * -qy + iz * -qx - ix * -qz;
    this.z = iz * qw + iw * -qz + ix * -qy - iy * -qx;

    return this;
  },
  transformDirection: function transformDirection(m) {

    // Input: THREE.Matrix4 affine matrix
    // Vector interpreted as a direction

    var x = this.x,
        y = this.y,
        z = this.z;

    var e = m.elements;

    this.x = e[0] * x + e[4] * y + e[8] * z;
    this.y = e[1] * x + e[5] * y + e[9] * z;
    this.z = e[2] * x + e[6] * y + e[10] * z;

    this.normalize();

    return this;
  },
  divide: function divide(v) {

    this.x /= v.x;
    this.y /= v.y;
    this.z /= v.z;

    return this;
  },
  divideScalar: function divideScalar(scalar) {

    if (scalar !== 0) {

      var invScalar = 1 / scalar;

      this.x *= invScalar;
      this.y *= invScalar;
      this.z *= invScalar;
    } else {

      this.x = 0;
      this.y = 0;
      this.z = 0;
    }

    return this;
  },
  min: function min(v) {

    if (this.x > v.x) {

      this.x = v.x;
    }

    if (this.y > v.y) {

      this.y = v.y;
    }

    if (this.z > v.z) {

      this.z = v.z;
    }

    return this;
  },
  max: function max(v) {

    if (this.x < v.x) {

      this.x = v.x;
    }

    if (this.y < v.y) {

      this.y = v.y;
    }

    if (this.z < v.z) {

      this.z = v.z;
    }

    return this;
  },
  clamp: function clamp(min, max) {

    // This function assumes min < max, if this assumption isn't true it will not operate correctly

    if (this.x < min.x) {

      this.x = min.x;
    } else if (this.x > max.x) {

      this.x = max.x;
    }

    if (this.y < min.y) {

      this.y = min.y;
    } else if (this.y > max.y) {

      this.y = max.y;
    }

    if (this.z < min.z) {

      this.z = min.z;
    } else if (this.z > max.z) {

      this.z = max.z;
    }

    return this;
  },


  clampScalar: function () {

    var min = void 0,
        max = void 0;

    return function (minVal, maxVal) {

      if (min === undefined) {

        min = new Vector3();
        max = new Vector3();
      }

      min.set(minVal, minVal, minVal);
      max.set(maxVal, maxVal, maxVal);

      return this.clamp(min, max);
    };
  }(),

  floor: function floor() {

    this.x = Math.floor(this.x);
    this.y = Math.floor(this.y);
    this.z = Math.floor(this.z);

    return this;
  },
  ceil: function ceil() {

    this.x = Math.ceil(this.x);
    this.y = Math.ceil(this.y);
    this.z = Math.ceil(this.z);

    return this;
  },
  round: function round() {

    this.x = Math.round(this.x);
    this.y = Math.round(this.y);
    this.z = Math.round(this.z);

    return this;
  },
  roundToZero: function roundToZero() {

    this.x = this.x < 0 ? Math.ceil(this.x) : Math.floor(this.x);
    this.y = this.y < 0 ? Math.ceil(this.y) : Math.floor(this.y);
    this.z = this.z < 0 ? Math.ceil(this.z) : Math.floor(this.z);

    return this;
  },
  negate: function negate() {

    return this.multiplyScalar(-1);
  },
  dot: function dot(v) {

    return this.x * v.x + this.y * v.y + this.z * v.z;
  },
  lengthSq: function lengthSq() {

    return this.x * this.x + this.y * this.y + this.z * this.z;
  },
  length: function length() {

    return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
  },
  lengthManhattan: function lengthManhattan() {

    return Math.abs(this.x) + Math.abs(this.y) + Math.abs(this.z);
  },
  normalize: function normalize() {

    return this.divideScalar(this.length());
  },
  setLength: function setLength(l) {

    var oldLength = this.length();

    if (oldLength !== 0 && l !== oldLength) {

      this.multiplyScalar(l / oldLength);
    }

    return this;
  },
  lerp: function lerp(v, alpha) {

    this.x += (v.x - this.x) * alpha;
    this.y += (v.y - this.y) * alpha;
    this.z += (v.z - this.z) * alpha;

    return this;
  },
  cross: function cross(v, w) {

    if (w !== undefined) {

      console.warn('DEPRECATED: Vector3\'s .cross() now only accepts one argument. Use .crossVectors( a, b ) instead.');

      return this.crossVectors(v, w);
    }

    var x = this.x,
        y = this.y,
        z = this.z;

    this.x = y * v.z - z * v.y;
    this.y = z * v.x - x * v.z;
    this.z = x * v.y - y * v.x;

    return this;
  },
  crossVectors: function crossVectors(a, b) {

    var ax = a.x,
        ay = a.y,
        az = a.z;
    var bx = b.x,
        by = b.y,
        bz = b.z;

    this.x = ay * bz - az * by;
    this.y = az * bx - ax * bz;
    this.z = ax * by - ay * bx;

    return this;
  },


  projectOnVector: function () {

    var v1 = void 0,
        dot = void 0;

    return function (vector) {

      if (v1 === undefined) {
        v1 = new Vector3();
      }

      v1.copy(vector).normalize();

      dot = this.dot(v1);

      return this.copy(v1).multiplyScalar(dot);
    };
  }(),

  projectOnPlane: function () {

    var v1 = void 0;

    return function (planeNormal) {

      if (v1 === undefined) {
        v1 = new Vector3();
      }

      v1.copy(this).projectOnVector(planeNormal);

      return this.sub(v1);
    };
  }(),

  reflect: function () {

    // Reflect incident vector off plane orthogonal to normal
    // Normal is assumed to have unit length

    var v1 = void 0;

    return function (normal) {

      if (v1 === undefined) {
        v1 = new Vector3();
      }

      return this.sub(v1.copy(normal).multiplyScalar(2 * this.dot(normal)));
    };
  }(),

  angleTo: function angleTo(v) {

    var theta = this.dot(v) / (this.length() * v.length());

    // Clamp, to handle numerical problems

    return Math.acos((0, _math.clamp)(theta, -1, 1));
  },
  distanceTo: function distanceTo(v) {

    return Math.sqrt(this.distanceToSquared(v));
  },
  distanceToSquared: function distanceToSquared(v) {

    var dx = this.x - v.x;
    var dy = this.y - v.y;
    var dz = this.z - v.z;

    return dx * dx + dy * dy + dz * dz;
  },
  setFromMatrixPosition: function setFromMatrixPosition(m) {

    this.x = m.elements[12];
    this.y = m.elements[13];
    this.z = m.elements[14];

    return this;
  },
  setFromMatrixScale: function setFromMatrixScale(m) {

    var sx = this.set(m.elements[0], m.elements[1], m.elements[2]).length();
    var sy = this.set(m.elements[4], m.elements[5], m.elements[6]).length();
    var sz = this.set(m.elements[8], m.elements[9], m.elements[10]).length();

    this.x = sx;
    this.y = sy;
    this.z = sz;

    return this;
  },
  setFromMatrixColumn: function setFromMatrixColumn(index, matrix) {

    var offset = index * 4;

    var me = matrix.elements;

    this.x = me[offset];
    this.y = me[offset + 1];
    this.z = me[offset + 2];

    return this;
  },
  equals: function equals(v) {

    return v.x === this.x && v.y === this.y && v.z === this.z;
  },
  fromArray: function fromArray(array) {

    this.x = array[0];
    this.y = array[1];
    this.z = array[2];

    return this;
  },
  toArray: function toArray() {

    return [this.x, this.y, this.z];
  },
  clone: function clone() {

    return new Vector3(this.x, this.y, this.z);
  }
};

exports.default = Vector3;

/***/ }),
/* 2 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _math = __webpack_require__(0);

// Based on  http://stackoverflow.com/questions/849211/shortest-distance-between-a-point-and-a-line-segment
function sqr(x) {
  return x * x;
}

function dist2(v, w) {
  return sqr(v.x - w.x) + sqr(v.y - w.y);
}

function distanceToPointSquared(lineSegment, point) {
  var l2 = dist2(lineSegment.start, lineSegment.end);

  if (l2 === 0) {
    return dist2(point, lineSegment.start);
  }
  var t = ((point.x - lineSegment.start.x) * (lineSegment.end.x - lineSegment.start.x) + (point.y - lineSegment.start.y) * (lineSegment.end.y - lineSegment.start.y)) / l2;

  if (t < 0) {
    return dist2(point, lineSegment.start);
  }
  if (t > 1) {
    return dist2(point, lineSegment.end);
  }

  var pt = {
    x: lineSegment.start.x + t * (lineSegment.end.x - lineSegment.start.x),
    y: lineSegment.start.y + t * (lineSegment.end.y - lineSegment.start.y)
  };

  return dist2(point, pt);
}

function distanceToPoint(lineSegment, point) {
  return Math.sqrt(distanceToPointSquared(lineSegment, point));
}

// Returns intersection points of two lines
function intersectLine(lineSegment1, lineSegment2) {
  var intersectionPoint = {};

  var x1 = lineSegment1.start.x,
      y1 = lineSegment1.start.y,
      x2 = lineSegment1.end.x,
      y2 = lineSegment1.end.y,
      x3 = lineSegment2.start.x,
      y3 = lineSegment2.start.y,
      x4 = lineSegment2.end.x,
      y4 = lineSegment2.end.y;

  var a1 = void 0,
      a2 = void 0,
      b1 = void 0,
      b2 = void 0,
      c1 = void 0,
      c2 = void 0; // Coefficients of line equations
  var r1 = void 0,
      r2 = void 0,
      r3 = void 0,
      r4 = void 0; // Sign values

  var denom = void 0,
      num = void 0; // Intermediate values

  // Compute a1, b1, c1, where line joining points 1 and 2 is "a1 x  +  b1 y  +  c1  =  0"
  a1 = y2 - y1;
  b1 = x1 - x2;
  c1 = x2 * y1 - x1 * y2;

  // Compute r3 and r4
  r3 = a1 * x3 + b1 * y3 + c1;
  r4 = a1 * x4 + b1 * y4 + c1;

  /* Check signs of r3 and r4.  If both point 3 and point 4 lie on
   * same side of line 1, the line segments do not intersect.
   */

  if (r3 !== 0 && r4 !== 0 && (0, _math.sign)(r3) === (0, _math.sign)(r4)) {
    return;
  }

  /* Compute a2, b2, c2 */

  a2 = y4 - y3;
  b2 = x3 - x4;
  c2 = x4 * y3 - x3 * y4;

  /* Compute r1 and r2 */

  r1 = a2 * x1 + b2 * y1 + c2;
  r2 = a2 * x2 + b2 * y2 + c2;

  /* Check signs of r1 and r2.  If both point 1 and point 2 lie
   * on same side of second line segment, the line segments do
   * not intersect.
   */

  if (r1 !== 0 && r2 !== 0 && (0, _math.sign)(r1) === (0, _math.sign)(r2)) {
    return;
  }

  /* Line segments intersect: compute intersection point.
   */

  denom = a1 * b2 - a2 * b1;

  /* The denom/2 is to get rounding instead of truncating.  It
   * is added or subtracted to the numerator, depending upon the
   * sign of the numerator.
   */

  num = b1 * c2 - b2 * c1;
  var x = parseFloat(num / denom);

  num = a2 * c1 - a1 * c2;
  var y = parseFloat(num / denom);

  intersectionPoint.x = x;
  intersectionPoint.y = y;

  return intersectionPoint;
}

// Module exports
var lineSegment = {
  distanceToPoint: distanceToPoint,
  intersectLine: intersectLine
};

exports.default = lineSegment;

/***/ }),
/* 3 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
var Quaternion = function Quaternion(x, y, z, w) {
  this.x = x || 0;
  this.y = y || 0;
  this.z = z || 0;
  this.w = w !== undefined ? w : 1;
};

Quaternion.prototype.setFromAxisAngle = function (axis, angle) {
  var halfAngle = angle / 2,
      s = Math.sin(halfAngle);

  this.x = axis.x * s;
  this.y = axis.y * s;
  this.z = axis.z * s;
  this.w = Math.cos(halfAngle);

  return this;
};

Quaternion.prototype.multiplyQuaternions = function (a, b) {
  var qax = a.x,
      qay = a.y,
      qaz = a.z,
      qaw = a.w;
  var qbx = b.x,
      qby = b.y,
      qbz = b.z,
      qbw = b.w;

  this.x = qax * qbw + qaw * qbx + qay * qbz - qaz * qby;
  this.y = qay * qbw + qaw * qby + qaz * qbx - qax * qbz;
  this.z = qaz * qbw + qaw * qbz + qax * qby - qay * qbx;
  this.w = qaw * qbw - qax * qbx - qay * qby - qaz * qbz;

  return this;
};

Quaternion.prototype.setFromRotationMatrix = function (m) {
  var te = m.elements,
      m11 = te[0],
      m12 = te[4],
      m13 = te[8],
      m21 = te[1],
      m22 = te[5],
      m23 = te[9],
      m31 = te[2],
      m32 = te[6],
      m33 = te[10],
      trace = m11 + m22 + m33,
      s = void 0;

  if (trace > 0) {

    s = 0.5 / Math.sqrt(trace + 1.0);

    this.w = 0.25 / s;
    this.x = (m32 - m23) * s;
    this.y = (m13 - m31) * s;
    this.z = (m21 - m12) * s;
  } else if (m11 > m22 && m11 > m33) {

    s = 2.0 * Math.sqrt(1.0 + m11 - m22 - m33);

    this.w = (m32 - m23) / s;
    this.x = 0.25 * s;
    this.y = (m12 + m21) / s;
    this.z = (m13 + m31) / s;
  } else if (m22 > m33) {

    s = 2.0 * Math.sqrt(1.0 + m22 - m11 - m33);

    this.w = (m13 - m31) / s;
    this.x = (m12 + m21) / s;
    this.y = 0.25 * s;
    this.z = (m23 + m32) / s;
  } else {

    s = 2.0 * Math.sqrt(1.0 + m33 - m11 - m22);

    this.w = (m21 - m12) / s;
    this.x = (m13 + m31) / s;
    this.y = (m23 + m32) / s;
    this.z = 0.25 * s;
  }

  return this;
};

exports.default = Quaternion;

/***/ }),
/* 4 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

var _vector = __webpack_require__(1);

var _vector2 = _interopRequireDefault(_vector);

var _math = __webpack_require__(0);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

// Copied from THREE.JS
/**
 * @author bhouston / http://exocortex.com
 */

var Line3 = function () {
  function Line3(start, end) {
    _classCallCheck(this, Line3);

    this.start = start !== undefined ? start : new _vector2.default();
    this.end = end !== undefined ? end : new _vector2.default();
  }

  _createClass(Line3, [{
    key: 'set',
    value: function set(start, end) {

      this.start.copy(start);
      this.end.copy(end);

      return this;
    }
  }, {
    key: 'copy',
    value: function copy(line) {

      this.start.copy(line.start);
      this.end.copy(line.end);

      return this;
    }
  }, {
    key: 'center',
    value: function center(optionalTarget) {

      var result = optionalTarget || new _vector2.default();

      return result.addVectors(this.start, this.end).multiplyScalar(0.5);
    }
  }, {
    key: 'delta',
    value: function delta(optionalTarget) {

      var result = optionalTarget || new _vector2.default();

      return result.subVectors(this.end, this.start);
    }
  }, {
    key: 'distanceSq',
    value: function distanceSq() {

      return this.start.distanceToSquared(this.end);
    }
  }, {
    key: 'distance',
    value: function distance() {

      return this.start.distanceTo(this.end);
    }
  }, {
    key: 'at',
    value: function at(t, optionalTarget) {

      var result = optionalTarget || new _vector2.default();

      return this.delta(result).multiplyScalar(t).add(this.start);
    }
  }, {
    key: 'closestPointToPointParameter',
    value: function closestPointToPointParameter() {

      var startP = new _vector2.default();
      var startEnd = new _vector2.default();

      return function (point, clampToLine) {

        startP.subVectors(point, this.start);
        startEnd.subVectors(this.end, this.start);

        var startEnd2 = startEnd.dot(startEnd);
        var startEnd_startP = startEnd.dot(startP);

        var t = startEnd_startP / startEnd2;

        if (clampToLine) {

          t = (0, _math.clamp)(t, 0, 1);
        }

        return t;
      };
    }
  }, {
    key: 'closestPointToPoint',
    value: function closestPointToPoint(point, clampToLine, optionalTarget) {

      var t = this.closestPointToPointParameter(point, clampToLine);

      var result = optionalTarget || new _vector2.default();

      return this.delta(result).multiplyScalar(t).add(this.start);
    }
  }, {
    key: 'applyMatrix4',
    value: function applyMatrix4(matrix) {

      this.start.applyMatrix4(matrix);
      this.end.applyMatrix4(matrix);

      return this;
    }
  }, {
    key: 'equals',
    value: function equals(line) {

      return line.start.equals(this.start) && line.end.equals(this.end);
    }
  }, {
    key: 'clone',
    value: function clone() {

      return new Line3().copy(this);
    }
  }, {
    key: 'intersectLine',
    value: function intersectLine(line) {
      // http://stackoverflow.com/questions/2316490/the-algorithm-to-find-the-point-of-intersection-of-two-3d-line-segment/10288710#10288710
      var da = this.end.clone().sub(this.start);
      var db = line.end.clone().sub(line.start);
      var dc = line.start.clone().sub(this.start);

      var daCrossDb = da.clone().cross(db);
      var dcCrossDb = dc.clone().cross(db);

      if (dc.dot(da) === 0) {
        // Lines are not coplanar, stop here
        return;
      }

      var s = dcCrossDb.dot(daCrossDb) / daCrossDb.lengthSq();

      // Make sure we have an intersection
      if (s > 1.0 || isNaN(s)) {
        return;
      }

      var intersection = this.start.clone().add(da.clone().multiplyScalar(s));
      var distanceTest = intersection.clone().sub(line.start).lengthSq() + intersection.clone().sub(line.end).lengthSq();

      if (distanceTest <= line.distanceSq()) {
        return intersection;
      }

      return;
    }
  }]);

  return Line3;
}();

exports.default = Line3;

/***/ }),
/* 5 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _vector = __webpack_require__(1);

var _vector2 = _interopRequireDefault(_vector);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

// Based on THREE.JS
var Matrix4 = function Matrix4(n11, n12, n13, n14, n21, n22, n23, n24, n31, n32, n33, n34, n41, n42, n43, n44) {
  this.elements = new Float32Array(16);

  // TODO: if n11 is undefined, then just set to identity, otherwise copy all other values into matrix
  //   We should not support semi specification of Matrix4, it is just weird.

  var te = this.elements;

  te[0] = n11 !== undefined ? n11 : 1;te[4] = n12 || 0;te[8] = n13 || 0;te[12] = n14 || 0;
  te[1] = n21 || 0;te[5] = n22 !== undefined ? n22 : 1;te[9] = n23 || 0;te[13] = n24 || 0;
  te[2] = n31 || 0;te[6] = n32 || 0;te[10] = n33 !== undefined ? n33 : 1;te[14] = n34 || 0;
  te[3] = n41 || 0;te[7] = n42 || 0;te[11] = n43 || 0;te[15] = n44 !== undefined ? n44 : 1;
};

Matrix4.prototype.makeRotationFromQuaternion = function (q) {
  var te = this.elements;

  var x = q.x,
      y = q.y,
      z = q.z,
      w = q.w;
  var x2 = x + x,
      y2 = y + y,
      z2 = z + z;
  var xx = x * x2,
      xy = x * y2,
      xz = x * z2;
  var yy = y * y2,
      yz = y * z2,
      zz = z * z2;
  var wx = w * x2,
      wy = w * y2,
      wz = w * z2;

  te[0] = 1 - (yy + zz);
  te[4] = xy - wz;
  te[8] = xz + wy;

  te[1] = xy + wz;
  te[5] = 1 - (xx + zz);
  te[9] = yz - wx;

  te[2] = xz - wy;
  te[6] = yz + wx;
  te[10] = 1 - (xx + yy);

  // Last column
  te[3] = 0;
  te[7] = 0;
  te[11] = 0;

  // Bottom row
  te[12] = 0;
  te[13] = 0;
  te[14] = 0;
  te[15] = 1;

  return this;
};

Matrix4.prototype.multiplyMatrices = function (a, b) {
  var ae = a.elements;
  var be = b.elements;
  var te = this.elements;

  var a11 = ae[0],
      a12 = ae[4],
      a13 = ae[8],
      a14 = ae[12];
  var a21 = ae[1],
      a22 = ae[5],
      a23 = ae[9],
      a24 = ae[13];
  var a31 = ae[2],
      a32 = ae[6],
      a33 = ae[10],
      a34 = ae[14];
  var a41 = ae[3],
      a42 = ae[7],
      a43 = ae[11],
      a44 = ae[15];

  var b11 = be[0],
      b12 = be[4],
      b13 = be[8],
      b14 = be[12];
  var b21 = be[1],
      b22 = be[5],
      b23 = be[9],
      b24 = be[13];
  var b31 = be[2],
      b32 = be[6],
      b33 = be[10],
      b34 = be[14];
  var b41 = be[3],
      b42 = be[7],
      b43 = be[11],
      b44 = be[15];

  te[0] = a11 * b11 + a12 * b21 + a13 * b31 + a14 * b41;
  te[4] = a11 * b12 + a12 * b22 + a13 * b32 + a14 * b42;
  te[8] = a11 * b13 + a12 * b23 + a13 * b33 + a14 * b43;
  te[12] = a11 * b14 + a12 * b24 + a13 * b34 + a14 * b44;

  te[1] = a21 * b11 + a22 * b21 + a23 * b31 + a24 * b41;
  te[5] = a21 * b12 + a22 * b22 + a23 * b32 + a24 * b42;
  te[9] = a21 * b13 + a22 * b23 + a23 * b33 + a24 * b43;
  te[13] = a21 * b14 + a22 * b24 + a23 * b34 + a24 * b44;

  te[2] = a31 * b11 + a32 * b21 + a33 * b31 + a34 * b41;
  te[6] = a31 * b12 + a32 * b22 + a33 * b32 + a34 * b42;
  te[10] = a31 * b13 + a32 * b23 + a33 * b33 + a34 * b43;
  te[14] = a31 * b14 + a32 * b24 + a33 * b34 + a34 * b44;

  te[3] = a41 * b11 + a42 * b21 + a43 * b31 + a44 * b41;
  te[7] = a41 * b12 + a42 * b22 + a43 * b32 + a44 * b42;
  te[11] = a41 * b13 + a42 * b23 + a43 * b33 + a44 * b43;
  te[15] = a41 * b14 + a42 * b24 + a43 * b34 + a44 * b44;

  return this;
};

Matrix4.prototype.multiply = function (m, n) {

  if (n !== undefined) {

    console.warn('DEPRECATED: Matrix4\'s .multiply() now only accepts one argument. Use .multiplyMatrices( a, b ) instead.');

    return this.multiplyMatrices(m, n);
  }

  return this.multiplyMatrices(this, m);
};

Matrix4.prototype.getInverse = function (m, throwOnInvertible) {

  // Based on http://www.euclideanspace.com/maths/algebra/matrix/functions/inverse/fourD/index.htm
  var te = this.elements;
  var me = m.elements;

  var n11 = me[0],
      n12 = me[4],
      n13 = me[8],
      n14 = me[12];
  var n21 = me[1],
      n22 = me[5],
      n23 = me[9],
      n24 = me[13];
  var n31 = me[2],
      n32 = me[6],
      n33 = me[10],
      n34 = me[14];
  var n41 = me[3],
      n42 = me[7],
      n43 = me[11],
      n44 = me[15];

  te[0] = n23 * n34 * n42 - n24 * n33 * n42 + n24 * n32 * n43 - n22 * n34 * n43 - n23 * n32 * n44 + n22 * n33 * n44;
  te[4] = n14 * n33 * n42 - n13 * n34 * n42 - n14 * n32 * n43 + n12 * n34 * n43 + n13 * n32 * n44 - n12 * n33 * n44;
  te[8] = n13 * n24 * n42 - n14 * n23 * n42 + n14 * n22 * n43 - n12 * n24 * n43 - n13 * n22 * n44 + n12 * n23 * n44;
  te[12] = n14 * n23 * n32 - n13 * n24 * n32 - n14 * n22 * n33 + n12 * n24 * n33 + n13 * n22 * n34 - n12 * n23 * n34;
  te[1] = n24 * n33 * n41 - n23 * n34 * n41 - n24 * n31 * n43 + n21 * n34 * n43 + n23 * n31 * n44 - n21 * n33 * n44;
  te[5] = n13 * n34 * n41 - n14 * n33 * n41 + n14 * n31 * n43 - n11 * n34 * n43 - n13 * n31 * n44 + n11 * n33 * n44;
  te[9] = n14 * n23 * n41 - n13 * n24 * n41 - n14 * n21 * n43 + n11 * n24 * n43 + n13 * n21 * n44 - n11 * n23 * n44;
  te[13] = n13 * n24 * n31 - n14 * n23 * n31 + n14 * n21 * n33 - n11 * n24 * n33 - n13 * n21 * n34 + n11 * n23 * n34;
  te[2] = n22 * n34 * n41 - n24 * n32 * n41 + n24 * n31 * n42 - n21 * n34 * n42 - n22 * n31 * n44 + n21 * n32 * n44;
  te[6] = n14 * n32 * n41 - n12 * n34 * n41 - n14 * n31 * n42 + n11 * n34 * n42 + n12 * n31 * n44 - n11 * n32 * n44;
  te[10] = n12 * n24 * n41 - n14 * n22 * n41 + n14 * n21 * n42 - n11 * n24 * n42 - n12 * n21 * n44 + n11 * n22 * n44;
  te[14] = n14 * n22 * n31 - n12 * n24 * n31 - n14 * n21 * n32 + n11 * n24 * n32 + n12 * n21 * n34 - n11 * n22 * n34;
  te[3] = n23 * n32 * n41 - n22 * n33 * n41 - n23 * n31 * n42 + n21 * n33 * n42 + n22 * n31 * n43 - n21 * n32 * n43;
  te[7] = n12 * n33 * n41 - n13 * n32 * n41 + n13 * n31 * n42 - n11 * n33 * n42 - n12 * n31 * n43 + n11 * n32 * n43;
  te[11] = n13 * n22 * n41 - n12 * n23 * n41 - n13 * n21 * n42 + n11 * n23 * n42 + n12 * n21 * n43 - n11 * n22 * n43;
  te[15] = n12 * n23 * n31 - n13 * n22 * n31 + n13 * n21 * n32 - n11 * n23 * n32 - n12 * n21 * n33 + n11 * n22 * n33;

  var det = n11 * te[0] + n21 * te[4] + n31 * te[8] + n41 * te[12];

  if (det === 0) {

    var msg = 'Matrix4.getInverse(): can\'t invert matrix, determinant is 0';

    if (throwOnInvertible || false) {

      throw new Error(msg);
    } else {

      console.warn(msg);
    }

    this.identity();

    return this;
  }

  this.multiplyScalar(1 / det);

  return this;
};

Matrix4.prototype.applyToVector3Array = function () {

  var v1 = new _vector2.default();

  return function (array, offset, length) {

    if (offset === undefined) {
      offset = 0;
    }
    if (length === undefined) {
      length = array.length;
    }

    for (var i = 0, j = offset; i < length; i += 3, j += 3) {

      v1.x = array[j];
      v1.y = array[j + 1];
      v1.z = array[j + 2];

      v1.applyMatrix4(this);

      array[j] = v1.x;
      array[j + 1] = v1.y;
      array[j + 2] = v1.z;
    }

    return array;
  };
};

Matrix4.prototype.makeTranslation = function (x, y, z) {

  this.set(1, 0, 0, x, 0, 1, 0, y, 0, 0, 1, z, 0, 0, 0, 1);

  return this;
};
Matrix4.prototype.multiplyScalar = function (s) {

  var te = this.elements;

  te[0] *= s;te[4] *= s;te[8] *= s;te[12] *= s;
  te[1] *= s;te[5] *= s;te[9] *= s;te[13] *= s;
  te[2] *= s;te[6] *= s;te[10] *= s;te[14] *= s;
  te[3] *= s;te[7] *= s;te[11] *= s;te[15] *= s;

  return this;
};
Matrix4.prototype.set = function (n11, n12, n13, n14, n21, n22, n23, n24, n31, n32, n33, n34, n41, n42, n43, n44) {

  var te = this.elements;

  te[0] = n11;te[4] = n12;te[8] = n13;te[12] = n14;
  te[1] = n21;te[5] = n22;te[9] = n23;te[13] = n24;
  te[2] = n31;te[6] = n32;te[10] = n33;te[14] = n34;
  te[3] = n41;te[7] = n42;te[11] = n43;te[15] = n44;

  return this;
};

Matrix4.prototype.makeScale = function (x, y, z) {

  this.set(x, 0, 0, 0, 0, y, 0, 0, 0, 0, z, 0, 0, 0, 0, 1);

  return this;
};

exports.default = Matrix4;

/***/ }),
/* 6 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _vector = __webpack_require__(1);

var _vector2 = _interopRequireDefault(_vector);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

// Copied from Three.JS
/**
 * @author bhouston / http://exocortex.com
 */

var Plane = function Plane(normal, constant) {

  this.normal = normal !== undefined ? normal : new _vector2.default(1, 0, 0);
  this.constant = constant !== undefined ? constant : 0;
};

Plane.prototype = {

  constructor: Plane,

  set: function set(normal, constant) {

    this.normal.copy(normal);
    this.constant = constant;

    return this;
  },
  setComponents: function setComponents(x, y, z, w) {

    this.normal.set(x, y, z);
    this.constant = w;

    return this;
  },
  setFromNormalAndCoplanarPoint: function setFromNormalAndCoplanarPoint(normal, point) {

    this.normal.copy(normal);
    this.constant = -point.dot(this.normal); // Must be this.normal, not normal, as this.normal is normalized

    return this;
  },


  setFromCoplanarPoints: function () {

    var v1 = new _vector2.default();
    var v2 = new _vector2.default();

    return function (a, b, c) {

      var normal = v1.subVectors(c, b).cross(v2.subVectors(a, b)).normalize();

      // Q: should an error be thrown if normal is zero (e.g. degenerate plane)?

      this.setFromNormalAndCoplanarPoint(normal, a);

      return this;
    };
  }(),

  copy: function copy(plane) {

    this.normal.copy(plane.normal);
    this.constant = plane.constant;

    return this;
  },
  normalize: function normalize() {

    // Note: will lead to a divide by zero if the plane is invalid.

    var inverseNormalLength = 1.0 / this.normal.length();

    this.normal.multiplyScalar(inverseNormalLength);
    this.constant *= inverseNormalLength;

    return this;
  },
  negate: function negate() {

    this.constant *= -1;
    this.normal.negate();

    return this;
  },
  distanceToPoint: function distanceToPoint(point) {

    return this.normal.dot(point) + this.constant;
  },
  distanceToSphere: function distanceToSphere(sphere) {

    return this.distanceToPoint(sphere.center) - sphere.radius;
  },
  projectPoint: function projectPoint(point, optionalTarget) {

    return this.orthoPoint(point, optionalTarget).sub(point).negate();
  },
  orthoPoint: function orthoPoint(point, optionalTarget) {

    var perpendicularMagnitude = this.distanceToPoint(point);

    var result = optionalTarget || new _vector2.default();

    return result.copy(this.normal).multiplyScalar(perpendicularMagnitude);
  },
  isIntersectionLine: function isIntersectionLine(line) {

    // Note: this tests if a line intersects the plane, not whether it (or its end-points) are coplanar with it.

    var startSign = this.distanceToPoint(line.start);
    var endSign = this.distanceToPoint(line.end);

    return startSign < 0 && endSign > 0 || endSign < 0 && startSign > 0;
  },


  intersectLine: function () {

    var v1 = new _vector2.default();

    return function (line, optionalTarget) {

      var result = optionalTarget || new _vector2.default();

      var direction = line.delta(v1);

      var denominator = this.normal.dot(direction);

      if (denominator === 0) {

        // Line is coplanar, return origin
        if (this.distanceToPoint(line.start) === 0) {

          return result.copy(line.start);
        }

        // Unsure if this is the correct method to handle this case.
        return undefined;
      }

      var t = -(line.start.dot(this.normal) + this.constant) / denominator;

      if (t < 0 || t > 1) {

        return undefined;
      }

      return result.copy(direction).multiplyScalar(t).add(line.start);
    };
  }(),

  intersectPlane: function intersectPlane(targetPlane) {
    // Returns the intersection line between two planes
    var direction = this.normal.clone().cross(targetPlane.normal);
    var origin = new _vector2.default();
    var intersectionData = {
      origin: origin,
      direction: direction
    };

    // If the planes are parallel, return an empty vector for the
    // Intersection line
    if (this.normal.clone().cross(targetPlane.normal).length < 1e-10) {
      intersectionData.direction = new _vector2.default();

      return intersectionData;
    }

    var h1 = this.constant;
    var h2 = targetPlane.constant;
    var n1dotn2 = this.normal.clone().dot(targetPlane.normal);

    var c1 = -(h1 - h2 * n1dotn2) / (1 - n1dotn2 * n1dotn2);
    var c2 = -(h2 - h1 * n1dotn2) / (1 - n1dotn2 * n1dotn2);

    intersectionData.origin = this.normal.clone().multiplyScalar(c1).add(targetPlane.normal.clone().multiplyScalar(c2));

    return intersectionData;
  },
  coplanarPoint: function coplanarPoint(optionalTarget) {

    var result = optionalTarget || new _vector2.default();

    return result.copy(this.normal).multiplyScalar(-this.constant);
  },
  translate: function translate(offset) {

    this.constant = this.constant - offset.dot(this.normal);

    return this;
  },
  equals: function equals(plane) {

    return plane.normal.equals(this.normal) && plane.constant === this.constant;
  },
  clone: function clone() {

    return new Plane().copy(this);
  }
};

exports.default = Plane;

/***/ }),
/* 7 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
function pageToPoint(e) {
  return {
    x: e.pageX,
    y: e.pageY
  };
}

function subtract(lhs, rhs) {
  return {
    x: lhs.x - rhs.x,
    y: lhs.y - rhs.y
  };
}

function copy(point) {
  return {
    x: point.x,
    y: point.y
  };
}

function distance(from, to) {
  return Math.sqrt(distanceSquared(from, to));
}

function distanceSquared(from, to) {
  var delta = subtract(from, to);

  return delta.x * delta.x + delta.y * delta.y;
}

function insideRect(point, rect) {
  if (point.x < rect.left || point.x > rect.left + rect.width || point.y < rect.top || point.y > rect.top + rect.height) {
    return false;
  }

  return true;
}

/**
 * Returns the closest source point to a target point
 * given an array of source points.
 *
 * @param sources An Array of source Points
 * @param target The target Point
 * @returns Point The closest point from the points array
 */
function findClosestPoint(sources, target) {
  var distances = [];
  var minDistance = void 0;

  sources.forEach(function (source, index) {
    var d = distance(source, target);

    distances.push(d);

    if (index === 0) {
      minDistance = d;
    } else {
      minDistance = Math.min(d, minDistance);
    }
  });

  var index = distances.indexOf(minDistance);

  return sources[index];
}

var point = {
  subtract: subtract,
  copy: copy,
  pageToPoint: pageToPoint,
  distance: distance,
  distanceSquared: distanceSquared,
  insideRect: insideRect,
  findClosestPoint: findClosestPoint
};

exports.default = point;

/***/ }),
/* 8 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _lineSegment = __webpack_require__(2);

var _lineSegment2 = _interopRequireDefault(_lineSegment);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function rectToLineSegments(rect) {
  var top = {
    start: {
      x: rect.left,
      y: rect.top
    },
    end: {
      x: rect.left + rect.width,
      y: rect.top

    }
  };
  var right = {
    start: {
      x: rect.left + rect.width,
      y: rect.top
    },
    end: {
      x: rect.left + rect.width,
      y: rect.top + rect.height

    }
  };
  var bottom = {
    start: {
      x: rect.left + rect.width,
      y: rect.top + rect.height
    },
    end: {
      x: rect.left,
      y: rect.top + rect.height

    }
  };
  var left = {
    start: {
      x: rect.left,
      y: rect.top + rect.height
    },
    end: {
      x: rect.left,
      y: rect.top

    }
  };
  var lineSegments = [top, right, bottom, left];

  return lineSegments;
}

function distanceToPoint(rect, point) {
  var minDistance = 655535;
  var lineSegments = rectToLineSegments(rect);

  lineSegments.forEach(function (segment) {
    var distance = _lineSegment2.default.distanceToPoint(segment, point);

    if (distance < minDistance) {
      minDistance = distance;
    }
  });

  return minDistance;
}

// Returns top-left and bottom-right points of the rectangle
function rectToPoints(rect) {
  var rectPoints = {
    topLeft: {
      x: rect.left,
      y: rect.top
    },
    bottomRight: {
      x: rect.left + rect.width,
      y: rect.top + rect.height
    }
  };

  return rectPoints;
}

// Returns whether two non-rotated rectangles are intersected
function doesIntersect(rect1, rect2) {
  var intersectLeftRight = void 0;
  var intersectTopBottom = void 0;

  var rect1Points = rectToPoints(rect1);
  var rect2Points = rectToPoints(rect2);

  if (rect1.width >= 0) {
    if (rect2.width >= 0) {
      intersectLeftRight = !(rect1Points.bottomRight.x <= rect2Points.topLeft.x || rect2Points.bottomRight.x <= rect1Points.topLeft.x);
    } else {
      intersectLeftRight = !(rect1Points.bottomRight.x <= rect2Points.bottomRight.x || rect2Points.topLeft.x <= rect1Points.topLeft.x);
    }
  } else if (rect2.width >= 0) {
    intersectLeftRight = !(rect1Points.topLeft.x <= rect2Points.topLeft.x || rect2Points.bottomRight.x <= rect1Points.bottomRight.x);
  } else {
    intersectLeftRight = !(rect1Points.topLeft.x <= rect2Points.bottomRight.x || rect2Points.topLeft.x <= rect1Points.bottomRight.x);
  }

  if (rect1.height >= 0) {
    if (rect2.height >= 0) {
      intersectTopBottom = !(rect1Points.bottomRight.y <= rect2Points.topLeft.y || rect2Points.bottomRight.y <= rect1Points.topLeft.y);
    } else {
      intersectTopBottom = !(rect1Points.bottomRight.y <= rect2Points.bottomRight.y || rect2Points.topLeft.y <= rect1Points.topLeft.y);
    }
  } else if (rect2.height >= 0) {
    intersectTopBottom = !(rect1Points.topLeft.y <= rect2Points.topLeft.y || rect2Points.bottomRight.y <= rect1Points.bottomRight.y);
  } else {
    intersectTopBottom = !(rect1Points.topLeft.y <= rect2Points.bottomRight.y || rect2Points.top <= rect1Points.bottomRight.y);
  }

  return intersectLeftRight && intersectTopBottom;
}

// Returns intersection points of two non-rotated rectangles
function getIntersectionRect(rect1, rect2) {
  var intersectRect = {
    topLeft: {},
    bottomRight: {}
  };

  if (!doesIntersect(rect1, rect2)) {
    return;
  }

  var rect1Points = rectToPoints(rect1);
  var rect2Points = rectToPoints(rect2);

  if (rect1.width >= 0) {
    if (rect2.width >= 0) {
      intersectRect.topLeft.x = Math.max(rect1Points.topLeft.x, rect2Points.topLeft.x);
      intersectRect.bottomRight.x = Math.min(rect1Points.bottomRight.x, rect2Points.bottomRight.x);
    } else {
      intersectRect.topLeft.x = Math.max(rect1Points.topLeft.x, rect2Points.bottomRight.x);
      intersectRect.bottomRight.x = Math.min(rect1Points.bottomRight.x, rect2Points.topLeft.x);
    }
  } else if (rect2.width >= 0) {
    intersectRect.topLeft.x = Math.min(rect1Points.topLeft.x, rect2Points.bottomRight.x);
    intersectRect.bottomRight.x = Math.max(rect1Points.bottomRight.x, rect2Points.topLeft.x);
  } else {
    intersectRect.topLeft.x = Math.min(rect1Points.topLeft.x, rect2Points.topLeft.x);
    intersectRect.bottomRight.x = Math.max(rect1Points.bottomRight.x, rect2Points.bottomRight.x);
  }

  if (rect1.height >= 0) {
    if (rect2.height >= 0) {
      intersectRect.topLeft.y = Math.max(rect1Points.topLeft.y, rect2Points.topLeft.y);
      intersectRect.bottomRight.y = Math.min(rect1Points.bottomRight.y, rect2Points.bottomRight.y);
    } else {
      intersectRect.topLeft.y = Math.max(rect1Points.topLeft.y, rect2Points.bottomRight.y);
      intersectRect.bottomRight.y = Math.min(rect1Points.bottomRight.y, rect2Points.topLeft.y);
    }
  } else if (rect2.height >= 0) {
    intersectRect.topLeft.y = Math.min(rect1Points.topLeft.y, rect2Points.bottomRight.y);
    intersectRect.bottomRight.y = Math.max(rect1Points.bottomRight.y, rect2Points.topLeft.y);
  } else {
    intersectRect.topLeft.y = Math.min(rect1Points.topLeft.y, rect2Points.topLeft.y);
    intersectRect.bottomRight.y = Math.max(rect1Points.bottomRight.y, rect2Points.bottomRight.y);
  }

  // Returns top-left and bottom-right points of intersected rectangle
  return intersectRect;
}

var rect = {
  distanceToPoint: distanceToPoint,
  getIntersectionRect: getIntersectionRect
};

exports.default = rect;

/***/ }),
/* 9 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
         value: true
});

var _Line = __webpack_require__(4);

Object.defineProperty(exports, 'Line3', {
         enumerable: true,
         get: function get() {
                  return _interopRequireDefault(_Line).default;
         }
});

var _lineSegment = __webpack_require__(2);

Object.defineProperty(exports, 'lineSegment', {
         enumerable: true,
         get: function get() {
                  return _interopRequireDefault(_lineSegment).default;
         }
});

var _math = __webpack_require__(0);

Object.defineProperty(exports, 'clamp', {
         enumerable: true,
         get: function get() {
                  return _math.clamp;
         }
});
Object.defineProperty(exports, 'degToRad', {
         enumerable: true,
         get: function get() {
                  return _math.degToRad;
         }
});
Object.defineProperty(exports, 'radToDeg', {
         enumerable: true,
         get: function get() {
                  return _math.radToDeg;
         }
});
Object.defineProperty(exports, 'sign', {
         enumerable: true,
         get: function get() {
                  return _math.sign;
         }
});

var _matrix = __webpack_require__(5);

Object.defineProperty(exports, 'Matrix4', {
         enumerable: true,
         get: function get() {
                  return _interopRequireDefault(_matrix).default;
         }
});

var _plane = __webpack_require__(6);

Object.defineProperty(exports, 'Plane', {
         enumerable: true,
         get: function get() {
                  return _interopRequireDefault(_plane).default;
         }
});

var _point = __webpack_require__(7);

Object.defineProperty(exports, 'point', {
         enumerable: true,
         get: function get() {
                  return _interopRequireDefault(_point).default;
         }
});

var _quaternion = __webpack_require__(3);

Object.defineProperty(exports, 'quaternion', {
         enumerable: true,
         get: function get() {
                  return _interopRequireDefault(_quaternion).default;
         }
});

var _rect = __webpack_require__(8);

Object.defineProperty(exports, 'rect', {
         enumerable: true,
         get: function get() {
                  return _interopRequireDefault(_rect).default;
         }
});

var _vector = __webpack_require__(1);

Object.defineProperty(exports, 'Vector3', {
         enumerable: true,
         get: function get() {
                  return _interopRequireDefault(_vector).default;
         }
});

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

/***/ })
/******/ ]);
});
//# sourceMappingURL=cornerstoneMath.js.map