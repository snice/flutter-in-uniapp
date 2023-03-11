package com.itfenbao.android.flutter;

public class FlutterConstants {

    public static final String CHANNEL = "com.itfenbao.uniapp";
    public static final String FLUTTER_MESSAGE = "flutter_message";
    public static final String INSTANCE_ID = "instanceId";
    public static final String CACHE_ID = "cacheId";
    public static final String CALLBACK_ID = "callbackId";

    interface Methods {
        String CAN_POP = "canPop";
        String POP = "pop";
        String GET_PARAMS = "getParams";
        String CALL_BACK_METHOD = "_uni_callback";
    }

}
