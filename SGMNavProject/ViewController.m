//
//  ViewController.m
//  SGMNavProject
//
//  Created by guimingsu on 15-5-31.
//  Copyright (c) 2015年 guimingsu. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+Random.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"IOS6 Gesture Back";
    self.view.backgroundColor = [UIColor randomColor];
    
}
- (IBAction)pushTaped:(UIButton *)sender {
    
    ViewController *viewcontroller = [[ViewController alloc ]initWithNibName:@"ViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
