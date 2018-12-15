//
//  ImageDownload.m
//  TableViewCellOptimization
//
//  Created by 梁宇航 on 2018/12/14.
//  Copyright © 2018年 梁宇航. All rights reserved.
//

#import "ImageDownload.h"
#import "DemoModel.h"
@implementation ImageDownload{
    NSURLSessionTask *_task;
}

- (void)loadImageWithModel:(DemoModel *)model success:(loadImageSuccess)completion{
    
    NSURLSession *session = [NSURLSession sharedSession];
    _task = [session dataTaskWithURL:[NSURL URLWithString:model.user.avatar_large] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            model.iconImage = image;
            completion();
        }
        
    }];
    
    [_task resume];
}

- (void)cancelLoadImage{
    [_task cancel];
}


@end
