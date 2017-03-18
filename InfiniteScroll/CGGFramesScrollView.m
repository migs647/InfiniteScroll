//
//  CGGFramesScrollView.m
//  InfiniteScroll
//
//  Created by Cody Garvin on 3/14/17.
//  Copyright © 2017 Cody Garvin. All rights reserved.
//

#import "CGGFramesScrollView.h"
#import "UILabel+.h"

NSInteger kCGGFramesScrollViewLabelTopMargin    = 32;
NSInteger kCGGFramesScrollViewLabelSideMargin   = 16;
NSInteger kCGGFramesScrollViewTagBase           = 1000;

typedef NS_ENUM(NSUInteger, CGGFramesScrollViewDirection) {
    ScrollDirectionNone,
    ScrollDirectionUp,
    ScrollDirectionDown
};

@interface CGGFramesScrollView () <UIScrollViewDelegate>
@property (nonatomic, strong) UIView *currentContainerView;
@property (nonatomic, strong) NSMutableArray *labelsLaidout;
@property (nonatomic, assign) CGFloat lastContentOffset;
@end

@implementation CGGFramesScrollView

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Initialization
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
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

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self configure];
    }
    
    return self;
}

- (void)dealloc
{
    // Make sure we aren't watching any rotation issues any more
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configure
{
    // Hide the scroll indicator so we can appear seemless
    [self buildContainerView];
    [self setShowsVerticalScrollIndicator:NO];
    
    // We need to know when orientation changes happen for doing new layouts
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public Methods
- (void)reload
{
    // Ignore any reloads
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // Ignore any reloads
    self.delegate = nil;
    
    // Get the container view ready -- This holds the sets of containers for labels
    // that we will move around
    [self buildContainerView];
    
    // Add all of the labels in an array that we need
    [self addLabels];
    
    // Center the world so we can scroll up and down
    [self calibratePosition];
    
    // Set the labels in the correct position now that the world is centered
    [self adjustLabelFrames];
    
    // Lets set up to watch any scrolling delegation
    self.delegate = self;
    
    // Lets watch for rotation notifications again.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
}

- (void)reloadLabelAtIndex:(NSInteger)index
{
    // Don't allow fluffery
    if (index < 0)
    {
        return;
    }
    
    // Grab the label from the view so we can use it to look up index in the
    // labels laidout
    UILabel *label = [self.currentContainerView viewWithTag:index];
    
    // Protect against accidental look ups
    if (!label || ![label isKindOfClass:[UILabel class]])
    {
        NSLog(@"Error: Failed to look up class");
        return;
    }
    
    __block NSInteger indexInLayoutArray = [self.labelsLaidout indexOfObject:label];
    label.numberOfLines = 0;

    CGRect expandedSize = [label sizeForCurrentString:CGSizeMake(self.contentSize.width - (kCGGFramesScrollViewLabelSideMargin*2), INT_MAX)];
    
    __block CGRect frameForCurrentLabel = label.frame;
    frameForCurrentLabel.size = expandedSize.size;
    
    // From the index down we need to redraw as some may have been expanded
    [UIView
     animateWithDuration:.33
     delay:0
     usingSpringWithDamping:1.0f initialSpringVelocity:0.5f
     options:UIViewAnimationOptionCurveEaseIn
     animations:
     ^{
         label.frame = frameForCurrentLabel;

         CGFloat previousCellHeightOrigin = frameForCurrentLabel.size.height + frameForCurrentLabel.origin.y;
         // Increment the index so we can grab the next cell
         ++indexInLayoutArray;
         while (indexInLayoutArray < [self.labelsLaidout count])
         {
             UILabel *nextLabel = [self.labelsLaidout objectAtIndex:indexInLayoutArray];
             frameForCurrentLabel = nextLabel.frame;
             frameForCurrentLabel.origin.y = previousCellHeightOrigin + kCGGFramesScrollViewLabelTopMargin;
             nextLabel.frame = frameForCurrentLabel;
             
             previousCellHeightOrigin = frameForCurrentLabel.size.height + frameForCurrentLabel.origin.y;
             indexInLayoutArray++;
         }
         
     }
     completion:nil];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Layout and building implementations
- (void)buildContainerView
{
    if (self.currentContainerView)
    {
        [self.currentContainerView removeFromSuperview];
        self.currentContainerView = nil;
    }
    
    // Make our size the current height but three times larger so we can scroll
    // in both directions. Setting the contentview larger than our scrollview
    // provides the ability to scroll
    self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height * 3);
    
    // Initialize our container for our labels
    self.labelsLaidout = [[NSMutableArray alloc] init];
    
    self.currentContainerView = [[UIView alloc] init];
    self.currentContainerView.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
    [self addSubview:self.currentContainerView];
}

- (void)addLabels
{
    if ([self.labelsLaidout count] < 1)
    {
        // cycle through the datasource labels and add them
        if (_dataSource &&
            [_dataSource respondsToSelector:@selector(numberOfLabels)] &&
            [_dataSource respondsToSelector:@selector(labelAtIndex:)] &&
            [_dataSource numberOfLabels] > 0)
        {
            // Fill in the data we need
            for (NSInteger index = 0; index < [_dataSource numberOfLabels]; ++index)
            {
                // Grab a label for the current index
                UILabel *label = [_dataSource labelAtIndex:index];
                label.tag = index + kCGGFramesScrollViewTagBase; // Use 1000 offset to prevent accidental look ups in the content view
                
                // If we don't have a label something went wrong -- bail out
                if (!label || ![label isKindOfClass:[UILabel class]])
                {
                    break;
                }
                
                UITapGestureRecognizer *tapGesture =
                [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped:)];
                [label addGestureRecognizer:tapGesture];
                
                label.userInteractionEnabled = YES;
                
                // Officially add the label
                [self.currentContainerView addSubview:label];
                
                // Add the label to the labels laidout so we can manipulate it later
                [self.labelsLaidout addObject:label];
            }
        }
    }
}

- (void)calibratePosition
{
    // Grab some attributes about our scrolled area and content area to
    // calculate the need to reposition our content view
    CGPoint currentOffset = [self contentOffset];
    CGFloat contentHeight = [self contentSize].height;
    CGFloat centerOffsetY = (contentHeight - self.bounds.size.height) / 2.0;
    CGFloat distanceFromTheMiddle = fabs(self.contentOffset.y - centerOffsetY);
    
    if (distanceFromTheMiddle > (contentHeight / 4.0))
    {
        self.contentOffset = CGPointMake(self.contentOffset.x, centerOffsetY);
        
        for (UIView *label in self.labelsLaidout)
        {
            CGPoint center = [self.currentContainerView convertPoint:label.center toView:self];
            center.y += (centerOffsetY - currentOffset.y);
            label.center = [self convertPoint:center toView:self.currentContainerView];
        }
    }
}

- (void)adjustLabelLayoutMin:(CGFloat)min toMax:(CGFloat)max
{
    // Figure out the direction we're going so we know how to tile
    CGGFramesScrollViewDirection scrollDirection = ScrollDirectionNone;
    if (self.lastContentOffset > self.contentOffset.y)
        scrollDirection = ScrollDirectionDown;
    else if (self.lastContentOffset < self.contentOffset.y)
        scrollDirection = ScrollDirectionUp;
    self.lastContentOffset = self.contentOffset.y;
    
    // Get out of here if we don't have a proper set up
    if ([_labelsLaidout count] < 1)
    {
        return;
    }
    
    NSMutableArray *labelsLaidout = [self.labelsLaidout mutableCopy];
    
    // Prevent the two redraw methods from stepping on each other since they
    // can both be true and possibly overwrite the previous ones ability to
    // rearrange the labels
    if (scrollDirection == ScrollDirectionUp)
    {
        // Check if we're scrolling down
        UILabel *lastLabel = [self.labelsLaidout lastObject];
        CGFloat bottom = CGRectGetMaxY(lastLabel.frame);
        while (bottom < max)
        {
            // Grab the first object and move it to the bottom
            UIView *firstElement = [labelsLaidout firstObject];
            [labelsLaidout removeObjectAtIndex:0];
            [labelsLaidout addObject:firstElement];
            
            // Adjust the frame
            CGRect frame = firstElement.frame;
            frame.origin.y = bottom + kCGGFramesScrollViewLabelTopMargin;
            firstElement.frame = frame;
            bottom = CGRectGetMaxY(firstElement.frame);
        }
    }
    else
    {
        // Check if we're scrolling up
        UILabel *firstLabel = [self.labelsLaidout firstObject];
        CGFloat top = CGRectGetMinY(firstLabel.frame);
        while (top > min)
        {
            UIView *lastElement = [labelsLaidout lastObject];
            [labelsLaidout removeObjectAtIndex:labelsLaidout.count - 1];
            [labelsLaidout insertObject:lastElement atIndex:0];
            
            // Adjust the positioning
            CGRect frame = lastElement.frame;
            frame.origin.y = top - frame.size.height - kCGGFramesScrollViewLabelTopMargin;
            lastElement.frame = frame;
            top = CGRectGetMinY(lastElement.frame);
        }
    }
    
    
    self.labelsLaidout = labelsLaidout;
}

- (void)adjustLabelFrames
{
    CGPoint lastOrigin = CGPointMake(kCGGFramesScrollViewLabelSideMargin,
                                     kCGGFramesScrollViewLabelTopMargin + self.bounds.size.height);
    for (UILabel *label in self.labelsLaidout)
    {
        CGFloat width = self.contentSize.width - (kCGGFramesScrollViewLabelSideMargin * 2);
        CGSize constraint = CGSizeMake(width, 3 * label.font.lineHeight);
        CGRect sizeRect = [label sizeForCurrentString:constraint];
        CGRect frame = label.frame;
        frame.origin = lastOrigin;
        frame.size.width = width;
        frame.size.height = sizeRect.size.height;
        label.frame = frame;
        
        // Update last origin
        lastOrigin.y += frame.size.height + kCGGFramesScrollViewLabelTopMargin;
    }
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Readjust the positioning of our content view if we have gone far enough
    // in a certain direction
    [self calibratePosition];

    // tile content in visible bounds
    CGRect visibleBounds = [self convertRect:[self bounds] toView:self.currentContainerView];

    [self adjustLabelLayoutMin:CGRectGetMinY(visibleBounds) toMax:CGRectGetMaxY(visibleBounds)];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Gesture Recognizer Methods
- (void)labelTapped:(UITapGestureRecognizer *)tapGesture
{
    NSLog(@"View: %@", tapGesture.view);
    [self reloadLabelAtIndex:tapGesture.view.tag];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Orientation Methods
- (void)orientationChanged:(NSNotification *)notification
{
    
    UIDeviceOrientation currentOrientation = [[UIDevice currentDevice] orientation];
    NSLog(@"Orientation: %zd", currentOrientation);
    // We rotated
    if (currentOrientation == UIDeviceOrientationLandscapeLeft ||
        currentOrientation == UIDeviceOrientationLandscapeRight ||
        currentOrientation == UIDeviceOrientationPortrait)
    {
        NSLog(@"Rotated");
        [self reload];
    }
}
@end
