//
//  GPCMediaFilesSelectorBridge.m
//  GPCProject
//
//  Created by ‰π on 2016/12/3.
//  Copyright ¬© 2016Âπ Tencent. All rights reserved.
//

#import "GPCMediaFilesSelectorBridge.h"
#import "GPCMediaFilesSelectorUtilityHelper.h"

#import "GPCMediaFilesSelectorPhotoCase.h"
#import "GPCMediaFilesSelectorPhotoCellView.h"
#import "GPCMediaFilesSelectorPhotoViewState.h"
#import "GPCMediaFilesSelectorPhotoViewResponder.h"
#import "GPCMediaFilesSelectorPhotoCaseDataSource.h" 

#import "GPCMediaFilesSelectorActionCase.h"
#import "GPCMediaFilesSelectorActionViewState.h"
#import "GPCMediaFilesSelectorActionCellView.h"
#import "GPCMediaFilesSelectorActionViewResponder.h"

#import "GPCMediaFilesSelectorGalleryCellView.h"
#import "GPCMediaFilesSelectorGalleryViewState.h"
#import "GPCMediaFilesSelectorAlbumCase.h"
#import "GPCMediaFilesSelectorGalleryViewResponder.h"

@interface GPCMediaFilesSelectorBridge()
@property(nonatomic,strong)UIImage* selectedImage;
@property(nonatomic,strong)UIImage* unSelectedImage;
@end

@implementation GPCMediaFilesSelectorBridge
+ (UICollectionViewLayout*)getMediaFilesCollectionViewLayout
{
    return nil;
}

+ (GPCMediaFilesSelectorPhotoCellView*)getMediaFilesPhotoCellView
{
    return [[GPCMediaFilesSelectorPhotoCellView alloc]
            initWithResponderClass:[GPCMediaFilesSelectorPhotoViewResponder class]
                                                                        frame:CGRectZero];
}

+ (GPCMediaFilesSelectorActionCellView*)getMediaFilesActionCellView
{
    return [[GPCMediaFilesSelectorActionCellView alloc]
            initWithResponderClass:[GPCMediaFilesSelectorActionViewResponder class]
                                                                         frame:CGRectZero];
}

+ (GPCMediaFilesSelectorGalleryCellView*)getMediaFilesGalleryCellView
{
    return [[GPCMediaFilesSelectorGalleryCellView alloc]
            initWithResponderClass:[GPCMediaFilesSelectorGalleryViewResponder class]
                                                                          frame:CGRectZero];
}

- (instancetype)init
{
    if(self = [super init])
    {
        self.maxNumOfPicturesSeleted = 4;
        self.unSelectedImage = [UIImage imageNamed:@"gpc_pictureSelector_photo_unSelected.png"];
        self.selectedImage = [UIImage imageNamed:@"gpc_pictureSelector_photo_selected.png"];
    }
    return self;
}

- (GPCMediaFilesSelectorPhotoViewState*)getSelectorPhotoCaseViewState:(NSUInteger)index
{
    GPCMediaFilesSelectorPhotoViewState* viewState = [GPCMediaFilesSelectorPhotoViewState new];
    viewState.unSelectedIconImage = self.unSelectedImage;
    viewState.selectedIconImage = self.selectedImage;
	return viewState;
}

- (GPCMediaFilesSelectorGalleryViewState*)getSelectorGalleryCaseViewState:(NSUInteger)index
{
    GPCMediaFilesSelectorGalleryViewState* viewState = [GPCMediaFilesSelectorGalleryViewState new];
    return viewState;
}

- (GPCMediaFilesSelectorActionViewState*)getSelectorActionCaseViewState:(NSUInteger)index
{
    GPCMediaFilesSelectorActionViewState* viewSate = [GPCMediaFilesSelectorActionViewState new];
    return viewSate;
}

- (NSUInteger)numOfSelectorCaseInPhotoCaseSource:(NSUInteger)countOfPhotoCasePhotoLibrary countOfTakingPhotoCase:(NSUInteger)countOfTakingPhotoCase
{
    return countOfPhotoCasePhotoLibrary;
}

