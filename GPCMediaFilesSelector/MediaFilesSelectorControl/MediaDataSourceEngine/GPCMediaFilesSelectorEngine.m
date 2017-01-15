//
//  GPCMediaFilesSelectorBaseEngine.m
//  GameBible
//
//  Created by robertyzli on 16/7/22.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCMediaFilesSelectorEngine.h"
#import "GPCMediaFilesSelectorCaseDataSource.h"
#import "GPCMediaFilesSelectorPhotoCaseDataSource.h"
#import "GPCMediaFilesSelectorGalleryCaseDataSource.h"
#import "GPCMediaFilesSelectorFrameworkManager.h"
#import "GPCMediaFilesSelectorPhotoCaseDataSource.h"

@interface GPCMediaFilesSelectorEngine()
@property(nonatomic,copy)GetPhotoCaseDataSouceBlock downloadPictureCaseSourceBlock;

@property(nonatomic,copy)GetPhotoCaseDataSouceBlock photoCaseSourceBlock;
@property(nonatomic,copy)GetGalleyCaseDataSourceBlock galleryCaseSourceBlock;

@property(nonatomic,copy)GetPhotoCaseDataSouceBlock videoCaseSourceBlock;
@property(nonatomic,copy)GetGalleyCaseDataSourceBlock videoGallerySourceBlock;

@property(nonatomic,copy)GetPhotoCaseDataSouceBlock livePhotoCaseSourceBlock;
@end

@implementation GPCMediaFilesSelectorEngine
#pragma mark--下载网络媒体相关接口
- (void)downloadPictuersWithURLs:(NSArray<GPCMediaFilesSelectorDownloadPictureModel*>*)URLs
                        complete:(GetPhotoCaseDataSouceBlock)complete
{
    self.downloadPictureCaseSourceBlock = complete;
    __weak typeof (self) weakSelf = self;
    [GPCMediaFilesSelectorCaseDataSource downloadPictuersWithURLs:URLs complete:^(PhotoSelectorAuthorizationStatus authonsizeState, GPCMediaFilesSelectorPhotoCaseDataSource *photoDataSource) {
        photoDataSource.bridge = weakSelf.bridge;
        if(weakSelf.downloadPictureCaseSourceBlock)
        {
            weakSelf.downloadPictureCaseSourceBlock(authonsizeState,photoDataSource);
        }
    }];
}

#pragma mark--加载本地相册媒体相关接口
- (void)loadAllPhotos:(GetPhotoCaseDataSouceBlock)allPhotosSelectorPhotoCaseDataSourceBlock
{
    self.photoCaseSourceBlock = allPhotosSelectorPhotoCaseDataSourceBlock;
    __weak typeof (self) weakSelf = self;
    [GPCMediaFilesSelectorCaseDataSource loadAllPhotos:[GPCMediaFilesSelectorPhotoCaseDataSource class] complete:^(PhotoSelectorAuthorizationStatus authonsizeState, GPCMediaFilesSelectorPhotoCaseDataSource *photoDataSource) {
        photoDataSource.bridge = weakSelf.bridge;
        if(weakSelf.photoCaseSourceBlock)
        {
            weakSelf.photoCaseSourceBlock(authonsizeState,photoDataSource);
        }
    }];
}

- (void)loadUserGallery:(GetGalleyCaseDataSourceBlock)galleryCaseDataSourceBlock
{
    __weak typeof (self) weakSelf = self;
    self.galleryCaseSourceBlock = galleryCaseDataSourceBlock;
    [GPCMediaFilesSelectorCaseDataSource loadUserGallery:[GPCMediaFilesSelectorGalleryCaseDataSource class] complete:^(GPCMediaFilesSelectorGalleryCaseDataSource *galleryDataSource) {
        galleryDataSource.bridge = weakSelf.bridge;
        if(weakSelf.galleryCaseSourceBlock)
        {
            weakSelf.galleryCaseSourceBlock(galleryDataSource);
        }
    }];
}

- (void)loadAllVideos:(GetPhotoCaseDataSouceBlock)allPhotosSelectorPhotoCaseDataSourceBlock
{
    self.videoCaseSourceBlock = allPhotosSelectorPhotoCaseDataSourceBlock;
    __weak typeof (self) weakSelf = self;
    
    [GPCMediaFilesSelectorCaseDataSource loadAllVideos:[GPCMediaFilesSelectorPhotoCaseDataSource class] complete:^(PhotoSelectorAuthorizationStatus authonsizeState, GPCMediaFilesSelectorPhotoCaseDataSource *photoDataSource) {
        photoDataSource.bridge = weakSelf.bridge;
        if(weakSelf.videoCaseSourceBlock)
        {
            weakSelf.videoCaseSourceBlock(authonsizeState,photoDataSource);
        }
    }];
}

- (void)loadUserVideoList:(GetGalleyCaseDataSourceBlock)galleryCaseDataSourceBlock
{
    __weak typeof (self) weakSelf = self;
    self.videoGallerySourceBlock = galleryCaseDataSourceBlock;
    [GPCMediaFilesSelectorCaseDataSource loadUserVideoList:[GPCMediaFilesSelectorGalleryCaseDataSource class] complete:^(GPCMediaFilesSelectorGalleryCaseDataSource *galleryDataSource) {
        galleryDataSource.bridge = weakSelf.bridge;
        if(weakSelf.videoGallerySourceBlock)
        {
            weakSelf.videoGallerySourceBlock(galleryDataSource);
        }
    }];
}

- (void)loadAllLivePhotos:(GetPhotoCaseDataSouceBlock)allPhotosSelectorPhotoCaseDataSourceBlock
{
    self.livePhotoCaseSourceBlock = allPhotosSelectorPhotoCaseDataSourceBlock;
    __weak typeof (self) weakSelf = self;
    
    [GPCMediaFilesSelectorCaseDataSource loadAllLivePhotos:[GPCMediaFilesSelectorPhotoCaseDataSource class] complete:^(PhotoSelectorAuthorizationStatus authonsizeState, GPCMediaFilesSelectorPhotoCaseDataSource *photoDataSource) {
        photoDataSource.bridge = weakSelf.bridge;
        if(weakSelf.livePhotoCaseSourceBlock)
        {
            weakSelf.livePhotoCaseSourceBlock(authonsizeState,photoDataSource);
        }
    }];
}
@end
