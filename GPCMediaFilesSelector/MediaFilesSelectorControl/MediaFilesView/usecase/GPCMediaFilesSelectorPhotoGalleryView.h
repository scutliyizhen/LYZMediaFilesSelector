//
//  GPCMediaFilesSelectorPhotoGalleryView.h
//  GameBible
//
//  Created by robertyzli on 16/7/16.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPCMediaFilesSelectorGalleryCaseDataSource.h"

@interface GPCMediaFilesSelectorPhotoGalleryView : UIView
@property(nonatomic,strong)GPCMediaFilesSelectorGalleryCaseDataSource* galleryDataSource;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithBridgeClass:(Class)bridgeClass caseSourceClass:(Class)caseSourceClass;
- (instancetype)initWithFrame:(CGRect)frame bridgeClass:(Class)bridgeClass caseSourceClass:(Class)caseSourceClass;
- (void)reloadData;
- (void)preLoadAssetsWhenViewDidAppear;
@end
