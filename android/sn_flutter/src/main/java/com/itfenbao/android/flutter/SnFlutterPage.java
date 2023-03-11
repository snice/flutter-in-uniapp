package com.itfenbao.android.flutter;

import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
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

    private final static String TAG = "FlutterPage";

    public static final String ENTRY_POINT = "entryPoint";
    public static final String PARAMS = "params";
    public static final String DESTROY_AFTER_BACK = "destroyAfterBack";

    private Handler mHandler = new Handler(Looper.getMainLooper());

    private String instanceId;
    private String cacheId;
    private String entryPoint;
    private boolean destroyAfterBack = true;
    private MethodChannel methodChannel;

    //    private FlutterEngine engine;
//    private FlutterView flutterView;
    private boolean canPop = false;
    private Map<String, Object> initParams = new HashMap();

    private boolean isInit = false;
    private boolean isCanBack = false;

    @Nullable
    @Override
    public FlutterEngine provideFlutterEngine(@NonNull Context context) {
        FlutterEngine engine = SnFlutterProxy.getInstance().createEngine(entryPoint);
        FlutterEngineCache.getInstance().put(cacheId, engine);
        return engine;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        instanceId = getIntent().getExtras().getString(FlutterConstants.INSTANCE_ID, null);
        entryPoint = getIntent().getExtras().getString(ENTRY_POINT, "main");
        cacheId = getIntent().getExtras().getString(FlutterConstants.CACHE_ID, entryPoint);
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
        mHandler.postDelayed(new Runnable() {
            @Override
            public void run() {
                isCanBack = true;
            }
        }, 500);
        if (!TextUtils.isEmpty(instanceId)) {
            MsgDispatcher.getInstance().addMessageChannel(instanceId, this);
        }
    }

    @Override
    public void onBackPressed() {
        if (!isCanBack) return;
        if (canPop) {
            if (this.getFlutterEngine() != null)
                this.getFlutterEngine().getNavigationChannel().popRoute();
        } else {
            super.onBackPressed();
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
        if (this.destroyAfterBack) {
            if (FlutterEngineCache.getInstance().contains(cacheId))
                FlutterEngineCache.getInstance().remove(cacheId);
            FlutterEngineCache.getInstance().put(cacheId, SnFlutterProxy.getInstance().createEngine(entryPoint));
        }
    }

    @Override
    public void onMethodCall(@NonNull final MethodCall call, @NonNull MethodChannel.Result result) {
        if (FlutterConstants.Methods.CAN_POP.equals(call.method)) {
            canPop = (boolean) call.arguments;
            return;
        }
        if (FlutterConstants.Methods.POP.equals(call.method)) {
            onBackPressed();
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

    @Override
    public void postMessage(String method, Map<String, Object> params) {
        if (methodChannel != null) {
            methodChannel.invokeMethod(method, params);
        }
    }

}
