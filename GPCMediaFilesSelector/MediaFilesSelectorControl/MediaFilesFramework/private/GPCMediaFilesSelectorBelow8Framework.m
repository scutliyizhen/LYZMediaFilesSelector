//
//  GPCMediaFilesSelectorBelow8Framework.m
//  GameBible
//
//  Created by robertyzli on 16/7/14.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "GPCMediaFilesSelectorBelow8Framework.h"
#import "GPCMediaFilesMetaDataPhotoBelow8Model.h"
#import "GPCMediaFilesSelectorLocalBelow8PhotoCase.h"
#import "GPCMediaFilesMetaDataGalleryBelow8Model.h"
#import "GPCMediaFilesSelectorAlbumBelow8Case.h"
#import "UIImage+ImageOrientation.h"

typedef NS_ENUM(NSUInteger, GPCALAssetsFilterTypeEnum)
{
    GPCInputALAssetsFilterTypeNoneEnum,
    GPCInputALAssetsFilterTypePhotosEnum,
    GPCInputALAssetsFilterTypeVideosEnum
};

static PhotoLibraryAuthorizedBlock g_authorizeBlock;

@interface GPCMediaFilesSelectorBelow8Framework()
@property(nonatomic,strong)ALAssetsLibrary* assetsLibrary;
@property(nonatomic,strong)NSMutableSet* selectedAssetURLs;
@property(nonatomic,strong)NSArray* groupTypes;
@property(nonatomic,assign)GPCALAssetsFilterTypeEnum filterType;

//相册
@property(nonatomic,strong)NSMutableArray<ALAsset*>* allPhotosData;
@property(nonatomic,strong)NSMutableDictionary<NSString*,ALAssetsGroup*>* allPhotoGroupDic;

@property(nonatomic,strong)NSMutableArray<ALAssetsGroup*>* albumsData;
@property(nonatomic,strong)NSMutableArray<NSArray<ALAsset*>*>* albumPhotos;
@property(nonatomic,strong)NSMutableDictionary<NSString*,ALAssetsGroup*>* albumGroupDic;

@property(nonatomic,assign)BOOL isHasLoadPhotos;
@property(nonatomic,assign)BOOL isHasLoadUserGallery;

//视频
@property(nonatomic,strong)NSMutableArray<ALAsset*>* allVideosData;
@property(nonatomic,strong)NSMutableDictionary<NSString*,ALAssetsGroup*>* allVideoGroupDic;

@property(nonatomic,strong)NSMutableArray<ALAssetsGroup*>* videosData;
@property(nonatomic,strong)NSMutableArray<NSArray<ALAsset*>*>* videosPhotos;
@property(nonatomic,strong)NSMutableDictionary<NSString*,ALAssetsGroup*>* videosGroupDic;

@property(nonatomic,assign)BOOL isHasLoadVideos;
@property(nonatomic,assign)BOOL isHasLoadUserVideos;

@property(nonatomic,strong)NSOperationQueue* requestOperationQueue;
@property(nonatomic,strong)NSMutableDictionary<NSString*,NSBlockOperation*>* blockOperationDic;
@end

@implementation GPCMediaFilesSelectorBelow8Framework
+ (void)authorizationStatusIsAuthorized:(PhotoLibraryAuthorizedBlock)handler;
{
    g_authorizeBlock = [handler copy];
    
    if(handler)
    {
        //        ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
        //
        //        PhotoSelectorAuthorizationStatus athorStatus = PhotoSelectorAuthorizationStatusNotDetermined;
        //        if(status == ALAuthorizationStatusNotDetermined)
        //        {
        //            athorStatus = PhotoSelectorAuthorizationStatusNotDetermined;
        //
        //        }else if (status == ALAuthorizationStatusRestricted)
        //        {
        //            athorStatus = PhotoSelectorAuthorizationStatusRestricted;
        //
        //        }else if (status == ALAuthorizationStatusDenied)
        //        {
        //            athorStatus = PhotoSelectorAuthorizationStatusDenied;
        //
        //        }else if (status == ALAuthorizationStatusAuthorized)
        //        {
        //            athorStatus = PhotoSelectorAuthorizationStatusAuthorized;
        //        }
        //
        //        if(status == ALAuthorizationStatusNotDetermined)
        //        {
        //
        //        }else
        //        {
        //        	
        //        }
        
        
        //        handler(athorStatus);
        
        handler(PhotoSelectorAuthorizationStatusAuthorized);
        
    }
}

