//
//  GPCMediaFilesSelectorCollectionView.m
//  GPCProject
//
//  Created by ‰π on 2016/12/5.
//  Copyright ¬© 2016Âπ Tencent. All rights reserved.
//

#import "GPCMediaFilesSelectorCollectionView.h"
#import "GPCMediaFilesSelectorFrameworkManager.h"

#import "GPCMediaFilesSelectorCase.h"
#import "GPCMediaFilesSelectorCellView.h"

#import "GPCMediaFilesSelectorPhotoCase.h"
#import "GPCMediaFilesSelectorPhotoCellView.h"

#import "GPCMediaFilesSelectorActionCase.h"
#import "GPCMediaFilesSelectorActionCellView.h"

#import "GPCMediaFilesSelectorAlbumCase.h"
#import "GPCMediaFilesSelectorGalleryCellView.h"

#import "GPCMediaFilesSelectorUtilityHelper.h"
#import "GPCGridCollectionViewLayout.h"
#import "GPCMediaFilesSelectorBridge.h"

@interface GPCMediaFilesSelectorCollectionView()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDataSourcePrefetching,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>
@property(nonatomic,strong,readwrite)UICollectionView* collectionView;
@property(nonatomic,strong)GPCGridCollectionViewLayout* collectionViewLayout;

@property(nonatomic,assign)Class caseSourceClass;
@property(nonatomic,assign)Class bridgeClass;

@property(nonatomic,assign)CGRect previorsPreHeatRect;
@property(nonatomic,assign)CGFloat collectionScrollvelocity;
@end

@implementation GPCMediaFilesSelectorCollectionView
- (instancetype)initWithBridgeClass:(Class)bridgeClass caseSourceClass:(Class)caseSourceClass
{
    return [self initWithFrame:CGRectZero bridgeClass:bridgeClass caseSourceClass:caseSourceClass];
}

