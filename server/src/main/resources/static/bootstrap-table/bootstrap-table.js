(function (global, factory) {
	typeof exports === 'object' && typeof module !== 'undefined' ? module.exports = factory(require('jquery')) :
	typeof define === 'function' && define.amd ? define(['jquery'], factory) :
	(global = global || self, global.BootstrapTable = factory(global.jQuery));
}(this, (function ($) { 'use strict';

	$ = $ && $.hasOwnProperty('default') ? $['default'] : $;

	var commonjsGlobal = typeof globalThis !== 'undefined' ? globalThis : typeof window !== 'undefined' ? window : typeof global !== 'undefined' ? global : typeof self !== 'undefined' ? self : {};

	function createCommonjsModule(fn, module) {
		return module = { exports: {} }, fn(module, module.exports), module.exports;
	}

	var check = function (it) {
	  return it && it.Math == Math && it;
	};

	// https://github.com/zloirock/core-js/issues/86#issuecomment-115759028
	var global_1 =
	  // eslint-disable-next-line no-undef
	  check(typeof globalThis == 'object' && globalThis) ||
	  check(typeof window == 'object' && window) ||
	  check(typeof self == 'object' && self) ||
	  check(typeof commonjsGlobal == 'object' && commonjsGlobal) ||
	  // eslint-disable-next-line no-new-func
	  Function('return this')();

	var fails = function (exec) {
	  try {
	    return !!exec();
	  } catch (error) {
	    return true;
	  }
	};

	// Thank's IE8 for his funny defineProperty
	var descriptors = !fails(function () {
	  return Object.defineProperty({}, 'a', { get: function () { return 7; } }).a != 7;
	});

	var nativePropertyIsEnumerable = {}.propertyIsEnumerable;
	var getOwnPropertyDescriptor = Object.getOwnPropertyDescriptor;

	// Nashorn ~ JDK8 bug
	var NASHORN_BUG = getOwnPropertyDescriptor && !nativePropertyIsEnumerable.call({ 1: 2 }, 1);

	// `Object.prototype.propertyIsEnumerable` method implementation
	// https://tc39.github.io/ecma262/#sec-object.prototype.propertyisenumerable
	var f = NASHORN_BUG ? function propertyIsEnumerable(V) {
	  var descriptor = getOwnPropertyDescriptor(this, V);
	  return !!descriptor && descriptor.enumerable;
	} : nativePropertyIsEnumerable;

	var objectPropertyIsEnumerable = {
		f: f
	};

	var createPropertyDescriptor = function (bitmap, value) {
	  return {
	    enumerable: !(bitmap & 1),
	    configurable: !(bitmap & 2),
	    writable: !(bitmap & 4),
	    value: value
	  };
	};

	var toString = {}.toString;

	var classofRaw = function (it) {
	  return toString.call(it).slice(8, -1);
	};

	var split = ''.split;

	// fallback for non-array-like ES3 and non-enumerable old V8 strings
	var indexedObject = fails(function () {
	  // throws an error in rhino, see https://github.com/mozilla/rhino/issues/346
	  // eslint-disable-next-line no-prototype-builtins
	  return !Object('z').propertyIsEnumerable(0);
	}) ? function (it) {
	  return classofRaw(it) == 'String' ? split.call(it, '') : Object(it);
	} : Object;

	// `RequireObjectCoercible` abstract operation
	// https://tc39.github.io/ecma262/#sec-requireobjectcoercible
	var requireObjectCoercible = function (it) {
	  if (it == undefined) throw TypeError("Can't call method on " + it);
	  return it;
	};

	// toObject with fallback for non-array-like ES3 strings



	var toIndexedObject = function (it) {
	  return indexedObject(requireObjectCoercible(it));
	};

	var isObject = function (it) {
	  return typeof it === 'object' ? it !== null : typeof it === 'function';
	};

	// `ToPrimitive` abstract operation
	// https://tc39.github.io/ecma262/#sec-toprimitive
	// instead of the ES6 spec version, we didn't implement @@toPrimitive case
	// and the second argument - flag - preferred type is a string
	var toPrimitive = function (input, PREFERRED_STRING) {
	  if (!isObject(input)) return input;
	  var fn, val;
	  if (PREFERRED_STRING && typeof (fn = input.toString) == 'function' && !isObject(val = fn.call(input))) return val;
	  if (typeof (fn = input.valueOf) == 'function' && !isObject(val = fn.call(input))) return val;
	  if (!PREFERRED_STRING && typeof (fn = input.toString) == 'function' && !isObject(val = fn.call(input))) return val;
	  throw TypeError("Can't convert object to primitive value");
	};

	var hasOwnProperty = {}.hasOwnProperty;

	var has = function (it, key) {
	  return hasOwnProperty.call(it, key);
	};

	var document$1 = global_1.document;
	// typeof document.createElement is 'object' in old IE
	var EXISTS = isObject(document$1) && isObject(document$1.createElement);

	var documentCreateElement = function (it) {
	  return EXISTS ? document$1.createElement(it) : {};
	};

	// Thank's IE8 for his funny defineProperty
	var ie8DomDefine = !descriptors && !fails(function () {
	  return Object.defineProperty(documentCreateElement('div'), 'a', {
	    get: function () { return 7; }
	  }).a != 7;
	});

	var nativeGetOwnPropertyDescriptor = Object.getOwnPropertyDescriptor;

	// `Object.getOwnPropertyDescriptor` method
	// https://tc39.github.io/ecma262/#sec-object.getownpropertydescriptor
	var f$1 = descriptors ? nativeGetOwnPropertyDescriptor : function getOwnPropertyDescriptor(O, P) {
	  O = toIndexedObject(O);
	  P = toPrimitive(P, true);
	  if (ie8DomDefine) try {
	    return nativeGetOwnPropertyDescriptor(O, P);
	  } catch (error) { /* empty */ }
	  if (has(O, P)) return createPropertyDescriptor(!objectPropertyIsEnumerable.f.call(O, P), O[P]);
	};

	var objectGetOwnPropertyDescriptor = {
		f: f$1
	};

	var anObject = function (it) {
	  if (!isObject(it)) {
	    throw TypeError(String(it) + ' is not an object');
	  } return it;
	};

	var nativeDefineProperty = Object.defineProperty;

	// `Object.defineProperty` method
	// https://tc39.github.io/ecma262/#sec-object.defineproperty
	var f$2 = descriptors ? nativeDefineProperty : function defineProperty(O, P, Attributes) {
	  anObject(O);
	  P = toPrimitive(P, true);
	  anObject(Attributes);
	  if (ie8DomDefine) try {
	    return nativeDefineProperty(O, P, Attributes);
	  } catch (error) { /* empty */ }
	  if ('get' in Attributes || 'set' in Attributes) throw TypeError('Accessors not supported');
	  if ('value' in Attributes) O[P] = Attributes.value;
	  return O;
	};

	var objectDefineProperty = {
		f: f$2
	};

	var createNonEnumerableProperty = descriptors ? function (object, key, value) {
	  return objectDefineProperty.f(object, key, createPropertyDescriptor(1, value));
	} : function (object, key, value) {
	  object[key] = value;
	  return object;
	};

	var setGlobal = function (key, value) {
	  try {
	    createNonEnumerableProperty(global_1, key, value);
	  } catch (error) {
	    global_1[key] = value;
	  } return value;
	};

	var SHARED = '__core-js_shared__';
	var store = global_1[SHARED] || setGlobal(SHARED, {});

	var sharedStore = store;

	var functionToString = Function.toString;

	// this helper broken in `3.4.1-3.4.4`, so we can't use `shared` helper
	if (typeof sharedStore.inspectSource != 'function') {
	  sharedStore.inspectSource = function (it) {
	    return functionToString.call(it);
	  };
	}

	var inspectSource = sharedStore.inspectSource;

	var WeakMap = global_1.WeakMap;

	var nativeWeakMap = typeof WeakMap === 'function' && /native code/.test(inspectSource(WeakMap));

	var shared = createCommonjsModule(function (module) {
	(module.exports = function (key, value) {
	  return sharedStore[key] || (sharedStore[key] = value !== undefined ? value : {});
	})('versions', []).push({
	  version: '3.6.0',
	  mode:  'global',
	  copyright: '© 2019 Denis Pushkarev (zloirock.ru)'
	});
	});

	var id = 0;
	var postfix = Math.random();

	var uid = function (key) {
	  return 'Symbol(' + String(key === undefined ? '' : key) + ')_' + (++id + postfix).toString(36);
	};

	var keys = shared('keys');

	var sharedKey = function (key) {
	  return keys[key] || (keys[key] = uid(key));
	};

	var hiddenKeys = {};

	var WeakMap$1 = global_1.WeakMap;
	var set, get, has$1;

	var enforce = function (it) {
	  return has$1(it) ? get(it) : set(it, {});
	};

	var getterFor = function (TYPE) {
	  return function (it) {
	    var state;
	    if (!isObject(it) || (state = get(it)).type !== TYPE) {
	      throw TypeError('Incompatible receiver, ' + TYPE + ' required');
	    } return state;
	  };
	};

	if (nativeWeakMap) {
	  var store$1 = new WeakMap$1();
	  var wmget = store$1.get;
	  var wmhas = store$1.has;
	  var wmset = store$1.set;
	  set = function (it, metadata) {
	    wmset.call(store$1, it, metadata);
	    return metadata;
	  };
	  get = function (it) {
	    return wmget.call(store$1, it) || {};
	  };
	  has$1 = function (it) {
	    return wmhas.call(store$1, it);
	  };
	} else {
	  var STATE = sharedKey('state');
	  hiddenKeys[STATE] = true;
	  set = function (it, metadata) {
	    createNonEnumerableProperty(it, STATE, metadata);
	    return metadata;
	  };
	  get = function (it) {
	    return has(it, STATE) ? it[STATE] : {};
	  };
	  has$1 = function (it) {
	    return has(it, STATE);
	  };
	}

	var internalState = {
	  set: set,
	  get: get,
	  has: has$1,
	  enforce: enforce,
	  getterFor: getterFor
	};

	var redefine = createCommonjsModule(function (module) {
	var getInternalState = internalState.get;
	var enforceInternalState = internalState.enforce;
	var TEMPLATE = String(String).split('String');

	(module.exports = function (O, key, value, options) {
	  var unsafe = options ? !!options.unsafe : false;
	  var simple = options ? !!options.enumerable : false;
	  var noTargetGet = options ? !!options.noTargetGet : false;
	  if (typeof value == 'function') {
	    if (typeof key == 'string' && !has(value, 'name')) createNonEnumerableProperty(value, 'name', key);
	    enforceInternalState(value).source = TEMPLATE.join(typeof key == 'string' ? key : '');
	  }
	  if (O === global_1) {
	    if (simple) O[key] = value;
	    else setGlobal(key, value);
	    return;
	  } else if (!unsafe) {
	    delete O[key];
	  } else if (!noTargetGet && O[key]) {
	    simple = true;
	  }
	  if (simple) O[key] = value;
	  else createNonEnumerableProperty(O, key, value);
	// add fake Function#toString for correct work wrapped methods / constructors with methods like LoDash isNative
	})(Function.prototype, 'toString', function toString() {
	  return typeof this == 'function' && getInternalState(this).source || inspectSource(this);
	});
	});

	var path = global_1;

	var aFunction = function (variable) {
	  return typeof variable == 'function' ? variable : undefined;
	};

	var getBuiltIn = function (namespace, method) {
	  return arguments.length < 2 ? aFunction(path[namespace]) || aFunction(global_1[namespace])
	    : path[namespace] && path[namespace][method] || global_1[namespace] && global_1[namespace][method];
	};

	var ceil = Math.ceil;
	var floor = Math.floor;

	// `ToInteger` abstract operation
	// https://tc39.github.io/ecma262/#sec-tointeger
	var toInteger = function (argument) {
	  return isNaN(argument = +argument) ? 0 : (argument > 0 ? floor : ceil)(argument);
	};

	var min = Math.min;

	// `ToLength` abstract operation
	// https://tc39.github.io/ecma262/#sec-tolength
	var toLength = function (argument) {
	  return argument > 0 ? min(toInteger(argument), 0x1FFFFFFFFFFFFF) : 0; // 2 ** 53 - 1 == 9007199254740991
	};

	var max = Math.max;
	var min$1 = Math.min;

	// Helper for a popular repeating case of the spec:
	// Let integer be ? ToInteger(index).
	// If integer < 0, let result be max((length + integer), 0); else let result be min(integer, length).
	var toAbsoluteIndex = function (index, length) {
	  var integer = toInteger(index);
	  return integer < 0 ? max(integer + length, 0) : min$1(integer, length);
	};

	// `Array.prototype.{ indexOf, includes }` methods implementation
	var createMethod = function (IS_INCLUDES) {
	  return function ($this, el, fromIndex) {
	    var O = toIndexedObject($this);
	    var length = toLength(O.length);
	    var index = toAbsoluteIndex(fromIndex, length);
	    var value;
	    // Array#includes uses SameValueZero equality algorithm
	    // eslint-disable-next-line no-self-compare
	    if (IS_INCLUDES && el != el) while (length > index) {
	      value = O[index++];
	      // eslint-disable-next-line no-self-compare
	      if (value != value) return true;
	    // Array#indexOf ignores holes, Array#includes - not
	    } else for (;length > index; index++) {
	      if ((IS_INCLUDES || index in O) && O[index] === el) return IS_INCLUDES || index || 0;
	    } return !IS_INCLUDES && -1;
	  };
	};

	var arrayIncludes = {
	  // `Array.prototype.includes` method
	  // https://tc39.github.io/ecma262/#sec-array.prototype.includes
	  includes: createMethod(true),
	  // `Array.prototype.indexOf` method
	  // https://tc39.github.io/ecma262/#sec-array.prototype.indexof
	  indexOf: createMethod(false)
	};

	var indexOf = arrayIncludes.indexOf;


	var objectKeysInternal = function (object, names) {
	  var O = toIndexedObject(object);
	  var i = 0;
	  var result = [];
	  var key;
	  for (key in O) !has(hiddenKeys, key) && has(O, key) && result.push(key);
	  // Don't enum bug & hidden keys
	  while (names.length > i) if (has(O, key = names[i++])) {
	    ~indexOf(result, key) || result.push(key);
	  }
	  return result;
	};

	// IE8- don't enum bug keys
	var enumBugKeys = [
	  'constructor',
	  'hasOwnProperty',
	  'isPrototypeOf',
	  'propertyIsEnumerable',
	  'toLocaleString',
	  'toString',
	  'valueOf'
	];

	var hiddenKeys$1 = enumBugKeys.concat('length', 'prototype');

	// `Object.getOwnPropertyNames` method
	// https://tc39.github.io/ecma262/#sec-object.getownpropertynames
	var f$3 = Object.getOwnPropertyNames || function getOwnPropertyNames(O) {
	  return objectKeysInternal(O, hiddenKeys$1);
	};

	var objectGetOwnPropertyNames = {
		f: f$3
	};

	var f$4 = Object.getOwnPropertySymbols;

	var objectGetOwnPropertySymbols = {
		f: f$4
	};

	// all object keys, includes non-enumerable and symbols
	var ownKeys = getBuiltIn('Reflect', 'ownKeys') || function ownKeys(it) {
	  var keys = objectGetOwnPropertyNames.f(anObject(it));
	  var getOwnPropertySymbols = objectGetOwnPropertySymbols.f;
	  return getOwnPropertySymbols ? keys.concat(getOwnPropertySymbols(it)) : keys;
	};

	var copyConstructorProperties = function (target, source) {
	  var keys = ownKeys(source);
	  var defineProperty = objectDefineProperty.f;
	  var getOwnPropertyDescriptor = objectGetOwnPropertyDescriptor.f;
	  for (var i = 0; i < keys.length; i++) {
	    var key = keys[i];
	    if (!has(target, key)) defineProperty(target, key, getOwnPropertyDescriptor(source, key));
	  }
	};

	var replacement = /#|\.prototype\./;

	var isForced = function (feature, detection) {
	  var value = data[normalize(feature)];
	  return value == POLYFILL ? true
	    : value == NATIVE ? false
	    : typeof detection == 'function' ? fails(detection)
	    : !!detection;
	};

	var normalize = isForced.normalize = function (string) {
	  return String(string).replace(replacement, '.').toLowerCase();
	};

	var data = isForced.data = {};
	var NATIVE = isForced.NATIVE = 'N';
	var POLYFILL = isForced.POLYFILL = 'P';

	var isForced_1 = isForced;

	var getOwnPropertyDescriptor$1 = objectGetOwnPropertyDescriptor.f;






	/*
	  options.target      - name of the target object
	  options.global      - target is the global object
	  options.stat        - export as static methods of target
	  options.proto       - export as prototype methods of target
	  options.real        - real prototype method for the `pure` version
	  options.forced      - export even if the native feature is available
	  options.bind        - bind methods to the target, required for the `pure` version
	  options.wrap        - wrap constructors to preventing global pollution, required for the `pure` version
	  options.unsafe      - use the simple assignment of property instead of delete + defineProperty
	  options.sham        - add a flag to not completely full polyfills
	  options.enumerable  - export as enumerable property
	  options.noTargetGet - prevent calling a getter on target
	*/
	var _export = function (options, source) {
	  var TARGET = options.target;
	  var GLOBAL = options.global;
	  var STATIC = options.stat;
	  var FORCED, target, key, targetProperty, sourceProperty, descriptor;
	  if (GLOBAL) {
	    target = global_1;
	  } else if (STATIC) {
	    target = global_1[TARGET] || setGlobal(TARGET, {});
	  } else {
	    target = (global_1[TARGET] || {}).prototype;
	  }
	  if (target) for (key in source) {
	    sourceProperty = source[key];
	    if (options.noTargetGet) {
	      descriptor = getOwnPropertyDescriptor$1(target, key);
	      targetProperty = descriptor && descriptor.value;
	    } else targetProperty = target[key];
	    FORCED = isForced_1(GLOBAL ? key : TARGET + (STATIC ? '.' : '#') + key, options.forced);
	    // contained in target
	    if (!FORCED && targetProperty !== undefined) {
	      if (typeof sourceProperty === typeof targetProperty) continue;
	      copyConstructorProperties(sourceProperty, targetProperty);
	    }
	    // add a flag to not completely full polyfills
	    if (options.sham || (targetProperty && targetProperty.sham)) {
	      createNonEnumerableProperty(sourceProperty, 'sham', true);
	    }
	    // extend global
	    redefine(target, key, sourceProperty, options);
	  }
	};

	var nativeSymbol = !!Object.getOwnPropertySymbols && !fails(function () {
	  // Chrome 38 Symbol has incorrect toString conversion
	  // eslint-disable-next-line no-undef
	  return !String(Symbol());
	});

	var useSymbolAsUid = nativeSymbol
	  // eslint-disable-next-line no-undef
	  && !Symbol.sham
	  // eslint-disable-next-line no-undef
	  && typeof Symbol() == 'symbol';

	// `IsArray` abstract operation
	// https://tc39.github.io/ecma262/#sec-isarray
	var isArray = Array.isArray || function isArray(arg) {
	  return classofRaw(arg) == 'Array';
	};

	// `ToObject` abstract operation
	// https://tc39.github.io/ecma262/#sec-toobject
	var toObject = function (argument) {
	  return Object(requireObjectCoercible(argument));
	};

	// `Object.keys` method
	// https://tc39.github.io/ecma262/#sec-object.keys
	var objectKeys = Object.keys || function keys(O) {
	  return objectKeysInternal(O, enumBugKeys);
	};

	// `Object.defineProperties` method
	// https://tc39.github.io/ecma262/#sec-object.defineproperties
	var objectDefineProperties = descriptors ? Object.defineProperties : function defineProperties(O, Properties) {
	  anObject(O);
	  var keys = objectKeys(Properties);
	  var length = keys.length;
	  var index = 0;
	  var key;
	  while (length > index) objectDefineProperty.f(O, key = keys[index++], Properties[key]);
	  return O;
	};

	var html = getBuiltIn('document', 'documentElement');

	var GT = '>';
	var LT = '<';
	var PROTOTYPE = 'prototype';
	var SCRIPT = 'script';
	var IE_PROTO = sharedKey('IE_PROTO');

	var EmptyConstructor = function () { /* empty */ };

	var scriptTag = function (content) {
	  return LT + SCRIPT + GT + content + LT + '/' + SCRIPT + GT;
	};

	// Create object with fake `null` prototype: use ActiveX Object with cleared prototype
	var NullProtoObjectViaActiveX = function (activeXDocument) {
	  activeXDocument.write(scriptTag(''));
	  activeXDocument.close();
	  var temp = activeXDocument.parentWindow.Object;
	  activeXDocument = null; // avoid memory leak
	  return temp;
	};

	// Create object with fake `null` prototype: use iframe Object with cleared prototype
	var NullProtoObjectViaIFrame = function () {
	  // Thrash, waste and sodomy: IE GC bug
	  var iframe = documentCreateElement('iframe');
	  var JS = 'java' + SCRIPT + ':';
	  var iframeDocument;
	  iframe.style.display = 'none';
	  html.appendChild(iframe);
	  // https://github.com/zloirock/core-js/issues/475
	  iframe.src = String(JS);
	  iframeDocument = iframe.contentWindow.document;
	  iframeDocument.open();
	  iframeDocument.write(scriptTag('document.F=Object'));
	  iframeDocument.close();
	  return iframeDocument.F;
	};

	// Check for document.domain and active x support
	// No need to use active x approach when document.domain is not set
	// see https://github.com/es-shims/es5-shim/issues/150
	// variation of https://github.com/kitcambridge/es5-shim/commit/4f738ac066346
	// avoid IE GC bug
	var activeXDocument;
	var NullProtoObject = function () {
	  try {
	    /* global ActiveXObject */
	    activeXDocument = document.domain && new ActiveXObject('htmlfile');
	  } catch (error) { /* ignore */ }
	  NullProtoObject = activeXDocument ? NullProtoObjectViaActiveX(activeXDocument) : NullProtoObjectViaIFrame();
	  var length = enumBugKeys.length;
	  while (length--) delete NullProtoObject[PROTOTYPE][enumBugKeys[length]];
	  return NullProtoObject();
	};

	hiddenKeys[IE_PROTO] = true;

	// `Object.create` method
	// https://tc39.github.io/ecma262/#sec-object.create
	var objectCreate = Object.create || function create(O, Properties) {
	  var result;
	  if (O !== null) {
	    EmptyConstructor[PROTOTYPE] = anObject(O);
	    result = new EmptyConstructor();
	    EmptyConstructor[PROTOTYPE] = null;
	    // add "__proto__" for Object.getPrototypeOf polyfill
	    result[IE_PROTO] = O;
	  } else result = NullProtoObject();
	  return Properties === undefined ? result : objectDefineProperties(result, Properties);
	};

	var nativeGetOwnPropertyNames = objectGetOwnPropertyNames.f;

	var toString$1 = {}.toString;

	var windowNames = typeof window == 'object' && window && Object.getOwnPropertyNames
	  ? Object.getOwnPropertyNames(window) : [];

	var getWindowNames = function (it) {
	  try {
	    return nativeGetOwnPropertyNames(it);
	  } catch (error) {
	    return windowNames.slice();
	  }
	};

	// fallback for IE11 buggy Object.getOwnPropertyNames with iframe and window
	var f$5 = function getOwnPropertyNames(it) {
	  return windowNames && toString$1.call(it) == '[object Window]'
	    ? getWindowNames(it)
	    : nativeGetOwnPropertyNames(toIndexedObject(it));
	};

	var objectGetOwnPropertyNamesExternal = {
		f: f$5
	};

	var WellKnownSymbolsStore = shared('wks');
	var Symbol$1 = global_1.Symbol;
	var createWellKnownSymbol = useSymbolAsUid ? Symbol$1 : uid;

	var wellKnownSymbol = function (name) {
	  if (!has(WellKnownSymbolsStore, name)) {
	    if (nativeSymbol && has(Symbol$1, name)) WellKnownSymbolsStore[name] = Symbol$1[name];
	    else WellKnownSymbolsStore[name] = createWellKnownSymbol('Symbol.' + name);
	  } return WellKnownSymbolsStore[name];
	};

	var f$6 = wellKnownSymbol;

	var wrappedWellKnownSymbol = {
		f: f$6
	};

	var defineProperty = objectDefineProperty.f;

	var defineWellKnownSymbol = function (NAME) {
	  var Symbol = path.Symbol || (path.Symbol = {});
	  if (!has(Symbol, NAME)) defineProperty(Symbol, NAME, {
	    value: wrappedWellKnownSymbol.f(NAME)
	  });
	};

	var defineProperty$1 = objectDefineProperty.f;



	var TO_STRING_TAG = wellKnownSymbol('toStringTag');

	var setToStringTag = function (it, TAG, STATIC) {
	  if (it && !has(it = STATIC ? it : it.prototype, TO_STRING_TAG)) {
	    defineProperty$1(it, TO_STRING_TAG, { configurable: true, value: TAG });
	  }
	};

	var aFunction$1 = function (it) {
	  if (typeof it != 'function') {
	    throw TypeError(String(it) + ' is not a function');
	  } return it;
	};

	// optional / simple context binding
	var bindContext = function (fn, that, length) {
	  aFunction$1(fn);
	  if (that === undefined) return fn;
	  switch (length) {
	    case 0: return function () {
	      return fn.call(that);
	    };
	    case 1: return function (a) {
	      return fn.call(that, a);
	    };
	    case 2: return function (a, b) {
	      return fn.call(that, a, b);
	    };
	    case 3: return function (a, b, c) {
	      return fn.call(that, a, b, c);
	    };
	  }
	  return function (/* ...args */) {
	    return fn.apply(that, arguments);
	  };
	};

	var SPECIES = wellKnownSymbol('species');

	// `ArraySpeciesCreate` abstract operation
	// https://tc39.github.io/ecma262/#sec-arrayspeciescreate
	var arraySpeciesCreate = function (originalArray, length) {
	  var C;
	  if (isArray(originalArray)) {
	    C = originalArray.constructor;
	    // cross-realm fallback
	    if (typeof C == 'function' && (C === Array || isArray(C.prototype))) C = undefined;
	    else if (isObject(C)) {
	      C = C[SPECIES];
	      if (C === null) C = undefined;
	    }
	  } return new (C === undefined ? Array : C)(length === 0 ? 0 : length);
	};

	var push = [].push;

	// `Array.prototype.{ forEach, map, filter, some, every, find, findIndex }` methods implementation
	var createMethod$1 = function (TYPE) {
	  var IS_MAP = TYPE == 1;
	  var IS_FILTER = TYPE == 2;
	  var IS_SOME = TYPE == 3;
	  var IS_EVERY = TYPE == 4;
	  var IS_FIND_INDEX = TYPE == 6;
	  var NO_HOLES = TYPE == 5 || IS_FIND_INDEX;
	  return function ($this, callbackfn, that, specificCreate) {
	    var O = toObject($this);
	    var self = indexedObject(O);
	    var boundFunction = bindContext(callbackfn, that, 3);
	    var length = toLength(self.length);
	    var index = 0;
	    var create = specificCreate || arraySpeciesCreate;
	    var target = IS_MAP ? create($this, length) : IS_FILTER ? create($this, 0) : undefined;
	    var value, result;
	    for (;length > index; index++) if (NO_HOLES || index in self) {
	      value = self[index];
	      result = boundFunction(value, index, O);
	      if (TYPE) {
	        if (IS_MAP) target[index] = result; // map
	        else if (result) switch (TYPE) {
	          case 3: return true;              // some
	          case 5: return value;             // find
	          case 6: return index;             // findIndex
	          case 2: push.call(target, value); // filter
	        } else if (IS_EVERY) return false;  // every
	      }
	    }
	    return IS_FIND_INDEX ? -1 : IS_SOME || IS_EVERY ? IS_EVERY : target;
	  };
	};

	var arrayIteration = {
	  // `Array.prototype.forEach` method
	  // https://tc39.github.io/ecma262/#sec-array.prototype.foreach
	  forEach: createMethod$1(0),
	  // `Array.prototype.map` method
	  // https://tc39.github.io/ecma262/#sec-array.prototype.map
	  map: createMethod$1(1),
	  // `Array.prototype.filter` method
	  // https://tc39.github.io/ecma262/#sec-array.prototype.filter
	  filter: createMethod$1(2),
	  // `Array.prototype.some` method
	  // https://tc39.github.io/ecma262/#sec-array.prototype.some
	  some: createMethod$1(3),
	  // `Array.prototype.every` method
	  // https://tc39.github.io/ecma262/#sec-array.prototype.every
	  every: createMethod$1(4),
	  // `Array.prototype.find` method
	  // https://tc39.github.io/ecma262/#sec-array.prototype.find
	  find: createMethod$1(5),
	  // `Array.prototype.findIndex` method
	  // https://tc39.github.io/ecma262/#sec-array.prototype.findIndex
	  findIndex: createMethod$1(6)
	};

	var $forEach = arrayIteration.forEach;

	var HIDDEN = sharedKey('hidden');
	var SYMBOL = 'Symbol';
	var PROTOTYPE$1 = 'prototype';
	var TO_PRIMITIVE = wellKnownSymbol('toPrimitive');
	var setInternalState = internalState.set;
	var getInternalState = internalState.getterFor(SYMBOL);
	var ObjectPrototype = Object[PROTOTYPE$1];
	var $Symbol = global_1.Symbol;
	var $stringify = getBuiltIn('JSON', 'stringify');
	var nativeGetOwnPropertyDescriptor$1 = objectGetOwnPropertyDescriptor.f;
	var nativeDefineProperty$1 = objectDefineProperty.f;
	var nativeGetOwnPropertyNames$1 = objectGetOwnPropertyNamesExternal.f;
	var nativePropertyIsEnumerable$1 = objectPropertyIsEnumerable.f;
	var AllSymbols = shared('symbols');
	var ObjectPrototypeSymbols = shared('op-symbols');
	var StringToSymbolRegistry = shared('string-to-symbol-registry');
	var SymbolToStringRegistry = shared('symbol-to-string-registry');
	var WellKnownSymbolsStore$1 = shared('wks');
	var QObject = global_1.QObject;
	// Don't use setters in Qt Script, https://github.com/zloirock/core-js/issues/173
	var USE_SETTER = !QObject || !QObject[PROTOTYPE$1] || !QObject[PROTOTYPE$1].findChild;

	// fallback for old Android, https://code.google.com/p/v8/issues/detail?id=687
	var setSymbolDescriptor = descriptors && fails(function () {
	  return objectCreate(nativeDefineProperty$1({}, 'a', {
	    get: function () { return nativeDefineProperty$1(this, 'a', { value: 7 }).a; }
	  })).a != 7;
	}) ? function (O, P, Attributes) {
	  var ObjectPrototypeDescriptor = nativeGetOwnPropertyDescriptor$1(ObjectPrototype, P);
	  if (ObjectPrototypeDescriptor) delete ObjectPrototype[P];
	  nativeDefineProperty$1(O, P, Attributes);
	  if (ObjectPrototypeDescriptor && O !== ObjectPrototype) {
	    nativeDefineProperty$1(ObjectPrototype, P, ObjectPrototypeDescriptor);
	  }
	} : nativeDefineProperty$1;

	var wrap = function (tag, description) {
	  var symbol = AllSymbols[tag] = objectCreate($Symbol[PROTOTYPE$1]);
	  setInternalState(symbol, {
	    type: SYMBOL,
	    tag: tag,
	    description: description
	  });
	  if (!descriptors) symbol.description = description;
	  return symbol;
	};

	var isSymbol = nativeSymbol && typeof $Symbol.iterator == 'symbol' ? function (it) {
	  return typeof it == 'symbol';
	} : function (it) {
	  return Object(it) instanceof $Symbol;
	};

	var $defineProperty = function defineProperty(O, P, Attributes) {
	  if (O === ObjectPrototype) $defineProperty(ObjectPrototypeSymbols, P, Attributes);
	  anObject(O);
	  var key = toPrimitive(P, true);
	  anObject(Attributes);
	  if (has(AllSymbols, key)) {
	    if (!Attributes.enumerable) {
	      if (!has(O, HIDDEN)) nativeDefineProperty$1(O, HIDDEN, createPropertyDescriptor(1, {}));
	      O[HIDDEN][key] = true;
	    } else {
	      if (has(O, HIDDEN) && O[HIDDEN][key]) O[HIDDEN][key] = false;
	      Attributes = objectCreate(Attributes, { enumerable: createPropertyDescriptor(0, false) });
	    } return setSymbolDescriptor(O, key, Attributes);
	  } return nativeDefineProperty$1(O, key, Attributes);
	};

	var $defineProperties = function defineProperties(O, Properties) {
	  anObject(O);
	  var properties = toIndexedObject(Properties);
	  var keys = objectKeys(properties).concat($getOwnPropertySymbols(properties));
	  $forEach(keys, function (key) {
	    if (!descriptors || $propertyIsEnumerable.call(properties, key)) $defineProperty(O, key, properties[key]);
	  });
	  return O;
	};

	var $create = function create(O, Properties) {
	  return Properties === undefined ? objectCreate(O) : $defineProperties(objectCreate(O), Properties);
	};

	var $propertyIsEnumerable = function propertyIsEnumerable(V) {
	  var P = toPrimitive(V, true);
	  var enumerable = nativePropertyIsEnumerable$1.call(this, P);
	  if (this === ObjectPrototype && has(AllSymbols, P) && !has(ObjectPrototypeSymbols, P)) return false;
	  return enumerable || !has(this, P) || !has(AllSymbols, P) || has(this, HIDDEN) && this[HIDDEN][P] ? enumerable : true;
	};

	var $getOwnPropertyDescriptor = function getOwnPropertyDescriptor(O, P) {
	  var it = toIndexedObject(O);
	  var key = toPrimitive(P, true);
	  if (it === ObjectPrototype && has(AllSymbols, key) && !has(ObjectPrototypeSymbols, key)) return;
	  var descriptor = nativeGetOwnPropertyDescriptor$1(it, key);
	  if (descriptor && has(AllSymbols, key) && !(has(it, HIDDEN) && it[HIDDEN][key])) {
	    descriptor.enumerable = true;
	  }
	  return descriptor;
	};

	var $getOwnPropertyNames = function getOwnPropertyNames(O) {
	  var names = nativeGetOwnPropertyNames$1(toIndexedObject(O));
	  var result = [];
	  $forEach(names, function (key) {
	    if (!has(AllSymbols, key) && !has(hiddenKeys, key)) result.push(key);
	  });
	  return result;
	};

	var $getOwnPropertySymbols = function getOwnPropertySymbols(O) {
	  var IS_OBJECT_PROTOTYPE = O === ObjectPrototype;
	  var names = nativeGetOwnPropertyNames$1(IS_OBJECT_PROTOTYPE ? ObjectPrototypeSymbols : toIndexedObject(O));
	  var result = [];
	  $forEach(names, function (key) {
	    if (has(AllSymbols, key) && (!IS_OBJECT_PROTOTYPE || has(ObjectPrototype, key))) {
	      result.push(AllSymbols[key]);
	    }
	  });
	  return result;
	};

	// `Symbol` constructor
	// https://tc39.github.io/ecma262/#sec-symbol-constructor
	if (!nativeSymbol) {
	  $Symbol = function Symbol() {
	    if (this instanceof $Symbol) throw TypeError('Symbol is not a constructor');
	    var description = !arguments.length || arguments[0] === undefined ? undefined : String(arguments[0]);
	    var tag = uid(description);
	    var setter = function (value) {
	      if (this === ObjectPrototype) setter.call(ObjectPrototypeSymbols, value);
	      if (has(this, HIDDEN) && has(this[HIDDEN], tag)) this[HIDDEN][tag] = false;
	      setSymbolDescriptor(this, tag, createPropertyDescriptor(1, value));
	    };
	    if (descriptors && USE_SETTER) setSymbolDescriptor(ObjectPrototype, tag, { configurable: true, set: setter });
	    return wrap(tag, description);
	  };

	  redefine($Symbol[PROTOTYPE$1], 'toString', function toString() {
	    return getInternalState(this).tag;
	  });

	  objectPropertyIsEnumerable.f = $propertyIsEnumerable;
	  objectDefineProperty.f = $defineProperty;
	  objectGetOwnPropertyDescriptor.f = $getOwnPropertyDescriptor;
	  objectGetOwnPropertyNames.f = objectGetOwnPropertyNamesExternal.f = $getOwnPropertyNames;
	  objectGetOwnPropertySymbols.f = $getOwnPropertySymbols;

	  if (descriptors) {
	    // https://github.com/tc39/proposal-Symbol-description
	    nativeDefineProperty$1($Symbol[PROTOTYPE$1], 'description', {
	      configurable: true,
	      get: function description() {
	        return getInternalState(this).description;
	      }
	    });
	    {
	      redefine(ObjectPrototype, 'propertyIsEnumerable', $propertyIsEnumerable, { unsafe: true });
	    }
	  }
	}

	if (!useSymbolAsUid) {
	  wrappedWellKnownSymbol.f = function (name) {
	    return wrap(wellKnownSymbol(name), name);
	  };
	}

	_export({ global: true, wrap: true, forced: !nativeSymbol, sham: !nativeSymbol }, {
	  Symbol: $Symbol
	});

	$forEach(objectKeys(WellKnownSymbolsStore$1), function (name) {
	  defineWellKnownSymbol(name);
	});

	_export({ target: SYMBOL, stat: true, forced: !nativeSymbol }, {
	  // `Symbol.for` method
	  // https://tc39.github.io/ecma262/#sec-symbol.for
	  'for': function (key) {
	    var string = String(key);
	    if (has(StringToSymbolRegistry, string)) return StringToSymbolRegistry[string];
	    var symbol = $Symbol(string);
	    StringToSymbolRegistry[string] = symbol;
	    SymbolToStringRegistry[symbol] = string;
	    return symbol;
	  },
	  // `Symbol.keyFor` method
	  // https://tc39.github.io/ecma262/#sec-symbol.keyfor
	  keyFor: function keyFor(sym) {
	    if (!isSymbol(sym)) throw TypeError(sym + ' is not a symbol');
	    if (has(SymbolToStringRegistry, sym)) return SymbolToStringRegistry[sym];
	  },
	  useSetter: function () { USE_SETTER = true; },
	  useSimple: function () { USE_SETTER = false; }
	});

	_export({ target: 'Object', stat: true, forced: !nativeSymbol, sham: !descriptors }, {
	  // `Object.create` method
	  // https://tc39.github.io/ecma262/#sec-object.create
	  create: $create,
	  // `Object.defineProperty` method
	  // https://tc39.github.io/ecma262/#sec-object.defineproperty
	  defineProperty: $defineProperty,
	  // `Object.defineProperties` method
	  // https://tc39.github.io/ecma262/#sec-object.defineproperties
	  defineProperties: $defineProperties,
	  // `Object.getOwnPropertyDescriptor` method
	  // https://tc39.github.io/ecma262/#sec-object.getownpropertydescriptors
	  getOwnPropertyDescriptor: $getOwnPropertyDescriptor
	});

	_export({ target: 'Object', stat: true, forced: !nativeSymbol }, {
	  // `Object.getOwnPropertyNames` method
	  // https://tc39.github.io/ecma262/#sec-object.getownpropertynames
	  getOwnPropertyNames: $getOwnPropertyNames,
	  // `Object.getOwnPropertySymbols` method
	  // https://tc39.github.io/ecma262/#sec-object.getownpropertysymbols
	  getOwnPropertySymbols: $getOwnPropertySymbols
	});

	// Chrome 38 and 39 `Object.getOwnPropertySymbols` fails on primitives
	// https://bugs.chromium.org/p/v8/issues/detail?id=3443
	_export({ target: 'Object', stat: true, forced: fails(function () { objectGetOwnPropertySymbols.f(1); }) }, {
	  getOwnPropertySymbols: function getOwnPropertySymbols(it) {
	    return objectGetOwnPropertySymbols.f(toObject(it));
	  }
	});

	// `JSON.stringify` method behavior with symbols
	// https://tc39.github.io/ecma262/#sec-json.stringify
	if ($stringify) {
	  var FORCED_JSON_STRINGIFY = !nativeSymbol || fails(function () {
	    var symbol = $Symbol();
	    // MS Edge converts symbol values to JSON as {}
	    return $stringify([symbol]) != '[null]'
	      // WebKit converts symbol values to JSON as null
	      || $stringify({ a: symbol }) != '{}'
	      // V8 throws on boxed symbols
	      || $stringify(Object(symbol)) != '{}';
	  });

	  _export({ target: 'JSON', stat: true, forced: FORCED_JSON_STRINGIFY }, {
	    // eslint-disable-next-line no-unused-vars
	    stringify: function stringify(it, replacer, space) {
	      var args = [it];
	      var index = 1;
	      var $replacer;
	      while (arguments.length > index) args.push(arguments[index++]);
	      $replacer = replacer;
	      if (!isObject(replacer) && it === undefined || isSymbol(it)) return; // IE8 returns string on undefined
	      if (!isArray(replacer)) replacer = function (key, value) {
	        if (typeof $replacer == 'function') value = $replacer.call(this, key, value);
	        if (!isSymbol(value)) return value;
	      };
	      args[1] = replacer;
	      return $stringify.apply(null, args);
	    }
	  });
	}

	// `Symbol.prototype[@@toPrimitive]` method
	// https://tc39.github.io/ecma262/#sec-symbol.prototype-@@toprimitive
	if (!$Symbol[PROTOTYPE$1][TO_PRIMITIVE]) {
	  createNonEnumerableProperty($Symbol[PROTOTYPE$1], TO_PRIMITIVE, $Symbol[PROTOTYPE$1].valueOf);
	}
	// `Symbol.prototype[@@toStringTag]` property
	// https://tc39.github.io/ecma262/#sec-symbol.prototype-@@tostringtag
	setToStringTag($Symbol, SYMBOL);

	hiddenKeys[HIDDEN] = true;

	var defineProperty$2 = objectDefineProperty.f;


	var NativeSymbol = global_1.Symbol;

	if (descriptors && typeof NativeSymbol == 'function' && (!('description' in NativeSymbol.prototype) ||
	  // Safari 12 bug
	  NativeSymbol().description !== undefined
	)) {
	  var EmptyStringDescriptionStore = {};
	  // wrap Symbol constructor for correct work with undefined description
	  var SymbolWrapper = function Symbol() {
	    var description = arguments.length < 1 || arguments[0] === undefined ? undefined : String(arguments[0]);
	    var result = this instanceof SymbolWrapper
	      ? new NativeSymbol(description)
	      // in Edge 13, String(Symbol(undefined)) === 'Symbol(undefined)'
	      : description === undefined ? NativeSymbol() : NativeSymbol(description);
	    if (description === '') EmptyStringDescriptionStore[result] = true;
	    return result;
	  };
	  copyConstructorProperties(SymbolWrapper, NativeSymbol);
	  var symbolPrototype = SymbolWrapper.prototype = NativeSymbol.prototype;
	  symbolPrototype.constructor = SymbolWrapper;

	  var symbolToString = symbolPrototype.toString;
	  var native = String(NativeSymbol('test')) == 'Symbol(test)';
	  var regexp = /^Symbol\((.*)\)[^)]+$/;
	  defineProperty$2(symbolPrototype, 'description', {
	    configurable: true,
	    get: function description() {
	      var symbol = isObject(this) ? this.valueOf() : this;
	      var string = symbolToString.call(symbol);
	      if (has(EmptyStringDescriptionStore, symbol)) return '';
	      var desc = native ? string.slice(7, -1) : string.replace(regexp, '$1');
	      return desc === '' ? undefined : desc;
	    }
	  });

	  _export({ global: true, forced: true }, {
	    Symbol: SymbolWrapper
	  });
	}

	// `Symbol.iterator` well-known symbol
	// https://tc39.github.io/ecma262/#sec-symbol.iterator
	defineWellKnownSymbol('iterator');

	var createProperty = function (object, key, value) {
	  var propertyKey = toPrimitive(key);
	  if (propertyKey in object) objectDefineProperty.f(object, propertyKey, createPropertyDescriptor(0, value));
	  else object[propertyKey] = value;
	};

	var userAgent = getBuiltIn('navigator', 'userAgent') || '';

	var process = global_1.process;
	var versions = process && process.versions;
	var v8 = versions && versions.v8;
	var match, version;

	if (v8) {
	  match = v8.split('.');
	  version = match[0] + match[1];
	} else if (userAgent) {
	  match = userAgent.match(/Edge\/(\d+)/);
	  if (!match || match[1] >= 74) {
	    match = userAgent.match(/Chrome\/(\d+)/);
	    if (match) version = match[1];
	  }
	}

	var v8Version = version && +version;

	var SPECIES$1 = wellKnownSymbol('species');

	var arrayMethodHasSpeciesSupport = function (METHOD_NAME) {
	  // We can't use this feature detection in V8 since it causes
	  // deoptimization and serious performance degradation
	  // https://github.com/zloirock/core-js/issues/677
	  return v8Version >= 51 || !fails(function () {
	    var array = [];
	    var constructor = array.constructor = {};
	    constructor[SPECIES$1] = function () {
	      return { foo: 1 };
	    };
	    return array[METHOD_NAME](Boolean).foo !== 1;
	  });
	};

	var IS_CONCAT_SPREADABLE = wellKnownSymbol('isConcatSpreadable');
	var MAX_SAFE_INTEGER = 0x1FFFFFFFFFFFFF;
	var MAXIMUM_ALLOWED_INDEX_EXCEEDED = 'Maximum allowed index exceeded';

	// We can't use this feature detection in V8 since it causes
	// deoptimization and serious performance degradation
	// https://github.com/zloirock/core-js/issues/679
	var IS_CONCAT_SPREADABLE_SUPPORT = v8Version >= 51 || !fails(function () {
	  var array = [];
	  array[IS_CONCAT_SPREADABLE] = false;
	  return array.concat()[0] !== array;
	});

	var SPECIES_SUPPORT = arrayMethodHasSpeciesSupport('concat');

	var isConcatSpreadable = function (O) {
	  if (!isObject(O)) return false;
	  var spreadable = O[IS_CONCAT_SPREADABLE];
	  return spreadable !== undefined ? !!spreadable : isArray(O);
	};

	var FORCED = !IS_CONCAT_SPREADABLE_SUPPORT || !SPECIES_SUPPORT;

	// `Array.prototype.concat` method
	// https://tc39.github.io/ecma262/#sec-array.prototype.concat
	// with adding support of @@isConcatSpreadable and @@species
	_export({ target: 'Array', proto: true, forced: FORCED }, {
	  concat: function concat(arg) { // eslint-disable-line no-unused-vars
	    var O = toObject(this);
	    var A = arraySpeciesCreate(O, 0);
	    var n = 0;
	    var i, k, length, len, E;
	    for (i = -1, length = arguments.length; i < length; i++) {
	      E = i === -1 ? O : arguments[i];
	      if (isConcatSpreadable(E)) {
	        len = toLength(E.length);
	        if (n + len > MAX_SAFE_INTEGER) throw TypeError(MAXIMUM_ALLOWED_INDEX_EXCEEDED);
	        for (k = 0; k < len; k++, n++) if (k in E) createProperty(A, n, E[k]);
	      } else {
	        if (n >= MAX_SAFE_INTEGER) throw TypeError(MAXIMUM_ALLOWED_INDEX_EXCEEDED);
	        createProperty(A, n++, E);
	      }
	    }
	    A.length = n;
	    return A;
	  }
	});

	var $filter = arrayIteration.filter;



	var HAS_SPECIES_SUPPORT = arrayMethodHasSpeciesSupport('filter');
	// Edge 14- issue
	var USES_TO_LENGTH = HAS_SPECIES_SUPPORT && !fails(function () {
	  [].filter.call({ length: -1, 0: 1 }, function (it) { throw it; });
	});

	// `Array.prototype.filter` method
	// https://tc39.github.io/ecma262/#sec-array.prototype.filter
	// with adding support of @@species
	_export({ target: 'Array', proto: true, forced: !HAS_SPECIES_SUPPORT || !USES_TO_LENGTH }, {
	  filter: function filter(callbackfn /* , thisArg */) {
	    return $filter(this, callbackfn, arguments.length > 1 ? arguments[1] : undefined);
	  }
	});

	var UNSCOPABLES = wellKnownSymbol('unscopables');
	var ArrayPrototype = Array.prototype;

	// Array.prototype[@@unscopables]
	// https://tc39.github.io/ecma262/#sec-array.prototype-@@unscopables
	if (ArrayPrototype[UNSCOPABLES] == undefined) {
	  objectDefineProperty.f(ArrayPrototype, UNSCOPABLES, {
	    configurable: true,
	    value: objectCreate(null)
	  });
	}

	// add a key to Array.prototype[@@unscopables]
	var addToUnscopables = function (key) {
	  ArrayPrototype[UNSCOPABLES][key] = true;
	};

	var $find = arrayIteration.find;


	var FIND = 'find';
	var SKIPS_HOLES = true;

	// Shouldn't skip holes
	if (FIND in []) Array(1)[FIND](function () { SKIPS_HOLES = false; });

	// `Array.prototype.find` method
	// https://tc39.github.io/ecma262/#sec-array.prototype.find
	_export({ target: 'Array', proto: true, forced: SKIPS_HOLES }, {
	  find: function find(callbackfn /* , that = undefined */) {
	    return $find(this, callbackfn, arguments.length > 1 ? arguments[1] : undefined);
	  }
	});

	// https://tc39.github.io/ecma262/#sec-array.prototype-@@unscopables
	addToUnscopables(FIND);

	var $findIndex = arrayIteration.findIndex;


	var FIND_INDEX = 'findIndex';
	var SKIPS_HOLES$1 = true;

	// Shouldn't skip holes
	if (FIND_INDEX in []) Array(1)[FIND_INDEX](function () { SKIPS_HOLES$1 = false; });

	// `Array.prototype.findIndex` method
	// https://tc39.github.io/ecma262/#sec-array.prototype.findindex
	_export({ target: 'Array', proto: true, forced: SKIPS_HOLES$1 }, {
	  findIndex: function findIndex(callbackfn /* , that = undefined */) {
	    return $findIndex(this, callbackfn, arguments.length > 1 ? arguments[1] : undefined);
	  }
	});

	// https://tc39.github.io/ecma262/#sec-array.prototype-@@unscopables
	addToUnscopables(FIND_INDEX);

	var $includes = arrayIncludes.includes;


	// `Array.prototype.includes` method
	// https://tc39.github.io/ecma262/#sec-array.prototype.includes
	_export({ target: 'Array', proto: true }, {
	  includes: function includes(el /* , fromIndex = 0 */) {
	    return $includes(this, el, arguments.length > 1 ? arguments[1] : undefined);
	  }
	});

	// https://tc39.github.io/ecma262/#sec-array.prototype-@@unscopables
	addToUnscopables('includes');

	var sloppyArrayMethod = function (METHOD_NAME, argument) {
	  var method = [][METHOD_NAME];
	  return !method || !fails(function () {
	    // eslint-disable-next-line no-useless-call,no-throw-literal
	    method.call(null, argument || function () { throw 1; }, 1);
	  });
	};

	var $indexOf = arrayIncludes.indexOf;


	var nativeIndexOf = [].indexOf;

	var NEGATIVE_ZERO = !!nativeIndexOf && 1 / [1].indexOf(1, -0) < 0;
	var SLOPPY_METHOD = sloppyArrayMethod('indexOf');

	// `Array.prototype.indexOf` method
	// https://tc39.github.io/ecma262/#sec-array.prototype.indexof
	_export({ target: 'Array', proto: true, forced: NEGATIVE_ZERO || SLOPPY_METHOD }, {
	  indexOf: function indexOf(searchElement /* , fromIndex = 0 */) {
	    return NEGATIVE_ZERO
	      // convert -0 to +0
	      ? nativeIndexOf.apply(this, arguments) || 0
	      : $indexOf(this, searchElement, arguments.length > 1 ? arguments[1] : undefined);
	  }
	});

	var correctPrototypeGetter = !fails(function () {
	  function F() { /* empty */ }
	  F.prototype.constructor = null;
	  return Object.getPrototypeOf(new F()) !== F.prototype;
	});

	var IE_PROTO$1 = sharedKey('IE_PROTO');
	var ObjectPrototype$1 = Object.prototype;

	// `Object.getPrototypeOf` method
	// https://tc39.github.io/ecma262/#sec-object.getprototypeof
	var objectGetPrototypeOf = correctPrototypeGetter ? Object.getPrototypeOf : function (O) {
	  O = toObject(O);
	  if (has(O, IE_PROTO$1)) return O[IE_PROTO$1];
	  if (typeof O.constructor == 'function' && O instanceof O.constructor) {
	    return O.constructor.prototype;
	  } return O instanceof Object ? ObjectPrototype$1 : null;
	};

	var ITERATOR = wellKnownSymbol('iterator');
	var BUGGY_SAFARI_ITERATORS = false;

	var returnThis = function () { return this; };

	// `%IteratorPrototype%` object
	// https://tc39.github.io/ecma262/#sec-%iteratorprototype%-object
	var IteratorPrototype, PrototypeOfArrayIteratorPrototype, arrayIterator;

	if ([].keys) {
	  arrayIterator = [].keys();
	  // Safari 8 has buggy iterators w/o `next`
	  if (!('next' in arrayIterator)) BUGGY_SAFARI_ITERATORS = true;
	  else {
	    PrototypeOfArrayIteratorPrototype = objectGetPrototypeOf(objectGetPrototypeOf(arrayIterator));
	    if (PrototypeOfArrayIteratorPrototype !== Object.prototype) IteratorPrototype = PrototypeOfArrayIteratorPrototype;
	  }
	}

	if (IteratorPrototype == undefined) IteratorPrototype = {};

	// 25.1.2.1.1 %IteratorPrototype%[@@iterator]()
	if ( !has(IteratorPrototype, ITERATOR)) {
	  createNonEnumerableProperty(IteratorPrototype, ITERATOR, returnThis);
	}

	var iteratorsCore = {
	  IteratorPrototype: IteratorPrototype,
	  BUGGY_SAFARI_ITERATORS: BUGGY_SAFARI_ITERATORS
	};

	var IteratorPrototype$1 = iteratorsCore.IteratorPrototype;

	var createIteratorConstructor = function (IteratorConstructor, NAME, next) {
	  var TO_STRING_TAG = NAME + ' Iterator';
	  IteratorConstructor.prototype = objectCreate(IteratorPrototype$1, { next: createPropertyDescriptor(1, next) });
	  setToStringTag(IteratorConstructor, TO_STRING_TAG, false);
	  return IteratorConstructor;
	};

	var aPossiblePrototype = function (it) {
	  if (!isObject(it) && it !== null) {
	    throw TypeError("Can't set " + String(it) + ' as a prototype');
	  } return it;
	};

	// `Object.setPrototypeOf` method
	// https://tc39.github.io/ecma262/#sec-object.setprototypeof
	// Works with __proto__ only. Old v8 can't work with null proto objects.
	/* eslint-disable no-proto */
	var objectSetPrototypeOf = Object.setPrototypeOf || ('__proto__' in {} ? function () {
	  var CORRECT_SETTER = false;
	  var test = {};
	  var setter;
	  try {
	    setter = Object.getOwnPropertyDescriptor(Object.prototype, '__proto__').set;
	    setter.call(test, []);
	    CORRECT_SETTER = test instanceof Array;
	  } catch (error) { /* empty */ }
	  return function setPrototypeOf(O, proto) {
	    anObject(O);
	    aPossiblePrototype(proto);
	    if (CORRECT_SETTER) setter.call(O, proto);
	    else O.__proto__ = proto;
	    return O;
	  };
	}() : undefined);

	var IteratorPrototype$2 = iteratorsCore.IteratorPrototype;
	var BUGGY_SAFARI_ITERATORS$1 = iteratorsCore.BUGGY_SAFARI_ITERATORS;
	var ITERATOR$1 = wellKnownSymbol('iterator');
	var KEYS = 'keys';
	var VALUES = 'values';
	var ENTRIES = 'entries';

	var returnThis$1 = function () { return this; };

	var defineIterator = function (Iterable, NAME, IteratorConstructor, next, DEFAULT, IS_SET, FORCED) {
	  createIteratorConstructor(IteratorConstructor, NAME, next);

	  var getIterationMethod = function (KIND) {
	    if (KIND === DEFAULT && defaultIterator) return defaultIterator;
	    if (!BUGGY_SAFARI_ITERATORS$1 && KIND in IterablePrototype) return IterablePrototype[KIND];
	    switch (KIND) {
	      case KEYS: return function keys() { return new IteratorConstructor(this, KIND); };
	      case VALUES: return function values() { return new IteratorConstructor(this, KIND); };
	      case ENTRIES: return function entries() { return new IteratorConstructor(this, KIND); };
	    } return function () { return new IteratorConstructor(this); };
	  };

	  var TO_STRING_TAG = NAME + ' Iterator';
	  var INCORRECT_VALUES_NAME = false;
	  var IterablePrototype = Iterable.prototype;
	  var nativeIterator = IterablePrototype[ITERATOR$1]
	    || IterablePrototype['@@iterator']
	    || DEFAULT && IterablePrototype[DEFAULT];
	  var defaultIterator = !BUGGY_SAFARI_ITERATORS$1 && nativeIterator || getIterationMethod(DEFAULT);
	  var anyNativeIterator = NAME == 'Array' ? IterablePrototype.entries || nativeIterator : nativeIterator;
	  var CurrentIteratorPrototype, methods, KEY;

	  // fix native
	  if (anyNativeIterator) {
	    CurrentIteratorPrototype = objectGetPrototypeOf(anyNativeIterator.call(new Iterable()));
	    if (IteratorPrototype$2 !== Object.prototype && CurrentIteratorPrototype.next) {
	      if ( objectGetPrototypeOf(CurrentIteratorPrototype) !== IteratorPrototype$2) {
	        if (objectSetPrototypeOf) {
	          objectSetPrototypeOf(CurrentIteratorPrototype, IteratorPrototype$2);
	        } else if (typeof CurrentIteratorPrototype[ITERATOR$1] != 'function') {
	          createNonEnumerableProperty(CurrentIteratorPrototype, ITERATOR$1, returnThis$1);
	        }
	      }
	      // Set @@toStringTag to native iterators
	      setToStringTag(CurrentIteratorPrototype, TO_STRING_TAG, true);
	    }
	  }

	  // fix Array#{values, @@iterator}.name in V8 / FF
	  if (DEFAULT == VALUES && nativeIterator && nativeIterator.name !== VALUES) {
	    INCORRECT_VALUES_NAME = true;
	    defaultIterator = function values() { return nativeIterator.call(this); };
	  }

	  // define iterator
	  if ( IterablePrototype[ITERATOR$1] !== defaultIterator) {
	    createNonEnumerableProperty(IterablePrototype, ITERATOR$1, defaultIterator);
	  }

	  // export additional methods
	  if (DEFAULT) {
	    methods = {
	      values: getIterationMethod(VALUES),
	      keys: IS_SET ? defaultIterator : getIterationMethod(KEYS),
	      entries: getIterationMethod(ENTRIES)
	    };
	    if (FORCED) for (KEY in methods) {
	      if (BUGGY_SAFARI_ITERATORS$1 || INCORRECT_VALUES_NAME || !(KEY in IterablePrototype)) {
	        redefine(IterablePrototype, KEY, methods[KEY]);
	      }
	    } else _export({ target: NAME, proto: true, forced: BUGGY_SAFARI_ITERATORS$1 || INCORRECT_VALUES_NAME }, methods);
	  }

	  return methods;
	};

	var ARRAY_ITERATOR = 'Array Iterator';
	var setInternalState$1 = internalState.set;
	var getInternalState$1 = internalState.getterFor(ARRAY_ITERATOR);

	// `Array.prototype.entries` method
	// https://tc39.github.io/ecma262/#sec-array.prototype.entries
	// `Array.prototype.keys` method
	// https://tc39.github.io/ecma262/#sec-array.prototype.keys
	// `Array.prototype.values` method
	// https://tc39.github.io/ecma262/#sec-array.prototype.values
	// `Array.prototype[@@iterator]` method
	// https://tc39.github.io/ecma262/#sec-array.prototype-@@iterator
	// `CreateArrayIterator` internal method
	// https://tc39.github.io/ecma262/#sec-createarrayiterator
	var es_array_iterator = defineIterator(Array, 'Array', function (iterated, kind) {
	  setInternalState$1(this, {
	    type: ARRAY_ITERATOR,
	    target: toIndexedObject(iterated), // target
	    index: 0,                          // next index
	    kind: kind                         // kind
	  });
	// `%ArrayIteratorPrototype%.next` method
	// https://tc39.github.io/ecma262/#sec-%arrayiteratorprototype%.next
	}, function () {
	  var state = getInternalState$1(this);
	  var target = state.target;
	  var kind = state.kind;
	  var index = state.index++;
	  if (!target || index >= target.length) {
	    state.target = undefined;
	    return { value: undefined, done: true };
	  }
	  if (kind == 'keys') return { value: index, done: false };
	  if (kind == 'values') return { value: target[index], done: false };
	  return { value: [index, target[index]], done: false };
	}, 'values');

	// https://tc39.github.io/ecma262/#sec-array.prototype-@@unscopables
	addToUnscopables('keys');
	addToUnscopables('values');
	addToUnscopables('entries');

	var nativeJoin = [].join;

	var ES3_STRINGS = indexedObject != Object;
	var SLOPPY_METHOD$1 = sloppyArrayMethod('join', ',');

	// `Array.prototype.join` method
	// https://tc39.github.io/ecma262/#sec-array.prototype.join
	_export({ target: 'Array', proto: true, forced: ES3_STRINGS || SLOPPY_METHOD$1 }, {
	  join: function join(separator) {
	    return nativeJoin.call(toIndexedObject(this), separator === undefined ? ',' : separator);
	  }
	});

	var $map = arrayIteration.map;



	var HAS_SPECIES_SUPPORT$1 = arrayMethodHasSpeciesSupport('map');
	// FF49- issue
	var USES_TO_LENGTH$1 = HAS_SPECIES_SUPPORT$1 && !fails(function () {
	  [].map.call({ length: -1, 0: 1 }, function (it) { throw it; });
	});

	// `Array.prototype.map` method
	// https://tc39.github.io/ecma262/#sec-array.prototype.map
	// with adding support of @@species
	_export({ target: 'Array', proto: true, forced: !HAS_SPECIES_SUPPORT$1 || !USES_TO_LENGTH$1 }, {
	  map: function map(callbackfn /* , thisArg */) {
	    return $map(this, callbackfn, arguments.length > 1 ? arguments[1] : undefined);
	  }
	});

	var nativeReverse = [].reverse;
	var test = [1, 2];

	// `Array.prototype.reverse` method
	// https://tc39.github.io/ecma262/#sec-array.prototype.reverse
	// fix for Safari 12.0 bug
	// https://bugs.webkit.org/show_bug.cgi?id=188794
	_export({ target: 'Array', proto: true, forced: String(test) === String(test.reverse()) }, {
	  reverse: function reverse() {
	    // eslint-disable-next-line no-self-assign
	    if (isArray(this)) this.length = this.length;
	    return nativeReverse.call(this);
	  }
	});

	var SPECIES$2 = wellKnownSymbol('species');
	var nativeSlice = [].slice;
	var max$1 = Math.max;

	// `Array.prototype.slice` method
	// https://tc39.github.io/ecma262/#sec-array.prototype.slice
	// fallback for not array-like ES3 strings and DOM objects
	_export({ target: 'Array', proto: true, forced: !arrayMethodHasSpeciesSupport('slice') }, {
	  slice: function slice(start, end) {
	    var O = toIndexedObject(this);
	    var length = toLength(O.length);
	    var k = toAbsoluteIndex(start, length);
	    var fin = toAbsoluteIndex(end === undefined ? length : end, length);
	    // inline `ArraySpeciesCreate` for usage native `Array#slice` where it's possible
	    var Constructor, result, n;
	    if (isArray(O)) {
	      Constructor = O.constructor;
	      // cross-realm fallback
	      if (typeof Constructor == 'function' && (Constructor === Array || isArray(Constructor.prototype))) {
	        Constructor = undefined;
	      } else if (isObject(Constructor)) {
	        Constructor = Constructor[SPECIES$2];
	        if (Constructor === null) Constructor = undefined;
	      }
	      if (Constructor === Array || Constructor === undefined) {
	        return nativeSlice.call(O, k, fin);
	      }
	    }
	    result = new (Constructor === undefined ? Array : Constructor)(max$1(fin - k, 0));
	    for (n = 0; k < fin; k++, n++) if (k in O) createProperty(result, n, O[k]);
	    result.length = n;
	    return result;
	  }
	});

	var test$1 = [];
	var nativeSort = test$1.sort;

	// IE8-
	var FAILS_ON_UNDEFINED = fails(function () {
	  test$1.sort(undefined);
	});
	// V8 bug
	var FAILS_ON_NULL = fails(function () {
	  test$1.sort(null);
	});
	// Old WebKit
	var SLOPPY_METHOD$2 = sloppyArrayMethod('sort');

	var FORCED$1 = FAILS_ON_UNDEFINED || !FAILS_ON_NULL || SLOPPY_METHOD$2;

	// `Array.prototype.sort` method
	// https://tc39.github.io/ecma262/#sec-array.prototype.sort
	_export({ target: 'Array', proto: true, forced: FORCED$1 }, {
	  sort: function sort(comparefn) {
	    return comparefn === undefined
	      ? nativeSort.call(toObject(this))
	      : nativeSort.call(toObject(this), aFunction$1(comparefn));
	  }
	});

	var max$2 = Math.max;
	var min$2 = Math.min;
	var MAX_SAFE_INTEGER$1 = 0x1FFFFFFFFFFFFF;
	var MAXIMUM_ALLOWED_LENGTH_EXCEEDED = 'Maximum allowed length exceeded';

	// `Array.prototype.splice` method
	// https://tc39.github.io/ecma262/#sec-array.prototype.splice
	// with adding support of @@species
	_export({ target: 'Array', proto: true, forced: !arrayMethodHasSpeciesSupport('splice') }, {
	  splice: function splice(start, deleteCount /* , ...items */) {
	    var O = toObject(this);
	    var len = toLength(O.length);
	    var actualStart = toAbsoluteIndex(start, len);
	    var argumentsLength = arguments.length;
	    var insertCount, actualDeleteCount, A, k, from, to;
	    if (argumentsLength === 0) {
	      insertCount = actualDeleteCount = 0;
	    } else if (argumentsLength === 1) {
	      insertCount = 0;
	      actualDeleteCount = len - actualStart;
	    } else {
	      insertCount = argumentsLength - 2;
	      actualDeleteCount = min$2(max$2(toInteger(deleteCount), 0), len - actualStart);
	    }
	    if (len + insertCount - actualDeleteCount > MAX_SAFE_INTEGER$1) {
	      throw TypeError(MAXIMUM_ALLOWED_LENGTH_EXCEEDED);
	    }
	    A = arraySpeciesCreate(O, actualDeleteCount);
	    for (k = 0; k < actualDeleteCount; k++) {
	      from = actualStart + k;
	      if (from in O) createProperty(A, k, O[from]);
	    }
	    A.length = actualDeleteCount;
	    if (insertCount < actualDeleteCount) {
	      for (k = actualStart; k < len - actualDeleteCount; k++) {
	        from = k + actualDeleteCount;
	        to = k + insertCount;
	        if (from in O) O[to] = O[from];
	        else delete O[to];
	      }
	      for (k = len; k > len - actualDeleteCount + insertCount; k--) delete O[k - 1];
	    } else if (insertCount > actualDeleteCount) {
	      for (k = len - actualDeleteCount; k > actualStart; k--) {
	        from = k + actualDeleteCount - 1;
	        to = k + insertCount - 1;
	        if (from in O) O[to] = O[from];
	        else delete O[to];
	      }
	    }
	    for (k = 0; k < insertCount; k++) {
	      O[k + actualStart] = arguments[k + 2];
	    }
	    O.length = len - actualDeleteCount + insertCount;
	    return A;
	  }
	});

	// makes subclassing work correct for wrapped built-ins
	var inheritIfRequired = function ($this, dummy, Wrapper) {
	  var NewTarget, NewTargetPrototype;
	  if (
	    // it can work only with native `setPrototypeOf`
	    objectSetPrototypeOf &&
	    // we haven't completely correct pre-ES6 way for getting `new.target`, so use this
	    typeof (NewTarget = dummy.constructor) == 'function' &&
	    NewTarget !== Wrapper &&
	    isObject(NewTargetPrototype = NewTarget.prototype) &&
	    NewTargetPrototype !== Wrapper.prototype
	  ) objectSetPrototypeOf($this, NewTargetPrototype);
	  return $this;
	};

	// a string of all valid unicode whitespaces
	// eslint-disable-next-line max-len
	var whitespaces = '\u0009\u000A\u000B\u000C\u000D\u0020\u00A0\u1680\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200A\u202F\u205F\u3000\u2028\u2029\uFEFF';

	var whitespace = '[' + whitespaces + ']';
	var ltrim = RegExp('^' + whitespace + whitespace + '*');
	var rtrim = RegExp(whitespace + whitespace + '*$');

	// `String.prototype.{ trim, trimStart, trimEnd, trimLeft, trimRight }` methods implementation
	var createMethod$2 = function (TYPE) {
	  return function ($this) {
	    var string = String(requireObjectCoercible($this));
	    if (TYPE & 1) string = string.replace(ltrim, '');
	    if (TYPE & 2) string = string.replace(rtrim, '');
	    return string;
	  };
	};

	var stringTrim = {
	  // `String.prototype.{ trimLeft, trimStart }` methods
	  // https://tc39.github.io/ecma262/#sec-string.prototype.trimstart
	  start: createMethod$2(1),
	  // `String.prototype.{ trimRight, trimEnd }` methods
	  // https://tc39.github.io/ecma262/#sec-string.prototype.trimend
	  end: createMethod$2(2),
	  // `String.prototype.trim` method
	  // https://tc39.github.io/ecma262/#sec-string.prototype.trim
	  trim: createMethod$2(3)
	};

	var getOwnPropertyNames = objectGetOwnPropertyNames.f;
	var getOwnPropertyDescriptor$2 = objectGetOwnPropertyDescriptor.f;
	var defineProperty$3 = objectDefineProperty.f;
	var trim = stringTrim.trim;

	var NUMBER = 'Number';
	var NativeNumber = global_1[NUMBER];
	var NumberPrototype = NativeNumber.prototype;

	// Opera ~12 has broken Object#toString
	var BROKEN_CLASSOF = classofRaw(objectCreate(NumberPrototype)) == NUMBER;

	// `ToNumber` abstract operation
	// https://tc39.github.io/ecma262/#sec-tonumber
	var toNumber = function (argument) {
	  var it = toPrimitive(argument, false);
	  var first, third, radix, maxCode, digits, length, index, code;
	  if (typeof it == 'string' && it.length > 2) {
	    it = trim(it);
	    first = it.charCodeAt(0);
	    if (first === 43 || first === 45) {
	      third = it.charCodeAt(2);
	      if (third === 88 || third === 120) return NaN; // Number('+0x1') should be NaN, old V8 fix
	    } else if (first === 48) {
	      switch (it.charCodeAt(1)) {
	        case 66: case 98: radix = 2; maxCode = 49; break; // fast equal of /^0b[01]+$/i
	        case 79: case 111: radix = 8; maxCode = 55; break; // fast equal of /^0o[0-7]+$/i
	        default: return +it;
	      }
	      digits = it.slice(2);
	      length = digits.length;
	      for (index = 0; index < length; index++) {
	        code = digits.charCodeAt(index);
	        // parseInt parses a string to a first unavailable symbol
	        // but ToNumber should return NaN if a string contains unavailable symbols
	        if (code < 48 || code > maxCode) return NaN;
	      } return parseInt(digits, radix);
	    }
	  } return +it;
	};

	// `Number` constructor
	// https://tc39.github.io/ecma262/#sec-number-constructor
	if (isForced_1(NUMBER, !NativeNumber(' 0o1') || !NativeNumber('0b1') || NativeNumber('+0x1'))) {
	  var NumberWrapper = function Number(value) {
	    var it = arguments.length < 1 ? 0 : value;
	    var dummy = this;
	    return dummy instanceof NumberWrapper
	      // check on 1..constructor(foo) case
	      && (BROKEN_CLASSOF ? fails(function () { NumberPrototype.valueOf.call(dummy); }) : classofRaw(dummy) != NUMBER)
	        ? inheritIfRequired(new NativeNumber(toNumber(it)), dummy, NumberWrapper) : toNumber(it);
	  };
	  for (var keys$1 = descriptors ? getOwnPropertyNames(NativeNumber) : (
	    // ES3:
	    'MAX_VALUE,MIN_VALUE,NaN,NEGATIVE_INFINITY,POSITIVE_INFINITY,' +
	    // ES2015 (in case, if modules with ES2015 Number statics required before):
	    'EPSILON,isFinite,isInteger,isNaN,isSafeInteger,MAX_SAFE_INTEGER,' +
	    'MIN_SAFE_INTEGER,parseFloat,parseInt,isInteger'
	  ).split(','), j = 0, key; keys$1.length > j; j++) {
	    if (has(NativeNumber, key = keys$1[j]) && !has(NumberWrapper, key)) {
	      defineProperty$3(NumberWrapper, key, getOwnPropertyDescriptor$2(NativeNumber, key));
	    }
	  }
	  NumberWrapper.prototype = NumberPrototype;
	  NumberPrototype.constructor = NumberWrapper;
	  redefine(global_1, NUMBER, NumberWrapper);
	}

	var nativeAssign = Object.assign;
	var defineProperty$4 = Object.defineProperty;

	// `Object.assign` method
	// https://tc39.github.io/ecma262/#sec-object.assign
	var objectAssign = !nativeAssign || fails(function () {
	  // should have correct order of operations (Edge bug)
	  if (descriptors && nativeAssign({ b: 1 }, nativeAssign(defineProperty$4({}, 'a', {
	    enumerable: true,
	    get: function () {
	      defineProperty$4(this, 'b', {
	        value: 3,
	        enumerable: false
	      });
	    }
	  }), { b: 2 })).b !== 1) return true;
	  // should work with symbols and should have deterministic property order (V8 bug)
	  var A = {};
	  var B = {};
	  // eslint-disable-next-line no-undef
	  var symbol = Symbol();
	  var alphabet = 'abcdefghijklmnopqrst';
	  A[symbol] = 7;
	  alphabet.split('').forEach(function (chr) { B[chr] = chr; });
	  return nativeAssign({}, A)[symbol] != 7 || objectKeys(nativeAssign({}, B)).join('') != alphabet;
	}) ? function assign(target, source) { // eslint-disable-line no-unused-vars
	  var T = toObject(target);
	  var argumentsLength = arguments.length;
	  var index = 1;
	  var getOwnPropertySymbols = objectGetOwnPropertySymbols.f;
	  var propertyIsEnumerable = objectPropertyIsEnumerable.f;
	  while (argumentsLength > index) {
	    var S = indexedObject(arguments[index++]);
	    var keys = getOwnPropertySymbols ? objectKeys(S).concat(getOwnPropertySymbols(S)) : objectKeys(S);
	    var length = keys.length;
	    var j = 0;
	    var key;
	    while (length > j) {
	      key = keys[j++];
	      if (!descriptors || propertyIsEnumerable.call(S, key)) T[key] = S[key];
	    }
	  } return T;
	} : nativeAssign;

	// `Object.assign` method
	// https://tc39.github.io/ecma262/#sec-object.assign
	_export({ target: 'Object', stat: true, forced: Object.assign !== objectAssign }, {
	  assign: objectAssign
	});

	var propertyIsEnumerable = objectPropertyIsEnumerable.f;

	// `Object.{ entries, values }` methods implementation
	var createMethod$3 = function (TO_ENTRIES) {
	  return function (it) {
	    var O = toIndexedObject(it);
	    var keys = objectKeys(O);
	    var length = keys.length;
	    var i = 0;
	    var result = [];
	    var key;
	    while (length > i) {
	      key = keys[i++];
	      if (!descriptors || propertyIsEnumerable.call(O, key)) {
	        result.push(TO_ENTRIES ? [key, O[key]] : O[key]);
	      }
	    }
	    return result;
	  };
	};

	var objectToArray = {
	  // `Object.entries` method
	  // https://tc39.github.io/ecma262/#sec-object.entries
	  entries: createMethod$3(true),
	  // `Object.values` method
	  // https://tc39.github.io/ecma262/#sec-object.values
	  values: createMethod$3(false)
	};

	var $entries = objectToArray.entries;

	// `Object.entries` method
	// https://tc39.github.io/ecma262/#sec-object.entries
	_export({ target: 'Object', stat: true }, {
	  entries: function entries(O) {
	    return $entries(O);
	  }
	});

	var TO_STRING_TAG$1 = wellKnownSymbol('toStringTag');
	var test$2 = {};

	test$2[TO_STRING_TAG$1] = 'z';

	var toStringTagSupport = String(test$2) === '[object z]';

	var TO_STRING_TAG$2 = wellKnownSymbol('toStringTag');
	// ES3 wrong here
	var CORRECT_ARGUMENTS = classofRaw(function () { return arguments; }()) == 'Arguments';

	// fallback for IE11 Script Access Denied error
	var tryGet = function (it, key) {
	  try {
	    return it[key];
	  } catch (error) { /* empty */ }
	};

	// getting tag from ES6+ `Object.prototype.toString`
	var classof = toStringTagSupport ? classofRaw : function (it) {
	  var O, tag, result;
	  return it === undefined ? 'Undefined' : it === null ? 'Null'
	    // @@toStringTag case
	    : typeof (tag = tryGet(O = Object(it), TO_STRING_TAG$2)) == 'string' ? tag
	    // builtinTag case
	    : CORRECT_ARGUMENTS ? classofRaw(O)
	    // ES3 arguments fallback
	    : (result = classofRaw(O)) == 'Object' && typeof O.callee == 'function' ? 'Arguments' : result;
	};

	// `Object.prototype.toString` method implementation
	// https://tc39.github.io/ecma262/#sec-object.prototype.tostring
	var objectToString = toStringTagSupport ? {}.toString : function toString() {
	  return '[object ' + classof(this) + ']';
	};

	// `Object.prototype.toString` method
	// https://tc39.github.io/ecma262/#sec-object.prototype.tostring
	if (!toStringTagSupport) {
	  redefine(Object.prototype, 'toString', objectToString, { unsafe: true });
	}

	var trim$1 = stringTrim.trim;


	var nativeParseFloat = global_1.parseFloat;
	var FORCED$2 = 1 / nativeParseFloat(whitespaces + '-0') !== -Infinity;

	// `parseFloat` method
	// https://tc39.github.io/ecma262/#sec-parsefloat-string
	var _parseFloat = FORCED$2 ? function parseFloat(string) {
	  var trimmedString = trim$1(String(string));
	  var result = nativeParseFloat(trimmedString);
	  return result === 0 && trimmedString.charAt(0) == '-' ? -0 : result;
	} : nativeParseFloat;

	// `parseFloat` method
	// https://tc39.github.io/ecma262/#sec-parsefloat-string
	_export({ global: true, forced: parseFloat != _parseFloat }, {
	  parseFloat: _parseFloat
	});

	var trim$2 = stringTrim.trim;


	var nativeParseInt = global_1.parseInt;
	var hex = /^[+-]?0[Xx]/;
	var FORCED$3 = nativeParseInt(whitespaces + '08') !== 8 || nativeParseInt(whitespaces + '0x16') !== 22;

	// `parseInt` method
	// https://tc39.github.io/ecma262/#sec-parseint-string-radix
	var _parseInt = FORCED$3 ? function parseInt(string, radix) {
	  var S = trim$2(String(string));
	  return nativeParseInt(S, (radix >>> 0) || (hex.test(S) ? 16 : 10));
	} : nativeParseInt;

	// `parseInt` method
	// https://tc39.github.io/ecma262/#sec-parseint-string-radix
	_export({ global: true, forced: parseInt != _parseInt }, {
	  parseInt: _parseInt
	});

	// `RegExp.prototype.flags` getter implementation
	// https://tc39.github.io/ecma262/#sec-get-regexp.prototype.flags
	var regexpFlags = function () {
	  var that = anObject(this);
	  var result = '';
	  if (that.global) result += 'g';
	  if (that.ignoreCase) result += 'i';
	  if (that.multiline) result += 'm';
	  if (that.dotAll) result += 's';
	  if (that.unicode) result += 'u';
	  if (that.sticky) result += 'y';
	  return result;
	};

	// babel-minify transpiles RegExp('a', 'y') -> /a/y and it causes SyntaxError,
	// so we use an intermediate function.
	function RE(s, f) {
	  return RegExp(s, f);
	}

	var UNSUPPORTED_Y = fails(function () {
	  // babel-minify transpiles RegExp('a', 'y') -> /a/y and it causes SyntaxError
	  var re = RE('a', 'y');
	  re.lastIndex = 2;
	  return re.exec('abcd') != null;
	});

	var BROKEN_CARET = fails(function () {
	  // https://bugzilla.mozilla.org/show_bug.cgi?id=773687
	  var re = RE('^r', 'gy');
	  re.lastIndex = 2;
	  return re.exec('str') != null;
	});

	var regexpStickyHelpers = {
		UNSUPPORTED_Y: UNSUPPORTED_Y,
		BROKEN_CARET: BROKEN_CARET
	};

	var nativeExec = RegExp.prototype.exec;
	// This always refers to the native implementation, because the
	// String#replace polyfill uses ./fix-regexp-well-known-symbol-logic.js,
	// which loads this file before patching the method.
	var nativeReplace = String.prototype.replace;

	var patchedExec = nativeExec;

	var UPDATES_LAST_INDEX_WRONG = (function () {
	  var re1 = /a/;
	  var re2 = /b*/g;
	  nativeExec.call(re1, 'a');
	  nativeExec.call(re2, 'a');
	  return re1.lastIndex !== 0 || re2.lastIndex !== 0;
	})();

	var UNSUPPORTED_Y$1 = regexpStickyHelpers.UNSUPPORTED_Y || regexpStickyHelpers.BROKEN_CARET;

	// nonparticipating capturing group, copied from es5-shim's String#split patch.
	var NPCG_INCLUDED = /()??/.exec('')[1] !== undefined;

	var PATCH = UPDATES_LAST_INDEX_WRONG || NPCG_INCLUDED || UNSUPPORTED_Y$1;

	if (PATCH) {
	  patchedExec = function exec(str) {
	    var re = this;
	    var lastIndex, reCopy, match, i;
	    var sticky = UNSUPPORTED_Y$1 && re.sticky;
	    var flags = regexpFlags.call(re);
	    var source = re.source;
	    var charsAdded = 0;
	    var strCopy = str;

	    if (sticky) {
	      flags = flags.replace('y', '');
	      if (flags.indexOf('g') === -1) {
	        flags += 'g';
	      }

	      strCopy = String(str).slice(re.lastIndex);
	      // Support anchored sticky behavior.
	      if (re.lastIndex > 0 && (!re.multiline || re.multiline && str[re.lastIndex - 1] !== '\n')) {
	        source = '(?: ' + source + ')';
	        strCopy = ' ' + strCopy;
	        charsAdded++;
	      }
	      // ^(? + rx + ) is needed, in combination with some str slicing, to
	      // simulate the 'y' flag.
	      reCopy = new RegExp('^(?:' + source + ')', flags);
	    }

	    if (NPCG_INCLUDED) {
	      reCopy = new RegExp('^' + source + '$(?!\\s)', flags);
	    }
	    if (UPDATES_LAST_INDEX_WRONG) lastIndex = re.lastIndex;

	    match = nativeExec.call(sticky ? reCopy : re, strCopy);

	    if (sticky) {
	      if (match) {
	        match.input = match.input.slice(charsAdded);
	        match[0] = match[0].slice(charsAdded);
	        match.index = re.lastIndex;
	        re.lastIndex += match[0].length;
	      } else re.lastIndex = 0;
	    } else if (UPDATES_LAST_INDEX_WRONG && match) {
	      re.lastIndex = re.global ? match.index + match[0].length : lastIndex;
	    }
	    if (NPCG_INCLUDED && match && match.length > 1) {
	      // Fix browsers whose `exec` methods don't consistently return `undefined`
	      // for NPCG, like IE8. NOTE: This doesn' work for /(.?)?/
	      nativeReplace.call(match[0], reCopy, function () {
	        for (i = 1; i < arguments.length - 2; i++) {
	          if (arguments[i] === undefined) match[i] = undefined;
	        }
	      });
	    }

	    return match;
	  };
	}

	var regexpExec = patchedExec;

	_export({ target: 'RegExp', proto: true, forced: /./.exec !== regexpExec }, {
	  exec: regexpExec
	});

	var TO_STRING = 'toString';
	var RegExpPrototype = RegExp.prototype;
	var nativeToString = RegExpPrototype[TO_STRING];

	var NOT_GENERIC = fails(function () { return nativeToString.call({ source: 'a', flags: 'b' }) != '/a/b'; });
	// FF44- RegExp#toString has a wrong name
	var INCORRECT_NAME = nativeToString.name != TO_STRING;

	// `RegExp.prototype.toString` method
	// https://tc39.github.io/ecma262/#sec-regexp.prototype.tostring
	if (NOT_GENERIC || INCORRECT_NAME) {
	  redefine(RegExp.prototype, TO_STRING, function toString() {
	    var R = anObject(this);
	    var p = String(R.source);
	    var rf = R.flags;
	    var f = String(rf === undefined && R instanceof RegExp && !('flags' in RegExpPrototype) ? regexpFlags.call(R) : rf);
	    return '/' + p + '/' + f;
	  }, { unsafe: true });
	}

	var MATCH = wellKnownSymbol('match');

	// `IsRegExp` abstract operation
	// https://tc39.github.io/ecma262/#sec-isregexp
	var isRegexp = function (it) {
	  var isRegExp;
	  return isObject(it) && ((isRegExp = it[MATCH]) !== undefined ? !!isRegExp : classofRaw(it) == 'RegExp');
	};

	var notARegexp = function (it) {
	  if (isRegexp(it)) {
	    throw TypeError("The method doesn't accept regular expressions");
	  } return it;
	};

	var MATCH$1 = wellKnownSymbol('match');

	var correctIsRegexpLogic = function (METHOD_NAME) {
	  var regexp = /./;
	  try {
	    '/./'[METHOD_NAME](regexp);
	  } catch (e) {
	    try {
	      regexp[MATCH$1] = false;
	      return '/./'[METHOD_NAME](regexp);
	    } catch (f) { /* empty */ }
	  } return false;
	};

	// `String.prototype.includes` method
	// https://tc39.github.io/ecma262/#sec-string.prototype.includes
	_export({ target: 'String', proto: true, forced: !correctIsRegexpLogic('includes') }, {
	  includes: function includes(searchString /* , position = 0 */) {
	    return !!~String(requireObjectCoercible(this))
	      .indexOf(notARegexp(searchString), arguments.length > 1 ? arguments[1] : undefined);
	  }
	});

	// `String.prototype.{ codePointAt, at }` methods implementation
	var createMethod$4 = function (CONVERT_TO_STRING) {
	  return function ($this, pos) {
	    var S = String(requireObjectCoercible($this));
	    var position = toInteger(pos);
	    var size = S.length;
	    var first, second;
	    if (position < 0 || position >= size) return CONVERT_TO_STRING ? '' : undefined;
	    first = S.charCodeAt(position);
	    return first < 0xD800 || first > 0xDBFF || position + 1 === size
	      || (second = S.charCodeAt(position + 1)) < 0xDC00 || second > 0xDFFF
	        ? CONVERT_TO_STRING ? S.charAt(position) : first
	        : CONVERT_TO_STRING ? S.slice(position, position + 2) : (first - 0xD800 << 10) + (second - 0xDC00) + 0x10000;
	  };
	};

	var stringMultibyte = {
	  // `String.prototype.codePointAt` method
	  // https://tc39.github.io/ecma262/#sec-string.prototype.codepointat
	  codeAt: createMethod$4(false),
	  // `String.prototype.at` method
	  // https://github.com/mathiasbynens/String.prototype.at
	  charAt: createMethod$4(true)
	};

	var charAt = stringMultibyte.charAt;



	var STRING_ITERATOR = 'String Iterator';
	var setInternalState$2 = internalState.set;
	var getInternalState$2 = internalState.getterFor(STRING_ITERATOR);

	// `String.prototype[@@iterator]` method
	// https://tc39.github.io/ecma262/#sec-string.prototype-@@iterator
	defineIterator(String, 'String', function (iterated) {
	  setInternalState$2(this, {
	    type: STRING_ITERATOR,
	    string: String(iterated),
	    index: 0
	  });
	// `%StringIteratorPrototype%.next` method
	// https://tc39.github.io/ecma262/#sec-%stringiteratorprototype%.next
	}, function next() {
	  var state = getInternalState$2(this);
	  var string = state.string;
	  var index = state.index;
	  var point;
	  if (index >= string.length) return { value: undefined, done: true };
	  point = charAt(string, index);
	  state.index += point.length;
	  return { value: point, done: false };
	});

	var SPECIES$3 = wellKnownSymbol('species');

	var REPLACE_SUPPORTS_NAMED_GROUPS = !fails(function () {
	  // #replace needs built-in support for named groups.
	  // #match works fine because it just return the exec results, even if it has
	  // a "grops" property.
	  var re = /./;
	  re.exec = function () {
	    var result = [];
	    result.groups = { a: '7' };
	    return result;
	  };
	  return ''.replace(re, '$<a>') !== '7';
	});

	// IE <= 11 replaces $0 with the whole match, as if it was $&
	// https://stackoverflow.com/questions/6024666/getting-ie-to-replace-a-regex-with-the-literal-string-0
	var REPLACE_KEEPS_$0 = (function () {
	  return 'a'.replace(/./, '$0') === '$0';
	})();

	// Chrome 51 has a buggy "split" implementation when RegExp#exec !== nativeExec
	// Weex JS has frozen built-in prototypes, so use try / catch wrapper
	var SPLIT_WORKS_WITH_OVERWRITTEN_EXEC = !fails(function () {
	  var re = /(?:)/;
	  var originalExec = re.exec;
	  re.exec = function () { return originalExec.apply(this, arguments); };
	  var result = 'ab'.split(re);
	  return result.length !== 2 || result[0] !== 'a' || result[1] !== 'b';
	});

	var fixRegexpWellKnownSymbolLogic = function (KEY, length, exec, sham) {
	  var SYMBOL = wellKnownSymbol(KEY);

	  var DELEGATES_TO_SYMBOL = !fails(function () {
	    // String methods call symbol-named RegEp methods
	    var O = {};
	    O[SYMBOL] = function () { return 7; };
	    return ''[KEY](O) != 7;
	  });

	  var DELEGATES_TO_EXEC = DELEGATES_TO_SYMBOL && !fails(function () {
	    // Symbol-named RegExp methods call .exec
	    var execCalled = false;
	    var re = /a/;

	    if (KEY === 'split') {
	      // We can't use real regex here since it causes deoptimization
	      // and serious performance degradation in V8
	      // https://github.com/zloirock/core-js/issues/306
	      re = {};
	      // RegExp[@@split] doesn't call the regex's exec method, but first creates
	      // a new one. We need to return the patched regex when creating the new one.
	      re.constructor = {};
	      re.constructor[SPECIES$3] = function () { return re; };
	      re.flags = '';
	      re[SYMBOL] = /./[SYMBOL];
	    }

	    re.exec = function () { execCalled = true; return null; };

	    re[SYMBOL]('');
	    return !execCalled;
	  });

	  if (
	    !DELEGATES_TO_SYMBOL ||
	    !DELEGATES_TO_EXEC ||
	    (KEY === 'replace' && !(REPLACE_SUPPORTS_NAMED_GROUPS && REPLACE_KEEPS_$0)) ||
	    (KEY === 'split' && !SPLIT_WORKS_WITH_OVERWRITTEN_EXEC)
	  ) {
	    var nativeRegExpMethod = /./[SYMBOL];
	    var methods = exec(SYMBOL, ''[KEY], function (nativeMethod, regexp, str, arg2, forceStringMethod) {
	      if (regexp.exec === regexpExec) {
	        if (DELEGATES_TO_SYMBOL && !forceStringMethod) {
	          // The native String method already delegates to @@method (this
	          // polyfilled function), leasing to infinite recursion.
	          // We avoid it by directly calling the native @@method method.
	          return { done: true, value: nativeRegExpMethod.call(regexp, str, arg2) };
	        }
	        return { done: true, value: nativeMethod.call(str, regexp, arg2) };
	      }
	      return { done: false };
	    }, { REPLACE_KEEPS_$0: REPLACE_KEEPS_$0 });
	    var stringMethod = methods[0];
	    var regexMethod = methods[1];

	    redefine(String.prototype, KEY, stringMethod);
	    redefine(RegExp.prototype, SYMBOL, length == 2
	      // 21.2.5.8 RegExp.prototype[@@replace](string, replaceValue)
	      // 21.2.5.11 RegExp.prototype[@@split](string, limit)
	      ? function (string, arg) { return regexMethod.call(string, this, arg); }
	      // 21.2.5.6 RegExp.prototype[@@match](string)
	      // 21.2.5.9 RegExp.prototype[@@search](string)
	      : function (string) { return regexMethod.call(string, this); }
	    );
	  }

	  if (sham) createNonEnumerableProperty(RegExp.prototype[SYMBOL], 'sham', true);
	};

	var charAt$1 = stringMultibyte.charAt;

	// `AdvanceStringIndex` abstract operation
	// https://tc39.github.io/ecma262/#sec-advancestringindex
	var advanceStringIndex = function (S, index, unicode) {
	  return index + (unicode ? charAt$1(S, index).length : 1);
	};

	// `RegExpExec` abstract operation
	// https://tc39.github.io/ecma262/#sec-regexpexec
	var regexpExecAbstract = function (R, S) {
	  var exec = R.exec;
	  if (typeof exec === 'function') {
	    var result = exec.call(R, S);
	    if (typeof result !== 'object') {
	      throw TypeError('RegExp exec method returned something other than an Object or null');
	    }
	    return result;
	  }

	  if (classofRaw(R) !== 'RegExp') {
	    throw TypeError('RegExp#exec called on incompatible receiver');
	  }

	  return regexpExec.call(R, S);
	};

	var max$3 = Math.max;
	var min$3 = Math.min;
	var floor$1 = Math.floor;
	var SUBSTITUTION_SYMBOLS = /\$([$&'`]|\d\d?|<[^>]*>)/g;
	var SUBSTITUTION_SYMBOLS_NO_NAMED = /\$([$&'`]|\d\d?)/g;

	var maybeToString = function (it) {
	  return it === undefined ? it : String(it);
	};

	// @@replace logic
	fixRegexpWellKnownSymbolLogic('replace', 2, function (REPLACE, nativeReplace, maybeCallNative, reason) {
	  return [
	    // `String.prototype.replace` method
	    // https://tc39.github.io/ecma262/#sec-string.prototype.replace
	    function replace(searchValue, replaceValue) {
	      var O = requireObjectCoercible(this);
	      var replacer = searchValue == undefined ? undefined : searchValue[REPLACE];
	      return replacer !== undefined
	        ? replacer.call(searchValue, O, replaceValue)
	        : nativeReplace.call(String(O), searchValue, replaceValue);
	    },
	    // `RegExp.prototype[@@replace]` method
	    // https://tc39.github.io/ecma262/#sec-regexp.prototype-@@replace
	    function (regexp, replaceValue) {
	      if (reason.REPLACE_KEEPS_$0 || (typeof replaceValue === 'string' && replaceValue.indexOf('$0') === -1)) {
	        var res = maybeCallNative(nativeReplace, regexp, this, replaceValue);
	        if (res.done) return res.value;
	      }

	      var rx = anObject(regexp);
	      var S = String(this);

	      var functionalReplace = typeof replaceValue === 'function';
	      if (!functionalReplace) replaceValue = String(replaceValue);

	      var global = rx.global;
	      if (global) {
	        var fullUnicode = rx.unicode;
	        rx.lastIndex = 0;
	      }
	      var results = [];
	      while (true) {
	        var result = regexpExecAbstract(rx, S);
	        if (result === null) break;

	        results.push(result);
	        if (!global) break;

	        var matchStr = String(result[0]);
	        if (matchStr === '') rx.lastIndex = advanceStringIndex(S, toLength(rx.lastIndex), fullUnicode);
	      }

	      var accumulatedResult = '';
	      var nextSourcePosition = 0;
	      for (var i = 0; i < results.length; i++) {
	        result = results[i];

	        var matched = String(result[0]);
	        var position = max$3(min$3(toInteger(result.index), S.length), 0);
	        var captures = [];
	        // NOTE: This is equivalent to
	        //   captures = result.slice(1).map(maybeToString)
	        // but for some reason `nativeSlice.call(result, 1, result.length)` (called in
	        // the slice polyfill when slicing native arrays) "doesn't work" in safari 9 and
	        // causes a crash (https://pastebin.com/N21QzeQA) when trying to debug it.
	        for (var j = 1; j < result.length; j++) captures.push(maybeToString(result[j]));
	        var namedCaptures = result.groups;
	        if (functionalReplace) {
	          var replacerArgs = [matched].concat(captures, position, S);
	          if (namedCaptures !== undefined) replacerArgs.push(namedCaptures);
	          var replacement = String(replaceValue.apply(undefined, replacerArgs));
	        } else {
	          replacement = getSubstitution(matched, S, position, captures, namedCaptures, replaceValue);
	        }
	        if (position >= nextSourcePosition) {
	          accumulatedResult += S.slice(nextSourcePosition, position) + replacement;
	          nextSourcePosition = position + matched.length;
	        }
	      }
	      return accumulatedResult + S.slice(nextSourcePosition);
	    }
	  ];

	  // https://tc39.github.io/ecma262/#sec-getsubstitution
	  function getSubstitution(matched, str, position, captures, namedCaptures, replacement) {
	    var tailPos = position + matched.length;
	    var m = captures.length;
	    var symbols = SUBSTITUTION_SYMBOLS_NO_NAMED;
	    if (namedCaptures !== undefined) {
	      namedCaptures = toObject(namedCaptures);
	      symbols = SUBSTITUTION_SYMBOLS;
	    }
	    return nativeReplace.call(replacement, symbols, function (match, ch) {
	      var capture;
	      switch (ch.charAt(0)) {
	        case '$': return '$';
	        case '&': return matched;
	        case '`': return str.slice(0, position);
	        case "'": return str.slice(tailPos);
	        case '<':
	          capture = namedCaptures[ch.slice(1, -1)];
	          break;
	        default: // \d\d?
	          var n = +ch;
	          if (n === 0) return match;
	          if (n > m) {
	            var f = floor$1(n / 10);
	            if (f === 0) return match;
	            if (f <= m) return captures[f - 1] === undefined ? ch.charAt(1) : captures[f - 1] + ch.charAt(1);
	            return match;
	          }
	          capture = captures[n - 1];
	      }
	      return capture === undefined ? '' : capture;
	    });
	  }
	});

	// `SameValue` abstract operation
	// https://tc39.github.io/ecma262/#sec-samevalue
	var sameValue = Object.is || function is(x, y) {
	  // eslint-disable-next-line no-self-compare
	  return x === y ? x !== 0 || 1 / x === 1 / y : x != x && y != y;
	};

	// @@search logic
	fixRegexpWellKnownSymbolLogic('search', 1, function (SEARCH, nativeSearch, maybeCallNative) {
	  return [
	    // `String.prototype.search` method
	    // https://tc39.github.io/ecma262/#sec-string.prototype.search
	    function search(regexp) {
	      var O = requireObjectCoercible(this);
	      var searcher = regexp == undefined ? undefined : regexp[SEARCH];
	      return searcher !== undefined ? searcher.call(regexp, O) : new RegExp(regexp)[SEARCH](String(O));
	    },
	    // `RegExp.prototype[@@search]` method
	    // https://tc39.github.io/ecma262/#sec-regexp.prototype-@@search
	    function (regexp) {
	      var res = maybeCallNative(nativeSearch, regexp, this);
	      if (res.done) return res.value;

	      var rx = anObject(regexp);
	      var S = String(this);

	      var previousLastIndex = rx.lastIndex;
	      if (!sameValue(previousLastIndex, 0)) rx.lastIndex = 0;
	      var result = regexpExecAbstract(rx, S);
	      if (!sameValue(rx.lastIndex, previousLastIndex)) rx.lastIndex = previousLastIndex;
	      return result === null ? -1 : result.index;
	    }
	  ];
	});

	var SPECIES$4 = wellKnownSymbol('species');

	// `SpeciesConstructor` abstract operation
	// https://tc39.github.io/ecma262/#sec-speciesconstructor
	var speciesConstructor = function (O, defaultConstructor) {
	  var C = anObject(O).constructor;
	  var S;
	  return C === undefined || (S = anObject(C)[SPECIES$4]) == undefined ? defaultConstructor : aFunction$1(S);
	};

	var arrayPush = [].push;
	var min$4 = Math.min;
	var MAX_UINT32 = 0xFFFFFFFF;

	// babel-minify transpiles RegExp('x', 'y') -> /x/y and it causes SyntaxError
	var SUPPORTS_Y = !fails(function () { return !RegExp(MAX_UINT32, 'y'); });

	// @@split logic
	fixRegexpWellKnownSymbolLogic('split', 2, function (SPLIT, nativeSplit, maybeCallNative) {
	  var internalSplit;
	  if (
	    'abbc'.split(/(b)*/)[1] == 'c' ||
	    'test'.split(/(?:)/, -1).length != 4 ||
	    'ab'.split(/(?:ab)*/).length != 2 ||
	    '.'.split(/(.?)(.?)/).length != 4 ||
	    '.'.split(/()()/).length > 1 ||
	    ''.split(/.?/).length
	  ) {
	    // based on es5-shim implementation, need to rework it
	    internalSplit = function (separator, limit) {
	      var string = String(requireObjectCoercible(this));
	      var lim = limit === undefined ? MAX_UINT32 : limit >>> 0;
	      if (lim === 0) return [];
	      if (separator === undefined) return [string];
	      // If `separator` is not a regex, use native split
	      if (!isRegexp(separator)) {
	        return nativeSplit.call(string, separator, lim);
	      }
	      var output = [];
	      var flags = (separator.ignoreCase ? 'i' : '') +
	                  (separator.multiline ? 'm' : '') +
	                  (separator.unicode ? 'u' : '') +
	                  (separator.sticky ? 'y' : '');
	      var lastLastIndex = 0;
	      // Make `global` and avoid `lastIndex` issues by working with a copy
	      var separatorCopy = new RegExp(separator.source, flags + 'g');
	      var match, lastIndex, lastLength;
	      while (match = regexpExec.call(separatorCopy, string)) {
	        lastIndex = separatorCopy.lastIndex;
	        if (lastIndex > lastLastIndex) {
	          output.push(string.slice(lastLastIndex, match.index));
	          if (match.length > 1 && match.index < string.length) arrayPush.apply(output, match.slice(1));
	          lastLength = match[0].length;
	          lastLastIndex = lastIndex;
	          if (output.length >= lim) break;
	        }
	        if (separatorCopy.lastIndex === match.index) separatorCopy.lastIndex++; // Avoid an infinite loop
	      }
	      if (lastLastIndex === string.length) {
	        if (lastLength || !separatorCopy.test('')) output.push('');
	      } else output.push(string.slice(lastLastIndex));
	      return output.length > lim ? output.slice(0, lim) : output;
	    };
	  // Chakra, V8
	  } else if ('0'.split(undefined, 0).length) {
	    internalSplit = function (separator, limit) {
	      return separator === undefined && limit === 0 ? [] : nativeSplit.call(this, separator, limit);
	    };
	  } else internalSplit = nativeSplit;

	  return [
	    // `String.prototype.split` method
	    // https://tc39.github.io/ecma262/#sec-string.prototype.split
	    function split(separator, limit) {
	      var O = requireObjectCoercible(this);
	      var splitter = separator == undefined ? undefined : separator[SPLIT];
	      return splitter !== undefined
	        ? splitter.call(separator, O, limit)
	        : internalSplit.call(String(O), separator, limit);
	    },
	    // `RegExp.prototype[@@split]` method
	    // https://tc39.github.io/ecma262/#sec-regexp.prototype-@@split
	    //
	    // NOTE: This cannot be properly polyfilled in engines that don't support
	    // the 'y' flag.
	    function (regexp, limit) {
	      var res = maybeCallNative(internalSplit, regexp, this, limit, internalSplit !== nativeSplit);
	      if (res.done) return res.value;

	      var rx = anObject(regexp);
	      var S = String(this);
	      var C = speciesConstructor(rx, RegExp);

	      var unicodeMatching = rx.unicode;
	      var flags = (rx.ignoreCase ? 'i' : '') +
	                  (rx.multiline ? 'm' : '') +
	                  (rx.unicode ? 'u' : '') +
	                  (SUPPORTS_Y ? 'y' : 'g');

	      // ^(? + rx + ) is needed, in combination with some S slicing, to
	      // simulate the 'y' flag.
	      var splitter = new C(SUPPORTS_Y ? rx : '^(?:' + rx.source + ')', flags);
	      var lim = limit === undefined ? MAX_UINT32 : limit >>> 0;
	      if (lim === 0) return [];
	      if (S.length === 0) return regexpExecAbstract(splitter, S) === null ? [S] : [];
	      var p = 0;
	      var q = 0;
	      var A = [];
	      while (q < S.length) {
	        splitter.lastIndex = SUPPORTS_Y ? q : 0;
	        var z = regexpExecAbstract(splitter, SUPPORTS_Y ? S : S.slice(q));
	        var e;
	        if (
	          z === null ||
	          (e = min$4(toLength(splitter.lastIndex + (SUPPORTS_Y ? 0 : q)), S.length)) === p
	        ) {
	          q = advanceStringIndex(S, q, unicodeMatching);
	        } else {
	          A.push(S.slice(p, q));
	          if (A.length === lim) return A;
	          for (var i = 1; i <= z.length - 1; i++) {
	            A.push(z[i]);
	            if (A.length === lim) return A;
	          }
	          q = p = e;
	        }
	      }
	      A.push(S.slice(p));
	      return A;
	    }
	  ];
	}, !SUPPORTS_Y);

	var non = '\u200B\u0085\u180E';

	// check that a method works with the correct list
	// of whitespaces and has a correct name
	var forcedStringTrimMethod = function (METHOD_NAME) {
	  return fails(function () {
	    return !!whitespaces[METHOD_NAME]() || non[METHOD_NAME]() != non || whitespaces[METHOD_NAME].name !== METHOD_NAME;
	  });
	};

	var $trim = stringTrim.trim;


	// `String.prototype.trim` method
	// https://tc39.github.io/ecma262/#sec-string.prototype.trim
	_export({ target: 'String', proto: true, forced: forcedStringTrimMethod('trim') }, {
	  trim: function trim() {
	    return $trim(this);
	  }
	});

	// iterable DOM collections
	// flag - `iterable` interface - 'entries', 'keys', 'values', 'forEach' methods
	var domIterables = {
	  CSSRuleList: 0,
	  CSSStyleDeclaration: 0,
	  CSSValueList: 0,
	  ClientRectList: 0,
	  DOMRectList: 0,
	  DOMStringList: 0,
	  DOMTokenList: 1,
	  DataTransferItemList: 0,
	  FileList: 0,
	  HTMLAllCollection: 0,
	  HTMLCollection: 0,
	  HTMLFormElement: 0,
	  HTMLSelectElement: 0,
	  MediaList: 0,
	  MimeTypeArray: 0,
	  NamedNodeMap: 0,
	  NodeList: 1,
	  PaintRequestList: 0,
	  Plugin: 0,
	  PluginArray: 0,
	  SVGLengthList: 0,
	  SVGNumberList: 0,
	  SVGPathSegList: 0,
	  SVGPointList: 0,
	  SVGStringList: 0,
	  SVGTransformList: 0,
	  SourceBufferList: 0,
	  StyleSheetList: 0,
	  TextTrackCueList: 0,
	  TextTrackList: 0,
	  TouchList: 0
	};

	var $forEach$1 = arrayIteration.forEach;


	// `Array.prototype.forEach` method implementation
	// https://tc39.github.io/ecma262/#sec-array.prototype.foreach
	var arrayForEach = sloppyArrayMethod('forEach') ? function forEach(callbackfn /* , thisArg */) {
	  return $forEach$1(this, callbackfn, arguments.length > 1 ? arguments[1] : undefined);
	} : [].forEach;

	for (var COLLECTION_NAME in domIterables) {
	  var Collection = global_1[COLLECTION_NAME];
	  var CollectionPrototype = Collection && Collection.prototype;
	  // some Chrome versions have non-configurable methods on DOMTokenList
	  if (CollectionPrototype && CollectionPrototype.forEach !== arrayForEach) try {
	    createNonEnumerableProperty(CollectionPrototype, 'forEach', arrayForEach);
	  } catch (error) {
	    CollectionPrototype.forEach = arrayForEach;
	  }
	}

	var ITERATOR$2 = wellKnownSymbol('iterator');
	var TO_STRING_TAG$3 = wellKnownSymbol('toStringTag');
	var ArrayValues = es_array_iterator.values;

	for (var COLLECTION_NAME$1 in domIterables) {
	  var Collection$1 = global_1[COLLECTION_NAME$1];
	  var CollectionPrototype$1 = Collection$1 && Collection$1.prototype;
	  if (CollectionPrototype$1) {
	    // some Chrome versions have non-configurable methods on DOMTokenList
	    if (CollectionPrototype$1[ITERATOR$2] !== ArrayValues) try {
	      createNonEnumerableProperty(CollectionPrototype$1, ITERATOR$2, ArrayValues);
	    } catch (error) {
	      CollectionPrototype$1[ITERATOR$2] = ArrayValues;
	    }
	    if (!CollectionPrototype$1[TO_STRING_TAG$3]) {
	      createNonEnumerableProperty(CollectionPrototype$1, TO_STRING_TAG$3, COLLECTION_NAME$1);
	    }
	    if (domIterables[COLLECTION_NAME$1]) for (var METHOD_NAME in es_array_iterator) {
	      // some Chrome versions have non-configurable methods on DOMTokenList
	      if (CollectionPrototype$1[METHOD_NAME] !== es_array_iterator[METHOD_NAME]) try {
	        createNonEnumerableProperty(CollectionPrototype$1, METHOD_NAME, es_array_iterator[METHOD_NAME]);
	      } catch (error) {
	        CollectionPrototype$1[METHOD_NAME] = es_array_iterator[METHOD_NAME];
	      }
	    }
	  }
	}

	function _typeof(obj) {
	  if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") {
	    _typeof = function (obj) {
	      return typeof obj;
	    };
	  } else {
	    _typeof = function (obj) {
	      return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj;
	    };
	  }

	  return _typeof(obj);
	}

	function _classCallCheck(instance, Constructor) {
	  if (!(instance instanceof Constructor)) {
	    throw new TypeError("Cannot call a class as a function");
	  }
	}

	function _defineProperties(target, props) {
	  for (var i = 0; i < props.length; i++) {
	    var descriptor = props[i];
	    descriptor.enumerable = descriptor.enumerable || false;
	    descriptor.configurable = true;
	    if ("value" in descriptor) descriptor.writable = true;
	    Object.defineProperty(target, descriptor.key, descriptor);
	  }
	}

	function _createClass(Constructor, protoProps, staticProps) {
	  if (protoProps) _defineProperties(Constructor.prototype, protoProps);
	  if (staticProps) _defineProperties(Constructor, staticProps);
	  return Constructor;
	}

	function _slicedToArray(arr, i) {
	  return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _nonIterableRest();
	}

	function _toConsumableArray(arr) {
	  return _arrayWithoutHoles(arr) || _iterableToArray(arr) || _nonIterableSpread();
	}

	function _arrayWithoutHoles(arr) {
	  if (Array.isArray(arr)) {
	    for (var i = 0, arr2 = new Array(arr.length); i < arr.length; i++) arr2[i] = arr[i];

	    return arr2;
	  }
	}

	function _arrayWithHoles(arr) {
	  if (Array.isArray(arr)) return arr;
	}

	function _iterableToArray(iter) {
	  if (Symbol.iterator in Object(iter) || Object.prototype.toString.call(iter) === "[object Arguments]") return Array.from(iter);
	}

	function _iterableToArrayLimit(arr, i) {
	  if (!(Symbol.iterator in Object(arr) || Object.prototype.toString.call(arr) === "[object Arguments]")) {
	    return;
	  }

	  var _arr = [];
	  var _n = true;
	  var _d = false;
	  var _e = undefined;

	  try {
	    for (var _i = arr[Symbol.iterator](), _s; !(_n = (_s = _i.next()).done); _n = true) {
	      _arr.push(_s.value);

	      if (i && _arr.length === i) break;
	    }
	  } catch (err) {
	    _d = true;
	    _e = err;
	  } finally {
	    try {
	      if (!_n && _i["return"] != null) _i["return"]();
	    } finally {
	      if (_d) throw _e;
	    }
	  }

	  return _arr;
	}

	function _nonIterableSpread() {
	  throw new TypeError("Invalid attempt to spread non-iterable instance");
	}

	function _nonIterableRest() {
	  throw new TypeError("Invalid attempt to destructure non-iterable instance");
	}

	var VERSION = '1.16.0';
	var bootstrapVersion = 4;

	try {
	  var rawVersion = $.fn.dropdown.Constructor.VERSION; // Only try to parse VERSION if it is defined.
	  // It is undefined in older versions of Bootstrap (tested with 3.1.1).

	  if (rawVersion !== undefined) {
	    bootstrapVersion = parseInt(rawVersion, 10);
	  }
	} catch (e) {// ignore
	}

	var CONSTANTS = {
	  3: {
	    iconsPrefix: 'glyphicon',
	    icons: {
	      paginationSwitchDown: 'glyphicon-collapse-down icon-chevron-down',
	      paginationSwitchUp: 'glyphicon-collapse-up icon-chevron-up',
	      refresh: 'glyphicon-refresh icon-refresh',
	      toggleOff: 'glyphicon-list-alt icon-list-alt',
	      toggleOn: 'glyphicon-list-alt icon-list-alt',
	      columns: 'glyphicon-th icon-th',
	      detailOpen: 'glyphicon-plus icon-plus',
	      detailClose: 'glyphicon-minus icon-minus',
	      fullscreen: 'glyphicon-fullscreen',
	      search: 'glyphicon-search',
	      clearSearch: 'glyphicon-trash'
	    },
	    classes: {
	      buttonsPrefix: 'btn',
	      buttons: 'default',
	      buttonsGroup: 'btn-group',
	      buttonsDropdown: 'btn-group',
	      pull: 'pull',
	      inputGroup: 'input-group',
	      inputPrefix: 'input-',
	      input: 'form-control',
	      paginationDropdown: 'btn-group dropdown',
	      dropup: 'dropup',
	      dropdownActive: 'active',
	      paginationActive: 'active',
	      buttonActive: 'active'
	    },
	    html: {
	      toolbarDropdown: ['<ul class="dropdown-menu" role="menu">', '</ul>'],
	      toolbarDropdownItem: '<li class="dropdown-item-marker" role="menuitem"><label>%s</label></li>',
	      toolbarDropdownSeparator: '<li class="divider"></li>',
	      pageDropdown: ['<ul class="dropdown-menu" role="menu">', '</ul>'],
	      pageDropdownItem: '<li role="menuitem" class="%s"><a href="#">%s</a></li>',
	      dropdownCaret: '<span class="caret"></span>',
	      pagination: ['<ul class="pagination%s">', '</ul>'],
	      paginationItem: '<li class="page-item%s"><a class="page-link" aria-label="%s" href="javascript:void(0)">%s</a></li>',
	      icon: '<i class="%s %s"></i>',
	      inputGroup: '<div class="input-group">%s<span class="input-group-btn">%s</span></div>',
	      searchInput: '<input class="%s%s" type="text" placeholder="%s">',
	      searchButton: '<button class="%s" type="button" name="search" title="%s">%s %s</button>',
	      searchClearButton: '<button class="%s" type="button" name="clearSearch" title="%s">%s %s</button>'
	    }
	  },
	  4: {
	    iconsPrefix: 'fa',
	    icons: {
	      paginationSwitchDown: 'fa-caret-square-down',
	      paginationSwitchUp: 'fa-caret-square-up',
	      refresh: 'fa-sync',
	      toggleOff: 'fa-toggle-off',
	      toggleOn: 'fa-toggle-on',
	      columns: 'fa-th-list',
	      detailOpen: 'fa-plus',
	      detailClose: 'fa-minus',
	      fullscreen: 'fa-arrows-alt',
	      search: 'fa-search',
	      clearSearch: 'fa-trash'
	    },
	    classes: {
	      buttonsPrefix: 'btn',
	      buttons: 'secondary',
	      buttonsGroup: 'btn-group',
	      buttonsDropdown: 'btn-group',
	      pull: 'float',
	      inputGroup: 'btn-group',
	      inputPrefix: 'form-control-',
	      input: 'form-control',
	      paginationDropdown: 'btn-group dropdown',
	      dropup: 'dropup',
	      dropdownActive: 'active',
	      paginationActive: 'active',
	      buttonActive: 'active'
	    },
	    html: {
	      toolbarDropdown: ['<div class="dropdown-menu dropdown-menu-right">', '</div>'],
	      toolbarDropdownItem: '<label class="dropdown-item dropdown-item-marker">%s</label>',
	      pageDropdown: ['<div class="dropdown-menu">', '</div>'],
	      pageDropdownItem: '<a class="dropdown-item %s" href="#">%s</a>',
	      toolbarDropdownSeparator: '<div class="dropdown-divider"></div>',
	      dropdownCaret: '<span class="caret"></span>',
	      pagination: ['<ul class="pagination%s">', '</ul>'],
	      paginationItem: '<li class="page-item%s"><a class="page-link" aria-label="%s" href="javascript:void(0)">%s</a></li>',
	      icon: '<i class="%s %s"></i>',
	      inputGroup: '<div class="input-group">%s<div class="input-group-append">%s</div></div>',
	      searchInput: '<input class="%s%s" type="text" placeholder="%s">',
	      searchButton: '<button class="%s" type="button" name="search" title="%s">%s %s</button>',
	      searchClearButton: '<button class="%s" type="button" name="clearSearch" title="%s">%s %s</button>'
	    }
	  }
	}[bootstrapVersion];
	var DEFAULTS = {
	  height: undefined,
	  classes: 'table table-bordered table-hover',
	  theadClasses: '',
	  headerStyle: function headerStyle(column) {
	    return {};
	  },
	  rowStyle: function rowStyle(row, index) {
	    return {};
	  },
	  rowAttributes: function rowAttributes(row, index) {
	    return {};
	  },
	  undefinedText: '-',
	  locale: undefined,
	  virtualScroll: false,
	  virtualScrollItemHeight: undefined,
	  sortable: true,
	  sortClass: undefined,
	  silentSort: true,
	  sortName: undefined,
	  sortOrder: 'asc',
	  sortStable: false,
	  rememberOrder: false,
	  serverSort: true,
	  customSort: undefined,
	  columns: [[]],
	  data: [],
	  url: undefined,
	  method: 'get',
	  cache: true,
	  contentType: 'application/json',
	  dataType: 'json',
	  ajax: undefined,
	  ajaxOptions: {},
	  queryParams: function queryParams(params) {
	    return params;
	  },
	  queryParamsType: 'limit',
	  // 'limit', undefined
	  responseHandler: function responseHandler(res) {
	    return res;
	  },
	  totalField: 'total',
	  totalNotFilteredField: 'totalNotFiltered',
	  dataField: 'rows',
	  pagination: false,
	  onlyInfoPagination: false,
	  showExtendedPagination: false,
	  paginationLoop: true,
	  sidePagination: 'client',
	  // client or server
	  totalRows: 0,
	  totalNotFiltered: 0,
	  pageNumber: 1,
	  pageSize: 10,
	  pageList: [10, 25, 50, 100],
	  paginationHAlign: 'right',
	  // right, left
	  paginationVAlign: 'bottom',
	  // bottom, top, both
	  paginationDetailHAlign: 'left',
	  // right, left
	  paginationPreText: '&lsaquo;',
	  paginationNextText: '&rsaquo;',
	  paginationSuccessivelySize: 5,
	  // Maximum successively number of pages in a row
	  paginationPagesBySide: 1,
	  // Number of pages on each side (right, left) of the current page.
	  paginationUseIntermediate: false,
	  // Calculate intermediate pages for quick access
	  search: false,
	  searchOnEnterKey: false,
	  strictSearch: false,
	  visibleSearch: false,
	  showButtonIcons: true,
	  showButtonText: false,
	  showSearchButton: false,
	  showSearchClearButton: false,
	  trimOnSearch: true,
	  searchAlign: 'right',
	  searchTimeOut: 500,
	  searchText: '',
	  customSearch: undefined,
	  showHeader: true,
	  showFooter: false,
	  footerStyle: function footerStyle(column) {
	    return {};
	  },
	  showColumns: false,
	  showColumnsToggleAll: false,
	  showColumnsSearch: false,
	  minimumCountColumns: 1,
	  showPaginationSwitch: false,
	  showRefresh: false,
	  showToggle: false,
	  showFullscreen: false,
	  smartDisplay: true,
	  escape: false,
	  filterOptions: {
	    filterAlgorithm: 'and'
	  },
	  idField: undefined,
	  selectItemName: 'btSelectItem',
	  clickToSelect: false,
	  ignoreClickToSelectOn: function ignoreClickToSelectOn(_ref) {
	    var tagName = _ref.tagName;
	    return ['A', 'BUTTON'].includes(tagName);
	  },
	  singleSelect: false,
	  checkboxHeader: true,
	  maintainMetaData: false,
	  multipleSelectRow: false,
	  uniqueId: undefined,
	  cardView: false,
	  detailView: false,
	  detailViewIcon: true,
	  detailViewByClick: false,
	  detailFormatter: function detailFormatter(index, row) {
	    return '';
	  },
	  detailFilter: function detailFilter(index, row) {
	    return true;
	  },
	  toolbar: undefined,
	  toolbarAlign: 'left',
	  buttonsToolbar: undefined,
	  buttonsAlign: 'right',
	  buttonsOrder: ['paginationSwitch', 'refresh', 'toggle', 'fullscreen', 'columns'],
	  buttonsPrefix: CONSTANTS.classes.buttonsPrefix,
	  buttonsClass: CONSTANTS.classes.buttons,
	  icons: CONSTANTS.icons,
	  html: CONSTANTS.html,
	  iconSize: undefined,
	  iconsPrefix: CONSTANTS.iconsPrefix,
	  // glyphicon or fa(font-awesome)
	  onAll: function onAll(name, args) {
	    return false;
	  },
	  onClickCell: function onClickCell(field, value, row, $element) {
	    return false;
	  },
	  onDblClickCell: function onDblClickCell(field, value, row, $element) {
	    return false;
	  },
	  onClickRow: function onClickRow(item, $element) {
	    return false;
	  },
	  onDblClickRow: function onDblClickRow(item, $element) {
	    return false;
	  },
	  onSort: function onSort(name, order) {
	    return false;
	  },
	  onCheck: function onCheck(row) {
	    return false;
	  },
	  onUncheck: function onUncheck(row) {
	    return false;
	  },
	  onCheckAll: function onCheckAll(rows) {
	    return false;
	  },
	  onUncheckAll: function onUncheckAll(rows) {
	    return false;
	  },
	  onCheckSome: function onCheckSome(rows) {
	    return false;
	  },
	  onUncheckSome: function onUncheckSome(rows) {
	    return false;
	  },
	  onLoadSuccess: function onLoadSuccess(data) {
	    return false;
	  },
	  onLoadError: function onLoadError(status) {
	    return false;
	  },
	  onColumnSwitch: function onColumnSwitch(field, checked) {
	    return false;
	  },
	  onPageChange: function onPageChange(number, size) {
	    return false;
	  },
	  onSearch: function onSearch(text) {
	    return false;
	  },
	  onToggle: function onToggle(cardView) {
	    return false;
	  },
	  onPreBody: function onPreBody(data) {
	    return false;
	  },
	  onPostBody: function onPostBody() {
	    return false;
	  },
	  onPostHeader: function onPostHeader() {
	    return false;
	  },
	  onPostFooter: function onPostFooter() {
	    return false;
	  },
	  onExpandRow: function onExpandRow(index, row, $detail) {
	    return false;
	  },
	  onCollapseRow: function onCollapseRow(index, row) {
	    return false;
	  },
	  onRefreshOptions: function onRefreshOptions(options) {
	    return false;
	  },
	  onRefresh: function onRefresh(params) {
	    return false;
	  },
	  onResetView: function onResetView() {
	    return false;
	  },
	  onScrollBody: function onScrollBody() {
	    return false;
	  }
	};
	var EN = {
	  formatLoadingMessage: function formatLoadingMessage() {
	    return 'Loading, please wait';
	  },
	  formatRecordsPerPage: function formatRecordsPerPage(pageNumber) {
	    return "".concat(pageNumber, " rows per page");
	  },
	  formatShowingRows: function formatShowingRows(pageFrom, pageTo, totalRows, totalNotFiltered) {
	    if (totalNotFiltered !== undefined && totalNotFiltered > 0 && totalNotFiltered > totalRows) {
	      return "Showing ".concat(pageFrom, " to ").concat(pageTo, " of ").concat(totalRows, " rows (filtered from ").concat(totalNotFiltered, " total rows)");
	    }

	    return "Showing ".concat(pageFrom, " to ").concat(pageTo, " of ").concat(totalRows, " rows");
	  },
	  formatSRPaginationPreText: function formatSRPaginationPreText() {
	    return 'previous page';
	  },
	  formatSRPaginationPageText: function formatSRPaginationPageText(page) {
	    return "to page ".concat(page);
	  },
	  formatSRPaginationNextText: function formatSRPaginationNextText() {
	    return 'next page';
	  },
	  formatDetailPagination: function formatDetailPagination(totalRows) {
	    return "Showing ".concat(totalRows, " rows");
	  },
	  formatSearch: function formatSearch() {
	    return 'Search';
	  },
	  formatClearSearch: function formatClearSearch() {
	    return 'Clear Search';
	  },
	  formatNoMatches: function formatNoMatches() {
	    return 'No matching records found';
	  },
	  formatPaginationSwitch: function formatPaginationSwitch() {
	    return 'Hide/Show pagination';
	  },
	  formatPaginationSwitchDown: function formatPaginationSwitchDown() {
	    return 'Show pagination';
	  },
	  formatPaginationSwitchUp: function formatPaginationSwitchUp() {
	    return 'Hide pagination';
	  },
	  formatRefresh: function formatRefresh() {
	    return 'Refresh';
	  },
	  formatToggle: function formatToggle() {
	    return 'Toggle';
	  },
	  formatToggleOn: function formatToggleOn() {
	    return 'Show card view';
	  },
	  formatToggleOff: function formatToggleOff() {
	    return 'Hide card view';
	  },
	  formatColumns: function formatColumns() {
	    return 'Columns';
	  },
	  formatColumnsToggleAll: function formatColumnsToggleAll() {
	    return 'Toggle all';
	  },
	  formatFullscreen: function formatFullscreen() {
	    return 'Fullscreen';
	  },
	  formatAllRows: function formatAllRows() {
	    return 'All';
	  }
	};
	var COLUMN_DEFAULTS = {
	  field: undefined,
	  title: undefined,
	  titleTooltip: undefined,
	  'class': undefined,
	  width: undefined,
	  widthUnit: 'px',
	  rowspan: undefined,
	  colspan: undefined,
	  align: undefined,
	  // left, right, center
	  halign: undefined,
	  // left, right, center
	  falign: undefined,
	  // left, right, center
	  valign: undefined,
	  // top, middle, bottom
	  cellStyle: undefined,
	  radio: false,
	  checkbox: false,
	  checkboxEnabled: true,
	  clickToSelect: true,
	  showSelectTitle: false,
	  sortable: false,
	  sortName: undefined,
	  order: 'asc',
	  // asc, desc
	  sorter: undefined,
	  visible: true,
	  switchable: true,
	  cardVisible: true,
	  searchable: true,
	  formatter: undefined,
	  footerFormatter: undefined,
	  detailFormatter: undefined,
	  searchFormatter: true,
	  escape: false,
	  events: undefined
	};
	var METHODS = ['getOptions', 'refreshOptions', 'getData', 'getSelections', 'getAllSelections', 'load', 'append', 'prepend', 'remove', 'removeAll', 'insertRow', 'updateRow', 'getRowByUniqueId', 'updateByUniqueId', 'removeByUniqueId', 'updateCell', 'updateCellByUniqueId', 'showRow', 'hideRow', 'getHiddenRows', 'showColumn', 'hideColumn', 'getVisibleColumns', 'getHiddenColumns', 'showAllColumns', 'hideAllColumns', 'mergeCells', 'checkAll', 'uncheckAll', 'checkInvert', 'check', 'uncheck', 'checkBy', 'uncheckBy', 'refresh', 'destroy', 'resetView', 'showLoading', 'hideLoading', 'togglePagination', 'toggleFullscreen', 'toggleView', 'resetSearch', 'filterBy', 'scrollTo', 'getScrollPosition', 'selectPage', 'prevPage', 'nextPage', 'toggleDetailView', 'expandRow', 'collapseRow', 'expandAllRows', 'collapseAllRows', 'updateColumnTitle', 'updateFormatText'];
	var EVENTS = {
	  'all.bs.table': 'onAll',
	  'click-row.bs.table': 'onClickRow',
	  'dbl-click-row.bs.table': 'onDblClickRow',
	  'click-cell.bs.table': 'onClickCell',
	  'dbl-click-cell.bs.table': 'onDblClickCell',
	  'sort.bs.table': 'onSort',
	  'check.bs.table': 'onCheck',
	  'uncheck.bs.table': 'onUncheck',
	  'check-all.bs.table': 'onCheckAll',
	  'uncheck-all.bs.table': 'onUncheckAll',
	  'check-some.bs.table': 'onCheckSome',
	  'uncheck-some.bs.table': 'onUncheckSome',
	  'load-success.bs.table': 'onLoadSuccess',
	  'load-error.bs.table': 'onLoadError',
	  'column-switch.bs.table': 'onColumnSwitch',
	  'page-change.bs.table': 'onPageChange',
	  'search.bs.table': 'onSearch',
	  'toggle.bs.table': 'onToggle',
	  'pre-body.bs.table': 'onPreBody',
	  'post-body.bs.table': 'onPostBody',
	  'post-header.bs.table': 'onPostHeader',
	  'post-footer.bs.table': 'onPostFooter',
	  'expand-row.bs.table': 'onExpandRow',
	  'collapse-row.bs.table': 'onCollapseRow',
	  'refresh-options.bs.table': 'onRefreshOptions',
	  'reset-view.bs.table': 'onResetView',
	  'refresh.bs.table': 'onRefresh',
	  'scroll-body.bs.table': 'onScrollBody'
	};
	Object.assign(DEFAULTS, EN);
	var Constants = {
	  VERSION: VERSION,
	  THEME: "bootstrap".concat(bootstrapVersion),
	  CONSTANTS: CONSTANTS,
	  DEFAULTS: DEFAULTS,
	  COLUMN_DEFAULTS: COLUMN_DEFAULTS,
	  METHODS: METHODS,
	  EVENTS: EVENTS,
	  LOCALES: {
	    en: EN,
	    'en-US': EN
	  }
	};

	var FAILS_ON_PRIMITIVES = fails(function () { objectKeys(1); });

	// `Object.keys` method
	// https://tc39.github.io/ecma262/#sec-object.keys
	_export({ target: 'Object', stat: true, forced: FAILS_ON_PRIMITIVES }, {
	  keys: function keys(it) {
	    return objectKeys(toObject(it));
	  }
	});

	var Utils = {
	  // it only does '%s', and return '' when arguments are undefined
	  sprintf: function sprintf(_str) {
	    for (var _len = arguments.length, args = new Array(_len > 1 ? _len - 1 : 0), _key = 1; _key < _len; _key++) {
	      args[_key - 1] = arguments[_key];
	    }

	    var flag = true;
	    var i = 0;

	    var str = _str.replace(/%s/g, function () {
	      var arg = args[i++];

	      if (typeof arg === 'undefined') {
	        flag = false;
	        return '';
	      }

	      return arg;
	    });

	    return flag ? str : '';
	  },
	  isEmptyObject: function isEmptyObject() {
	    var obj = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {};
	    return Object.entries(obj).length === 0 && obj.constructor === Object;
	  },
	  isNumeric: function isNumeric(n) {
	    return !isNaN(parseFloat(n)) && isFinite(n);
	  },
	  getFieldTitle: function getFieldTitle(list, value) {
	    var _iteratorNormalCompletion = true;
	    var _didIteratorError = false;
	    var _iteratorError = undefined;

	    try {
	      for (var _iterator = list[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
	        var item = _step.value;

	        if (item.field === value) {
	          return item.title;
	        }
	      }
	    } catch (err) {
	      _didIteratorError = true;
	      _iteratorError = err;
	    } finally {
	      try {
	        if (!_iteratorNormalCompletion && _iterator.return != null) {
	          _iterator.return();
	        }
	      } finally {
	        if (_didIteratorError) {
	          throw _iteratorError;
	        }
	      }
	    }

	    return '';
	  },
	  setFieldIndex: function setFieldIndex(columns) {
	    var totalCol = 0;
	    var flag = [];
	    var _iteratorNormalCompletion2 = true;
	    var _didIteratorError2 = false;
	    var _iteratorError2 = undefined;

	    try {
	      for (var _iterator2 = columns[0][Symbol.iterator](), _step2; !(_iteratorNormalCompletion2 = (_step2 = _iterator2.next()).done); _iteratorNormalCompletion2 = true) {
	        var column = _step2.value;
	        totalCol += column.colspan || 1;
	      }
	    } catch (err) {
	      _didIteratorError2 = true;
	      _iteratorError2 = err;
	    } finally {
	      try {
	        if (!_iteratorNormalCompletion2 && _iterator2.return != null) {
	          _iterator2.return();
	        }
	      } finally {
	        if (_didIteratorError2) {
	          throw _iteratorError2;
	        }
	      }
	    }

	    for (var i = 0; i < columns.length; i++) {
	      flag[i] = [];

	      for (var j = 0; j < totalCol; j++) {
	        flag[i][j] = false;
	      }
	    }

	    for (var _i = 0; _i < columns.length; _i++) {
	      var _iteratorNormalCompletion3 = true;
	      var _didIteratorError3 = false;
	      var _iteratorError3 = undefined;

	      try {
	        for (var _iterator3 = columns[_i][Symbol.iterator](), _step3; !(_iteratorNormalCompletion3 = (_step3 = _iterator3.next()).done); _iteratorNormalCompletion3 = true) {
	          var r = _step3.value;
	          var rowspan = r.rowspan || 1;
	          var colspan = r.colspan || 1;

	          var index = flag[_i].indexOf(false);

	          r.colspanIndex = index;

	          if (colspan === 1) {
	            r.fieldIndex = index; // when field is undefined, use index instead

	            if (typeof r.field === 'undefined') {
	              r.field = index;
	            }
	          } else {
	            r.colspanGroup = r.colspan;
	          }

	          for (var k = 0; k < rowspan; k++) {
	            flag[_i + k][index] = true;
	          }

	          for (var _k = 0; _k < colspan; _k++) {
	            flag[_i][index + _k] = true;
	          }
	        }
	      } catch (err) {
	        _didIteratorError3 = true;
	        _iteratorError3 = err;
	      } finally {
	        try {
	          if (!_iteratorNormalCompletion3 && _iterator3.return != null) {
	            _iterator3.return();
	          }
	        } finally {
	          if (_didIteratorError3) {
	            throw _iteratorError3;
	          }
	        }
	      }
	    }
	  },
	  updateFieldGroup: function updateFieldGroup(columns) {
	    var _ref;

	    var allColumns = (_ref = []).concat.apply(_ref, _toConsumableArray(columns));

	    var _iteratorNormalCompletion4 = true;
	    var _didIteratorError4 = false;
	    var _iteratorError4 = undefined;

	    try {
	      for (var _iterator4 = columns[Symbol.iterator](), _step4; !(_iteratorNormalCompletion4 = (_step4 = _iterator4.next()).done); _iteratorNormalCompletion4 = true) {
	        var c = _step4.value;
	        var _iteratorNormalCompletion5 = true;
	        var _didIteratorError5 = false;
	        var _iteratorError5 = undefined;

	        try {
	          for (var _iterator5 = c[Symbol.iterator](), _step5; !(_iteratorNormalCompletion5 = (_step5 = _iterator5.next()).done); _iteratorNormalCompletion5 = true) {
	            var r = _step5.value;

	            if (r.colspanGroup > 1) {
	              var colspan = 0;

	              var _loop = function _loop(i) {
	                var column = allColumns.find(function (col) {
	                  return col.fieldIndex === i;
	                });

	                if (column.visible) {
	                  colspan++;
	                }
	              };

	              for (var i = r.colspanIndex; i < r.colspanIndex + r.colspanGroup; i++) {
	                _loop(i);
	              }

	              r.colspan = colspan;
	              r.visible = colspan > 0;
	            }
	          }
	        } catch (err) {
	          _didIteratorError5 = true;
	          _iteratorError5 = err;
	        } finally {
	          try {
	            if (!_iteratorNormalCompletion5 && _iterator5.return != null) {
	              _iterator5.return();
	            }
	          } finally {
	            if (_didIteratorError5) {
	              throw _iteratorError5;
	            }
	          }
	        }
	      }
	    } catch (err) {
	      _didIteratorError4 = true;
	      _iteratorError4 = err;
	    } finally {
	      try {
	        if (!_iteratorNormalCompletion4 && _iterator4.return != null) {
	          _iterator4.return();
	        }
	      } finally {
	        if (_didIteratorError4) {
	          throw _iteratorError4;
	        }
	      }
	    }
	  },
	  getScrollBarWidth: function getScrollBarWidth() {
	    if (this.cachedWidth === undefined) {
	      var $inner = $('<div/>').addClass('fixed-table-scroll-inner');
	      var $outer = $('<div/>').addClass('fixed-table-scroll-outer');
	      $outer.append($inner);
	      $('body').append($outer);
	      var w1 = $inner[0].offsetWidth;
	      $outer.css('overflow', 'scroll');
	      var w2 = $inner[0].offsetWidth;

	      if (w1 === w2) {
	        w2 = $outer[0].clientWidth;
	      }

	      $outer.remove();
	      this.cachedWidth = w1 - w2;
	    }

	    return this.cachedWidth;
	  },
	  calculateObjectValue: function calculateObjectValue(self, name, args, defaultValue) {
	    var func = name;

	    if (typeof name === 'string') {
	      // support obj.func1.func2
	      var names = name.split('.');

	      if (names.length > 1) {
	        func = window;
	        var _iteratorNormalCompletion6 = true;
	        var _didIteratorError6 = false;
	        var _iteratorError6 = undefined;

	        try {
	          for (var _iterator6 = names[Symbol.iterator](), _step6; !(_iteratorNormalCompletion6 = (_step6 = _iterator6.next()).done); _iteratorNormalCompletion6 = true) {
	            var f = _step6.value;
	            func = func[f];
	          }
	        } catch (err) {
	          _didIteratorError6 = true;
	          _iteratorError6 = err;
	        } finally {
	          try {
	            if (!_iteratorNormalCompletion6 && _iterator6.return != null) {
	              _iterator6.return();
	            }
	          } finally {
	            if (_didIteratorError6) {
	              throw _iteratorError6;
	            }
	          }
	        }
	      } else {
	        func = window[name];
	      }
	    }

	    if (func !== null && _typeof(func) === 'object') {
	      return func;
	    }

	    if (typeof func === 'function') {
	      return func.apply(self, args || []);
	    }

	    if (!func && typeof name === 'string' && this.sprintf.apply(this, [name].concat(_toConsumableArray(args)))) {
	      return this.sprintf.apply(this, [name].concat(_toConsumableArray(args)));
	    }

	    return defaultValue;
	  },
	  compareObjects: function compareObjects(objectA, objectB, compareLength) {
	    var aKeys = Object.keys(objectA);
	    var bKeys = Object.keys(objectB);

	    if (compareLength && aKeys.length !== bKeys.length) {
	      return false;
	    }

	    for (var _i2 = 0, _aKeys = aKeys; _i2 < _aKeys.length; _i2++) {
	      var key = _aKeys[_i2];

	      if (bKeys.includes(key) && objectA[key] !== objectB[key]) {
	        return false;
	      }
	    }

	    return true;
	  },
	  escapeHTML: function escapeHTML(text) {
	    if (typeof text === 'string') {
	      return text.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&#039;').replace(/`/g, '&#x60;');
	    }

	    return text;
	  },
	  getRealDataAttr: function getRealDataAttr(dataAttr) {
	    for (var _i3 = 0, _Object$entries = Object.entries(dataAttr); _i3 < _Object$entries.length; _i3++) {
	      var _Object$entries$_i = _slicedToArray(_Object$entries[_i3], 2),
	          attr = _Object$entries$_i[0],
	          value = _Object$entries$_i[1];

	      var auxAttr = attr.split(/(?=[A-Z])/).join('-').toLowerCase();

	      if (auxAttr !== attr) {
	        dataAttr[auxAttr] = value;
	        delete dataAttr[attr];
	      }
	    }

	    return dataAttr;
	  },
	  getItemField: function getItemField(item, field, escape) {
	    var value = item;

	    if (typeof field !== 'string' || item.hasOwnProperty(field)) {
	      return escape ? this.escapeHTML(item[field]) : item[field];
	    }

	    var props = field.split('.');
	    var _iteratorNormalCompletion7 = true;
	    var _didIteratorError7 = false;
	    var _iteratorError7 = undefined;

	    try {
	      for (var _iterator7 = props[Symbol.iterator](), _step7; !(_iteratorNormalCompletion7 = (_step7 = _iterator7.next()).done); _iteratorNormalCompletion7 = true) {
	        var p = _step7.value;
	        value = value && value[p];
	      }
	    } catch (err) {
	      _didIteratorError7 = true;
	      _iteratorError7 = err;
	    } finally {
	      try {
	        if (!_iteratorNormalCompletion7 && _iterator7.return != null) {
	          _iterator7.return();
	        }
	      } finally {
	        if (_didIteratorError7) {
	          throw _iteratorError7;
	        }
	      }
	    }

	    return escape ? this.escapeHTML(value) : value;
	  },
	  isIEBrowser: function isIEBrowser() {
	    return navigator.userAgent.includes('MSIE ') || /Trident.*rv:11\./.test(navigator.userAgent);
	  },
	  findIndex: function findIndex(items, item) {
	    var _iteratorNormalCompletion8 = true;
	    var _didIteratorError8 = false;
	    var _iteratorError8 = undefined;

	    try {
	      for (var _iterator8 = items[Symbol.iterator](), _step8; !(_iteratorNormalCompletion8 = (_step8 = _iterator8.next()).done); _iteratorNormalCompletion8 = true) {
	        var it = _step8.value;

	        if (JSON.stringify(it) === JSON.stringify(item)) {
	          return items.indexOf(it);
	        }
	      }
	    } catch (err) {
	      _didIteratorError8 = true;
	      _iteratorError8 = err;
	    } finally {
	      try {
	        if (!_iteratorNormalCompletion8 && _iterator8.return != null) {
	          _iterator8.return();
	        }
	      } finally {
	        if (_didIteratorError8) {
	          throw _iteratorError8;
	        }
	      }
	    }

	    return -1;
	  },
	  trToData: function trToData(columns, $els) {
	    var _this = this;

	    var data = [];
	    var m = [];
	    $els.each(function (y, el) {
	      var row = {}; // save tr's id, class and data-* attributes

	      row._id = $(el).attr('id');
	      row._class = $(el).attr('class');
	      row._data = _this.getRealDataAttr($(el).data());
	      $(el).find('>td,>th').each(function (_x, el) {
	        var cspan = +$(el).attr('colspan') || 1;
	        var rspan = +$(el).attr('rowspan') || 1;
	        var x = _x; // skip already occupied cells in current row

	        for (; m[y] && m[y][x]; x++) {} // ignore
	        // mark matrix elements occupied by current cell with true


	        for (var tx = x; tx < x + cspan; tx++) {
	          for (var ty = y; ty < y + rspan; ty++) {
	            if (!m[ty]) {
	              // fill missing rows
	              m[ty] = [];
	            }

	            m[ty][tx] = true;
	          }
	        }

	        var field = columns[x].field;
	        row[field] = $(el).html().trim(); // save td's id, class and data-* attributes

	        row["_".concat(field, "_id")] = $(el).attr('id');
	        row["_".concat(field, "_class")] = $(el).attr('class');
	        row["_".concat(field, "_rowspan")] = $(el).attr('rowspan');
	        row["_".concat(field, "_colspan")] = $(el).attr('colspan');
	        row["_".concat(field, "_title")] = $(el).attr('title');
	        row["_".concat(field, "_data")] = _this.getRealDataAttr($(el).data());
	      });
	      data.push(row);
	    });
	    return data;
	  },
	  sort: function sort(a, b, order, sortStable, aPosition, bPosition) {
	    if (a === undefined || a === null) {
	      a = '';
	    }

	    if (b === undefined || b === null) {
	      b = '';
	    }

	    if (sortStable && a === b) {
	      a = aPosition;
	      b = bPosition;
	    } // If both values are numeric, do a numeric comparison


	    if (this.isNumeric(a) && this.isNumeric(b)) {
	      // Convert numerical values form string to float.
	      a = parseFloat(a);
	      b = parseFloat(b);

	      if (a < b) {
	        return order * -1;
	      }

	      if (a > b) {
	        return order;
	      }

	      return 0;
	    }

	    if (a === b) {
	      return 0;
	    } // If value is not a string, convert to string


	    if (typeof a !== 'string') {
	      a = a.toString();
	    }

	    if (a.localeCompare(b) === -1) {
	      return order * -1;
	    }

	    return order;
	  },
	  getResizeEventName: function getResizeEventName() {
	    var id = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : '';
	    id = id || "".concat(+new Date()).concat(~~(Math.random() * 1000000));
	    return "resize.bootstrap-table-".concat(id);
	  }
	};

	var BLOCK_ROWS = 50;
	var CLUSTER_BLOCKS = 4;

	var VirtualScroll =
	/*#__PURE__*/
	function () {
	  function VirtualScroll(options) {
	    var _this = this;

	    _classCallCheck(this, VirtualScroll);

	    this.rows = options.rows;
	    this.scrollEl = options.scrollEl;
	    this.contentEl = options.contentEl;
	    this.callback = options.callback;
	    this.itemHeight = options.itemHeight;
	    this.cache = {};
	    this.scrollTop = this.scrollEl.scrollTop;
	    this.initDOM(this.rows, options.fixedScroll);
	    this.scrollEl.scrollTop = this.scrollTop;
	    this.lastCluster = 0;

	    var onScroll = function onScroll() {
	      if (_this.lastCluster !== (_this.lastCluster = _this.getNum())) {
	        _this.initDOM(_this.rows);

	        _this.callback();
	      }
	    };

	    this.scrollEl.addEventListener('scroll', onScroll, false);

	    this.destroy = function () {
	      _this.contentEl.innerHtml = '';

	      _this.scrollEl.removeEventListener('scroll', onScroll, false);
	    };
	  }

	  _createClass(VirtualScroll, [{
	    key: "initDOM",
	    value: function initDOM(rows, fixedScroll) {
	      if (typeof this.clusterHeight === 'undefined') {
	        this.cache.scrollTop = this.scrollEl.scrollTop;
	        this.cache.data = this.contentEl.innerHTML = rows[0] + rows[0] + rows[0];
	        this.getRowsHeight(rows);
	      }

	      var data = this.initData(rows, this.getNum(fixedScroll));
	      var thisRows = data.rows.join('');
	      var dataChanged = this.checkChanges('data', thisRows);
	      var topOffsetChanged = this.checkChanges('top', data.topOffset);
	      var bottomOffsetChanged = this.checkChanges('bottom', data.bottomOffset);
	      var html = [];

	      if (dataChanged && topOffsetChanged) {
	        if (data.topOffset) {
	          html.push(this.getExtra('top', data.topOffset));
	        }

	        html.push(thisRows);

	        if (data.bottomOffset) {
	          html.push(this.getExtra('bottom', data.bottomOffset));
	        }

	        this.contentEl.innerHTML = html.join('');

	        if (fixedScroll) {
	          this.contentEl.scrollTop = this.cache.scrollTop;
	        }
	      } else if (bottomOffsetChanged) {
	        this.contentEl.lastChild.style.height = "".concat(data.bottomOffset, "px");
	      }
	    }
	  }, {
	    key: "getRowsHeight",
	    value: function getRowsHeight() {
	      if (typeof this.itemHeight === 'undefined') {
	        var nodes = this.contentEl.children;
	        var node = nodes[Math.floor(nodes.length / 2)];
	        this.itemHeight = node.offsetHeight;
	      }

	      this.blockHeight = this.itemHeight * BLOCK_ROWS;
	      this.clusterRows = BLOCK_ROWS * CLUSTER_BLOCKS;
	      this.clusterHeight = this.blockHeight * CLUSTER_BLOCKS;
	    }
	  }, {
	    key: "getNum",
	    value: function getNum(fixedScroll) {
	      this.scrollTop = fixedScroll ? this.cache.scrollTop : this.scrollEl.scrollTop;
	      return Math.floor(this.scrollTop / (this.clusterHeight - this.blockHeight)) || 0;
	    }
	  }, {
	    key: "initData",
	    value: function initData(rows, num) {
	      if (rows.length < BLOCK_ROWS) {
	        return {
	          topOffset: 0,
	          bottomOffset: 0,
	          rowsAbove: 0,
	          rows: rows
	        };
	      }

	      var start = Math.max((this.clusterRows - BLOCK_ROWS) * num, 0);
	      var end = start + this.clusterRows;
	      var topOffset = Math.max(start * this.itemHeight, 0);
	      var bottomOffset = Math.max((rows.length - end) * this.itemHeight, 0);
	      var thisRows = [];
	      var rowsAbove = start;

	      if (topOffset < 1) {
	        rowsAbove++;
	      }

	      for (var i = start; i < end; i++) {
	        rows[i] && thisRows.push(rows[i]);
	      }

	      return {
	        topOffset: topOffset,
	        bottomOffset: bottomOffset,
	        rowsAbove: rowsAbove,
	        rows: thisRows
	      };
	    }
	  }, {
	    key: "checkChanges",
	    value: function checkChanges(type, value) {
	      var changed = value !== this.cache[type];
	      this.cache[type] = value;
	      return changed;
	    }
	  }, {
	    key: "getExtra",
	    value: function getExtra(className, height) {
	      var tag = document.createElement('tr');
	      tag.className = "virtual-scroll-".concat(className);

	      if (height) {
	        tag.style.height = "".concat(height, "px");
	      }

	      return tag.outerHTML;
	    }
	  }]);

	  return VirtualScroll;
	}();

	var BootstrapTable =
	/*#__PURE__*/
	function () {
	  function BootstrapTable(el, options) {
	    _classCallCheck(this, BootstrapTable);

	    this.options = options;
	    this.$el = $(el);
	    this.$el_ = this.$el.clone();
	    this.timeoutId_ = 0;
	    this.timeoutFooter_ = 0;
	    this.init();
	  }

	  _createClass(BootstrapTable, [{
	    key: "init",
	    value: function init() {
	      this.initConstants();
	      this.initLocale();
	      this.initContainer();
	      this.initTable();
	      this.initHeader();
	      this.initData();
	      this.initHiddenRows();
	      this.initToolbar();
	      this.initPagination();
	      this.initBody();
	      this.initSearchText();
	      this.initServer();
	    }
	  }, {
	    key: "initConstants",
	    value: function initConstants() {
	      var opts = this.options;
	      this.constants = Constants.CONSTANTS;
	      this.constants.theme = $.fn.bootstrapTable.theme;
	      var buttonsPrefix = opts.buttonsPrefix ? "".concat(opts.buttonsPrefix, "-") : '';
	      this.constants.buttonsClass = [opts.buttonsPrefix, buttonsPrefix + opts.buttonsClass, Utils.sprintf("".concat(buttonsPrefix, "%s"), opts.iconSize)].join(' ').trim();
	    }
	  }, {
	    key: "initLocale",
	    value: function initLocale() {
	      if (this.options.locale) {
	        var locales = $.fn.bootstrapTable.locales;
	        var parts = this.options.locale.split(/-|_/);
	        parts[0] = parts[0].toLowerCase();

	        if (parts[1]) {
	          parts[1] = parts[1].toUpperCase();
	        }

	        if (locales[this.options.locale]) {
	          $.extend(this.options, locales[this.options.locale]);
	        } else if (locales[parts.join('-')]) {
	          $.extend(this.options, locales[parts.join('-')]);
	        } else if (locales[parts[0]]) {
	          $.extend(this.options, locales[parts[0]]);
	        }
	      }
	    }
	  }, {
	    key: "initContainer",
	    value: function initContainer() {
	      var topPagination = ['top', 'both'].includes(this.options.paginationVAlign) ? '<div class="fixed-table-pagination clearfix"></div>' : '';
	      var bottomPagination = ['bottom', 'both'].includes(this.options.paginationVAlign) ? '<div class="fixed-table-pagination"></div>' : '';
	      this.$container = $("\n      <div class=\"bootstrap-table ".concat(this.constants.theme, "\">\n      <div class=\"fixed-table-toolbar\"></div>\n      ").concat(topPagination, "\n      <div class=\"fixed-table-container\">\n      <div class=\"fixed-table-header\"><table></table></div>\n      <div class=\"fixed-table-body\">\n      <div class=\"fixed-table-loading\">\n      <span class=\"loading-wrap\">\n      <span class=\"loading-text\">").concat(this.options.formatLoadingMessage(), "</span>\n      <span class=\"animation-wrap\"><span class=\"animation-dot\"></span></span>\n      </span>\n      </div>\n      </div>\n      <div class=\"fixed-table-footer\"><table><thead><tr></tr></thead></table></div>\n      </div>\n      ").concat(bottomPagination, "\n      </div>\n    "));
	      this.$container.insertAfter(this.$el);
	      this.$tableContainer = this.$container.find('.fixed-table-container');
	      this.$tableHeader = this.$container.find('.fixed-table-header');
	      this.$tableBody = this.$container.find('.fixed-table-body');
	      this.$tableLoading = this.$container.find('.fixed-table-loading');
	      this.$tableFooter = this.$el.find('tfoot'); // checking if custom table-toolbar exists or not

	      if (this.options.buttonsToolbar) {
	        this.$toolbar = $('body').find(this.options.buttonsToolbar);
	      } else {
	        this.$toolbar = this.$container.find('.fixed-table-toolbar');
	      }

	      this.$pagination = this.$container.find('.fixed-table-pagination');
	      this.$tableBody.append(this.$el);
	      this.$container.after('<div class="clearfix"></div>');
	      this.$el.addClass(this.options.classes);
	      this.$tableLoading.addClass(this.options.classes);

	      if (this.options.height) {
	        this.$tableContainer.addClass('fixed-height');

	        if (this.options.showFooter) {
	          this.$tableContainer.addClass('has-footer');
	        }

	        if (this.options.classes.split(' ').includes('table-bordered')) {
	          this.$tableBody.append('<div class="fixed-table-border"></div>');
	          this.$tableBorder = this.$tableBody.find('.fixed-table-border');
	          this.$tableLoading.addClass('fixed-table-border');
	        }

	        this.$tableFooter = this.$container.find('.fixed-table-footer');
	      }
	    }
	  }, {
	    key: "initTable",
	    value: function initTable() {
	      var _this = this;

	      var columns = [];
	      this.$header = this.$el.find('>thead');

	      if (!this.$header.length) {
	        this.$header = $("<thead class=\"".concat(this.options.theadClasses, "\"></thead>")).appendTo(this.$el);
	      } else if (this.options.theadClasses) {
	        this.$header.addClass(this.options.theadClasses);
	      }

	      this.$header.find('tr').each(function (i, el) {
	        var column = [];
	        $(el).find('th').each(function (i, el) {
	          // #2014: getFieldIndex and elsewhere assume this is string, causes issues if not
	          if (typeof $(el).data('field') !== 'undefined') {
	            $(el).data('field', "".concat($(el).data('field')));
	          }

	          column.push($.extend({}, {
	            title: $(el).html(),
	            'class': $(el).attr('class'),
	            titleTooltip: $(el).attr('title'),
	            rowspan: $(el).attr('rowspan') ? +$(el).attr('rowspan') : undefined,
	            colspan: $(el).attr('colspan') ? +$(el).attr('colspan') : undefined
	          }, $(el).data()));
	        });
	        columns.push(column);
	      });

	      if (!Array.isArray(this.options.columns[0])) {
	        this.options.columns = [this.options.columns];
	      }

	      this.options.columns = $.extend(true, [], columns, this.options.columns);
	      this.columns = [];
	      this.fieldsColumnsIndex = [];
	      Utils.setFieldIndex(this.options.columns);
	      this.options.columns.forEach(function (columns, i) {
	        columns.forEach(function (_column, j) {
	          var column = $.extend({}, BootstrapTable.COLUMN_DEFAULTS, _column);

	          if (typeof column.fieldIndex !== 'undefined') {
	            _this.columns[column.fieldIndex] = column;
	            _this.fieldsColumnsIndex[column.field] = column.fieldIndex;
	          }

	          _this.options.columns[i][j] = column;
	        });
	      }); // if options.data is setting, do not process tbody and tfoot data

	      if (!this.options.data.length) {
	        this.options.data = Utils.trToData(this.columns, this.$el.find('>tbody>tr'));

	        if (this.options.data.length) {
	          this.fromHtml = true;
	        }
	      }

	      this.footerData = Utils.trToData(this.columns, this.$el.find('>tfoot>tr'));

	      if (this.footerData) {
	        this.$el.find('tfoot').html('<tr></tr>');
	      }

	      if (!this.options.showFooter || this.options.cardView) {
	        this.$tableFooter.hide();
	      } else {
	        this.$tableFooter.show();
	      }
	    }
	  }, {
	    key: "initHeader",
	    value: function initHeader() {
	      var _this2 = this;

	      var visibleColumns = {};
	      var html = [];
	      this.header = {
	        fields: [],
	        styles: [],
	        classes: [],
	        formatters: [],
	        detailFormatters: [],
	        events: [],
	        sorters: [],
	        sortNames: [],
	        cellStyles: [],
	        searchables: []
	      };
	      Utils.updateFieldGroup(this.options.columns);
	      this.options.columns.forEach(function (columns, i) {
	        html.push('<tr>');

	        if (i === 0 && !_this2.options.cardView && _this2.options.detailView && _this2.options.detailViewIcon) {
	          html.push("<th class=\"detail\" rowspan=\"".concat(_this2.options.columns.length, "\">\n          <div class=\"fht-cell\"></div>\n          </th>\n        "));
	        }

	        columns.forEach(function (column, j) {
	          var class_ = Utils.sprintf(' class="%s"', column['class']);
	          var unitWidth = column.widthUnit;
	          var width = parseFloat(column.width);
	          var halign = Utils.sprintf('text-align: %s; ', column.halign ? column.halign : column.align);
	          var align = Utils.sprintf('text-align: %s; ', column.align);
	          var style = Utils.sprintf('vertical-align: %s; ', column.valign);
	          style += Utils.sprintf('width: %s; ', (column.checkbox || column.radio) && !width ? !column.showSelectTitle ? '36px' : undefined : width ? width + unitWidth : undefined);

	          if (typeof column.fieldIndex === 'undefined' && !column.visible) {
	            return;
	          }

	          var headerStyle = Utils.calculateObjectValue(null, _this2.options.headerStyle, [column]);
	          var csses = [];
	          var classes = '';

	          if (headerStyle && headerStyle.css) {
	            for (var _i = 0, _Object$entries = Object.entries(headerStyle.css); _i < _Object$entries.length; _i++) {
	              var _Object$entries$_i = _slicedToArray(_Object$entries[_i], 2),
	                  key = _Object$entries$_i[0],
	                  value = _Object$entries$_i[1];

	              csses.push("".concat(key, ": ").concat(value));
	            }
	          }

	          if (headerStyle && headerStyle.classes) {
	            classes = Utils.sprintf(' class="%s"', column['class'] ? [column['class'], headerStyle.classes].join(' ') : headerStyle.classes);
	          }

	          if (typeof column.fieldIndex !== 'undefined') {
	            _this2.header.fields[column.fieldIndex] = column.field;
	            _this2.header.styles[column.fieldIndex] = align + style;
	            _this2.header.classes[column.fieldIndex] = class_;
	            _this2.header.formatters[column.fieldIndex] = column.formatter;
	            _this2.header.detailFormatters[column.fieldIndex] = column.detailFormatter;
	            _this2.header.events[column.fieldIndex] = column.events;
	            _this2.header.sorters[column.fieldIndex] = column.sorter;
	            _this2.header.sortNames[column.fieldIndex] = column.sortName;
	            _this2.header.cellStyles[column.fieldIndex] = column.cellStyle;
	            _this2.header.searchables[column.fieldIndex] = column.searchable;

	            if (!column.visible) {
	              return;
	            }

	            if (_this2.options.cardView && !column.cardVisible) {
	              return;
	            }

	            visibleColumns[column.field] = column;
	          }

	          html.push("<th".concat(Utils.sprintf(' title="%s"', column.titleTooltip)), column.checkbox || column.radio ? Utils.sprintf(' class="bs-checkbox %s"', column['class'] || '') : classes || class_, Utils.sprintf(' style="%s"', halign + style + csses.join('; ')), Utils.sprintf(' rowspan="%s"', column.rowspan), Utils.sprintf(' colspan="%s"', column.colspan), Utils.sprintf(' data-field="%s"', column.field), // If `column` is not the first element of `this.options.columns[0]`, then className 'data-not-first-th' should be added.
	          j === 0 && i > 0 ? ' data-not-first-th' : '', '>');
	          html.push(Utils.sprintf('<div class="th-inner %s">', _this2.options.sortable && column.sortable ? 'sortable both' : ''));
	          var text = _this2.options.escape ? Utils.escapeHTML(column.title) : column.title;
	          var title = text;

	          if (column.checkbox) {
	            text = '';

	            if (!_this2.options.singleSelect && _this2.options.checkboxHeader) {
	              text = '<label><input name="btSelectAll" type="checkbox" /><span></span></label>';
	            }

	            _this2.header.stateField = column.field;
	          }

	          if (column.radio) {
	            text = '';
	            _this2.header.stateField = column.field;
	          }

	          if (!text && column.showSelectTitle) {
	            text += title;
	          }

	          html.push(text);
	          html.push('</div>');
	          html.push('<div class="fht-cell"></div>');
	          html.push('</div>');
	          html.push('</th>');
	        });
	        html.push('</tr>');
	      });
	      this.$header.html(html.join(''));
	      this.$header.find('th[data-field]').each(function (i, el) {
	        $(el).data(visibleColumns[$(el).data('field')]);
	      });
	      this.$container.off('click', '.th-inner').on('click', '.th-inner', function (e) {
	        var $this = $(e.currentTarget);

	        if (_this2.options.detailView && !$this.parent().hasClass('bs-checkbox')) {
	          if ($this.closest('.bootstrap-table')[0] !== _this2.$container[0]) {
	            return false;
	          }
	        }

	        if (_this2.options.sortable && $this.parent().data().sortable) {
	          _this2.onSort(e);
	        }
	      });
	      this.$header.children().children().off('keypress').on('keypress', function (e) {
	        if (_this2.options.sortable && $(e.currentTarget).data().sortable) {
	          var code = e.keyCode || e.which;

	          if (code === 13) {
	            // Enter keycode
	            _this2.onSort(e);
	          }
	        }
	      });
	      var resizeEvent = Utils.getResizeEventName(this.$el.attr('id'));
	      $(window).off(resizeEvent);

	      if (!this.options.showHeader || this.options.cardView) {
	        this.$header.hide();
	        this.$tableHeader.hide();
	        this.$tableLoading.css('top', 0);
	      } else {
	        this.$header.show();
	        this.$tableHeader.show();
	        this.$tableLoading.css('top', this.$header.outerHeight() + 1); // Assign the correct sortable arrow

	        this.getCaret();
	        $(window).on(resizeEvent, function () {
	          return _this2.resetView();
	        });
	      }

	      this.$selectAll = this.$header.find('[name="btSelectAll"]');
	      this.$selectAll.off('click').on('click', function (e) {
	        e.stopPropagation();
	        var checked = $(e.currentTarget).prop('checked');

	        _this2[checked ? 'checkAll' : 'uncheckAll']();

	        _this2.updateSelected();
	      });
	    }
	  }, {
	    key: "initData",
	    value: function initData(data, type) {
	      if (type === 'append') {
	        this.options.data = this.options.data.concat(data);
	      } else if (type === 'prepend') {
	        this.options.data = [].concat(data).concat(this.options.data);
	      } else {
	        this.options.data = data || this.options.data;
	      }

	      this.data = this.options.data;

	      if (this.options.sidePagination === 'server') {
	        return;
	      }

	      this.initSort();
	    }
	  }, {
	    key: "initSort",
	    value: function initSort() {
	      var _this3 = this;

	      var name = this.options.sortName;
	      var order = this.options.sortOrder === 'desc' ? -1 : 1;
	      var index = this.header.fields.indexOf(this.options.sortName);
	      var timeoutId = 0;

	      if (index !== -1) {
	        if (this.options.sortStable) {
	          this.data.forEach(function (row, i) {
	            if (!row.hasOwnProperty('_position')) {
	              row._position = i;
	            }
	          });
	        }

	        if (this.options.customSort) {
	          Utils.calculateObjectValue(this.options, this.options.customSort, [this.options.sortName, this.options.sortOrder, this.data]);
	        } else {
	          this.data.sort(function (a, b) {
	            if (_this3.header.sortNames[index]) {
	              name = _this3.header.sortNames[index];
	            }

	            var aa = Utils.getItemField(a, name, _this3.options.escape);
	            var bb = Utils.getItemField(b, name, _this3.options.escape);
	            var value = Utils.calculateObjectValue(_this3.header, _this3.header.sorters[index], [aa, bb, a, b]);

	            if (value !== undefined) {
	              if (_this3.options.sortStable && value === 0) {
	                return order * (a._position - b._position);
	              }

	              return order * value;
	            }

	            return Utils.sort(aa, bb, order, _this3.options.sortStable, a._position, b._position);
	          });
	        }

	        if (this.options.sortClass !== undefined) {
	          clearTimeout(timeoutId);
	          timeoutId = setTimeout(function () {
	            _this3.$el.removeClass(_this3.options.sortClass);

	            var index = _this3.$header.find("[data-field=\"".concat(_this3.options.sortName, "\"]")).index();

	            _this3.$el.find("tr td:nth-child(".concat(index + 1, ")")).addClass(_this3.options.sortClass);
	          }, 250);
	        }
	      }
	    }
	  }, {
	    key: "onSort",
	    value: function onSort(_ref) {
	      var type = _ref.type,
	          currentTarget = _ref.currentTarget;
	      var $this = type === 'keypress' ? $(currentTarget) : $(currentTarget).parent();
	      var $this_ = this.$header.find('th').eq($this.index());
	      this.$header.add(this.$header_).find('span.order').remove();

	      if (this.options.sortName === $this.data('field')) {
	        this.options.sortOrder = this.options.sortOrder === 'asc' ? 'desc' : 'asc';
	      } else {
	        this.options.sortName = $this.data('field');

	        if (this.options.rememberOrder) {
	          this.options.sortOrder = $this.data('order') === 'asc' ? 'desc' : 'asc';
	        } else {
	          this.options.sortOrder = this.columns[this.fieldsColumnsIndex[$this.data('field')]].sortOrder || this.columns[this.fieldsColumnsIndex[$this.data('field')]].order;
	        }
	      }

	      this.trigger('sort', this.options.sortName, this.options.sortOrder);
	      $this.add($this_).data('order', this.options.sortOrder); // Assign the correct sortable arrow

	      this.getCaret();

	      if (this.options.sidePagination === 'server' && this.options.serverSort) {
	        this.options.pageNumber = 1;
	        this.initServer(this.options.silentSort);
	        return;
	      }

	      this.initSort();
	      this.initBody();
	    }
	  }, {
	    key: "initToolbar",
	    value: function initToolbar() {
	      var _this4 = this;

	      var opts = this.options;
	      var html = [];
	      var timeoutId = 0;
	      var $keepOpen;
	      var switchableCount = 0;

	      if (this.$toolbar.find('.bs-bars').children().length) {
	        $('body').append($(opts.toolbar));
	      }

	      this.$toolbar.html('');

	      if (typeof opts.toolbar === 'string' || _typeof(opts.toolbar) === 'object') {
	        $(Utils.sprintf('<div class="bs-bars %s-%s"></div>', this.constants.classes.pull, opts.toolbarAlign)).appendTo(this.$toolbar).append($(opts.toolbar));
	      } // showColumns, showToggle, showRefresh


	      html = ["<div class=\"".concat(['columns', "columns-".concat(opts.buttonsAlign), this.constants.classes.buttonsGroup, "".concat(this.constants.classes.pull, "-").concat(opts.buttonsAlign)].join(' '), "\">")];

	      if (typeof opts.icons === 'string') {
	        opts.icons = Utils.calculateObjectValue(null, opts.icons);
	      }

	      var buttonsHtml = {
	        paginationSwitch: "<button class=\"".concat(this.constants.buttonsClass, "\" type=\"button\" name=\"paginationSwitch\"\n        aria-label=\"Pagination Switch\" title=\"").concat(opts.formatPaginationSwitch(), "\">\n        ").concat(opts.showButtonIcons ? Utils.sprintf(this.constants.html.icon, opts.iconsPrefix, opts.icons.paginationSwitchDown) : '', "\n        ").concat(opts.showButtonText ? opts.formatPaginationSwitchUp() : '', "\n        </button>"),
	        refresh: "<button class=\"".concat(this.constants.buttonsClass, "\" type=\"button\" name=\"refresh\"\n        aria-label=\"Refresh\" title=\"").concat(opts.formatRefresh(), "\">\n        ").concat(opts.showButtonIcons ? Utils.sprintf(this.constants.html.icon, opts.iconsPrefix, opts.icons.refresh) : '', "\n        ").concat(opts.showButtonText ? opts.formatRefresh() : '', "\n        </button>"),
	        toggle: "<button class=\"".concat(this.constants.buttonsClass, "\" type=\"button\" name=\"toggle\"\n        aria-label=\"Toggle\" title=\"").concat(opts.formatToggle(), "\">\n        ").concat(opts.showButtonIcons ? Utils.sprintf(this.constants.html.icon, opts.iconsPrefix, opts.icons.toggleOff) : '', "\n        ").concat(opts.showButtonText ? opts.formatToggleOn() : '', "\n        </button>"),
	        fullscreen: "<button class=\"".concat(this.constants.buttonsClass, "\" type=\"button\" name=\"fullscreen\"\n        aria-label=\"Fullscreen\" title=\"").concat(opts.formatFullscreen(), "\">\n        ").concat(opts.showButtonIcons ? Utils.sprintf(this.constants.html.icon, opts.iconsPrefix, opts.icons.fullscreen) : '', "\n        ").concat(opts.showButtonText ? opts.formatFullscreen() : '', "\n        </button>"),
	        columns: function () {
	          var html = [];
	          html.push("<div class=\"keep-open ".concat(_this4.constants.classes.buttonsDropdown, "\" title=\"").concat(opts.formatColumns(), "\">\n          <button class=\"").concat(_this4.constants.buttonsClass, " dropdown-toggle\" type=\"button\" data-toggle=\"dropdown\"\n          aria-label=\"Columns\" title=\"").concat(opts.formatColumns(), "\">\n          ").concat(opts.showButtonIcons ? Utils.sprintf(_this4.constants.html.icon, opts.iconsPrefix, opts.icons.columns) : '', "\n          ").concat(opts.showButtonText ? opts.formatColumns() : '', "\n          ").concat(_this4.constants.html.dropdownCaret, "\n          </button>\n          ").concat(_this4.constants.html.toolbarDropdown[0]));

	          if (opts.showColumnsSearch) {
	            html.push(Utils.sprintf(_this4.constants.html.toolbarDropdownItem, Utils.sprintf('<input type="text" class="%s" id="columnsSearch" placeholder="%s" autocomplete="off">', _this4.constants.classes.input, opts.formatSearch())));
	            html.push(_this4.constants.html.toolbarDropdownSeparator);
	          }

	          if (opts.showColumnsToggleAll) {
	            var allFieldsVisible = _this4.getVisibleColumns().length === _this4.columns.filter(function (column) {
	              return !_this4.isSelectionColumn(column);
	            }).length;

	            html.push(Utils.sprintf(_this4.constants.html.toolbarDropdownItem, Utils.sprintf('<input type="checkbox" class="toggle-all" %s> <span>%s</span>', allFieldsVisible ? 'checked="checked"' : '', opts.formatColumnsToggleAll())));
	            html.push(_this4.constants.html.toolbarDropdownSeparator);
	          }

	          var visibleColumns = 0;

	          _this4.columns.forEach(function (column, i) {
	            if (column.visible) {
	              visibleColumns++;
	            }
	          });

	          _this4.columns.forEach(function (column, i) {
	            if (_this4.isSelectionColumn(column)) {
	              return;
	            }

	            if (opts.cardView && !column.cardVisible) {
	              return;
	            }

	            var checked = column.visible ? ' checked="checked"' : '';
	            var disabled = visibleColumns <= _this4.options.minimumCountColumns && checked ? ' disabled="disabled"' : '';

	            if (column.switchable) {
	              html.push(Utils.sprintf(_this4.constants.html.toolbarDropdownItem, Utils.sprintf('<input type="checkbox" data-field="%s" value="%s"%s%s> <span>%s</span>', column.field, i, checked, disabled, column.title)));
	              switchableCount++;
	            }
	          });

	          html.push(_this4.constants.html.toolbarDropdown[1], '</div>');
	          return html.join('');
	        }()
	      };

	      if (typeof opts.buttonsOrder === 'string') {
	        opts.buttonsOrder = opts.buttonsOrder.replace(/\[|\]| |'/g, '').toLowerCase().split(',');
	      }

	      var _iteratorNormalCompletion = true;
	      var _didIteratorError = false;
	      var _iteratorError = undefined;

	      try {
	        for (var _iterator = opts.buttonsOrder[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
	          var button = _step.value;

	          if (opts['show' + button.charAt(0).toUpperCase() + button.substring(1)]) {
	            html.push(buttonsHtml[button]);
	          }
	        }
	      } catch (err) {
	        _didIteratorError = true;
	        _iteratorError = err;
	      } finally {
	        try {
	          if (!_iteratorNormalCompletion && _iterator.return != null) {
	            _iterator.return();
	          }
	        } finally {
	          if (_didIteratorError) {
	            throw _iteratorError;
	          }
	        }
	      }

	      html.push('</div>'); // Fix #188: this.showToolbar is for extensions

	      if (this.showToolbar || html.length > 2) {
	        this.$toolbar.append(html.join(''));
	      }

	      if (opts.showPaginationSwitch) {
	        this.$toolbar.find('button[name="paginationSwitch"]').off('click').on('click', function () {
	          return _this4.togglePagination();
	        });
	      }

	      if (opts.showFullscreen) {
	        this.$toolbar.find('button[name="fullscreen"]').off('click').on('click', function () {
	          return _this4.toggleFullscreen();
	        });
	      }

	      if (opts.showRefresh) {
	        this.$toolbar.find('button[name="refresh"]').off('click').on('click', function () {
	          return _this4.refresh();
	        });
	      }

	      if (opts.showToggle) {
	        this.$toolbar.find('button[name="toggle"]').off('click').on('click', function () {
	          _this4.toggleView();
	        });
	      }

	      if (opts.showColumns) {
	        $keepOpen = this.$toolbar.find('.keep-open');
	        var $checkboxes = $keepOpen.find('input[type="checkbox"]:not(".toggle-all")');
	        var $toggleAll = $keepOpen.find('input[type="checkbox"].toggle-all');

	        if (switchableCount <= opts.minimumCountColumns) {
	          $keepOpen.find('input').prop('disabled', true);
	        }

	        $keepOpen.find('li, label').off('click').on('click', function (e) {
	          e.stopImmediatePropagation();
	        });
	        $checkboxes.off('click').on('click', function (_ref2) {
	          var currentTarget = _ref2.currentTarget;
	          var $this = $(currentTarget);

	          _this4._toggleColumn($this.val(), $this.prop('checked'), false);

	          _this4.trigger('column-switch', $this.data('field'), $this.prop('checked'));

	          $toggleAll.prop('checked', $checkboxes.filter(':checked').length === _this4.columns.filter(function (column) {
	            return !_this4.isSelectionColumn(column);
	          }).length);
	        });
	        $toggleAll.off('click').on('click', function (_ref3) {
	          var currentTarget = _ref3.currentTarget;

	          _this4._toggleAllColumns($(currentTarget).prop('checked'));
	        });

	        if (opts.showColumnsSearch) {
	          var $columnsSearch = $keepOpen.find('#columnsSearch');
	          var $listItems = $keepOpen.find('.dropdown-item-marker');
	          $columnsSearch.on('keyup paste change', function (_ref4) {
	            var currentTarget = _ref4.currentTarget;
	            var $this = $(currentTarget);
	            var searchValue = $this.val().toLowerCase();
	            $listItems.show();
	            $checkboxes.each(function (i, el) {
	              var $checkbox = $(el);
	              var $listItem = $checkbox.parents('.dropdown-item-marker');
	              var text = $listItem.text().toLowerCase();

	              if (!text.includes(searchValue)) {
	                $listItem.hide();
	              }
	            });
	          });
	        }
	      } // Fix #4516: this.showSearchClearButton is for extensions


	      if (opts.search || this.showSearchClearButton) {
	        html = [];
	        var showSearchButton = Utils.sprintf(this.constants.html.searchButton, this.constants.buttonsClass, opts.formatSearch(), opts.showButtonIcons ? Utils.sprintf(this.constants.html.icon, opts.iconsPrefix, opts.icons.search) : '', opts.showButtonText ? opts.formatSearch() : '');
	        var showSearchClearButton = Utils.sprintf(this.constants.html.searchClearButton, this.constants.buttonsClass, opts.formatClearSearch(), opts.showButtonIcons ? Utils.sprintf(this.constants.html.icon, opts.iconsPrefix, opts.icons.clearSearch) : '', opts.showButtonText ? opts.formatClearSearch() : '');
	        var searchInputHtml = "<input class=\"".concat(this.constants.classes.input, "\n        ").concat(Utils.sprintf(' %s%s', this.constants.classes.inputPrefix, opts.iconSize), "\n        search-input\" type=\"text\" placeholder=\"").concat(opts.formatSearch(), "\" autocomplete=\"off\">");
	        var searchInputFinalHtml = searchInputHtml;

	        if (opts.showSearchButton || opts.showSearchClearButton) {
	          var _buttonsHtml = (opts.showSearchButton ? showSearchButton : '') + (opts.showSearchClearButton ? showSearchClearButton : '');

	          searchInputFinalHtml = opts.search ? Utils.sprintf(this.constants.html.inputGroup, searchInputHtml, _buttonsHtml) : _buttonsHtml;
	        }

	        html.push(Utils.sprintf("\n        <div class=\"".concat(this.constants.classes.pull, "-").concat(opts.searchAlign, " search ").concat(this.constants.classes.inputGroup, "\">\n          %s\n        </div>\n      "), searchInputFinalHtml));
	        this.$toolbar.append(html.join(''));
	        var $searchInput = this.$toolbar.find('.search input');

	        var handleInputEvent = function handleInputEvent() {
	          var eventTriggers = "keyup drop blur ".concat(Utils.isIEBrowser() ? 'mouseup' : '');
	          $searchInput.off(eventTriggers).on(eventTriggers, function (event) {
	            if (opts.searchOnEnterKey && event.keyCode !== 13) {
	              return;
	            }

	            if ([37, 38, 39, 40].includes(event.keyCode)) {
	              return;
	            }

	            clearTimeout(timeoutId); // doesn't matter if it's 0

	            timeoutId = setTimeout(function () {
	              _this4.onSearch({
	                currentTarget: event.currentTarget
	              });
	            }, opts.searchTimeOut);
	          });
	        };

	        if (opts.showSearchButton) {
	          this.$toolbar.find('.search button[name=search]').off('click').on('click', function (event) {
	            clearTimeout(timeoutId); // doesn't matter if it's 0

	            timeoutId = setTimeout(function () {
	              _this4.onSearch({
	                currentTarget: $searchInput
	              });
	            }, opts.searchTimeOut);
	          });

	          if (opts.searchOnEnterKey) {
	            handleInputEvent();
	          }
	        } else {
	          handleInputEvent();
	        }

	        if (opts.showSearchClearButton) {
	          this.$toolbar.find('.search button[name=clearSearch]').click(function () {
	            _this4.resetSearch();
	          });
	        }
	      }
	    }
	  }, {
	    key: "onSearch",
	    value: function onSearch() {
	      var _ref5 = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {},
	          currentTarget = _ref5.currentTarget,
	          firedByInitSearchText = _ref5.firedByInitSearchText;

	      var overwriteSearchText = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : true;

	      if (currentTarget !== undefined && $(currentTarget).length && overwriteSearchText) {
	        var text = $(currentTarget).val().trim();

	        if (this.options.trimOnSearch && $(currentTarget).val() !== text) {
	          $(currentTarget).val(text);
	        }

	        if (this.searchText === text && text.length > 0) {
	          return;
	        }

	        if ($(currentTarget).hasClass('search-input')) {
	          this.searchText = text;
	          this.options.searchText = text;
	        }
	      }

	      if (!firedByInitSearchText) {
	        this.options.pageNumber = 1;
	      }

	      this.initSearch();

	      if (firedByInitSearchText) {
	        if (this.options.sidePagination === 'client') {
	          this.updatePagination();
	        }
	      } else {
	        this.updatePagination();
	      }

	      this.trigger('search', this.searchText);
	    }
	  }, {
	    key: "initSearch",
	    value: function initSearch() {
	      var _this5 = this;

	      this.filterOptions = this.filterOptions || this.options.filterOptions;

	      if (this.options.sidePagination !== 'server') {
	        if (this.options.customSearch) {
	          this.data = Utils.calculateObjectValue(this.options, this.options.customSearch, [this.options.data, this.searchText, this.filterColumns]);
	          return;
	        }

	        var s = this.searchText && (this.fromHtml ? Utils.escapeHTML(this.searchText) : this.searchText).toLowerCase();
	        var f = Utils.isEmptyObject(this.filterColumns) ? null : this.filterColumns; // Check filter

	        if (typeof this.filterOptions.filterAlgorithm === 'function') {
	          this.data = this.options.data.filter(function (item, i) {
	            return _this5.filterOptions.filterAlgorithm.apply(null, [item, f]);
	          });
	        } else if (typeof this.filterOptions.filterAlgorithm === 'string') {
	          this.data = f ? this.options.data.filter(function (item, i) {
	            var filterAlgorithm = _this5.filterOptions.filterAlgorithm;

	            if (filterAlgorithm === 'and') {
	              for (var key in f) {
	                if (Array.isArray(f[key]) && !f[key].includes(item[key]) || !Array.isArray(f[key]) && item[key] !== f[key]) {
	                  return false;
	                }
	              }
	            } else if (filterAlgorithm === 'or') {
	              var match = false;

	              for (var _key in f) {
	                if (Array.isArray(f[_key]) && f[_key].includes(item[_key]) || !Array.isArray(f[_key]) && item[_key] === f[_key]) {
	                  match = true;
	                }
	              }

	              return match;
	            }

	            return true;
	          }) : this.options.data;
	        }

	        var visibleFields = this.getVisibleFields();
	        this.data = s ? this.data.filter(function (item, i) {
	          for (var j = 0; j < _this5.header.fields.length; j++) {
	            if (!_this5.header.searchables[j] || _this5.options.visibleSearch && visibleFields.indexOf(_this5.header.fields[j]) === -1) {
	              continue;
	            }

	            var key = Utils.isNumeric(_this5.header.fields[j]) ? parseInt(_this5.header.fields[j], 10) : _this5.header.fields[j];
	            var column = _this5.columns[_this5.fieldsColumnsIndex[key]];
	            var value = void 0;

	            if (typeof key === 'string') {
	              value = item;
	              var props = key.split('.');

	              for (var _i2 = 0; _i2 < props.length; _i2++) {
	                if (value[props[_i2]] !== null) {
	                  value = value[props[_i2]];
	                }
	              }
	            } else {
	              value = item[key];
	            } // Fix #142: respect searchFormatter boolean


	            if (column && column.searchFormatter) {
	              value = Utils.calculateObjectValue(column, _this5.header.formatters[j], [value, item, i, column.field], value);
	            }

	            if (typeof value === 'string' || typeof value === 'number') {
	              if (_this5.options.strictSearch) {
	                if ("".concat(value).toLowerCase() === s) {
	                  return true;
	                }
	              } else {
	                var largerSmallerEqualsRegex = /(?:(<=|=>|=<|>=|>|<)(?:\s+)?(\d+)?|(\d+)?(\s+)?(<=|=>|=<|>=|>|<))/gm;
	                var matches = largerSmallerEqualsRegex.exec(s);
	                var comparisonCheck = false;

	                if (matches) {
	                  var operator = matches[1] || "".concat(matches[5], "l");
	                  var comparisonValue = matches[2] || matches[3];
	                  var int = parseInt(value, 10);
	                  var comparisonInt = parseInt(comparisonValue, 10);

	                  switch (operator) {
	                    case '>':
	                    case '<l':
	                      comparisonCheck = int > comparisonInt;
	                      break;

	                    case '<':
	                    case '>l':
	                      comparisonCheck = int < comparisonInt;
	                      break;

	                    case '<=':
	                    case '=<':
	                    case '>=l':
	                    case '=>l':
	                      comparisonCheck = int <= comparisonInt;
	                      break;

	                    case '>=':
	                    case '=>':
	                    case '<=l':
	                    case '=<l':
	                      comparisonCheck = int >= comparisonInt;
	                      break;
	                  }
	                }

	                if (comparisonCheck || "".concat(value).toLowerCase().includes(s)) {
	                  return true;
	                }
	              }
	            }
	          }

	          return false;
	        }) : this.data;
	      }

	      this.initSort();
	    }
	  }, {
	    key: "initPagination",
	    value: function initPagination() {
	      var _this6 = this;

	      var opts = this.options;

	      if (!opts.pagination) {
	        this.$pagination.hide();
	        return;
	      }

	      this.$pagination.show();
	      var html = [];
	      var allSelected = false;
	      var i;
	      var from;
	      var to;
	      var $pageList;
	      var $pre;
	      var $next;
	      var $number;
	      var data = this.getData({
	        includeHiddenRows: false
	      });
	      var pageList = opts.pageList;

	      if (typeof pageList === 'string') {
	        pageList = pageList.replace(/\[|\]| /g, '').toLowerCase().split(',');
	      }

	      pageList = pageList.map(function (value) {
	        if (typeof value === 'string') {
	          return value.toLowerCase() === opts.formatAllRows().toLowerCase() || ['all', 'unlimited'].includes(value.toLowerCase()) ? opts.formatAllRows() : +value;
	        }

	        return value;
	      });

	      if (opts.sidePagination !== 'server') {
	        opts.totalRows = data.length;
	      }

	      this.totalPages = 0;

	      if (opts.totalRows) {
	        if (opts.pageSize === opts.formatAllRows()) {
	          opts.pageSize = opts.totalRows;
	          allSelected = true;
	        }

	        this.totalPages = ~~((opts.totalRows - 1) / opts.pageSize) + 1;
	        opts.totalPages = this.totalPages;
	      }

	      if (this.totalPages > 0 && opts.pageNumber > this.totalPages) {
	        opts.pageNumber = this.totalPages;
	      }

	      this.pageFrom = (opts.pageNumber - 1) * opts.pageSize + 1;
	      this.pageTo = opts.pageNumber * opts.pageSize;

	      if (this.pageTo > opts.totalRows) {
	        this.pageTo = opts.totalRows;
	      }

	      if (this.options.pagination && this.options.sidePagination !== 'server') {
	        this.options.totalNotFiltered = this.options.data.length;
	      }

	      if (!this.options.showExtendedPagination) {
	        this.options.totalNotFiltered = undefined;
	      }

	      var paginationInfo = opts.onlyInfoPagination ? opts.formatDetailPagination(opts.totalRows) : opts.formatShowingRows(this.pageFrom, this.pageTo, opts.totalRows, opts.totalNotFiltered);
	      html.push("<div class=\"".concat(this.constants.classes.pull, "-").concat(opts.paginationDetailHAlign, " pagination-detail\">\n      <span class=\"pagination-info\">\n      ").concat(paginationInfo, "\n      </span>"));

	      if (!opts.onlyInfoPagination) {
	        html.push('<span class="page-list">');
	        var pageNumber = ["<span class=\"".concat(this.constants.classes.paginationDropdown, "\">\n        <button class=\"").concat(this.constants.buttonsClass, " dropdown-toggle\" type=\"button\" data-toggle=\"dropdown\">\n        <span class=\"page-size\">\n        ").concat(allSelected ? opts.formatAllRows() : opts.pageSize, "\n        </span>\n        ").concat(this.constants.html.dropdownCaret, "\n        </button>\n        ").concat(this.constants.html.pageDropdown[0])];
	        pageList.forEach(function (page, i) {
	          if (!opts.smartDisplay || i === 0 || pageList[i - 1] < opts.totalRows) {
	            var active;

	            if (allSelected) {
	              active = page === opts.formatAllRows() ? _this6.constants.classes.dropdownActive : '';
	            } else {
	              active = page === opts.pageSize ? _this6.constants.classes.dropdownActive : '';
	            }

	            pageNumber.push(Utils.sprintf(_this6.constants.html.pageDropdownItem, active, page));
	          }
	        });
	        pageNumber.push("".concat(this.constants.html.pageDropdown[1], "</span>"));
	        html.push(opts.formatRecordsPerPage(pageNumber.join('')));
	        html.push('</span></div>');
	        html.push("<div class=\"".concat(this.constants.classes.pull, "-").concat(opts.paginationHAlign, " pagination\">"), Utils.sprintf(this.constants.html.pagination[0], Utils.sprintf(' pagination-%s', opts.iconSize)), Utils.sprintf(this.constants.html.paginationItem, ' page-pre', opts.formatSRPaginationPreText(), opts.paginationPreText));

	        if (this.totalPages < opts.paginationSuccessivelySize) {
	          from = 1;
	          to = this.totalPages;
	        } else {
	          from = opts.pageNumber - opts.paginationPagesBySide;
	          to = from + opts.paginationPagesBySide * 2;
	        }

	        if (opts.pageNumber < opts.paginationSuccessivelySize - 1) {
	          to = opts.paginationSuccessivelySize;
	        }

	        if (opts.paginationSuccessivelySize > this.totalPages - from) {
	          from = from - (opts.paginationSuccessivelySize - (this.totalPages - from)) + 1;
	        }

	        if (from < 1) {
	          from = 1;
	        }

	        if (to > this.totalPages) {
	          to = this.totalPages;
	        }

	        var middleSize = Math.round(opts.paginationPagesBySide / 2);

	        var pageItem = function pageItem(i) {
	          var classes = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : '';
	          return Utils.sprintf(_this6.constants.html.paginationItem, classes + (i === opts.pageNumber ? " ".concat(_this6.constants.classes.paginationActive) : ''), opts.formatSRPaginationPageText(i), i);
	        };

	        if (from > 1) {
	          var max = opts.paginationPagesBySide;
	          if (max >= from) max = from - 1;

	          for (i = 1; i <= max; i++) {
	            html.push(pageItem(i));
	          }

	          if (from - 1 === max + 1) {
	            i = from - 1;
	            html.push(pageItem(i));
	          } else {
	            if (from - 1 > max) {
	              if (from - opts.paginationPagesBySide * 2 > opts.paginationPagesBySide && opts.paginationUseIntermediate) {
	                i = Math.round((from - middleSize) / 2 + middleSize);
	                html.push(pageItem(i, ' page-intermediate'));
	              } else {
	                html.push(Utils.sprintf(this.constants.html.paginationItem, ' page-first-separator disabled', '', '...'));
	              }
	            }
	          }
	        }

	        for (i = from; i <= to; i++) {
	          html.push(pageItem(i));
	        }

	        if (this.totalPages > to) {
	          var min = this.totalPages - (opts.paginationPagesBySide - 1);
	          if (to >= min) min = to + 1;

	          if (to + 1 === min - 1) {
	            i = to + 1;
	            html.push(pageItem(i));
	          } else {
	            if (min > to + 1) {
	              if (this.totalPages - to > opts.paginationPagesBySide * 2 && opts.paginationUseIntermediate) {
	                i = Math.round((this.totalPages - middleSize - to) / 2 + to);
	                html.push(pageItem(i, ' page-intermediate'));
	              } else {
	                html.push(Utils.sprintf(this.constants.html.paginationItem, ' page-last-separator disabled', '', '...'));
	              }
	            }
	          }

	          for (i = min; i <= this.totalPages; i++) {
	            html.push(pageItem(i));
	          }
	        }

	        html.push(Utils.sprintf(this.constants.html.paginationItem, ' page-next', opts.formatSRPaginationNextText(), opts.paginationNextText));
	        html.push(this.constants.html.pagination[1], '</div>');
	      }

	      this.$pagination.html(html.join(''));
	      var dropupClass = ['bottom', 'both'].includes(opts.paginationVAlign) ? " ".concat(this.constants.classes.dropup) : '';
	      this.$pagination.last().find('.page-list > span').addClass(dropupClass);

	      if (!opts.onlyInfoPagination) {
	        $pageList = this.$pagination.find('.page-list a');
	        $pre = this.$pagination.find('.page-pre');
	        $next = this.$pagination.find('.page-next');
	        $number = this.$pagination.find('.page-item').not('.page-next, .page-pre, .page-last-separator, .page-first-separator');

	        if (this.totalPages <= 1) {
	          this.$pagination.find('div.pagination').hide();
	        }

	        if (opts.smartDisplay) {
	          if (pageList.length < 2 || opts.totalRows <= pageList[0]) {
	            this.$pagination.find('span.page-list').hide();
	          }
	        } // when data is empty, hide the pagination


	        this.$pagination[this.getData().length ? 'show' : 'hide']();

	        if (!opts.paginationLoop) {
	          if (opts.pageNumber === 1) {
	            $pre.addClass('disabled');
	          }

	          if (opts.pageNumber === this.totalPages) {
	            $next.addClass('disabled');
	          }
	        }

	        if (allSelected) {
	          opts.pageSize = opts.formatAllRows();
	        } // removed the events for last and first, onPageNumber executeds the same logic


	        $pageList.off('click').on('click', function (e) {
	          return _this6.onPageListChange(e);
	        });
	        $pre.off('click').on('click', function (e) {
	          return _this6.onPagePre(e);
	        });
	        $next.off('click').on('click', function (e) {
	          return _this6.onPageNext(e);
	        });
	        $number.off('click').on('click', function (e) {
	          return _this6.onPageNumber(e);
	        });
	      }
	    }
	  }, {
	    key: "updatePagination",
	    value: function updatePagination(event) {
	      // Fix #171: IE disabled button can be clicked bug.
	      if (event && $(event.currentTarget).hasClass('disabled')) {
	        return;
	      }

	      if (!this.options.maintainMetaData) {
	        this.resetRows();
	      }

	      this.initPagination();

	      if (this.options.sidePagination === 'server') {
	        this.initServer();
	      } else {
	        this.initBody();
	      }

	      this.trigger('page-change', this.options.pageNumber, this.options.pageSize);
	    }
	  }, {
	    key: "onPageListChange",
	    value: function onPageListChange(event) {
	      event.preventDefault();
	      var $this = $(event.currentTarget);
	      $this.parent().addClass(this.constants.classes.dropdownActive).siblings().removeClass(this.constants.classes.dropdownActive);
	      this.options.pageSize = $this.text().toUpperCase() === this.options.formatAllRows().toUpperCase() ? this.options.formatAllRows() : +$this.text();
	      this.$toolbar.find('.page-size').text(this.options.pageSize);
	      this.updatePagination(event);
	      return false;
	    }
	  }, {
	    key: "onPagePre",
	    value: function onPagePre(event) {
	      event.preventDefault();

	      if (this.options.pageNumber - 1 === 0) {
	        this.options.pageNumber = this.options.totalPages;
	      } else {
	        this.options.pageNumber--;
	      }

	      this.updatePagination(event);
	      return false;
	    }
	  }, {
	    key: "onPageNext",
	    value: function onPageNext(event) {
	      event.preventDefault();

	      if (this.options.pageNumber + 1 > this.options.totalPages) {
	        this.options.pageNumber = 1;
	      } else {
	        this.options.pageNumber++;
	      }

	      this.updatePagination(event);
	      return false;
	    }
	  }, {
	    key: "onPageNumber",
	    value: function onPageNumber(event) {
	      event.preventDefault();

	      if (this.options.pageNumber === +$(event.currentTarget).text()) {
	        return;
	      }

	      this.options.pageNumber = +$(event.currentTarget).text();
	      this.updatePagination(event);
	      return false;
	    }
	  }, {
	    key: "initRow",
	    value: function initRow(item, i, data, trFragments) {
	      var _this7 = this;

	      var html = [];
	      var style = {};
	      var csses = [];
	      var data_ = '';
	      var attributes = {};
	      var htmlAttributes = [];

	      if (Utils.findIndex(this.hiddenRows, item) > -1) {
	        return;
	      }

	      style = Utils.calculateObjectValue(this.options, this.options.rowStyle, [item, i], style);

	      if (style && style.css) {
	        for (var _i3 = 0, _Object$entries2 = Object.entries(style.css); _i3 < _Object$entries2.length; _i3++) {
	          var _Object$entries2$_i = _slicedToArray(_Object$entries2[_i3], 2),
	              key = _Object$entries2$_i[0],
	              value = _Object$entries2$_i[1];

	          csses.push("".concat(key, ": ").concat(value));
	        }
	      }

	      attributes = Utils.calculateObjectValue(this.options, this.options.rowAttributes, [item, i], attributes);

	      if (attributes) {
	        for (var _i4 = 0, _Object$entries3 = Object.entries(attributes); _i4 < _Object$entries3.length; _i4++) {
	          var _Object$entries3$_i = _slicedToArray(_Object$entries3[_i4], 2),
	              _key2 = _Object$entries3$_i[0],
	              _value = _Object$entries3$_i[1];

	          htmlAttributes.push("".concat(_key2, "=\"").concat(Utils.escapeHTML(_value), "\""));
	        }
	      }

	      if (item._data && !Utils.isEmptyObject(item._data)) {
	        for (var _i5 = 0, _Object$entries4 = Object.entries(item._data); _i5 < _Object$entries4.length; _i5++) {
	          var _Object$entries4$_i = _slicedToArray(_Object$entries4[_i5], 2),
	              k = _Object$entries4$_i[0],
	              v = _Object$entries4$_i[1];

	          // ignore data-index
	          if (k === 'index') {
	            return;
	          }

	          data_ += " data-".concat(k, "='").concat(_typeof(v) === 'object' ? JSON.stringify(v) : v, "'");
	        }
	      }

	      html.push('<tr', Utils.sprintf(' %s', htmlAttributes.length ? htmlAttributes.join(' ') : undefined), Utils.sprintf(' id="%s"', Array.isArray(item) ? undefined : item._id), Utils.sprintf(' class="%s"', style.classes || (Array.isArray(item) ? undefined : item._class)), " data-index=\"".concat(i, "\""), Utils.sprintf(' data-uniqueid="%s"', Utils.getItemField(item, this.options.uniqueId, false)), Utils.sprintf(' data-has-detail-view="%s"', !this.options.cardView && this.options.detailView && Utils.calculateObjectValue(null, this.options.detailFilter, [i, item]) ? 'true' : undefined), Utils.sprintf('%s', data_), '>');

	      if (this.options.cardView) {
	        html.push("<td colspan=\"".concat(this.header.fields.length, "\"><div class=\"card-views\">"));
	      }

	      if (!this.options.cardView && this.options.detailView && this.options.detailViewIcon) {
	        html.push('<td>');

	        if (Utils.calculateObjectValue(null, this.options.detailFilter, [i, item])) {
	          html.push("\n          <a class=\"detail-icon\" href=\"#\">\n          ".concat(Utils.sprintf(this.constants.html.icon, this.options.iconsPrefix, this.options.icons.detailOpen), "\n          </a>\n        "));
	        }

	        html.push('</td>');
	      }

	      this.header.fields.forEach(function (field, j) {
	        var text = '';
	        var value_ = Utils.getItemField(item, field, _this7.options.escape);
	        var value = '';
	        var type = '';
	        var cellStyle = {};
	        var id_ = '';
	        var class_ = _this7.header.classes[j];
	        var style_ = '';
	        var data_ = '';
	        var rowspan_ = '';
	        var colspan_ = '';
	        var title_ = '';
	        var column = _this7.columns[j];

	        if (_this7.fromHtml && typeof value_ === 'undefined') {
	          if (!column.checkbox && !column.radio) {
	            return;
	          }
	        }

	        if (!column.visible) {
	          return;
	        }

	        if (_this7.options.cardView && !column.cardVisible) {
	          return;
	        }

	        if (column.escape) {
	          value_ = Utils.escapeHTML(value_);
	        }

	        if (csses.concat([_this7.header.styles[j]]).length) {
	          style_ = " style=\"".concat(csses.concat([_this7.header.styles[j]]).join('; '), "\"");
	        } // handle td's id and class


	        if (item["_".concat(field, "_id")]) {
	          id_ = Utils.sprintf(' id="%s"', item["_".concat(field, "_id")]);
	        }

	        if (item["_".concat(field, "_class")]) {
	          class_ = Utils.sprintf(' class="%s"', item["_".concat(field, "_class")]);
	        }

	        if (item["_".concat(field, "_rowspan")]) {
	          rowspan_ = Utils.sprintf(' rowspan="%s"', item["_".concat(field, "_rowspan")]);
	        }

	        if (item["_".concat(field, "_colspan")]) {
	          colspan_ = Utils.sprintf(' colspan="%s"', item["_".concat(field, "_colspan")]);
	        }

	        if (item["_".concat(field, "_title")]) {
	          title_ = Utils.sprintf(' title="%s"', item["_".concat(field, "_title")]);
	        }

	        cellStyle = Utils.calculateObjectValue(_this7.header, _this7.header.cellStyles[j], [value_, item, i, field], cellStyle);

	        if (cellStyle.classes) {
	          class_ = " class=\"".concat(cellStyle.classes, "\"");
	        }

	        if (cellStyle.css) {
	          var csses_ = [];

	          for (var _i6 = 0, _Object$entries5 = Object.entries(cellStyle.css); _i6 < _Object$entries5.length; _i6++) {
	            var _Object$entries5$_i = _slicedToArray(_Object$entries5[_i6], 2),
	                _key3 = _Object$entries5$_i[0],
	                _value2 = _Object$entries5$_i[1];

	            csses_.push("".concat(_key3, ": ").concat(_value2));
	          }

	          style_ = " style=\"".concat(csses_.concat(_this7.header.styles[j]).join('; '), "\"");
	        }

	        value = Utils.calculateObjectValue(column, _this7.header.formatters[j], [value_, item, i, field], value_);

	        if (item["_".concat(field, "_data")] && !Utils.isEmptyObject(item["_".concat(field, "_data")])) {
	          for (var _i7 = 0, _Object$entries6 = Object.entries(item["_".concat(field, "_data")]); _i7 < _Object$entries6.length; _i7++) {
	            var _Object$entries6$_i = _slicedToArray(_Object$entries6[_i7], 2),
	                _k = _Object$entries6$_i[0],
	                _v = _Object$entries6$_i[1];

	            // ignore data-index
	            if (_k === 'index') {
	              return;
	            }

	            data_ += " data-".concat(_k, "=\"").concat(_v, "\"");
	          }
	        }

	        if (column.checkbox || column.radio) {
	          type = column.checkbox ? 'checkbox' : type;
	          type = column.radio ? 'radio' : type;
	          var c = column['class'] || '';
	          var isChecked = (value === true || value_ || value && value.checked) && value !== false;
	          var isDisabled = !column.checkboxEnabled || value && value.disabled;
	          text = [_this7.options.cardView ? "<div class=\"card-view ".concat(c, "\">") : "<td class=\"bs-checkbox ".concat(c, "\"").concat(class_).concat(style_, ">"), "<label>\n            <input\n            data-index=\"".concat(i, "\"\n            name=\"").concat(_this7.options.selectItemName, "\"\n            type=\"").concat(type, "\"\n            ").concat(Utils.sprintf('value="%s"', item[_this7.options.idField]), "\n            ").concat(Utils.sprintf('checked="%s"', isChecked ? 'checked' : undefined), "\n            ").concat(Utils.sprintf('disabled="%s"', isDisabled ? 'disabled' : undefined), " />\n            <span></span>\n            </label>"), _this7.header.formatters[j] && typeof value === 'string' ? value : '', _this7.options.cardView ? '</div>' : '</td>'].join('');
	          item[_this7.header.stateField] = value === true || !!value_ || value && value.checked;
	        } else {
	          value = typeof value === 'undefined' || value === null ? _this7.options.undefinedText : value;

	          if (_this7.options.cardView) {
	            var cardTitle = _this7.options.showHeader ? "<span class=\"card-view-title\"".concat(style_, ">").concat(Utils.getFieldTitle(_this7.columns, field), "</span>") : '';
	            text = "<div class=\"card-view\">".concat(cardTitle, "<span class=\"card-view-value\">").concat(value, "</span></div>");

	            if (_this7.options.smartDisplay && value === '') {
	              text = '<div class="card-view"></div>';
	            }
	          } else {
	            text = "<td".concat(id_).concat(class_).concat(style_).concat(data_).concat(rowspan_).concat(colspan_).concat(title_, ">").concat(value, "</td>");
	          }
	        }

	        html.push(text);
	      });

	      if (this.options.cardView) {
	        html.push('</div></td>');
	      }

	      html.push('</tr>');
	      return html.join('');
	    }
	  }, {
	    key: "initBody",
	    value: function initBody(fixedScroll) {
	      var _this8 = this;

	      var data = this.getData();
	      this.trigger('pre-body', data);
	      this.$body = this.$el.find('>tbody');

	      if (!this.$body.length) {
	        this.$body = $('<tbody></tbody>').appendTo(this.$el);
	      } // Fix #389 Bootstrap-table-flatJSON is not working


	      if (!this.options.pagination || this.options.sidePagination === 'server') {
	        this.pageFrom = 1;
	        this.pageTo = data.length;
	      }

	      var rows = [];
	      var trFragments = $(document.createDocumentFragment());
	      var hasTr = false;

	      for (var i = this.pageFrom - 1; i < this.pageTo; i++) {
	        var item = data[i];
	        var tr = this.initRow(item, i, data, trFragments);
	        hasTr = hasTr || !!tr;

	        if (tr && typeof tr === 'string') {
	          if (!this.options.virtualScroll) {
	            trFragments.append(tr);
	          } else {
	            rows.push(tr);
	          }
	        }
	      } // show no records


	      if (!hasTr) {
	        this.$body.html("<tr class=\"no-records-found\">".concat(Utils.sprintf('<td colspan="%s">%s</td>', this.$header.find('th').length, this.options.formatNoMatches()), "</tr>"));
	      } else {
	        if (!this.options.virtualScroll) {
	          this.$body.html(trFragments);
	        } else {
	          if (this.virtualScroll) {
	            this.virtualScroll.destroy();
	          }

	          this.virtualScroll = new VirtualScroll({
	            rows: rows,
	            fixedScroll: fixedScroll,
	            scrollEl: this.$tableBody[0],
	            contentEl: this.$body[0],
	            itemHeight: this.options.virtualScrollItemHeight,
	            callback: function callback() {
	              _this8.fitHeader();

	              _this8.initBodyEvent();
	            }
	          });
	        }
	      }

	      if (!fixedScroll) {
	        this.scrollTo(0);
	      }

	      this.initBodyEvent();
	      this.updateSelected();
	      this.initFooter();
	      this.resetView();

	      if (this.options.sidePagination !== 'server') {
	        this.options.totalRows = data.length;
	      }

	      this.trigger('post-body', data);
	    }
	  }, {
	    key: "initBodyEvent",
	    value: function initBodyEvent() {
	      var _this9 = this;

	      // click to select by column
	      this.$body.find('> tr[data-index] > td').off('click dblclick').on('click dblclick', function (e) {
	        var $td = $(e.currentTarget);
	        var $tr = $td.parent();
	        var $cardViewArr = $(e.target).parents('.card-views').children();
	        var $cardViewTarget = $(e.target).parents('.card-view');
	        var rowIndex = $tr.data('index');
	        var item = _this9.data[rowIndex];
	        var index = _this9.options.cardView ? $cardViewArr.index($cardViewTarget) : $td[0].cellIndex;

	        var fields = _this9.getVisibleFields();

	        var field = fields[_this9.options.detailView && _this9.options.detailViewIcon && !_this9.options.cardView ? index - 1 : index];
	        var column = _this9.columns[_this9.fieldsColumnsIndex[field]];
	        var value = Utils.getItemField(item, field, _this9.options.escape);

	        if ($td.find('.detail-icon').length) {
	          return;
	        }

	        _this9.trigger(e.type === 'click' ? 'click-cell' : 'dbl-click-cell', field, value, item, $td);

	        _this9.trigger(e.type === 'click' ? 'click-row' : 'dbl-click-row', item, $tr, field); // if click to select - then trigger the checkbox/radio click


	        if (e.type === 'click' && _this9.options.clickToSelect && column.clickToSelect && !Utils.calculateObjectValue(_this9.options, _this9.options.ignoreClickToSelectOn, [e.target])) {
	          var $selectItem = $tr.find(Utils.sprintf('[name="%s"]', _this9.options.selectItemName));

	          if ($selectItem.length) {
	            $selectItem[0].click();
	          }
	        }

	        if (e.type === 'click' && _this9.options.detailViewByClick) {
	          _this9.toggleDetailView(rowIndex, _this9.header.detailFormatters[_this9.fieldsColumnsIndex[field]]);
	        }
	      }).off('mousedown').on('mousedown', function (e) {
	        // https://github.com/jquery/jquery/issues/1741
	        _this9.multipleSelectRowCtrlKey = e.ctrlKey || e.metaKey;
	        _this9.multipleSelectRowShiftKey = e.shiftKey;
	      });
	      this.$body.find('> tr[data-index] > td > .detail-icon').off('click').on('click', function (e) {
	        e.preventDefault();

	        _this9.toggleDetailView($(e.currentTarget).parent().parent().data('index'));

	        return false;
	      });
	      this.$selectItem = this.$body.find(Utils.sprintf('[name="%s"]', this.options.selectItemName));
	      this.$selectItem.off('click').on('click', function (e) {
	        e.stopImmediatePropagation();
	        var $this = $(e.currentTarget);

	        _this9._toggleCheck($this.prop('checked'), $this.data('index'));
	      });
	      this.header.events.forEach(function (_events, i) {
	        var events = _events;

	        if (!events) {
	          return;
	        } // fix bug, if events is defined with namespace


	        if (typeof events === 'string') {
	          events = Utils.calculateObjectValue(null, events);
	        }

	        var field = _this9.header.fields[i];

	        var fieldIndex = _this9.getVisibleFields().indexOf(field);

	        if (fieldIndex === -1) {
	          return;
	        }

	        if (_this9.options.detailView && !_this9.options.cardView) {
	          fieldIndex += 1;
	        }

	        var _loop = function _loop(key) {
	          if (!events.hasOwnProperty(key)) {
	            return "continue";
	          }

	          var event = events[key];

	          _this9.$body.find('>tr:not(.no-records-found)').each(function (i, tr) {
	            var $tr = $(tr);
	            var $td = $tr.find(_this9.options.cardView ? '.card-views>.card-view' : '>td').eq(fieldIndex);
	            var index = key.indexOf(' ');
	            var name = key.substring(0, index);
	            var el = key.substring(index + 1);
	            $td.find(el).off(name).on(name, function (e) {
	              var index = $tr.data('index');
	              var row = _this9.data[index];
	              var value = row[field];
	              event.apply(_this9, [e, value, row, index]);
	            });
	          });
	        };

	        for (var key in events) {
	          var _ret = _loop(key);

	          if (_ret === "continue") continue;
	        }
	      });
	    }
	  }, {
	    key: "initServer",
	    value: function initServer(silent, query, url) {
	      var _this10 = this;

	      var data = {};
	      var index = this.header.fields.indexOf(this.options.sortName);
	      var params = {
	        searchText: this.searchText,
	        sortName: this.options.sortName,
	        sortOrder: this.options.sortOrder
	      };

	      if (this.header.sortNames[index]) {
	        params.sortName = this.header.sortNames[index];
	      }

	      if (this.options.pagination && this.options.sidePagination === 'server') {
	        params.pageSize = this.options.pageSize === this.options.formatAllRows() ? this.options.totalRows : this.options.pageSize;
	        params.pageNumber = this.options.pageNumber;
	      }

	      if (!(url || this.options.url) && !this.options.ajax) {
	        return;
	      }

	      if (this.options.queryParamsType === 'limit') {
	        params = {
	          search: params.searchText,
	          sort: params.sortName,
	          order: params.sortOrder
	        };

	        if (this.options.pagination && this.options.sidePagination === 'server') {
	          params.offset = this.options.pageSize === this.options.formatAllRows() ? 0 : this.options.pageSize * (this.options.pageNumber - 1);
	          params.limit = this.options.pageSize === this.options.formatAllRows() ? this.options.totalRows : this.options.pageSize;

	          if (params.limit === 0) {
	            delete params.limit;
	          }
	        }
	      }

	      if (!Utils.isEmptyObject(this.filterColumnsPartial)) {
	        params.filter = JSON.stringify(this.filterColumnsPartial, null);
	      }

	      $.extend(params, query || {});
	      data = Utils.calculateObjectValue(this.options, this.options.queryParams, [params], data); // false to stop request

	      if (data === false) {
	        return;
	      }

	      if (!silent) {
	        this.showLoading();
	      }

	      var request = $.extend({}, Utils.calculateObjectValue(null, this.options.ajaxOptions), {
	        type: this.options.method,
	        url: url || this.options.url,
	        data: this.options.contentType === 'application/json' && this.options.method === 'post' ? JSON.stringify(data) : data,
	        cache: this.options.cache,
	        contentType: this.options.contentType,
	        dataType: this.options.dataType,
	        success: function success(_res, textStatus, jqXHR) {
	          var res = Utils.calculateObjectValue(_this10.options, _this10.options.responseHandler, [_res, jqXHR], _res);

	          _this10.load(res);

	          _this10.trigger('load-success', res, jqXHR && jqXHR.status, jqXHR);

	          if (!silent) {
	            _this10.hideLoading();
	          }

	          if (_this10.options.sidePagination === 'server' && res[_this10.options.totalField] > 0 && !res[_this10.options.dataField].length) {
	            _this10.updatePagination();
	          }
	        },
	        error: function error(jqXHR) {
	          var data = [];

	          if (_this10.options.sidePagination === 'server') {
	            data = {};
	            data[_this10.options.totalField] = 0;
	            data[_this10.options.dataField] = [];
	          }

	          _this10.load(data);

	          _this10.trigger('load-error', jqXHR && jqXHR.status, jqXHR);

	          if (!silent) _this10.$tableLoading.hide();
	        }
	      });

	      if (this.options.ajax) {
	        Utils.calculateObjectValue(this, this.options.ajax, [request], null);
	      } else {
	        if (this._xhr && this._xhr.readyState !== 4) {
	          this._xhr.abort();
	        }

	        this._xhr = $.ajax(request);
	      }

	      return data;
	    }
	  }, {
	    key: "initSearchText",
	    value: function initSearchText() {
	      if (this.options.search) {
	        this.searchText = '';

	        if (this.options.searchText !== '') {
	          var $search = this.$toolbar.find('.search input');
	          $search.val(this.options.searchText);
	          this.onSearch({
	            currentTarget: $search,
	            firedByInitSearchText: true
	          });
	        }
	      }
	    }
	  }, {
	    key: "getCaret",
	    value: function getCaret() {
	      var _this11 = this;

	      this.$header.find('th').each(function (i, th) {
	        $(th).find('.sortable').removeClass('desc asc').addClass($(th).data('field') === _this11.options.sortName ? _this11.options.sortOrder : 'both');
	      });
	    }
	  }, {
	    key: "updateSelected",
	    value: function updateSelected() {
	      var checkAll = this.$selectItem.filter(':enabled').length && this.$selectItem.filter(':enabled').length === this.$selectItem.filter(':enabled').filter(':checked').length;
	      this.$selectAll.add(this.$selectAll_).prop('checked', checkAll);
	      this.$selectItem.each(function (i, el) {
	        $(el).closest('tr')[$(el).prop('checked') ? 'addClass' : 'removeClass']('selected');
	      });
	    }
	  }, {
	    key: "updateRows",
	    value: function updateRows() {
	      var _this12 = this;

	      this.$selectItem.each(function (i, el) {
	        _this12.data[$(el).data('index')][_this12.header.stateField] = $(el).prop('checked');
	      });
	    }
	  }, {
	    key: "resetRows",
	    value: function resetRows() {
	      var _iteratorNormalCompletion2 = true;
	      var _didIteratorError2 = false;
	      var _iteratorError2 = undefined;

	      try {
	        for (var _iterator2 = this.data[Symbol.iterator](), _step2; !(_iteratorNormalCompletion2 = (_step2 = _iterator2.next()).done); _iteratorNormalCompletion2 = true) {
	          var row = _step2.value;
	          this.$selectAll.prop('checked', false);
	          this.$selectItem.prop('checked', false);

	          if (this.header.stateField) {
	            row[this.header.stateField] = false;
	          }
	        }
	      } catch (err) {
	        _didIteratorError2 = true;
	        _iteratorError2 = err;
	      } finally {
	        try {
	          if (!_iteratorNormalCompletion2 && _iterator2.return != null) {
	            _iterator2.return();
	          }
	        } finally {
	          if (_didIteratorError2) {
	            throw _iteratorError2;
	          }
	        }
	      }

	      this.initHiddenRows();
	    }
	  }, {
	    key: "trigger",
	    value: function trigger(_name) {
	      var _this$options;

	      var name = "".concat(_name, ".bs.table");

	      for (var _len = arguments.length, args = new Array(_len > 1 ? _len - 1 : 0), _key4 = 1; _key4 < _len; _key4++) {
	        args[_key4 - 1] = arguments[_key4];
	      }

	      (_this$options = this.options)[BootstrapTable.EVENTS[name]].apply(_this$options, args);

	      this.$el.trigger($.Event(name), args);
	      this.options.onAll(name, args);
	      this.$el.trigger($.Event('all.bs.table'), [name, args]);
	    }
	  }, {
	    key: "resetHeader",
	    value: function resetHeader() {
	      var _this13 = this;

	      // fix #61: the hidden table reset header bug.
	      // fix bug: get $el.css('width') error sometime (height = 500)
	      clearTimeout(this.timeoutId_);
	      this.timeoutId_ = setTimeout(function () {
	        return _this13.fitHeader();
	      }, this.$el.is(':hidden') ? 100 : 0);
	    }
	  }, {
	    key: "fitHeader",
	    value: function fitHeader() {
	      var _this14 = this;

	      if (this.$el.is(':hidden')) {
	        this.timeoutId_ = setTimeout(function () {
	          return _this14.fitHeader();
	        }, 100);
	        return;
	      }

	      var fixedBody = this.$tableBody.get(0);
	      var scrollWidth = fixedBody.scrollWidth > fixedBody.clientWidth && fixedBody.scrollHeight > fixedBody.clientHeight + this.$header.outerHeight() ? Utils.getScrollBarWidth() : 0;
	      this.$el.css('margin-top', -this.$header.outerHeight());
	      var focused = $(':focus');

	      if (focused.length > 0) {
	        var $th = focused.parents('th');

	        if ($th.length > 0) {
	          var dataField = $th.attr('data-field');

	          if (dataField !== undefined) {
	            var $headerTh = this.$header.find("[data-field='".concat(dataField, "']"));

	            if ($headerTh.length > 0) {
	              $headerTh.find(':input').addClass('focus-temp');
	            }
	          }
	        }
	      }

	      this.$header_ = this.$header.clone(true, true);
	      this.$selectAll_ = this.$header_.find('[name="btSelectAll"]');
	      this.$tableHeader.css('margin-right', scrollWidth).find('table').css('width', this.$el.outerWidth()).html('').attr('class', this.$el.attr('class')).append(this.$header_);
	      this.$tableLoading.css('width', this.$el.outerWidth());
	      var focusedTemp = $('.focus-temp:visible:eq(0)');

	      if (focusedTemp.length > 0) {
	        focusedTemp.focus();
	        this.$header.find('.focus-temp').removeClass('focus-temp');
	      } // fix bug: $.data() is not working as expected after $.append()


	      this.$header.find('th[data-field]').each(function (i, el) {
	        _this14.$header_.find(Utils.sprintf('th[data-field="%s"]', $(el).data('field'))).data($(el).data());
	      });
	      var visibleFields = this.getVisibleFields();
	      var $ths = this.$header_.find('th');
	      var $tr = this.$body.find('>tr:not(.no-records-found,.virtual-scroll-top)').eq(0);

	      while ($tr.length && $tr.find('>td[colspan]:not([colspan="1"])').length) {
	        $tr = $tr.next();
	      }

	      $tr.find('> *').each(function (i, el) {
	        var $this = $(el);
	        var index = i;

	        if (_this14.options.detailView && _this14.options.detailViewIcon && !_this14.options.cardView) {
	          if (i === 0) {
	            var $thDetail = $ths.filter('.detail');

	            var _zoomWidth = $thDetail.innerWidth() - $thDetail.find('.fht-cell').width();

	            $thDetail.find('.fht-cell').width($this.innerWidth() - _zoomWidth);
	          }

	          index = i - 1;
	        }

	        if (index === -1) {
	          return;
	        }

	        var $th = _this14.$header_.find(Utils.sprintf('th[data-field="%s"]', visibleFields[index]));

	        if ($th.length > 1) {
	          $th = $($ths[$this[0].cellIndex]);
	        }

	        var zoomWidth = $th.innerWidth() - $th.find('.fht-cell').width();
	        $th.find('.fht-cell').width($this.innerWidth() - zoomWidth);
	      });
	      this.horizontalScroll();
	      this.trigger('post-header');
	    }
	  }, {
	    key: "initFooter",
	    value: function initFooter() {
	      if (!this.options.showFooter || this.options.cardView) {
	        // do nothing
	        return;
	      }

	      var data = this.getData();
	      var html = [];

	      if (!this.options.cardView && this.options.detailView && this.options.detailViewIcon) {
	        html.push('<th class="detail"><div class="th-inner"></div><div class="fht-cell"></div></th>');
	      }

	      var _iteratorNormalCompletion3 = true;
	      var _didIteratorError3 = false;
	      var _iteratorError3 = undefined;

	      try {
	        for (var _iterator3 = this.columns[Symbol.iterator](), _step3; !(_iteratorNormalCompletion3 = (_step3 = _iterator3.next()).done); _iteratorNormalCompletion3 = true) {
	          var column = _step3.value;
	          var falign = '';
	          var valign = '';
	          var csses = [];
	          var style = {};
	          var class_ = Utils.sprintf(' class="%s"', column['class']);

	          if (!column.visible) {
	            continue;
	          }

	          if (this.options.cardView && !column.cardVisible) {
	            return;
	          }

	          falign = Utils.sprintf('text-align: %s; ', column.falign ? column.falign : column.align);
	          valign = Utils.sprintf('vertical-align: %s; ', column.valign);
	          style = Utils.calculateObjectValue(null, this.options.footerStyle, [column]);

	          if (style && style.css) {
	            for (var _i8 = 0, _Object$entries7 = Object.entries(style.css); _i8 < _Object$entries7.length; _i8++) {
	              var _Object$entries7$_i = _slicedToArray(_Object$entries7[_i8], 2),
	                  key = _Object$entries7$_i[0],
	                  value = _Object$entries7$_i[1];

	              csses.push("".concat(key, ": ").concat(value));
	            }
	          }

	          if (style && style.classes) {
	            class_ = Utils.sprintf(' class="%s"', column['class'] ? [column['class'], style.classes].join(' ') : style.classes);
	          }

	          html.push('<th', class_, Utils.sprintf(' style="%s"', falign + valign + csses.concat().join('; ')), '>');
	          html.push('<div class="th-inner">');
	          html.push(Utils.calculateObjectValue(column, column.footerFormatter, [data], this.footerData[0] && this.footerData[0][column.field] || ''));
	          html.push('</div>');
	          html.push('<div class="fht-cell"></div>');
	          html.push('</div>');
	          html.push('</th>');
	        }
	      } catch (err) {
	        _didIteratorError3 = true;
	        _iteratorError3 = err;
	      } finally {
	        try {
	          if (!_iteratorNormalCompletion3 && _iterator3.return != null) {
	            _iterator3.return();
	          }
	        } finally {
	          if (_didIteratorError3) {
	            throw _iteratorError3;
	          }
	        }
	      }

	      if (!this.options.height && !this.$tableFooter.length) {
	        this.$el.append('<tfoot><tr></tr></tfoot>');
	        this.$tableFooter = this.$el.find('tfoot');
	      }

	      this.$tableFooter.find('tr').html(html.join(''));
	      this.trigger('post-footer', this.$tableFooter);
	    }
	  }, {
	    key: "fitFooter",
	    value: function fitFooter() {
	      var _this15 = this;

	      if (this.$el.is(':hidden')) {
	        setTimeout(function () {
	          return _this15.fitFooter();
	        }, 100);
	        return;
	      }

	      var fixedBody = this.$tableBody.get(0);
	      var scrollWidth = fixedBody.scrollWidth > fixedBody.clientWidth && fixedBody.scrollHeight > fixedBody.clientHeight + this.$header.outerHeight() ? Utils.getScrollBarWidth() : 0;
	      this.$tableFooter.css('margin-right', scrollWidth).find('table').css('width', this.$el.outerWidth()).attr('class', this.$el.attr('class'));
	      var visibleFields = this.getVisibleFields();
	      var $ths = this.$tableFooter.find('th');
	      var $tr = this.$body.find('>tr:first-child:not(.no-records-found)');

	      while ($tr.length && $tr.find('>td[colspan]:not([colspan="1"])').length) {
	        $tr = $tr.next();
	      }

	      $tr.find('> *').each(function (i, el) {
	        var $this = $(el);
	        var index = i;

	        if (_this15.options.detailView && !_this15.options.cardView) {
	          if (i === 0) {
	            var $thDetail = $ths.filter('.detail');

	            var _zoomWidth2 = $thDetail.innerWidth() - $thDetail.find('.fht-cell').width();

	            $thDetail.find('.fht-cell').width($this.innerWidth() - _zoomWidth2);
	          }

	          index = i - 1;
	        }

	        if (index === -1) {
	          return;
	        }

	        var $th = $ths.eq(i);
	        var zoomWidth = $th.innerWidth() - $th.find('.fht-cell').width();
	        $th.find('.fht-cell').width($this.innerWidth() - zoomWidth);
	      });
	      this.horizontalScroll();
	    }
	  }, {
	    key: "horizontalScroll",
	    value: function horizontalScroll() {
	      var _this16 = this;

	      // horizontal scroll event
	      // TODO: it's probably better improving the layout than binding to scroll event
	      this.$tableBody.off('scroll').on('scroll', function () {
	        var scrollLeft = _this16.$tableBody.scrollLeft();

	        if (_this16.options.showHeader && _this16.options.height) {
	          _this16.$tableHeader.scrollLeft(scrollLeft);
	        }

	        if (_this16.options.showFooter && !_this16.options.cardView) {
	          _this16.$tableFooter.scrollLeft(scrollLeft);
	        }

	        _this16.trigger('scroll-body', _this16.$tableBody);
	      });
	    }
	  }, {
	    key: "getVisibleFields",
	    value: function getVisibleFields() {
	      var visibleFields = [];
	      var _iteratorNormalCompletion4 = true;
	      var _didIteratorError4 = false;
	      var _iteratorError4 = undefined;

	      try {
	        for (var _iterator4 = this.header.fields[Symbol.iterator](), _step4; !(_iteratorNormalCompletion4 = (_step4 = _iterator4.next()).done); _iteratorNormalCompletion4 = true) {
	          var field = _step4.value;
	          var column = this.columns[this.fieldsColumnsIndex[field]];

	          if (!column || !column.visible) {
	            continue;
	          }

	          visibleFields.push(field);
	        }
	      } catch (err) {
	        _didIteratorError4 = true;
	        _iteratorError4 = err;
	      } finally {
	        try {
	          if (!_iteratorNormalCompletion4 && _iterator4.return != null) {
	            _iterator4.return();
	          }
	        } finally {
	          if (_didIteratorError4) {
	            throw _iteratorError4;
	          }
	        }
	      }

	      return visibleFields;
	    }
	  }, {
	    key: "initHiddenRows",
	    value: function initHiddenRows() {
	      this.hiddenRows = [];
	    } // PUBLIC FUNCTION DEFINITION
	    // =======================

	  }, {
	    key: "getOptions",
	    value: function getOptions() {
	      // deep copy and remove data
	      var options = $.extend({}, this.options);
	      delete options.data;
	      return $.extend(true, {}, options);
	    }
	  }, {
	    key: "refreshOptions",
	    value: function refreshOptions(options) {
	      // If the objects are equivalent then avoid the call of destroy / init methods
	      if (Utils.compareObjects(this.options, options, true)) {
	        return;
	      }

	      this.options = $.extend(this.options, options);
	      this.trigger('refresh-options', this.options);
	      this.destroy();
	      this.init();
	    }
	  }, {
	    key: "getData",
	    value: function getData(params) {
	      var data = this.options.data;

	      if ((this.searchText || this.options.customSearch || this.options.sortName || !Utils.isEmptyObject(this.filterColumns) || !Utils.isEmptyObject(this.filterColumnsPartial)) && (!params || !params.unfiltered)) {
	        data = this.data;
	      }

	      if (params && params.useCurrentPage) {
	        data = data.slice(this.pageFrom - 1, this.pageTo);
	      }

	      if (params && !params.includeHiddenRows) {
	        var hiddenRows = this.getHiddenRows();
	        data = data.filter(function (row) {
	          return Utils.findIndex(hiddenRows, row) === -1;
	        });
	      }

	      return data;
	    }
	  }, {
	    key: "getSelections",
	    value: function getSelections() {
	      var _this17 = this;

	      // fix #2424: from html with checkbox
	      return this.data.filter(function (row) {
	        return row[_this17.header.stateField] === true;
	      });
	    }
	  }, {
	    key: "getAllSelections",
	    value: function getAllSelections() {
	      var _this18 = this;

	      return this.options.data.filter(function (row) {
	        return row[_this18.header.stateField] === true;
	      });
	    }
	  }, {
	    key: "load",
	    value: function load(_data) {
	      var fixedScroll = false;
	      var data = _data; // #431: support pagination

	      if (this.options.pagination && this.options.sidePagination === 'server') {
	        this.options.totalRows = data[this.options.totalField];
	      }

	      if (this.options.pagination && this.options.sidePagination === 'server') {
	        this.options.totalNotFiltered = data[this.options.totalNotFilteredField];
	      }

	      fixedScroll = data.fixedScroll;
	      data = Array.isArray(data) ? data : data[this.options.dataField];
	      this.initData(data);
	      this.initSearch();
	      this.initPagination();
	      this.initBody(fixedScroll);
	    }
	  }, {
	    key: "append",
	    value: function append(data) {
	      this.initData(data, 'append');
	      this.initSearch();
	      this.initPagination();
	      this.initSort();
	      this.initBody(true);
	    }
	  }, {
	    key: "prepend",
	    value: function prepend(data) {
	      this.initData(data, 'prepend');
	      this.initSearch();
	      this.initPagination();
	      this.initSort();
	      this.initBody(true);
	    }
	  }, {
	    key: "remove",
	    value: function remove(params) {
	      var len = this.options.data.length;
	      var i;
	      var row;

	      if (!params.hasOwnProperty('field') || !params.hasOwnProperty('values')) {
	        return;
	      }

	      for (i = len - 1; i >= 0; i--) {
	        row = this.options.data[i];

	        if (!row.hasOwnProperty(params.field)) {
	          continue;
	        }

	        if (params.values.includes(row[params.field])) {
	          this.options.data.splice(i, 1);

	          if (this.options.sidePagination === 'server') {
	            this.options.totalRows -= 1;
	          }
	        }
	      }

	      if (len === this.options.data.length) {
	        return;
	      }

	      this.initSearch();
	      this.initPagination();
	      this.initSort();
	      this.initBody(true);
	    }
	  }, {
	    key: "removeAll",
	    value: function removeAll() {
	      if (this.options.data.length > 0) {
	        this.options.data.splice(0, this.options.data.length);
	        this.initSearch();
	        this.initPagination();
	        this.initBody(true);
	      }
	    }
	  }, {
	    key: "insertRow",
	    value: function insertRow(params) {
	      if (!params.hasOwnProperty('index') || !params.hasOwnProperty('row')) {
	        return;
	      }

	      this.options.data.splice(params.index, 0, params.row);
	      this.initSearch();
	      this.initPagination();
	      this.initSort();
	      this.initBody(true);
	    }
	  }, {
	    key: "updateRow",
	    value: function updateRow(params) {
	      var allParams = Array.isArray(params) ? params : [params];
	      var _iteratorNormalCompletion5 = true;
	      var _didIteratorError5 = false;
	      var _iteratorError5 = undefined;

	      try {
	        for (var _iterator5 = allParams[Symbol.iterator](), _step5; !(_iteratorNormalCompletion5 = (_step5 = _iterator5.next()).done); _iteratorNormalCompletion5 = true) {
	          var _params = _step5.value;

	          if (!_params.hasOwnProperty('index') || !_params.hasOwnProperty('row')) {
	            continue;
	          }

	          $.extend(this.options.data[_params.index], _params.row);

	          if (_params.hasOwnProperty('replace') && _params.replace) {
	            this.options.data[_params.index] = _params.row;
	          } else {
	            $.extend(this.options.data[_params.index], _params.row);
	          }
	        }
	      } catch (err) {
	        _didIteratorError5 = true;
	        _iteratorError5 = err;
	      } finally {
	        try {
	          if (!_iteratorNormalCompletion5 && _iterator5.return != null) {
	            _iterator5.return();
	          }
	        } finally {
	          if (_didIteratorError5) {
	            throw _iteratorError5;
	          }
	        }
	      }

	      this.initSearch();
	      this.initPagination();
	      this.initSort();
	      this.initBody(true);
	    }
	  }, {
	    key: "getRowByUniqueId",
	    value: function getRowByUniqueId(_id) {
	      var uniqueId = this.options.uniqueId;
	      var len = this.options.data.length;
	      var id = _id;
	      var dataRow = null;
	      var i;
	      var row;
	      var rowUniqueId;

	      for (i = len - 1; i >= 0; i--) {
	        row = this.options.data[i];

	        if (row.hasOwnProperty(uniqueId)) {
	          // uniqueId is a column
	          rowUniqueId = row[uniqueId];
	        } else if (row._data && row._data.hasOwnProperty(uniqueId)) {
	          // uniqueId is a row data property
	          rowUniqueId = row._data[uniqueId];
	        } else {
	          continue;
	        }

	        if (typeof rowUniqueId === 'string') {
	          id = id.toString();
	        } else if (typeof rowUniqueId === 'number') {
	          if (Number(rowUniqueId) === rowUniqueId && rowUniqueId % 1 === 0) {
	            id = parseInt(id);
	          } else if (rowUniqueId === Number(rowUniqueId) && rowUniqueId !== 0) {
	            id = parseFloat(id);
	          }
	        }

	        if (rowUniqueId === id) {
	          dataRow = row;
	          break;
	        }
	      }

	      return dataRow;
	    }
	  }, {
	    key: "updateByUniqueId",
	    value: function updateByUniqueId(params) {
	      var allParams = Array.isArray(params) ? params : [params];
	      var _iteratorNormalCompletion6 = true;
	      var _didIteratorError6 = false;
	      var _iteratorError6 = undefined;

	      try {
	        for (var _iterator6 = allParams[Symbol.iterator](), _step6; !(_iteratorNormalCompletion6 = (_step6 = _iterator6.next()).done); _iteratorNormalCompletion6 = true) {
	          var _params2 = _step6.value;

	          if (!_params2.hasOwnProperty('id') || !_params2.hasOwnProperty('row')) {
	            continue;
	          }

	          var rowId = this.options.data.indexOf(this.getRowByUniqueId(_params2.id));

	          if (rowId === -1) {
	            continue;
	          }

	          if (_params2.hasOwnProperty('replace') && _params2.replace) {
	            this.options.data[rowId] = _params2.row;
	          } else {
	            $.extend(this.options.data[rowId], _params2.row);
	          }
	        }
	      } catch (err) {
	        _didIteratorError6 = true;
	        _iteratorError6 = err;
	      } finally {
	        try {
	          if (!_iteratorNormalCompletion6 && _iterator6.return != null) {
	            _iterator6.return();
	          }
	        } finally {
	          if (_didIteratorError6) {
	            throw _iteratorError6;
	          }
	        }
	      }

	      this.initSearch();
	      this.initPagination();
	      this.initSort();
	      this.initBody(true);
	    }
	  }, {
	    key: "removeByUniqueId",
	    value: function removeByUniqueId(id) {
	      var len = this.options.data.length;
	      var row = this.getRowByUniqueId(id);

	      if (row) {
	        this.options.data.splice(this.options.data.indexOf(row), 1);
	      }

	      if (len === this.options.data.length) {
	        return;
	      }

	      this.initSearch();
	      this.initPagination();
	      this.initBody(true);
	    }
	  }, {
	    key: "updateCell",
	    value: function updateCell(params) {
	      if (!params.hasOwnProperty('index') || !params.hasOwnProperty('field') || !params.hasOwnProperty('value')) {
	        return;
	      }

	      this.data[params.index][params.field] = params.value;

	      if (params.reinit === false) {
	        return;
	      }

	      this.initSort();
	      this.initBody(true);
	    }
	  }, {
	    key: "updateCellByUniqueId",
	    value: function updateCellByUniqueId(params) {
	      var _this19 = this;

	      if (!params.hasOwnProperty('id') || !params.hasOwnProperty('field') || !params.hasOwnProperty('value')) {
	        return;
	      }

	      var allParams = Array.isArray(params) ? params : [params];
	      allParams.forEach(function (_ref6) {
	        var id = _ref6.id,
	            field = _ref6.field,
	            value = _ref6.value;

	        var rowId = _this19.options.data.indexOf(_this19.getRowByUniqueId(id));

	        if (rowId === -1) {
	          return;
	        }

	        _this19.options.data[rowId][field] = value;
	      });

	      if (params.reinit === false) {
	        return;
	      }

	      this.initSort();
	      this.initBody(true);
	    }
	  }, {
	    key: "showRow",
	    value: function showRow(params) {
	      this._toggleRow(params, true);
	    }
	  }, {
	    key: "hideRow",
	    value: function hideRow(params) {
	      this._toggleRow(params, false);
	    }
	  }, {
	    key: "_toggleRow",
	    value: function _toggleRow(params, visible) {
	      var row;

	      if (params.hasOwnProperty('index')) {
	        row = this.getData()[params.index];
	      } else if (params.hasOwnProperty('uniqueId')) {
	        row = this.getRowByUniqueId(params.uniqueId);
	      }

	      if (!row) {
	        return;
	      }

	      var index = Utils.findIndex(this.hiddenRows, row);

	      if (!visible && index === -1) {
	        this.hiddenRows.push(row);
	      } else if (visible && index > -1) {
	        this.hiddenRows.splice(index, 1);
	      }

	      if (visible) {
	        this.updatePagination();
	      } else {
	        this.initBody(true);
	        this.initPagination();
	      }
	    }
	  }, {
	    key: "getHiddenRows",
	    value: function getHiddenRows(show) {
	      if (show) {
	        this.initHiddenRows();
	        this.initBody(true);
	        return;
	      }

	      var data = this.getData();
	      var rows = [];
	      var _iteratorNormalCompletion7 = true;
	      var _didIteratorError7 = false;
	      var _iteratorError7 = undefined;

	      try {
	        for (var _iterator7 = data[Symbol.iterator](), _step7; !(_iteratorNormalCompletion7 = (_step7 = _iterator7.next()).done); _iteratorNormalCompletion7 = true) {
	          var row = _step7.value;

	          if (this.hiddenRows.includes(row)) {
	            rows.push(row);
	          }
	        }
	      } catch (err) {
	        _didIteratorError7 = true;
	        _iteratorError7 = err;
	      } finally {
	        try {
	          if (!_iteratorNormalCompletion7 && _iterator7.return != null) {
	            _iterator7.return();
	          }
	        } finally {
	          if (_didIteratorError7) {
	            throw _iteratorError7;
	          }
	        }
	      }

	      this.hiddenRows = rows;
	      return rows;
	    }
	  }, {
	    key: "showColumn",
	    value: function showColumn(field) {
	      var _this20 = this;

	      var fields = Array.isArray(field) ? field : [field];
	      fields.forEach(function (field) {
	        _this20._toggleColumn(_this20.fieldsColumnsIndex[field], true, true);
	      });
	    }
	  }, {
	    key: "hideColumn",
	    value: function hideColumn(field) {
	      var _this21 = this;

	      var fields = Array.isArray(field) ? field : [field];
	      fields.forEach(function (field) {
	        _this21._toggleColumn(_this21.fieldsColumnsIndex[field], false, true);
	      });
	    }
	  }, {
	    key: "_toggleColumn",
	    value: function _toggleColumn(index, checked, needUpdate) {
	      if (index === -1 || this.columns[index].visible === checked) {
	        return;
	      }

	      this.columns[index].visible = checked;
	      this.initHeader();
	      this.initSearch();
	      this.initPagination();
	      this.initBody();

	      if (this.options.showColumns) {
	        var $items = this.$toolbar.find('.keep-open input:not(".toggle-all")').prop('disabled', false);

	        if (needUpdate) {
	          $items.filter(Utils.sprintf('[value="%s"]', index)).prop('checked', checked);
	        }

	        if ($items.filter(':checked').length <= this.options.minimumCountColumns) {
	          $items.filter(':checked').prop('disabled', true);
	        }
	      }
	    }
	  }, {
	    key: "getVisibleColumns",
	    value: function getVisibleColumns() {
	      var _this22 = this;

	      return this.columns.filter(function (column) {
	        return column.visible && !_this22.isSelectionColumn(column);
	      });
	    }
	  }, {
	    key: "getHiddenColumns",
	    value: function getHiddenColumns() {
	      return this.columns.filter(function (_ref7) {
	        var visible = _ref7.visible;
	        return !visible;
	      });
	    }
	  }, {
	    key: "isSelectionColumn",
	    value: function isSelectionColumn(column) {
	      return column.radio || column.checkbox;
	    }
	  }, {
	    key: "showAllColumns",
	    value: function showAllColumns() {
	      this._toggleAllColumns(true);
	    }
	  }, {
	    key: "hideAllColumns",
	    value: function hideAllColumns() {
	      this._toggleAllColumns(false);
	    }
	  }, {
	    key: "_toggleAllColumns",
	    value: function _toggleAllColumns(visible) {
	      var _this23 = this;

	      var _iteratorNormalCompletion8 = true;
	      var _didIteratorError8 = false;
	      var _iteratorError8 = undefined;

	      try {
	        for (var _iterator8 = this.columns.slice().reverse()[Symbol.iterator](), _step8; !(_iteratorNormalCompletion8 = (_step8 = _iterator8.next()).done); _iteratorNormalCompletion8 = true) {
	          var column = _step8.value;

	          if (column.switchable) {
	            if (!visible && this.options.showColumns && this.getVisibleColumns().length === this.options.minimumCountColumns) {
	              continue;
	            }

	            column.visible = visible;
	          }
	        }
	      } catch (err) {
	        _didIteratorError8 = true;
	        _iteratorError8 = err;
	      } finally {
	        try {
	          if (!_iteratorNormalCompletion8 && _iterator8.return != null) {
	            _iterator8.return();
	          }
	        } finally {
	          if (_didIteratorError8) {
	            throw _iteratorError8;
	          }
	        }
	      }

	      this.initHeader();
	      this.initSearch();
	      this.initPagination();
	      this.initBody();

	      if (this.options.showColumns) {
	        var $items = this.$toolbar.find('.keep-open input[type="checkbox"]:not(".toggle-all")').prop('disabled', false);

	        if (visible) {
	          $items.prop('checked', visible);
	        } else {
	          $items.get().reverse().forEach(function (item) {
	            if ($items.filter(':checked').length > _this23.options.minimumCountColumns) {
	              $(item).prop('checked', visible);
	            }
	          });
	        }

	        if ($items.filter(':checked').length <= this.options.minimumCountColumns) {
	          $items.filter(':checked').prop('disabled', true);
	        }
	      }
	    }
	  }, {
	    key: "mergeCells",
	    value: function mergeCells(options) {
	      var row = options.index;
	      var col = this.getVisibleFields().indexOf(options.field);
	      var rowspan = options.rowspan || 1;
	      var colspan = options.colspan || 1;
	      var i;
	      var j;
	      var $tr = this.$body.find('>tr');

	      if (this.options.detailView && !this.options.cardView) {
	        col += 1;
	      }

	      var $td = $tr.eq(row).find('>td').eq(col);

	      if (row < 0 || col < 0 || row >= this.data.length) {
	        return;
	      }

	      for (i = row; i < row + rowspan; i++) {
	        for (j = col; j < col + colspan; j++) {
	          $tr.eq(i).find('>td').eq(j).hide();
	        }
	      }

	      $td.attr('rowspan', rowspan).attr('colspan', colspan).show();
	    }
	  }, {
	    key: "checkAll",
	    value: function checkAll() {
	      this._toggleCheckAll(true);
	    }
	  }, {
	    key: "uncheckAll",
	    value: function uncheckAll() {
	      this._toggleCheckAll(false);
	    }
	  }, {
	    key: "_toggleCheckAll",
	    value: function _toggleCheckAll(checked) {
	      var rowsBefore = this.getSelections();
	      this.$selectAll.add(this.$selectAll_).prop('checked', checked);
	      this.$selectItem.filter(':enabled').prop('checked', checked);
	      this.updateRows();
	      var rowsAfter = this.getSelections();

	      if (checked) {
	        this.trigger('check-all', rowsAfter, rowsBefore);
	        return;
	      }

	      this.trigger('uncheck-all', rowsAfter, rowsBefore);
	    }
	  }, {
	    key: "checkInvert",
	    value: function checkInvert() {
	      var $items = this.$selectItem.filter(':enabled');
	      var checked = $items.filter(':checked');
	      $items.each(function (i, el) {
	        $(el).prop('checked', !$(el).prop('checked'));
	      });
	      this.updateRows();
	      this.updateSelected();
	      this.trigger('uncheck-some', checked);
	      checked = this.getSelections();
	      this.trigger('check-some', checked);
	    }
	  }, {
	    key: "check",
	    value: function check(index) {
	      this._toggleCheck(true, index);
	    }
	  }, {
	    key: "uncheck",
	    value: function uncheck(index) {
	      this._toggleCheck(false, index);
	    }
	  }, {
	    key: "_toggleCheck",
	    value: function _toggleCheck(checked, index) {
	      var $el = this.$selectItem.filter("[data-index=\"".concat(index, "\"]"));
	      var row = this.data[index];

	      if ($el.is(':radio') || this.options.singleSelect || this.options.multipleSelectRow && !this.multipleSelectRowCtrlKey && !this.multipleSelectRowShiftKey) {
	        var _iteratorNormalCompletion9 = true;
	        var _didIteratorError9 = false;
	        var _iteratorError9 = undefined;

	        try {
	          for (var _iterator9 = this.options.data[Symbol.iterator](), _step9; !(_iteratorNormalCompletion9 = (_step9 = _iterator9.next()).done); _iteratorNormalCompletion9 = true) {
	            var r = _step9.value;
	            r[this.header.stateField] = false;
	          }
	        } catch (err) {
	          _didIteratorError9 = true;
	          _iteratorError9 = err;
	        } finally {
	          try {
	            if (!_iteratorNormalCompletion9 && _iterator9.return != null) {
	              _iterator9.return();
	            }
	          } finally {
	            if (_didIteratorError9) {
	              throw _iteratorError9;
	            }
	          }
	        }

	        this.$selectItem.filter(':checked').not($el).prop('checked', false);
	      }

	      row[this.header.stateField] = checked;

	      if (this.options.multipleSelectRow) {
	        if (this.multipleSelectRowShiftKey && this.multipleSelectRowLastSelectedIndex >= 0) {
	          var indexes = [this.multipleSelectRowLastSelectedIndex, index].sort();

	          for (var i = indexes[0] + 1; i < indexes[1]; i++) {
	            this.data[i][this.header.stateField] = true;
	            this.$selectItem.filter("[data-index=\"".concat(i, "\"]")).prop('checked', true);
	          }
	        }

	        this.multipleSelectRowCtrlKey = false;
	        this.multipleSelectRowShiftKey = false;
	        this.multipleSelectRowLastSelectedIndex = checked ? index : -1;
	      }

	      $el.prop('checked', checked);
	      this.updateSelected();
	      this.trigger(checked ? 'check' : 'uncheck', this.data[index], $el);
	    }
	  }, {
	    key: "checkBy",
	    value: function checkBy(obj) {
	      this._toggleCheckBy(true, obj);
	    }
	  }, {
	    key: "uncheckBy",
	    value: function uncheckBy(obj) {
	      this._toggleCheckBy(false, obj);
	    }
	  }, {
	    key: "_toggleCheckBy",
	    value: function _toggleCheckBy(checked, obj) {
	      var _this24 = this;

	      if (!obj.hasOwnProperty('field') || !obj.hasOwnProperty('values')) {
	        return;
	      }

	      var rows = [];
	      this.data.forEach(function (row, i) {
	        if (!row.hasOwnProperty(obj.field)) {
	          return false;
	        }

	        if (obj.values.includes(row[obj.field])) {
	          var $el = _this24.$selectItem.filter(':enabled').filter(Utils.sprintf('[data-index="%s"]', i));

	          $el = checked ? $el.not(':checked') : $el.filter(':checked');

	          if (!$el.length) {
	            return;
	          }

	          $el.prop('checked', checked);
	          row[_this24.header.stateField] = checked;
	          rows.push(row);

	          _this24.trigger(checked ? 'check' : 'uncheck', row, $el);
	        }
	      });
	      this.updateSelected();
	      this.trigger(checked ? 'check-some' : 'uncheck-some', rows);
	    }
	  }, {
	    key: "refresh",
	    value: function refresh(params) {
	      if (params && params.url) {
	        this.options.url = params.url;
	      }

	      if (params && params.pageNumber) {
	        this.options.pageNumber = params.pageNumber;
	      }

	      if (params && params.pageSize) {
	        this.options.pageSize = params.pageSize;
	      }

	      this.trigger('refresh', this.initServer(params && params.silent, params && params.query, params && params.url));
	    }
	  }, {
	    key: "destroy",
	    value: function destroy() {
	      this.$el.insertBefore(this.$container);
	      $(this.options.toolbar).insertBefore(this.$el);
	      this.$container.next().remove();
	      this.$container.remove();
	      this.$el.html(this.$el_.html()).css('margin-top', '0').attr('class', this.$el_.attr('class') || ''); // reset the class
	    }
	  }, {
	    key: "resetView",
	    value: function resetView(params) {
	      var padding = 0;

	      if (params && params.height) {
	        this.options.height = params.height;
	      }

	      this.$selectAll.prop('checked', this.$selectItem.length > 0 && this.$selectItem.length === this.$selectItem.filter(':checked').length);
	      this.$tableContainer.toggleClass('has-card-view', this.options.cardView);

	      if (!this.options.cardView && this.options.showHeader && this.options.height) {
	        this.$tableHeader.show();
	        this.resetHeader();
	        padding += this.$header.outerHeight(true) + 1;
	      } else {
	        this.$tableHeader.hide();
	        this.trigger('post-header');
	      }

	      if (!this.options.cardView && this.options.showFooter) {
	        this.$tableFooter.show();
	        this.fitFooter();

	        if (this.options.height) {
	          padding += this.$tableFooter.outerHeight(true);
	        }
	      }

	      if (this.$container.hasClass('fullscreen')) {
	        this.$tableContainer.css('height', '');
	        this.$tableContainer.css('width', '');
	      } else if (this.options.height) {
	        var toolbarHeight = this.$toolbar.outerHeight(true);
	        var paginationHeight = this.$pagination.outerHeight(true);
	        var height = this.options.height - toolbarHeight - paginationHeight;
	        var $bodyTable = this.$tableBody.find('>table');
	        var tableHeight = $bodyTable.outerHeight();
	        this.$tableContainer.css('height', "".concat(height, "px"));

	        if (this.$tableBorder) {
	          var tableBorderHeight = height - tableHeight - 2;

	          if (this.$tableBody[0].scrollWidth - this.$tableBody.innerWidth()) {
	            tableBorderHeight -= Utils.getScrollBarWidth();
	          }

	          this.$tableBorder.css('width', "".concat($bodyTable.outerWidth(), "px"));
	          this.$tableBorder.css('height', "".concat(tableBorderHeight, "px"));
	        }
	      }

	      if (this.options.cardView) {
	        // remove the element css
	        this.$el.css('margin-top', '0');
	        this.$tableContainer.css('padding-bottom', '0');
	        this.$tableFooter.hide();
	      } else {
	        // Assign the correct sortable arrow
	        this.getCaret();
	        this.$tableContainer.css('padding-bottom', "".concat(padding, "px"));
	      }

	      this.trigger('reset-view');
	    }
	  }, {
	    key: "showLoading",
	    value: function showLoading() {
	      this.$tableLoading.css('display', 'flex');
	    }
	  }, {
	    key: "hideLoading",
	    value: function hideLoading() {
	      this.$tableLoading.css('display', 'none');
	    }
	  }, {
	    key: "togglePagination",
	    value: function togglePagination() {
	      this.options.pagination = !this.options.pagination;
	      var icon = this.options.showButtonIcons ? this.options.pagination ? this.options.icons.paginationSwitchDown : this.options.icons.paginationSwitchUp : '';
	      var text = this.options.showButtonText ? this.options.pagination ? this.options.formatPaginationSwitchUp() : this.options.formatPaginationSwitchDown() : '';
	      this.$toolbar.find('button[name="paginationSwitch"]').html(Utils.sprintf(this.constants.html.icon, this.options.iconsPrefix, icon) + ' ' + text);
	      this.updatePagination();
	    }
	  }, {
	    key: "toggleFullscreen",
	    value: function toggleFullscreen() {
	      this.$el.closest('.bootstrap-table').toggleClass('fullscreen');
	      this.resetView();
	    }
	  }, {
	    key: "toggleView",
	    value: function toggleView() {
	      this.options.cardView = !this.options.cardView;
	      this.initHeader();
	      var icon = this.options.showButtonIcons ? this.options.cardView ? this.options.icons.toggleOn : this.options.icons.toggleOff : '';
	      var text = this.options.showButtonText ? this.options.cardView ? this.options.formatToggleOff() : this.options.formatToggleOn() : '';
	      this.$toolbar.find('button[name="toggle"]').html(Utils.sprintf(this.constants.html.icon, this.options.iconsPrefix, icon) + ' ' + text);
	      this.initBody();
	      this.trigger('toggle', this.options.cardView);
	    }
	  }, {
	    key: "resetSearch",
	    value: function resetSearch(text) {
	      var $search = this.$toolbar.find('.search input');
	      $search.val(text || '');
	      this.onSearch({
	        currentTarget: $search
	      });
	    }
	  }, {
	    key: "filterBy",
	    value: function filterBy(columns, options) {
	      this.filterOptions = Utils.isEmptyObject(options) ? this.options.filterOptions : $.extend(this.options.filterOptions, options);
	      this.filterColumns = Utils.isEmptyObject(columns) ? {} : columns;
	      this.options.pageNumber = 1;
	      this.initSearch();
	      this.updatePagination();
	    }
	  }, {
	    key: "scrollTo",
	    value: function scrollTo(params) {
	      if (typeof params === 'undefined') {
	        return this.$tableBody.scrollTop();
	      }

	      var options = {
	        unit: 'px',
	        value: 0
	      };

	      if (_typeof(params) === 'object') {
	        options = Object.assign(options, params);
	      } else if (typeof params === 'string' && params === 'bottom') {
	        options.value = this.$tableBody[0].scrollHeight;
	      } else if (typeof params === 'string') {
	        options.value = params;
	      }

	      var scrollTo = options.value;

	      if (options.unit === 'rows') {
	        scrollTo = 0;
	        this.$body.find("> tr:lt(".concat(options.value, ")")).each(function (i, el) {
	          scrollTo += $(el).outerHeight(true);
	        });
	      }

	      this.$tableBody.scrollTop(scrollTo);
	    }
	  }, {
	    key: "getScrollPosition",
	    value: function getScrollPosition() {
	      return this.scrollTo();
	    }
	  }, {
	    key: "selectPage",
	    value: function selectPage(page) {
	      if (page > 0 && page <= this.options.totalPages) {
	        this.options.pageNumber = page;
	        this.updatePagination();
	      }
	    }
	  }, {
	    key: "prevPage",
	    value: function prevPage() {
	      if (this.options.pageNumber > 1) {
	        this.options.pageNumber--;
	        this.updatePagination();
	      }
	    }
	  }, {
	    key: "nextPage",
	    value: function nextPage() {
	      if (this.options.pageNumber < this.options.totalPages) {
	        this.options.pageNumber++;
	        this.updatePagination();
	      }
	    }
	  }, {
	    key: "toggleDetailView",
	    value: function toggleDetailView(index, _columnDetailFormatter) {
	      var $tr = this.$body.find(Utils.sprintf('> tr[data-index="%s"]', index));

	      if ($tr.next().is('tr.detail-view')) {
	        this.collapseRow(index);
	      } else {
	        this.expandRow(index, _columnDetailFormatter);
	      }

	      this.resetView();
	    }
	  }, {
	    key: "expandRow",
	    value: function expandRow(index, _columnDetailFormatter) {
	      var row = this.data[index];
	      var $tr = this.$body.find(Utils.sprintf('> tr[data-index="%s"][data-has-detail-view]', index));

	      if ($tr.next().is('tr.detail-view')) {
	        return;
	      }

	      if (this.options.detailViewIcon) {
	        $tr.find('a.detail-icon').html(Utils.sprintf(this.constants.html.icon, this.options.iconsPrefix, this.options.icons.detailClose));
	      }

	      $tr.after(Utils.sprintf('<tr class="detail-view"><td colspan="%s"></td></tr>', $tr.children('td').length));
	      var $element = $tr.next().find('td');
	      var detailFormatter = _columnDetailFormatter || this.options.detailFormatter;
	      var content = Utils.calculateObjectValue(this.options, detailFormatter, [index, row, $element], '');

	      if ($element.length === 1) {
	        $element.append(content);
	      }

	      this.trigger('expand-row', index, row, $element);
	    }
	  }, {
	    key: "collapseRow",
	    value: function collapseRow(index) {
	      var row = this.data[index];
	      var $tr = this.$body.find(Utils.sprintf('> tr[data-index="%s"][data-has-detail-view]', index));

	      if (!$tr.next().is('tr.detail-view')) {
	        return;
	      }

	      if (this.options.detailViewIcon) {
	        $tr.find('a.detail-icon').html(Utils.sprintf(this.constants.html.icon, this.options.iconsPrefix, this.options.icons.detailOpen));
	      }

	      this.trigger('collapse-row', index, row, $tr.next());
	      $tr.next().remove();
	    }
	  }, {
	    key: "expandAllRows",
	    value: function expandAllRows() {
	      var trs = this.$body.find('> tr[data-index][data-has-detail-view]');

	      for (var i = 0; i < trs.length; i++) {
	        this.expandRow($(trs[i]).data('index'));
	      }
	    }
	  }, {
	    key: "collapseAllRows",
	    value: function collapseAllRows() {
	      var trs = this.$body.find('> tr[data-index][data-has-detail-view]');

	      for (var i = 0; i < trs.length; i++) {
	        this.collapseRow($(trs[i]).data('index'));
	      }
	    }
	  }, {
	    key: "updateColumnTitle",
	    value: function updateColumnTitle(params) {
	      if (!params.hasOwnProperty('field') || !params.hasOwnProperty('title')) {
	        return;
	      }

	      this.columns[this.fieldsColumnsIndex[params.field]].title = this.options.escape ? Utils.escapeHTML(params.title) : params.title;

	      if (this.columns[this.fieldsColumnsIndex[params.field]].visible) {
	        var header = this.options.height !== undefined ? this.$tableHeader : this.$header;
	        header.find('th[data-field]').each(function (i, el) {
	          if ($(el).data('field') === params.field) {
	            $($(el).find('.th-inner')[0]).text(params.title);
	            return false;
	          }
	        });
	      }
	    }
	  }, {
	    key: "updateFormatText",
	    value: function updateFormatText(formatName, text) {
	      if (!/^format/.test(formatName) || !this.options[formatName]) {
	        return;
	      }

	      if (typeof text === 'string') {
	        this.options[formatName] = function () {
	          return text;
	        };
	      } else if (typeof text === 'function') {
	        this.options[formatName] = text;
	      }

	      this.initToolbar();
	      this.initPagination();
	      this.initBody();
	    }
	  }]);

	  return BootstrapTable;
	}();

	BootstrapTable.VERSION = Constants.VERSION;
	BootstrapTable.DEFAULTS = Constants.DEFAULTS;
	BootstrapTable.LOCALES = Constants.LOCALES;
	BootstrapTable.COLUMN_DEFAULTS = Constants.COLUMN_DEFAULTS;
	BootstrapTable.METHODS = Constants.METHODS;
	BootstrapTable.EVENTS = Constants.EVENTS; // BOOTSTRAP TABLE PLUGIN DEFINITION
	// =======================

	$.BootstrapTable = BootstrapTable;

	$.fn.bootstrapTable = function (option) {
	  for (var _len2 = arguments.length, args = new Array(_len2 > 1 ? _len2 - 1 : 0), _key5 = 1; _key5 < _len2; _key5++) {
	    args[_key5 - 1] = arguments[_key5];
	  }

	  var value;
	  this.each(function (i, el) {
	    var data = $(el).data('bootstrap.table');
	    var options = $.extend({}, BootstrapTable.DEFAULTS, $(el).data(), _typeof(option) === 'object' && option);

	    if (typeof option === 'string') {
	      var _data2;

	      if (!Constants.METHODS.includes(option)) {
	        throw new Error("Unknown method: ".concat(option));
	      }

	      if (!data) {
	        return;
	      }

	      value = (_data2 = data)[option].apply(_data2, args);

	      if (option === 'destroy') {
	        $(el).removeData('bootstrap.table');
	      }
	    }

	    if (!data) {
	      $(el).data('bootstrap.table', data = new $.BootstrapTable(el, options));
	    }
	  });
	  return typeof value === 'undefined' ? this : value;
	};

	$.fn.bootstrapTable.Constructor = BootstrapTable;
	$.fn.bootstrapTable.theme = Constants.THEME;
	$.fn.bootstrapTable.VERSION = Constants.VERSION;
	$.fn.bootstrapTable.defaults = BootstrapTable.DEFAULTS;
	$.fn.bootstrapTable.columnDefaults = BootstrapTable.COLUMN_DEFAULTS;
	$.fn.bootstrapTable.events = BootstrapTable.EVENTS;
	$.fn.bootstrapTable.locales = BootstrapTable.LOCALES;
	$.fn.bootstrapTable.methods = BootstrapTable.METHODS;
	$.fn.bootstrapTable.utils = Utils; // BOOTSTRAP TABLE INIT
	// =======================

	$(function () {
	  $('[data-toggle="table"]').bootstrapTable();
	});

	return BootstrapTable;

})));
