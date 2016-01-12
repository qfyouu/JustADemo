//
//  ZXReadViewController.m
//  CartoonStar
//
//  Created by qianfeng on 15/8/20.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ZXReadViewController.h"
#import "ZXReadModel.h"
#import "ZXReadCell.h"
#import "ZXChapterListModel.h"
#import "ZXHistoryManager.h"


#define kReadUrl(chapter_id,date)  [NSString stringWithFormat:@"http://app.u17.com/v3/app/android/phone/comic/chapter?chapter_id=%d&t=%d&v=2110000&android_id=c37003cf2965586a&key=null&come_from=sanxingJ",chapter_id,date]
@interface ZXReadViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSMutableArray *datas;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIView *view3;
@property (nonatomic,strong)ZXHistoryManager *manager;
@end

@implementation ZXReadViewController{
    int chapter;
    int t;
    int current;
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
//    UIView *view = [[UIView alloc]initWithFrame:self.view.bounds];
//    _view3 = view;
    _manager = [ZXHistoryManager sharedManager];
    [self.view addSubview:_view3];
    NSDate *date = [NSDate date];
    t = date.timeIntervalSince1970;
    chapter = _model.chapter_id.intValue;
    current = _currentChapter;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    leftButton.frame = CGRectMake(10, 20, 20, 20);
    
    [leftButton setImage:[[UIImage imageNamed:@"bt_comic_read_over_back.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonClike:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    [self.view bringSubviewToFront:leftButton];
    //[self prepareData];
    [self prepareTableView];
    [self setRefresh];
}
- (void)leftButtonClike:(UIButton *)button{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)setRefresh{
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.tableView headerBeginRefreshing];

    
    [self.tableView addFooterWithTarget:self action:@selector(refreshMore)];
    
    self.tableView.footerPullToRefreshText = @"上拉加载";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载";
    self.tableView.footerRefreshingText = @"正在拼命加载中";
}
- (void)headerRefresh{
    //up=0;
    [self prepareData];
    [self.tableView headerEndRefreshing];
}

- (void)refreshMore{
    if (current < _sumDatas.count-2) {
        ZXChapterListModel *model = _sumDatas[++current];
        chapter = model.chapter_id.intValue;
        //NSLog(@"%d",chapter);
        [self prepareData];
    }
    
}
- (void)viewWillDisappear:(BOOL)animated{
    ZXChapterListModel *model = _sumDatas[current];
    NSString *string = model.name;
    //ZXLIstModel *model1 = self.datas.firstObject;
    if ([_manager insert:_listModel andChapterName:string]) {
        NSLog(@"增加成功");
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshHistory" object:self];
}


- (void)downLoadData{
    NSString *path = kReadUrl(chapter, t);
    ZXDataCache *dataCache = [ZXDataCache sharedCache];
    NSData *data = [dataCache getDataWithStringName:path];
    if (data) {
        [self jsonWithData:data];
    }else{
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeBlack];
        [manager GET:kReadUrl(chapter, t) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [dataCache saveDataWithData:responseObject andStringName:path];
            [self jsonWithData:responseObject];
            [SVProgressHUD showSuccessWithStatus:@"OK" maskType:SVProgressHUDMaskTypeBlack];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"加载失败" maskType:SVProgressHUDMaskTypeBlack];
            [self.tableView footerEndRefreshing];
        }];

    }
}
- (void)prepareData{

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeBlack];
    [manager GET:kReadUrl(chapter, t) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self jsonWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dataDic = dic[@"data"];
        NSArray *array = dataDic[@"returnData"];
        for (NSDictionary *dic in array) {
            ZXReadModel *model = [[ZXReadModel alloc]initWithDictionary:dic error:nil];
            [self.datas addObject:model];
        }
        [SVProgressHUD showSuccessWithStatus:@"OK" maskType:SVProgressHUDMaskTypeBlack];
        [self.tableView footerEndRefreshing];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败" maskType:SVProgressHUDMaskTypeBlack];
        [self.tableView footerEndRefreshing];
    }];

}
- (void)jsonWithData:(NSData *)data{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSDictionary *dataDic = dic[@"data"];
    NSArray *array = dataDic[@"returnData"];
    for (NSDictionary *dic in array) {
        ZXReadModel *model = [[ZXReadModel alloc]initWithDictionary:dic error:nil];
        [self.datas addObject:model];
    }
    [self.tableView footerEndRefreshing];
    [self.tableView reloadData];

}
- (void)prepareTableView{
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchAction:)];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView addGestureRecognizer:pinch];
    [_tableView registerClass:[ZXReadCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
}
- (void)pinchAction:(UIPinchGestureRecognizer *)pinch{
    _tableView.transform = CGAffineTransformScale(_tableView.transform, pinch.scale, pinch.scale);
    pinch.scale = 1;
}
#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZXReadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    ZXReadModel *model = self.datas[indexPath.row];
    
    cell.model = model;

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZXReadModel *model = self.datas[indexPath.row];
    CGFloat height = model.height.floatValue;

    return height/2.0;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
