//
//  GPCPinDaoPictureSelectorViewController.m
//  GameBible
//
//  Created by robertyzli on 16/7/14.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCTopNaviHeaderView.h"
#import "GPCInputPhotoCameraHelper.h"
#import "GPCMediaFilesSelectorEngine.h"
#import "GPCMediaFilesSelectorUtilityHelper.h"
#import "GPCMediaFilesSelectorCollectionView.h"
#import "GPCMediaFilesSelectorDemo_2GalleryView.h"
#import "GPCMediaFilesSelectorDemo_2ViewController.h"
#import "GPCMediaFilesSelectorPhotoCaseDataSource.h"
#import "GPCMediaFilesSelectorWithTwoActionBridge.h"

@interface GPCMediaFilesSelectorDemo_2ViewController ()<UIAlertViewDelegate>
@property(nonatomic,strong)GPCTopNaviHeaderView* topHeaderView;
@property(nonatomic,strong)GPCMediaFilesSelectorCollectionView* photoGridView;
@property(nonatomic,strong)GPCMediaFilesSelectorDemo_2GalleryView* galleryView;
@property(nonatomic,strong)GPCMediaFilesSelectorEngine* pictureSelectorEngine;
@end

@implementation GPCMediaFilesSelectorDemo_2ViewController
- (instancetype)init
{
    if(self = [super init])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pictureSelectorNumSeletedUpdateNotification:) name:picSelectedNumNotification object:nil];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)loadView
{
    [super loadView];
    
    self.topHeaderView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), [GPCTopNaviHeaderView getTopNaviHeaderViewHeight:YES]);
    
    self.photoGridView.frame = CGRectMake(0, CGRectGetMaxY(self.topHeaderView.frame), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - CGRectGetHeight(self.topHeaderView.frame));
    
    __weak typeof (self) weakSelf = self;
    [self.pictureSelectorEngine loadAllPhotos:^(PhotoSelectorAuthorizationStatus authonsizeState, GPCMediaFilesSelectorPhotoCaseDataSource *photoDataSource) {
        if(authonsizeState == PhotoSelectorAuthorizationStatusAuthorized)
        {
            weakSelf.photoGridView.caseSource = photoDataSource;
            [weakSelf.photoGridView reloadData];
            [weakSelf.photoGridView preLoadAssetsWhenViewDidAppear];
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

- (GPCMediaFilesSelectorDemo_2GalleryView*)galleryView
{
    if(_galleryView == nil)
    {
        _galleryView = [GPCMediaFilesSelectorDemo_2GalleryView new];
        [self.view addSubview:_galleryView];
        
        __weak typeof (self) weakSelf = self;
        _galleryView.goBackBlock = ^(){
            [weakSelf hideAlbumFileListView];
        };
    }
    return _galleryView;
}

- (GPCMediaFilesSelectorEngine*)pictureSelectorEngine
{
    if(_pictureSelectorEngine == nil)
    {
        _pictureSelectorEngine = [GPCMediaFilesSelectorEngine new];
        _pictureSelectorEngine.bridge = [GPCMediaFilesSelectorWithTwoActionBridge new];
        __weak typeof (_pictureSelectorEngine) weakEngine = _pictureSelectorEngine;
        __weak typeof (self) weakSelf = self;
        
        //相册按钮点击
        _pictureSelectorEngine.bridge.galleryIconClickBlock = ^(){
            [weakEngine loadUserGallery:^(GPCMediaFilesSelectorGalleryCaseDataSource *galleryCaseDataSource) {
                weakSelf.galleryView.galleryDataSource = galleryCaseDataSource;
                [weakSelf.galleryView preLoadAssetsWhenViewDidAppear];
                [weakSelf.galleryView reloadGalleryView];
            }];
            
            [weakSelf showAlbumFileListView];
        };
        
        //拍摄照片
        _pictureSelectorEngine.bridge.takingPhotoIConClickBlock = ^(){
        
            GPCInputPhotoCameraHelper* cameraHelper = [GPCInputPhotoCameraHelper shareInstance];
            cameraHelper.takingPhotoBlock = ^(BOOL finished,UIImage* photo){
                if(finished)
                {
                    GPCMediaFilesSelectorPhotoCaseDataSource* gridDataSource = (GPCMediaFilesSelectorPhotoCaseDataSource*)weakSelf.photoGridView.caseSource;
                    [gridDataSource addTakingPhoto:photo];
                    [weakSelf.photoGridView reloadData];
                }
            };
            
            [cameraHelper showPhotoCameraViewController:weakSelf];
        };
        
        //选中某个相册
        _pictureSelectorEngine.bridge.galleryViewClickBlock = ^(GPCMediaFilesSelectorPhotoCaseDataSource* photoDataSource,NSString* galleryTitle){
            weakSelf.photoGridView.caseSource = photoDataSource;
            photoDataSource.bridge = weakEngine.bridge;
            [weakSelf.photoGridView reloadData];
            [weakSelf hideAlbumFileListView];
        };
    }
    return _pictureSelectorEngine;
}

- (GPCMediaFilesSelectorCollectionView*)photoGridView
{
    if(_photoGridView == nil)
    {
        _photoGridView = [[GPCMediaFilesSelectorCollectionView alloc] initWithBridgeClass:[GPCMediaFilesSelectorWithTwoActionBridge class]
                                                                          caseSourceClass:[GPCMediaFilesSelectorPhotoCaseDataSource class]];
        [self.view addSubview:_photoGridView];
    }
    return _photoGridView;
}

- (GPCTopNaviHeaderView*)topHeaderView
{
    if(_topHeaderView == nil)
    {
        _topHeaderView = [GPCTopNaviHeaderView new];
        _topHeaderView.backgroundColor = [UIColor whiteColor];
        _topHeaderView.statusBarShow = YES;
        _topHeaderView.midTitleLabel.text = @"照片";
        [_topHeaderView.rightButton setTitle:@"" forState:UIControlStateNormal];
        [self.view addSubview:_topHeaderView];
        
        __weak typeof (self) weakSelf = self;
        
        _topHeaderView.leftBtnClick = ^(){
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };
        _topHeaderView.rightBtnClick = ^(){
            [((GPCMediaFilesSelectorPhotoCaseDataSource*)weakSelf.photoGridView.caseSource) requestPicturesSelectedPreviewImages:weakSelf.requestPicturesSelectedBlock];
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };
    }
    return _topHeaderView;
}

-(void)showAlbumFileListView
{
    self.galleryView.frame = CGRectMake(CGRectGetWidth(self.view.bounds), CGRectGetMinY(self.photoGridView.frame), CGRectGetWidth(self.photoGridView.frame), CGRectGetHeight(self.photoGridView.frame));
    
    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.galleryView.frame = CGRectMake(0, CGRectGetMinY(weakSelf.photoGridView.frame), CGRectGetWidth(weakSelf.photoGridView.frame), CGRectGetHeight(weakSelf.photoGridView.frame));
    } completion:nil];
}

-(void)hideAlbumFileListView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.galleryView.frame = CGRectMake(CGRectGetWidth(self.view.bounds), CGRectGetMinY(self.photoGridView.frame), CGRectGetWidth(self.photoGridView.frame), CGRectGetHeight(self.photoGridView.frame));
    } completion:nil];
}

#pragma mark--选中照片数量更新通知
- (void)pictureSelectorNumSeletedUpdateNotification:(NSNotification*)notification
{
    NSDictionary* info = notification.userInfo;
    NSNumber* numSelected = info[selectedNumUpdateKey];
    NSString* title = nil;
    if([numSelected integerValue] == 0)
    {
       title = @"完成";
    }else
    {
        title = [NSString stringWithFormat:@"完成(%ld)",(long)[numSelected integerValue]];
    }
    
    [self.topHeaderView.rightButton setTitle:title forState:UIControlStateNormal];
    if([GPCMediaFilesSelectorUtilityHelper GetCurrentSystemVersion] < 8.0 )
    {
        self.topHeaderView.rightButton.titleLabel.text = title;
    }
    [self.topHeaderView setNeedsLayout];
}
@end
