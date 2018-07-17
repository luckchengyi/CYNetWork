//
//  NetHelper.h
//  CYNetWork
//
//  Created by 高程宜 on 2018/7/16.
//  Copyright © 2018年 高程宜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetRequest.h"
@interface NetHelper : NSObject

+(void)postWithResuest:(NetRequest *)request;

@end
