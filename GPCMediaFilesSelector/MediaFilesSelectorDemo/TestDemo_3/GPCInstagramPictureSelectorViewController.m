//
//  GPCInstagramPictureSelectorViewController.m
//  GameBible
//
//  Created by robertyzli on 16/7/23.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCTopNaviHeaderView.h"
#import "GPCInstagramGridView.h"
#import "GPCBigPictureBrowserView.h"
#import "GPCMediaFilesSelectorEngine.h"
#import "GPCInputPhotoCameraHelper.h"
#import "GPCMediaFilesSelectorUtilityHelper.h"
#import "GPCMediaFilesSelectorPhotoGalleryView.h"
#import "GPCInstagramPictureSelectorViewController.h"
#import "GPCMediaFilesSelectorWithOneActionBride.h"

#define GPC_NAVI_HEIGHT (44.0) //＋标题栏1px底线 richiepu 2016_05_19

@interface GPCInstagramPictureSelectorViewController ()
@property(nonatomic,strong)GPCTopNaviHeaderView* topHeaderView;
@property(nonatomic,strong)UIView* topHeaderLineView;
@property(nonatomic,strong)GPCInstagramGridView* photoGridView;
@property(nonatomic,strong)GPCMediaFilesSelectorPhotoGalleryView* galleryView;
@property(nonatomic,strong)GPCBigPictureBrowserView* bigPictureBrowser;
//选图engine
@property(nonatomic,strong)GPCMediaFilesSelectorEngine* pictureSelectorEngine;
//辅助view
@property(nonatomic,strong)UIView* panGestureView;
@property(nonatomic,strong)UIView* browserAndSelctorBgView;
//动画辅助rect,point
@property(nonatomic,assign)CGRect fullScreenFrame_BrSel;
@property(nonatomic,assign)CGRect hideScreenFrame_BrSel;
@property(nonatomic,assign)CGRect fullScreenGridFrame;//照片
@property(nonatomic,assign)CGRect hideScreemGridFrame;//照片
@property(nonatomic,assign)CGRect fullScreenFrameAlbumList;//相册列表
@property(nonatomic,assign)CGRect hideScreenFrameAlbumList;//相册列表

@property(nonatomic,assign)CGPoint gridViewPanContentOffSet;
@property(nonatomic,assign)CGPoint gridViewPanLasttransition;

@property(nonatomic,assign)BOOL isBrAndSelFullScreen;
@property(nonatomic,assign)BOOL isHasLoadGalleryDataSource;
@end

@implementation GPCInstagramPictureSelectorViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBColorC(0x9E9092);
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden: YES];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden: NO];
    self.navigationController.navigationBarHidden = NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)loadView
{
    [super loadView];
    [self layoutSubviewWhenLoadView];
    
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
    }];}

