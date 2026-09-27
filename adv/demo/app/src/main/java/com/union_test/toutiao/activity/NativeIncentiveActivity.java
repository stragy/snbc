package com.union_test.toutiao.activity;

import android.app.Activity;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.FrameLayout;

import com.bytedance.sdk.openadsdk.AdSlot;
import com.bytedance.sdk.openadsdk.TTAdManager;
import com.bytedance.sdk.openadsdk.TTAdNative;
import com.bytedance.sdk.openadsdk.TTFeedAd;
import com.bytedance.sdk.openadsdk.TTNativeAd;
import com.union_test.toutiao.R;
import com.union_test.toutiao.config.TTAdManagerHolder;
import com.union_test.toutiao.utils.TToast;
import com.union_test.toutiao.utils.UIUtils;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 原生福利（锚点）广告使用示例。英文命名：Incentive Ad。
 */
public class NativeIncentiveActivity extends Activity {

    public static final String TAG = "IncentiveAd";
    private static final String CODE_ID = "985308267";

    private TTAdNative mTTAdNative;
    private TTFeedAd mTTFeedAd;

    private FrameLayout mIncentiveContainer;
    private EditText mEtWidth;
    private EditText mEtHeight;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_native_incentive);

        mIncentiveContainer = findViewById(R.id.native_incentive_container);
        mEtWidth = findViewById(R.id.express_width);
        mEtHeight = findViewById(R.id.express_height);

        findViewById(R.id.btn_ane_back).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        findViewById(R.id.btn_native_incentive_load).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                loadIncentiveAd();
            }
        });

        //step1:初始化sdk
        TTAdManager ttAdManager = TTAdManagerHolder.get();
        //step2:创建TTAdNative对象，用于调用广告请求接口
        mTTAdNative = ttAdManager.createAdNative(this);
        //step3:(可选，强烈建议在合适的时机调用):申请部分权限，如read_phone_state,防止获取不了imei时候，下载类广告没有填充的问题。
        TTAdManagerHolder.get().requestPermissionIfNecessary(this);
    }

    private void loadIncentiveAd() {
        int widthDp = parseIntOr(mEtWidth.getText().toString(), 350);
        int heightDp = parseIntOr(mEtHeight.getText().toString(), 300);

        //step4:创建feed广告请求类型参数AdSlot,具体参数含义参考文档
        AdSlot adSlot = new AdSlot.Builder()
                .setCodeId(CODE_ID)
                .setImageAcceptedSize(UIUtils.dp2px(this, widthDp), UIUtils.dp2px(this, heightDp))
                .setExpressViewAcceptedSize(widthDp, heightDp)
                .setAdCount(1)
                .build();

        if (mTTAdNative == null) {
            return;
        }

        //step5:请求原生福利广告
        mTTAdNative.loadIncentiveAd(adSlot, new TTAdNative.FeedAdListener() {
            @Override
            public void onError(int code, String message) {
                Log.d(TAG, "onError: " + code + ", " + message);
                TToast.show(NativeIncentiveActivity.this, "load error : " + code + ", " + message);
            }

            @Override
            public void onFeedAdLoad(List<TTFeedAd> ads) {
                if (ads == null || ads.isEmpty()) {
                    TToast.show(NativeIncentiveActivity.this, "on FeedAdLoaded: ad is null!");
                    return;
                }
                if (mTTFeedAd != null) {
                    mTTFeedAd.destroy();
                }
                mTTFeedAd = ads.get(0);
                Log.d(TAG, "onFeedAdLoad: " + mTTFeedAd.getMediaExtraInfo());

                // 接入要求：mediaExtraInfo.style_category 非空，代表请求到的是原生福利广告，走原生福利广告展示流程
                // 否则视为常规信息流广告，demo 这里不做展示处理。
                if (!isIncentiveAd(mTTFeedAd)) {
                    Log.d(TAG, "onFeedAdLoad: 非锚点广告，不展示");
                    TToast.show(NativeIncentiveActivity.this, "非锚点广告，不展示");
                    return;
                }

                mTTFeedAd.setActivityForDownloadApp(NativeIncentiveActivity.this);
                showIncentiveAd(mTTFeedAd);
            }
        });
    }

    private static boolean isIncentiveAd(TTFeedAd ad) {
        if (ad == null) {
            return false;
        }
        Map<String, Object> mediaExtra = ad.getMediaExtraInfo();
        return mediaExtra != null && mediaExtra.get("style_category") != null;
    }

    /**
     * 原生福利广告展示流程：
     * 1）注册原生福利广告行为监听
     * 2）将准备好的空白容器通过 registerView 注册给 SDK
     */
    private void showIncentiveAd(TTFeedAd ad) {
        mIncentiveContainer.removeAllViews();

        // 注册原生福利广告行为监听
        ad.setIncentiveAdListener(new TTNativeAd.IncentiveAdListener() {
            @Override
            public void incentiveAdInfo(JSONObject jsonObject) {
                Log.d(TAG, "incentiveAdInfo: " + jsonObject);
                TToast.show(NativeIncentiveActivity.this, "incentiveAdInfo: " + jsonObject);
                // 必须在该回调里同步调整容器尺寸，根据返回的 preferred_size_width / preferred_size_height / preferred_aspect_ratio 调整容器至建议尺寸
                adjustToPreferredSize(jsonObject);
            }

            @Override
            public void incentiveAdRenderSuccess(JSONObject jsonObject) {
                Log.d(TAG, "incentiveAdRenderSuccess: " + jsonObject);
                TToast.show(NativeIncentiveActivity.this, "incentiveAdRenderSuccess: " + jsonObject);
            }

            @Override
            public void incentiveAdRenderFail(JSONObject jsonObject) {
                Log.d(TAG, "incentiveAdRenderFail: " + jsonObject);
                TToast.show(NativeIncentiveActivity.this, "incentiveAdRenderFail: " + jsonObject);
            }

            @Override
            public void incentiveAdClose() {
                Log.d(TAG, "incentiveAdClose");
                TToast.show(NativeIncentiveActivity.this, "incentiveAdClose");
            }
        });

        // 优先按用户输入尺寸设置容器；未输入时先按 match_parent 占位，
        // 等 incentiveAdInfo 回调再用建议尺寸/宽高比动态修改。
        applyContainerSizeFromUserInput();

        // 注册视图接口与信息流广告完全一致：这里点击区域、创意区域都传入空白容器本身即可
        List<View> clickViewList = new ArrayList<>();
        clickViewList.add(mIncentiveContainer);
        List<View> creativeViewList = new ArrayList<>();
        creativeViewList.add(mIncentiveContainer);

        ad.registerViewForInteraction((ViewGroup) mIncentiveContainer, // 无需渲染任何广告素材，直接把空白容器container注册给SDK即可
                new ArrayList<View>(),
                clickViewList,
                creativeViewList,
                null,
                new TTNativeAd.AdInteractionListener() {
                    @Override
                    public void onAdClicked(View view, TTNativeAd ad) {
                        Log.d(TAG, "onAdClicked");
                        TToast.show(NativeIncentiveActivity.this, "原生福利广告被点击");
                    }

                    @Override
                    public void onAdCreativeClick(View view, TTNativeAd ad) {
                        Log.d(TAG, "onAdCreativeClick");
                        TToast.show(NativeIncentiveActivity.this, "原生福利广告创意按钮被点击");
                    }

                    @Override
                    public void onAdShow(TTNativeAd ad) {
                        Log.d(TAG, "onAdShow");
                        TToast.show(NativeIncentiveActivity.this, "原生福利广告展示");
                    }
                });
    }

    /**
     * 依据用户输入的宽高设置容器；用户不填时保持 match_parent，等incentiveAdInfo建议尺寸回调。
     */
    private void applyContainerSizeFromUserInput() {
        int widthDp = parseIntOr(mEtWidth.getText().toString(), 0);
        int heightDp = parseIntOr(mEtHeight.getText().toString(), 0);
        if (widthDp <= 0 && heightDp <= 0) {
            return;
        }
        ViewGroup.LayoutParams lp = mIncentiveContainer.getLayoutParams();
        lp.width = widthDp > 0 ? UIUtils.dp2px(this, widthDp) : ViewGroup.LayoutParams.MATCH_PARENT;
        lp.height = heightDp > 0 ? UIUtils.dp2px(this, heightDp) : ViewGroup.LayoutParams.MATCH_PARENT;
        mIncentiveContainer.setLayoutParams(lp);
    }

    /**
     * 用户未输入尺寸时，读取回调中的 preferred_size_width / preferred_size_height /
     * preferred_aspect_ratio 动态修改父容器大小。
     * <p>
     * 优先级：preferred_size_width / preferred_size_height > preferred_aspect_ratio
     */
    private void adjustToPreferredSize(JSONObject info) {
        if (info == null) {
            return;
        }
        int userW = parseIntOr(mEtWidth.getText().toString(), 0);
        int userH = parseIntOr(mEtHeight.getText().toString(), 0);
        if (userW > 0 && userH > 0) {
            // 用户已输入完整尺寸，遵循用户输入
            return;
        }

        int preferredW = info.optInt("preferred_size_width", 0);
        int preferredH = info.optInt("preferred_size_height", 0);
        double preferredRatio = info.optDouble("preferred_aspect_ratio", 0d);

        int finalWidthDp = 0;
        int finalHeightDp = 0;
        if (preferredW > 0 && preferredH > 0) {
            finalWidthDp = preferredW;
            finalHeightDp = preferredH;
        } else if (preferredW > 0 && preferredRatio > 0d) {
            finalWidthDp = preferredW;
            finalHeightDp = (int) Math.round(preferredW / preferredRatio);
        } else if (preferredH > 0 && preferredRatio > 0d) {
            finalHeightDp = preferredH;
            finalWidthDp = (int) Math.round(preferredH * preferredRatio);
        } else {
            return;
        }

        ViewGroup.LayoutParams lp = mIncentiveContainer.getLayoutParams();
        lp.width = UIUtils.dp2px(this, finalWidthDp);
        lp.height = UIUtils.dp2px(this, finalHeightDp);
        mIncentiveContainer.setLayoutParams(lp);
    }

    private static int parseIntOr(String text, int fallback) {
        if (TextUtils.isEmpty(text)) {
            return fallback;
        }
        try {
            return Integer.parseInt(text.trim());
        } catch (NumberFormatException e) {
            return fallback;
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (mTTFeedAd != null) {
            mTTFeedAd.destroy();
            mTTFeedAd = null;
        }
        TToast.reset();
    }
}
