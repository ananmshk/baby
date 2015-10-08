//
//  PublicViewController.h
//  星星育儿搜
//
//  Created by qingyun on 15/9/15.
//  Copyright (c) 2015年 河南青云信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublicViewController : UIViewController

// 网络请求参数
@property (nonatomic, copy) NSString *keywards;
@property (nonatomic, copy) NSString *labelid;
//@property (nonatomic, copy) NSString *page;
@property (nonatomic, copy) NSString *userid;
- (void)loadData;

@end
