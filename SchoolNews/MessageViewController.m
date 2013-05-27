//
//  MessageViewController.m
//  SchoolNews
//
//  Created by Jerry on 1月9星期三.
//
//

#import "MessageViewController.h"

@interface MessageViewController ()

- (void)showMessagePicker;
- (void)showMailPicker;
- (void)loadMailComposerSheet;
- (void)loadMessageComposerSheet;

@end

@implementation MessageViewController
@synthesize messageComposeViewController;
@synthesize mailComposeViewController;
MessageViewController* g_MessageViewController;
+ (id)singleton
{
    if (g_MessageViewController == nil) {
        g_MessageViewController = [[MessageViewController alloc] init];
    }
    return g_MessageViewController;
}

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

- (void)setType:(Type )sender
{
    type_ = sender;
    switch (type_) {
        case Message:
            [self showMessagePicker];
            break;
        case Mail:
            [self showMailPicker];
            break;
        default:
            break;
    }
}

- (void)setRecipients:(NSArray *)sender
{
    switch (type_) {
        case Mail:
            [self.mailComposeViewController setToRecipients:sender];
            break;
        case Message:
            [self.messageComposeViewController setRecipients:sender];
            break;
        default:
            break;
    }
}

#pragma mark private
- (void)showMessagePicker
{
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (messageClass != nil) {
        if ([messageClass canSendText]) {
            [self loadMessageComposerSheet];
        }
        else
        {
            NSLog(@"the device can not send message");
        }
    }
}

- (void)showMailPicker
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil) {
        if ([mailClass canSendMail]) {
            [self loadMailComposerSheet];
        }
        else {
            NSLog(@"the device is can not send mail");
        }
    }

}

- (void)loadMailComposerSheet
{
    self.mailComposeViewController = [[MFMailComposeViewController alloc] init];
    self.mailComposeViewController.mailComposeDelegate = self;
        //picker.body = @"测试iphone发送短信";
        //    picker.recipients = [NSArray arrayWithObject:@"15801345017"];
        //[self presentViewController:mailComposeViewController_ animated:NO completion:nil];
}

- (void)loadMessageComposerSheet
{
    self.messageComposeViewController = [[MFMessageComposeViewController alloc] init];
    self.messageComposeViewController.messageComposeDelegate = self;
        //picker.body = @"测试iphone发送短信";
        //    picker.recipients = [NSArray arrayWithObject:@"15801345017"];
        //[self presentViewController:messageComposeViewController_ animated:NO completion:nil];
    
}

#pragma Message Deleaget
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    switch (result)
    {
        case MessageComposeResultCancelled:
            NSLog(@"Result: SMS sending canceled");
            break;
        case MessageComposeResultSent:
            NSLog(@"Result: SMS sent");
            break;
        case MessageComposeResultFailed:
            NSLog(@"Result: SMS sending failed");
            break;
        default:
            NSLog(@"Result: SMS not sent");
            break;
    }
    [self.messageComposeViewController dismissViewControllerAnimated:YES completion:nil];
}


#pragma Mail Delegate
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Result: Mail sending canceled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Result: Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Result: Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Result: Mail sending failed");
            break;
        default:
            NSLog(@"Result: Mail not sent");
            break;
    }
    [self.mailComposeViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
