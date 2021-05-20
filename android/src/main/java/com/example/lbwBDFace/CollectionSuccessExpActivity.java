package com.example.lbwBDFace;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;

import com.example.lbwBDFace.ui.CollectionSuccessActivity;
import com.example.lbwBDFace.ui.utils.IntentUtils;

import org.greenrobot.eventbus.EventBus;


/**
 * 采集成功页面
 * Created by v_liujialu01 on 2020/4/1.
 */

public class CollectionSuccessExpActivity extends CollectionSuccessActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    // 回到首页
    public void onReturnHome(View v) {
        super.onReturnHome(v);

        String bmpStr = IntentUtils.getInstance().getBitmap();
        if ("FaceLivenessExpActivity".equals(mDestroyType)) {
            //ExampleApplication.destroyActivity("FaceLivenessExpActivity");
            EventBus.getDefault().post(MessageEvent.getInstance("1",bmpStr));
        }
        if ("FaceDetectExpActivity".equals(mDestroyType)) {
           // ExampleApplication.destroyActivity("FaceDetectExpActivity");
            EventBus.getDefault().post(MessageEvent.getInstance("2",bmpStr));
        }
        finish();
    }
}
