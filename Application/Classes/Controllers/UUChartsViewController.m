//
//  ZXChartsViewController.m
//  CartoonStar
//
//  Created by qianfeng on 15/8/14.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ZXChartsViewController.h"
#import "ZXRankModel.h"
#import "ZXRankCell.h"
#import "ZXRankListController.h"
#define kRankUrl(date)  [NSString stringWithFormat:@"http://app.u17.com/v3/app/android/phone/rank/list?sortVersion=2&t=%d&v=2150000&android_id=c37003cf2965586a&key=null&come_from=u17",date]
@interface ZXChartsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSMutableArray *datas;
@property (nonatomic,strong)UITableView *tableView;

@end

@implementation ZXChartsViewController{
    int t;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDate *date = [NSDate date];
    t = date.timeIntervalSince1970;
    
    [self prepareData];
    [self prepareTableView];
}
- (NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
- (void)prepareData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeBlack];
    [manager GET:kRankUrl(t) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dataDic = dic[@"data"];
        NSDictionary *returnData = dataDic[@"returnData"];
        NSArray *array = returnData[@"rankinglist"];
        for (NSDictionary *dict in array) {
            ZXRankModel *model = [[ZXRankModel alloc]initWithDictionary:dict error:nil];
            [self.datas addObject:model];
        }
        [SVProgressHUD showSuccessWithStatus:@"OK" maskType:SVProgressHUDMaskTypeBlack];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败" maskType:SVProgressHUDMaskTypeBlack];
        [self prepareData];
    }];
}
- (void)prepareTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-49-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView registerNib:[UINib nibWithNibName:@"ZXRankCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZXRankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    ZXRankModel *model = self.datas[indexPath.row];
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZXRankListController *rank = [[ZXRankListController alloc]init];
    ZXRankModel *model = self.datas[indexPath.row];
    rank.argName = model.argName;
    rank.argValue = model.argValue;
    rank.number = (int)indexPath.row;
    [self presentViewController:rank animated:YES completion:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
