//
//  GPCMediaFilesSelectorAbove8Framework.m
//  GameBible
//
//  Created by robertyzli on 16/7/14.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCMediaFilesSelectorAbove8Framework.h"
#import <Photos/PHPhotoLibrary.h>
#import <Photos/PHAsset.h>
#import <Photos/PHFetchResult.h>
#import <Photos/PHFetchOptions.h>
#import <Photos/PHImageManager.h>
#import <photos/PHCollection.h>
#import <Photos/PHChange.h>
#import "GPCMediaFilesSelectorUtilityHelper.h"
#import "GPCMediaFilesSelectorLocalAbove8PhotoCase.h"
#import "GPCMediaFilesMetaDataPhotoAbove8Model.h"
#import "GPCMediaFilesMetaDataGalleryAbove8Model.h"
#import "GPCMediaFilesSelectorAlbumCase.h"
#import "GPCMediaFilesSelectorAlbumAbove8Case.h"

@interface GPCMediaFilesSelectorAbove8Framework()<PHPhotoLibraryChangeObserver>

@property(nonatomic,strong)PHCachingImageManager* imageManager;
//照片
@property(nonatomic,strong)NSMutableArray<PHAsset*>* allFetchPhotosAssets;
@property(nonatomic,strong)NSMutableArray<NSMutableArray<PHAsset*>*>* albumFetchAssetsList;
@property(nonatomic,strong)NSMutableArray<PHCollection*>* albumCollectionList;
@property(nonatomic,assign)BOOL isHasLoadAllPhotos;
@property(nonatomic,assign)BOOL isHasLoadUserGallery;

//视频
@property(nonatomic,strong)NSMutableArray<PHAsset*>* allFetchVideosAssets;
@property(nonatomic,strong)NSMutableArray<NSMutableArray<PHAsset*>*>* videoFetchAssetsList;
@property(nonatomic,strong)NSMutableArray<PHCollection*>* videoCollectionList;
@property(nonatomic,assign)BOOL isHasLoadVideoList;
@property(nonatomic,assign)BOOL isHasLoadAllVideos;
@property(nonatomic,assign)CGSize videoGridAssetSize;

//Live Photo
@property(nonatomic,strong)NSMutableArray<PHAsset*>* allFetchLivePhotoAssets;
@property(nonatomic,assign)BOOL isHasLoadAllLivePhotos;
@end

@implementation GPCMediaFilesSelectorAbove8Framework
+ (void)authorizationStatusIsAuthorized:(PhotoLibraryAuthorizedBlock)handler;
{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(handler)
            {
                PhotoSelectorAuthorizationStatus athorStatus = PhotoSelectorAuthorizationStatusNotDetermined;
                if(status == PHAuthorizationStatusNotDetermined)
                {
                    athorStatus = PhotoSelectorAuthorizationStatusNotDetermined;
                    
                }else if (status == PHAuthorizationStatusRestricted)
                {
                    athorStatus = PhotoSelectorAuthorizationStatusRestricted;
                    
                }else if (status == PHAuthorizationStatusDenied)
                {
                    athorStatus = PhotoSelectorAuthorizationStatusDenied;
                    
                }else if (status == PHAuthorizationStatusAuthorized)
                {
                    athorStatus = PhotoSelectorAuthorizationStatusAuthorized;
                }
                
                handler(athorStatus);
            }
            
        });
    }];
}

- (instancetype)init
{
    if(self = [super init])
    {
        self.imageManager = [[PHCachingImageManager alloc] init];
        self.isHasLoadAllPhotos = NO;
        self.isHasLoadUserGallery = NO;
        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    }
    return self;
}

- (void)dealloc
{
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (NSMutableArray<PHAsset*>*)getAssetsListWithAssetFetchResult:(PHFetchResult<PHAsset*>*)assetFetchResult
                                                     mediaType:(PHAssetMediaType)mediaType
                                                  subMediaType:(PHAssetMediaSubtype)subMediaType
{
    NSMutableArray* assetsList = [NSMutableArray new];
    
    if(mediaType == PHAssetMediaTypeUnknown)
    {
        [assetFetchResult enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(obj)
            {
                [assetsList addObject:obj];
            }
        }];
    }else
    {
        if(subMediaType == PHAssetMediaSubtypeNone)
        {
            [assetFetchResult enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if(obj.mediaType == mediaType)
                {
                    [assetsList addObject:obj];
                }
            }];
        }else
        {
            [assetFetchResult enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if(obj.mediaType == mediaType && obj.mediaSubtypes == subMediaType)
                {
                    [assetsList addObject:obj];
                }
            }];
        }
    }
    return assetsList;
}

