//
//  ViewController.m
//  LYZMediaFilesSelector
//
//  Created by 李义真 on 2017/1/15.
//  Copyright © 2017年 李义真. All rights reserved.
//

#import "ViewController.h"
#import "GPCMediaFilesSelectorTestViewController.h"

@interface ViewController ()
@property(nonatomic,strong)GPCMediaFilesSelectorTestViewController* demoController;
@end

@implementation ViewController
- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton* meidaFilesDemoBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 90.0, 300, 180,40)];
    [meidaFilesDemoBtn setBackgroundColor:[UIColor blueColor]];
    [meidaFilesDemoBtn setTitle:@"媒体文件选择器Demo" forState:UIControlStateNormal];
    [meidaFilesDemoBtn addTarget:self action:@selector(meidaFilesDemoBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:meidaFilesDemoBtn];
}

- (GPCMediaFilesSelectorTestViewController *)demoController
{
    if(_demoController == nil)
    {
        _demoController = [GPCMediaFilesSelectorTestViewController new];
    }
    return _demoController;
}

- (void)meidaFilesDemoBtnClickEvent:(UIButton*)btn
{
    UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:self.demoController];
    [self presentViewController:navi animated:YES completion:nil];
}
@end
