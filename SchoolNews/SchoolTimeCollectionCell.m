//
//  SchoolTimeCollectionCell.m
//  SchoolNews
//
//  Created by Jerry on 5月7星期二.
//
//

#import "SchoolTimeCollectionCell.h"
#import "ClassTableViewController.h"
@interface SchoolTimeCollectionCell(privateAPI)

- (void)loadTheTableViewController;

@end
@implementation SchoolTimeCollectionCell
{
    ClassTableViewController* classTableViewController_;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self loadTheTableViewController];
    }
    return self;
}

- (void)setClasses:(NSDictionary* )sender
{
    [classTableViewController_ setClasses:sender];
}

- (void)setLoding:(BOOL )loding
{
    if (loding) {
        //正在加载中
        [classTableViewController_ clear];
    }
    else
    {
        //加载完成
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark private API
- (void)loadTheTableViewController
{
    classTableViewController_ = [[ClassTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [classTableViewController_.tableView setFrame:CGRectMake(0, 0, 320, CGRectGetHeight(self.bounds))];
    [self addSubview:classTableViewController_.tableView];
}

@end