- (GPCMediaFilesSelectorCase*)getPictureSelectorCaseByIndex:(NSUInteger)index
                                         photoCaseSource:(GPCMediaFilesSelectorPhotoCaseDataSource*)photoCaseSource
                                    photoCaseSourceBlcok:(GPCPhotoCaseByIndexInPhotoCaseSourceBlcok)photoCaseSourceBlcok
{
    GPCMediaFilesSelectorPhotoCase* photoCase = photoCaseSourceBlcok(index);
    __block GPCMediaFilesSelectorPhotoCase* tmpCase = nil;
    //查询是否在选中列表中
    [photoCaseSource.photoCaseListSelected enumerateObjectsUsingBlock:^(GPCMediaFilesSelectorPhotoCase * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([photoCase.photoKey isEqualToString:obj.photoKey])
        {
            tmpCase = obj;
        }
    }];
    if(tmpCase)
    {
        photoCase = tmpCase;
    }
    return photoCase;
}

- (void)photoCaseBindViewClickEvent:(UIView*)sender
                           cellView:(GPCMediaFilesSelectorPhotoCellView*)cellView
                          photoCase:(GPCMediaFilesSelectorPhotoCase*)photoCase
{
    if([cellView isKindOfClass:[GPCMediaFilesSelectorPhotoCellView class]])
    {
        photoCase.viewState.isPreviewIng = YES;
        [cellView updateSelectorCellState];
        if(photoCase != photoCase.photoDataSource.currentPrevingPhotoCase)
        {
            //取消上次预览
            GPCMediaFilesSelectorPhotoCase* lastPrevingPhotoCase = photoCase.photoDataSource.currentPrevingPhotoCase;
            lastPrevingPhotoCase.viewState.isPreviewIng = NO;
            [lastPrevingPhotoCase.photoCellView updateSelectorCellState];
            
            //记录本次预览
            photoCase.photoDataSource.currentPrevingPhotoCase = photoCase;
        }
        
        if(photoCase.viewState.isSelected)
        {
            [photoCase.photoDataSource deletePhotoCaseSelected:photoCase completed:^(BOOL success, NSArray<GPCMediaFilesSelectorPhotoCase *> *photoCaseListSelected) {
                if(success)
                {
                    [photoCaseListSelected enumerateObjectsUsingBlock:^(GPCMediaFilesSelectorPhotoCase * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if(obj.viewState.indexOfSelected > photoCase.viewState.indexOfSelected)
                        {
                            obj.viewState.indexOfSelected -= 1;
                            [obj.photoCellView updateSelectorCellState];
                        }
                    }];
                    
                    photoCase.viewState.isSelected = NO;
                    photoCase.viewState.numOfSelectedHidden = YES;
                    photoCase.viewState.indexOfSelected = 0;
                    [photoCase.photoCellView updateSelectorCellState];
                    //通知当前选中的数目
                    [[NSNotificationCenter defaultCenter] postNotificationName:picSelectedNumNotification object:nil userInfo:@{selectedNumUpdateKey:@(photoCaseListSelected.count)}];
                }
            }];
        }else
        {
            [photoCase.photoDataSource addPhotoCaseSelected:photoCase completed:^(BOOL success, NSArray<GPCMediaFilesSelectorPhotoCase *> *photoCaseListSelected) {
                if(success)
                {
                    //通知更新当前选中的数目
                    [[NSNotificationCenter defaultCenter] postNotificationName:picSelectedNumNotification object:nil userInfo:@{selectedNumUpdateKey:@(photoCaseListSelected.count)}];
                    
                    photoCase.viewState.isSelected = YES;
                     photoCase.viewState.numOfSelectedHidden = NO;
                    photoCase.viewState.indexOfSelected = photoCaseListSelected.count;
                    [photoCase.photoCellView updateSelectorCellState];
                }else
                {
                    NSUInteger maxNumSelected = self.maxNumOfPicturesSeleted;
                    [GPCMediaFilesSelectorUtilityHelper showTipsWithMessage:[NSString stringWithFormat:@"最多能选择%lu张",(unsigned long)maxNumSelected]];
                }
            }];
        }
    }
}

- (void)addedTakingPhotoIntoCaseSource:(GPCMediaFilesSelectorPhotoCase *)photoCase
                              complete:(GPCAddTakingPhotoOperationBlock)complete{  }

- (void)actionCaseBindViewClickEvent:(UIView*)sender
                            cellView:(GPCMediaFilesSelectorActionCellView*)cellView
                          actionCase:(GPCMediaFilesSelectorActionCase*)actionCase{  }

- (void)galleryCaseBindViewClickEvent:(UIView*)sender
                             cellView:(GPCMediaFilesSelectorGalleryCellView*)cellView
                            albumCase:(GPCMediaFilesSelectorAlbumCase*)albumCase
{
    if(self.galleryViewClickBlock)
    {
        self.galleryViewClickBlock(albumCase.photoDataSource,albumCase.viewState.galleryTitle);
    }
}
@end










