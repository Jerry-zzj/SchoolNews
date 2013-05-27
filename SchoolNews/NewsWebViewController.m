//
//  NewsWebViewController.m
//  SchoolNews
//
//  Created by Jerry on 1月23星期三.
//
//

#import "NewsWebViewController.h"
#import "RegexKitLite.h"
#import "PublicDefines.h"
#import "SVProgressHUD.h"

#define HTML_HEADER(head)               [NSString stringWithFormat:@"%@%@%@",@"<html><head>",head,@"</head>"]
#define HTML_CONTENT_CSS(fontSize)      [NSString stringWithFormat:@"%@%g%@",@"<style type=\"text/css\">body{font-size:",fontSize,@"px;color: black;line-height:60pt;margin-left:1cm;margin-right:0.4cm}</style>"]
#define HTML_BODY(body)                 [NSString stringWithFormat:@"<body>%@</body>",body]
#define HTML_END                        @"</html>"

#define IMAGE_REGULAR                   @"<(img|IMG) [^>]+>"
#define IMAGE_DOMAIN                    @"src=\"[^\"]+\""
#define IMAGE_WIDTH                     @"(width|WIDTH)(=|:)\"[0-9]{0,4}\""
#define IMAGE_HEIGHT                    @"(height|HEIGHT)(=|:)\"[0-9]{0,4}\""

#define FONT_SIZE                       @"(font-size|Font-SIZE):[0-9]{1,2}(pt|px)"

//html中的标题，发布日期，发布部门，包含格式
/*#define TITLE_HTML(x,titleFontSize)                   [NSString stringWithFormat:@"%@%g%@%@%@",@"<div style=\"text-align:center;\" class=\"ArticleTitle\"><strong><span style=\"font-size:",titleFontSize,@"px;\" id=\"dnn_ctr1533_ArticleDetails_lblTitle\"class=\"Head\">",x,@"</span></strong></div>"]*/
#define TITLE_HTML(x,titleFontSize)                   [NSString stringWithFormat:@"%@%g%@%@%@",@"<div style=\"text-align:left;\" class=\"ArticleTitle\"><strong><span style=\"font-size:",titleFontSize,@"px;\" class=\"Head\">",x,@"</span></strong></div>"]
#define RELEASE_DATE(x,fontSize)               [NSString stringWithFormat:@"<div><span style=\"color:#A5A5A5;line-height:10pt;font-size:%ipx\">发布日期:</span><span style=\"color:#A5A5A5;font-size:%i\">%@</span><span style=\"color:#A5A5A5;\"> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span>",fontSize,fontSize,x]
#define RELEASE_DEPARTMENT(x,fontSize)         [NSString stringWithFormat:@"<span style=\"color:#A5A5A5;line-height:10pt;font-size:%ipx\">%@</span><hr /></div>",fontSize,x]
//
#define MAX_TITLE_SIZE                  90
#define MAX_RELEASE_SIZE                70
#define MAX_CONTENT_SIZE                80
#define MIN_TITLE_SIZE                  60
#define MIN_RELEASE_SIZE                40
#define MIN_CONTENT_SIZE                50

@interface NewsWebViewController ()

//将图片的相对地址换成绝对地址，并且修改图片的大小
- (NSString* )modifyTheImage:(NSString* )sender;
//放大字体
- (void)enlargeTheWebView;
//缩小字体
- (void)narrowTheWebView;
//获得图片所在服务器的域名
- (NSString* )getImageDomain:(NSString* )sender;
//给内容加上标题，发布时间和发布部门
- (NSString* )addTitleAndDateAndDepartment:(NSString* )sender;

@end

