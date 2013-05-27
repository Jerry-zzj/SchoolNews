//
//  ContentShowWebViewController.m
//  SchoolNews
//
//  Created by Jerry on 4月12星期五.
//
//

#import "ContentShowWebViewController.h"
#import "TouchMoveWebView.h"
#import "ContentObject.h"
#import "PublicDefines.h"
#import "WebService.h"
#import "RegexKitLite.h"


@interface ContentShowWebViewController ()

- (void)loadWebView;
- (void)loadActivityView;
- (void)loadWebContent;
- (void)loadTheBackBarbutton;
- (void)popSelf;
- (NSString* )composeWenInfo:(NSString* )contentSender;
- (void)changeTheFontSize:(NSMutableString* )sender;
- (void)changeTheImage:(NSMutableString* )sender;

@end

@implementation ContentShowWebViewController
{
    TouchMoveWebView* webView;
    ContentObject* showObject;
    UIActivityIndicatorView* activityView;
    UIView* zoomView;
}
- (id)initWithContentObject:(ContentObject* )sender
{
    self = [super init];
    if (self) {
        showObject = sender;
        [showObject addObserver:self
                     forKeyPath:@"webContent"
                        options:0
                        context:nil];
        
        [showObject addObserver:self
                     forKeyPath:@"zoomEnable"
                        options:0
                        context:nil];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadTheBackBarbutton];
    [self loadWebView];
    [self loadActivityView];
    [self loadWebContent];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [showObject removeObserver:self
                    forKeyPath:@"webContent"];
    [showObject removeObserver:self
                    forKeyPath:@"zoomEnable"];
}

- (void)setZoomEnable:(BOOL )sender
{
    if (sender) {
        //有放大功能
        //[self loadTheZoomButton];
    }
    else
    {
        //没有放大功能
        //self.navigationItem.rightBarButtonItem = nil;
    }
}

#pragma mark kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"webContent"]) {
        NSMutableString* contents = [NSMutableString stringWithString:showObject.webContent];
        [self changeTheFontSize:contents];
        NSString* htmlString = [self composeWenInfo:contents];
        NSString* bundlePath = [[NSBundle mainBundle] resourcePath];
        NSURL* baseURL = [NSURL fileURLWithPath:bundlePath];
        [activityView stopAnimating];
        [webView loadHTMLString:htmlString baseURL:baseURL];
    }
}

#pragma mark customWebView Delegate
- (void)swipToLeft
{
    
}

