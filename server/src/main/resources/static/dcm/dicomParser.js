/*! dicom-parser - 1.8.12 - 2023-02-20 | (c) 2017 Chris Hafey | https://github.com/cornerstonejs/dicomParser */
(function webpackUniversalModuleDefinition(root, factory) {
	if(typeof exports === 'object' && typeof module === 'object')
		module.exports = factory(require("zlib"));
	else if(typeof define === 'function' && define.amd)
		define("dicom-parser", ["zlib"], factory);
	else if(typeof exports === 'object')
		exports["dicom-parser"] = factory(require("zlib"));
	else
		root["dicomParser"] = factory(root["zlib"]);
})(this, function(__WEBPACK_EXTERNAL_MODULE_zlib__) {
return /******/ (function(modules) { // webpackBootstrap
/******/ 	function hotDisposeChunk(chunkId) {
/******/ 		delete installedChunks[chunkId];
/******/ 	}
/******/ 	var parentHotUpdateCallback = this["webpackHotUpdate"];
/******/ 	this["webpackHotUpdate"] = // eslint-disable-next-line no-unused-vars
/******/ 	function webpackHotUpdateCallback(chunkId, moreModules) {
/******/ 		hotAddUpdateChunk(chunkId, moreModules);
/******/ 		if (parentHotUpdateCallback) parentHotUpdateCallback(chunkId, moreModules);
/******/ 	} ;
/******/
/******/ 	// eslint-disable-next-line no-unused-vars
/******/ 	function hotDownloadUpdateChunk(chunkId) {
/******/ 		var script = document.createElement("script");
/******/ 		script.charset = "utf-8";
/******/ 		script.src = __webpack_require__.p + "" + chunkId + "." + hotCurrentHash + ".hot-update.js";
/******/ 		if (null) script.crossOrigin = null;
/******/ 		document.head.appendChild(script);
/******/ 	}
/******/
/******/ 	// eslint-disable-next-line no-unused-vars
/******/ 	function hotDownloadManifest(requestTimeout) {
/******/ 		requestTimeout = requestTimeout || 10000;
/******/ 		return new Promise(function(resolve, reject) {
/******/ 			if (typeof XMLHttpRequest === "undefined") {
/******/ 				return reject(new Error("No browser support"));
/******/ 			}
/******/ 			try {
/******/ 				var request = new XMLHttpRequest();
/******/ 				var requestPath = __webpack_require__.p + "" + hotCurrentHash + ".hot-update.json";
/******/ 				request.open("GET", requestPath, true);
/******/ 				request.timeout = requestTimeout;
/******/ 				request.send(null);
/******/ 			} catch (err) {
/******/ 				return reject(err);
/******/ 			}
/******/ 			request.onreadystatechange = function() {
/******/ 				if (request.readyState !== 4) return;
/******/ 				if (request.status === 0) {
/******/ 					// timeout
/******/ 					reject(
/******/ 						new Error("Manifest request to " + requestPath + " timed out.")
/******/ 					);
/******/ 				} else if (request.status === 404) {
/******/ 					// no update available
/******/ 					resolve();
/******/ 				} else if (request.status !== 200 && request.status !== 304) {
/******/ 					// other failure
/******/ 					reject(new Error("Manifest request to " + requestPath + " failed."));
/******/ 				} else {
/******/ 					// success
/******/ 					try {
/******/ 						var update = JSON.parse(request.responseText);
/******/ 					} catch (e) {
/******/ 						reject(e);
/******/ 						return;
/******/ 					}
/******/ 					resolve(update);
/******/ 				}
/******/ 			};
/******/ 		});
/******/ 	}
/******/
/******/ 	var hotApplyOnUpdate = true;
/******/ 	// eslint-disable-next-line no-unused-vars
/******/ 	var hotCurrentHash = "1c62e16b6d24be6b7eef";
/******/ 	var hotRequestTimeout = 10000;
/******/ 	var hotCurrentModuleData = {};
/******/ 	var hotCurrentChildModule;
/******/ 	// eslint-disable-next-line no-unused-vars
/******/ 	var hotCurrentParents = [];
/******/ 	// eslint-disable-next-line no-unused-vars
/******/ 	var hotCurrentParentsTemp = [];
/******/
/******/ 	// eslint-disable-next-line no-unused-vars
/******/ 	function hotCreateRequire(moduleId) {
/******/ 		var me = installedModules[moduleId];
/******/ 		if (!me) return __webpack_require__;
/******/ 		var fn = function(request) {
/******/ 			if (me.hot.active) {
/******/ 				if (installedModules[request]) {
/******/ 					if (installedModules[request].parents.indexOf(moduleId) === -1) {
/******/ 						installedModules[request].parents.push(moduleId);
/******/ 					}
/******/ 				} else {
/******/ 					hotCurrentParents = [moduleId];
/******/ 					hotCurrentChildModule = request;
/******/ 				}
/******/ 				if (me.children.indexOf(request) === -1) {
/******/ 					me.children.push(request);
/******/ 				}
/******/ 			} else {
/******/ 				console.warn(
/******/ 					"[HMR] unexpected require(" +
/******/ 						request +
/******/ 						") from disposed module " +
/******/ 						moduleId
/******/ 				);
/******/ 				hotCurrentParents = [];
/******/ 			}
/******/ 			return __webpack_require__(request);
/******/ 		};
/******/ 		var ObjectFactory = function ObjectFactory(name) {
/******/ 			return {
/******/ 				configurable: true,
/******/ 				enumerable: true,
/******/ 				get: function() {
/******/ 					return __webpack_require__[name];
/******/ 				},
/******/ 				set: function(value) {
/******/ 					__webpack_require__[name] = value;
/******/ 				}
/******/ 			};
/******/ 		};
/******/ 		for (var name in __webpack_require__) {
/******/ 			if (
/******/ 				Object.prototype.hasOwnProperty.call(__webpack_require__, name) &&
/******/ 				name !== "e" &&
/******/ 				name !== "t"
/******/ 			) {
/******/ 				Object.defineProperty(fn, name, ObjectFactory(name));
/******/ 			}
/******/ 		}
/******/ 		fn.e = function(chunkId) {
/******/ 			if (hotStatus === "ready") hotSetStatus("prepare");
/******/ 			hotChunksLoading++;
/******/ 			return __webpack_require__.e(chunkId).then(finishChunkLoading, function(err) {
/******/ 				finishChunkLoading();
/******/ 				throw err;
/******/ 			});
/******/
/******/ 			function finishChunkLoading() {
/******/ 				hotChunksLoading--;
/******/ 				if (hotStatus === "prepare") {
/******/ 					if (!hotWaitingFilesMap[chunkId]) {
/******/ 						hotEnsureUpdateChunk(chunkId);
/******/ 					}
/******/ 					if (hotChunksLoading === 0 && hotWaitingFiles === 0) {
/******/ 						hotUpdateDownloaded();
/******/ 					}
/******/ 				}
/******/ 			}
/******/ 		};
/******/ 		fn.t = function(value, mode) {
/******/ 			if (mode & 1) value = fn(value);
/******/ 			return __webpack_require__.t(value, mode & ~1);
/******/ 		};
/******/ 		return fn;
/******/ 	}
/******/
/******/ 	// eslint-disable-next-line no-unused-vars
/******/ 	function hotCreateModule(moduleId) {
/******/ 		var hot = {
/******/ 			// private stuff
/******/ 			_acceptedDependencies: {},
/******/ 			_declinedDependencies: {},
/******/ 			_selfAccepted: false,
/******/ 			_selfDeclined: false,
/******/ 			_selfInvalidated: false,
/******/ 			_disposeHandlers: [],
/******/ 			_main: hotCurrentChildModule !== moduleId,
/******/
/******/ 			// Module API
/******/ 			active: true,
/******/ 			accept: function(dep, callback) {
/******/ 				if (dep === undefined) hot._selfAccepted = true;
/******/ 				else if (typeof dep === "function") hot._selfAccepted = dep;
/******/ 				else if (typeof dep === "object")
/******/ 					for (var i = 0; i < dep.length; i++)
/******/ 						hot._acceptedDependencies[dep[i]] = callback || function() {};
/******/ 				else hot._acceptedDependencies[dep] = callback || function() {};
/******/ 			},
/******/ 			decline: function(dep) {
/******/ 				if (dep === undefined) hot._selfDeclined = true;
/******/ 				else if (typeof dep === "object")
/******/ 					for (var i = 0; i < dep.length; i++)
/******/ 						hot._declinedDependencies[dep[i]] = true;
/******/ 				else hot._declinedDependencies[dep] = true;
/******/ 			},
/******/ 			dispose: function(callback) {
/******/ 				hot._disposeHandlers.push(callback);
/******/ 			},
/******/ 			addDisposeHandler: function(callback) {
/******/ 				hot._disposeHandlers.push(callback);
/******/ 			},
/******/ 			removeDisposeHandler: function(callback) {
/******/ 				var idx = hot._disposeHandlers.indexOf(callback);
/******/ 				if (idx >= 0) hot._disposeHandlers.splice(idx, 1);
/******/ 			},
/******/ 			invalidate: function() {
/******/ 				this._selfInvalidated = true;
/******/ 				switch (hotStatus) {
/******/ 					case "idle":
/******/ 						hotUpdate = {};
/******/ 						hotUpdate[moduleId] = modules[moduleId];
/******/ 						hotSetStatus("ready");
/******/ 						break;
/******/ 					case "ready":
/******/ 						hotApplyInvalidatedModule(moduleId);
/******/ 						break;
/******/ 					case "prepare":
/******/ 					case "check":
/******/ 					case "dispose":
/******/ 					case "apply":
/******/ 						(hotQueuedInvalidatedModules =
/******/ 							hotQueuedInvalidatedModules || []).push(moduleId);
/******/ 						break;
/******/ 					default:
/******/ 						// ignore requests in error states
/******/ 						break;
/******/ 				}
/******/ 			},
/******/
/******/ 			// Management API
/******/ 			check: hotCheck,
/******/ 			apply: hotApply,
/******/ 			status: function(l) {
/******/ 				if (!l) return hotStatus;
/******/ 				hotStatusHandlers.push(l);
/******/ 			},
/******/ 			addStatusHandler: function(l) {
/******/ 				hotStatusHandlers.push(l);
/******/ 			},
/******/ 			removeStatusHandler: function(l) {
/******/ 				var idx = hotStatusHandlers.indexOf(l);
/******/ 				if (idx >= 0) hotStatusHandlers.splice(idx, 1);
/******/ 			},
/******/
/******/ 			//inherit from previous dispose call
/******/ 			data: hotCurrentModuleData[moduleId]
/******/ 		};
/******/ 		hotCurrentChildModule = undefined;
/******/ 		return hot;
/******/ 	}
/******/
/******/ 	var hotStatusHandlers = [];
/******/ 	var hotStatus = "idle";
/******/
/******/ 	function hotSetStatus(newStatus) {
/******/ 		hotStatus = newStatus;
/******/ 		for (var i = 0; i < hotStatusHandlers.length; i++)
/******/ 			hotStatusHandlers[i].call(null, newStatus);
/******/ 	}
/******/
/******/ 	// while downloading
/******/ 	var hotWaitingFiles = 0;
/******/ 	var hotChunksLoading = 0;
/******/ 	var hotWaitingFilesMap = {};
/******/ 	var hotRequestedFilesMap = {};
/******/ 	var hotAvailableFilesMap = {};
/******/ 	var hotDeferred;
/******/
/******/ 	// The update info
/******/ 	var hotUpdate, hotUpdateNewHash, hotQueuedInvalidatedModules;
/******/
/******/ 	function toModuleId(id) {
/******/ 		var isNumber = +id + "" === id;
/******/ 		return isNumber ? +id : id;
/******/ 	}
/******/
/******/ 	function hotCheck(apply) {
/******/ 		if (hotStatus !== "idle") {
/******/ 			throw new Error("check() is only allowed in idle status");
/******/ 		}
/******/ 		hotApplyOnUpdate = apply;
/******/ 		hotSetStatus("check");
/******/ 		return hotDownloadManifest(hotRequestTimeout).then(function(update) {
/******/ 			if (!update) {
/******/ 				hotSetStatus(hotApplyInvalidatedModules() ? "ready" : "idle");
/******/ 				return null;
/******/ 			}
/******/ 			hotRequestedFilesMap = {};
/******/ 			hotWaitingFilesMap = {};
/******/ 			hotAvailableFilesMap = update.c;
/******/ 			hotUpdateNewHash = update.h;
/******/
/******/ 			hotSetStatus("prepare");
/******/ 			var promise = new Promise(function(resolve, reject) {
/******/ 				hotDeferred = {
/******/ 					resolve: resolve,
/******/ 					reject: reject
/******/ 				};
/******/ 			});
/******/ 			hotUpdate = {};
/******/ 			var chunkId = "dicomParser";
/******/ 			// eslint-disable-next-line no-lone-blocks
/******/ 			{
/******/ 				hotEnsureUpdateChunk(chunkId);
/******/ 			}
/******/ 			if (
/******/ 				hotStatus === "prepare" &&
/******/ 				hotChunksLoading === 0 &&
/******/ 				hotWaitingFiles === 0
/******/ 			) {
/******/ 				hotUpdateDownloaded();
/******/ 			}
/******/ 			return promise;
/******/ 		});
/******/ 	}
/******/
/******/ 	// eslint-disable-next-line no-unused-vars
/******/ 	function hotAddUpdateChunk(chunkId, moreModules) {
/******/ 		if (!hotAvailableFilesMap[chunkId] || !hotRequestedFilesMap[chunkId])
/******/ 			return;
/******/ 		hotRequestedFilesMap[chunkId] = false;
/******/ 		for (var moduleId in moreModules) {
/******/ 			if (Object.prototype.hasOwnProperty.call(moreModules, moduleId)) {
/******/ 				hotUpdate[moduleId] = moreModules[moduleId];
/******/ 			}
/******/ 		}
/******/ 		if (--hotWaitingFiles === 0 && hotChunksLoading === 0) {
/******/ 			hotUpdateDownloaded();
/******/ 		}
/******/ 	}
/******/
/******/ 	function hotEnsureUpdateChunk(chunkId) {
/******/ 		if (!hotAvailableFilesMap[chunkId]) {
/******/ 			hotWaitingFilesMap[chunkId] = true;
/******/ 		} else {
/******/ 			hotRequestedFilesMap[chunkId] = true;
/******/ 			hotWaitingFiles++;
/******/ 			hotDownloadUpdateChunk(chunkId);
/******/ 		}
/******/ 	}
/******/
/******/ 	function hotUpdateDownloaded() {
/******/ 		hotSetStatus("ready");
/******/ 		var deferred = hotDeferred;
/******/ 		hotDeferred = null;
/******/ 		if (!deferred) return;
/******/ 		if (hotApplyOnUpdate) {
/******/ 			// Wrap deferred object in Promise to mark it as a well-handled Promise to
/******/ 			// avoid triggering uncaught exception warning in Chrome.
/******/ 			// See https://bugs.chromium.org/p/chromium/issues/detail?id=465666
/******/ 			Promise.resolve()
/******/ 				.then(function() {
/******/ 					return hotApply(hotApplyOnUpdate);
/******/ 				})
/******/ 				.then(
/******/ 					function(result) {
/******/ 						deferred.resolve(result);
/******/ 					},
/******/ 					function(err) {
/******/ 						deferred.reject(err);
/******/ 					}
/******/ 				);
/******/ 		} else {
/******/ 			var outdatedModules = [];
/******/ 			for (var id in hotUpdate) {
/******/ 				if (Object.prototype.hasOwnProperty.call(hotUpdate, id)) {
/******/ 					outdatedModules.push(toModuleId(id));
/******/ 				}
/******/ 			}
/******/ 			deferred.resolve(outdatedModules);
/******/ 		}
/******/ 	}
/******/
/******/ 	function hotApply(options) {
/******/ 		if (hotStatus !== "ready")
/******/ 			throw new Error("apply() is only allowed in ready status");
/******/ 		options = options || {};
/******/ 		return hotApplyInternal(options);
/******/ 	}
/******/
/******/ 	function hotApplyInternal(options) {
/******/ 		hotApplyInvalidatedModules();
/******/
/******/ 		var cb;
/******/ 		var i;
/******/ 		var j;
/******/ 		var module;
/******/ 		var moduleId;
/******/
/******/ 		function getAffectedStuff(updateModuleId) {
/******/ 			var outdatedModules = [updateModuleId];
/******/ 			var outdatedDependencies = {};
/******/
/******/ 			var queue = outdatedModules.map(function(id) {
/******/ 				return {
/******/ 					chain: [id],
/******/ 					id: id
/******/ 				};
/******/ 			});
/******/ 			while (queue.length > 0) {
/******/ 				var queueItem = queue.pop();
/******/ 				var moduleId = queueItem.id;
/******/ 				var chain = queueItem.chain;
/******/ 				module = installedModules[moduleId];
/******/ 				if (
/******/ 					!module ||
/******/ 					(module.hot._selfAccepted && !module.hot._selfInvalidated)
/******/ 				)
/******/ 					continue;
/******/ 				if (module.hot._selfDeclined) {
/******/ 					return {
/******/ 						type: "self-declined",
/******/ 						chain: chain,
/******/ 						moduleId: moduleId
/******/ 					};
/******/ 				}
/******/ 				if (module.hot._main) {
/******/ 					return {
/******/ 						type: "unaccepted",
/******/ 						chain: chain,
/******/ 						moduleId: moduleId
/******/ 					};
/******/ 				}
/******/ 				for (var i = 0; i < module.parents.length; i++) {
/******/ 					var parentId = module.parents[i];
/******/ 					var parent = installedModules[parentId];
/******/ 					if (!parent) continue;
/******/ 					if (parent.hot._declinedDependencies[moduleId]) {
/******/ 						return {
/******/ 							type: "declined",
/******/ 							chain: chain.concat([parentId]),
/******/ 							moduleId: moduleId,
/******/ 							parentId: parentId
/******/ 						};
/******/ 					}
/******/ 					if (outdatedModules.indexOf(parentId) !== -1) continue;
/******/ 					if (parent.hot._acceptedDependencies[moduleId]) {
/******/ 						if (!outdatedDependencies[parentId])
/******/ 							outdatedDependencies[parentId] = [];
/******/ 						addAllToSet(outdatedDependencies[parentId], [moduleId]);
/******/ 						continue;
/******/ 					}
/******/ 					delete outdatedDependencies[parentId];
/******/ 					outdatedModules.push(parentId);
/******/ 					queue.push({
/******/ 						chain: chain.concat([parentId]),
/******/ 						id: parentId
/******/ 					});
/******/ 				}
/******/ 			}
/******/
/******/ 			return {
/******/ 				type: "accepted",
/******/ 				moduleId: updateModuleId,
/******/ 				outdatedModules: outdatedModules,
/******/ 				outdatedDependencies: outdatedDependencies
/******/ 			};
/******/ 		}
/******/
/******/ 		function addAllToSet(a, b) {
/******/ 			for (var i = 0; i < b.length; i++) {
/******/ 				var item = b[i];
/******/ 				if (a.indexOf(item) === -1) a.push(item);
/******/ 			}
/******/ 		}
/******/
/******/ 		// at begin all updates modules are outdated
/******/ 		// the "outdated" status can propagate to parents if they don't accept the children
/******/ 		var outdatedDependencies = {};
/******/ 		var outdatedModules = [];
/******/ 		var appliedUpdate = {};
/******/
/******/ 		var warnUnexpectedRequire = function warnUnexpectedRequire() {
/******/ 			console.warn(
/******/ 				"[HMR] unexpected require(" + result.moduleId + ") to disposed module"
/******/ 			);
/******/ 		};
/******/
/******/ 		for (var id in hotUpdate) {
/******/ 			if (Object.prototype.hasOwnProperty.call(hotUpdate, id)) {
/******/ 				moduleId = toModuleId(id);
/******/ 				/** @type {TODO} */
/******/ 				var result;
/******/ 				if (hotUpdate[id]) {
/******/ 					result = getAffectedStuff(moduleId);
/******/ 				} else {
/******/ 					result = {
/******/ 						type: "disposed",
/******/ 						moduleId: id
/******/ 					};
/******/ 				}
/******/ 				/** @type {Error|false} */
/******/ 				var abortError = false;
/******/ 				var doApply = false;
/******/ 				var doDispose = false;
/******/ 				var chainInfo = "";
/******/ 				if (result.chain) {
/******/ 					chainInfo = "\nUpdate propagation: " + result.chain.join(" -> ");
/******/ 				}
/******/ 				switch (result.type) {
/******/ 					case "self-declined":
/******/ 						if (options.onDeclined) options.onDeclined(result);
/******/ 						if (!options.ignoreDeclined)
/******/ 							abortError = new Error(
/******/ 								"Aborted because of self decline: " +
/******/ 									result.moduleId +
/******/ 									chainInfo
/******/ 							);
/******/ 						break;
/******/ 					case "declined":
/******/ 						if (options.onDeclined) options.onDeclined(result);
/******/ 						if (!options.ignoreDeclined)
/******/ 							abortError = new Error(
/******/ 								"Aborted because of declined dependency: " +
/******/ 									result.moduleId +
/******/ 									" in " +
/******/ 									result.parentId +
/******/ 									chainInfo
/******/ 							);
/******/ 						break;
/******/ 					case "unaccepted":
/******/ 						if (options.onUnaccepted) options.onUnaccepted(result);
/******/ 						if (!options.ignoreUnaccepted)
/******/ 							abortError = new Error(
/******/ 								"Aborted because " + moduleId + " is not accepted" + chainInfo
/******/ 							);
/******/ 						break;
/******/ 					case "accepted":
/******/ 						if (options.onAccepted) options.onAccepted(result);
/******/ 						doApply = true;
/******/ 						break;
/******/ 					case "disposed":
/******/ 						if (options.onDisposed) options.onDisposed(result);
/******/ 						doDispose = true;
/******/ 						break;
/******/ 					default:
/******/ 						throw new Error("Unexception type " + result.type);
/******/ 				}
/******/ 				if (abortError) {
/******/ 					hotSetStatus("abort");
/******/ 					return Promise.reject(abortError);
/******/ 				}
/******/ 				if (doApply) {
/******/ 					appliedUpdate[moduleId] = hotUpdate[moduleId];
/******/ 					addAllToSet(outdatedModules, result.outdatedModules);
/******/ 					for (moduleId in result.outdatedDependencies) {
/******/ 						if (
/******/ 							Object.prototype.hasOwnProperty.call(
/******/ 								result.outdatedDependencies,
/******/ 								moduleId
/******/ 							)
/******/ 						) {
/******/ 							if (!outdatedDependencies[moduleId])
/******/ 								outdatedDependencies[moduleId] = [];
/******/ 							addAllToSet(
/******/ 								outdatedDependencies[moduleId],
/******/ 								result.outdatedDependencies[moduleId]
/******/ 							);
/******/ 						}
/******/ 					}
/******/ 				}
/******/ 				if (doDispose) {
/******/ 					addAllToSet(outdatedModules, [result.moduleId]);
/******/ 					appliedUpdate[moduleId] = warnUnexpectedRequire;
/******/ 				}
/******/ 			}
/******/ 		}
/******/
/******/ 		// Store self accepted outdated modules to require them later by the module system
/******/ 		var outdatedSelfAcceptedModules = [];
/******/ 		for (i = 0; i < outdatedModules.length; i++) {
/******/ 			moduleId = outdatedModules[i];
/******/ 			if (
/******/ 				installedModules[moduleId] &&
/******/ 				installedModules[moduleId].hot._selfAccepted &&
/******/ 				// removed self-accepted modules should not be required
/******/ 				appliedUpdate[moduleId] !== warnUnexpectedRequire &&
/******/ 				// when called invalidate self-accepting is not possible
/******/ 				!installedModules[moduleId].hot._selfInvalidated
/******/ 			) {
/******/ 				outdatedSelfAcceptedModules.push({
/******/ 					module: moduleId,
/******/ 					parents: installedModules[moduleId].parents.slice(),
/******/ 					errorHandler: installedModules[moduleId].hot._selfAccepted
/******/ 				});
/******/ 			}
/******/ 		}
/******/
/******/ 		// Now in "dispose" phase
/******/ 		hotSetStatus("dispose");
/******/ 		Object.keys(hotAvailableFilesMap).forEach(function(chunkId) {
/******/ 			if (hotAvailableFilesMap[chunkId] === false) {
/******/ 				hotDisposeChunk(chunkId);
/******/ 			}
/******/ 		});
/******/
/******/ 		var idx;
/******/ 		var queue = outdatedModules.slice();
/******/ 		while (queue.length > 0) {
/******/ 			moduleId = queue.pop();
/******/ 			module = installedModules[moduleId];
/******/ 			if (!module) continue;
/******/
/******/ 			var data = {};
/******/
/******/ 			// Call dispose handlers
/******/ 			var disposeHandlers = module.hot._disposeHandlers;
/******/ 			for (j = 0; j < disposeHandlers.length; j++) {
/******/ 				cb = disposeHandlers[j];
/******/ 				cb(data);
/******/ 			}
/******/ 			hotCurrentModuleData[moduleId] = data;
/******/
/******/ 			// disable module (this disables requires from this module)
/******/ 			module.hot.active = false;
/******/
/******/ 			// remove module from cache
/******/ 			delete installedModules[moduleId];
/******/
/******/ 			// when disposing there is no need to call dispose handler
/******/ 			delete outdatedDependencies[moduleId];
/******/
/******/ 			// remove "parents" references from all children
/******/ 			for (j = 0; j < module.children.length; j++) {
/******/ 				var child = installedModules[module.children[j]];
/******/ 				if (!child) continue;
/******/ 				idx = child.parents.indexOf(moduleId);
/******/ 				if (idx >= 0) {
/******/ 					child.parents.splice(idx, 1);
/******/ 				}
/******/ 			}
/******/ 		}
/******/
/******/ 		// remove outdated dependency from module children
/******/ 		var dependency;
/******/ 		var moduleOutdatedDependencies;
/******/ 		for (moduleId in outdatedDependencies) {
/******/ 			if (
/******/ 				Object.prototype.hasOwnProperty.call(outdatedDependencies, moduleId)
/******/ 			) {
/******/ 				module = installedModules[moduleId];
/******/ 				if (module) {
/******/ 					moduleOutdatedDependencies = outdatedDependencies[moduleId];
/******/ 					for (j = 0; j < moduleOutdatedDependencies.length; j++) {
/******/ 						dependency = moduleOutdatedDependencies[j];
/******/ 						idx = module.children.indexOf(dependency);
/******/ 						if (idx >= 0) module.children.splice(idx, 1);
/******/ 					}
/******/ 				}
/******/ 			}
/******/ 		}
/******/
/******/ 		// Now in "apply" phase
/******/ 		hotSetStatus("apply");
/******/
/******/ 		if (hotUpdateNewHash !== undefined) {
/******/ 			hotCurrentHash = hotUpdateNewHash;
/******/ 			hotUpdateNewHash = undefined;
/******/ 		}
/******/ 		hotUpdate = undefined;
/******/
/******/ 		// insert new code
/******/ 		for (moduleId in appliedUpdate) {
/******/ 			if (Object.prototype.hasOwnProperty.call(appliedUpdate, moduleId)) {
/******/ 				modules[moduleId] = appliedUpdate[moduleId];
/******/ 			}
/******/ 		}
/******/
/******/ 		// call accept handlers
/******/ 		var error = null;
/******/ 		for (moduleId in outdatedDependencies) {
/******/ 			if (
/******/ 				Object.prototype.hasOwnProperty.call(outdatedDependencies, moduleId)
/******/ 			) {
/******/ 				module = installedModules[moduleId];
/******/ 				if (module) {
/******/ 					moduleOutdatedDependencies = outdatedDependencies[moduleId];
/******/ 					var callbacks = [];
/******/ 					for (i = 0; i < moduleOutdatedDependencies.length; i++) {
/******/ 						dependency = moduleOutdatedDependencies[i];
/******/ 						cb = module.hot._acceptedDependencies[dependency];
/******/ 						if (cb) {
/******/ 							if (callbacks.indexOf(cb) !== -1) continue;
/******/ 							callbacks.push(cb);
/******/ 						}
/******/ 					}
/******/ 					for (i = 0; i < callbacks.length; i++) {
/******/ 						cb = callbacks[i];
/******/ 						try {
/******/ 							cb(moduleOutdatedDependencies);
/******/ 						} catch (err) {
/******/ 							if (options.onErrored) {
/******/ 								options.onErrored({
/******/ 									type: "accept-errored",
/******/ 									moduleId: moduleId,
/******/ 									dependencyId: moduleOutdatedDependencies[i],
/******/ 									error: err
/******/ 								});
/******/ 							}
/******/ 							if (!options.ignoreErrored) {
/******/ 								if (!error) error = err;
/******/ 							}
/******/ 						}
/******/ 					}
/******/ 				}
/******/ 			}
/******/ 		}
/******/
/******/ 		// Load self accepted modules
/******/ 		for (i = 0; i < outdatedSelfAcceptedModules.length; i++) {
/******/ 			var item = outdatedSelfAcceptedModules[i];
/******/ 			moduleId = item.module;
/******/ 			hotCurrentParents = item.parents;
/******/ 			hotCurrentChildModule = moduleId;
/******/ 			try {
/******/ 				__webpack_require__(moduleId);
/******/ 			} catch (err) {
/******/ 				if (typeof item.errorHandler === "function") {
/******/ 					try {
/******/ 						item.errorHandler(err);
/******/ 					} catch (err2) {
/******/ 						if (options.onErrored) {
/******/ 							options.onErrored({
/******/ 								type: "self-accept-error-handler-errored",
/******/ 								moduleId: moduleId,
/******/ 								error: err2,
/******/ 								originalError: err
/******/ 							});
/******/ 						}
/******/ 						if (!options.ignoreErrored) {
/******/ 							if (!error) error = err2;
/******/ 						}
/******/ 						if (!error) error = err;
/******/ 					}
/******/ 				} else {
/******/ 					if (options.onErrored) {
/******/ 						options.onErrored({
/******/ 							type: "self-accept-errored",
/******/ 							moduleId: moduleId,
/******/ 							error: err
/******/ 						});
/******/ 					}
/******/ 					if (!options.ignoreErrored) {
/******/ 						if (!error) error = err;
/******/ 					}
/******/ 				}
/******/ 			}
/******/ 		}
/******/
/******/ 		// handle errors in accept handlers and self accepted module load
/******/ 		if (error) {
/******/ 			hotSetStatus("fail");
/******/ 			return Promise.reject(error);
/******/ 		}
/******/
/******/ 		if (hotQueuedInvalidatedModules) {
/******/ 			return hotApplyInternal(options).then(function(list) {
/******/ 				outdatedModules.forEach(function(moduleId) {
/******/ 					if (list.indexOf(moduleId) < 0) list.push(moduleId);
/******/ 				});
/******/ 				return list;
/******/ 			});
/******/ 		}
/******/
/******/ 		hotSetStatus("idle");
/******/ 		return new Promise(function(resolve) {
/******/ 			resolve(outdatedModules);
/******/ 		});
/******/ 	}
/******/
/******/ 	function hotApplyInvalidatedModules() {
/******/ 		if (hotQueuedInvalidatedModules) {
/******/ 			if (!hotUpdate) hotUpdate = {};
/******/ 			hotQueuedInvalidatedModules.forEach(hotApplyInvalidatedModule);
/******/ 			hotQueuedInvalidatedModules = undefined;
/******/ 			return true;
/******/ 		}
/******/ 	}
/******/
/******/ 	function hotApplyInvalidatedModule(moduleId) {
/******/ 		if (!Object.prototype.hasOwnProperty.call(hotUpdate, moduleId))
/******/ 			hotUpdate[moduleId] = modules[moduleId];
/******/ 	}
/******/
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
/******/ 			exports: {},
/******/ 			hot: hotCreateModule(moduleId),
/******/ 			parents: (hotCurrentParentsTemp = hotCurrentParents, hotCurrentParents = [], hotCurrentParentsTemp),
/******/ 			children: []
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, hotCreateRequire(moduleId));
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
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, { enumerable: true, get: getter });
/******/ 		}
/******/ 	};
/******/
/******/ 	// define __esModule on exports
/******/ 	__webpack_require__.r = function(exports) {
/******/ 		if(typeof Symbol !== 'undefined' && Symbol.toStringTag) {
/******/ 			Object.defineProperty(exports, Symbol.toStringTag, { value: 'Module' });
/******/ 		}
/******/ 		Object.defineProperty(exports, '__esModule', { value: true });
/******/ 	};
/******/
/******/ 	// create a fake namespace object
/******/ 	// mode & 1: value is a module id, require it
/******/ 	// mode & 2: merge all properties of value into the ns
/******/ 	// mode & 4: return value when already ns object
/******/ 	// mode & 8|1: behave like require
/******/ 	__webpack_require__.t = function(value, mode) {
/******/ 		if(mode & 1) value = __webpack_require__(value);
/******/ 		if(mode & 8) return value;
/******/ 		if((mode & 4) && typeof value === 'object' && value && value.__esModule) return value;
/******/ 		var ns = Object.create(null);
/******/ 		__webpack_require__.r(ns);
/******/ 		Object.defineProperty(ns, 'default', { enumerable: true, value: value });
/******/ 		if(mode & 2 && typeof value != 'string') for(var key in value) __webpack_require__.d(ns, key, function(key) { return value[key]; }.bind(null, key));
/******/ 		return ns;
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
/******/ 	// __webpack_hash__
/******/ 	__webpack_require__.h = function() { return hotCurrentHash; };
/******/
/******/
/******/ 	// Load entry module and return exports
/******/ 	return hotCreateRequire("./index.js")(__webpack_require__.s = "./index.js");
/******/ })
/************************************************************************/
/******/ ({

/***/ "./alloc.js":
/*!******************!*\
  !*** ./alloc.js ***!
  \******************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return alloc; });
/**
 * Creates a new byteArray of the same type (Uint8Array or Buffer) of the specified length.
 * @param byteArray the underlying byteArray (either Uint8Array or Buffer)
 * @param length number of bytes of the Byte Array
 * @returns {object} Uint8Array or Buffer depending on the type of byteArray
 */
function alloc(byteArray, length) {
  if (typeof Buffer !== 'undefined' && byteArray instanceof Buffer) {
    return Buffer.alloc(length);
  } else if (byteArray instanceof Uint8Array) {
    return new Uint8Array(length);
  }

  throw 'dicomParser.alloc: unknown type for byteArray';
}

/***/ }),

