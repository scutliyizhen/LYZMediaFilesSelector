//
//  GPCGridCollectionViewLayout.m
//  GameBible
//
//  Created by robertyzli on 16/4/19.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCGridCollectionViewLayout.h"

@interface GPCGridCollectionViewLayout()
{
    CGFloat _nextStartX;
    CGFloat _nextStartY;
    
    NSUInteger _currentSection;
}
@property(nonatomic,strong)NSMutableDictionary<NSString*,UICollectionViewLayoutAttributes*>* attributes;
@property(nonatomic,assign)CGFloat contentHeight;
@end

@implementation GPCGridCollectionViewLayout
- (instancetype)init
{
    if(self = [super init])
    {
        _numOfRow = 1;
        _currentSection = 0;
    }
    return self;
}

- (void)setNumOfRow:(NSUInteger)numOfRow
{
    if(numOfRow == 0)
    {
        _numOfRow = 1;
    }else
    {
        _numOfRow = numOfRow;
    }
}

- (NSMutableDictionary*)attributes
{
    if(_attributes == nil)
    {
        _attributes = [[NSMutableDictionary alloc] init];
    }
    return _attributes;
}

#pragma  mark--UICollectionViewLayout核心代码
- (void)prepareLayout
{
    [super prepareLayout];
    
    _nextStartX = self.contentEdgeInsets.left;
    _nextStartY = self.contentEdgeInsets.top;
    _contentHeight = self.contentEdgeInsets.top;
    
    if(CGSizeEqualToSize(CGSizeZero, _cellSize))
    {
        CGFloat width = (self.collectionView.bounds.size.width - self.contentEdgeInsets.left
                         - (self.numOfRow - 1) * self.cellHGap - self.contentEdgeInsets.right)/self.numOfRow;
        
        _cellSize = CGSizeMake(width, width);
    }
    if(self.updateCellSizeBlock)
    {
        self.updateCellSizeBlock(self.cellSize);
    }
    
    
    [self.attributes  removeAllObjects];
    
    NSUInteger sectionCount = 0;
    
    if([self.collectionView.dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)])
    {
        sectionCount = [self.collectionView.dataSource numberOfSectionsInCollectionView:self.collectionView];
    }
    for(NSUInteger sectionCounter = 0; sectionCounter < sectionCount; sectionCounter++)
    {
        NSUInteger cellCount = 0;
        if([self.collectionView.dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)])
        {
            cellCount = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:sectionCounter];
        }
        for(NSUInteger cellCounter = 0; cellCounter < cellCount; cellCounter ++)
        {
            NSIndexPath* indexPath = [NSIndexPath indexPathForItem:cellCounter inSection:sectionCounter];
            NSString* key = [self getLayoutKeyByIndexPath:indexPath];
            [self.attributes setObject:[self getlayoutAttributesForItemAtIndexPath:indexPath] forKey:key];
        }
    }
}

- (CGSize)collectionViewContentSize
{
    CGFloat height = self.contentEdgeInsets.top;
    NSUInteger sections = [self.collectionView numberOfSections];
    NSUInteger rows = 0;
    for(NSUInteger sectionCounter = 0; sectionCounter < sections; sectionCounter++)
    {
        NSUInteger items = [self.collectionView numberOfItemsInSection:sectionCounter];
        rows = rows + items% self.numOfRow == 0 ? items/self.numOfRow : items/self.numOfRow + 1;
        
    }
    height = height + rows * self.cellSize.height + (rows - 1) * self.cellVGap + self.contentEdgeInsets.bottom;
    
    return CGSizeMake(self.collectionView.bounds.size.width, height);
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray* tmpAttrs = [[NSMutableArray alloc] init];
    [self.attributes enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, UICollectionViewLayoutAttributes * _Nonnull obj, BOOL * _Nonnull stop) {
        if(CGRectIntersectsRect(rect, obj.frame))
        {
            [tmpAttrs addObject:obj];
        }
    }];
    
    return tmpAttrs;
}


- (UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.attributes objectForKey:[self getLayoutKeyByIndexPath:indexPath]];
}

- (NSString*)getLayoutKeyByIndexPath:(NSIndexPath*)indexPath
{
    return [NSString stringWithFormat:@"section_%ld_item_%ld",(long)indexPath.section,(long)indexPath.item];
}

//关键的布局代码，核心
- (UICollectionViewLayoutAttributes*)getlayoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    NSUInteger row = indexPath.item/self.numOfRow;
    NSUInteger column = indexPath.item%self.numOfRow;
    CGFloat frameX = self.contentEdgeInsets.left + column * self.cellHGap + column * self.cellSize.width;
    CGFloat frameY = 0.0;
    if(indexPath.section == 0)
    {
        frameY = self.contentEdgeInsets.top + row*self.cellVGap + row * self.cellSize.height;
    }else
    {
        NSUInteger lastSectionRows = [self.collectionView numberOfItemsInSection:indexPath.section - 1];
        frameY = self.contentEdgeInsets.top + (lastSectionRows/self.numOfRow)*self.cellVGap + row * self.cellVGap + lastSectionRows * self.cellSize.height + row* self.cellSize.height;
    }
    _contentHeight = frameY + self.cellSize.height;
    
    if(indexPath.section == [self.collectionView numberOfSections] - 1 && indexPath.row == [self.collectionView numberOfItemsInSection:indexPath.section])
    {
        //最后一个
        _contentHeight += self.contentEdgeInsets.bottom;
    }
    
    UICollectionViewLayoutAttributes* attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attr.frame = CGRectMake(frameX, frameY, self.cellSize.width, self.cellSize.height);
    
    return attr;
}
@end