#pragma mark--缓存属性
- (NSMutableDictionary<NSString*,NSBlockOperation*>*)blockOperationDic
{
    if(_blockOperationDic == nil)
    {
        _blockOperationDic = [NSMutableDictionary new];
    }
    return _blockOperationDic;
}

- (NSOperationQueue*)requestOperationQueue
{
    if(_requestOperationQueue == nil)
    {
        _requestOperationQueue = [NSOperationQueue new];
        _requestOperationQueue.maxConcurrentOperationCount = 2;//设置最大线程个数为2，否则太多会降低性能
    }
    return _requestOperationQueue;
}

- (ALAssetsLibrary*)assetsLibrary
{
    if(_assetsLibrary == nil)
    {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    
    return _assetsLibrary;
}

- (NSMutableSet*)selectedAssetURLs
{
    if(_selectedAssetURLs == nil)
    {
        _selectedAssetURLs = [NSMutableSet set];
    }
    return _selectedAssetURLs;
}

- (NSArray*)groupTypes
{
    if(_groupTypes == nil)
    {
        _groupTypes = @[@(PHAssetCollectionSubtypeSmartAlbumUserLibrary),@(PHAssetCollectionSubtypeSmartAlbumRecentlyAdded)];
    }
    return _groupTypes;
}

- (NSString*)getObjectAddressString:(id)obj
{
    return [NSString stringWithFormat:@"%p",obj];
}

#pragma mark--加载相册
//加载所有照片
- (void)loadAllPhotos:(void(^)(BOOL finished,GPCMediaFilesMetaDataPhotoModel* metaPhotoModel))complete
{
    if(self.isHasLoadPhotos)
    {
        if(complete)
        {
            GPCMediaFilesMetaDataPhotoBelow8Model* meta = [GPCMediaFilesMetaDataPhotoBelow8Model new];
            meta.fetchAssets = self.allPhotosData;
            meta.groupAssets = self.allPhotoGroupDic;
            complete(YES,meta);
        }
        return;
    }
    
    self.filterType =  GPCInputALAssetsFilterTypeNoneEnum;
    __weak typeof (self) weakSelf = self;
    
    self.albumsData = [NSMutableArray new];
    self.allPhotosData = [NSMutableArray new];
    self.allPhotoGroupDic = [NSMutableDictionary new];
    
    [self loadAssetsGroupsWithTypes:self.groupTypes completion:^(NSArray* assetsGroups){
        [assetsGroups enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            ALAssetsGroup* assetGroup = (ALAssetsGroup*)obj;
            [weakSelf.albumsData addObject:assetGroup];
            
            if(idx == 0)
            {
                [assetGroup enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                    
                    if(result)
                    {
                    	[weakSelf.allPhotosData addObject:result];
                        [weakSelf.allPhotoGroupDic setObject:assetGroup forKey:[weakSelf getObjectAddressString:result]];
                    }
                }];
            }
        }];
        
        weakSelf.isHasLoadPhotos = YES;
        
        if(complete)
        {
            GPCMediaFilesMetaDataPhotoBelow8Model* meta = [GPCMediaFilesMetaDataPhotoBelow8Model new];
            meta.fetchAssets = weakSelf.allPhotosData;
            meta.groupAssets = weakSelf.allPhotoGroupDic;
            complete(YES,meta);
        }
    }];
}

//缩略图请求
- (void)requestThumbnailImage:(GPCRequestImageOption*)option
                 selectorCase:(GPCMediaFilesSelectorLocalPhotoCase*)selectorCase
                 requestBlock:(RequestThumanailImageForIndexBlock)requestBlock
{
    GPCMediaFilesSelectorLocalBelow8PhotoCase* photoCase = (GPCMediaFilesSelectorLocalBelow8PhotoCase*)selectorCase;
    if(photoCase.asset == nil) return;
    
    GPCLocalPhotoCaseDataModel* dataModel = [GPCLocalPhotoCaseDataModel new];
    if(option.deliveryMode == RequestImageDeliveryMode_Fast)
    {
    	if(option.isAsynchronous == YES)
        {
            dataModel.imageType = LocalPhotoImageType_Fast_Asyn;
        }else
        {
            dataModel.imageType = LocalPhotoImageType_Fast;
        }
    }else
    {
        if(option.isAsynchronous == YES)
        {
            dataModel.imageType = LocalPhotoImageType_Opportunistic_Asyn;
        }else
        {
            dataModel.imageType = LocalPhotoImageType_Opportunistic;
        }
    }
    dataModel.image = [UIImage imageWithCGImage:photoCase.asset.thumbnail];
    if(requestBlock)
    {
        requestBlock(photoCase,dataModel);
    }
}

