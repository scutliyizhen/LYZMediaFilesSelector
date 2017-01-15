//
//  GPCMediaFilesSelectorBridge.h
//  GPCProject
//
//  Created by 李义真 on 2016/12/3.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class GPCMediaFilesSelectorCase;

@class GPCMediaFilesSelectorPhotoCellView;
@class GPCMediaFilesSelectorPhotoCase;
@class GPCMediaFilesSelectorPhotoViewState;
@class GPCMediaFilesSelectorPhotoCaseDataSource;
typedef void(^GPCAddTakingPhotoOperationBlock)(BOOL success);
typedef GPCMediaFilesSelectorPhotoCase*(^GPCPhotoCaseByIndexInPhotoCaseSourceBlcok)(NSUInteger photoCaseIndex);

@class GPCMediaFilesSelectorActionCellView;
@class GPCMediaFilesSelectorActionCase;
@class GPCMediaFilesSelectorActionViewState;
@class GPCMediaFilesSelectorCaseDataSource;
typedef void(^GPCMediaFilesSelectorActionViewClickBlock)();

@class GPCMediaFilesSelectorGalleryCellView;
@class GPCMediaFilesSelectorAlbumCase;
@class GPCMediaFilesSelectorGalleryViewState;
@class GPCMediaFilesSelectorGalleryCaseDataSource;
typedef void(^GPCMediaFilesSelectorGalleryViewClickBlock)(GPCMediaFilesSelectorPhotoCaseDataSource* photoDataSource,NSString* galleryTitle);

@interface GPCMediaFilesSelectorBridge : NSObject
@property(nonatomic,assign)NSUInteger maxNumOfPicturesSeleted;//默认为4
@property(nonatomic,copy)GPCMediaFilesSelectorActionViewClickBlock galleryIconClickBlock;
@property(nonatomic,copy)GPCMediaFilesSelectorActionViewClickBlock takingPhotoIConClickBlock;
@property(nonatomic,copy)GPCMediaFilesSelectorGalleryViewClickBlock galleryViewClickBlock;
+ (UICollectionViewLayout*)getMediaFilesCollectionViewLayout;

+ (GPCMediaFilesSelectorPhotoCellView*)getMediaFilesPhotoCellView;
+ (GPCMediaFilesSelectorActionCellView*)getMediaFilesActionCellView;
+ (GPCMediaFilesSelectorGalleryCellView*)getMediaFilesGalleryCellView;

- (GPCMediaFilesSelectorPhotoViewState*)getSelectorPhotoCaseViewState:(NSUInteger)index;
- (GPCMediaFilesSelectorGalleryViewState*)getSelectorGalleryCaseViewState:(NSUInteger)index;
- (GPCMediaFilesSelectorActionViewState*)getSelectorActionCaseViewState:(NSUInteger)index;

//该方法为视图层提供数据源数目，由开发者可以在子类中重写
- (NSUInteger)numOfSelectorCaseInPhotoCaseSource:(NSUInteger)countOfPhotoCasePhotoLibrary
                          countOfTakingPhotoCase:(NSUInteger)countOfTakingPhotoCase;
//该方法为视图层提供数据源数目，由开发者可以在子类中重写
- (GPCMediaFilesSelectorCase*)getPictureSelectorCaseByIndex:(NSUInteger)index
                                         photoCaseSource:(GPCMediaFilesSelectorPhotoCaseDataSource*)photoCaseSource
                                    photoCaseSourceBlcok:(GPCPhotoCaseByIndexInPhotoCaseSourceBlcok)photoCaseSourceBlcok;
//照片cell的点击事件，对应GPCMediaFilesSelectorPhotoCase
- (void)photoCaseBindViewClickEvent:(UIView*)sender
                  cellView:(GPCMediaFilesSelectorPhotoCellView*)cellView
                      photoCase:(GPCMediaFilesSelectorPhotoCase*)photoCase;
// 该方法在拍摄照片完成后调用，开发者可以自己实现当拍照完成后的显示逻辑
- (void)addedTakingPhotoIntoCaseSource:(GPCMediaFilesSelectorPhotoCase*)photoCase
                              complete:(GPCAddTakingPhotoOperationBlock)complete;
//照片cell的点击事件，对应GPCMediaFilesSelectorActionCase
- (void)actionCaseBindViewClickEvent:(UIView*)sender
                            cellView:(GPCMediaFilesSelectorActionCellView*)cellView
                          actionCase:(GPCMediaFilesSelectorActionCase*)actionCase;
//照片cell的点击事件，对应GPCMediaFilesSelectorAlbumCase
- (void)galleryCaseBindViewClickEvent:(UIView*)sender
                             cellView:(GPCMediaFilesSelectorGalleryCellView*)cellView
                            albumCase:(GPCMediaFilesSelectorAlbumCase*)albumCase;
@end