#pragma mark--重置请求所有照片缓存
- (void)resetCachedAssets
{
    [GPCMediaFilesSelectorAbove8Framework authorizationStatusIsAuthorized:^(PhotoSelectorAuthorizationStatus authorizeStatus) {
        if(authorizeStatus == PhotoSelectorAuthorizationStatusAuthorized)
        {
            [self.imageManager stopCachingImagesForAllAssets];
        }
    }];
}

#pragma mark--加载所有照片
- (void)loadAllPhotos:(void(^)(BOOL finished,GPCMediaFilesMetaDataPhotoModel* metaPhotoModel))complete
{
    GPCMediaFilesMetaDataPhotoAbove8Model* meta = [GPCMediaFilesMetaDataPhotoAbove8Model new];
    if(self.isHasLoadAllPhotos)
    {
        if(complete)
        {
            //meta.fetchPhotosResult = self.allFetchPhotosResult;
            meta.fetchPhotoAssets = self.allFetchPhotosAssets;
            complete(YES,meta);
        }
        
        return;
    }
    
    PHFetchOptions* allPhotosOption = [[PHFetchOptions alloc] init];
    //modificationDate。creationDate
    allPhotosOption.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:NO]];
    PHFetchResult<PHAsset*>* allFetchPhotosResult = [PHAsset fetchAssetsWithOptions:allPhotosOption];
    
    self.allFetchPhotosAssets = [self getAssetsListWithAssetFetchResult:allFetchPhotosResult mediaType:PHAssetMediaTypeUnknown subMediaType:PHAssetMediaSubtypeNone];
    
    self.isHasLoadAllPhotos = YES;
    
    meta.fetchPhotoAssets = self.allFetchPhotosAssets;
    
    if(complete)
    {
        complete(YES,meta);
    }
}

- (void)setAssetGridThumbnailSize:(CGSize)assetGridThumbnailSize
{
    CGFloat scale = [UIScreen mainScreen].scale;
    [super setAssetGridThumbnailSize:CGSizeMake(assetGridThumbnailSize.width * scale, assetGridThumbnailSize.height * scale)];
    
    if([[UIDevice currentDevice].systemVersion doubleValue] < 9.0)
    {
        self.videoGridAssetSize = CGSizeMake(PHImageManagerMaximumSize .width * scale, PHImageManagerMaximumSize.height* scale);
    }else
    {
        self.videoGridAssetSize = self.assetGridThumbnailSize;
    }
}

