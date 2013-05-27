//
//  MessageViewController.h
//  SchoolNews
//
//  Created by Jerry on 1月9星期三.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <MessageUI/MFMailComposeViewController.h>
typedef enum{
    Message,
    Mail
}Type;
@interface MessageViewController : UIViewController<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>
{
    Type type_;
    
}
@property (nonatomic,retain)MFMessageComposeViewController* messageComposeViewController;
@property (nonatomic,retain)MFMailComposeViewController* mailComposeViewController;
+ (id)singleton;
- (void)setType:(Type )sender;
//在使用之前应该先设置收件人
- (void)setRecipients:(NSArray *)sender;
@end
