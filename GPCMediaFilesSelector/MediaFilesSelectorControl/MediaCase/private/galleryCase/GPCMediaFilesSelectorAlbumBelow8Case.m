//
//  GPCMediaFilesSelectorAlbumBelow8Case.m
//  GameBible
//
//  Created by robertyzli on 16/7/18.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCMediaFilesSelectorAlbumBelow8Case.h"
#import "GPCMediaFilesSelectorPhotoCaseDataSource.h"
#import "GPCMediaFilesSelectorGalleryCaseDataSource.h"

@implementation GPCMediaFilesSelectorAlbumBelow8Case
- (GPCMediaFilesSelectorPhotoCaseDataSource*)photoDataSource
{
    return [[GPCMediaFilesSelectorPhotoCaseDataSource alloc] initWithMetaDataPhotoModel:self.metaData];
}

- (NSString*)galleryTitle
{
    return [self.groupAsset valueForProperty:ALAssetsGroupPropertyName];
}

- (NSUInteger)photosCount
{
    return [self.metaData numbersOfPictureModel];
}
@end
