//
//  CollectionHeaderView.m
//  DVDLibrary
//
//  Created by Ming on 3/4/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//

#import "CollectionHeaderView.h"

@implementation CollectionHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 28)];
//        
//        // Setup label
//        self.sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 28)];
//        label.textColor = [UIColor whiteColor];
//        label.textAlignment = NSTextAlignmentCenter;
//        NSString *string = [self.sections objectAtIndex:section];
//        [label setText:string];
//        [view addSubview:label];
        
        [self setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.7f]];
        
        //return view;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
