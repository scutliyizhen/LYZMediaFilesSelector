//
//  GPCMediaFilesSelectorActionViewResponder.m
//  MTGP
//
//  Created by 李义真 on 2017/1/6.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "GPCMediaFilesSelectorActionViewResponder.h"
#import "GPCMediaFilesSelectorActionCase.h"
#import "GPCMediaFilesSelectorActionCellView.h"

static NSMutableDictionary<NSString*,GPCMediaFilesSelectorActionCellView*>* g_ActionCellViewResponderDic;

@implementation GPCMediaFilesSelectorActionViewResponder
+ (void)initialize
{
    g_ActionCellViewResponderDic = [NSMutableDictionary new];
}

+ (void)bindActionCellViewResponder:(GPCMediaFilesSelectorActionCellView *)cellView
{
    if(cellView == nil) return;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectorCellViewClick:)];
    [cellView addGestureRecognizer:tap];
    
    NSString* key = [self getSelectorCellViewKey:tap];
    [g_ActionCellViewResponderDic setObject:cellView forKey:key];
}

+ (NSMutableDictionary<NSString*,GPCMediaFilesSelectorActionCellView*>*)getGestureCellViewDic
{
    return g_ActionCellViewResponderDic;
}

+ (void)selectorCellViewClick:(UITapGestureRecognizer*)gs
{
    NSString* key = [self getSelectorCellViewKey:gs];
    GPCMediaFilesSelectorCellView* cellView = [g_ActionCellViewResponderDic objectForKey:key];
    if([cellView isKindOfClass:[GPCMediaFilesSelectorActionCellView class]])
    {
        GPCMediaFilesSelectorActionCellView* actionCellView = (GPCMediaFilesSelectorActionCellView*)cellView;
        [actionCellView.actionCase bindViewClickEvent:actionCellView cellView:actionCellView selectorCase:actionCellView.actionCase];
    }
}
@end
