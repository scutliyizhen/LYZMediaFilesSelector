//
//  GPCInstagramGridView.m
//  GameBible
//
//  Created by robertyzli on 16/7/23.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCInstagramGridView.h"

@interface GPCInstagramGridView()<UIGestureRecognizerDelegate>
@property(nonatomic,strong)UIPanGestureRecognizer* panGestrure;
@end

@implementation GPCInstagramGridView
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.panGestrure = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        self.panGestrure.delegate = self;
        [self addGestureRecognizer:self.panGestrure];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (void)handlePan:(UIPanGestureRecognizer*)panGestrure
{
    if(self.panGesBlock)
    {
        self.panGesBlock(self.panGestrure,self.collectionView);
    }
}

//保证拖拽手势在UIScrollView与其父View上都生效
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma makr--UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(scrollView.contentOffset.y < -2)
    {
        if(self.srollViewUpDownDrag)
        {
            self.srollViewUpDownDrag(NO);
        }
    }else
    {
        if(self.srollViewUpDownDrag)
        {
            self.srollViewUpDownDrag(YES);
        }
    }
}
@end