/***/ "./bigEndianByteArrayParser.js":
/*!*************************************!*\
  !*** ./bigEndianByteArrayParser.js ***!
  \*************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/**
 * Internal helper functions for parsing different types from a big-endian byte array
 */
/* harmony default export */ __webpack_exports__["default"] = ({
  /**
     *
     * Parses an unsigned int 16 from a big-endian byte array
     *
     * @param byteArray the byte array to read from
     * @param position the position in the byte array to read from
     * @returns {*} the parsed unsigned int 16
     * @throws error if buffer overread would occur
     * @access private
     */
  readUint16: function readUint16(byteArray, position) {
    if (position < 0) {
      throw 'bigEndianByteArrayParser.readUint16: position cannot be less than 0';
    }

    if (position + 2 > byteArray.length) {
      throw 'bigEndianByteArrayParser.readUint16: attempt to read past end of buffer';
    }

    return (byteArray[position] << 8) + byteArray[position + 1];
  },

  /**
     *
     * Parses a signed int 16 from a big-endian byte array
     *
     * @param byteArray the byte array to read from
     * @param position the position in the byte array to read from
     * @returns {*} the parsed signed int 16
     * @throws error if buffer overread would occur
     * @access private
     */
  readInt16: function readInt16(byteArray, position) {
    if (position < 0) {
      throw 'bigEndianByteArrayParser.readInt16: position cannot be less than 0';
    }

    if (position + 2 > byteArray.length) {
      throw 'bigEndianByteArrayParser.readInt16: attempt to read past end of buffer';
    }

    var int16 = (byteArray[position] << 8) + byteArray[position + 1]; // fix sign

    if (int16 & 0x8000) {
      int16 = int16 - 0xFFFF - 1;
    }

    return int16;
  },

  /**
     * Parses an unsigned int 32 from a big-endian byte array
     *
     * @param byteArray the byte array to read from
     * @param position the position in the byte array to read from
     * @returns {*} the parsed unsigned int 32
     * @throws error if buffer overread would occur
     * @access private
     */
  readUint32: function readUint32(byteArray, position) {
    if (position < 0) {
      throw 'bigEndianByteArrayParser.readUint32: position cannot be less than 0';
    }

    if (position + 4 > byteArray.length) {
      throw 'bigEndianByteArrayParser.readUint32: attempt to read past end of buffer';
    }

    var uint32 = 256 * (256 * (256 * byteArray[position] + byteArray[position + 1]) + byteArray[position + 2]) + byteArray[position + 3];
    return uint32;
  },

  /**
     * Parses a signed int 32 from a big-endian byte array
     *
     * @param byteArray the byte array to read from
     * @param position the position in the byte array to read from
     * @returns {*} the parsed signed int 32
     * @throws error if buffer overread would occur
     * @access private
     */
  readInt32: function readInt32(byteArray, position) {
    if (position < 0) {
      throw 'bigEndianByteArrayParser.readInt32: position cannot be less than 0';
    }

    if (position + 4 > byteArray.length) {
      throw 'bigEndianByteArrayParser.readInt32: attempt to read past end of buffer';
    }

    var int32 = (byteArray[position] << 24) + (byteArray[position + 1] << 16) + (byteArray[position + 2] << 8) + byteArray[position + 3];
    return int32;
  },

  /**
     * Parses 32-bit float from a big-endian byte array
     *
     * @param byteArray the byte array to read from
     * @param position the position in the byte array to read from
     * @returns {*} the parsed 32-bit float
     * @throws error if buffer overread would occur
     * @access private
     */
  readFloat: function readFloat(byteArray, position) {
    if (position < 0) {
      throw 'bigEndianByteArrayParser.readFloat: position cannot be less than 0';
    }

    if (position + 4 > byteArray.length) {
      throw 'bigEndianByteArrayParser.readFloat: attempt to read past end of buffer';
    } // I am sure there is a better way than this but this should be safe


    var byteArrayForParsingFloat = new Uint8Array(4);
    byteArrayForParsingFloat[3] = byteArray[position];
    byteArrayForParsingFloat[2] = byteArray[position + 1];
    byteArrayForParsingFloat[1] = byteArray[position + 2];
    byteArrayForParsingFloat[0] = byteArray[position + 3];
    var floatArray = new Float32Array(byteArrayForParsingFloat.buffer);
    return floatArray[0];
  },

  /**
     * Parses 64-bit float from a big-endian byte array
     *
     * @param byteArray the byte array to read from
     * @param position the position in the byte array to read from
     * @returns {*} the parsed 64-bit float
     * @throws error if buffer overread would occur
     * @access private
     */
  readDouble: function readDouble(byteArray, position) {
    if (position < 0) {
      throw 'bigEndianByteArrayParser.readDouble: position cannot be less than 0';
    }

    if (position + 8 > byteArray.length) {
      throw 'bigEndianByteArrayParser.readDouble: attempt to read past end of buffer';
    } // I am sure there is a better way than this but this should be safe


    var byteArrayForParsingFloat = new Uint8Array(8);
    byteArrayForParsingFloat[7] = byteArray[position];
    byteArrayForParsingFloat[6] = byteArray[position + 1];
    byteArrayForParsingFloat[5] = byteArray[position + 2];
    byteArrayForParsingFloat[4] = byteArray[position + 3];
    byteArrayForParsingFloat[3] = byteArray[position + 4];
    byteArrayForParsingFloat[2] = byteArray[position + 5];
    byteArrayForParsingFloat[1] = byteArray[position + 6];
    byteArrayForParsingFloat[0] = byteArray[position + 7];
    var floatArray = new Float64Array(byteArrayForParsingFloat.buffer);
    return floatArray[0];
  }
});

