//
//  GPCMediaFilesSelectorCollectionView.h
//  GPCProject
//
//  Created by 李义真 on 2016/12/5.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPCMediaFilesSelectorCaseDataSource.h"

@interface GPCMediaFilesSelectorCollectionView : UIView
@property(nonatomic,strong,readonly)UICollectionView* collectionView;
@property(nonatomic,strong)GPCMediaFilesSelectorCaseDataSource* caseSource;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithBridgeClass:(Class)bridgeClass caseSourceClass:(Class)caseSourceClass;
- (instancetype)initWithFrame:(CGRect)frame bridgeClass:(Class)bridgeClass caseSourceClass:(Class)caseSourceClass;
- (void)preLoadAssetsWhenViewDidAppear;
- (void)reloadData;
@end
