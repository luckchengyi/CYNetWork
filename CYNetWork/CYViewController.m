//
//  ViewController.m
//  CYNetWork
//
//  Created by 高程宜 on 2018/7/5.
//  Copyright © 2018年 高程宜. All rights reserved.
//

#import "CYViewController.h"
#import "NetWorkManager.h"
@interface CYViewController ()

@end

@implementation CYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *view =[[UIImageView alloc]initWithFrame:self.view.frame];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://img.zcool.cn/community/0117e2571b8b246ac72538120dd8a4.jpg@1280w_1l_2o_100sh.jpg"]];
    UIImage *img = [UIImage imageWithData:data];
    view.image = img;
    [self.view addSubview:view];
    
    [self registHTTPCompleteBlock];
    [self errorBack];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)registHTTPCompleteBlock {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"15212776560" forKey:@"mobile"];
    [dic setObject:@"0086" forKey:@"phone_region"];
    [dic setObject:@"123456" forKey:@"password"];
    [dic setObject:@"56A8DA3DB4922618323D6535BA8E5772" forKey:@"_sign_"];
    [dic setObject:@"com.weimob.mdstore" forKey:@"appIdentifier"];

    [[NetWorkManager shareManager]post:[NetRequest requestWith:@"http://mxdapi.mengdian.com/v2/account/login" params:dic result:^(BOOL success, NetResponse *response) {
        [self data:response.data];
    }]];
    
//    [[NetWorkManager shareManager]post:[NetRequest requestWith:@"http://mxdapi.mengdian.com/prettyStoreApp/userProfilePull" params:nil result:^(BOOL success, NetResponse *response) {
//        NSLog(@"%@",response.data);
//    }]];
}

-(void)data:(id)data{
    NSLog(@"%@",data);
}

-(void)errorBack{
    [NetWorkManager setRequestErrorCommonBlock:^(NSString *URL, NSString *postData, NSInteger code, NSString *message, id returnData) {
        if (code == -8888888) {
            UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"" message:@"网络不可用" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [view show];
        }else{
             NSLog(@"+++++++++++++%@",message);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
