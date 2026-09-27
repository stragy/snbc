package com.example.bct_new;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

/**
 * 启动入口 Activity。
 *
 * 开屏广告不再在本原生层处理：
 *  - 隐私合规要求穿山甲 SDK 必须在用户同意《隐私政策》之后初始化，而隐私协议弹窗在
 *    Flutter 侧（SplashPage → xieyi_dialog），原生层无法感知；在启动即初始化 SDK 属违规。
 *  - Pangle SDK 为全局单例初始化，原生层与 Flutter 侧（flutter_pangle_ads，appId=5408517）
 *    重复 init 会冲突，导致 Flutter 侧开屏广告无法填充。
 *
 * 因此开屏广告统一由 Flutter 侧 AdHelper.showSplashAd() 在用户同意协议后展示，
 * 本 Activity 仅作为启动入口，直接跳转 MainActivity。
 */
public class SplashAdActivity extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        goToMainActivity();
    }

    private void goToMainActivity() {
        if (isFinishing()) {
            return;
        }
        Intent intent = new Intent(this, MainActivity.class);
        startActivity(intent);
        finish();
    }

    @Override
    public void onBackPressed() {
        // 启动页禁用返回键
    }
}
