//
//  ZXSearchResultController.m
//  CartoonStar
//
//  Created by qianfeng on 15/8/22.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ZXSearchResultController.h"
#import "ZXNavgationBarView.h"
#import "ZXUpdateModel.h"
#import "ZXRecommendCell.h"
#import "ZXSearchRecommendModel.h"
#import "ZXImageView.h"
#import "UIImageView+AFNetworking.h"
#import "ZXAppLIstViewController.h"

#define kSearchResultUrl(tags)  [NSString stringWithFormat:@"http://app.u17.com/v3/app/android/phone/search/rslist?q=%@&page=1&t=1440164546&v=2150000&android_id=c37003cf2965586a&key=null&come_from=u17",tags]

#define kSearchRecommendUrl(t)  [NSString stringWithFormat:@"http://app.u17.com/v3/app/android/phone/search/recommend?t=%d&v=2150000&android_id=c37003cf2965586a&key=null&come_from=u17",t]

@interface ZXSearchResultController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSMutableArray *datas;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *recommendDatas;
@end

@implementation ZXSearchResultController{
    int t;
}

- (NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
- (NSMutableArray *)recommendDatas{
    if (!_recommendDatas) {
        _recommendDatas = [NSMutableArray array];
    }
    return _recommendDatas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDate *date = [NSDate date];
    t = date.timeIntervalSince1970;
    // Do any additional setup after loading the view.
    [self prepareTabbar];
    [self prepareTableView];
    [self setRefresh];

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
    [self prepareData];
    [self.tableView headerEndRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    titleLabel.text = @"搜索结果";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [barView addSubview:titleLabel];
    
    
}
- (void)prepareTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"ZXRecommendCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
}
- (void)prepareData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeBlack];
    NSString *string = [kSearchResultUrl(_searchText) stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dataDic = dic[@"data"];
        NSDictionary *returnData = dataDic[@"returnData"];
        NSArray *array = returnData[@"comicList"];
        for (NSDictionary *dict in array) {
            ZXUpdateModel *model = [[ZXUpdateModel alloc]initWithDictionary:dict error:nil];
            [self.datas addObject:model];
        }
        [SVProgressHUD showSuccessWithStatus:@"加载成功" maskType:SVProgressHUDMaskTypeBlack];
        [self prepareFooterData];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"搜索失败,请重试" maskType:SVProgressHUDMaskTypeBlack];
    }];
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
    cell.model = model;
    if (model.is_dujia.intValue) {
        cell.duGiaImageView.image = [[UIImage imageNamed:@"icon_list_dujia.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }else{
        cell.duGiaImageView.image = nil;
    }
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
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"找到与\"%@\"有关的漫画%d本",_searchText,self.datas.count];
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return @"编辑部推荐";
}
- (void)buttonclike:(UIButton *)button{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)prepareFooterData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:kSearchRecommendUrl(t) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dataDic = dic[@"data"];
        NSArray *array = dataDic[@"returnData"];
        for (NSDictionary *dict in array) {
            ZXSearchRecommendModel *model = [[ZXSearchRecommendModel alloc]initWithDictionary:dict error:nil];
            [self.recommendDatas addObject:model];
        }
        self.tableView.tableFooterView = [self prepareFooterView:self.recommendDatas];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
- (UIView *)prepareFooterView:(NSArray *)array{
    CGFloat padding = 10.0;
    CGFloat width = (self.view.frame.size.width-5*padding)/4.0;
    CGFloat height = 1.5*width;
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, height+2*padding)];
    scrollView.showsHorizontalScrollIndicator = NO;
    for (int i=0; i<array.count; i++) {
        ZXSearchRecommendModel *model = array[i];
        ZXImageView *imageView = [[ZXImageView alloc]initWithFrame:CGRectMake(padding+(width+padding)*i, padding, width, height)];
        imageView.userInteractionEnabled = YES;
        imageView.recommendModel = model;
        //[UIImage imageNamed:@"bg_default_cover.png"]
        [imageView setImageWithURL:[NSURL URLWithString:model.coverUrl] placeholderImage:[UIImage imageNamed:@"bg_default_cover.png"]];
        [scrollView addSubview:imageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [imageView addGestureRecognizer:tap];
    }
    scrollView.contentSize = CGSizeMake(padding+(width+padding)*array.count, 0);
    return scrollView;
}
- (void)tapAction:(UITapGestureRecognizer *)tap{
    ZXImageView *imageView = (ZXImageView *)tap.view;
    ZXAppLIstViewController *list = [[ZXAppLIstViewController alloc]init];
    list.comicid = imageView.recommendModel.comicId.intValue;
    [self presentViewController:list animated:YES completion:nil];
}
@end
