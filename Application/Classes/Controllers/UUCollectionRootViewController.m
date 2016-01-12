//
//  ZXCollectionRootViewController.m
//  CartoonStar
//
//  Created by qianfeng on 15/8/14.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ZXCollectionRootViewController.h"
#import "ZXNavgationBarView.h"
#import "ZXButton.h"
@interface ZXCollectionRootViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong)NSArray *classNames;
@property (nonatomic,strong)NSMutableArray *buttonArray;
@property (nonatomic,strong)UIImageView *imageView;


@end

@implementation ZXCollectionRootViewController{
    BOOL symbol[3];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareNavgationBar];
    [self prepareScrollView];
}
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}
- (NSMutableArray *)buttonArray{
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}
- (void)prepareNavgationBar{
    ZXNavgationBarView *barView = [[ZXNavgationBarView alloc]init];
    _classNames = @[@"ZXCollectionViewController",@"ZXHistoryViewController"];
    //@"ZXLocationViewController"
    NSArray * buttonNames = @[@"收藏",@"历史"];
    CGFloat width = (CGFloat)([UIScreen mainScreen].bounds.size.width-20*6)/5;
    for (int i=0; i<buttonNames.count; i++) {
        ZXButton *button = [ZXButton buttonWithFrame:CGRectMake(20+(width+20)*i, 8, width, 30) title:buttonNames[i] tintColor:[UIColor clearColor] titleColor:[UIColor whiteColor]];
        button.tag = 1000+i;
        
        [button addTarget:self action:@selector(buttonClike:) forControlEvents:UIControlEventTouchUpInside];
        [barView addSubview:button];
        if (i==0) {
            button.selected = YES;
            button.transform = CGAffineTransformScale(button.transform, 1.2, 1.2);
            _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 8, 8)];
            CGPoint center = button.center;
            center.y += 15;
            _imageView.center = center;
            _imageView.image = [[UIImage imageNamed:@"icon_dot_normal.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [barView addSubview:_imageView];
        }
        [self.buttonArray addObject:button];

    }
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = CGRectMake(self.view.frame.size.width-10-60, 5, 60, 44-10);
    
    
    [rightButton setTitle:@"返回" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _button = rightButton;
    [barView addSubview:rightButton];

    [self.view addSubview:barView];
}
- (void)rightButtonClick:(UIButton *)button{
    if (_system) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"亲,当前无法返回" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    
}
- (void)buttonClike:(ZXButton *)button{
    for (int i=0; i<self.buttonArray.count; i++) {
        
        if (i!=button.tag-1000) {
            //NSLog(@"%d",i);
            ZXButton *button = self.buttonArray[i];
            if (button.selected) {
                button.selected = !button.selected;
                button.transform = CGAffineTransformScale(button.transform, 0.9, 0.9);
            }
        }
        
    }
    if (!button.selected) {
        button.selected = !button.selected;
        button.transform = CGAffineTransformScale(button.transform, 1.1, 1.1);
        
        CGPoint center = button.center;
        center.y += 15;
        
        [UIView animateWithDuration:0.5 animations:^{
            _imageView.center = center;
        }];
    }
    [self prepareController:button];

}
- (void)prepareScrollView{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64-49)];
    Class cls = NSClassFromString(_classNames[0]);
    symbol[0] = YES;
    UIViewController *controller = [[cls alloc]init];
    //controller.view.backgroundColor = [UIColor redColor];
    controller.view.frame = CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    [self addChildViewController:controller];
    [_scrollView addSubview:controller.view];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor yellowColor];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width*_classNames.count, 0);
    [self.view addSubview:_scrollView];
}

- (void)prepareController:(ZXButton *)button{
    if (!symbol[button.tag-1000]) {
        
        Class cls = NSClassFromString(_classNames[button.tag-1000]);
        UIViewController *controller = [[cls alloc]init];
        controller.view.frame = CGRectMake(_scrollView.frame.size.width*(button.tag-1000), 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
        
        [self addChildViewController:controller];
        
        [_scrollView addSubview:controller.view];
        
        
        symbol[button.tag-1000] = YES;
    }
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width*(button.tag-1000), 0) animated:NO];

}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offSet = scrollView.contentOffset.x;
    int i = offSet/scrollView.frame.size.width;
    if (!symbol[i]) {
        Class cls = NSClassFromString(_classNames[i]);
        UIViewController *controller = [[cls alloc]init];
        controller.view.frame = CGRectMake(_scrollView.frame.size.width*i, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
        
        [self addChildViewController:controller];
        
        [_scrollView addSubview:controller.view];
        
        
        symbol[i] = YES;
    }
    ZXButton *button = self.buttonArray[i];
    CGPoint center = button.center;
    center.y += 15;
    [UIView animateWithDuration:0.3 animations:^{
        _imageView.center = center;
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
