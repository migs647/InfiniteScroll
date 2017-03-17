//
//  CGGLabel.m
//  InfiniteScroll
//
//  Created by Cody Garvin on 3/15/17.
//  Copyright © 2017 Cody Garvin. All rights reserved.
//

#import "CGGLabel.h"

CGFloat kCGGLabelTopMargin = 10.0f;
CGFloat kCGGLabelSideMargin = 10.0f;
CGFloat kCGGLabelSize = 72.0f;

@interface CGGLabel ()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *imageView;
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
    // Lazy Instantiation
    if (!_imageView)
    {
        self.imageView = [[UIImageView alloc] init];
        
        // TODO: Position the imageView later when the team wants it
    }
    
    [self.imageView setImage:image];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private Methods
- (void)configure
{
    
    
}

- (void)createImageView
{
    if (self.imageView)
    { // No need to create another
        return;
    }
    
    CGRect imageSize = CGRectMake(kCGGLabelSideMargin, kCGGLabelTopMargin, kCGGLabelSize, kCGGLabelSize);
    self.imageView = [[UIImageView alloc] initWithFrame:imageSize];
    [self addSubview:self.imageView];
}
@end