/***/ }),

/***/ "./byteArrayParser.js":
/*!****************************!*\
  !*** ./byteArrayParser.js ***!
  \****************************/
/*! exports provided: readFixedString */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "readFixedString", function() { return readFixedString; });
/**
 * Internal helper functions common to parsing byte arrays of any type
 */

/**
 * Reads a string of 8-bit characters from an array of bytes and advances
 * the position by length bytes.  A null terminator will end the string
 * but will not affect advancement of the position.  Trailing and leading
 * spaces are preserved (not trimmed)
 * @param byteArray the byteArray to read from
 * @param position the position in the byte array to read from
 * @param length the maximum number of bytes to parse
 * @returns {string} the parsed string
 * @throws error if buffer overread would occur
 * @access private
 */
function readFixedString(byteArray, position, length) {
  if (length < 0) {
    throw 'dicomParser.readFixedString - length cannot be less than 0';
  }

  if (position + length > byteArray.length) {
    throw 'dicomParser.readFixedString: attempt to read past end of buffer';
  }

  var result = '';

  var _byte;

  for (var i = 0; i < length; i++) {
    _byte = byteArray[position + i];

    if (_byte === 0) {
      position += length;
      return result;
    }

    result += String.fromCharCode(_byte);
  }

  return result;
}

/***/ }),

/***/ "./byteStream.js":
/*!***********************!*\
  !*** ./byteStream.js ***!
  \***********************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return ByteStream; });
/* harmony import */ var _sharedCopy_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./sharedCopy.js */ "./sharedCopy.js");
/* harmony import */ var _byteArrayParser_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./byteArrayParser.js */ "./byteArrayParser.js");
function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); Object.defineProperty(Constructor, "prototype", { writable: false }); return Constructor; }



/**
 *
 * Internal helper class to assist with parsing. Supports reading from a byte
 * stream contained in a Uint8Array.  Example usage:
 *
 *  var byteArray = new Uint8Array(32);
 *  var byteStream = new dicomParser.ByteStream(dicomParser.littleEndianByteArrayParser, byteArray);
 *
 * */

/**
 * Constructor for ByteStream objects.
 * @param byteArrayParser a parser for parsing the byte array
 * @param byteArray a Uint8Array containing the byte stream
 * @param position (optional) the position to start reading from.  0 if not specified
 * @constructor
 * @throws will throw an error if the byteArrayParser parameter is not present
 * @throws will throw an error if the byteArray parameter is not present or invalid
 * @throws will throw an error if the position parameter is not inside the byte array
 */

var ByteStream = /*#__PURE__*/function () {
  function ByteStream(byteArrayParser, byteArray, position) {
    _classCallCheck(this, ByteStream);

    if (byteArrayParser === undefined) {
      throw 'dicomParser.ByteStream: missing required parameter \'byteArrayParser\'';
    }

    if (byteArray === undefined) {
      throw 'dicomParser.ByteStream: missing required parameter \'byteArray\'';
    }

    if (byteArray instanceof Uint8Array === false && (typeof Buffer === 'undefined' || byteArray instanceof Buffer === false)) {
      throw 'dicomParser.ByteStream: parameter byteArray is not of type Uint8Array or Buffer';
    }

    if (position < 0) {
      throw 'dicomParser.ByteStream: parameter \'position\' cannot be less than 0';
    }

    if (position >= byteArray.length) {
      throw 'dicomParser.ByteStream: parameter \'position\' cannot be greater than or equal to \'byteArray\' length';
    }

    this.byteArrayParser = byteArrayParser;
    this.byteArray = byteArray;
    this.position = position ? position : 0;
    this.warnings = []; // array of string warnings encountered while parsing
  }
  /**
     * Safely seeks through the byte stream.  Will throw an exception if an attempt
     * is made to seek outside of the byte array.
     * @param offset the number of bytes to add to the position
     * @throws error if seek would cause position to be outside of the byteArray
     */


  _createClass(ByteStream, [{
    key: "seek",
    value: function seek(offset) {
      if (this.position + offset < 0) {
        throw 'dicomParser.ByteStream.prototype.seek: cannot seek to position < 0';
      }

      this.position += offset;
    }
    /**
       * Returns a new ByteStream object from the current position and of the requested number of bytes
       * @param numBytes the length of the byte array for the ByteStream to contain
       * @returns {dicomParser.ByteStream}
       * @throws error if buffer overread would occur
       */

  }, {
    key: "readByteStream",
    value: function readByteStream(numBytes) {
      if (this.position + numBytes > this.byteArray.length) {
        throw 'dicomParser.ByteStream.prototype.readByteStream: readByteStream - buffer overread';
      }

      var byteArrayView = Object(_sharedCopy_js__WEBPACK_IMPORTED_MODULE_0__["default"])(this.byteArray, this.position, numBytes);
      this.position += numBytes;
      return new ByteStream(this.byteArrayParser, byteArrayView);
    }
  }, {
    key: "getSize",
    value: function getSize() {
      return this.byteArray.length;
    }
    /**
       *
       * Parses an unsigned int 16 from a byte array and advances
       * the position by 2 bytes
       *
       * @returns {*} the parsed unsigned int 16
       * @throws error if buffer overread would occur
       */

  }, {
    key: "readUint16",
    value: function readUint16() {
      var result = this.byteArrayParser.readUint16(this.byteArray, this.position);
      this.position += 2;
      return result;
    }
    /**
       * Parses an unsigned int 32 from a byte array and advances
       * the position by 2 bytes
       *
       * @returns {*} the parse unsigned int 32
       * @throws error if buffer overread would occur
       */

  }, {
    key: "readUint32",
    value: function readUint32() {
      var result = this.byteArrayParser.readUint32(this.byteArray, this.position);
      this.position += 4;
      return result;
    }
    /**
       * Reads a string of 8-bit characters from an array of bytes and advances
       * the position by length bytes.  A null terminator will end the string
       * but will not effect advancement of the position.
       * @param length the maximum number of bytes to parse
       * @returns {string} the parsed string
       * @throws error if buffer overread would occur
       */

  }, {
    key: "readFixedString",
    value: function readFixedString(length) {
      var result = Object(_byteArrayParser_js__WEBPACK_IMPORTED_MODULE_1__["readFixedString"])(this.byteArray, this.position, length);

      this.position += length;
      return result;
    }
  }]);

  return ByteStream;
}();



/***/ }),

/***/ "./dataSet.js":
/*!********************!*\
  !*** ./dataSet.js ***!
  \********************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return DataSet; });
/* harmony import */ var _byteArrayParser_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./byteArrayParser.js */ "./byteArrayParser.js");
function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); Object.defineProperty(Constructor, "prototype", { writable: false }); return Constructor; }


/**
 *
 * The DataSet class encapsulates a collection of DICOM Elements and provides various functions
 * to access the data in those elements
 *
 * Rules for handling padded spaces:
 * DS = Strip leading and trailing spaces
 * DT = Strip trailing spaces
 * IS = Strip leading and trailing spaces
 * PN = Strip trailing spaces
 * TM = Strip trailing spaces
 * AE = Strip leading and trailing spaces
 * CS = Strip leading and trailing spaces
 * SH = Strip leading and trailing spaces
 * LO = Strip leading and trailing spaces
 * LT = Strip trailing spaces
 * ST = Strip trailing spaces
 * UT = Strip trailing spaces
 *
 */

function getByteArrayParser(element, defaultParser) {
  return element.parser !== undefined ? element.parser : defaultParser;
}
/**
 * Constructs a new DataSet given byteArray and collection of elements
 * @param byteArrayParser
 * @param byteArray
 * @param elements
 * @constructor
 */


var DataSet = /*#__PURE__*/function () {
  function DataSet(byteArrayParser, byteArray, elements) {
    _classCallCheck(this, DataSet);

    this.byteArrayParser = byteArrayParser;
    this.byteArray = byteArray;
    this.elements = elements;
  }
  /**
     * Finds the element for tag and returns an unsigned int 16 if it exists and has data
     * @param tag The DICOM tag in the format xGGGGEEEE
     * @param index the index of the value in a multivalued element.  Default is index 0 if not supplied
     * @returns {*} unsigned int 16 or undefined if the attribute is not present or has data of length 0
     */


  _createClass(DataSet, [{
    key: "uint16",
    value: function uint16(tag, index) {
      var element = this.elements[tag];
      index = index !== undefined ? index : 0;

      if (element && element.length !== 0) {
        return getByteArrayParser(element, this.byteArrayParser).readUint16(this.byteArray, element.dataOffset + index * 2);
      }

      return undefined;
    }
    /**
       * Finds the element for tag and returns an signed int 16 if it exists and has data
       * @param tag The DICOM tag in the format xGGGGEEEE
       * @param index the index of the value in a multivalued element.  Default is index 0 if not supplied
       * @returns {*} signed int 16 or undefined if the attribute is not present or has data of length 0
       */

  }, {
    key: "int16",
    value: function int16(tag, index) {
      var element = this.elements[tag];
      index = index !== undefined ? index : 0;

      if (element && element.length !== 0) {
        return getByteArrayParser(element, this.byteArrayParser).readInt16(this.byteArray, element.dataOffset + index * 2);
      }

      return undefined;
    }
    /**
       * Finds the element for tag and returns an unsigned int 32 if it exists and has data
       * @param tag The DICOM tag in the format xGGGGEEEE
       * @param index the index of the value in a multivalued element.  Default is index 0 if not supplied
       * @returns {*} unsigned int 32 or undefined if the attribute is not present or has data of length 0
       */

  }, {
    key: "uint32",
    value: function uint32(tag, index) {
      var element = this.elements[tag];
      index = index !== undefined ? index : 0;

      if (element && element.length !== 0) {
        return getByteArrayParser(element, this.byteArrayParser).readUint32(this.byteArray, element.dataOffset + index * 4);
      }

      return undefined;
    }
    /**
       * Finds the element for tag and returns an signed int 32 if it exists and has data
       * @param tag The DICOM tag in the format xGGGGEEEE
       * @param index the index of the value in a multivalued element.  Default is index 0 if not supplied
       * @returns {*} signed int 32 or undefined if the attribute is not present or has data of length 0
       */

  }, {
    key: "int32",
    value: function int32(tag, index) {
      var element = this.elements[tag];
      index = index !== undefined ? index : 0;

      if (element && element.length !== 0) {
        return getByteArrayParser(element, this.byteArrayParser).readInt32(this.byteArray, element.dataOffset + index * 4);
      }

      return undefined;
    }
    /**
       * Finds the element for tag and returns a 32 bit floating point number (VR=FL) if it exists and has data
       * @param tag The DICOM tag in the format xGGGGEEEE
       * @param index the index of the value in a multivalued element.  Default is index 0 if not supplied
       * @returns {*} float or undefined if the attribute is not present or has data of length 0
       */

  }, {
    key: "float",
    value: function float(tag, index) {
      var element = this.elements[tag];
      index = index !== undefined ? index : 0;

      if (element && element.length !== 0) {
        return getByteArrayParser(element, this.byteArrayParser).readFloat(this.byteArray, element.dataOffset + index * 4);
      }

      return undefined;
    }
    /**
       * Finds the element for tag and returns a 64 bit floating point number (VR=FD) if it exists and has data
       * @param tag The DICOM tag in the format xGGGGEEEE
       * @param index the index of the value in a multivalued element.  Default is index 0 if not supplied
       * @returns {*} float or undefined if the attribute is not present or doesn't has data of length 0
       */

  }, {
    key: "double",
    value: function double(tag, index) {
      var element = this.elements[tag];
      index = index !== undefined ? index : 0;

      if (element && element.length !== 0) {
        return getByteArrayParser(element, this.byteArrayParser).readDouble(this.byteArray, element.dataOffset + index * 8);
      }

      return undefined;
    }
    /**
       * Returns the number of string values for the element
       * @param tag The DICOM tag in the format xGGGGEEEE
       * @returns {*} the number of string values or undefined if the attribute is not present or has zero length data
       */

  }, {
    key: "numStringValues",
    value: function numStringValues(tag) {
      var element = this.elements[tag];

      if (element && element.length > 0) {
        var fixedString = Object(_byteArrayParser_js__WEBPACK_IMPORTED_MODULE_0__["readFixedString"])(this.byteArray, element.dataOffset, element.length);
        var numMatching = fixedString.match(/\\/g);

        if (numMatching === null) {
          return 1;
        }

        return numMatching.length + 1;
      }

      return undefined;
    }
    /**
       * Returns a string for the element.  If index is provided, the element is assumed to be
       * multi-valued and will return the component specified by index.  Undefined is returned
       * if there is no component with the specified index, the element does not exist or is zero length.
       *
       * Use this function for VR types of AE, CS, SH and LO
       *
       * @param tag The DICOM tag in the format xGGGGEEEE
       * @param index the index of the desired value in a multi valued string or undefined for the entire string
       * @returns {*}
       */

  }, {
    key: "string",
    value: function string(tag, index) {
      var element = this.elements[tag];
      if (element && element.Value) return element.Value;

      if (element && element.length > 0) {
        var fixedString = Object(_byteArrayParser_js__WEBPACK_IMPORTED_MODULE_0__["readFixedString"])(this.byteArray, element.dataOffset, element.length);

        if (index >= 0) {
          var values = fixedString.split('\\'); // trim trailing spaces

          return values[index].trim();
        } // trim trailing spaces


        return fixedString.trim();
      }

      return undefined;
    }
    /**
       * Returns a string with the leading spaces preserved and trailing spaces removed.
       *
       * Use this function to access data for VRs of type UT, ST and LT
       *
       * @param tag
       * @param index
       * @returns {*}
       */

  }, {
    key: "text",
    value: function text(tag, index) {
      var element = this.elements[tag];

      if (element && element.length > 0) {
        var fixedString = Object(_byteArrayParser_js__WEBPACK_IMPORTED_MODULE_0__["readFixedString"])(this.byteArray, element.dataOffset, element.length);

        if (index >= 0) {
          var values = fixedString.split('\\');
          return values[index].replace(/ +$/, '');
        }

        return fixedString.replace(/ +$/, '');
      }

      return undefined;
    }
    /**
       * Parses a string to a float for the specified index in a multi-valued element.  If index is not specified,
       * the first value in a multi-valued VR will be parsed if present.
       * @param tag The DICOM tag in the format xGGGGEEEE
       * @param index the index of the desired value in a multi valued string or undefined for the first value
       * @returns {*} a floating point number or undefined if not present or data not long enough
       */

  }, {
    key: "floatString",
    value: function floatString(tag, index) {
      var element = this.elements[tag];

      if (element && element.length > 0) {
        index = index !== undefined ? index : 0;
        var value = this.string(tag, index);

        if (value !== undefined) {
          return parseFloat(value);
        }
      }

      return undefined;
    }
    /**
       * Parses a string to an integer for the specified index in a multi-valued element.  If index is not specified,
       * the first value in a multi-valued VR will be parsed if present.
       * @param tag The DICOM tag in the format xGGGGEEEE
       * @param index the index of the desired value in a multi valued string or undefined for the first value
       * @returns {*} an integer or undefined if not present or data not long enough
       */

  }, {
    key: "intString",
    value: function intString(tag, index) {
      var element = this.elements[tag];

      if (element && element.length > 0) {
        index = index !== undefined ? index : 0;
        var value = this.string(tag, index);

        if (value !== undefined) {
          return parseInt(value);
        }
      }

      return undefined;
    }
    /**
       * Parses an element tag according to the 'AT' VR definition (VR=AT).
       * @param {String} A DICOM tag with in the format xGGGGEEEE.
       * @returns {String} A string representation of a data element tag or undefined if the field is not present or data is not long enough.
       */

  }, {
    key: "attributeTag",
    value: function attributeTag(tag) {
      var element = this.elements[tag];

      if (element && element.length === 4) {
        var parser = getByteArrayParser(element, this.byteArrayParser).readUint16;
        var bytes = this.byteArray;
        var offset = element.dataOffset;
        return "x".concat("00000000".concat((parser(bytes, offset) * 256 * 256 + parser(bytes, offset + 2)).toString(16)).substr(-8));
      }

      return undefined;
    }
  }]);

  return DataSet;
}();



