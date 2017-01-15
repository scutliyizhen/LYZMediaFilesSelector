//
//  GPCMediaFilesSelectorVideoList_demo1ViewController.m
//  GPCProject
//
//  Created by robertyzli on 2016/12/1.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCMediaFilesSelectorVideoList_demo1ViewController.h"
#import "GPCMediaFilesSelctorVideoListView.h"

@interface GPCMediaFilesSelectorVideoList_demo1ViewController ()
@property(nonatomic,strong)GPCPictureSelctorVideoListView* listView;
@end

@implementation GPCMediaFilesSelectorVideoList_demo1ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    __weak typeof (self) weakSelf = self;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.selectorEngine loadAllVideos:^(PhotoSelectorAuthorizationStatus authonsizeState, GPCMediaFilesSelectorPhotoCaseDataSource *photoDataSource) {
        if(authonsizeState == PhotoSelectorAuthorizationStatusAuthorized)
        {
            weakSelf.listView.gridCaseDataSource = photoDataSource;
            [weakSelf.listView reloadData];
            [weakSelf.listView preLoadAssetsWhenViewDidAppear];
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"打开相册失败"
                                                           message:@"请打开 设置-隐私-照片 来进行设置"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil, nil];
            [alert show];
        }

    }];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.listView.frame = CGRectMake(0, 64.0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 64.0);;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //解决控制器自动适配UScrollView在导航条隐藏情况下滚动适配的问题
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = NO;
    self.title = @"视频列表";
}

- (GPCPictureSelctorVideoListView*)listView
{
	if(_listView == nil)
    {
        _listView = [GPCPictureSelctorVideoListView new];
        [self.view addSubview:_listView];
    }
    return _listView;
}
@end
