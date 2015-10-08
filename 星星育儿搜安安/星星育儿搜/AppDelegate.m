//
//  AppDelegate.m
//  星星育儿搜
//
//  Created by qingyun on 15/9/14.
//  Copyright (c) 2015年 河南青云信息科技有限公司. All rights reserved.
//

#import "AppDelegate.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//以下是ShareSDK必须添加的依赖库：
//1、libicucore.dylib
//2、libz.dylib
//3、libstdc++.dylib
//4、JavaScriptCore.framework

//＝＝＝＝＝＝＝＝＝＝以下是各个平台SDK的头文件，根据需要继承的平台添加＝＝＝
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//以下是腾讯SDK的依赖库：
//libsqlite3.dylib

//微信SDK头文件
#import "WXApi.h"
//以下是微信SDK的依赖库：
//libsqlite3.dylib

//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"
//以下是新郎微博SDK的依赖库：
//ImageIO.framework



#import "Common.h"
#import <iflyMSC/IFlySpeechUtility.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //1.window
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    //2.根据不同情况制定根视图
    self.window.rootViewController = [self instantiateRootViewController];
    [self.window makeKeyAndVisible];
    
    //初始化
    NSString *initString = [NSString stringWithFormat:@"appid=%@", @"5565df39"];
    [IFlySpeechUtility createUtility:initString];
    
    
    //    设置shareSDK的appKey，
    [ShareSDK registerApp:@"iosv1101"
          activePlatforms:@[@(SSDKPlatformTypeSinaWeibo),  @(SSDKPlatformTypeWechat), @(SSDKPlatformTypeQQ)] onImport:^(SSDKPlatformType platformType) {
              
              switch (platformType)
              {
                  case SSDKPlatformTypeWechat:
                      [ShareSDKConnector connectWeChat:[WXApi class]];
                      break;
                  case SSDKPlatformTypeQQ:
                      [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                      break;
                  case SSDKPlatformTypeSinaWeibo:
                      [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                      break;
                  default:
                      break;
              }
              
          }
     
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              switch (platformType)
              {
                  case SSDKPlatformTypeSinaWeibo:
                      //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                      [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
                                                appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                                              redirectUri:@"http://www.sharesdk.cn"
                                                 authType:SSDKAuthTypeBoth];
                      break;
                  case SSDKPlatformTypeWechat:
                      [appInfo SSDKSetupWeChatByAppId:@"wx4868b35061f87885"
                                            appSecret:@"64020361b8ec4c99936c0e3999a9f249"];
                      break;
                  case SSDKPlatformTypeQQ:
                      [appInfo SSDKSetupQQByAppId:@"100371282"
                                           appKey:@"aed9b0303e3ed1e27bae87c33761161d"
                                         authType:SSDKAuthTypeBoth];
                      break;
                      
                  default:
                      break;
              };
          }];
    
    return YES;
}

-(id)instantiateRootViewController{
    //当前运行的版本
    NSString *currentVerision = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    //本地保存的版本号
    NSUserDefaults *userDe = [NSUserDefaults standardUserDefaults];
    NSString *localVersion = [userDe objectForKey:kAPP_Version];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if ([currentVerision isEqualToString:localVersion]) {
        //已近运行过该版本
        //初始化主控制器
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"main"];
        return vc;
        
    }else{
        //第一次运行该版本
        //初始化引导页控制器
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"guide"];
        return vc;
    }
}
-(void)guideEnd{
    //更新本地存储的版本
    //当前运行的版本
    NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    NSUserDefaults *userDe = [NSUserDefaults standardUserDefaults];
     [userDe setObject:currentVersion forKey:kAPP_Version];
    [userDe synchronize];
    UIStoryboard *st = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //出队根视图
    UIViewController *vc = [st instantiateViewControllerWithIdentifier:@"main"];
    //指定window的新的根控制器
    self.window.rootViewController = vc;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