/***/ }),

/***/ "./findAndSetUNElementLength.js":
/*!**************************************!*\
  !*** ./findAndSetUNElementLength.js ***!
  \**************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return findAndSetUNElementLength; });
/**
 * Internal helper functions for parsing DICOM elements
 */

/**
 * reads from the byte stream until it finds the magic number for the Sequence Delimitation
 * Item item and then sets the length of the element
 * @param byteStream
 * @param element
 */
function findAndSetUNElementLength(byteStream, element) {
  if (byteStream === undefined) {
    throw 'dicomParser.findAndSetUNElementLength: missing required parameter \'byteStream\'';
  } // group, element, length


  var itemDelimitationItemLength = 8;
  var maxPosition = byteStream.byteArray.length - itemDelimitationItemLength;

  while (byteStream.position <= maxPosition) {
    var groupNumber = byteStream.readUint16();

    if (groupNumber === 0xfffe) {
      var elementNumber = byteStream.readUint16();

      if (elementNumber === 0xe0dd) {
        // NOTE: It would be better to also check for the length to be 0 as part of the check above
        // but we will just log a warning for now
        var itemDelimiterLength = byteStream.readUint32();

        if (itemDelimiterLength !== 0) {
          byteStream.warnings("encountered non zero length following item delimiter at position ".concat(byteStream.position - 4, " while reading element of undefined length with tag ").concat(element.tag));
        }

        element.length = byteStream.position - element.dataOffset;
        return;
      }
    }
  } // No item delimitation item - silently set the length to the end
  // of the buffer and set the position past the end of the buffer


  element.length = byteStream.byteArray.length - element.dataOffset;
  byteStream.seek(byteStream.byteArray.length - byteStream.position);
}

/***/ }),

/***/ "./findEndOfEncapsulatedPixelData.js":
/*!*******************************************!*\
  !*** ./findEndOfEncapsulatedPixelData.js ***!
  \*******************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return findEndOfEncapsulatedElement; });
/* harmony import */ var _readTag_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./readTag.js */ "./readTag.js");

/**
 * Internal helper functions for parsing DICOM elements
 */

/**
 * Reads an encapsulated pixel data element and adds an array of fragments to the element
 * containing the offset and length of each fragment and any offsets from the basic offset
 * table
 * @param byteStream
 * @param element
 */

function findEndOfEncapsulatedElement(byteStream, element, warnings) {
  if (byteStream === undefined) {
    throw 'dicomParser.findEndOfEncapsulatedElement: missing required parameter \'byteStream\'';
  }

  if (element === undefined) {
    throw 'dicomParser.findEndOfEncapsulatedElement: missing required parameter \'element\'';
  }

  element.encapsulatedPixelData = true;
  element.basicOffsetTable = [];
  element.fragments = [];
  var basicOffsetTableItemTag = Object(_readTag_js__WEBPACK_IMPORTED_MODULE_0__["default"])(byteStream);

  if (basicOffsetTableItemTag !== 'xfffee000') {
    throw 'dicomParser.findEndOfEncapsulatedElement: basic offset table not found';
  }

  var basicOffsetTableItemlength = byteStream.readUint32();
  var numFragments = basicOffsetTableItemlength / 4; // Bad idea to not include the basic offset table, as it means writing the data out is inconsistent with reading it
  // but leave this for now.  To fix later.

  for (var i = 0; i < numFragments; i++) {
    var offset = byteStream.readUint32();
    element.basicOffsetTable.push(offset);
  }

  var baseOffset = byteStream.position;

  while (byteStream.position < byteStream.byteArray.length) {
    var tag = Object(_readTag_js__WEBPACK_IMPORTED_MODULE_0__["default"])(byteStream);
    var length = byteStream.readUint32();

    if (tag === 'xfffee0dd') {
      byteStream.seek(length);
      element.length = byteStream.position - element.dataOffset;
      return;
    } else if (tag === 'xfffee000') {
      element.fragments.push({
        offset: byteStream.position - baseOffset - 8,
        position: byteStream.position,
        length: length
      });
    } else {
      if (warnings) {
        warnings.push("unexpected tag ".concat(tag, " while searching for end of pixel data element with undefined length"));
      }

      if (length > byteStream.byteArray.length - byteStream.position) {
        // fix length
        length = byteStream.byteArray.length - byteStream.position;
      }

      element.fragments.push({
        offset: byteStream.position - baseOffset - 8,
        position: byteStream.position,
        length: length
      });
      byteStream.seek(length);
      element.length = byteStream.position - element.dataOffset;
      return;
    }

    byteStream.seek(length);
  }

  if (warnings) {
    warnings.push("pixel data element ".concat(element.tag, " missing sequence delimiter tag xfffee0dd"));
  }
}

/***/ }),

/***/ "./findItemDelimitationItem.js":
/*!*************************************!*\
  !*** ./findItemDelimitationItem.js ***!
  \*************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return findItemDelimitationItemAndSetElementLength; });
/**
 * Internal helper functions for parsing DICOM elements
 */

/**
 * reads from the byte stream until it finds the magic numbers for the item delimitation item
 * and then sets the length of the element
 * @param byteStream
 * @param element
 */
function findItemDelimitationItemAndSetElementLength(byteStream, element) {
  if (byteStream === undefined) {
    throw 'dicomParser.readDicomElementImplicit: missing required parameter \'byteStream\'';
  }

  var itemDelimitationItemLength = 8; // group, element, length

  var maxPosition = byteStream.byteArray.length - itemDelimitationItemLength;

  while (byteStream.position <= maxPosition) {
    var groupNumber = byteStream.readUint16();

    if (groupNumber === 0xfffe) {
      var elementNumber = byteStream.readUint16();

      if (elementNumber === 0xe00d) {
        // NOTE: It would be better to also check for the length to be 0 as part of the check above
        // but we will just log a warning for now
        var itemDelimiterLength = byteStream.readUint32(); // the length

        if (itemDelimiterLength !== 0) {
          byteStream.warnings("encountered non zero length following item delimiter at position ".concat(byteStream.position - 4, " while reading element of undefined length with tag ").concat(element.tag));
        }

        element.length = byteStream.position - element.dataOffset;
        return;
      }
    }
  } // No item delimitation item - silently set the length to the end of the buffer and set the position past the end of the buffer


  element.length = byteStream.byteArray.length - element.dataOffset;
  byteStream.seek(byteStream.byteArray.length - byteStream.position);
}

/***/ }),

/***/ "./index.js":
/*!******************!*\
  !*** ./index.js ***!
  \******************/
/*! exports provided: isStringVr, isPrivateTag, parsePN, parseTM, parseDA, explicitElementToString, explicitDataSetToJS, createJPEGBasicOffsetTable, parseDicomDataSetExplicit, parseDicomDataSetImplicit, readFixedString, alloc, version, bigEndianByteArrayParser, ByteStream, sharedCopy, DataSet, findAndSetUNElementLength, findEndOfEncapsulatedElement, findItemDelimitationItemAndSetElementLength, littleEndianByteArrayParser, parseDicom, readDicomElementExplicit, readDicomElementImplicit, readEncapsulatedImageFrame, readEncapsulatedPixelData, readEncapsulatedPixelDataFromFragments, readPart10Header, readSequenceItemsExplicit, readSequenceItemsImplicit, readSequenceItem, readTag, default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _util_index_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./util/index.js */ "./util/index.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "isStringVr", function() { return _util_index_js__WEBPACK_IMPORTED_MODULE_0__["isStringVr"]; });

/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "isPrivateTag", function() { return _util_index_js__WEBPACK_IMPORTED_MODULE_0__["isPrivateTag"]; });

/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "parsePN", function() { return _util_index_js__WEBPACK_IMPORTED_MODULE_0__["parsePN"]; });

/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "parseTM", function() { return _util_index_js__WEBPACK_IMPORTED_MODULE_0__["parseTM"]; });

/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "parseDA", function() { return _util_index_js__WEBPACK_IMPORTED_MODULE_0__["parseDA"]; });

/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "explicitElementToString", function() { return _util_index_js__WEBPACK_IMPORTED_MODULE_0__["explicitElementToString"]; });

/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "explicitDataSetToJS", function() { return _util_index_js__WEBPACK_IMPORTED_MODULE_0__["explicitDataSetToJS"]; });

/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "createJPEGBasicOffsetTable", function() { return _util_index_js__WEBPACK_IMPORTED_MODULE_0__["createJPEGBasicOffsetTable"]; });

/* harmony import */ var _parseDicomDataSet_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./parseDicomDataSet.js */ "./parseDicomDataSet.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "parseDicomDataSetExplicit", function() { return _parseDicomDataSet_js__WEBPACK_IMPORTED_MODULE_1__["parseDicomDataSetExplicit"]; });

/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "parseDicomDataSetImplicit", function() { return _parseDicomDataSet_js__WEBPACK_IMPORTED_MODULE_1__["parseDicomDataSetImplicit"]; });

/* harmony import */ var _byteArrayParser_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./byteArrayParser.js */ "./byteArrayParser.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "readFixedString", function() { return _byteArrayParser_js__WEBPACK_IMPORTED_MODULE_2__["readFixedString"]; });

/* harmony import */ var _alloc_js__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ./alloc.js */ "./alloc.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "alloc", function() { return _alloc_js__WEBPACK_IMPORTED_MODULE_3__["default"]; });

/* harmony import */ var _version_js__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! ./version.js */ "./version.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "version", function() { return _version_js__WEBPACK_IMPORTED_MODULE_4__["default"]; });

