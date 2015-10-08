//
//  HotLabel.h
//  星星育儿搜
//
//  Created by qingyun on 15/9/17.
//  Copyright (c) 2015年 河南青云信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotLabel : NSObject

@property (nonatomic, copy) NSString *labelname;
@property (nonatomic, copy) NSString *labelid;

- (instancetype)initWithDictinary:(NSDictionary *)dict;


@end
