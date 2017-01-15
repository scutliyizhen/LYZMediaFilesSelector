//
//  GPCPictureSeletorDemo_1ViewController.m
//  GPCMediaFilesSelector
//
//  Created by robertyzli on 2016/11/23.
//  Copyright © 2016年 robertyzli. All rights reserved.
//

#import "GPCMediaFilesSeletorDemo_1ViewController.h"
#import "GPCMediaFilesSelectorPhotoCaseDataSource.h"
#import "GPCMediaFilesSelectorGridDemo_1ViewController.h"
#import "GPCMediaFilesSelectorGallertDemo_1ViewController.h"
#import "GPCMediaFilesSelectorVideoList_demo1ViewController.h"
#import "GPCMediaFilesSelectorGridDemo_1ViewController.h"
#import "GPCMediaFilesSelectorEngine.h"
#import "GPCMediaFilesSelectorBridge.h"

@interface GPCPictureSeletorDemo_1ViewController ()
@property(nonatomic,strong)GPCMediaFilesSelectorEngine* pictureSelectorEngine;//图片选择器Engine
@property(nonatomic,assign)GalleryListType currenTalleryType;
@end

@implementation GPCPictureSeletorDemo_1ViewController
- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //导航按钮
    UIButton* leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //九宫格
    UIButton* gridButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 70.0, 120, 140,40)];
    [gridButton setBackgroundColor:[UIColor blueColor]];
    [gridButton setTitle:@"默认相册" forState:UIControlStateNormal];
    [gridButton addTarget:self action:@selector(gridButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gridButton];
    
    //相册
    UIButton* galleryButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 70.0, 180, 140,40)];
    [galleryButton setBackgroundColor:[UIColor redColor]];
    [galleryButton setTitle:@"相册列表" forState:UIControlStateNormal];
    [galleryButton addTarget:self action:@selector(galleryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:galleryButton];
    
    //视频相册
    UIButton* videoGalleryButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 70.0, 240, 140,40)];
    [videoGalleryButton setBackgroundColor:[UIColor orangeColor]];
    [videoGalleryButton setTitle:@"视频相册" forState:UIControlStateNormal];
    [videoGalleryButton addTarget:self action:@selector(videoGalleryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:videoGalleryButton];
    
    //所有视频列表
    UIButton* videoListButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 70.0, 300, 140,40)];
    [videoListButton setBackgroundColor:[UIColor purpleColor]];
    [videoListButton setTitle:@"所有视频列表" forState:UIControlStateNormal];
    [videoListButton addTarget:self action:@selector(videoListButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:videoListButton];
    
    //所有LivePhoto列表
    UIButton* livePhotoListButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 70.0, 360, 140,40)];
    [livePhotoListButton setBackgroundColor:[UIColor brownColor]];
    [livePhotoListButton setTitle:@"所有LivePhoto" forState:UIControlStateNormal];
    [livePhotoListButton addTarget:self action:@selector(livePhotoGridButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:livePhotoListButton];
    
    //加载网络照片
    UIButton* downloadPictureButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 70.0, 420, 140,40)];
    [downloadPictureButton setBackgroundColor:[UIColor magentaColor]];
    [downloadPictureButton setTitle:@"网络图片加载" forState:UIControlStateNormal];
    [downloadPictureButton addTarget:self action:@selector(downloadPictureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downloadPictureButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.navigationController.navigationBarHidden = NO;
    self.title = @"媒体文件选择器";
}

- (GPCMediaFilesSelectorEngine*)pictureSelectorEngine
{
	if(_pictureSelectorEngine == nil)
    {
        _pictureSelectorEngine = [GPCMediaFilesSelectorEngine new];
        //设置GridView 所对应的DataSource
        _pictureSelectorEngine.bridge = [GPCMediaFilesSelectorBridge new];
        _pictureSelectorEngine.bridge.maxNumOfPicturesSeleted = 6;//如果不设置默认为4
     
        //相册点击事件
        __weak typeof (self) weakSelf = self;
        __weak typeof (_pictureSelectorEngine) weakEngine = _pictureSelectorEngine;
        _pictureSelectorEngine.bridge.galleryViewClickBlock = ^(GPCMediaFilesSelectorPhotoCaseDataSource* photoDataSource,NSString* galleryTitle)
        {
            photoDataSource.bridge = weakEngine.bridge;
            GPCMediaFilesSelectorGridDemo_1ViewController* gridViewController = [GPCMediaFilesSelectorGridDemo_1ViewController new];
            gridViewController.gridDataSource = photoDataSource;
            gridViewController.selectorEngine = weakSelf.pictureSelectorEngine;
            if(self.currenTalleryType == GalleryListType_Photo)
            {
                gridViewController.gridViewType = GridViewType_Photo;
            }
            
            if(self.currenTalleryType == GalleryListType_Video)
            {
                gridViewController.gridViewType = GridViewType_Video;
            }
            
            [weakSelf.navigationController pushViewController:gridViewController animated:YES];
        };
    }
    return _pictureSelectorEngine;
}

- (void)leftButtonClick:(UIButton*)btn
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)gridButtonClick:(UIButton*)btn
{
    GPCMediaFilesSelectorGridDemo_1ViewController* gridViewController = [GPCMediaFilesSelectorGridDemo_1ViewController new];
    gridViewController.selectorEngine = self.pictureSelectorEngine;
    [self.navigationController pushViewController:gridViewController animated:YES];
}

