package com.itfenbao.android.flutter;

import android.content.Context;
import android.os.Bundle;
import android.text.TextUtils;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.itfenbao.android.flutter.plugin.SnFlutterProxy;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngineCache;
import io.flutter.embedding.engine.plugins.util.GeneratedPluginRegister;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class SnFlutterPage extends FlutterActivity implements IMessage, MethodChannel.MethodCallHandler {

    public static final String ENTRY_POINT = "entryPoint";
    public static final String INITIAL_ROUTE = "initialRoute";
    public static final String PARAMS = "params";
    public static final String DESTROY_AFTER_BACK = "destroyAfterBack";

    private String instanceId;
    private String cacheId;
    private String entryPoint;
    private String initialRoute;
    private boolean destroyAfterBack = true;
    private MethodChannel methodChannel;

    private Map<String, Object> initParams = new HashMap();

    @Nullable
    @Override
    public FlutterEngine provideFlutterEngine(@NonNull Context context) {
        FlutterEngine engine = SnFlutterProxy.getInstance().createEngine(entryPoint, initialRoute);
        if (!TextUtils.isEmpty(cacheId)) FlutterEngineCache.getInstance().put(cacheId, engine);
        return engine;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        instanceId = getIntent().getExtras().getString(FlutterConstants.INSTANCE_ID, null);
        entryPoint = getIntent().getExtras().getString(ENTRY_POINT, "main");
        initialRoute = getIntent().getExtras().getString(INITIAL_ROUTE, null);
        cacheId = getIntent().getExtras().getString(FlutterConstants.CACHE_ID, null);
        destroyAfterBack = getIntent().getExtras().getBoolean(DESTROY_AFTER_BACK, true);
        if (getIntent().getExtras().containsKey(PARAMS)) {
            initParams = UniUtils.mapFromBundle(getIntent().getBundleExtra(PARAMS));
        }
        super.onCreate(savedInstanceState);
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
    protected void onDestroy() {
        if (!TextUtils.isEmpty(instanceId)) {
            MsgDispatcher.getInstance().removeMessageChannel(instanceId);
        }
        if (methodChannel != null) {
            methodChannel.setMethodCallHandler(null);
            methodChannel = null;
        }
        super.onDestroy();
        destroy();
    }

    private void destroy() {
        if (this.destroyAfterBack && !TextUtils.isEmpty(cacheId)) {
            if (FlutterEngineCache.getInstance().contains(cacheId))
                FlutterEngineCache.getInstance().remove(cacheId);
            FlutterEngineCache.getInstance().put(cacheId, SnFlutterProxy.getInstance().createEngine(entryPoint, initialRoute));
        }
    }

    @Override
    public void onMethodCall(@NonNull final MethodCall call, @NonNull MethodChannel.Result result) {
        if (FlutterConstants.Methods.CAN_POP.equals(call.method)) {
            result.success(true);
            return;
        }
        if (FlutterConstants.Methods.POP.equals(call.method)) {
            onBackPressed();
            result.success(true);
            return;
        }
        if (FlutterConstants.Methods.GET_PARAMS.equals(call.method)) {
            result.success(initParams);
            return;
        }
        if (FlutterConstants.Methods.CALL_BACK_METHOD.equals(call.method)) {
            if (call.arguments != null) UniUtils.invokeCallback(call.arguments);
            result.success(true);
            return;
        }
        UniUtils.fireGlobalEventCallback(FlutterConstants.FLUTTER_MESSAGE + "&" + instanceId, call, result);
    }

    @Override
    public void postMessage(String method, Map<String, Object> params) {
        if (methodChannel != null) {
            methodChannel.invokeMethod(method, params);
        }
    }

}
