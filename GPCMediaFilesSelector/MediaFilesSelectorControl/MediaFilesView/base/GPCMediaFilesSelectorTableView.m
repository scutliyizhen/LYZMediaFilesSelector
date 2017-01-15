//
//  GPCMediaFilesSelectorTableView.m
//  GPCProject
//
//  Created by 李义真 on 2016/12/5.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCMediaFilesSelectorTableView.h"
#import "GPCMediaFilesSelectorUtilityHelper.h"
#import "GPCMediaFilesSelectorCase.h"
#import "GPCMediaFilesSelectorCellView.h"
#import "GPCMediaFilesSelectorPhotoCase.h"
#import "GPCMediaFilesSelectorPhotoCellView.h"
#import "GPCMediaFilesSelectorActionCase.h"
#import "GPCMediaFilesSelectorActionCellView.h"
#import "GPCMediaFilesSelectorAlbumCase.h"
#import "GPCMediaFilesSelectorGalleryCellView.h"

#define GPC_BOTTOM_CONTENT_VIEW_TAG (10000)

static NSString* GPCInputGalleryNullCellViewIdentifier = @"gpcInputGalleryNullCellViewIdentifier";

@interface GPCMediaFilesSelectorTableView()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property(nonatomic,strong,readwrite)UITableView* tableView;
@property(nonatomic,assign)CGRect previorsPreHeatRect;
@end

@implementation GPCMediaFilesSelectorTableView
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.previorsPreHeatRect = CGRectZero;
    }
    return self;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (UITableView*)tableView
{
    if(_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_tableView];
    }
    return _tableView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}

- (void)reloadData
{
    [self.tableView reloadData];
}

- (void)preLoadAssetsWhenViewDidAppear
{
    [self updateCachedAlbums];
}

#pragma mark--UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(numberOfSectionsInTableView:)])
    {
        return [self.delegate numberOfSectionsInTableView:tableView];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(tableView:numberOfRowsInSection:)])
    {
        return [self.delegate tableView:tableView numberOfRowsInSection:section];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)])
    {
        return [self.delegate tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(tableView:cellIdentifierForRowAtIndexPath:)])
    {
        NSString*  cellIdentifier = [self.delegate tableView:tableView cellIdentifierForRowAtIndexPath:indexPath];
        NSAssert(cellIdentifier != nil, @"tableView cellIdentifier == nil");
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        UIView* contentView = [cell.contentView viewWithTag:GPC_BOTTOM_CONTENT_VIEW_TAG];
        if(contentView == nil)
        {
            if(self.delegate &&
               [self.delegate respondsToSelector:@selector(tableView:cellContentViewForRowAtIndexPath:)])
            {
                UIView* cellContentView = [self.delegate tableView:tableView cellContentViewForRowAtIndexPath:indexPath];
                contentView = cellContentView;
                contentView.frame = cell.contentView.bounds;
                contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
                contentView.tag = GPC_BOTTOM_CONTENT_VIEW_TAG;
                [cell.contentView addSubview:cellContentView];
            }
        }
        
        if([contentView isKindOfClass:[GPCMediaFilesSelectorCellView class]] && [self.delegate respondsToSelector:@selector(tableView:selectorCaseForRowAtIndexPath:)])
        {
            GPCMediaFilesSelectorCase* selectorCase = [self.delegate tableView:tableView selectorCaseForRowAtIndexPath:indexPath];
            if([contentView isKindOfClass:[GPCMediaFilesSelectorPhotoCellView class]])
            {
                GPCMediaFilesSelectorPhotoCellView* photoCellView = (GPCMediaFilesSelectorPhotoCellView*)contentView;
                if([selectorCase isKindOfClass:[GPCMediaFilesSelectorPhotoCase class]])
                {
                    GPCMediaFilesSelectorPhotoCase* photoCase = (GPCMediaFilesSelectorPhotoCase*)selectorCase;
                     photoCellView.photoCase = photoCase;
                     photoCase.photoCellView = photoCellView;
                    
                    if(photoCase.iconImage)
                    {
                        photoCellView.highQualityImage = photoCase.iconImage;
                    }else
                    {
                        __weak GPCMediaFilesSelectorPhotoCellView* weakPhotoCellView = photoCellView;
                        if(self.tableView.dragging == NO && self.tableView.decelerating == NO)
                        {
                            photoCase.options.deliveryMode = PhotoCaseRequestOptionDeliveryModeOpportunisticMode;
                            [photoCase requestUpdateIconImage:^(UIImage *image,BOOL isFastImage,GPCMediaFilesSelectorCase* selectorCase ,NSDictionary *info) {
                                weakPhotoCellView.highQualityImage = image;
                            }];
                        }else
                        {
                            photoCase.options.deliveryMode = PhotoCaseRequestOptionDeliveryModeFastMode;
                            [photoCase requestUpdateIconImage:^(UIImage *image,BOOL isFastImage,GPCMediaFilesSelectorCase* selectorCase,NSDictionary *info) {
                                weakPhotoCellView.fastImage = image;
                            }];
                        }
                    }

                }
            }
            
            if([contentView isKindOfClass:[GPCMediaFilesSelectorActionCellView class]])
            {
                GPCMediaFilesSelectorActionCellView* actionCellView = (GPCMediaFilesSelectorActionCellView*)contentView;
                if([selectorCase isKindOfClass:[GPCMediaFilesSelectorActionCase class]])
                {
                    GPCMediaFilesSelectorActionCase* actionCase = (GPCMediaFilesSelectorActionCase*)selectorCase;
                    actionCase.actionCellView = actionCellView;
                    actionCellView.actionCase = actionCase;
                }
                if(selectorCase.iconImage)
                {
                    actionCellView.picImgView.image = selectorCase.iconImage;
                }else
                {
                    __weak GPCMediaFilesSelectorActionCellView* weakActionCellView = actionCellView;
                    [selectorCase requestUpdateIconImage:^(UIImage *image,BOOL isFastImage,GPCMediaFilesSelectorCase* selectorCase  ,NSDictionary *info) {
                        weakActionCellView.picImgView.image = image;
                    }];
                }
            }
            
            if([contentView isKindOfClass:[GPCMediaFilesSelectorGalleryCellView class]])
            {
                GPCMediaFilesSelectorGalleryCellView* galleryCellView = (GPCMediaFilesSelectorGalleryCellView*)contentView;
                if([selectorCase isKindOfClass:[GPCMediaFilesSelectorAlbumCase class]])
                {
                    GPCMediaFilesSelectorAlbumCase* galleryCase = (GPCMediaFilesSelectorAlbumCase*)selectorCase;
                    galleryCase.galleryCellView = galleryCellView;
                    galleryCellView.galleryCase = galleryCase;
                }
                if(selectorCase.iconImage)
                {
                    galleryCellView.imageView.image = selectorCase.iconImage;
                }else
                {
                    __weak GPCMediaFilesSelectorGalleryCellView* weakGalleryCellView = galleryCellView;
                    [selectorCase requestUpdateIconImage:^(UIImage *image,BOOL isFastImage,GPCMediaFilesSelectorCase* selectorCase ,NSDictionary *info) {
                        weakGalleryCellView.imageView.image = image;
                    }];
                }
            }
        }
        
        return cell;
    }else
    {
        return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GPCInputGalleryNullCellViewIdentifier];
    }
}