//预览图请求
- (void)requestPreviewImage:(CGSize)previewSize photoModel:(GPCMediaFilesSelectorLocalPhotoCase*)photoModel
               requestBlock:(RequestPreviewImageForAssets)requestBlock
{
    GPCMediaFilesSelectorLocalBelow8PhotoCase* photoCase = (GPCMediaFilesSelectorLocalBelow8PhotoCase*)photoModel;
    if(photoCase.asset == nil) return;
    //先获取小预览图
    UIImage* smallPreviewImage = [UIImage imageWithCGImage:photoCase.asset.aspectRatioThumbnail];
    
    if(requestBlock)
    {
        requestBlock(NO,smallPreviewImage,photoCase);//告诉外面还没有加载完成，这是给上层一个暂时展示的粗略图
    }
    
    __weak typeof (self) weakSelf = self;
    NSBlockOperation*  operation = [NSBlockOperation blockOperationWithBlock:^{
        
        ALAssetRepresentation* representation = [photoCase.asset defaultRepresentation];
        UIImageOrientation orientation = UIImageOrientationUp;
        NSNumber* orientationValue = [photoCase.asset valueForProperty:@"ALAssetPropertyOrientation"];
        if (orientationValue != nil)
        {
            orientation = [orientationValue intValue];
        }
        UIImage* fullScreenImage = [UIImage imageWithCGImage:representation.fullResolutionImage
                                                  scale:representation.scale orientation:orientation];
        
        fullScreenImage = [fullScreenImage fixOrientation];//方向旋转
        
        //转到主线程队列
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [weakSelf.blockOperationDic removeObjectForKey:photoCase.photoKey];
            
            if(requestBlock)
            {
                requestBlock(YES,fullScreenImage,photoCase);
            }
        });
    }];
    
    [self.blockOperationDic setObject:operation forKey:photoCase.photoKey];
    
    [self.requestOperationQueue addOperation:operation];
}

- (void)stopCachingPreviewImage:(CGSize)previewSize photoModel:(GPCMediaFilesSelectorLocalPhotoCase *)photoModel
{
    GPCMediaFilesSelectorLocalBelow8PhotoCase* photoCase = (GPCMediaFilesSelectorLocalBelow8PhotoCase*)photoModel;
    if(photoCase.photoKey == nil) return;
    NSBlockOperation* blockOperation = [self.blockOperationDic objectForKey:photoCase.photoKey];
    if(blockOperation)
    {
        [blockOperation cancel];
        [self.blockOperationDic removeObjectForKey:photoCase.photoKey];
    }
}

//加载相册列表
- (void)loadUserPhotoAlbum:(void(^)(BOOL finished,GPCMediaFilesMetaDataGalleryModel* metaGallerysModel))complete
{
    if(self.isHasLoadUserGallery)
    {
        GPCMediaFilesMetaDataGalleryBelow8Model* meta = [GPCMediaFilesMetaDataGalleryBelow8Model new];
        meta.galleryGroup = self.albumsData;
        meta.galleryOfAssets = self.albumPhotos;
        meta.galleryGroupDic = self.albumGroupDic;
        if(complete)
        {
            complete(YES,meta);
        }
    }else
    {
        __weak typeof (self) weakSelf = self;
        self.albumGroupDic = [NSMutableDictionary new];
        self.albumPhotos = [NSMutableArray new];
        
        [self.albumsData enumerateObjectsUsingBlock:^(ALAssetsGroup * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSMutableArray* photos = [[NSMutableArray alloc] init];
            [obj enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                
                if(result)
                {
                	[photos addObject:result];
                }
            }];
            [weakSelf.albumGroupDic setObject:obj forKey:[weakSelf getObjectAddressString:photos]];
            [weakSelf.albumPhotos addObject:photos];
        }];
        
        GPCMediaFilesMetaDataGalleryBelow8Model* meta = [GPCMediaFilesMetaDataGalleryBelow8Model new];
        meta.galleryGroup = self.albumsData;
        meta.galleryOfAssets = self.albumPhotos;
        meta.galleryGroupDic = self.albumGroupDic;
        if(complete)
        {
            complete(YES,meta);
        }
    }
}