//缩略图请求
- (void)requestThumbnailImage:(GPCRequestImageOption*)option
                 selectorCase:(GPCMediaFilesSelectorLocalPhotoCase*)selectorCase
                 requestBlock:(RequestThumanailImageForIndexBlock)requestBlock
{
    GPCMediaFilesSelectorLocalAbove8PhotoCase* photoModel = (GPCMediaFilesSelectorLocalAbove8PhotoCase*)selectorCase;
    PHAsset* asset = photoModel.asset;
    
    if(asset == nil) return;
    
    PHImageRequestOptions* optionPH = [[PHImageRequestOptions alloc] init];
    optionPH.synchronous = NO;
    optionPH.networkAccessAllowed = YES;
    
    CGSize targetSize = CGSizeZero;
    PHImageContentMode contentMode = PHImageContentModeAspectFit;
    if(asset.mediaType == PHAssetMediaTypeVideo)
    {
        targetSize = CGSizeMake(self.videoGridAssetSize.width * photoModel.options.thumbnailImageScale, self.videoGridAssetSize.height * photoModel.options.thumbnailImageScale);
        contentMode = PHImageContentModeAspectFill;
    }else
    {
        targetSize = CGSizeMake(self.assetGridThumbnailSize.width * photoModel.options.thumbnailImageScale, self.assetGridThumbnailSize.height * photoModel.options.thumbnailImageScale);
        contentMode = PHImageContentModeAspectFill;
    }
    
    GPCLocalPhotoCaseDataModel* dataModel = [GPCLocalPhotoCaseDataModel new];
    dataModel.thumbnailImageSizeScale = option.thumbnailImageSizeScale;
    if(option.deliveryMode == RequestImageDeliveryMode_Fast)
    {
        //使用PHImageRequestOptionsDeliveryModeFastFormat模式，缩略图过于模糊；
        optionPH.resizeMode = PHImageRequestOptionsResizeModeFast;
        optionPH.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    
        if(option.isAsynchronous == YES)
        {
            dataModel.imageType = LocalPhotoImageType_Fast_Asyn;
        }else
        {
        	dataModel.imageType = LocalPhotoImageType_Fast;
        }
    }else
    {
        //该模式是尽可能的获取高清质量的缩略图，后面的resultHandler可能会被调用多次
        option.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
        contentMode = PHImageContentModeAspectFill;
        targetSize = self.assetGridThumbnailSize;
        
        if(option.isAsynchronous == YES)
        {
            dataModel.imageType = LocalPhotoImageType_Opportunistic_Asyn;
        }else
        {
            dataModel.imageType = LocalPhotoImageType_Opportunistic;
        }
    }
    [self.imageManager requestImageForAsset:asset
                                 targetSize:targetSize
                                contentMode:contentMode
                                    options:optionPH
                              resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                  if(requestBlock)
                                  {
                                      if([[UIDevice currentDevice].systemVersion doubleValue] < 9.0)
                                      {
                                          if(asset.mediaType == PHAssetMediaTypeVideo)
                                          {
                                              BOOL isDegrade = [[info objectForKey:PHImageResultIsDegradedKey] boolValue];
                                              if(isDegrade == NO)
                                              {
                                                  dataModel.image = result;
                                                  requestBlock(photoModel,dataModel);
                                              }
                                          }else
                                          {
                                              dataModel.image = result;
                                              requestBlock(photoModel,dataModel);
                                          }
                                      }else
                                      {
                                          dataModel.image = result;
                                          requestBlock(photoModel,dataModel);
                                      }
                                  }
                              }];
}

- (void)startCachingImages:(NSArray<GPCMediaFilesSelectorLocalPhotoCase*>*)assetsStartCachingModels
{
    NSMutableArray* startCachings = [NSMutableArray arrayWithCapacity:assetsStartCachingModels.count];
    [assetsStartCachingModels enumerateObjectsUsingBlock:^(GPCMediaFilesSelectorLocalPhotoCase * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if([obj isKindOfClass:[GPCMediaFilesSelectorLocalAbove8PhotoCase class]])
        {
            GPCMediaFilesSelectorLocalAbove8PhotoCase* photoModel = (GPCMediaFilesSelectorLocalAbove8PhotoCase*)obj;
            if(photoModel.asset)
            {
                [startCachings addObject:photoModel.asset];
            }
        }
    }];
    
    if(startCachings.count == 0) return;
    
    CGSize targetSize = CGSizeZero;
    PHImageContentMode contentMode = PHImageContentModeAspectFit;
    GPCMediaFilesSelectorLocalAbove8PhotoCase* photoModel = (GPCMediaFilesSelectorLocalAbove8PhotoCase*)assetsStartCachingModels.firstObject;
    if(photoModel.asset.mediaType == PHAssetMediaTypeVideo)
    {
        targetSize = self.videoGridAssetSize;
        contentMode = PHImageContentModeAspectFill;
    }else
    {
        targetSize = self.assetGridThumbnailSize;
        contentMode = PHImageContentModeAspectFill;
    }
    if(photoModel.options.deliveryMode != PhotoCaseRequestOptionDeliveryModeFastMode)
    {
        contentMode = PHImageContentModeAspectFill;
        targetSize = self.assetGridThumbnailSize;
    }
    
    PHImageRequestOptions* option = [[PHImageRequestOptions alloc] init];
    option.synchronous = NO;
    option.networkAccessAllowed = YES;
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    option.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    
    [self.imageManager startCachingImagesForAssets:startCachings
                                        targetSize:targetSize
                                       contentMode:PHImageContentModeAspectFill
                                           options:option];
}

