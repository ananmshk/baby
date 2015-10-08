//
//  CollectionViewCell.h
//  星星育儿搜
//
//  Created by qingyun on 15/9/17.
//  Copyright (c) 2015年 河南青云信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HotLabel;

@interface CollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) NSString *labelID;
@property (weak, nonatomic) IBOutlet UIButton *title;

- (void)setCollectionCellWithModel:(HotLabel *)model;
@end
