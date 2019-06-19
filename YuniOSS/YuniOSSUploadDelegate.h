//
//  YuniOSSUploadDelegate.h
//  AliyunOSSSDK iOS
//
//  Created by mingo on 2019/6/18.
//  Copyright © 2019 aliyun. All rights reserved.
//

#ifndef YuniOSSUploadDelegate_h
#define YuniOSSUploadDelegate_h

#import <Foundation/Foundation.h>
#import "OSSModel.h"
#import "OSSNetworkingRequestDelegate.h"

static uint8_t yuniOSSSharedBuffer[1024];

@interface YuniOSSUploadDelegate : NSObject <NSStreamDelegate>

@property (nonatomic, strong) NSThread *thread;
@property (nonatomic, strong) NSRunLoop *runLoop;
@property (nonatomic, strong) NSURL * uploadingFileURL;
@property (nonatomic, strong) NSInputStream * fileStream;
@property (nonatomic, strong) NSInputStream * bodyStream;
@property (nonatomic, strong) NSOutputStream * outputStream;
@property (nonatomic, strong) NSURLSessionDataTask * dataTask;
@property (nonatomic, strong) OSSNetworkingRequestDelegate * requestDelegate;
@property (nonatomic, assign) BOOL isSkipped;

- (NSURLSessionDataTask *_Nullable)getDataTask:(OSSNetworkingRequestDelegate *_Nonnull)request
                                   withSession:(NSURLSession *_Nonnull)session;

- (void)needNewBodyStream:(NSURLSessionDataTask *_Nonnull)task
              withSession:(NSURLSession *_Nonnull)session
    withCompletionHandler:(void (^_Nonnull)(NSInputStream * _Nullable))completionHandler;

@end

#endif /* YuniOSSUploadDelegate_h */
