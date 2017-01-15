//
//  GPCInstagramGridView.h
//  GameBible
//
//  Created by robertyzli on 16/7/23.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCMediaFilesSelectorCollectionView.h"

typedef void(^PicSelectorPanGestrureBlock)(UIPanGestureRecognizer* panGesture,UIScrollView* scrollView);
typedef void(^CollectionViewUpDownEvent)(BOOL isUpDrag);

@interface GPCInstagramGridView : GPCMediaFilesSelectorCollectionView
@property(nonatomic,copy)PicSelectorPanGestrureBlock panGesBlock;
@property(nonatomic,copy)CollectionViewUpDownEvent srollViewUpDownDrag;
@end
