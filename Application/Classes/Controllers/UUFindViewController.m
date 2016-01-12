//
//  ZXFindViewController.m
//  CartoonStar
//
//  Created by qianfeng on 15/8/14.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ZXFindViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "ZXFindModel.h"
#import "ZXFindCell.h"
#import "ZXImageView.h"
#import "MJRefresh.h"
#import "UIImageView+AFNetworking.h"
#import "ZXFindListViewController.h"
#import "ZXDataCache.h"
#import "ZXDownLoadManager.h"

#define kFindUrl(num,t)   [NSString stringWithFormat:@"http://wan.17qugame.com/game/mobile/appIndex/1?num=%d&t=%d&v=2110000&android_id=c37003cf2965586a&key=null&come_from=sanxingJ&model=GT-I9300",num,t]
@interface ZXFindViewController ()<UITableViewDataSource,UITableViewDelegate,ZXDownLoadManagerDelegate>
@property (nonatomic,strong)NSMutableArray *datas;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIPageControl *pageControl;
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)NSMutableArray *managers;
@end


@implementation ZXFindViewController{
    int t;
    int num;
    int numb;
    NSTimer *timer;
}
- (NSMutableArray *)managers{
    if (!_managers) {
        _managers = [NSMutableArray array];
    }
    return _managers;
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
    //http://wan.17qugame.com/game/mobile/appIndex/1?num=10&t=1439475029&v=2110000&android_id=c37003cf2965586a&key=null&come_from=sanxingJ&model=GT-I9300 HTTP/1.1
    NSDate *date = [NSDate date];
    t = date.timeIntervalSince1970;
    num = 10;
    //
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downloadGame:) name:@"downloadgame" object:nil];
    [self prepareTableView];
    //[self prepareData];
    [self setRefresh];
}
- (void)downloadGame:(NSNotification *)noti{
    NSDictionary *dic = noti.userInfo;
    UIButton *button = dic[@"button"];
    numb = (int)button.tag-1000;
    ZXDownLoadManager *manager = self.managers[numb];
    manager.delegate = self;
    //    NSLog(@"%ld",button.tag);
    button.tintColor = [UIColor clearColor];
    //self.tableView cellForRowAtIndexPath:
    button.selected = !button.selected;
    if (button.selected) {
        [manager start];
        [button setTitle:@"暂停" forState:UIControlStateNormal];
    }else{
        [manager stop];
        [button setTitle:@"下载" forState:UIControlStateNormal];
    }

}

#pragma mark - ZXDownLoadManagerDelegate
- (void)fileDownloader:(ZXDownLoadManager *)manager failWithError:(NSError *)errpr{
    //NSLog(@"%@",errpr.localizedFailureReason);
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"下载失败" message:errpr.localizedFailureReason delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}
- (void)fileDownloader:(ZXDownLoadManager *)manager didDownloadSize:(long long)downloadSize totalSize:(long long)totalSize{
    NSLog(@"%lld",downloadSize);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:numb inSection:0];
    ZXFindCell *cell = (ZXFindCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    cell.progressView.progress = (double)downloadSize/totalSize;
    //_progressView.progress = (double)downloadSize/totalSize;
}
- (void)fileDownloaderDidFinish:(ZXDownLoadManager *)manager{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"下载完成" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:numb inSection:0];
    ZXFindCell *cell = (ZXFindCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell.downloadButton setTitle:@"完成" forState:UIControlStateNormal];

}

