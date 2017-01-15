//
//  GPCMediaFilesSelectorGridDemo_1ViewController.m
//  GPCMediaFilesSelector
//
//  Created by robertyzli on 2016/11/24.
//  Copyright ¬© 2016Âπ robertyzli. All rights reserved.
//

#import "GPCMediaFilesSelectorCollectionView.h"
#import "GPCMediaFilesSelectorBridge.h"
#import "GPCMediaFilesSelectorGridDemo_1ViewController.h"
#import "GPCPicturSelectorLivePhotoPreviewController.h"

@interface GPCMediaFilesSelectorGridDemo_1ViewController ()
@property(nonatomic,strong)GPCMediaFilesSelectorCollectionView* photoGridView;//‰πÂÆGridView
@end

@implementation GPCMediaFilesSelectorGridDemo_1ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.photoGridView.frame = CGRectMake(0, 64.0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 64.0);
    
    UIButton* rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if(self.gridDataSource == nil)
    {
        __weak typeof (self) weakSelf = self;
        [self.selectorEngine loadAllPhotos:^(PhotoSelectorAuthorizationStatus authonsizeState, GPCMediaFilesSelectorPhotoCaseDataSource *photoDataSource) {
            if(authonsizeState == PhotoSelectorAuthorizationStatusAuthorized)
            {
                weakSelf.photoGridView.caseSource = photoDataSource;
                [weakSelf.photoGridView preLoadAssetsWhenViewDidAppear];
                [weakSelf.photoGridView reloadData];
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
    }else
    {
        self.photoGridView.caseSource = self.gridDataSource;
        [self.photoGridView preLoadAssetsWhenViewDidAppear];
        [self.photoGridView reloadData];
    }
}

- (void)rightButtonClick:(UIButton*)btn
{
    //照片
    if(self.gridViewType == GridViewType_Photo)
    {
        [((GPCMediaFilesSelectorPhotoCaseDataSource*)self.photoGridView.caseSource) requestPicturesSelectedPreviewImages:^(NSArray<UIImage *> *imageList) {
            
            //DDLogDebug(@"ImageListSelected:%@",imageList);
            
        }];
        [self.navigationController popViewControllerAnimated:YES];
    }
    //视频
    if(self.gridViewType == GridViewType_Video)
    {
        [((GPCMediaFilesSelectorPhotoCaseDataSource*)self.photoGridView.caseSource) requestVideoOperation:^(NSArray<GPCMediaFilesSelectorVideoItem *> *videoList) {
            //DDLogDebug(@"videoListSelected:%@",videoList);
        }];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    //Live Photo
    __weak typeof (self) weakSelf = self;
    if(self.gridViewType == GridViewType_LivePhoto)
    {
        [((GPCMediaFilesSelectorPhotoCaseDataSource*)self.photoGridView.caseSource) requestLivePhotoOperation:^(NSArray<GPCMediaFilesSelectorLivePhotoItem *> *livePhotoList) {
            GPCPicturSelectorLivePhotoPreviewController* liveViewController = [GPCPicturSelectorLivePhotoPreviewController new];
            liveViewController.livePhotoItemList = livePhotoList;
            [weakSelf.navigationController pushViewController:liveViewController animated:YES];
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //解决控制器自动适配UScrollView在导航条隐藏情况下滚动适配的问题
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = NO;
    self.title = @"照片九宫格";
}

- (GPCMediaFilesSelectorCollectionView*)photoGridView
{
    if(_photoGridView == nil)
    {
        _photoGridView = [[GPCMediaFilesSelectorCollectionView alloc] initWithBridgeClass:[GPCMediaFilesSelectorBridge class]
                                                                          caseSourceClass:[GPCMediaFilesSelectorPhotoCaseDataSource class]];
        [self.view addSubview:_photoGridView];
    }
    return _photoGridView;
}
@end
