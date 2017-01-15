//
//  GPCMediaFilesSelectorFrameworkManager.m
//  GameBible
//
//  Created by robertyzli on 16/7/14.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCMediaFilesSelectorFrameworkManager.h"
#import "GPCMediaFilesSelectorBaseFramework.h"

@interface GPCMediaFilesSelectorFrameworkManager()
@property(nonatomic,strong)GPCMediaFilesSelectorBaseFramework* photoFrameWork;
@property(nonatomic,strong)GPCMediaFilesSelectorNetDownLoadFramework* downLoadFrameWork;
@end

@implementation GPCMediaFilesSelectorFrameworkManager
+ (instancetype)shareInstance
{
    static GPCMediaFilesSelectorFrameworkManager* manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        manager = [[GPCMediaFilesSelectorFrameworkManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    if(self = [super init])
    {
        self.photoFrameWork = [GPCMediaFilesSelectorBaseFramework createLYZPhotoFramework];
        self.downLoadFrameWork = [[GPCMediaFilesSelectorNetDownLoadFramework alloc] init];
    }
    return self;
}

/*
 *加载网络图片相关接口
 */
- (GPCMediaFilesMetaDataPhotoModel*)getPictureMetaDataPhotoModelByDownloadURLs:(NSArray<NSString*>*)downloadURLs
{
   return [self.downLoadFrameWork getPictureMetaDataPhotoModelByDownloadURLs:downloadURLs];
}

- (GPCMediaFilesMetaDataPhotoModel*)getPictureMethDataPhotoModel:(NSUInteger)numOfPicUrls
                                          thumbnailImageBlock:(GetDownloadPictureThumbnailURLBlock)thumbnailImageBlock
                                                bigImageBlock:(GetDownLoadPictureBigURLBlock)bigImageBlock
{
    return [self.downLoadFrameWork getPictureMethDataPhotoModel:numOfPicUrls thumbnailImageBlock:thumbnailImageBlock bigImageBlock:bigImageBlock];
}

- (void)downloadPictureWithURL:(NSString*)URL complete:(DownLoadPictureBlock)complete
{
    [self.downLoadFrameWork downloadPictureWithURL:URL complete:complete];
}

/*
 *本地相册照片相关接口
 */

+ (void)authorizationStatusIsAuthorized:(PhotoLibraryAuthorizedBlock)handler
{
    [GPCMediaFilesSelectorBaseFramework authorizationStatusIsAuthorized:handler];
}

- (NSArray<GPCMediaFilesSelectorObserver*>*)observers
{
    return [self.photoFrameWork getObservers];
}

#pragma mark--注册与反注册观察者
- (void)regisertObeserverPhotoLibraryChanged:(id)observer
                     photoRequestTypeHandler:(PhotoRequestTypeBlock)photoRequestTypeHandler
                         photosReloadHandler:(PhotoLibraryChangedReload)photosReloadHandler
                      albumListReloadHandler:(PhotoLibraryAlbumListReload)albumListReloadHandler
                      photoAlbumIndexHandler:(PhotoAlbumIndexBlock)photoAlbumIndexHandler
                        photosChangedHandler:(PhotoLibraryPhotosChanged)photosChangedHandler
{
    [self.photoFrameWork regisertObeserverPhotoLibraryChanged:observer
                                      photoRequestTypeHandler:photoRequestTypeHandler
                                          photosReloadHandler:photosReloadHandler
                                       albumListReloadHandler:albumListReloadHandler
                                       photoAlbumIndexHandler:photoAlbumIndexHandler
                                         photosChangedHandler:photosChangedHandler];
}

- (void)unRegisterObserver:(id)observer
{
    [self.photoFrameWork unRegisterObserver:observer];
}

#pragma mark--重置请求所有照片缓存
- (void)resetCachedAssets
{
    [self.photoFrameWork resetCachedAssets];
}

#pragma mark--加载所有照片
- (void)loadAllPhotos:(void(^)(BOOL finished,GPCMediaFilesMetaDataPhotoModel* metaPhotoModel))complete
{
    [self.photoFrameWork loadAllPhotos:complete];
}

- (void)setAssetGridThumbnailSize:(CGSize)assetGridThumbnailSize
{
    self.photoFrameWork.assetGridThumbnailSize = assetGridThumbnailSize;
}

- (CGSize)assetGridThumbnailSize
{
    return self.photoFrameWork.assetGridThumbnailSize;
}

//缩略图请求
- (void)requestThumbnailImage:(GPCRequestImageOption*)option
                 selectorCase:(GPCMediaFilesSelectorLocalPhotoCase*)selectorCase
                 requestBlock:(RequestThumanailImageForIndexBlock)requestBlock
{
    [self.photoFrameWork requestThumbnailImage:option
                                  selectorCase:selectorCase
                                  requestBlock:requestBlock];
}

- (void)startCachingImages:(NSArray<GPCMediaFilesSelectorLocalPhotoCase*>*)assetsStartCachingModels
{
    [self.photoFrameWork startCachingImages:assetsStartCachingModels];
}

- (void)stopCachingImages:(NSArray<GPCMediaFilesSelectorLocalPhotoCase*>*)assetsStopCachingModels
{
    [self.photoFrameWork stopCachingImages:assetsStopCachingModels];
}

//预览图请求
- (void)requestPreviewImage:(CGSize)previewSize photoModel:(GPCMediaFilesSelectorLocalPhotoCase*)photoModel
               requestBlock:(RequestPreviewImageForAssets)requestBlock
{
    [self.photoFrameWork requestPreviewImage:previewSize photoModel:photoModel requestBlock:requestBlock];
}

- (void)startCachingPreviewImage:(CGSize)previewSize photoModel:(GPCMediaFilesSelectorLocalPhotoCase*)photoModel
{
    [self.photoFrameWork startCachingPreviewImage:previewSize photoModel:photoModel];
}

- (void)stopCachingPreviewImage:(CGSize)previewSize photoModel:(GPCMediaFilesSelectorLocalPhotoCase*)photoModel
{
    [self.photoFrameWork stopCachingPreviewImage:previewSize photoModel:photoModel];
}

//加载相册列表
- (void)loadUserPhotoAlbum:(void(^)(BOOL finished,GPCMediaFilesMetaDataGalleryModel* metaGallerysModel))complete
{
    [self.photoFrameWork loadUserPhotoAlbum:complete];
}

- (void)startCachingGalleryImage:(CGSize)targetSize galleryModel:(GPCMediaFilesSelectorAlbumCase*)galleryModel
{
    [self.photoFrameWork startCachingGalleryImage:targetSize galleryModel:galleryModel];
}

- (void)stopCachingGalleryImage:(CGSize)targetSize galleryModel:(GPCMediaFilesSelectorAlbumCase*)galleryModel
{
    [self.photoFrameWork stopCachingGalleryImage:targetSize galleryModel:galleryModel];
}

- (void)requestGalleryImage:(CGSize)targetSize galleryModel:(GPCMediaFilesSelectorAlbumCase*)galleryModel requestBlock:(RequestAlbumForIndexBlock)requestBlock
{
    [self.photoFrameWork requestGalleryImage:targetSize galleryModel:galleryModel requestBlock:requestBlock];
}

//视频列表
- (void)loadAllVideos:(void(^)(BOOL finished,GPCMediaFilesMetaDataPhotoModel* metaPhotoModel))complete
{
    [self.photoFrameWork loadAllVideos:complete];
}

- (void)loadUserVideoList:(void(^)(BOOL finished,GPCMediaFilesMetaDataGalleryModel* metaGallerysModel))complete
{
    [self.photoFrameWork loadUserVideoList:complete];
}

- (void)requestVideoWithLocalPhotoCase:(GPCMediaFilesSelectorLocalPhotoCase*)photoCase
                              complete:(RequestVideoBlock)complete
{
    [self.photoFrameWork requestVideoWithLocalPhotoCase:photoCase complete:complete];
}

//Live Photo
- (void)loadAllLivePhotos:(void(^)(BOOL finished,GPCMediaFilesMetaDataPhotoModel* metaPhotoModel))complete
{
    [self.photoFrameWork loadAllLivePhotos:complete];
}

- (void)requestLivePhotoWithLocalPhotoCase:(CGSize)livePhotoSize
                                 photoCase:(GPCMediaFilesSelectorLocalPhotoCase*)photoCase
                                  complete:(RequestLivePhotoBlock)complete
{
    [self.photoFrameWork requestLivePhotoWithLocalPhotoCase:livePhotoSize
                                                  photoCase:photoCase
                                                   complete:complete];
     
}
@end
