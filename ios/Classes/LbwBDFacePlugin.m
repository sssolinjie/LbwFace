#import "LbwBDFacePlugin.h"
#import "FaceParameterConfig.h"
#import "IDLFaceSDK/IDLFaceSDK.h"
#import "BDFaceLivingConfigModel.h"
#import "BDFaceDetectionViewController.h"
#import "BDFaceLivenessViewController.h"
#import "NSObject+BdTransFlutterStreamManager.h"

static FlutterResult m_result;

@implementation LbwBDFacePlugin

+(FlutterResult)myresult {
    return m_result;
}
+ (void)setFlag:(FlutterResult)flag {
    m_result = flag;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"lbwBDFace"
            binaryMessenger:[registrar messenger]];
  LbwBDFacePlugin* instance = [[LbwBDFacePlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
    
    FlutterEventChannel *eventChanel = [FlutterEventChannel eventChannelWithName:@"lbwBDFace111" binaryMessenger:[registrar messenger]];
        
    [eventChanel setStreamHandler:[[BdTransFlutterStreamManager sharedInstance] streamHandler]];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"initSDK" isEqualToString:call.method]) {
      [self initSDK];
      [self initLivenesswithList];
      [LbwBDFacePlugin setFlag:result];
    }else if ([@"destory" isEqualToString:call.method]) {
        [self destorySDK];
      }else if ([@"faceDetect" isEqualToString:call.method]) {
          [LbwBDFacePlugin setFlag:result];
          [self faceDetect];
        }else if ([@"faceLiveness" isEqualToString:call.method]) {
            [LbwBDFacePlugin setFlag:result];
            [self faceLiveness];
          }else {
    result(FlutterMethodNotImplemented);
  }
}

-(void) initSDK{
    NSString* licensePath = [NSString stringWithFormat:@"%@.%@", FACE_LICENSE_NAME, FACE_LICENSE_SUFFIX ];
    [[FaceSDKManager sharedInstance] setLicenseID:FACE_LICENSE_ID andLocalLicenceFile:licensePath andRemoteAuthorize:true];
    if (![[FaceSDKManager sharedInstance] canWork]){
        NSLog(@"授权失败，请检测ID 和 授权文件是否可用");
        return;
    }else{
        NSLog(@"授权成功");
    }
    
    // 初始化SDK配置参数，可使用默认配置
    // 设置最小检测人脸阈值
    [[FaceSDKManager sharedInstance] setMinFaceSize:200];
    // 设置截取人脸图片高
    [[FaceSDKManager sharedInstance] setCropFaceSizeWidth:480];
    // 设置截取人脸图片宽
    [[FaceSDKManager sharedInstance] setCropFaceSizeHeight:640];
    // 设置人脸遮挡阀值
    [[FaceSDKManager sharedInstance] setOccluThreshold:0.5];
    // 设置亮度阀值
    [[FaceSDKManager sharedInstance] setMinIllumThreshold:40];
    [[FaceSDKManager sharedInstance] setMaxIllumThreshold:240];
    // 设置图像模糊阀值
    [[FaceSDKManager sharedInstance] setBlurThreshold:0.3];
    // 设置头部姿态角度
    [[FaceSDKManager sharedInstance] setEulurAngleThrPitch:10 yaw:10 roll:10];
    // 设置人脸检测精度阀值
    [[FaceSDKManager sharedInstance] setNotFaceThreshold:0.6];
    // 设置抠图的缩放倍数
    [[FaceSDKManager sharedInstance] setCropEnlargeRatio:2.5];
    // 设置照片采集张数
    [[FaceSDKManager sharedInstance] setMaxCropImageNum:1];
    // 设置超时时间
    [[FaceSDKManager sharedInstance] setConditionTimeout:15];
    // 设置开启口罩检测，非动作活体检测可以采集戴口罩图片
    [[FaceSDKManager sharedInstance] setIsCheckMouthMask:true];
    // 设置开启口罩检测情况下，非动作活体检测口罩过滤阈值，默认0.8 不需要修改
    [[FaceSDKManager sharedInstance] setMouthMaskThreshold:0.8f];
    // 设置原始图缩放比例
    [[FaceSDKManager sharedInstance] setImageWithScale:0.5f];
    // 设置图片加密类型，type=0 基于base64 加密；type=1 基于百度安全算法加密
    [[FaceSDKManager sharedInstance] setImageEncrypteType:0];
    // 设置人脸过远框比例
    [[FaceSDKManager sharedInstance] setMinRect:0.4];
    // 初始化SDK功能函数
    [[FaceSDKManager sharedInstance] initCollect];
    
}
- (void)initLivenesswithList {
    // 默认活体检测打开，顺序执行
    /*
     添加当前默认的动作，是否需要按照顺序，动作活体的数量（设置页面会根据这个numOfLiveness来判断选择了几个动作）
     */
    [BDFaceLivingConfigModel.sharedInstance.liveActionArray addObject:@(FaceLivenessActionTypeLiveEye)];
    [BDFaceLivingConfigModel.sharedInstance.liveActionArray addObject:@(FaceLivenessActionTypeLiveMouth)];
    [BDFaceLivingConfigModel.sharedInstance.liveActionArray addObject:@(FaceLivenessActionTypeLiveYawRight)];
//    [BDFaceLivingConfigModel.sharedInstance.liveActionArray addObject:@(FaceLivenessActionTypeLiveYawLeft)];
//    [BDFaceLivingConfigModel.sharedInstance.liveActionArray addObject:@(FaceLivenessActionTypeLivePitchUp)];
//    [BDFaceLivingConfigModel.sharedInstance.liveActionArray addObject:@(FaceLivenessActionTypeLivePitchDown)];
//    [BDFaceLivingConfigModel.sharedInstance.liveActionArray addObject:@(FaceLivenessActionTypeLiveYaw)];
    BDFaceLivingConfigModel.sharedInstance.isByOrder = NO;
    BDFaceLivingConfigModel.sharedInstance.numOfLiveness = 3;
}
- (void) destorySDK{
    // 销毁SDK功能函数
    [[FaceSDKManager sharedInstance] uninitCollect];
}

- (void)faceDetect {
    FlutterAppDelegate* delegate = (FlutterAppDelegate*)[[UIApplication sharedApplication]delegate];
    FlutterViewController* rootVC = (FlutterViewController*)delegate.window.rootViewController;
    [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"LiveMode"];
    BDFaceDetectionViewController* dvc = [[BDFaceDetectionViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:dvc];
    navi.navigationBarHidden = true;
    navi.modalPresentationStyle = UIModalPresentationFullScreen;
    [rootVC presentViewController:navi animated:YES completion:nil];
}

- (void)faceLiveness {
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"LiveMode"];
    FlutterAppDelegate* delegate = (FlutterAppDelegate*)[[UIApplication sharedApplication]delegate];
    FlutterViewController* rootVC = (FlutterViewController*)delegate.window.rootViewController;
    
    BDFaceLivenessViewController* lvc = [[BDFaceLivenessViewController alloc] init];
    BDFaceLivingConfigModel* model = [BDFaceLivingConfigModel sharedInstance];
    [lvc livenesswithList:model.liveActionArray order:model.isByOrder numberOfLiveness:model.numOfLiveness];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:lvc];
    navi.navigationBarHidden = true;
    navi.modalPresentationStyle = UIModalPresentationFullScreen;
    [rootVC presentViewController:navi animated:YES completion:nil];
}
@end