- (void)stopCachingImages:(NSArray<GPCMediaFilesSelectorLocalPhotoCase*>*)assetsStopCachingModels
{
    NSMutableArray* stopCachings = [NSMutableArray arrayWithCapacity:assetsStopCachingModels.count];
    [assetsStopCachingModels enumerateObjectsUsingBlock:^(GPCMediaFilesSelectorLocalPhotoCase * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[GPCMediaFilesSelectorLocalAbove8PhotoCase class]])
        {
            GPCMediaFilesSelectorLocalAbove8PhotoCase* photoModel = (GPCMediaFilesSelectorLocalAbove8PhotoCase*)obj;
            if(photoModel.asset)
            {
                [stopCachings addObject:photoModel.asset];
            }
        }
    }];
    
    if(stopCachings.count == 0) return;
    
    CGSize targetSize = CGSizeZero;
    PHImageContentMode contentMode = PHImageContentModeAspectFit;
    GPCMediaFilesSelectorLocalAbove8PhotoCase* photoModel = (GPCMediaFilesSelectorLocalAbove8PhotoCase*)assetsStopCachingModels.firstObject;
    if(photoModel.asset.mediaType == PHAssetMediaTypeVideo)
    {
        targetSize = self.videoGridAssetSize;
        contentMode = PHImageContentModeAspectFill;
    }else
    {
        targetSize = self.assetGridThumbnailSize;
        contentMode = PHImageContentModeAspectFill;
    }
    
    if(photoModel.options.deliveryMode != PhotoCaseRequestOptionDeliveryModeFastMode)
    {
        contentMode = PHImageContentModeAspectFill;
        targetSize = self.assetGridThumbnailSize;
    }
    
    PHImageRequestOptions* option = [[PHImageRequestOptions alloc] init];
    option.synchronous = NO;
    option.networkAccessAllowed = YES;
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    option.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    
    [self.imageManager stopCachingImagesForAssets:stopCachings
                                       targetSize:targetSize
                                      contentMode:PHImageContentModeAspectFill
                                          options:option];
}

//预览图请求
- (void)requestPreviewImage:(CGSize)previewSize photoModel:(GPCMediaFilesSelectorLocalPhotoCase*)photoModel
               requestBlock:(RequestPreviewImageForAssets)requestBlock
{
    GPCMediaFilesSelectorLocalAbove8PhotoCase* tmpModel = (GPCMediaFilesSelectorLocalAbove8PhotoCase*)photoModel;
    
    if(tmpModel.asset == nil) return;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize targetSize = CGSizeMake(previewSize.width * scale, previewSize.height * scale);
    PHImageRequestOptions* option = [[PHImageRequestOptions alloc] init];
    option.networkAccessAllowed = YES;
    
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    [self.imageManager requestImageForAsset:tmpModel.asset
                                 targetSize:targetSize
                                contentMode:PHImageContentModeAspectFill
                                    options:option
                              resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                  
                                  BOOL isDegraded = [[info objectForKey:PHImageResultIsDegradedKey] boolValue];
                                  if(requestBlock)
                                  {
                                      requestBlock(isDegraded == NO ? YES : NO ,result,photoModel);
                                  }
                              }];

}

- (void)startCachingPreviewImage:(CGSize)previewSize photoModel:(GPCMediaFilesSelectorLocalPhotoCase*)photoModel
{
    GPCMediaFilesSelectorLocalAbove8PhotoCase* tmpModel = (GPCMediaFilesSelectorLocalAbove8PhotoCase*)photoModel;
    
    if(tmpModel.asset == nil) return;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize targetSize = CGSizeMake(previewSize.width * scale, previewSize.height * scale);
    [self.imageManager startCachingImagesForAssets:@[tmpModel.asset]
                                        targetSize:targetSize
                                       contentMode:PHImageContentModeAspectFill
                                           options:nil];
}

