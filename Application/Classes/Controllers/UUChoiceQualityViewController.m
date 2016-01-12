//
//  ZXChoiceQualityViewController.m
//  CartoonStar
//
//  Created by qianfeng on 15/8/14.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ZXChoiceQualityViewController.h"
#import "ZXQualityADModel.h"
#import "ZXQualityADListModel.h"
#import "ZXRecommendModel.h"
#import "ZXComicListItemsModel.h"
#import "ZXQualityCell.h"
#import "ZXQualityHeaderView.h"
#import "ZXQualityRooterView.h"
#import "ZXAppLIstViewController.h"
#import "ZXRecommendController.h"

#import "ZXQualityFirstView.h"
#import "ZXQualityLastView.h"
#define kQualityUrl(date) [NSString stringWithFormat:@"http://app.u17.com/v3/app/android/phone/recommend/itemlist?version=0&t=%d&v=2150000&android_id=c37003cf2965586a&key=null&come_from=u17",date]
@interface ZXChoiceQualityViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
//UITableViewDataSource,UITableViewDelegate
@property (nonatomic,strong)NSMutableArray *datas;
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)ZXQualityHeaderView *headerView;

@end

@implementation ZXChoiceQualityViewController{
    int t;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //1439866952
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushListController:) name:@"list" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushListController:) name:@"last" object:nil];
   
//    [self prepareData];
    [self prepareCollectionView];
    //[self prepareTableView];
     [self setRefresh];
    
    
}
- (void)pushListController:(NSNotification *)notification{
    ZXAppLIstViewController *listController = [[ZXAppLIstViewController alloc]init];
    listController.comicid = [notification.userInfo[@"comicid"] intValue];
    
    [self presentViewController:listController animated:YES completion:nil];
}
- (NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
- (void)setRefresh{
    [self.collectionView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.collectionView headerBeginRefreshing];
    
    //[self.tableView addFooterWithTarget:self action:@selector(rooterRefresh)];
    
    self.collectionView.headerPullToRefreshText = @"下拉刷新";
    self.collectionView.headerReleaseToRefreshText = @"松开后刷新";
    self.collectionView.headerRefreshingText = @"正在拼命刷新中";
    
    self.collectionView.footerPullToRefreshText = @"上拉加载";
    self.collectionView.footerReleaseToRefreshText = @"松开后加载";
    self.collectionView.footerRefreshingText = @"正在拼命加载中";
}
- (void)headerRefresh{
    //[self.datas removeAllObjects];
    [self prepareData];
    [self.collectionView headerEndRefreshing];
}
- (void)prepareData{
    NSDate *date = [NSDate date];
    t = date.timeIntervalSince1970;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeBlack];
    [manager GET:kQualityUrl(t) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.datas.count!=0) {
            [self.datas removeAllObjects];
        }
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dataDic = dic[@"data"];
        NSArray *returnDataArray = dataDic[@"returnData"];
        for (int i=0; i<returnDataArray.count; i++) {
            NSDictionary *dictionary = returnDataArray[i];
            if (i==0 || i==returnDataArray.count-1) {
                ZXQualityADListModel *adListModel = [[ZXQualityADListModel alloc]initWithDictionary:dictionary error:nil];
                [self.datas addObject:adListModel];
            }else{
                ZXRecommendModel *model = [[ZXRecommendModel alloc]initWithDictionary:dictionary error:nil];
                
                if (model.title==nil) continue;
              
                [self.datas addObject:model];
            }
           // NSLog(@"%ld",self.datas.count);
        }
        //[NSThread sleepForTimeInterval:2];
        [SVProgressHUD showSuccessWithStatus:@"OK" maskType:SVProgressHUDMaskTypeBlack];
        [self.collectionView reloadData];
        //[self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败" maskType:SVProgressHUDMaskTypeBlack];
        [self prepareData];
    }];
}


