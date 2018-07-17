//
//  NetWorkManager.m
//  CYNetWork
//
//  Created by 高程宜 on 2018/7/16.
//  Copyright © 2018年 高程宜. All rights reserved.
//

#import "NetWorkManager.h"
#import "DataTurn.h"
const NSString *kPageWillDeallocInManager = @"kPageWillDeallocInManager";

@interface NetWorkManager ()<NetTaskDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) NSString *cusBaseURL;
@property (nonatomic, assign) NSTimeInterval requestTimeout;

@end

@implementation NetWorkManager

-(void)dealloc{
    
}

-(NSMutableArray *)netTasks{
    if (_netTasks == nil) {
        _netTasks = [[NSMutableArray alloc]init];
    }
    return _netTasks;
}


static NetWorkManager *_manage = nil;
+(instancetype)shareManager{
    if (!_manage) {
        [NetWorkManager registerHTTPManagerWithBansURL:nil];
    }
    return _manage;
}

+(void)registerHTTPManagerWithBansURL:(NSString *)baseURL {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.HTTPMaximumConnectionsPerHost = 10;
        _manage = [[self alloc]initWithBaseURL:[NSURL URLWithString:baseURL] sessionConfiguration:configuration];
        [_manage.securityPolicy setAllowInvalidCertificates:YES];
        [_manage registerNotification];
        //发送json数据
        _manage.requestSerializer = [AFJSONRequestSerializer serializer];
        //相应 二级制 数据， 目的为了能和打点分析公用同一个mansger
        _manage.responseSerializer = [AFHTTPResponseSerializer serializer];
        //设置响应方式
        _manage.responseSerializer.acceptableContentTypes =  [_manage.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/atom+xml",@"application/xml",@"text/xml",nil]];
        [_manage.requestSerializer setValue:@"application/json; encoding=utf-8" forHTTPHeaderField:@"Content-Type"];
        [_manage.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [_manage.requestSerializer setValue:@"haoshuai" forHTTPHeaderField:@"gaochengyi"];
        _manage.cusBaseURL = baseURL;
        
    });
}

-(void)post:(NetRequest *)request{
    NetTask *task = [[NetTask alloc]init];
    task.request = request;
    task.delgate = self;
    [task start];
}

-(void)processTaskSuccess:(NetTask *)task{
    NetResponse *response = task.response;
    NSInteger code = response.code;
    if (response && code == 0 ) {
        if (response.request.httpResult) {
            response.request.httpResult(YES, response);
        }
        return;
    }
    NetRequestErrorCommonBlock completeBlock = [NetWorkManager shareManager].reqestCompleteBlock;
    if (completeBlock) {
        NSString *postData = [DataTurn toJSONPrettyPrintedData:task.request.params];
        completeBlock(task.request.url, postData, task.response.code, task.response.msg, task.response.responseData);
    }
    NetRequestErrorTaskBlock errorTaskBlock = [NetWorkManager shareManager].requestErrorTaskBlock;
    if (errorTaskBlock) {
        errorTaskBlock(task);
    }
    if (response.request.httpResult) {
        response.request.httpResult(NO, response);
    }
}

#pragma mark - NetTaskDelegate
-(void)didTaskSuccess:(NetTask *)task{
    [self processTaskSuccess:task];
}

-(void)didTaskError:(NetTask *)task{
    NetRequestErrorCommonBlock comleteBlock = [NetWorkManager shareManager].reqestCompleteBlock;
    if (comleteBlock) {
        NSString *postData = [DataTurn toJSONPrettyPrintedData:task.request.params];
        comleteBlock(task.request.url,postData,task.response.code,task.response.msg,task.response.responseData);
    }
    NetRequestErrorTaskBlock errorTaskblock = [NetWorkManager shareManager].requestErrorTaskBlock;
    if (errorTaskblock) {
        errorTaskblock(task);
    }
    NetResponse *response = task.response;
    if (response.request.httpResult) {
        response.request.httpResult(NO, response);
    }
}

+(void)setRequestErrorCommonBlock:(NetRequestErrorCommonBlock)requestCompleteBlock{
    [NetWorkManager shareManager].reqestCompleteBlock = requestCompleteBlock;
}

-(void)registerNotification {
    
}

-(void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field{
    
}



@end