- (void)stopCachingPreviewImage:(CGSize)previewSize photoModel:(GPCMediaFilesSelectorLocalPhotoCase*)photoModel
{
    GPCMediaFilesSelectorLocalAbove8PhotoCase* tmpModel = (GPCMediaFilesSelectorLocalAbove8PhotoCase*)photoModel;
    if(tmpModel.asset == nil) return;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize targetSize = CGSizeMake(previewSize.width * scale, previewSize.height * scale);
    [self.imageManager stopCachingImagesForAssets:@[tmpModel.asset]
                                       targetSize:targetSize
                                      contentMode:PHImageContentModeAspectFill
                                          options:nil];
}

#pragma mark--加载相册
//加载相册列表
- (void)loadUserPhotoAlbum:(void(^)(BOOL finished,GPCMediaFilesMetaDataGalleryModel* metaGallerysModel))complete
{
    GPCMediaFilesMetaDataGalleryAbove8Model* galleryModel = [GPCMediaFilesMetaDataGalleryAbove8Model new];
    if(self.isHasLoadUserGallery)
    {
        if(complete)
        {
            galleryModel.galleryConllections = self.albumCollectionList;
            galleryModel.galleryFetchAssets = self.albumFetchAssetsList;
            complete(YES,galleryModel);
        }
    }
    
    self.albumFetchAssetsList = [[NSMutableArray alloc] init];
    self.albumCollectionList = [[NSMutableArray alloc] init];
    PHFetchResult<PHAssetCollection*>* cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    PHFetchResult<PHAssetCollection*>* recentlyAdded = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumRecentlyAdded options:nil];
    
    PHFetchOptions* option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:NO]];
    
    __weak typeof (self) weakSelf = self;
    [cameraRoll enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHFetchResult<PHAsset*>* result = [PHAsset fetchAssetsInAssetCollection:obj options:option];
        NSMutableArray* assetList = [weakSelf getAssetsListWithAssetFetchResult:result mediaType:PHAssetMediaTypeUnknown subMediaType:PHAssetMediaSubtypeNone];
        if(assetList.count > 0)
        {
            [weakSelf.albumFetchAssetsList addObject:assetList];
            [weakSelf.albumCollectionList addObject:obj];
        }
    }];
    [recentlyAdded enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHFetchResult<PHAsset*>* result = [PHAsset fetchAssetsInAssetCollection:obj options:option];
        NSMutableArray* assetList = [weakSelf getAssetsListWithAssetFetchResult:result mediaType:PHAssetMediaTypeUnknown subMediaType:PHAssetMediaSubtypeNone];
        if(assetList.count > 0)
        {
            [weakSelf.albumFetchAssetsList addObject:assetList];
            [weakSelf.albumCollectionList addObject:obj];
        }
    }];
    if([GPCMediaFilesSelectorUtilityHelper GetCurrentSystemVersion] >= 9.0)
    {
        PHFetchResult<PHAssetCollection*>* screenShots = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumScreenshots options:nil];
        
        [screenShots enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PHFetchResult<PHAsset*>* result = [PHAsset fetchAssetsInAssetCollection:obj options:option];
            NSMutableArray* assetList = [weakSelf getAssetsListWithAssetFetchResult:result mediaType:PHAssetMediaTypeUnknown subMediaType:PHAssetMediaSubtypeNone];;
            if(assetList.count > 0)
            {
                [weakSelf.albumFetchAssetsList addObject:assetList];
                [weakSelf.albumCollectionList addObject:obj];
            }
        }];
    }
    PHFetchResult<PHCollection*>* userCreate = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    [userCreate enumerateObjectsUsingBlock:^(PHCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if([obj isKindOfClass:[PHAssetCollection class]])
        {
            PHFetchResult<PHAsset*>* result = [PHAsset fetchAssetsInAssetCollection:(PHAssetCollection*)obj options:option];
            NSMutableArray* assetList = [weakSelf getAssetsListWithAssetFetchResult:result mediaType:PHAssetMediaTypeUnknown subMediaType:PHAssetMediaSubtypeNone];;
            if(assetList.count > 0)
            {
                [weakSelf.albumFetchAssetsList addObject:assetList];
                [weakSelf.albumCollectionList addObject:obj];
            }
        }
    }];
    
    self.isHasLoadUserGallery = YES;
    
    if(complete)
    {
        galleryModel.galleryFetchAssets = self.albumFetchAssetsList;
        galleryModel.galleryConllections = self.albumCollectionList;
        complete(YES,galleryModel);
    }
}

