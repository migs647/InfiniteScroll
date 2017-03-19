//
//  CGGALScrollViewTests.m
//  CGGInfiniteScrollView
//
//  Created by Cody Garvin on 3/19/17.
//  Copyright © 2017 Cody Garvin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "CGGALScrollView.h"

@interface CGGALScrollView ()
- (void)configure;
- (void)buildContainerView;
- (instancetype)initWithFrame:(CGRect)rect;
- (instancetype)initWithCoder:(NSCoder *)coder;
- (void)setCurrentContainerView:(UIView *)view;
- (UIView *)currentContainerView;
@end

@interface CGGALScrollViewTests : XCTestCase

@end

@implementation CGGALScrollViewTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInit {
    
    CGGALScrollView *scrollView = [[CGGALScrollView alloc] init];
    id mock = [OCMockObject partialMockForObject:scrollView];
    [mock setExpectationOrderMatters:YES];
    [[mock expect] configure];
    id blah = [mock init];
    NSLog(@"Blah: %@", blah);
    [mock verify];
}

//- (void)testInitWithCoder {
//
//    OCMClassMock([CGGFramesScrollView class]);
//    CGGFramesScrollView *scrollView = [[CGGFramesScrollView alloc] initWithFrame:CGRectZero];
//    id mock = [OCMockObject partialMockForObject:scrollView];
//    [mock setExpectationOrderMatters:YES];
//    [[mock expect] configure];
//    id blah = [mock initWithCoder:[OCMArg isNotNil]];
//    NSLog(@"Blah: %@", blah);
//    [mock verify];
//}

- (void)testConfigure {
    
    CGGALScrollView *scrollView = [[CGGALScrollView alloc] initWithFrame:CGRectZero];
    [scrollView setCurrentContainerView:[UIView new]];
    [scrollView configure];
    
    // Verify the correct methods are called
    id mock = [OCMockObject partialMockForObject:scrollView];
    [[[mock expect] ignoringNonObjectArgs] setShowsVerticalScrollIndicator:NO];
    [mock configure];
    [mock verify];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
