//
//  ScrollViewALViewControllerTests.m
//  InfiniteScroll
//
//  Created by Cody Garvin on 3/17/17.
//  Copyright © 2017 Cody Garvin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "ScrollViewALViewController.h"
#import "iTunesXMLParser.h"


typedef void(^iTunesXMLParserTestBlock)(NSError *error);
@interface ScrollViewALViewController ()
- (void)loadData;
@end

@interface ScrollViewALViewControllerTests : XCTestCase <iTunesXMLParserDelegate, UIScrollViewDelegate>
@property (nonatomic, copy) iTunesXMLParserTestBlock fullFillBlock;
@property (nonatomic, strong) XCTestExpectation *expectation;
@property (nonatomic, strong) iTunesXMLParser *parser;
@property (nonatomic, copy) NSURL *url;
@end

@implementation ScrollViewALViewControllerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    
    // Create a parser for later use
    self.url = [[NSBundle mainBundle] URLForResource:@"topsongs" withExtension:@"xml"];
    self.parser = [[iTunesXMLParser alloc] init];
    self.parser.parserDelegate = self;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testViewDidLoad {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    ScrollViewALViewController *allController = [[ScrollViewALViewController alloc] init];
    [allController viewDidLoad];
    
    // create a partial mock for that object
    id mock = [OCMockObject partialMockForObject:allController];
    // tell the mock object what you expect
    [[mock expect] loadData];
    // call the actual method on the mock object
    [mock viewDidLoad];
    // and finally verify
    [mock verify];
}

- (void)testViewNumberOfLabels {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    ScrollViewALViewController *allController = [[ScrollViewALViewController alloc] init];
    [allController viewDidLoad];
    
    // create a partial mock for that object
    id mock = [OCMockObject partialMockForObject:allController];
    // tell the mock object what you expect
    [[mock expect] loadData];
    // call the actual method on the mock object
    [mock viewDidLoad];
    // and finally verify
    [mock verify];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - iTunesXMLParserDelegate Methods
- (void)parsingDidFinishWithData:(NSArray *)data error:(NSError *)error
{
    if (self.fullFillBlock) {
        self.fullFillBlock(error);
    }
}


@end
