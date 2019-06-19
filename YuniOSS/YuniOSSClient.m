//
//  YuniOSSClient.m
//  AliyunOSSSDK iOS
//
//  Created by mingo on 2019/6/19.
//  Copyright © 2019 aliyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "OSSNetworkingRequestDelegate.h"
#import "YuniOSSUploadDelegate.h"
#import "YuniOSSClient.h"

@interface OSSRequest ()

@property (nonatomic, strong) OSSNetworkingRequestDelegate *requestDelegate;

@end

@implementation YuniOSSClient

- (OSSTask *)putObjectEncrypt:(OSSPutObjectRequest *)request {
    OSSNetworkingRequestDelegate *requestDelegate = request.requestDelegate;
    YuniOSSUploadDelegate *uploadDelegate = [YuniOSSUploadDelegate new];
    uploadDelegate.uploadingFileURL = request.uploadingFileURL;
    requestDelegate.uploadDelegate = uploadDelegate;
    return [super putObject:request];
}

@end
