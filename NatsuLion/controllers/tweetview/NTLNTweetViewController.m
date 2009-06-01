#import "NTLNTweetViewController.h"
#import "NTLNMessage.h"
#import "NTLNBrowserViewController.h"
#import "NTLNFriendsViewController.h"
#import "NTLNTweetPostViewController.h"
#import "NTLNAccount.h"
#import "NTLNRoundedIconView.h"
#import "NTLNUserTimelineViewController.h"
#import "NTLNConfiguration.h"
#import "NTLNColors.h"
#import "NTLNCellBackgroundView.h"
#import "NTLNAppDelegate.h"
#import "NTLNIconTextCell.h"
#import "NTLNLinkTweetCell.h"
#import "NTLNCell.h"
#import "NTLNTwitterPost.h"
#import "NTLNUserViewController.h"
#import "NSDateExtended.h"
#import "NTLNConversationViewController.h"
#import "NTLNImages.h"
#import "NTLNHttpClientPool.h"
#import "GTMRegex.h"

#define TEXT_FONT_SIZE	16.0

@implementation NTLNURLPair
@synthesize url, text, screenName, conversation;

- (void)dealloc {
	[url release];
	[text release];
	[screenName release];
	[super dealloc];
}
@end


@interface NTLNTweetViewController(Private)
- (CGFloat)getTextboxHeight:(NSString *)str;
- (UITableViewCell *)screenNameCell;
- (UITableViewCell *)urlCell:(NTLNURLPair*)pair isEven:(BOOL)isEven;
- (UITableViewCell *)nameCell;
- (UITableViewCell *)tweetCell;
- (void)parseToken;

@end


@implementation NTLNTweetViewController

@synthesize message;

- (void)setupTableView {
	UITableView *tv = [[[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] 
												   style:UITableViewStylePlain] autorelease];	
	tv.delegate = self;
	tv.dataSource = self;
	tv.autoresizesSubviews = YES;
	tv.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	self.view = tv;
}

- (void)viewDidLoad {
	[self setupTableView];
	((UITableView*)self.view).autoresizesSubviews = YES;
	[self.navigationItem setTitle:@"Tweet"];
}

- (void)makeLinks {
	if (links == nil) {
		links = [[NSMutableArray alloc] init];

		if (message.in_reply_to_status_id.length > 0) {
			NTLNURLPair *pair = [[NTLNURLPair alloc] init];
			pair.text = [NSString stringWithFormat:@"in reply to %@", message.in_reply_to_screen_name];
			pair.conversation = YES;
			[links addObject:pair];
		}

		NTLNURLPair *pair = [[NTLNURLPair alloc] init];
		pair.text = message.screenName;
		[links addObject:pair];
		[self parseToken];
	}
}

- (void)setupPostButton {
	UIBarButtonItem *postButton = [[[UIBarButtonItem alloc] 
									initWithBarButtonSystemItem:UIBarButtonSystemItemCompose 
									target:self 
									action:@selector(replyButtonAction:)] autorelease];
	
	[[self navigationItem] setRightBarButtonItem:postButton];
}

