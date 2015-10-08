//
//  SearchViewController.m
//  星星育儿搜
//
//  Created by qingyun on 15/9/15.
//  Copyright (c) 2015年 河南青云信息科技有限公司. All rights reserved.
//

#import "SearchViewController.h"
#import <iflyMSC/IFlyRecognizerView.h>
#import <iflyMSC/IFlyRecognizerViewDelegate.h>
#import <iflyMSC/IFlySpeechConstant.h>
#import "UIViewController+ShareViewController.h"
#import "SVProgressHUD.h"

//#import "IATConfig.h"


@interface SearchViewController ()<UITextFieldDelegate, IFlyRecognizerViewDelegate>


@property (weak, nonatomic) IBOutlet UITextField *textField;
@property(nonatomic, strong)IFlyRecognizerView *iflyView;//语音识别控件


@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //textfield 的左视图添加
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 16, 13)];
    image.image =[UIImage imageNamed:@"search_small"];
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 16, 13)];
    
    [leftView addSubview:image];
    
    self.textField.leftView = leftView;
    self.textField.clearButtonMode = UITextFieldViewModeAlways;
    self.textField.delegate = self;
    //添加右视图
    self.textField.rightViewMode = UITextFieldViewModeAlways;
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [btn setImage:[UIImage imageNamed:@"go"] forState:UIControlStateNormal];
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [rightView addSubview:btn];
    self.textField.rightView = rightView;
    [btn addTarget:self action:@selector(goNext) forControlEvents:UIControlEventTouchUpInside];

    
}

-(void)goNext{
    if (self.textField.text.length == 0 ||[self.textField.text isEqualToString:@""]) {
//        UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"警告" message:@"输入不能为空" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    
//        [view show];
        
        [SVProgressHUD showErrorWithStatus:@"搜索内容不能为空"];
    }else{
        [self NextView];
    }
    
}

-(void)NextView{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier: @"public"];
    [vc setValue:self.textField.text forKey:@"keywards"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.title = self.textField.text;
    [self.navigationController pushViewController:vc animated:YES];
    
   

    
    



}

#pragma mark -  textfield delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:.3f animations:^{
        CGRect rect = self.view.frame;
        self.view.frame = CGRectOffset(rect, 0, -120);
        
    }];
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:.2f animations:^{
        CGRect rect = self.view.frame;
        self.view.frame = CGRectOffset(rect, 0, 120);
        
    }];
    return YES;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)voiceRecognition:(id)sender {
    
    //初始化语音识别控件
    _iflyView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
    _iflyView.delegate = self;
    
    //设置返回结果为plain格式
    [_iflyView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
    //功能领域，普通听写
    [_iflyView setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    
//    IATConfig *instance = [IATConfig sharedInstance];
//    //设置最长录音时间
//    [_iflyView setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
//    //设置后端点
//    [_iflyView setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
//    //设置前端点
//    [_iflyView setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
//    //网络等待时间
//    [_iflyView setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
//    
//    //设置采样率，推荐使用16K
//    [_iflyView setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
//    if ([instance.language isEqualToString:[IATConfig chinese]]) {
//        //设置语言
//        [_iflyView setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
//        //设置方言
//        [_iflyView setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT]];
//    }else if ([instance.language isEqualToString:[IATConfig english]]) {
//        //设置语言
//        [_iflyView setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
//    }
//    //设置是否返回标点符号
//    [_iflyView setParameter:instance.dot forKey:[IFlySpeechConstant ASR_PTT]];
//    
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
-(void)onError:(IFlySpeechError *)error
{
    
}


- (IBAction)share:(id)sender {
    [self showShareActionSheet:self.view];
    
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
