//
//  GPCMediaFilesSelectorAlbumAbove8Case.m
//  GameBible
//
//  Created by robertyzli on 16/7/18.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCMediaFilesSelectorAlbumAbove8Case.h"
#import "GPCMediaFilesSelectorPhotoCaseDataSource.h"
#import "GPCMediaFilesSelectorGalleryCaseDataSource.h"

@implementation GPCMediaFilesSelectorAlbumAbove8Case
- (GPCMediaFilesSelectorPhotoCaseDataSource*)photoDataSource
{
    GPCMediaFilesSelectorPhotoCaseDataSource* photoCaseSource = [[GPCMediaFilesSelectorPhotoCaseDataSource alloc] initWithMetaDataPhotoModel:self.metaData];
    photoCaseSource.bridge = self.galleryDataSource.bridge;
    return photoCaseSource;
}

- (NSString*)galleryTitle
{
   return self.phCollection.localizedTitle;
}

- (NSUInteger)photosCount
{
    return [self.metaData numbersOfPictureModel];
}
@end
