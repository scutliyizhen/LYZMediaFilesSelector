//
//  GPCMediaFilesSelectorNetDownLoadFramework.m
//  GPCProject
//
//  Created by robertyzli on 2016/12/22.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCMediaFilesSelectorNetDownLoadFramework.h"
#import "GPCMediaFilesSelectorUtilityHelper.h"
#import "GPCMediaFilesNetMetaDataPhotoAbove8Model.h"
#import "GPCMediaFilesNetMetaDataPhotoBelow8Model.h"
#import "SDWebImageManager.h"

@implementation GPCMediaFilesSelectorNetDownLoadFramework
- (GPCMediaFilesMetaDataPhotoModel*)getPictureMetaDataPhotoModelByDownloadURLs:(NSArray<NSString *> *)downloadURLs
{
    if(downloadURLs == nil) return nil;
    
    if(GPC_IOS_SYSTEM_VERSION_GREATER_8_0)
    {
        GPCPictureNetMetaDataPhotoAbove8Model* metaData = [GPCPictureNetMetaDataPhotoAbove8Model new];
        metaData.thumbnailImageURLs = downloadURLs;
        metaData.bigImageURLs = downloadURLs;
        return metaData;
    }else
    {
        GPCPictureNetMetaDataPhotoBelow8Model* metaData = [GPCPictureNetMetaDataPhotoBelow8Model new];
        metaData.thumbnailImageURLs = downloadURLs;
        metaData.bigImageURLs = downloadURLs;
        return metaData;
    }
}

- (GPCMediaFilesMetaDataPhotoModel*)getPictureMethDataPhotoModel:(NSUInteger)numOfPicUrls
                                          thumbnailImageBlock:(GetDownloadPictureThumbnailURLBlock)thumbnailImageBlock
                                                bigImageBlock:(GetDownLoadPictureBigURLBlock)bigImageBlock
{
    NSMutableArray* thumbnailImageURLs = [NSMutableArray new];
    NSMutableArray* bigImageURLs = [NSMutableArray new];
    
    if(thumbnailImageBlock)
    {
        for(NSUInteger i = 0 ; i < numOfPicUrls ; i ++)
        {
            NSString* url = thumbnailImageBlock(i);
            if(url)
            {
                [thumbnailImageURLs addObject:url];
            }
        }
    }
    
    if(bigImageBlock)
    {
        for(NSUInteger i = 0 ; i < numOfPicUrls ; i ++)
        {
            NSString* url = bigImageBlock(i);
            if(url)
            {
                [bigImageURLs addObject:url];
            }
        }
    }
    
    if(thumbnailImageURLs.count != numOfPicUrls || bigImageURLs.count != numOfPicUrls)
    {
        NSAssert(thumbnailImageURLs.count != numOfPicUrls, @"thumbnailImageURLs.count != numOfPicUrls");
        NSAssert(bigImageURLs.count != numOfPicUrls, @"bigImageURLs.count != numOfPicUrls");
        
        return nil;
    }else
    {
    	if(numOfPicUrls == 0)
        {
            return nil;
        }else
        {
            if(GPC_IOS_SYSTEM_VERSION_GREATER_8_0)
            {
                GPCPictureNetMetaDataPhotoAbove8Model* metaData = [GPCPictureNetMetaDataPhotoAbove8Model new];
                metaData.thumbnailImageURLs = thumbnailImageURLs;
                metaData.bigImageURLs = bigImageURLs;
                return metaData;
            }else
            {
                GPCPictureNetMetaDataPhotoBelow8Model* metaData = [GPCPictureNetMetaDataPhotoBelow8Model new];
                metaData.thumbnailImageURLs = thumbnailImageURLs;
                metaData.bigImageURLs = bigImageURLs;
                return metaData;
            }
        }
    }
}

- (void)downloadPictureWithURL:(NSString *)URL complete:(DownLoadPictureBlock)complete
{
    NSURL* url = [NSURL URLWithString:URL];
    if(url == nil)
    {
    	if(complete)
        {
            complete(NO,nil);
        }
    }else
    {
        [[SDWebImageManager sharedManager] downloadImageWithURL:url options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if(complete)
            {
                complete(finished,image);
            }
        }];
    }
}
@end
