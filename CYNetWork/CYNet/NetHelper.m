//
//  NetHelper.m
//  CYNetWork
//
//  Created by 高程宜 on 2018/7/16.
//  Copyright © 2018年 高程宜. All rights reserved.
//

#import "NetHelper.h"
#import "NetWorkManager.h"
@implementation NetHelper

+(void)postWithResuest:(NetRequest *)request{
    [[NetWorkManager shareManager]post:request];
}

@end
