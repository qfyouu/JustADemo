//
//  NSString+util.h
//  cell高度问题
//
//  Created by qianfeng on 15/3/16.
//  Copyright (c) 2015年 刘威振. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (util)

- (CGFloat)heightWithFont:(UIFont *)font width:(CGFloat)width;

@end

@interface NSString (md5)

- (NSString *)md5;

@end
