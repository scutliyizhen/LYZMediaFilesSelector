//
//  GPCMediaFilesMetaDataGalleryAbove8Model.m
//  GameBible
//
//  Created by robertyzli on 16/7/16.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCMediaFilesMetaDataGalleryAbove8Model.h"
#import "GPCMediaFilesMetaDataPhotoAbove8Model.h"
#import "GPCMediaFilesSelectorAlbumAbove8Case.h"
#import "GPCMediaFilesSelectorGalleryViewState.h"

@implementation GPCMediaFilesMetaDataGalleryAbove8Model
- (NSUInteger)numbersOfPictureModel
{
    return self.galleryConllections.count;
}

- (GPCMediaFilesSelectorCase*)getPicureModelFromMetaDataByIndex:(NSUInteger)index
{  
    PHCollection* collection = self.galleryConllections[index];
    GPCMediaFilesSelectorGalleryViewState* viewState = [self.bridge getSelectorGalleryCaseViewState:index];
    GPCMediaFilesSelectorAlbumAbove8Case* galleryModel = [[GPCMediaFilesSelectorAlbumAbove8Case alloc]
                                                          initWithViewState:viewState];
    galleryModel.phCollection = collection;
    
    GPCMediaFilesMetaDataPhotoAbove8Model* metaDataPhotoModel = [GPCMediaFilesMetaDataPhotoAbove8Model new];
    NSArray<PHAsset*>* fetchResult = self.galleryFetchAssets[index];
    metaDataPhotoModel.fetchPhotoAssets = fetchResult;
    
    galleryModel.metaData = metaDataPhotoModel;
    
    return galleryModel;
}
@end
