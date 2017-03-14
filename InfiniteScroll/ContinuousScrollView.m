//
//  ContinuousScrollView.m
//  InfiniteScroll
//
//  Created by Cody Garvin on 3/12/17.
//  Copyright © 2017 Cody Garvin. All rights reserved.
//

#import "ContinuousScrollView.h"

NSInteger kContinuousScrollViewLabelTopMargin = 32;
NSInteger kContinuousScrollViewLabelSideMargin = 16;

@interface ContinuousScrollView () <UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *labelContainersLaidout;
@property (nonatomic, strong) UIView *currentContainerView;
@property (nonatomic, strong) NSArray *verticalLabelConstraints;
@end

@implementation ContinuousScrollView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // Hide the scroll indicator so we can appear seemless
        [self setShowsVerticalScrollIndicator:NO];
    }
    
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        // Hide the scroll indicator so we can appear seemless
        [self setShowsVerticalScrollIndicator:NO];
    }
    
    return self;
}

- (void)reload {
    
    // Reset our world
    self.labelContainersLaidout = nil;
    self.currentContainerView = nil;
    
    // Get the container view ready -- This holds the sets of containers for labels
    // that we will move around
    [self buildContainerView];
    
    // Tile out the labels -- should only need 3 sets total
    [self tileLabels];
    
    // Now layout all of our subviews
    [self setNeedsLayout];
}

- (void)buildContainerView
{
    self.delegate = self;
    
    // Get rid of the old container view if there was one
    if (_currentContainerView)
    {
        [_currentContainerView removeFromSuperview];
        self.currentContainerView = nil;
    }
    
    // Create the new container view
    self.currentContainerView = [[UIView alloc] init];
    self.currentContainerView.backgroundColor = [UIColor greenColor];
    _currentContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_currentContainerView];
    
    NSDictionary *views = @{@"_currentContainerView":_currentContainerView};
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|[_currentContainerView]|"
                          options:0 metrics:0 views:views]];
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|[_currentContainerView]"
                          options:0 metrics:0 views:views]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_currentContainerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
}

- (void)tileLabels
{
    // Grab three sets and build their constraints
    UIView *labelSet1 = [self buildLabelSet];
    [self.currentContainerView addSubview:labelSet1];
     [NSLayoutConstraint activateConstraints:
      [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[labelSet1]|"
                                              options:0 metrics:0
                                                views:NSDictionaryOfVariableBindings(labelSet1)]];
    
    UIView *labelSet2 = [self buildLabelSet];
    [self.currentContainerView addSubview:labelSet2];
    [NSLayoutConstraint activateConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[labelSet2]|"
                                             options:0 metrics:0
                                               views:NSDictionaryOfVariableBindings(labelSet2)]];
    
    UIView *labelSet3 = [self buildLabelSet];
    [self.currentContainerView addSubview:labelSet3];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint
                                             constraintsWithVisualFormat:@"H:|[labelSet3]|"
                                             options:0 metrics:0
                                             views:NSDictionaryOfVariableBindings(labelSet3)]];
    
    // Add and save the vertical constraints
    self.verticalLabelConstraints = [NSLayoutConstraint
                                     constraintsWithVisualFormat:@"V:|[labelSet1][labelSet2][labelSet3]-padding-|"
                                     options:0 metrics:@{@"padding": @(kContinuousScrollViewLabelTopMargin)}
                                     views:NSDictionaryOfVariableBindings(labelSet1, labelSet2, labelSet3)];
    [NSLayoutConstraint activateConstraints:self.verticalLabelConstraints];
}

- (UIView *)buildLabelSet
{
    // Add the labels to a container view so we can move the containers around.
    // This will give us the ability to make it appear like the user is scrolling
    // since we will move the content view that may overlap the faux set of cells.
    // While that is going we will move the opposite set to the direction the user
    // is scrolling.
    
    // Start with the labelContainerView
    UIView *labelContainerView = [[UIView alloc] init];
    labelContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    labelContainerView.backgroundColor = [UIColor redColor];

    // Start fresh
    NSString *labelConstraintString = @"";
    NSMutableDictionary *labelConstraintDictionary = [[NSMutableDictionary alloc] init];
    
    // First check that our data source has some friends
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
            
            // If we don't have a label something went wrong -- bail out
            if (!label)
            {
                break;
            }
            
            // Build the view name for the constraint string generation
            NSString *viewName = [NSString stringWithFormat:@"label_%zd", index];
            
            // Append to the labelConstraintString
            labelConstraintString =
            [NSString stringWithFormat:@"%@-%zd-[%@]", labelConstraintString,
             kContinuousScrollViewLabelTopMargin, viewName];
            
            // Add to the labelConstraintDictionary
            [labelConstraintDictionary setObject:label forKey:viewName];
            
            // Make sure that we're autolayout compatible before adding
            label.translatesAutoresizingMaskIntoConstraints = NO;
            
            // Officially add the label
            [labelContainerView addSubview:label];
            
            // Add the horizontal constraints
            [self addHorizontalConstraintsForLabel:label byName:viewName];
        }
        
        // Append the constraint to the bottom of the content view
        // Example: V:|-32-[label_0]-32-[label_1]-32-|
        if (labelConstraintString && ![labelConstraintString isEqualToString:@""])
        {
            labelConstraintString = [NSString stringWithFormat:@"V:|%@|", labelConstraintString];
            
            // Build the vertical constraints
            self.verticalLabelConstraints =
            [NSLayoutConstraint constraintsWithVisualFormat:labelConstraintString
                                                    options:0 metrics:0
                                                      views:labelConstraintDictionary];
            
            // Add the vertical constraints
            [NSLayoutConstraint activateConstraints:self.verticalLabelConstraints];
            
        }
    }
    
    return labelContainerView;
}

- (void)addHorizontalConstraintsForLabel:(UILabel *)label byName:(NSString *)viewName
{
    // Build the horizontal constraint string with the right names
    NSString *horizontalConstraintString =
    [NSString stringWithFormat:@"H:|-%zd-[%@]-%zd-|",
     kContinuousScrollViewLabelSideMargin, viewName, kContinuousScrollViewLabelSideMargin];
    
    // Build the constraints now that we have the string
    NSArray *horizontalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:horizontalConstraintString
                                            options:0 metrics:0
                                              views:@{viewName: label}];
    
    // Add the new found constraints
    [NSLayoutConstraint activateConstraints:horizontalConstraints];
}

- (void)calibratePosition
{
    // Grab some attributes about our scrolled area and content area to
    // calculate the need to reposition our content view
    CGFloat contentHeight = [self contentSize].height;
    CGFloat centerOffsetY = (contentHeight - self.bounds.size.height) / 2.0;
    CGFloat distanceFromTheMiddle = fabs(self.contentOffset.y - centerOffsetY);
    
    if (distanceFromTheMiddle > (contentHeight / 4.0))
    {
        self.contentOffset = CGPointMake(self.contentOffset.x, centerOffsetY);
    }
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self calibratePosition];
}

@end
