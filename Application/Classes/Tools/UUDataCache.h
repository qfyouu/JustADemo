//
//  UUDataCache.h
//  CartoonStar
//
//  Created by 尤锐 on 15/8/25.
//  Copyright (c) 2015年 尤锐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUDataCache : NSObject


+ (UUDataCache *)sharedCache;

- (BOOL)saveDataWithData:(NSData *)data andStringName:(NSString *)name;

- (NSData *)getDataWithStringName:(NSString *)name;
@end
