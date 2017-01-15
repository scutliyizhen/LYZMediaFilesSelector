//
//  GPCMediaFilesSelectorGalleryCellView.h
//  GPCProject
//
//  Created by 李义真 on 2016/12/4.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCMediaFilesSelectorCellView.h"
#import "GPCMediaFilesSelectorAlbumCase.h"

@interface GPCMediaFilesSelectorGalleryCellView : GPCMediaFilesSelectorCellView
@property(nonatomic,strong,readonly)UIImageView* imageView;
@property(nonatomic,strong)GPCMediaFilesSelectorAlbumCase* galleryCase;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithResponderClass:(Class)responderClass frame:(CGRect)frame;
@end
