//
//  GPCMediaFilesSelectorGalleryViewResponder.m
//  MTGP
//
//  Created by 李义真 on 2017/1/6.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "GPCMediaFilesSelectorGalleryViewResponder.h"
#import "GPCMediaFilesSelectorAlbumCase.h"
#import "GPCMediaFilesSelectorGalleryCellView.h"

static NSMutableDictionary<NSString*,GPCMediaFilesSelectorGalleryCellView*>* g_GalleryCellViewResponderDic;

@implementation GPCMediaFilesSelectorGalleryViewResponder
+ (void)initialize
{
    g_GalleryCellViewResponderDic = [NSMutableDictionary new];
}

+ (void)bindGalleryCellViewResponder:(GPCMediaFilesSelectorGalleryCellView *)cellView
{
    if(cellView == nil) return;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectorCellViewClick:)];
    [cellView addGestureRecognizer:tap];
    
    NSString* key = [self getSelectorCellViewKey:tap];
    [g_GalleryCellViewResponderDic setObject:cellView forKey:key];
}

+ (NSMutableDictionary<NSString*,GPCMediaFilesSelectorGalleryCellView*>*)getGestureCellViewDic
{
    return g_GalleryCellViewResponderDic;
}

+ (void)selectorCellViewClick:(UITapGestureRecognizer*)gs
{
    NSString* key = [self getSelectorCellViewKey:gs];
    GPCMediaFilesSelectorCellView* cellView = [g_GalleryCellViewResponderDic objectForKey:key];
    if([cellView isKindOfClass:[GPCMediaFilesSelectorGalleryCellView class]])
    {
        GPCMediaFilesSelectorGalleryCellView* galleryCellView = (GPCMediaFilesSelectorGalleryCellView*)cellView;
        [galleryCellView.galleryCase bindViewClickEvent:galleryCellView cellView:galleryCellView selectorCase:galleryCellView.galleryCase];
    }
}
@end
