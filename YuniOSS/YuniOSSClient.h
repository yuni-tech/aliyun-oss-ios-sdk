//
//  YuniOSSClient.h
//  AliyunOSSSDK
//
//  Created by mingo on 2019/6/19.
//  Copyright © 2019 aliyun. All rights reserved.
//

#import "OSSClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface YuniOSSClient : OSSClient

- (OSSTask *)putObjectEncrypt:(OSSPutObjectRequest *)request;

@end

NS_ASSUME_NONNULL_END
