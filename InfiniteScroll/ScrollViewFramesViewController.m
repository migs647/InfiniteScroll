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
    [_frameScrollView reload];
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
