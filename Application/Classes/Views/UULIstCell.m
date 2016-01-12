//
//  ZXLIstCell.m
//  CartoonStar
//
//  Created by qianfeng on 15/8/19.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ZXLIstCell.h"
#import "ZXChapterListModel.h"
#import "ZXDownLoadManager.h"


@interface ZXLIstCell ()<ZXDownLoadManagerDelegate>

@property (nonatomic,strong)ZXDownLoadManager *manager;
@property (nonatomic,strong)UIProgressView *progressView;

@end
@implementation ZXLIstCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, [UIScreen mainScreen].bounds.size.width-100, self.frame.size.height)];
        [self.contentView addSubview:_label];
        
        _downloadButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _downloadButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-50, 10, 30, self.frame.size.height-10);
        //@"icon_download_start.png"
//        [_downloadButton setImage:[[UIImage imageNamed:nil]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//        [_downloadButton addTarget:self action:@selector(downloadAction:) forControlEvents:UIControlEventTouchUpInside];
//        _downloadButton.tintColor = [UIColor clearColor];
//        [self.contentView addSubview:_downloadButton];
    }
    return self;
}
- (void)downloadAction:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        
    }else{
        
    }
}
- (void)setModel:(ZXChapterListModel *)model{
    _model = model;
    _label.text = [NSString stringWithFormat:@"%@ (%@p)",model.name,model.image_total];
    _manager = [[ZXDownLoadManager alloc]init];
    _manager.url = [NSURL URLWithString:@""];
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filepath = [doc stringByAppendingPathComponent:@""];
    self.manager.pathString = filepath;
    self.manager.delegate = self;
}

#pragma mark - ZXDownLoadManagerDelegate
- (void)fileDownloader:(ZXDownLoadManager *)manager failWithError:(NSError *)errpr{
    NSLog(@"%@",errpr.debugDescription);
}
- (void)fileDownloader:(ZXDownLoadManager *)manager didDownloadSize:(long long)downloadSize totalSize:(long long)totalSize{
    self.progressView.progress = (double)downloadSize/totalSize;
}
- (void)fileDownloaderDidFinish:(ZXDownLoadManager *)manager{
    
}
@end
