!function(t){var e={};function n(r){if(e[r])return e[r].exports;var o=e[r]={i:r,l:!1,exports:{}};return t[r].call(o.exports,o,o.exports,n),o.l=!0,o.exports}n.m=t,n.c=e,n.d=function(t,e,r){n.o(t,e)||Object.defineProperty(t,e,{enumerable:!0,get:r})},n.r=function(t){"undefined"!=typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(t,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(t,"__esModule",{value:!0})},n.t=function(t,e){if(1&e&&(t=n(t)),8&e)return t;if(4&e&&"object"==typeof t&&t&&t.__esModule)return t;var r=Object.create(null);if(n.r(r),Object.defineProperty(r,"default",{enumerable:!0,value:t}),2&e&&"string"!=typeof t)for(var o in t)n.d(r,o,function(e){return t[e]}.bind(null,o));return r},n.n=function(t){var e=t&&t.__esModule?function(){return t.default}:function(){return t};return n.d(e,"a",e),e},n.o=function(t,e){return Object.prototype.hasOwnProperty.call(t,e)},n.p="",n(n.s=28)}([function(t,e){t.exports={"@VERSION":2}},function(t,e,n){"use strict";function r(t,e,n,r,o,i,a,s,u,l){var f,c="function"==typeof t?t.options:t;if(u){c.components||(c.components={});var p=Object.prototype.hasOwnProperty;for(var d in u)p.call(u,d)&&!p.call(c.components,d)&&(c.components[d]=u[d])}if(l&&("function"==typeof l.beforeCreate&&(l.beforeCreate=[l.beforeCreate]),(l.beforeCreate||(l.beforeCreate=[])).unshift((function(){this[l.__module]=this})),(c.mixins||(c.mixins=[])).push(l)),e&&(c.render=e,c.staticRenderFns=n,c._compiled=!0),r&&(c.functional=!0),i&&(c._scopeId="data-v-"+i),a?(f=function(t){(t=t||this.$vnode&&this.$vnode.ssrContext||this.parent&&this.parent.$vnode&&this.parent.$vnode.ssrContext)||"undefined"==typeof __VUE_SSR_CONTEXT__||(t=__VUE_SSR_CONTEXT__),o&&o.call(this,t),t&&t._registeredComponents&&t._registeredComponents.add(a)},c._ssrRegister=f):o&&(f=s?function(){o.call(this,this.$root.$options.shadowRoot)}:o),f)if(c.functional){c._injectStyles=f;var y=c.render;c.render=function(t,e){return f.call(e),y(t,e)}}else{var h=c.beforeCreate;c.beforeCreate=h?[].concat(h,f):[f]}return{exports:t,options:c}}n.d(e,"a",(function(){return r}))},function(t,e,n){Vue.prototype.__$appStyle__={},Vue.prototype.__merge_style&&Vue.prototype.__merge_style(n(3).default,Vue.prototype.__$appStyle__)},function(t,e,n){"use strict";n.r(e);var r=n(0),o=n.n(r);for(var i in r)["default"].indexOf(i)<0&&function(t){n.d(e,t,(function(){return r[t]}))}(i);e.default=o.a},function(t,e){if("undefined"==typeof Promise||Promise.prototype.finally||(Promise.prototype.finally=function(t){var e=this.constructor;return this.then((function(n){return e.resolve(t()).then((function(){return n}))}),(function(n){return e.resolve(t()).then((function(){throw n}))}))}),"undefined"!=typeof uni&&uni&&uni.requireGlobal){var n=uni.requireGlobal();ArrayBuffer=n.ArrayBuffer,Int8Array=n.Int8Array,Uint8Array=n.Uint8Array,Uint8ClampedArray=n.Uint8ClampedArray,Int16Array=n.Int16Array,Uint16Array=n.Uint16Array,Int32Array=n.Int32Array,Uint32Array=n.Uint32Array,Float32Array=n.Float32Array,Float64Array=n.Float64Array,BigInt64Array=n.BigInt64Array,BigUint64Array=n.BigUint64Array}},function(t,e){function n(e){return t.exports=n="function"==typeof Symbol&&"symbol"==typeof Symbol.iterator?function(t){return typeof t}:function(t){return t&&"function"==typeof Symbol&&t.constructor===Symbol&&t!==Symbol.prototype?"symbol":typeof t},t.exports.__esModule=!0,t.exports.default=t.exports,n(e)}t.exports=n,t.exports.__esModule=!0,t.exports.default=t.exports},function(t,e,n){"use strict";var r=n(16),o=n(9),i=n(1);var a=Object(i.a)(o.default,r.b,r.c,!1,null,null,"7346c9f1",!1,r.a,void 0);(function(t){this.options.style||(this.options.style={}),Vue.prototype.__merge_style&&Vue.prototype.__$appStyle__&&Vue.prototype.__merge_style(Vue.prototype.__$appStyle__,this.options.style)}).call(a),e.default=a.exports},,,function(t,e,n){"use strict";var r=n(10),o=n.n(r);e.default=o.a},function(t,e,n){"use strict";(function(t){Object.defineProperty(e,"__esModule",{value:!0}),e.default=void 0;var r=n(20),o={data:function(){var t=plus.io.convertLocalFileSystemURL("/static/demos/gallery/build/kraken/index.js");return{canPop:!1,instanceId:"webf",entryPoint:"webf",initialRoute:"file://".concat(t),params:{a:1}}},onBackPress:function(){if(this.canPop)return this.$refs.flutter.pop(),!0},onLoad:function(){var e=this;this.methodChannel=new r.MethodChannel(this.instanceId),this.methodChannel.$on("test",(function(n){t("log","test",n," at pages/flutter/webf.nvue:32"),n.callbackId?e.methodChannel.callback(n.callbackId,{result:3}):uni.showToast({title:JSON.stringify(n),icon:"none"})}))},methods:{onPop:function(){uni.navigateBack()},onPopChange:function(t){var e=t.detail;(this.canPop=e.pop,"ios"==uni.getSystemInfoSync().platform)&&this.$scope.$getAppWebview().setStyle({popGesture:this.canPop?"none":"close"})}}};e.default=o}).call(this,n(19).default)},,,,,,function(t,e,n){"use strict";n.d(e,"b",(function(){return r})),n.d(e,"c",(function(){return o})),n.d(e,"a",(function(){}));var r=function(){var t=this.$createElement,e=this._self._c||t;return e("scroll-view",{staticStyle:{flexDirection:"column"},attrs:{scrollY:!0,showScrollbar:!0,enableBackToTop:!0,bubble:"true"}},[e("sn-flutter-view",{ref:"flutter",staticStyle:{flex:"1"},attrs:{instanceId:this.instanceId,entryPoint:this.entryPoint,initialRoute:this.initialRoute,params:this.params,destroyAfterBack:"true"},on:{pop:this.onPop,popChange:this.onPopChange}})],1)},o=[]},,,function(t,e,n){"use strict";function r(t){var e=Object.prototype.toString.call(t);return e.substring(8,e.length-1)}function o(){return"string"==typeof __channelId__&&__channelId__}function i(t,e){switch(r(e)){case"Function":return"function() { [native code] }";default:return e}}Object.defineProperty(e,"__esModule",{value:!0}),e.default=function(){for(var t=arguments.length,e=new Array(t),n=0;n<t;n++)e[n]=arguments[n];var a=e.shift();if(o())return e.push(e.pop().replace("at ","uni-app:///")),console[a].apply(console,e);var s=e.map((function(t){var e=Object.prototype.toString.call(t).toLowerCase();if("[object object]"===e||"[object array]"===e)try{t="---BEGIN:JSON---"+JSON.stringify(t,i)+"---END:JSON---"}catch(n){t=e}else if(null===t)t="---NULL---";else if(void 0===t)t="---UNDEFINED---";else{var n=r(t).toUpperCase();t="NUMBER"===n||"BOOLEAN"===n?"---BEGIN:"+n+"---"+t+"---END:"+n+"---":String(t)}return t})),u="";if(s.length>1){var l=s.pop();u=s.join("---COMMA---"),0===l.indexOf(" at ")?u+=l:u+="---COMMA---"+l}else u=s[0];console[a](u)},e.log=function(t){for(var e=arguments.length,n=new Array(e>1?e-1:0),r=1;r<e;r++)n[r-1]=arguments[r];console[t].apply(console,n)}},function(t,e,n){"use strict";(function(t){var r=n(22);Object.defineProperty(e,"__esModule",{value:!0}),e.MethodChannel=void 0;var o=r(n(23)),i=r(n(24)),a=function(){function e(n){(0,o.default)(this,e),this.msgHandlers=new Map,this.instanceId=n,this.flutter=t("sn-flutter");var r=this;plus.globalEvent.addEventListener("flutter_message&"+this.instanceId,(function(t){r.msgHandlers.has(t.method)&&r.msgHandlers.get(t.method).call(r,t.params)}))}return(0,i.default)(e,[{key:"$emit",value:function(t,e){var n=arguments.length>2&&void 0!==arguments[2]?arguments[2]:void 0;n?this.flutter.postMessageWithCallback({instanceId:this.instanceId,params:{method:t,params:e}},n):this.flutter.postMessage({instanceId:this.instanceId,params:{method:t,params:e}})}},{key:"callback",value:function(t,e){this.flutter.invokeMethodCallback({callbackId:t,params:e})}},{key:"$on",value:function(t,e){this.msgHandlers.set(t,e)}},{key:"$off",value:function(t){this.msgHandlers.delete(t)}}]),e}();e.MethodChannel=a}).call(this,n(21).default)},function(t,e,n){"use strict";Object.defineProperty(e,"__esModule",{value:!0}),e.default=function(t){return weex.requireModule(t)}},function(t,e){t.exports=function(t){return t&&t.__esModule?t:{default:t}},t.exports.__esModule=!0,t.exports.default=t.exports},function(t,e){t.exports=function(t,e){if(!(t instanceof e))throw new TypeError("Cannot call a class as a function")},t.exports.__esModule=!0,t.exports.default=t.exports},function(t,e,n){var r=n(25);function o(t,e){for(var n=0;n<e.length;n++){var o=e[n];o.enumerable=o.enumerable||!1,o.configurable=!0,"value"in o&&(o.writable=!0),Object.defineProperty(t,r(o.key),o)}}t.exports=function(t,e,n){return e&&o(t.prototype,e),n&&o(t,n),Object.defineProperty(t,"prototype",{writable:!1}),t},t.exports.__esModule=!0,t.exports.default=t.exports},function(t,e,n){var r=n(5).default,o=n(26);t.exports=function(t){var e=o(t,"string");return"symbol"===r(e)?e:String(e)},t.exports.__esModule=!0,t.exports.default=t.exports},function(t,e,n){var r=n(5).default;t.exports=function(t,e){if("object"!==r(t)||null===t)return t;var n=t[Symbol.toPrimitive];if(void 0!==n){var o=n.call(t,e||"default");if("object"!==r(o))return o;throw new TypeError("@@toPrimitive must return a primitive value.")}return("string"===e?String:Number)(t)},t.exports.__esModule=!0,t.exports.default=t.exports},,function(t,e,n){"use strict";n.r(e);n(2),n(4);var r=n(6);r.default.mpType="page",r.default.route="pages/flutter/webf",r.default.el="#root",new Vue(r.default)}]);