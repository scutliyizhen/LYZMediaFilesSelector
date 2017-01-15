//
//  GPCMediaFilesMetaDataGalleryBelow8Model.m
//  GameBible
//
//  Created by robertyzli on 16/7/16.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCMediaFilesMetaDataGalleryBelow8Model.h"
#import "GPCMediaFilesSelectorAlbumBelow8Case.h"
#import "GPCMediaFilesMetaDataPhotoBelow8Model.h"


@implementation GPCMediaFilesMetaDataGalleryBelow8Model
- (NSUInteger)numbersOfPictureModel
{
   return self.galleryGroup.count;
}

- (GPCMediaFilesSelectorCase*)getPicureModelFromMetaDataByIndex:(NSUInteger)index
{
    ALAssetsGroup* group = self.galleryGroup[index];
    GPCMediaFilesSelectorGalleryViewState* viewState = [self.bridge getSelectorGalleryCaseViewState:index];
    
    GPCMediaFilesSelectorAlbumBelow8Case* galleryCase = [[GPCMediaFilesSelectorAlbumBelow8Case alloc]
                                                         initWithViewState:viewState];
    galleryCase.groupAsset = group;
    
    GPCMediaFilesMetaDataPhotoBelow8Model* photoMeta = [GPCMediaFilesMetaDataPhotoBelow8Model new];
    ALAssetsGroup* groupAssets = [self.galleryGroupDic objectForKey:[NSString stringWithFormat:@"%p",photoMeta.fetchAssets]];
    NSMutableDictionary* groupDic = [NSMutableDictionary new];
    [photoMeta.fetchAssets enumerateObjectsUsingBlock:^(ALAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString* key = [NSString stringWithFormat:@"%p",obj];
        [groupDic setObject:groupAssets forKey:key];
    }];
    photoMeta.groupAssets = groupDic;
    photoMeta.fetchAssets = self.galleryOfAssets[index];
    
    galleryCase.metaData = photoMeta;
    
    return galleryCase;
}
@end
