//
//  YuniOSSUploadDelegate.m
//  AliyunOSSSDK iOS
//
//  Created by mingo on 2019/6/19.
//  Copyright © 2019 aliyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "YuniOSSUploadDelegate.h"

@implementation YuniOSSUploadDelegate

- (instancetype)init {
    if (self = [super init]) {
        self.thread = [[NSThread alloc]initWithTarget:self selector:@selector(run) object:nil];
        [self.thread start];
    }
    return self;
}

- (void)dealloc {
    [self.thread cancel];
}

- (void)run{
    @autoreleasepool {
        self.runLoop = [NSRunLoop currentRunLoop];
        [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    }
}

- (NSURLSessionDataTask *)getDataTask:(OSSNetworkingRequestDelegate *)request
                          withSession:(NSURLSession *)session
{
    self.dataTask = [session uploadTaskWithStreamedRequest:request.internalRequest];
    return self.dataTask;
}
     
- (void)needNewBodyStream:(NSURLSessionDataTask *_Nonnull)task
                       withSession:(NSURLSession *_Nonnull)session
             withCompletionHandler:(void (^_Nonnull)(NSInputStream * _Nullable))completionHandler
{
    self.fileStream = [NSInputStream inputStreamWithURL:self.uploadingFileURL];
    [self.fileStream open];
    [self.fileStream read:yuniOSSSharedBuffer maxLength:64];
    NSInputStream *inputStream = nil;
    NSOutputStream *outputStream = nil;
    [NSStream getBoundStreamsWithBufferSize:1024 inputStream:&inputStream outputStream:&outputStream];
    self.bodyStream = inputStream;
    self.outputStream = outputStream;
    self.outputStream.delegate = self;
    [self.outputStream scheduleInRunLoop:self.runLoop forMode:NSDefaultRunLoopMode];
    [self.outputStream open];
    completionHandler(self.bodyStream);
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode;
{
    switch (eventCode) {
        case NSStreamEventNone: break;
        case NSStreamEventOpenCompleted:break;
        case NSStreamEventHasBytesAvailable: {
        } break;
            
        case NSStreamEventHasSpaceAvailable: {
            NSInteger len = [self.fileStream read:yuniOSSSharedBuffer maxLength:1024];
            if (len > 0) {
                [self.outputStream write:yuniOSSSharedBuffer maxLength:len];
            } else {
                [self.thread cancel];
                [self.fileStream close];
                [self.outputStream close];
            }
        } break;
            
        case NSStreamEventErrorOccurred:
            [self.thread cancel];
            [aStream close];
            [aStream removeFromRunLoop:[self.runLoop] forMode:NSDefaultRunLoopMode];
            aStream = nil;
        break;
        case NSStreamEventEndEncountered:
            [self.thread cancel];
            [aStream close];
            [aStream removeFromRunLoop:[self.runLoop] forMode:NSDefaultRunLoopMode];
            aStream = nil;
        break;
        default:
            break;
    }
}

@end

