//
//  GPCPicturSelectorLivePhotoPreviewController.h
//  GPCProject
//
//  Created by 李义真 on 2016/12/22.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPCMediaFilesSelectorPhotoCaseDataSource.h"

@interface GPCPicturSelectorLivePhotoPreviewController : UIViewController
@property(nonatomic,strong)NSArray<GPCMediaFilesSelectorLivePhotoItem*>* livePhotoItemList;
@end
