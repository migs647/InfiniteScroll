//
//  CGGLabel.m
//  InfiniteScroll
//
//  Created by Cody Garvin on 3/15/17.
//  Copyright © 2017 Cody Garvin. All rights reserved.
//

#import "CGGLabel.h"

@interface CGGLabel ()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *imageView;
@end

@implementation CGGLabel

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Initialization Methods
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self configure];
    }
    
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self configure];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self configure];
    }
    
    return self;
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Getters / Setters Methods
- (void)setImage:(UIImage *)image
{
    
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private Methods
- (void)configure
{
//    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
//    _imageView.backgroundColor = [UIColor grayColor];
//    [self addSubview:_imageView];
    
    
}

@end