/* harmony import */ var _bigEndianByteArrayParser_js__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(/*! ./bigEndianByteArrayParser.js */ "./bigEndianByteArrayParser.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "bigEndianByteArrayParser", function() { return _bigEndianByteArrayParser_js__WEBPACK_IMPORTED_MODULE_5__["default"]; });

/* harmony import */ var _byteStream_js__WEBPACK_IMPORTED_MODULE_6__ = __webpack_require__(/*! ./byteStream.js */ "./byteStream.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "ByteStream", function() { return _byteStream_js__WEBPACK_IMPORTED_MODULE_6__["default"]; });

/* harmony import */ var _sharedCopy_js__WEBPACK_IMPORTED_MODULE_7__ = __webpack_require__(/*! ./sharedCopy.js */ "./sharedCopy.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "sharedCopy", function() { return _sharedCopy_js__WEBPACK_IMPORTED_MODULE_7__["default"]; });

/* harmony import */ var _dataSet_js__WEBPACK_IMPORTED_MODULE_8__ = __webpack_require__(/*! ./dataSet.js */ "./dataSet.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "DataSet", function() { return _dataSet_js__WEBPACK_IMPORTED_MODULE_8__["default"]; });

/* harmony import */ var _findAndSetUNElementLength_js__WEBPACK_IMPORTED_MODULE_9__ = __webpack_require__(/*! ./findAndSetUNElementLength.js */ "./findAndSetUNElementLength.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "findAndSetUNElementLength", function() { return _findAndSetUNElementLength_js__WEBPACK_IMPORTED_MODULE_9__["default"]; });

/* harmony import */ var _findEndOfEncapsulatedPixelData_js__WEBPACK_IMPORTED_MODULE_10__ = __webpack_require__(/*! ./findEndOfEncapsulatedPixelData.js */ "./findEndOfEncapsulatedPixelData.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "findEndOfEncapsulatedElement", function() { return _findEndOfEncapsulatedPixelData_js__WEBPACK_IMPORTED_MODULE_10__["default"]; });

/* harmony import */ var _findItemDelimitationItem_js__WEBPACK_IMPORTED_MODULE_11__ = __webpack_require__(/*! ./findItemDelimitationItem.js */ "./findItemDelimitationItem.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "findItemDelimitationItemAndSetElementLength", function() { return _findItemDelimitationItem_js__WEBPACK_IMPORTED_MODULE_11__["default"]; });

/* harmony import */ var _littleEndianByteArrayParser_js__WEBPACK_IMPORTED_MODULE_12__ = __webpack_require__(/*! ./littleEndianByteArrayParser.js */ "./littleEndianByteArrayParser.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "littleEndianByteArrayParser", function() { return _littleEndianByteArrayParser_js__WEBPACK_IMPORTED_MODULE_12__["default"]; });

/* harmony import */ var _parseDicom_js__WEBPACK_IMPORTED_MODULE_13__ = __webpack_require__(/*! ./parseDicom.js */ "./parseDicom.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "parseDicom", function() { return _parseDicom_js__WEBPACK_IMPORTED_MODULE_13__["default"]; });

/* harmony import */ var _readDicomElementExplicit_js__WEBPACK_IMPORTED_MODULE_14__ = __webpack_require__(/*! ./readDicomElementExplicit.js */ "./readDicomElementExplicit.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "readDicomElementExplicit", function() { return _readDicomElementExplicit_js__WEBPACK_IMPORTED_MODULE_14__["default"]; });

/* harmony import */ var _readDicomElementImplicit_js__WEBPACK_IMPORTED_MODULE_15__ = __webpack_require__(/*! ./readDicomElementImplicit.js */ "./readDicomElementImplicit.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "readDicomElementImplicit", function() { return _readDicomElementImplicit_js__WEBPACK_IMPORTED_MODULE_15__["default"]; });

/* harmony import */ var _readEncapsulatedImageFrame_js__WEBPACK_IMPORTED_MODULE_16__ = __webpack_require__(/*! ./readEncapsulatedImageFrame.js */ "./readEncapsulatedImageFrame.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "readEncapsulatedImageFrame", function() { return _readEncapsulatedImageFrame_js__WEBPACK_IMPORTED_MODULE_16__["default"]; });

/* harmony import */ var _readEncapsulatedPixelData_js__WEBPACK_IMPORTED_MODULE_17__ = __webpack_require__(/*! ./readEncapsulatedPixelData.js */ "./readEncapsulatedPixelData.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "readEncapsulatedPixelData", function() { return _readEncapsulatedPixelData_js__WEBPACK_IMPORTED_MODULE_17__["default"]; });

/* harmony import */ var _readEncapsulatedPixelDataFromFragments_js__WEBPACK_IMPORTED_MODULE_18__ = __webpack_require__(/*! ./readEncapsulatedPixelDataFromFragments.js */ "./readEncapsulatedPixelDataFromFragments.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "readEncapsulatedPixelDataFromFragments", function() { return _readEncapsulatedPixelDataFromFragments_js__WEBPACK_IMPORTED_MODULE_18__["default"]; });

/* harmony import */ var _readPart10Header_js__WEBPACK_IMPORTED_MODULE_19__ = __webpack_require__(/*! ./readPart10Header.js */ "./readPart10Header.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "readPart10Header", function() { return _readPart10Header_js__WEBPACK_IMPORTED_MODULE_19__["default"]; });

/* harmony import */ var _readSequenceElementExplicit_js__WEBPACK_IMPORTED_MODULE_20__ = __webpack_require__(/*! ./readSequenceElementExplicit.js */ "./readSequenceElementExplicit.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "readSequenceItemsExplicit", function() { return _readSequenceElementExplicit_js__WEBPACK_IMPORTED_MODULE_20__["default"]; });

/* harmony import */ var _readSequenceElementImplicit_js__WEBPACK_IMPORTED_MODULE_21__ = __webpack_require__(/*! ./readSequenceElementImplicit.js */ "./readSequenceElementImplicit.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "readSequenceItemsImplicit", function() { return _readSequenceElementImplicit_js__WEBPACK_IMPORTED_MODULE_21__["default"]; });

/* harmony import */ var _readSequenceItem_js__WEBPACK_IMPORTED_MODULE_22__ = __webpack_require__(/*! ./readSequenceItem.js */ "./readSequenceItem.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "readSequenceItem", function() { return _readSequenceItem_js__WEBPACK_IMPORTED_MODULE_22__["default"]; });

/* harmony import */ var _readTag_js__WEBPACK_IMPORTED_MODULE_23__ = __webpack_require__(/*! ./readTag.js */ "./readTag.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "readTag", function() { return _readTag_js__WEBPACK_IMPORTED_MODULE_23__["default"]; });

























var dicomParser = {
  isStringVr: _util_index_js__WEBPACK_IMPORTED_MODULE_0__["isStringVr"],
  isPrivateTag: _util_index_js__WEBPACK_IMPORTED_MODULE_0__["isPrivateTag"],
  parsePN: _util_index_js__WEBPACK_IMPORTED_MODULE_0__["parsePN"],
  parseTM: _util_index_js__WEBPACK_IMPORTED_MODULE_0__["parseTM"],
  parseDA: _util_index_js__WEBPACK_IMPORTED_MODULE_0__["parseDA"],
  explicitElementToString: _util_index_js__WEBPACK_IMPORTED_MODULE_0__["explicitElementToString"],
  explicitDataSetToJS: _util_index_js__WEBPACK_IMPORTED_MODULE_0__["explicitDataSetToJS"],
  createJPEGBasicOffsetTable: _util_index_js__WEBPACK_IMPORTED_MODULE_0__["createJPEGBasicOffsetTable"],
  parseDicomDataSetExplicit: _parseDicomDataSet_js__WEBPACK_IMPORTED_MODULE_1__["parseDicomDataSetExplicit"],
  parseDicomDataSetImplicit: _parseDicomDataSet_js__WEBPACK_IMPORTED_MODULE_1__["parseDicomDataSetImplicit"],
  readFixedString: _byteArrayParser_js__WEBPACK_IMPORTED_MODULE_2__["readFixedString"],
  alloc: _alloc_js__WEBPACK_IMPORTED_MODULE_3__["default"],
  version: _version_js__WEBPACK_IMPORTED_MODULE_4__["default"],
  bigEndianByteArrayParser: _bigEndianByteArrayParser_js__WEBPACK_IMPORTED_MODULE_5__["default"],
  ByteStream: _byteStream_js__WEBPACK_IMPORTED_MODULE_6__["default"],
  sharedCopy: _sharedCopy_js__WEBPACK_IMPORTED_MODULE_7__["default"],
  DataSet: _dataSet_js__WEBPACK_IMPORTED_MODULE_8__["default"],
  findAndSetUNElementLength: _findAndSetUNElementLength_js__WEBPACK_IMPORTED_MODULE_9__["default"],
  findEndOfEncapsulatedElement: _findEndOfEncapsulatedPixelData_js__WEBPACK_IMPORTED_MODULE_10__["default"],
  findItemDelimitationItemAndSetElementLength: _findItemDelimitationItem_js__WEBPACK_IMPORTED_MODULE_11__["default"],
  littleEndianByteArrayParser: _littleEndianByteArrayParser_js__WEBPACK_IMPORTED_MODULE_12__["default"],
  parseDicom: _parseDicom_js__WEBPACK_IMPORTED_MODULE_13__["default"],
  readDicomElementExplicit: _readDicomElementExplicit_js__WEBPACK_IMPORTED_MODULE_14__["default"],
  readDicomElementImplicit: _readDicomElementImplicit_js__WEBPACK_IMPORTED_MODULE_15__["default"],
  readEncapsulatedImageFrame: _readEncapsulatedImageFrame_js__WEBPACK_IMPORTED_MODULE_16__["default"],
  readEncapsulatedPixelData: _readEncapsulatedPixelData_js__WEBPACK_IMPORTED_MODULE_17__["default"],
  readEncapsulatedPixelDataFromFragments: _readEncapsulatedPixelDataFromFragments_js__WEBPACK_IMPORTED_MODULE_18__["default"],
  readPart10Header: _readPart10Header_js__WEBPACK_IMPORTED_MODULE_19__["default"],
  readSequenceItemsExplicit: _readSequenceElementExplicit_js__WEBPACK_IMPORTED_MODULE_20__["default"],
  readSequenceItemsImplicit: _readSequenceElementImplicit_js__WEBPACK_IMPORTED_MODULE_21__["default"],
  readSequenceItem: _readSequenceItem_js__WEBPACK_IMPORTED_MODULE_22__["default"],
  readTag: _readTag_js__WEBPACK_IMPORTED_MODULE_23__["default"],
  LEI: _parseDicom_js__WEBPACK_IMPORTED_MODULE_13__["LEI"],
  LEE: _parseDicom_js__WEBPACK_IMPORTED_MODULE_13__["LEE"]
};

/* harmony default export */ __webpack_exports__["default"] = (dicomParser);

/***/ }),

/***/ "./littleEndianByteArrayParser.js":
/*!****************************************!*\
  !*** ./littleEndianByteArrayParser.js ***!
  \****************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/**
 * Internal helper functions for parsing different types from a little-endian byte array
 */
/* harmony default export */ __webpack_exports__["default"] = ({
  /**
   *
   * Parses an unsigned int 16 from a little-endian byte array
   *
   * @param byteArray the byte array to read from
   * @param position the position in the byte array to read from
   * @returns {*} the parsed unsigned int 16
   * @throws error if buffer overread would occur
   * @access private
   */
  readUint16: function readUint16(byteArray, position) {
    if (position < 0) {
      throw 'littleEndianByteArrayParser.readUint16: position cannot be less than 0';
    }

    if (position + 2 > byteArray.length) {
      throw 'littleEndianByteArrayParser.readUint16: attempt to read past end of buffer';
    }

    return byteArray[position] + byteArray[position + 1] * 256;
  },

  /**
   *
   * Parses a signed int 16 from a little-endian byte array
   *
   * @param byteArray the byte array to read from
   * @param position the position in the byte array to read from
   * @returns {*} the parsed signed int 16
   * @throws error if buffer overread would occur
   * @access private
   */
  readInt16: function readInt16(byteArray, position) {
    if (position < 0) {
      throw 'littleEndianByteArrayParser.readInt16: position cannot be less than 0';
    }

    if (position + 2 > byteArray.length) {
      throw 'littleEndianByteArrayParser.readInt16: attempt to read past end of buffer';
    }

    var int16 = byteArray[position] + (byteArray[position + 1] << 8); // fix sign

    if (int16 & 0x8000) {
      int16 = int16 - 0xFFFF - 1;
    }

    return int16;
  },

  /**
   * Parses an unsigned int 32 from a little-endian byte array
   *
   * @param byteArray the byte array to read from
   * @param position the position in the byte array to read from
   * @returns {*} the parsed unsigned int 32
   * @throws error if buffer overread would occur
   * @access private
   */
  readUint32: function readUint32(byteArray, position) {
    if (position < 0) {
      throw 'littleEndianByteArrayParser.readUint32: position cannot be less than 0';
    }

    if (position + 4 > byteArray.length) {
      throw 'littleEndianByteArrayParser.readUint32: attempt to read past end of buffer';
    }

    return byteArray[position] + byteArray[position + 1] * 256 + byteArray[position + 2] * 256 * 256 + byteArray[position + 3] * 256 * 256 * 256;
  },

  /**
  * Parses a signed int 32 from a little-endian byte array
  *
  * @param byteArray the byte array to read from
  * @param position the position in the byte array to read from
   * @returns {*} the parsed unsigned int 32
   * @throws error if buffer overread would occur
   * @access private
   */
  readInt32: function readInt32(byteArray, position) {
    if (position < 0) {
      throw 'littleEndianByteArrayParser.readInt32: position cannot be less than 0';
    }

    if (position + 4 > byteArray.length) {
      throw 'littleEndianByteArrayParser.readInt32: attempt to read past end of buffer';
    }

    return byteArray[position] + (byteArray[position + 1] << 8) + (byteArray[position + 2] << 16) + (byteArray[position + 3] << 24);
  },

  /**
   * Parses 32-bit float from a little-endian byte array
   *
   * @param byteArray the byte array to read from
   * @param position the position in the byte array to read from
   * @returns {*} the parsed 32-bit float
   * @throws error if buffer overread would occur
   * @access private
   */
  readFloat: function readFloat(byteArray, position) {
    if (position < 0) {
      throw 'littleEndianByteArrayParser.readFloat: position cannot be less than 0';
    }

    if (position + 4 > byteArray.length) {
      throw 'littleEndianByteArrayParser.readFloat: attempt to read past end of buffer';
    } // I am sure there is a better way than this but this should be safe


    var byteArrayForParsingFloat = new Uint8Array(4);
    byteArrayForParsingFloat[0] = byteArray[position];
    byteArrayForParsingFloat[1] = byteArray[position + 1];
    byteArrayForParsingFloat[2] = byteArray[position + 2];
    byteArrayForParsingFloat[3] = byteArray[position + 3];
    var floatArray = new Float32Array(byteArrayForParsingFloat.buffer);
    return floatArray[0];
  },

  /**
   * Parses 64-bit float from a little-endian byte array
   *
   * @param byteArray the byte array to read from
   * @param position the position in the byte array to read from
   * @returns {*} the parsed 64-bit float
   * @throws error if buffer overread would occur
   * @access private
   */
  readDouble: function readDouble(byteArray, position) {
    if (position < 0) {
      throw 'littleEndianByteArrayParser.readDouble: position cannot be less than 0';
    }

    if (position + 8 > byteArray.length) {
      throw 'littleEndianByteArrayParser.readDouble: attempt to read past end of buffer';
    } // I am sure there is a better way than this but this should be safe


    var byteArrayForParsingFloat = new Uint8Array(8);
    byteArrayForParsingFloat[0] = byteArray[position];
    byteArrayForParsingFloat[1] = byteArray[position + 1];
    byteArrayForParsingFloat[2] = byteArray[position + 2];
    byteArrayForParsingFloat[3] = byteArray[position + 3];
    byteArrayForParsingFloat[4] = byteArray[position + 4];
    byteArrayForParsingFloat[5] = byteArray[position + 5];
    byteArrayForParsingFloat[6] = byteArray[position + 6];
    byteArrayForParsingFloat[7] = byteArray[position + 7];
    var floatArray = new Float64Array(byteArrayForParsingFloat.buffer);
    return floatArray[0];
  }
});

/***/ }),

/***/ "./parseDicom.js":
/*!***********************!*\
  !*** ./parseDicom.js ***!
  \***********************/
/*! exports provided: default, LEI, LEE, BEI */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return parseDicom; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "LEI", function() { return LEI; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "LEE", function() { return LEE; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "BEI", function() { return BEI; });
/* harmony import */ var _alloc_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./alloc.js */ "./alloc.js");
/* harmony import */ var _bigEndianByteArrayParser_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./bigEndianByteArrayParser.js */ "./bigEndianByteArrayParser.js");
/* harmony import */ var _byteStream_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./byteStream.js */ "./byteStream.js");
/* harmony import */ var _dataSet_js__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ./dataSet.js */ "./dataSet.js");
/* harmony import */ var _littleEndianByteArrayParser_js__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! ./littleEndianByteArrayParser.js */ "./littleEndianByteArrayParser.js");
/* harmony import */ var _readPart10Header_js__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(/*! ./readPart10Header.js */ "./readPart10Header.js");
/* harmony import */ var _sharedCopy_js__WEBPACK_IMPORTED_MODULE_6__ = __webpack_require__(/*! ./sharedCopy.js */ "./sharedCopy.js");
/* harmony import */ var _byteArrayParser_js__WEBPACK_IMPORTED_MODULE_7__ = __webpack_require__(/*! ./byteArrayParser.js */ "./byteArrayParser.js");
/* harmony import */ var _parseDicomDataSet_js__WEBPACK_IMPORTED_MODULE_8__ = __webpack_require__(/*! ./parseDicomDataSet.js */ "./parseDicomDataSet.js");








 // LEE (Little Endian Explicit) is the transfer syntax used in dimse operations when there is a split
// between the header and data.

var LEE = '1.2.840.10008.1.2.1'; // LEI (Little Endian Implicit) is the transfer syntax in raw files

var LEI = '1.2.840.10008.1.2'; // BEI (Big Endian Implicit) is deprecated, but needs special parse handling

var BEI = '1.2.840.10008.1.2.2';
/**
 * Parses a DICOM P10 byte array and returns a DataSet object with the parsed elements.
 * If the options argument is supplied and it contains the untilTag property, parsing
 * will stop once that tag is encoutered.  This can be used to parse partial byte streams.
 *
 * @param byteArray the byte array
 * @param options object to control parsing behavior (optional)
 * @returns {DataSet}
 * @throws error if an error occurs while parsing.  The exception object will contain a
 *         property dataSet with the elements successfully parsed before the error.
 */

function parseDicom(byteArray) {
  var options = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : {};

  if (byteArray === undefined) {
    throw new Error('dicomParser.parseDicom: missing required parameter \'byteArray\'');
  }

  var readTransferSyntax = function readTransferSyntax(metaHeaderDataSet) {
    if (metaHeaderDataSet.elements.x00020010 === undefined) {
      throw new Error('dicomParser.parseDicom: missing required meta header attribute 0002,0010');
    }

    var transferSyntaxElement = metaHeaderDataSet.elements.x00020010;
    return transferSyntaxElement && transferSyntaxElement.Value || _byteArrayParser_js__WEBPACK_IMPORTED_MODULE_7__["readFixedString"](byteArray, transferSyntaxElement.dataOffset, transferSyntaxElement.length);
  };

  function isExplicit(transferSyntax) {
    // implicit little endian
    if (transferSyntax === '1.2.840.10008.1.2') {
      return false;
    } // all other transfer syntaxes should be explicit


    return true;
  }

  function getDataSetByteStream(transferSyntax, position) {
    // Detect whether we are inside a browser or Node.js
    var isNode = Object.prototype.toString.call(typeof process !== 'undefined' ? process : 0) === '[object process]';

    if (transferSyntax === '1.2.840.10008.1.2.1.99') {
      // if an infalter callback is registered, use it
      if (options && options.inflater) {
        var fullByteArrayCallback = options.inflater(byteArray, position);
        return new _byteStream_js__WEBPACK_IMPORTED_MODULE_2__["default"](_littleEndianByteArrayParser_js__WEBPACK_IMPORTED_MODULE_4__["default"], fullByteArrayCallback, 0);
      } // if running on node, use the zlib library to inflate
      // http://stackoverflow.com/questions/4224606/how-to-check-whether-a-script-is-running-under-node-js
      else if (isNode === true) {
        // inflate it
        var zlib = __webpack_require__(/*! zlib */ "zlib");

        var deflatedBuffer = Object(_sharedCopy_js__WEBPACK_IMPORTED_MODULE_6__["default"])(byteArray, position, byteArray.length - position);
        var inflatedBuffer = zlib.inflateRawSync(deflatedBuffer); // create a single byte array with the full header bytes and the inflated bytes

        var fullByteArrayBuffer = Object(_alloc_js__WEBPACK_IMPORTED_MODULE_0__["default"])(byteArray, inflatedBuffer.length + position);
        byteArray.copy(fullByteArrayBuffer, 0, 0, position);
        inflatedBuffer.copy(fullByteArrayBuffer, position);
        return new _byteStream_js__WEBPACK_IMPORTED_MODULE_2__["default"](_littleEndianByteArrayParser_js__WEBPACK_IMPORTED_MODULE_4__["default"], fullByteArrayBuffer, 0);
      } // if pako is defined - use it.  This is the web browser path
      // https://github.com/nodeca/pako
      else if (typeof pako !== 'undefined') {
        // inflate it
        var deflated = byteArray.slice(position);
        var inflated = pako.inflateRaw(deflated); // create a single byte array with the full header bytes and the inflated bytes

        var fullByteArray = Object(_alloc_js__WEBPACK_IMPORTED_MODULE_0__["default"])(byteArray, inflated.length + position);
        fullByteArray.set(byteArray.slice(0, position), 0);
        fullByteArray.set(inflated, position);
        return new _byteStream_js__WEBPACK_IMPORTED_MODULE_2__["default"](_littleEndianByteArrayParser_js__WEBPACK_IMPORTED_MODULE_4__["default"], fullByteArray, 0);
      } // throw exception since no inflater is available


      throw 'dicomParser.parseDicom: no inflater available to handle deflate transfer syntax';
    } // explicit big endian


    if (transferSyntax === BEI) {
      return new _byteStream_js__WEBPACK_IMPORTED_MODULE_2__["default"](_bigEndianByteArrayParser_js__WEBPACK_IMPORTED_MODULE_1__["default"], byteArray, position);
    } // all other transfer syntaxes are little endian; only the pixel encoding differs
    // make a new stream so the metaheader warnings don't come along for the ride


    return new _byteStream_js__WEBPACK_IMPORTED_MODULE_2__["default"](_littleEndianByteArrayParser_js__WEBPACK_IMPORTED_MODULE_4__["default"], byteArray, position);
  }

  function mergeDataSets(metaHeaderDataSet, instanceDataSet) {
    for (var propertyName in metaHeaderDataSet.elements) {
      if (metaHeaderDataSet.elements.hasOwnProperty(propertyName)) {
        instanceDataSet.elements[propertyName] = metaHeaderDataSet.elements[propertyName];
      }
    }

    if (metaHeaderDataSet.warnings !== undefined) {
      instanceDataSet.warnings = metaHeaderDataSet.warnings.concat(instanceDataSet.warnings);
    }

    return instanceDataSet;
  }

  function readDataSet(metaHeaderDataSet) {
    var transferSyntax = readTransferSyntax(metaHeaderDataSet);
    var explicit = isExplicit(transferSyntax);
    var dataSetByteStream = getDataSetByteStream(transferSyntax, metaHeaderDataSet.position);
    var elements = {};
    var dataSet = new _dataSet_js__WEBPACK_IMPORTED_MODULE_3__["default"](dataSetByteStream.byteArrayParser, dataSetByteStream.byteArray, elements);
    dataSet.warnings = dataSetByteStream.warnings;

    try {
      if (explicit) {
        _parseDicomDataSet_js__WEBPACK_IMPORTED_MODULE_8__["parseDicomDataSetExplicit"](dataSet, dataSetByteStream, dataSetByteStream.byteArray.length, options);
      } else {
        _parseDicomDataSet_js__WEBPACK_IMPORTED_MODULE_8__["parseDicomDataSetImplicit"](dataSet, dataSetByteStream, dataSetByteStream.byteArray.length, options);
      }
    } catch (e) {
      var ex = {
        exception: e,
        dataSet: dataSet
      };
      throw ex;
    }

    return dataSet;
  } // main function here


  function parseTheByteStream() {
    var metaHeaderDataSet = Object(_readPart10Header_js__WEBPACK_IMPORTED_MODULE_5__["default"])(byteArray, options);
    var dataSet = readDataSet(metaHeaderDataSet);
    return mergeDataSets(metaHeaderDataSet, dataSet);
  } // This is where we actually start parsing


  return parseTheByteStream();
}


/***/ }),

/***/ "./parseDicomDataSet.js":
/*!******************************!*\
  !*** ./parseDicomDataSet.js ***!
  \******************************/
/*! exports provided: parseDicomDataSetExplicit, parseDicomDataSetImplicit */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "parseDicomDataSetExplicit", function() { return parseDicomDataSetExplicit; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "parseDicomDataSetImplicit", function() { return parseDicomDataSetImplicit; });
/* harmony import */ var _readDicomElementExplicit_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./readDicomElementExplicit.js */ "./readDicomElementExplicit.js");
/* harmony import */ var _readDicomElementImplicit_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./readDicomElementImplicit.js */ "./readDicomElementImplicit.js");


/**
 * Internal helper functions for parsing implicit and explicit DICOM data sets
 */

/**
 * reads an explicit data set
 * @param byteStream the byte stream to read from
 * @param maxPosition the maximum position to read up to (optional - only needed when reading sequence items)
 */

function parseDicomDataSetExplicit(dataSet, byteStream, maxPosition) {
  var options = arguments.length > 3 && arguments[3] !== undefined ? arguments[3] : {};
  maxPosition = maxPosition === undefined ? byteStream.byteArray.length : maxPosition;

  if (byteStream === undefined) {
    throw 'dicomParser.parseDicomDataSetExplicit: missing required parameter \'byteStream\'';
  }

  if (maxPosition < byteStream.position || maxPosition > byteStream.byteArray.length) {
    throw 'dicomParser.parseDicomDataSetExplicit: invalid value for parameter \'maxP osition\'';
  }

  var elements = dataSet.elements;

  while (byteStream.position < maxPosition) {
    var element = Object(_readDicomElementExplicit_js__WEBPACK_IMPORTED_MODULE_0__["default"])(byteStream, dataSet.warnings, options.untilTag);
    elements[element.tag] = element;

    if (element.tag === options.untilTag) {
      return;
    }
  }

  if (byteStream.position > maxPosition) {
    throw 'dicomParser:parseDicomDataSetExplicit: buffer overrun';
  }
}
/**
 * reads an implicit data set
 * @param byteStream the byte stream to read from
 * @param maxPosition the maximum position to read up to (optional - only needed when reading sequence items)
 */

function parseDicomDataSetImplicit(dataSet, byteStream, maxPosition) {
  var options = arguments.length > 3 && arguments[3] !== undefined ? arguments[3] : {};
  maxPosition = maxPosition === undefined ? dataSet.byteArray.length : maxPosition;

  if (byteStream === undefined) {
    throw 'dicomParser.parseDicomDataSetImplicit: missing required parameter \'byteStream\'';
  }

  if (maxPosition < byteStream.position || maxPosition > byteStream.byteArray.length) {
    throw 'dicomParser.parseDicomDataSetImplicit: invalid value for parameter \'maxPosition\'';
  }

  var elements = dataSet.elements;

  while (byteStream.position < maxPosition) {
    var element = Object(_readDicomElementImplicit_js__WEBPACK_IMPORTED_MODULE_1__["default"])(byteStream, options.untilTag, options.vrCallback);
    elements[element.tag] = element;

    if (element.tag === options.untilTag) {
      return;
    }
  }
}

/***/ }),

/***/ "./readDicomElementExplicit.js":
/*!*************************************!*\
  !*** ./readDicomElementExplicit.js ***!
  \*************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return readDicomElementExplicit; });
/* harmony import */ var _findEndOfEncapsulatedPixelData_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./findEndOfEncapsulatedPixelData.js */ "./findEndOfEncapsulatedPixelData.js");
/* harmony import */ var _findAndSetUNElementLength_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./findAndSetUNElementLength.js */ "./findAndSetUNElementLength.js");
/* harmony import */ var _readSequenceElementImplicit_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./readSequenceElementImplicit.js */ "./readSequenceElementImplicit.js");
/* harmony import */ var _readTag_js__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ./readTag.js */ "./readTag.js");
/* harmony import */ var _findItemDelimitationItem_js__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! ./findItemDelimitationItem.js */ "./findItemDelimitationItem.js");
/* harmony import */ var _readSequenceElementExplicit_js__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(/*! ./readSequenceElementExplicit.js */ "./readSequenceElementExplicit.js");






