//
//  GPCMediaFilesSelectorCaseDataSource.m
//  GameBible
//
//  Created by robertyzli on 16/7/16.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCMediaFilesSelectorCaseDataSource.h"
#import "GPCMediaFilesSelectorFrameworkManager.h"
#import "GPCMediaFilesSelectorPhotoCaseDataSource.h"
#import "GPCMediaFilesSelectorCase.h"

@implementation GPCMediaFilesSelectorDownloadPictureModel
@end

@interface GPCMediaFilesSelectorCaseDataSource()
@property(nonatomic,copy)GPCGetPhotoCaseDataSouceBlock photoCaseSourceBlock;
@property(nonatomic,copy)GPCGetPhotoCaseDataSouceBlock videoCaseSourceBlock;
@property(nonatomic,copy)GPCGetGalleyCaseDataSourceBlock galleryPhotoCaseSourceBlock;
@property(nonatomic,copy)GPCGetGalleyCaseDataSourceBlock galleryVideoCaseSourceBlock;
@end

@implementation GPCMediaFilesSelectorCaseDataSource
+ (void)setThumPhotoSize:(CGSize)thumPhotoSize
{
    [GPCMediaFilesSelectorFrameworkManager shareInstance].assetGridThumbnailSize = thumPhotoSize;
}

+ (NSArray<NSString*>*)gridCellIdentifiers
{
    return @[NSStringFromClass([GPCMediaFilesSelectorCase class])];
}

+ (NSString*)getIdentifierByModel:(GPCMediaFilesSelectorCase *)model
{
    return NSStringFromClass([GPCMediaFilesSelectorCase class]);
}

+ (void)downloadPictuersWithURLs:(NSArray<GPCMediaFilesSelectorDownloadPictureModel*>*)URLs
                        complete:(GPCGetPhotoCaseDataSouceBlock)complete
{
    [GPCMediaFilesSelectorFrameworkManager authorizationStatusIsAuthorized:^(PhotoSelectorAuthorizationStatus authorizationStatus) {
        if(authorizationStatus == PhotoSelectorAuthorizationStatusAuthorized)
        {
            NSMutableArray<NSString*>* thumbnailImageURLs = [NSMutableArray new];
            NSMutableArray<NSString*>* bigImageURLs = [NSMutableArray new];
            
            [URLs enumerateObjectsUsingBlock:^(GPCMediaFilesSelectorDownloadPictureModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if(obj.thumbnailImageURL)
                {
                    [thumbnailImageURLs addObject:obj.thumbnailImageURL];
                }
                
                if(obj.bigImageURL)
                {
                    [bigImageURLs addObject:obj.bigImageURL];
                }
            }];
            
            if(thumbnailImageURLs.count == 0)
            {
                if(complete)
                {
                    complete(PhotoSelectorAuthorizationStatusAuthorized,nil);
                }
            }else
            {
            	if(thumbnailImageURLs.count != bigImageURLs.count)
                {
                    GPCMediaFilesMetaDataPhotoModel* metaModel = [[GPCMediaFilesSelectorFrameworkManager shareInstance] getPictureMetaDataPhotoModelByDownloadURLs:thumbnailImageURLs];
                    GPCMediaFilesSelectorPhotoCaseDataSource* caseSource = [[GPCMediaFilesSelectorPhotoCaseDataSource alloc] initWithMetaDataPhotoModel:metaModel];
                    if(complete)
                    {
                        complete(PhotoSelectorAuthorizationStatusAuthorized,caseSource);
                    }
                }else
                {
                    GPCMediaFilesMetaDataPhotoModel* metaModel = [[GPCMediaFilesSelectorFrameworkManager shareInstance] getPictureMethDataPhotoModel:thumbnailImageURLs.count thumbnailImageBlock:^NSString *(NSUInteger index)
                    {
                        return thumbnailImageURLs[index];
                    } bigImageBlock:^NSString *(NSUInteger index)
                    {
                        return bigImageURLs[index];
                    }];
                    
                    GPCMediaFilesSelectorPhotoCaseDataSource* caseSource = [[GPCMediaFilesSelectorPhotoCaseDataSource alloc] initWithMetaDataPhotoModel:metaModel];
                    if(complete)
                    {
                        complete(PhotoSelectorAuthorizationStatusAuthorized,caseSource);
                    }
                }
            }
        }else
        {
            if(complete)
            {
                complete(authorizationStatus,nil);
            }
        }
    }];
}