- (instancetype)initWithFrame:(CGRect)frame bridgeClass:(Class)bridgeClass caseSourceClass:(Class)caseSourceClass
{
	if(self = [super initWithFrame:frame])
    {
        [[GPCMediaFilesSelectorFrameworkManager shareInstance] resetCachedAssets];
        self.previorsPreHeatRect = CGRectZero;
        self.backgroundColor = RGBColorC(0xFFFFFF);
        self.bridgeClass = bridgeClass;
        self.caseSourceClass = caseSourceClass;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

- (void)preLoadAssetsWhenViewDidAppear
{
    self.collectionView.frame = self.bounds;
    [self.collectionViewLayout prepareLayout];
//    [self updateCachedAssets];
}

- (void)setSelectorCaseSourceClass:(Class)caseSourceClass
{
    self.caseSourceClass = caseSourceClass;
}

- (void)reloadData
{
    [_collectionViewLayout invalidateLayout];
    [self.collectionView reloadData];
}

- (UICollectionView*)collectionView
{
    if(_collectionView == nil)
    {
        UICollectionViewLayout* viewLayout = [self.bridgeClass getMediaFilesCollectionViewLayout];
        if(viewLayout == nil)
        {
            viewLayout = self.collectionViewLayout;
        }
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                   collectionViewLayout:viewLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.alwaysBounceVertical = YES;
//        _collectionView.prefetchDataSource = self;
//        _collectionView.prefetchingEnabled = YES;
        _collectionView.backgroundColor = [UIColor clearColor];;
        __weak typeof (_collectionView) weakCollectionView = _collectionView;
        
        NSAssert(self.caseSourceClass != nil, @"GPCMediaFilesSelectorCollectionView caseSourceClass = nil !!!");
        
        [[self.caseSourceClass gridCellIdentifiers] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [weakCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:obj];
        }];
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionViewCellIdentifier"];
        
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

- (GPCGridCollectionViewLayout*)collectionViewLayout
{
    if(_collectionViewLayout == nil)
    {
        _collectionViewLayout = [[GPCGridCollectionViewLayout alloc] init];
        _collectionViewLayout.cellHGap = 2.0;
        _collectionViewLayout.cellVGap = 2.0;
        _collectionViewLayout.numOfRow = 4;
        _collectionViewLayout.contentEdgeInsets = UIEdgeInsetsMake(2.0, 2.0, 2.0, 2.0);
        
        _collectionViewLayout.updateCellSizeBlock = ^(CGSize cellSize){[GPCMediaFilesSelectorCaseDataSource setThumPhotoSize:cellSize];};
    }
    return _collectionViewLayout;
}

#pragma mark--UICollectionViewDataSourcePrefetching
//- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
//{
//    NSLog(@"prefetchItemsAtIndexPaths List:%@",indexPaths);
//   __weak typeof (self) weakSelf = self;
//    //È¢ËΩΩÂ∞ÁÂ≠
//#ifdef GPC_SELECTOR_CASE_TEST
//   NSLog(@"prefetchItemsAtIndexPaths List:%@",indexPaths);
//#endif
//    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        GPCMediaFilesSelectorCase* selectorCase = [weakSelf.caseSource getPictureSelectorModelInPictureListByIndex:obj.row];
//        if([selectorCase isKindOfClass:[GPCMediaFilesSelectorPhotoCase class]])
//        {
//            GPCMediaFilesSelectorPhotoCase* photoCase = (GPCMediaFilesSelectorPhotoCase*)selectorCase;
//            photoCase.options.deliveryMode = PhotoCaseRequestOptionDeliveryModeFastMode;
//            [selectorCase startCachingThumbnailImage];
//        }
//    }];
//}
//
//- (void)collectionView:(UICollectionView *)collectionView cancelPrefetchingForItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
//{
//    __weak typeof (self) weakSelf = self;
//    //Ê∂ËØ∑Ê
//#ifdef GPC_SELECTOR_CASE_TEST
//   NSLog(@"cancelPrefetchingForItemsAtIndexPaths List:%@",indexPaths);
//#endif
//    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        GPCMediaFilesSelectorCase* selectorCase = [weakSelf.caseSource getPictureSelectorModelInPictureListByIndex:obj.row];
//        [selectorCase stopCachingThumbnailImage];
//    }];
//}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"willDisplayCell index:%ld",(long)indexPath.row);
    
    UIView* cellView = [cell.contentView viewWithTag:10000];
    if(cellView && [cellView isKindOfClass:[GPCMediaFilesSelectorPhotoCellView class]])
    {
        GPCMediaFilesSelectorPhotoCellView* photoCellView = (GPCMediaFilesSelectorPhotoCellView*)cellView;
        [photoCellView.photoCase startExposureOperation];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"didEndDisplayingCell index:%ld",(long)indexPath.row);
    
    UIView* cellView = [cell.contentView viewWithTag:10000];
    if(cellView && [cellView isKindOfClass:[GPCMediaFilesSelectorPhotoCellView class]])
    {
        GPCMediaFilesSelectorPhotoCellView* photoCellView = (GPCMediaFilesSelectorPhotoCellView*)cellView;
        [photoCellView.photoCase endExposureOperaion];
    }
}

#pragma mark--UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = [self.caseSource numberOfPicureModels];
    return count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"cellForItemAtIndexPath index:%ld",(long)indexPath.row);
    
    GPCMediaFilesSelectorCase* selectorCase = [self.caseSource getPictureSelectorModelInPictureListByIndex:indexPath.item];
    
    NSAssert(selectorCase != nil,@"GridView Cell Model == nil");
    
    NSString* identifier = [[self.caseSource class] getIdentifierByModel:selectorCase];
    
    NSAssert(identifier != nil,@"GridView identifier == nil ");
    
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier
                                                                           forIndexPath:indexPath];
    
    GPCMediaFilesSelectorCellView* cellView = [cell.contentView viewWithTag:10000];
    
    if(cellView == nil)
    {
        Class class = [selectorCase getObjectClass];
        
        cellView = [class createSelectorCaseCellView:self.bridgeClass];
        
        cellView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        cellView.frame = cell.contentView.bounds;
        
        cellView.tag = 10000;
        
        [cell.contentView addSubview:cellView];
    }
     //NSLog(@"cellForItemAtIndexPath row:%ld",(long)indexPath.row);
    if([selectorCase isKindOfClass:[GPCMediaFilesSelectorPhotoCase class]])
    {
        GPCMediaFilesSelectorPhotoCellView* photoCellView = (GPCMediaFilesSelectorPhotoCellView*)cellView;
        GPCMediaFilesSelectorPhotoCase* photoCase = (GPCMediaFilesSelectorPhotoCase*)selectorCase;
        photoCase.photoCellView = photoCellView;
        photoCellView.photoCase = photoCase;
        
        if(selectorCase.iconImage)
        {
            photoCellView.highQualityImage = selectorCase.iconImage;
        }else
        {
            //动态分辨率计算模型(a> 1, 0 < b < 1, m > 1)
            //(1). y = 1                 ( x = 0) 同步高分辨率
            //(2). y = 1                 ( 0 < x <= a + m)
            //(3). y = m/(x-a)-b         (a+m<x<=(a+m/b))
            //(4). y = b                 (a+m/b<x)
            float a = 3000;
            float b = 0.5;
            float m = 2;
            
            CGFloat thumbmailImageScale = 0;
            
            if(self.collectionScrollvelocity == 0)
            {
                thumbmailImageScale = 1.0;
            }else if (self.collectionScrollvelocity > 0 && self.collectionScrollvelocity <= (a + m))
            {
                thumbmailImageScale = 1.0;
            }else if (self.collectionScrollvelocity > (a + m) && self.collectionScrollvelocity <= (a + m/b))
            {
                thumbmailImageScale = m / (self.collectionScrollvelocity - a) - b;
            }else
            {
                thumbmailImageScale = b;
            }
            __weak GPCMediaFilesSelectorPhotoCellView* weakPhotoCellView = photoCellView;
            if(self.collectionView.dragging == NO && self.collectionView.decelerating == NO)
            {
                photoCase.options.deliveryMode = PhotoCaseRequestOptionDeliveryModeOpportunisticMode;
                photoCase.options.isAsynchronous = NO;
                photoCase.options.isSpecialRunloopMode = NO;
                [photoCase requestUpdateIconImage:^(UIImage *image,BOOL isFastImage, GPCMediaFilesSelectorCase* selectorCase ,NSDictionary *info) {
                    weakPhotoCellView.highQualityImage = image;
                }];
                
                [photoCellView.photoCase stayingOnScreenOperation];
            }else
            {
#ifdef GPC_SELECTOR_CASE_TEST
               NSLog(@"cellForItemAtIndexPath index:%d",indexPath.row);
#endif
                //NSLog(@"velocity:%f",self.collectionScrollvelocity);
                photoCase.options.isAsynchronous = YES;
                photoCase.options.thumbnailImageScale = thumbmailImageScale;
                if(self.collectionScrollvelocity < 1000)
                {
                    photoCase.options.deliveryMode = PhotoCaseRequestOptionDeliveryModeOpportunisticMode;
                    [photoCase requestUpdateIconImage:^(UIImage *image,BOOL isFastImage, GPCMediaFilesSelectorCase* selectorCase ,NSDictionary *info) {
                        weakPhotoCellView.highQualityImage = image;
                    }];
                }else
                {
                    photoCase.options.deliveryMode = PhotoCaseRequestOptionDeliveryModeFastMode;
                    [photoCase requestUpdateIconImage:^(UIImage *image,BOOL isFastImage, GPCMediaFilesSelectorCase* selectorCase ,NSDictionary *info) {
                        if(isFastImage)
                        {
                            weakPhotoCellView.fastImage = image;
                        }else
                        {
                            weakPhotoCellView.highQualityImage = image;
                        }
                    }];
                }
            }
        }
    }
    
    if([selectorCase isKindOfClass:[GPCMediaFilesSelectorActionCase class]])
    {
        GPCMediaFilesSelectorActionCellView* actionCellView = (GPCMediaFilesSelectorActionCellView*)cellView;
        GPCMediaFilesSelectorActionCase* actionCase = (GPCMediaFilesSelectorActionCase*)selectorCase;
        actionCase.actionCellView = actionCellView;
        actionCellView.actionCase = actionCase;
        
        if(actionCase.iconImage)
        {
            actionCellView.picImgView.image = selectorCase.iconImage;
        }else
        {
             __weak GPCMediaFilesSelectorActionCellView* weakActionCellView = actionCellView;
          	 [actionCase requestUpdateIconImage:^(UIImage *image,BOOL isFastImage ,GPCMediaFilesSelectorCase* selectorCase ,NSDictionary *info) {
                 weakActionCellView.picImgView.image = image;
             }];
        }
    }
    
    if([selectorCase isKindOfClass:[GPCMediaFilesSelectorAlbumCase class]])
    {
        GPCMediaFilesSelectorGalleryCellView* galleryCellView = (GPCMediaFilesSelectorGalleryCellView*)cellView;
        GPCMediaFilesSelectorAlbumCase* galleryCase = (GPCMediaFilesSelectorAlbumCase*)selectorCase;
        galleryCase.galleryCellView = galleryCellView;
        galleryCellView.galleryCase = galleryCase;
        
        if(galleryCase.iconImage)
        {
            galleryCellView.imageView.image = selectorCase.iconImage;
        }else
        {
            __weak GPCMediaFilesSelectorGalleryCellView* weakGalleryCellView = galleryCellView;
            [galleryCase requestUpdateIconImage:^(UIImage *image,BOOL isFastImage, GPCMediaFilesSelectorCase* selectorCase ,NSDictionary *info) {
                weakGalleryCellView.imageView.image = image;
            }];
        }
    }
    return cell;
}

