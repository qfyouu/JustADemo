//
//  ZXHistoryCell.m
//  CartoonStar
//
//  Created by qianfeng on 15/8/25.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ZXHistoryCell.h"
#import "ZXHistoryManager.h"
@implementation ZXHistoryCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)delete:(UIButton *)button {
    int num = (int)button.tag-1000;
    NSNumber *number = [[NSNumber alloc]initWithInt:num];
    NSDictionary *dic = @{@"num":number};
    [[NSNotificationCenter defaultCenter]postNotificationName:@"history" object:self userInfo:dic];
}

@end
