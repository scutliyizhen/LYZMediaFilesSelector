//
//  GPCMediaFilesSelectorAlbumCase.h
//  GameBible
//
//  Created by robertyzli on 16/7/13.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCMediaFilesSelectorCase.h"
#import "GPCMediaFilesMetaDataPhotoModel.h"

@class GPCMediaFilesSelectorPhotoCaseDataSource;
@class GPCMediaFilesSelectorGalleryCaseDataSource;
@class GPCMediaFilesSelectorGalleryCellView;
@class GPCMediaFilesSelectorGalleryViewState;

@interface GPCMediaFilesSelectorAlbumCase : GPCMediaFilesSelectorCase
@property(nonatomic,strong,readonly)GPCMediaFilesSelectorPhotoCaseDataSource* photoDataSource;
@property(nonatomic,strong,readonly)NSString* galleryTitle;
@property(nonatomic,assign,readonly)NSUInteger photosCount;
@property(nonatomic,strong,readonly)GPCMediaFilesSelectorGalleryViewState* viewState;

@property(nonatomic,weak)GPCMediaFilesSelectorGalleryCellView* galleryCellView;
@property(nonatomic,weak)GPCMediaFilesSelectorGalleryCaseDataSource* galleryDataSource;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithViewState:(GPCMediaFilesSelectorGalleryViewState*)viewState;
@end
