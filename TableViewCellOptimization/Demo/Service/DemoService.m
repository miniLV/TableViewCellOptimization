//
//  DemoService.m
//  TableViewCellOptimization
//
//  Created by 梁宇航 on 2018/12/14.
//  Copyright © 2018年 梁宇航. All rights reserved.
//

#import "DemoService.h"
#import <AFNetworking.h>
#import "DemoModel.h"
#import <YYModel.h>
@implementation DemoService

+ (void)fetchDataSuccess:(successBlock)completion{
    
    //新浪微博API
    NSString *urlStr = @"https://api.weibo.com/2/statuses/public_timeline.json?access_token=2.00xo2AIClMprWC3c9e06af90JEgXHE";
    
    [[AFHTTPSessionManager manager] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *tempDatas = responseObject[@"statuses"];
        NSMutableArray *json = @[].mutableCopy;
        [json addObjectsFromArray:tempDatas];
        [json addObjectsFromArray:tempDatas];
        [json addObjectsFromArray:tempDatas];
        [json addObjectsFromArray:tempDatas];
        [json addObjectsFromArray:tempDatas];
        
        NSArray *datas = [NSArray yy_modelArrayWithClass:[DemoModel class] json:json];
        completion(datas);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error");
    }];
    
}

@end
