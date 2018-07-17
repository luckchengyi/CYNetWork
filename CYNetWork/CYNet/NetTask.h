//
//  NetTask.h
//  CYNetWork
//
//  Created by 高程宜 on 2018/7/16.
//  Copyright © 2018年 高程宜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetRequest.h"
#import "NetResponse.h"
@class NetTask;
@protocol NetTaskDelegate <NSObject>

-(void)didTaskSuccess:(NetTask *)task;

-(void)didTaskError:(NetTask *)task;

@end

@interface NetTask : NSObject

//AFN的task
@property (nonatomic, strong) NSURLSessionTask *task;

//request参数
@property (nonatomic, strong) NetRequest *request;

@property (nonatomic, strong, readonly)NetResponse *response;

//结果回调
@property (nonatomic, assign)id<NetTaskDelegate> delgate;

//开始请求
-(void)start;

//每个任务的唯一标识
-(NSString *)taskIdentifier;

@end