/**
 * Internal helper functions for for parsing DICOM elements
 */

var getDataLengthSizeInBytesForVR = function getDataLengthSizeInBytesForVR(vr) {
  if (vr === 'OB' || vr === 'OD' || vr === 'OL' || vr === 'OW' || vr === 'SQ' || vr === 'OF' || vr === 'UC' || vr === 'UR' || vr === 'UT' || vr === 'UN') {
    return 4;
  }

  return 2;
};

function readDicomElementExplicit(byteStream, warnings, untilTag) {
  if (byteStream === undefined) {
    throw 'dicomParser.readDicomElementExplicit: missing required parameter \'byteStream\'';
  }

  var element = {
    tag: Object(_readTag_js__WEBPACK_IMPORTED_MODULE_3__["default"])(byteStream),
    vr: byteStream.readFixedString(2) // length set below based on VR
    // dataOffset set below based on VR and size of length

  };
  var dataLengthSizeBytes = getDataLengthSizeInBytesForVR(element.vr);

  if (dataLengthSizeBytes === 2) {
    element.length = byteStream.readUint16();
    element.dataOffset = byteStream.position;
  } else {
    byteStream.seek(2);
    element.length = byteStream.readUint32();
    element.dataOffset = byteStream.position;
  }

  if (element.length === 4294967295) {
    element.hadUndefinedLength = true;
  }

  if (element.tag === untilTag) {
    return element;
  } // if VR is SQ, parse the sequence items


  if (element.vr === 'SQ') {
    Object(_readSequenceElementExplicit_js__WEBPACK_IMPORTED_MODULE_5__["default"])(byteStream, element, warnings);
    return element;
  }

  if (element.length === 4294967295) {
    if (element.tag === 'x7fe00010') {
      Object(_findEndOfEncapsulatedPixelData_js__WEBPACK_IMPORTED_MODULE_0__["default"])(byteStream, element, warnings);
      return element;
    } else if (element.vr === 'UN') {
      Object(_readSequenceElementImplicit_js__WEBPACK_IMPORTED_MODULE_2__["default"])(byteStream, element);
      return element;
    }

    Object(_findItemDelimitationItem_js__WEBPACK_IMPORTED_MODULE_4__["default"])(byteStream, element);
    return element;
  }

  byteStream.seek(element.length);
  return element;
}

/***/ }),

/***/ "./readDicomElementImplicit.js":
/*!*************************************!*\
  !*** ./readDicomElementImplicit.js ***!
  \*************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return readDicomElementImplicit; });
/* harmony import */ var _findItemDelimitationItem_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./findItemDelimitationItem.js */ "./findItemDelimitationItem.js");
/* harmony import */ var _readSequenceElementImplicit_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./readSequenceElementImplicit.js */ "./readSequenceElementImplicit.js");
/* harmony import */ var _readTag_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./readTag.js */ "./readTag.js");
/* harmony import */ var _util_util_js__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ./util/util.js */ "./util/util.js");




/**
 * Internal helper functions for for parsing DICOM elements
 */

var isSequence = function isSequence(element, byteStream) {
  if (element.vr !== undefined) {
    return element.vr === 'SQ';
  }

  if (byteStream.position + 4 <= byteStream.byteArray.length) {
    var nextTag = Object(_readTag_js__WEBPACK_IMPORTED_MODULE_2__["default"])(byteStream);
    byteStream.seek(-4); // Item start tag (fffe,e000) or sequence delimiter (i.e. end of sequence) tag (0fffe,e0dd)
    // These are the tags that could potentially be found directly after a sequence start tag (the delimiter
    // is found in the case of an empty sequence). This is not 100% safe because a non-sequence item
    // could have data that has these bytes, but this is how to do it without a data dictionary.

    return nextTag === 'xfffee000' || nextTag === 'xfffee0dd';
  }

  byteStream.warnings.push('eof encountered before finding sequence item tag or sequence delimiter tag in peeking to determine VR');
  return false;
};

function readDicomElementImplicit(byteStream, untilTag, vrCallback) {
  if (byteStream === undefined) {
    throw 'dicomParser.readDicomElementImplicit: missing required parameter \'byteStream\'';
  }

  var tag = Object(_readTag_js__WEBPACK_IMPORTED_MODULE_2__["default"])(byteStream);
  var element = {
    tag: tag,
    vr: vrCallback !== undefined ? vrCallback(tag) : undefined,
    length: byteStream.readUint32(),
    dataOffset: byteStream.position
  };

  if (element.length === 4294967295) {
    element.hadUndefinedLength = true;
  }

  if (element.tag === untilTag) {
    return element;
  } // always parse sequences with undefined lengths, since there's no other way to know how long they are.


  if (isSequence(element, byteStream) && (!Object(_util_util_js__WEBPACK_IMPORTED_MODULE_3__["isPrivateTag"])(element.tag) || element.hadUndefinedLength)) {
    // parse the sequence
    Object(_readSequenceElementImplicit_js__WEBPACK_IMPORTED_MODULE_1__["default"])(byteStream, element, vrCallback);

    if (Object(_util_util_js__WEBPACK_IMPORTED_MODULE_3__["isPrivateTag"])(element.tag)) {
      element.items = undefined;
    }

    return element;
  } // if element is not a sequence and has undefined length, we have to
  // scan the data for a magic number to figure out when it ends.


  if (element.hadUndefinedLength) {
    Object(_findItemDelimitationItem_js__WEBPACK_IMPORTED_MODULE_0__["default"])(byteStream, element);
    return element;
  } // non sequence element with known length, skip over the data part


  byteStream.seek(element.length);
  return element;
}

/***/ }),

/***/ "./readEncapsulatedImageFrame.js":
/*!***************************************!*\
  !*** ./readEncapsulatedImageFrame.js ***!
  \***************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return readEncapsulatedImageFrame; });
/* harmony import */ var _readEncapsulatedPixelDataFromFragments_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./readEncapsulatedPixelDataFromFragments.js */ "./readEncapsulatedPixelDataFromFragments.js");

/**
 * Functionality for extracting encapsulated pixel data
 */

var findFragmentIndexWithOffset = function findFragmentIndexWithOffset(fragments, offset) {
  for (var i = 0; i < fragments.length; i++) {
    if (fragments[i].offset === offset) {
      return i;
    }
  }
};

var calculateNumberOfFragmentsForFrame = function calculateNumberOfFragmentsForFrame(frameIndex, basicOffsetTable, fragments, startFragmentIndex) {
  // special case for last frame
  if (frameIndex === basicOffsetTable.length - 1) {
    return fragments.length - startFragmentIndex;
  } // iterate through each fragment looking for the one matching the offset for the next frame


  var nextFrameOffset = basicOffsetTable[frameIndex + 1];

  for (var i = startFragmentIndex + 1; i < fragments.length; i++) {
    if (fragments[i].offset === nextFrameOffset) {
      return i - startFragmentIndex;
    }
  }

  throw 'dicomParser.calculateNumberOfFragmentsForFrame: could not find fragment with offset matching basic offset table';
};
/**
 * Returns the pixel data for the specified frame in an encapsulated pixel data element that has a non
 * empty basic offset table.  Note that this function will fail if the basic offset table is empty - in that
 * case you need to determine which fragments map to which frames and read them using
 * readEncapsulatedPixelDataFromFragments().  Also see the function createJEPGBasicOffsetTable() to see
 * how a basic offset table can be created for JPEG images
 *
 * @param dataSet - the dataSet containing the encapsulated pixel data
 * @param pixelDataElement - the pixel data element (x7fe00010) to extract the frame from
 * @param frameIndex - the zero based frame index
 * @param [basicOffsetTable] - optional array of starting offsets for frames
 * @param [fragments] - optional array of objects describing each fragment (offset, position, length)
 * @returns {object} with the encapsulated pixel data
 */


function readEncapsulatedImageFrame(dataSet, pixelDataElement, frameIndex, basicOffsetTable, fragments) {
  // default parameters
  basicOffsetTable = basicOffsetTable || pixelDataElement.basicOffsetTable;
  fragments = fragments || pixelDataElement.fragments; // Validate parameters

  if (dataSet === undefined) {
    throw 'dicomParser.readEncapsulatedImageFrame: missing required parameter \'dataSet\'';
  }

  if (pixelDataElement === undefined) {
    throw 'dicomParser.readEncapsulatedImageFrame: missing required parameter \'pixelDataElement\'';
  }

  if (frameIndex === undefined) {
    throw 'dicomParser.readEncapsulatedImageFrame: missing required parameter \'frameIndex\'';
  }

  if (basicOffsetTable === undefined) {
    throw 'dicomParser.readEncapsulatedImageFrame: parameter \'pixelDataElement\' does not have basicOffsetTable';
  }

  if (pixelDataElement.tag !== 'x7fe00010') {
    throw 'dicomParser.readEncapsulatedImageFrame: parameter \'pixelDataElement\' refers to non pixel data tag (expected tag = x7fe00010)';
  }

  if (pixelDataElement.encapsulatedPixelData !== true) {
    throw 'dicomParser.readEncapsulatedImageFrame: parameter \'pixelDataElement\' refers to pixel data element that does not have encapsulated pixel data';
  }

  if (pixelDataElement.hadUndefinedLength !== true) {
    throw 'dicomParser.readEncapsulatedImageFrame: parameter \'pixelDataElement\' refers to pixel data element that does not have undefined length';
  }

  if (pixelDataElement.fragments === undefined) {
    throw 'dicomParser.readEncapsulatedImageFrame: parameter \'pixelDataElement\' refers to pixel data element that does not have fragments';
  }

  if (basicOffsetTable.length === 0) {
    throw 'dicomParser.readEncapsulatedImageFrame: basicOffsetTable has zero entries';
  }

  if (frameIndex < 0) {
    throw 'dicomParser.readEncapsulatedImageFrame: parameter \'frameIndex\' must be >= 0';
  }

  if (frameIndex >= basicOffsetTable.length) {
    throw 'dicomParser.readEncapsulatedImageFrame: parameter \'frameIndex\' must be < basicOffsetTable.length';
  } // find starting fragment based on the offset for the frame in the basic offset table


  var offset = basicOffsetTable[frameIndex];
  var startFragmentIndex = findFragmentIndexWithOffset(fragments, offset);

  if (startFragmentIndex === undefined) {
    throw 'dicomParser.readEncapsulatedImageFrame: unable to find fragment that matches basic offset table entry';
  } // calculate the number of fragments for this frame


  var numFragments = calculateNumberOfFragmentsForFrame(frameIndex, basicOffsetTable, fragments, startFragmentIndex); // now extract the frame from the fragments

  return Object(_readEncapsulatedPixelDataFromFragments_js__WEBPACK_IMPORTED_MODULE_0__["default"])(dataSet, pixelDataElement, startFragmentIndex, numFragments, fragments);
}

/***/ }),

/***/ "./readEncapsulatedPixelData.js":
/*!**************************************!*\
  !*** ./readEncapsulatedPixelData.js ***!
  \**************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return readEncapsulatedPixelData; });
/* harmony import */ var _readEncapsulatedImageFrame_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./readEncapsulatedImageFrame.js */ "./readEncapsulatedImageFrame.js");
/* harmony import */ var _readEncapsulatedPixelDataFromFragments_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./readEncapsulatedPixelDataFromFragments.js */ "./readEncapsulatedPixelDataFromFragments.js");


/**
 * Functionality for extracting encapsulated pixel data
 */

var deprecatedNoticeLogged = false;
/**
 * Returns the pixel data for the specified frame in an encapsulated pixel data element.  If no basic offset
 * table is present, it assumes that all fragments are for one frame.  Note that this assumption/logic is not
 * valid for multi-frame instances so this function has been deprecated and will eventually be removed.  Code
 * should be updated to use readEncapsulatedPixelDataFromFragments() or readEncapsulatedImageFrame()
 *
 * @deprecated since version 1.6 - use readEncapsulatedPixelDataFromFragments() or readEncapsulatedImageFrame()
 * @param dataSet - the dataSet containing the encapsulated pixel data
 * @param pixelDataElement - the pixel data element (x7fe00010) to extract the frame from
 * @param frame - the zero based frame index
 * @returns {object} with the encapsulated pixel data
 */

function readEncapsulatedPixelData(dataSet, pixelDataElement, frame) {
  if (!deprecatedNoticeLogged) {
    deprecatedNoticeLogged = true;

    if (console && console.log) {
      console.log('WARNING: dicomParser.readEncapsulatedPixelData() has been deprecated');
    }
  }

  if (dataSet === undefined) {
    throw 'dicomParser.readEncapsulatedPixelData: missing required parameter \'dataSet\'';
  }

  if (pixelDataElement === undefined) {
    throw 'dicomParser.readEncapsulatedPixelData: missing required parameter \'element\'';
  }

  if (frame === undefined) {
    throw 'dicomParser.readEncapsulatedPixelData: missing required parameter \'frame\'';
  }

  if (pixelDataElement.tag !== 'x7fe00010') {
    throw 'dicomParser.readEncapsulatedPixelData: parameter \'element\' refers to non pixel data tag (expected tag = x7fe00010)';
  }

  if (pixelDataElement.encapsulatedPixelData !== true) {
    throw 'dicomParser.readEncapsulatedPixelData: parameter \'element\' refers to pixel data element that does not have encapsulated pixel data';
  }

  if (pixelDataElement.hadUndefinedLength !== true) {
    throw 'dicomParser.readEncapsulatedPixelData: parameter \'element\' refers to pixel data element that does not have encapsulated pixel data';
  }

  if (pixelDataElement.basicOffsetTable === undefined) {
    throw 'dicomParser.readEncapsulatedPixelData: parameter \'element\' refers to pixel data element that does not have encapsulated pixel data';
  }

  if (pixelDataElement.fragments === undefined) {
    throw 'dicomParser.readEncapsulatedPixelData: parameter \'element\' refers to pixel data element that does not have encapsulated pixel data';
  }

  if (frame < 0) {
    throw 'dicomParser.readEncapsulatedPixelData: parameter \'frame\' must be >= 0';
  } // If the basic offset table is not empty, we can extract the frame


  if (pixelDataElement.basicOffsetTable.length !== 0) {
    return Object(_readEncapsulatedImageFrame_js__WEBPACK_IMPORTED_MODULE_0__["default"])(dataSet, pixelDataElement, frame);
  } // No basic offset table, assume all fragments are for one frame - NOTE that this is NOT a valid
  // assumption but is the original behavior so we are keeping it for now


  return Object(_readEncapsulatedPixelDataFromFragments_js__WEBPACK_IMPORTED_MODULE_1__["default"])(dataSet, pixelDataElement, 0, pixelDataElement.fragments.length);
}

/***/ }),

/***/ "./readEncapsulatedPixelDataFromFragments.js":
/*!***************************************************!*\
  !*** ./readEncapsulatedPixelDataFromFragments.js ***!
  \***************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return readEncapsulatedPixelDataFromFragments; });
/* harmony import */ var _alloc_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./alloc.js */ "./alloc.js");
/* harmony import */ var _byteStream_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./byteStream.js */ "./byteStream.js");
/* harmony import */ var _readSequenceItem_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./readSequenceItem.js */ "./readSequenceItem.js");
/* harmony import */ var _sharedCopy_js__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ./sharedCopy.js */ "./sharedCopy.js");




/**
 * Functionality for extracting encapsulated pixel data
 */

var calculateBufferSize = function calculateBufferSize(fragments, startFragment, numFragments) {
  var bufferSize = 0;

  for (var i = startFragment; i < startFragment + numFragments; i++) {
    bufferSize += fragments[i].length;
  }

  return bufferSize;
};
/**
 * Returns the encapsulated pixel data from the specified fragments.  Use this function when you know
 * the fragments you want to extract data from.  See
 *
 * @param dataSet - the dataSet containing the encapsulated pixel data
 * @param pixelDataElement - the pixel data element (x7fe00010) to extract the fragment data from
 * @param startFragmentIndex - zero based index of the first fragment to extract from
 * @param [numFragments] - the number of fragments to extract from, default is 1
 * @param [fragments] - optional array of objects describing each fragment (offset, position, length)
 * @returns {object} byte array with the encapsulated pixel data
 */


