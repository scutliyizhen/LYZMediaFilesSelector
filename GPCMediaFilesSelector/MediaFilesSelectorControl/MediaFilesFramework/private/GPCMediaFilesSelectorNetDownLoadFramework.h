//
//  GPCMediaFilesSelectorNetDownLoadFramework.h
//  GPCProject
//
//  Created by robertyzli on 2016/12/22.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPCMediaFilesMetaDataPhotoModel.h"

typedef void(^DownLoadPictureBlock)(BOOL finished,UIImage* image);

typedef NSString*(^GetDownloadPictureThumbnailURLBlock)(NSUInteger index);
typedef NSString*(^GetDownLoadPictureBigURLBlock)(NSUInteger index);

@interface GPCMediaFilesSelectorNetDownLoadFramework : NSObject
- (GPCMediaFilesMetaDataPhotoModel*)getPictureMetaDataPhotoModelByDownloadURLs:(NSArray<NSString*>*)downloadURLs;
- (GPCMediaFilesMetaDataPhotoModel*)getPictureMethDataPhotoModel:(NSUInteger)numOfPicUrls
                                          thumbnailImageBlock:(GetDownloadPictureThumbnailURLBlock)thumbnailImageBlock
                                                bigImageBlock:(GetDownLoadPictureBigURLBlock)bigImageBlock;
- (void)downloadPictureWithURL:(NSString*)URL complete:(DownLoadPictureBlock)complete;
@end
