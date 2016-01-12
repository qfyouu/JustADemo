//
//  ZXCollectionViewController.m
//  CartoonStar
//
//  Created by qianfeng on 15/8/14.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ZXCollectionViewController.h"
#import "ZXCollectionCell.h"
#import "ZXCollectionManager.h"
#import "ZXLIstModel.h"
#import "ZXAppLIstViewController.h"

@interface ZXCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)ZXCollectionManager *manager;
@property (nonatomic,strong)NSMutableArray *datas;
@end

@implementation ZXCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _manager = [ZXCollectionManager sharedManager];
    // Do any additional setup after loading the view.
    _datas = [NSMutableArray arrayWithArray:[_manager fetchAll]];
    //[self.collectionView reloadData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refrsh) name:@"refresh" object:nil];
    [self prepareCollectionView];
}
- (void)refrsh{
    //NSLog(@"123");
    [_datas removeAllObjects];
    _datas = [NSMutableArray arrayWithArray:[_manager fetchAll]];
    [self.collectionView reloadData];
}
- (void)prepareCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat padding = 10.0;
    CGFloat width = ([UIScreen mainScreen].bounds.size.width-4*padding)/3.0;
    CGFloat height = 1.2 * width;
    layout.itemSize = CGSizeMake(width, height);
    layout.minimumLineSpacing = padding;
    //layout.minimumLineSpacing = padding;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-49-64) collectionViewLayout:layout];
    
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[ZXCollectionCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];

}
#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.datas.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZXCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    ZXLIstModel *model = self.datas[indexPath.row];
    [cell.imageView1 setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"umeng_socialize_share_pic.png"]];
    cell.label1.text = model.name;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    ZXAppLIstViewController *list = [[ZXAppLIstViewController alloc]init];
    ZXLIstModel *model = self.datas[indexPath.row];
    list.comicid = model.comic_id.intValue;
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
