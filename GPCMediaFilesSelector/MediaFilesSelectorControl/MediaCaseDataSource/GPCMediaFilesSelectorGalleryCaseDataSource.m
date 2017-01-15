//
//  GPCMediaFilesSelectorGalleryCaseDataSource.m
//  GameBible
//
//  Created by robertyzli on 16/7/16.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCMediaFilesSelectorGalleryCaseDataSource.h"
#import "GPCMediaFilesSelectorUtilityHelper.h"
#import "GPCMediaFilesSelectorBridge.h"

#define GPC_PHOTO_ALBUM_IMAGE_HEIGHT (GPC_WIDTH_RATIO*130/2.0)

@interface GPCMediaFilesSelectorGalleryCaseDataSource()
@property(nonatomic,assign,readwrite)CGSize targetSize;
@end

@implementation GPCMediaFilesSelectorGalleryCaseDataSource
+ (NSArray<NSString*>*)gridCellIdentifiers
{
    NSMutableArray* tmp = [NSMutableArray new];
    [tmp addObject:NSStringFromClass([GPCMediaFilesSelectorAlbumCase class])];
    return tmp;
}

+ (NSString*)getIdentifierByModel:(GPCMediaFilesSelectorCase *)model
{
    return NSStringFromClass([GPCMediaFilesSelectorAlbumCase class]);
}

- (instancetype)initWithMetaDataPhotoModel:(GPCMediaFilesMetaDataBaseModel *)metaDataModel
{
    if(self = [super initWithMetaDataPhotoModel:metaDataModel])
    {
        self.targetSize = CGSizeMake(GPC_PHOTO_ALBUM_IMAGE_HEIGHT, GPC_PHOTO_ALBUM_IMAGE_HEIGHT);
    }
    return self;
}

- (GPCMediaFilesSelectorCase*)getPictureSelectorModelInPictureListByIndex:(NSUInteger)index
{
    GPCMediaFilesSelectorAlbumCase* galleryCase = (GPCMediaFilesSelectorAlbumCase*)[super getPictureSelectorModelInPictureListByIndex:index];
    galleryCase.galleryDataSource = self;
    return galleryCase;
}
@end


