//
//  ZXRecommendController.m
//  CartoonStar
//
//  Created by qianfeng on 15/8/20.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ZXRecommendController.h"
#import "ZXUpdateModel.h"
#import "ZXRecommendCell.h"
#import "ZXNavgationBarView.h"
#import "ZXAppLIstViewController.h"


#define kRecommendUrl(page,argName,argValue)  [NSString stringWithFormat:@"http://app.u17.com/v3/app/android/phone/list/index?size=40&page=%d&argName=%@&argValue=%@&con=0&t=1439529212&v=2150000&android_id=c37003cf2965586a&key=null&come_from=u17",page,argName,argValue]
@interface ZXRecommendController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSMutableArray *datas;

@property (nonatomic,strong)UITableView *tableView;

@end

@implementation ZXRecommendController{
    int page;
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
    self.automaticallyAdjustsScrollViewInsets = NO;
    page = 1;
    //[self prepareData];
    [self prepareTableView];
    [self prepareTabbar];
    [self setRefresh];
    
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
    [self prepareData];
    [self.tableView headerEndRefreshing];
}
- (void)rooterRefresh{
    page ++ ;
    //NSLog(@"%d",t);
    [self prepareData];
    [self.tableView footerEndRefreshing];
}

- (void)prepareTabbar{
    ZXNavgationBarView *barView = [[ZXNavgationBarView alloc]init];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[[UIImage imageNamed:@"ic_back.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    button.frame = CGRectMake(10, 10, 20, 44-20);
    [button addTarget:self action:@selector(buttonclike:) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:button];
    [self.view addSubview:barView];
    
    NSArray *array = @[@"S级作品推荐",@"A级作品推荐",@"热门作品推荐",@"订阅作品推荐"];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2.0-70, 0, 140, barView.frame.size.height)];
    titleLabel.text = (_is_class ==YES ? _title1:array[_number-1]);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [barView addSubview:titleLabel];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = CGRectMake(self.view.frame.size.width-10-60, 5, 60, 44-10);
    
//    [rightButton setImage:[[UIImage imageNamed:@"download.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] forState:UIControlStateNormal];
    [rightButton setTitle:@"随机看" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:rightButton];
    
}
- (void)buttonclike:(UIButton *)button{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)rightButtonClick:(UIButton *)button{
    int num = arc4random()%self.datas.count;
    ZXUpdateModel *model = self.datas[num];
    ZXAppLIstViewController *list = [[ZXAppLIstViewController alloc]init];
    list.comicid = model.comic_id.intValue;
    [self presentViewController:list animated:YES completion:nil];
}
- (void)prepareData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeBlack];
    [manager GET:kRecommendUrl(page, _argName, _argValue) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dataDic = dic[@"data"];
        NSArray *array = dataDic[@"returnData"];
        for (NSDictionary *dict in array) {
            ZXUpdateModel *model = [[ZXUpdateModel alloc]initWithDictionary:dict error:nil];
            [self.datas addObject:model];
        }
        [SVProgressHUD showSuccessWithStatus:@"OK" maskType:SVProgressHUDMaskTypeBlack];
        
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败" maskType:SVProgressHUDMaskTypeBlack];
    }];

}
- (void)prepareTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [_tableView registerNib:[UINib nibWithNibName:@"ZXRecommendCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZXRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    ZXUpdateModel *model = self.datas[indexPath.row];
    
    if (model.is_dujia.intValue) {
        
        cell.duGiaImageView.image = [[UIImage imageNamed:@"icon_list_dujia.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }else{
        cell.duGiaImageView.image = nil;
    }
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZXAppLIstViewController *list = [[ZXAppLIstViewController alloc]init];
    ZXUpdateModel *model = self.datas[indexPath.row];
    list.comicid = model.comic_id.intValue;
    [self presentViewController:list animated:YES completion:nil];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UIScreen mainScreen].bounds.size.width==320? 120 : [UIScreen mainScreen].bounds.size.height/5.0;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
