//
//  GPCMediaFilesSelectorLocalBelow8PhotoCase.m
//  GameBible
//
//  Created by robertyzli on 16/7/13.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCMediaFilesSelectorLocalBelow8PhotoCase.h"
#import "GPCMediaFilesSelectorFrameworkManager.h"
#import "GPCMediaFilesSelectorUtilityHelper.h"
#import <AssetsLibrary/ALAssetRepresentation.h>

@interface GPCMediaFilesSelectorLocalBelow8PhotoCase()
@property(nonatomic,strong)UIImage* downLoadThumImage;
@property(nonatomic,strong)NSMutableDictionary* downloadInfo;
@end

@implementation GPCMediaFilesSelectorLocalBelow8PhotoCase
- (NSString*)photoKey
{
  if(self.asset)//本地加载的媒体文件
  {
      NSURL* url = [self.asset valueForProperty:ALAssetPropertyAssetURL];
      return url.absoluteString;
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
        ALAssetRepresentation* representation = [self.asset defaultRepresentation];
        return representation.filename;
    }else
    {
    	 return [GPCMediaFilesSelectorUtilityHelper stringWithBase64EncodedString:self.photoKey];
    }
}

- (NSString*)galleryTitle
{
    if(self.asset)
    {
    	return [self.groupAsset valueForProperty:ALAssetsGroupPropertyName];
    }else
    {
    	return @"网络下载";
    }
}

- (NSDate*)createDate
{
    if(self.asset)
    {
    	return [self.asset valueForProperty:ALAssetPropertyDate];
    }else
    {
        return [NSDate date];
    }
}

- (void)requestUpdateIconImage:(RequestUpdateIConImageInfoBlock)complete
{
    if(self.asset == nil)
    {
        if(self.downLoadThumImage == nil)
        {
            __weak typeof (self) weakSelf = self;
            [[GPCMediaFilesSelectorFrameworkManager shareInstance] downloadPictureWithURL:self.thumbnailImageURL complete:^(BOOL finished, UIImage *image) {
                   if(complete)
                   {
                       weakSelf.downLoadThumImage = image;
                       complete(image,NO,weakSelf,[weakSelf getPhotoInfo]);
                   }
               }];
        }else
        {
        	if(complete)
            {
                complete(self.downLoadThumImage,NO,self,[self getPhotoInfo]);
            }
        }
    }else
    {
        [super requestUpdateIconImage:complete];
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
@end
