//
//  SLMQRManager.m
//  SLMQRCodeReaderApp
//
//  Created by myxc on 09/03/2018.
//  Copyright © 2018 fengxin. All rights reserved.
//

#import "SLMQRManager.h"
#import "SLMQRCodeReaderApp-Swift.h"
#import "SLMQRCodeReader.h"
#import <UIKit/UIKit.h>
@implementation SLMQRManager

- (instancetype)init {
    self = [super init];
    if (self) {
        SLMQRCodeReader *reader = [[SLMQRCodeReader alloc] init];
        [reader showQRReaderWithController:[UIViewController new]];
        reader.qrCodeContent = ^(NSString * _Nonnull content) {
            
        };
    }
    return self;
}

@end
