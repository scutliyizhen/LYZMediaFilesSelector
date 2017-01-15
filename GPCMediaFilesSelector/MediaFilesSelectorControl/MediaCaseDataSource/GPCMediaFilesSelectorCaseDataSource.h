//
//  GPCMediaFilesSelectorCaseDataSource.h
//  GameBible
//
//  Created by robertyzli on 16/7/16.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPCMediaFilesSelectorCase.h"
#import "GPCMediaFilesMetaDataBaseModel.h"
#import "GPCMediaFilesSelectorBaseFramework.h"

@class GPCMediaFilesSelectorBridge;
@class GPCMediaFilesSelectorPhotoCaseDataSource;
@class GPCMediaFilesSelectorGalleryCaseDataSource;

typedef void(^GPCGetPhotoCaseDataSouceBlock) (PhotoSelectorAuthorizationStatus authonsizeState,GPCMediaFilesSelectorPhotoCaseDataSource* photoDataSource);
typedef void(^GPCGetGalleyCaseDataSourceBlock)(GPCMediaFilesSelectorGalleryCaseDataSource* galleryDataSource);

@interface GPCMediaFilesSelectorDownloadPictureModel : NSObject
@property(nonatomic,strong)NSString* thumbnailImageURL;
@property(nonatomic,strong)NSString* bigImageURL;
@end

@interface GPCMediaFilesSelectorCaseDataSource : NSObject
{
    GPCMediaFilesMetaDataBaseModel* _metaDataModel;
}
@property (nonatomic,strong)GPCMediaFilesSelectorBridge* bridge;

+ (NSArray<NSString*>*)gridCellIdentifiers;
+ (NSString*)getIdentifierByModel:(GPCMediaFilesSelectorCase*)model;
+ (void)setThumPhotoSize:(CGSize)thumPhotoSize;

/*
 *加载网络图片相关接口
 */
+ (void)downloadPictuersWithURLs:(NSArray<GPCMediaFilesSelectorDownloadPictureModel*>*)URLs
                        complete:(GPCGetPhotoCaseDataSouceBlock)complete;

/*
 *本地相册照片相关接口
 */
//加载默认全部照片
+ (void)loadAllPhotos:(Class)photoCaseClass  complete:(GPCGetPhotoCaseDataSouceBlock)complete;
//加载相册列表
+ (void)loadUserGallery:(Class)galleryCaseClass complete:(GPCGetGalleyCaseDataSourceBlock)complete;
//加载视频列表
+ (void)loadUserVideoList:(Class)galleryCaseClass complete:(GPCGetGalleyCaseDataSourceBlock)complete;
//加载所有视频
+ (void)loadAllVideos:(Class)photoCaseClass  complete:(GPCGetPhotoCaseDataSouceBlock)complete;

+ (void)loadAllLivePhotos:(Class)photoCaseClass complete:(GPCGetPhotoCaseDataSouceBlock)complete;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithMetaDataPhotoModel:(GPCMediaFilesMetaDataBaseModel*)metaDataModel;
- (NSUInteger)numberOfPicureModels;
- (GPCMediaFilesSelectorCase*)getPictureSelectorModelInPictureListByIndex:(NSUInteger)index;
@end
