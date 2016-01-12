//
//  ZXMineViewController.m
//  CartoonStar
//
//  Created by qianfeng on 15/8/14.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ZXMineViewController.h"
#import "ZXNavgationBarView.h"
#import "ZXCollectionViewController.h"
#import "ZXHistoryViewController.h"
#import "ZXCollectionRootViewController.h"
#import "ZXFindViewController.h"
//#import "UMSocial.h"
#import "ZXIdeaController.h"

@interface ZXMineViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSArray *datas;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *images;

@end

@implementation ZXMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *array1 = @[@"我的收藏",@"我的历史"];
    NSArray *array2 = @[@"清除缓存",@"当前版本",@"关于我们"];
    NSArray *array3 = @[@"意见反馈",@"为我点赞"];
    _datas = @[array1,array2,array3];
    //platform_info__alipay.png
    NSArray *images1 = @[@"icon_u17app_wp.png",@"icon_u17app_web.png"];
    NSArray *images2 = @[@"tucao_delete_pressed.png",@"visible.png",@"tucao.png"];
    NSArray *images3 = @[@"tucao_scale_pressed.png",@"tucao_ok_pressed.png"];
    _images = @[images1,images2,images3];
    [self prepareTableView];
}
- (void)prepareTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-49-20)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    ZXNavgationBarView *barView = [[ZXNavgationBarView alloc]init];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, self.view.frame.size.width, 44)];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.text = @"当前应用";
    [barView addSubview:label];
    _tableView.tableHeaderView = barView;
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.datas.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.datas[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.datas[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    cell.imageView.image = [UIImage imageNamed:_images[indexPath.section][indexPath.row]];
    if (indexPath.section==0) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, 0, 40, 40) ;
        button.tag = 1000+indexPath.row+indexPath.section;
        [button setTitle:@"查看" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(lookAction:) forControlEvents:UIControlEventTouchUpInside];
        button.clipsToBounds = YES;
        button.layer.cornerRadius = 20;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //[view addSubview:button];
        button.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
        
        cell.accessoryView = button;

    }
    if ((indexPath.section==1)&&(indexPath.row==0)) {

        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, 0, 40, 40) ;
        [button setTitle:@"清除" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        button.clipsToBounds = YES;
        button.layer.cornerRadius = 20;
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        //[view addSubview:button];
        
        button.backgroundColor = [UIColor cyanColor];
        cell.accessoryView = button;

    }else if ((indexPath.section==1)&&(indexPath.row==1)){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
        label.text = @"Version-1.0.0";
        label.font = [UIFont boldSystemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        cell.accessoryView = label;
    }else if ((indexPath.section==1)&&(indexPath.row==2)){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, 0, 40, 40) ;
        button.tag = 1000+indexPath.row+indexPath.section;
        [button setTitle:@"查看" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(lookAction:) forControlEvents:UIControlEventTouchUpInside];
        button.clipsToBounds = YES;
        button.layer.cornerRadius = 20;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //[view addSubview:button];
        button.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
        
        cell.accessoryView = button;

    }else if ((indexPath.section==2)&&(indexPath.row==0)){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, 0, 40, 40) ;
        button.tag = 1000+indexPath.row+indexPath.section+10;
        [button setTitle:@"意见" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(lookAction:) forControlEvents:UIControlEventTouchUpInside];
        button.clipsToBounds = YES;
        button.layer.cornerRadius = 20;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //[view addSubview:button];
        button.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
        
        cell.accessoryView = button;

    }else if ((indexPath.section==2)&&(indexPath.row==1)){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, 0, 40, 40) ;
        button.tag = 1000+indexPath.row+indexPath.section+10;
//        [button setTitle:@"意见" forState:UIControlStateNormal];
        [button setImage:[[UIImage imageNamed:@"btn_comic_favorited.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        button.tintColor = [UIColor clearColor];
        
        [button setImage:[[UIImage imageNamed:@"btn_comic_not_favorite.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(lookAction:) forControlEvents:UIControlEventTouchUpInside];
        
        button.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
        
        cell.accessoryView = button;

    }
    return cell;
}
- (void)lookAction:(UIButton *)button{
    switch (button.tag-1000) {
        case 0:{
            ZXCollectionRootViewController *collection = [[ZXCollectionRootViewController alloc]init];
            collection.system = YES;
            //[collection.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self presentViewController:collection animated:YES completion:nil];
        }break;
        case 1:{
            ZXCollectionRootViewController *history = [[ZXCollectionRootViewController alloc]init];
            history.system = YES;
            //[history.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [history.scrollView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width, 0) animated:NO];
            [self presentViewController:history animated:YES completion:nil];
        }break;
        case 3:{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"我们" message:@"这是一款漫画浏览的应用,希望能给广大漫画爱好者带来福音,如有错误欢迎大家指正" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }break;
        case 12:{
            ZXIdeaController *idea = [[ZXIdeaController alloc]init];
            [self presentViewController:idea animated:YES completion:nil];
        }break;
        case 13:{
            button.selected = !button.selected;
        }break;
        default:
            break;
    }
}
//btn_comic_favorited.png
//btn_comic_not_favorite.png
- (void)deleteAction:(UIButton *)button{

    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *path = [NSString stringWithFormat:@"%@/Documents/Cache",NSHomeDirectory()];
    if ([manager fileExistsAtPath:path]) {
        NSDictionary *dic = [manager attributesOfItemAtPath:path error:nil];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"清除成功" message:[NSString stringWithFormat:@"成功清除%@B的缓存",dic[NSFileSize]] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        [manager removeItemAtPath:path error:nil];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"没有缓存可以清除" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