#pragma mark--对屏幕上可见cell 加载照片
- (void)loadIMagesForOnScreenRows
{
    NSArray<UITableViewCell*>* cellList = self.tableView.visibleCells;
    [cellList enumerateObjectsUsingBlock:^(UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView* contentView = [obj.contentView viewWithTag:10000];
        if([contentView isKindOfClass:[GPCMediaFilesSelectorPhotoCellView class]])
        {
            GPCMediaFilesSelectorPhotoCellView* photoCellView = (GPCMediaFilesSelectorPhotoCellView*)contentView;
            __weak GPCMediaFilesSelectorPhotoCellView* weakPhotoCellView = photoCellView;
            photoCellView.photoCase.options.deliveryMode = PhotoCaseRequestOptionDeliveryModeOpportunisticMode;
            [photoCellView.photoCase requestUpdateIconImage:^(UIImage *image,BOOL isFastImage,GPCMediaFilesSelectorCase* selectorCase  ,NSDictionary *info) {
                weakPhotoCellView.highQualityImage = image;
            }];
        }
        
        if([contentView isKindOfClass:[GPCMediaFilesSelectorGalleryCellView class]])
        {
            GPCMediaFilesSelectorGalleryCellView* galleryCellView = (GPCMediaFilesSelectorGalleryCellView*)contentView;
            __weak GPCMediaFilesSelectorGalleryCellView* weakGalleryCellView = galleryCellView;
            [galleryCellView.galleryCase requestUpdateIconImage:^(UIImage *image,BOOL isFastImage,GPCMediaFilesSelectorCase* selectorCase  ,NSDictionary *info) {
                weakGalleryCellView.imageView.image = image;
            }];
        }
        
        if([contentView isKindOfClass:[GPCMediaFilesSelectorActionCellView class]])
        {
            GPCMediaFilesSelectorActionCellView* actionCellView = (GPCMediaFilesSelectorActionCellView*)contentView;
            __weak GPCMediaFilesSelectorActionCellView* weakActionCellView = actionCellView;
            
            [actionCellView.actionCase requestUpdateIconImage:^(UIImage *image,BOOL isFastImage,GPCMediaFilesSelectorCase* selectorCase ,NSDictionary *info) {
                weakActionCellView.picImgView.image = image;
            }];
        }
    }];
}