@implementation NewsWebViewController
@synthesize touchMoveDelegate;
@synthesize newsDataSource;
NewsWebViewController* g_NewsWebViewController;
- (NewsWebViewController* )singleton
{
    if (g_NewsWebViewController == nil) {
        g_NewsWebViewController = [[NewsWebViewController alloc] init];
    }
    return g_NewsWebViewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        titleSize_ = WEB_TITLE_FONT_SIZE;
        releaseSize_ = WEB_RELEASE_SIZE;
        contentSize_ = WEB_CONTENT_SIZE;
        newsWebView_ = [[CustomWebView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT - TABBAR_HEIGHT - NAVIGATIONBAR_HEIGHT)];
        newsWebView_.swipDelegate = self;
        [self.view addSubview:newsWebView_];
        
        //注册缩放通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(enlargeTheWebView)
                                                     name:@"ToEnlargeTheWebView"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(narrowTheWebView)
                                                     name:@"ToNarrowTheWebView"
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //NSLog(@"%@",NSStringFromCGRect(newsWebView_.frame));
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setContent:(NSString* )sender
{
    NSString* modifyImagecontentString = [self modifyTheImage:sender];
    NSString* addPrefixContentString = [self addTitleAndDateAndDepartment:modifyImagecontentString];
    NSString* htmlBodyCss = HTML_CONTENT_CSS(contentSize_);
    NSString* htmlHead = HTML_HEADER(htmlBodyCss);
    NSString* htmlString = [NSString stringWithFormat:@"%@%@%@",htmlHead,HTML_BODY(addPrefixContentString),HTML_END];
    NSString* bundlePath = [[NSBundle mainBundle] resourcePath];
    NSURL* baseURL = [NSURL fileURLWithPath:bundlePath];
    NSLog(@"%@",htmlString);
    [newsWebView_ loadHTMLString:htmlString baseURL:baseURL];
}

#pragma mark webview delegate
- (void)swipToLeft
{
    [self.touchMoveDelegate touchMoveToLeft];
}

- (void)swipToRight
{
    [self.touchMoveDelegate touchMoveToRight];
}

#pragma mark private method
//将图片的相对地址换成绝对地址，并且修改图片的大小
- (NSString* )modifyTheImage:(NSString* )sender
{
    //NSLog(@"%@",sender);
    content_ = [sender copy];
    NSMutableString* contentString = [NSMutableString stringWithString:sender];
    NSArray* allImageString = [sender componentsMatchedByRegex:IMAGE_REGULAR];
    for (NSString* object in allImageString) {
        NSMutableString* imageString = [NSMutableString stringWithString:object];
        //加入域名
        NSString* tempDomainString = [object stringByMatching:IMAGE_DOMAIN];
        if (tempDomainString != nil && [tempDomainString rangeOfString:@"http"].length == 0) {
            NSMutableString* domainString = [NSMutableString stringWithString:tempDomainString];
            NSString* imageDomainString = [self getImageDomain:sender];
            [domainString insertString:imageDomainString atIndex:5];
            [imageString replaceOccurrencesOfString:tempDomainString withString:domainString options:0 range:NSMakeRange(0, [imageString length])];
        }
        //修改图片宽度
        NSString* widthRegularString = [imageString stringByMatching:IMAGE_WIDTH];
        if (widthRegularString != nil) {
            [imageString replaceOccurrencesOfString:widthRegularString withString:@"width=\"920\"" options:0 range:NSMakeRange(0, [imageString length])];
        }
        else
        {
            [imageString insertString:@"width=\"920\" " atIndex:[imageString length] - 2];
        }
        
        //修改图片高度
        NSString* heightRegularString = [imageString stringByMatching:IMAGE_HEIGHT];
        if (heightRegularString != nil) {
            [imageString replaceOccurrencesOfString:heightRegularString withString:@"height=\"588\"" options:0 range:NSMakeRange(0, [imageString length])];
        }
        else
        {
            [imageString insertString:@"height=\"588\" " atIndex:[imageString length] - 2];
        }
        //替换文本
        [contentString replaceOccurrencesOfString:object withString:imageString options:0 range:NSMakeRange(0, contentString.length)];
    }
    //修改字体大小
    NSArray* fontSizeStringArray = [contentString componentsMatchedByRegex:FONT_SIZE];
    for (NSString* object in fontSizeStringArray) {
        NSString* fontSizeString = [NSString stringWithFormat:@"FONT-SIZE: %gpx",contentSize_];
        [contentString replaceOccurrencesOfString:object withString:fontSizeString options:0 range:NSMakeRange(0, contentString.length)];
    }
    //NSLog(@"%@",contentString);
    return contentString;
}

//放大字体
- (void)enlargeTheWebView
{
    //发大标题
    titleSize_ += 5;
    if (titleSize_ > MAX_TITLE_SIZE) {
        return;
    }
    //放大发布字体
    releaseSize_ += 5;
    if (releaseSize_ > MAX_RELEASE_SIZE) {
        return;
    }
    //放大内容字体
    contentSize_ += 5;
    if (contentSize_ > MAX_CONTENT_SIZE) {
        return;
    }
    if (content_ != nil) {
        [self setContent:content_];
    }
}

//缩小字体
- (void)narrowTheWebView
{
    //缩小标题字体
    titleSize_ -= 5;
    if (titleSize_ < MIN_TITLE_SIZE) {
        return;
    }
    //缩小发布字体
    releaseSize_ -= 5;
    if (releaseSize_ < MIN_RELEASE_SIZE) {
        return;
    }
    //缩小内容字体
    contentSize_ -= 5;
    if (contentSize_ < MIN_CONTENT_SIZE) {
        return;
    }
    if (content_ != nil) {
        [self setContent:content_];
    }
}

//获得图片所在服务器的域名
- (NSString* )getImageDomain:(NSString* )sender
{
    NewsObject* showNews = [self.newsDataSource newsWebViewShowNews];
    if(showNews.newsFrom == nil)
    {
        return @"http://cmccapp.zjicm.edu.cn";
    }
    else
    {
        return showNews.newsFrom;
    }
}

//给内容加上标题，发布时间和发布部门
- (NSString* )addTitleAndDateAndDepartment:(NSString* )sender
{
    NSMutableString* content = [NSMutableString stringWithString:sender];
    NewsObject* showNews = [self.newsDataSource newsWebViewShowNews];
    //加标题
    NSString* titleInHtml = TITLE_HTML(showNews.title,titleSize_);
    [content insertString:titleInHtml atIndex:0];
    
    //加发布日期
    NSDate* releaseDate = showNews.date;
    NSString* dateString = [[releaseDate description] substringToIndex:10];
    NSString* releaseDateInHtml = RELEASE_DATE(dateString,WEB_RELEASE_SIZE);
    [content insertString:releaseDateInHtml atIndex:[titleInHtml length]];
    
    //加发布部门
    NSString* department = showNews.department;
    if ([department isEqualToString:@"null"]) {
        department = @" ";
    }
    NSString* releaseDepartmentInHtml = RELEASE_DEPARTMENT(department,WEB_RELEASE_SIZE);
    [content insertString:releaseDepartmentInHtml atIndex:[titleInHtml length] + [releaseDateInHtml length]];
    
    return content;
}
@end