- (void)layoutSubviewWhenLoadView
{
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    self.isBrAndSelFullScreen = NO;
    //初始化图片预览与选择、照片列表全屏与半屏Frame
    self.fullScreenFrame_BrSel = CGRectMake(0, GPC_NAVI_HEIGHT - width,
                                            width, height + width - GPC_NAVI_HEIGHT);
    
    self.hideScreenFrame_BrSel = CGRectMake(0, GPC_NAVI_HEIGHT, width, height + width - GPC_NAVI_HEIGHT);
    
    self.fullScreenFrameAlbumList = CGRectMake(0, GPC_NAVI_HEIGHT,
                                               width, height - GPC_NAVI_HEIGHT);
    CGRect tmpHideAlbumFrame = self.fullScreenFrameAlbumList;
    tmpHideAlbumFrame.origin.y = GPC_NAVI_HEIGHT*2 -[GPCMediaFilesSelectorUtilityHelper getMainScreenBounds].size.height;
    self.hideScreenFrameAlbumList = tmpHideAlbumFrame;
    
    //照片格子表全屏与半屏的frame
    CGRect bigPicturePreviewFrame = CGRectMake(0, 0, width, width);
    self.hideScreemGridFrame = CGRectMake(0, CGRectGetMaxY(bigPicturePreviewFrame), width, CGRectGetHeight(self.fullScreenFrame_BrSel) - CGRectGetHeight(bigPicturePreviewFrame));
    CGRect gridFrame = self.hideScreemGridFrame;
    gridFrame.size.height = CGRectGetHeight(self.fullScreenFrame_BrSel) - CGRectGetMinY(self.hideScreemGridFrame);
    self.fullScreenGridFrame = gridFrame;
    
    //头部导航区域
    self.topHeaderView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), [GPCTopNaviHeaderView getTopNaviHeaderViewHeight:NO]);
    
    //导航view下的分割线
    self.topHeaderLineView.frame = CGRectMake(0, CGRectGetHeight(self.topHeaderView.bounds) - 0.5, CGRectGetWidth(self.topHeaderView.frame), 0.5);
    
    //大图预览与选图布局
    [self layoutBroserAndSelectorRegion:self.isBrAndSelFullScreen];
    
    //大图预览
    self.bigPictureBrowser.frame = CGRectMake(0, 0, width, width);
    //大图预览上的手势view
    self.panGestureView.frame = self.bigPictureBrowser.frame;
    //照片格子
    self.photoGridView.frame = self.hideScreemGridFrame;
    
    //相册列表
    self.galleryView.frame = self.hideScreenFrameAlbumList;
}

- (void)layoutBroserAndSelectorRegion:(BOOL)isFullScreen
{
    if(isFullScreen)
    {
        //y值就是导航的高度－大图预览区域的高度
        self.browserAndSelctorBgView.frame = self.fullScreenFrame_BrSel;
        self.panGestureView.backgroundColor = RGBAColor(0x00, 0x00, 0x00, 0.6);
        self.photoGridView.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }else
    {
        self.browserAndSelctorBgView.frame = self.hideScreenFrame_BrSel;
        self.panGestureView.backgroundColor = [UIColor clearColor];
        CGFloat bottomOffset = CGRectGetMaxY(self.browserAndSelctorBgView.frame) - self.view.bounds.size.height;
        self.photoGridView.collectionView.contentInset = UIEdgeInsetsMake(0, 0, bottomOffset, 0);
    }
}

- (void)midRightButtonClick
{
    __weak typeof (self) weakself = self;
    
    [self.view bringSubviewToFront:self.topHeaderView];
    if(CGRectEqualToRect(self.fullScreenFrameAlbumList, self.galleryView.frame))
    {
        [UIView animateWithDuration:0.25 animations:^{
            
            weakself.topHeaderView.midButton.midImageView.transform = CGAffineTransformMakeRotation(0*M_PI/180);
        
            weakself.galleryView.frame = weakself.hideScreenFrameAlbumList;
            
        } completion:^(BOOL finished) {
            [weakself.galleryView removeFromSuperview];
        }];
    }else
    {
          [self.view insertSubview:self.galleryView belowSubview:self.topHeaderView];
        [UIView animateWithDuration:0.25 animations:^{
            
             weakself.galleryView.frame = weakself.fullScreenFrameAlbumList;
            weakself.topHeaderView.midButton.midImageView.transform = CGAffineTransformMakeRotation(-180*M_PI/180);
            
        } completion:^(BOOL finished) {
            //NSLog(@"%@", NSStringFromCGPoint(_redView.layer.position));
        }];
    }
}

