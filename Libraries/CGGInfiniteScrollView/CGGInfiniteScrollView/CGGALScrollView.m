//
//  CGGALScrollView.m
//  InfiniteScroll
//
//  Created by Cody Garvin on 3/12/17.
//  Copyright © 2017 Cody Garvin. All rights reserved.
//

#import "CGGALScrollView.h"

NSInteger kCGGALScrollViewLabelTopMargin = 32;
NSInteger kCGGALScrollViewLabelSideMargin = 16;

typedef NS_ENUM(NSUInteger, CGGALScrollViewScrollDirection) {
    ScrollDirectionNone,
    ScrollDirectionUp,
    ScrollDirectionDown
};

@interface CGGALScrollView () <UIScrollViewDelegate>
@property (nonatomic, strong) NSArray *labelContainersLaidout;
@property (nonatomic, strong) UIView *currentContainerView;
@property (nonatomic, strong) NSArray *verticalLabelConstraints;
@property (nonatomic, assign) CGFloat lastContentOffset;
@end

@implementation CGGALScrollView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // Hide the scroll indicator so we can appear seemless
        [self configure];
    }
    
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        // Hide the scroll indicator so we can appear seemless
        [self configure];
    }
    
    return self;
}

- (void)configure
{
    // Hide the scroll indicator so we can appear seemless
    [self setShowsVerticalScrollIndicator:NO];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public Methods
- (void)reload
{
    
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

- (void)reloadLabelAtIndex:(NSInteger)index
{
    // Don't allow fluffery
    if (index < 0)
    {
        return;
    }
    
    if (_dataSource && [_dataSource respondsToSelector:@selector(labelAtIndex:)])
    {
        for (UIView *container in self.labelContainersLaidout)
        {
            // Find the label
            UILabel *currentLabel = [container viewWithTag:index];
            if (currentLabel && [currentLabel isKindOfClass:[UILabel class]])
            {
                currentLabel.numberOfLines = 0;
            }
        }
//        UILabel *label = [_labelsLaidout objectAtIndex:index];
//        label.numberOfLines = 0;
//
//        CGRect expandedSize = [label sizeForCurrentString:CGSizeMake(self.contentSize.width - (kCGGFramesScrollViewLabelSideMargin*2), INT_MAX)];
//        
//        CGRect frameForCurrentLabel = label.frame;
//        frameForCurrentLabel.size = expandedSize.size;
//        label.frame = frameForCurrentLabel;
//        
//        // From the index down we need to redraw as some may have been expanded
//        CGFloat previousCellHeightOrigin = frameForCurrentLabel.size.height + frameForCurrentLabel.origin.y;
//        
//        // Increment the index so we can grab the next cell
//        ++index;
//        while (index < [self.labelsLaidout count])
//        {
//            UILabel *nextLabel = [self.labelsLaidout objectAtIndex:index];
//            frameForCurrentLabel = nextLabel.frame;
//            frameForCurrentLabel.origin.y = previousCellHeightOrigin + kCGGFramesScrollViewLabelTopMargin;
//            nextLabel.frame = frameForCurrentLabel;
//            
//            previousCellHeightOrigin = frameForCurrentLabel.size.height + frameForCurrentLabel.origin.y;
//            index++;
//        }
    }
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Hidden Methods
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
    _currentContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_currentContainerView];
    
    NSDictionary *views = @{@"_currentContainerView":_currentContainerView};
    // Make the container view constrain to the top and bottom of the scroll view
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|[_currentContainerView]|"
                          options:0 metrics:0 views:views]];
    // Make the container view snap to the left side
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|[_currentContainerView]"
                          options:0 metrics:0 views:views]];
    // Make the containerview the same width at the scroll view
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_currentContainerView
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:1.0 constant:0]];
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
    
    self.labelContainersLaidout = @[labelSet1, labelSet2, labelSet3];
    
    // Add and save the vertical constraints
    [self buildLabelContainerConstraints];
    
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
            label.tag = index;
            
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
             kCGGALScrollViewLabelTopMargin, viewName];
            
            // Add to the labelConstraintDictionary
            [labelConstraintDictionary setObject:label forKey:viewName];
            
            // Make sure that we're autolayout compatible before adding
            label.translatesAutoresizingMaskIntoConstraints = NO;
            
            // Add a tap watcher
            label.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped:)];
            [label addGestureRecognizer:tapGesture];
            
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
            
            // Add the vertical constraints
            [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:labelConstraintString
                                                                                            options:0 metrics:0
                                                                                              views:labelConstraintDictionary]];
            
        }
    }
    
    return labelContainerView;
}

