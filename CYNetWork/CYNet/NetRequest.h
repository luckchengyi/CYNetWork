//
//  NetRequest.h
//  CYNetWork
//
//  Created by 高程宜 on 2018/7/16.
//  Copyright © 2018年 高程宜. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NetResponse;
typedef void (^NetHttpResult)(BOOL success, NetResponse *response);

@interface NetRequest : NSObject

//接口名字
@property (nonatomic, strong) NSString *url;
//请求具体参数
@property (nonatomic, strong) NSDictionary *params;
//数据类，自动转换为相应的类，和NetResponse类的modelData/modelListData对应
@property (nonatomic, strong) NSString *resultClass;
//页面标识付，用于delloc时,cancel请求
@property (nonatomic, strong) NSString *pageId;
//签名后的参数
@property (nonatomic, strong) NSDictionary *signedParams;
//失败后重试次数，超时的时候会判断，业务失败不做重试
@property (nonatomic, assign) NSInteger retryCount;
//失败重试最大数，默认为1
@property (nonatomic, assign) NSInteger retryTotal;
//block回调
@property(nonatomic, copy) NetHttpResult httpResult;

+(NetRequest *)requestWith:(NSString *)url params:(NSDictionary *)params result:(NetHttpResult)result;

@end
