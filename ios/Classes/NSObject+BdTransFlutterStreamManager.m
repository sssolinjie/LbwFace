//
//  NSObject+BdTransFlutterStreamManager.m
//  lbwBDFace
//
//  Created by imacmini on 2021/3/10.
//

#import "NSObject+BdTransFlutterStreamManager.h"

@implementation BdTransFlutterStreamManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static BdTransFlutterStreamManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[BdTransFlutterStreamManager alloc] init];
        BdTransFlutterStreamHandler * streamHandler = [[BdTransFlutterStreamHandler alloc] init];
        manager.streamHandler = streamHandler;
    });

    return manager;
}

@end


@implementation BdTransFlutterStreamHandler

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
    self.eventSink = eventSink;
    return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {

    return nil;
}

-(void) sendbase:(NSString*)imagedata{
    self.eventSink(imagedata);
}

@end