function readEncapsulatedPixelDataFromFragments(dataSet, pixelDataElement, startFragmentIndex, numFragments, fragments) {
  // default values
  numFragments = numFragments || 1;
  fragments = fragments || pixelDataElement.fragments; // check parameters

  if (dataSet === undefined) {
    throw 'dicomParser.readEncapsulatedPixelDataFromFragments: missing required parameter \'dataSet\'';
  }

  if (pixelDataElement === undefined) {
    throw 'dicomParser.readEncapsulatedPixelDataFromFragments: missing required parameter \'pixelDataElement\'';
  }

  if (startFragmentIndex === undefined) {
    throw 'dicomParser.readEncapsulatedPixelDataFromFragments: missing required parameter \'startFragmentIndex\'';
  }

  if (numFragments === undefined) {
    throw 'dicomParser.readEncapsulatedPixelDataFromFragments: missing required parameter \'numFragments\'';
  }

  if (pixelDataElement.tag !== 'x7fe00010') {
    throw 'dicomParser.readEncapsulatedPixelDataFromFragments: parameter \'pixelDataElement\' refers to non pixel data tag (expected tag = x7fe00010';
  }

  if (pixelDataElement.encapsulatedPixelData !== true) {
    throw 'dicomParser.readEncapsulatedPixelDataFromFragments: parameter \'pixelDataElement\' refers to pixel data element that does not have encapsulated pixel data';
  }

  if (pixelDataElement.hadUndefinedLength !== true) {
    throw 'dicomParser.readEncapsulatedPixelDataFromFragments: parameter \'pixelDataElement\' refers to pixel data element that does not have encapsulated pixel data';
  }

  if (pixelDataElement.basicOffsetTable === undefined) {
    throw 'dicomParser.readEncapsulatedPixelDataFromFragments: parameter \'pixelDataElement\' refers to pixel data element that does not have encapsulated pixel data';
  }

  if (pixelDataElement.fragments === undefined) {
    throw 'dicomParser.readEncapsulatedPixelDataFromFragments: parameter \'pixelDataElement\' refers to pixel data element that does not have encapsulated pixel data';
  }

  if (pixelDataElement.fragments.length <= 0) {
    throw 'dicomParser.readEncapsulatedPixelDataFromFragments: parameter \'pixelDataElement\' refers to pixel data element that does not have encapsulated pixel data';
  }

  if (startFragmentIndex < 0) {
    throw 'dicomParser.readEncapsulatedPixelDataFromFragments: parameter \'startFragmentIndex\' must be >= 0';
  }

  if (startFragmentIndex >= pixelDataElement.fragments.length) {
    throw 'dicomParser.readEncapsulatedPixelDataFromFragments: parameter \'startFragmentIndex\' must be < number of fragments';
  }

  if (numFragments < 1) {
    throw 'dicomParser.readEncapsulatedPixelDataFromFragments: parameter \'numFragments\' must be > 0';
  }

  if (startFragmentIndex + numFragments > pixelDataElement.fragments.length) {
    throw 'dicomParser.readEncapsulatedPixelDataFromFragments: parameter \'startFragment\' + \'numFragments\' < number of fragments';
  } // create byte stream on the data for this pixel data element


  var byteStream = new _byteStream_js__WEBPACK_IMPORTED_MODULE_1__["default"](dataSet.byteArrayParser, dataSet.byteArray, pixelDataElement.dataOffset); // seek past the basic offset table (no need to parse it again since we already have)

  var basicOffsetTable = Object(_readSequenceItem_js__WEBPACK_IMPORTED_MODULE_2__["default"])(byteStream);

  if (basicOffsetTable.tag !== 'xfffee000') {
    throw 'dicomParser.readEncapsulatedPixelData: missing basic offset table xfffee000';
  }

  byteStream.seek(basicOffsetTable.length);
  var fragmentZeroPosition = byteStream.position; // tag + length

  var fragmentHeaderSize = 8; // if there is only one fragment, return a view on this array to avoid copying

  if (numFragments === 1) {
    return Object(_sharedCopy_js__WEBPACK_IMPORTED_MODULE_3__["default"])(byteStream.byteArray, fragmentZeroPosition + fragments[startFragmentIndex].offset + fragmentHeaderSize, fragments[startFragmentIndex].length);
  } // more than one fragment, combine all of the fragments into one buffer


  var bufferSize = calculateBufferSize(fragments, startFragmentIndex, numFragments);
  var pixelData = Object(_alloc_js__WEBPACK_IMPORTED_MODULE_0__["default"])(byteStream.byteArray, bufferSize);
  var pixelDataIndex = 0;

  for (var i = startFragmentIndex; i < startFragmentIndex + numFragments; i++) {
    var fragmentOffset = fragmentZeroPosition + fragments[i].offset + fragmentHeaderSize;

    for (var j = 0; j < fragments[i].length; j++) {
      pixelData[pixelDataIndex++] = byteStream.byteArray[fragmentOffset++];
    }
  }

  return pixelData;
}

/***/ }),

/***/ "./readPart10Header.js":
/*!*****************************!*\
  !*** ./readPart10Header.js ***!
  \*****************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return readPart10Header; });
/* harmony import */ var _byteStream_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./byteStream.js */ "./byteStream.js");
/* harmony import */ var _dataSet_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./dataSet.js */ "./dataSet.js");
/* harmony import */ var _littleEndianByteArrayParser_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./littleEndianByteArrayParser.js */ "./littleEndianByteArrayParser.js");
/* harmony import */ var _readDicomElementExplicit_js__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ./readDicomElementExplicit.js */ "./readDicomElementExplicit.js");




/**
 * Parses a DICOM P10 byte array and returns a DataSet object with the parsed elements.  If the options
 * argument is supplied and it contains the untilTag property, parsing will stop once that
 * tag is encoutered.  This can be used to parse partial byte streams.
 *
 * @param byteArray the byte array
 * @param options Optional options values
 *    TransferSyntaxUID: String to specify a default raw transfer syntax UID.
 *        Use the LEI transfer syntax for raw files, or the provided one for SCP transfers.
 * @returns {DataSet}
 * @throws error if an error occurs while parsing.  The exception object will contain a property dataSet with the
 *         elements successfully parsed before the error.
 */

function readPart10Header(byteArray) {
  var options = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : {};

  if (byteArray === undefined) {
    throw 'dicomParser.readPart10Header: missing required parameter \'byteArray\'';
  }

  var TransferSyntaxUID = options.TransferSyntaxUID;
  var littleEndianByteStream = new _byteStream_js__WEBPACK_IMPORTED_MODULE_0__["default"](_littleEndianByteArrayParser_js__WEBPACK_IMPORTED_MODULE_2__["default"], byteArray);

  function readPrefix() {
    if (littleEndianByteStream.getSize() <= 132 && TransferSyntaxUID) {
      return false;
    }

    littleEndianByteStream.seek(128);
    var prefix = littleEndianByteStream.readFixedString(4);

    if (prefix !== 'DICM') {
      var _ref = options || {},
          _TransferSyntaxUID = _ref.TransferSyntaxUID;

      if (!_TransferSyntaxUID) {
        throw 'dicomParser.readPart10Header: DICM prefix not found at location 132 - this is not a valid DICOM P10 file.';
      }

      littleEndianByteStream.seek(0);
      return false;
    }

    return true;
  } // main function here


  function readTheHeader() {
    // Per the DICOM standard, the header is always encoded in Explicit VR Little Endian (see PS3.10, section 7.1)
    // so use littleEndianByteStream throughout this method regardless of the transfer syntax
    var isPart10 = readPrefix();
    var warnings = [];
    var elements = {};

    if (!isPart10) {
      littleEndianByteStream.position = 0;
      var _metaHeaderDataSet = {
        elements: {
          x00020010: {
            tag: 'x00020010',
            vr: 'UI',
            Value: TransferSyntaxUID
          }
        },
        warnings: warnings
      }; // console.log('Returning metaHeaderDataSet', metaHeaderDataSet);

      return _metaHeaderDataSet;
    }

    while (littleEndianByteStream.position < littleEndianByteStream.byteArray.length) {
      var position = littleEndianByteStream.position;
      var element = Object(_readDicomElementExplicit_js__WEBPACK_IMPORTED_MODULE_3__["default"])(littleEndianByteStream, warnings);

      if (element.tag > 'x0002ffff') {
        littleEndianByteStream.position = position;
        break;
      } // Cache the littleEndianByteArrayParser for meta header elements, since the rest of the data set may be big endian
      // and this parser will be needed later if the meta header values are to be read.


      element.parser = _littleEndianByteArrayParser_js__WEBPACK_IMPORTED_MODULE_2__["default"];
      elements[element.tag] = element;
    }

    var metaHeaderDataSet = new _dataSet_js__WEBPACK_IMPORTED_MODULE_1__["default"](littleEndianByteStream.byteArrayParser, littleEndianByteStream.byteArray, elements);
    metaHeaderDataSet.warnings = littleEndianByteStream.warnings;
    metaHeaderDataSet.position = littleEndianByteStream.position;
    return metaHeaderDataSet;
  } // This is where we actually start parsing


  return readTheHeader();
}

/***/ }),

/***/ "./readSequenceElementExplicit.js":
/*!****************************************!*\
  !*** ./readSequenceElementExplicit.js ***!
  \****************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return readSequenceItemsExplicit; });
/* harmony import */ var _dataSet_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./dataSet.js */ "./dataSet.js");
/* harmony import */ var _readDicomElementExplicit_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./readDicomElementExplicit.js */ "./readDicomElementExplicit.js");
/* harmony import */ var _readSequenceItem_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./readSequenceItem.js */ "./readSequenceItem.js");
/* harmony import */ var _readTag_js__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ./readTag.js */ "./readTag.js");
/* harmony import */ var _parseDicomDataSet_js__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! ./parseDicomDataSet.js */ "./parseDicomDataSet.js");





/**
 * Internal helper functions for parsing DICOM elements
 */

function readDicomDataSetExplicitUndefinedLength(byteStream, warnings) {
  var elements = {};

  while (byteStream.position < byteStream.byteArray.length) {
    var element = Object(_readDicomElementExplicit_js__WEBPACK_IMPORTED_MODULE_1__["default"])(byteStream, warnings);
    elements[element.tag] = element; // we hit an item delimiter tag, return the current offset to mark
    // the end of this sequence item

    if (element.tag === 'xfffee00d') {
      return new _dataSet_js__WEBPACK_IMPORTED_MODULE_0__["default"](byteStream.byteArrayParser, byteStream.byteArray, elements);
    }
  } // eof encountered - log a warning and return what we have for the element


  warnings.push('eof encountered before finding item delimiter tag while reading sequence item of undefined length');
  return new _dataSet_js__WEBPACK_IMPORTED_MODULE_0__["default"](byteStream.byteArrayParser, byteStream.byteArray, elements);
}

function readSequenceItemExplicit(byteStream, warnings) {
  var item = Object(_readSequenceItem_js__WEBPACK_IMPORTED_MODULE_2__["default"])(byteStream);

  if (item.length === 4294967295) {
    item.hadUndefinedLength = true;
    item.dataSet = readDicomDataSetExplicitUndefinedLength(byteStream, warnings);
    item.length = byteStream.position - item.dataOffset;
  } else {
    item.dataSet = new _dataSet_js__WEBPACK_IMPORTED_MODULE_0__["default"](byteStream.byteArrayParser, byteStream.byteArray, {});
    _parseDicomDataSet_js__WEBPACK_IMPORTED_MODULE_4__["parseDicomDataSetExplicit"](item.dataSet, byteStream, byteStream.position + item.length);
  }

  return item;
}

function readSQElementUndefinedLengthExplicit(byteStream, element, warnings) {
  while (byteStream.position + 4 <= byteStream.byteArray.length) {
    // end reading this sequence if the next tag is the sequence delimitation item
    var nextTag = Object(_readTag_js__WEBPACK_IMPORTED_MODULE_3__["default"])(byteStream);
    byteStream.seek(-4);

    if (nextTag === 'xfffee0dd') {
      // set the correct length
      element.length = byteStream.position - element.dataOffset;
      byteStream.seek(8);
      return element;
    }

    var item = readSequenceItemExplicit(byteStream, warnings);
    element.items.push(item);
  }

  warnings.push('eof encountered before finding sequence delimitation tag while reading sequence of undefined length');
  element.length = byteStream.position - element.dataOffset;
}

function readSQElementKnownLengthExplicit(byteStream, element, warnings) {
  var maxPosition = element.dataOffset + element.length;

  while (byteStream.position < maxPosition) {
    var item = readSequenceItemExplicit(byteStream, warnings);
    element.items.push(item);
  }
}

function readSequenceItemsExplicit(byteStream, element, warnings) {
  if (byteStream === undefined) {
    throw 'dicomParser.readSequenceItemsExplicit: missing required parameter \'byteStream\'';
  }

  if (element === undefined) {
    throw 'dicomParser.readSequenceItemsExplicit: missing required parameter \'element\'';
  }

  element.items = [];

  if (element.length === 4294967295) {
    readSQElementUndefinedLengthExplicit(byteStream, element, warnings);
  } else {
    readSQElementKnownLengthExplicit(byteStream, element, warnings);
  }
}

/***/ }),

/***/ "./readSequenceElementImplicit.js":
/*!****************************************!*\
  !*** ./readSequenceElementImplicit.js ***!
  \****************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return readSequenceItemsImplicit; });
/* harmony import */ var _dataSet_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./dataSet.js */ "./dataSet.js");
/* harmony import */ var _readDicomElementImplicit_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./readDicomElementImplicit.js */ "./readDicomElementImplicit.js");
/* harmony import */ var _readSequenceItem_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./readSequenceItem.js */ "./readSequenceItem.js");
/* harmony import */ var _readTag_js__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ./readTag.js */ "./readTag.js");
/* harmony import */ var _parseDicomDataSet_js__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! ./parseDicomDataSet.js */ "./parseDicomDataSet.js");





/**
 * Internal helper functions for parsing DICOM elements
 */

function readDicomDataSetImplicitUndefinedLength(byteStream, vrCallback) {
  var elements = {};

  while (byteStream.position < byteStream.byteArray.length) {
    var element = Object(_readDicomElementImplicit_js__WEBPACK_IMPORTED_MODULE_1__["default"])(byteStream, undefined, vrCallback);
    elements[element.tag] = element; // we hit an item delimiter tag, return the current offset to mark
    // the end of this sequence item

    if (element.tag === 'xfffee00d') {
      return new _dataSet_js__WEBPACK_IMPORTED_MODULE_0__["default"](byteStream.byteArrayParser, byteStream.byteArray, elements);
    }
  } // eof encountered - log a warning and return what we have for the element


  byteStream.warnings.push('eof encountered before finding sequence item delimiter in sequence item of undefined length');
  return new _dataSet_js__WEBPACK_IMPORTED_MODULE_0__["default"](byteStream.byteArrayParser, byteStream.byteArray, elements);
}

function readSequenceItemImplicit(byteStream, vrCallback) {
  var item = Object(_readSequenceItem_js__WEBPACK_IMPORTED_MODULE_2__["default"])(byteStream);

  if (item.length === 4294967295) {
    item.hadUndefinedLength = true;
    item.dataSet = readDicomDataSetImplicitUndefinedLength(byteStream, vrCallback);
    item.length = byteStream.position - item.dataOffset;
  } else {
    item.dataSet = new _dataSet_js__WEBPACK_IMPORTED_MODULE_0__["default"](byteStream.byteArrayParser, byteStream.byteArray, {});
    _parseDicomDataSet_js__WEBPACK_IMPORTED_MODULE_4__["parseDicomDataSetImplicit"](item.dataSet, byteStream, byteStream.position + item.length, {
      vrCallback: vrCallback
    });
  }

  return item;
}

function readSQElementUndefinedLengthImplicit(byteStream, element, vrCallback) {
  while (byteStream.position + 4 <= byteStream.byteArray.length) {
    // end reading this sequence if the next tag is the sequence delimitation item
    var nextTag = Object(_readTag_js__WEBPACK_IMPORTED_MODULE_3__["default"])(byteStream);
    byteStream.seek(-4);

    if (nextTag === 'xfffee0dd') {
      // set the correct length
      element.length = byteStream.position - element.dataOffset;
      byteStream.seek(8);
      return element;
    }

    var item = readSequenceItemImplicit(byteStream, vrCallback);
    element.items.push(item);
  }

  byteStream.warnings.push('eof encountered before finding sequence delimiter in sequence of undefined length');
  element.length = byteStream.byteArray.length - element.dataOffset;
}

function readSQElementKnownLengthImplicit(byteStream, element, vrCallback) {
  var maxPosition = element.dataOffset + element.length;

  while (byteStream.position < maxPosition) {
    var item = readSequenceItemImplicit(byteStream, vrCallback);
    element.items.push(item);
  }
}
/**
 * Reads sequence items for an element in an implicit little endian byte stream
 * @param byteStream the implicit little endian byte stream
 * @param element the element to read the sequence items for
 * @param vrCallback an optional method that returns a VR string given a tag
 */


function readSequenceItemsImplicit(byteStream, element, vrCallback) {
  if (byteStream === undefined) {
    throw 'dicomParser.readSequenceItemsImplicit: missing required parameter \'byteStream\'';
  }

  if (element === undefined) {
    throw 'dicomParser.readSequenceItemsImplicit: missing required parameter \'element\'';
  }

  element.items = [];

  if (element.length === 4294967295) {
    readSQElementUndefinedLengthImplicit(byteStream, element, vrCallback);
  } else {
    readSQElementKnownLengthImplicit(byteStream, element, vrCallback);
  }
}

/***/ }),

/***/ "./readSequenceItem.js":
/*!*****************************!*\
  !*** ./readSequenceItem.js ***!
  \*****************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return readSequenceItem; });
/* harmony import */ var _readTag_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./readTag.js */ "./readTag.js");

/**
 * Internal helper functions for parsing DICOM elements
 */

/**
 * Reads the tag and length of a sequence item and returns them as an object with the following properties
 *  tag : string for the tag of this element in the format xggggeeee
 *  length: the number of bytes in this item or 4294967295 if undefined
 *  dataOffset: the offset into the byteStream of the data for this item
 * @param byteStream the byte
 * @returns {{tag: string, length: integer, dataOffset: integer}}
 */

