
//
//  ZXIdeaController.m
//  CartoonStar
//
//  Created by qianfeng on 15/8/26.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ZXIdeaController.h"
#import "ZXNavgationBarView.h"
@interface ZXIdeaController ()

@end

@implementation ZXIdeaController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareTabbar];
    [self prepareUI];
}
- (void)prepareTabbar{
    ZXNavgationBarView *barView = [[ZXNavgationBarView alloc]init];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[[UIImage imageNamed:@"ic_back.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    button.frame = CGRectMake(10, 10, 20, 44-20);
    [button addTarget:self action:@selector(buttonclike:) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:button];
    [self.view addSubview:barView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2.0-50, 0, 100, barView.frame.size.height)];
    titleLabel.text = @"意见";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [barView addSubview:titleLabel];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = CGRectMake(self.view.frame.size.width-10-20, 10, 20, 44-20);
    
}
- (void)buttonclike:(UIButton *)button{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)prepareUI{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 64, self.view.frame.size.width, 50)];
    label.text = [NSString stringWithFormat:@"请输入您的宝贵意见:"];
    label.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:label];
    UITextView *textView = [[UITextView alloc] init];
    textView.frame = CGRectMake(10, CGRectGetMaxY(label.frame), self.view.frame.size.width-20, 180);
    textView.backgroundColor = [UIColor cyanColor];
    textView.font = [UIFont boldSystemFontOfSize:15];
    textView.textColor = [UIColor redColor];
    [self.view addSubview:textView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    cancelBtn.tag = 1000+1;
    [cancelBtn setFrame:CGRectMake(0, textView.frame.size.height-30, 60, 30)];
    [cancelBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [textView addSubview:cancelBtn];
    
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    commitBtn.tag = 1000+2;
    [commitBtn setFrame:CGRectMake(textView.frame.size.width-60, textView.frame.size.height-30, 60, 30)];
    [commitBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [textView addSubview:commitBtn];

}
- (void)back:(UIButton *)button{
    [self dismissViewControllerAnimated:YES completion:nil];
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