#pragma mark--(1)图片选择CollectionView拖动动画
- (void)handlePanForGridView:(UIPanGestureRecognizer*)panGesture
                  scrollView:(UIScrollView*)scrollView
{
    
    if(CGRectEqualToRect(self.fullScreenFrame_BrSel, self.browserAndSelctorBgView.frame)) return;//全屏状态下此手势屏蔽掉
    
    if([panGesture locationInView:self.view].y < CGRectGetMinY(self.hideScreenFrame_BrSel)
       + self.bigPictureBrowser.bounds.size.height - 20)
    {
        //禁止UIScrollView的滚动，开始整体移动
        
        scrollView.contentOffset = self.gridViewPanContentOffSet;
        
        //视图前置操作(预览view)
        [self.view bringSubviewToFront:self.browserAndSelctorBgView];
        
        CGPoint center = self.browserAndSelctorBgView.center;
        CGPoint translation = [panGesture translationInView:self.view];
        self.browserAndSelctorBgView.center = CGPointMake(center.x, center.y + translation.y);
    }else
    {
        //恢复UIScrollView的滚动，禁止整体移动
    }
    
    if(panGesture.state == UIGestureRecognizerStateEnded)
    {
        BOOL isUpDrag = self.gridViewPanLasttransition.y > 0 ? NO :YES;
        [self browserAndSelectorFullHalfWhenPanGesEndState:isUpDrag complete:^(BOOL isFinished) {
            scrollView.scrollEnabled = YES;
        }];
    }
    self.gridViewPanContentOffSet = scrollView.contentOffset;
    self.gridViewPanLasttransition = [panGesture translationInView:self.view];
    [panGesture setTranslation:CGPointZero inView:self.view];
}

- (void)browserAndSelectorFullHalfWhenPanGesEndState:(BOOL)isUpDrag  complete:(void(^)(BOOL isFinished))complete
{
    __weak typeof(self) weakSelf = self;
    CGFloat upDragBoundary = self.hideScreenFrame_BrSel.origin.y - 20.0;
    CGFloat downGragBoundary = self.fullScreenFrame_BrSel.origin.y + 20.0;
    BOOL isFullScreen = NO;
    if(isUpDrag)
    {
        //正在向上拖拽
        if(self.browserAndSelctorBgView.frame.origin.y < upDragBoundary)
        {
            isFullScreen = YES;
            self.photoGridView.frame = self.fullScreenGridFrame;
        }else
        {
            isFullScreen = NO;
            self.photoGridView.frame = self.hideScreemGridFrame;
        }
    }else
    {
        //正在向下拖拽
        if(self.browserAndSelctorBgView.frame.origin.y < downGragBoundary)
        {
            isFullScreen = YES;
            self.photoGridView.frame = self.fullScreenGridFrame;
        }else
        {
            isFullScreen = NO;
            self.photoGridView.frame = self.hideScreemGridFrame;
        }
    }
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [weakSelf layoutBroserAndSelectorRegion:isFullScreen];
    } completion:^(BOOL finished) {
        if(CGRectEqualToRect(weakSelf.browserAndSelctorBgView.frame, weakSelf.fullScreenFrame_BrSel))
        {
            weakSelf.isBrAndSelFullScreen = YES;
        }else
        {
            weakSelf.isBrAndSelFullScreen = NO;
        }
        if(complete)
        {
            complete(finished);
        }
    }];
}

#pragma mark--(2)全屏时点击蒙板激活半屏处理方法
- (void)handleTap:(UITapGestureRecognizer*)recognizer
{
    if(CGRectEqualToRect(self.browserAndSelctorBgView.frame, self.fullScreenFrame_BrSel))
    {
        [self browserAndSelctorBgViewTransDownAnimation];
    }
}

- (void)browserAndSelctorBgViewTransDownAnimation
{
    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [weakSelf layoutBroserAndSelectorRegion:NO];
    } completion:^(BOOL finished) {
        if(CGRectEqualToRect(weakSelf.browserAndSelctorBgView.frame, self.fullScreenFrame_BrSel))
        {
            weakSelf.isBrAndSelFullScreen = YES;
        }else
        {
            weakSelf.isBrAndSelFullScreen = NO;
        }
    }];
}