#pragma mark--加载视频列表
- (void)loadAllVideos:(void (^)(BOOL, GPCMediaFilesMetaDataPhotoModel *))complete
{
    if(self.isHasLoadVideos)
    {
        if(complete)
        {
            GPCMediaFilesMetaDataPhotoBelow8Model* meta = [GPCMediaFilesMetaDataPhotoBelow8Model new];
            meta.fetchAssets = self.allVideosData;
            meta.groupAssets = self.allVideoGroupDic;
            complete(YES,meta);
        }
        return;
    }
    
    self.filterType =  GPCInputALAssetsFilterTypeVideosEnum;
    __weak typeof (self) weakSelf = self;
    
    self.allVideosData = [NSMutableArray new];
    self.allVideoGroupDic = [NSMutableDictionary new];
    
    [self loadAssetsGroupsWithTypes:self.groupTypes completion:^(NSArray* assetsGroups){
        [assetsGroups enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            ALAssetsGroup* assetGroup = (ALAssetsGroup*)obj;
            if(idx == 0)
            {
                [assetGroup enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                    
                    if(result)
                    {
                        [weakSelf.allVideosData addObject:result];
                        [weakSelf.allVideoGroupDic setObject:assetGroup forKey:[weakSelf getObjectAddressString:result]];
                    }
                }];
            }
        }];
        
        weakSelf.isHasLoadVideos = YES;
        
        if(complete)
        {
            GPCMediaFilesMetaDataPhotoBelow8Model* meta = [GPCMediaFilesMetaDataPhotoBelow8Model new];
            meta.fetchAssets = weakSelf.allVideosData;
            meta.groupAssets = weakSelf.allVideoGroupDic;
            complete(YES,meta);
        }
    }];
}

- (void)loadUserVideoList:(void (^)(BOOL, GPCMediaFilesMetaDataGalleryModel *))complete
{
    if(self.isHasLoadUserVideos)
    {
        GPCMediaFilesMetaDataGalleryBelow8Model* meta = [GPCMediaFilesMetaDataGalleryBelow8Model new];
        meta.galleryGroup = self.videosData;
        meta.galleryOfAssets = self.videosPhotos;
        meta.galleryGroupDic = self.videosGroupDic;
        if(complete)
        {
            complete(YES,meta);
        }
    }else
    {
        self.videosPhotos = [NSMutableArray new];
        self.videosData = [NSMutableArray new];
        self.videosGroupDic = [NSMutableDictionary new];
        
        self.filterType =  GPCInputALAssetsFilterTypeVideosEnum;
        __weak typeof (self) weakSelf = self;
        [self loadAssetsGroupsWithTypes:self.groupTypes completion:^(NSArray* assetsGroups){
            [assetsGroups enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                ALAssetsGroup* assetGroup = (ALAssetsGroup*)obj;
                [weakSelf.videosData addObject:assetGroup];
                
                NSMutableArray* videos = [[NSMutableArray alloc] init];
                [assetGroup enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                    
                    if(result)
                    {
                        [videos addObject:result];
                    }
                }];
                [weakSelf.videosPhotos addObject:videos];
                [weakSelf.videosGroupDic setObject:assetGroup forKey:[weakSelf getObjectAddressString:videos]];
            }];
            
            weakSelf.isHasLoadPhotos = YES;
            
            GPCMediaFilesMetaDataGalleryBelow8Model* meta = [GPCMediaFilesMetaDataGalleryBelow8Model new];
            meta.galleryGroup = weakSelf.videosData;
            meta.galleryOfAssets = weakSelf.videosPhotos;
            meta.galleryGroupDic = weakSelf.videosGroupDic;
            if(complete)
            {
                complete(YES,meta);
            }
        }];
    }
}

- (void)requestVideoWithLocalPhotoCase:(GPCMediaFilesSelectorLocalPhotoCase *)photoCase complete:(RequestVideoBlock)complete
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        GPCMediaFilesSelectorLocalBelow8PhotoCase* belowCase = (GPCMediaFilesSelectorLocalBelow8PhotoCase*)photoCase;
        ALAssetRepresentation* representation = [belowCase.asset defaultRepresentation];
        AVPlayerItem* platerItem = [AVPlayerItem playerItemWithURL:representation.url];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(complete)
            {
                complete(YES,0,platerItem,nil);
            }
        });
    });
}