#pragma mark-UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadIMagesForOnScreenRows];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //[self updateCachedAssets];

    static NSTimeInterval lastTime = 0;
    static CGFloat lastDisplacement = 0;
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    CGFloat nowDisplacement = scrollView.contentOffset.y;
    
    NSTimeInterval deltaTime = nowTime - lastTime;
    CGFloat displacementOffset = nowDisplacement - lastDisplacement;
    
    self.collectionScrollvelocity = ABS(displacementOffset / deltaTime);
    
    lastTime = nowTime;
    lastDisplacement = nowDisplacement;
}

#pragma mark--滚动停止时加载
- (void)loadIMagesForOnScreenRows
{
    NSArray<UICollectionViewCell*>* cellList = self.collectionView.visibleCells;
    [cellList enumerateObjectsUsingBlock:^(UICollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView* contentView = [obj.contentView viewWithTag:10000];
        if([contentView isKindOfClass:[GPCMediaFilesSelectorPhotoCellView class]])
        {
            GPCMediaFilesSelectorPhotoCellView* photoCellView = (GPCMediaFilesSelectorPhotoCellView*)contentView;
                __weak GPCMediaFilesSelectorPhotoCellView* weakPhotoCellView = photoCellView;
            photoCellView.photoCase.options.deliveryMode = PhotoCaseRequestOptionDeliveryModeOpportunisticMode;
            photoCellView.photoCase.options.isAsynchronous = NO;
            photoCellView.photoCase.options.isSpecialRunloopMode = YES;
            [photoCellView.photoCase requestUpdateIconImage:^(UIImage *image,BOOL isFastImage, GPCMediaFilesSelectorCase* selectorCase ,NSDictionary *info) {
                    weakPhotoCellView.highQualityImage = image;
                }];
            
            [photoCellView.photoCase stayingOnScreenOperation];
        }
        
        if([contentView isKindOfClass:[GPCMediaFilesSelectorGalleryCellView class]])
        {
            GPCMediaFilesSelectorGalleryCellView* galleryCellView = (GPCMediaFilesSelectorGalleryCellView*)contentView;
            __weak GPCMediaFilesSelectorGalleryCellView* weakGalleryCellView = galleryCellView;
            [galleryCellView.galleryCase requestUpdateIconImage:^(UIImage *image, BOOL isFastImage,GPCMediaFilesSelectorCase* selectorCase ,NSDictionary *info) {
                weakGalleryCellView.imageView.image = image;
            }];
        }
        
        if([contentView isKindOfClass:[GPCMediaFilesSelectorActionCellView class]])
        {
            GPCMediaFilesSelectorActionCellView* actionCellView = (GPCMediaFilesSelectorActionCellView*)contentView;
            __weak GPCMediaFilesSelectorActionCellView* weakActionCellView = actionCellView;
            
            [actionCellView.actionCase requestUpdateIconImage:^(UIImage *image,BOOL isFastImage, GPCMediaFilesSelectorCase* selectorCase ,NSDictionary *info) {
                weakActionCellView.picImgView.image = image;
            }];
        }
    }];
}

