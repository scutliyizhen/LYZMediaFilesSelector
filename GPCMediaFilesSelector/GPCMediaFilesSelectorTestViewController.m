//
//  GPCMediaFilesSelectorTestViewController.m
//  GPCMediaFilesSelector
//
//  Created by robertyzli on 16/8/24.
//  Copyright © 2016年 robertyzli. All rights reserved.
//

#import "GPCMediaFilesSelectorTestViewController.h"
#import "GPCMediaFilesSelectorDemo_2ViewController.h"
#import "GPCInstagramPictureSelectorViewController.h"
#import "GPCMediaFilesSeletorDemo_1ViewController.h"
#import "GPCMediaFilesSelectorUtilityHelper.h"

@interface GPCMediaFilesSelectorTestViewController ()
@property(nonatomic,strong)GPCPictureSeletorDemo_1ViewController* pictureSelectorDemoViewController;
@property(nonatomic,strong)GPCInstagramPictureSelectorViewController* projectSecondViewController;
@property(nonatomic,strong)GPCMediaFilesSelectorDemo_2ViewController*  projectFirstViewController;
@end

@implementation GPCMediaFilesSelectorTestViewController
- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //导航按钮
    UIButton* leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* btn1 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 70.0, 200, 140,40)];
    [btn1 setBackgroundColor:[UIColor blueColor]];
    [btn1 setTitle:@"Demo_1" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(pictureDemoBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn1];
    UIButton* btn2 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 70.0, 280, 140,40)];
    [btn2 setBackgroundColor:[UIColor redColor]];
    [btn2 setTitle:@"Demo_2" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(projectFirstBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UIButton* btn3 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 70.0, 360.0, 140,40)];
    [btn3 setBackgroundColor:[UIColor greenColor]];
    [btn3 setTitle:@"Demo_3" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(projectSecondBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //解决控制器自动适配UScrollView在导航条隐藏情况下滚动适配的问题
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = NO;
    self.title = @"媒体文件选择器";
}

- (void)leftButtonClick:(UIButton*)btn
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)pictureDemoBtnClickEvent:(UIButton*)btn
{
    UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:self.pictureSelectorDemoViewController];
    
    [self presentViewController:navi animated:YES completion:nil];
}

- (void)projectFirstBtnClickEvent:(UIButton*)btn
{
    UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:self.projectFirstViewController];
    
    [self presentViewController:navi animated:YES completion:nil];
}

- (void)projectSecondBtnClickEvent:(UIButton*)btn
{
    UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:self.projectSecondViewController];
    
    [self presentViewController:navi animated:YES completion:nil];
}

- (GPCPictureSeletorDemo_1ViewController*)pictureSelectorDemoViewController
{
	if(_pictureSelectorDemoViewController == nil)
    {
        _pictureSelectorDemoViewController = [GPCPictureSeletorDemo_1ViewController new];
    }
    return _pictureSelectorDemoViewController;
}

- (GPCMediaFilesSelectorDemo_2ViewController*)projectFirstViewController
{
    _projectFirstViewController = [GPCMediaFilesSelectorDemo_2ViewController new];
    
    return _projectFirstViewController;
}

- (GPCInstagramPictureSelectorViewController*)projectSecondViewController
{
    _projectSecondViewController = [GPCInstagramPictureSelectorViewController new];
    return _projectSecondViewController;
}
@end
