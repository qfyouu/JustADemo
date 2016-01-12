//
//  ZXFindListViewController.m
//  CartoonStar
//
//  Created by qianfeng on 15/8/24.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ZXFindListViewController.h"
#import "ZXNavgationBarView.h"
#import "ZXGameModel.h"
#import "UIImageView+AFNetworking.h"
#import "ZXDownLoadManager.h"



@interface ZXFindListViewController ()<ZXDownLoadManagerDelegate>

@property (nonatomic,strong)ZXGameModel *model;
@property (nonatomic,strong)ZXDownLoadManager *manager;
@property (nonatomic,strong)UIProgressView *progressView;
@property (nonatomic,strong)UIButton *button;

@end

@implementation ZXFindListViewController{
    int t;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //http://wan.17qugame.com/game/mobile/appDetails/29?t=1439475116&v=2110000&android_id=c37003cf2965586a&key=null&come_from=sanxingJ&model=GT-I9300%20HTTP/1.1
    NSDate *date = [NSDate date];
    t = date.timeIntervalSince1970;
    [self prepareTabbar];
//    [self prepareData];
    [self downLoadData];
    
    
    
    
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
    titleLabel.text = @"游戏详情";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [barView addSubview:titleLabel];
    
}
- (void)buttonclike:(UIButton *)button{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)downLoadData{
    NSString *string = [NSString stringWithFormat:@"http://wan.17qugame.com/game/mobile/appDetails/%d?t=%d&v=2110000&android_id=c37003cf2965586a&key=null&come_from=sanxingJ",_appId,t];
    ZXDataCache *dataCache = [ZXDataCache sharedCache];
    NSData *data = [dataCache getDataWithStringName:string];
    if (data) {
        [self jsonData:data];
    }else{
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeBlack];
        NSString *string = [NSString stringWithFormat:@"http://wan.17qugame.com/game/mobile/appDetails/%d?t=%d&v=2110000&android_id=c37003cf2965586a&key=null&come_from=sanxingJ",_appId,t];
        [manager GET:string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [dataCache saveDataWithData:responseObject andStringName:string];
            [self jsonData:responseObject];
            [SVProgressHUD showSuccessWithStatus:@"加载成功" maskType:SVProgressHUDMaskTypeBlack];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"加载失败" maskType:SVProgressHUDMaskTypeBlack];
            [self downLoadData];
        }];

    }
}
- (void)jsonData:(NSData *)data{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSDictionary *data1 = dic[@"data"];
    NSDictionary *returnData = data1[@"returnData"];
    NSDictionary *appDic = returnData[@"app"];
    ZXGameModel *model = [[ZXGameModel alloc]initWithDictionary:appDic error:nil];
    _model = model;
    [self prepareUI];

}
- (void)prepareData{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeBlack];
    NSString *string = [NSString stringWithFormat:@"http://wan.17qugame.com/game/mobile/appDetails/%d?t=%d&v=2110000&android_id=c37003cf2965586a&key=null&come_from=sanxingJ",_appId,t];
    [manager GET:string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *data = dic[@"data"];
        NSDictionary *returnData = data[@"returnData"];
        NSDictionary *appDic = returnData[@"app"];
        ZXGameModel *model = [[ZXGameModel alloc]initWithDictionary:appDic error:nil];
        _model = model;
        [SVProgressHUD showSuccessWithStatus:@"加载成功" maskType:SVProgressHUDMaskTypeBlack];
        [self prepareUI];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败" maskType:SVProgressHUDMaskTypeBlack];
        [self prepareData];
    }];


}
- (void)prepareUI{
    _manager = [[ZXDownLoadManager alloc]init];
    _manager.url = [NSURL URLWithString:_model.dowmLoadUrl];
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [doc stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.apk",_model.title]];
    _manager.pathString = filePath;
    _manager.delegate = self;
    
    
    
    CGFloat height = self.view.frame.size.height/8.0;
    CGFloat pad = 10.0;
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(pad, pad, height-2*pad, height-2*pad)];
    imageView.clipsToBounds = YES;
    imageView.layer.cornerRadius = 10;
    [imageView setImageWithURL:[NSURL URLWithString:_model.coverUrl]placeholderImage:[UIImage imageNamed:@"umeng_socialize_share_pic.png"]];
    [scrollView addSubview:imageView];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+10, imageView.frame.origin.y, scrollView.frame.size.width-2*height, (height-2*pad)/2.0)];
    nameLabel.font = [UIFont boldSystemFontOfSize:20];
    nameLabel.text = _model.title;
    [scrollView addSubview:nameLabel];
    
    UILabel *sizeLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, CGRectGetMaxY(nameLabel.frame), nameLabel.frame.size.width, nameLabel.frame.size.height)];
    sizeLabel.font = [UIFont systemFontOfSize:12];
    sizeLabel.text = [NSString stringWithFormat:@"%dMB",_model.size.intValue/1024/1024];
    [scrollView addSubview:sizeLabel];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(CGRectGetMaxX(nameLabel.frame)+10, nameLabel.frame.size.height, height-2*pad, nameLabel.frame.size.height);
    button.tintColor = [UIColor clearColor];
    [button setTitle:@"下载" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:20];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor cyanColor];
    [button addTarget:self action:@selector(downloadButtonClike:) forControlEvents:UIControlEventTouchUpInside];
    _button = button;
    [scrollView addSubview:button];
    _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(button.frame.origin.x, CGRectGetMaxY(button.frame)+5, button.frame.size.width, 5)];
    _progressView.progressTintColor = [UIColor redColor];
    [scrollView addSubview:_progressView];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+pad-1, scrollView.frame.size.width, 1)];
    view1.backgroundColor = [UIColor darkGrayColor];
    [scrollView addSubview:view1];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(view1.frame)+10, view1.frame.size.width, height/2.0-20)];
    label1.text = @"游戏截图";
    [scrollView addSubview:label1];
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label1.frame)+10, scrollView.frame.size.width, 1)];
    view2.backgroundColor = [UIColor darkGrayColor];
    [scrollView addSubview:view2];
    
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view2.frame), scrollView.frame.size.width, 4*height)];
    scroll.pagingEnabled = YES;
    CGFloat imageViewWidth = (self.view.frame.size.width-3*pad)/2.0;
    //CGFloat imageViewHeight = height*4;
    for (int i=0; i<_model.smallPictureUrls.count; i++) {
        UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(pad+(imageViewWidth+pad)*i, 10, imageViewWidth, scroll.frame.size.height-20)];
        [imageView1 setImageWithURL:[NSURL URLWithString:_model.smallPictureUrls[i]] placeholderImage:[[UIImage imageNamed:@"bg_default_potriat_change.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [scroll addSubview:imageView1];
    }
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.contentSize = CGSizeMake(pad+(pad+imageViewWidth)*_model.smallPictureUrls.count, 0);
    [scrollView addSubview:scroll];
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(scroll.frame), scrollView.frame.size.width, 1)];
    view3.backgroundColor = [UIColor darkGrayColor];
    [scrollView addSubview:view3];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(view3.frame)+10, scrollView.frame.size.width, height/2.0-20)];
    label2.text = @"游戏简介";
    [scrollView addSubview:label2];
    UIView *view4 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label2.frame)+10, scrollView.frame.size.width, 1)];
    view4.backgroundColor = [UIColor darkGrayColor];
    [scrollView addSubview:view4];
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(view4.frame)+10, scrollView.frame.size.width-20, scrollView.frame.size.height+64-CGRectGetMaxY(view4.frame))];
    label3.font = [UIFont systemFontOfSize:12];
    label3.text = _model.desc;
    label3.numberOfLines = 0;
    CGSize size = [label3.text boundingRectWithSize:CGSizeMake(label3.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label3.font} context:nil].size;
    CGRect frame = label3.frame;
    frame.size = size;
    label3.frame = frame;
    //label3.backgroundColor = [UIColor redColor];
    [scrollView addSubview:label3];
    scrollView.contentSize = CGSizeMake(0, view4.frame.origin.y+label3.frame.size.height+pad+10);
    [self.view addSubview:scrollView];
}
- (void)downloadButtonClike:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        [self.manager start];
        [button setTitle:@"暂停" forState:UIControlStateNormal];
    }else{
        [self.manager stop];
        [button setTitle:@"下载" forState:UIControlStateNormal];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ZXDownLoadManagerDelegate

- (void)fileDownloader:(ZXDownLoadManager *)manager failWithError:(NSError *)errpr{
    //NSLog(@"%@",errpr.localizedFailureReason);
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"下载失败" message:errpr.localizedFailureReason delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}
- (void)fileDownloader:(ZXDownLoadManager *)manager didDownloadSize:(long long)downloadSize totalSize:(long long)totalSize{
    NSLog(@"%lld",downloadSize);
    _progressView.progress = (double)downloadSize/totalSize;
}
- (void)fileDownloaderDidFinish:(ZXDownLoadManager *)manager{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"下载完成" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    [_button setTitle:@"完成" forState:UIControlStateNormal];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