- (void)galleryButtonClick:(UIButton*)btn
{
    GPCMediaFilesSelectorGallertDemo_1ViewController* galleryViewController = [GPCMediaFilesSelectorGallertDemo_1ViewController new];
    galleryViewController.galleryListType = GalleryListType_Photo;
    self.currenTalleryType = GalleryListType_Photo;
    galleryViewController.selectorEngine = self.pictureSelectorEngine;
    [self.navigationController pushViewController:galleryViewController animated:YES];
}

- (void)videoListButtonClick:(UIButton*)btn
{
    GPCMediaFilesSelectorVideoList_demo1ViewController* galleryViewController = [GPCMediaFilesSelectorVideoList_demo1ViewController new];
    galleryViewController.selectorEngine = self.pictureSelectorEngine;
    [self.navigationController pushViewController:galleryViewController animated:YES];
}

- (void)livePhotoGridButtonClick:(UIButton*)btn
{
    __weak typeof (self) weakSelf = self;
    [self.pictureSelectorEngine loadAllLivePhotos:^(PhotoSelectorAuthorizationStatus authonsizeState, GPCMediaFilesSelectorPhotoCaseDataSource *photoDataSource) {
        if(authonsizeState == PhotoSelectorAuthorizationStatusAuthorized)
        {
            GPCMediaFilesSelectorGridDemo_1ViewController* livePhotoViewController = [GPCMediaFilesSelectorGridDemo_1ViewController new];
            livePhotoViewController.gridViewType = GridViewType_LivePhoto;
            livePhotoViewController.selectorEngine = weakSelf.pictureSelectorEngine;
            livePhotoViewController.gridDataSource = photoDataSource;
            [weakSelf.navigationController pushViewController:livePhotoViewController animated:YES];
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

- (void)downloadPictureButtonClick:(UIButton*)btn
{
	__weak typeof (self) weakSelf = self;
    NSArray* urlList = @[@"https://p.qpic.cn/GameBible/dx4Y70y9XctafLiadic1PbsErVNP3Wb2el/"
                         ,@"https://p.qpic.cn/GameBible/dx4Y70y9XctbSPvfPJFjABwhxqOiaW2Ag/"
                         ,@"https://p.qpic.cn/GameBible/dx4Y70y9Xcv6Q7xyAp2IT0IiahOPP3xfo/"
                         ,@"https://p.qpic.cn/GameBible/dx4Y70y9XcvCqIOq7NFCaXOEZwxXQc9v/"
                         ,@"https://p.qpic.cn/GameBible/dx4Y70y9Xcsj9hpJyqudiaoaEIM1LoUFC/"
                         ,@"https://p.qpic.cn/GameBible/dx4Y70y9XcsUQGNDfCHqeLPju1ohia6A0/"
                         ,@"https://p.qpic.cn/GameBible/dx4Y70y9XcvtoY6UKKz4LFxEoBNI5HvG/"
                         ,@"http://p.qpic.cn/GameBible/dx4Y70y9XcvmKaNeuzlVEWxu2cLTAjZG/108"
                         ,@"http://p.qpic.cn/GameBible/dx4Y70y9XcuHic9XRAksawtTY40KCIoRg/108"
                         ,@"http://p.qpic.cn/GameBible/dx4Y70y9Xcun6UFGYUyHtANpPMwP8uML/108"
                         ,@"http://p.qpic.cn/GameBible/dx4Y70y9XcuFZ62w0pu9HK9WvbKWicGmr/108"
                         ,@"http://p.qpic.cn/GameBible/dx4Y70y9Xcs0thS2TZic48GcytGYQ7SkA/108"
                         ,@"http://p.qpic.cn/GameBible/dx4Y70y9XcvbRNTW7HRZwibe2Hwwyu2RK/108"
                         ,@"http://p.qpic.cn/GameBible/dx4Y70y9XctpXBKKCia1NwPLIsXveUb1z/108"
                         ,@"http://p.qpic.cn/GameBible/dx4Y70y9XcsUOcWibjyVCCR3kV4tBwYvB/108"
                         ,@"http://q.qlogo.cn/qqapp/1105092508/D549BB8CCED08CDE6519F933B5D08439/100"
                         ,@"https://p.qpic.cn/GameBible/dx4Y70y9Xcsj9hpJyqudiaoaEIM1LoUFC/"
                         ,@"https://p.qpic.cn/GameBible/dx4Y70y9XcvCqIOq7NFCaXOEZwxXQc9v/"
                         ,@"https://p.qpic.cn/GameBible/dx4Y70y9Xcsj9hpJyqudiaoaEIM1LoUFC/"
                         ,@"https://p.qpic.cn/GameBible/dx4Y70y9XcsUQGNDfCHqeLPju1ohia6A0/"
                         ,@"https://p.qpic.cn/GameBible/dx4Y70y9XcvtoY6UKKz4LFxEoBNI5HvG/"
                         ,@"http://p.qpic.cn/GameBible/dx4Y70y9XcvmKaNeuzlVEWxu2cLTAjZG/108"
                         ,@"https://p.qpic.cn/GameBible/dx4Y70y9XcsUQGNDfCHqeLPju1ohia6A0/"
                         ,@"https://p.qpic.cn/GameBible/dx4Y70y9XcvtoY6UKKz4LFxEoBNI5HvG/"
                         ,@"http://p.qpic.cn/GameBible/dx4Y70y9XcvmKaNeuzlVEWxu2cLTAjZG/108"
                         ,@"http://p.qpic.cn/GameBible/dx4Y70y9XcuHic9XRAksawtTY40KCIoRg/108"
                         ,@"http://p.qpic.cn/GameBible/dx4Y70y9Xcun6UFGYUyHtANpPMwP8uML/108"
                         ,@"http://p.qpic.cn/GameBible/dx4Y70y9XcuFZ62w0pu9HK9WvbKWicGmr/108"
                         ,@"http://p.qpic.cn/GameBible/dx4Y70y9Xcs0thS2TZic48GcytGYQ7SkA/108"
                         ,@"http://p.qpic.cn/GameBible/dx4Y70y9XcvbRNTW7HRZwibe2Hwwyu2RK/108"
                         ,@"http://p.qpic.cn/GameBible/dx4Y70y9Xcun6UFGYUyHtANpPMwP8uML/108"
                         ,@"http://p.qpic.cn/GameBible/dx4Y70y9XcuFZ62w0pu9HK9WvbKWicGmr/108"
                         ,@"http://p.qpic.cn/GameBible/dx4Y70y9Xcs0thS2TZic48GcytGYQ7SkA/108"
                         ,@"http://p.qpic.cn/GameBible/dx4Y70y9XcvbRNTW7HRZwibe2Hwwyu2RK/108"
                         ,@"http://p.qpic.cn/GameBible/dx4Y70y9XctpXBKKCia1NwPLIsXveUb1z/108"
                         ,@"http://p.qpic.cn/GameBible/dx4Y70y9XcsUOcWibjyVCCR3kV4tBwYvB/108"
                         ,@"http://q.qlogo.cn/qqapp/1105092508/D549BB8CCED08CDE6519F933B5D08439/100"
                         ,@"https://p.qpic.cn/GameBible/dx4Y70y9Xcsj9hpJyqudiaoaEIM1LoUFC/"
                         ,@"https://p.qpic.cn/GameBible/dx4Y70y9XcvCqIOq7NFCaXOEZwxXQc9v/"
                         ,@"https://p.qpic.cn/GameBible/dx4Y70y9Xcsj9hpJyqudiaoaEIM1LoUFC/"
                         ,@"https://p.qpic.cn/GameBible/dx4Y70y9XcsUQGNDfCHqeLPju1ohia6A0/"
                         ,@"https://p.qpic.cn/GameBible/dx4Y70y9XcvtoY6UKKz4LFxEoBNI5HvG/"
                         ,@"http://p.qpic.cn/GameBible/dx4Y70y9XcvmKaNeuzlVEWxu2cLTAjZG/108"
                         ,@"https://p.qpic.cn/GameBible/dx4Y70y9XcsUQGNDfCHqeLPju1ohia6A0/"
                         ,@"https://p.qpic.cn/GameBible/dx4Y70y9XcvtoY6UKKz4LFxEoBNI5HvG/"
                         ,@"http://p.qpic.cn/GameBible/dx4Y70y9XcvmKaNeuzlVEWxu2cLTAjZG/108"
                         ,@"http://p.qpic.cn/GameBible/dx4Y70y9XctpXBKKCia1NwPLIsXveUb1z/108"
                         ,@"http://p.qpic.cn/GameBible/dx4Y70y9XcsUOcWibjyVCCR3kV4tBwYvB/108"
                         ,@"http://q.qlogo.cn/qqapp/1105092508/D549BB8CCED08CDE6519F933B5D08439/100"
                         ];
    
    
    NSMutableArray* urlModelList = [NSMutableArray new];
    [urlList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GPCMediaFilesSelectorDownloadPictureModel* model = [GPCMediaFilesSelectorDownloadPictureModel new];
        model.thumbnailImageURL = obj;
        model.bigImageURL = obj;
        [urlModelList addObject:model];
    }];
    
    [self.pictureSelectorEngine downloadPictuersWithURLs:urlModelList complete:^(PhotoSelectorAuthorizationStatus authonsizeState, GPCMediaFilesSelectorPhotoCaseDataSource *photoDataSource) {
        if(authonsizeState == PhotoSelectorAuthorizationStatusAuthorized)
        {
            GPCMediaFilesSelectorGridDemo_1ViewController* livePhotoViewController = [GPCMediaFilesSelectorGridDemo_1ViewController new];
            livePhotoViewController.gridViewType = GridViewType_DownloadPicture;
            livePhotoViewController.selectorEngine = weakSelf.pictureSelectorEngine;
            livePhotoViewController.gridDataSource = photoDataSource;
            [weakSelf.navigationController pushViewController:livePhotoViewController animated:YES];
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"没有相册权限，无法保存数据"
                                                           message:@"请打开 设置-隐私-照片 来进行设置"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

- (void)videoGalleryButtonClick:(UIButton*)btn
{
    GPCMediaFilesSelectorGallertDemo_1ViewController* galleryViewController = [GPCMediaFilesSelectorGallertDemo_1ViewController new];
    galleryViewController.galleryListType = GalleryListType_Video;
    self.currenTalleryType = GalleryListType_Video;
    galleryViewController.selectorEngine = self.pictureSelectorEngine;
    [self.navigationController pushViewController:galleryViewController animated:YES];
}
@end
