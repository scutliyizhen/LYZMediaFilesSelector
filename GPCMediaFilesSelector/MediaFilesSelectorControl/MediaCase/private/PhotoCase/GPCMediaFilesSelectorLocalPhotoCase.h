//
//  GPCMediaFilesSelectorLocalPhotoCase.h
//  GameBible
//
//  Created by robertyzli on 16/7/18.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCMediaFilesSelectorPhotoCase.h"

@class GPCMediaFilesSelectorLocalPhotoCase;

typedef void(^SelectorCaseAddOperationBlock)(NSOperation* operation);
typedef BOOL(^SelectorCaseIsExistedQueueBlock)(NSOperation* operation);

typedef NS_ENUM(NSUInteger, LocalPhotoImageType) {
    LocalPhotoImageType_Opportunistic,
    LocalPhotoImageType_Opportunistic_Asyn,
    LocalPhotoImageType_Fast,
    LocalPhotoImageType_Fast_Asyn,
};

typedef BOOL(^LocalPhotoCaseSearchOperationBlock)(NSOperation* operation);
typedef void(^LocalPhotoCaseAddedOperationBlock)(NSOperation* operation);
typedef void(^LocalPhotoCaseAddedCaseOnDisplayingBlock)(GPCMediaFilesSelectorLocalPhotoCase* photoCase);
typedef void(^LocalPhotoCaseDeletedCaseOnDisplayingBlock)(GPCMediaFilesSelectorLocalPhotoCase* photoCase);


@interface GPCLocalPhotoCaseDataModel:NSObject
@property(nonatomic,strong)UIImage* image;
@property(nonatomic,assign)CGFloat thumbnailImageSizeScale;
@property(nonatomic,assign)LocalPhotoImageType imageType;
@end

@interface GPCMediaFilesSelectorLocalPhotoCase : GPCMediaFilesSelectorPhotoCase
//在列表中的索引值，无论是本地加载还是网络下载，该值都有效
@property(nonatomic,assign)NSUInteger index;

@property(nonatomic,strong)NSString* photoTitle;
@property(nonatomic,strong)NSDate* createDate;
@property(nonatomic,strong)NSString* galleryTitle;

@property(nonatomic,copy)LocalPhotoCaseSearchOperationBlock searchOperationBlock;
@property(nonatomic,copy)LocalPhotoCaseAddedOperationBlock addedOperationBlock;
@property(nonatomic,copy)LocalPhotoCaseAddedCaseOnDisplayingBlock addedCaseOnDisplayingBlock;
@property(nonatomic,copy)LocalPhotoCaseDeletedCaseOnDisplayingBlock deletedCaseOnDisplayingBlock;

//内存控制属性
@property(nonatomic,assign,readonly)NSUInteger exposureCount;
@property(nonatomic,assign,readonly)BOOL isDisplayOnScreen;
- (NSDictionary*)getPhotoInfo;
@end
