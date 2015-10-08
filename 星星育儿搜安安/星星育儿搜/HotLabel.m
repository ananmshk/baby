//
//  HotLabel.m
//  星星育儿搜
//
//  Created by qingyun on 15/9/17.
//  Copyright (c) 2015年 河南青云信息科技有限公司. All rights reserved.
//

#import "HotLabel.h"

@implementation HotLabel


- (instancetype)initWithDictinary:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.labelname = dict[@"labelname"];
        self.labelid = dict[@"labelid"];
    }
    return self;
}


@end
