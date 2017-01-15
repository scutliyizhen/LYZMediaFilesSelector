//
//  GPCMediaFilesSelectorTakingPhotoCase.m
//  GameBible
//
//  Created by robertyzli on 16/7/13.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCMediaFilesSelectorTakingPhotoCase.h"

@implementation GPCMediaFilesSelectorTakingPhotoCase
- (void)requestPreviewImageOperation:(RequestPreviewImageBlock)requestBlok
{
    if(requestBlok)
    {
        requestBlok(YES,self.iconImage,self);
    }
}

- (UIImage*)iconImage
{
    return self.takingImage;
}
@end
