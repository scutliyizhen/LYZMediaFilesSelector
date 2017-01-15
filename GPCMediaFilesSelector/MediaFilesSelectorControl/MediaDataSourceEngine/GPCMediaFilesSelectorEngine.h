//
//  GPCMediaFilesSelectorBaseEngine.h
//  GameBible
//
//  Created by robertyzli on 16/7/22.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPCMediaFilesSelectorPhotoCaseDataSource.h"
#import "GPCMediaFilesSelectorGalleryCaseDataSource.h"

/**
 *  1.选中的照片数目更新通知，
 *  2.框架通知外面使用者选中数目的更新，由于事件触发的地方与外界层级比较远，降低耦合所以才用通知
 *  3.通知名：picSelectedNumNotification
 *  4.userinfo  key:selectedNumUpdateKey   value:NSNumber
 */

@class GPCMediaFilesSelectorBridge;

typedef void(^GetPhotoCaseDataSouceBlock) (PhotoSelectorAuthorizationStatus authonsizeState,GPCMediaFilesSelectorPhotoCaseDataSource* photoDataSource);
typedef void(^GetGalleyCaseDataSourceBlock)(GPCMediaFilesSelectorGalleryCaseDataSource* galleryDataSource);

@interface GPCMediaFilesSelectorEngine : NSObject
@property(nonatomic,strong)GPCMediaFilesSelectorBridge* bridge;

/*
 *加载网络图片相关接口
 */
- (void)downloadPictuersWithURLs:(NSArray<GPCMediaFilesSelectorDownloadPictureModel*>*)URLs
                        complete:(GetPhotoCaseDataSouceBlock)complete;

/*
 *本地相册照片相关接口
 */
- (void)loadAllPhotos:(GetPhotoCaseDataSouceBlock)allPhotosSelectorPhotoCaseDataSourceBlock;//加载默认全部照片
- (void)loadUserGallery:(GetGalleyCaseDataSourceBlock)galleryCaseDataSourceBlock;//加载相册列表

- (void)loadAllVideos:(GetPhotoCaseDataSouceBlock)allPhotosSelectorPhotoCaseDataSourceBlock;//加载所有视频
- (void)loadUserVideoList:(GetGalleyCaseDataSourceBlock)galleryCaseDataSourceBlock;//加载视频列表

- (void)loadAllLivePhotos:(GetPhotoCaseDataSouceBlock)allPhotosSelectorPhotoCaseDataSourceBlock;//加载所有LivePhoto
@end
