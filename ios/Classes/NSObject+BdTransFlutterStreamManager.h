//
//  NSObject+BdTransFlutterStreamManager.h
//  lbwBDFace
//
//  Created by imacmini on 2021/3/10.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN
@class BdTransFlutterStreamHandler;
@interface BdTransFlutterStreamManager : NSObject
+ (instancetype)sharedInstance ;
@property (nonatomic, strong) BdTransFlutterStreamHandler* streamHandler;

@end

@interface BdTransFlutterStreamHandler : NSObject<FlutterStreamHandler>
@property (nonatomic, strong) FlutterEventSink eventSink;

@end
NS_ASSUME_NONNULL_END
