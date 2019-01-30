//
//  ExposeButton.m
//  Test
//
//  Created by Sean on 2019/1/30.
//  Copyright © 2019 private. All rights reserved.
//

#import "ExposeButton.h"

@interface ExposeButton ()
@property (strong, nonatomic) UIDynamicAnimator *animator;

@property (strong, nonatomic) NSTimer *timer;
@end

@implementation ExposeButton
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]];
    [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)]];
}

static int number = 10;

#pragma mark - Action
- (void)handleTap:(UIGestureRecognizer *)gesture {
    UIButton * sender = (UIButton *)gesture.view;
    if (!sender.isSelected) {
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
        sender.selected = true;
    }
    
    if (sender.selected) {
        [self explode];
    }
}

- (void)longPress:(UIGestureRecognizer *)gesture {
    UIButton * sender = (UIButton *)gesture.view;
    if (!sender.isSelected) {
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
        sender.selected = true;
    }
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.timer.fireDate = [NSDate distantPast];
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        self.timer.fireDate = [NSDate distantFuture];
    }
}

- (void)explode {
    for (NSInteger index = 1; index <= 6; index++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"emoji_%@",@(index)]];
        UIImageView *imageView = [UIImageView new];
        imageView.image = image;
        imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        [self addSubview:imageView];

        
        CGFloat angleRange = M_PI / 6.0 * 5.0;//150度
        CGFloat angleItem = angleRange / number;
        NSInteger random = arc4random_uniform(number);
        
        UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[imageView] mode:UIPushBehaviorModeContinuous];
        pushBehavior.angle = -M_PI_4 / 3.0 - angleItem *random;
        pushBehavior.magnitude = 0.60 + random * 0.05;
        UIPushBehavior __weak *weakPush = pushBehavior;
        pushBehavior.action = ^{
            CGFloat alpha = imageView.alpha;
            imageView.alpha = alpha - 0.02;
            if (imageView.alpha <= 0.0) {
                [imageView removeFromSuperview];
                [self.animator removeBehavior:weakPush];
            }
        };
        [self.animator addBehavior:pushBehavior];
    }
}

#pragma mark - Getter
- (UIDynamicAnimator *)animator {
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    }
    return _animator;
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:0.2
                                             target:self
                                           selector:@selector(explode)
                                           userInfo:nil
                                            repeats:true];
        
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    return _timer;
}
@end
