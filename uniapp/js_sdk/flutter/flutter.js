export class MethodChannel {
	constructor(arg) {
		this.msgHandlers = new Map();
		this.instanceId = arg;
		this.flutter = uni.requireNativePlugin('sn-flutter');
		const self = this
		plus.globalEvent.addEventListener('flutter_message' + '&' + this.instanceId, function(e) {
			if (self.msgHandlers.has(e.method)) {
				self.msgHandlers.get(e.method).call(self, e.params);
			}
		})
	}

	$emit(method, params, fun = undefined) {
		if (fun) {
			this.flutter.postMessageWithCallback({
				instanceId: this.instanceId,
				params: {
					method,
					params
				}
			}, fun)
		} else {
			this.flutter.postMessage({
				instanceId: this.instanceId,
				params: {
					method,
					params
				}
			})
		}
	}

	callback(callbackId, params) {
		this.flutter.invokeMethodCallback({
			callbackId,
			params
		})
	}

	$on(id, fun) {
		this.msgHandlers.set(id, fun);
	}
	$off(id) {
		this.msgHandlers.delete(id);
	}
}