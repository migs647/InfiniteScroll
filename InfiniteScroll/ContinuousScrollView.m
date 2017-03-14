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
@property (nonatomic, strong) NSMutableArray *labelsLaidout;
@property (nonatomic, strong) UIView *currentContainerView;
@end

@implementation ContinuousScrollView

- (void)reload {
    
    // Reset our world
    self.labelsLaidout = nil;
    self.currentContainerView = nil;
    
    // Get the container view ready
    [self buildContainerView];
    
    // Build a vertical constraint string for the items
    [self addLabels];
    
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

- (void)addLabels
{
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
        NSMutableArray *labelsLaidOut = [[NSMutableArray alloc] init];
        
        // Do this three times so we have cells on top and cells on bottom
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
            [self.currentContainerView addSubview:label];
            
            // Add the horizontal constraints
            [self addHorizontalConstraintsForLabel:label byName:viewName];
        }
        self.labelsLaidout = labelsLaidOut;
        
        // Append the constraint to the bottom of the content view
        // Example: V:|-32-[label_0]-32-[label_1]-32-|
        if (labelConstraintString && ![labelConstraintString isEqualToString:@""])
        {
            labelConstraintString = [NSString stringWithFormat:@"V:|%@-%zd-|", labelConstraintString,
                                     kContinuousScrollViewLabelTopMargin];
            
            // Build the vertical constraints
            NSArray *verticalConstraints =
            [NSLayoutConstraint constraintsWithVisualFormat:labelConstraintString
                                                    options:0 metrics:0
                                                      views:labelConstraintDictionary];
            
            // Add the vertical constraints
            [self.currentContainerView addConstraints:verticalConstraints];
        }
    }
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
    [self.currentContainerView addConstraints:horizontalConstraints];
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
        NSLog(@"Move to the correct offset");
        self.contentOffset = CGPointMake(self.contentOffset.x, centerOffsetY);
    }
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [self calibratePosition];
}

@end
