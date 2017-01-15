//
//  GPCMediaFilesSelectorCase.h
//  GameBible
//
//  Created by robertyzli on 16/7/13.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GPCMediaFilesSelectorPhotoViewState.h"

@class GPCMediaFilesSelectorCellView;
@class GPCMediaFilesSelectorCase;

typedef void(^RequestUpdateIConImageInfoBlock)(UIImage* image,
                                                   BOOL isFastImage,
                             GPCMediaFilesSelectorCase* selectorCase,
                                          NSDictionary* info);

@interface GPCMediaFilesSelectorCase : NSObject
{
    Class _objectClass;
}
@property (nonatomic,strong,readonly)UIImage* iconImage;
+ (GPCMediaFilesSelectorCellView*)createSelectorCaseCellView:(Class)bridgeClass;
- (Class)getObjectClass;
- (void)bindViewClickEvent:(UIView*)sender
                  cellView:(GPCMediaFilesSelectorCellView*)cellView
              selectorCase:(GPCMediaFilesSelectorCase*)selectorCase;
- (void)requestUpdateIconImage:(RequestUpdateIConImageInfoBlock)complete;
@end
