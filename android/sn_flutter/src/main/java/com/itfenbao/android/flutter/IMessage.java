package com.itfenbao.android.flutter;

import java.util.Map;

public interface IMessage {
    void postMessage(String method, Map<String, Object> params);
}
