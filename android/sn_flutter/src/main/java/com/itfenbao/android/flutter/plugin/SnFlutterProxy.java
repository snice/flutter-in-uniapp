package com.itfenbao.android.flutter.plugin;

import android.app.Application;
import android.content.Context;

import io.dcloud.feature.uniapp.UniAppHookProxy;
import io.flutter.FlutterInjector;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngineGroup;
import io.flutter.embedding.engine.dart.DartExecutor;

public class SnFlutterProxy implements UniAppHookProxy {

    private static SnFlutterProxy proxy;
    private FlutterEngineGroup group;
    private Context context;

    @Override
    public void onSubProcessCreate(Application application) {

    }

    @Override
    public void onCreate(Application application) {
        context = application;
        group = new FlutterEngineGroup(application);
        proxy = this;
    }

    public FlutterEngine createEngine(String entryPoint, String initialRoute) {
        DartExecutor.DartEntrypoint dartEntryPoint = new DartExecutor.DartEntrypoint(FlutterInjector.instance().flutterLoader().findAppBundlePath(), entryPoint);
//        FlutterEngine engine = this.createEngine(context);
//        engine.getDartExecutor().executeDartEntrypoint(dartEntryPoint);
//        return engine;
//         multi engine share data
        return group.createAndRunEngine(context, dartEntryPoint, initialRoute);
    }

    public static SnFlutterProxy getInstance() {
        return proxy;
    }

//    FlutterEngine createEngine(Context context) {
//        return new FlutterEngine(context, null, true);
//    }

}
