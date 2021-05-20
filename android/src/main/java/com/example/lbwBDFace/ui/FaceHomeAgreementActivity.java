package com.example.lbwBDFace.ui;

import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;

import com.example.lbwBDFace.R;

/**
 * 人脸采集协议页面
 */
public class FaceHomeAgreementActivity extends BaseActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_face_home_agreement);
        initView();
    }

    private void initView() {
        ImageView agreementReturn = (ImageView) findViewById(R.id.agreement_return);
        agreementReturn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });

    }
}
