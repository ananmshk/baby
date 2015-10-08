//
//  HotListViewController.m
//  星星育儿搜
//
//  Created by qingyun on 15/9/17.
//  Copyright (c) 2015年 河南青云信息科技有限公司. All rights reserved.
//

#import "HotListViewController.h"
#import "HotLabel.h"
#import "CollectionViewCell.h"
#import "AFNetworking.h"

#import "PublicTableViewCell.h"
#import "PublicViewController.h"
#import "PublicModel.h"

#import <iflyMSC/IFlyRecognizerView.h>
#import <iflyMSC/IFlyRecognizerViewDelegate.h>
#import <iflyMSC/IFlySpeechConstant.h>

#import "SVProgressHUD.h"
#import "Common.h"
#import "DetailsViewController.h"


@interface HotListViewController ()<IFlyRecognizerViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate>


@property(nonatomic, strong)IFlyRecognizerView *iflyView;//语音识别控件
@property(nonatomic, copy)NSArray *array;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *search;


@end

@implementation HotListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBarController.tabBar.hidden = NO;
    self.textField.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.search.imageView.contentMode = UIViewContentModeCenter;
    
    //添加语音按钮
    self.textField.rightViewMode = UITextFieldViewModeAlways;
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 29, 24)];
    [btn setImage:[UIImage imageNamed:@"mike_small"] forState:UIControlStateNormal];
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightView addSubview:btn];
    self.textField.rightView = rightView;
    
    //语音按钮
    [btn addTarget:self action:@selector(speech) forControlEvents:UIControlEventTouchDown];
    
  [self loadData];
    
}

//语音识别
-(void)speech{
    //初始化语音识别控件
    _iflyView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
    _iflyView.delegate = self;
    
    //设置返回结果为plain格式
    [_iflyView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
    //功能领域，普通听写
    [_iflyView setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    [_iflyView start];
    
}
#pragma mark - ifly delegate

-(void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast{
    NSMutableString *string = [[NSMutableString alloc] init];
    NSDictionary *dic = resultArray[0];
    for (NSString *key in dic) {
        [string appendString:key];
    }
    self.textField.text = [string copy];
    [_iflyView cancel];
    
}

- (void)onError:(IFlySpeechError *)error
{
    NSLog(@"%@",error);
}


#pragma  mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

    
#pragma mark - collection data source delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.array.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    
    
    [cell setCollectionCellWithModel:self.array[indexPath.row]];
    
    [cell.title addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
    
}
-(void)loadData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dict = @{@"c":@"iosapp",@"a":@"labels"};
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:KURL parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSDictionary *dict = [NSDictionary dictionaryWithDictionary: responseObject];
        NSArray *resultArray = dict[@"data"];
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *resultDict in resultArray) {
            HotLabel *button = [[HotLabel alloc] initWithDictinary:resultDict];
            [array addObject:button];
            
        }

        self.array = array;
        
        [self.collectionView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)buttonTouch:(UIButton *)sender
{
    CollectionViewCell *cell = (CollectionViewCell *)sender.superview.superview;
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    PublicViewController *VC = [story instantiateViewControllerWithIdentifier:@"public"];
    [VC setValue:cell.labelID forKey:@"labelid"];
    VC.hidesBottomBarWhenPushed = YES;
    VC.title = cell.title.titleLabel.text;
    [self.navigationController pushViewController:VC animated:YES];
    [VC loadData];
    
}

- (IBAction)searchButton:(id)sender {
    if (self.textField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"输入内容不能为空"];
    }else{
        PublicViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"public"];
        VC.hidesBottomBarWhenPushed = YES;
        VC.title = self.textField.text;
        
        [VC setValue:self.textField.text forKey:@"keywards"];
      
        [self.navigationController pushViewController:VC animated:YES];
         
        [VC loadData];
    }

}

@end