#pragma mark--UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [self updateCachedAlbums];
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadIMagesForOnScreenRows];
}

- (void)updateCachedAlbums
{
        CGRect preHeatRect = self.tableView.bounds;
        preHeatRect = CGRectInset(preHeatRect, 0.0f, -0.5*CGRectGetHeight(preHeatRect));
        CGFloat delta = ABS(CGRectGetMidY(preHeatRect) - CGRectGetMidY(self.previorsPreHeatRect));
        if(delta > CGRectGetHeight(self.tableView.bounds))
        {
            NSArray<UITableViewCell*>* cellList = [self.tableView visibleCells];
            [cellList enumerateObjectsUsingBlock:^(UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
                            }];
            __weak typeof (self) weakSelf = self;
            [self computeDifferenceBetweenRect:self.previorsPreHeatRect andRect:preHeatRect removedHandler:^(CGRect removedRect) {
                NSArray<NSIndexPath*>* indexList = [weakSelf.tableView indexPathsForRowsInRect:removedRect];
                [indexList enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
                    UITableViewCell* cell = [weakSelf.tableView cellForRowAtIndexPath:obj];
                    [weakSelf startOrStopRequestImage:NO cell:cell];
                }];
                
            } addedHandler:^(CGRect addedRect) {
                NSArray<NSIndexPath*>* indexList = [weakSelf.tableView indexPathsForRowsInRect:addedRect];
                [indexList enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                     UITableViewCell* cell = [weakSelf.tableView cellForRowAtIndexPath:obj];
                    [weakSelf startOrStopRequestImage:YES cell:cell];
                }];
            }];
        }
    
}

- (void)startOrStopRequestImage:(BOOL)start cell:(UITableViewCell*)cell
{
//    UIView* contentView = [cell viewWithTag:GPC_BOTTOM_CONTENT_VIEW_TAG];
//    if([contentView isKindOfClass:[GPCMediaFilesSelectorPhotoCellView class]])
//    {
//        GPCMediaFilesSelectorPhotoCellView* photoCellView = (GPCMediaFilesSelectorPhotoCellView*)contentView;
//        if(start)
//        {
//            [photoCellView.photoCase startRequestIconImage];
//        }else
//        {
//            [photoCellView.photoCase stopRequestIConImage];
//        }
//    }
//    
//    if([contentView isKindOfClass:[GPCMediaFilesSelectorGalleryCellView class]])
//    {
//        GPCMediaFilesSelectorGalleryCellView* galleryCellView = (GPCMediaFilesSelectorGalleryCellView*)contentView;
//        if(start)
//        {
//            [galleryCellView.galleryCase startRequestIconImage];
//        }else
//        {
//            [galleryCellView.galleryCase stopRequestIConImage];
//        }
//    }
//    
//    if([contentView isKindOfClass:[GPCMediaFilesSelectorActionCellView class]])
//    {
//        GPCMediaFilesSelectorActionCellView* actionCellView = (GPCMediaFilesSelectorActionCellView*)contentView;
//        if(start)
//        {
//            [actionCellView.actionCase startRequestIconImage];
//        }else
//        {
//            [actionCellView.actionCase stopRequestIConImage];
//        }
//    }
}

- (void)computeDifferenceBetweenRect:(CGRect)oldRect andRect:(CGRect)newRect
                      removedHandler:(void (^)(CGRect removedRect))removedHandler
                        addedHandler:(void (^)(CGRect addedRect))addedHandler {
    if (CGRectIntersectsRect(newRect, oldRect)) {
        CGFloat oldMaxY = CGRectGetMaxY(oldRect);
        CGFloat oldMinY = CGRectGetMinY(oldRect);
        CGFloat newMaxY = CGRectGetMaxY(newRect);
        CGFloat newMinY = CGRectGetMinY(newRect);
        
        if (newMaxY > oldMaxY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY));
            addedHandler(rectToAdd);
        }
        
        if (oldMinY > newMinY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY));
            addedHandler(rectToAdd);
        }
        
        if (newMaxY < oldMaxY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY));
            removedHandler(rectToRemove);
        }
        
        if (oldMinY < newMinY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY));
            removedHandler(rectToRemove);
        }
    } else {
        addedHandler(newRect);
        removedHandler(oldRect);
    }
}
@end
