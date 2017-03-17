//
//  ScrollViewFramesViewController.m
//  InfiniteScroll
//
//  Created by Cody Garvin on 3/15/17.
//  Copyright © 2017 Cody Garvin. All rights reserved.
//

#import "ScrollViewFramesViewController.h"
#import "ScrollDataModel.h"
#import "iTunesXMLParser.h"
#import "CGGFramesScrollView.h"
#import <AFNetworking/AFNetworking.h>

@interface ScrollViewFramesViewController () <CGGFramesScrollViewDataSource, iTunesXMLParserDelegate>
@property (nonatomic, strong) NSArray *scrollData;
@property (nonatomic, weak) IBOutlet CGGFramesScrollView *frameScrollView;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation ScrollViewFramesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self loadData];
    
    // Do any additional setup after loading the view, typically from a nib.
    [self.frameScrollView setDataSource:self];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData
{
    // Load the data from AFNetworking instead of the built-in xml
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    AFXMLParserResponseSerializer *responseSerializer = [AFXMLParserResponseSerializer serializer];
    NSMutableSet *currentContentTypes = responseSerializer.acceptableContentTypes.mutableCopy;
    [currentContentTypes addObject:@"application/atom+xml"];
    responseSerializer.acceptableContentTypes = [NSSet setWithSet:currentContentTypes];
    manager.responseSerializer = responseSerializer;
    
    NSURL *URL = [NSURL URLWithString:@"https://itunes.apple.com/us/rss/topsongs/limit=10/xml"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
            [self parseXMLPayload:responseObject];
        }
        
    }];
    [dataTask resume];
}

- (void)parseXMLPayload:(NSXMLParser *)parser
{
    self.dataArray = [[NSMutableArray alloc] init];
    
    // Parse the feed for songs!! songs!!
    iTunesXMLParser *iTunesParser = [[iTunesXMLParser alloc] init];
    iTunesParser.parserDelegate = self;
    [iTunesParser parseWithParser:parser];

}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - iTunesXMLParserDelegate Methods
- (void)parsingDidFinishWithData:(NSArray *)data error:(NSError *)error
{
    self.dataArray = data;
    [_frameScrollView reload];
    
    // Stop animating hud
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - ContinuousScrollViewDataSource Methods
- (NSInteger)numberOfLabels
{
    return [_dataArray count];
}

- (UILabel *)labelAtIndex:(NSInteger)index
{
    UILabel *returnLabel = nil;
    if ([_dataArray count] > index)
    {
        ScrollDataModel *dataModel = [_dataArray objectAtIndex:index];
        returnLabel = [[UILabel alloc] init];
        returnLabel.text = [NSString stringWithFormat:@"%zd - %@", index+1, dataModel.text];
        returnLabel.tag = index;
        returnLabel.numberOfLines = 3;
        returnLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    
    return returnLabel;
}

@end
