//
//  PublicTableViewCell.h
//  星星育儿搜
//
//  Created by qingyun on 15/9/17.
//  Copyright (c) 2015年 河南青云信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PublicModel;
@interface PublicTableViewCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UIImageView *imageV;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UIButton *like;
@property (strong, nonatomic) IBOutlet UIButton *share;

@property (strong, nonatomic) IBOutlet UILabel *detail;
@property (nonatomic, copy) NSString *msgid;

@property(nonatomic, strong) PublicModel *publicModel;
- (void)GetFromTableViewModel:(PublicModel *)publicModel;
@end
