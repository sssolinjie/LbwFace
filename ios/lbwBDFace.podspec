#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint lbwBDFace.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'lbwBDFace'
  s.version          = '0.0.1'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'
  s.ios.vendored_frameworks = 'Frameworks/IDLFaceSDK.framework'
  s.vendored_frameworks = 'IDLFaceSDK.framework'
  #s.resources = ['Frameworks/com.baidu.idl.face.faceSDK.bundle', 'Frameworks/com.baidu.idl.face.live.action.image.bundle', 'Frameworks/com.baidu.idl.face.model.faceSDK.bundle', 'Assets/Assets.xcassets']
  s.resources = ['Frameworks/com.baidu.idl.face.faceSDK.bundle', 'Frameworks/com.baidu.idl.face.live.action.image.bundle', 'Frameworks/com.baidu.idl.face.model.faceSDK.bundle', 'Assets/icon_titlebar_back_p.png','Assets/icon_titlebar_back@3x.png','Assets/icon_titlebar_close.png','Assets/btn_main_p.png']
  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
