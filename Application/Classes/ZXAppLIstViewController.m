//
//  ZXAppLIstViewController.m
//  CartoonStar
//
//  Created by qianfeng on 15/8/19.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ZXAppLIstViewController.h"
#import "ZXNavgationBarView.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "ZXLIstModel.h"
#import "ZXChapterListModel.h"
#import "ZXLIstCell.h"
#import "UIImageView+AFNetworking.h"
#import "ZXReadViewController.h"
#import "ZXLast_readModel.h"
#import "ZXCollectionManager.h"
//#import "UMSocial.h"
#define kAppListUrl(comicid,date)  [NSString stringWithFormat:@"http://app.u17.com/v3/app/android/phone/comic/detail?comicid=%d&t=%d&v=2110000&android_id=c37003cf2965586a&key=null&come_from=sanxingJ",comicid,date]
@interface ZXAppLIstViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)ZXCollectionManager *manager1;
@property (nonatomic,strong)NSMutableArray *datas;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIView *rooterView;
@property (nonatomic,strong)UIView *upView;
@property (nonatomic,strong)UIView *headerView1;
@property (nonatomic,strong)UIView *headerView2;
@property (nonatomic,strong)UIView *headerView3;

@property (nonatomic,strong)UIButton *leftButton;
@property (nonatomic,strong)UIButton *rightButton;

@property (nonatomic,strong)UIButton *leftButton1;
@property (nonatomic,strong)UIButton *rightButton1;

@end

@implementation ZXAppLIstViewController{
    int t;
}
- (NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // ZXCollectionManager *manager = [ZXCollectionManager sharedManager];
    _manager1 = [ZXCollectionManager sharedManager];
    
    NSDate *date = [NSDate date];
    t = date.timeIntervalSince1970;
    
    
//    [self prepareData];
    [self prepareTabbar];
    [self prepareTableView];
    [self setRefresh];
   
}
- (void)prepareData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeBlack];
    [manager GET:kAppListUrl(self.comicid, t) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dataDic = dic[@"data"];
        NSDictionary *returnData = dataDic[@"returnData"];
        NSDictionary *comicDic = returnData[@"comic"];
        ZXLIstModel *model = [[ZXLIstModel alloc]initWithDictionary:comicDic error:nil];
        [self.datas addObject:model];
        NSArray *array = returnData[@"chapter_list"];
        for (NSDictionary *dict in array) {
            ZXChapterListModel *model = [[ZXChapterListModel alloc]initWithDictionary:dict error:nil];
            [self.datas addObject:model];
        }
        NSDictionary *dicty = returnData[@"last_read"];
        ZXLast_readModel *readModel = [[ZXLast_readModel alloc]initWithDictionary:dicty error:nil];
        [self.datas addObject:readModel];
    
        [SVProgressHUD showSuccessWithStatus:@"OK" maskType:SVProgressHUDMaskTypeBlack];
        
        [self prepareTableView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败" maskType:SVProgressHUDMaskTypeBlack];
        [self prepareData];
    }];

}
- (void)setRefresh{
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.tableView headerBeginRefreshing];
    
    //[self.tableView addFooterWithTarget:self action:@selector(rooterRefresh)];
    
    self.tableView.headerPullToRefreshText = @"下拉刷新";
    self.tableView.headerReleaseToRefreshText = @"松开后刷新";
    self.tableView.headerRefreshingText = @"正在拼命刷新中";
    
    self.tableView.footerPullToRefreshText = @"上拉加载";
    self.tableView.footerReleaseToRefreshText = @"松开后加载";
    self.tableView.footerRefreshingText = @"正在拼命加载中";
}
- (void)headerRefresh{
    //[self.datas removeAllObjects];
    [self prepareData];
    [self.tableView headerEndRefreshing];
}

