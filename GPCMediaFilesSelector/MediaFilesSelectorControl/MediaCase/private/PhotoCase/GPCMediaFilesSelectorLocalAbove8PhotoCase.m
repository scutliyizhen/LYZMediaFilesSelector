//
//  GPCMediaFilesSelectorLocalAbove8PhotoCase.m
//  GameBible
//
//  Created by robertyzli on 16/7/13.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <Photos/PHFetchOptions.h>
#import <Photos/PHCollection.h>
#import "GPCMediaFilesSelectorLocalAbove8PhotoCase.h"
#import "GPCMediaFilesSelectorFrameworkManager.h"
#import "GPCMediaFilesSelectorUtilityHelper.h"

@interface GPCMediaFilesSelectorLocalAbove8PhotoCase()
@property(nonatomic,strong)NSString* gallaryTitleName;
@property(nonatomic,strong)UIImage* downloadThumImage;
@property(nonatomic,strong)NSMutableDictionary* downloadInfo;
@end


@implementation GPCMediaFilesSelectorLocalAbove8PhotoCase
- (NSString*)photoKey
{
    if(self.asset)//本地相册加载的媒体文件，不限定图片
    {
    	return self.asset.localIdentifier;
    }else
    {
        if(self.thumbnailImageURL)
        {
        	return [NSString stringWithFormat:@"%@_%lu",self.thumbnailImageURL,(unsigned long)self.index];
        }else
        {
        	return [NSString stringWithFormat:@"%lu",(unsigned long)self.index];
        }
    }
}

- (NSString*)photoTitle
{
    if(self.asset)
    {
    	return [self.asset valueForKey:@"filename"];
    }else
    {
        return [GPCMediaFilesSelectorUtilityHelper stringWithBase64EncodedString:self.photoKey];
    }
}

- (NSString*)galleryTitle
{
    if(self.asset)
    {
        if(self.gallaryTitleName)
        {
            return self.gallaryTitleName;
        }else
        {
            PHFetchOptions* options = [PHFetchOptions new];
            PHFetchResult<PHAssetCollection *>* result = [PHAssetCollection fetchAssetCollectionsContainingAsset:self.asset withType:PHAssetCollectionTypeAlbum options:options];
            
            if(result.count > 0)
            {
                PHAssetCollection* collection = [result objectAtIndex:0];
                self.gallaryTitleName = collection.localizedTitle;
                return self.gallaryTitleName;
            }
            return nil;
        }

    }else
    {
        return @"网络下载";
    }
}

- (NSDate*)createDate
{
    if(self.asset)
    {
        return self.asset.creationDate;
    }else
    {
        return [NSDate date];
    }
}

- (UIImage*)iconImage
{
    if(self.thumbnailImageURL.length > 0)
    {
        return self.downloadThumImage;
    }else
    {
       return [super iconImage];
    }
}

- (void)requestUpdateIconImage:(RequestUpdateIConImageInfoBlock)complete
{
    //下载网络中图片
    if(self.thumbnailImageURL.length > 0)
    {
        if(self.downloadThumImage == nil)
        {
            __weak typeof (self) weakSelf = self;
            [[GPCMediaFilesSelectorFrameworkManager shareInstance] downloadPictureWithURL:self.thumbnailImageURL complete:^(BOOL finished, UIImage *image) {
                if(complete)
                {
                    weakSelf.downloadThumImage = image;
                    complete(image,NO,weakSelf,[weakSelf getPhotoInfo]);
                }
            }];
        }else
        {
            if(complete)
            {
                complete(self.downloadThumImage,NO,self,[self getPhotoInfo]);
            }
        }
    }
    //加载本地相册中的照片
    if(self.asset)
    {
        [super requestUpdateIconImage:complete];
    }
}

- (void)requestLivePhoto:(RequestLivePhotoBlock)requestBlock
{
    if(self.asset)
    {
        CGSize sizeFor6Plus = CGSizeMake(414, 736);//逻辑尺寸
        [[GPCMediaFilesSelectorFrameworkManager shareInstance] requestLivePhotoWithLocalPhotoCase:sizeFor6Plus photoCase:self complete:requestBlock];
    }
}

//预览图不做缓存
- (void)requestPreviewImageOperation:(RequestPreviewImageBlock)requestBlok
{
	if(self.asset == nil)
    {
        __weak typeof (self) weakSelf = self;
        [[GPCMediaFilesSelectorFrameworkManager shareInstance] downloadPictureWithURL:self.bigImageURL complete:^(BOOL finished, UIImage *image) {
            if(requestBlok)
            {
                requestBlok(finished,image,weakSelf);
            }
        }];
    }else
    {
        [super requestPreviewImageOperation:requestBlok];
    }
}

- (void)requestVideoOperation:(RequestVideoBlock)requestBlock
{
	if(self.asset)
    {
        [super requestVideoOperation:requestBlock];
    }
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"\n index:%lu isDisplaying:%d exposureCount:%lu",(unsigned long)self.index,self.isDisplayOnScreen,(unsigned long)self.exposureCount];
}
@end