+ (void)loadAllPhotos:(Class)photoCaseClass  complete:(GPCGetPhotoCaseDataSouceBlock)complete;
{
    [GPCMediaFilesSelectorFrameworkManager authorizationStatusIsAuthorized:^(PhotoSelectorAuthorizationStatus authorStatus) {
        
        if(authorStatus == PhotoSelectorAuthorizationStatusAuthorized)
        {
            [[GPCMediaFilesSelectorFrameworkManager shareInstance] loadAllPhotos:^(BOOL finished, GPCMediaFilesMetaDataPhotoModel *metaPhotoModel) {
                
                id photoDataSource = [[photoCaseClass alloc] initWithMetaDataPhotoModel:metaPhotoModel];
                if(complete)
                {
                    complete(PhotoSelectorAuthorizationStatusAuthorized,photoDataSource);
                }
            }];
        }else
        {
            if(complete)
            {
                complete(authorStatus,nil);
            }
        }
    }];
}

+ (void)loadUserGallery:(Class)galleryCaseClass complete:(GPCGetGalleyCaseDataSourceBlock)complete
{
    [[GPCMediaFilesSelectorFrameworkManager shareInstance] loadUserPhotoAlbum:^(BOOL finished, GPCMediaFilesMetaDataGalleryModel *metaGallerysModel) {
        if(finished)
        {
            id gallerDataSource = [[galleryCaseClass alloc] initWithMetaDataPhotoModel:metaGallerysModel];
            if(complete)
            {
                complete(gallerDataSource);
            }
        }else
        {
            if(complete)
            {
                complete(nil);
            }
        }
    }];
}

+ (void)loadAllVideos:(Class)photoCaseClass  complete:(GPCGetPhotoCaseDataSouceBlock)complete
{
    [GPCMediaFilesSelectorFrameworkManager authorizationStatusIsAuthorized:^(PhotoSelectorAuthorizationStatus authorStatus) {
        
        if(authorStatus == PhotoSelectorAuthorizationStatusAuthorized)
        {
            [[GPCMediaFilesSelectorFrameworkManager shareInstance] loadAllVideos:^(BOOL finished, GPCMediaFilesMetaDataPhotoModel *metaPhotoModel) {
                id photoDataSource = [[photoCaseClass alloc] initWithMetaDataPhotoModel:metaPhotoModel];
                if(complete)
                {
                    complete(PhotoSelectorAuthorizationStatusAuthorized,photoDataSource);
                }
            }];
        }else
        {
            if(complete)
            {
                complete(authorStatus,nil);
            }
        }
    }];
}

+ (void)loadUserVideoList:(Class)galleryCaseClass complete:(GPCGetGalleyCaseDataSourceBlock)complete
{
    [[GPCMediaFilesSelectorFrameworkManager shareInstance] loadUserVideoList:^(BOOL finished, GPCMediaFilesMetaDataGalleryModel *metaGallerysModel) {
        if(finished)
        {
            id gallerDataSource = [[galleryCaseClass alloc] initWithMetaDataPhotoModel:metaGallerysModel];
            if(complete)
            {
                complete(gallerDataSource);
            }
        }else
        {
            if(complete)
            {
                complete(nil);
            }
        }
    }];
}

+ (void)loadAllLivePhotos:(Class)photoCaseClass complete:(GPCGetPhotoCaseDataSouceBlock)complete
{
    [GPCMediaFilesSelectorFrameworkManager authorizationStatusIsAuthorized:^(PhotoSelectorAuthorizationStatus authorStatus) {
        
        if(authorStatus == PhotoSelectorAuthorizationStatusAuthorized)
        {
            [[GPCMediaFilesSelectorFrameworkManager shareInstance] loadAllLivePhotos:^(BOOL finished, GPCMediaFilesMetaDataPhotoModel *metaPhotoModel) {
                id photoDataSource = [[photoCaseClass alloc] initWithMetaDataPhotoModel:metaPhotoModel];
                if(complete)
                {
                    complete(PhotoSelectorAuthorizationStatusAuthorized,photoDataSource);
                }
            }];
        }else
        {
            if(complete)
            {
                complete(authorStatus,nil);
            }
        }
    }];
}

- (instancetype)initWithMetaDataPhotoModel:(GPCMediaFilesMetaDataBaseModel *)metaDataModel
{
    if(self = [super init])
    {
        _metaDataModel = metaDataModel;
    }
    return self;
}

- (void)setBridge:(GPCMediaFilesSelectorBridge *)bridge
{
    _bridge = bridge;
    _metaDataModel.bridge = bridge;
}

- (NSUInteger)numberOfPicureModels
{
    return [_metaDataModel numbersOfPictureModel];
}

- (GPCMediaFilesSelectorCase*)getPictureSelectorModelInPictureListByIndex:(NSUInteger)index
{
    return [_metaDataModel getPicureModelFromMetaDataByIndex:index];
}
@end
