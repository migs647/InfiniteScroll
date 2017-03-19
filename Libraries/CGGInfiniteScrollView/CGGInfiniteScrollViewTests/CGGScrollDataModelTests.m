//
//  CGGScrollDataModelTests.m
//  CGGInfiniteScrollView
//
//  Created by Cody Garvin on 3/19/17.
//  Copyright © 2017 Cody Garvin. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "CGGScrollDataModel.h"

@interface CGGScrollDataModelTests : XCTestCase

@end

@implementation CGGScrollDataModelTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDescription {

    CGGScrollDataModel *test = [[CGGScrollDataModel alloc] initWithText:@"Test" imageURL:@"image.jpg"];
    NSLog(@"Test: %@", test.description);
    XCTAssert([test.description isEqualToString:@"CGGScrollDataModel: Test - image.jpg"], "Description has been changed");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Make sure we aren't doing anything performant in the initialization
        CGGScrollDataModel *test = [[CGGScrollDataModel alloc] initWithText:@"Test" imageURL:@"image.jpg"];
        NSLog(@"Test: %@", test.description);
    }];
}

@end
