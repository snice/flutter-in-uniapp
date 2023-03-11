package com.itfenbao.android.flutter;

import android.content.Context;
import android.text.TextUtils;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.itfenbao.android.flutter.plugin.SnFlutterProxy;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.android.FlutterFragment;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngineCache;
import io.flutter.embedding.engine.plugins.util.GeneratedPluginRegister;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class SnFlutterFragment extends FlutterFragment implements IMessage, MethodChannel.MethodCallHandler {

    public interface UniComponentFireEvent {
        void fireEvent(String eventName, Map<String, Object> data);
    }

    private interface Events {
        String POP = "pop";
        String POP_CHANGE = "popChange";
    }

    private String instanceId;
    private String cacheId;
    private String entryPoint = "main";
    private boolean destroyAfterBack = true;
    private Map<String, Object> initParams = new HashMap();
    private MethodChannel methodChannel;
    private UniComponentFireEvent fireEvent;

    public void setFireEvent(UniComponentFireEvent fireEvent) {
        this.fireEvent = fireEvent;
    }

    public void setCacheId(String cacheId) {
        this.cacheId = cacheId;
    }

    public void setInstanceId(String instanceId) {
        this.instanceId = instanceId;
    }

    public void setDestroyAfterBack(boolean destroyAfterBack) {
        this.destroyAfterBack = destroyAfterBack;
    }

    public void setInitParams(Map<String, Object> initParams) {
        this.initParams = initParams;
    }

    @Nullable
    @Override
    public FlutterEngine provideFlutterEngine(@NonNull Context context) {
        return super.provideFlutterEngine(context);
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegister.registerGeneratedPlugins(flutterEngine);
        methodChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), FlutterConstants.CHANNEL);
        methodChannel.setMethodCallHandler(this);
        if (!TextUtils.isEmpty(instanceId)) {
            MsgDispatcher.getInstance().addMessageChannel(instanceId, this);
        }
    }

    @Override
    public void onDestroy() {
        if (!TextUtils.isEmpty(instanceId)) {
            MsgDispatcher.getInstance().removeMessageChannel(instanceId);
        }
        if (methodChannel != null) {
            methodChannel.setMethodCallHandler(null);
            methodChannel = null;
        }
        super.onDestroy();
        if (this.destroyAfterBack) {
            if (FlutterEngineCache.getInstance().contains(cacheId))
                FlutterEngineCache.getInstance().remove(cacheId);
            FlutterEngineCache.getInstance().put(cacheId, SnFlutterProxy.getInstance().createEngine(entryPoint));
        }
    }

    public void popRoute() {
        if (getFlutterEngine() != null) {
            getFlutterEngine().getNavigationChannel().popRoute();
        }
    }

    @Override
    public void postMessage(String method, Map<String, Object> params) {
        methodChannel.invokeMethod(method, params);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        if (FlutterConstants.Methods.CAN_POP.equals(call.method)) {
            setCanPopResult((boolean) call.arguments());
            return;
        }
        if (FlutterConstants.Methods.POP.equals(call.method)) {
            this.fireEvent(Events.POP, null);
            return;
        }
        if (FlutterConstants.Methods.GET_PARAMS.equals(call.method)) {
            result.success(initParams);
            return;
        }
        if (FlutterConstants.Methods.CALL_BACK_METHOD.equals(call.method)) {
            if (call.arguments != null)
                UniUtils.invokeCallback(call.arguments);
            return;
        }
        UniUtils.fireGlobalEventCallback(FlutterConstants.FLUTTER_MESSAGE + "&" + instanceId, call, result);
    }

    private void setCanPopResult(final boolean canPopResult) {
        this.fireEvent(Events.POP_CHANGE, newParams(new HashMap<String, Object>() {{
            put("pop", canPopResult);
        }}));
    }

    private void fireEvent(String eventName, Map<String, Object> data) {
        if (fireEvent != null)
            fireEvent.fireEvent(eventName, data);
    }

    private Map newParams(Map detail) {
        Map<String, Object> params = new HashMap<>();
        params.put("detail", detail);
        return params;
    }

}
