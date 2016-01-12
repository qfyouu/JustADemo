//
//  ZXUpdateCell.m
//  CartoonStar
//
//  Created by qianfeng on 15/8/17.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ZXUpdateCell.h"
#import "ZXUpdateModel.h"
#import "UIImageView+AFNetworking.h"

@implementation ZXUpdateCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat width = ([UIScreen mainScreen].bounds.size.width-20)/4.0;
        _itemImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, width, 1.3*width)];
        [self.contentView addSubview:_itemImageView];
        
        CGFloat height = _itemImageView.frame.size.height/4.0;
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(width+20, 10+5, 200, height-10)];
        _nameLabel.font = [UIFont boldSystemFontOfSize:17];
        [self.contentView addSubview:_nameLabel];
        
        UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(width+20, CGRectGetMaxY(_nameLabel.frame)+10, height-10, height-10)];
        imageView1.image = [[UIImage imageNamed:@"icon_list_author_green.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self.contentView addSubview:imageView1];
        
        _nicknameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView1.frame), imageView1.frame.origin.y, 60, imageView1.frame.size.height)];
        //_nicknameLabel.adjustsFontSizeToFitWidth = YES;
        _nicknameLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_nicknameLabel];
        
        UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_nicknameLabel.frame), imageView1.frame.origin.y, imageView1.frame.size.width, imageView1.frame.size.height)];
        imageView2.image = [[UIImage imageNamed:@"icon_list_hand_green.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self.contentView addSubview:imageView2];
        
        _click_totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView2.frame), imageView2.frame.origin.y, 50, imageView2.frame.size.height)];
        //_click_totalLabel.adjustsFontSizeToFitWidth = YES;
        _click_totalLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_click_totalLabel];
        
        UIImageView *imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_click_totalLabel.frame), imageView1.frame.origin.y, imageView1.frame.size.width, imageView1.frame.size.height)];
        imageView3.image = [[UIImage imageNamed:@"icon_list_classify_green.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self.contentView addSubview:imageView3];
        
        _tagsLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView3.frame), imageView3.frame.origin.y, 100, imageView3.frame.size.height)];
        //_tagsLabel.adjustsFontSizeToFitWidth = YES;
        _tagsLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_tagsLabel];
        

        
        _last_update_chapter_nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView1.frame.origin.x, CGRectGetMaxY(imageView1.frame)+10, 150, imageView1.frame.size.height)];
        //_last_update_chapter_nameLabel.adjustsFontSizeToFitWidth = YES;
        _last_update_chapter_nameLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_last_update_chapter_nameLabel];
        
        UIImageView *imageView4 = [[UIImageView alloc]initWithFrame:CGRectMake(imageView1.frame.origin.x, CGRectGetMaxY(_last_update_chapter_nameLabel.frame)+10, imageView1.frame.size.width, imageView1.frame.size.height)];
        imageView4.image = [[UIImage imageNamed:@"icon_list_clock.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self.contentView addSubview:imageView4];
        
        _last_update_timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView4.frame)+10, imageView4.frame.origin.y, 150, imageView4.frame.size.height)];
        _last_update_timeLabel.textColor = [UIColor redColor];
        _last_update_timeLabel.font = [UIFont systemFontOfSize:13];
        //_last_update_timeLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_last_update_timeLabel];
        _image = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-50, 0, 50, 50)];
        [self.contentView addSubview:_image];
    }
    return self;
}

- (void)setModel:(ZXUpdateModel *)model{
    _model = model;
    [_itemImageView setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"bg_default_cover.png"]];
    //CGRect frame = _nameLabel.frame;
    _nameLabel.text = model.name;
    
    _nicknameLabel.text = model.nickname;

    _click_totalLabel.text = model.click_total;
    

    _tagsLabel.text = [model.tags componentsJoinedByString:@" "];
    

    
    _last_update_chapter_nameLabel.text = [NSString stringWithFormat:@"更新到  %@",model.last_update_chapter_name];
    
    NSDate *date = [NSDate date];
    int t = date.timeIntervalSince1970 - model.last_update_time.floatValue;
    if (t/60 < 60) {
        _last_update_timeLabel.text = [NSString stringWithFormat:@"%d分钟前更新",t/60];
    }else if (t/60/60<24){
        _last_update_timeLabel.text = [NSString stringWithFormat:@"%d小时前更新",t/60/60];
    }else{
        _last_update_timeLabel.text = [NSString stringWithFormat:@"%d天前更新",t/60/60/24];
    }
    
   
    

}
- (void)awakeFromNib {
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
