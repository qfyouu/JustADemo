//
//  ZXSearchViewController.m
//  CartoonStar
//
//  Created by qianfeng on 15/8/14.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ZXSearchViewController.h"
#import "ZXSearchModel.h"
#import "ZXSearchCell.h"
#import "ZXLabel.h"
#import "ZXSearchListController.h"
#import "ZXSearchResultController.h"
#define  kSearchUrl(date)  [NSString stringWithFormat:@"http://app.u17.com/v3/app/android/phone/search/hotkeywords?t=%d&v=2110000&android_id=c37003cf2965586a&key=null&come_from=sanxingJ",date]
@interface ZXSearchViewController ()<UISearchBarDelegate>
@property (nonatomic,strong)NSMutableArray *datas;
//@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)UILabel *label;
@end

@implementation ZXSearchViewController{
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
    //self.view.backgroundColor = [UIColor blueColor];
    
    NSDate *date = [NSDate date];
    t = date.timeIntervalSince1970;
    //[_searchBar resignFirstResponder];
    [self prepareDate];
    [self prepareUI];
}
- (void)prepareDate{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeBlack];
    [manager GET:kSearchUrl(t) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dataDic = dic[@"data"];
        NSArray *array = dataDic[@"returnData"];
        
        for (NSDictionary *dict in array) {
            ZXSearchModel *model = [[ZXSearchModel alloc]initWithDictionary:dict error:nil];
            [self.datas addObject:model];
        }
        [self prepareScreen];
        [SVProgressHUD showSuccessWithStatus:@"加载成功" maskType:SVProgressHUDMaskTypeBlack];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败" maskType:SVProgressHUDMaskTypeBlack];
        [self prepareDate];
    }];

}
- (void)prepareUI{
    
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 30)];
    _searchBar.placeholder = @"搜索";
    _searchBar.searchBarStyle = UISearchBarStyleDefault;
    _searchBar.delegate = self;
    _searchBar.showsSearchResultsButton = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchBarAction:)];
    [_searchBar addGestureRecognizer:tap];
    [self.view addSubview:_searchBar];
    //bg_comic_begin_read.9.png
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_searchBar.frame)+30, 10, 30)];
    imageView.image = [UIImage imageNamed:@"bg_comic_begin_read.9.png"];
    [self.view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+10, imageView.frame.origin.y, 200, imageView.frame.size.height)];
    label.text = @"热门搜索";
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textColor = [UIColor redColor];
    _label = label;
    [self.view addSubview:_label];
    
    
}
- (void)prepareScreen{
    CGFloat gap = 5.0;
    CGFloat width = ([UIScreen mainScreen].bounds.size.width-3*gap-20)/4.0;
    for (int i=0; i<self.datas.count; i++) {
        ZXSearchModel *model = self.datas[i];
        ZXLabel *label = [[ZXLabel alloc]initWithFrame:CGRectMake(10+(width+5)*(i%4), CGRectGetMaxY(_label.frame)+30+(width/2.0+5)*(i/4), width, width/2.0)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [label addGestureRecognizer:tap];
        label.userInteractionEnabled = YES;
        label.model = model;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = model.tag;
        label.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
        [self.view addSubview:label];
    }
}
- (void)searchBarAction:(UITapGestureRecognizer *)tap{
    ZXSearchListController *list = [[ZXSearchListController alloc]init];
    [self presentViewController:list animated:YES completion:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"search" object:self];
}
#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    ZXSearchListController *list = [[ZXSearchListController alloc]init];
    [self presentViewController:list animated:YES completion:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"search" object:self];
}
- (void)tapAction:(UITapGestureRecognizer *)tap{
    ZXLabel *label = (ZXLabel *)tap.view;
    ZXSearchResultController *searchList = [[ZXSearchResultController alloc]init];
    searchList.searchText = label.model.tag;
    [self presentViewController:searchList animated:YES completion:nil];
    
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
