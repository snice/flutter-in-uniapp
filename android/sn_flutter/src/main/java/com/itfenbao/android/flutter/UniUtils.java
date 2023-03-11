package com.itfenbao.android.flutter;

import android.os.Bundle;

import androidx.annotation.NonNull;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.util.TypeUtils;
import com.taobao.weex.WXSDKInstance;
import com.taobao.weex.WXSDKManager;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class UniUtils {

    public static void fireGlobalEventCallback(String eventName, MethodCall call, MethodChannel.Result result) {
        fireGlobalEventCallback(eventName, parseParams(call, result));
    }

    public static HashMap parseParams(@NonNull final MethodCall call, final MethodChannel.Result result) {
        return new HashMap() {{
            put("method", call.method);
            if (call.arguments != null) {
                JSONObject object = null;
                if (call.arguments instanceof Map) {
                    object = JSON.parseObject(JSON.toJSONString(call.arguments));
                } else if (call.arguments instanceof org.json.JSONObject) {
                    String json = ((org.json.JSONObject) call.arguments).toString();
                    object = JSON.parseObject(json);
                }
                if (object != null) {
                    if (object.containsKey(FlutterConstants.CALLBACK_ID)) {
                        MsgDispatcher.getInstance().addFlutterCallback(object.getString(FlutterConstants.CALLBACK_ID), result);
                    }
                    put("params", object);
                }
            }
        }};
    }

    private static void fireGlobalEventCallback(String eventName, Map<String, Object> params) {
        for (WXSDKInstance instance : WXSDKManager.getInstance().getAllInstanceMap().values()) {
            instance.fireGlobalEventCallback(eventName, params);
        }
    }

    public static Bundle parseFromJson(JSONObject jsonObject) {
        Bundle paramsBundle = new Bundle();
        for (String k : jsonObject.keySet()) {
            Object v = jsonObject.get(k);
            if (v instanceof Boolean) {
                paramsBundle.putBoolean(k, TypeUtils.castToBoolean(v));
            } else if (v instanceof Integer) {
                paramsBundle.putInt(k, TypeUtils.castToInt(v));
            } else if (v instanceof Float) {
                paramsBundle.putFloat(k, TypeUtils.castToFloat(v));
            } else if (v instanceof Double) {
                paramsBundle.putDouble(k, TypeUtils.castToDouble(v));
            } else if (v instanceof String) {
                paramsBundle.putString(k, TypeUtils.castToString(v));
            }
        }
        return paramsBundle;
    }

    public static Map mapFromBundle(Bundle bundle) {
        Map map = new HashMap();
        for (String k : bundle.keySet()) {
            map.put(k, bundle.get(k));
        }
        return map;
    }

    public static void invokeCallback(@NonNull Object arguments) {
        JSONObject map = null;
        if (arguments instanceof Map) {
            map = new JSONObject((Map<String, Object>) arguments);
        } else if (arguments instanceof org.json.JSONObject) {
            map = JSON.parseObject(JSON.toJSONString(arguments));
        }
        if (map != null) {
            if (map.containsKey(FlutterConstants.CALLBACK_ID)) {
                String callbackId = map.getString(FlutterConstants.CALLBACK_ID);
                map.remove(FlutterConstants.CALLBACK_ID);
                if (map.getBooleanValue("keepAlive")) {
                    map.remove("keepAlive");
                    MsgDispatcher.getInstance().invokeKeepAliveUniCallback(callbackId, map);
                } else {
                    MsgDispatcher.getInstance().invokeUniCallback(callbackId, map);
                }
            }
        }

    }
}
