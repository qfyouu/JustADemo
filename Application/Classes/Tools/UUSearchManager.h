//
//  ZXSearchManager.h
//  CartoonStar
//
//  Created by 尤锐 on 15/8/22.
//  Copyright (c) 2015年 尤锐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXSearchManager : NSObject

+ (ZXSearchManager *)sharedManager;


- (BOOL)insert:(NSString *)string;
- (BOOL)delete:(NSString *)string;

- (NSMutableArray *)fetchAll;

- (BOOL)deleteAll;

@end