#pragma mark-滚动时
//- (void)updateCachedAssets
//{
//    CGRect preHeatRect = self.collectionView.bounds;
//    preHeatRect = CGRectInset(preHeatRect, 0.0f, -0.5*CGRectGetHeight(preHeatRect));
//    
//    CGFloat delta = ABS(CGRectGetMidY(preHeatRect) - CGRectGetMidY(self.previorsPreHeatRect));
//    if(delta >= 0.5 * CGRectGetHeight(self.collectionView.bounds))
//    {
//        __weak typeof (self) weakSelf = self;
//        [self computeDifferenceBetweenRect:self.previorsPreHeatRect
//                                   andRect:preHeatRect
//                            removedHandler:^(CGRect removedRect) {
//                                NSArray* attrs = [weakSelf.collectionView.collectionViewLayout
//                                                  layoutAttributesForElementsInRect:removedRect];
//                                [weakSelf stopRequstCellContentViewIconImage:attrs];
//                                
//                            } addedHandler:^(CGRect addedRect) {
//                                NSArray* attrs = [weakSelf.collectionView.collectionViewLayout layoutAttributesForElementsInRect:addedRect];
//                                [weakSelf startRequstCellContentViewIconImage:attrs];
//                            }];
//        self.previorsPreHeatRect = preHeatRect;
//    }
//    
//}