- (void)startCachingGalleryImage:(CGSize)targetSize galleryModel:(GPCMediaFilesSelectorAlbumCase*)galleryModel
{
    GPCMediaFilesSelectorAlbumAbove8Case* model = (GPCMediaFilesSelectorAlbumAbove8Case*)galleryModel;
    GPCMediaFilesMetaDataPhotoAbove8Model* metaDataModel = model.metaData;
    if(metaDataModel.fetchPhotoAssets.count == 0 || metaDataModel.fetchPhotoAssets[0] == nil) return;
    if(metaDataModel.fetchPhotoAssets.count > 0)
    {
        CGFloat scale = [UIScreen mainScreen].scale;
        CGSize tmpSize = CGSizeMake(targetSize.width * scale, targetSize.height * scale);
        
        [self.imageManager startCachingImagesForAssets:@[metaDataModel.fetchPhotoAssets[0]]
                                            targetSize:tmpSize
                                           contentMode:PHImageContentModeAspectFill
                                               options:nil];
    }
}

- (void)stopCachingGalleryImage:(CGSize)targetSize galleryModel:(GPCMediaFilesSelectorAlbumCase*)galleryModel
{
    GPCMediaFilesSelectorAlbumAbove8Case* model = (GPCMediaFilesSelectorAlbumAbove8Case*)galleryModel;
    GPCMediaFilesMetaDataPhotoAbove8Model* metaDataModel = model.metaData;
    if(metaDataModel.fetchPhotoAssets.count == 0 || metaDataModel.fetchPhotoAssets[0] == nil) return;
    if(metaDataModel.fetchPhotoAssets.count > 0)
    {
        CGFloat scale = [UIScreen mainScreen].scale;
        CGSize tmpSize = CGSizeMake(targetSize.width * scale, targetSize.height * scale);
        
        [self.imageManager stopCachingImagesForAssets:@[metaDataModel.fetchPhotoAssets[0]]
                                            targetSize:tmpSize
                                           contentMode:PHImageContentModeAspectFill
                                               options:nil];
    }
}

- (void)requestGalleryImage:(CGSize)targetSize galleryModel:(GPCMediaFilesSelectorAlbumCase*)galleryModel requestBlock:(RequestAlbumForIndexBlock)requestBlock
{
    GPCMediaFilesSelectorAlbumAbove8Case* model = (GPCMediaFilesSelectorAlbumAbove8Case*)galleryModel;
    GPCMediaFilesMetaDataPhotoAbove8Model* metaDataModel = model.metaData;
    if(metaDataModel.fetchPhotoAssets.count == 0 || metaDataModel.fetchPhotoAssets[0] == nil) return;
    if(metaDataModel.fetchPhotoAssets.count > 0)
    {
        CGFloat scale = [UIScreen mainScreen].scale;
        CGSize size = CGSizeMake(targetSize.width * scale, targetSize.height * scale);
        [self.imageManager requestImageForAsset:metaDataModel.fetchPhotoAssets[0]
                                     targetSize:size
                                    contentMode:PHImageContentModeAspectFill
                                        options:nil
                                  resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                      if(requestBlock)
                                      {
                                          requestBlock(result);
                                      }
                                  }];

    }else
    {
        if(requestBlock)
        {
            requestBlock(nil);
        }
    }
}