- (void)prepareTabbar{
    ZXNavgationBarView *barView = [[ZXNavgationBarView alloc]init];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[[UIImage imageNamed:@"ic_back.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    button.frame = CGRectMake(10, 10, 20, 44-20);
    [button addTarget:self action:@selector(buttonclike:) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:button];
    [self.view addSubview:barView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2.0-50, 0, 100, barView.frame.size.height)];
    titleLabel.text = @"漫画介绍";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [barView addSubview:titleLabel];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = CGRectMake(self.view.frame.size.width-10-20, 10, 20, 44-20);
    //@"abc_ic_menu_share_holo_light.png"
    [rightButton setImage:[[UIImage imageNamed:nil]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:rightButton];
    
}
- (void)buttonclike:(UIButton *)button{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//分享
- (void)rightButtonClick:(UIButton *)button{
//    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"507fcab25270157b37000010" shareText:@"我在玩儿" shareImage:nil shareToSnsNames:@[UMShareToRenren,UMShareToWechatTimeline,UMShareToSina,UMShareToQzone,UMShareToDouban] delegate:nil];
}
- (void)prepareTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    ZXLIstModel *model = self.datas.firstObject;
    _tableView.tableHeaderView = [self prepareHeaderView:model];
    
    [_tableView registerClass:[ZXLIstCell class] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:_tableView];
}

- (UIView *)prepareHeaderView: (ZXLIstModel *)model{
    CGFloat height = ([UIScreen mainScreen].bounds.size.height-64)/3.0*2.0;
    _headerView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height)];
    
    CGFloat imageViewWidth = ([UIScreen mainScreen].bounds.size.width-40)/3.0;
    CGFloat imageViewHeight = 1.5*imageViewWidth;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, imageViewWidth, imageViewHeight)];
    [imageView setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"umeng_socialize_share_pic.png"]];
    [_headerView1 addSubview:imageView];
    
    CGFloat height1 = (imageView.frame.size.height-4*10)/7.0;
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+10, imageView.frame.origin.y, [UIScreen mainScreen].bounds.size.width-CGRectGetMaxX(imageView.frame)-10, 2*height1)];
    nameLabel.text = model.name;
    nameLabel.font = [UIFont boldSystemFontOfSize:20];
    [_headerView1 addSubview:nameLabel];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, CGRectGetMaxY(nameLabel.frame)+10, 30, height1)];
    label1.text = @"作者";
    label1.font = [UIFont systemFontOfSize:13];
    [_headerView1 addSubview:label1];
    
    UILabel *authorLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame),label1.frame.origin.y, [UIScreen mainScreen].bounds.size.width-CGRectGetMaxX(label1.frame)-10, height1)];
    authorLabel.font = [UIFont boldSystemFontOfSize:15];
    authorLabel.text = model.author_name;
    [_headerView1 addSubview:authorLabel];
    
    UILabel *last_update_Label = [[UILabel alloc]initWithFrame:CGRectMake(label1.frame.origin.x, CGRectGetMaxY(label1.frame)+10, [UIScreen mainScreen].bounds.size.width-label1.frame.origin.x, height1)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.last_update_time.intValue];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    last_update_Label.text = [NSString stringWithFormat:@"更新  %@",[formatter stringFromDate:date]];
    last_update_Label.font = [UIFont systemFontOfSize:13];
    [_headerView1 addSubview:last_update_Label];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(label1.frame.origin.x, CGRectGetMaxY(last_update_Label.frame)+10, last_update_Label.frame.size.width, height1)];
    label2.font = [UIFont systemFontOfSize:13];
    label2.text = [NSString stringWithFormat:@"总点击  %@",model.click_total];
    [_headerView1 addSubview:label2];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    button1.frame = CGRectMake(label1.frame.origin.x, CGRectGetMaxY(imageView.frame)-height1*2, imageViewWidth*0.7, height1*2);
    button1.backgroundColor = [UIColor redColor];
    if ([_manager1 findModel:model]) {
        button1.backgroundColor = [UIColor orangeColor];
        [button1 setTitle:@"已收藏" forState:UIControlStateNormal];
    }else{
        [button1 setTitle:@"添加收藏" forState:UIControlStateNormal];
    }

    //[button1 setTitle:@"添加收藏" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    _manager 
    [button1 addTarget:self action:@selector(buttonLeftClike:) forControlEvents:UIControlEventTouchUpInside];
    _leftButton1 = button1;
    [_headerView1 addSubview:_leftButton1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    button2.frame = CGRectMake(CGRectGetMaxX(button1.frame)+10, button1.frame.origin.y, imageViewWidth*0.7, height1*2);
    button2.backgroundColor = [UIColor greenColor];
    [button2 setTitle:@"开始阅读" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(buttonRightClike:) forControlEvents:UIControlEventTouchUpInside];
    _rightButton1 = button2;
    [_headerView1 addSubview:_rightButton1];
    
    UIView *upView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _headerView1.frame.size.width, CGRectGetMaxY(imageView.frame))];
    [upView addSubview:imageView];
    [upView addSubview:nameLabel];
    [upView addSubview:label1];
    [upView addSubview:authorLabel];
    [upView addSubview:last_update_Label];
    [upView addSubview:label2];
    [upView addSubview:button1];
    [upView addSubview:button2];
    _headerView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, upView.frame.size.width, upView.frame.size.height+60)];
    [_headerView1 addSubview:upView];
    [_headerView1 addSubview:imageView];
    [_headerView1 addSubview:nameLabel];
    [_headerView1 addSubview:label1];
    [_headerView1 addSubview:authorLabel];
    [_headerView1 addSubview:last_update_Label];
    [_headerView1 addSubview:label2];
    [_headerView1 addSubview:button1];
    [_headerView1 addSubview:button2];
    UILabel *upLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(upView.frame)+10, upView.frame.size.width-40, 40)];
    upLabel.text = model.myDescription;
    upLabel.numberOfLines = 2;
    upLabel.font = [UIFont systemFontOfSize:13];
    [_headerView1 addSubview:upLabel];
    UIButton *upButton1 = [UIButton buttonWithType:UIButtonTypeSystem];
    upButton1.frame = CGRectMake(_headerView1.frame.size.width-30, _headerView1.frame.size.height-30, 20, 20);
    [upButton1 setImage:[[UIImage imageNamed:@"icon_comic_detail_disvisible.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [upButton1 addTarget:self action:@selector(downButtionClick:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView1 addSubview:upButton1];
    

    return _headerView1;
}
- (UIView *)prepareHeadeView1:(ZXLIstModel *)model{
    CGFloat height = ([UIScreen mainScreen].bounds.size.height-64-49)/3.0*2.0;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height)];
    
    CGFloat imageViewWidth = ([UIScreen mainScreen].bounds.size.width-40)/3.0;
    CGFloat imageViewHeight = 1.5*imageViewWidth;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, imageViewWidth, imageViewHeight)];
    [imageView setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"umeng_socialize_share_pic.png"]];
    [headerView addSubview:imageView];
    
    CGFloat height1 = (imageView.frame.size.height-4*10)/7.0;
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+10, imageView.frame.origin.y, [UIScreen mainScreen].bounds.size.width-CGRectGetMaxX(imageView.frame)-10, 2*height1)];
    nameLabel.text = model.name;
    nameLabel.font = [UIFont boldSystemFontOfSize:20];
    [headerView addSubview:nameLabel];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, CGRectGetMaxY(nameLabel.frame)+10, 30, height1)];
    label1.text = @"作者";
    label1.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:label1];
    
    UILabel *authorLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame),label1.frame.origin.y, [UIScreen mainScreen].bounds.size.width-CGRectGetMaxX(label1.frame)-10, height1)];
    authorLabel.font = [UIFont boldSystemFontOfSize:15];
    authorLabel.text = model.author_name;
    [headerView addSubview:authorLabel];
    
    UILabel *last_update_Label = [[UILabel alloc]initWithFrame:CGRectMake(label1.frame.origin.x, CGRectGetMaxY(label1.frame)+10, [UIScreen mainScreen].bounds.size.width-label1.frame.origin.x, height1)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.last_update_time.intValue];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    last_update_Label.text = [NSString stringWithFormat:@"更新  %@",[formatter stringFromDate:date]];
    last_update_Label.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:last_update_Label];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(label1.frame.origin.x, CGRectGetMaxY(last_update_Label.frame)+10, last_update_Label.frame.size.width, height1)];
    label2.font = [UIFont systemFontOfSize:13];
    label2.text = [NSString stringWithFormat:@"总点击  %@",model.click_total];
    [headerView addSubview:label2];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    button1.frame = CGRectMake(label1.frame.origin.x, CGRectGetMaxY(imageView.frame)-height1*2, imageViewWidth*0.7, height1*2);
    button1.backgroundColor = [UIColor redColor];
    if ([_manager1 findModel:model]) {
        button1.backgroundColor = [UIColor orangeColor];
        [button1 setTitle:@"已收藏" forState:UIControlStateNormal];
    }else{
        [button1 setTitle:@"添加收藏" forState:UIControlStateNormal];
        button1.backgroundColor = [UIColor redColor];
    }
    
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(buttonLeftClike:) forControlEvents:UIControlEventTouchUpInside];
    _leftButton = button1;
    [headerView addSubview:_leftButton];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    button2.frame = CGRectMake(CGRectGetMaxX(button1.frame)+10, button1.frame.origin.y, imageViewWidth*0.7, height1*2);
    button2.backgroundColor = [UIColor greenColor];
    [button2 setTitle:@"开始阅读" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(buttonRightClike:) forControlEvents:UIControlEventTouchUpInside];
    _rightButton = button2;

    [headerView addSubview:_rightButton];
    
    UIView *rooterView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), headerView.frame.size.width, headerView.frame.size.height-CGRectGetMaxY(imageView.frame))];
    //_rooterView = rooterView;
    //rooterView.backgroundColor = [UIColor cyanColor];
    [headerView addSubview:rooterView];
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(imageView.frame)+10, headerView.frame.size.width-40, 50)];
    //label3.backgroundColor = [UIColor redColor];
    label3.text = model.myDescription;
    label3.numberOfLines = 0;
    label3.font = [UIFont systemFontOfSize:13];
    CGRect frame = label3.frame;
    CGSize size = [label3.text boundingRectWithSize:CGSizeMake(label3.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label3.font} context:nil].size;
    frame.size = size;
    label3.frame = frame;
    //label3.backgroundColor = [UIColor cyanColor];
    [headerView addSubview:label3];
    //火影忍者
