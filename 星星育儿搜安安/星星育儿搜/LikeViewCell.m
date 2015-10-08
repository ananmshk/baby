//
//  LikeViewCell.m
//  星星育儿搜
//
//  Created by qingyun on 15/9/20.
//  Copyright (c) 2015年 河南青云信息科技有限公司. All rights reserved.
//

#import "LikeViewCell.h"
#import "PublicModel.h"
#import "UIImageView+WebCache.h"
@implementation LikeViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)GetFromPublicModel:(PublicModel *)model{
    self.msgid = model.msgid;
    self.title.text = model.title;
    self.detail.text = model.descrip;
    NSString *url = model.images[0];
    NSString *urlString = [url stringByAppendingString:@"_middle.jpg"];
    [self.imageV  sd_setImageWithURL:[NSURL URLWithString:urlString]];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
