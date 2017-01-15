//
//  GPCMediaFilesSelectorGallertDemo_1ViewController.m
//  GPCMediaFilesSelector
//
//  Created by robertyzli on 2016/11/24.
//  Copyright © 2016年 robertyzli. All rights reserved.
//

#import "GPCMediaFilesSelectorPhotoGalleryView.h"
#import "GPCMediaFilesSelectorBridge.h"
#import "GPCMediaFilesSelectorGalleryCaseDataSource.h"
#import "GPCMediaFilesSelectorGallertDemo_1ViewController.h"

@interface GPCMediaFilesSelectorGallertDemo_1ViewController ()
@property(nonatomic,strong)GPCMediaFilesSelectorPhotoGalleryView* galleryView;//相册GalleryView
@end

@implementation GPCMediaFilesSelectorGallertDemo_1ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    __weak typeof (self) weakSelf = self;
    
    if(self.galleryListType == GalleryListType_Photo)
    {
       [self.selectorEngine loadUserGallery:^(GPCMediaFilesSelectorGalleryCaseDataSource *galleryCaseDataSource) {
           weakSelf.galleryView.galleryDataSource = galleryCaseDataSource;
           [weakSelf.galleryView preLoadAssetsWhenViewDidAppear];
           [weakSelf.galleryView reloadData];
       }];
    }
    
    if(self.galleryListType == GalleryListType_Video)
    {
        [self.selectorEngine loadUserVideoList:^(GPCMediaFilesSelectorGalleryCaseDataSource *galleryDataSource) {
            weakSelf.galleryView.galleryDataSource = galleryDataSource;
            [weakSelf.galleryView preLoadAssetsWhenViewDidAppear];
            [weakSelf.galleryView reloadData];
        }];
    }
 
    self.galleryView.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 64);
    [self.galleryView setNeedsLayout];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //解决控制器自动适配UScrollView在导航条隐藏情况下滚动适配的问题
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = NO;
    self.title = @"相册列表";
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (GPCMediaFilesSelectorPhotoGalleryView*)galleryView
{
    if(_galleryView == nil)
    {
        _galleryView = [[GPCMediaFilesSelectorPhotoGalleryView alloc] initWithBridgeClass:[GPCMediaFilesSelectorBridge class]
                                                                          caseSourceClass:[GPCMediaFilesSelectorGalleryCaseDataSource class]];
        [self.view addSubview:_galleryView];
    }
    return _galleryView;
}
@end
