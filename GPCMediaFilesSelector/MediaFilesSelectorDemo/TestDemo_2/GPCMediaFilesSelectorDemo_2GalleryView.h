//
//  GPCMediaFilesSelectorDemo_2GalleryView.h
//  GameBible
//
//  Created by robertyzli on 16/7/17.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPCMediaFilesSelectorGalleryCaseDataSource.h"

typedef void(^NaviBackClickBlock)();

@interface GPCMediaFilesSelectorDemo_2GalleryView : UIView
@property(nonatomic,strong)GPCMediaFilesSelectorGalleryCaseDataSource* galleryDataSource;
@property(nonatomic,copy)NaviBackClickBlock goBackBlock;
- (void)reloadGalleryView;
- (void)preLoadAssetsWhenViewDidAppear;
@end
