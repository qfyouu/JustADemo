//
//  ZXQualityFirstView.m
//  CartoonStar
//
//  Created by qianfeng on 15/8/18.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ZXQualityFirstView.h"
#import "ZXQualityADModel.h"
#import "UIImageView+AFNetworking.h"
#import "ZXImageView.h"
#import "ZXChoiceQualityViewController.h"

@implementation ZXQualityFirstView{
    NSTimer *timer;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        _itemImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 210, 40, 30)];
        [self addSubview:_itemImageView];
        _sectionLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_itemImageView.frame), 215, 150, 20)];
        _sectionLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_sectionLabel];
        
        _moreButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _moreButton.frame = CGRectMake(self.frame.size.width-70, 210, 50, 30);
        [_moreButton setTitle:@"更多" forState:UIControlStateNormal];
        [self addSubview:_moreButton];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_moreButton.frame), 220, 10, 10)];
        imageView.image = [[UIImage imageNamed:@"icon_arrow.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self addSubview:imageView];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame)-2, self.frame.size.width, 1)];
        view.backgroundColor = [UIColor darkGrayColor];
        [self addSubview:view];


    }
    return self;
}

- (void)setArray:(NSArray *)array{
    _array = array;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 200)];
    _scrollView = [[UIScrollView alloc]initWithFrame:view.frame];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    ZXImageView *imageView = [[ZXImageView alloc]initWithFrame:CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
    imageView.tag = 999;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageAction:)];
    ZXQualityADModel *model = array.lastObject;
    imageView.model = model;
    imageView.userInteractionEnabled = YES;
    

    [imageView setImageWithURL:[NSURL URLWithString:model.bigImageUrl]];
    [imageView addGestureRecognizer:tap];
    [_scrollView addSubview:imageView];
    
    for (int i=0; i<array.count; i++) {
        ZXQualityADModel *model = array[i];
        ZXImageView *imageView = [[ZXImageView alloc]initWithFrame:CGRectMake(_scrollView.frame.size.width*(i+1), 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        imageView.tag = 1000 + i;
        imageView.model = model;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageAction:)];
        [imageView setImageWithURL:[NSURL URLWithString:model.bigImageUrl]];
        [imageView addGestureRecognizer:tap];
        [_scrollView addSubview:imageView];
    }
    [view addSubview:_scrollView];
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_scrollView.frame)-100, CGRectGetMaxY(_scrollView.frame)-20, 100, 20)];
    _pageControl.backgroundColor = [UIColor clearColor];
    
    _pageControl.numberOfPages = 4;
    [view addSubview:_pageControl];
    [view bringSubviewToFront:_pageControl];
    //[self addSubview:_pageControl];
    _pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    //[self bringSubviewToFront:_pageControl];
    _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width, 0);
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width*array.count, 0);
   // [self addSubview:_scrollView];
    _scrollView.delegate = self;
    [self addSubview:view];
    [self changePageController:_pageControl];
    timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];

}
- (void)changePageController:(UIPageControl *)pageControl{
    NSArray *array = pageControl.subviews;
    for (int i=0; i<array.count; i++) {
        UIView *subView = [array objectAtIndex:i];
//        if ([NSStringFromClass([subView class]) isEqualToString:NSStringFromClass([UIImageView class])]) {
//            ((UIImageView *)subView).image = (pageControl.currentPage==i? [UIImage imageNamed:@"icon_dot_selected.png"] : [UIImage imageNamed:@"icon_dot_normal.png"]);
//        }
        subView.backgroundColor = (pageControl.currentPage==i? [UIColor greenColor]:[UIColor whiteColor]);
    }
}
- (void)autoScroll{
    CGFloat offset = self.scrollView.contentOffset.x;
    if (offset>=self.array.count*self.scrollView.frame.size.width) {
        [self.scrollView setContentOffset:CGPointZero animated:NO];
        [self.scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:YES];
        self.pageControl.currentPage = 0;
    }else{
        [self.scrollView setContentOffset:CGPointMake(offset+_scrollView.frame.size.width, 0) animated:YES];
        self.pageControl.currentPage = self.scrollView.contentOffset.x/self.scrollView.frame.size.width;
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [timer invalidate];
    //NSLog(@"123");
    timer = nil;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
    //NSLog(@"456");

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x>scrollView.frame.size.width) {
        _pageControl.currentPage = scrollView.contentOffset.x/scrollView.frame.size.width-1;
    }
}
- (void)imageAction:(UITapGestureRecognizer *)tap{
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:nil name:@"list" object:nil];
    ZXImageView *imageView = (ZXImageView *)tap.view;
    ZXQualityADModel *model = imageView.model;

    NSDictionary *dic = @{@"comicid":model.comicId};
    [[NSNotificationCenter defaultCenter]postNotificationName:@"list" object:self userInfo:dic];
}
@end