#pragma mark--(3)拖动图片预览激活全屏与半屏
- (void)handlePan:(UIPanGestureRecognizer*)recognizer
{
    CGRect currentFrame = self.browserAndSelctorBgView.frame;
    CGPoint translation = [recognizer translationInView:self.view];
    
    if(currentFrame.origin.y + translation.y > self.hideScreenFrame_BrSel.origin.y ||
       currentFrame.origin.y + translation.y < self.fullScreenFrame_BrSel.origin.y)
    {
        
        [recognizer setTranslation:CGPointZero inView:self.view];
        return;
    }
    
    //视图前置操作(预览view)
    [self.view bringSubviewToFront:self.browserAndSelctorBgView];
    
    CGPoint center = self.browserAndSelctorBgView.center;
    self.browserAndSelctorBgView.center = CGPointMake(center.x, center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:self.view];
    
    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        [self browserAndSelectorFullHalfWhenPanGesEndState:nil];
    }
}

- (void)browserAndSelectorFullHalfWhenPanGesEndState:(void(^)(BOOL isFinished))complete
{
    __weak typeof(self) weakSelf = self;
    
    
    CGFloat scope = self.hideScreenFrame_BrSel.origin.y - self.fullScreenFrame_BrSel.origin.y;
    CGFloat upDownBoundary = self.hideScreenFrame_BrSel.origin.y - scope/5.0;
    BOOL isFullScreen = self.browserAndSelctorBgView.frame.origin.y < upDownBoundary ? YES : NO;//恢复到全屏
    
    if(isFullScreen)
    {
        self.photoGridView.frame = self.fullScreenGridFrame;
    }else
    {
        self.photoGridView.frame = self.hideScreemGridFrame;
    }
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        
        [weakSelf layoutBroserAndSelectorRegion:isFullScreen];
        
        
    } completion:^(BOOL finished) {
        if(CGRectEqualToRect(weakSelf.browserAndSelctorBgView.frame, weakSelf.fullScreenFrame_BrSel))
        {
            weakSelf.isBrAndSelFullScreen = YES;
        }else
        {
            weakSelf.isBrAndSelFullScreen = NO;
        }
        if(complete)
        {
            complete(finished);
        }
    }];
}

- (GPCMediaFilesSelectorEngine*)pictureSelectorEngine
{
    if(_pictureSelectorEngine == nil)
    {
        _pictureSelectorEngine = [GPCMediaFilesSelectorEngine new];
        
        GPCMediaFilesSelectorWithOneActionBride* bridge = [GPCMediaFilesSelectorWithOneActionBride new];
        __weak typeof (self) weakSelf = self;
        bridge.previewBlock = ^(UIImage* image){
            [weakSelf.bigPictureBrowser setImage:image];
            
            if(weakSelf.isBrAndSelFullScreen)
            {
                [weakSelf layoutBroserAndSelectorRegion:NO];
                weakSelf.isBrAndSelFullScreen = NO;
            }
        };
        _pictureSelectorEngine.bridge = bridge;
        __weak typeof (_pictureSelectorEngine) weakEngine = _pictureSelectorEngine;
        _pictureSelectorEngine.bridge.galleryViewClickBlock = ^(GPCMediaFilesSelectorPhotoCaseDataSource* photoDataSource,NSString* galleryTitle){
            weakSelf.photoGridView.caseSource = photoDataSource;
            photoDataSource.bridge = weakEngine.bridge;
            [weakSelf.photoGridView preLoadAssetsWhenViewDidAppear];
            [weakSelf.photoGridView reloadData];
            
            weakSelf.topHeaderView.midButton.midImageView.transform = CGAffineTransformMakeRotation(0*M_PI/180);
            weakSelf.galleryView.frame = weakSelf.hideScreenFrameAlbumList;
            
            weakSelf.topHeaderView.midButton.midLable.text = galleryTitle;
        };
        
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
    }
    return _pictureSelectorEngine;
}

- (UIView*)topHeaderLineView
{
    if(_topHeaderLineView == nil)
    {
        _topHeaderLineView = [UIView new];
        _topHeaderLineView.backgroundColor = RGBColorC(0x9E9092);
        [self.topHeaderView addSubview:_topHeaderLineView];
    }
    return _topHeaderLineView;
}

