//
//  ScrollViewALViewController.m
//  InfiniteScroll
//
//  Created by Cody Garvin on 3/15/17.
//  Copyright © 2017 Cody Garvin. All rights reserved.
//

#import "ScrollViewALViewController.h"
#import "iTunesXMLParser.h"
#import <CGGInfiniteScrollView/CGGInfiniteScrollView.h>

@interface ScrollViewALViewController () <CGGALScrollViewDataSource, iTunesXMLParserDelegate>
@property (nonatomic, strong) NSArray *scrollData;
@property (nonatomic, weak) IBOutlet CGGALScrollView *alScrollView;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation ScrollViewALViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    
    // Do any additional setup after loading the view, typically from a nib.
    [self.alScrollView setDataSource:self];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.dataArray = nil;
    self.alScrollView = nil;
}

- (void)loadData
{
    self.dataArray = [[NSMutableArray alloc] init];
    
    // Parse the feed for songs!! songs!!
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"topsongs" withExtension:@"xml"];
    iTunesXMLParser *parser = [[iTunesXMLParser alloc] init];
    parser.parserDelegate = self;
    [parser parseWithURL:url];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - iTunesXMLParserDelegate Methods
- (void)parsingDidFinishWithData:(NSArray *)data error:(NSError *)error
{
    self.dataArray = data;
    [_alScrollView reload];
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
        CGGScrollDataModel *dataModel = [_dataArray objectAtIndex:index];
        returnLabel = [[UILabel alloc] init];
        returnLabel.text = [NSString stringWithFormat:@"%zd - %@", index+1, dataModel.text];
        returnLabel.tag = index;
        returnLabel.numberOfLines = 3;
        returnLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    
    return returnLabel;
}


@end
