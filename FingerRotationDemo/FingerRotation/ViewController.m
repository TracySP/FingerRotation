//
//  ViewController.m
//  绘制学习
//
//  Created by 四维图新SP on 17/3/7.
//  Copyright © 2017年 TracyMcSong. All rights reserved.
//
//#define SW [UIScreen mainScreen].bounds.size.width
//
//#define SH [UIScreen mainScreen].bounds.size.height

#import "ViewController.h"
#import "SPDrawView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    /// ceshi 
    
    SPDrawView *view = [[SPDrawView alloc] initWithFrame:CGRectMake(0, 0, SW, SH)];
    
    view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:view];
    
    [view setImage:[UIImage imageNamed:@"ipad分辨率"]];
    
    [view setAngle:M_PI / 5];
}

@end
