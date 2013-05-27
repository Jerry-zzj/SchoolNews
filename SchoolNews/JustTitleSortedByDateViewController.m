//
//  JustTitleSortedByDateViewController.m
//  SchoolNews
//
//  Created by shuangchi on 12月19星期三.
//
//

#import "JustTitleSortedByDateViewController.h"

@interface JustTitleSortedByDateViewController ()

@end

@implementation JustTitleSortedByDateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = [indexPath section];
    int row = [indexPath row];
    NSString* key = [allKeys_ objectAtIndex:section];
    NSArray* objectForKey = [self.showDataDictionary objectForKey:key];
    NSDictionary* dictionaryInRow = [objectForKey objectAtIndex:row];
    NSString* title = [dictionaryInRow objectForKey:@"标题"];
    
    CGSize tempSize = CGSizeMake(320, 1000);
    UIFont* font = [UIFont systemFontOfSize:17];
    CGSize textSize = [title sizeWithFont:font
                        constrainedToSize:tempSize
                            lineBreakMode:NSLineBreakByCharWrapping];
    if (textSize.height < 44) {
        return 44.0;
    }
    else
    {
        return textSize.height;
    }
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    int section = [indexPath section];
    int row = [indexPath row];
    NSString* key = [allKeys_ objectAtIndex:section];
    NSArray* objectForKey = [self.showDataDictionary objectForKey:key];
    NSDictionary* dictionaryInRow = [objectForKey objectAtIndex:row];
    NSString* title = [dictionaryInRow objectForKey:@"标题"];
    
    /*CGSize tempSize = CGSizeMake(320 , 1000);
    UIFont* font = [UIFont systemFontOfSize:17];
    CGSize size= [title sizeWithFont:font
                   constrainedToSize:tempSize
                       lineBreakMode:UILineBreakModeWordWrap];*/
    cell.textLabel.numberOfLines = 10;
    cell.textLabel.text = title;
    return cell;
}
@end
