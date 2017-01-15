//
//  GPCMediaFilesSelectorPhotoViewState.m
//  GPCProject
//
//  Created by 李义真 on 2016/12/4.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCMediaFilesSelectorPhotoViewState.h"

@interface GPCMediaFilesSelectorPhotoViewState()
@end

@implementation GPCMediaFilesSelectorPhotoViewState
- (instancetype)init
{
	if(self = [super init])
    {
        self.numOfSelectedHidden = YES;
    }
    return self;
}
@end
