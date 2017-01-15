//
//  GPCMediaFilesSelectorBaseFramework.m
//  GameBible
//
//  Created by robertyzli on 16/7/14.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCMediaFilesSelectorBaseFramework.h"
#import "GPCMediaFilesSelectorUtilityHelper.h"
#import "GPCMediaFilesSelectorAbove8Framework.h"
#import "GPCMediaFilesSelectorBelow8Framework.h"

@implementation GPCRequestImageOption
@end

@implementation GPCMediaFilesSelectorBaseFramework
+ (instancetype)createLYZPhotoFramework
{
    if(GPC_IOS_SYSTEM_VERSION_GREATER_8_0)
    {
        return [[GPCMediaFilesSelectorAbove8Framework alloc] init];
    }else
    {
        return [[GPCMediaFilesSelectorBelow8Framework alloc] init];
    }
}

- (NSArray<GPCMediaFilesSelectorObserver*>*)getObservers
{
    return _observerList;
}

+ (void)authorizationStatusIsAuthorized:(PhotoLibraryAuthorizedBlock)handler
{
    if(GPC_IOS_SYSTEM_VERSION_GREATER_8_0)
    {
        [GPCMediaFilesSelectorAbove8Framework authorizationStatusIsAuthorized:handler];
    }else
    {
        [GPCMediaFilesSelectorBelow8Framework authorizationStatusIsAuthorized:handler];
    }
}

- (instancetype)init
{
    if(self = [super init])
    {
        _observerList = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark--注册与反注册观察者
- (void)regisertObeserverPhotoLibraryChanged:(id)observer
                     photoRequestTypeHandler:(PhotoRequestTypeBlock)photoRequestTypeHandler
                         photosReloadHandler:(PhotoLibraryChangedReload)photosReloadHandler
                      albumListReloadHandler:(PhotoLibraryAlbumListReload)albumListReloadHandler
                      photoAlbumIndexHandler:(PhotoAlbumIndexBlock)photoAlbumIndexHandler
                        photosChangedHandler:(PhotoLibraryPhotosChanged)photosChangedHandler
{
    if(observer == nil)  return;
    
    GPCMediaFilesSelectorObserver* observerModel = [[GPCMediaFilesSelectorObserver alloc] init];
    observerModel.observer = observer;
    observerModel.objName = [NSString stringWithFormat:@"%p",observer];
    observerModel.photoRequestTypeHandler = photoRequestTypeHandler;
    observerModel.photosReloadHandler = photosReloadHandler;
    observerModel.albumListReloadHandler = albumListReloadHandler;
    observerModel.photoAlbumIndexHandler = photoAlbumIndexHandler;
    observerModel.photosChangedHandler = photosChangedHandler;
    [_observerList addObject:observerModel];
}

- (void)unRegisterObserver:(id)observer
{
    __block   GPCMediaFilesSelectorObserver* observerModel = nil;
    [_observerList enumerateObjectsUsingBlock:^(GPCMediaFilesSelectorObserver * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString* key = [NSString stringWithFormat:@"%p",observer];
        if([obj.objName isEqualToString:key])
        {
            observerModel = obj;
            *stop = YES;
        }
    }];
    if(observerModel)
    {
        [_observerList removeObject:observerModel];
    }
}

//重置缓存
- (void)resetCachedAssets
{
    
}

//加载所有照片
- (void)loadAllPhotos:(void(^)(BOOL finished,GPCMediaFilesMetaDataPhotoModel* metaPhotoModel))complete
{
    
}

- (void)setAssetGridThumbnailSize:(CGSize)assetGridThumbnailSize
{
    _assetGridThumbnailSize = assetGridThumbnailSize;
}

//缩略图请求
- (void)requestThumbnailImage:(GPCRequestImageOption*)option
                 selectorCase:(GPCMediaFilesSelectorLocalPhotoCase*)selectorCase
                 requestBlock:(RequestThumanailImageForIndexBlock)requestBlock
{
    
}

- (void)startCachingImages:(NSArray<GPCMediaFilesSelectorLocalPhotoCase*>*)assetsStartCachingModels
{
    
}

- (void)stopCachingImages:(NSArray<GPCMediaFilesSelectorLocalPhotoCase*>*)assetsStopCachingModels
{
    
}

//预览图请求
- (void)requestPreviewImage:(CGSize)previewSize photoModel:(GPCMediaFilesSelectorLocalPhotoCase*)photoModel
               requestBlock:(RequestPreviewImageForAssets)requestBlock
{
    
}

- (void)startCachingPreviewImage:(CGSize)previewSize photoModel:(GPCMediaFilesSelectorLocalPhotoCase*)photoModel
{
    
}

- (void)stopCachingPreviewImage:(CGSize)previewSize photoModel:(GPCMediaFilesSelectorLocalPhotoCase*)photoModel
{
    
}

//加载相册列表
- (void)loadUserPhotoAlbum:(void(^)(BOOL finished,GPCMediaFilesMetaDataGalleryModel* metaGallerysModel))complete
{

}

- (void)startCachingGalleryImage:(CGSize)targetSize galleryModel:(GPCMediaFilesSelectorAlbumCase*)galleryModel
{

}

- (void)stopCachingGalleryImage:(CGSize)targetSize galleryModel:(GPCMediaFilesSelectorAlbumCase*)galleryModel
{

}

- (void)requestGalleryImage:(CGSize)targetSize galleryModel:(GPCMediaFilesSelectorAlbumCase*)galleryModel requestBlock:(RequestAlbumForIndexBlock)requestBlock
{

}

//加载视频列表
- (void)loadAllVideos:(void(^)(BOOL finished,GPCMediaFilesMetaDataPhotoModel* metaPhotoModel))complete
{

}

- (void)loadUserVideoList:(void(^)(BOOL finished,GPCMediaFilesMetaDataGalleryModel* metaGallerysModel))complete
{

}

- (void)requestVideoWithLocalPhotoCase:(GPCMediaFilesSelectorLocalPhotoCase*)photoCase
                              complete:(RequestVideoBlock)complete
{

}

//Live Photo
- (void)loadAllLivePhotos:(void(^)(BOOL finished,GPCMediaFilesMetaDataPhotoModel* metaPhotoModel))complete
{

}

- (void)requestLivePhotoWithLocalPhotoCase:(CGSize)livePhotoSize  photoCase:(GPCMediaFilesSelectorLocalPhotoCase*)photoCase  complete:(RequestLivePhotoBlock)complete
{

}
@end