- (void)swipToRight
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark private
- (void)loadWebView
{
    webView = [[TouchMoveWebView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT - TABBAR_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    webView.swipDelegate = self;
    [self.view addSubview:webView];
}

- (void)loadActivityView
{
    activityView = [[UIActivityIndicatorView alloc] initWithFrame:self.view.bounds];
    [activityView setColor:[UIColor redColor]];
    [self.view addSubview:activityView];
    [activityView startAnimating];
}

- (void)loadWebContent
{
    NSMutableString* content;
    if (showObject.webContent == nil) {
        [showObject.webservice getWebServiceData];
        return;
    }
    else
    {
        content = [NSMutableString stringWithString:showObject.webContent];
    }
    [self changeTheFontSize:content];
    NSString* htmlString = [self composeWenInfo:content];
    NSString* bundlePath = [[NSBundle mainBundle] resourcePath];
    NSURL* baseURL = [NSURL fileURLWithPath:bundlePath];
    [activityView stopAnimating];
    [webView loadHTMLString:htmlString baseURL:baseURL];
}

- (void)loadTheZoomButton
{
    if (zoomView == nil) {
        UIButton* enlargeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [enlargeButton setFrame:CGRectMake(40, 7, 30, 30)];
        [enlargeButton setImage:[UIImage imageNamed:@"放大.png"] forState:UIControlStateNormal];
        [enlargeButton addTarget:self action:@selector(enlarge) forControlEvents:UIControlEventTouchUpInside];
        UIButton* narrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [narrowButton setFrame:CGRectMake(0, 7, 30, 30)];
        [narrowButton setImage:[UIImage imageNamed:@"缩小.png"] forState:UIControlStateNormal];
        [narrowButton addTarget:self action:@selector(narrow) forControlEvents:UIControlEventTouchUpInside];
        
        zoomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
        [zoomView addSubview:enlargeButton];
        [zoomView addSubview:narrowButton];
    }
    UIBarButtonItem* zoomBarButton = [[UIBarButtonItem alloc] initWithCustomView:zoomView];
    self.navigationItem.rightBarButtonItem = zoomBarButton;
}

- (void)loadTheBackBarbutton
{
    NSString* type = showObject.type;
    UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] initWithTitle:type
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(popSelf)];
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (void)popSelf
{
    [self.navigationController popViewControllerAnimated:YES];
}

#define TITLE_HTML(x,titleFontSize)                   [NSString stringWithFormat:@"%@%g%@%@%@",@"<div style=\"text-align:left;margin-bottom:30px\" class=\"ArticleTitle\"><strong><span style=\"font-size:",titleFontSize,@"px;\">",x,@"</span></strong></div>"]

#define RELEASE_DATE(x,fontSize)               [NSString stringWithFormat:@"<div><span style=\"color:#A5A5A5;line-height:10pt;font-size:%ipx\">发布日期:</span><span style=\"color:#A5A5A5;font-size:%i\">%@</span><span style=\"color:#A5A5A5;\"> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span>",fontSize,fontSize,x]

#define RELEASE_DEPARTMENT(x,fontSize)         [NSString stringWithFormat:@"<span style=\"color:#A5A5A5;line-height:10pt;font-size:%ipx\">%@</span><hr /></div>",fontSize,x]

#define HTML_HEADER(head)               [NSString stringWithFormat:@"%@%@%@",@"<html><head>",head,@"</head>"]
#define HTML_CONTENT_CSS(fontSize)      [NSString stringWithFormat:@"%@%g%@",@"<style type=\"text/css\">body{font-size:",fontSize,@"px;color: black;line-height:60pt}hr{size:\"100\";}</style>"]
#define HTML_BODY(body)                 [NSString stringWithFormat:@"<body>%@</body>",body]
#define HTML_END                        @"</html>"
- (NSString* )composeWenInfo:(NSString* )contentSender
{
    NSMutableString* content = [NSMutableString stringWithString:contentSender];
    NSString* titleInHtml = TITLE_HTML(showObject.title,55.0);
    [content insertString:titleInHtml atIndex:0];
    
    //加发布日期
    NSDate* releaseDate = showObject.releaseDate;
    NSString* dateString = [[releaseDate description] substringToIndex:10];
    NSString* releaseDateInHtml = RELEASE_DATE(dateString,WEB_RELEASE_SIZE);
    [content insertString:releaseDateInHtml atIndex:[titleInHtml length]];
    
    //加发布部门
    NSString* department = showObject.releaseDepartment;
    if ([department isEqualToString:@"null"]) {
        department = @" ";
    }
    NSString* releaseDepartmentInHtml = RELEASE_DEPARTMENT(department,WEB_RELEASE_SIZE);
    [content insertString:releaseDepartmentInHtml atIndex:[titleInHtml length] + [releaseDateInHtml length]];
    
    NSString* htmlBodyCss = HTML_CONTENT_CSS(50.0);
    NSString* htmlHead = HTML_HEADER(htmlBodyCss);
    NSString* htmlString = [NSString stringWithFormat:@"%@%@%@",htmlHead,HTML_BODY(content),HTML_END];
    return htmlString;
}


- (void)changeTheFontSize:(NSMutableString* )sender
{
    //LINE-HEIGHT: 26pt
    NSString* fontSizeRegex = @"(FONT|font)(-| )(SIZE|size)(:|: |=)[0-9]+(pt|px)*";
    [sender replaceOccurrencesOfRegex:fontSizeRegex withString:@"FONT size=50"];
    [sender replaceOccurrencesOfRegex:@"(LINE|line)(-| )(HEIGHT|height)(: |=| )[0-9]+pt" withString:@"" range:NSMakeRange(0, sender.length)];
    [self changeTheImage:sender];
    NSLog(@"%@",sender);
}

- (void)changeTheImage:(NSMutableString* )sender
{
    NSString* imageRegex = @"(img|IMG) (src|SRC)=\"";
    [sender replaceOccurrencesOfRegex:imageRegex withString:@"IMG src=\"http://oa.zjicm.edu.cn"];
}

@end