#pragma mark--加载视频列表
- (void)loadAllVideos:(void(^)(BOOL finished,GPCMediaFilesMetaDataPhotoModel* metaPhotoModel))complete
{
    GPCMediaFilesMetaDataPhotoAbove8Model* meta = [GPCMediaFilesMetaDataPhotoAbove8Model new];
    if(self.isHasLoadAllVideos)
    {
        if(complete)
        {
            meta.fetchPhotoAssets = self.allFetchVideosAssets;
            complete(YES,meta);
        }
        
        return;
    }
    
    PHFetchOptions* allVideosOption = [[PHFetchOptions alloc] init];
    allVideosOption.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:NO]];
    PHFetchResult<PHAsset*>* allFetchVideosResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:allVideosOption];
    
    self.allFetchVideosAssets = [self getAssetsListWithAssetFetchResult:allFetchVideosResult mediaType:PHAssetMediaTypeUnknown subMediaType:PHAssetMediaSubtypeNone];
    self.isHasLoadAllVideos = YES;
    meta.fetchPhotoAssets = self.allFetchVideosAssets;
    if(complete)
    {
        complete(YES,meta);
    }
}

- (void)loadUserVideoList:(void (^)(BOOL, GPCMediaFilesMetaDataGalleryModel *))complete
{
    GPCMediaFilesMetaDataGalleryAbove8Model* galleryModel = [GPCMediaFilesMetaDataGalleryAbove8Model new];
    if(self.isHasLoadVideoList)
    {
        if(complete)
        {
            galleryModel.galleryConllections = self.videoCollectionList;
            galleryModel.galleryFetchAssets = self.videoFetchAssetsList;
            complete(YES,galleryModel);
        }
    }
    
    self.videoCollectionList = [[NSMutableArray alloc] init];
    self.videoFetchAssetsList = [[NSMutableArray alloc] init];
    PHFetchResult<PHAssetCollection*>* videoList = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumVideos options:nil];
    PHFetchResult<PHAssetCollection*>* slomoVideoList = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumSlomoVideos options:nil];
    
    PHFetchOptions* option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:NO]];
    
    __weak typeof (self) weakSelf = self;
    [videoList enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        PHFetchResult<PHAsset*>* resutl = [PHAsset fetchAssetsInAssetCollection:obj options:option];
        NSMutableArray* assetsList = [weakSelf getAssetsListWithAssetFetchResult:resutl mediaType:PHAssetMediaTypeUnknown subMediaType:PHAssetMediaSubtypeNone];
        if(assetsList.count > 0)
        {
            [weakSelf.videoFetchAssetsList addObject:assetsList];
            [weakSelf.videoCollectionList addObject:obj];
        }
    }];
   
    [slomoVideoList enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHFetchResult<PHAsset*>* resutl = [PHAsset fetchAssetsInAssetCollection:obj options:option];
        NSMutableArray* assetsList = [weakSelf getAssetsListWithAssetFetchResult:resutl mediaType:PHAssetMediaTypeUnknown subMediaType:PHAssetMediaSubtypeNone];
        if(assetsList.count > 0)
        {
            [weakSelf.videoFetchAssetsList addObject:assetsList];
            [weakSelf.videoCollectionList addObject:obj];
        }
    }];
   
    PHFetchResult<PHCollection*>* userCreate = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    [userCreate enumerateObjectsUsingBlock:^(PHCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if([obj isKindOfClass:[PHAssetCollection class]])
        {
            PHAssetCollection* assetCollection = (PHAssetCollection*)obj;
            PHFetchResult<PHAsset*>* resutl = [PHAsset fetchAssetsInAssetCollection:assetCollection options:option];
            
            NSMutableArray* videoList = [NSMutableArray new];
            [resutl enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if(obj.mediaType == PHAssetMediaTypeVideo)
                {
                    [videoList addObject:obj];
                }
            }];
            
            if(videoList.count > 0)
            {
                [weakSelf.videoFetchAssetsList addObject:videoList];
                [weakSelf.videoCollectionList addObject:obj];
            }
        }
    }];
    
    self.isHasLoadVideoList = YES;
    
    if(complete)
    {
        galleryModel.galleryFetchAssets = self.videoFetchAssetsList;
        galleryModel.galleryConllections = self.videoCollectionList;
        complete(YES,galleryModel);
    }
}

