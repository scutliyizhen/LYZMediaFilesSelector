//
//  GPCPictureNetMetaDataPhotoAbove8Model.m
//  GPCProject
//
//  Created by robertyzli on 2016/12/22.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCMediaFilesNetMetaDataPhotoAbove8Model.h"
#import "GPCMediaFilesSelectorLocalAbove8PhotoCase.h"

@implementation GPCPictureNetMetaDataPhotoAbove8Model
- (NSUInteger)numbersOfPictureModel
{
    return self.thumbnailImageURLs.count == self.bigImageURLs.count ? self.thumbnailImageURLs.count : 0;
}

- (GPCMediaFilesSelectorCase*)getPicureModelFromMetaDataByIndex:(NSUInteger)index
{
    GPCMediaFilesSelectorPhotoViewState* viewState = [self.bridge getSelectorPhotoCaseViewState:index];
    GPCMediaFilesSelectorLocalAbove8PhotoCase*model = [[GPCMediaFilesSelectorLocalAbove8PhotoCase alloc] initWithViewState:viewState];
    model.thumbnailImageURL = self.thumbnailImageURLs[index];
    model.bigImageURL = self.bigImageURLs[index];
    model.index = index;
    return model;
}
@end
