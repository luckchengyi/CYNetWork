//
//  NetResponse.h
//  CYNetWork
//
//  Created by 高程宜 on 2018/7/16.
//  Copyright © 2018年 高程宜. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    responseBusinessError = 1,
    reponseNetError = 2
} ResponseErropType;

@class NetRequest;
@interface NetResponse : NSObject

//原始字典数据
@property(nonatomic, strong) NSDictionary *responseData;
//接口错误类型
@property(nonatomic, assign) ResponseErropType erropType;
//data数据
@property(nonatomic, strong) id data;
//状态码
@property(nonatomic, assign) NSInteger code;
//状态信息
@property(nonatomic, strong) NSString *msg;
//参数
@property(nonatomic, strong) NetRequest *request;
//自动转换模式结果
@property(nonatomic, strong) id modelData;
//自动转换数组模型结果
@property(nonatomic, strong) NSMutableArray *modelListData;

@end
