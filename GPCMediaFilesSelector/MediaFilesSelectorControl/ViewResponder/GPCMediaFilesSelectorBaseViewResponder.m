//
//  GPCMediaFilesSelectorBaseViewResponder.m
//  MTGP
//
//  Created by 李义真 on 2017/1/5.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "GPCMediaFilesSelectorBaseViewResponder.h"

@implementation GPCMediaFilesSelectorBaseViewResponder
+ (NSString*)getSelectorCellViewKey:(UITapGestureRecognizer*)gs
{
    NSString* key = [NSString stringWithFormat:@"%p",gs];
    return key;
}
@end