- (void)setRefresh{
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.tableView headerBeginRefreshing];
    
    [self.tableView addFooterWithTarget:self action:@selector(rooterRefresh)];
    
    self.tableView.headerPullToRefreshText = @"下拉刷新";
    self.tableView.headerReleaseToRefreshText = @"松开后刷新";
    self.tableView.headerRefreshingText = @"正在拼命刷新中";
    
    self.tableView.footerPullToRefreshText = @"上拉加载";
    self.tableView.footerReleaseToRefreshText = @"松开后加载";
    self.tableView.footerRefreshingText = @"正在拼命加载中";
}
- (void)headerRefresh{
    
    [self.datas removeAllObjects];
    //[self prepareData];
    [self downLoadData];
    [self.tableView headerEndRefreshing];
}
- (void)rooterRefresh{
    num++;
    //NSLog(@"%d",t);
    //[self prepareData];
    [self downLoadData];
    [self.tableView footerEndRefreshing];
}
- (void)downLoadData{
    NSString *string = kFindUrl(num, t);
    ZXDataCache *dataCache = [ZXDataCache sharedCache];
    
    NSData *data = [dataCache getDataWithStringName:string];
    
    if (data) {
        [self jsonData:data];
    }else{
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeBlack];
        [manager GET:kFindUrl(num, t) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    NSDictionary *dataDic = dic[@"data"];
    NSDictionary *dict = dataDic[@"returnData"];
    ZXFindModel *model = [[ZXFindModel alloc]initWithDictionary:dict error:nil];
    [self.datas addObject:model];
    [self.tableView reloadData];
    self.tableView.tableHeaderView = [self prepareHeaderView:model];

}
- (void)prepareData{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeBlack];
    [manager GET:kFindUrl(num, t) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dataDic = dic[@"data"];
        NSDictionary *dict = dataDic[@"returnData"];
        ZXFindModel *model = [[ZXFindModel alloc]initWithDictionary:dict error:nil];
        [self.datas addObject:model];
        [self.tableView reloadData];
        self.tableView.tableHeaderView = [self prepareHeaderView:model];
        [SVProgressHUD showSuccessWithStatus:@"加载成功" maskType:SVProgressHUDMaskTypeBlack];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败" maskType:SVProgressHUDMaskTypeBlack];
        [self prepareData];
    }];

}
- (void)prepareTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-49-20) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerNib:[UINib nibWithNibName:@"ZXFindCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
}
#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ZXFindModel *model = self.datas.firstObject;
    
    return model.itemList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZXFindCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    ZXFindModel *model = self.datas.firstObject;
    ZXFindListModel *listModel = model.itemList[indexPath.row];
    cell.model = listModel;
    cell.downloadButton.tag = 1000+indexPath.row;
    ZXDownLoadManager *manager = [[ZXDownLoadManager alloc]init];
    manager.url = [NSURL URLWithString:listModel.dowmLoadUrl];
    NSString *doc =[NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [doc stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.apk",listModel.title]];
    manager.pathString = filePath;
    //    _manager.delegate = self;
    [self.managers addObject:manager];

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZXFindModel *model = self.datas.firstObject;
    ZXFindListModel *listModel = model.itemList[indexPath.row];
    ZXFindListViewController *listContrller = [[ZXFindListViewController alloc]init];
    listContrller.appId = listModel.appId.intValue;
    [self presentViewController:listContrller animated:YES completion:nil];
}
- (UIView *)prepareHeaderView:(ZXFindModel *)model{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-100)];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, view.frame.size.height/5*2)];
    UIView *bgView = [[UIView alloc]initWithFrame:scrollView.frame];
    [bgView addSubview:scrollView];
    ZXFindModel *findModel = self.datas.firstObject;
    NSArray *array = model.banner;
    ZXFindBannerModel *bmodel = array.lastObject;
    ZXImageView *imageView = [[ZXImageView alloc]initWithFrame:scrollView.frame];
    [imageView setImageWithURL:[NSURL URLWithString:bmodel.coverUrl] placeholderImage:[[UIImage imageNamed:@"bg_default_potriat_change.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]];
    [scrollView addSubview:imageView];
    imageView.bannerModel = bmodel;
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [imageView addGestureRecognizer:tap];
    
    for (int i=0; i<array.count; i++) {
        ZXFindBannerModel *model = array[i];
        ZXImageView *imageView = [[ZXImageView alloc]initWithFrame:CGRectMake(scrollView.frame.size.width*(i+1), 0, scrollView.frame.size.width, scrollView.frame.size.height)];
        [imageView setImageWithURL:[NSURL URLWithString:model.coverUrl] placeholderImage:[[UIImage imageNamed:@"bg_default_potriat_change.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]];
        imageView.bannerModel = model;
        imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [imageView addGestureRecognizer:tap];
        [scrollView addSubview:imageView];
    }
    _scrollView = scrollView;
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.view.frame.size.width-100, scrollView.frame.size.height-30, 100, 30)];
    _pageControl.numberOfPages = array.count;
    //_pageControl.backgroundColor
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [bgView addSubview:_pageControl];
    [bgView bringSubviewToFront:_pageControl];
    //scrollView.backgroundColor = [UIColor redColor];
    scrollView.contentOffset = CGPointMake(scrollView.frame.size.width, 0);
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width*array.count, 0);
    scrollView.pagingEnabled = YES;
    [view addSubview:bgView];
    
    NSArray *array1 = findModel.recommands;
    CGFloat pad = 10.0;
    CGFloat height = (view.frame.size.height - scrollView.frame.size.height-4*pad)/3.0;
    CGFloat width = (view.frame.size.width-3*pad)/2.0;
    for (int i=0; i<array1.count; i++) {
        ZXReModel *model = array1[i];
        ZXImageView *imageView = [[ZXImageView alloc]initWithFrame:CGRectMake(pad+(width+pad)*(i%2), CGRectGetMaxY(scrollView.frame)+pad+(height+pad)*(i/2), width, height-20)];
        [imageView setImageWithURL:[NSURL URLWithString:model.coverUrl] placeholderImage:[UIImage imageNamed:@"bg_default_recommend_bottom.png"]];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        imageView.remodel = model;
        [imageView addGestureRecognizer:tap];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.origin.x, CGRectGetMaxY(imageView.frame), imageView.frame.size.width, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = model.title;
        [view addSubview:imageView];
        [view addSubview:label];
    }
    if (!timer) {
        timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
    }else{
        [timer invalidate];
        timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
     }
    return view;
}
- (void)autoScroll{
    ZXFindModel *model = self.datas.firstObject;
    NSArray *array = model.banner;
    CGFloat offset = self.scrollView.contentOffset.x;
    if (offset>=array.count*self.scrollView.frame.size.width) {
        [self.scrollView setContentOffset:CGPointZero animated:NO];
        [self.scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:YES];
        self.pageControl.currentPage = 0;
    }else{
        [self.scrollView setContentOffset:CGPointMake(offset+_scrollView.frame.size.width, 0) animated:YES];
        self.pageControl.currentPage = self.scrollView.contentOffset.x/self.scrollView.frame.size.width;
    }

}
- (void)tapAction:(UIGestureRecognizer *)tap{
    ZXImageView *imageView = (ZXImageView *)tap.view;
    ZXFindListViewController *list = [[ZXFindListViewController alloc]init];
    if (imageView.bannerModel) {
        list.appId = imageView.bannerModel.appId.intValue;
    }else if (imageView.remodel){
        list.appId = imageView.remodel.appId.intValue;
    }
    [self presentViewController:list animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
