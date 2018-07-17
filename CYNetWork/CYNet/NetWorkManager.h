//
//  NetWorkManager.h
//  CYNetWork
//
//  Created by 高程宜 on 2018/7/16.
//  Copyright © 2018年 高程宜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "NetTask.h"
#import "NetRequest.h"

typedef void (^NetRequestErrorCommonBlock)(NSString *URL, NSString *postData, NSInteger code, NSString *message, id returnData);

typedef void (^NetRequestErrorTaskBlock)(NetTask *task);

@interface NetWorkManager : AFHTTPSessionManager

@property (nonatomic, strong) NSMutableArray *netTasks;
@property (nonatomic, strong, readonly) NSMutableArray *noTipURLs;
@property (nonatomic, strong, readonly) NSDictionary *commonParams;
@property (nonatomic, copy) NetRequestErrorCommonBlock reqestCompleteBlock;
@property (nonatomic, copy) NetRequestErrorTaskBlock requestErrorTaskBlock;
@property (nonatomic, assign, readonly) BOOL isMonitorNetworkStatus;

+(instancetype)shareManager;

//设置http头
-(void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;

-(void)post:(NetRequest *)request;

+(void)setRequestErrorCommonBlock:(NetRequestErrorCommonBlock)requestCompleteBlock;


@end
