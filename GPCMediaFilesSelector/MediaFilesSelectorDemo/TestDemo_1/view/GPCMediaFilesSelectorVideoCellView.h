//
//  GPCMediaFilesSelectorVideoCellView.h
//  GPCProject
//
//  Created by robertyzli on 2016/12/1.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPCMediaFilesSelectorPhotoCase.h"

@interface GPCMediaFilesSelectorVideoCellView : UIView
@property(nonatomic,strong)UIImage* iconImage;
@property(nonatomic,strong)NSString* photoTile;
@property(nonatomic,strong)NSString* createTime;
@property(nonatomic,strong)NSString* galleryTitle;
@property(nonatomic,strong)GPCMediaFilesSelectorPhotoCase* photoCase;
@end
