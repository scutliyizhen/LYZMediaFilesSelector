//
//  GPCMediaFielsSelectorPhotoViewResponder.h
//  MTGP
//
//  Created by 李义真 on 2017/1/5.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "GPCMediaFilesSelectorBaseViewResponder.h"

@class GPCMediaFilesSelectorPhotoCellView;

@interface GPCMediaFilesSelectorPhotoViewResponder : GPCMediaFilesSelectorBaseViewResponder
+ (void)bindPhotoCellViewResponder:(GPCMediaFilesSelectorPhotoCellView *)cellView;
+ (NSMutableDictionary<NSString*,GPCMediaFilesSelectorPhotoCellView*>*)getGestureCellViewDic;
@end