- (void)viewWillAppear:(BOOL)animated {
	NSIndexPath *tableSelection = [(UITableView*)self.view indexPathForSelectedRow];
	[(UITableView*)self.view deselectRowAtIndexPath:tableSelection animated:NO];
	
	[self makeLinks];
	
	[(UITableView*)self.view reloadData];
	
	((UITableView*)self.view).backgroundColor = [[NTLNColors instance] scrollViewBackground];
	if ([[NTLNConfiguration instance] darkColorTheme]) {
		((UITableView*)self.view).indicatorStyle = UIScrollViewIndicatorStyleWhite;
	} else {
		((UITableView*)self.view).indicatorStyle = UIScrollViewIndicatorStyleBlack;
	}

	if (![[NTLNConfiguration instance] lefthand]) {
		[self setupPostButton];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
	LOG(@"NTLNTweetViewController#didReceiveMemoryWarning");
}

- (void)dealloc {
	LOG(@"NTLNTweetViewController#dealloc");
	[links release];
	[message release];
	[favAI release];
	[favButton release];
	[super dealloc];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch ([indexPath row]) {
		case 0:
			return 70;
		case 1:
			return 70 + [self getTextboxHeight:message.text] + 12;
	}
	return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 2 + [links count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	int row = [indexPath row];
	NTLNCell *cell = nil;
	switch(row)
	{
		case 0:
			cell = (NTLNCell*)[self nameCell];
			break;
		case 1:
			cell = (NTLNCell*)[self tweetCell];
			break;
		default:
			cell = (NTLNCell*)[self urlCell:[links objectAtIndex:row-2] isEven:((row%2)==0)];
			break;
	}
	
	if (row >= [links count] + 1) {
		cell.cellType = NTLNCellTypeRoundBottom;
	}
	
	return cell;
}

- (void)switchToUserTimelineViewWithScreenName:(NSString*)screenName {
	NTLNUserTimelineViewController *utvc = [[[NTLNUserTimelineViewController alloc] init] autorelease];
	utvc.screenName = screenName;
	[[self navigationController] pushViewController:utvc animated:YES];
}

- (void)switchToUserTimelineViewWithScreenNames:(NSArray*)screenNames {
	NTLNUserTimelineViewController *utvc = [[[NTLNUserTimelineViewController alloc] init] autorelease];
	utvc.screenNames = screenNames;
	[[self navigationController] pushViewController:utvc animated:YES];
}

- (void)switchToBrowserViewWithURL:(NSString*)url {
	if ([[NTLNConfiguration instance] useSafari]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
	} else {
		NTLNBrowserViewController *browser = [[[NTLNBrowserViewController alloc] init] autorelease];
		browser.url = url;
		[[self tabBarController] presentModalViewController:browser animated:YES]; 
	}
}

- (void)switchToUserViewWithScreenName:(NSString*)screenName {
	NTLNUserViewController *vc = [[[NTLNUserViewController alloc] init] autorelease];
	vc.message = message;
	[[self navigationController] pushViewController:vc animated:YES];
}

- (void)switchToConversationView {
	NTLNConversationViewController *vc = [[[NTLNConversationViewController alloc] init] autorelease];
	vc.rootMessage = message;
	[[self navigationController] pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	int row = [indexPath row];
	if (row == 0) {
		[self switchToUserViewWithScreenName:message.screenName];
	} else if (row == 1) {
		
	} else {
		NTLNURLPair *pair = [links objectAtIndex:row-2];
		
		if (pair.screenName) {
			NSArray *names = [[NSArray alloc] initWithObjects:message.screenName, pair.screenName, nil];
			[self switchToUserTimelineViewWithScreenNames:names];
			[names release];
		} else if (pair.url) {
			[self switchToBrowserViewWithURL:pair.url];
		} else if (pair.conversation) {
			[self switchToConversationView];
		} else {
			[self switchToUserTimelineViewWithScreenName:message.screenName];
		}		
	}
}

- (void)favButtonAction:(id)sender {
	NTLNTwitterClient *twitterClient = [[NTLNHttpClientPool sharedInstance] 
							 idleClientWithType:NTLNHttpClientPoolClientType_TwitterClient];
	twitterClient.delegate = self;

	if (message.favorited) {
		[twitterClient destroyFavoriteWithID:message.statusId];
	} else {
		[twitterClient createFavoriteWithID:message.statusId];
	}
	
	UIImage *buttonImage = nil;
	if ([[NTLNConfiguration instance] darkColorTheme]) {
		buttonImage = [UIImage imageNamed:@"pushed_black_04.png"];
	} else {
		buttonImage = [UIImage imageNamed:@"pushed_04.png"];
	}
	[favButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
	[favButton addSubview:favAI];
	[favAI startAnimating];
}

- (void)replyButtonAction:(id)sender {
	if (message.replyType == NTLN_MESSAGE_REPLY_TYPE_DIRECT) {
		[[NTLNTwitterPost shardInstance] createDMPost:message.screenName withReplyMessage:message];
	} else {
		[[NTLNTwitterPost shardInstance] createReplyPost:[@"@" stringByAppendingString:message.screenName] 
										withReplyMessage:message];
	}
	[NTLNTweetPostViewController present:self.tabBarController];
}

- (void)retweetButtonAction:(id)sender {
	[[NTLNTwitterPost shardInstance] updateText:[NSString stringWithFormat:@"RT @%@: %@", message.screenName, message.text]];
	[NTLNTweetPostViewController present:self.tabBarController];
}

- (CGFloat)getTextboxHeight:(NSString *)str
{
	CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:TEXT_FONT_SIZE] 
				  constrainedToSize:CGSizeMake(300.0, 280.0)];
	CGFloat h = size.height;
	if (h < 20) return 20.0;
	return h;
}

- (UIImage*)favButtonImage{
	if (message.favorited) {
		if ([[NTLNConfiguration instance] darkColorTheme]) {
			return [UIImage imageNamed:@"normal_black_04_.png"];
		} else {
			return [UIImage imageNamed:@"normal_04_.png"];
		}
	} else {
		if ([[NTLNConfiguration instance] darkColorTheme]) {
			return [UIImage imageNamed:@"normal_black_04.png"];
		} else {
			return [UIImage imageNamed:@"normal_04.png"];
		}
	}
}

- (UITableViewCell *)nameCell {	
	NTLNLinkNameCell *cell = [[[NTLNLinkNameCell alloc] initWithFrame:CGRectZero] autorelease];
	[cell createCellWithName:message.name screenName:message.screenName];

	NTLNRoundedIconView *iconview = [[[NTLNRoundedIconView alloc] 
									  initWithFrame:CGRectMake(6.5, 6.5, 56.0, 56.0) 
									  image:message.iconContainer.iconImage 
									  round:8.0] autorelease];
	iconview.backgroundColor = [UIColor clearColor];
	[iconview addTarget:self action:@selector(replyButtonAction:)
	   forControlEvents:UIControlEventTouchUpInside];
	[cell.contentView addSubview:iconview];	

	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	return cell;
}

- (UITableViewCell *)tweetCell {
	CGFloat textHeight = [self getTextboxHeight:message.text];
	NTLNLinkTweetCell *cell = [[[NTLNLinkTweetCell alloc] initWithFrame:CGRectZero] autorelease];

	NSString *footer;
	if (message.source.length > 0) {
		footer = [NSString stringWithFormat:@"%@ from %@", [message.timestamp descriptionWithTwitterStyle], message.source];
	} else {
		footer = [message.timestamp descriptionWithTwitterStyle];
	}
	[cell createCellWithText:message.text footer:footer textHeight:textHeight];
	
	textHeight += 12;
	
	
	UIImage *bimage[5];
	if ([[NTLNConfiguration instance] darkColorTheme]) {
		bimage[0] = [UIImage imageNamed:@"normal_black_03.png"];
		bimage[1] = [UIImage imageNamed:@"pushed_black_03.png"];
		bimage[2] = [UIImage imageNamed:@"pushed_black_04.png"];
		bimage[3] = [UIImage imageNamed:@"normal_black_05.png"];
		bimage[4] = [UIImage imageNamed:@"pushed_black_05.png"];
	} else {
		bimage[0] = [UIImage imageNamed:@"normal_03.png"];
		bimage[1] = [UIImage imageNamed:@"pushed_03.png"];
		bimage[2] = [UIImage imageNamed:@"pushed_04.png"];
		bimage[3] = [UIImage imageNamed:@"normal_05.png"];
		bimage[4] = [UIImage imageNamed:@"pushed_05.png"];
	}
		
	int y = textHeight + 13*2;
	{
		UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
		[b setFrame:CGRectMake(13, y, 100, 36)];
		[b setBackgroundImage:bimage[0] forState:UIControlStateNormal];
		[b setBackgroundImage:bimage[1] forState:UIControlStateHighlighted];
		[b addTarget:self action:@selector(replyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
		[cell addSubview:b];
	}
	{
		UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
		[b setFrame:CGRectMake(13+100, y, 97, 36)];
		[b setBackgroundImage:[self favButtonImage] forState:UIControlStateNormal];
		[b setBackgroundImage:bimage[2] forState:UIControlStateHighlighted];
		[b addTarget:self action:@selector(favButtonAction:) forControlEvents:UIControlEventTouchUpInside];
		[cell addSubview:b];
		favButton = [b retain];
		
		UIActivityIndicatorView *ai = [[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(97/2-12, 36/2-12, 24, 24)] autorelease];
		ai.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
		ai.hidesWhenStopped = YES;
		favAI = [ai retain];
	}
	{
		UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
		[b setFrame:CGRectMake(13+100+97, y, 100, 36)];
		[b setBackgroundImage:bimage[3] forState:UIControlStateNormal];
		[b setBackgroundImage:bimage[4] forState:UIControlStateHighlighted];
		[b addTarget:self action:@selector(retweetButtonAction:) forControlEvents:UIControlEventTouchUpInside];
		[cell addSubview:b];
	}
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
//	cell.cellType = NTLNCellTypeNoRound;
//	cell.bgcolor = [[NTLNColors instance] oddBackground];
	return cell;
}

- (UITableViewCell *)urlCell:(NTLNURLPair*)pair isEven:(BOOL)isEven {	
	NTLNIconTextCell *cell = [[[NTLNIconTextCell alloc] initWithFrame:CGRectZero] autorelease];
	UIImage *icon = nil;
	if (pair.screenName || pair.conversation) {
		icon = [[NTLNImages sharedInstance] iconConversation];
	} else if (pair.url != nil) {
		icon = [[NTLNImages sharedInstance] iconURL];
	} else {
		icon = [[NTLNImages sharedInstance] iconChat];
	}
	[cell createCellWithText:pair.text icon:icon isEven:isEven];
	return cell;
}

- (void)parseToken {
	NSString *text = message.text;
	NSArray *a;

	a = [text gtm_allSubstringsMatchedByPattern:@"@[[:alnum:]_]+"];
	for (NSString *s in a) {
		NTLNURLPair *pair = [[NTLNURLPair alloc] init];
		pair.text = [NSString stringWithFormat:@"%@ + %@", message.screenName, [s substringFromIndex:1]];
		pair.screenName = [s substringFromIndex:1];
		[links addObject:pair];
		[pair release];
	}

	a = [text gtm_allSubstringsMatchedByPattern:@"http:\\/\\/[^[:space:]]+"];
	for (NSString *s in a) {
		NTLNURLPair *pair = [[NTLNURLPair alloc] init];
		pair.text = s;
		pair.url = s;
		[links addObject:pair];
		[pair release];
	}

	a = [text gtm_allSubstringsMatchedByPattern:@"https:\\/\\/[^[:space:]]+"];
	for (NSString *s in a) {
		NTLNURLPair *pair = [[NTLNURLPair alloc] init];
		pair.text = s;
		pair.url = s;
		[links addObject:pair];
		[pair release];
	}
/*
	a = [text gtm_allSubstringsMatchedByPattern:@"#[^[:space:]]+"];
	for (NSString *s in a) {
		NSLog(@"hashtags: %@", s);
	}
*/	
}

- (void)twitterClientSucceeded:(NTLNTwitterClient*)sender messages:(NSArray*)messages {
	message.favorited = !message.favorited;
	[favButton setBackgroundImage:[self favButtonImage] forState:UIControlStateNormal];
	[favAI stopAnimating];
	[favAI removeFromSuperview];
}

- (void)twitterClientFailed:(NTLNTwitterClient*)sender {
	[favButton setBackgroundImage:[self favButtonImage] forState:UIControlStateNormal];
	[favAI stopAnimating];
	[favAI removeFromSuperview];
}

- (void)twitterClientBegin:(NTLNTwitterClient*)sender {
	LOG(@"TweetView#twitterClientBegin");
}

- (void)twitterClientEnd:(NTLNTwitterClient*)sender {
	LOG(@"TweetView#twitterClientEnd");
}

@end



