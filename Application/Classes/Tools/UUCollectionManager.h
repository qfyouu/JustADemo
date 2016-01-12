//
//  ZXCollectionManager.h
//  CartoonStar
//
//  Created by 尤锐 on 15/8/22.
//  Copyright (c) 2015年 尤锐. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ZXLIstModel;
@interface ZXCollectionManager : NSObject

+ (ZXCollectionManager *)sharedManager;

- (void)prepare;
- (BOOL)insert:(ZXLIstModel *)model ;
- (BOOL)delete:(ZXLIstModel *)model ;
- (BOOL)deleteById:(NSString *)comic_id ;
- (NSMutableArray *)fetchAll;
- (BOOL)deleteAll;
- (BOOL)findModel:(ZXLIstModel *)model;

@end
