//
//  UILabel+.m
//  InfiniteScroll
//
//  Created by Cody Garvin on 3/15/17.
//  Copyright © 2017 Cody Garvin. All rights reserved.
//

#import "UILabel+.h"

@implementation UILabel (UILabelExtras)
- (CGRect)sizeForCurrentString:(CGSize)constraintSize
{
    // set paragraph style
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    // make dictionary of attributes with paragraph style
    NSDictionary *sizeAttributes = @{NSFontAttributeName:self.font,
                                     NSParagraphStyleAttributeName: style};
    
    CGRect frame = [self.text boundingRectWithSize:constraintSize
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:sizeAttributes context:nil];
    
    return frame;
}
@end
