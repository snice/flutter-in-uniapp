package com.itfenbao.android.flutter;

import android.content.Context;
import android.text.TextUtils;
import android.view.View;
import android.widget.FrameLayout;

import androidx.annotation.NonNull;
import androidx.fragment.app.FragmentActivity;
import androidx.fragment.app.FragmentManager;

import com.alibaba.fastjson.JSON;
import com.taobao.weex.common.Destroyable;

import java.util.HashMap;
import java.util.Map;

import io.dcloud.feature.uniapp.UniSDKInstance;
import io.dcloud.feature.uniapp.annotation.UniJSMethod;
import io.dcloud.feature.uniapp.dom.AbsAttr;
import io.dcloud.feature.uniapp.ui.action.AbsComponentData;
import io.dcloud.feature.uniapp.ui.component.AbsVContainer;
import io.dcloud.feature.uniapp.ui.component.UniComponent;
import io.dcloud.feature.uniapp.ui.component.UniComponentProp;
import io.flutter.embedding.android.FlutterFragment;
import io.flutter.embedding.engine.FlutterEngineCache;

public class FlutterComponent extends UniComponent<FrameLayout> implements Destroyable, SnFlutterFragment.UniComponentFireEvent {

    private static final String ENTRY_POINT = "entryPoint";
    private static final String INITIAL_ROUTE = "initialRoute";
    private static final String PARAMS = "params";
    public static final String DESTROY_AFTER_BACK = "destroyAfterBack";

    private String instanceId;
    private String cacheId;
    private String entryPoint = "main";
    private String initialRoute;
    private boolean destroyAfterBack = true;
    private Map<String, Object> initParams = new HashMap();

    private SnFlutterFragment mFragment;

    public FlutterComponent(UniSDKInstance instance, AbsVContainer parent, int type, AbsComponentData componentData) {
        super(instance, parent, type, componentData);
        init(componentData.getAttrs());
    }

    public FlutterComponent(UniSDKInstance instance, AbsVContainer parent, AbsComponentData componentData) {
        super(instance, parent, componentData);
        init(componentData.getAttrs());
    }

    private void init(AbsAttr attr) {
        if (attr.containsKey(ENTRY_POINT)) {
            entryPoint = attr.get(ENTRY_POINT).toString();
        }
        if (attr.containsKey(INITIAL_ROUTE)) {
            initialRoute = attr.get(INITIAL_ROUTE).toString();
            if (TextUtils.isEmpty(initialRoute)) initialRoute = null;
        }
        if (attr.containsKey(FlutterConstants.CACHE_ID)) {
            cacheId = attr.get(FlutterConstants.CACHE_ID).toString();
        }
        if (attr.containsKey(FlutterConstants.INSTANCE_ID)) {
            instanceId = attr.get(FlutterConstants.INSTANCE_ID).toString();
        }
        if (attr.containsKey(PARAMS)) {
            initParams = JSON.parseObject(attr.get(PARAMS).toString(), Map.class);
        }
        if (attr.containsKey(DESTROY_AFTER_BACK)) {
            destroyAfterBack = Boolean.parseBoolean(attr.get(DESTROY_AFTER_BACK).toString());
        }
    }

    @Override
    protected FrameLayout initComponentHostView(@NonNull Context context) {
        return new FrameLayout(context) {{
            setId(View.generateViewId());
        }};
    }

    @Override
    protected void onHostViewInitialized(FrameLayout host) {
        super.onHostViewInitialized(host);
        if (!TextUtils.isEmpty(cacheId) && FlutterEngineCache.getInstance().get(cacheId) != null) {
            mFragment = new FlutterFragment.CachedEngineFragmentBuilder(SnFlutterFragment.class, cacheId).build();
        } else {
            mFragment = new FlutterFragment.NewEngineFragmentBuilder(SnFlutterFragment.class).dartEntrypoint(entryPoint).initialRoute(initialRoute).build();
        }
        mFragment.setCacheId(cacheId);
        mFragment.setInitialRoute(initialRoute);
        mFragment.setInitParams(initParams);
        mFragment.setInstanceId(instanceId);
        mFragment.setDestroyAfterBack(destroyAfterBack);
        mFragment.setFireEvent(this);
        FragmentActivity fragmentActivity = (FragmentActivity) getInstance().getContext();
        FragmentManager fragmentManager = fragmentActivity.getSupportFragmentManager();
        fragmentManager.beginTransaction().add(getHostView().getId(), mFragment).commit();
    }

    @UniComponentProp(name = DESTROY_AFTER_BACK)
    public void setDestroyAfterBack(boolean destroyAfterBack) {
        this.destroyAfterBack = destroyAfterBack;
        if (mFragment != null) mFragment.setDestroyAfterBack(this.destroyAfterBack);
    }

    @UniComponentProp(name = PARAMS)
    public void setInitParams(String params) {
        this.initParams = JSON.parseObject(params, Map.class);
        if (mFragment != null) mFragment.setInitParams(this.initParams);
    }

    @UniJSMethod
    public void pop() {
        if (mFragment != null) {
            mFragment.popRoute();
        }
    }

    @Override
    public void onActivityResume() {
        super.onActivityResume();
        if (mFragment != null) {
            mFragment.onResume();
        }
    }

    @Override
    public void onActivityPause() {
        super.onActivityPause();
        if (mFragment != null) {
            mFragment.onPause();
        }
    }

    @Override
    public void onActivityStop() {
        super.onActivityStop();
        if (mFragment != null) {
            mFragment.onStop();
        }
    }

    @Override
    public void onActivityDestroy() {
        super.onActivityDestroy();
        destroyFragment();
    }

    @Override
    public void destroy() {
        destroyFragment();
        super.destroy();
    }

    private void destroyFragment() {
        if (mFragment != null) {
            mFragment.setFireEvent(null);
            FragmentActivity fragmentActivity = (FragmentActivity) getInstance().getContext();
            FragmentManager fragmentManager = fragmentActivity.getSupportFragmentManager();
            fragmentManager.beginTransaction().remove(mFragment).commit();
            mFragment = null;
        }
    }

}
