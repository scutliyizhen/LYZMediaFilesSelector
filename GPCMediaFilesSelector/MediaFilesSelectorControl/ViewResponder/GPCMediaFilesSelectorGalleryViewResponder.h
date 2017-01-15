//
//  GPCMediaFilesSelectorGalleryViewResponder.h
//  MTGP
//
//  Created by 李义真 on 2017/1/6.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "GPCMediaFilesSelectorBaseViewResponder.h"

@class GPCMediaFilesSelectorGalleryCellView;
@interface GPCMediaFilesSelectorGalleryViewResponder : GPCMediaFilesSelectorBaseViewResponder
+ (void)bindGalleryCellViewResponder:(GPCMediaFilesSelectorGalleryCellView *)cellView;
+ (NSMutableDictionary<NSString*,GPCMediaFilesSelectorGalleryCellView*>*)getGestureCellViewDic;
@end
