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
import io.dcloud.feature.uniapp.ui.action.AbsComponentData;
import io.dcloud.feature.uniapp.ui.component.AbsVContainer;
import io.dcloud.feature.uniapp.ui.component.UniComponent;
import io.dcloud.feature.uniapp.ui.component.UniComponentProp;
import io.flutter.embedding.android.FlutterFragment;
import io.flutter.embedding.engine.FlutterEngineCache;

public class FlutterComponent extends UniComponent<FrameLayout> implements Destroyable, SnFlutterFragment.UniComponentFireEvent {


    private static final String ENTRY_POINT = "entryPoint";
    private static final String PARAMS = "params";
    public static final String DESTROY_AFTER_BACK = "destroyAfterBack";

    private String instanceId;
    private String cacheId;
    private String entryPoint = "main";
    private boolean destroyAfterBack = true;
    private Map<String, Object> initParams = new HashMap();

    private SnFlutterFragment mFragment;
    private boolean isAdded = false;

    public FlutterComponent(UniSDKInstance instance, AbsVContainer parent, AbsComponentData componentData) {
        super(instance, parent, componentData);
        if (componentData.getAttrs().containsKey(ENTRY_POINT)) {
            entryPoint = componentData.getAttrs().get(ENTRY_POINT).toString();
        }
        if (componentData.getAttrs().containsKey(FlutterConstants.CACHE_ID)) {
            cacheId = componentData.getAttrs().get(FlutterConstants.CACHE_ID).toString();
        }
        if (TextUtils.isEmpty(cacheId)) {
            cacheId = entryPoint;
        }
        if (componentData.getAttrs().containsKey(FlutterConstants.INSTANCE_ID)) {
            instanceId = componentData.getAttrs().get(FlutterConstants.INSTANCE_ID).toString();
        }
        if (componentData.getAttrs().containsKey(PARAMS)) {
            initParams = JSON.parseObject(componentData.getAttrs().get(PARAMS).toString(), Map.class);
        }
        if (componentData.getAttrs().containsKey(DESTROY_AFTER_BACK)) {
            destroyAfterBack = Boolean.parseBoolean(componentData.getAttrs().get(DESTROY_AFTER_BACK).toString());
        }

    }

    @Override
    protected FrameLayout initComponentHostView(@NonNull Context context) {
        return new FrameLayout(context) {{
            setId(View.generateViewId());
        }};
    }

    @UniComponentProp(name = ENTRY_POINT)
    public void setEntryPoint(String entryPoint) {
    }

    @UniComponentProp(name = DESTROY_AFTER_BACK)
    public void setDestroyAfterBack(boolean destroyAfterBack) {
        this.destroyAfterBack = destroyAfterBack;
        if (mFragment != null)
            mFragment.setDestroyAfterBack(this.destroyAfterBack);
    }

    @UniComponentProp(name = PARAMS)
    public void setInitParams(String params) {
        this.initParams = JSON.parseObject(params, Map.class);
        if (mFragment != null)
            mFragment.setInitParams(this.initParams);
    }

    @UniJSMethod
    public void pop() {
        if (mFragment != null) {
            mFragment.popRoute();
        }
    }

    @Override
    protected void onFinishLayout() {
        super.onFinishLayout();
        if (isAdded) return;
        isAdded = true;
        if (FlutterEngineCache.getInstance().get(cacheId) != null) {
            mFragment = new FlutterFragment.CachedEngineFragmentBuilder(SnFlutterFragment.class, cacheId).build();
        } else {
            mFragment = new FlutterFragment.NewEngineFragmentBuilder(SnFlutterFragment.class)
                    .dartEntrypoint(entryPoint)
                    .build();
        }
        mFragment.setCacheId(cacheId);
        mFragment.setInitParams(initParams);
        mFragment.setInstanceId(instanceId);
        mFragment.setDestroyAfterBack(destroyAfterBack);
        mFragment.setFireEvent(this);
        FragmentActivity fragmentActivity = (FragmentActivity) getInstance().getContext();
        FragmentManager fragmentManager = fragmentActivity.getSupportFragmentManager();
        fragmentManager.beginTransaction().add(getHostView().getId(), mFragment).commit();
    }

    @Override
    public void onActivityResume() {
        super.onActivityResume();
        if (isAdded) {
            mFragment.onResume();
        }
    }

    @Override
    public void onActivityPause() {
        super.onActivityPause();
        if (isAdded) {
            mFragment.onPause();
        }
    }

    @Override
    public void onActivityStop() {
        super.onActivityStop();
        if (isAdded) {
            mFragment.onStop();
        }
    }

    @Override
    public void onActivityDestroy() {
        super.onActivityDestroy();
        if (isAdded) {
            mFragment.setFireEvent(null);
            mFragment.onDestroy();
        }
        isAdded = false;
        FragmentActivity fragmentActivity = (FragmentActivity) getInstance().getContext();
        FragmentManager fragmentManager = fragmentActivity.getSupportFragmentManager();
        fragmentManager.beginTransaction().remove(mFragment).commit();
        mFragment = null;
    }

    @Override
    public void destroy() {
        super.destroy();
    }

}
