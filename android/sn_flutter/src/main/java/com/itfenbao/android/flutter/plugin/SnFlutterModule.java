package com.itfenbao.android.flutter.plugin;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.itfenbao.android.flutter.FlutterConstants;
import com.itfenbao.android.flutter.MsgDispatcher;
import com.itfenbao.android.flutter.SnFlutterActivity;
import com.itfenbao.android.flutter.UniUtils;
import com.taobao.weex.adapter.URIAdapter;

import java.util.Random;

import io.dcloud.feature.uniapp.annotation.UniJSMethod;
import io.dcloud.feature.uniapp.bridge.UniJSCallback;
import io.dcloud.feature.uniapp.common.UniModule;
import io.flutter.embedding.engine.FlutterEngineCache;

public class SnFlutterModule extends UniModule {

    /**
     * 打开webf页面
     *
     * @param json
     */
    @UniJSMethod
    public void openWebf(JSONObject json) {
        JSONObject params = new JSONObject(json);
        if (json.containsKey("url")) {
            String url = json.getString("url");
            Uri uri = mUniSDKInstance.rewriteUri(Uri.parse(url), URIAdapter.FILE);
            params.put(SnFlutterActivity.INITIAL_ROUTE, uri.toString());
        }
        openFlutter(params);
    }

    /**
     * 打开flutter页面
     *
     * @param params
     */
    @UniJSMethod
    public void openFlutter(final JSONObject params) {
        Context context = mUniSDKInstance.getContext();
        final Bundle bundle = new Bundle();
        if (params.containsKey(FlutterConstants.CACHE_ID)) {
            String cacheId = params.getString(FlutterConstants.CACHE_ID);
            bundle.putString(FlutterConstants.CACHE_ID, cacheId);
            bundle.putString("cached_engine_id", cacheId);
        }
        if (params.containsKey(FlutterConstants.INSTANCE_ID))
            bundle.putString(FlutterConstants.INSTANCE_ID, params.getString(FlutterConstants.INSTANCE_ID));
        if (params.containsKey(SnFlutterActivity.ENTRY_POINT))
            bundle.putString(SnFlutterActivity.ENTRY_POINT, params.getString(SnFlutterActivity.ENTRY_POINT));
        if (params.containsKey(SnFlutterActivity.INITIAL_ROUTE))
            bundle.putString(SnFlutterActivity.INITIAL_ROUTE, params.getString(SnFlutterActivity.INITIAL_ROUTE));
        if (params.containsKey(SnFlutterActivity.DESTROY_AFTER_BACK))
            bundle.putBoolean(SnFlutterActivity.DESTROY_AFTER_BACK, params.getBoolean(SnFlutterActivity.DESTROY_AFTER_BACK));
        if (params.containsKey(SnFlutterActivity.PARAMS))
            bundle.putBundle(SnFlutterActivity.PARAMS, UniUtils.parseFromJson(params.getJSONObject(SnFlutterActivity.PARAMS)));
        context.startActivity(new Intent(context, SnFlutterActivity.class) {{
            putExtras(bundle);
        }});
    }

    @UniJSMethod
    public void cachePages(final JSONObject params) {
        JSONArray pages = params.getJSONArray("pages");
        for (int i = 0; i < pages.size(); i++) {
            final String page = pages.getString(i);
            if (!FlutterEngineCache.getInstance().contains(page))
                FlutterEngineCache.getInstance().put(page, SnFlutterProxy.getInstance().createEngine(page, null));
        }
    }

    @UniJSMethod
    public void cacheEntryPoints(final JSONObject params) {
        for (String key : params.keySet()) {
            if (!FlutterEngineCache.getInstance().contains(key))
                FlutterEngineCache.getInstance().put(key, SnFlutterProxy.getInstance().createEngine(params.getString(key), null));
        }
    }

    @UniJSMethod
    public void postMessage(JSONObject jsonObject) {
        String instanceId = jsonObject.getString(FlutterConstants.INSTANCE_ID);
        JSONObject params = jsonObject.getJSONObject("params");
        String method = params.getString("method");
        MsgDispatcher.getInstance().postMessage(instanceId, method, params.getJSONObject("params"));
    }

    @UniJSMethod
    public void postMessageWithCallback(JSONObject jsonObject, UniJSCallback callback) {
        String instanceId = jsonObject.getString(FlutterConstants.INSTANCE_ID);
        JSONObject params = jsonObject.getJSONObject("params");
        String method = params.getString("method");
        if (callback != null) {
            String callbackId = instanceId + "-" + method + "-" + getRandomString(15);
            params.getJSONObject("params").put(FlutterConstants.CALLBACK_ID, callbackId);
            MsgDispatcher.getInstance().addUniCallback(callbackId, callback);
        }
        MsgDispatcher.getInstance().postMessage(instanceId, method, params.getJSONObject("params"));
    }

    @UniJSMethod
    public void invokeMethodCallback(JSONObject jsonObject) {
        String callbackId = jsonObject.getString(FlutterConstants.CALLBACK_ID);
        MsgDispatcher.getInstance().invokeFlutterCallback(callbackId, jsonObject.getJSONObject("params"));
    }

    private String getRandomString(int length) {
        String str = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        Random random = new Random();
        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < length; i++) {
            int number = random.nextInt(62);
            sb.append(str.charAt(number));
        }
        return sb.toString();
    }

}
