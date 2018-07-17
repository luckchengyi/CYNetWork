//
//  NetRequest.m
//  CYNetWork
//
//  Created by 高程宜 on 2018/7/16.
//  Copyright © 2018年 高程宜. All rights reserved.
//

#import "NetRequest.h"

@implementation NetRequest

-(instancetype)init{
    self = [super init];
    if (self) {
        self.retryTotal = 1;
    }
    return self;
}

+(NetRequest *)requestWith:(NSString *)url params:(NSDictionary *)params result:(NetHttpResult)result{
    NetRequest *request = [[NetRequest alloc]init];
    request.url = url;
    request.params = params;
    request.httpResult = result;
    return request;
}

@end
