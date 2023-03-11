package com.itfenbao.android.flutter;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;

import java.util.HashMap;
import java.util.Map;

import io.dcloud.feature.uniapp.bridge.UniJSCallback;
import io.flutter.plugin.common.MethodChannel;

public class MsgDispatcher {

    private Map<String, IMessage> messageMap = new HashMap<>();

    private Map<String, UniJSCallback> callbackMap = new HashMap<>();

    private Map<String, MethodChannel.Result> resultMap = new HashMap<>();

    private MsgDispatcher() {
    }

    private static MsgDispatcher instance;

    public static MsgDispatcher getInstance() {
        if (instance == null)
            instance = new MsgDispatcher();
        return instance;
    }

    void addMessageChannel(String instanceId, IMessage message) {
        messageMap.put(instanceId, message);
    }

    void removeMessageChannel(String instanceId) {
        messageMap.remove(instanceId);
    }

    public void addUniCallback(String callbackId, UniJSCallback callback) {
        callbackMap.put(callbackId, callback);
    }

    void addFlutterCallback(String callbackId, MethodChannel.Result result) {
        resultMap.put(callbackId, result);
    }

//    void removeCallback(String callbackId) {
//        callbackMap.remove(callbackId);
//    }

    /**
     * 给Flutter发消息
     *
     * @param instanceId 唯一Flutter实例ID
     * @param method     方法名
     * @param jsonObject 参数
     */
    public void postMessage(String instanceId, String method, JSONObject jsonObject) {
        if (messageMap.containsKey(instanceId)) {
            messageMap.get(instanceId).postMessage(method, jsonObject);
        }
    }

    void invokeUniCallback(String callbackId, JSONObject jsonObject) {
        if (callbackMap.containsKey(callbackId)) {
            callbackMap.get(callbackId).invoke(jsonObject);
            callbackMap.remove(callbackId);
        }
    }

    void invokeKeepAliveUniCallback(String callbackId, JSONObject jsonObject) {
        if (callbackMap.containsKey(callbackId)) {
            callbackMap.get(callbackId).invokeAndKeepAlive(jsonObject);
        }
    }

    public void invokeFlutterCallback(String callbackId, JSONObject jsonObject) {
        if (resultMap.containsKey(callbackId)) {
            resultMap.get(callbackId).success(JSON.parseObject(jsonObject.toJSONString(), Map.class));
            resultMap.remove(callbackId);
        }
    }
}
