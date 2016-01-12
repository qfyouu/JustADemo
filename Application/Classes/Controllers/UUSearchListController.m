//
//  ZXSearchListController.m
//  CartoonStar
//
//  Created by qianfeng on 15/8/22.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ZXSearchListController.h"
#import "ZXSearchModel.h"
#import "ZXUpdateModel.h"
#import "ZXNavgationBarView.h"
#import "ZXSearchManager.h"
#import "ZXSearchResultController.h"

@interface ZXSearchListController ()<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic,strong)UITextField *textField;
@property (nonatomic,strong)ZXSearchManager *manager;
@property (nonatomic,strong)NSArray *searchDatas;
@property (nonatomic,strong)UITableView *searchTableView;


@end

@implementation ZXSearchListController{
    int t;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //搜索结果
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(beginSearch) name:@"search" object:nil];
    NSDate *date = [NSDate date];
    t = date.timeIntervalSince1970;
    //[self prepareData];
    [self prepareTableBar];
    
}
- (void)beginSearch{
    [_textField becomeFirstResponder];
    _manager = [ZXSearchManager sharedManager];
    _searchDatas = [_manager fetchAll];
    [self prepareSearchTableView];
    
}
- (void)prepareSearchTableView{
    _searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-268) style:UITableViewStylePlain];
    _searchTableView.delegate = self;
    _searchTableView.dataSource =self;
    [_searchTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_searchTableView];
}
#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchDatas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.searchDatas[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZXSearchResultController *result = [[ZXSearchResultController alloc]init];
    result.searchText = self.searchDatas[indexPath.row];
    [self presentViewController:result animated:YES completion:nil];

}
- (void)prepareTableBar{
    ZXNavgationBarView *barView = [[ZXNavgationBarView alloc]init];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[[UIImage imageNamed:@"ic_back.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    button.frame = CGRectMake(10, 5, 30, 44-10);
    [button addTarget:self action:@selector(buttonclike:) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:button];
    [self.view addSubview:barView];
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(button.frame)+10, 5, self.view.frame.size.width-100-50, 44-10)];
    _textField.borderStyle = UITextBorderStyleNone;
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.clearButtonMode = UITextFieldViewModeAlways;
    [barView addSubview:_textField];
    //icon_delete_search_history.png
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    deleteButton.frame = CGRectMake(CGRectGetMaxX(_textField.frame)+10, 5, 30, 44-10);
    
    [deleteButton setImage:[[UIImage imageNamed:@"icon_delete_search_history.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:deleteButton];

    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    searchButton.frame = CGRectMake(CGRectGetMaxX(deleteButton.frame)+20, 5, 30, 44-10);
    
    [searchButton setImage:[[UIImage imageNamed:@"icon_search_actionbar_normal.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchBegin:) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:searchButton];
}
- (void)delete:(UIButton *)button{
    if ([_manager deleteAll]) {
        NSLog(@"删除完毕");
    }
    self.searchDatas = [_manager fetchAll];
    [self.searchTableView reloadData];
    

}
- (void)searchBegin:(UIButton *)buuton{
    if ([_manager insert:_textField.text]) {
        NSLog(@"增加成功");
    }
    
    ZXSearchResultController *result = [[ZXSearchResultController alloc]init];
    result.searchText = _textField.text;
    [self presentViewController:result animated:YES completion:nil];
    self.searchDatas = [_manager fetchAll];
    [self.searchTableView reloadData];
    
}
- (void)buttonclike:(UIButton *)button{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
