//
//  GPCMediaFilesSelectorFrameworkManager.h
//  GameBible
//
//  Created by robertyzli on 16/7/14.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/PhotosTypes.h>
#import "GPCMediaFilesSelectorObserver.h"
#import "GPCMediaFilesSelectorBaseFramework.h"
#import "GPCMediaFilesMetaDataPhotoModel.h"
#import "GPCMediaFilesSelectorLocalPhotoCase.h"
#import "GPCMediaFilesSelectorNetDownLoadFramework.h"

@interface GPCMediaFilesSelectorFrameworkManager : NSObject
@property(nonatomic,assign)CGSize assetGridThumbnailSize;
@property(nonatomic,readonly,strong)NSArray<GPCMediaFilesSelectorObserver*>* observers;

+ (instancetype)shareInstance;
/*
 *加载网络图片相关接口
 */
- (GPCMediaFilesMetaDataPhotoModel*)getPictureMetaDataPhotoModelByDownloadURLs:(NSArray<NSString*>*)downloadURLs;
- (GPCMediaFilesMetaDataPhotoModel*)getPictureMethDataPhotoModel:(NSUInteger)numOfPicUrls
                                          thumbnailImageBlock:(GetDownloadPictureThumbnailURLBlock)thumbnailImageBlock
                                                bigImageBlock:(GetDownLoadPictureBigURLBlock)bigImageBlock;
- (void)downloadPictureWithURL:(NSString*)URL complete:(DownLoadPictureBlock)complete;
/*
 *本地相册照片相关接口
 */
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

//视频
- (void)loadAllVideos:(void(^)(BOOL finished,GPCMediaFilesMetaDataPhotoModel* metaPhotoModel))complete;
- (void)loadUserVideoList:(void(^)(BOOL finished,GPCMediaFilesMetaDataGalleryModel* metaGallerysModel))complete;
- (void)requestVideoWithLocalPhotoCase:(GPCMediaFilesSelectorLocalPhotoCase*)photoCase
                              complete:(RequestVideoBlock)complete;

//Live Photo
- (void)loadAllLivePhotos:(void(^)(BOOL finished,GPCMediaFilesMetaDataPhotoModel* metaPhotoModel))complete;
- (void)requestLivePhotoWithLocalPhotoCase:(CGSize)livePhotoSize
                                 photoCase:(GPCMediaFilesSelectorLocalPhotoCase*)photoCase
                                  complete:(RequestLivePhotoBlock)complete;
@end
