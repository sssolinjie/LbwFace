package com.example.lbwBDFace.ui.widget;

import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;

import androidx.annotation.NonNull;

import com.baidu.idl.face.platform.utils.DensityUtils;
import com.example.lbwBDFace.R;

/**
 * 超时弹窗
 * Created by v_liujialu01 on 2020/4/7.
 */

public class TimeoutDialog extends Dialog implements View.OnClickListener {
    private Context mContext;
    private OnTimeoutDialogClickListener mOnTimeoutDialogClickListener;

    public TimeoutDialog(@NonNull Context context) {
        super(context, R.style.DefaultDialog);
        mContext = context;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        initView();
    }

    private void initView() {
        LayoutInflater inflater = LayoutInflater.from(mContext);
        View view = inflater.inflate(R.layout.dialog_time_out, null);
        setContentView(view);
        Window dialogWindow = getWindow();
        dialogWindow.setGravity(Gravity.CENTER_HORIZONTAL);
        WindowManager.LayoutParams lp = dialogWindow.getAttributes();
        int widthPx = DensityUtils.getDisplayWidth(getContext());
        int dp = DensityUtils.px2dip(getContext(), widthPx) - 40;
        lp.width = DensityUtils.dip2px(getContext(), dp);
        lp.height = WindowManager.LayoutParams.WRAP_CONTENT;
        dialogWindow.setAttributes(lp);
        Button btnDialogRecollect = (Button) view.findViewById(R.id.btn_dialog_recollect);
        btnDialogRecollect.setOnClickListener(this);
//        Button btnDialogReturn = (Button) view.findViewById(R.id.btn_dialog_return);
//        btnDialogReturn.setOnClickListener(this);
    }

    public void setDialogListener(OnTimeoutDialogClickListener listener) {
        mOnTimeoutDialogClickListener = listener;
    }

    @Override
    public void onClick(View v) {
        int id = v.getId();
        if (id == R.id.btn_dialog_recollect) {
            if (mOnTimeoutDialogClickListener != null) {
                mOnTimeoutDialogClickListener.onRecollect();
            }
        }
//        else if (id == R.id.btn_dialog_return) {
//            if (mOnTimeoutDialogClickListener != null) {
//                mOnTimeoutDialogClickListener.onReturn();
//            }
//        }
    }

    public interface OnTimeoutDialogClickListener {
        void onRecollect();

        void onReturn();
    }
}