- (void)requestVideoWithLocalPhotoCase:(GPCMediaFilesSelectorLocalPhotoCase *)photoCase
                              complete:(RequestVideoBlock)complete
{
    GPCMediaFilesSelectorLocalAbove8PhotoCase* above8Case = (GPCMediaFilesSelectorLocalAbove8PhotoCase*)photoCase;
    if(above8Case.asset == nil) return;
    PHVideoRequestOptions* option = [PHVideoRequestOptions new];
    option.version = PHVideoRequestOptionsVersionCurrent;
    option.networkAccessAllowed = YES;
    
   PHImageRequestID requestID = [self.imageManager requestPlayerItemForVideo:above8Case.asset options:option resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
       
       BOOL isDegraded = [[info objectForKey:PHImageResultIsDegradedKey] boolValue];
       if(complete)
       {
           complete(isDegraded == NO ? YES : NO,requestID,playerItem,info);
       }
    }];
}

#pragma mark--加载Live Photo
- (void)loadAllLivePhotos:(void (^)(BOOL, GPCMediaFilesMetaDataPhotoModel *))complete
{
    GPCMediaFilesMetaDataPhotoAbove8Model* meta = [GPCMediaFilesMetaDataPhotoAbove8Model new];
    if(self.isHasLoadAllLivePhotos)
    {
        if(complete)
        {
            meta.fetchPhotoAssets = self.allFetchLivePhotoAssets;
            complete(YES,meta);
        }
        
        return;
    }
    
    PHFetchOptions* allPhotosOption = [[PHFetchOptions alloc] init];
    //modificationDate,creationDate
    allPhotosOption.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:NO]];
    PHFetchResult<PHAsset*>* allFetchLivePhotosResult = [PHAsset fetchAssetsWithOptions:allPhotosOption];
    
    self.allFetchLivePhotoAssets = [self getAssetsListWithAssetFetchResult:allFetchLivePhotosResult mediaType:PHAssetMediaTypeImage subMediaType:PHAssetMediaSubtypePhotoLive];
    
    self.isHasLoadAllLivePhotos = YES;
    
    meta.fetchPhotoAssets = self.allFetchLivePhotoAssets;
    
    if(complete)
    {
        complete(YES,meta);
    }
}


- (void)requestLivePhotoWithLocalPhotoCase:(CGSize)livePhotoSize
                                 photoCase:(GPCMediaFilesSelectorLocalPhotoCase *)photoCase
                                  complete:(RequestLivePhotoBlock)complete
{
    GPCMediaFilesSelectorLocalAbove8PhotoCase* tmpModel = (GPCMediaFilesSelectorLocalAbove8PhotoCase*)photoCase;
    if(tmpModel.asset == nil) return;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize targetSize = CGSizeMake(livePhotoSize.width * scale, livePhotoSize.height * scale);
    
    PHLivePhotoRequestOptions* option = [PHLivePhotoRequestOptions new];
    option.version = PHImageRequestOptionsVersionCurrent;
    option.networkAccessAllowed = YES;
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    [self.imageManager requestLivePhotoForAsset:tmpModel.asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:option resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nullable info) {
        
        BOOL isDegraded = [[info objectForKey:PHImageResultIsDegradedKey] boolValue];
        if(complete)
        {
            complete(isDegraded == NO ? YES : NO,livePhoto,info);
        }
    }];
}

- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    //先临时取消app前后台切换照片数据同步
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //
    //       __weak typeof (self) weakSelf = self;
    //        [_observerList enumerateObjectsUsinLYZock:^(GPCLocalPhotoManagerObserver * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //            if(obj.observer && obj.photoRequestTypeHandler)
    //            {
    //
    //                DDLogDebug(@"Observer=%@_%@",obj.objName,obj.observer);
    //                GPC_Photo_Request_type type = obj.photoRequestTypeHandler();
    //                if(type == GPC_Photo_Request_type_All)//所有照片
    //                {
    //                    [weakSelf photoAllChanges:obj changeInstance:changeInstance];
    //                }
    //
    //                if(type == GPC_Photo_Request_type_Special_Album)//指定相册
    //                {
    //                    [weakSelf photoSpecialAlbumChanges:obj changeInstance:changeInstance];
    //                }
    //
    //                if(type == GPC_Photo_Request_type_AlbumList)//相册
    //                {
    //                    [weakSelf photoAlbumListChanges:obj changeInstance:changeInstance];
    //                }
    //            }
    //        }];
    //    });
}
@end
