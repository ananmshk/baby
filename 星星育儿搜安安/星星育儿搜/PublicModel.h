//
//  PublicModel.h
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

#import <Foundation/Foundation.h>

@interface PublicModel : NSObject
@property (nonatomic, copy) NSString *msgid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *descrip;
@property (nonatomic, copy) NSArray *images;

- (instancetype)initWithDictionary:(NSDictionary *)dict;


@end
