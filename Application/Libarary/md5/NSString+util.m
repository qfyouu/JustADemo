//
//  NSString+util.m
//  cell高度问题
//
//  Created by qianfeng on 15/3/16.
//  Copyright (c) 2015年 刘威振. All rights reserved.
//

#import "NSString+util.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (util)

- (CGFloat)heightWithFont:(UIFont *)font width:(CGFloat)width {
    // NOTE: All of the following methods will default to drawing on a baseline, limiting drawing to a single line.
    // To correctly draw and size multi-line text, pass NSStringDrawingUsesLineFragmentOrigin in the options parameter.
    // This method returns fractional sizes (in the size component of the returned CGRect); to use a returned size to size views, you must use raise its value to the nearest higher integer using the ceil function.
    CGFloat height = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.height;
    // return height;
    return ceil(height);
}

@end


@implementation NSString (md5)

- (NSString *)md5 {
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    // NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    NSMutableString *outputString = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
    // return [outputString autorelease];
}

@end

