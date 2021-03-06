//
//  LikeViewCell.h
//  星星育儿搜
//
//  Created by qingyun on 15/9/20.
//  Copyright (c) 2015年 河南青云信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PublicModel;
@interface LikeViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *detail;
@property(nonatomic, copy)NSString *msgid;
-(void)GetFromPublicModel:(PublicModel *)model;

@end