//    NSLog(@"%f",rooterView.frame.size.height);
//    NSLog(@"%f",label3.frame.size.height);
    
    //CGFloat height3 = ((rooterView.frame.size.height-label3.frame.size.height)-6*5-10)/5.0;
    
    UILabel *rLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(label3.frame.origin.x, CGRectGetMaxY(label3.frame)+5, label3.frame.size.width, 20)];
    rLabel1.text = [NSString stringWithFormat:@"分类 : %@",model.theme_ids];
    rLabel1.adjustsFontSizeToFitWidth = YES;
    //rLabel1.backgroundColor = [UIColor redColor];
    rLabel1.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:rLabel1];
    
    UILabel *rLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(label3.frame.origin.x, CGRectGetMaxY(rLabel1.frame)+5, label3.frame.size.width, 20)];
    rLabel2.adjustsFontSizeToFitWidth = YES;
    rLabel2.text = [NSString stringWithFormat:@"类型 : %@",model.cate_id];
    //rLabel2.backgroundColor = [UIColor yellowColor];
    rLabel2.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:rLabel2];
    
    UILabel *rLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(label3.frame.origin.x, CGRectGetMaxY(rLabel2.frame)+5, label3.frame.size.width/2.0, 20)];
    rLabel3.adjustsFontSizeToFitWidth = YES;
    rLabel3.text = [NSString stringWithFormat:@"总月票 : %d",model.total_ticket.intValue];
    rLabel3.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:rLabel3];
    
    UILabel *rLabel4 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(rLabel3.frame), CGRectGetMaxY(rLabel2.frame)+5, label3.frame.size.width/2.0, 20)];
    rLabel4.text = [NSString stringWithFormat:@"总吐槽 : %d",model.total_tucao.intValue];
    rLabel4.adjustsFontSizeToFitWidth = YES;
    rLabel4.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:rLabel4];
    
    UILabel *rLabel5 = [[UILabel alloc]initWithFrame:CGRectMake(rLabel3.frame.origin.x, CGRectGetMaxY(rLabel3.frame)+5, label3.frame.size.width/2.0, 20)];
    rLabel5.text = [NSString stringWithFormat:@"总点击 : %@",model.click_total];
    rLabel5.adjustsFontSizeToFitWidth = YES;
    rLabel5.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:rLabel5];
    
    UILabel *rLabel6 = [[UILabel alloc]initWithFrame:CGRectMake(rLabel4.frame.origin.x, CGRectGetMaxY(rLabel3.frame)+5, label3.frame.size.width/2.0, 20)];
    rLabel6.text = [NSString stringWithFormat:@"总评论 : %d",model.comment_total.intValue];
    rLabel6.adjustsFontSizeToFitWidth = YES;
    rLabel6.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:rLabel6];
    
    UILabel *rLabel7 = [[UILabel alloc]initWithFrame:CGRectMake(rLabel5.frame.origin.x, CGRectGetMaxY(rLabel5.frame)+5, label3.frame.size.width/2.0, 20)];
    rLabel7.text = [NSString stringWithFormat:@"总图片 : %d",model.image_all.intValue];
    rLabel7.adjustsFontSizeToFitWidth = YES;
    rLabel7.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:rLabel7];
    
    UILabel *rLabel8 = [[UILabel alloc]initWithFrame:CGRectMake(rLabel6.frame.origin.x, CGRectGetMaxY(rLabel6.frame)+5, label3.frame.size.width/2.0, 20)];
    rLabel8.text = [NSString stringWithFormat:@"本月月票 : %d",model.month_ticket.intValue];
    rLabel8.adjustsFontSizeToFitWidth = YES;
    rLabel8.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:rLabel8];
    CGRect frame3 = headerView.frame;
    frame3.size.height = CGRectGetMaxY(rLabel8.frame)+5;
    NSLog(@"%f",CGRectGetMaxY(rLabel8.frame)+5);
    NSLog(@"%f",frame3.size.height);
    headerView.frame = frame3;
    UIButton *upButton = [UIButton buttonWithType:UIButtonTypeSystem];
    upButton.frame = CGRectMake(headerView.frame.size.width-30, headerView.frame.size.height-30, 20, 20);
    [upButton setImage:[[UIImage imageNamed:@"icon_comic_detail_visible.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [upButton addTarget:self action:@selector(upButtionClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:upButton];
    
    return headerView;

}
- (UIView *)prepareHeadeView2:(ZXLIstModel *)model{
        CGFloat height = ([UIScreen mainScreen].bounds.size.height-64)/3.0*2.0;
        _headerView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height)];
    
        CGFloat imageViewWidth = ([UIScreen mainScreen].bounds.size.width-40)/3.0;
        CGFloat imageViewHeight = 1.5*imageViewWidth;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, imageViewWidth, imageViewHeight)];
        [imageView setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"umeng_socialize_share_pic.png"]];
        [_headerView2 addSubview:imageView];
    
        CGFloat height1 = (imageView.frame.size.height-4*10)/7.0;
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+10, imageView.frame.origin.y, [UIScreen mainScreen].bounds.size.width-CGRectGetMaxX(imageView.frame)-10, 2*height1)];
        nameLabel.text = model.name;
        nameLabel.font = [UIFont boldSystemFontOfSize:20];
        [_headerView2 addSubview:nameLabel];
    
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, CGRectGetMaxY(nameLabel.frame)+10, 30, height1)];
        label1.text = @"作者";
        label1.font = [UIFont systemFontOfSize:13];
        [_headerView2 addSubview:label1];
    
        UILabel *authorLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame),label1.frame.origin.y, [UIScreen mainScreen].bounds.size.width-CGRectGetMaxX(label1.frame)-10, height1)];
        authorLabel.font = [UIFont boldSystemFontOfSize:15];
        authorLabel.text = model.author_name;
        [_headerView2 addSubview:authorLabel];
    
        UILabel *last_update_Label = [[UILabel alloc]initWithFrame:CGRectMake(label1.frame.origin.x, CGRectGetMaxY(label1.frame)+10, [UIScreen mainScreen].bounds.size.width-label1.frame.origin.x, height1)];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.last_update_time.intValue];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        last_update_Label.text = [NSString stringWithFormat:@"更新  %@",[formatter stringFromDate:date]];
        last_update_Label.font = [UIFont systemFontOfSize:13];
        [_headerView2 addSubview:last_update_Label];
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(label1.frame.origin.x, CGRectGetMaxY(last_update_Label.frame)+10, last_update_Label.frame.size.width, height1)];
        label2.font = [UIFont systemFontOfSize:13];
        label2.text = [NSString stringWithFormat:@"总点击  %@",model.click_total];
        [_headerView2 addSubview:label2];
    
        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
        button1.frame = CGRectMake(label1.frame.origin.x, CGRectGetMaxY(imageView.frame)-height1*2, imageViewWidth*0.7, height1*2);
        button1.backgroundColor = [UIColor redColor];
        if ([_manager1 findModel:model]) {
            button1.backgroundColor = [UIColor orangeColor];
            [button1 setTitle:@"已收藏" forState:UIControlStateNormal];
        }else{
            [button1 setTitle:@"添加收藏" forState:UIControlStateNormal];
            button1.backgroundColor = [UIColor redColor];
        }
    
        //[button1 setTitle:@"添加收藏" forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //    _manager
        [button1 addTarget:self action:@selector(buttonLeftClike:) forControlEvents:UIControlEventTouchUpInside];
        _leftButton1 = button1;
        [_headerView2 addSubview:_leftButton1];
    
        UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
        button2.frame = CGRectMake(CGRectGetMaxX(button1.frame)+10, button1.frame.origin.y, imageViewWidth*0.7, height1*2);
        button2.backgroundColor = [UIColor greenColor];
        [button2 setTitle:@"开始阅读" forState:UIControlStateNormal];
        [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button2 addTarget:self action:@selector(buttonRightClike:) forControlEvents:UIControlEventTouchUpInside];
        _rightButton1 = button2;
        [_headerView2 addSubview:_rightButton1];
    
        UIView *upView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _headerView2.frame.size.width, CGRectGetMaxY(imageView.frame))];
        [upView addSubview:imageView];
        [upView addSubview:nameLabel];
        [upView addSubview:label1];
        [upView addSubview:authorLabel];
        [upView addSubview:last_update_Label];
        [upView addSubview:label2];
        [upView addSubview:button1];
        [upView addSubview:button2];
        _headerView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, upView.frame.size.width, upView.frame.size.height+60)];
        [_headerView1 addSubview:upView];
        [_headerView1 addSubview:imageView];
        [_headerView1 addSubview:nameLabel];
        [_headerView1 addSubview:label1];
        [_headerView1 addSubview:authorLabel];
        [_headerView1 addSubview:last_update_Label];
        [_headerView1 addSubview:label2];
        [_headerView1 addSubview:button1];
        [_headerView1 addSubview:button2];
        UILabel *upLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(upView.frame)+10, upView.frame.size.width-40, 40)];
        upLabel.text = model.myDescription;
        upLabel.numberOfLines = 2;
        upLabel.font = [UIFont systemFontOfSize:13];
        [_headerView1 addSubview:upLabel];
        UIButton *upButton1 = [UIButton buttonWithType:UIButtonTypeSystem];
        upButton1.frame = CGRectMake(_headerView1.frame.size.width-30, _headerView1.frame.size.height-30, 20, 20);
        [upButton1 setImage:[[UIImage imageNamed:@"icon_comic_detail_disvisible.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [upButton1 addTarget:self action:@selector(downButtionClick:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView1 addSubview:upButton1];
    
        //    NSLog(@"%@",upView);
        //[_headerView2 addSubview:_upView];
    
        UIView *rooterView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), _headerView2.frame.size.width, _headerView2.frame.size.height-CGRectGetMaxY(imageView.frame))];
        _rooterView = rooterView;
        //rooterView.backgroundColor = [UIColor redColor];
        [_headerView2 addSubview:_rooterView];
    
        UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, [UIScreen mainScreen].bounds.size.width-40, rooterView.frame.size.height/3.0)];
        label3.text = model.myDescription;
        label3.numberOfLines = 0;
        label3.font = [UIFont systemFontOfSize:13];
        CGRect frame = label3.frame;
        CGSize size = [label3.text boundingRectWithSize:CGSizeMake(label3.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label3.font} context:nil].size;
        frame.size = size;
        label3.frame = frame;
        //label3.backgroundColor = [UIColor cyanColor];
        [rooterView addSubview:label3];
    
        CGFloat height3 = ((rooterView.frame.size.height-label3.frame.size.height)-6*5-10)/5.0;
    
        UILabel *rLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(label3.frame.origin.x, CGRectGetMaxY(label3.frame)+5, label3.frame.size.width, height3)];
        rLabel1.text = [NSString stringWithFormat:@"分类 : %@",model.theme_ids];
        rLabel1.font = [UIFont systemFontOfSize:13];
        [rooterView addSubview:rLabel1];
    
        UILabel *rLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(label3.frame.origin.x, CGRectGetMaxY(rLabel1.frame)+5, label3.frame.size.width, height3)];
        rLabel2.text = [NSString stringWithFormat:@"类型 : %@",model.cate_id];
        rLabel2.font = [UIFont systemFontOfSize:13];
        [rooterView addSubview:rLabel2];
    
        UILabel *rLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(label3.frame.origin.x, CGRectGetMaxY(rLabel2.frame)+5, label3.frame.size.width/2.0, height3)];
        rLabel3.text = [NSString stringWithFormat:@"总月票 : %d",model.total_ticket.intValue];
        rLabel3.font = [UIFont systemFontOfSize:13];
        [rooterView addSubview:rLabel3];
    
        UILabel *rLabel4 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(rLabel3.frame), CGRectGetMaxY(rLabel2.frame)+5, label3.frame.size.width/2.0, height3)];
        rLabel4.text = [NSString stringWithFormat:@"总吐槽 : %d",model.total_tucao.intValue];
        rLabel4.font = [UIFont systemFontOfSize:13];
        [rooterView addSubview:rLabel4];
    
        UILabel *rLabel5 = [[UILabel alloc]initWithFrame:CGRectMake(rLabel3.frame.origin.x, CGRectGetMaxY(rLabel3.frame)+5, label3.frame.size.width/2.0, height3)];
        rLabel5.text = [NSString stringWithFormat:@"总点击 : %@",model.click_total];
        rLabel5.font = [UIFont systemFontOfSize:13];
        [rooterView addSubview:rLabel5];
    
        UILabel *rLabel6 = [[UILabel alloc]initWithFrame:CGRectMake(rLabel4.frame.origin.x, CGRectGetMaxY(rLabel3.frame)+5, label3.frame.size.width/2.0, height3)];
        rLabel6.text = [NSString stringWithFormat:@"总评论 : %d",model.comment_total.intValue];
        rLabel6.font = [UIFont systemFontOfSize:13];
        [rooterView addSubview:rLabel6];
    
        UILabel *rLabel7 = [[UILabel alloc]initWithFrame:CGRectMake(rLabel5.frame.origin.x, CGRectGetMaxY(rLabel5.frame)+5, label3.frame.size.width/2.0, height3)];
        rLabel7.text = [NSString stringWithFormat:@"总图片 : %d",model.image_all.intValue];
        rLabel7.font = [UIFont systemFontOfSize:13];
        [rooterView addSubview:rLabel7];
    
        UILabel *rLabel8 = [[UILabel alloc]initWithFrame:CGRectMake(rLabel6.frame.origin.x, CGRectGetMaxY(rLabel6.frame)+5, label3.frame.size.width/2.0, height3)];
        rLabel8.text = [NSString stringWithFormat:@"本月月票 : %d",model.month_ticket.intValue];
        rLabel8.font = [UIFont systemFontOfSize:13];
        [rooterView addSubview:rLabel8];
    
        UIButton *upButton = [UIButton buttonWithType:UIButtonTypeSystem];
        upButton.frame = CGRectMake(_headerView2.frame.size.width-30, _headerView2.frame.size.height-30, 20, 20);
        [upButton setImage:[[UIImage imageNamed:@"icon_comic_detail_visible.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [upButton addTarget:self action:@selector(upButtionClick:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView2 addSubview:upButton];
        //    _headerView2 = headerView;
        _headerView3 = [self prepareHeadeView1:model];
        
        
        return _headerView2;

}
- (void)upButtionClick:(UIButton *)button{
    ZXLIstModel *model = self.datas.firstObject;
    _tableView.tableHeaderView = [self prepareHeaderView:model];
}
- (void)downButtionClick:(UIButton *)button{
    ZXLIstModel *model = self.datas.firstObject;
    //_tableView.tableHeaderView = _headerView2;
    _tableView.tableHeaderView = [self prepareHeadeView1:model];
}
- (void)buttonLeftClike:(UIButton *)button{
    ZXLIstModel *model = self.datas.firstObject;
    if ([_manager1 findModel:model]) {
        [_manager1 delete:model];
        button.backgroundColor = [UIColor redColor];
        [button setTitle:@"添加收藏" forState:UIControlStateNormal];
    }else{
        [_manager1 insert:model];
        [button setTitle:@"已收藏" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor orangeColor];
        
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refresh" object:self];
//    NSLog(@"left");
}
- (void)buttonRightClike:(UIButton *)button{
    ZXChapterListModel *model = self.datas[1];
    ZXReadViewController *read = [[ZXReadViewController alloc]init];
    ZXChapterListModel *lastModel = self.datas[_datas.count-2];
    ZXLIstModel *listModel = self.datas.firstObject;
    read.currentChapter = 1;
    read.sumDatas = self.datas;
    read.model = model;
    read.listModel = listModel;
    read.maxChapter_id = lastModel.chapter_id.intValue;
    [self presentViewController:read animated:YES completion:nil];
    
}
#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count-2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZXLIstCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    ZXChapterListModel *model = self.datas[indexPath.row + 1];
    cell.model = model;
//    if (indexPath.row%2!=0) {
//        cell.backgroundColor = [UIColor lightGrayColor];
//    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 1, view.frame.size.width, 1)];
    view1.backgroundColor = [UIColor darkGrayColor];
    [view addSubview:view1];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 1, 100, view.frame.size.height-1)];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.text = @"目录";
    [view addSubview:label];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(view.frame.size.width-50, 10, 30, 30);
    
    [button setImage:[[UIImage imageNamed:@"icon_comic_rank.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rankClike:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 60.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    //NSLog(@"1");
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(10, view.frame.size.height/2.0, view.frame.size.width/3-10, 1)];
    view1.backgroundColor = [UIColor darkGrayColor];
    [view addSubview:view1];
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(view1.frame), 0, view1.frame.size.width, view.frame.size.height)];
    UIImageView *imageView5 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
    //view2.backgroundColor = [UIColor cyanColor];
    imageView5.image = [[UIImage imageNamed:@"icon_comic_list_uncomplete"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [view2 addSubview:imageView5];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView5.frame), 10, view2.frame.size.width-imageView5.frame.size.width-10, view.frame.size.height-20)];
    //label.backgroundColor = [UIColor redColor];
    label.text = @"未完待续";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:20];
    [view2 addSubview:label];
    [view addSubview:view2];
    
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(view2.frame), view.frame.size.height/2.0, view.frame.size.width/3.0-10, 1)];
    view3.backgroundColor = [UIColor darkGrayColor];
    [view addSubview:view3];
    
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZXChapterListModel *model = self.datas[indexPath.row+1];
    
    ZXChapterListModel *lastModel = self.datas[_datas.count-2];
    ZXReadViewController *read = [[ZXReadViewController alloc]init];
    ZXLIstModel *bgModel = self.datas.firstObject;
    read.currentChapter = (int)indexPath.row+1;
    read.sumDatas = self.datas;
    read.model = model;
    read.listModel = bgModel;
    read.maxChapter_id = lastModel.chapter_id.intValue;
    [self presentViewController:read animated:YES completion:nil];
}
- (void)rankClike:(UIButton *)button{
    for (int i=0; i<self.datas.count/2; i++) {
        [self.datas exchangeObjectAtIndex:i withObjectAtIndex:self.datas.count-i-1];
    }
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
