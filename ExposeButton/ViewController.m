//
//  ViewController.m
//  ExposeButton
//
//  Created by Sean on 2019/1/30.
//

#import "ViewController.h"
#import "ExposeButton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    ExposeButton *button = [ExposeButton new];
    button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(0, 0, 50, 50);
    button.center = self.view.center;
    [self.view addSubview:button];
}


@end
