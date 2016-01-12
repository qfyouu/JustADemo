//
//  ZXHistoryViewController.m
//  CartoonStar
//
//  Created by qianfeng on 15/8/14.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ZXHistoryViewController.h"
#import "ZXHistoryManager.h"
#import "ZXLIstModel.h"
#import "ZXHistoryCell.h"
#import "UIImageView+AFNetworking.h"
#import "ZXAppLIstViewController.h"
@interface ZXHistoryViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)ZXHistoryManager *manager;
@property (nonatomic,strong)NSMutableArray *array;
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation ZXHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _manager = [ZXHistoryManager sharedManager];
    _array = [NSMutableArray arrayWithArray:[_manager fetchAll]];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerNib:[UINib nibWithNibName:@"ZXHistoryCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    //[[NSNotificationCenter defaultCenter]postNotificationName:@"history" object:self userInfo:dic];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteAction:) name:@"history" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshTableView) name:@"refreshHistory" object:nil];
    
}
- (void)refreshTableView{
    [self.array removeAllObjects];
    _array = [NSMutableArray arrayWithArray:[_manager fetchAll]];
    [self.tableView reloadData];
}
- (void)deleteAction:(NSNotification *)noti{
    NSDictionary *dic = noti.userInfo;
    int num = [dic[@"num"] intValue];
    ZXLIstModel *model = self.array[num];
    if ([_manager delete:model]) {
        self.array = [NSMutableArray arrayWithArray:[_manager fetchAll]];
        [self.tableView reloadData];
    }
}
#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZXHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    ZXLIstModel *model = self.array[indexPath.row];
    [cell.itemImageView setImageWithURL:[NSURL URLWithString:model.cover]placeholderImage:[UIImage imageNamed:@"umeng_socialize_share_pic.png"]];
    cell.nameLabel.text = model.name;
    cell.deleteButton.tag = 1000+indexPath.row;
    cell.historyLabel.text = [NSString stringWithFormat:@"上次观看到 %@",model.author_name];
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZXLIstModel *model = self.array[indexPath.row];
    ZXAppLIstViewController *list = [[ZXAppLIstViewController alloc]init];
    list.comicid = model.comic_id.intValue;
    [self presentViewController:list animated:YES completion:nil];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
