package com.example.lbwBDFace;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.util.Log;
import android.widget.Toast;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.ImageView;
import android.widget.TextView;
import androidx.annotation.NonNull;


import com.baidu.idl.face.platform.FaceConfig;
import com.baidu.idl.face.platform.FaceEnvironment;
import com.baidu.idl.face.platform.FaceSDKManager;
import com.baidu.idl.face.platform.LivenessTypeEnum;
import com.baidu.idl.face.platform.listener.IInitCallback;

import org.greenrobot.eventbus.EventBus;
import org.greenrobot.eventbus.Subscribe;
import org.greenrobot.eventbus.ThreadMode;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.PluginRegistry;
/** LbwBDFacePlugin */
public class LbwBDFacePlugin implements FlutterPlugin, MethodCallHandler,ActivityAware,PluginRegistry.ActivityResultListener {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Application application;
  private Context context;
  private boolean mIsInitSuccess;
  private static final String TAG = LbwBDFacePlugin.class.getSimpleName();
  private LbwBDFacePlugin.LivenessCallback livenessCallback;
  private LbwBDFacePlugin.DetectCallback detectCallback;
  private static Activity activity;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "lbwBDFace");
    channel.setMethodCallHandler(this);
    application = ((Application) flutterPluginBinding.getApplicationContext());
    context = application.getApplicationContext();
    EventBus.getDefault().register(this);
  }
  //此处是旧的插件加载注册方式
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "lbwWake");
    final LbwBDFacePlugin plugin = new LbwBDFacePlugin().initPlugin(channel, registrar);
    channel.setMethodCallHandler(plugin);
    registrar.addActivityResultListener(plugin);
  }
  public LbwBDFacePlugin initPlugin(MethodChannel methodChannel, Registrar registrar) {
    channel = methodChannel;
    activity = registrar.activity();
    context = registrar.context();
    application = ((Application) context.getApplicationContext());
    return this;
  }
  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("initSDK")) {
      initSDK();
    } else if (call.method.equals("destory")) {

    } else if (call.method.equals("faceDetect")) {
      detectCallback = new LbwBDFacePlugin.DetectCallback(result);
      detect(call.hasArgument("language") ? call.<String>argument("language") : null);
    } else if (call.method.equals("faceLiveness")) {
      livenessCallback = new LbwBDFacePlugin.LivenessCallback(result);
      liveness(call.hasArgument("language") ? call.<String>argument("language") : null);
    } else {
      result.notImplemented();
    }
  }
  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
    EventBus.getDefault().unregister(this);
  }

  private void detect(String language) {
    Intent intent = new Intent(activity, FaceDetectExpActivity.class);
    Bundle mBundle = new Bundle();
    mBundle.putString("language", (language == null || "".equals(language)) ? "zh" : language);
    intent.putExtras(mBundle);
    activity.startActivity(intent);
  }

  private void liveness(String language) {
    Intent intent = new Intent(activity, FaceLivenessExpActivity.class);
    Bundle mBundle = new Bundle();
    mBundle.putString("language", (language == null || "".equals(language)) ? "zh" : language);
    intent.putExtras(mBundle);
    activity.startActivity(intent);
  }

  public void initSDK() {
    FaceSDKManager.getInstance().initialize(context, "lianshiLicense-face-android",
            "idl-license.face-android", new IInitCallback() {
              @Override
              public void initSuccess() {
                Log.e("baidu", "初始化成功");
              }

              @Override
              public void initFailure(final int errCode, final String errMsg) {
                Log.e("baidu", "初始化失败 = " + errCode + " " + errMsg);
              }
            });
    // 随机动作
    Config.isLivenessRandom = true;
    // 根据需求添加活体动作
    Config.livenessList.clear();
    Config.livenessList.add(LivenessTypeEnum.Eye);
    // TODO test
//        Config.livenessList.add(LivenessTypeEnum.Mouth);
//        Config.livenessList.add(LivenessTypeEnum.HeadUp);
//        Config.livenessList.add(LivenessTypeEnum.HeadDown);
//        Config.livenessList.add(LivenessTypeEnum.HeadLeft);
//        Config.livenessList.add(LivenessTypeEnum.HeadRight);
//        Config.livenessList.add(LivenessTypeEnum.HeadLeftOrRight);
    // 设置 FaceConfig
    FaceConfig config = FaceSDKManager.getInstance()
            .getFaceConfig();
    // 设置可检测的最小人脸阈值
    config.setMinFaceSize(FaceEnvironment.VALUE_MIN_FACE_SIZE);
    // 设置可检测到人脸的阈值
    config.setNotFaceValue(FaceEnvironment.VALUE_NOT_FACE_THRESHOLD);
    // 设置模糊度阈值
    config.setBlurnessValue(FaceEnvironment.VALUE_BLURNESS);
    // 设置光照阈值（范围0-255）
    config.setBrightnessValue(FaceEnvironment.VALUE_BRIGHTNESS);
    // 设置遮挡阈值
    config.setOcclusionValue(FaceEnvironment.VALUE_OCCLUSION);
    // 设置人脸姿态角阈值
    config.setHeadPitchValue(FaceEnvironment.VALUE_HEAD_PITCH);
    config.setHeadYawValue(FaceEnvironment.VALUE_HEAD_YAW);
    // 设置闭眼阈值
    config.setEyeClosedValue(FaceEnvironment.VALUE_CLOSE_EYES);
    // 设置图片缓存数量
    config.setCacheImageNum(FaceEnvironment.VALUE_CACHE_IMAGE_NUM);
    // 设置活体动作，通过设置list，LivenessTypeEunm.Eye, LivenessTypeEunm.Mouth,
    // LivenessTypeEunm.HeadUp, LivenessTypeEunm.HeadDown, LivenessTypeEunm.HeadLeft,
    // LivenessTypeEunm.HeadRight, LivenessTypeEunm.HeadLeftOrRight
    config.setLivenessTypeList(Config.livenessList);
    // 设置动作活体是否随机
    config.setLivenessRandom(Config.isLivenessRandom);
    // 设置开启提示音
    config.setSound(true);
    // 原图缩放系数
    config.setScale(FaceEnvironment.VALUE_SCALE);
    // 抠图高的设定，为了保证好的抠图效果，我们要求高宽比是4：3，所以会在内部进行计算，只需要传入高即可
    config.setCropHeight(FaceEnvironment.VALUE_CROP_HEIGHT);
    // 加密类型，0：Base64加密，上传时image_sec传false；1：百度加密文件加密，上传时image_sec传true
    config.setSecType(FaceEnvironment.VALUE_SEC_TYPE);
    FaceSDKManager.getInstance().setFaceConfig(config);
    // 初始化资源文件
    FaceSDKResSettings.initializeResId();
  }


  @Override
  public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
    Log.i("BaiduFacePlugin",
            "onActivityResult: requestCode=" + requestCode + ", resultCode=" + resultCode + ", data=" + data);
    return false;
  }
  @Subscribe(threadMode = ThreadMode.MAIN)
  public void onGetMessage(MessageEvent message) {
    if(message.type=="1"){
      livenessCallback.sucess(message.message);
    }else {
      detectCallback.sucess(message.message);
    }
  }
  ///activity 生命周期
  @Override
  public void onAttachedToActivity(ActivityPluginBinding activityPluginBinding) {
    Log.e("onAttachedToActivity", "onAttachedToActivity");
    this.activity = activityPluginBinding.getActivity();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    //Log.e("onDetachedFromActivityForConfigChanges", "onDetachedFromActivityForConfigChanges");
    EventBus.getDefault().unregister(this);
  }

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding activityPluginBinding) {
    //Log.e("onReattachedToActivityForConfigChanges", "onReattachedToActivityForConfigChanges");
  }

  @Override
  public void onDetachedFromActivity() {
    //Log.e("onDetachedFromActivity", "onDetachedFromActivity");
  }


  class LivenessCallback {

    private Result result;

    public LivenessCallback(Result result) {
      this.result = result;
    }

    public void sucess(String image) {
      Map<String, String> map = new HashMap<>();
      map.put("success", "true");
      map.put("srcimage", image);
      result.success(image);
    }

    public void failed() {
      Map<String, String> map = new HashMap<>();
      map.put("success", "false");
      result.success("0");
    }

  }

  class DetectCallback {

    private Result result;

    public DetectCallback(Result result) {
      this.result = result;
    }

    public void sucess(String image) {
      Map<String, String> map = new HashMap<>();
      map.put("success", "true");
      map.put("srcimage", image);
      result.success(image);
    }

    public void failed() {
      Map<String, String> map = new HashMap<>();
      map.put("success", "false");
      result.success("0");
    }

  }
}