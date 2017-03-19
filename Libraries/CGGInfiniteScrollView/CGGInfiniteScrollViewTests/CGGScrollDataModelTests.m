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

- (void)testModelConverted {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    CGGScrollDataModel *dataModel = [[CGGScrollDataModel alloc] initWithText:@"test1" imageURL:@"testURL"];
    XCTAssertTrue([dataModel.text isEqualToString:@"test1"], @"Image text did not save");
    XCTAssertNotNil(dataModel.imageURL, @"image url failed to convert");
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
