//
//  DemoModel.h
//  TableViewCellOptimization
//
//  Created by 梁宇航 on 2018/12/14.
//  Copyright © 2018年 梁宇航. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class User;
@interface DemoModel : NSObject

@property (nonatomic, strong)UIImage *iconImage;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, strong) User *user;


@end


@interface User : NSObject

@property (nonatomic, copy) NSString *avatar_large;

@end