- (void)prepareCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat padding = 10.0;
    CGFloat width = ([UIScreen mainScreen].bounds.size.width-4*padding)/3.0;
    CGFloat height = 1.5 * width;
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
    [_collectionView registerClass:[ZXQualityCell class] forCellWithReuseIdentifier:@"cell"];
    [_collectionView registerClass:[ZXQualityHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [_collectionView registerClass:[ZXQualityRooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"rooter"];
    [_collectionView registerClass:[ZXQualityFirstView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerfirst"];
    [_collectionView registerClass:[ZXQualityLastView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"rootlast"];
    [self.view addSubview:_collectionView];
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.datas.count-2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    ZXRecommendModel *bigModel = self.datas[section + 1];
   // NSLog(@"%@",bigModel);
    return bigModel.comicListItems.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZXQualityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    ZXRecommendModel *bigModel = self.datas[indexPath.section+1];
    ZXComicListItemsModel *model = bigModel.comicListItems[indexPath.row];
    [cell.itemImageView setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"umeng_socialize_share_pic.png"]];
    cell.itemLabel.text = model.name;
    //cell.backgroundColor = [UIColor cyanColor];
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section==0) {
            ZXQualityADListModel *listModel = self.datas.firstObject;
            NSArray *array = listModel.galleryItems;
            ZXRecommendModel *model = self.datas[indexPath.section + 1];
            ZXQualityFirstView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerfirst" forIndexPath:indexPath];
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                header.array = array;
            });
            [header.itemImageView setImageWithURL:[NSURL URLWithString:model.titleIconUrl] placeholderImage:[UIImage imageNamed:@"bg_default_recommend_title.png"]];
            header.sectionLabel.text = model.titleWithIcon;
            header.moreButton.tag = 1000 + indexPath.section + 1;
            [header.moreButton addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];

            reusableView = header;

        }else{
    
            ZXQualityHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
            //ZXQualityHeaderView *headerView = [[ZXQualityHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
            ZXRecommendModel *model = self.datas[indexPath.section + 1];
            [headerView.itemImageView setImageWithURL:[NSURL URLWithString:model.titleIconUrl] placeholderImage:[UIImage imageNamed:@"bg_default_recommend_title.png"]];
            headerView.sectionLabel.text = model.titleWithIcon;
            headerView.moreButton.tag = 1000 + indexPath.section + 1;
            [headerView.moreButton addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
            //[rooter addSubview:headerView];
            
            reusableView = headerView;
        }
    
    }else{
        if (indexPath.section==self.datas.count-3) {
            ZXQualityLastView *rooter = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"rootlast" forIndexPath:indexPath];
            ZXQualityADListModel *model = self.datas.lastObject;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                rooter.array = model.bannerItems;
            });
            reusableView = rooter;
        }else{
            ZXQualityRooterView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"rooter" forIndexPath:indexPath];
            view.backgroundColor = [UIColor darkGrayColor];
            reusableView = view;
        }
    }
    return reusableView;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    ZXRecommendModel *model = self.datas[indexPath.section + 1];
    ZXComicListItemsModel *detalModel = model.comicListItems[indexPath.row];
    ZXAppLIstViewController *list = [[ZXAppLIstViewController alloc]init];
    list.comicid = detalModel.comic_id.intValue;
    [self presentViewController:list animated:YES completion:nil];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return section==0? CGSizeMake([UIScreen mainScreen].bounds.size.width, 250): CGSizeMake([UIScreen mainScreen].bounds.size.width, 51);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return section==self.datas.count-3 ? CGSizeMake([UIScreen mainScreen].bounds.size.width, 200) : CGSizeMake([UIScreen mainScreen].bounds.size.width, 1);
}
- (void)moreAction:(UIButton *)button{
    ZXRecommendModel *model = self.datas[button.tag-1000];
    ZXRecommendController *controller = [[ZXRecommendController alloc]init];
    controller.argName = model.argName;
    controller.argValue = model.argValue;
    controller.number = (int)(button.tag-1000);
    
    [self presentViewController:controller animated:YES completion:nil];
}

@end
