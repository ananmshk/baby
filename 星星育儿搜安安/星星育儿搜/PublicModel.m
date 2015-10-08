//
//  PublicModel.m
//  星星育儿搜
//
//  Created by qingyun on 15/9/17.
//  Copyright (c) 2015年 河南青云信息科技有限公司. All rights reserved.
//
//"msgid": "信息id",
//"title": "信息标题",
//"description": "信息详情",
//"images": [
//           "www.baybytop.cn/a.jpg",
//           "www.baybytop.cn/a.jpg"
//           ]

#import "PublicModel.h"

@implementation PublicModel
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.msgid = dict[@"msgid"];
        self.title = dict[@"title"];
        self.descrip = dict[@"description"];
        self.images = dict[@"images"];
    }
    return self;
}


@end
