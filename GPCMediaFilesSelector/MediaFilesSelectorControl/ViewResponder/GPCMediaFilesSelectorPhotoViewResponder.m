//
//  GPCMediaFielsSelectorPhotoViewResponder.m
//  MTGP
//
//  Created by 李义真 on 2017/1/5.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "GPCMediaFilesSelectorPhotoViewResponder.h"
#import "GPCMediaFilesSelectorPhotoCase.h"
#import "GPCMediaFilesSelectorPhotoCellView.h"

static NSMutableDictionary<NSString*,GPCMediaFilesSelectorPhotoCellView*>* g_PhotoCellViewResponderDic;

@implementation GPCMediaFilesSelectorPhotoViewResponder
+ (void)initialize
{
    g_PhotoCellViewResponderDic = [NSMutableDictionary new];
}

+ (void)bindPhotoCellViewResponder:(GPCMediaFilesSelectorPhotoCellView *)cellView
{
    if(cellView == nil) return;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectorCellViewClick:)];
    [cellView addGestureRecognizer:tap];
    
    NSString* key = [self getSelectorCellViewKey:tap];
    [g_PhotoCellViewResponderDic setObject:cellView forKey:key];
}

+ (NSMutableDictionary<NSString*,GPCMediaFilesSelectorPhotoCellView*>*)getGestureCellViewDic
{
    return g_PhotoCellViewResponderDic;
}

+ (void)selectorCellViewClick:(UITapGestureRecognizer*)gs
{
    NSString* key = [self getSelectorCellViewKey:gs];
    GPCMediaFilesSelectorCellView* cellView = [g_PhotoCellViewResponderDic objectForKey:key];
    if([cellView isKindOfClass:[GPCMediaFilesSelectorPhotoCellView class]])
    {
        GPCMediaFilesSelectorPhotoCellView* photoCellView = (GPCMediaFilesSelectorPhotoCellView*)cellView;
        [photoCellView.photoCase bindViewClickEvent:photoCellView cellView:photoCellView selectorCase:photoCellView.photoCase];
    }
}
@end
