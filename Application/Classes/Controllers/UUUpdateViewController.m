//
//  ZXUpdateViewController.m
//  CartoonStar
//
//  Created by qianfeng on 15/8/14.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ZXUpdateViewController.h"
//#import "ZXUpdateListModel.h"
#import "ZXUpdateModel.h"
#import "ZXUpdateCell.h"
#import "ZXAppLIstViewController.h"
#define kUpdateUrl(date) [NSString stringWithFormat:@"http://app.u17.com/v3/app/android/phone/list/index?size=40&page=1&argName=sort&argValue=0&con=3&t=%d&v=2150000&android_id=c37003cf2965586a&key=null&come_from=u17",date]
@interface ZXUpdateViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSMutableArray *datas;
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation ZXUpdateViewController{
    int t;
    int up;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDate *date = [NSDate date];
    t = date.timeIntervalSince1970;
 
    //[self prepareData];
    [self prepareTableView];
    [self setRefresh];
}
- (NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
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
    up=0;
    [self prepareData];
    [self.tableView headerEndRefreshing];
}
- (void)rooterRefresh{
    up++;
    //NSLog(@"%d",t);
    [self prepareData];
    [self.tableView footerEndRefreshing];
}
- (void)prepareData{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeBlack];
    [manager GET:kUpdateUrl(t) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dictionary = dic[@"data"];
        NSArray *array = dictionary[@"returnData"];
        for (NSDictionary *dict in array) {
            ZXUpdateModel *model = [[ZXUpdateModel alloc]initWithDictionary:dict error:nil];
            [self.datas addObject:model];
        }
        [SVProgressHUD showSuccessWithStatus:@"OK" maskType:SVProgressHUDMaskTypeBlack];
        [self.tableView reloadData];
        if (up) {
            ZXUpdateModel *model = self.datas.lastObject;
            t = model.last_update_time.intValue;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败" maskType:SVProgressHUDMaskTypeBlack];
        [self prepareData];
    }];
}
- (void)prepareTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    [_tableView registerClass:[ZXUpdateCell class] forCellReuseIdentifier:@"cell"];
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZXUpdateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    ZXUpdateModel *model = self.datas[indexPath.row];
    if (model.is_dujia.intValue==1) {
         cell.image.image = [[UIImage imageNamed:@"icon_list_dujia.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }else{
        cell.image.image = nil;
    }
    cell.model = model;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //120 4  135 6
    //金瓶梅
    return  [UIScreen mainScreen].bounds.size.width==320? 120 : [UIScreen mainScreen].bounds.size.height/5.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZXAppLIstViewController *list = [[ZXAppLIstViewController alloc]init];
    ZXUpdateModel *model = self.datas[indexPath.row];
    list.comicid = model.comic_id.intValue;
    [self presentViewController:list animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