- (GPCTopNaviHeaderView*)topHeaderView
{
    if(_topHeaderView == nil)
    {
        _topHeaderView = [GPCTopNaviHeaderView new];
        _topHeaderView.backgroundColor = [UIColor whiteColor];
        _topHeaderView.statusBarShow = NO;
        _topHeaderView.isMidButton = YES;
        _topHeaderView.midButton.midImageView.image = [UIImage imageNamed:@"gpc_pictureSelector_photo_drag_down_arrow.png"];
        _topHeaderView.midButton.midLable.text = @"全部照片";
        [_topHeaderView.rightButton setTitle:@"" forState:UIControlStateNormal];
        [self.view addSubview:_topHeaderView];
        
        __weak typeof (self) weakSelf = self;
        
        _topHeaderView.leftBtnClick = ^(){
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };
        _topHeaderView.middleBtnClick = ^(){
        
            [weakSelf midRightButtonClick];
        };
    }
    return _topHeaderView;
}

- (GPCInstagramGridView*)photoGridView
{
    if(_photoGridView == nil)
    {
        _photoGridView = [[GPCInstagramGridView alloc] initWithBridgeClass:[GPCMediaFilesSelectorWithOneActionBride class]
                                                           caseSourceClass:[GPCMediaFilesSelectorPhotoCaseDataSource class]];
        [self.browserAndSelctorBgView addSubview:_photoGridView];
        
        __weak typeof (self) weakSelf = self;
        _photoGridView.panGesBlock = ^(UIPanGestureRecognizer* panGesture,UIScrollView* scrollView){
            [weakSelf handlePanForGridView:panGesture scrollView:scrollView];
        };
        
        _photoGridView.srollViewUpDownDrag = ^(BOOL isUpDrag){
            if(CGRectEqualToRect(weakSelf.photoGridView.frame, weakSelf.fullScreenGridFrame) && isUpDrag == NO)
            {
                [weakSelf browserAndSelctorBgViewTransDownAnimation];
            }
        };
    }
    return _photoGridView;
}

- (GPCMediaFilesSelectorPhotoGalleryView*)galleryView
{
    if(_galleryView == nil)
    {
        _galleryView = [[GPCMediaFilesSelectorPhotoGalleryView alloc] initWithBridgeClass:[GPCMediaFilesSelectorWithOneActionBride class]
                                                                          caseSourceClass:[GPCMediaFilesSelectorGalleryCaseDataSource class]];
        _galleryView.backgroundColor = [UIColor whiteColor];
        
         __weak typeof (self) weakSelf = self;
        if(self.isHasLoadGalleryDataSource == NO)
        {
            [self.pictureSelectorEngine loadUserGallery:^(GPCMediaFilesSelectorGalleryCaseDataSource *galleryDataSource) {
                weakSelf.galleryView.galleryDataSource = galleryDataSource;
                [weakSelf.galleryView preLoadAssetsWhenViewDidAppear];
                [weakSelf.galleryView reloadData];
            }];
            
            self.isHasLoadGalleryDataSource = YES;
        }
    }
    return _galleryView;
}

- (UIView*)browserAndSelctorBgView
{
    if(_browserAndSelctorBgView == nil)
    {
        _browserAndSelctorBgView = [[UIView alloc] init];
        _browserAndSelctorBgView.backgroundColor = RGBColorC(0x9E9092);
        [self.view addSubview:_browserAndSelctorBgView];
    }
    
    return _browserAndSelctorBgView;
}

- (GPCBigPictureBrowserView*)bigPictureBrowser
{
    if(_bigPictureBrowser == nil)
    {
         _bigPictureBrowser = [[GPCBigPictureBrowserView alloc] initWithFrame:CGRectZero];
        [self.browserAndSelctorBgView addSubview:_bigPictureBrowser];
    }
    return _bigPictureBrowser;
}

- (UIView*)panGestureView
{
    if(_panGestureView == nil)
    {
        //滑动手势view
        _panGestureView = [[UIView alloc] init];
        
        UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [_panGestureView addGestureRecognizer:panGesture];
        [self.browserAndSelctorBgView insertSubview:_panGestureView aboveSubview:self.bigPictureBrowser];
    }
    return _panGestureView;
}
@end
