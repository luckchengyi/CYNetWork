//
//  NetTask.m
//  CYNetWork
//
//  Created by 高程宜 on 2018/7/16.
//  Copyright © 2018年 高程宜. All rights reserved.
//

#import "NetTask.h"
#import "NetWorkManager.h"
#import "DataTurn.h"
@implementation NetTask

@synthesize response = _response;
-(void)dealloc{
    self.delgate = nil;
}

-(NSString *)taskIdentifier{
    if (self.task) {
        return [NSString stringWithFormat:@"%lu",(unsigned long)self.task.taskIdentifier];
    }
    return nil;
}

-(void)start{
    self.request.retryCount ++;
        __weak __typeof(self)weakSelf = self;
    AFNetworkReachabilityManager *recachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [recachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status==-1 || status== 0) {
            NSError *error = [NSError errorWithDomain:@"当前网络不可用" code:-8888888 userInfo:nil];
            [weakSelf callError:error];
            return;
        }
    }];
    [recachabilityManager startMonitoring];
    NSURLSessionTask *task = [[NetWorkManager shareManager]POST:self.request.url parameters:self.request.params progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%lld",uploadProgress.completedUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self callSuccess:responseObject];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self callError:error];
    }];
    self.task = task;
}

-(void)callSuccess:(NSData *)responseObject{
    NSDictionary *info = [DataTurn JSONDataWithData:responseObject];
    _response = [self responseWithInfo:info];
    NSLog(@"===================接口返回日志分割线=====================");
    NSLog(@"返回值:%@",[DataTurn toJSONData:info]);
    NSLog(@"调用的接口：%@，发送的数据:%@",self.request.url,[DataTurn toJSONData:self.request.params]);
    if (_delgate && [_delgate respondsToSelector:@selector(didTaskSuccess:)]) {
        [_delgate didTaskSuccess:self];
    }
    
}

-(void)callError:(NSError *)error{
    _response = [self responseWithError:error];
    NSLog(@"==================非业务错误返回日志===============");
    NSLog(@"返回值:%@",error.domain);
    NSLog(@"调用的接口：%@,发送的数据；%@",self.request.url,[DataTurn toJSONData:self.request.params]);
    if (_delgate && [_delgate respondsToSelector:@selector(didTaskError:)]) {
        [_delgate didTaskError:self];
    }
}

-(NetResponse *)responseWithInfo:(NSDictionary *)responseInfo{
    NetResponse *response = [[NetResponse alloc]init];
    response.request = self.request;
    id data = responseInfo[@"data"];
    response.code = [responseInfo[@"code"] integerValue];
    response.msg = responseInfo[@"message"];
    response.data = data;
    response.responseData = responseInfo;
    if (response.request.resultClass) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            response.modelData = [DataTurn getObjByJsonStr:data ClassName:response.request.resultClass];
        } else if ([data isKindOfClass:[NSArray class]]) {
            response.modelListData = [DataTurn getObjArrByJsonStr:data ClassName:response.request.resultClass];
        }
    }
    return response;
}

-(NetResponse *)responseWithError:(NSError *)error{
    NetResponse *response = [[NetResponse alloc]init];
    response.code = error.code;
    response.request = self.request;
    response.msg = @"";
    return response;
}

@end
