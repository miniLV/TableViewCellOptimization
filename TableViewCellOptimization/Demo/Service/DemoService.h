//
//  DemoService.h
//  TableViewCellOptimization
//
//  Created by 梁宇航 on 2018/12/14.
//  Copyright © 2018年 梁宇航. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^successBlock)(NSArray *array);

@interface DemoService : NSObject

+ (void)fetchDataSuccess:(successBlock)completion;

@end