- (void)requestGalleryImage:(CGSize)targetSize galleryModel:(GPCMediaFilesSelectorAlbumCase*)galleryModel requestBlock:(RequestAlbumForIndexBlock)requestBlock
{
    GPCMediaFilesSelectorAlbumBelow8Case* galleryCase = (GPCMediaFilesSelectorAlbumBelow8Case*)galleryModel;
    GPCMediaFilesMetaDataPhotoBelow8Model* meta = galleryCase.metaData;
    
    if(meta.fetchAssets.count > 0)
    {
        ALAsset* asset = meta.fetchAssets[0];
        UIImage* image = [UIImage imageWithCGImage:asset.thumbnail];
        if(requestBlock)
        {
            requestBlock(image);
        }
    }else
    {
        if(requestBlock)
        {
            requestBlock(nil);
        }
    }
}

#pragma mark - 加载本地相册元数据
- (void)loadAssetsGroupsWithTypes:(NSArray *)types completion:(void (^)(NSArray *assetsGroups))completion
{
    __block NSMutableArray *assetsGroups = [NSMutableArray array];
    __block NSUInteger numberOfFinishedTypes = 0;
    for (NSNumber *type in types) {
        __weak typeof(self) weakSelf = self;
        [self.assetsLibrary enumerateGroupsWithTypes:[type unsignedIntegerValue]
                                          usingBlock:^(ALAssetsGroup *assetsGroup, BOOL *stop) {
                                              if (assetsGroup) {
                                                  // Filter the assets group
                                                  [assetsGroup setAssetsFilter:ALAssetsFilterFormALAssetsFilterTypeEnum(weakSelf.filterType)];
                                                  
                                                  if (assetsGroup.numberOfAssets > 0) {
                                                      // Add assets group
                                                      [assetsGroups addObject:assetsGroup];
                                                  }
                                              } else {
                                                  numberOfFinishedTypes++;
                                              }
                                              
                                              // Check if the loading finished
                                              if (numberOfFinishedTypes == types.count) {
                                                  // Sort assets groups
                                                  NSArray *sortedAssetsGroups = [self sortAssetsGroups:(NSArray *)assetsGroups typesOrder:types];
                                                  
                                                  // Call completion block
                                                  if (completion) {
                                                      completion(sortedAssetsGroups);
                                                  }
                                              }
                                          } failureBlock:^(NSError *error) {
                                              if(g_authorizeBlock)
                                              {
                                                  g_authorizeBlock(PhotoSelectorAuthorizationStatusDenied);
                                              }
                                          }];
    }
}

- (NSArray *)sortAssetsGroups:(NSArray *)assetsGroups typesOrder:(NSArray *)typesOrder
{
    NSMutableArray *sortedAssetsGroups = [NSMutableArray array];
    
    for (ALAssetsGroup *assetsGroup in assetsGroups)
    {
        if (sortedAssetsGroups.count == 0) {
            [sortedAssetsGroups addObject:assetsGroup];
            continue;
        }
        
        ALAssetsGroupType assetsGroupType = [[assetsGroup valueForProperty:ALAssetsGroupPropertyType] unsignedIntegerValue];
        NSUInteger indexOfAssetsGroupType = [typesOrder indexOfObject:@(assetsGroupType)];
        
        for (NSInteger i = 0; i <= sortedAssetsGroups.count; i++)
        {
            if (i == sortedAssetsGroups.count) {
                [sortedAssetsGroups addObject:assetsGroup];
                break;
            }
            
            ALAssetsGroup *sortedAssetsGroup = [sortedAssetsGroups objectAtIndex:i];
            ALAssetsGroupType sortedAssetsGroupType = [[sortedAssetsGroup valueForProperty:ALAssetsGroupPropertyType] unsignedIntegerValue];
            NSUInteger indexOfSortedAssetsGroupType = [typesOrder indexOfObject:@(sortedAssetsGroupType)];
            
            if (indexOfAssetsGroupType < indexOfSortedAssetsGroupType)
            {
                [sortedAssetsGroups insertObject:assetsGroup atIndex:i];
                break;
            }
        }
    }
    
    return [sortedAssetsGroups copy];
}

ALAssetsFilter * ALAssetsFilterFormALAssetsFilterTypeEnum(GPCALAssetsFilterTypeEnum type)
{
    switch (type)
    {
        case GPCInputALAssetsFilterTypeNoneEnum:
            return [ALAssetsFilter allAssets];
            break;
            
        case GPCInputALAssetsFilterTypePhotosEnum:
            return [ALAssetsFilter allPhotos];
            break;
            
        case GPCInputALAssetsFilterTypeVideosEnum:
            return [ALAssetsFilter allVideos];
            break;
    }
}
@end
