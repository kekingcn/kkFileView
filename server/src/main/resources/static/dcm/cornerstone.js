/*! cornerstone-core - 2.2.8 - 2018-12-05 | (c) 2016 Chris Hafey | https://github.com/cornerstonejs/cornerstone */
(function webpackUniversalModuleDefinition(root, factory) {
	if(typeof exports === 'object' && typeof module === 'object')
		module.exports = factory();
	else if(typeof define === 'function' && define.amd)
		define("cornerstone-core", [], factory);
	else if(typeof exports === 'object')
		exports["cornerstone-core"] = factory();
	else
		root["cornerstone"] = factory();
})(window, function() {
return /******/ (function(modules) { // webpackBootstrap
/******/ 	function hotDisposeChunk(chunkId) {
/******/ 		delete installedChunks[chunkId];
/******/ 	}
/******/ 	var parentHotUpdateCallback = window["webpackHotUpdate"];
/******/ 	window["webpackHotUpdate"] = // eslint-disable-next-line no-unused-vars
/******/ 	function webpackHotUpdateCallback(chunkId, moreModules) {
/******/ 		hotAddUpdateChunk(chunkId, moreModules);
/******/ 		if (parentHotUpdateCallback) parentHotUpdateCallback(chunkId, moreModules);
/******/ 	} ;
/******/
/******/ 	// eslint-disable-next-line no-unused-vars
/******/ 	function hotDownloadUpdateChunk(chunkId) {
/******/ 		var head = document.getElementsByTagName("head")[0];
/******/ 		var script = document.createElement("script");
/******/ 		script.charset = "utf-8";
/******/ 		script.src = __webpack_require__.p + "" + chunkId + "." + hotCurrentHash + ".hot-update.js";
/******/ 		;
/******/ 		head.appendChild(script);
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
/******/ 	var hotCurrentHash = "72ed982d5a0046aad5fa";
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
/******/ 	var hotUpdate, hotUpdateNewHash;
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
/******/ 				hotSetStatus("idle");
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
/******/ 			var chunkId = "cornerstone";
/******/ 			// eslint-disable-next-line no-lone-blocks
/******/ 			{
/******/ 				/*globals chunkId */
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
/******/ 			var queue = outdatedModules.slice().map(function(id) {
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
/******/ 				if (!module || module.hot._selfAccepted) continue;
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
/******/ 				installedModules[moduleId].hot._selfAccepted
/******/ 			)
/******/ 				outdatedSelfAcceptedModules.push({
/******/ 					module: moduleId,
/******/ 					errorHandler: installedModules[moduleId].hot._selfAccepted
/******/ 				});
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
/******/ 		// Not in "apply" phase
/******/ 		hotSetStatus("apply");
/******/
/******/ 		hotCurrentHash = hotUpdateNewHash;
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
/******/ 			hotCurrentParents = [moduleId];
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
/******/ 		hotSetStatus("idle");
/******/ 		return new Promise(function(resolve) {
/******/ 			resolve(outdatedModules);
/******/ 		});
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

/***/ "./canvasToPixel.js":
/*!**************************!*\
  !*** ./canvasToPixel.js ***!
  \**************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _enabledElements_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./enabledElements.js */ "./enabledElements.js");
/* harmony import */ var _internal_getTransform_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./internal/getTransform.js */ "./internal/getTransform.js");


/**
 * Converts a point in the canvas coordinate system to the pixel coordinate system
 * system.  This can be used to reset tools' image coordinates after modifications
 * have been made in canvas space (e.g. moving a tool by a few cm, independent of
 * image resolution).
 *
 * @param {HTMLElement} element The Cornerstone element within which the input point lies
 * @param {{x: Number, y: Number}} pt The input point in the canvas coordinate system
 *
 * @returns {{x: Number, y: Number}} The transformed point in the pixel coordinate system
 * @memberof PixelCoordinateSystem
 */

/* harmony default export */ __webpack_exports__["default"] = (function (element, pt) {
  var enabledElement = Object(_enabledElements_js__WEBPACK_IMPORTED_MODULE_0__["getEnabledElement"])(element);
  var transform = Object(_internal_getTransform_js__WEBPACK_IMPORTED_MODULE_1__["default"])(enabledElement);
  transform.invert();
  return transform.transformPoint(pt.x, pt.y);
});

/***/ }),

/***/ "./colors/colormap.js":
/*!****************************!*\
  !*** ./colors/colormap.js ***!
  \****************************/
/*! exports provided: getColormapsList, getColormap */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "getColormapsList", function() { return getColormapsList; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "getColormap", function() { return getColormap; });
/* harmony import */ var _lookupTable_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./lookupTable.js */ "./colors/lookupTable.js");

var COLOR_TRANSPARENT = [0, 0, 0, 0]; // Colormaps
//
// Hot Iron, PET, Hot Metal Blue and PET 20 Step are color palettes
// Defined by the DICOM standard
// http://dicom.nema.org/dicom/2013/output/chtml/part06/chapter_B.html
//
// All Linear Segmented Colormaps were copied from matplotlib
// https://github.com/stefanv/matplotlib/blob/master/lib/matplotlib/_cm.py

var colormapsData = {
  hotIron: {
    name: 'Hot Iron',
    numOfColors: 256,
    colors: [[0, 0, 0, 255], [2, 0, 0, 255], [4, 0, 0, 255], [6, 0, 0, 255], [8, 0, 0, 255], [10, 0, 0, 255], [12, 0, 0, 255], [14, 0, 0, 255], [16, 0, 0, 255], [18, 0, 0, 255], [20, 0, 0, 255], [22, 0, 0, 255], [24, 0, 0, 255], [26, 0, 0, 255], [28, 0, 0, 255], [30, 0, 0, 255], [32, 0, 0, 255], [34, 0, 0, 255], [36, 0, 0, 255], [38, 0, 0, 255], [40, 0, 0, 255], [42, 0, 0, 255], [44, 0, 0, 255], [46, 0, 0, 255], [48, 0, 0, 255], [50, 0, 0, 255], [52, 0, 0, 255], [54, 0, 0, 255], [56, 0, 0, 255], [58, 0, 0, 255], [60, 0, 0, 255], [62, 0, 0, 255], [64, 0, 0, 255], [66, 0, 0, 255], [68, 0, 0, 255], [70, 0, 0, 255], [72, 0, 0, 255], [74, 0, 0, 255], [76, 0, 0, 255], [78, 0, 0, 255], [80, 0, 0, 255], [82, 0, 0, 255], [84, 0, 0, 255], [86, 0, 0, 255], [88, 0, 0, 255], [90, 0, 0, 255], [92, 0, 0, 255], [94, 0, 0, 255], [96, 0, 0, 255], [98, 0, 0, 255], [100, 0, 0, 255], [102, 0, 0, 255], [104, 0, 0, 255], [106, 0, 0, 255], [108, 0, 0, 255], [110, 0, 0, 255], [112, 0, 0, 255], [114, 0, 0, 255], [116, 0, 0, 255], [118, 0, 0, 255], [120, 0, 0, 255], [122, 0, 0, 255], [124, 0, 0, 255], [126, 0, 0, 255], [128, 0, 0, 255], [130, 0, 0, 255], [132, 0, 0, 255], [134, 0, 0, 255], [136, 0, 0, 255], [138, 0, 0, 255], [140, 0, 0, 255], [142, 0, 0, 255], [144, 0, 0, 255], [146, 0, 0, 255], [148, 0, 0, 255], [150, 0, 0, 255], [152, 0, 0, 255], [154, 0, 0, 255], [156, 0, 0, 255], [158, 0, 0, 255], [160, 0, 0, 255], [162, 0, 0, 255], [164, 0, 0, 255], [166, 0, 0, 255], [168, 0, 0, 255], [170, 0, 0, 255], [172, 0, 0, 255], [174, 0, 0, 255], [176, 0, 0, 255], [178, 0, 0, 255], [180, 0, 0, 255], [182, 0, 0, 255], [184, 0, 0, 255], [186, 0, 0, 255], [188, 0, 0, 255], [190, 0, 0, 255], [192, 0, 0, 255], [194, 0, 0, 255], [196, 0, 0, 255], [198, 0, 0, 255], [200, 0, 0, 255], [202, 0, 0, 255], [204, 0, 0, 255], [206, 0, 0, 255], [208, 0, 0, 255], [210, 0, 0, 255], [212, 0, 0, 255], [214, 0, 0, 255], [216, 0, 0, 255], [218, 0, 0, 255], [220, 0, 0, 255], [222, 0, 0, 255], [224, 0, 0, 255], [226, 0, 0, 255], [228, 0, 0, 255], [230, 0, 0, 255], [232, 0, 0, 255], [234, 0, 0, 255], [236, 0, 0, 255], [238, 0, 0, 255], [240, 0, 0, 255], [242, 0, 0, 255], [244, 0, 0, 255], [246, 0, 0, 255], [248, 0, 0, 255], [250, 0, 0, 255], [252, 0, 0, 255], [254, 0, 0, 255], [255, 0, 0, 255], [255, 2, 0, 255], [255, 4, 0, 255], [255, 6, 0, 255], [255, 8, 0, 255], [255, 10, 0, 255], [255, 12, 0, 255], [255, 14, 0, 255], [255, 16, 0, 255], [255, 18, 0, 255], [255, 20, 0, 255], [255, 22, 0, 255], [255, 24, 0, 255], [255, 26, 0, 255], [255, 28, 0, 255], [255, 30, 0, 255], [255, 32, 0, 255], [255, 34, 0, 255], [255, 36, 0, 255], [255, 38, 0, 255], [255, 40, 0, 255], [255, 42, 0, 255], [255, 44, 0, 255], [255, 46, 0, 255], [255, 48, 0, 255], [255, 50, 0, 255], [255, 52, 0, 255], [255, 54, 0, 255], [255, 56, 0, 255], [255, 58, 0, 255], [255, 60, 0, 255], [255, 62, 0, 255], [255, 64, 0, 255], [255, 66, 0, 255], [255, 68, 0, 255], [255, 70, 0, 255], [255, 72, 0, 255], [255, 74, 0, 255], [255, 76, 0, 255], [255, 78, 0, 255], [255, 80, 0, 255], [255, 82, 0, 255], [255, 84, 0, 255], [255, 86, 0, 255], [255, 88, 0, 255], [255, 90, 0, 255], [255, 92, 0, 255], [255, 94, 0, 255], [255, 96, 0, 255], [255, 98, 0, 255], [255, 100, 0, 255], [255, 102, 0, 255], [255, 104, 0, 255], [255, 106, 0, 255], [255, 108, 0, 255], [255, 110, 0, 255], [255, 112, 0, 255], [255, 114, 0, 255], [255, 116, 0, 255], [255, 118, 0, 255], [255, 120, 0, 255], [255, 122, 0, 255], [255, 124, 0, 255], [255, 126, 0, 255], [255, 128, 4, 255], [255, 130, 8, 255], [255, 132, 12, 255], [255, 134, 16, 255], [255, 136, 20, 255], [255, 138, 24, 255], [255, 140, 28, 255], [255, 142, 32, 255], [255, 144, 36, 255], [255, 146, 40, 255], [255, 148, 44, 255], [255, 150, 48, 255], [255, 152, 52, 255], [255, 154, 56, 255], [255, 156, 60, 255], [255, 158, 64, 255], [255, 160, 68, 255], [255, 162, 72, 255], [255, 164, 76, 255], [255, 166, 80, 255], [255, 168, 84, 255], [255, 170, 88, 255], [255, 172, 92, 255], [255, 174, 96, 255], [255, 176, 100, 255], [255, 178, 104, 255], [255, 180, 108, 255], [255, 182, 112, 255], [255, 184, 116, 255], [255, 186, 120, 255], [255, 188, 124, 255], [255, 190, 128, 255], [255, 192, 132, 255], [255, 194, 136, 255], [255, 196, 140, 255], [255, 198, 144, 255], [255, 200, 148, 255], [255, 202, 152, 255], [255, 204, 156, 255], [255, 206, 160, 255], [255, 208, 164, 255], [255, 210, 168, 255], [255, 212, 172, 255], [255, 214, 176, 255], [255, 216, 180, 255], [255, 218, 184, 255], [255, 220, 188, 255], [255, 222, 192, 255], [255, 224, 196, 255], [255, 226, 200, 255], [255, 228, 204, 255], [255, 230, 208, 255], [255, 232, 212, 255], [255, 234, 216, 255], [255, 236, 220, 255], [255, 238, 224, 255], [255, 240, 228, 255], [255, 242, 232, 255], [255, 244, 236, 255], [255, 246, 240, 255], [255, 248, 244, 255], [255, 250, 248, 255], [255, 252, 252, 255], [255, 255, 255, 255]]
  },
  pet: {
    name: 'PET',
    numColors: 256,
    colors: [[0, 0, 0, 255], [0, 2, 1, 255], [0, 4, 3, 255], [0, 6, 5, 255], [0, 8, 7, 255], [0, 10, 9, 255], [0, 12, 11, 255], [0, 14, 13, 255], [0, 16, 15, 255], [0, 18, 17, 255], [0, 20, 19, 255], [0, 22, 21, 255], [0, 24, 23, 255], [0, 26, 25, 255], [0, 28, 27, 255], [0, 30, 29, 255], [0, 32, 31, 255], [0, 34, 33, 255], [0, 36, 35, 255], [0, 38, 37, 255], [0, 40, 39, 255], [0, 42, 41, 255], [0, 44, 43, 255], [0, 46, 45, 255], [0, 48, 47, 255], [0, 50, 49, 255], [0, 52, 51, 255], [0, 54, 53, 255], [0, 56, 55, 255], [0, 58, 57, 255], [0, 60, 59, 255], [0, 62, 61, 255], [0, 65, 63, 255], [0, 67, 65, 255], [0, 69, 67, 255], [0, 71, 69, 255], [0, 73, 71, 255], [0, 75, 73, 255], [0, 77, 75, 255], [0, 79, 77, 255], [0, 81, 79, 255], [0, 83, 81, 255], [0, 85, 83, 255], [0, 87, 85, 255], [0, 89, 87, 255], [0, 91, 89, 255], [0, 93, 91, 255], [0, 95, 93, 255], [0, 97, 95, 255], [0, 99, 97, 255], [0, 101, 99, 255], [0, 103, 101, 255], [0, 105, 103, 255], [0, 107, 105, 255], [0, 109, 107, 255], [0, 111, 109, 255], [0, 113, 111, 255], [0, 115, 113, 255], [0, 117, 115, 255], [0, 119, 117, 255], [0, 121, 119, 255], [0, 123, 121, 255], [0, 125, 123, 255], [0, 128, 125, 255], [1, 126, 127, 255], [3, 124, 129, 255], [5, 122, 131, 255], [7, 120, 133, 255], [9, 118, 135, 255], [11, 116, 137, 255], [13, 114, 139, 255], [15, 112, 141, 255], [17, 110, 143, 255], [19, 108, 145, 255], [21, 106, 147, 255], [23, 104, 149, 255], [25, 102, 151, 255], [27, 100, 153, 255], [29, 98, 155, 255], [31, 96, 157, 255], [33, 94, 159, 255], [35, 92, 161, 255], [37, 90, 163, 255], [39, 88, 165, 255], [41, 86, 167, 255], [43, 84, 169, 255], [45, 82, 171, 255], [47, 80, 173, 255], [49, 78, 175, 255], [51, 76, 177, 255], [53, 74, 179, 255], [55, 72, 181, 255], [57, 70, 183, 255], [59, 68, 185, 255], [61, 66, 187, 255], [63, 64, 189, 255], [65, 63, 191, 255], [67, 61, 193, 255], [69, 59, 195, 255], [71, 57, 197, 255], [73, 55, 199, 255], [75, 53, 201, 255], [77, 51, 203, 255], [79, 49, 205, 255], [81, 47, 207, 255], [83, 45, 209, 255], [85, 43, 211, 255], [86, 41, 213, 255], [88, 39, 215, 255], [90, 37, 217, 255], [92, 35, 219, 255], [94, 33, 221, 255], [96, 31, 223, 255], [98, 29, 225, 255], [100, 27, 227, 255], [102, 25, 229, 255], [104, 23, 231, 255], [106, 21, 233, 255], [108, 19, 235, 255], [110, 17, 237, 255], [112, 15, 239, 255], [114, 13, 241, 255], [116, 11, 243, 255], [118, 9, 245, 255], [120, 7, 247, 255], [122, 5, 249, 255], [124, 3, 251, 255], [126, 1, 253, 255], [128, 0, 255, 255], [130, 2, 252, 255], [132, 4, 248, 255], [134, 6, 244, 255], [136, 8, 240, 255], [138, 10, 236, 255], [140, 12, 232, 255], [142, 14, 228, 255], [144, 16, 224, 255], [146, 18, 220, 255], [148, 20, 216, 255], [150, 22, 212, 255], [152, 24, 208, 255], [154, 26, 204, 255], [156, 28, 200, 255], [158, 30, 196, 255], [160, 32, 192, 255], [162, 34, 188, 255], [164, 36, 184, 255], [166, 38, 180, 255], [168, 40, 176, 255], [170, 42, 172, 255], [171, 44, 168, 255], [173, 46, 164, 255], [175, 48, 160, 255], [177, 50, 156, 255], [179, 52, 152, 255], [181, 54, 148, 255], [183, 56, 144, 255], [185, 58, 140, 255], [187, 60, 136, 255], [189, 62, 132, 255], [191, 64, 128, 255], [193, 66, 124, 255], [195, 68, 120, 255], [197, 70, 116, 255], [199, 72, 112, 255], [201, 74, 108, 255], [203, 76, 104, 255], [205, 78, 100, 255], [207, 80, 96, 255], [209, 82, 92, 255], [211, 84, 88, 255], [213, 86, 84, 255], [215, 88, 80, 255], [217, 90, 76, 255], [219, 92, 72, 255], [221, 94, 68, 255], [223, 96, 64, 255], [225, 98, 60, 255], [227, 100, 56, 255], [229, 102, 52, 255], [231, 104, 48, 255], [233, 106, 44, 255], [235, 108, 40, 255], [237, 110, 36, 255], [239, 112, 32, 255], [241, 114, 28, 255], [243, 116, 24, 255], [245, 118, 20, 255], [247, 120, 16, 255], [249, 122, 12, 255], [251, 124, 8, 255], [253, 126, 4, 255], [255, 128, 0, 255], [255, 130, 4, 255], [255, 132, 8, 255], [255, 134, 12, 255], [255, 136, 16, 255], [255, 138, 20, 255], [255, 140, 24, 255], [255, 142, 28, 255], [255, 144, 32, 255], [255, 146, 36, 255], [255, 148, 40, 255], [255, 150, 44, 255], [255, 152, 48, 255], [255, 154, 52, 255], [255, 156, 56, 255], [255, 158, 60, 255], [255, 160, 64, 255], [255, 162, 68, 255], [255, 164, 72, 255], [255, 166, 76, 255], [255, 168, 80, 255], [255, 170, 85, 255], [255, 172, 89, 255], [255, 174, 93, 255], [255, 176, 97, 255], [255, 178, 101, 255], [255, 180, 105, 255], [255, 182, 109, 255], [255, 184, 113, 255], [255, 186, 117, 255], [255, 188, 121, 255], [255, 190, 125, 255], [255, 192, 129, 255], [255, 194, 133, 255], [255, 196, 137, 255], [255, 198, 141, 255], [255, 200, 145, 255], [255, 202, 149, 255], [255, 204, 153, 255], [255, 206, 157, 255], [255, 208, 161, 255], [255, 210, 165, 255], [255, 212, 170, 255], [255, 214, 174, 255], [255, 216, 178, 255], [255, 218, 182, 255], [255, 220, 186, 255], [255, 222, 190, 255], [255, 224, 194, 255], [255, 226, 198, 255], [255, 228, 202, 255], [255, 230, 206, 255], [255, 232, 210, 255], [255, 234, 214, 255], [255, 236, 218, 255], [255, 238, 222, 255], [255, 240, 226, 255], [255, 242, 230, 255], [255, 244, 234, 255], [255, 246, 238, 255], [255, 248, 242, 255], [255, 250, 246, 255], [255, 252, 250, 255], [255, 255, 255, 255]]
  },
  hotMetalBlue: {
    name: 'Hot Metal Blue',
    numColors: 256,
    colors: [[0, 0, 0, 255], [0, 0, 2, 255], [0, 0, 4, 255], [0, 0, 6, 255], [0, 0, 8, 255], [0, 0, 10, 255], [0, 0, 12, 255], [0, 0, 14, 255], [0, 0, 16, 255], [0, 0, 17, 255], [0, 0, 19, 255], [0, 0, 21, 255], [0, 0, 23, 255], [0, 0, 25, 255], [0, 0, 27, 255], [0, 0, 29, 255], [0, 0, 31, 255], [0, 0, 33, 255], [0, 0, 35, 255], [0, 0, 37, 255], [0, 0, 39, 255], [0, 0, 41, 255], [0, 0, 43, 255], [0, 0, 45, 255], [0, 0, 47, 255], [0, 0, 49, 255], [0, 0, 51, 255], [0, 0, 53, 255], [0, 0, 55, 255], [0, 0, 57, 255], [0, 0, 59, 255], [0, 0, 61, 255], [0, 0, 63, 255], [0, 0, 65, 255], [0, 0, 67, 255], [0, 0, 69, 255], [0, 0, 71, 255], [0, 0, 73, 255], [0, 0, 75, 255], [0, 0, 77, 255], [0, 0, 79, 255], [0, 0, 81, 255], [0, 0, 83, 255], [0, 0, 84, 255], [0, 0, 86, 255], [0, 0, 88, 255], [0, 0, 90, 255], [0, 0, 92, 255], [0, 0, 94, 255], [0, 0, 96, 255], [0, 0, 98, 255], [0, 0, 100, 255], [0, 0, 102, 255], [0, 0, 104, 255], [0, 0, 106, 255], [0, 0, 108, 255], [0, 0, 110, 255], [0, 0, 112, 255], [0, 0, 114, 255], [0, 0, 116, 255], [0, 0, 117, 255], [0, 0, 119, 255], [0, 0, 121, 255], [0, 0, 123, 255], [0, 0, 125, 255], [0, 0, 127, 255], [0, 0, 129, 255], [0, 0, 131, 255], [0, 0, 133, 255], [0, 0, 135, 255], [0, 0, 137, 255], [0, 0, 139, 255], [0, 0, 141, 255], [0, 0, 143, 255], [0, 0, 145, 255], [0, 0, 147, 255], [0, 0, 149, 255], [0, 0, 151, 255], [0, 0, 153, 255], [0, 0, 155, 255], [0, 0, 157, 255], [0, 0, 159, 255], [0, 0, 161, 255], [0, 0, 163, 255], [0, 0, 165, 255], [0, 0, 167, 255], [3, 0, 169, 255], [6, 0, 171, 255], [9, 0, 173, 255], [12, 0, 175, 255], [15, 0, 177, 255], [18, 0, 179, 255], [21, 0, 181, 255], [24, 0, 183, 255], [26, 0, 184, 255], [29, 0, 186, 255], [32, 0, 188, 255], [35, 0, 190, 255], [38, 0, 192, 255], [41, 0, 194, 255], [44, 0, 196, 255], [47, 0, 198, 255], [50, 0, 200, 255], [52, 0, 197, 255], [55, 0, 194, 255], [57, 0, 191, 255], [59, 0, 188, 255], [62, 0, 185, 255], [64, 0, 182, 255], [66, 0, 179, 255], [69, 0, 176, 255], [71, 0, 174, 255], [74, 0, 171, 255], [76, 0, 168, 255], [78, 0, 165, 255], [81, 0, 162, 255], [83, 0, 159, 255], [85, 0, 156, 255], [88, 0, 153, 255], [90, 0, 150, 255], [93, 2, 144, 255], [96, 4, 138, 255], [99, 6, 132, 255], [102, 8, 126, 255], [105, 9, 121, 255], [108, 11, 115, 255], [111, 13, 109, 255], [114, 15, 103, 255], [116, 17, 97, 255], [119, 19, 91, 255], [122, 21, 85, 255], [125, 23, 79, 255], [128, 24, 74, 255], [131, 26, 68, 255], [134, 28, 62, 255], [137, 30, 56, 255], [140, 32, 50, 255], [143, 34, 47, 255], [146, 36, 44, 255], [149, 38, 41, 255], [152, 40, 38, 255], [155, 41, 35, 255], [158, 43, 32, 255], [161, 45, 29, 255], [164, 47, 26, 255], [166, 49, 24, 255], [169, 51, 21, 255], [172, 53, 18, 255], [175, 55, 15, 255], [178, 56, 12, 255], [181, 58, 9, 255], [184, 60, 6, 255], [187, 62, 3, 255], [190, 64, 0, 255], [194, 66, 0, 255], [198, 68, 0, 255], [201, 70, 0, 255], [205, 72, 0, 255], [209, 73, 0, 255], [213, 75, 0, 255], [217, 77, 0, 255], [221, 79, 0, 255], [224, 81, 0, 255], [228, 83, 0, 255], [232, 85, 0, 255], [236, 87, 0, 255], [240, 88, 0, 255], [244, 90, 0, 255], [247, 92, 0, 255], [251, 94, 0, 255], [255, 96, 0, 255], [255, 98, 3, 255], [255, 100, 6, 255], [255, 102, 9, 255], [255, 104, 12, 255], [255, 105, 15, 255], [255, 107, 18, 255], [255, 109, 21, 255], [255, 111, 24, 255], [255, 113, 26, 255], [255, 115, 29, 255], [255, 117, 32, 255], [255, 119, 35, 255], [255, 120, 38, 255], [255, 122, 41, 255], [255, 124, 44, 255], [255, 126, 47, 255], [255, 128, 50, 255], [255, 130, 53, 255], [255, 132, 56, 255], [255, 134, 59, 255], [255, 136, 62, 255], [255, 137, 65, 255], [255, 139, 68, 255], [255, 141, 71, 255], [255, 143, 74, 255], [255, 145, 76, 255], [255, 147, 79, 255], [255, 149, 82, 255], [255, 151, 85, 255], [255, 152, 88, 255], [255, 154, 91, 255], [255, 156, 94, 255], [255, 158, 97, 255], [255, 160, 100, 255], [255, 162, 103, 255], [255, 164, 106, 255], [255, 166, 109, 255], [255, 168, 112, 255], [255, 169, 115, 255], [255, 171, 118, 255], [255, 173, 121, 255], [255, 175, 124, 255], [255, 177, 126, 255], [255, 179, 129, 255], [255, 181, 132, 255], [255, 183, 135, 255], [255, 184, 138, 255], [255, 186, 141, 255], [255, 188, 144, 255], [255, 190, 147, 255], [255, 192, 150, 255], [255, 194, 153, 255], [255, 196, 156, 255], [255, 198, 159, 255], [255, 200, 162, 255], [255, 201, 165, 255], [255, 203, 168, 255], [255, 205, 171, 255], [255, 207, 174, 255], [255, 209, 176, 255], [255, 211, 179, 255], [255, 213, 182, 255], [255, 215, 185, 255], [255, 216, 188, 255], [255, 218, 191, 255], [255, 220, 194, 255], [255, 222, 197, 255], [255, 224, 200, 255], [255, 226, 203, 255], [255, 228, 206, 255], [255, 229, 210, 255], [255, 231, 213, 255], [255, 233, 216, 255], [255, 235, 219, 255], [255, 237, 223, 255], [255, 239, 226, 255], [255, 240, 229, 255], [255, 242, 232, 255], [255, 244, 236, 255], [255, 246, 239, 255], [255, 248, 242, 255], [255, 250, 245, 255], [255, 251, 249, 255], [255, 253, 252, 255], [255, 255, 255, 255]]
  },
  pet20Step: {
    name: 'PET 20 Step',
    numColors: 256,
    colors: [[0, 0, 0, 255], [0, 0, 0, 255], [0, 0, 0, 255], [0, 0, 0, 255], [0, 0, 0, 255], [0, 0, 0, 255], [0, 0, 0, 255], [0, 0, 0, 255], [0, 0, 0, 255], [0, 0, 0, 255], [0, 0, 0, 255], [0, 0, 0, 255], [0, 0, 0, 255], [96, 0, 80, 255], [96, 0, 80, 255], [96, 0, 80, 255], [96, 0, 80, 255], [96, 0, 80, 255], [96, 0, 80, 255], [96, 0, 80, 255], [96, 0, 80, 255], [96, 0, 80, 255], [96, 0, 80, 255], [96, 0, 80, 255], [96, 0, 80, 255], [96, 0, 80, 255], [48, 48, 80, 255], [48, 48, 80, 255], [48, 48, 80, 255], [48, 48, 80, 255], [48, 48, 80, 255], [48, 48, 80, 255], [48, 48, 80, 255], [48, 48, 80, 255], [48, 48, 80, 255], [48, 48, 80, 255], [48, 48, 80, 255], [48, 48, 80, 255], [48, 48, 80, 255], [48, 48, 112, 255], [48, 48, 112, 255], [48, 48, 112, 255], [48, 48, 112, 255], [48, 48, 112, 255], [48, 48, 112, 255], [48, 48, 112, 255], [48, 48, 112, 255], [48, 48, 112, 255], [48, 48, 112, 255], [48, 48, 112, 255], [48, 48, 112, 255], [80, 80, 128, 255], [80, 80, 128, 255], [80, 80, 128, 255], [80, 80, 128, 255], [80, 80, 128, 255], [80, 80, 128, 255], [80, 80, 128, 255], [80, 80, 128, 255], [80, 80, 128, 255], [80, 80, 128, 255], [80, 80, 128, 255], [80, 80, 128, 255], [80, 80, 128, 255], [96, 96, 176, 255], [96, 96, 176, 255], [96, 96, 176, 255], [96, 96, 176, 255], [96, 96, 176, 255], [96, 96, 176, 255], [96, 96, 176, 255], [96, 96, 176, 255], [96, 96, 176, 255], [96, 96, 176, 255], [96, 96, 176, 255], [96, 96, 176, 255], [96, 96, 176, 255], [112, 112, 192, 255], [112, 112, 192, 255], [112, 112, 192, 255], [112, 112, 192, 255], [112, 112, 192, 255], [112, 112, 192, 255], [112, 112, 192, 255], [112, 112, 192, 255], [112, 112, 192, 255], [112, 112, 192, 255], [112, 112, 192, 255], [112, 112, 192, 255], [112, 112, 192, 255], [128, 128, 224, 255], [128, 128, 224, 255], [128, 128, 224, 255], [128, 128, 224, 255], [128, 128, 224, 255], [128, 128, 224, 255], [128, 128, 224, 255], [128, 128, 224, 255], [128, 128, 224, 255], [128, 128, 224, 255], [128, 128, 224, 255], [128, 128, 224, 255], [48, 96, 48, 255], [48, 96, 48, 255], [48, 96, 48, 255], [48, 96, 48, 255], [48, 96, 48, 255], [48, 96, 48, 255], [48, 96, 48, 255], [48, 96, 48, 255], [48, 96, 48, 255], [48, 96, 48, 255], [48, 96, 48, 255], [48, 96, 48, 255], [48, 96, 48, 255], [48, 144, 48, 255], [48, 144, 48, 255], [48, 144, 48, 255], [48, 144, 48, 255], [48, 144, 48, 255], [48, 144, 48, 255], [48, 144, 48, 255], [48, 144, 48, 255], [48, 144, 48, 255], [48, 144, 48, 255], [48, 144, 48, 255], [48, 144, 48, 255], [48, 144, 48, 255], [80, 192, 80, 255], [80, 192, 80, 255], [80, 192, 80, 255], [80, 192, 80, 255], [80, 192, 80, 255], [80, 192, 80, 255], [80, 192, 80, 255], [80, 192, 80, 255], [80, 192, 80, 255], [80, 192, 80, 255], [80, 192, 80, 255], [80, 192, 80, 255], [80, 192, 80, 255], [64, 224, 64, 255], [64, 224, 64, 255], [64, 224, 64, 255], [64, 224, 64, 255], [64, 224, 64, 255], [64, 224, 64, 255], [64, 224, 64, 255], [64, 224, 64, 255], [64, 224, 64, 255], [64, 224, 64, 255], [64, 224, 64, 255], [64, 224, 64, 255], [224, 224, 80, 255], [224, 224, 80, 255], [224, 224, 80, 255], [224, 224, 80, 255], [224, 224, 80, 255], [224, 224, 80, 255], [224, 224, 80, 255], [224, 224, 80, 255], [224, 224, 80, 255], [224, 224, 80, 255], [224, 224, 80, 255], [224, 224, 80, 255], [224, 224, 80, 255], [208, 208, 96, 255], [208, 208, 96, 255], [208, 208, 96, 255], [208, 208, 96, 255], [208, 208, 96, 255], [208, 208, 96, 255], [208, 208, 96, 255], [208, 208, 96, 255], [208, 208, 96, 255], [208, 208, 96, 255], [208, 208, 96, 255], [208, 208, 96, 255], [208, 208, 96, 255], [208, 176, 64, 255], [208, 176, 64, 255], [208, 176, 64, 255], [208, 176, 64, 255], [208, 176, 64, 255], [208, 176, 64, 255], [208, 176, 64, 255], [208, 176, 64, 255], [208, 176, 64, 255], [208, 176, 64, 255], [208, 176, 64, 255], [208, 176, 64, 255], [208, 176, 64, 255], [208, 144, 0, 255], [208, 144, 0, 255], [208, 144, 0, 255], [208, 144, 0, 255], [208, 144, 0, 255], [208, 144, 0, 255], [208, 144, 0, 255], [208, 144, 0, 255], [208, 144, 0, 255], [208, 144, 0, 255], [208, 144, 0, 255], [208, 144, 0, 255], [192, 96, 0, 255], [192, 96, 0, 255], [192, 96, 0, 255], [192, 96, 0, 255], [192, 96, 0, 255], [192, 96, 0, 255], [192, 96, 0, 255], [192, 96, 0, 255], [192, 96, 0, 255], [192, 96, 0, 255], [192, 96, 0, 255], [192, 96, 0, 255], [192, 96, 0, 255], [176, 48, 0, 255], [176, 48, 0, 255], [176, 48, 0, 255], [176, 48, 0, 255], [176, 48, 0, 255], [176, 48, 0, 255], [176, 48, 0, 255], [176, 48, 0, 255], [176, 48, 0, 255], [176, 48, 0, 255], [176, 48, 0, 255], [176, 48, 0, 255], [176, 48, 0, 255], [255, 0, 0, 255], [255, 0, 0, 255], [255, 0, 0, 255], [255, 0, 0, 255], [255, 0, 0, 255], [255, 0, 0, 255], [255, 0, 0, 255], [255, 0, 0, 255], [255, 0, 0, 255], [255, 0, 0, 255], [255, 0, 0, 255], [255, 0, 0, 255], [255, 0, 0, 255], [255, 255, 255, 255], [255, 255, 255, 255], [255, 255, 255, 255], [255, 255, 255, 255], [255, 255, 255, 255], [255, 255, 255, 255], [255, 255, 255, 255], [255, 255, 255, 255], [255, 255, 255, 255], [255, 255, 255, 255], [255, 255, 255, 255], [255, 255, 255, 255], [255, 255, 255, 255]]
  },
  gray: {
    name: 'Gray',
    numColors: 256,
    gamma: 1,
    segmentedData: {
      red: [[0, 0, 0], [1, 1, 1]],
      green: [[0, 0, 0], [1, 1, 1]],
      blue: [[0, 0, 0], [1, 1, 1]]
    }
  },
  jet: {
    name: 'Jet',
    numColors: 256,
    gamma: 1,
    segmentedData: {
      red: [[0, 0, 0], [0.35, 0, 0], [0.66, 1, 1], [0.89, 1, 1], [1, 0.5, 0.5]],
      green: [[0, 0, 0], [0.125, 0, 0], [0.375, 1, 1], [0.64, 1, 1], [0.91, 0, 0], [1, 0, 0]],
      blue: [[0, 0.5, 0.5], [0.11, 1, 1], [0.34, 1, 1], [0.65, 0, 0], [1, 0, 0]]
    }
  },
  hsv: {
    name: 'HSV',
    numColors: 256,
    gamma: 1,
    segmentedData: {
      red: [[0, 1, 1], [0.158730, 1, 1], [0.174603, 0.968750, 0.968750], [0.333333, 0.031250, 0.031250], [0.349206, 0, 0], [0.666667, 0, 0], [0.682540, 0.031250, 0.031250], [0.841270, 0.968750, 0.968750], [0.857143, 1, 1], [1, 1, 1]],
      green: [[0, 0, 0], [0.158730, 0.937500, 0.937500], [0.174603, 1, 1], [0.507937, 1, 1], [0.666667, 0.062500, 0.062500], [0.682540, 0, 0], [1, 0, 0]],
      blue: [[0, 0, 0], [0.333333, 0, 0], [0.349206, 0.062500, 0.062500], [0.507937, 1, 1], [0.841270, 1, 1], [0.857143, 0.937500, 0.937500], [1, 0.09375, 0.09375]]
    }
  },
  hot: {
    name: 'Hot',
    numColors: 256,
    gamma: 1,
    segmentedData: {
      red: [[0, 0.0416, 0.0416], [0.365079, 1, 1], [1, 1, 1]],
      green: [[0, 0, 0], [0.365079, 0, 0], [0.746032, 1, 1], [1, 1, 1]],
      blue: [[0, 0, 0], [0.746032, 0, 0], [1, 1, 1]]
    }
  },
  cool: {
    name: 'Cool',
    numColors: 256,
    gamma: 1,
    segmentedData: {
      red: [[0, 0, 0], [1, 1, 1]],
      green: [[0, 1, 1], [1, 0, 0]],
      blue: [[0, 1, 1], [1, 1, 1]]
    }
  },
  spring: {
    name: 'Spring',
    numColors: 256,
    gamma: 1,
    segmentedData: {
      red: [[0, 1, 1], [1, 1, 1]],
      green: [[0, 0, 0], [1, 1, 1]],
      blue: [[0, 1, 1], [1, 0, 0]]
    }
  },
  summer: {
    name: 'Summer',
    numColors: 256,
    gamma: 1,
    segmentedData: {
      red: [[0, 0, 0], [1, 1, 1]],
      green: [[0, 0.5, 0.5], [1, 1, 1]],
      blue: [[0, 0.4, 0.4], [1, 0.4, 0.4]]
    }
  },
  autumn: {
    name: 'Autumn',
    numColors: 256,
    gamma: 1,
    segmentedData: {
      red: [[0, 1, 1], [1, 1, 1]],
      green: [[0, 0, 0], [1, 1, 1]],
      blue: [[0, 0, 0], [1, 0, 0]]
    }
  },
  winter: {
    name: 'Winter',
    numColors: 256,
    gamma: 1,
    segmentedData: {
      red: [[0, 0, 0], [1, 0, 0]],
      green: [[0, 0, 0], [1, 1, 1]],
      blue: [[0, 1, 1], [1, 0.5, 0.5]]
    }
  },
  bone: {
    name: 'Bone',
    numColors: 256,
    gamma: 1,
    segmentedData: {
      red: [[0, 0, 0], [0.746032, 0.652778, 0.652778], [1, 1, 1]],
      green: [[0, 0, 0], [0.365079, 0.319444, 0.319444], [0.746032, 0.777778, 0.777778], [1, 1, 1]],
      blue: [[0, 0, 0], [0.365079, 0.444444, 0.444444], [1, 1, 1]]
    }
  },
  copper: {
    name: 'Copper',
    numColors: 256,
    gamma: 1,
    segmentedData: {
      red: [[0, 0, 0], [0.809524, 1, 1], [1, 1, 1]],
      green: [[0, 0, 0], [1, 0.7812, 0.7812]],
      blue: [[0, 0, 0], [1, 0.4975, 0.4975]]
    }
  },
  spectral: {
    name: 'Spectral',
    numColors: 256,
    gamma: 1,
    segmentedData: {
      red: [[0, 0, 0], [0.05, 0.4667, 0.4667], [0.10, 0.5333, 0.5333], [0.15, 0, 0], [0.20, 0, 0], [0.25, 0, 0], [0.30, 0, 0], [0.35, 0, 0], [0.40, 0, 0], [0.45, 0, 0], [0.50, 0, 0], [0.55, 0, 0], [0.60, 0, 0], [0.65, 0.7333, 0.7333], [0.70, 0.9333, 0.9333], [0.75, 1, 1], [0.80, 1, 1], [0.85, 1, 1], [0.90, 0.8667, 0.8667], [0.95, 0.80, 0.80], [1, 0.80, 0.80]],
      green: [[0, 0, 0], [0.05, 0, 0], [0.10, 0, 0], [0.15, 0, 0], [0.20, 0, 0], [0.25, 0.4667, 0.4667], [0.30, 0.6000, 0.6000], [0.35, 0.6667, 0.6667], [0.40, 0.6667, 0.6667], [0.45, 0.6000, 0.6000], [0.50, 0.7333, 0.7333], [0.55, 0.8667, 0.8667], [0.60, 1, 1], [0.65, 1, 1], [0.70, 0.9333, 0.9333], [0.75, 0.8000, 0.8000], [0.80, 0.6000, 0.6000], [0.85, 0, 0], [0.90, 0, 0], [0.95, 0, 0], [1, 0.80, 0.80]],
      blue: [[0, 0, 0], [0.05, 0.5333, 0.5333], [0.10, 0.6000, 0.6000], [0.15, 0.6667, 0.6667], [0.20, 0.8667, 0.8667], [0.25, 0.8667, 0.8667], [0.30, 0.8667, 0.8667], [0.35, 0.6667, 0.6667], [0.40, 0.5333, 0.5333], [0.45, 0, 0], [0.5, 0, 0], [0.55, 0, 0], [0.60, 0, 0], [0.65, 0, 0], [0.70, 0, 0], [0.75, 0, 0], [0.80, 0, 0], [0.85, 0, 0], [0.90, 0, 0], [0.95, 0, 0], [1, 0.80, 0.80]]
    }
  },
  coolwarm: {
    name: 'CoolWarm',
    numColors: 256,
    gamma: 1,
    segmentedData: {
      red: [[0, 0.2298057, 0.2298057], [0.03125, 0.26623388, 0.26623388], [0.0625, 0.30386891, 0.30386891], [0.09375, 0.342804478, 0.342804478], [0.125, 0.38301334, 0.38301334], [0.15625, 0.424369608, 0.424369608], [0.1875, 0.46666708, 0.46666708], [0.21875, 0.509635204, 0.509635204], [0.25, 0.552953156, 0.552953156], [0.28125, 0.596262162, 0.596262162], [0.3125, 0.639176211, 0.639176211], [0.34375, 0.681291281, 0.681291281], [0.375, 0.722193294, 0.722193294], [0.40625, 0.761464949, 0.761464949], [0.4375, 0.798691636, 0.798691636], [0.46875, 0.833466556, 0.833466556], [0.5, 0.865395197, 0.865395197], [0.53125, 0.897787179, 0.897787179], [0.5625, 0.924127593, 0.924127593], [0.59375, 0.944468518, 0.944468518], [0.625, 0.958852946, 0.958852946], [0.65625, 0.96732803, 0.96732803], [0.6875, 0.969954137, 0.969954137], [0.71875, 0.966811177, 0.966811177], [0.75, 0.958003065, 0.958003065], [0.78125, 0.943660866, 0.943660866], [0.8125, 0.923944917, 0.923944917], [0.84375, 0.89904617, 0.89904617], [0.875, 0.869186849, 0.869186849], [0.90625, 0.834620542, 0.834620542], [0.9375, 0.795631745, 0.795631745], [0.96875, 0.752534934, 0.752534934], [1, 0.705673158, 0.705673158]],
      green: [[0, 0.298717966, 0.298717966], [0.03125, 0.353094838, 0.353094838], [0.0625, 0.406535296, 0.406535296], [0.09375, 0.458757618, 0.458757618], [0.125, 0.50941904, 0.50941904], [0.15625, 0.558148092, 0.558148092], [0.1875, 0.604562568, 0.604562568], [0.21875, 0.648280772, 0.648280772], [0.25, 0.688929332, 0.688929332], [0.28125, 0.726149107, 0.726149107], [0.3125, 0.759599947, 0.759599947], [0.34375, 0.788964712, 0.788964712], [0.375, 0.813952739, 0.813952739], [0.40625, 0.834302879, 0.834302879], [0.4375, 0.849786142, 0.849786142], [0.46875, 0.860207984, 0.860207984], [0.5, 0.86541021, 0.86541021], [0.53125, 0.848937047, 0.848937047], [0.5625, 0.827384882, 0.827384882], [0.59375, 0.800927443, 0.800927443], [0.625, 0.769767752, 0.769767752], [0.65625, 0.734132809, 0.734132809], [0.6875, 0.694266682, 0.694266682], [0.71875, 0.650421156, 0.650421156], [0.75, 0.602842431, 0.602842431], [0.78125, 0.551750968, 0.551750968], [0.8125, 0.49730856, 0.49730856], [0.84375, 0.439559467, 0.439559467], [0.875, 0.378313092, 0.378313092], [0.90625, 0.312874446, 0.312874446], [0.9375, 0.24128379, 0.24128379], [0.96875, 0.157246067, 0.157246067], [1, 0.01555616, 0.01555616]],
      blue: [[0, 0.753683153, 0.753683153], [0.03125, 0.801466763, 0.801466763], [0.0625, 0.84495867, 0.84495867], [0.09375, 0.883725899, 0.883725899], [0.125, 0.917387822, 0.917387822], [0.15625, 0.945619588, 0.945619588], [0.1875, 0.968154911, 0.968154911], [0.21875, 0.98478814, 0.98478814], [0.25, 0.995375608, 0.995375608], [0.28125, 0.999836203, 0.999836203], [0.3125, 0.998151185, 0.998151185], [0.34375, 0.990363227, 0.990363227], [0.375, 0.976574709, 0.976574709], [0.40625, 0.956945269, 0.956945269], [0.4375, 0.931688648, 0.931688648], [0.46875, 0.901068838, 0.901068838], [0.5, 0.865395561, 0.865395561], [0.53125, 0.820880546, 0.820880546], [0.5625, 0.774508472, 0.774508472], [0.59375, 0.726736146, 0.726736146], [0.625, 0.678007945, 0.678007945], [0.65625, 0.628751763, 0.628751763], [0.6875, 0.579375448, 0.579375448], [0.71875, 0.530263762, 0.530263762], [0.75, 0.481775914, 0.481775914], [0.78125, 0.434243684, 0.434243684], [0.8125, 0.387970225, 0.387970225], [0.84375, 0.343229596, 0.343229596], [0.875, 0.300267182, 0.300267182], [0.90625, 0.259301199, 0.259301199], [0.9375, 0.220525627, 0.220525627], [0.96875, 0.184115123, 0.184115123], [1, 0.150232812, 0.150232812]]
    }
  },
  blues: {
    name: 'Blues',
    numColors: 256,
    gamma: 1,
    segmentedData: {
      red: [[0, 0.9686274528503418, 0.9686274528503418], [0.125, 0.87058824300765991, 0.87058824300765991], [0.25, 0.7764706015586853, 0.7764706015586853], [0.375, 0.61960786581039429, 0.61960786581039429], [0.5, 0.41960784792900085, 0.41960784792900085], [0.625, 0.25882354378700256, 0.25882354378700256], [0.75, 0.12941177189350128, 0.12941177189350128], [0.875, 0.031372550874948502, 0.031372550874948502], [1, 0.031372550874948502, 0.031372550874948502]],
      green: [[0, 0.9843137264251709, 0.9843137264251709], [0.125, 0.92156863212585449, 0.92156863212585449], [0.25, 0.85882353782653809, 0.85882353782653809], [0.375, 0.7921568751335144, 0.7921568751335144], [0.5, 0.68235296010971069, 0.68235296010971069], [0.625, 0.57254904508590698, 0.57254904508590698], [0.75, 0.44313725829124451, 0.44313725829124451], [0.875, 0.31764706969261169, 0.31764706969261169], [1, 0.18823529779911041, 0.18823529779911041]],
      blue: [[0, 1, 1], [0.125, 0.9686274528503418, 0.9686274528503418], [0.25, 0.93725490570068359, 0.93725490570068359], [0.375, 0.88235294818878174, 0.88235294818878174], [0.5, 0.83921569585800171, 0.83921569585800171], [0.625, 0.7764706015586853, 0.7764706015586853], [0.75, 0.70980393886566162, 0.70980393886566162], [0.875, 0.61176472902297974, 0.61176472902297974], [1, 0.41960784792900085, 0.41960784792900085]]
    }
  }
};
/**
 *  Generate linearly spaced vectors
*  http://cens.ioc.ee/local/man/matlab/techdoc/ref/linspace.html
 * @param {Number} a A number representing the first vector
 * @param {Number} b A number representing the second vector
 * @param {Number} n The number of linear spaced vectors to generate
 * @returns {Array} An array of points representing linear spaced vectors.
 * @memberof Colors
 */

function linspace(a, b, n) {
  n = n === null ? 100 : n;
  var increment = (b - a) / (n - 1);
  var vector = [];

  while (n-- > 0) {
    vector.push(a);
    a += increment;
  } // Make sure the last item will always be "b" because most of the
  // Time we'll get numbers like 1.0000000000000002 instead of 1.


  vector[vector.length - 1] = b;
  return vector;
}
/**
 * Returns the "rank/index" of the element in a sorted array if found or the highest index if not. Uses (binary search)
 * @param {Array} array A sorted array to search in
 * @param {any} elem the element in the array to search for
 * @returns {number} The rank/index of the element in the given array
 * @memberof Colors
 */


function getRank(array, elem) {
  var left = 0;
  var right = array.length - 1;

  while (left <= right) {
    var mid = left + Math.floor((right - left) / 2);
    var midElem = array[mid];

    if (midElem === elem) {
      return mid;
    } else if (elem < midElem) {
      right = mid - 1;
    } else {
      left = mid + 1;
    }
  }

  return left;
}
/**
 * Find the indices into a sorted array a such that, if the corresponding elements
 * In v were inserted before the indices, the order of a would be preserved.
 *  http://lagrange.univ-lyon1.fr/docs/numpy/1.11.0/reference/generated/numpy.searchsorted.html
 * @param {Array} inputArray The array where the values will be inserted
 * @param {Array} values An array of the values to be inserted into the inputArray
 * @returns {Array} The indices where elements should be inserted to maintain order.
 * @memberof Colors
 */


function searchSorted(inputArray, values) {
  var i;
  var indexes = [];
  var len = values.length;
  inputArray.sort(function (a, b) {
    return a - b;
  });

  for (i = 0; i < len; i++) {
    indexes[i] = getRank(inputArray, values[i]);
  }

  return indexes;
}
/**
 * Creates an *N* -element 1-d lookup table
 * @param {Number} N The number of elements in the result lookup table
 * @param {Array} data represented by a list of x,y0,y1 mapping correspondences. Each element in this
 * List represents how a value between 0 and 1 (inclusive) represented by x is mapped to
 * A corresponding value between 0 and 1 (inclusive). The two values of y are to allow for
 * Discontinuous mapping functions (say as might be found in a sawtooth) where y0 represents
 * The value of y for values of x <= to that given, and y1 is the value to be used for x >
 * Than that given). The list must start with x=0, end with x=1, and all values of x must be
 * In increasing order. Values between the given mapping points are determined by simple linear
 * Interpolation.
 * @param {any} gamma value denotes a "gamma curve" value which adjusts the brightness
 * at the bottom and top of the map.
 * @returns {any[]} an array "result" where result[x*(N-1)] gives the closest value for
 * Values of x between 0 and 1.
 * @memberof Colors
 */


function makeMappingArray(N, data, gamma) {
  var i;
  var x = [];
  var y0 = [];
  var y1 = [];
  var lut = [];
  gamma = gamma === null ? 1 : gamma;

  for (i = 0; i < data.length; i++) {
    var element = data[i];
    x.push((N - 1) * element[0]);
    y0.push(element[1]);
    y1.push(element[1]);
  }

  var xLinSpace = linspace(0, 1, N);

  for (i = 0; i < N; i++) {
    xLinSpace[i] = (N - 1) * Math.pow(xLinSpace[i], gamma);
  }

  var xLinSpaceIndexes = searchSorted(x, xLinSpace);

  for (i = 1; i < N - 1; i++) {
    var index = xLinSpaceIndexes[i];
    var colorPercent = (xLinSpace[i] - x[index - 1]) / (x[index] - x[index - 1]);
    var colorDelta = y0[index] - y1[index - 1];
    lut[i] = colorPercent * colorDelta + y1[index - 1];
  }

  lut[0] = y1[0];
  lut[N - 1] = y0[data.length - 1];
  return lut;
}
/**
 * Creates a Colormap based on lookup tables using linear segments.
 * @param {{red:Array, green:Array, blue:Array}} segmentedData An object with a red, green and blue entries.
 * Each entry should be a list of x, y0, y1 tuples, forming rows in a table.
 * @param {Number} N The number of elements in the result Colormap
 * @param {any} gamma value denotes a "gamma curve" value which adjusts the brightness
 * at the bottom and top of the Colormap.
 * @returns {Array} The created Colormap object
 * @description The lookup table is generated using linear interpolation for each
 *  Primary color, with the 0-1 domain divided into any number of
 * Segments.
 * https://github.com/stefanv/matplotlib/blob/3f1a23755e86fef97d51e30e106195f34425c9e3/lib/matplotlib/colors.py#L663
 * @memberof Colors
 */


function createLinearSegmentedColormap(segmentedData, N, gamma) {
  var i;
  var lut = [];
  N = N === null ? 256 : N;
  gamma = gamma === null ? 1 : gamma;
  var redLut = makeMappingArray(N, segmentedData.red, gamma);
  var greenLut = makeMappingArray(N, segmentedData.green, gamma);
  var blueLut = makeMappingArray(N, segmentedData.blue, gamma);

  for (i = 0; i < N; i++) {
    var red = Math.round(redLut[i] * 255);
    var green = Math.round(greenLut[i] * 255);
    var blue = Math.round(blueLut[i] * 255);
    var rgba = [red, green, blue, 255];
    lut.push(rgba);
  }

  return lut;
}
/**
 * Return all available colormaps (id and name)
 * @returns {Array<{id,key}>} An array of colormaps with an object containing the "id" and display "name"
 * @memberof Colors
 */


function getColormapsList() {
  var colormaps = [];
  var keys = Object.keys(colormapsData);
  keys.forEach(function (key) {
    if (colormapsData.hasOwnProperty(key)) {
      var colormap = colormapsData[key];
      colormaps.push({
        id: key,
        name: colormap.name
      });
    }
  });
  colormaps.sort(function (a, b) {
    var aName = a.name.toLowerCase();
    var bName = b.name.toLowerCase();

    if (aName === bName) {
      return 0;
    }

    return aName < bName ? -1 : 1;
  });
  return colormaps;
}
/**
 * Return a colorMap object with the provided id and colormapData
 * if the Id matches existent colorMap objects (check colormapsData) the colormapData is ignored.
 * if the colormapData is not empty, the colorMap will be added to the colormapsData list. Otherwise, an empty colorMap object is returned.
 * @param {string} id The ID of the colormap
 * @param {Object} colormapData - An object that can contain a name, numColors, gama, segmentedData and/or colors
 * @returns {*} The Colormap Object
 * @memberof Colors
*/

function getColormap(id, colormapData) {
  var colormap = colormapsData[id];

  if (!colormap) {
    colormap = colormapsData[id] = colormapData || {
      name: '',
      colors: []
    };
  }

  if (!colormap.colors && colormap.segmentedData) {
    colormap.colors = createLinearSegmentedColormap(colormap.segmentedData, colormap.numColors, colormap.gamma);
  }

  return {
    getId: function getId() {
      return id;
    },
    getColorSchemeName: function getColorSchemeName() {
      return colormap.name;
    },
    setColorSchemeName: function setColorSchemeName(name) {
      colormap.name = name;
    },
    getNumberOfColors: function getNumberOfColors() {
      return colormap.colors.length;
    },
    setNumberOfColors: function setNumberOfColors(numColors) {
      while (colormap.colors.length < numColors) {
        colormap.colors.push(COLOR_TRANSPARENT);
      }

      colormap.colors.length = numColors;
    },
    getColor: function getColor(index) {
      if (this.isValidIndex(index)) {
        return colormap.colors[index];
      }

      return COLOR_TRANSPARENT;
    },
    getColorRepeating: function getColorRepeating(index) {
      var numColors = colormap.colors.length;
      index = numColors ? index % numColors : 0;
      return this.getColor(index);
    },
    setColor: function setColor(index, rgba) {
      if (this.isValidIndex(index)) {
        colormap.colors[index] = rgba;
      }
    },
    addColor: function addColor(rgba) {
      colormap.colors.push(rgba);
    },
    insertColor: function insertColor(index, rgba) {
      if (this.isValidIndex(index)) {
        colormap.colors.splice(index, 1, rgba);
      }
    },
    removeColor: function removeColor(index) {
      if (this.isValidIndex(index)) {
        colormap.colors.splice(index, 1);
      }
    },
    clearColors: function clearColors() {
      colormap.colors = [];
    },
    buildLookupTable: function buildLookupTable(lut) {
      if (!lut) {
        return;
      }

      var numColors = colormap.colors.length;
      lut.setNumberOfTableValues(numColors);

      for (var i = 0; i < numColors; i++) {
        lut.setTableValue(i, colormap.colors[i]);
      }
    },
    createLookupTable: function createLookupTable() {
      var lut = new _lookupTable_js__WEBPACK_IMPORTED_MODULE_0__["default"]();
      this.buildLookupTable(lut);
      return lut;
    },
    isValidIndex: function isValidIndex(index) {
      return index >= 0 && index < colormap.colors.length;
    }
  };
}

/***/ }),

/***/ "./colors/index.js":
/*!*************************!*\
  !*** ./colors/index.js ***!
  \*************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _colormap_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./colormap.js */ "./colors/colormap.js");
/* harmony import */ var _lookupTable_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./lookupTable.js */ "./colors/lookupTable.js");


/* harmony default export */ __webpack_exports__["default"] = ({
  getColormap: _colormap_js__WEBPACK_IMPORTED_MODULE_0__["getColormap"],
  getColormapsList: _colormap_js__WEBPACK_IMPORTED_MODULE_0__["getColormapsList"],
  LookupTable: _lookupTable_js__WEBPACK_IMPORTED_MODULE_1__["default"]
});

/***/ }),

/***/ "./colors/lookupTable.js":
/*!*******************************!*\
  !*** ./colors/lookupTable.js ***!
  \*******************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

// This code was created based on vtkLookupTable
// http://www.vtk.org/doc/release/5.0/html/a01697.html
// https://github.com/Kitware/VTK/blob/master/Common/Core/vtkLookupTable.cxx
var BELOW_RANGE_COLOR_INDEX = 0;
var ABOVE_RANGE_COLOR_INDEX = 1;
var NAN_COLOR_INDEX = 2;
/**
 * Converts an HSV  (Hue, Saturation, Value) color to RGB (Red, Green, Blue) color value
 * @param {Number} hue A number representing the hue color value
 * @param {any} sat A number representing the saturation color value
 * @param {any} val A number representing the value color value
 * @returns {Numberp[]} An RGB color array
 */

function HSVToRGB(hue, sat, val) {
  if (hue > 1) {
    throw new Error('HSVToRGB expects hue < 1');
  }

  var rgb = [];

  if (sat === 0) {
    rgb[0] = val;
    rgb[1] = val;
    rgb[2] = val;
    return rgb;
  }

  var hueCase = Math.floor(hue * 6);
  var frac = 6 * hue - hueCase;
  var lx = val * (1 - sat);
  var ly = val * (1 - sat * frac);
  var lz = val * (1 - sat * (1 - frac));

  switch (hueCase) {
    /* 0<hue<1/6 */
    case 0:
    case 6:
      rgb[0] = val;
      rgb[1] = lz;
      rgb[2] = lx;
      break;

    /* 1/6<hue<2/6 */

    case 1:
      rgb[0] = ly;
      rgb[1] = val;
      rgb[2] = lx;
      break;

    /* 2/6<hue<3/6 */

    case 2:
      rgb[0] = lx;
      rgb[1] = val;
      rgb[2] = lz;
      break;

    /* 3/6<hue/4/6 */

    case 3:
      rgb[0] = lx;
      rgb[1] = ly;
      rgb[2] = val;
      break;

    /* 4/6<hue<5/6 */

    case 4:
      rgb[0] = lz;
      rgb[1] = lx;
      rgb[2] = val;
      break;

    /* 5/6<hue<1 */

    case 5:
      rgb[0] = val;
      rgb[1] = lx;
      rgb[2] = ly;
      break;
  }

  return rgb;
}
/**
 * Maps a value to an index in the table
 * @param {Number} v A double value which table index will be returned.
 * @param {any} p An object that contains the Table "Range", the table "MaxIndex",
 * A "Shift" from first value in the table and the table "Scale" value
 * @returns {Number} The mapped index in the table
 * @memberof Colors
 */


function linearIndexLookupMain(v, p) {
  var dIndex; // NOTE: Added Math.floor since values were not integers? Check VTK source

  if (v < p.Range[0]) {
    dIndex = p.MaxIndex + BELOW_RANGE_COLOR_INDEX + 1.5;
  } else if (v > p.Range[1]) {
    dIndex = p.MaxIndex + ABOVE_RANGE_COLOR_INDEX + 1.5;
  } else {
    dIndex = (v + p.Shift) * p.Scale;
  }

  return Math.floor(dIndex);
}
/**
 * Maps scalar values into colors via a lookup table
 * LookupTable is an object that is used by mapper objects to map scalar values into rgba (red-green-blue-alpha transparency) color specification,
 * or rgba into scalar values. The color table can be created by direct insertion of color values, or by specifying hue, saturation, value, and alpha range and generating a table
 */


var LookupTable =
/*#__PURE__*/
function () {
  /**
   * Creates a default linear LookupTable object with 256 colors.
   */
  function LookupTable() {
    _classCallCheck(this, LookupTable);

    this.NumberOfColors = 256;
    this.Ramp = 'linear';
    this.TableRange = [0, 255];
    this.HueRange = [0, 0.66667];
    this.SaturationRange = [1, 1];
    this.ValueRange = [1, 1];
    this.AlphaRange = [1, 1];
    this.NaNColor = [128, 0, 0, 255];
    this.BelowRangeColor = [0, 0, 0, 255];
    this.UseBelowRangeColor = true;
    this.AboveRangeColor = [255, 255, 255, 255];
    this.UseAboveRangeColor = true;
    this.InputRange = [0, 255];
    this.Table = [];
  }
  /**
   * Specify the number of values (i.e., colors) in the lookup table.
   * @param {Number} number The number of colors in he LookupTable
   * @returns {void}
   * @memberof Colors
   */


  _createClass(LookupTable, [{
    key: "setNumberOfTableValues",
    value: function setNumberOfTableValues(number) {
      this.NumberOfColors = number;
    }
    /**
     * Set the shape of the table ramp to either 'linear', 'scurve' or 'sqrt'
     * @param {String} ramp A string value representing the shape of the table. Allowed values are 'linear', 'scurve' or 'sqrt'
     * @returns {void}
     * @memberof Colors
     */

  }, {
    key: "setRamp",
    value: function setRamp(ramp) {
      this.Ramp = ramp;
    }
    /**
     * Sets the minimum/maximum scalar values for scalar mapping.
     * Scalar values less than minimum range value are clamped to minimum range value.
     * Scalar values greater than maximum range value are clamped to maximum range value.
     * @param {Number} start A double representing the minimum scaler value of the LookupTable
     * @param {any} end A double representing the maximum scaler value of the LookupTable
     * @returns {void}
     * @memberof Colors
     */

  }, {
    key: "setTableRange",
    value: function setTableRange(start, end) {
      this.TableRange[0] = start;
      this.TableRange[1] = end;
    }
    /**
     * Set the range in hue (using automatic generation). Hue ranges between [0,1].
     * @param {Number} start A double representing the minimum hue value in a range. Min. is 0
     * @param {Number} end A double representing the maximum hue value in a range. Max. is 1
     * @returns {void}
     * @memberof Colors
     */

  }, {
    key: "setHueRange",
    value: function setHueRange(start, end) {
      this.HueRange[0] = start;
      this.HueRange[1] = end;
    }
    /**
     * Set the range in saturation (using automatic generation). Saturation ranges between [0,1].
     * @param {Number} start A double representing the minimum Saturation value in a range. Min. is 0
     * @param {Number} end A double representing the maximum Saturation value in a range. Max. is 1
     * @returns {void}
     * @memberof Colors
     */

  }, {
    key: "setSaturationRange",
    value: function setSaturationRange(start, end) {
      this.SaturationRange[0] = start;
      this.SaturationRange[1] = end;
    }
    /**
     * Set the range in value (using automatic generation). Value ranges between [0,1].
     * @param {Numeber } start A double representing the minimum value in a range. Min. is 0
     * @param {Numeber} end A double representing the maximum value in a range. Max. is 1
     * @returns {void}
     * @memberof Colors
     */

  }, {
    key: "setValueRange",
    value: function setValueRange(start, end) {
      // Set the range in value (using automatic generation). Value ranges between [0,1].
      this.ValueRange[0] = start;
      this.ValueRange[1] = end;
    }
    /**
     * (Not Used) Sets the range of scalars which will be mapped.
     * @param {Number} start the minimum scalar value in the range
     * @param {Number} end the maximum scalar value in the range
     * @returns {void}
     * @memberof Colors
     */

  }, {
    key: "setRange",
    value: function setRange(start, end) {
      this.InputRange[0] = start;
      this.InputRange[1] = end;
    }
    /**
     * Set the range in alpha (using automatic generation). Alpha ranges from [0,1].
     * @param {Number} start A double representing the minimum alpha value
     * @param {Number} end A double representing the maximum alpha value
     * @returns {void}
     * @memberof Colors
     */

  }, {
    key: "setAlphaRange",
    value: function setAlphaRange(start, end) {
      // Set the range in alpha (using automatic generation). Alpha ranges from [0,1].
      this.AlphaRange[0] = start;
      this.AlphaRange[1] = end;
    }
    /**
     * Map one value through the lookup table and return the color as an
     * RGBA array of doubles between 0 and 1.
     * @param {Number} scalar A double scalar value which will be mapped to a color in the LookupTable
     * @returns {Number[]} An RGBA array of doubles between 0 and 1
     * @memberof Colors
     */

  }, {
    key: "getColor",
    value: function getColor(scalar) {
      return this.mapValue(scalar);
    }
    /**
     * Generate lookup table from hue, saturation, value, alpha min/max values. Table is built from linear ramp of each value.
     * @param {Boolean} force true to force the build of the LookupTable. Otherwie, false. This is useful if a lookup table has been defined manually
     * (using SetTableValue) and then an application decides to rebuild the lookup table using the implicit process.
     * @returns {void}
     * @memberof Colors
     */

  }, {
    key: "build",
    value: function build(force) {
      if (this.Table.length > 1 && !force) {
        return;
      } // Clear the table


      this.Table = [];
      var maxIndex = this.NumberOfColors - 1;
      var hinc, sinc, vinc, ainc;

      if (maxIndex) {
        hinc = (this.HueRange[1] - this.HueRange[0]) / maxIndex;
        sinc = (this.SaturationRange[1] - this.SaturationRange[0]) / maxIndex;
        vinc = (this.ValueRange[1] - this.ValueRange[0]) / maxIndex;
        ainc = (this.AlphaRange[1] - this.AlphaRange[0]) / maxIndex;
      } else {
        hinc = sinc = vinc = ainc = 0.0;
      }

      for (var i = 0; i <= maxIndex; i++) {
        var hue = this.HueRange[0] + i * hinc;
        var sat = this.SaturationRange[0] + i * sinc;
        var val = this.ValueRange[0] + i * vinc;
        var alpha = this.AlphaRange[0] + i * ainc;
        var rgb = HSVToRGB(hue, sat, val);
        var c_rgba = [];

        switch (this.Ramp) {
          case 'scurve':
            c_rgba[0] = Math.floor(127.5 * (1.0 + Math.cos((1.0 - rgb[0]) * Math.PI)));
            c_rgba[1] = Math.floor(127.5 * (1.0 + Math.cos((1.0 - rgb[1]) * Math.PI)));
            c_rgba[2] = Math.floor(127.5 * (1.0 + Math.cos((1.0 - rgb[2]) * Math.PI)));
            c_rgba[3] = Math.floor(alpha * 255);
            break;

          case 'linear':
            c_rgba[0] = Math.floor(rgb[0] * 255 + 0.5);
            c_rgba[1] = Math.floor(rgb[1] * 255 + 0.5);
            c_rgba[2] = Math.floor(rgb[2] * 255 + 0.5);
            c_rgba[3] = Math.floor(alpha * 255 + 0.5);
            break;

          case 'sqrt':
            c_rgba[0] = Math.floor(Math.sqrt(rgb[0]) * 255 + 0.5);
            c_rgba[1] = Math.floor(Math.sqrt(rgb[1]) * 255 + 0.5);
            c_rgba[2] = Math.floor(Math.sqrt(rgb[2]) * 255 + 0.5);
            c_rgba[3] = Math.floor(Math.sqrt(alpha) * 255 + 0.5);
            break;

          default:
            throw new Error("Invalid Ramp value (".concat(this.Ramp, ")"));
        }

        this.Table.push(c_rgba);
      }

      this.buildSpecialColors();
    }
    /**
     * Ensures the out-of-range colors (Below range and Above range) are set correctly.
     * @returns {void}
     * @memberof Colors
     */

  }, {
    key: "buildSpecialColors",
    value: function buildSpecialColors() {
      var numberOfColors = this.NumberOfColors;
      var belowRangeColorIndex = numberOfColors + BELOW_RANGE_COLOR_INDEX;
      var aboveRangeColorIndex = numberOfColors + ABOVE_RANGE_COLOR_INDEX;
      var nanColorIndex = numberOfColors + NAN_COLOR_INDEX; // Below range color

      if (this.UseBelowRangeColor || numberOfColors === 0) {
        this.Table[belowRangeColorIndex] = this.BelowRangeColor;
      } else {
        // Duplicate the first color in the table.
        this.Table[belowRangeColorIndex] = this.Table[0];
      } // Above range color


      if (this.UseAboveRangeColor || numberOfColors === 0) {
        this.Table[aboveRangeColorIndex] = this.AboveRangeColor;
      } else {
        // Duplicate the last color in the table.
        this.Table[aboveRangeColorIndex] = this.Table[numberOfColors - 1];
      } // Always use NanColor


      this.Table[nanColorIndex] = this.NaNColor;
    }
    /**
     * Similar to GetColor - Map one value through the lookup table and return the color as an
     * RGBA array of doubles between 0 and 1.
     * @param {Numeber} v A double scalar value which will be mapped to a color in the LookupTable
     * @returns {Number[]} An RGBA array of doubles between 0 and 1
     * @memberof Colors
     */

  }, {
    key: "mapValue",
    value: function mapValue(v) {
      var index = this.getIndex(v);

      if (index < 0) {
        return this.NaNColor;
      } else if (index === 0) {
        if (this.UseBelowRangeColor && v < this.TableRange[0]) {
          return this.BelowRangeColor;
        }
      } else if (index === this.NumberOfColors - 1) {
        if (this.UseAboveRangeColor && v > this.TableRange[1]) {
          return this.AboveRangeColor;
        }
      }

      return this.Table[index];
    }
    /**
     * Return the table index associated with a particular value.
     * @param {Number} v A double value which table index will be returned.
     * @returns {Number} The index in the LookupTable
     * @memberof Colors
     */

  }, {
    key: "getIndex",
    value: function getIndex(v) {
      var p = {};
      p.Range = [];
      p.MaxIndex = this.NumberOfColors - 1; // This was LookupShiftAndScale

      p.Shift = -this.TableRange[0];

      if (this.TableRange[1] <= this.TableRange[0]) {
        p.Scale = Number.MAX_VALUE;
      } else {
        p.Scale = p.MaxIndex / (this.TableRange[1] - this.TableRange[0]);
      }

      p.Range[0] = this.TableRange[0];
      p.Range[1] = this.TableRange[1]; // First, check whether we have a number...

      if (isNaN(v)) {
        // For backwards compatibility
        return -1;
      } // Map to an index:


      var index = linearIndexLookupMain(v, p); // For backwards compatibility, if the index indicates an
      // Out-of-range value, truncate to index range for in-range colors.

      if (index === this.NumberOfColors + BELOW_RANGE_COLOR_INDEX) {
        index = 0;
      } else if (index === this.NumberOfColors + ABOVE_RANGE_COLOR_INDEX) {
        index = this.NumberOfColors - 1;
      }

      return index;
    }
    /**
     * Directly load color into lookup table. Use [0,1] double values for color component specification.
     * Make sure that you've either used the Build() method or used SetNumberOfTableValues() prior to using this method.
     * @param {Number} index The index in the LookupTable of where to insert the color value
     * @param {Number[]} rgba An array of [0,1] double values for an RGBA color component
     * @returns {void}
     * @memberof Colors
     */

  }, {
    key: "setTableValue",
    value: function setTableValue(index, rgba) {
      // Check if it index, red, green, blue and alpha were passed as parameter
      if (arguments.length === 5) {
        rgba = Array.prototype.slice.call(arguments, 1);
      } // Check the index to make sure it is valid


      if (index < 0) {
        throw new Error("Can't set the table value for negative index (".concat(index, ")"));
      }

      if (index >= this.NumberOfColors) {
        new Error("Index ".concat(index, " is greater than the number of colors ").concat(this.NumberOfColors));
      }

      this.Table[index] = rgba;

      if (index === 0 || index === this.NumberOfColors - 1) {
        // This is needed due to the way the special colors are stored in
        // The internal table. If Above/BelowRangeColors are not used and
        // The min/max colors are changed in the table with this member
        // Function, then the colors used for values outside the range may
        // Be incorrect. Calling this here ensures the out-of-range colors
        // Are set correctly.
        this.buildSpecialColors();
      }
    }
  }]);

  return LookupTable;
}();

/* harmony default export */ __webpack_exports__["default"] = (LookupTable);

/***/ }),

/***/ "./disable.js":
/*!********************!*\
  !*** ./disable.js ***!
  \********************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _enabledElements_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./enabledElements.js */ "./enabledElements.js");
/* harmony import */ var _triggerEvent_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./triggerEvent.js */ "./triggerEvent.js");
/* harmony import */ var _events_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./events.js */ "./events.js");



/**
 *  Disable an HTML element for further use in Cornerstone
 *
 * @param {HTMLElement} element An HTML Element enabled for Cornerstone
 * @returns {void}
 * @memberof Enable
 */

/* harmony default export */ __webpack_exports__["default"] = (function (element) {
  if (element === undefined) {
    throw new Error('disable: element must not be undefined');
  } // Search for this element in this list of enabled elements


  var enabledElements = Object(_enabledElements_js__WEBPACK_IMPORTED_MODULE_0__["getEnabledElements"])();

  for (var i = 0; i < enabledElements.length; i++) {
    if (enabledElements[i].element === element) {
      // We found it!
      // Fire an event so dependencies can cleanup
      var eventData = {
        element: element
      };
      Object(_triggerEvent_js__WEBPACK_IMPORTED_MODULE_1__["default"])(element, _events_js__WEBPACK_IMPORTED_MODULE_2__["default"].ELEMENT_DISABLED, eventData);
      Object(_triggerEvent_js__WEBPACK_IMPORTED_MODULE_1__["default"])(_events_js__WEBPACK_IMPORTED_MODULE_2__["events"], _events_js__WEBPACK_IMPORTED_MODULE_2__["default"].ELEMENT_DISABLED, eventData); // Remove the child DOM elements that we created (e.g.canvas)

      enabledElements[i].element.removeChild(enabledElements[i].canvas);
      enabledElements[i].canvas = undefined; // Remove this element from the list of enabled elements

      enabledElements.splice(i, 1);
      break;
    }
  }
});

/***/ }),

/***/ "./displayImage.js":
/*!*************************!*\
  !*** ./displayImage.js ***!
  \*************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _enabledElements_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./enabledElements.js */ "./enabledElements.js");
/* harmony import */ var _internal_getDefaultViewport_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./internal/getDefaultViewport.js */ "./internal/getDefaultViewport.js");
/* harmony import */ var _updateImage_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./updateImage.js */ "./updateImage.js");
/* harmony import */ var _internal_now_js__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ./internal/now.js */ "./internal/now.js");
/* harmony import */ var _layers_js__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! ./layers.js */ "./layers.js");
/* harmony import */ var _triggerEvent_js__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(/*! ./triggerEvent.js */ "./triggerEvent.js");
/* harmony import */ var _events_js__WEBPACK_IMPORTED_MODULE_6__ = __webpack_require__(/*! ./events.js */ "./events.js");







/**
 * Sets a new image object for a given element.
 *
 * Will also apply an optional viewport setting.
 *
 * @param {HTMLElement} element An HTML Element enabled for Cornerstone
 * @param {Object} image An Image loaded by a Cornerstone Image Loader
 * @param {Object} [viewport] A set of Cornerstone viewport parameters
 * @returns {void}
 * @memberof Drawing
 */

/* harmony default export */ __webpack_exports__["default"] = (function (element, image, viewport) {
  if (element === undefined) {
    throw new Error('displayImage: parameter element must not be undefined');
  }

  if (image === undefined) {
    throw new Error('displayImage: parameter image must not be undefined');
  }

  var enabledElement = Object(_enabledElements_js__WEBPACK_IMPORTED_MODULE_0__["getEnabledElement"])(element);
  var oldImage = enabledElement.image;
  enabledElement.image = image;

  if (enabledElement.layers && enabledElement.layers.length) {
    Object(_layers_js__WEBPACK_IMPORTED_MODULE_4__["setLayerImage"])(element, image);
  }

  if (enabledElement.viewport === undefined) {
    enabledElement.viewport = Object(_internal_getDefaultViewport_js__WEBPACK_IMPORTED_MODULE_1__["default"])(enabledElement.canvas, image);
  } // Merge viewport


  if (viewport) {
    for (var attrname in viewport) {
      if (viewport[attrname] !== null) {
        enabledElement.viewport[attrname] = viewport[attrname];
      }
    }
  }

  var frameRate;

  if (enabledElement.lastImageTimeStamp !== undefined) {
    var timeSinceLastImage = Object(_internal_now_js__WEBPACK_IMPORTED_MODULE_3__["default"])() - enabledElement.lastImageTimeStamp;
    frameRate = (1000 / timeSinceLastImage).toFixed();
  }

  enabledElement.lastImageTimeStamp = Object(_internal_now_js__WEBPACK_IMPORTED_MODULE_3__["default"])();
  var newImageEventData = {
    viewport: enabledElement.viewport,
    element: enabledElement.element,
    image: enabledElement.image,
    oldImage: oldImage,
    enabledElement: enabledElement,
    frameRate: frameRate
  };
  Object(_triggerEvent_js__WEBPACK_IMPORTED_MODULE_5__["default"])(enabledElement.element, _events_js__WEBPACK_IMPORTED_MODULE_6__["default"].NEW_IMAGE, newImageEventData);
  Object(_updateImage_js__WEBPACK_IMPORTED_MODULE_2__["default"])(element);
});

/***/ }),

/***/ "./draw.js":
/*!*****************!*\
  !*** ./draw.js ***!
  \*****************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _enabledElements_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./enabledElements.js */ "./enabledElements.js");
/* harmony import */ var _internal_drawImage_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./internal/drawImage.js */ "./internal/drawImage.js");


/**
 * Immediately draws the enabled element
 *
 * @param {HTMLElement} element An HTML Element enabled for Cornerstone
 * @returns {void}
 * @memberof Drawing
 */

/* harmony default export */ __webpack_exports__["default"] = (function (element) {
  var enabledElement = Object(_enabledElements_js__WEBPACK_IMPORTED_MODULE_0__["getEnabledElement"])(element);

  if (enabledElement.image === undefined) {
    throw new Error('draw: image has not been loaded yet');
  }

  Object(_internal_drawImage_js__WEBPACK_IMPORTED_MODULE_1__["default"])(enabledElement);
});

/***/ }),

/***/ "./drawInvalidated.js":
/*!****************************!*\
  !*** ./drawInvalidated.js ***!
  \****************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _enabledElements_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./enabledElements.js */ "./enabledElements.js");
/* harmony import */ var _internal_drawImage_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./internal/drawImage.js */ "./internal/drawImage.js");
/**
 * This module is responsible for drawing invalidated enabled elements
 */


/**
 * Draws all invalidated enabled elements and clears the invalid flag after drawing it
 *
 * @returns {void}
 * @memberof Drawing
 */

/* harmony default export */ __webpack_exports__["default"] = (function () {
  var enabledElements = Object(_enabledElements_js__WEBPACK_IMPORTED_MODULE_0__["getEnabledElements"])();

  for (var i = 0; i < enabledElements.length; i++) {
    var ee = enabledElements[i];

    if (ee.invalid === true) {
      Object(_internal_drawImage_js__WEBPACK_IMPORTED_MODULE_1__["default"])(ee, true);
    }
  }
});

/***/ }),

/***/ "./enable.js":
/*!*******************!*\
  !*** ./enable.js ***!
  \*******************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _enabledElements_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./enabledElements.js */ "./enabledElements.js");
/* harmony import */ var _resize_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./resize.js */ "./resize.js");
/* harmony import */ var _internal_drawImageSync_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./internal/drawImageSync.js */ "./internal/drawImageSync.js");
/* harmony import */ var _internal_requestAnimationFrame_js__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ./internal/requestAnimationFrame.js */ "./internal/requestAnimationFrame.js");
/* harmony import */ var _internal_tryEnableWebgl_js__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! ./internal/tryEnableWebgl.js */ "./internal/tryEnableWebgl.js");
/* harmony import */ var _triggerEvent_js__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(/*! ./triggerEvent.js */ "./triggerEvent.js");
/* harmony import */ var _generateUUID_js__WEBPACK_IMPORTED_MODULE_6__ = __webpack_require__(/*! ./generateUUID.js */ "./generateUUID.js");
/* harmony import */ var _events_js__WEBPACK_IMPORTED_MODULE_7__ = __webpack_require__(/*! ./events.js */ "./events.js");
/* harmony import */ var _internal_getCanvas_js__WEBPACK_IMPORTED_MODULE_8__ = __webpack_require__(/*! ./internal/getCanvas.js */ "./internal/getCanvas.js");









/**
 * @module Enable
 * This module is responsible for enabling an element to display images with cornerstone
 */

/**
 * Returns whether or not an Enabled Element has either a currently active image or
 * a non-empty Array of Enabled Element Layers.
 *
 * @param {EnabledElement} enabledElement An Enabled Element
 * @return {Boolean} Whether or not the Enabled Element has an active image or valid set of layers
 * @memberof Enable
 */

function hasImageOrLayers(enabledElement) {
  return enabledElement.image !== undefined || enabledElement.layers.length > 0;
}
/**
 * Enable an HTML Element for use in Cornerstone
 *
 * - If there is a Canvas already present within the HTMLElement, and it has the class
 * 'cornerstone-canvas', this function will use this existing Canvas instead of creating
 * a new one. This may be helpful when using libraries (e.g. React, Vue) which don't
 * want third parties to change the DOM.
 *
 * @param {HTMLElement} element An HTML Element enabled for Cornerstone
 * @param {Object} options Options for the enabledElement
 *
 * @return {void}
 * @memberof Enable
 */


/* harmony default export */ __webpack_exports__["default"] = (function (element, options) {
  if (element === undefined) {
    throw new Error('enable: parameter element cannot be undefined');
  } // If this enabled element has the option set for WebGL, we should
  // Check if this device actually supports it


  if (options && options.renderer && options.renderer.toLowerCase() === 'webgl') {
    Object(_internal_tryEnableWebgl_js__WEBPACK_IMPORTED_MODULE_4__["default"])(options);
  }

  var canvas = Object(_internal_getCanvas_js__WEBPACK_IMPORTED_MODULE_8__["default"])(element);
  var enabledElement = {
    element: element,
    canvas: canvas,
    image: undefined,
    // Will be set once image is loaded
    invalid: false,
    // True if image needs to be drawn, false if not
    needsRedraw: true,
    options: options,
    layers: [],
    data: {},
    renderingTools: {},
    uuid: Object(_generateUUID_js__WEBPACK_IMPORTED_MODULE_6__["default"])()
  };
  Object(_enabledElements_js__WEBPACK_IMPORTED_MODULE_0__["addEnabledElement"])(enabledElement);
  Object(_triggerEvent_js__WEBPACK_IMPORTED_MODULE_5__["default"])(_events_js__WEBPACK_IMPORTED_MODULE_7__["events"], _events_js__WEBPACK_IMPORTED_MODULE_7__["default"].ELEMENT_ENABLED, enabledElement);
  Object(_resize_js__WEBPACK_IMPORTED_MODULE_1__["default"])(element, true);
  /**
   * Draw the image immediately
   *
   * @param {DOMHighResTimeStamp} timestamp The current time for when requestAnimationFrame starts to fire callbacks
   * @returns {void}
   * @memberof Drawing
   */

  function draw(timestamp) {
    if (enabledElement.canvas === undefined) {
      return;
    }

    var eventDetails = {
      enabledElement: enabledElement,
      timestamp: timestamp
    };
    Object(_triggerEvent_js__WEBPACK_IMPORTED_MODULE_5__["default"])(enabledElement.element, _events_js__WEBPACK_IMPORTED_MODULE_7__["default"].PRE_RENDER, eventDetails);

    if (enabledElement.needsRedraw && hasImageOrLayers(enabledElement)) {
      Object(_internal_drawImageSync_js__WEBPACK_IMPORTED_MODULE_2__["default"])(enabledElement, enabledElement.invalid);
    }

    Object(_internal_requestAnimationFrame_js__WEBPACK_IMPORTED_MODULE_3__["default"])(draw);
  }

  draw();
});

/***/ }),

/***/ "./enabledElementData.js":
/*!*******************************!*\
  !*** ./enabledElementData.js ***!
  \*******************************/
/*! exports provided: getElementData, removeElementData */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "getElementData", function() { return getElementData; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "removeElementData", function() { return removeElementData; });
/* harmony import */ var _enabledElements_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./enabledElements.js */ "./enabledElements.js");

/**
 * Retrieves any data for a Cornerstone enabledElement for a specific string
 * dataType
 *
 * @param {HTMLElement} element An HTML Element enabled for Cornerstone
 * @param {string} dataType A string name for an arbitrary set of data
 * @returns {*} Whatever data is stored for this enabled element
 */

function getElementData(element, dataType) {
  var ee = Object(_enabledElements_js__WEBPACK_IMPORTED_MODULE_0__["getEnabledElement"])(element);

  if (ee.data.hasOwnProperty(dataType) === false) {
    ee.data[dataType] = {};
  }

  return ee.data[dataType];
}
/**
 * Clears any data for a Cornerstone enabledElement for a specific string
 * dataType
 *
 * @param {HTMLElement} element An HTML Element enabled for Cornerstone
 * @param {string} dataType A string name for an arbitrary set of data
 *
 * @returns {void}
 */

function removeElementData(element, dataType) {
  var ee = Object(_enabledElements_js__WEBPACK_IMPORTED_MODULE_0__["getEnabledElement"])(element);
  delete ee.data[dataType];
}

/***/ }),

/***/ "./enabledElements.js":
/*!****************************!*\
  !*** ./enabledElements.js ***!
  \****************************/
/*! exports provided: getEnabledElement, addEnabledElement, getEnabledElementsByImageId, getEnabledElements */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "getEnabledElement", function() { return getEnabledElement; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "addEnabledElement", function() { return addEnabledElement; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "getEnabledElementsByImageId", function() { return getEnabledElementsByImageId; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "getEnabledElements", function() { return getEnabledElements; });
var enabledElements = [];
/**
 * @module EnabledElements
 */

/**
 * @module Objects
 */

/**
 * A two-dimensional vector
 *
 * @typedef {Object} vec2
 * @memberof Objects
 * @param {Number} x - The x distance
 * @param {Number} y - The y distance
 */

/**
 * VOI
 *
 * @typedef {Object} VOI
 * @memberof Objects
 * @param {Number} windowWidth - Window Width for display
 * @param {Number} windowCenter - Window Center for display
 */

/**
 * Lookup Table Array
 *
 * @typedef {Object} LUT
 * @memberof Objects
 * @property {Number} firstValueMapped
 * @property {Number} numBitsPerEntry
 * @property {Array} lut
 */

/**
 * Image Statistics Object
 *
 * @typedef {Object} ImageStats
 * @memberof Objects
 * @property {Number} [lastGetPixelDataTime] The time in ms taken to retrieve stored pixels required to draw the image
 * @property {Number} [lastStoredPixelDataToCanvasImageDataTime] The time in ms taken to map from stored pixel array to canvas pixel array
 * @property {Number} [lastPutImageDataTime] The time in ms taken for putImageData to put the canvas pixel data into the canvas context
 * @property {Number} [lastRenderTime] The total time in ms taken for the entire rendering function to run
 * @property {Number} [lastLutGenerateTime] The time in ms taken to generate the lookup table for the image
 */

/**
 * An Image Object in Cornerstone
 *
 * @typedef {Object} Image
 * @memberof Objects
 * @property {string} imageId - The imageId associated with this image object
 * @property {Number} minPixelValue - the minimum stored pixel value in the image
 * @property {Number} maxPixelValue - the maximum stored pixel value in the image
 * @property {Number} slope - the rescale slope to convert stored pixel values to modality pixel values or 1 if not specified
 * @property {Number} intercept - the rescale intercept used to convert stored pixel values to modality values or 0 if not specified
 * @property {Number} windowCenter - the default windowCenter to apply to the image
 * @property {Number} windowWidth - the default windowWidth to apply to the image
 * @property {function} getPixelData - a function that returns the underlying pixel data. An array of integers for grayscale and an array of RGBA for color
 * @property {function} getImageData - a function that returns a canvas imageData object for the image. This is only needed for color images
 * @property {function} getCanvas - a function that returns a canvas element with the image loaded into it. This is only needed for color images.
 * @property {function} getImage - a function that returns a JavaScript Image object with the image data. This is optional and typically used for images encoded in standard web JPEG and PNG formats
 * @property {Number} rows - number of rows in the image. This is the same as height but duplicated for convenience
 * @property {Number} columns - number of columns in the image. This is the same as width but duplicated for convenience
 * @property {Number} height - the height of the image. This is the same as rows but duplicated for convenience
 * @property {Number} width - the width of the image. This is the same as columns but duplicated for convenience
 * @property {Boolean} color - true if pixel data is RGB, false if grayscale
 * @property {Object} lut - The Lookup Table
 * @property {Boolean} rgba - Is the color pixel data stored in RGBA?
 * @property {Number} columnPixelSpacing - horizontal distance between the middle of each pixel (or width of each pixel) in mm or undefined if not known
 * @property {Number} rowPixelSpacing - vertical distance between the middle of each pixel (or height of each pixel) in mm or undefined if not known
 * @property {Boolean} invert - true if the the image should initially be displayed be inverted, false if not. This is here mainly to support DICOM images with a photometric interpretation of MONOCHROME1
 * @property {Number} sizeInBytes - the number of bytes used to store the pixels for this image.
 * @property {Boolean} [falseColor=false] - Whether or not the image has undergone false color mapping
 * @property {Array} [origPixelData] - Original pixel data for an image after it has undergone false color mapping
 * @property {ImageStats} [stats] - Statistics for the last redraw of the image
 * @property {Object} cachedLut - Cached Lookup Table for this image.
 * @property {String|Colormap} [colormap] - Depreacted. Use viewport.colormap instead. an optional colormap ID or colormap object (from colors/colormap.js). This will be applied during rendering to convert the image to pseudocolor
 * @property {Boolean} [labelmap=false] - whether or not to render this image as a label map (i.e. skip modality and VOI LUT pipelines and use only a color lookup table)
 */

/**
 * A Viewport Settings Object Cornerstone
 *
 * @typedef {Object} Viewport
 * @memberof Objects
 * @property {Number} [scale=1.0] - The scale applied to the image. A scale of 1.0 will display no zoom (one image pixel takes up one screen pixel). A scale of 2.0 will be double zoom and a scale of .5 will be zoomed out by 2x
 * @property {vec2} [translation] - An object with properties x and y which describe the translation to apply in the pixel coordinate system. Note that the image is initially displayed centered in the enabled element with a x and y translation of 0 and 0 respectively.
 * @property {VOI} [voi] - an object with properties windowWidth and windowCenter.
 * @property {boolean} [invert=false] - Whether or not the image is inverted.
 * @property {boolean} [pixelReplication=false] - true if the image smooth / interpolation should be used when zoomed in on the image or false if pixel replication should be used.
 * @property {boolean} [hflip=false] - true if the image is flipped horizontally. Default is false
 * @property {boolean} [vflip=false] - true if the image is flipped vertically. Default is false
 * @property {Number} [rotation=0] - the rotation of the image (90 degree increments). Default is 0
 * @property {LUT} [modalityLUT] - the modality LUT to apply or undefined if none
 * @property {LUT} [voiLUT] - the modality LUT to apply or undefined if none
 * @property {String|Colormap} [colormap] - an optional colormap ID or colormap object (from colors/colormap.js). This will be applied during rendering to convert the image to pseudocolor
 * @property {Boolean} [labelmap=false] - whether or not to render this image as a label map (i.e. skip modality and VOI LUT pipelines and use only a color lookup table)
 */

/**
 * An Enabled Element in Cornerstone
 *
 * @typedef {Object} EnabledElement
 * @memberof Objects
 * @property {HTMLElement} element - The DOM element which has been enabled for use by Cornerstone
 * @property {Image} [image] - The image currently displayed in the enabledElement
 * @property {Viewport} [viewport] - The current viewport settings of the enabledElement
 * @property {HTMLCanvasElement} [canvas] - The current canvas for this enabledElement
 * @property {Boolean} invalid - Whether or not the image pixel data underlying the enabledElement has been changed, necessitating a redraw
 * @property {Boolean} needsRedraw - A flag for triggering a redraw of the canvas without re-retrieving the pixel data, since it remains valid
 * @property {EnabledElementLayer[]} [layers] - The layers that have been added to the enabledElement
 * @property {Boolean} [syncViewports] - Whether or not to synchronize the viewport parameters
 * for each of the enabled element's layers
 * @property {Boolean} [lastSyncViewportsState] - The previous state for the sync viewport boolean
 */

/**
 * An Enabled Element Layer in Cornerstone
 *
 * @typedef {Object} EnabledElementLayer
 * @memberof Objects
 * @property {HTMLElement} element - The DOM element which has been enabled for use by Cornerstone
 * @property {Image} [image] - The image currently displayed in the enabledElement
 * @property {Viewport} [viewport] - The current viewport settings of the enabledElement
 * @property {HTMLCanvasElement} [canvas] - The current canvas for this enabledElement
 * @property {Object} [options] - Layer drawing options
 * @property {Boolean} invalid - Whether or not the image pixel data underlying the enabledElement has been changed, necessitating a redraw
 * @property {Boolean} needsRedraw - A flag for triggering a redraw of the canvas without re-retrieving the pixel data, since it remains valid
 */

/**
 * An Image Load Object
 *
 * @typedef {Object} ImageLoadObject
 * @memberof Objects
 * @property {Promise} promise - The Promise tracking the loading of this image
 * @property {Function|undefined} cancelFn - A function to cancel the image load request
 */

/**
 * Retrieves a Cornerstone Enabled Element object
 *
 * @param {HTMLElement} element An HTML Element enabled for Cornerstone
 *
 * @returns {EnabledElement} A Cornerstone Enabled Element
 * @memberof EnabledElements
 */

function getEnabledElement(element) {
  if (element === undefined) {
    throw new Error('getEnabledElement: parameter element must not be undefined');
  }

  for (var i = 0; i < enabledElements.length; i++) {
    if (enabledElements[i].element === element) {
      return enabledElements[i];
    }
  }

  throw new Error('element not enabled');
}
/**
 * Adds a Cornerstone Enabled Element object to the central store of enabledElements
 *
 * @param {EnabledElement} enabledElement A Cornerstone enabledElement Object
 * @returns {void}
 * @memberof EnabledElements
 */

function addEnabledElement(enabledElement) {
  if (enabledElement === undefined) {
    throw new Error('getEnabledElement: enabledElement element must not be undefined');
  }

  enabledElements.push(enabledElement);
}
/**
 * Adds a Cornerstone Enabled Element object to the central store of enabledElements
 *
 * @param {string} imageId A Cornerstone Image ID
 * @returns {EnabledElement[]} An Array of Cornerstone enabledElement Objects
 * @memberof EnabledElements
 */

function getEnabledElementsByImageId(imageId) {
  var ees = [];
  enabledElements.forEach(function (enabledElement) {
    if (enabledElement.image && enabledElement.image.imageId === imageId) {
      ees.push(enabledElement);
    }
  });
  return ees;
}
/**
 * Retrieve all of the currently enabled Cornerstone elements
 *
 * @return {EnabledElement[]} An Array of Cornerstone enabledElement Objects
 * @memberof EnabledElements
 */

function getEnabledElements() {
  return enabledElements;
}

/***/ }),

/***/ "./events.js":
/*!*******************!*\
  !*** ./events.js ***!
  \*******************/
/*! exports provided: default, events */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "events", function() { return events; });
function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

var EVENTS = {
  NEW_IMAGE: 'cornerstonenewimage',
  INVALIDATED: 'cornerstoneinvalidated',
  PRE_RENDER: 'cornerstoneprerender',
  IMAGE_CACHE_MAXIMUM_SIZE_CHANGED: 'cornerstoneimagecachemaximumsizechanged',
  IMAGE_CACHE_PROMISE_REMOVED: 'cornerstoneimagecachepromiseremoved',
  IMAGE_CACHE_FULL: 'cornerstoneimagecachefull',
  IMAGE_CACHE_CHANGED: 'cornerstoneimagecachechanged',
  WEBGL_TEXTURE_REMOVED: 'cornerstonewebgltextureremoved',
  WEBGL_TEXTURE_CACHE_FULL: 'cornerstonewebgltexturecachefull',
  IMAGE_LOADED: 'cornerstoneimageloaded',
  IMAGE_LOAD_FAILED: 'cornerstoneimageloadfailed',
  ELEMENT_RESIZED: 'cornerstoneelementresized',
  IMAGE_RENDERED: 'cornerstoneimagerendered',
  LAYER_ADDED: 'cornerstonelayeradded',
  LAYER_REMOVED: 'cornerstonelayerremoved',
  ACTIVE_LAYER_CHANGED: 'cornerstoneactivelayerchanged',
  ELEMENT_DISABLED: 'cornerstoneelementdisabled',
  ELEMENT_ENABLED: 'cornerstoneelementenabled'
};
/* harmony default export */ __webpack_exports__["default"] = (EVENTS);
/**
 * EventTarget - Provides the [EventTarget](https://developer.mozilla.org/en-US/docs/Web/API/EventTarget) interface
 *
 * @class
 * @memberof Polyfills
 */

var EventTarget =
/*#__PURE__*/
function () {
  function EventTarget() {
    _classCallCheck(this, EventTarget);

    this.listeners = {};
    this.namespaces = {};
  }

  _createClass(EventTarget, [{
    key: "addEventNamespaceListener",
    value: function addEventNamespaceListener(type, callback) {
      if (type.indexOf('.') <= 0) {
        return;
      }

      this.namespaces[type] = callback;
      this.addEventListener(type.split('.')[0], callback);
    }
  }, {
    key: "removeEventNamespaceListener",
    value: function removeEventNamespaceListener(type) {
      if (type.indexOf('.') <= 0 || !this.namespaces[type]) {
        return;
      }

      this.removeEventListener(type.split('.')[0], this.namespaces[type]);
      delete this.namespaces[type];
    }
  }, {
    key: "addEventListener",
    value: function addEventListener(type, callback) {
      // Check if it is an event namespace
      if (type.indexOf('.') > 0) {
        this.addEventNamespaceListener(type, callback);
        return;
      }

      if (!(type in this.listeners)) {
        this.listeners[type] = [];
      }

      this.listeners[type].push(callback);
    }
  }, {
    key: "removeEventListener",
    value: function removeEventListener(type, callback) {
      // Check if it is an event namespace
      if (type.indexOf('.') > 0) {
        this.removeEventNamespaceListener(type);
        return;
      }

      if (!(type in this.listeners)) {
        return;
      }

      var stack = this.listeners[type];

      for (var i = 0, l = stack.length; i < l; i++) {
        if (stack[i] === callback) {
          stack.splice(i, 1);
          return;
        }
      }
    }
  }, {
    key: "dispatchEvent",
    value: function dispatchEvent(event) {
      if (!(event.type in this.listeners)) {
        return true;
      }

      var stack = this.listeners[event.type];

      for (var i = 0, l = stack.length; i < l; i++) {
        stack[i].call(this, event);
      }

      return !event.defaultPrevented;
    }
  }]);

  return EventTarget;
}();

var events = new EventTarget();

/***/ }),

/***/ "./falseColorMapping.js":
/*!******************************!*\
  !*** ./falseColorMapping.js ***!
  \******************************/
/*! exports provided: convertImageToFalseColorImage, convertToFalseColorImage, restoreImage */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "convertImageToFalseColorImage", function() { return convertImageToFalseColorImage; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "convertToFalseColorImage", function() { return convertToFalseColorImage; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "restoreImage", function() { return restoreImage; });
/* harmony import */ var _enabledElements_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./enabledElements.js */ "./enabledElements.js");
/* harmony import */ var _pixelDataToFalseColorData_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./pixelDataToFalseColorData.js */ "./pixelDataToFalseColorData.js");
/* harmony import */ var _colors_colormap_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./colors/colormap.js */ "./colors/colormap.js");



/**
 * Retrieves the minimum and maximum pixel values from an Array of pixel data
 *
 * @param {Array} pixelData The input pixel data array
 *
 * @returns {{minPixelValue: Number, maxPixelValue: Number}} The minimum and maximum pixel values in the input Array
 */

function getPixelValues(pixelData) {
  var minPixelValue = Number.MAX_VALUE;
  var maxPixelValue = Number.MIN_VALUE;
  var len = pixelData.length;
  var pixel;

  for (var i = 0; i < len; i++) {
    pixel = pixelData[i];
    minPixelValue = minPixelValue < pixel ? minPixelValue : pixel;
    maxPixelValue = maxPixelValue > pixel ? maxPixelValue : pixel;
  }

  return {
    minPixelValue: minPixelValue,
    maxPixelValue: maxPixelValue
  };
}
/**
 * Retrieve a function that will allow an image object to be reset to its original form
 * after a false color mapping transformation
 *
 * @param {Image} image A Cornerstone Image Object
 *
 * @return {Function} A function for resetting an Image Object to its original form
 */


function getRestoreImageMethod(image) {
  if (image.restore) {
    return image.restore;
  }

  var color = image.color;
  var rgba = image.rgba;
  var cachedLut = image.cachedLut;
  var slope = image.slope;
  var windowWidth = image.windowWidth;
  var windowCenter = image.windowCenter;
  var minPixelValue = image.minPixelValue;
  var maxPixelValue = image.maxPixelValue;
  return function () {
    image.color = color;
    image.rgba = rgba;
    image.cachedLut = cachedLut;
    image.slope = slope;
    image.windowWidth = windowWidth;
    image.windowCenter = windowCenter;
    image.minPixelValue = minPixelValue;
    image.maxPixelValue = maxPixelValue;

    if (image.origPixelData) {
      var pixelData = image.origPixelData;

      image.getPixelData = function () {
        return pixelData;
      };
    } // Remove some attributes added by false color mapping


    image.origPixelData = undefined;
    image.colormapId = undefined;
    image.falseColor = undefined;
  };
} //
// Then we need to make sure it will be converted into a colormap object if it's as string.

/**
 * User can pass a colormap or its id as string to some of these public functions.
 * Then we need to make sure it will be converted into a colormap object if it's a string.
 *
 * @param {*} colormap A colormap ID or Object
 * @return {*} The colormap
 */


function ensuresColormap(colormap) {
  if (colormap && typeof colormap === 'string') {
    colormap = Object(_colors_colormap_js__WEBPACK_IMPORTED_MODULE_2__["getColormap"])(colormap);
  }

  return colormap;
}
/**
 * Restores a false color image to its original version
 *
 * @param {Image} image A Cornerstone Image Object
 * @returns {Boolean} True if the image object had a valid restore function, which was run. Otherwise, false.
 */


function restoreImage(image) {
  if (image.restore && typeof image.restore === 'function') {
    image.restore();
    return true;
  }

  return false;
}
/**
 * Convert an image to a false color image
 *
 * @param {Image} image A Cornerstone Image Object
 * @param {String|Object} colormap - it can be a colormap object or a colormap id (string)
 *
 * @returns {Boolean} - Whether or not the image has been converted to a false color image
 */


function convertImageToFalseColorImage(image, colormap) {
  if (image.color && !image.falseColor) {
    throw new Error('Color transforms are not implemented yet');
  } // User can pass a colormap id or a colormap object


  colormap = ensuresColormap(colormap);
  var colormapId = colormap.getId(); // Doesn't do anything if colormapId hasn't changed

  if (image.colormapId === colormapId) {
    // It has already being converted into a false color image
    // Using the colormapId passed as parameter
    return false;
  } // Restore the image attributes updated when converting to a false color image


  restoreImage(image); // Convert the image to a false color image

  if (colormapId) {
    var minPixelValue = image.minPixelValue || 0;
    var maxPixelValue = image.maxPixelValue || 255;
    image.restore = getRestoreImageMethod(image);
    var lookupTable = colormap.createLookupTable();
    lookupTable.setTableRange(minPixelValue, maxPixelValue); // Update the pixel data and render the new image

    Object(_pixelDataToFalseColorData_js__WEBPACK_IMPORTED_MODULE_1__["default"])(image, lookupTable); // Update min and max pixel values

    var pixelValues = getPixelValues(image.getPixelData());
    image.minPixelValue = pixelValues.minPixelValue;
    image.maxPixelValue = pixelValues.maxPixelValue;
    image.windowWidth = 255;
    image.windowCenter = 128; // Cache the last colormapId used for performance
    // Then it doesn't need to be re-rendered on next
    // Time if the user hasn't updated it

    image.colormapId = colormapId;
  } // Return `true` to tell the caller that the image has got updated


  return true;
}
/**
 * Convert the image of a element to a false color image
 *
 * @param {HTMLElement} element The Cornerstone element
 * @param {*} colormap - it can be a colormap object or a colormap id (string)
 *
 * @returns {void}
 */


function convertToFalseColorImage(element, colormap) {
  var enabledElement = Object(_enabledElements_js__WEBPACK_IMPORTED_MODULE_0__["getEnabledElement"])(element);
  return convertImageToFalseColorImage(enabledElement.image, colormap);
}



/***/ }),

/***/ "./fitToWindow.js":
/*!************************!*\
  !*** ./fitToWindow.js ***!
  \************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _enabledElements_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./enabledElements.js */ "./enabledElements.js");
/* harmony import */ var _updateImage_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./updateImage.js */ "./updateImage.js");
/* harmony import */ var _internal_getImageFitScale_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./internal/getImageFitScale.js */ "./internal/getImageFitScale.js");



/**
 * Adjusts an image's scale and translation so the image is centered and all pixels
 * in the image are viewable.
 *
 * @param {HTMLElement} element The Cornerstone element to update
 * @returns {void}
 */

/* harmony default export */ __webpack_exports__["default"] = (function (element) {
  var enabledElement = Object(_enabledElements_js__WEBPACK_IMPORTED_MODULE_0__["getEnabledElement"])(element);
  var image = enabledElement.image; // The new scale is the minimum of the horizontal and vertical scale values

  enabledElement.viewport.scale = Object(_internal_getImageFitScale_js__WEBPACK_IMPORTED_MODULE_2__["default"])(enabledElement.canvas, image, enabledElement.viewport.rotation).scaleFactor;
  enabledElement.viewport.translation.x = 0;
  enabledElement.viewport.translation.y = 0;
  Object(_updateImage_js__WEBPACK_IMPORTED_MODULE_1__["default"])(element);
});

/***/ }),

/***/ "./generateUUID.js":
/*!*************************!*\
  !*** ./generateUUID.js ***!
  \*************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/**
* Generates a UUID for the enabledElement.
*
* @return {String} the UUID.
*/
/* harmony default export */ __webpack_exports__["default"] = (function () {
  // https://stackoverflow.com/a/8809472/9208320 Public Domain/MIT

  /* eslint no-bitwise: ["error", { "allow": ["&","|"] }] */
  var d = new Date().getTime();

  if (typeof performance !== 'undefined' && typeof performance.now === 'function') {
    d += performance.now(); // Use high-precision timer if available
  }

  return 'x.x.x.x.x.x.xxxx.xxx.x.x.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
    var r = (d + Math.random() * 16) % 16 | 0;
    d = Math.floor(d / 16);
    return (c === 'x' ? r : r & 0x3 | 0x8).toString(16);
  });
});

/***/ }),

/***/ "./getDefaultViewportForImage.js":
/*!***************************************!*\
  !*** ./getDefaultViewportForImage.js ***!
  \***************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _enabledElements_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./enabledElements.js */ "./enabledElements.js");
/* harmony import */ var _internal_getDefaultViewport_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./internal/getDefaultViewport.js */ "./internal/getDefaultViewport.js");


/**
 * Returns a default viewport for display the specified image on the specified
 * enabled element.  The default viewport is fit to window
 *
 * @param {HTMLElement} element The DOM element enabled for Cornerstone
 * @param {Image} image A Cornerstone Image Object
 *
 * @returns {Viewport} The default viewport for the image
 */

/* harmony default export */ __webpack_exports__["default"] = (function (element, image) {
  var enabledElement = Object(_enabledElements_js__WEBPACK_IMPORTED_MODULE_0__["getEnabledElement"])(element);
  return Object(_internal_getDefaultViewport_js__WEBPACK_IMPORTED_MODULE_1__["default"])(enabledElement.canvas, image);
});

/***/ }),

/***/ "./getImage.js":
/*!*********************!*\
  !*** ./getImage.js ***!
  \*********************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _enabledElements_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./enabledElements.js */ "./enabledElements.js");

/**
 * Returns the currently displayed image for an element or undefined if no image has
 * been displayed yet
 *
 * @param {HTMLElement} element The DOM element enabled for Cornerstone
 * @returns {Image} The Cornerstone Image Object displayed in this element
 */

/* harmony default export */ __webpack_exports__["default"] = (function (element) {
  var enabledElement = Object(_enabledElements_js__WEBPACK_IMPORTED_MODULE_0__["getEnabledElement"])(element);
  return enabledElement.image;
});

/***/ }),

/***/ "./getPixels.js":
/*!**********************!*\
  !*** ./getPixels.js ***!
  \**********************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _enabledElements_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./enabledElements.js */ "./enabledElements.js");
/* harmony import */ var _getStoredPixels_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./getStoredPixels.js */ "./getStoredPixels.js");
/* harmony import */ var _internal_getModalityLUT_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./internal/getModalityLUT.js */ "./internal/getModalityLUT.js");



/**
 * Retrieves an array of pixels from a rectangular region with modality LUT transformation applied
 *
 * @param {HTMLElement} element The DOM element enabled for Cornerstone
 * @param {Number} x The x coordinate of the top left corner of the sampling rectangle in image coordinates
 * @param {Number} y The y coordinate of the top left corner of the sampling rectangle in image coordinates
 * @param {Number} width The width of the of the sampling rectangle in image coordinates
 * @param {Number} height The height of the of the sampling rectangle in image coordinates
 * @returns {Array} The modality pixel value of the pixels in the sampling rectangle
 */

/* harmony default export */ __webpack_exports__["default"] = (function (element, x, y, width, height) {
  var storedPixels = Object(_getStoredPixels_js__WEBPACK_IMPORTED_MODULE_1__["default"])(element, x, y, width, height);
  var ee = Object(_enabledElements_js__WEBPACK_IMPORTED_MODULE_0__["getEnabledElement"])(element);
  var mlutfn = Object(_internal_getModalityLUT_js__WEBPACK_IMPORTED_MODULE_2__["default"])(ee.image.slope, ee.image.intercept, ee.viewport.modalityLUT);
  return storedPixels.map(mlutfn);
});

/***/ }),

/***/ "./getStoredPixels.js":
/*!****************************!*\
  !*** ./getStoredPixels.js ***!
  \****************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _enabledElements_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./enabledElements.js */ "./enabledElements.js");

/**
 * Retrieves an array of stored pixel values from a rectangular region of an image
 *
 * @param {HTMLElement} element The DOM element enabled for Cornerstone
 * @param {Number} x The x coordinate of the top left corner of the sampling rectangle in image coordinates
 * @param {Number} y The y coordinate of the top left corner of the sampling rectangle in image coordinates
 * @param {Number} width The width of the of the sampling rectangle in image coordinates
 * @param {Number} height The height of the of the sampling rectangle in image coordinates
 * @returns {Array} The stored pixel value of the pixels in the sampling rectangle
 */

/* harmony default export */ __webpack_exports__["default"] = (function (element, x, y, width, height) {
  if (element === undefined) {
    throw new Error('getStoredPixels: parameter element must not be undefined');
  }

  x = Math.round(x);
  y = Math.round(y);
  var enabledElement = Object(_enabledElements_js__WEBPACK_IMPORTED_MODULE_0__["getEnabledElement"])(element);
  var storedPixels = [];
  var index = 0;
  var pixelData = enabledElement.image.getPixelData();

  for (var row = 0; row < height; row++) {
    for (var column = 0; column < width; column++) {
      var spIndex = (row + y) * enabledElement.image.columns + (column + x);
      storedPixels[index++] = pixelData[spIndex];
    }
  }

  return storedPixels;
});

/***/ }),

/***/ "./getViewport.js":
/*!************************!*\
  !*** ./getViewport.js ***!
  \************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _enabledElements_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./enabledElements.js */ "./enabledElements.js");

/**
 * Retrieves the viewport for the specified enabled element
 *
 * @param {HTMLElement} element The DOM element enabled for Cornerstone
 * @returns {Viewport|undefined} The Cornerstone Viewport settings for this element, if they exist. Otherwise, undefined
 * @memberof ViewportSettings
 */

/* harmony default export */ __webpack_exports__["default"] = (function (element) {
  var enabledElement = Object(_enabledElements_js__WEBPACK_IMPORTED_MODULE_0__["getEnabledElement"])(element);
  var viewport = enabledElement.viewport;

  if (viewport === undefined) {
    return;
  } // Return a copy of the viewport


  return Object.assign({}, viewport);
});

/***/ }),

/***/ "./imageCache.js":
/*!***********************!*\
  !*** ./imageCache.js ***!
  \***********************/
/*! exports provided: cachedImages, setMaximumSizeBytes, putImageLoadObject, getImageLoadObject, removeImageLoadObject, getCacheInfo, purgeCache, changeImageIdCacheSize, default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "cachedImages", function() { return cachedImages; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "setMaximumSizeBytes", function() { return setMaximumSizeBytes; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "putImageLoadObject", function() { return putImageLoadObject; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "getImageLoadObject", function() { return getImageLoadObject; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "removeImageLoadObject", function() { return removeImageLoadObject; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "getCacheInfo", function() { return getCacheInfo; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "purgeCache", function() { return purgeCache; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "changeImageIdCacheSize", function() { return changeImageIdCacheSize; });
/* harmony import */ var _events_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./events.js */ "./events.js");
/* harmony import */ var _triggerEvent_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./triggerEvent.js */ "./triggerEvent.js");


/**
 * This module deals with caching images
 * @module ImageCache
 */

var maximumSizeInBytes = 1024 * 1024 * 1024; // 1 GB

var cacheSizeInBytes = 0; // Dictionary of imageId to cachedImage objects

var imageCacheDict = {}; // Array of cachedImage objects

var cachedImages = [];
/** Sets the maximum size of cache and purges cache contents if necessary.
 *
 * @param {number} numBytes The maximun size that the cache should occupy.
 * @returns {void}
 */

function setMaximumSizeBytes(numBytes) {
  if (numBytes === undefined) {
    throw new Error('setMaximumSizeBytes: parameter numBytes must not be undefined');
  }

  if (numBytes.toFixed === undefined) {
    throw new Error('setMaximumSizeBytes: parameter numBytes must be a number');
  }

  maximumSizeInBytes = numBytes;
  Object(_triggerEvent_js__WEBPACK_IMPORTED_MODULE_1__["default"])(_events_js__WEBPACK_IMPORTED_MODULE_0__["events"], _events_js__WEBPACK_IMPORTED_MODULE_0__["default"].IMAGE_CACHE_MAXIMUM_SIZE_CHANGED);
  purgeCacheIfNecessary();
}
/**
 * Purges the cache if size exceeds maximum
 * @returns {void}
 */

function purgeCacheIfNecessary() {
  // If max cache size has not been exceeded, do nothing
  if (cacheSizeInBytes <= maximumSizeInBytes) {
    return;
  } // Cache size has been exceeded, create list of images sorted by timeStamp
  // So we can purge the least recently used image


  function compare(a, b) {
    if (a.timeStamp > b.timeStamp) {
      return -1;
    }

    if (a.timeStamp < b.timeStamp) {
      return 1;
    }

    return 0;
  }

  cachedImages.sort(compare); // Remove images as necessary)

  while (cacheSizeInBytes > maximumSizeInBytes) {
    var lastCachedImage = cachedImages[cachedImages.length - 1];
    var imageId = lastCachedImage.imageId;
    removeImageLoadObject(imageId);
    Object(_triggerEvent_js__WEBPACK_IMPORTED_MODULE_1__["default"])(_events_js__WEBPACK_IMPORTED_MODULE_0__["events"], _events_js__WEBPACK_IMPORTED_MODULE_0__["default"].IMAGE_CACHE_PROMISE_REMOVED, {
      imageId: imageId
    });
  }

  var cacheInfo = getCacheInfo();
  Object(_triggerEvent_js__WEBPACK_IMPORTED_MODULE_1__["default"])(_events_js__WEBPACK_IMPORTED_MODULE_0__["events"], _events_js__WEBPACK_IMPORTED_MODULE_0__["default"].IMAGE_CACHE_FULL, cacheInfo);
}
/**
 * Puts a new image loader into the cache
 *
 * @param {string} imageId ImageId of the image loader
 * @param {Object} imageLoadObject The object that is loading or loaded the image
 * @returns {void}
 */


function putImageLoadObject(imageId, imageLoadObject) {
  if (imageId === undefined) {
    throw new Error('putImageLoadObject: imageId must not be undefined');
  }

  if (imageLoadObject.promise === undefined) {
    throw new Error('putImageLoadObject: imageLoadObject.promise must not be undefined');
  }

  if (imageCacheDict.hasOwnProperty(imageId) === true) {
    throw new Error('putImageLoadObject: imageId already in cache');
  }

  if (imageLoadObject.cancelFn && typeof imageLoadObject.cancelFn !== 'function') {
    throw new Error('putImageLoadObject: imageLoadObject.cancelFn must be a function');
  }

  var cachedImage = {
    loaded: false,
    imageId: imageId,
    sharedCacheKey: undefined,
    // The sharedCacheKey for this imageId.  undefined by default
    imageLoadObject: imageLoadObject,
    timeStamp: Date.now(),
    sizeInBytes: 0
  };
  imageCacheDict[imageId] = cachedImage;
  cachedImages.push(cachedImage);
  imageLoadObject.promise.then(function (image) {
    if (cachedImages.indexOf(cachedImage) === -1) {
      // If the image has been purged before being loaded, we stop here.
      return;
    }

    cachedImage.loaded = true;
    cachedImage.image = image;

    if (image.sizeInBytes === undefined) {
      throw new Error('putImageLoadObject: image.sizeInBytes must not be undefined');
    }

    if (image.sizeInBytes.toFixed === undefined) {
      throw new Error('putImageLoadObject: image.sizeInBytes is not a number');
    }

    cachedImage.sizeInBytes = image.sizeInBytes;
    cacheSizeInBytes += cachedImage.sizeInBytes;
    var eventDetails = {
      action: 'addImage',
      image: cachedImage
    };
    Object(_triggerEvent_js__WEBPACK_IMPORTED_MODULE_1__["default"])(_events_js__WEBPACK_IMPORTED_MODULE_0__["events"], _events_js__WEBPACK_IMPORTED_MODULE_0__["default"].IMAGE_CACHE_CHANGED, eventDetails);
    cachedImage.sharedCacheKey = image.sharedCacheKey;
    purgeCacheIfNecessary();
  }, function () {
    var cachedImage = imageCacheDict[imageId];
    cachedImages.splice(cachedImages.indexOf(cachedImage), 1);
    delete imageCacheDict[imageId];
  });
}
/**
 * Retuns the object that is loading a given imageId
 *
 * @param {string} imageId Image ID
 * @returns {void}
 */

function getImageLoadObject(imageId) {
  if (imageId === undefined) {
    throw new Error('getImageLoadObject: imageId must not be undefined');
  }

  var cachedImage = imageCacheDict[imageId];

  if (cachedImage === undefined) {
    return;
  } // Bump time stamp for cached image


  cachedImage.timeStamp = Date.now();
  return cachedImage.imageLoadObject;
}
/**
 * Removes the image loader associated with a given Id from the cache
 *
 * @param {string} imageId Image ID
 * @returns {void}
 */

function removeImageLoadObject(imageId) {
  if (imageId === undefined) {
    throw new Error('removeImageLoadObject: imageId must not be undefined');
  }

  var cachedImage = imageCacheDict[imageId];

  if (cachedImage === undefined) {
    throw new Error('removeImageLoadObject: imageId was not present in imageCache');
  }

  cachedImages.splice(cachedImages.indexOf(cachedImage), 1);
  cacheSizeInBytes -= cachedImage.sizeInBytes;
  var eventDetails = {
    action: 'deleteImage',
    image: cachedImage
  };
  Object(_triggerEvent_js__WEBPACK_IMPORTED_MODULE_1__["default"])(_events_js__WEBPACK_IMPORTED_MODULE_0__["events"], _events_js__WEBPACK_IMPORTED_MODULE_0__["default"].IMAGE_CACHE_CHANGED, eventDetails);
  decache(cachedImage.imageLoadObject);
  delete imageCacheDict[imageId];
}
/**
 * @typedef {Object} CacheInformation
 * @property {number} maximumSizeInBytes  The maximum size of the cache in bytes
 * @property {number} cacheSizeInBytes Currently occupied space in the cache in bytes
 * @property {number} numberOfImagesCached Number of ImageLoaders in the cache
 * @returns {void}
 */

/**
 * Gets the current state of the cache
 * @returns {void}
 */

function getCacheInfo() {
  return {
    maximumSizeInBytes: maximumSizeInBytes,
    cacheSizeInBytes: cacheSizeInBytes,
    numberOfImagesCached: cachedImages.length
  };
} // This method should only be called by `removeImageLoadObject` because it's
// The one that knows how to deal with shared cache keys and cache size.

/**
 * INTERNAL: Removes and ImageLoader from the cache
 *
 * @param {Object} imageLoadObject Image Loader Object to remove
 * @returns {void}
 */

function decache(imageLoadObject) {
  imageLoadObject.promise.then(function () {
    if (imageLoadObject.decache) {
      imageLoadObject.decache();
    }
  }, function () {
    if (imageLoadObject.decache) {
      imageLoadObject.decache();
    }
  });
}
/**
 * Removes all images from cache
 * @returns {void}
 */


function purgeCache() {
  while (cachedImages.length > 0) {
    var removedCachedImage = cachedImages[0];
    removeImageLoadObject(removedCachedImage.imageId);
  }
}
/**
 * Updates the space than an image is using in the cache
 *
 * @param {string} imageId Image ID
 * @param {number} newCacheSize New image size
 * @returns {void}
 */

function changeImageIdCacheSize(imageId, newCacheSize) {
  var cacheEntry = imageCacheDict[imageId];

  if (cacheEntry) {
    cacheEntry.imageLoadObject.promise.then(function (image) {
      var cacheSizeDifference = newCacheSize - image.sizeInBytes;
      image.sizeInBytes = newCacheSize;
      cacheEntry.sizeInBytes = newCacheSize;
      cacheSizeInBytes += cacheSizeDifference;
      var eventDetails = {
        action: 'changeImageSize',
        image: image
      };
      Object(_triggerEvent_js__WEBPACK_IMPORTED_MODULE_1__["default"])(_events_js__WEBPACK_IMPORTED_MODULE_0__["events"], _events_js__WEBPACK_IMPORTED_MODULE_0__["default"].IMAGE_CACHE_CHANGED, eventDetails);
    });
  }
}
/* harmony default export */ __webpack_exports__["default"] = ({
  imageCache: imageCacheDict,
  cachedImages: cachedImages,
  setMaximumSizeBytes: setMaximumSizeBytes,
  putImageLoadObject: putImageLoadObject,
  getImageLoadObject: getImageLoadObject,
  removeImageLoadObject: removeImageLoadObject,
  getCacheInfo: getCacheInfo,
  purgeCache: purgeCache,
  changeImageIdCacheSize: changeImageIdCacheSize
});

/***/ }),

/***/ "./imageLoader.js":
/*!************************!*\
  !*** ./imageLoader.js ***!
  \************************/
/*! exports provided: loadImage, loadAndCacheImage, registerImageLoader, registerUnknownImageLoader */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "loadImage", function() { return loadImage; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "loadAndCacheImage", function() { return loadAndCacheImage; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "registerImageLoader", function() { return registerImageLoader; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "registerUnknownImageLoader", function() { return registerUnknownImageLoader; });
/* harmony import */ var _imageCache_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./imageCache.js */ "./imageCache.js");
/* harmony import */ var _events_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./events.js */ "./events.js");
/* harmony import */ var _triggerEvent_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./triggerEvent.js */ "./triggerEvent.js");



/**
 * This module deals with ImageLoaders, loading images and caching images
 * @module ImageLoader
 */

var imageLoaders = {};
var unknownImageLoader;
/**
 * Load an image using a registered Cornerstone Image Loader.
 *
 * The image loader that is used will be
 * determined by the image loader scheme matching against the imageId.
 *
 * @param {String} imageId A Cornerstone Image Object's imageId
 * @param {Object} [options] Options to be passed to the Image Loader
 *
 * @returns {ImageLoadObject} An Object which can be used to act after an image is loaded or loading fails
 * @memberof ImageLoader
 */

function loadImageFromImageLoader(imageId, options) {
  var colonIndex = imageId.indexOf(':');
  var scheme = imageId.substring(0, colonIndex);
  var loader = imageLoaders[scheme];

  if (loader === undefined || loader === null) {
    if (unknownImageLoader !== undefined) {
      return unknownImageLoader(imageId);
    }

    throw new Error('loadImageFromImageLoader: no image loader for imageId');
  }

  var imageLoadObject = loader(imageId, options); // Broadcast an image loaded event once the image is loaded

  imageLoadObject.promise.then(function (image) {
    Object(_triggerEvent_js__WEBPACK_IMPORTED_MODULE_2__["default"])(_events_js__WEBPACK_IMPORTED_MODULE_1__["events"], _events_js__WEBPACK_IMPORTED_MODULE_1__["default"].IMAGE_LOADED, {
      image: image
    });
  }, function (error) {
    var errorObject = {
      imageId: imageId,
      error: error
    };
    Object(_triggerEvent_js__WEBPACK_IMPORTED_MODULE_2__["default"])(_events_js__WEBPACK_IMPORTED_MODULE_1__["events"], _events_js__WEBPACK_IMPORTED_MODULE_1__["default"].IMAGE_LOAD_FAILED, errorObject);
  });
  return imageLoadObject;
}
/**
 * Loads an image given an imageId and optional priority and returns a promise which will resolve to
 * the loaded image object or fail if an error occurred.  The loaded image is not stored in the cache.
 *
 * @param {String} imageId A Cornerstone Image Object's imageId
 * @param {Object} [options] Options to be passed to the Image Loader
 *
 * @returns {ImageLoadObject} An Object which can be used to act after an image is loaded or loading fails
 * @memberof ImageLoader
 */


function loadImage(imageId, options) {
  if (imageId === undefined) {
    throw new Error('loadImage: parameter imageId must not be undefined');
  }

  var imageLoadObject = Object(_imageCache_js__WEBPACK_IMPORTED_MODULE_0__["getImageLoadObject"])(imageId);

  if (imageLoadObject !== undefined) {
    return imageLoadObject.promise;
  }

  return loadImageFromImageLoader(imageId, options).promise;
} //

/**
 * Loads an image given an imageId and optional priority and returns a promise which will resolve to
 * the loaded image object or fail if an error occurred. The image is stored in the cache.
 *
 * @param {String} imageId A Cornerstone Image Object's imageId
 * @param {Object} [options] Options to be passed to the Image Loader
 *
 * @returns {ImageLoadObject} Image Loader Object
 * @memberof ImageLoader
 */

function loadAndCacheImage(imageId, options) {
  if (imageId === undefined) {
    throw new Error('loadAndCacheImage: parameter imageId must not be undefined');
  }

  var imageLoadObject = Object(_imageCache_js__WEBPACK_IMPORTED_MODULE_0__["getImageLoadObject"])(imageId);

  if (imageLoadObject !== undefined) {
    return imageLoadObject.promise;
  }

  imageLoadObject = loadImageFromImageLoader(imageId, options);
  Object(_imageCache_js__WEBPACK_IMPORTED_MODULE_0__["putImageLoadObject"])(imageId, imageLoadObject);
  return imageLoadObject.promise;
}
/**
 * Registers an imageLoader plugin with cornerstone for the specified scheme
 *
 * @param {String} scheme The scheme to use for this image loader (e.g. 'dicomweb', 'wadouri', 'http')
 * @param {Function} imageLoader A Cornerstone Image Loader function
 * @returns {void}
 * @memberof ImageLoader
 */

function registerImageLoader(scheme, imageLoader) {
  imageLoaders[scheme] = imageLoader;
}
/**
 * Registers a new unknownImageLoader and returns the previous one
 *
 * @param {Function} imageLoader A Cornerstone Image Loader
 *
 * @returns {Function|Undefined} The previous Unknown Image Loader
 * @memberof ImageLoader
 */

function registerUnknownImageLoader(imageLoader) {
  var oldImageLoader = unknownImageLoader;
  unknownImageLoader = imageLoader;
  return oldImageLoader;
}

/***/ }),

/***/ "./index.js":
/*!******************!*\
  !*** ./index.js ***!
  \******************/
/*! exports provided: drawImage, generateLut, getDefaultViewport, requestAnimationFrame, storedPixelDataToCanvasImageData, storedColorPixelDataToCanvasImageData, storedPixelDataToCanvasImageDataColorLUT, storedPixelDataToCanvasImageDataPseudocolorLUT, internal, renderLabelMapImage, renderPseudoColorImage, renderColorImage, renderGrayscaleImage, renderWebImage, renderToCanvas, canvasToPixel, disable, displayImage, draw, drawInvalidated, enable, getElementData, removeElementData, getEnabledElement, addEnabledElement, getEnabledElementsByImageId, getEnabledElements, addLayer, removeLayer, getLayer, getLayers, getVisibleLayers, setActiveLayer, getActiveLayer, purgeLayers, setLayerImage, fitToWindow, getDefaultViewportForImage, getImage, getPixels, getStoredPixels, getViewport, loadImage, loadAndCacheImage, registerImageLoader, registerUnknownImageLoader, invalidate, invalidateImageId, pageToPixel, pixelToCanvas, reset, resize, setToPixelCoordinateSystem, setViewport, updateImage, pixelDataToFalseColorData, rendering, imageCache, metaData, webGL, colors, convertImageToFalseColorImage, convertToFalseColorImage, restoreImage, EVENTS, events, triggerEvent, default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _internal_drawImage_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./internal/drawImage.js */ "./internal/drawImage.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "drawImage", function() { return _internal_drawImage_js__WEBPACK_IMPORTED_MODULE_0__["default"]; });

/* harmony import */ var _internal_generateLut_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./internal/generateLut.js */ "./internal/generateLut.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "generateLut", function() { return _internal_generateLut_js__WEBPACK_IMPORTED_MODULE_1__["default"]; });

/* harmony import */ var _internal_getDefaultViewport_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./internal/getDefaultViewport.js */ "./internal/getDefaultViewport.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "getDefaultViewport", function() { return _internal_getDefaultViewport_js__WEBPACK_IMPORTED_MODULE_2__["default"]; });

/* harmony import */ var _internal_requestAnimationFrame_js__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ./internal/requestAnimationFrame.js */ "./internal/requestAnimationFrame.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "requestAnimationFrame", function() { return _internal_requestAnimationFrame_js__WEBPACK_IMPORTED_MODULE_3__["default"]; });

/* harmony import */ var _internal_storedPixelDataToCanvasImageData_js__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! ./internal/storedPixelDataToCanvasImageData.js */ "./internal/storedPixelDataToCanvasImageData.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "storedPixelDataToCanvasImageData", function() { return _internal_storedPixelDataToCanvasImageData_js__WEBPACK_IMPORTED_MODULE_4__["default"]; });

/* harmony import */ var _internal_storedColorPixelDataToCanvasImageData_js__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(/*! ./internal/storedColorPixelDataToCanvasImageData.js */ "./internal/storedColorPixelDataToCanvasImageData.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "storedColorPixelDataToCanvasImageData", function() { return _internal_storedColorPixelDataToCanvasImageData_js__WEBPACK_IMPORTED_MODULE_5__["default"]; });

/* harmony import */ var _internal_storedPixelDataToCanvasImageDataColorLUT_js__WEBPACK_IMPORTED_MODULE_6__ = __webpack_require__(/*! ./internal/storedPixelDataToCanvasImageDataColorLUT.js */ "./internal/storedPixelDataToCanvasImageDataColorLUT.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "storedPixelDataToCanvasImageDataColorLUT", function() { return _internal_storedPixelDataToCanvasImageDataColorLUT_js__WEBPACK_IMPORTED_MODULE_6__["default"]; });

/* harmony import */ var _internal_storedPixelDataToCanvasImageDataPseudocolorLUT_js__WEBPACK_IMPORTED_MODULE_7__ = __webpack_require__(/*! ./internal/storedPixelDataToCanvasImageDataPseudocolorLUT.js */ "./internal/storedPixelDataToCanvasImageDataPseudocolorLUT.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "storedPixelDataToCanvasImageDataPseudocolorLUT", function() { return _internal_storedPixelDataToCanvasImageDataPseudocolorLUT_js__WEBPACK_IMPORTED_MODULE_7__["default"]; });

/* harmony import */ var _internal_index_js__WEBPACK_IMPORTED_MODULE_8__ = __webpack_require__(/*! ./internal/index.js */ "./internal/index.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "internal", function() { return _internal_index_js__WEBPACK_IMPORTED_MODULE_8__["default"]; });

/* harmony import */ var _rendering_renderLabelMapImage_js__WEBPACK_IMPORTED_MODULE_9__ = __webpack_require__(/*! ./rendering/renderLabelMapImage.js */ "./rendering/renderLabelMapImage.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "renderLabelMapImage", function() { return _rendering_renderLabelMapImage_js__WEBPACK_IMPORTED_MODULE_9__["renderLabelMapImage"]; });

/* harmony import */ var _rendering_renderPseudoColorImage_js__WEBPACK_IMPORTED_MODULE_10__ = __webpack_require__(/*! ./rendering/renderPseudoColorImage.js */ "./rendering/renderPseudoColorImage.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "renderPseudoColorImage", function() { return _rendering_renderPseudoColorImage_js__WEBPACK_IMPORTED_MODULE_10__["renderPseudoColorImage"]; });

/* harmony import */ var _rendering_renderColorImage_js__WEBPACK_IMPORTED_MODULE_11__ = __webpack_require__(/*! ./rendering/renderColorImage.js */ "./rendering/renderColorImage.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "renderColorImage", function() { return _rendering_renderColorImage_js__WEBPACK_IMPORTED_MODULE_11__["renderColorImage"]; });

/* harmony import */ var _rendering_renderGrayscaleImage_js__WEBPACK_IMPORTED_MODULE_12__ = __webpack_require__(/*! ./rendering/renderGrayscaleImage.js */ "./rendering/renderGrayscaleImage.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "renderGrayscaleImage", function() { return _rendering_renderGrayscaleImage_js__WEBPACK_IMPORTED_MODULE_12__["renderGrayscaleImage"]; });

/* harmony import */ var _rendering_renderWebImage_js__WEBPACK_IMPORTED_MODULE_13__ = __webpack_require__(/*! ./rendering/renderWebImage.js */ "./rendering/renderWebImage.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "renderWebImage", function() { return _rendering_renderWebImage_js__WEBPACK_IMPORTED_MODULE_13__["renderWebImage"]; });

/* harmony import */ var _rendering_renderToCanvas_js__WEBPACK_IMPORTED_MODULE_14__ = __webpack_require__(/*! ./rendering/renderToCanvas.js */ "./rendering/renderToCanvas.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "renderToCanvas", function() { return _rendering_renderToCanvas_js__WEBPACK_IMPORTED_MODULE_14__["default"]; });

/* harmony import */ var _canvasToPixel_js__WEBPACK_IMPORTED_MODULE_15__ = __webpack_require__(/*! ./canvasToPixel.js */ "./canvasToPixel.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "canvasToPixel", function() { return _canvasToPixel_js__WEBPACK_IMPORTED_MODULE_15__["default"]; });

/* harmony import */ var _disable_js__WEBPACK_IMPORTED_MODULE_16__ = __webpack_require__(/*! ./disable.js */ "./disable.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "disable", function() { return _disable_js__WEBPACK_IMPORTED_MODULE_16__["default"]; });

/* harmony import */ var _displayImage_js__WEBPACK_IMPORTED_MODULE_17__ = __webpack_require__(/*! ./displayImage.js */ "./displayImage.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "displayImage", function() { return _displayImage_js__WEBPACK_IMPORTED_MODULE_17__["default"]; });

/* harmony import */ var _draw_js__WEBPACK_IMPORTED_MODULE_18__ = __webpack_require__(/*! ./draw.js */ "./draw.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "draw", function() { return _draw_js__WEBPACK_IMPORTED_MODULE_18__["default"]; });

/* harmony import */ var _drawInvalidated_js__WEBPACK_IMPORTED_MODULE_19__ = __webpack_require__(/*! ./drawInvalidated.js */ "./drawInvalidated.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "drawInvalidated", function() { return _drawInvalidated_js__WEBPACK_IMPORTED_MODULE_19__["default"]; });

/* harmony import */ var _enable_js__WEBPACK_IMPORTED_MODULE_20__ = __webpack_require__(/*! ./enable.js */ "./enable.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "enable", function() { return _enable_js__WEBPACK_IMPORTED_MODULE_20__["default"]; });

/* harmony import */ var _enabledElementData_js__WEBPACK_IMPORTED_MODULE_21__ = __webpack_require__(/*! ./enabledElementData.js */ "./enabledElementData.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "getElementData", function() { return _enabledElementData_js__WEBPACK_IMPORTED_MODULE_21__["getElementData"]; });

/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "removeElementData", function() { return _enabledElementData_js__WEBPACK_IMPORTED_MODULE_21__["removeElementData"]; });

/* harmony import */ var _enabledElements_js__WEBPACK_IMPORTED_MODULE_22__ = __webpack_require__(/*! ./enabledElements.js */ "./enabledElements.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "getEnabledElement", function() { return _enabledElements_js__WEBPACK_IMPORTED_MODULE_22__["getEnabledElement"]; });

/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "addEnabledElement", function() { return _enabledElements_js__WEBPACK_IMPORTED_MODULE_22__["addEnabledElement"]; });

/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "getEnabledElementsByImageId", function() { return _enabledElements_js__WEBPACK_IMPORTED_MODULE_22__["getEnabledElementsByImageId"]; });

/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "getEnabledElements", function() { return _enabledElements_js__WEBPACK_IMPORTED_MODULE_22__["getEnabledElements"]; });

/* harmony import */ var _layers_js__WEBPACK_IMPORTED_MODULE_23__ = __webpack_require__(/*! ./layers.js */ "./layers.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "addLayer", function() { return _layers_js__WEBPACK_IMPORTED_MODULE_23__["addLayer"]; });

/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "removeLayer", function() { return _layers_js__WEBPACK_IMPORTED_MODULE_23__["removeLayer"]; });

/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "getLayer", function() { return _layers_js__WEBPACK_IMPORTED_MODULE_23__["getLayer"]; });

/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "getLayers", function() { return _layers_js__WEBPACK_IMPORTED_MODULE_23__["getLayers"]; });

/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "getVisibleLayers", function() { return _layers_js__WEBPACK_IMPORTED_MODULE_23__["getVisibleLayers"]; });

/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "setActiveLayer", function() { return _layers_js__WEBPACK_IMPORTED_MODULE_23__["setActiveLayer"]; });

/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "getActiveLayer", function() { return _layers_js__WEBPACK_IMPORTED_MODULE_23__["getActiveLayer"]; });

/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "purgeLayers", function() { return _layers_js__WEBPACK_IMPORTED_MODULE_23__["purgeLayers"]; });

/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "setLayerImage", function() { return _layers_js__WEBPACK_IMPORTED_MODULE_23__["setLayerImage"]; });

/* harmony import */ var _fitToWindow_js__WEBPACK_IMPORTED_MODULE_24__ = __webpack_require__(/*! ./fitToWindow.js */ "./fitToWindow.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "fitToWindow", function() { return _fitToWindow_js__WEBPACK_IMPORTED_MODULE_24__["default"]; });

/* harmony import */ var _getDefaultViewportForImage_js__WEBPACK_IMPORTED_MODULE_25__ = __webpack_require__(/*! ./getDefaultViewportForImage.js */ "./getDefaultViewportForImage.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "getDefaultViewportForImage", function() { return _getDefaultViewportForImage_js__WEBPACK_IMPORTED_MODULE_25__["default"]; });

/* harmony import */ var _getImage_js__WEBPACK_IMPORTED_MODULE_26__ = __webpack_require__(/*! ./getImage.js */ "./getImage.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "getImage", function() { return _getImage_js__WEBPACK_IMPORTED_MODULE_26__["default"]; });

/* harmony import */ var _getPixels_js__WEBPACK_IMPORTED_MODULE_27__ = __webpack_require__(/*! ./getPixels.js */ "./getPixels.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "getPixels", function() { return _getPixels_js__WEBPACK_IMPORTED_MODULE_27__["default"]; });

/* harmony import */ var _getStoredPixels_js__WEBPACK_IMPORTED_MODULE_28__ = __webpack_require__(/*! ./getStoredPixels.js */ "./getStoredPixels.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "getStoredPixels", function() { return _getStoredPixels_js__WEBPACK_IMPORTED_MODULE_28__["default"]; });

/* harmony import */ var _getViewport_js__WEBPACK_IMPORTED_MODULE_29__ = __webpack_require__(/*! ./getViewport.js */ "./getViewport.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "getViewport", function() { return _getViewport_js__WEBPACK_IMPORTED_MODULE_29__["default"]; });

/* harmony import */ var _imageLoader_js__WEBPACK_IMPORTED_MODULE_30__ = __webpack_require__(/*! ./imageLoader.js */ "./imageLoader.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "loadImage", function() { return _imageLoader_js__WEBPACK_IMPORTED_MODULE_30__["loadImage"]; });

/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "loadAndCacheImage", function() { return _imageLoader_js__WEBPACK_IMPORTED_MODULE_30__["loadAndCacheImage"]; });

/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "registerImageLoader", function() { return _imageLoader_js__WEBPACK_IMPORTED_MODULE_30__["registerImageLoader"]; });

/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "registerUnknownImageLoader", function() { return _imageLoader_js__WEBPACK_IMPORTED_MODULE_30__["registerUnknownImageLoader"]; });

/* harmony import */ var _invalidate_js__WEBPACK_IMPORTED_MODULE_31__ = __webpack_require__(/*! ./invalidate.js */ "./invalidate.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "invalidate", function() { return _invalidate_js__WEBPACK_IMPORTED_MODULE_31__["default"]; });

/* harmony import */ var _invalidateImageId_js__WEBPACK_IMPORTED_MODULE_32__ = __webpack_require__(/*! ./invalidateImageId.js */ "./invalidateImageId.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "invalidateImageId", function() { return _invalidateImageId_js__WEBPACK_IMPORTED_MODULE_32__["default"]; });

/* harmony import */ var _pageToPixel_js__WEBPACK_IMPORTED_MODULE_33__ = __webpack_require__(/*! ./pageToPixel.js */ "./pageToPixel.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "pageToPixel", function() { return _pageToPixel_js__WEBPACK_IMPORTED_MODULE_33__["default"]; });

/* harmony import */ var _pixelToCanvas_js__WEBPACK_IMPORTED_MODULE_34__ = __webpack_require__(/*! ./pixelToCanvas.js */ "./pixelToCanvas.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "pixelToCanvas", function() { return _pixelToCanvas_js__WEBPACK_IMPORTED_MODULE_34__["default"]; });

/* harmony import */ var _reset_js__WEBPACK_IMPORTED_MODULE_35__ = __webpack_require__(/*! ./reset.js */ "./reset.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "reset", function() { return _reset_js__WEBPACK_IMPORTED_MODULE_35__["default"]; });

/* harmony import */ var _resize_js__WEBPACK_IMPORTED_MODULE_36__ = __webpack_require__(/*! ./resize.js */ "./resize.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "resize", function() { return _resize_js__WEBPACK_IMPORTED_MODULE_36__["default"]; });

/* harmony import */ var _setToPixelCoordinateSystem_js__WEBPACK_IMPORTED_MODULE_37__ = __webpack_require__(/*! ./setToPixelCoordinateSystem.js */ "./setToPixelCoordinateSystem.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "setToPixelCoordinateSystem", function() { return _setToPixelCoordinateSystem_js__WEBPACK_IMPORTED_MODULE_37__["default"]; });

/* harmony import */ var _setViewport_js__WEBPACK_IMPORTED_MODULE_38__ = __webpack_require__(/*! ./setViewport.js */ "./setViewport.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "setViewport", function() { return _setViewport_js__WEBPACK_IMPORTED_MODULE_38__["default"]; });

/* harmony import */ var _updateImage_js__WEBPACK_IMPORTED_MODULE_39__ = __webpack_require__(/*! ./updateImage.js */ "./updateImage.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "updateImage", function() { return _updateImage_js__WEBPACK_IMPORTED_MODULE_39__["default"]; });

/* harmony import */ var _pixelDataToFalseColorData_js__WEBPACK_IMPORTED_MODULE_40__ = __webpack_require__(/*! ./pixelDataToFalseColorData.js */ "./pixelDataToFalseColorData.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "pixelDataToFalseColorData", function() { return _pixelDataToFalseColorData_js__WEBPACK_IMPORTED_MODULE_40__["default"]; });

/* harmony import */ var _rendering_index_js__WEBPACK_IMPORTED_MODULE_41__ = __webpack_require__(/*! ./rendering/index.js */ "./rendering/index.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "rendering", function() { return _rendering_index_js__WEBPACK_IMPORTED_MODULE_41__["default"]; });

/* harmony import */ var _imageCache_js__WEBPACK_IMPORTED_MODULE_42__ = __webpack_require__(/*! ./imageCache.js */ "./imageCache.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "imageCache", function() { return _imageCache_js__WEBPACK_IMPORTED_MODULE_42__["default"]; });

/* harmony import */ var _metaData_js__WEBPACK_IMPORTED_MODULE_43__ = __webpack_require__(/*! ./metaData.js */ "./metaData.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "metaData", function() { return _metaData_js__WEBPACK_IMPORTED_MODULE_43__["default"]; });

/* harmony import */ var _webgl_index_js__WEBPACK_IMPORTED_MODULE_44__ = __webpack_require__(/*! ./webgl/index.js */ "./webgl/index.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "webGL", function() { return _webgl_index_js__WEBPACK_IMPORTED_MODULE_44__["default"]; });

/* harmony import */ var _colors_index_js__WEBPACK_IMPORTED_MODULE_45__ = __webpack_require__(/*! ./colors/index.js */ "./colors/index.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "colors", function() { return _colors_index_js__WEBPACK_IMPORTED_MODULE_45__["default"]; });

/* harmony import */ var _falseColorMapping_js__WEBPACK_IMPORTED_MODULE_46__ = __webpack_require__(/*! ./falseColorMapping.js */ "./falseColorMapping.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "convertImageToFalseColorImage", function() { return _falseColorMapping_js__WEBPACK_IMPORTED_MODULE_46__["convertImageToFalseColorImage"]; });

/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "convertToFalseColorImage", function() { return _falseColorMapping_js__WEBPACK_IMPORTED_MODULE_46__["convertToFalseColorImage"]; });

/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "restoreImage", function() { return _falseColorMapping_js__WEBPACK_IMPORTED_MODULE_46__["restoreImage"]; });

/* harmony import */ var _events_js__WEBPACK_IMPORTED_MODULE_47__ = __webpack_require__(/*! ./events.js */ "./events.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "EVENTS", function() { return _events_js__WEBPACK_IMPORTED_MODULE_47__["default"]; });

/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "events", function() { return _events_js__WEBPACK_IMPORTED_MODULE_47__["events"]; });

/* harmony import */ var _triggerEvent_js__WEBPACK_IMPORTED_MODULE_48__ = __webpack_require__(/*! ./triggerEvent.js */ "./triggerEvent.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "triggerEvent", function() { return _triggerEvent_js__WEBPACK_IMPORTED_MODULE_48__["default"]; });

// Internal (some of these are from old internal/legacy expose)








 // Rendering







/**
 * @module PixelCoordinateSystem
 */

/**
 * @module ViewportSettings
 */



































var cornerstone = {
  drawImage: _internal_drawImage_js__WEBPACK_IMPORTED_MODULE_0__["default"],
  generateLut: _internal_generateLut_js__WEBPACK_IMPORTED_MODULE_1__["default"],
  getDefaultViewport: _internal_getDefaultViewport_js__WEBPACK_IMPORTED_MODULE_2__["default"],
  requestAnimationFrame: _internal_requestAnimationFrame_js__WEBPACK_IMPORTED_MODULE_3__["default"],
  storedPixelDataToCanvasImageData: _internal_storedPixelDataToCanvasImageData_js__WEBPACK_IMPORTED_MODULE_4__["default"],
  storedColorPixelDataToCanvasImageData: _internal_storedColorPixelDataToCanvasImageData_js__WEBPACK_IMPORTED_MODULE_5__["default"],
  storedPixelDataToCanvasImageDataColorLUT: _internal_storedPixelDataToCanvasImageDataColorLUT_js__WEBPACK_IMPORTED_MODULE_6__["default"],
  storedPixelDataToCanvasImageDataPseudocolorLUT: _internal_storedPixelDataToCanvasImageDataPseudocolorLUT_js__WEBPACK_IMPORTED_MODULE_7__["default"],
  internal: _internal_index_js__WEBPACK_IMPORTED_MODULE_8__["default"],
  renderLabelMapImage: _rendering_renderLabelMapImage_js__WEBPACK_IMPORTED_MODULE_9__["renderLabelMapImage"],
  renderPseudoColorImage: _rendering_renderPseudoColorImage_js__WEBPACK_IMPORTED_MODULE_10__["renderPseudoColorImage"],
  renderColorImage: _rendering_renderColorImage_js__WEBPACK_IMPORTED_MODULE_11__["renderColorImage"],
  renderGrayscaleImage: _rendering_renderGrayscaleImage_js__WEBPACK_IMPORTED_MODULE_12__["renderGrayscaleImage"],
  renderWebImage: _rendering_renderWebImage_js__WEBPACK_IMPORTED_MODULE_13__["renderWebImage"],
  renderToCanvas: _rendering_renderToCanvas_js__WEBPACK_IMPORTED_MODULE_14__["default"],
  canvasToPixel: _canvasToPixel_js__WEBPACK_IMPORTED_MODULE_15__["default"],
  disable: _disable_js__WEBPACK_IMPORTED_MODULE_16__["default"],
  displayImage: _displayImage_js__WEBPACK_IMPORTED_MODULE_17__["default"],
  draw: _draw_js__WEBPACK_IMPORTED_MODULE_18__["default"],
  drawInvalidated: _drawInvalidated_js__WEBPACK_IMPORTED_MODULE_19__["default"],
  enable: _enable_js__WEBPACK_IMPORTED_MODULE_20__["default"],
  getElementData: _enabledElementData_js__WEBPACK_IMPORTED_MODULE_21__["getElementData"],
  removeElementData: _enabledElementData_js__WEBPACK_IMPORTED_MODULE_21__["removeElementData"],
  getEnabledElement: _enabledElements_js__WEBPACK_IMPORTED_MODULE_22__["getEnabledElement"],
  addEnabledElement: _enabledElements_js__WEBPACK_IMPORTED_MODULE_22__["addEnabledElement"],
  getEnabledElementsByImageId: _enabledElements_js__WEBPACK_IMPORTED_MODULE_22__["getEnabledElementsByImageId"],
  getEnabledElements: _enabledElements_js__WEBPACK_IMPORTED_MODULE_22__["getEnabledElements"],
  addLayer: _layers_js__WEBPACK_IMPORTED_MODULE_23__["addLayer"],
  removeLayer: _layers_js__WEBPACK_IMPORTED_MODULE_23__["removeLayer"],
  getLayer: _layers_js__WEBPACK_IMPORTED_MODULE_23__["getLayer"],
  getLayers: _layers_js__WEBPACK_IMPORTED_MODULE_23__["getLayers"],
  getVisibleLayers: _layers_js__WEBPACK_IMPORTED_MODULE_23__["getVisibleLayers"],
  setActiveLayer: _layers_js__WEBPACK_IMPORTED_MODULE_23__["setActiveLayer"],
  getActiveLayer: _layers_js__WEBPACK_IMPORTED_MODULE_23__["getActiveLayer"],
  purgeLayers: _layers_js__WEBPACK_IMPORTED_MODULE_23__["purgeLayers"],
  setLayerImage: _layers_js__WEBPACK_IMPORTED_MODULE_23__["setLayerImage"],
  fitToWindow: _fitToWindow_js__WEBPACK_IMPORTED_MODULE_24__["default"],
  getDefaultViewportForImage: _getDefaultViewportForImage_js__WEBPACK_IMPORTED_MODULE_25__["default"],
  getImage: _getImage_js__WEBPACK_IMPORTED_MODULE_26__["default"],
  getPixels: _getPixels_js__WEBPACK_IMPORTED_MODULE_27__["default"],
  getStoredPixels: _getStoredPixels_js__WEBPACK_IMPORTED_MODULE_28__["default"],
  getViewport: _getViewport_js__WEBPACK_IMPORTED_MODULE_29__["default"],
  loadImage: _imageLoader_js__WEBPACK_IMPORTED_MODULE_30__["loadImage"],
  loadAndCacheImage: _imageLoader_js__WEBPACK_IMPORTED_MODULE_30__["loadAndCacheImage"],
  registerImageLoader: _imageLoader_js__WEBPACK_IMPORTED_MODULE_30__["registerImageLoader"],
  registerUnknownImageLoader: _imageLoader_js__WEBPACK_IMPORTED_MODULE_30__["registerUnknownImageLoader"],
  invalidate: _invalidate_js__WEBPACK_IMPORTED_MODULE_31__["default"],
  invalidateImageId: _invalidateImageId_js__WEBPACK_IMPORTED_MODULE_32__["default"],
  pageToPixel: _pageToPixel_js__WEBPACK_IMPORTED_MODULE_33__["default"],
  pixelToCanvas: _pixelToCanvas_js__WEBPACK_IMPORTED_MODULE_34__["default"],
  reset: _reset_js__WEBPACK_IMPORTED_MODULE_35__["default"],
  resize: _resize_js__WEBPACK_IMPORTED_MODULE_36__["default"],
  setToPixelCoordinateSystem: _setToPixelCoordinateSystem_js__WEBPACK_IMPORTED_MODULE_37__["default"],
  setViewport: _setViewport_js__WEBPACK_IMPORTED_MODULE_38__["default"],
  updateImage: _updateImage_js__WEBPACK_IMPORTED_MODULE_39__["default"],
  pixelDataToFalseColorData: _pixelDataToFalseColorData_js__WEBPACK_IMPORTED_MODULE_40__["default"],
  rendering: _rendering_index_js__WEBPACK_IMPORTED_MODULE_41__["default"],
  imageCache: _imageCache_js__WEBPACK_IMPORTED_MODULE_42__["default"],
  metaData: _metaData_js__WEBPACK_IMPORTED_MODULE_43__["default"],
  webGL: _webgl_index_js__WEBPACK_IMPORTED_MODULE_44__["default"],
  colors: _colors_index_js__WEBPACK_IMPORTED_MODULE_45__["default"],
  convertImageToFalseColorImage: _falseColorMapping_js__WEBPACK_IMPORTED_MODULE_46__["convertImageToFalseColorImage"],
  convertToFalseColorImage: _falseColorMapping_js__WEBPACK_IMPORTED_MODULE_46__["convertToFalseColorImage"],
  restoreImage: _falseColorMapping_js__WEBPACK_IMPORTED_MODULE_46__["restoreImage"],
  EVENTS: _events_js__WEBPACK_IMPORTED_MODULE_47__["default"],
  events: _events_js__WEBPACK_IMPORTED_MODULE_47__["events"],
  triggerEvent: _triggerEvent_js__WEBPACK_IMPORTED_MODULE_48__["default"]
};

/* harmony default export */ __webpack_exports__["default"] = (cornerstone);

/***/ }),

/***/ "./internal/calculateTransform.js":
/*!****************************************!*\
  !*** ./internal/calculateTransform.js ***!
  \****************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _transform_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./transform.js */ "./internal/transform.js");

/**
 * Calculate the transform for a Cornerstone enabled element
 *
 * @param {EnabledElement} enabledElement The Cornerstone Enabled Element
 * @param {Number} [scale] The viewport scale
 * @return {Transform} The current transform
 * @memberof Internal
 */

/* harmony default export */ __webpack_exports__["default"] = (function (enabledElement, scale) {
  var transform = new _transform_js__WEBPACK_IMPORTED_MODULE_0__["Transform"](); // Move to center of canvas

  transform.translate(enabledElement.canvas.width / 2, enabledElement.canvas.height / 2); // Apply the rotation before scaling for non square pixels

  var angle = enabledElement.viewport.rotation;

  if (angle !== 0) {
    transform.rotate(angle * Math.PI / 180);
  } // Apply the scale


  var widthScale = enabledElement.viewport.scale;
  var heightScale = enabledElement.viewport.scale;
  var width = enabledElement.viewport.displayedArea.brhc.x - (enabledElement.viewport.displayedArea.tlhc.x - 1);
  var height = enabledElement.viewport.displayedArea.brhc.y - (enabledElement.viewport.displayedArea.tlhc.y - 1);

  if (enabledElement.viewport.displayedArea.presentationSizeMode === 'NONE') {
    if (enabledElement.image.rowPixelSpacing < enabledElement.image.columnPixelSpacing) {
      widthScale *= enabledElement.image.columnPixelSpacing / enabledElement.image.rowPixelSpacing;
    } else if (enabledElement.image.columnPixelSpacing < enabledElement.image.rowPixelSpacing) {
      heightScale *= enabledElement.image.rowPixelSpacing / enabledElement.image.columnPixelSpacing;
    }
  } else {
    // These should be good for "TRUE SIZE" and "MAGNIFY"
    widthScale = enabledElement.viewport.displayedArea.columnPixelSpacing;
    heightScale = enabledElement.viewport.displayedArea.rowPixelSpacing;

    if (enabledElement.viewport.displayedArea.presentationSizeMode === 'SCALE TO FIT') {
      // Fit TRUE IMAGE image (width/height) to window
      var verticalScale = enabledElement.canvas.height / (height * heightScale);
      var horizontalScale = enabledElement.canvas.width / (width * widthScale); // Apply new scale

      widthScale = heightScale = Math.min(horizontalScale, verticalScale);

      if (enabledElement.viewport.displayedArea.rowPixelSpacing < enabledElement.viewport.displayedArea.columnPixelSpacing) {
        widthScale *= enabledElement.viewport.displayedArea.columnPixelSpacing / enabledElement.viewport.displayedArea.rowPixelSpacing;
      } else if (enabledElement.viewport.displayedArea.columnPixelSpacing < enabledElement.viewport.displayedArea.rowPixelSpacing) {
        heightScale *= enabledElement.viewport.displayedArea.rowPixelSpacing / enabledElement.viewport.displayedArea.columnPixelSpacing;
      }
    }
  }

  transform.scale(widthScale, heightScale); // Unrotate to so we can translate unrotated

  if (angle !== 0) {
    transform.rotate(-angle * Math.PI / 180);
  } // Apply the pan offset


  transform.translate(enabledElement.viewport.translation.x, enabledElement.viewport.translation.y); // Rotate again so we can apply general scale

  if (angle !== 0) {
    transform.rotate(angle * Math.PI / 180);
  }

  if (scale !== undefined) {
    // Apply the font scale
    transform.scale(scale, scale);
  } // Apply Flip if required


  if (enabledElement.viewport.hflip) {
    transform.scale(-1, 1);
  }

  if (enabledElement.viewport.vflip) {
    transform.scale(1, -1);
  } // Move back from center of image


  transform.translate(-width / 2, -height / 2);
  return transform;
});

/***/ }),

/***/ "./internal/computeAutoVoi.js":
/*!************************************!*\
  !*** ./internal/computeAutoVoi.js ***!
  \************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return computeAutoVoi; });
/**
 * Computes the VOI to display all the pixels if no VOI LUT data (Window Width/Window Center or voiLUT) exists on the viewport object.
 *
 * @param {Viewport} viewport - Object containing the viewport properties
 * @param {Object} image An Image loaded by a Cornerstone Image Loader
 * @returns {void}
 * @memberof Internal
 */
function computeAutoVoi(viewport, image) {
  if (hasVoi(viewport)) {
    return;
  }

  var maxVoi = image.maxPixelValue * image.slope + image.intercept;
  var minVoi = image.minPixelValue * image.slope + image.intercept;
  var ww = maxVoi - minVoi;
  var wc = (maxVoi + minVoi) / 2;

  if (viewport.voi === undefined) {
    viewport.voi = {
      windowWidth: ww,
      windowCenter: wc
    };
  } else {
    viewport.voi.windowWidth = ww;
    viewport.voi.windowCenter = wc;
  }
}
/**
 * Check if viewport has voi LUT data
 * @param {any} viewport The viewport to check for voi LUT data
 * @returns {Boolean} true viewport has LUT data (Window Width/Window Center or voiLUT). Otherwise, false.
 * @memberof Internal
 */

function hasVoi(viewport) {
  var hasLut = viewport.voiLUT && viewport.voiLUT.lut && viewport.voiLUT.lut.length > 0;
  return hasLut || viewport.voi.windowWidth !== undefined && viewport.voi.windowCenter !== undefined;
}

/***/ }),

/***/ "./internal/drawCompositeImage.js":
/*!****************************************!*\
  !*** ./internal/drawCompositeImage.js ***!
  \****************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _layers_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ../layers.js */ "./layers.js");
/* harmony import */ var _rendering_renderGrayscaleImage_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ../rendering/renderGrayscaleImage.js */ "./rendering/renderGrayscaleImage.js");
/* harmony import */ var _rendering_renderColorImage_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ../rendering/renderColorImage.js */ "./rendering/renderColorImage.js");
/* harmony import */ var _rendering_renderPseudoColorImage_js__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ../rendering/renderPseudoColorImage.js */ "./rendering/renderPseudoColorImage.js");
/* harmony import */ var _rendering_renderLabelMapImage_js__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! ../rendering/renderLabelMapImage.js */ "./rendering/renderLabelMapImage.js");
/* harmony import */ var _setToPixelCoordinateSystem_js__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(/*! ../setToPixelCoordinateSystem.js */ "./setToPixelCoordinateSystem.js");







function getViewportRatio(baseLayer, targetLayer) {
  if (!baseLayer.syncProps) {
    updateLayerSyncProps(baseLayer);
  }

  if (!targetLayer.syncProps) {
    updateLayerSyncProps(targetLayer);
  }

  return targetLayer.syncProps.originalScale / baseLayer.syncProps.originalScale;
}

function updateLayerSyncProps(layer) {
  var syncProps = layer.syncProps || {}; // This is used to keep each of the layers' viewports in sync with the active layer

  syncProps.originalScale = layer.viewport.scale;
  layer.syncProps = syncProps;
} // Sync all viewports based on active layer's viewport


function syncViewports(layers, activeLayer) {
  // If we intend to keep the viewport's scale, translation and rotation in sync,
  // loop through the layers
  layers.forEach(function (layer) {
    // Don't do anything to the active layer
    // Don't do anything if this layer has no viewport
    if (layer === activeLayer || !layer.viewport || !activeLayer.viewport) {
      return;
    }

    if (!layer.syncProps) {
      updateLayerSyncProps(layer);
    }

    var viewportRatio = getViewportRatio(activeLayer, layer); // Update the layer's translation and scale to keep them in sync with the first image
    // based on the ratios between the images

    layer.viewport.scale = activeLayer.viewport.scale * viewportRatio;
    layer.viewport.rotation = activeLayer.viewport.rotation;
    layer.viewport.translation = {
      x: activeLayer.viewport.translation.x / viewportRatio,
      y: activeLayer.viewport.translation.y / viewportRatio
    };
    layer.viewport.hflip = activeLayer.viewport.hflip;
    layer.viewport.vflip = activeLayer.viewport.vflip;
  });
}
/**
 * Internal function to render all layers for a Cornerstone enabled element
 *
 * @param {CanvasRenderingContext2D} context Canvas context to draw upon
 * @param {EnabledElementLayer[]} layers The array of all layers for this enabled element
 * @param {Boolean} invalidated A boolean whether or not this image has been invalidated and must be redrawn
 * @returns {void}
 * @memberof Internal
 */


function renderLayers(context, layers, invalidated) {
  // Loop through each layer and draw it to the canvas
  layers.forEach(function (layer, index) {
    if (!layer.image) {
      return;
    }

    context.save(); // Set the layer's canvas to the pixel coordinate system

    layer.canvas = context.canvas;
    Object(_setToPixelCoordinateSystem_js__WEBPACK_IMPORTED_MODULE_5__["default"])(layer, context); // Render into the layer's canvas

    var colormap = layer.viewport.colormap || layer.options.colormap;
    var labelmap = layer.viewport.labelmap;
    var isInvalid = layer.invalid || invalidated;

    if (colormap && colormap !== '' && labelmap === true) {
      Object(_rendering_renderLabelMapImage_js__WEBPACK_IMPORTED_MODULE_4__["addLabelMapLayer"])(layer, isInvalid);
    } else if (colormap && colormap !== '') {
      Object(_rendering_renderPseudoColorImage_js__WEBPACK_IMPORTED_MODULE_3__["addPseudoColorLayer"])(layer, isInvalid);
    } else if (layer.image.color === true) {
      Object(_rendering_renderColorImage_js__WEBPACK_IMPORTED_MODULE_2__["addColorLayer"])(layer, isInvalid);
    } else {
      // If this is the base layer, use the alpha channel for rendering of the grayscale image
      var useAlphaChannel = index === 0;
      Object(_rendering_renderGrayscaleImage_js__WEBPACK_IMPORTED_MODULE_1__["addGrayscaleLayer"])(layer, isInvalid, useAlphaChannel);
    } // Apply any global opacity settings that have been defined for this layer


    if (layer.options && layer.options.opacity) {
      context.globalAlpha = layer.options.opacity;
    } else {
      context.globalAlpha = 1;
    }

    if (layer.options && layer.options.fillStyle) {
      context.fillStyle = layer.options.fillStyle;
    } // Set the pixelReplication property before drawing from the layer into the
    // composite canvas


    context.imageSmoothingEnabled = !layer.viewport.pixelReplication;
    context.mozImageSmoothingEnabled = context.imageSmoothingEnabled; // Draw from the current layer's canvas onto the enabled element's canvas

    var sx = layer.viewport.displayedArea.tlhc.x - 1;
    var sy = layer.viewport.displayedArea.tlhc.y - 1;
    var width = layer.viewport.displayedArea.brhc.x - sx;
    var height = layer.viewport.displayedArea.brhc.y - sy;
    context.drawImage(layer.canvas, sx, sy, width, height, 0, 0, width, height);
    context.restore();
    layer.invalid = false;
  });
}
/**
 * Internal API function to draw a composite image to a given enabled element
 *
 * @param {EnabledElement} enabledElement An enabled element to draw into
 * @param {Boolean} invalidated - true if pixel data has been invalidated and cached rendering should not be used
 * @returns {void}
 */


/* harmony default export */ __webpack_exports__["default"] = (function (enabledElement, invalidated) {
  var element = enabledElement.element;
  var allLayers = Object(_layers_js__WEBPACK_IMPORTED_MODULE_0__["getLayers"])(element);
  var activeLayer = Object(_layers_js__WEBPACK_IMPORTED_MODULE_0__["getActiveLayer"])(element);
  var visibleLayers = Object(_layers_js__WEBPACK_IMPORTED_MODULE_0__["getVisibleLayers"])(element);
  var resynced = !enabledElement.lastSyncViewportsState && enabledElement.syncViewports; // This state will help us to determine if the user has re-synced the
  // layers allowing us to make a new copy of the viewports

  enabledElement.lastSyncViewportsState = enabledElement.syncViewports; // Stores a copy of all viewports if the user has just synced them then we can use the
  // copies to calculate anything later (ratio, translation offset, rotation offset, etc)

  if (resynced) {
    allLayers.forEach(function (layer) {
      if (layer.viewport) {
        updateLayerSyncProps(layer);
      }
    });
  } // Sync all viewports in case it's activated


  if (enabledElement.syncViewports === true) {
    syncViewports(visibleLayers, activeLayer);
  } // Get the enabled element's canvas so we can draw to it


  var context = enabledElement.canvas.getContext('2d');
  context.setTransform(1, 0, 0, 1, 0, 0); // Clear the canvas

  context.fillStyle = 'black';
  context.fillRect(0, 0, enabledElement.canvas.width, enabledElement.canvas.height); // Render all visible layers

  renderLayers(context, visibleLayers, invalidated);
});

/***/ }),

/***/ "./internal/drawImage.js":
/*!*******************************!*\
  !*** ./internal/drawImage.js ***!
  \*******************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/**
 * Internal API function to draw an image to a given enabled element
 *
 * @param {EnabledElement} enabledElement The Cornerstone Enabled Element to redraw
 * @param {Boolean} [invalidated = false] - true if pixel data has been invalidated and cached rendering should not be used
 * @returns {void}
 * @memberof Internal
 */
/* harmony default export */ __webpack_exports__["default"] = (function (enabledElement) {
  var invalidated = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : false;
  enabledElement.needsRedraw = true;

  if (invalidated) {
    enabledElement.invalid = true;
  }
});

/***/ }),

/***/ "./internal/drawImageSync.js":
/*!***********************************!*\
  !*** ./internal/drawImageSync.js ***!
  \***********************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _now_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./now.js */ "./internal/now.js");
/* harmony import */ var _drawCompositeImage_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./drawCompositeImage.js */ "./internal/drawCompositeImage.js");
/* harmony import */ var _rendering_renderColorImage_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ../rendering/renderColorImage.js */ "./rendering/renderColorImage.js");
/* harmony import */ var _rendering_renderGrayscaleImage_js__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ../rendering/renderGrayscaleImage.js */ "./rendering/renderGrayscaleImage.js");
/* harmony import */ var _rendering_renderPseudoColorImage_js__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! ../rendering/renderPseudoColorImage.js */ "./rendering/renderPseudoColorImage.js");
/* harmony import */ var _rendering_renderLabelMapImage_js__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(/*! ../rendering/renderLabelMapImage.js */ "./rendering/renderLabelMapImage.js");
/* harmony import */ var _triggerEvent_js__WEBPACK_IMPORTED_MODULE_6__ = __webpack_require__(/*! ../triggerEvent.js */ "./triggerEvent.js");
/* harmony import */ var _events_js__WEBPACK_IMPORTED_MODULE_7__ = __webpack_require__(/*! ../events.js */ "./events.js");








/**
 * Draw an image to a given enabled element synchronously
 *
 * @param {EnabledElement} enabledElement An enabled element to draw into
 * @param {Boolean} invalidated - true if pixel data has been invalidated and cached rendering should not be used
 * @returns {void}
 * @memberof Internal
 */

/* harmony default export */ __webpack_exports__["default"] = (function (enabledElement, invalidated) {
  var image = enabledElement.image;
  var element = enabledElement.element;
  var layers = enabledElement.layers || []; // Check if enabledElement can be redrawn

  if (!enabledElement.canvas || !(enabledElement.image || layers.length)) {
    return;
  } // Start measuring the time needed to draw the image/layers


  var start = Object(_now_js__WEBPACK_IMPORTED_MODULE_0__["default"])();
  image.stats = {
    lastGetPixelDataTime: -1.0,
    lastStoredPixelDataToCanvasImageDataTime: -1.0,
    lastPutImageDataTime: -1.0,
    lastRenderTime: -1.0,
    lastLutGenerateTime: -1.0
  };

  if (layers && layers.length) {
    Object(_drawCompositeImage_js__WEBPACK_IMPORTED_MODULE_1__["default"])(enabledElement, invalidated);
  } else if (image) {
    var render = image.render;

    if (!render) {
      if (enabledElement.viewport.colormap && enabledElement.viewport.colormap !== '' && enabledElement.image.labelmap === true) {
        render = _rendering_renderLabelMapImage_js__WEBPACK_IMPORTED_MODULE_5__["renderLabelMapImage"];
      } else if (enabledElement.viewport.colormap && enabledElement.viewport.colormap !== '') {
        render = _rendering_renderPseudoColorImage_js__WEBPACK_IMPORTED_MODULE_4__["renderPseudoColorImage"];
      } else if (image.color) {
        render = _rendering_renderColorImage_js__WEBPACK_IMPORTED_MODULE_2__["renderColorImage"];
      } else {
        render = _rendering_renderGrayscaleImage_js__WEBPACK_IMPORTED_MODULE_3__["renderGrayscaleImage"];
      }
    }

    render(enabledElement, invalidated);
  } // Calculate how long it took to draw the image/layers


  var renderTimeInMs = Object(_now_js__WEBPACK_IMPORTED_MODULE_0__["default"])() - start;
  var eventData = {
    viewport: enabledElement.viewport,
    element: element,
    image: image,
    enabledElement: enabledElement,
    canvasContext: enabledElement.canvas.getContext('2d'),
    renderTimeInMs: renderTimeInMs
  };
  image.stats.lastRenderTime = renderTimeInMs;
  enabledElement.invalid = false;
  enabledElement.needsRedraw = false;
  Object(_triggerEvent_js__WEBPACK_IMPORTED_MODULE_6__["default"])(element, _events_js__WEBPACK_IMPORTED_MODULE_7__["default"].IMAGE_RENDERED, eventData);
});

/***/ }),

/***/ "./internal/generateColorLut.js":
/*!**************************************!*\
  !*** ./internal/generateColorLut.js ***!
  \**************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _getVOILut_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./getVOILut.js */ "./internal/getVOILut.js");

/**
 * Creates a LUT used while rendering to convert stored pixel values to
 * display pixels
 *
 * @param {Image} image A Cornerstone Image Object
 * @param {Number} windowWidth The Window Width
 * @param {Number} windowCenter The Window Center
 * @param {Boolean} invert A boolean describing whether or not the image has been inverted
 * @param {Array} [voiLUT] A Volume of Interest Lookup Table
 *
 * @returns {Uint8ClampedArray} A lookup table to apply to the image
 * @memberof Internal
 */

/* harmony default export */ __webpack_exports__["default"] = (function (image, windowWidth, windowCenter, invert, voiLUT) {
  var maxPixelValue = image.maxPixelValue;
  var minPixelValue = image.minPixelValue;
  var offset = Math.min(minPixelValue, 0);

  if (image.cachedLut === undefined) {
    var length = maxPixelValue - offset + 1;
    image.cachedLut = {};
    image.cachedLut.lutArray = new Uint8ClampedArray(length);
  }

  var lut = image.cachedLut.lutArray;
  var vlutfn = Object(_getVOILut_js__WEBPACK_IMPORTED_MODULE_0__["default"])(windowWidth, windowCenter, voiLUT);

  if (invert === true) {
    for (var storedValue = minPixelValue; storedValue <= maxPixelValue; storedValue++) {
      lut[storedValue + -offset] = 255 - vlutfn(storedValue);
    }
  } else {
    for (var _storedValue = minPixelValue; _storedValue <= maxPixelValue; _storedValue++) {
      lut[_storedValue + -offset] = vlutfn(_storedValue);
    }
  }

  return lut;
});

/***/ }),

/***/ "./internal/generateLut.js":
/*!*********************************!*\
  !*** ./internal/generateLut.js ***!
  \*********************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _getModalityLUT_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./getModalityLUT.js */ "./internal/getModalityLUT.js");
/* harmony import */ var _getVOILut_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./getVOILut.js */ "./internal/getVOILut.js");


/**
 * Creates a LUT used while rendering to convert stored pixel values to
 * display pixels
 *
 * @param {Image} image A Cornerstone Image Object
 * @param {Number} windowWidth The Window Width
 * @param {Number} windowCenter The Window Center
 * @param {Boolean} invert A boolean describing whether or not the image has been inverted
 * @param {Array} [modalityLUT] A modality Lookup Table
 * @param {Array} [voiLUT] A Volume of Interest Lookup Table
 *
 * @returns {Uint8ClampedArray} A lookup table to apply to the image
 * @memberof Internal
 */

/* harmony default export */ __webpack_exports__["default"] = (function (image, windowWidth, windowCenter, invert, modalityLUT, voiLUT) {
  var maxPixelValue = image.maxPixelValue;
  var minPixelValue = image.minPixelValue;
  var offset = Math.min(minPixelValue, 0);

  if (image.cachedLut === undefined) {
    var length = maxPixelValue - offset + 1;
    image.cachedLut = {};
    image.cachedLut.lutArray = new Uint8ClampedArray(length);
  }

  var lut = image.cachedLut.lutArray;
  var mlutfn = Object(_getModalityLUT_js__WEBPACK_IMPORTED_MODULE_0__["default"])(image.slope, image.intercept, modalityLUT);
  var vlutfn = Object(_getVOILut_js__WEBPACK_IMPORTED_MODULE_1__["default"])(windowWidth, windowCenter, voiLUT);

  if (invert === true) {
    for (var storedValue = minPixelValue; storedValue <= maxPixelValue; storedValue++) {
      lut[storedValue + -offset] = 255 - vlutfn(mlutfn(storedValue));
    }
  } else {
    for (var _storedValue = minPixelValue; _storedValue <= maxPixelValue; _storedValue++) {
      lut[_storedValue + -offset] = vlutfn(mlutfn(_storedValue));
    }
  }

  return lut;
});

/***/ }),

/***/ "./internal/getCanvas.js":
/*!*******************************!*\
  !*** ./internal/getCanvas.js ***!
  \*******************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return getCanvas; });
var CANVAS_CSS_CLASS = 'cornerstone-canvas';
/**
 * Create a canvas and append it to the element
 *
 * @param {HTMLElement} element An HTML Element
 * @return {HTMLElement} canvas A Canvas DOM element
 */

function createCanvas(element) {
  var canvas = document.createElement('canvas');
  canvas.style.display = 'block';
  canvas.classList.add(CANVAS_CSS_CLASS);
  element.appendChild(canvas);
  return canvas;
}
/**
 * Create a canvas or returns the one that already exists for a given element
 *
 * @param {HTMLElement} element An HTML Element
 * @return {HTMLElement} canvas A Canvas DOM element
 */


function getCanvas(element) {
  var selector = "canvas.".concat(CANVAS_CSS_CLASS);
  return element.querySelector(selector) || createCanvas(element);
}

/***/ }),

/***/ "./internal/getDefaultViewport.js":
/*!****************************************!*\
  !*** ./internal/getDefaultViewport.js ***!
  \****************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _getImageFitScale_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./getImageFitScale.js */ "./internal/getImageFitScale.js");

/**
 * Creates a new viewport object containing default values
 *
 * @returns {Viewport} viewport object
 * @memberof Internal
 */

function createViewport() {
  var displayedArea = createDefaultDisplayedArea();
  return {
    scale: 1,
    translation: {
      x: 0,
      y: 0
    },
    voi: {
      windowWidth: undefined,
      windowCenter: undefined
    },
    invert: false,
    pixelReplication: false,
    rotation: 0,
    hflip: false,
    vflip: false,
    modalityLUT: undefined,
    voiLUT: undefined,
    colormap: undefined,
    labelmap: false,
    displayedArea: displayedArea
  };
}
/**
 * Creates the default displayed area.
 * C.10.4 Displayed Area Module: This Module describes Attributes required to define a Specified Displayed Area space.
 *
 * @returns {tlhc: {x,y}, brhc: {x, y},rowPixelSpacing: Number, columnPixelSpacing: Number, presentationSizeMode: Number} displayedArea object
 * @memberof Internal
 */


function createDefaultDisplayedArea() {
  return {
    // Top Left Hand Corner
    tlhc: {
      x: 1,
      y: 1
    },
    // Bottom Right Hand Corner
    brhc: {
      x: 1,
      y: 1
    },
    rowPixelSpacing: 1,
    columnPixelSpacing: 1,
    presentationSizeMode: 'NONE'
  };
}
/**
 * Creates a new viewport object containing default values for the image and canvas
 *
 * @param {HTMLElement} canvas A Canvas DOM element
 * @param {Image} image A Cornerstone Image Object
 * @returns {Viewport} viewport object
 * @memberof Internal
 */


/* harmony default export */ __webpack_exports__["default"] = (function (canvas, image) {
  if (canvas === undefined) {
    throw new Error('getDefaultViewport: parameter canvas must not be undefined');
  }

  if (image === undefined) {
    return createViewport();
  } // Fit image to window


  var scale = Object(_getImageFitScale_js__WEBPACK_IMPORTED_MODULE_0__["default"])(canvas, image, 0).scaleFactor;
  return {
    scale: scale,
    translation: {
      x: 0,
      y: 0
    },
    voi: {
      windowWidth: image.windowWidth,
      windowCenter: image.windowCenter
    },
    invert: image.invert,
    pixelReplication: false,
    rotation: 0,
    hflip: false,
    vflip: false,
    modalityLUT: image.modalityLUT,
    voiLUT: image.voiLUT,
    colormap: image.colormap,
    labelmap: Boolean(image.labelmap),
    displayedArea: {
      tlhc: {
        x: 1,
        y: 1
      },
      brhc: {
        x: image.columns,
        y: image.rows
      },
      rowPixelSpacing: image.rowPixelSpacing === undefined ? 1 : image.rowPixelSpacing,
      columnPixelSpacing: image.columnPixelSpacing === undefined ? 1 : image.columnPixelSpacing,
      presentationSizeMode: 'NONE'
    }
  };
});

/***/ }),

/***/ "./internal/getImageFitScale.js":
/*!**************************************!*\
  !*** ./internal/getImageFitScale.js ***!
  \**************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _validator_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./validator.js */ "./internal/validator.js");
/* harmony import */ var _getImageSize_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./getImageSize.js */ "./internal/getImageSize.js");


/**
 * Calculates the horizontal, vertical and minimum scale factor for an image
   @param {{width, height}} windowSize The window size where the image is displayed. This can be any HTML element or structure with a width, height fields (e.g. canvas).
 * @param {any} image The cornerstone image object
 * @param {Number} rotation Optional. The rotation angle of the image.
 * @return {{horizontalScale, verticalScale, scaleFactor}} The calculated horizontal, vertical and minimum scale factor
 * @memberof Internal
 */

/* harmony default export */ __webpack_exports__["default"] = (function (windowSize, image) {
  var rotation = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : null;
  Object(_validator_js__WEBPACK_IMPORTED_MODULE_0__["validateParameterUndefinedOrNull"])(windowSize, 'getImageScale: parameter windowSize must not be undefined');
  Object(_validator_js__WEBPACK_IMPORTED_MODULE_0__["validateParameterUndefinedOrNull"])(image, 'getImageScale: parameter image must not be undefined');
  var imageSize = Object(_getImageSize_js__WEBPACK_IMPORTED_MODULE_1__["default"])(image, rotation);
  var rowPixelSpacing = image.rowPixelSpacing || 1;
  var columnPixelSpacing = image.columnPixelSpacing || 1;
  var verticalRatio = 1;
  var horizontalRatio = 1;

  if (rowPixelSpacing < columnPixelSpacing) {
    horizontalRatio = columnPixelSpacing / rowPixelSpacing;
  } else {
    // even if they are equal we want to calculate this ratio (the ration might be 0.5)
    verticalRatio = rowPixelSpacing / columnPixelSpacing;
  }

  var verticalScale = windowSize.height / imageSize.height / verticalRatio;
  var horizontalScale = windowSize.width / imageSize.width / horizontalRatio; // Fit image to window

  return {
    verticalScale: verticalScale,
    horizontalScale: horizontalScale,
    scaleFactor: Math.min(horizontalScale, verticalScale)
  };
});

/***/ }),

/***/ "./internal/getImageSize.js":
/*!**********************************!*\
  !*** ./internal/getImageSize.js ***!
  \**********************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _validator_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./validator.js */ "./internal/validator.js");

/**
 * Check if the angle is rotated
 * @param {Number} rotation the rotation angle
 * @returns {Boolean} true if the angle is rotated; Otherwise, false.
 * @memberof Internal
 */

function isRotated(rotation) {
  return !(rotation === null || rotation === undefined || rotation === 0 || rotation === 180);
}
/**
 * Retrieves the current image dimensions given an enabled element
 *
 * @param {any} image The Cornerstone image.
 * @param {Number} rotation Optional. The rotation angle of the image.
 * @return {{width:Number, height:Number}} The Image dimensions
 * @memberof Internal
 */


/* harmony default export */ __webpack_exports__["default"] = (function (image) {
  var rotation = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : null;
  Object(_validator_js__WEBPACK_IMPORTED_MODULE_0__["validateParameterUndefinedOrNull"])(image, 'getImageSize: parameter image must not be undefined');
  Object(_validator_js__WEBPACK_IMPORTED_MODULE_0__["validateParameterUndefinedOrNull"])(image.width, 'getImageSize: parameter image must have width');
  Object(_validator_js__WEBPACK_IMPORTED_MODULE_0__["validateParameterUndefinedOrNull"])(image.height, 'getImageSize: parameter image must have height');

  if (isRotated(rotation)) {
    return {
      height: image.width,
      width: image.height
    };
  }

  return {
    width: image.width,
    height: image.height
  };
});

/***/ }),

/***/ "./internal/getModalityLUT.js":
/*!************************************!*\
  !*** ./internal/getModalityLUT.js ***!
  \************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/**
 * Generates a linear modality transformation function
 *
 * See DICOM PS3.3 C.11.1 Modality LUT Module
 *
 * http://dicom.nema.org/medical/Dicom/current/output/chtml/part03/sect_C.11.html
 *
 * @param {Number} slope m in the equation specified by Rescale Intercept (0028,1052).
 * @param {Number} intercept The value b in relationship between stored values (SV) and the output units specified in Rescale Type (0028,1054).

 Output units = m*SV + b.
 * @return {function(*): *} A linear modality LUT function. Given a stored pixel it returns the modality pixel value
 * @memberof Internal
 */
function generateLinearModalityLUT(slope, intercept) {
  return function (storedPixelValue) {
    return storedPixelValue * slope + intercept;
  };
}

function generateNonLinearModalityLUT(modalityLUT) {
  var minValue = modalityLUT.lut[0];
  var maxValue = modalityLUT.lut[modalityLUT.lut.length - 1];
  var maxValueMapped = modalityLUT.firstValueMapped + modalityLUT.lut.length;
  return function (storedPixelValue) {
    if (storedPixelValue < modalityLUT.firstValueMapped) {
      return minValue;
    } else if (storedPixelValue >= maxValueMapped) {
      return maxValue;
    }

    return modalityLUT.lut[storedPixelValue];
  };
}
/**
 * Get the appropriate Modality LUT for the current situation.
 *
 * @param {Number} [slope] m in the equation specified by Rescale Intercept (0028,1052).
 * @param {Number} [intercept] The value b in relationship between stored values (SV) and the output units specified in Rescale Type (0028,1054).
 * @param {Function} [modalityLUT] A modality LUT function. Given a stored pixel it returns the modality pixel value.
 *
 * @return {function(*): *} A modality LUT function. Given a stored pixel it returns the modality pixel value.
 * @memberof Internal
 */


/* harmony default export */ __webpack_exports__["default"] = (function (slope, intercept, modalityLUT) {
  if (modalityLUT) {
    return generateNonLinearModalityLUT(modalityLUT);
  }

  return generateLinearModalityLUT(slope, intercept);
});

/***/ }),

/***/ "./internal/getTransform.js":
/*!**********************************!*\
  !*** ./internal/getTransform.js ***!
  \**********************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _calculateTransform_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./calculateTransform.js */ "./internal/calculateTransform.js");

/* harmony default export */ __webpack_exports__["default"] = (function (enabledElement) {
  // For now we will calculate it every time it is requested.
  // In the future, we may want to cache it in the enabled element to speed things up.
  return Object(_calculateTransform_js__WEBPACK_IMPORTED_MODULE_0__["default"])(enabledElement);
});

/***/ }),

/***/ "./internal/getVOILut.js":
/*!*******************************!*\
  !*** ./internal/getVOILut.js ***!
  \*******************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
function _toConsumableArray(arr) { return _arrayWithoutHoles(arr) || _iterableToArray(arr) || _nonIterableSpread(); }

function _nonIterableSpread() { throw new TypeError("Invalid attempt to spread non-iterable instance"); }

function _iterableToArray(iter) { if (Symbol.iterator in Object(iter) || Object.prototype.toString.call(iter) === "[object Arguments]") return Array.from(iter); }

function _arrayWithoutHoles(arr) { if (Array.isArray(arr)) { for (var i = 0, arr2 = new Array(arr.length); i < arr.length; i++) { arr2[i] = arr[i]; } return arr2; } }

/* eslint no-bitwise: 0 */

/**
 * Volume of Interest Lookup Table Function
 *
 * @typedef {Function} VOILUTFunction
 *
 * @param {Number} modalityLutValue
 * @returns {Number} transformed value
 * @memberof Objects
 */

/**
 * @module: VOILUT
 */

/**
 *
 * @param {Number} windowWidth Window Width
 * @param {Number} windowCenter Window Center
 * @returns {VOILUTFunction} VOI LUT mapping function
 * @memberof VOILUT
 */
function generateLinearVOILUT(windowWidth, windowCenter) {
  return function (modalityLutValue) {
    return ((modalityLutValue - windowCenter) / windowWidth + 0.5) * 255.0;
  };
}
/**
 * Generate a non-linear volume of interest lookup table
 *
 * @param {LUT} voiLUT Volume of Interest Lookup Table Object
 *
 * @returns {VOILUTFunction} VOI LUT mapping function
 * @memberof VOILUT
 */


function generateNonLinearVOILUT(voiLUT) {
  // We don't trust the voiLUT.numBitsPerEntry, mainly thanks to Agfa!
  var bitsPerEntry = Math.max.apply(Math, _toConsumableArray(voiLUT.lut)).toString(2).length;
  var shift = bitsPerEntry - 8;
  var minValue = voiLUT.lut[0] >> shift;
  var maxValue = voiLUT.lut[voiLUT.lut.length - 1] >> shift;
  var maxValueMapped = voiLUT.firstValueMapped + voiLUT.lut.length - 1;
  return function (modalityLutValue) {
    if (modalityLutValue < voiLUT.firstValueMapped) {
      return minValue;
    } else if (modalityLutValue >= maxValueMapped) {
      return maxValue;
    }

    return voiLUT.lut[modalityLutValue - voiLUT.firstValueMapped] >> shift;
  };
}
/**
 * Retrieve a VOI LUT mapping function given the current windowing settings
 * and the VOI LUT for the image
 *
 * @param {Number} windowWidth Window Width
 * @param {Number} windowCenter Window Center
 * @param {LUT} [voiLUT] Volume of Interest Lookup Table Object
 *
 * @return {VOILUTFunction} VOI LUT mapping function
 * @memberof VOILUT
 */


/* harmony default export */ __webpack_exports__["default"] = (function (windowWidth, windowCenter, voiLUT) {
  if (voiLUT) {
    return generateNonLinearVOILUT(voiLUT);
  }

  return generateLinearVOILUT(windowWidth, windowCenter);
});

/***/ }),

/***/ "./internal/guid.js":
/*!**************************!*\
  !*** ./internal/guid.js ***!
  \**************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
function s4() {
  return Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1);
}
/**
 * Generate a unique identifier
 *
 * @return {string} A unique identifier
 * @memberof Internal
 */


/* harmony default export */ __webpack_exports__["default"] = (function () {
  return "".concat(s4() + s4(), "-").concat(s4(), "-").concat(s4(), "-").concat(s4(), "-").concat(s4()).concat(s4()).concat(s4());
});

/***/ }),

/***/ "./internal/index.js":
/*!***************************!*\
  !*** ./internal/index.js ***!
  \***************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _drawImage_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./drawImage.js */ "./internal/drawImage.js");
/* harmony import */ var _generateLut_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./generateLut.js */ "./internal/generateLut.js");
/* harmony import */ var _getDefaultViewport_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./getDefaultViewport.js */ "./internal/getDefaultViewport.js");
/* harmony import */ var _requestAnimationFrame_js__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ./requestAnimationFrame.js */ "./internal/requestAnimationFrame.js");
/* harmony import */ var _storedPixelDataToCanvasImageData_js__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! ./storedPixelDataToCanvasImageData.js */ "./internal/storedPixelDataToCanvasImageData.js");
/* harmony import */ var _storedPixelDataToCanvasImageDataRGBA_js__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(/*! ./storedPixelDataToCanvasImageDataRGBA.js */ "./internal/storedPixelDataToCanvasImageDataRGBA.js");
/* harmony import */ var _storedColorPixelDataToCanvasImageData_js__WEBPACK_IMPORTED_MODULE_6__ = __webpack_require__(/*! ./storedColorPixelDataToCanvasImageData.js */ "./internal/storedColorPixelDataToCanvasImageData.js");
/* harmony import */ var _storedPixelDataToCanvasImageDataColorLUT_js__WEBPACK_IMPORTED_MODULE_7__ = __webpack_require__(/*! ./storedPixelDataToCanvasImageDataColorLUT.js */ "./internal/storedPixelDataToCanvasImageDataColorLUT.js");
/* harmony import */ var _storedPixelDataToCanvasImageDataPseudocolorLUT_js__WEBPACK_IMPORTED_MODULE_8__ = __webpack_require__(/*! ./storedPixelDataToCanvasImageDataPseudocolorLUT.js */ "./internal/storedPixelDataToCanvasImageDataPseudocolorLUT.js");
/* harmony import */ var _getTransform_js__WEBPACK_IMPORTED_MODULE_9__ = __webpack_require__(/*! ./getTransform.js */ "./internal/getTransform.js");
/* harmony import */ var _calculateTransform_js__WEBPACK_IMPORTED_MODULE_10__ = __webpack_require__(/*! ./calculateTransform.js */ "./internal/calculateTransform.js");
/* harmony import */ var _transform_js__WEBPACK_IMPORTED_MODULE_11__ = __webpack_require__(/*! ./transform.js */ "./internal/transform.js");












/**
 * @module Internal
 */

/* harmony default export */ __webpack_exports__["default"] = ({
  drawImage: _drawImage_js__WEBPACK_IMPORTED_MODULE_0__["default"],
  generateLut: _generateLut_js__WEBPACK_IMPORTED_MODULE_1__["default"],
  getDefaultViewport: _getDefaultViewport_js__WEBPACK_IMPORTED_MODULE_2__["default"],
  requestAnimationFrame: _requestAnimationFrame_js__WEBPACK_IMPORTED_MODULE_3__["default"],
  storedPixelDataToCanvasImageData: _storedPixelDataToCanvasImageData_js__WEBPACK_IMPORTED_MODULE_4__["default"],
  storedPixelDataToCanvasImageDataRGBA: _storedPixelDataToCanvasImageDataRGBA_js__WEBPACK_IMPORTED_MODULE_5__["default"],
  storedPixelDataToCanvasImageDataColorLUT: _storedPixelDataToCanvasImageDataColorLUT_js__WEBPACK_IMPORTED_MODULE_7__["default"],
  storedPixelDataToCanvasImageDataPseudocolorLUT: _storedPixelDataToCanvasImageDataPseudocolorLUT_js__WEBPACK_IMPORTED_MODULE_8__["default"],
  storedColorPixelDataToCanvasImageData: _storedColorPixelDataToCanvasImageData_js__WEBPACK_IMPORTED_MODULE_6__["default"],
  getTransform: _getTransform_js__WEBPACK_IMPORTED_MODULE_9__["default"],
  calculateTransform: _calculateTransform_js__WEBPACK_IMPORTED_MODULE_10__["default"],
  Transform: _transform_js__WEBPACK_IMPORTED_MODULE_11__["Transform"]
});

/***/ }),

/***/ "./internal/now.js":
/*!*************************!*\
  !*** ./internal/now.js ***!
  \*************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/**
 * @module Polyfills
 */

/**
 * Use the performance.now() method if possible, and if not, use Date.now()
 *
 * @return {number} Time elapsed since the time origin
 * @memberof Polyfills
 */
/* harmony default export */ __webpack_exports__["default"] = (function () {
  if (window.performance) {
    return performance.now();
  }

  return Date.now();
});

/***/ }),

/***/ "./internal/requestAnimationFrame.js":
/*!*******************************************!*\
  !*** ./internal/requestAnimationFrame.js ***!
  \*******************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
function requestFrame(callback) {
  window.setTimeout(callback, 1000 / 60);
}
/**
 * Polyfills requestAnimationFrame for older browsers.
 *
 * @param {Function} callback A parameter specifying a function to call when it's time to update your animation for the next repaint. The callback has one single argument, a DOMHighResTimeStamp, which indicates the current time (the time returned from performance.now() ) for when requestAnimationFrame starts to fire callbacks.
 *
 * @return {Number} A long integer value, the request id, that uniquely identifies the entry in the callback list. This is a non-zero value, but you may not make any other assumptions about its value. You can pass this value to window.cancelAnimationFrame() to cancel the refresh callback request.
 * @memberof Polyfills
 */


/* harmony default export */ __webpack_exports__["default"] = (function (callback) {
  return window.requestAnimationFrame(callback) || window.webkitRequestAnimationFrame(callback) || window.mozRequestAnimationFrame(callback) || window.oRequestAnimationFrame(callback) || window.msRequestAnimationFrame(callback) || requestFrame(callback);
});

/***/ }),

/***/ "./internal/storedColorPixelDataToCanvasImageData.js":
/*!***********************************************************!*\
  !*** ./internal/storedColorPixelDataToCanvasImageData.js ***!
  \***********************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _now_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./now.js */ "./internal/now.js");

/**
 * Converts stored color pixel values to display pixel values using a LUT.
 *
 * Note: Skips alpha value for any input image pixel data.
 *
 * @param {Image} image A Cornerstone Image Object
 * @param {Array} lut Lookup table array
 * @param {Uint8ClampedArray} canvasImageDataData canvasImageData.data buffer filled with white pixels
 *
 * @returns {void}
 * @memberof Internal
 */

/* harmony default export */ __webpack_exports__["default"] = (function (image, lut, canvasImageDataData) {
  var start = Object(_now_js__WEBPACK_IMPORTED_MODULE_0__["default"])();
  var pixelData = image.getPixelData();
  image.stats.lastGetPixelDataTime = Object(_now_js__WEBPACK_IMPORTED_MODULE_0__["default"])() - start;
  var minPixelValue = image.minPixelValue;
  var canvasImageDataIndex = 0;
  var storedPixelDataIndex = 0;
  var numPixels = pixelData.length; // NOTE: As of Nov 2014, most javascript engines have lower performance when indexing negative indexes.
  // We have a special code path for this case that improves performance.  Thanks to @jpambrun for this enhancement

  start = Object(_now_js__WEBPACK_IMPORTED_MODULE_0__["default"])();

  if (minPixelValue < 0) {
    while (storedPixelDataIndex < numPixels) {
      canvasImageDataData[canvasImageDataIndex++] = lut[pixelData[storedPixelDataIndex++] + -minPixelValue]; // Red

      canvasImageDataData[canvasImageDataIndex++] = lut[pixelData[storedPixelDataIndex++] + -minPixelValue]; // Green

      canvasImageDataData[canvasImageDataIndex] = lut[pixelData[storedPixelDataIndex] + -minPixelValue]; // Blue

      storedPixelDataIndex += 2;
      canvasImageDataIndex += 2;
    }
  } else {
    while (storedPixelDataIndex < numPixels) {
      canvasImageDataData[canvasImageDataIndex++] = lut[pixelData[storedPixelDataIndex++]]; // Red

      canvasImageDataData[canvasImageDataIndex++] = lut[pixelData[storedPixelDataIndex++]]; // Green

      canvasImageDataData[canvasImageDataIndex] = lut[pixelData[storedPixelDataIndex]]; // Blue

      storedPixelDataIndex += 2;
      canvasImageDataIndex += 2;
    }
  }

  image.stats.lastStoredPixelDataToCanvasImageDataTime = Object(_now_js__WEBPACK_IMPORTED_MODULE_0__["default"])() - start;
});

/***/ }),

/***/ "./internal/storedPixelDataToCanvasImageData.js":
/*!******************************************************!*\
  !*** ./internal/storedPixelDataToCanvasImageData.js ***!
  \******************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _now_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./now.js */ "./internal/now.js");

/**
 * This function transforms stored pixel values into a canvas image data buffer
 * by using a LUT.  This is the most performance sensitive code in cornerstone and
 * we use a special trick to make this go as fast as possible.  Specifically we
 * use the alpha channel only to control the luminance rather than the red, green and
 * blue channels which makes it over 3x faster. The canvasImageDataData buffer needs
 * to be previously filled with white pixels.
 *
 * NOTE: Attribution would be appreciated if you use this technique!
 *
 * @param {Image} image A Cornerstone Image Object
 * @param {Array} lut Lookup table array
 * @param {Uint8ClampedArray} canvasImageDataData canvasImageData.data buffer filled with white pixels
 *
 * @returns {void}
 * @memberof Internal
 */

/* harmony default export */ __webpack_exports__["default"] = (function (image, lut, canvasImageDataData) {
  var start = Object(_now_js__WEBPACK_IMPORTED_MODULE_0__["default"])();
  var pixelData = image.getPixelData();
  image.stats.lastGetPixelDataTime = Object(_now_js__WEBPACK_IMPORTED_MODULE_0__["default"])() - start;
  var numPixels = pixelData.length;
  var minPixelValue = image.minPixelValue;
  var canvasImageDataIndex = 3;
  var storedPixelDataIndex = 0; // NOTE: As of Nov 2014, most javascript engines have lower performance when indexing negative indexes.
  // We have a special code path for this case that improves performance.  Thanks to @jpambrun for this enhancement
  // Added two paths (Int16Array, Uint16Array) to avoid polymorphic deoptimization in chrome.

  start = Object(_now_js__WEBPACK_IMPORTED_MODULE_0__["default"])();

  if (pixelData instanceof Int16Array) {
    if (minPixelValue < 0) {
      while (storedPixelDataIndex < numPixels) {
        canvasImageDataData[canvasImageDataIndex] = lut[pixelData[storedPixelDataIndex++] + -minPixelValue]; // Alpha

        canvasImageDataIndex += 4;
      }
    } else {
      while (storedPixelDataIndex < numPixels) {
        canvasImageDataData[canvasImageDataIndex] = lut[pixelData[storedPixelDataIndex++]]; // Alpha

        canvasImageDataIndex += 4;
      }
    }
  } else if (pixelData instanceof Uint16Array) {
    while (storedPixelDataIndex < numPixels) {
      canvasImageDataData[canvasImageDataIndex] = lut[pixelData[storedPixelDataIndex++]]; // Alpha

      canvasImageDataIndex += 4;
    }
  } else if (minPixelValue < 0) {
    while (storedPixelDataIndex < numPixels) {
      canvasImageDataData[canvasImageDataIndex] = lut[pixelData[storedPixelDataIndex++] + -minPixelValue]; // Alpha

      canvasImageDataIndex += 4;
    }
  } else {
    while (storedPixelDataIndex < numPixels) {
      canvasImageDataData[canvasImageDataIndex] = lut[pixelData[storedPixelDataIndex++]]; // Alpha

      canvasImageDataIndex += 4;
    }
  }

  image.stats.lastStoredPixelDataToCanvasImageDataTime = Object(_now_js__WEBPACK_IMPORTED_MODULE_0__["default"])() - start;
});

/***/ }),

/***/ "./internal/storedPixelDataToCanvasImageDataColorLUT.js":
/*!**************************************************************!*\
  !*** ./internal/storedPixelDataToCanvasImageDataColorLUT.js ***!
  \**************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _colors_index_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ../colors/index.js */ "./colors/index.js");
/* harmony import */ var _now_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./now.js */ "./internal/now.js");


/**
 *
 * @param {Image} image A Cornerstone Image Object
 * @param {LookupTable|Array} colorLut Lookup table array
 * @param {Uint8ClampedArray} canvasImageDataData canvasImageData.data buffer filled with white pixels
 *
 * @returns {void}
 * @memberof Internal
 */

function storedPixelDataToCanvasImageDataColorLUT(image, colorLut, canvasImageDataData) {
  var start = Object(_now_js__WEBPACK_IMPORTED_MODULE_1__["default"])();
  var pixelData = image.getPixelData();
  image.stats.lastGetPixelDataTime = Object(_now_js__WEBPACK_IMPORTED_MODULE_1__["default"])() - start;
  var numPixels = pixelData.length;
  var minPixelValue = image.minPixelValue;
  var canvasImageDataIndex = 0;
  var storedPixelDataIndex = 0;
  var rgba;
  var clut;
  start = Object(_now_js__WEBPACK_IMPORTED_MODULE_1__["default"])();

  if (colorLut instanceof _colors_index_js__WEBPACK_IMPORTED_MODULE_0__["default"].LookupTable) {
    clut = colorLut.Table;
  } else {
    clut = colorLut;
  }

  if (minPixelValue < 0) {
    while (storedPixelDataIndex < numPixels) {
      rgba = clut[pixelData[storedPixelDataIndex++] + -minPixelValue];
      canvasImageDataData[canvasImageDataIndex++] = rgba[0];
      canvasImageDataData[canvasImageDataIndex++] = rgba[1];
      canvasImageDataData[canvasImageDataIndex++] = rgba[2];
      canvasImageDataData[canvasImageDataIndex++] = rgba[3];
    }
  } else {
    while (storedPixelDataIndex < numPixels) {
      rgba = clut[pixelData[storedPixelDataIndex++]];
      canvasImageDataData[canvasImageDataIndex++] = rgba[0];
      canvasImageDataData[canvasImageDataIndex++] = rgba[1];
      canvasImageDataData[canvasImageDataIndex++] = rgba[2];
      canvasImageDataData[canvasImageDataIndex++] = rgba[3];
    }
  }

  image.stats.lastStoredPixelDataToCanvasImageDataTime = Object(_now_js__WEBPACK_IMPORTED_MODULE_1__["default"])() - start;
}

/* harmony default export */ __webpack_exports__["default"] = (storedPixelDataToCanvasImageDataColorLUT);

/***/ }),

/***/ "./internal/storedPixelDataToCanvasImageDataPseudocolorLUT.js":
/*!********************************************************************!*\
  !*** ./internal/storedPixelDataToCanvasImageDataPseudocolorLUT.js ***!
  \********************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _colors_index_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ../colors/index.js */ "./colors/index.js");
/* harmony import */ var _now_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./now.js */ "./internal/now.js");


/**
 *
 * @param {Image} image A Cornerstone Image Object
 * @param {Array} grayscaleLut Lookup table array
 * @param {LookupTable|Array} colorLut Lookup table array
 * @param {Uint8ClampedArray} canvasImageDataData canvasImageData.data buffer filled with white pixels
 *
 * @returns {void}
 * @memberof Internal
 */

function storedPixelDataToCanvasImageDataPseudocolorLUT(image, grayscaleLut, colorLut, canvasImageDataData) {
  var start = Object(_now_js__WEBPACK_IMPORTED_MODULE_1__["default"])();
  var pixelData = image.getPixelData();
  image.stats.lastGetPixelDataTime = Object(_now_js__WEBPACK_IMPORTED_MODULE_1__["default"])() - start;
  var numPixels = pixelData.length;
  var minPixelValue = image.minPixelValue;
  var canvasImageDataIndex = 0;
  var storedPixelDataIndex = 0;
  var grayscale;
  var rgba;
  var clut;
  start = Object(_now_js__WEBPACK_IMPORTED_MODULE_1__["default"])();

  if (colorLut instanceof _colors_index_js__WEBPACK_IMPORTED_MODULE_0__["default"].LookupTable) {
    clut = colorLut.Table;
  } else {
    clut = colorLut;
  }

  if (minPixelValue < 0) {
    while (storedPixelDataIndex < numPixels) {
      grayscale = grayscaleLut[pixelData[storedPixelDataIndex++] + -minPixelValue];
      rgba = clut[grayscale];
      canvasImageDataData[canvasImageDataIndex++] = rgba[0];
      canvasImageDataData[canvasImageDataIndex++] = rgba[1];
      canvasImageDataData[canvasImageDataIndex++] = rgba[2];
      canvasImageDataData[canvasImageDataIndex++] = rgba[3];
    }
  } else {
    while (storedPixelDataIndex < numPixels) {
      grayscale = grayscaleLut[pixelData[storedPixelDataIndex++]];
      rgba = clut[grayscale];
      canvasImageDataData[canvasImageDataIndex++] = rgba[0];
      canvasImageDataData[canvasImageDataIndex++] = rgba[1];
      canvasImageDataData[canvasImageDataIndex++] = rgba[2];
      canvasImageDataData[canvasImageDataIndex++] = rgba[3];
    }
  }

  image.stats.lastStoredPixelDataToCanvasImageDataTime = Object(_now_js__WEBPACK_IMPORTED_MODULE_1__["default"])() - start;
}

/* harmony default export */ __webpack_exports__["default"] = (storedPixelDataToCanvasImageDataPseudocolorLUT);

/***/ }),

/***/ "./internal/storedPixelDataToCanvasImageDataRGBA.js":
/*!**********************************************************!*\
  !*** ./internal/storedPixelDataToCanvasImageDataRGBA.js ***!
  \**********************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _now_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./now.js */ "./internal/now.js");

/**
 * This function transforms stored pixel values into a canvas image data buffer
 * by using a LUT.
 *
 * @param {Image} image A Cornerstone Image Object
 * @param {Array} lut Lookup table array
 * @param {Uint8ClampedArray} canvasImageDataData canvasImageData.data buffer filled with white pixels
 *
 * @returns {void}
 * @memberof Internal
 */

/* harmony default export */ __webpack_exports__["default"] = (function (image, lut, canvasImageDataData) {
  var start = Object(_now_js__WEBPACK_IMPORTED_MODULE_0__["default"])();
  var pixelData = image.getPixelData();
  image.stats.lastGetPixelDataTime = Object(_now_js__WEBPACK_IMPORTED_MODULE_0__["default"])() - start;
  var numPixels = pixelData.length;
  var minPixelValue = image.minPixelValue;
  var canvasImageDataIndex = 0;
  var storedPixelDataIndex = 0;
  var pixelValue; // NOTE: As of Nov 2014, most javascript engines have lower performance when indexing negative indexes.
  // We have a special code path for this case that improves performance.  Thanks to @jpambrun for this enhancement
  // Added two paths (Int16Array, Uint16Array) to avoid polymorphic deoptimization in chrome.

  start = Object(_now_js__WEBPACK_IMPORTED_MODULE_0__["default"])();

  if (pixelData instanceof Int16Array) {
    if (minPixelValue < 0) {
      while (storedPixelDataIndex < numPixels) {
        pixelValue = lut[pixelData[storedPixelDataIndex++] + -minPixelValue];
        canvasImageDataData[canvasImageDataIndex++] = pixelValue;
        canvasImageDataData[canvasImageDataIndex++] = pixelValue;
        canvasImageDataData[canvasImageDataIndex++] = pixelValue;
        canvasImageDataData[canvasImageDataIndex++] = 255; // Alpha
      }
    } else {
      while (storedPixelDataIndex < numPixels) {
        pixelValue = lut[pixelData[storedPixelDataIndex++]];
        canvasImageDataData[canvasImageDataIndex++] = pixelValue;
        canvasImageDataData[canvasImageDataIndex++] = pixelValue;
        canvasImageDataData[canvasImageDataIndex++] = pixelValue;
        canvasImageDataData[canvasImageDataIndex++] = 255; // Alpha
      }
    }
  } else if (pixelData instanceof Uint16Array) {
    while (storedPixelDataIndex < numPixels) {
      pixelValue = lut[pixelData[storedPixelDataIndex++]];
      canvasImageDataData[canvasImageDataIndex++] = pixelValue;
      canvasImageDataData[canvasImageDataIndex++] = pixelValue;
      canvasImageDataData[canvasImageDataIndex++] = pixelValue;
      canvasImageDataData[canvasImageDataIndex++] = 255; // Alpha
    }
  } else if (minPixelValue < 0) {
    while (storedPixelDataIndex < numPixels) {
      pixelValue = lut[pixelData[storedPixelDataIndex++] + -minPixelValue];
      canvasImageDataData[canvasImageDataIndex++] = pixelValue;
      canvasImageDataData[canvasImageDataIndex++] = pixelValue;
      canvasImageDataData[canvasImageDataIndex++] = pixelValue;
      canvasImageDataData[canvasImageDataIndex++] = 255; // Alpha
    }
  } else {
    while (storedPixelDataIndex < numPixels) {
      pixelValue = lut[pixelData[storedPixelDataIndex++]];
      canvasImageDataData[canvasImageDataIndex++] = pixelValue;
      canvasImageDataData[canvasImageDataIndex++] = pixelValue;
      canvasImageDataData[canvasImageDataIndex++] = pixelValue;
      canvasImageDataData[canvasImageDataIndex++] = 255; // Alpha
    }
  }

  image.stats.lastStoredPixelDataToCanvasImageDataTime = Object(_now_js__WEBPACK_IMPORTED_MODULE_0__["default"])() - start;
});

/***/ }),

/***/ "./internal/storedRGBAPixelDataToCanvasImageData.js":
/*!**********************************************************!*\
  !*** ./internal/storedRGBAPixelDataToCanvasImageData.js ***!
  \**********************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _now_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./now.js */ "./internal/now.js");

/**
 * Converts stored RGBA color pixel values to display pixel values using a LUT.
 *
 * @param {Image} image A Cornerstone Image Object
 * @param {Array} lut Lookup table array
 * @param {Uint8ClampedArray} canvasImageDataData canvasImageData.data buffer filled with white pixels
 *
 * @returns {void}
 * @memberof Internal
 */

/* harmony default export */ __webpack_exports__["default"] = (function (image, lut, canvasImageDataData) {
  var start = Object(_now_js__WEBPACK_IMPORTED_MODULE_0__["default"])();
  var pixelData = image.getPixelData();
  image.stats.lastGetPixelDataTime = Object(_now_js__WEBPACK_IMPORTED_MODULE_0__["default"])() - start;
  var minPixelValue = image.minPixelValue;
  var canvasImageDataIndex = 0;
  var storedPixelDataIndex = 0;
  var numPixels = pixelData.length; // NOTE: As of Nov 2014, most javascript engines have lower performance when indexing negative indexes.
  // We have a special code path for this case that improves performance.  Thanks to @jpambrun for this enhancement

  start = Object(_now_js__WEBPACK_IMPORTED_MODULE_0__["default"])();

  if (minPixelValue < 0) {
    while (storedPixelDataIndex < numPixels) {
      canvasImageDataData[canvasImageDataIndex++] = lut[pixelData[storedPixelDataIndex++] + -minPixelValue]; // Red

      canvasImageDataData[canvasImageDataIndex++] = lut[pixelData[storedPixelDataIndex++] + -minPixelValue]; // Green

      canvasImageDataData[canvasImageDataIndex++] = lut[pixelData[storedPixelDataIndex++] + -minPixelValue]; // Blue

      canvasImageDataData[canvasImageDataIndex++] = pixelData[storedPixelDataIndex++];
    }
  } else {
    while (storedPixelDataIndex < numPixels) {
      canvasImageDataData[canvasImageDataIndex++] = lut[pixelData[storedPixelDataIndex++]]; // Red

      canvasImageDataData[canvasImageDataIndex++] = lut[pixelData[storedPixelDataIndex++]]; // Green

      canvasImageDataData[canvasImageDataIndex++] = lut[pixelData[storedPixelDataIndex++]]; // Blue

      canvasImageDataData[canvasImageDataIndex++] = pixelData[storedPixelDataIndex++];
    }
  }

  image.stats.lastStoredPixelDataToCanvasImageDataTime = Object(_now_js__WEBPACK_IMPORTED_MODULE_0__["default"])() - start;
});

/***/ }),

/***/ "./internal/transform.js":
/*!*******************************!*\
  !*** ./internal/transform.js ***!
  \*******************************/
/*! exports provided: Transform */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "Transform", function() { return Transform; });
function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

// By Simon Sarris
// Www.simonsarris.com
// Sarris@acm.org
//
// Free to use and distribute at will
// So long as you are nice to people, etc
// Simple class for keeping track of the current transformation matrix
// For instance:
//    Var t = new Transform();
//    T.rotate(5);
//    Var m = t.m;
//    Ctx.setTransform(m[0], m[1], m[2], m[3], m[4], m[5]);
// Is equivalent to:
//    Ctx.rotate(5);
// But now you can retrieve it :)
// Remember that this does not account for any CSS transforms applied to the canvas
var Transform =
/*#__PURE__*/
function () {
  function Transform() {
    _classCallCheck(this, Transform);

    this.reset();
  }

  _createClass(Transform, [{
    key: "reset",
    value: function reset() {
      this.m = [1, 0, 0, 1, 0, 0];
    }
  }, {
    key: "clone",
    value: function clone() {
      var transform = new Transform();
      transform.m[0] = this.m[0];
      transform.m[1] = this.m[1];
      transform.m[2] = this.m[2];
      transform.m[3] = this.m[3];
      transform.m[4] = this.m[4];
      transform.m[5] = this.m[5];
      return transform;
    }
  }, {
    key: "multiply",
    value: function multiply(matrix) {
      var m11 = this.m[0] * matrix.m[0] + this.m[2] * matrix.m[1];
      var m12 = this.m[1] * matrix.m[0] + this.m[3] * matrix.m[1];
      var m21 = this.m[0] * matrix.m[2] + this.m[2] * matrix.m[3];
      var m22 = this.m[1] * matrix.m[2] + this.m[3] * matrix.m[3];
      var dx = this.m[0] * matrix.m[4] + this.m[2] * matrix.m[5] + this.m[4];
      var dy = this.m[1] * matrix.m[4] + this.m[3] * matrix.m[5] + this.m[5];
      this.m[0] = m11;
      this.m[1] = m12;
      this.m[2] = m21;
      this.m[3] = m22;
      this.m[4] = dx;
      this.m[5] = dy;
    }
  }, {
    key: "invert",
    value: function invert() {
      var d = 1 / (this.m[0] * this.m[3] - this.m[1] * this.m[2]);
      var m0 = this.m[3] * d;
      var m1 = -this.m[1] * d;
      var m2 = -this.m[2] * d;
      var m3 = this.m[0] * d;
      var m4 = d * (this.m[2] * this.m[5] - this.m[3] * this.m[4]);
      var m5 = d * (this.m[1] * this.m[4] - this.m[0] * this.m[5]);
      this.m[0] = m0;
      this.m[1] = m1;
      this.m[2] = m2;
      this.m[3] = m3;
      this.m[4] = m4;
      this.m[5] = m5;
    }
  }, {
    key: "rotate",
    value: function rotate(rad) {
      var c = Math.cos(rad);
      var s = Math.sin(rad);
      var m11 = this.m[0] * c + this.m[2] * s;
      var m12 = this.m[1] * c + this.m[3] * s;
      var m21 = this.m[0] * -s + this.m[2] * c;
      var m22 = this.m[1] * -s + this.m[3] * c;
      this.m[0] = m11;
      this.m[1] = m12;
      this.m[2] = m21;
      this.m[3] = m22;
    }
  }, {
    key: "translate",
    value: function translate(x, y) {
      this.m[4] += this.m[0] * x + this.m[2] * y;
      this.m[5] += this.m[1] * x + this.m[3] * y;
    }
  }, {
    key: "scale",
    value: function scale(sx, sy) {
      this.m[0] *= sx;
      this.m[1] *= sx;
      this.m[2] *= sy;
      this.m[3] *= sy;
    }
  }, {
    key: "transformPoint",
    value: function transformPoint(px, py) {
      var x = px;
      var y = py;
      px = x * this.m[0] + y * this.m[2] + this.m[4];
      py = x * this.m[1] + y * this.m[3] + this.m[5];
      return {
        x: px,
        y: py
      };
    }
  }]);

  return Transform;
}();

/***/ }),

/***/ "./internal/tryEnableWebgl.js":
/*!************************************!*\
  !*** ./internal/tryEnableWebgl.js ***!
  \************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _webgl_index_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ../webgl/index.js */ "./webgl/index.js");

/**
 * Checks if webGL is supported and initializes the rendering engine.
 * @param {any} options Options to check if webgl rendering is requested (e.g. enable webgl by passing {renderer: 'webgl'})
 * @returns {Boolean} true if webgl rendering has been successfully initialized. Otherwise, false.
 */

/* harmony default export */ __webpack_exports__["default"] = (function (options) {
  if (_webgl_index_js__WEBPACK_IMPORTED_MODULE_0__["default"].renderer.isWebGLAvailable()) {
    // If WebGL is available on the device, initialize the renderer
    // And return the renderCanvas from the WebGL rendering path
    _webgl_index_js__WEBPACK_IMPORTED_MODULE_0__["default"].renderer.initRenderer();
    options.renderer = 'webgl';
    return true;
  } // If WebGL is not available on this device, we will fall back
  // To using the Canvas renderer


  console.error('WebGL not available, falling back to Canvas renderer');
  delete options.renderer;
  return false;
});

/***/ }),

/***/ "./internal/validator.js":
/*!*******************************!*\
  !*** ./internal/validator.js ***!
  \*******************************/
/*! exports provided: validateParameterUndefined, validateParameterUndefinedOrNull */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "validateParameterUndefined", function() { return validateParameterUndefined; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "validateParameterUndefinedOrNull", function() { return validateParameterUndefinedOrNull; });
/**
 * Check if the supplied parameter is undefined and throws and error
 * @param {any} checkParam the parameter to validate for undefined
 * @param {any} errorMsg the error message to be thrown
 * @returns {void}
 * @memberof internal
 */
function validateParameterUndefined(checkParam, errorMsg) {
  if (checkParam === undefined) {
    throw new Error(errorMsg);
  }
}
/**
 * Check if the supplied parameter is undefined or null and throws and error
 * @param {any} checkParam the parameter to validate for undefined
 * @param {any} errorMsg the error message to be thrown
 * @returns {void}
 * @memberof internal
 */

function validateParameterUndefinedOrNull(checkParam, errorMsg) {
  if (checkParam === undefined || checkParam === null) {
    throw new Error(errorMsg);
  }
}

/***/ }),

/***/ "./invalidate.js":
/*!***********************!*\
  !*** ./invalidate.js ***!
  \***********************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _enabledElements_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./enabledElements.js */ "./enabledElements.js");
/* harmony import */ var _triggerEvent_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./triggerEvent.js */ "./triggerEvent.js");
/* harmony import */ var _events_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./events.js */ "./events.js");



/**
 * Sets the invalid flag on the enabled element and fire an event
 * @param {HTMLElement} element The DOM element enabled for Cornerstone
 * @returns {void}
 * @memberof Drawing
 */

/* harmony default export */ __webpack_exports__["default"] = (function (element) {
  var enabledElement = Object(_enabledElements_js__WEBPACK_IMPORTED_MODULE_0__["getEnabledElement"])(element);
  enabledElement.invalid = true;
  enabledElement.needsRedraw = true;
  var eventData = {
    element: element
  };
  Object(_triggerEvent_js__WEBPACK_IMPORTED_MODULE_1__["default"])(element, _events_js__WEBPACK_IMPORTED_MODULE_2__["default"].INVALIDATED, eventData);
});

/***/ }),

/***/ "./invalidateImageId.js":
/*!******************************!*\
  !*** ./invalidateImageId.js ***!
  \******************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _enabledElements_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./enabledElements.js */ "./enabledElements.js");
/* harmony import */ var _internal_drawImage_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./internal/drawImage.js */ "./internal/drawImage.js");


/**
 * Forces the image to be updated/redrawn for the all enabled elements
 * displaying the specified imageId
 *
 * @param {string} imageId The imageId of the Cornerstone Image Object to redraw
 * @returns {void}
 * @memberof Drawing
 */

/* harmony default export */ __webpack_exports__["default"] = (function (imageId) {
  var enabledElements = Object(_enabledElements_js__WEBPACK_IMPORTED_MODULE_0__["getEnabledElementsByImageId"])(imageId);
  enabledElements.forEach(function (enabledElement) {
    Object(_internal_drawImage_js__WEBPACK_IMPORTED_MODULE_1__["default"])(enabledElement, true);
  });
});

/***/ }),

/***/ "./layers.js":
/*!*******************!*\
  !*** ./layers.js ***!
  \*******************/
/*! exports provided: rescaleImage, addLayer, removeLayer, getLayer, getLayers, getVisibleLayers, setActiveLayer, setLayerImage, getActiveLayer, purgeLayers */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "rescaleImage", function() { return rescaleImage; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "addLayer", function() { return addLayer; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "removeLayer", function() { return removeLayer; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "getLayer", function() { return getLayer; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "getLayers", function() { return getLayers; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "getVisibleLayers", function() { return getVisibleLayers; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "setActiveLayer", function() { return setActiveLayer; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "setLayerImage", function() { return setLayerImage; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "getActiveLayer", function() { return getActiveLayer; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "purgeLayers", function() { return purgeLayers; });
/* harmony import */ var _internal_guid_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./internal/guid.js */ "./internal/guid.js");
/* harmony import */ var _enabledElements_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./enabledElements.js */ "./enabledElements.js");
/* harmony import */ var _internal_getDefaultViewport_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./internal/getDefaultViewport.js */ "./internal/getDefaultViewport.js");
/* harmony import */ var _updateImage_js__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ./updateImage.js */ "./updateImage.js");
/* harmony import */ var _triggerEvent_js__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! ./triggerEvent.js */ "./triggerEvent.js");
/* harmony import */ var _events_js__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(/*! ./events.js */ "./events.js");






/**
 * @module EnabledElementLayers
 */

/**
 * Helper function to trigger an event on a Cornerstone element with
 * a specific layerId
 *
 * @param {String} eventName The event name (e.g. CornerstoneLayerAdded)
 * @param {EnabledElement} enabledElement The Cornerstone enabled element
 * @param {String} layerId The layer's unique identifier
 * @returns {void}
 * @memberof EnabledElementLayers
 */

function triggerEventForLayer(eventName, enabledElement, layerId) {
  var element = enabledElement.element;
  var eventData = {
    viewport: enabledElement.viewport,
    element: enabledElement.element,
    image: enabledElement.image,
    enabledElement: enabledElement,
    layerId: layerId
  };
  Object(_triggerEvent_js__WEBPACK_IMPORTED_MODULE_4__["default"])(element, eventName, eventData);
}
/**
 * Rescale the target layer to the base layer based on the
 * relative size of each image and their pixel dimensions.
 *
 * This function will update the Viewport parameters of the
 * target layer to a new scale.
 *
 * @param {EnabledElementLayer} baseLayer The base layer
 * @param {EnabledElementLayer} targetLayer The target layer to rescale
 * @returns {void}
 * @memberof EnabledElementLayers
 */


function rescaleImage(baseLayer, targetLayer) {
  if (baseLayer.layerId === targetLayer.layerId) {
    throw new Error('rescaleImage: both arguments represent the same layer');
  }

  var baseImage = baseLayer.image;
  var targetImage = targetLayer.image; // Return if these images don't have an imageId (e.g. for dynamic images)

  if (!baseImage.imageId || !targetImage.imageId) {
    return;
  } // Column pixel spacing need to be considered when calculating the
  // ratio between the layer added and base layer images


  var colRelative = targetLayer.viewport.displayedArea.columnPixelSpacing * targetImage.width / (baseLayer.viewport.displayedArea.columnPixelSpacing * baseImage.width);
  var viewportRatio = targetLayer.viewport.scale / baseLayer.viewport.scale * colRelative;
  targetLayer.viewport.scale = baseLayer.viewport.scale * viewportRatio;
}
/**
 * Add a layer to a Cornerstone element
 *
 * @param {HTMLElement} element The DOM element enabled for Cornerstone
 * @param {Image} image A Cornerstone Image object to add as a new layer
 * @param {Object} options Options for the layer
 *
 * @returns {String} layerId The new layer's unique identifier
 * @memberof EnabledElementLayers
 */

function addLayer(element, image, options) {
  var layerId = Object(_internal_guid_js__WEBPACK_IMPORTED_MODULE_0__["default"])();
  var enabledElement = Object(_enabledElements_js__WEBPACK_IMPORTED_MODULE_1__["getEnabledElement"])(element);
  var layers = enabledElement.layers;
  var viewport;

  if (image) {
    viewport = Object(_internal_getDefaultViewport_js__WEBPACK_IMPORTED_MODULE_2__["default"])(enabledElement.canvas, image); // Override the defaults if any optional viewport settings
    // have been specified

    if (options && options.viewport) {
      viewport = Object.assign(viewport, options.viewport);
    }
  } // Set syncViewports to true by default when a new layer is added


  if (enabledElement.syncViewports !== false) {
    enabledElement.syncViewports = true;
  }

  var newLayer = {
    image: image,
    layerId: layerId,
    viewport: viewport,
    options: options || {},
    renderingTools: {}
  }; // Rescale the new layer based on the base layer to make sure
  // they will have a proportional size (pixel spacing)

  if (layers.length && image) {
    rescaleImage(layers[0], newLayer);
  }

  layers.push(newLayer);
  triggerEventForLayer(_events_js__WEBPACK_IMPORTED_MODULE_5__["default"].LAYER_ADDED, enabledElement, layerId); // Set the layer as active if it's the first layer added

  if (layers.length === 1 && image) {
    setActiveLayer(element, layerId);
  }

  return layerId;
}
/**
 * Remove a layer from a Cornerstone element given a layer ID
 *
 * @param {HTMLElement} element The DOM element enabled for Cornerstone
 * @param {String} layerId The unique identifier for the layer
 * @returns {void}
 * @memberof EnabledElementLayers
 */

function removeLayer(element, layerId) {
  var enabledElement = Object(_enabledElements_js__WEBPACK_IMPORTED_MODULE_1__["getEnabledElement"])(element);
  var layers = enabledElement.layers;
  var index = enabledElement.layers.findIndex(function (layer) {
    return layer.layerId === layerId;
  });

  if (index !== -1) {
    layers.splice(index, 1); // If the current layer is active, and we have other layers,
    // switch to the first layer that remains in the array

    if (layerId === enabledElement.activeLayerId && layers.length) {
      setActiveLayer(element, layers[0].layerId);
    }

    triggerEventForLayer(_events_js__WEBPACK_IMPORTED_MODULE_5__["default"].LAYER_REMOVED, enabledElement, layerId);
  }
}
/**
 * Retrieve a layer from a Cornerstone element given a layer ID
 *
 * @param {HTMLElement} element The DOM element enabled for Cornerstone
 * @param {String} layerId The unique identifier for the layer
 * @return {EnabledElementLayer} The layer
 * @memberof EnabledElementLayers
 */

function getLayer(element, layerId) {
  var enabledElement = Object(_enabledElements_js__WEBPACK_IMPORTED_MODULE_1__["getEnabledElement"])(element);
  return enabledElement.layers.find(function (layer) {
    return layer.layerId === layerId;
  });
}
/**
 * Retrieve all layers for a Cornerstone element
 *
 * @param {HTMLElement} element The DOM element enabled for Cornerstone
 *
 * @return {EnabledElementLayer[]} An array of layers
 * @memberof EnabledElementLayers
 */

function getLayers(element) {
  var enabledElement = Object(_enabledElements_js__WEBPACK_IMPORTED_MODULE_1__["getEnabledElement"])(element);
  return enabledElement.layers;
}
/**
 * Retrieve all visible layers for a Cornerstone element
 *
 * @param {HTMLElement} element The DOM element enabled for Cornerstone
 *
 * @return {EnabledElementLayer[]} An array of layers
 * @memberof EnabledElementLayers
 */

function getVisibleLayers(element) {
  var enabledElement = Object(_enabledElements_js__WEBPACK_IMPORTED_MODULE_1__["getEnabledElement"])(element);
  return enabledElement.layers.filter(function (layer) {
    return layer.options && layer.options.visible !== false && layer.options.opacity !== 0;
  });
}
/**
 * Set the active layer for a Cornerstone element
 *
 * @param {HTMLElement} element The DOM element enabled for Cornerstone
 * @param {String} layerId The unique identifier for the layer
 * @returns {void}
 * @memberof EnabledElementLayers
 */

function setActiveLayer(element, layerId) {
  var enabledElement = Object(_enabledElements_js__WEBPACK_IMPORTED_MODULE_1__["getEnabledElement"])(element); // Stop here if this layer is already active

  if (enabledElement.activeLayerId === layerId) {
    return;
  }

  var index = enabledElement.layers.findIndex(function (layer) {
    return layer.layerId === layerId;
  });

  if (index === -1) {
    throw new Error('setActiveLayer: layer not found in layers array');
  }

  var layer = enabledElement.layers[index];

  if (!layer.image) {
    throw new Error('setActiveLayer: layer with undefined image cannot be set as active.');
  }

  enabledElement.activeLayerId = layerId;
  enabledElement.image = layer.image;
  enabledElement.viewport = layer.viewport;
  Object(_updateImage_js__WEBPACK_IMPORTED_MODULE_3__["default"])(element);
  triggerEventForLayer(_events_js__WEBPACK_IMPORTED_MODULE_5__["default"].ACTIVE_LAYER_CHANGED, enabledElement, layerId);
}
/**
 * Set a new image for a specific layerId
 *
 * @param {HTMLElement} element The DOM element enabled for Cornerstone
 * @param {Image} image The image to be displayed in this layer
 * @param {String} [layerId] The unique identifier for the layer
 * @returns {void}
 * @memberof EnabledElementLayers
 */

function setLayerImage(element, image, layerId) {
  var enabledElement = Object(_enabledElements_js__WEBPACK_IMPORTED_MODULE_1__["getEnabledElement"])(element);
  var baseLayer = enabledElement.layers[0];
  var layer;

  if (layerId) {
    layer = getLayer(element, layerId);
  } else {
    layer = getActiveLayer(element);
  }

  if (!layer) {
    throw new Error('setLayerImage: Layer not found');
  }

  layer.image = image;

  if (!image) {
    layer.viewport = undefined;
    return;
  }

  if (!layer.viewport) {
    var defaultViewport = Object(_internal_getDefaultViewport_js__WEBPACK_IMPORTED_MODULE_2__["default"])(enabledElement.canvas, image); // Override the defaults if any optional viewport settings
    // have been specified

    if (layer.options && layer.options.viewport) {
      layer.viewport = Object.assign(defaultViewport, layer.options.viewport);
    }

    if (baseLayer.layerId !== layerId) {
      rescaleImage(baseLayer, layer);
    }
  }
}
/**
 * Retrieve the currently active layer for a Cornerstone element
 *
 * @param {HTMLElement} element The DOM element enabled for Cornerstone
 * @return {EnabledElementLayer} The currently active layer
 * @memberof EnabledElementLayers
 */

function getActiveLayer(element) {
  var enabledElement = Object(_enabledElements_js__WEBPACK_IMPORTED_MODULE_1__["getEnabledElement"])(element);
  return enabledElement.layers.find(function (layer) {
    return layer.layerId === enabledElement.activeLayerId;
  });
}
/**
 * Purge the layers
 *
 * @param {HTMLElement} element The DOM element enabled for Cornerstone
 *
 * @returns {void}
 */

function purgeLayers(element) {
  var enabledElement = Object(_enabledElements_js__WEBPACK_IMPORTED_MODULE_1__["getEnabledElement"])(element);
  enabledElement.layers = [];
  delete enabledElement.activeLayerId;
  delete enabledElement.lastSyncViewportsState;
}

/***/ }),

/***/ "./metaData.js":
/*!*********************!*\
  !*** ./metaData.js ***!
  \*********************/
/*! exports provided: addProvider, removeProvider, default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "addProvider", function() { return addProvider; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "removeProvider", function() { return removeProvider; });
// This module defines a way to access various metadata about an imageId.  This layer of abstraction exists
// So metadata can be provided in different ways (e.g. by parsing DICOM P10 or by a WADO-RS document)
var providers = [];
/**
 * @module Metadata
 */

/**
 * Adds a metadata provider with the specified priority
 * @param {Function} provider Metadata provider function
 * @param {Number} [priority=0] - 0 is default/normal, > 0 is high, < 0 is low
 *
 * @returns {void}
 * @memberof Metadata
 */

function addProvider(provider) {
  var priority = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : 0;
  var i; // Find the right spot to insert this provider based on priority

  for (i = 0; i < providers.length; i++) {
    if (providers[i].priority <= priority) {
      break;
    }
  } // Insert the decode task at position i


  providers.splice(i, 0, {
    priority: priority,
    provider: provider
  });
}
/**
 * Removes the specified provider
 *
 * @param {Function} provider Metadata provider function
 *
 * @returns {void}
 * @memberof Metadata
 */

function removeProvider(provider) {
  for (var i = 0; i < providers.length; i++) {
    if (providers[i].provider === provider) {
      providers.splice(i, 1);
      break;
    }
  }
}
/**
 * Gets metadata from the registered metadata providers.  Will call each one from highest priority to lowest
 * until one responds
 *
 * @param {String} type The type of metadata requested from the metadata store
 * @param {String} imageId The Cornerstone Image Object's imageId
 *
 * @returns {*} The metadata retrieved from the metadata store
 * @memberof Metadata
 */

function getMetaData(type, imageId) {
  // Invoke each provider in priority order until one returns something
  for (var i = 0; i < providers.length; i++) {
    var result = providers[i].provider(type, imageId);

    if (result !== undefined) {
      return result;
    }
  }
}

/* harmony default export */ __webpack_exports__["default"] = ({
  addProvider: addProvider,
  removeProvider: removeProvider,
  get: getMetaData
});

/***/ }),

/***/ "./pageToPixel.js":
/*!************************!*\
  !*** ./pageToPixel.js ***!
  \************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _enabledElements_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./enabledElements.js */ "./enabledElements.js");
/* harmony import */ var _internal_getTransform_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./internal/getTransform.js */ "./internal/getTransform.js");


/**
 * Converts a point in the page coordinate system to the pixel coordinate
 * system
 *
 * @param {HTMLElement} element The Cornerstone element within which the input point lies
 * @param {Number} pageX The x value in the page coordinate system
 * @param {Number} pageY The y value in the page coordinate system
 *
 * @returns {{x: Number, y: Number}} The transformed point in the pixel coordinate system
 */

/* harmony default export */ __webpack_exports__["default"] = (function (element, pageX, pageY) {
  var enabledElement = Object(_enabledElements_js__WEBPACK_IMPORTED_MODULE_0__["getEnabledElement"])(element);

  if (enabledElement.image === undefined) {
    throw new Error('image has not been loaded yet');
  } // Convert the pageX and pageY to the canvas client coordinates


  var rect = element.getBoundingClientRect();
  var clientX = pageX - rect.left - window.pageXOffset;
  var clientY = pageY - rect.top - window.pageYOffset;
  var pt = {
    x: clientX,
    y: clientY
  };
  var transform = Object(_internal_getTransform_js__WEBPACK_IMPORTED_MODULE_1__["default"])(enabledElement);
  transform.invert();
  return transform.transformPoint(pt.x, pt.y);
});

/***/ }),

/***/ "./pixelDataToFalseColorData.js":
/*!**************************************!*\
  !*** ./pixelDataToFalseColorData.js ***!
  \**************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return pixelDataToFalseColorData; });
/* harmony import */ var _colors_index_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./colors/index.js */ "./colors/index.js");

/**
 * Converts the image pixel data into a false color data
 *
 * @param {Image} image A Cornerstone Image Object
 * @param {Object} lookupTable A lookup table Object
 *
 * @returns {void}
 * @deprecated This function is superseded by the ability to set the Viewport parameters
 * to include colormaps.
 */

function pixelDataToFalseColorData(image, lookupTable) {
  if (image.color && !image.falseColor) {
    throw new Error('Color transforms are not implemented yet');
  }

  var minPixelValue = image.minPixelValue;
  var canvasImageDataIndex = 0;
  var storedPixelDataIndex = 0;
  var numPixels = image.width * image.height;
  var origPixelData = image.origPixelData || image.getPixelData();
  var storedColorPixelData = new Uint8Array(numPixels * 4);
  var sp;
  var mapped;
  image.color = true;
  image.falseColor = true;
  image.origPixelData = origPixelData;

  if (lookupTable instanceof _colors_index_js__WEBPACK_IMPORTED_MODULE_0__["default"].LookupTable) {
    lookupTable.build();

    while (storedPixelDataIndex < numPixels) {
      sp = origPixelData[storedPixelDataIndex++];
      mapped = lookupTable.mapValue(sp);
      storedColorPixelData[canvasImageDataIndex++] = mapped[0];
      storedColorPixelData[canvasImageDataIndex++] = mapped[1];
      storedColorPixelData[canvasImageDataIndex++] = mapped[2];
      storedColorPixelData[canvasImageDataIndex++] = mapped[3];
    }
  } else if (minPixelValue < 0) {
    while (storedPixelDataIndex < numPixels) {
      sp = origPixelData[storedPixelDataIndex++];
      storedColorPixelData[canvasImageDataIndex++] = lookupTable[sp + -minPixelValue][0]; // Red

      storedColorPixelData[canvasImageDataIndex++] = lookupTable[sp + -minPixelValue][1]; // Green

      storedColorPixelData[canvasImageDataIndex++] = lookupTable[sp + -minPixelValue][2]; // Blue

      storedColorPixelData[canvasImageDataIndex++] = lookupTable[sp + -minPixelValue][3]; // Alpha
    }
  } else {
    while (storedPixelDataIndex < numPixels) {
      sp = origPixelData[storedPixelDataIndex++];
      storedColorPixelData[canvasImageDataIndex++] = lookupTable[sp][0]; // Red

      storedColorPixelData[canvasImageDataIndex++] = lookupTable[sp][1]; // Green

      storedColorPixelData[canvasImageDataIndex++] = lookupTable[sp][2]; // Blue

      storedColorPixelData[canvasImageDataIndex++] = lookupTable[sp][3]; // Alpha
    }
  }

  image.rgba = true;
  image.cachedLut = undefined;
  image.render = undefined;
  image.slope = 1;
  image.intercept = 0;
  image.minPixelValue = 0;
  image.maxPixelValue = 255;
  image.windowWidth = 255;
  image.windowCenter = 128;

  image.getPixelData = function () {
    return storedColorPixelData;
  };
}

/***/ }),

/***/ "./pixelToCanvas.js":
/*!**************************!*\
  !*** ./pixelToCanvas.js ***!
  \**************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _enabledElements_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./enabledElements.js */ "./enabledElements.js");
/* harmony import */ var _internal_getTransform_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./internal/getTransform.js */ "./internal/getTransform.js");


/**
 * Converts a point in the pixel coordinate system to the canvas coordinate system
 * system.  This can be used to render using canvas context without having the weird
 * side effects that come from scaling and non square pixels
 *
 * @param {HTMLElement} element An HTML Element enabled for Cornerstone
 * @param {{x: Number, y: Number}} pt The transformed point in the pixel coordinate system
 *
 * @returns {{x: Number, y: Number}} The input point in the canvas coordinate system
 * @memberof PixelCoordinateSystem
 */

/* harmony default export */ __webpack_exports__["default"] = (function (element, pt) {
  var enabledElement = Object(_enabledElements_js__WEBPACK_IMPORTED_MODULE_0__["getEnabledElement"])(element);
  var transform = Object(_internal_getTransform_js__WEBPACK_IMPORTED_MODULE_1__["default"])(enabledElement);
  return transform.transformPoint(pt.x, pt.y);
});

/***/ }),

/***/ "./rendering/doesImageNeedToBeRendered.js":
/*!************************************************!*\
  !*** ./rendering/doesImageNeedToBeRendered.js ***!
  \************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/**
 * Determine whether or not an Enabled Element needs to be re-rendered.
 *
 * If the imageId has changed, or if any of the last rendered viewport
 * parameters have changed, this function will return true.
 *
 * @param {EnabledElement} enabledElement An Enabled Element
 * @param {Image} image An Image
 * @return {boolean} Whether or not the Enabled Element needs to re-render its image
 * @memberof rendering
 */
/* harmony default export */ __webpack_exports__["default"] = (function (enabledElement, image) {
  var lastRenderedImageId = enabledElement.renderingTools.lastRenderedImageId;
  var lastRenderedViewport = enabledElement.renderingTools.lastRenderedViewport;
  return image.imageId !== lastRenderedImageId || !lastRenderedViewport || lastRenderedViewport.windowCenter !== enabledElement.viewport.voi.windowCenter || lastRenderedViewport.windowWidth !== enabledElement.viewport.voi.windowWidth || lastRenderedViewport.invert !== enabledElement.viewport.invert || lastRenderedViewport.rotation !== enabledElement.viewport.rotation || lastRenderedViewport.hflip !== enabledElement.viewport.hflip || lastRenderedViewport.vflip !== enabledElement.viewport.vflip || lastRenderedViewport.modalityLUT !== enabledElement.viewport.modalityLUT || lastRenderedViewport.voiLUT !== enabledElement.viewport.voiLUT || lastRenderedViewport.colormap !== enabledElement.viewport.colormap;
});

/***/ }),

/***/ "./rendering/getLut.js":
/*!*****************************!*\
  !*** ./rendering/getLut.js ***!
  \*****************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _internal_computeAutoVoi_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ../internal/computeAutoVoi.js */ "./internal/computeAutoVoi.js");
/* harmony import */ var _lutMatches_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./lutMatches.js */ "./rendering/lutMatches.js");
/* harmony import */ var _internal_generateLut_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ../internal/generateLut.js */ "./internal/generateLut.js");



/**
 * Retrieve or generate a LUT Array for an Image and Viewport
 *
 * @param {Image} image An Image Object
 * @param {Viewport} viewport An Viewport Object
 * @param {Boolean} invalidated Whether or not the LUT data has been invalidated
 * (e.g. by a change to the windowWidth, windowCenter, or invert viewport parameters).
 * @return {Uint8ClampedArray} LUT Array
 * @memberof rendering
 */

/* harmony default export */ __webpack_exports__["default"] = (function (image, viewport, invalidated) {
  // If we have a cached lut and it has the right values, return it immediately
  if (image.cachedLut !== undefined && image.cachedLut.windowCenter === viewport.voi.windowCenter && image.cachedLut.windowWidth === viewport.voi.windowWidth && Object(_lutMatches_js__WEBPACK_IMPORTED_MODULE_1__["default"])(image.cachedLut.modalityLUT, viewport.modalityLUT) && Object(_lutMatches_js__WEBPACK_IMPORTED_MODULE_1__["default"])(image.cachedLut.voiLUT, viewport.voiLUT) && image.cachedLut.invert === viewport.invert && invalidated !== true) {
    return image.cachedLut.lutArray;
  }

  Object(_internal_computeAutoVoi_js__WEBPACK_IMPORTED_MODULE_0__["default"])(viewport, image); // Lut is invalid or not present, regenerate it and cache it

  Object(_internal_generateLut_js__WEBPACK_IMPORTED_MODULE_2__["default"])(image, viewport.voi.windowWidth, viewport.voi.windowCenter, viewport.invert, viewport.modalityLUT, viewport.voiLUT);
  image.cachedLut.windowWidth = viewport.voi.windowWidth;
  image.cachedLut.windowCenter = viewport.voi.windowCenter;
  image.cachedLut.invert = viewport.invert;
  image.cachedLut.voiLUT = viewport.voiLUT;
  image.cachedLut.modalityLUT = viewport.modalityLUT;
  return image.cachedLut.lutArray;
});

/***/ }),

/***/ "./rendering/index.js":
/*!****************************!*\
  !*** ./rendering/index.js ***!
  \****************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _renderColorImage_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./renderColorImage.js */ "./rendering/renderColorImage.js");
/* harmony import */ var _renderGrayscaleImage_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./renderGrayscaleImage.js */ "./rendering/renderGrayscaleImage.js");
/* harmony import */ var _renderWebImage_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./renderWebImage.js */ "./rendering/renderWebImage.js");
/* harmony import */ var _renderPseudoColorImage_js__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ./renderPseudoColorImage.js */ "./rendering/renderPseudoColorImage.js");
/* harmony import */ var _renderLabelMapImage_js__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! ./renderLabelMapImage.js */ "./rendering/renderLabelMapImage.js");
/* harmony import */ var _renderToCanvas_js__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(/*! ./renderToCanvas.js */ "./rendering/renderToCanvas.js");






/**
 * @module rendering
 */

/* harmony default export */ __webpack_exports__["default"] = ({
  colorImage: _renderColorImage_js__WEBPACK_IMPORTED_MODULE_0__["renderColorImage"],
  grayscaleImage: _renderGrayscaleImage_js__WEBPACK_IMPORTED_MODULE_1__["renderGrayscaleImage"],
  webImage: _renderWebImage_js__WEBPACK_IMPORTED_MODULE_2__["renderWebImage"],
  pseudoColorImage: _renderPseudoColorImage_js__WEBPACK_IMPORTED_MODULE_3__["renderPseudoColorImage"],
  labelMapImage: _renderLabelMapImage_js__WEBPACK_IMPORTED_MODULE_4__["renderLabelMapImage"],
  toCanvas: _renderToCanvas_js__WEBPACK_IMPORTED_MODULE_5__["default"]
});

/***/ }),

/***/ "./rendering/initializeRenderCanvas.js":
/*!*********************************************!*\
  !*** ./rendering/initializeRenderCanvas.js ***!
  \*********************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/**
 * Sets size and clears canvas
 *
 * @param {Object} enabledElement Cornerstone Enabled Element
 * @param {Object} image Image to be rendered
 * @returns {void}
 * @memberof rendering
 */
/* harmony default export */ __webpack_exports__["default"] = (function (enabledElement, image) {
  var renderCanvas = enabledElement.renderingTools.renderCanvas; // Resize the canvas

  renderCanvas.width = image.width;
  renderCanvas.height = image.height;
  var canvasContext = renderCanvas.getContext('2d'); // NOTE - we need to fill the render canvas with white pixels since we
  // control the luminance using the alpha channel to improve rendering performance.

  canvasContext.fillStyle = 'white';
  canvasContext.fillRect(0, 0, renderCanvas.width, renderCanvas.height);
  var renderCanvasData = canvasContext.getImageData(0, 0, image.width, image.height);
  enabledElement.renderingTools.renderCanvasContext = canvasContext;
  enabledElement.renderingTools.renderCanvasData = renderCanvasData;
});

/***/ }),

/***/ "./rendering/lutMatches.js":
/*!*********************************!*\
  !*** ./rendering/lutMatches.js ***!
  \*********************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/**
 * Check if two lookup tables match
 *
 * @param {LUT} a A lookup table function
 * @param {LUT} b Another lookup table function
 * @return {boolean} Whether or not they match
 * @memberof rendering
 */
/* harmony default export */ __webpack_exports__["default"] = (function (a, b) {
  // If undefined, they are equal
  if (!a && !b) {
    return true;
  } // If one is undefined, not equal


  if (!a || !b) {
    return false;
  } // Check the unique ids


  return a.id === b.id;
});

/***/ }),

/***/ "./rendering/renderColorImage.js":
/*!***************************************!*\
  !*** ./rendering/renderColorImage.js ***!
  \***************************************/
/*! exports provided: renderColorImage, addColorLayer */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "renderColorImage", function() { return renderColorImage; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "addColorLayer", function() { return addColorLayer; });
/* harmony import */ var _internal_now_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ../internal/now.js */ "./internal/now.js");
/* harmony import */ var _internal_generateColorLut_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ../internal/generateColorLut.js */ "./internal/generateColorLut.js");
/* harmony import */ var _internal_storedColorPixelDataToCanvasImageData_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ../internal/storedColorPixelDataToCanvasImageData.js */ "./internal/storedColorPixelDataToCanvasImageData.js");
/* harmony import */ var _internal_storedRGBAPixelDataToCanvasImageData_js__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ../internal/storedRGBAPixelDataToCanvasImageData.js */ "./internal/storedRGBAPixelDataToCanvasImageData.js");
/* harmony import */ var _setToPixelCoordinateSystem_js__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! ../setToPixelCoordinateSystem.js */ "./setToPixelCoordinateSystem.js");
/* harmony import */ var _webgl_index_js__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(/*! ../webgl/index.js */ "./webgl/index.js");
/* harmony import */ var _doesImageNeedToBeRendered_js__WEBPACK_IMPORTED_MODULE_6__ = __webpack_require__(/*! ./doesImageNeedToBeRendered.js */ "./rendering/doesImageNeedToBeRendered.js");
/* harmony import */ var _initializeRenderCanvas_js__WEBPACK_IMPORTED_MODULE_7__ = __webpack_require__(/*! ./initializeRenderCanvas.js */ "./rendering/initializeRenderCanvas.js");
/* harmony import */ var _saveLastRendered_js__WEBPACK_IMPORTED_MODULE_8__ = __webpack_require__(/*! ./saveLastRendered.js */ "./rendering/saveLastRendered.js");









/**
 * Generates an appropriate Look Up Table to render the given image with the given window width and level (specified in the viewport)
 * Uses an internal cache for performance
 *
 * @param {Object} image  The image to be rendered
 * @param {Object} viewport The viewport values used for rendering
 * @returns {Uint8ClampedArray} Look Up Table array.
 * @memberof rendering
 */

function getLut(image, viewport) {
  // If we have a cached lut and it has the right values, return it immediately
  if (image.cachedLut !== undefined && image.cachedLut.windowCenter === viewport.voi.windowCenter && image.cachedLut.windowWidth === viewport.voi.windowWidth && image.cachedLut.invert === viewport.invert) {
    return image.cachedLut.lutArray;
  } // Lut is invalid or not present, regenerate it and cache it


  Object(_internal_generateColorLut_js__WEBPACK_IMPORTED_MODULE_1__["default"])(image, viewport.voi.windowWidth, viewport.voi.windowCenter, viewport.invert);
  image.cachedLut.windowWidth = viewport.voi.windowWidth;
  image.cachedLut.windowCenter = viewport.voi.windowCenter;
  image.cachedLut.invert = viewport.invert;
  return image.cachedLut.lutArray;
}
/**
 * Returns an appropriate canvas to render the Image. If the canvas available in the cache is appropriate
 * it is returned, otherwise adjustments are made. It also sets the color transfer functions.
 *
 * @param {Object} enabledElement The cornerstone enabled element
 * @param {Object} image The image to be rendered
 * @param {Boolean} invalidated Is pixel data valid
 * @returns {HTMLCanvasElement} An appropriate canvas for rendering the image
 * @memberof rendering
 */


function getRenderCanvas(enabledElement, image, invalidated) {
  var canvasWasColor = enabledElement.renderingTools.lastRenderedIsColor === true;

  if (!enabledElement.renderingTools.renderCanvas || !canvasWasColor) {
    enabledElement.renderingTools.renderCanvas = document.createElement('canvas');
  }

  var renderCanvas = enabledElement.renderingTools.renderCanvas; // The ww/wc is identity and not inverted - get a canvas with the image rendered into it for
  // Fast drawing

  if (enabledElement.viewport.voi.windowWidth === 255 && enabledElement.viewport.voi.windowCenter === 128 && enabledElement.viewport.invert === false && image.getCanvas && image.getCanvas()) {
    return image.getCanvas();
  } // Apply the lut to the stored pixel data onto the render canvas


  if (Object(_doesImageNeedToBeRendered_js__WEBPACK_IMPORTED_MODULE_6__["default"])(enabledElement, image) === false && invalidated !== true) {
    return renderCanvas;
  } // If our render canvas does not match the size of this image reset it
  // NOTE: This might be inefficient if we are updating multiple images of different
  // Sizes frequently.


  if (renderCanvas.width !== image.width || renderCanvas.height !== image.height) {
    Object(_initializeRenderCanvas_js__WEBPACK_IMPORTED_MODULE_7__["default"])(enabledElement, image);
  } // Get the lut to use


  var start = Object(_internal_now_js__WEBPACK_IMPORTED_MODULE_0__["default"])();
  var colorLut = getLut(image, enabledElement.viewport);
  image.stats = image.stats || {};
  image.stats.lastLutGenerateTime = Object(_internal_now_js__WEBPACK_IMPORTED_MODULE_0__["default"])() - start;
  var renderCanvasData = enabledElement.renderingTools.renderCanvasData;
  var renderCanvasContext = enabledElement.renderingTools.renderCanvasContext; // The color image voi/invert has been modified - apply the lut to the underlying
  // Pixel data and put it into the renderCanvas

  if (image.rgba) {
    Object(_internal_storedRGBAPixelDataToCanvasImageData_js__WEBPACK_IMPORTED_MODULE_3__["default"])(image, colorLut, renderCanvasData.data);
  } else {
    Object(_internal_storedColorPixelDataToCanvasImageData_js__WEBPACK_IMPORTED_MODULE_2__["default"])(image, colorLut, renderCanvasData.data);
  }

  start = Object(_internal_now_js__WEBPACK_IMPORTED_MODULE_0__["default"])();
  renderCanvasContext.putImageData(renderCanvasData, 0, 0);
  image.stats.lastPutImageDataTime = Object(_internal_now_js__WEBPACK_IMPORTED_MODULE_0__["default"])() - start;
  return renderCanvas;
}
/**
 * API function to render a color image to an enabled element
 *
 * @param {EnabledElement} enabledElement The Cornerstone Enabled Element to redraw
 * @param {Boolean} invalidated - true if pixel data has been invalidated and cached rendering should not be used
 * @returns {void}
 * @memberof rendering
 */


function renderColorImage(enabledElement, invalidated) {
  if (enabledElement === undefined) {
    throw new Error('renderColorImage: enabledElement parameter must not be undefined');
  }

  var image = enabledElement.image;

  if (image === undefined) {
    throw new Error('renderColorImage: image must be loaded before it can be drawn');
  } // Get the canvas context and reset the transform


  var context = enabledElement.canvas.getContext('2d');
  context.setTransform(1, 0, 0, 1, 0, 0); // Clear the canvas

  context.fillStyle = 'black';
  context.fillRect(0, 0, enabledElement.canvas.width, enabledElement.canvas.height); // Turn off image smooth/interpolation if pixelReplication is set in the viewport

  context.imageSmoothingEnabled = !enabledElement.viewport.pixelReplication;
  context.mozImageSmoothingEnabled = context.imageSmoothingEnabled; // Save the canvas context state and apply the viewport properties

  Object(_setToPixelCoordinateSystem_js__WEBPACK_IMPORTED_MODULE_4__["default"])(enabledElement, context);
  var renderCanvas;

  if (enabledElement.options && enabledElement.options.renderer && enabledElement.options.renderer.toLowerCase() === 'webgl') {
    // If this enabled element has the option set for WebGL, we should
    // User it as our renderer.
    renderCanvas = _webgl_index_js__WEBPACK_IMPORTED_MODULE_5__["default"].renderer.render(enabledElement);
  } else {
    // If no options are set we will retrieve the renderCanvas through the
    // Normal Canvas rendering path
    renderCanvas = getRenderCanvas(enabledElement, image, invalidated);
  }

  var sx = enabledElement.viewport.displayedArea.tlhc.x - 1;
  var sy = enabledElement.viewport.displayedArea.tlhc.y - 1;
  var width = enabledElement.viewport.displayedArea.brhc.x - sx;
  var height = enabledElement.viewport.displayedArea.brhc.y - sy;
  context.drawImage(renderCanvas, sx, sy, width, height, 0, 0, width, height);
  enabledElement.renderingTools = Object(_saveLastRendered_js__WEBPACK_IMPORTED_MODULE_8__["default"])(enabledElement);
}
function addColorLayer(layer, invalidated) {
  if (layer === undefined) {
    throw new Error('addColorLayer: layer parameter must not be undefined');
  }

  var image = layer.image;

  if (image === undefined) {
    throw new Error('addColorLayer: image must be loaded before it can be drawn');
  } // All multi-layer images should include the alpha value


  image.rgba = true;
  layer.canvas = getRenderCanvas(layer, image, invalidated);
  var context = layer.canvas.getContext('2d'); // Turn off image smooth/interpolation if pixelReplication is set in the viewport

  context.imageSmoothingEnabled = !layer.viewport.pixelReplication;
  context.mozImageSmoothingEnabled = context.imageSmoothingEnabled;
  layer.renderingTools = Object(_saveLastRendered_js__WEBPACK_IMPORTED_MODULE_8__["default"])(layer);
}

/***/ }),

/***/ "./rendering/renderGrayscaleImage.js":
/*!*******************************************!*\
  !*** ./rendering/renderGrayscaleImage.js ***!
  \*******************************************/
/*! exports provided: renderGrayscaleImage, addGrayscaleLayer */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "renderGrayscaleImage", function() { return renderGrayscaleImage; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "addGrayscaleLayer", function() { return addGrayscaleLayer; });
/* harmony import */ var _internal_storedPixelDataToCanvasImageData_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ../internal/storedPixelDataToCanvasImageData.js */ "./internal/storedPixelDataToCanvasImageData.js");
/* harmony import */ var _internal_storedPixelDataToCanvasImageDataRGBA_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ../internal/storedPixelDataToCanvasImageDataRGBA.js */ "./internal/storedPixelDataToCanvasImageDataRGBA.js");
/* harmony import */ var _setToPixelCoordinateSystem_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ../setToPixelCoordinateSystem.js */ "./setToPixelCoordinateSystem.js");
/* harmony import */ var _internal_now_js__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ../internal/now.js */ "./internal/now.js");
/* harmony import */ var _webgl_index_js__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! ../webgl/index.js */ "./webgl/index.js");
/* harmony import */ var _getLut_js__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(/*! ./getLut.js */ "./rendering/getLut.js");
/* harmony import */ var _doesImageNeedToBeRendered_js__WEBPACK_IMPORTED_MODULE_6__ = __webpack_require__(/*! ./doesImageNeedToBeRendered.js */ "./rendering/doesImageNeedToBeRendered.js");
/* harmony import */ var _initializeRenderCanvas_js__WEBPACK_IMPORTED_MODULE_7__ = __webpack_require__(/*! ./initializeRenderCanvas.js */ "./rendering/initializeRenderCanvas.js");
/* harmony import */ var _saveLastRendered_js__WEBPACK_IMPORTED_MODULE_8__ = __webpack_require__(/*! ./saveLastRendered.js */ "./rendering/saveLastRendered.js");









/**
 * Returns an appropriate canvas to render the Image. If the canvas available in the cache is appropriate
 * it is returned, otherwise adjustments are made. It also sets the color transfer functions.
 *
 * @param {Object} enabledElement The cornerstone enabled element
 * @param {Object} image The image to be rendered
 * @param {Boolean} invalidated Is pixel data valid
 * @param {Boolean} [useAlphaChannel = true] Will an alpha channel be used
 * @returns {HTMLCanvasElement} An appropriate canvas for rendering the image
 * @memberof rendering
 */

function getRenderCanvas(enabledElement, image, invalidated) {
  var useAlphaChannel = arguments.length > 3 && arguments[3] !== undefined ? arguments[3] : true;
  var canvasWasColor = enabledElement.renderingTools.lastRenderedIsColor === true;

  if (!enabledElement.renderingTools.renderCanvas || canvasWasColor) {
    enabledElement.renderingTools.renderCanvas = document.createElement('canvas');
    Object(_initializeRenderCanvas_js__WEBPACK_IMPORTED_MODULE_7__["default"])(enabledElement, image);
  }

  var renderCanvas = enabledElement.renderingTools.renderCanvas;

  if (Object(_doesImageNeedToBeRendered_js__WEBPACK_IMPORTED_MODULE_6__["default"])(enabledElement, image) === false && invalidated !== true) {
    return renderCanvas;
  } // If our render canvas does not match the size of this image reset it
  // NOTE: This might be inefficient if we are updating multiple images of different
  // Sizes frequently.


  if (renderCanvas.width !== image.width || renderCanvas.height !== image.height) {
    Object(_initializeRenderCanvas_js__WEBPACK_IMPORTED_MODULE_7__["default"])(enabledElement, image);
  } // Get the lut to use


  var start = Object(_internal_now_js__WEBPACK_IMPORTED_MODULE_3__["default"])();
  var lut = Object(_getLut_js__WEBPACK_IMPORTED_MODULE_5__["default"])(image, enabledElement.viewport, invalidated);
  image.stats = image.stats || {};
  image.stats.lastLutGenerateTime = Object(_internal_now_js__WEBPACK_IMPORTED_MODULE_3__["default"])() - start;
  var renderCanvasData = enabledElement.renderingTools.renderCanvasData;
  var renderCanvasContext = enabledElement.renderingTools.renderCanvasContext; // Gray scale image - apply the lut and put the resulting image onto the render canvas

  if (useAlphaChannel) {
    Object(_internal_storedPixelDataToCanvasImageData_js__WEBPACK_IMPORTED_MODULE_0__["default"])(image, lut, renderCanvasData.data);
  } else {
    Object(_internal_storedPixelDataToCanvasImageDataRGBA_js__WEBPACK_IMPORTED_MODULE_1__["default"])(image, lut, renderCanvasData.data);
  }

  start = Object(_internal_now_js__WEBPACK_IMPORTED_MODULE_3__["default"])();
  renderCanvasContext.putImageData(renderCanvasData, 0, 0);
  image.stats.lastPutImageDataTime = Object(_internal_now_js__WEBPACK_IMPORTED_MODULE_3__["default"])() - start;
  return renderCanvas;
}
/**
 * API function to draw a grayscale image to a given enabledElement
 *
 * @param {EnabledElement} enabledElement The Cornerstone Enabled Element to redraw
 * @param {Boolean} invalidated - true if pixel data has been invalidated and cached rendering should not be used
 * @returns {void}
 * @memberof rendering
 */


function renderGrayscaleImage(enabledElement, invalidated) {
  if (enabledElement === undefined) {
    throw new Error('drawImage: enabledElement parameter must not be undefined');
  }

  var image = enabledElement.image;

  if (image === undefined) {
    throw new Error('drawImage: image must be loaded before it can be drawn');
  } // Get the canvas context and reset the transform


  var context = enabledElement.canvas.getContext('2d');
  context.setTransform(1, 0, 0, 1, 0, 0); // Clear the canvas

  context.fillStyle = 'black';
  context.fillRect(0, 0, enabledElement.canvas.width, enabledElement.canvas.height); // Turn off image smooth/interpolation if pixelReplication is set in the viewport

  context.imageSmoothingEnabled = !enabledElement.viewport.pixelReplication;
  context.mozImageSmoothingEnabled = context.imageSmoothingEnabled; // Save the canvas context state and apply the viewport properties

  Object(_setToPixelCoordinateSystem_js__WEBPACK_IMPORTED_MODULE_2__["default"])(enabledElement, context);
  var renderCanvas;

  if (enabledElement.options && enabledElement.options.renderer && enabledElement.options.renderer.toLowerCase() === 'webgl') {
    // If this enabled element has the option set for WebGL, we should
    // User it as our renderer.
    renderCanvas = _webgl_index_js__WEBPACK_IMPORTED_MODULE_4__["default"].renderer.render(enabledElement);
  } else {
    // If no options are set we will retrieve the renderCanvas through the
    // Normal Canvas rendering path
    renderCanvas = getRenderCanvas(enabledElement, image, invalidated);
  }

  var sx = enabledElement.viewport.displayedArea.tlhc.x - 1;
  var sy = enabledElement.viewport.displayedArea.tlhc.y - 1;
  var width = enabledElement.viewport.displayedArea.brhc.x - sx;
  var height = enabledElement.viewport.displayedArea.brhc.y - sy;
  context.drawImage(renderCanvas, sx, sy, width, height, 0, 0, width, height);
  enabledElement.renderingTools = Object(_saveLastRendered_js__WEBPACK_IMPORTED_MODULE_8__["default"])(enabledElement);
}
/**
 * API function to draw a grayscale image to a given layer
 *
 * @param {EnabledElementLayer} layer The layer that the image will be added to
 * @param {Boolean} invalidated - true if pixel data has been invalidated and cached rendering should not be used
 * @param {Boolean} [useAlphaChannel] - Whether or not to render the grayscale image using only the alpha channel.
                                        This does not work if this layer is not the first layer in the enabledElement.
 * @returns {void}
 */

function addGrayscaleLayer(layer, invalidated) {
  var useAlphaChannel = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : false;

  if (layer === undefined) {
    throw new Error('addGrayscaleLayer: layer parameter must not be undefined');
  }

  var image = layer.image;

  if (image === undefined) {
    throw new Error('addGrayscaleLayer: image must be loaded before it can be drawn');
  }

  layer.canvas = getRenderCanvas(layer, image, invalidated, useAlphaChannel);
  var context = layer.canvas.getContext('2d'); // Turn off image smooth/interpolation if pixelReplication is set in the viewport

  context.imageSmoothingEnabled = !layer.viewport.pixelReplication;
  context.mozImageSmoothingEnabled = context.imageSmoothingEnabled;
  layer.renderingTools = Object(_saveLastRendered_js__WEBPACK_IMPORTED_MODULE_8__["default"])(layer);
}

/***/ }),

/***/ "./rendering/renderLabelMapImage.js":
/*!******************************************!*\
  !*** ./rendering/renderLabelMapImage.js ***!
  \******************************************/
/*! exports provided: renderLabelMapImage, addLabelMapLayer */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "renderLabelMapImage", function() { return renderLabelMapImage; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "addLabelMapLayer", function() { return addLabelMapLayer; });
/* harmony import */ var _setToPixelCoordinateSystem_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ../setToPixelCoordinateSystem.js */ "./setToPixelCoordinateSystem.js");
/* harmony import */ var _internal_now_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ../internal/now.js */ "./internal/now.js");
/* harmony import */ var _initializeRenderCanvas_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./initializeRenderCanvas.js */ "./rendering/initializeRenderCanvas.js");
/* harmony import */ var _saveLastRendered_js__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ./saveLastRendered.js */ "./rendering/saveLastRendered.js");
/* harmony import */ var _doesImageNeedToBeRendered_js__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! ./doesImageNeedToBeRendered.js */ "./rendering/doesImageNeedToBeRendered.js");
/* harmony import */ var _internal_storedPixelDataToCanvasImageDataColorLUT_js__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(/*! ../internal/storedPixelDataToCanvasImageDataColorLUT.js */ "./internal/storedPixelDataToCanvasImageDataColorLUT.js");
/* harmony import */ var _colors_index_js__WEBPACK_IMPORTED_MODULE_6__ = __webpack_require__(/*! ../colors/index.js */ "./colors/index.js");







/**
 * Returns an appropriate canvas to render the Image. If the canvas available in the cache is appropriate
 * it is returned, otherwise adjustments are made. It also sets the color transfer functions.
 *
 * @param {Object} enabledElement The cornerstone enabled element
 * @param {Object} image The image to be rendered
 * @param {Boolean} invalidated Is pixel data valid
 * @returns {HTMLCanvasElement} An appropriate canvas for rendering the image
 * @memberof rendering
 */

function getRenderCanvas(enabledElement, image, invalidated) {
  if (!enabledElement.renderingTools.renderCanvas) {
    enabledElement.renderingTools.renderCanvas = document.createElement('canvas');
  }

  var renderCanvas = enabledElement.renderingTools.renderCanvas;
  var colormap = enabledElement.viewport.colormap || enabledElement.options.colormap;

  if (enabledElement.options.colormap) {
    console.warn('enabledElement.options.colormap is deprecated. Use enabledElement.viewport.colormap instead');
  }

  if (colormap && typeof colormap === 'string') {
    colormap = _colors_index_js__WEBPACK_IMPORTED_MODULE_6__["default"].getColormap(colormap);
  }

  if (!colormap) {
    throw new Error('renderLabelMapImage: colormap not found.');
  }

  var colormapId = colormap.getId();

  if (Object(_doesImageNeedToBeRendered_js__WEBPACK_IMPORTED_MODULE_4__["default"])(enabledElement, image) === false && invalidated !== true && enabledElement.renderingTools.colormapId === colormapId) {
    return renderCanvas;
  } // If our render canvas does not match the size of this image reset it
  // NOTE: This might be inefficient if we are updating multiple images of different
  // Sizes frequently.


  if (renderCanvas.width !== image.width || renderCanvas.height !== image.height) {
    Object(_initializeRenderCanvas_js__WEBPACK_IMPORTED_MODULE_2__["default"])(enabledElement, image);
  } // Get the lut to use


  var start = Object(_internal_now_js__WEBPACK_IMPORTED_MODULE_1__["default"])();

  if (!enabledElement.renderingTools.colorLut || invalidated || enabledElement.renderingTools.colormapId !== colormapId) {
    enabledElement.renderingTools.colorLut = colormap.createLookupTable();
    enabledElement.renderingTools.colormapId = colormapId;
  }

  image.stats = image.stats || {};
  image.stats.lastLutGenerateTime = Object(_internal_now_js__WEBPACK_IMPORTED_MODULE_1__["default"])() - start;
  var colorLut = enabledElement.renderingTools.colorLut;
  var renderCanvasData = enabledElement.renderingTools.renderCanvasData;
  var renderCanvasContext = enabledElement.renderingTools.renderCanvasContext;
  Object(_internal_storedPixelDataToCanvasImageDataColorLUT_js__WEBPACK_IMPORTED_MODULE_5__["default"])(image, colorLut, renderCanvasData.data);
  start = Object(_internal_now_js__WEBPACK_IMPORTED_MODULE_1__["default"])();
  renderCanvasContext.putImageData(renderCanvasData, 0, 0);
  image.stats.lastPutImageDataTime = Object(_internal_now_js__WEBPACK_IMPORTED_MODULE_1__["default"])() - start;
  return renderCanvas;
}
/**
 * API function to draw a label map image to a given enabledElement
 *
 * @param {EnabledElement} enabledElement The Cornerstone Enabled Element to redraw
 * @param {Boolean} invalidated - true if pixel data has been invalidated and cached rendering should not be used
 * @returns {void}
 * @memberof rendering
 */


function renderLabelMapImage(enabledElement, invalidated) {
  if (enabledElement === undefined) {
    throw new Error('renderLabelMapImage: enabledElement parameter must not be undefined');
  }

  var image = enabledElement.image;

  if (image === undefined) {
    throw new Error('renderLabelMapImage: image must be loaded before it can be drawn');
  } // Get the canvas context and reset the transform


  var context = enabledElement.canvas.getContext('2d');
  context.setTransform(1, 0, 0, 1, 0, 0); // Clear the canvas

  context.fillStyle = 'black';
  context.fillRect(0, 0, enabledElement.canvas.width, enabledElement.canvas.height); // Turn off image smooth/interpolation if pixelReplication is set in the viewport

  context.imageSmoothingEnabled = !enabledElement.viewport.pixelReplication;
  context.mozImageSmoothingEnabled = context.imageSmoothingEnabled; // Save the canvas context state and apply the viewport properties

  Object(_setToPixelCoordinateSystem_js__WEBPACK_IMPORTED_MODULE_0__["default"])(enabledElement, context); // If no options are set we will retrieve the renderCanvas through the
  // Normal Canvas rendering path
  // TODO: Add WebGL support for label map pipeline

  var renderCanvas = getRenderCanvas(enabledElement, image, invalidated);
  var sx = enabledElement.viewport.displayedArea.tlhc.x - 1;
  var sy = enabledElement.viewport.displayedArea.tlhc.y - 1;
  var width = enabledElement.viewport.displayedArea.brhc.x - sx;
  var height = enabledElement.viewport.displayedArea.brhc.y - sy;
  context.drawImage(renderCanvas, sx, sy, width, height, 0, 0, width, height);
  enabledElement.renderingTools = Object(_saveLastRendered_js__WEBPACK_IMPORTED_MODULE_3__["default"])(enabledElement);
}
/**
 * API function to draw a pseudo-color image to a given layer
 *
 * @param {EnabledElementLayer} layer The layer that the image will be added to
 * @param {Boolean} invalidated - true if pixel data has been invalidated and cached rendering should not be used
 * @returns {void}
 */

function addLabelMapLayer(layer, invalidated) {
  if (layer === undefined) {
    throw new Error('addLabelMapLayer: layer parameter must not be undefined');
  }

  var image = layer.image;

  if (image === undefined) {
    throw new Error('addLabelMapLayer: image must be loaded before it can be drawn');
  }

  layer.canvas = getRenderCanvas(layer, image, invalidated);
  var context = layer.canvas.getContext('2d'); // Turn off image smooth/interpolation if pixelReplication is set in the viewport

  context.imageSmoothingEnabled = !layer.viewport.pixelReplication;
  context.mozImageSmoothingEnabled = context.imageSmoothingEnabled;
  layer.renderingTools = Object(_saveLastRendered_js__WEBPACK_IMPORTED_MODULE_3__["default"])(layer);
}

/***/ }),

/***/ "./rendering/renderPseudoColorImage.js":
/*!*********************************************!*\
  !*** ./rendering/renderPseudoColorImage.js ***!
  \*********************************************/
/*! exports provided: renderPseudoColorImage, addPseudoColorLayer */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "renderPseudoColorImage", function() { return renderPseudoColorImage; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "addPseudoColorLayer", function() { return addPseudoColorLayer; });
/* harmony import */ var _setToPixelCoordinateSystem_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ../setToPixelCoordinateSystem.js */ "./setToPixelCoordinateSystem.js");
/* harmony import */ var _internal_now_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ../internal/now.js */ "./internal/now.js");
/* harmony import */ var _initializeRenderCanvas_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./initializeRenderCanvas.js */ "./rendering/initializeRenderCanvas.js");
/* harmony import */ var _getLut_js__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ./getLut.js */ "./rendering/getLut.js");
/* harmony import */ var _saveLastRendered_js__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! ./saveLastRendered.js */ "./rendering/saveLastRendered.js");
/* harmony import */ var _doesImageNeedToBeRendered_js__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(/*! ./doesImageNeedToBeRendered.js */ "./rendering/doesImageNeedToBeRendered.js");
/* harmony import */ var _internal_storedPixelDataToCanvasImageDataPseudocolorLUT_js__WEBPACK_IMPORTED_MODULE_6__ = __webpack_require__(/*! ../internal/storedPixelDataToCanvasImageDataPseudocolorLUT.js */ "./internal/storedPixelDataToCanvasImageDataPseudocolorLUT.js");
/* harmony import */ var _colors_index_js__WEBPACK_IMPORTED_MODULE_7__ = __webpack_require__(/*! ../colors/index.js */ "./colors/index.js");








/**
 * Returns an appropriate canvas to render the Image. If the canvas available in the cache is appropriate
 * it is returned, otherwise adjustments are made. It also sets the color transfer functions.
 *
 * @param {Object} enabledElement The cornerstone enabled element
 * @param {Object} image The image to be rendered
 * @param {Boolean} invalidated Is pixel data valid
 * @returns {HTMLCanvasElement} An appropriate canvas for rendering the image
 * @memberof rendering
 */

function getRenderCanvas(enabledElement, image, invalidated) {
  if (!enabledElement.renderingTools.renderCanvas) {
    enabledElement.renderingTools.renderCanvas = document.createElement('canvas');
  }

  var renderCanvas = enabledElement.renderingTools.renderCanvas;
  var colormap = enabledElement.viewport.colormap || enabledElement.options.colormap;

  if (enabledElement.options.colormap) {
    console.warn('enabledElement.options.colormap is deprecated. Use enabledElement.viewport.colormap instead');
  }

  if (colormap && typeof colormap === 'string') {
    colormap = _colors_index_js__WEBPACK_IMPORTED_MODULE_7__["default"].getColormap(colormap);
  }

  if (!colormap) {
    throw new Error('renderPseudoColorImage: colormap not found.');
  }

  var colormapId = colormap.getId();

  if (Object(_doesImageNeedToBeRendered_js__WEBPACK_IMPORTED_MODULE_5__["default"])(enabledElement, image) === false && invalidated !== true && enabledElement.renderingTools.colormapId === colormapId) {
    return renderCanvas;
  } // If our render canvas does not match the size of this image reset it
  // NOTE: This might be inefficient if we are updating multiple images of different
  // Sizes frequently.


  if (renderCanvas.width !== image.width || renderCanvas.height !== image.height) {
    Object(_initializeRenderCanvas_js__WEBPACK_IMPORTED_MODULE_2__["default"])(enabledElement, image);
  } // Get the lut to use


  var start = Object(_internal_now_js__WEBPACK_IMPORTED_MODULE_1__["default"])();

  if (!enabledElement.renderingTools.colorLut || invalidated || enabledElement.renderingTools.colormapId !== colormapId) {
    colormap.setNumberOfColors(256);
    enabledElement.renderingTools.colorLut = colormap.createLookupTable();
    enabledElement.renderingTools.colormapId = colormapId;
  }

  var lut = Object(_getLut_js__WEBPACK_IMPORTED_MODULE_3__["default"])(image, enabledElement.viewport, invalidated);
  image.stats = image.stats || {};
  image.stats.lastLutGenerateTime = Object(_internal_now_js__WEBPACK_IMPORTED_MODULE_1__["default"])() - start;
  var colorLut = enabledElement.renderingTools.colorLut;
  var renderCanvasData = enabledElement.renderingTools.renderCanvasData;
  var renderCanvasContext = enabledElement.renderingTools.renderCanvasContext;
  Object(_internal_storedPixelDataToCanvasImageDataPseudocolorLUT_js__WEBPACK_IMPORTED_MODULE_6__["default"])(image, lut, colorLut, renderCanvasData.data);
  start = Object(_internal_now_js__WEBPACK_IMPORTED_MODULE_1__["default"])();
  renderCanvasContext.putImageData(renderCanvasData, 0, 0);
  image.stats.lastPutImageDataTime = Object(_internal_now_js__WEBPACK_IMPORTED_MODULE_1__["default"])() - start;
  return renderCanvas;
}
/**
 * API function to draw a pseudo-color image to a given enabledElement
 *
 * @param {EnabledElement} enabledElement The Cornerstone Enabled Element to redraw
 * @param {Boolean} invalidated - true if pixel data has been invalidated and cached rendering should not be used
 * @returns {void}
 * @memberof rendering
 */


function renderPseudoColorImage(enabledElement, invalidated) {
  if (enabledElement === undefined) {
    throw new Error('drawImage: enabledElement parameter must not be undefined');
  }

  var image = enabledElement.image;

  if (image === undefined) {
    throw new Error('drawImage: image must be loaded before it can be drawn');
  } // Get the canvas context and reset the transform


  var context = enabledElement.canvas.getContext('2d');
  context.setTransform(1, 0, 0, 1, 0, 0); // Clear the canvas

  context.fillStyle = 'black';
  context.fillRect(0, 0, enabledElement.canvas.width, enabledElement.canvas.height); // Turn off image smooth/interpolation if pixelReplication is set in the viewport

  context.imageSmoothingEnabled = !enabledElement.viewport.pixelReplication;
  context.mozImageSmoothingEnabled = context.imageSmoothingEnabled; // Save the canvas context state and apply the viewport properties

  Object(_setToPixelCoordinateSystem_js__WEBPACK_IMPORTED_MODULE_0__["default"])(enabledElement, context); // If no options are set we will retrieve the renderCanvas through the
  // Normal Canvas rendering path
  // TODO: Add WebGL support for pseudocolor pipeline

  var renderCanvas = getRenderCanvas(enabledElement, image, invalidated);
  var sx = enabledElement.viewport.displayedArea.tlhc.x - 1;
  var sy = enabledElement.viewport.displayedArea.tlhc.y - 1;
  var width = enabledElement.viewport.displayedArea.brhc.x - sx;
  var height = enabledElement.viewport.displayedArea.brhc.y - sy;
  context.drawImage(renderCanvas, sx, sy, width, height, 0, 0, width, height);
  enabledElement.renderingTools = Object(_saveLastRendered_js__WEBPACK_IMPORTED_MODULE_4__["default"])(enabledElement);
}
/**
 * API function to draw a pseudo-color image to a given layer
 *
 * @param {EnabledElementLayer} layer The layer that the image will be added to
 * @param {Boolean} invalidated - true if pixel data has been invalidated and cached rendering should not be used
 * @returns {void}
 */

function addPseudoColorLayer(layer, invalidated) {
  if (layer === undefined) {
    throw new Error('addPseudoColorLayer: layer parameter must not be undefined');
  }

  var image = layer.image;

  if (image === undefined) {
    throw new Error('addPseudoColorLayer: image must be loaded before it can be drawn');
  }

  layer.canvas = getRenderCanvas(layer, image, invalidated);
  var context = layer.canvas.getContext('2d'); // Turn off image smooth/interpolation if pixelReplication is set in the viewport

  context.imageSmoothingEnabled = !layer.viewport.pixelReplication;
  context.mozImageSmoothingEnabled = context.imageSmoothingEnabled;
  layer.renderingTools = Object(_saveLastRendered_js__WEBPACK_IMPORTED_MODULE_4__["default"])(layer);
}

/***/ }),

/***/ "./rendering/renderToCanvas.js":
/*!*************************************!*\
  !*** ./rendering/renderToCanvas.js ***!
  \*************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _triggerEvent_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ../triggerEvent.js */ "./triggerEvent.js");
/* harmony import */ var _events_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ../events.js */ "./events.js");
/* harmony import */ var _internal_drawImageSync_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ../internal/drawImageSync.js */ "./internal/drawImageSync.js");
/* harmony import */ var _internal_getDefaultViewport_js__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ../internal/getDefaultViewport.js */ "./internal/getDefaultViewport.js");
/* harmony import */ var _internal_tryEnableWebgl_js__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! ../internal/tryEnableWebgl.js */ "./internal/tryEnableWebgl.js");





/**
 * @typedef {Object} EnabledElementStub
 * @property {HTMLElement} element  The enabled element
 * @property {HTMLCanvasElement} canvas The current canvas
 * @property {Object} image Currently displayed image
 * @property {Boolean} invalid Whether or not the image pixel data has been changed
 * @property {Boolean} needsRedraw  A flag for triggering a redraw of the canvas without re-retrieving the pixel data, since it remains valid
 * @property {Object} options Layer drawing options
 * @property {Object[]} layers Layers added to the EnabledElement
 * @property {Object} data
 * @property {Object} renderingTools
 * @property {Object} viewport The current viewport
 * @memberof rendering
 */

/**
 * creates a dummy enabled element
 *
 * @param {HTMLCanvasElement} canvas the canvas that will be assigned to the enabled element.
 * @param {any} image An Image loaded by a Cornerstone Image Loader
 * @param { any } options Options for rendering the image (e.g.enable webgl by {renderer: 'webgl' })
 * @param { any } viewport A set of Cornerstone viewport parameters
 * @returns {EnabledElementStub} a dummy enabled element
 * @memberof rendering
 */

function createEnabledElementStub(canvas, image, options, viewport) {
  return {
    element: canvas,
    canvas: canvas,
    image: image,
    invalid: true,
    // True if image needs to be drawn, false if not
    needsRedraw: true,
    options: options,
    layers: [],
    data: {},
    renderingTools: {},
    viewport: viewport
  };
}
/**
 * Render the image to the provided canvas immediately.
 * @param {any} canvas The HTML canvas where the image will be rendered.
 * @param {any} image An Image loaded by a Cornerstone Image Loader
 * @param {any} [viewport = null] A set of Cornerstone viewport parameters
 * @param {any} [options = null] Options for rendering the image (e.g. enable webgl by {renderer: 'webgl'})
 * @returns {void}
 * @memberof rendering
 */


/* harmony default export */ __webpack_exports__["default"] = (function (canvas, image) {
  var viewport = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : null;
  var options = arguments.length > 3 && arguments[3] !== undefined ? arguments[3] : null;

  if (canvas === undefined) {
    throw new Error('renderToCanvas: parameter canvas cannot be undefined');
  } // If this enabled element has the option set for WebGL, we should
  // Check if this device actually supports it


  if (options && options.renderer && options.renderer.toLowerCase() === 'webgl') {
    Object(_internal_tryEnableWebgl_js__WEBPACK_IMPORTED_MODULE_4__["default"])(options);
  }

  var defaultViewport = Object(_internal_getDefaultViewport_js__WEBPACK_IMPORTED_MODULE_3__["default"])(canvas, image);

  if (viewport) {
    Object.assign(defaultViewport, viewport);
  }

  var enabledElementStub = createEnabledElementStub(canvas, image, options, defaultViewport);
  var eventDetails = {
    enabledElement: enabledElementStub,
    timestamp: Date.now()
  };
  Object(_triggerEvent_js__WEBPACK_IMPORTED_MODULE_0__["default"])(enabledElementStub.element, _events_js__WEBPACK_IMPORTED_MODULE_1__["default"].PRE_RENDER, eventDetails);
  Object(_internal_drawImageSync_js__WEBPACK_IMPORTED_MODULE_2__["default"])(enabledElementStub, enabledElementStub.invalid);
});

/***/ }),

/***/ "./rendering/renderWebImage.js":
/*!*************************************!*\
  !*** ./rendering/renderWebImage.js ***!
  \*************************************/
/*! exports provided: renderWebImage */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "renderWebImage", function() { return renderWebImage; });
/* harmony import */ var _setToPixelCoordinateSystem_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ../setToPixelCoordinateSystem.js */ "./setToPixelCoordinateSystem.js");
/* harmony import */ var _renderColorImage_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./renderColorImage.js */ "./rendering/renderColorImage.js");


/**
 * API function to draw a standard web image (PNG, JPG) to an enabledImage
 *
 * @param {EnabledElement} enabledElement The Cornerstone Enabled Element to redraw
 * @param {Boolean} invalidated - true if pixel data has been invalidated and cached rendering should not be used
 * @returns {void}
 * @memberof rendering
 */

function renderWebImage(enabledElement, invalidated) {
  if (enabledElement === undefined) {
    throw new Error('renderWebImage: enabledElement parameter must not be undefined');
  }

  var image = enabledElement.image;

  if (image === undefined) {
    throw new Error('renderWebImage: image must be loaded before it can be drawn');
  } // If the viewport ww/wc and invert all match the initial state of the image, we can draw the image
  // Directly. If any of those are changed, we call renderColorImage() to apply the lut


  if (enabledElement.viewport.voi.windowWidth === enabledElement.image.windowWidth && enabledElement.viewport.voi.windowCenter === enabledElement.image.windowCenter && enabledElement.viewport.invert === false) {
    // Get the canvas context and reset the transform
    var context = enabledElement.canvas.getContext('2d');
    context.setTransform(1, 0, 0, 1, 0, 0); // Clear the canvas

    context.fillStyle = 'black';
    context.fillRect(0, 0, enabledElement.canvas.width, enabledElement.canvas.height); // Turn off image smooth/interpolation if pixelReplication is set in the viewport

    context.imageSmoothingEnabled = !enabledElement.viewport.pixelReplication;
    context.mozImageSmoothingEnabled = context.imageSmoothingEnabled; // Save the canvas context state and apply the viewport properties

    Object(_setToPixelCoordinateSystem_js__WEBPACK_IMPORTED_MODULE_0__["default"])(enabledElement, context);
    var sx = enabledElement.viewport.displayedArea.tlhc.x - 1;
    var sy = enabledElement.viewport.displayedArea.tlhc.y - 1;
    var width = enabledElement.viewport.displayedArea.brhc.x - sx;
    var height = enabledElement.viewport.displayedArea.brhc.y - sy;
    context.drawImage(image.getImage(), sx, sy, width, height, 0, 0, width, height);
  } else {
    Object(_renderColorImage_js__WEBPACK_IMPORTED_MODULE_1__["renderColorImage"])(enabledElement, invalidated);
  }
}

/***/ }),

/***/ "./rendering/saveLastRendered.js":
/*!***************************************!*\
  !*** ./rendering/saveLastRendered.js ***!
  \***************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/**
 * Saves the parameters of the last render into renderingTools, used later to decide if data can be reused.
 *
 * @param {Object} enabledElement Cornerstone EnabledElement
 * @returns {Object} enabledElement.renderingTools
 * @memberof rendering
 */
/* harmony default export */ __webpack_exports__["default"] = (function (enabledElement) {
  var imageId = enabledElement.image.imageId;
  var viewport = enabledElement.viewport;
  var isColor = enabledElement.image.color;
  enabledElement.renderingTools.lastRenderedImageId = imageId;
  enabledElement.renderingTools.lastRenderedIsColor = isColor;
  enabledElement.renderingTools.lastRenderedViewport = {
    windowCenter: viewport.voi.windowCenter,
    windowWidth: viewport.voi.windowWidth,
    invert: viewport.invert,
    rotation: viewport.rotation,
    hflip: viewport.hflip,
    vflip: viewport.vflip,
    modalityLUT: viewport.modalityLUT,
    voiLUT: viewport.voiLUT,
    colormap: viewport.colormap
  };
  return enabledElement.renderingTools;
});

/***/ }),

/***/ "./reset.js":
/*!******************!*\
  !*** ./reset.js ***!
  \******************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _enabledElements_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./enabledElements.js */ "./enabledElements.js");
/* harmony import */ var _internal_getDefaultViewport_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./internal/getDefaultViewport.js */ "./internal/getDefaultViewport.js");
/* harmony import */ var _updateImage_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./updateImage.js */ "./updateImage.js");



/**
 * Resets the viewport to the default settings
 *
 * @param {HTMLElement} element An HTML Element enabled for Cornerstone
 * @returns {void}
 */

/* harmony default export */ __webpack_exports__["default"] = (function (element) {
  var enabledElement = Object(_enabledElements_js__WEBPACK_IMPORTED_MODULE_0__["getEnabledElement"])(element);
  enabledElement.viewport = Object(_internal_getDefaultViewport_js__WEBPACK_IMPORTED_MODULE_1__["default"])(enabledElement.canvas, enabledElement.image);
  Object(_updateImage_js__WEBPACK_IMPORTED_MODULE_2__["default"])(element);
});

/***/ }),

/***/ "./resize.js":
/*!*******************!*\
  !*** ./resize.js ***!
  \*******************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _enabledElements_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./enabledElements.js */ "./enabledElements.js");
/* harmony import */ var _fitToWindow_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./fitToWindow.js */ "./fitToWindow.js");
/* harmony import */ var _updateImage_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./updateImage.js */ "./updateImage.js");
/* harmony import */ var _triggerEvent_js__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ./triggerEvent.js */ "./triggerEvent.js");
/* harmony import */ var _internal_getImageSize_js__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! ./internal/getImageSize.js */ "./internal/getImageSize.js");
/* harmony import */ var _events_js__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(/*! ./events.js */ "./events.js");






/**
 * This module is responsible for enabling an element to display images with cornerstone
 *
 * @param {HTMLElement} element The DOM element enabled for Cornerstone
 * @param {HTMLElement} canvas The Canvas DOM element within the DOM element enabled for Cornerstone
 * @returns {void}
 */

function setCanvasSize(element, canvas) {
  // The device pixel ratio is 1.0 for normal displays and > 1.0
  // For high DPI displays like Retina

  /*
      This functionality is disabled due to buggy behavior on systems with mixed DPI's.  If the canvas
    is created on a display with high DPI (e.g. 2.0) and then the browser window is dragged to
    a different display with a different DPI (e.g. 1.0), the canvas is not recreated so the pageToPixel
    produces incorrect results.  I couldn't find any way to determine when the DPI changed other than
    by polling which is not very clean.  If anyone has any ideas here, please let me know, but for now
    we will disable this functionality.  We may want
    to add a mechanism to optionally enable this functionality if we can determine it is safe to do
    so (e.g. iPad or iPhone or perhaps enumerate the displays on the system.  I am choosing
    to be cautious here since I would rather not have bug reports or safety issues related to this
    scenario.
      var devicePixelRatio = window.devicePixelRatio;
    if(devicePixelRatio === undefined) {
        devicePixelRatio = 1.0;
    }
    */
  // Avoid setting the same value because it flashes the canvas with IE and Edge
  if (canvas.width !== element.clientWidth) {
    canvas.width = element.clientWidth;
    canvas.style.width = "".concat(element.clientWidth, "px");
  } // Avoid setting the same value because it flashes the canvas with IE and Edge


  if (canvas.height !== element.clientHeight) {
    canvas.height = element.clientHeight;
    canvas.style.height = "".concat(element.clientHeight, "px");
  }
}
/**
 * Checks if the image of a given enabled element fitted the window
 * before the resize
 *
 * @param {EnabledElement} enabledElement The Cornerstone Enabled Element
 * @param {number} oldCanvasWidth The width of the canvas before the resize
 * @param {number} oldCanvasHeight The height of the canvas before the resize
 * @return {Boolean} true if it fitted the windows, false otherwise
 */


function wasFitToWindow(enabledElement, oldCanvasWidth, oldCanvasHeight) {
  var scale = enabledElement.viewport.scale;
  var imageSize = Object(_internal_getImageSize_js__WEBPACK_IMPORTED_MODULE_4__["default"])(enabledElement.image, enabledElement.viewport.rotation);
  var imageWidth = Math.round(imageSize.width * scale);
  var imageHeight = Math.round(imageSize.height * scale);
  var x = enabledElement.viewport.translation.x;
  var y = enabledElement.viewport.translation.y;
  return imageWidth === oldCanvasWidth && imageHeight <= oldCanvasHeight || imageWidth <= oldCanvasWidth && imageHeight === oldCanvasHeight && x === 0 && y === 0;
}
/**
 * Rescale the image relative to the changed size of the canvas
 *
 * @param {EnabledElement} enabledElement The Cornerstone Enabled Element
 * @param {number} oldCanvasWidth The width of the canvas before the resize
 * @param {number} oldCanvasHeight The height of the canvas before the resize
 * @return {void}
 */


function relativeRescale(enabledElement, oldCanvasWidth, oldCanvasHeight) {
  var scale = enabledElement.viewport.scale;
  var canvasWidth = enabledElement.canvas.width;
  var canvasHeight = enabledElement.canvas.height;
  var relWidthChange = canvasWidth / oldCanvasWidth;
  var relHeightChange = canvasHeight / oldCanvasHeight;
  var relChange = Math.sqrt(relWidthChange * relHeightChange);
  enabledElement.viewport.scale = relChange * scale;
}
/**
 * Resizes an enabled element and optionally fits the image to window
 *
 * @param {HTMLElement} element The DOM element enabled for Cornerstone
 * @param {Boolean} forceFitToWindow true to to force a refit, false to rescale accordingly
 * @returns {void}
 */


/* harmony default export */ __webpack_exports__["default"] = (function (element, forceFitToWindow) {
  var enabledElement = Object(_enabledElements_js__WEBPACK_IMPORTED_MODULE_0__["getEnabledElement"])(element);
  var oldCanvasWidth = enabledElement.canvas.width;
  var oldCanvasHeight = enabledElement.canvas.height;
  setCanvasSize(element, enabledElement.canvas);
  var eventData = {
    element: element
  };
  Object(_triggerEvent_js__WEBPACK_IMPORTED_MODULE_3__["default"])(element, _events_js__WEBPACK_IMPORTED_MODULE_5__["default"].ELEMENT_RESIZED, eventData);

  if (enabledElement.image === undefined) {
    return;
  }

  if (forceFitToWindow || wasFitToWindow(enabledElement, oldCanvasWidth, oldCanvasHeight)) {
    // Fit the image to the window again if it fitted before the resize
    Object(_fitToWindow_js__WEBPACK_IMPORTED_MODULE_1__["default"])(element);
  } else {
    // Adapt the scale of a zoomed or panned image relative to the size change
    relativeRescale(enabledElement, oldCanvasWidth, oldCanvasHeight);
    Object(_updateImage_js__WEBPACK_IMPORTED_MODULE_2__["default"])(element);
  }
});

/***/ }),

/***/ "./setToPixelCoordinateSystem.js":
/*!***************************************!*\
  !*** ./setToPixelCoordinateSystem.js ***!
  \***************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _internal_calculateTransform_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./internal/calculateTransform.js */ "./internal/calculateTransform.js");

/**
 * Sets the canvas context transformation matrix to the pixel coordinate system.  This allows
 * geometry to be driven using the canvas context using coordinates in the pixel coordinate system
 * @param {EnabledElement} enabledElement The
 * @param {CanvasRenderingContext2D} context The CanvasRenderingContext2D for the enabledElement's Canvas
 * @param {Number} [scale] Optional scale to apply
 * @returns {void}
 */

/* harmony default export */ __webpack_exports__["default"] = (function (enabledElement, context, scale) {
  if (enabledElement === undefined) {
    throw new Error('setToPixelCoordinateSystem: parameter enabledElement must not be undefined');
  }

  if (context === undefined) {
    throw new Error('setToPixelCoordinateSystem: parameter context must not be undefined');
  }

  var transform = Object(_internal_calculateTransform_js__WEBPACK_IMPORTED_MODULE_0__["default"])(enabledElement, scale);
  context.setTransform(transform.m[0], transform.m[1], transform.m[2], transform.m[3], transform.m[4], transform.m[5]);
});

/***/ }),

/***/ "./setViewport.js":
/*!************************!*\
  !*** ./setViewport.js ***!
  \************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _internal_getDefaultViewport_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./internal/getDefaultViewport.js */ "./internal/getDefaultViewport.js");
/* harmony import */ var _enabledElements_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./enabledElements.js */ "./enabledElements.js");
/* harmony import */ var _updateImage_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./updateImage.js */ "./updateImage.js");



var MIN_WINDOW_WIDTH = 0.000001;
var MIN_VIEWPORT_SCALE = 0.0001;
/**
 * Sets/updates viewport of a given enabled element
 *
 * @param {HTMLElement} element - DOM element of the enabled element
 * @param {Viewport} [viewport] - Object containing the viewport properties
 * @returns {void}
 * @memberof ViewportSettings
 */

/* harmony default export */ __webpack_exports__["default"] = (function (element, viewport) {
  var enabledElement = Object(_enabledElements_js__WEBPACK_IMPORTED_MODULE_1__["getEnabledElement"])(element); // If viewport is not already set, start with default and merge new
  // viewport options later

  if (enabledElement.viewport === undefined) {
    enabledElement.viewport = Object(_internal_getDefaultViewport_js__WEBPACK_IMPORTED_MODULE_0__["default"])(enabledElement.canvas);
  } // Merge viewport


  if (viewport) {
    for (var attrname in viewport) {
      if (viewport[attrname] !== null) {
        enabledElement.viewport[attrname] = viewport[attrname];
      }
    }
  } // Prevent window width from being too small (note that values close to zero are valid and can occur with
  // PET images in particular)


  if (enabledElement.viewport.voi.windowWidth) {
    enabledElement.viewport.voi.windowWidth = Math.max(viewport.voi.windowWidth, MIN_WINDOW_WIDTH);
  } // Prevent scale from getting too small


  if (enabledElement.viewport.scale) {
    enabledElement.viewport.scale = Math.max(viewport.scale, MIN_VIEWPORT_SCALE);
  } // Normalize the rotation value to a positive rotation in degrees


  enabledElement.viewport.rotation %= 360;

  if (enabledElement.viewport.rotation < 0) {
    enabledElement.viewport.rotation += 360;
  }

  if (enabledElement.image) {
    // Force the image to be updated since the viewport has been modified
    Object(_updateImage_js__WEBPACK_IMPORTED_MODULE_2__["default"])(element);
  }
});

/***/ }),

/***/ "./triggerEvent.js":
/*!*************************!*\
  !*** ./triggerEvent.js ***!
  \*************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return triggerEvent; });
/**
 * Trigger a CustomEvent
 *
 * @param {EventTarget} el The element or EventTarget to trigger the event upon
 * @param {String} type The event type name
 * @param {Object|null} detail=null The event data to be sent
 * @returns {Boolean} The return value is false if at least one event listener called preventDefault(). Otherwise it returns true.
 */
function triggerEvent(el, type) {
  var detail = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : null;
  var event; // This check is needed to polyfill CustomEvent on IE11-

  if (typeof window.CustomEvent === 'function') {
    event = new CustomEvent(type, {
      detail: detail,
      cancelable: true
    });
  } else {
    event = document.createEvent('CustomEvent');
    event.initCustomEvent(type, true, true, detail);
  }

  return el.dispatchEvent(event);
}

/***/ }),

/***/ "./updateImage.js":
/*!************************!*\
  !*** ./updateImage.js ***!
  \************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _enabledElements_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./enabledElements.js */ "./enabledElements.js");
/* harmony import */ var _internal_drawImage_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./internal/drawImage.js */ "./internal/drawImage.js");


/**
 * Forces the image to be updated/redrawn for the specified enabled element
 * @param {HTMLElement} element An HTML Element enabled for Cornerstone
 * @param {Boolean} [invalidated=false] Whether or not the image pixel data has been changed, necessitating a redraw
 *
 * @returns {void}
 * @memberof Drawing
 */

/* harmony default export */ __webpack_exports__["default"] = (function (element) {
  var invalidated = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : false;
  var enabledElement = Object(_enabledElements_js__WEBPACK_IMPORTED_MODULE_0__["getEnabledElement"])(element);

  if (enabledElement.image === undefined && !enabledElement.layers.length) {
    throw new Error('updateImage: image has not been loaded yet');
  }

  Object(_internal_drawImage_js__WEBPACK_IMPORTED_MODULE_1__["default"])(enabledElement, invalidated);
});

/***/ }),

/***/ "./webgl/createProgramFromString.js":
/*!******************************************!*\
  !*** ./webgl/createProgramFromString.js ***!
  \******************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/**
 * Creates and compiles a shader.
 *
 * @param {!WebGLRenderingContext} gl The WebGL Context.
 * @param {string} shaderSource The GLSL source code for the shader.
 * @param {number} shaderType The type of shader, VERTEX_SHADER or FRAGMENT_SHADER.
 *
 * @return {!WebGLShader} The shader.
 * @memberof WebGLRendering
 */
function compileShader(gl, shaderSource, shaderType) {
  // Create the shader object
  var shader = gl.createShader(shaderType); // Set the shader source code.

  gl.shaderSource(shader, shaderSource); // Compile the shader

  gl.compileShader(shader); // Check if it compiled

  var success = gl.getShaderParameter(shader, gl.COMPILE_STATUS);

  if (!success && !gl.isContextLost()) {
    // Something went wrong during compilation; get the error
    var infoLog = gl.getShaderInfoLog(shader);
    console.error("Could not compile shader:\n".concat(infoLog));
  }

  return shader;
}
/**
 * Creates a program from 2 shaders.
 *
 * @param {!WebGLRenderingContext} gl The WebGL context.
 * @param {!WebGLShader} vertexShader A vertex shader.
 * @param {!WebGLShader} fragmentShader A fragment shader.
 * @return {!WebGLProgram} A program.
 * @memberof WebGLRendering
 */


function createProgram(gl, vertexShader, fragmentShader) {
  // Create a program.
  var program = gl.createProgram(); // Attach the shaders.

  gl.attachShader(program, vertexShader);
  gl.attachShader(program, fragmentShader); // Link the program.

  gl.linkProgram(program); // Check if it linked.

  var success = gl.getProgramParameter(program, gl.LINK_STATUS);

  if (!success && !gl.isContextLost()) {
    // Something went wrong with the link
    var infoLog = gl.getProgramInfoLog(program);
    console.error("WebGL program filed to link:\n".concat(infoLog));
  }

  return program;
}
/**
 * Creates a program from 2 shaders source (Strings)
 * @param  {!WebGLRenderingContext} gl              The WebGL context.
 * @param  {!WebGLShader} vertexShaderSrc   Vertex shader string
 * @param  {!WebGLShader} fragShaderSrc Fragment shader string
 * @return {!WebGLProgram}                 A program
 * @memberof WebGLRendering
 */


/* harmony default export */ __webpack_exports__["default"] = (function (gl, vertexShaderSrc, fragShaderSrc) {
  var vertexShader = compileShader(gl, vertexShaderSrc, gl.VERTEX_SHADER);
  var fragShader = compileShader(gl, fragShaderSrc, gl.FRAGMENT_SHADER);
  return createProgram(gl, vertexShader, fragShader);
});

/***/ }),

/***/ "./webgl/index.js":
/*!************************!*\
  !*** ./webgl/index.js ***!
  \************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _renderer_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./renderer.js */ "./webgl/renderer.js");
/* harmony import */ var _createProgramFromString_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./createProgramFromString.js */ "./webgl/createProgramFromString.js");
/* harmony import */ var _textureCache_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./textureCache.js */ "./webgl/textureCache.js");



/**
 * @module WebGLRendering
 */

var mod = {
  createProgramFromString: _createProgramFromString_js__WEBPACK_IMPORTED_MODULE_1__["default"],
  renderer: {
    render: _renderer_js__WEBPACK_IMPORTED_MODULE_0__["render"],
    initRenderer: _renderer_js__WEBPACK_IMPORTED_MODULE_0__["initRenderer"],
    getRenderCanvas: _renderer_js__WEBPACK_IMPORTED_MODULE_0__["getRenderCanvas"],
    isWebGLAvailable: _renderer_js__WEBPACK_IMPORTED_MODULE_0__["isWebGLAvailable"]
  },
  textureCache: _textureCache_js__WEBPACK_IMPORTED_MODULE_2__["default"]
};
Object.defineProperty(mod, 'isWebGLInitialized', {
  enumerable: true,
  configurable: false,
  get: function get() {
    return _renderer_js__WEBPACK_IMPORTED_MODULE_0__["isWebGLInitialized"];
  }
});
/* harmony default export */ __webpack_exports__["default"] = (mod);

/***/ }),

/***/ "./webgl/renderer.js":
/*!***************************!*\
  !*** ./webgl/renderer.js ***!
  \***************************/
/*! exports provided: isWebGLInitialized, getRenderCanvas, initRenderer, render, isWebGLAvailable */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "isWebGLInitialized", function() { return isWebGLInitialized; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "getRenderCanvas", function() { return getRenderCanvas; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "initRenderer", function() { return initRenderer; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "render", function() { return render; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "isWebGLAvailable", function() { return isWebGLAvailable; });
/* harmony import */ var _shaders_index_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./shaders/index.js */ "./webgl/shaders/index.js");
/* harmony import */ var _vertexShader_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./vertexShader.js */ "./webgl/vertexShader.js");
/* harmony import */ var _textureCache_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./textureCache.js */ "./webgl/textureCache.js");
/* harmony import */ var _createProgramFromString_js__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ./createProgramFromString.js */ "./webgl/createProgramFromString.js");
/* eslint no-bitwise: 0 */




var renderCanvas = document.createElement('canvas');
var gl;
var texCoordBuffer;
var positionBuffer;
var isWebGLInitialized = false;

function getRenderCanvas() {
  return renderCanvas;
}

function initShaders() {
  for (var id in _shaders_index_js__WEBPACK_IMPORTED_MODULE_0__["shaders"]) {
    // Console.log("WEBGL: Loading shader", id);
    var shader = _shaders_index_js__WEBPACK_IMPORTED_MODULE_0__["shaders"][id];
    shader.attributes = {};
    shader.uniforms = {};
    shader.vert = _vertexShader_js__WEBPACK_IMPORTED_MODULE_1__["vertexShader"];
    shader.program = Object(_createProgramFromString_js__WEBPACK_IMPORTED_MODULE_3__["default"])(gl, shader.vert, shader.frag);
    shader.attributes.texCoordLocation = gl.getAttribLocation(shader.program, 'a_texCoord');
    gl.enableVertexAttribArray(shader.attributes.texCoordLocation);
    shader.attributes.positionLocation = gl.getAttribLocation(shader.program, 'a_position');
    gl.enableVertexAttribArray(shader.attributes.positionLocation);
    shader.uniforms.resolutionLocation = gl.getUniformLocation(shader.program, 'u_resolution');
  }
}

function initRenderer() {
  if (isWebGLInitialized === true) {
    // Console.log("WEBGL Renderer already initialized");
    return;
  }

  if (initWebGL(renderCanvas)) {
    initBuffers();
    initShaders(); // Console.log("WEBGL Renderer initialized!");

    isWebGLInitialized = true;
  }
}

function updateRectangle(gl, width, height) {
  gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([width, height, 0, height, width, 0, 0, 0]), gl.STATIC_DRAW);
}

function handleLostContext(event) {
  event.preventDefault();
  console.warn('WebGL Context Lost!');
}

function handleRestoredContext(event) {
  event.preventDefault();
  isWebGLInitialized = false;
  _textureCache_js__WEBPACK_IMPORTED_MODULE_2__["default"].purgeCache();
  initRenderer(); // Console.log('WebGL Context Restored.');
}

function initWebGL(canvas) {
  gl = null;

  try {
    // Try to grab the standard context. If it fails, fallback to experimental.
    var options = {
      preserveDrawingBuffer: true // Preserve buffer so we can copy to display canvas element

    }; // ---------------- Testing purposes -------------
    // If (debug === true && WebGLDebugUtils) {
    //    RenderCanvas = WebGLDebugUtils.makeLostContextSimulatingCanvas(renderCanvas);
    // }
    // ---------------- Testing purposes -------------

    gl = canvas.getContext('webgl', options) || canvas.getContext('experimental-webgl', options); // Set up event listeners for context lost / context restored

    canvas.removeEventListener('webglcontextlost', handleLostContext, false);
    canvas.addEventListener('webglcontextlost', handleLostContext, false);
    canvas.removeEventListener('webglcontextrestored', handleRestoredContext, false);
    canvas.addEventListener('webglcontextrestored', handleRestoredContext, false);
  } catch (error) {
    throw new Error('Error creating WebGL context');
  } // If we don't have a GL context, give up now


  if (!gl) {
    console.error('Unable to initialize WebGL. Your browser may not support it.');
    gl = null;
  }

  return gl;
}
/**
 * Returns the image data type as a string representation.
 * @param {any} image The cornerstone image object
 * @returns {string} image data type (rgb, iint16, uint16, int8 and uint8)
 * @memberof WebGLRendering
 */


function getImageDataType(image) {
  if (image.color) {
    return 'rgb';
  }

  var pixelData = image.getPixelData();

  if (pixelData instanceof Int16Array) {
    return 'int16';
  }

  if (pixelData instanceof Uint16Array) {
    return 'uint16';
  }

  if (pixelData instanceof Int8Array) {
    return 'int8';
  }

  return 'uint8';
}

function getShaderProgram(image) {
  var datatype = getImageDataType(image); // We need a mechanism for
  // Choosing the shader based on the image datatype
  // Console.log("Datatype: " + datatype);

  if (_shaders_index_js__WEBPACK_IMPORTED_MODULE_0__["shaders"].hasOwnProperty(datatype)) {
    return _shaders_index_js__WEBPACK_IMPORTED_MODULE_0__["shaders"][datatype];
  }

  return _shaders_index_js__WEBPACK_IMPORTED_MODULE_0__["shaders"].rgb;
}

function generateTexture(image) {
  var TEXTURE_FORMAT = {
    uint8: gl.LUMINANCE,
    int8: gl.LUMINANCE_ALPHA,
    uint16: gl.LUMINANCE_ALPHA,
    int16: gl.RGB,
    rgb: gl.RGB
  };
  var TEXTURE_BYTES = {
    int8: 1,
    // Luminance
    uint16: 2,
    // Luminance + Alpha
    int16: 3,
    // RGB
    rgb: 3 // RGB

  };
  var imageDataType = getImageDataType(image);
  var format = TEXTURE_FORMAT[imageDataType]; // GL texture configuration

  var texture = gl.createTexture();
  gl.bindTexture(gl.TEXTURE_2D, texture);
  gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
  gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
  gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
  gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
  gl.pixelStorei(gl.UNPACK_ALIGNMENT, 1);
  var imageData = _shaders_index_js__WEBPACK_IMPORTED_MODULE_0__["dataUtilities"][imageDataType].storedPixelDataToImageData(image, image.width, image.height);
  gl.texImage2D(gl.TEXTURE_2D, 0, format, image.width, image.height, 0, format, gl.UNSIGNED_BYTE, imageData); // Calculate the size in bytes of this image in memory

  var sizeInBytes = image.width * image.height * TEXTURE_BYTES[imageDataType];
  return {
    texture: texture,
    sizeInBytes: sizeInBytes
  };
}

function getImageTexture(image) {
  var imageTexture = _textureCache_js__WEBPACK_IMPORTED_MODULE_2__["default"].getImageTexture(image.imageId);

  if (!imageTexture) {
    // Console.log("Generating texture for imageid: ", image.imageId);
    imageTexture = generateTexture(image);
    _textureCache_js__WEBPACK_IMPORTED_MODULE_2__["default"].putImageTexture(image, imageTexture);
  }

  return imageTexture.texture;
}

function initBuffers() {
  positionBuffer = gl.createBuffer();
  gl.bindBuffer(gl.ARRAY_BUFFER, positionBuffer);
  gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([1, 1, 0, 1, 1, 0, 0, 0]), gl.STATIC_DRAW);
  texCoordBuffer = gl.createBuffer();
  gl.bindBuffer(gl.ARRAY_BUFFER, texCoordBuffer);
  gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([1.0, 1.0, 0.0, 1.0, 1.0, 0.0, 0.0, 0.0]), gl.STATIC_DRAW);
}

function renderQuad(shader, parameters, texture, width, height) {
  gl.clearColor(1.0, 0.0, 0.0, 1.0);
  gl.viewport(0, 0, width, height);
  gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
  gl.useProgram(shader.program);
  gl.bindBuffer(gl.ARRAY_BUFFER, texCoordBuffer);
  gl.vertexAttribPointer(shader.attributes.texCoordLocation, 2, gl.FLOAT, false, 0, 0);
  gl.bindBuffer(gl.ARRAY_BUFFER, positionBuffer);
  gl.vertexAttribPointer(shader.attributes.positionLocation, 2, gl.FLOAT, false, 0, 0);

  for (var key in parameters) {
    var uniformLocation = gl.getUniformLocation(shader.program, key);

    if (!uniformLocation) {
      continue; // Disabling this error for now since RGB requires minPixelValue
      // but the other shaders do not.
      // throw `Could not access location for uniform: ${key}`;
    }

    var uniform = parameters[key];
    var type = uniform.type;
    var value = uniform.value;

    if (type === 'i') {
      gl.uniform1i(uniformLocation, value);
    } else if (type === 'f') {
      gl.uniform1f(uniformLocation, value);
    } else if (type === '2f') {
      gl.uniform2f(uniformLocation, value[0], value[1]);
    }
  }

  updateRectangle(gl, width, height);
  gl.activeTexture(gl.TEXTURE0);
  gl.bindTexture(gl.TEXTURE_2D, texture);
  gl.drawArrays(gl.TRIANGLE_STRIP, 0, 4);
}

function render(enabledElement) {
  // Resize the canvas
  var image = enabledElement.image;
  renderCanvas.width = image.width;
  renderCanvas.height = image.height;
  var viewport = enabledElement.viewport; // Render the current image

  var shader = getShaderProgram(image);
  var texture = getImageTexture(image);
  var parameters = {
    u_resolution: {
      type: '2f',
      value: [image.width, image.height]
    },
    wc: {
      type: 'f',
      value: viewport.voi.windowCenter
    },
    ww: {
      type: 'f',
      value: viewport.voi.windowWidth
    },
    slope: {
      type: 'f',
      value: image.slope
    },
    intercept: {
      type: 'f',
      value: image.intercept
    },
    minPixelValue: {
      type: 'f',
      value: image.minPixelValue
    },
    invert: {
      type: 'i',
      value: viewport.invert ? 1 : 0
    }
  };
  renderQuad(shader, parameters, texture, image.width, image.height);
  return renderCanvas;
}
function isWebGLAvailable() {
  // Adapted from
  // http://stackoverflow.com/questions/9899807/three-js-detect-webgl-support-and-fallback-to-regular-canvas
  var options = {
    failIfMajorPerformanceCaveat: true
  };

  try {
    var canvas = document.createElement('canvas');
    return Boolean(window.WebGLRenderingContext) && (canvas.getContext('webgl', options) || canvas.getContext('experimental-webgl', options));
  } catch (e) {
    return false;
  }
}

/***/ }),

/***/ "./webgl/shaders/index.js":
/*!********************************!*\
  !*** ./webgl/shaders/index.js ***!
  \********************************/
/*! exports provided: shaders, dataUtilities */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "shaders", function() { return shaders; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "dataUtilities", function() { return dataUtilities; });
/* harmony import */ var _int16_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./int16.js */ "./webgl/shaders/int16.js");
/* harmony import */ var _int8_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./int8.js */ "./webgl/shaders/int8.js");
/* harmony import */ var _rgb_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./rgb.js */ "./webgl/shaders/rgb.js");
/* harmony import */ var _uint16_js__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ./uint16.js */ "./webgl/shaders/uint16.js");
/* harmony import */ var _uint8_js__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! ./uint8.js */ "./webgl/shaders/uint8.js");





var shaders = {
  int16: _int16_js__WEBPACK_IMPORTED_MODULE_0__["int16Shader"],
  int8: _int8_js__WEBPACK_IMPORTED_MODULE_1__["int8Shader"],
  rgb: _rgb_js__WEBPACK_IMPORTED_MODULE_2__["rgbShader"],
  uint16: _uint16_js__WEBPACK_IMPORTED_MODULE_3__["uint16Shader"],
  uint8: _uint8_js__WEBPACK_IMPORTED_MODULE_4__["uint8Shader"]
};
var dataUtilities = {
  int16: _int16_js__WEBPACK_IMPORTED_MODULE_0__["int16DataUtilities"],
  int8: _int8_js__WEBPACK_IMPORTED_MODULE_1__["int8DataUtilities"],
  rgb: _rgb_js__WEBPACK_IMPORTED_MODULE_2__["rgbDataUtilities"],
  uint16: _uint16_js__WEBPACK_IMPORTED_MODULE_3__["uint16DataUtilities"],
  uint8: _uint8_js__WEBPACK_IMPORTED_MODULE_4__["uint8DataUtilities"]
};


/***/ }),

/***/ "./webgl/shaders/int16.js":
/*!********************************!*\
  !*** ./webgl/shaders/int16.js ***!
  \********************************/
/*! exports provided: int16DataUtilities, int16Shader */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "int16DataUtilities", function() { return int16DataUtilities; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "int16Shader", function() { return int16Shader; });
/* eslint no-bitwise: 0 */
var int16Shader = {};
/**
 * Convert stored pixel data to image data.
 *
 * Pack int16 into three uint8 channels (r, g, b)
 *
 * @param {Image} image A Cornerstone Image Object
 * @returns {Uint8Array} The image data for use by the WebGL shader
 * @memberof WebGLRendering
 */

function storedPixelDataToImageData(image) {
  // Transfer image data to alpha and luminance channels of WebGL texture
  // Credit to @jpambrun and @fernandojsg
  // Pack int16 into three uint8 channels (r, g, b)
  var pixelData = image.getPixelData();
  var numberOfChannels = 3;
  var data = new Uint8Array(image.width * image.height * numberOfChannels);
  var offset = 0;

  for (var i = 0; i < pixelData.length; i++) {
    var val = Math.abs(pixelData[i]);
    data[offset++] = val & 0xFF;
    data[offset++] = val >> 8;
    data[offset++] = pixelData[i] < 0 ? 0 : 1; // 0 For negative, 1 for positive
  }

  return data;
}

var int16DataUtilities = {
  storedPixelDataToImageData: storedPixelDataToImageData
};
int16Shader.frag = 'precision mediump float;' + 'uniform sampler2D u_image;' + 'uniform float ww;' + 'uniform float wc;' + 'uniform float slope;' + 'uniform float intercept;' + 'uniform int invert;' + 'varying vec2 v_texCoord;' + 'void main() {' + // Get texture
'vec4 color = texture2D(u_image, v_texCoord);' + // Calculate luminance from packed texture
'float intensity = color.r*256.0 + color.g*65536.0;' + 'if (color.b == 0.0)' + 'intensity = -intensity;' + // Rescale based on slope and window settings
'intensity = intensity * slope + intercept;' + 'float center0 = wc - 0.5;' + 'float width0 = max(ww, 1.0);' + 'intensity = (intensity - center0) / width0 + 0.5;' + // Clamp intensity
'intensity = clamp(intensity, 0.0, 1.0);' + // RGBA output
'gl_FragColor = vec4(intensity, intensity, intensity, 1.0);' + // Apply any inversion necessary
'if (invert == 1)' + 'gl_FragColor.rgb = 1.0 - gl_FragColor.rgb;' + '}';


/***/ }),

/***/ "./webgl/shaders/int8.js":
/*!*******************************!*\
  !*** ./webgl/shaders/int8.js ***!
  \*******************************/
/*! exports provided: int8DataUtilities, int8Shader */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "int8DataUtilities", function() { return int8DataUtilities; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "int8Shader", function() { return int8Shader; });
var int8Shader = {};
/**
 * Convert stored pixel data to image data.
 *
 * Store data in Uint8Array
 *
 * @param {Image} image A Cornerstone Image Object
 * @returns {Uint8Array} The image data for use by the WebGL shader
 * @memberof WebGLRendering
 */

function storedPixelDataToImageData(image) {
  // Transfer image data to alpha channel of WebGL texture
  // Store data in Uint8Array
  var pixelData = image.getPixelData();
  var numberOfChannels = 2;
  var data = new Uint8Array(image.width * image.height * numberOfChannels);
  var offset = 0;

  for (var i = 0; i < pixelData.length; i++) {
    data[offset++] = pixelData[i];
    data[offset++] = pixelData[i] < 0 ? 0 : 1; // 0 For negative, 1 for positive
  }

  return data;
}

var int8DataUtilities = {
  storedPixelDataToImageData: storedPixelDataToImageData
};
int8Shader.frag = 'precision mediump float;' + 'uniform sampler2D u_image;' + 'uniform float ww;' + 'uniform float wc;' + 'uniform float slope;' + 'uniform float intercept;' + 'uniform int invert;' + 'varying vec2 v_texCoord;' + 'void main() {' + // Get texture
'vec4 color = texture2D(u_image, v_texCoord);' + // Calculate luminance from packed texture
'float intensity = color.r*256.;' + 'if (color.a == 0.0)' + 'intensity = -intensity;' + // Rescale based on slope and window settings
'intensity = intensity * slope + intercept;' + 'float center0 = wc - 0.5;' + 'float width0 = max(ww, 1.0);' + 'intensity = (intensity - center0) / width0 + 0.5;' + // Clamp intensity
'intensity = clamp(intensity, 0.0, 1.0);' + // RGBA output
'gl_FragColor = vec4(intensity, intensity, intensity, 1.0);' + // Apply any inversion necessary
'if (invert == 1)' + 'gl_FragColor.rgb = 1.0 - gl_FragColor.rgb;' + '}';


/***/ }),

/***/ "./webgl/shaders/rgb.js":
/*!******************************!*\
  !*** ./webgl/shaders/rgb.js ***!
  \******************************/
/*! exports provided: rgbDataUtilities, rgbShader */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "rgbDataUtilities", function() { return rgbDataUtilities; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "rgbShader", function() { return rgbShader; });
var rgbShader = {};
/**
 * Convert stored pixel data to image data.
 *
 * Pack RGB images into a 3-channel RGB texture
 *
 * @param {Image} image A Cornerstone Image Object
 * @returns {Uint8Array} The image data for use by the WebGL shader
 * @memberof WebGLRendering
 */

function storedPixelDataToImageData(image) {
  var minPixelValue = image.minPixelValue;
  var canvasImageDataIndex = 0;
  var storedPixelDataIndex = 0; // Only 3 channels, since we use WebGL's RGB texture format

  var numStoredPixels = image.width * image.height * 4;
  var numOutputPixels = image.width * image.height * 3;
  var storedPixelData = image.getPixelData();
  var data = new Uint8Array(numOutputPixels); // NOTE: As of Nov 2014, most javascript engines have lower performance when indexing negative indexes.
  // We have a special code path for this case that improves performance.  Thanks to @jpambrun for this enhancement

  if (minPixelValue < 0) {
    while (storedPixelDataIndex < numStoredPixels) {
      data[canvasImageDataIndex++] = storedPixelData[storedPixelDataIndex++] + -minPixelValue; // Red

      data[canvasImageDataIndex++] = storedPixelData[storedPixelDataIndex++] + -minPixelValue; // Green

      data[canvasImageDataIndex++] = storedPixelData[storedPixelDataIndex++] + -minPixelValue; // Blue

      storedPixelDataIndex += 1; // The stored pixel data has 4 channels
    }
  } else {
    while (storedPixelDataIndex < numStoredPixels) {
      data[canvasImageDataIndex++] = storedPixelData[storedPixelDataIndex++]; // Red

      data[canvasImageDataIndex++] = storedPixelData[storedPixelDataIndex++]; // Green

      data[canvasImageDataIndex++] = storedPixelData[storedPixelDataIndex++]; // Blue

      storedPixelDataIndex += 1; // The stored pixel data has 4 channels
    }
  }

  return data;
}

var rgbDataUtilities = {
  storedPixelDataToImageData: storedPixelDataToImageData
};
rgbShader.frag = 'precision mediump float;' + 'uniform sampler2D u_image;' + 'uniform float ww;' + 'uniform float wc;' + 'uniform float slope;' + 'uniform float intercept;' + 'uniform float minPixelValue;' + 'uniform int invert;' + 'varying vec2 v_texCoord;' + 'void main() {' + // Get texture
'vec3 color = texture2D(u_image, v_texCoord).xyz;' + // Rescale based on slope and intercept
'color = color * 256.0 * slope + intercept;' + // Apply window settings
'float center0 = wc - 0.5 - minPixelValue;' + 'float width0 = max(ww, 1.0);' + 'color = (color - center0) / width0 + 0.5;' + // RGBA output
'gl_FragColor = vec4(color, 1);' + // Apply any inversion necessary
'if (invert == 1)' + 'gl_FragColor.rgb = 1. - gl_FragColor.rgb;' + '}';


/***/ }),

/***/ "./webgl/shaders/uint16.js":
/*!*********************************!*\
  !*** ./webgl/shaders/uint16.js ***!
  \*********************************/
/*! exports provided: uint16DataUtilities, uint16Shader */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "uint16DataUtilities", function() { return uint16DataUtilities; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "uint16Shader", function() { return uint16Shader; });
/* eslint no-bitwise: 0 */
var uint16Shader = {};
/**
 * Convert stored pixel data to image data.
 *
 * For uint16 pack uint16 into two uint8 channels (r and a).
 *
 * @param {Image} image A Cornerstone Image Object
 * @returns {Uint8Array} The image data for use by the WebGL shader
 * @memberof WebGLRendering
 */

function storedPixelDataToImageData(image) {
  // Transfer image data to alpha and luminance channels of WebGL texture
  // Credit to @jpambrun and @fernandojsg
  // Pack uint16 into two uint8 channels (r and a)
  var pixelData = image.getPixelData();
  var numberOfChannels = 2;
  var data = new Uint8Array(image.width * image.height * numberOfChannels);
  var offset = 0;

  for (var i = 0; i < pixelData.length; i++) {
    var val = pixelData[i];
    data[offset++] = val & 0xFF;
    data[offset++] = val >> 8;
  }

  return data;
}

var uint16DataUtilities = {
  storedPixelDataToImageData: storedPixelDataToImageData
};
uint16Shader.frag = 'precision mediump float;' + 'uniform sampler2D u_image;' + 'uniform float ww;' + 'uniform float wc;' + 'uniform float slope;' + 'uniform float intercept;' + 'uniform int invert;' + 'varying vec2 v_texCoord;' + 'void main() {' + // Get texture
'vec4 color = texture2D(u_image, v_texCoord);' + // Calculate luminance from packed texture
'float intensity = color.r*256.0 + color.a*65536.0;' + // Rescale based on slope and window settings
'intensity = intensity * slope + intercept;' + 'float center0 = wc - 0.5;' + 'float width0 = max(ww, 1.0);' + 'intensity = (intensity - center0) / width0 + 0.5;' + // Clamp intensity
'intensity = clamp(intensity, 0.0, 1.0);' + // RGBA output
'gl_FragColor = vec4(intensity, intensity, intensity, 1.0);' + // Apply any inversion necessary
'if (invert == 1)' + 'gl_FragColor.rgb = 1.0 - gl_FragColor.rgb;' + '}';


/***/ }),

/***/ "./webgl/shaders/uint8.js":
/*!********************************!*\
  !*** ./webgl/shaders/uint8.js ***!
  \********************************/
/*! exports provided: uint8DataUtilities, uint8Shader */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "uint8DataUtilities", function() { return uint8DataUtilities; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "uint8Shader", function() { return uint8Shader; });
var uint8Shader = {};
/**
 * Convert stored pixel data to image data. Here we will store
 * all data in the alpha channel.
 *
 * @param {Image} image A Cornerstone Image Object
 * @returns {Uint8Array} The image data for use by the WebGL shader
 * @memberof WebGLRendering
 */

function storedPixelDataToImageData(image) {
  // Transfer image data to alpha channel of WebGL texture
  return image.getPixelData();
}

var uint8DataUtilities = {
  storedPixelDataToImageData: storedPixelDataToImageData
};
uint8Shader.frag = 'precision mediump float;' + 'uniform sampler2D u_image;' + 'uniform float ww;' + 'uniform float wc;' + 'uniform float slope;' + 'uniform float intercept;' + 'uniform int invert;' + 'varying vec2 v_texCoord;' + 'void main() {' + // Get texture
'vec4 color = texture2D(u_image, v_texCoord);' + // Calculate luminance from packed texture
'float intensity = color.r*256.0;' + // Rescale based on slope and window settings
'intensity = intensity * slope + intercept;' + 'float center0 = wc - 0.5;' + 'float width0 = max(ww, 1.0);' + 'intensity = (intensity - center0) / width0 + 0.5;' + // Clamp intensity
'intensity = clamp(intensity, 0.0, 1.0);' + // RGBA output
'gl_FragColor = vec4(intensity, intensity, intensity, 1.0);' + // Apply any inversion necessary
'if (invert == 1)' + 'gl_FragColor.rgb = 1.0 - gl_FragColor.rgb;' + '}';


/***/ }),

/***/ "./webgl/textureCache.js":
/*!*******************************!*\
  !*** ./webgl/textureCache.js ***!
  \*******************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _events_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ../events.js */ "./events.js");
/* harmony import */ var _triggerEvent_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ../triggerEvent.js */ "./triggerEvent.js");


/**
 * This module deals with caching image textures in VRAM for WebGL
 * @module WebGLTextureCache
 */

var imageCache = {};
var cachedImages = [];
var maximumSizeInBytes = 1024 * 1024 * 256; // 256 MB

var cacheSizeInBytes = 0;

function getCacheInfo() {
  return {
    maximumSizeInBytes: maximumSizeInBytes,
    cacheSizeInBytes: cacheSizeInBytes,
    numberOfImagesCached: cachedImages.length
  };
}

function purgeCacheIfNecessary() {
  // If max cache size has not been exceeded, do nothing
  if (cacheSizeInBytes <= maximumSizeInBytes) {
    return;
  } // Cache size has been exceeded, create list of images sorted by timeStamp
  // So we can purge the least recently used image


  function compare(a, b) {
    if (a.timeStamp > b.timeStamp) {
      return -1;
    }

    if (a.timeStamp < b.timeStamp) {
      return 1;
    }

    return 0;
  }

  cachedImages.sort(compare); // Remove images as necessary

  while (cacheSizeInBytes > maximumSizeInBytes) {
    var lastCachedImage = cachedImages[cachedImages.length - 1];
    cacheSizeInBytes -= lastCachedImage.sizeInBytes;
    delete imageCache[lastCachedImage.imageId];
    cachedImages.pop();
    Object(_triggerEvent_js__WEBPACK_IMPORTED_MODULE_1__["default"])(_events_js__WEBPACK_IMPORTED_MODULE_0__["events"], _events_js__WEBPACK_IMPORTED_MODULE_0__["default"].WEBGL_TEXTURE_REMOVED, {
      imageId: lastCachedImage.imageId
    });
  }

  var cacheInfo = getCacheInfo();
  Object(_triggerEvent_js__WEBPACK_IMPORTED_MODULE_1__["default"])(_events_js__WEBPACK_IMPORTED_MODULE_0__["events"], _events_js__WEBPACK_IMPORTED_MODULE_0__["default"].WEBGL_TEXTURE_CACHE_FULL, cacheInfo);
}

function setMaximumSizeBytes(numBytes) {
  if (numBytes === undefined) {
    throw new Error('setMaximumSizeBytes: parameter numBytes must not be undefined');
  }

  if (numBytes.toFixed === undefined) {
    throw new Error('setMaximumSizeBytes: parameter numBytes must be a number');
  }

  maximumSizeInBytes = numBytes;
  purgeCacheIfNecessary();
}

function putImageTexture(image, imageTexture) {
  var imageId = image.imageId;

  if (image === undefined) {
    throw new Error('putImageTexture: image must not be undefined');
  }

  if (imageId === undefined) {
    throw new Error('putImageTexture: imageId must not be undefined');
  }

  if (imageTexture === undefined) {
    throw new Error('putImageTexture: imageTexture must not be undefined');
  }

  if (Object.prototype.hasOwnProperty.call(imageCache, imageId) === true) {
    throw new Error('putImageTexture: imageId already in cache');
  }

  var cachedImage = {
    imageId: imageId,
    imageTexture: imageTexture,
    timeStamp: new Date(),
    sizeInBytes: imageTexture.sizeInBytes
  };
  imageCache[imageId] = cachedImage;
  cachedImages.push(cachedImage);

  if (imageTexture.sizeInBytes === undefined) {
    throw new Error('putImageTexture: imageTexture.sizeInBytes must not be undefined');
  }

  if (imageTexture.sizeInBytes.toFixed === undefined) {
    throw new Error('putImageTexture: imageTexture.sizeInBytes is not a number');
  }

  cacheSizeInBytes += cachedImage.sizeInBytes;
  purgeCacheIfNecessary();
}

function getImageTexture(imageId) {
  if (imageId === undefined) {
    throw new Error('getImageTexture: imageId must not be undefined');
  }

  var cachedImage = imageCache[imageId];

  if (cachedImage === undefined) {
    return;
  } // Bump time stamp for cached image


  cachedImage.timeStamp = new Date();
  return cachedImage.imageTexture;
}

function removeImageTexture(imageId) {
  if (imageId === undefined) {
    throw new Error('removeImageTexture: imageId must not be undefined');
  }

  var cachedImage = imageCache[imageId];

  if (cachedImage === undefined) {
    throw new Error('removeImageTexture: imageId must not be undefined');
  }

  cachedImages.splice(cachedImages.indexOf(cachedImage), 1);
  cacheSizeInBytes -= cachedImage.sizeInBytes;
  delete imageCache[imageId];
  return cachedImage.imageTexture;
}

function purgeCache() {
  while (cachedImages.length > 0) {
    var removedCachedImage = cachedImages.pop();
    delete imageCache[removedCachedImage.imageId];
  }

  cacheSizeInBytes = 0;
}

/* harmony default export */ __webpack_exports__["default"] = ({
  purgeCache: purgeCache,
  getImageTexture: getImageTexture,
  putImageTexture: putImageTexture,
  removeImageTexture: removeImageTexture,
  setMaximumSizeBytes: setMaximumSizeBytes
});

/***/ }),

/***/ "./webgl/vertexShader.js":
/*!*******************************!*\
  !*** ./webgl/vertexShader.js ***!
  \*******************************/
/*! exports provided: vertexShader */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "vertexShader", function() { return vertexShader; });
var vertexShader = 'attribute vec2 a_position;' + 'attribute vec2 a_texCoord;' + 'uniform vec2 u_resolution;' + 'varying vec2 v_texCoord;' + 'void main() {' + 'vec2 zeroToOne = a_position / u_resolution;' + 'vec2 zeroToTwo = zeroToOne * 2.0;' + 'vec2 clipSpace = zeroToTwo - 1.0;' + 'gl_Position = vec4(clipSpace * vec2(1, -1), 0, 1);' + 'v_texCoord = a_texCoord;' + '}';

/***/ })

/******/ });
});
//# sourceMappingURL=cornerstone.js.map