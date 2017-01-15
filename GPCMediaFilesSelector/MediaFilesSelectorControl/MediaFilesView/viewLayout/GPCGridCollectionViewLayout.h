//
//  GPCGridCollectionViewLayout.h
//  GameBible
//
//  Created by robertyzli on 16/4/19.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UpdateCellSizeBlock)(CGSize cellSize);

@interface GPCGridCollectionViewLayout : UICollectionViewLayout
@property(nonatomic,copy)UpdateCellSizeBlock updateCellSizeBlock;
@property(nonatomic,assign)CGFloat cellHGap;
@property(nonatomic,assign)CGFloat cellVGap;
@property(nonatomic,assign)UIEdgeInsets contentEdgeInsets;
@property(nonatomic,assign)CGSize cellSize;
@property(nonatomic,assign)NSUInteger numOfRow;
@end