//- (void)stopRequstCellContentViewIconImage:(NSArray<UICollectionViewLayoutAttributes*>*)attrs
//{
//    __weak typeof (self) weakSelf = self;
//#ifdef GPC_SELECTOR_CASE_TEST
//    NSLog(@"updateCachedAssets removedList:%@",attrs);
//#endif
//    
//    //NSMutableArray* tmpList = [NSMutableArray new];
//    [attrs enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        GPCMediaFilesSelectorCase* selectorCase = [weakSelf.caseSource getPictureSelectorModelInPictureListByIndex:obj.indexPath.row];
//        //[tmpList addObject:selectorCase];
////        [selectorCase stopCachingThumbnailImage];
//    }];
//    
//    //[GPCMediaFilesSelectorCaseDataSource stopRequestIconImagesWithSelectorCases:tmpList];
//}

//- (void)startRequstCellContentViewIconImage:(NSArray<UICollectionViewLayoutAttributes*>*)attrs
//{
//    __weak typeof (self) weakSelf = self;
//    //ÂºÂßËØ∑Ê
//#ifdef GPC_SELECTOR_CASE_TEST
//    NSLog(@"updateCachedAssets addedList:%@",attrs);
//#endif
//    //NSMutableArray* tmpList = [NSMutableArray new];
//    [attrs enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        GPCMediaFilesSelectorCase* selectorCase = [weakSelf.caseSource getPictureSelectorModelInPictureListByIndex:obj.indexPath.row];
//        //[tmpList addObject:selectorCase];
////        [selectorCase startCachingThumbnailImage];
//    }];
//    
//    //[GPCMediaFilesSelectorCaseDataSource startRequestIconImagesWithSelectorCases:tmpList];
//}

//- (void)computeDifferenceBetweenRect:(CGRect)oldRect andRect:(CGRect)newRect
//                      removedHandler:(void (^)(CGRect removedRect))removedHandler
//                        addedHandler:(void (^)(CGRect addedRect))addedHandler {
//    if (CGRectIntersectsRect(newRect, oldRect)) {
//        CGFloat oldMaxY = CGRectGetMaxY(oldRect);
//        CGFloat oldMinY = CGRectGetMinY(oldRect);
//        CGFloat newMaxY = CGRectGetMaxY(newRect);
//        CGFloat newMinY = CGRectGetMinY(newRect);
//        
//        if (newMaxY > oldMaxY) {
//            CGRect rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY));
//            addedHandler(rectToAdd);
//        }
//        
//        if (oldMinY > newMinY) {
//            CGRect rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY));
//            addedHandler(rectToAdd);
//        }
//        
//        if (newMaxY < oldMaxY) {
//            CGRect rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY));
//            removedHandler(rectToRemove);
//        }
//        
//        if (oldMinY < newMinY) {
//            CGRect rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY));
//            removedHandler(rectToRemove);
//        }
//    } else {
//        addedHandler(newRect);
//        removedHandler(oldRect);
//    }
//}
@end
