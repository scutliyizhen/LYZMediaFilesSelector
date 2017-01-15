//
//  GPCMediaFilesSelectorActionViewResponder.h
//  MTGP
//
//  Created by 李义真 on 2017/1/6.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "GPCMediaFilesSelectorBaseViewResponder.h"

@class GPCMediaFilesSelectorActionCellView;
@interface GPCMediaFilesSelectorActionViewResponder : GPCMediaFilesSelectorBaseViewResponder
+ (void)bindActionCellViewResponder:(GPCMediaFilesSelectorActionCellView *)cellView;
+ (NSMutableDictionary<NSString*,GPCMediaFilesSelectorActionCellView*>*)getGestureCellViewDic;
@end