- (void)addHorizontalConstraintsForLabel:(UILabel *)label byName:(NSString *)viewName
{
    // Build the horizontal constraint string with the right names
    NSString *horizontalConstraintString =
    [NSString stringWithFormat:@"H:|-%zd-[%@]-%zd-|",
     kCGGALScrollViewLabelSideMargin, viewName, kCGGALScrollViewLabelSideMargin];
    
    // Build the constraints now that we have the string
    NSArray *horizontalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:horizontalConstraintString
                                            options:0 metrics:0
                                              views:@{viewName: label}];
    
    // Add the new found constraints
    [NSLayoutConstraint activateConstraints:horizontalConstraints];
}

// Used to reorder the constraints by going through an ordered array of the
// containers
- (void)buildLabelContainerConstraints
{
    if (self.verticalLabelConstraints)
    {
        [NSLayoutConstraint deactivateConstraints:self.verticalLabelConstraints];
    }
    
    NSMutableDictionary *constraintsDictionary = [[NSMutableDictionary alloc] init];
    NSInteger index = 1;
    for (UIView *labelSet in self.labelContainersLaidout)
    {
        NSString *indexName = [NSString stringWithFormat:@"labelSet%zd", index];
        [constraintsDictionary setObject:labelSet forKey:indexName];
        index++;
    }
    self.verticalLabelConstraints = [NSLayoutConstraint
                                     constraintsWithVisualFormat:@"V:|[labelSet1][labelSet2][labelSet3]-padding-|"
                                     options:0 metrics:@{@"padding": @(kCGGALScrollViewLabelTopMargin)}
                                     views:constraintsDictionary];
    [NSLayoutConstraint activateConstraints:self.verticalLabelConstraints];
    
    [self setNeedsUpdateConstraints];
}

- (void)calibratePositionForDirection:(CGGALScrollViewScrollDirection)direction
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
        
        // Reorder the views in the array to adjust the positioning
        [self adjustTileLayoutForDirection:direction];
        [self buildLabelContainerConstraints];
        
        for (UIView *container in self.labelContainersLaidout)
        {
            CGPoint center = [self.currentContainerView convertPoint:container.center toView:self];
            center.y += (centerOffsetY - currentOffset.y);
            container.center = [self convertPoint:center toView:self.currentContainerView];
        }
    }
}

- (void)adjustTileLayoutForDirection:(CGGALScrollViewScrollDirection)direction
{
    // Get out of here if we don't have a proper set up
    if ([_labelContainersLaidout count] < 3)
    {
        return;
    }
    
    NSMutableArray *labelsLaidout = [self.labelContainersLaidout mutableCopy];
    if (direction == ScrollDirectionUp)
    { // Move first element to the end
        UIView *firstElement = [labelsLaidout firstObject];
        [labelsLaidout removeObjectAtIndex:0];
        [labelsLaidout addObject:firstElement];
    }
    else if (direction == ScrollDirectionDown)
    { // Move the last element to the beginning
        UIView *lastElement = [labelsLaidout lastObject];
        [labelsLaidout removeObjectAtIndex:2];
        [labelsLaidout insertObject:lastElement atIndex:0];
    }
    self.labelContainersLaidout = [NSArray arrayWithArray:labelsLaidout];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Figure out the direction we're going so we know how to tile
    CGGALScrollViewScrollDirection scrollDirection;
    if (self.lastContentOffset > scrollView.contentOffset.y)
        scrollDirection = ScrollDirectionDown;
    else if (self.lastContentOffset < scrollView.contentOffset.y)
        scrollDirection = ScrollDirectionUp;
    self.lastContentOffset = scrollView.contentOffset.y;

    // Readjust the positioning of our content view if we have gone far enough
    // in a certain direction
    [self calibratePositionForDirection:scrollDirection];
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Gesture Recognizer Methods
- (void)labelTapped:(UITapGestureRecognizer *)tapGesture
{
    NSLog(@"View: %@", tapGesture.view);
    [self reloadLabelAtIndex:tapGesture.view.tag];
}
@end
