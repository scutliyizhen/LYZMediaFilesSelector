//
//  GPCMediaFilesSelectorBaseFramework.h
//  GameBible
//
//  Created by robertyzli on 16/7/14.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPCMediaFilesSelectorObserver.h"
#import <Photos/PhotosTypes.h>
#import "GPCMediaFilesMetaDataPhotoModel.h"
#import "GPCMediaFilesMetaDataGalleryModel.h"

typedef NS_ENUM(NSUInteger,PhotoSelectorAuthorizationStatus){
    PhotoSelectorAuthorizationStatusNotDetermined,
    PhotoSelectorAuthorizationStatusRestricted,
    PhotoSelectorAuthorizationStatusDenied,
    PhotoSelectorAuthorizationStatusAuthorized,
};

typedef NS_ENUM(NSUInteger,RequestImageDeliveryMode) {
    RequestImageDeliveryMode_Opportunistic,
    RequestImageDeliveryMode_Fast,
};

typedef void(^PhotoLibraryAuthorizedBlock)(PhotoSelectorAuthorizationStatus authorizationStatus);



@interface GPCRequestImageOption : NSObject
@property(nonatomic,assign)CGFloat thumbnailImageSizeScale;
@property(nonatomic,assign)RequestImageDeliveryMode deliveryMode;
@property(nonatomic,assign)BOOL isAsynchronous;
@end


@interface GPCMediaFilesSelectorBaseFramework : NSObject
{
    NSMutableArray<GPCMediaFilesSelectorObserver*>* _observerList;
}
@property(nonatomic,assign)CGSize assetGridThumbnailSize;

+ (instancetype)createLYZPhotoFramework;
- (NSArray<GPCMediaFilesSelectorObserver*>*)getObservers;

+ (void)authorizationStatusIsAuthorized:(PhotoLibraryAuthorizedBlock)handler;
- (void)regisertObeserverPhotoLibraryChanged:(id)observer
                     photoRequestTypeHandler:(PhotoRequestTypeBlock)photoRequestTypeHandler
                         photosReloadHandler:(PhotoLibraryChangedReload)photosReloadHandler
                      albumListReloadHandler:(PhotoLibraryAlbumListReload)albumListReloadHandler
                      photoAlbumIndexHandler:(PhotoAlbumIndexBlock)photoAlbumIndexHandler
                        photosChangedHandler:(PhotoLibraryPhotosChanged)photosChangedHandler;
- (void)unRegisterObserver:(id)observer;
//重置缓存
- (void)resetCachedAssets;

//加载所有照片
- (void)loadAllPhotos:(void(^)(BOOL finished,GPCMediaFilesMetaDataPhotoModel* metaPhotoModel))complete;
//缩略图请求
- (void)requestThumbnailImage:(GPCRequestImageOption*)option
        selectorCase:(GPCMediaFilesSelectorLocalPhotoCase*)selectorCase
        requestBlock:(RequestThumanailImageForIndexBlock)requestBlock;
- (void)startCachingImages:(NSArray<GPCMediaFilesSelectorLocalPhotoCase*>*)assetsStartCachingModels;
- (void)stopCachingImages:(NSArray<GPCMediaFilesSelectorLocalPhotoCase*>*)assetsStopCachingModels;
//预览图请求
- (void)requestPreviewImage:(CGSize)previewSize photoModel:(GPCMediaFilesSelectorLocalPhotoCase*)photoModel
               requestBlock:(RequestPreviewImageForAssets)requestBlock;
- (void)startCachingPreviewImage:(CGSize)previewSize photoModel:(GPCMediaFilesSelectorLocalPhotoCase*)photoModel;
- (void)stopCachingPreviewImage:(CGSize)previewSize photoModel:(GPCMediaFilesSelectorLocalPhotoCase*)photoModel;
//加载相册列表
- (void)loadUserPhotoAlbum:(void(^)(BOOL finished,GPCMediaFilesMetaDataGalleryModel* metaGallerysModel))complete;
- (void)startCachingGalleryImage:(CGSize)targetSize galleryModel:(GPCMediaFilesSelectorAlbumCase*)galleryModel;
- (void)stopCachingGalleryImage:(CGSize)targetSize galleryModel:(GPCMediaFilesSelectorAlbumCase*)galleryModel;
- (void)requestGalleryImage:(CGSize)targetSize galleryModel:(GPCMediaFilesSelectorAlbumCase*)galleryModel requestBlock:(RequestAlbumForIndexBlock)requestBlock;
//视频列表
- (void)loadAllVideos:(void(^)(BOOL finished,GPCMediaFilesMetaDataPhotoModel* metaPhotoModel))complete;
- (void)loadUserVideoList:(void(^)(BOOL finished,GPCMediaFilesMetaDataGalleryModel* metaGallerysModel))complete;
- (void)requestVideoWithLocalPhotoCase:(GPCMediaFilesSelectorLocalPhotoCase*)photoCase
                              complete:(RequestVideoBlock)complete;
//Live Photo
- (void)loadAllLivePhotos:(void(^)(BOOL finished,GPCMediaFilesMetaDataPhotoModel* metaPhotoModel))complete;
- (void)requestLivePhotoWithLocalPhotoCase:(CGSize)livePhotoSize
                                 photoCase:(GPCMediaFilesSelectorLocalPhotoCase*)photoCase
                                  complete:(RequestLivePhotoBlock)complete;;
@end
