//
//  AppDelegate.m
//  Calculator01
//
//  Created by LaoWen on 14-7-18.
//  Copyright (c) 2014年 qianfeng. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
{
    UILabel *_label;
    NSString *_operator1;//操作数1
    NSString *_operator2;//操作数2
    NSString *_operand;//操作符
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self createCalculator];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#define MARGIN 120//第一行按钮顶的Y坐标

//创建计算器
- (void)createCalculator
{
    _label = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 300, 60)];
    [_label setBackgroundColor:[UIColor cyanColor]];
    _label.layer.cornerRadius = 5;
    _label.numberOfLines = 2;
    _label.textAlignment = NSTextAlignmentRight;
    [self.window addSubview:_label];
    
    _operand = @"";
    _operator1 = @"";
    _operator2 = @"";
    
    //创建第一行按钮
    NSArray *titles0 = @[@"MC", @"M+", @"M-", @"MR",
                         @"清除"];
    for (int i=0; i<5; i++) {
        int w = (320-60)/5;//第一行有5个按钮，按钮两边各空出10个宽度，所以5个按钮两边总共空出60个宽度，按钮的宽度就是(320-60)/5
        int h = 50;
        int x = 10+i*(w+10);
        int y = MARGIN;
        [self createButtonWithRect:CGRectMake(x, y, w, h) andTitle:titles0[i]];
    }
    
    //创建其它按钮。
    NSArray *titles1 = @[@"7", @"8", @"9", @"+",
                         @"4", @"5", @"6", @"-",
                         @"1", @"2", @"3", @"*",
                         @"0", @".", @"=", @"/"];
    for (int i=0; i<4; i++) {
        for (int j=0; j<4; j++) {
            int w = (320-50)/4;
            int h = 50;
            int x = 10+j*(w+10);
            int y = MARGIN+(i+1)*(h+10);//因为前边已经创建一行按钮了，所以这里是i+1
            [self createButtonWithRect:CGRectMake(x, y, w, h) andTitle:titles1[i*4+j]];
        }
    }
}

//创建按钮
//参数：
//  rect：按钮的位置和大小
/// title：按钮标题
- (void)createButtonWithRect: (CGRect)rect andTitle: (NSString *)title
{
    //创建按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    [button setTitle:title forState:UIControlStateNormal];
    
    button.layer.cornerRadius = 10;//设置按钮的圆角半径
    
    //设置按钮的背景颜色
    [button setBackgroundColor:[UIColor cyanColor]];
    
    //设置按钮上标题的颜色
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    //设置按钮的事件处理程序
    [button addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //把按钮加到View上
    [self.window addSubview:button];
}

//按钮被点击的事件处理程序
//参数：
//  sender：被点击的按钮
- (void)onButtonClick: (UIButton *)sender
{
    NSLog(@"onButtonClick");
    
    //以M开头的按钮不处理
    if ([sender.titleLabel.text hasPrefix:@"M"]) {
        return;
    }
    
    //清除按钮被点击
    if ([sender.titleLabel.text isEqualToString:@"清除"]) {
        _operand = @"";
        _operator1 = @"";
        _operator2 = @"";
        _label.text = @"";
        return;
    }
    
    NSString *strInput = sender.titleLabel.text;
    NSLog(@"%@", strInput);
    
    if ([self isOperand:strInput]) {//输入操作符
        NSLog(@"Operand");
        if (_operand.length) {//当前已经有一个操作符了，对当前的两个操作数和一个操作符进行运算。
            float operator1 = [_operator1 floatValue];
            float operator2 = [_operator2 floatValue];
            float result;
            if ([_operand isEqualToString:@"+"]) {
                result = operator1 + operator2;
            } else if ([_operand isEqualToString:@"-"]) {
                result = operator1 - operator2;
            } else if ([_operand isEqualToString:@"*"]) {
                result = operator1 * operator2;
            } else if ([_operand isEqualToString:@"/"]) {
                result = operator1 / operator2;
            }
            
            _operator1 = [[NSString stringWithFormat:@"%0.2f", result]copy];
            _operator2 = @"";
            if ([strInput isEqualToString:@"="]) {
                _operand = @"";
            } else {
                _operand = [strInput copy];
            }
            
            _label.text = _operator1;
        } else {
            _operand = [strInput copy];
        }
        
    } else {//输入操作数
        NSLog(@"Operator");
        if (_operand && _operand.length) {//当前有操作符，这是第二操作数
            _operator2 = [[_operator2 stringByAppendingString:strInput]copy];
        } else {
            _operator1 = [[NSString stringWithFormat:@"%@%@", _operator1, strInput]copy];
        }
    }
    if (_operator2.length) {
        _label.text = [NSString stringWithFormat:@"%@\n%@", _operator2, _operand];
    } else {
        _label.text = [NSString stringWithFormat:@"%@\n%@", _operator1, _operand];
    }
    
    NSLog(@"%@:%@:%@", _operator1, _operand, _operator2);
}

//判断参数str是否为运算符
//返回值为TRUE代表是运算符，FALSE代表不是运算符
- (BOOL)isOperand:(NSString *)str
{
    NSRange range = [str rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"+-*/="]];
    if (range.location != NSNotFound) {
        return TRUE;
    }
    return FALSE;
}

@end
