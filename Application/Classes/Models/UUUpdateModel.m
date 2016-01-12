//
//  ZXUpdateModel.m
//  CartoonStar
//
//  Created by qianfeng on 15/8/17.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ZXUpdateModel.h"

@implementation ZXUpdateModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err{
    if (self=[super initWithDictionary:dict error:err]) {
        _myDescription = dict[@"description"];
    }
    return self;
}
@end
