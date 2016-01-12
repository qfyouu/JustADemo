//
//  ZXClassViewController.m
//  CartoonStar
//
//  Created by qianfeng on 15/8/14.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ZXClassViewController.h"
#import "ZXClassModel.h"
#import "ZXQualityCell.h"
#import "ZXRecommendController.h"

#define kUrlClass(date) [NSString stringWithFormat:@"http://app.u17.com/v3/app/android/phone/sort/list?sortVersion=1165&t=%d&v=2110000&android_id=c37003cf2965586a&key=null&come_from=sanxingJ&model=GT-I9300",date]
@interface ZXClassViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)NSMutableArray *datas;
@property (nonatomic,strong)UICollectionView *collectionView;
//@property (nonatomic,strong)NSMutableArray *names;
@end

@implementation ZXClassViewController{
    int t;
}
//- (NSMutableArray *)names{
//    if (!_names) {
//        _names = [NSMutableArray array];
//    }
//    return _names;
//}
- (NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //http://app.u17.com/v3/app/android/phone/sort/list?sortVersion=1165&t=1439474721&v=2110000&android_id=c37003cf2965586a&key=null&come_from=sanxingJ&model=GT-I9300
    NSDate *date = [NSDate date];
    t = date.timeIntervalSince1970;
    [self prepareDate];
    [self prepareCollectionView];

}
- (void)prepareDate{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeBlack];
    [manager GET:kUrlClass(t) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dataDic = dic[@"data"];
        NSDictionary *dataDic1 = dataDic[@"returnData"];
        NSArray *array = dataDic1[@"rankinglist"];
        for (NSDictionary *dict in array) {
            ZXClassModel *model = [[ZXClassModel alloc]initWithDictionary:dict error:nil];
            [self.datas addObject:model];
        }
        [SVProgressHUD showSuccessWithStatus:@"加载成功" maskType:SVProgressHUDMaskTypeBlack];
        [self.collectionView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败" maskType:SVProgressHUDMaskTypeBlack];
        [self prepareDate];
    }];
}

- (void)prepareCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat padding = 10.0;
    CGFloat width = (self.view.frame.size.width-4*padding)/3.0;
    CGFloat height = 1.2*width;
    layout.itemSize = CGSizeMake(width, height);
    layout.minimumLineSpacing = padding;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-49-64) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[ZXQualityCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];
    
    
    
}
#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.datas.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZXQualityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    ZXClassModel *model = self.datas[indexPath.row];
    [cell.itemImageView setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"bg_default_classify.png"]];
    cell.itemLabel.text = model.sortName;
    //[self.names addObject:model.sortName];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    ZXClassModel *model = self.datas[indexPath.row];
    ZXRecommendController *recommend = [[ZXRecommendController alloc]init];
    recommend.argName = model.argName;
    recommend.argValue = model.argValue;
    recommend.title1 = model.sortName;
    recommend.is_class = YES;
    [self presentViewController:recommend animated:YES completion:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