function readSequenceItem(byteStream) {
  if (byteStream === undefined) {
    throw 'dicomParser.readSequenceItem: missing required parameter \'byteStream\'';
  }

  var element = {
    tag: Object(_readTag_js__WEBPACK_IMPORTED_MODULE_0__["default"])(byteStream),
    length: byteStream.readUint32(),
    dataOffset: byteStream.position
  };

  if (element.tag !== 'xfffee000') {
    throw "dicomParser.readSequenceItem: item tag (FFFE,E000) not found at offset ".concat(byteStream.position);
  }

  return element;
}

/***/ }),

/***/ "./readTag.js":
/*!********************!*\
  !*** ./readTag.js ***!
  \********************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return readTag; });
/**
 * Internal helper functions for parsing DICOM elements
 */

/**
 * Reads a tag (group number and element number) from a byteStream
 * @param byteStream the byte stream to read from
 * @returns {string} the tag in format xggggeeee where gggg is the lowercase hex value of the group number
 * and eeee is the lower case hex value of the element number
 */
function readTag(byteStream) {
  if (byteStream === undefined) {
    throw 'dicomParser.readTag: missing required parameter \'byteStream\'';
  }

  var groupNumber = byteStream.readUint16() * 256 * 256;
  var elementNumber = byteStream.readUint16();
  var tag = "x".concat("00000000".concat((groupNumber + elementNumber).toString(16)).substr(-8));
  return tag;
}

/***/ }),

/***/ "./sharedCopy.js":
/*!***********************!*\
  !*** ./sharedCopy.js ***!
  \***********************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return sharedCopy; });
/**
 *
 * Internal helper function to create a shared copy of a byteArray
 *
 */

/**
 * Creates a view of the underlying byteArray.  The view is of the same type as the byteArray (e.g.
 * Uint8Array or Buffer) and shares the same underlying memory (changing one changes the other)
 * @param byteArray the underlying byteArray (either Uint8Array or Buffer)
 * @param byteOffset offset into the underlying byteArray to create the view of
 * @param length number of bytes in the view
 * @returns {object} Uint8Array or Buffer depending on the type of byteArray
 */
function sharedCopy(byteArray, byteOffset, length) {
  if (typeof Buffer !== 'undefined' && byteArray instanceof Buffer) {
    return byteArray.slice(byteOffset, byteOffset + length);
  } else if (byteArray instanceof Uint8Array) {
    return new Uint8Array(byteArray.buffer, byteArray.byteOffset + byteOffset, length);
  }

  throw 'dicomParser.from: unknown type for byteArray';
}

/***/ }),

/***/ "./util/createJPEGBasicOffsetTable.js":
/*!********************************************!*\
  !*** ./util/createJPEGBasicOffsetTable.js ***!
  \********************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return createJPEGBasicOffsetTable; });
// Each JPEG image has an end of image marker 0xFFD9
function isEndOfImageMarker(dataSet, position) {
  return dataSet.byteArray[position] === 0xFF && dataSet.byteArray[position + 1] === 0xD9;
}

function isFragmentEndOfImage(dataSet, pixelDataElement, fragmentIndex) {
  var fragment = pixelDataElement.fragments[fragmentIndex]; // Need to check the last two bytes and the last three bytes for marker since odd length
  // fragments are zero padded

  if (isEndOfImageMarker(dataSet, fragment.position + fragment.length - 2) || isEndOfImageMarker(dataSet, fragment.position + fragment.length - 3)) {
    return true;
  }

  return false;
}

function findLastImageFrameFragmentIndex(dataSet, pixelDataElement, startFragment) {
  for (var fragmentIndex = startFragment; fragmentIndex < pixelDataElement.fragments.length; fragmentIndex++) {
    if (isFragmentEndOfImage(dataSet, pixelDataElement, fragmentIndex)) {
      return fragmentIndex;
    }
  }
}
/**
 * Creates a basic offset table by scanning fragments for JPEG start of image and end Of Image markers
 * @param {object} dataSet - the parsed dicom dataset
 * @param {object} pixelDataElement - the pixel data element
 * @param [fragments] - optional array of objects describing each fragment (offset, position, length)
 * @returns {Array} basic offset table (array of offsets to beginning of each frame)
 */


function createJPEGBasicOffsetTable(dataSet, pixelDataElement, fragments) {
  // Validate parameters
  if (dataSet === undefined) {
    throw 'dicomParser.createJPEGBasicOffsetTable: missing required parameter dataSet';
  }

  if (pixelDataElement === undefined) {
    throw 'dicomParser.createJPEGBasicOffsetTable: missing required parameter pixelDataElement';
  }

  if (pixelDataElement.tag !== 'x7fe00010') {
    throw 'dicomParser.createJPEGBasicOffsetTable: parameter \'pixelDataElement\' refers to non pixel data tag (expected tag = x7fe00010\'';
  }

  if (pixelDataElement.encapsulatedPixelData !== true) {
    throw 'dicomParser.createJPEGBasicOffsetTable: parameter \'pixelDataElement\' refers to pixel data element that does not have encapsulated pixel data';
  }

  if (pixelDataElement.hadUndefinedLength !== true) {
    throw 'dicomParser.createJPEGBasicOffsetTable: parameter \'pixelDataElement\' refers to pixel data element that does not have encapsulated pixel data';
  }

  if (pixelDataElement.basicOffsetTable === undefined) {
    throw 'dicomParser.createJPEGBasicOffsetTable: parameter \'pixelDataElement\' refers to pixel data element that does not have encapsulated pixel data';
  }

  if (pixelDataElement.fragments === undefined) {
    throw 'dicomParser.createJPEGBasicOffsetTable: parameter \'pixelDataElement\' refers to pixel data element that does not have encapsulated pixel data';
  }

  if (pixelDataElement.fragments.length <= 0) {
    throw 'dicomParser.createJPEGBasicOffsetTable: parameter \'pixelDataElement\' refers to pixel data element that does not have encapsulated pixel data';
  }

  if (fragments && fragments.length <= 0) {
    throw 'dicomParser.createJPEGBasicOffsetTable: parameter \'fragments\' must not be zero length';
  } // Default values


  fragments = fragments || pixelDataElement.fragments;
  var basicOffsetTable = [];
  var startFragmentIndex = 0;

  while (true) {
    // Add the offset for the start fragment
    basicOffsetTable.push(pixelDataElement.fragments[startFragmentIndex].offset);
    var endFragmentIndex = findLastImageFrameFragmentIndex(dataSet, pixelDataElement, startFragmentIndex);

    if (endFragmentIndex === undefined || endFragmentIndex === pixelDataElement.fragments.length - 1) {
      return basicOffsetTable;
    }

    startFragmentIndex = endFragmentIndex + 1;
  }
}

/***/ }),

/***/ "./util/dataSetToJS.js":
/*!*****************************!*\
  !*** ./util/dataSetToJS.js ***!
  \*****************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return explicitDataSetToJS; });
/* harmony import */ var _elementToString_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./elementToString.js */ "./util/elementToString.js");
/* harmony import */ var _util_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./util.js */ "./util/util.js");


/**
 * converts an explicit dataSet to a javascript object
 * @param dataSet
 * @param options
 */

function explicitDataSetToJS(dataSet, options) {
  if (dataSet === undefined) {
    throw 'dicomParser.explicitDataSetToJS: missing required parameter dataSet';
  }

  options = options || {
    omitPrivateAttibutes: true,
    // true if private elements should be omitted
    maxElementLength: 128 // maximum element length to try and convert to string format

  };
  var result = {};

  for (var tag in dataSet.elements) {
    var element = dataSet.elements[tag]; // skip this element if it a private element and our options specify that we should

    if (options.omitPrivateAttibutes === true && _util_js__WEBPACK_IMPORTED_MODULE_1__["isPrivateTag"](tag)) {
      continue;
    }

    if (element.items) {
      // handle sequences
      var sequenceItems = [];

      for (var i = 0; i < element.items.length; i++) {
        sequenceItems.push(explicitDataSetToJS(element.items[i].dataSet, options));
      }

      result[tag] = sequenceItems;
    } else {
      var asString;
      asString = undefined;

      if (element.length < options.maxElementLength) {
        asString = Object(_elementToString_js__WEBPACK_IMPORTED_MODULE_0__["default"])(dataSet, element);
      }

      if (asString !== undefined) {
        result[tag] = asString;
      } else {
        result[tag] = {
          dataOffset: element.dataOffset,
          length: element.length
        };
      }
    }
  }

  return result;
}

/***/ }),

/***/ "./util/elementToString.js":
/*!*********************************!*\
  !*** ./util/elementToString.js ***!
  \*********************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return explicitElementToString; });
/* harmony import */ var _util_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./util.js */ "./util/util.js");

/**
 * Converts an explicit VR element to a string or undefined if it is not possible to convert.
 * Throws an error if an implicit element is supplied
 * @param dataSet
 * @param element
 * @returns {*}
 */

function explicitElementToString(dataSet, element) {
  if (dataSet === undefined || element === undefined) {
    throw 'dicomParser.explicitElementToString: missing required parameters';
  }

  if (element.vr === undefined) {
    throw 'dicomParser.explicitElementToString: cannot convert implicit element to string';
  }

  var vr = element.vr;
  var tag = element.tag;
  var textResult;

  function multiElementToString(numItems, func) {
    var result = '';

    for (var i = 0; i < numItems; i++) {
      if (i !== 0) {
        result += '/';
      }

      result += func.call(dataSet, tag, i).toString();
    }

    return result;
  }

  if (_util_js__WEBPACK_IMPORTED_MODULE_0__["isStringVr"](vr) === true) {
    textResult = dataSet.string(tag);
  } else if (vr === 'AT') {
    var num = dataSet.uint32(tag);

    if (num === undefined) {
      return undefined;
    }

    if (num < 0) {
      num = 0xFFFFFFFF + num + 1;
    }

    return "x".concat(num.toString(16).toUpperCase());
  } else if (vr === 'US') {
    textResult = multiElementToString(element.length / 2, dataSet.uint16);
  } else if (vr === 'SS') {
    textResult = multiElementToString(element.length / 2, dataSet.int16);
  } else if (vr === 'UL') {
    textResult = multiElementToString(element.length / 4, dataSet.uint32);
  } else if (vr === 'SL') {
    textResult = multiElementToString(element.length / 4, dataSet.int32);
  } else if (vr === 'FD') {
    textResult = multiElementToString(element.length / 8, dataSet["double"]);
  } else if (vr === 'FL') {
    textResult = multiElementToString(element.length / 4, dataSet["float"]);
  }

  return textResult;
}

/***/ }),

/***/ "./util/index.js":
/*!***********************!*\
  !*** ./util/index.js ***!
  \***********************/
/*! exports provided: isStringVr, isPrivateTag, parsePN, parseTM, parseDA, explicitElementToString, explicitDataSetToJS, createJPEGBasicOffsetTable */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _util_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./util.js */ "./util/util.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "isStringVr", function() { return _util_js__WEBPACK_IMPORTED_MODULE_0__["isStringVr"]; });

/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "isPrivateTag", function() { return _util_js__WEBPACK_IMPORTED_MODULE_0__["isPrivateTag"]; });

/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "parsePN", function() { return _util_js__WEBPACK_IMPORTED_MODULE_0__["parsePN"]; });

/* harmony import */ var _parseTM_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./parseTM.js */ "./util/parseTM.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "parseTM", function() { return _parseTM_js__WEBPACK_IMPORTED_MODULE_1__["default"]; });

/* harmony import */ var _parseDA_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./parseDA.js */ "./util/parseDA.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "parseDA", function() { return _parseDA_js__WEBPACK_IMPORTED_MODULE_2__["default"]; });

/* harmony import */ var _elementToString_js__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ./elementToString.js */ "./util/elementToString.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "explicitElementToString", function() { return _elementToString_js__WEBPACK_IMPORTED_MODULE_3__["default"]; });

/* harmony import */ var _dataSetToJS_js__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! ./dataSetToJS.js */ "./util/dataSetToJS.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "explicitDataSetToJS", function() { return _dataSetToJS_js__WEBPACK_IMPORTED_MODULE_4__["default"]; });

/* harmony import */ var _createJPEGBasicOffsetTable_js__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(/*! ./createJPEGBasicOffsetTable.js */ "./util/createJPEGBasicOffsetTable.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "createJPEGBasicOffsetTable", function() { return _createJPEGBasicOffsetTable_js__WEBPACK_IMPORTED_MODULE_5__["default"]; });









/***/ }),

/***/ "./util/parseDA.js":
/*!*************************!*\
  !*** ./util/parseDA.js ***!
  \*************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return parseDA; });
// algorithm based on http://stackoverflow.com/questions/1433030/validate-number-of-days-in-a-given-month
function daysInMonth(m, y) {
  // m is 0 indexed: 0-11
  switch (m) {
    case 2:
      return y % 4 == 0 && y % 100 || y % 400 == 0 ? 29 : 28;

    case 9:
    case 4:
    case 6:
    case 11:
      return 30;

    default:
      return 31;
  }
}

function isValidDate(d, m, y) {
  // make year is a number
  if (isNaN(y)) {
    return false;
  }

  return m > 0 && m <= 12 && d > 0 && d <= daysInMonth(m, y);
}
/**
 * Parses a DA formatted string into a Javascript object
 * @param {string} date a string in the DA VR format
 * @param {boolean} [validate] - true if an exception should be thrown if the date is invalid
 * @returns {*} Javascript object with properties year, month and day or undefined if not present or not 8 bytes long
 */


function parseDA(date, validate) {
  if (date && date.length === 8) {
    var yyyy = parseInt(date.substring(0, 4), 10);
    var mm = parseInt(date.substring(4, 6), 10);
    var dd = parseInt(date.substring(6, 8), 10);

    if (validate) {
      if (isValidDate(dd, mm, yyyy) !== true) {
        throw "invalid DA '".concat(date, "'");
      }
    }

    return {
      year: yyyy,
      month: mm,
      day: dd
    };
  }

  if (validate) {
    throw "invalid DA '".concat(date, "'");
  }

  return undefined;
}

/***/ }),

/***/ "./util/parseTM.js":
/*!*************************!*\
  !*** ./util/parseTM.js ***!
  \*************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return parseTM; });
/**
 * Parses a TM formatted string into a javascript object with properties for hours, minutes, seconds and fractionalSeconds
 * @param {string} time - a string in the TM VR format
 * @param {boolean} [validate] - true if an exception should be thrown if the date is invalid
 * @returns {*} javascript object with properties for hours, minutes, seconds and fractionalSeconds or undefined if no element or data.  Missing fields are set to undefined
 */
function parseTM(time, validate) {
  if (time.length >= 2) {
    // must at least have HH
    // 0123456789
    // HHMMSS.FFFFFF
    var hh = parseInt(time.substring(0, 2), 10);
    var mm = time.length >= 4 ? parseInt(time.substring(2, 4), 10) : undefined;
    var ss = time.length >= 6 ? parseInt(time.substring(4, 6), 10) : undefined;
    var fractionalStr = time.length >= 8 ? time.substring(7, 13) : undefined;
    var ffffff = fractionalStr ? parseInt(fractionalStr, 10) * Math.pow(10, 6 - fractionalStr.length) : undefined;

    if (validate) {
      if (isNaN(hh) || mm !== undefined && isNaN(mm) || ss !== undefined && isNaN(ss) || ffffff !== undefined && isNaN(ffffff) || hh < 0 || hh > 23 || mm && (mm < 0 || mm > 59) || ss && (ss < 0 || ss > 59) || ffffff && (ffffff < 0 || ffffff > 999999)) {
        throw "invalid TM '".concat(time, "'");
      }
    }

    return {
      hours: hh,
      minutes: mm,
      seconds: ss,
      fractionalSeconds: ffffff
    };
  }

  if (validate) {
    throw "invalid TM '".concat(time, "'");
  }

  return undefined;
}

/***/ }),

/***/ "./util/util.js":
/*!**********************!*\
  !*** ./util/util.js ***!
  \**********************/
/*! exports provided: isStringVr, isPrivateTag, parsePN */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "isStringVr", function() { return isStringVr; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "isPrivateTag", function() { return isPrivateTag; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "parsePN", function() { return parsePN; });
var stringVrs = {
  AE: true,
  AS: true,
  AT: false,
  CS: true,
  DA: true,
  DS: true,
  DT: true,
  FL: false,
  FD: false,
  IS: true,
  LO: true,
  LT: true,
  OB: false,
  OD: false,
  OF: false,
  OW: false,
  PN: true,
  SH: true,
  SL: false,
  SQ: false,
  SS: false,
  ST: true,
  TM: true,
  UI: true,
  UL: false,
  UN: undefined,
  // dunno
  UR: true,
  US: false,
  UT: true
};
/**
 * Tests to see if vr is a string or not.
 * @param vr
 * @returns true if string, false it not string, undefined if unknown vr or UN type
 */

var isStringVr = function isStringVr(vr) {
  return stringVrs[vr];
};
/**
 * Tests to see if a given tag in the format xggggeeee is a private tag or not
 * @param tag
 * @returns {boolean}
 * @throws error if fourth character cannot be parsed
 */


var isPrivateTag = function isPrivateTag(tag) {
  var lastGroupDigit = parseInt(tag[4], 16);

  if (isNaN(lastGroupDigit)) {
    throw 'dicomParser.isPrivateTag: cannot parse last character of group';
  }

  var groupIsOdd = lastGroupDigit % 2 === 1;
  return groupIsOdd;
};
/**
 * Parses a PN formatted string into a javascript object with properties for givenName, familyName, middleName, prefix and suffix
 * @param personName a string in the PN VR format
 * @param index
 * @returns {*} javascript object with properties for givenName, familyName, middleName, prefix and suffix or undefined if no element or data
 */


var parsePN = function parsePN(personName) {
  if (personName === undefined) {
    return undefined;
  }

  var stringValues = personName.split('^');
  return {
    familyName: stringValues[0],
    givenName: stringValues[1],
    middleName: stringValues[2],
    prefix: stringValues[3],
    suffix: stringValues[4]
  };
};



/***/ }),

/***/ "./version.js":
/*!********************!*\
  !*** ./version.js ***!
  \********************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony default export */ __webpack_exports__["default"] = ('1.8.12');

/***/ }),

/***/ "zlib":
/*!***********************!*\
  !*** external "zlib" ***!
  \***********************/
/*! no static exports found */
/***/ (function(module, exports) {

module.exports = __WEBPACK_EXTERNAL_MODULE_zlib__;

/***/ })

/******/ });
});
//# sourceMappingURL=dicomParser.js.map