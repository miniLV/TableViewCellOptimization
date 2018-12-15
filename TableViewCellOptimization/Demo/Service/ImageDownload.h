//
//  ImageDownload.h
//  TableViewCellOptimization
//
//  Created by 梁宇航 on 2018/12/14.
//  Copyright © 2018年 梁宇航. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DemoModel;

@interface ImageDownload : NSObject

typedef void(^loadImageSuccess)(void);

//开始加载图片，下载完成回调
- (void)loadImageWithModel:(DemoModel *)model success:(loadImageSuccess)completion;

//取消当前的图片下载操作
- (void)cancelLoadImage;

@end
