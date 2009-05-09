#import "NSDateExtended.h"

@implementation NSDate(NTLNExtended) 

- (NSString*)descriptionWithTwitterStyle {
	time_t now = [[NSDate date] timeIntervalSince1970];
	time_t t = [self timeIntervalSince1970];
	
	int d = now - t;
	
	if (d < 5) {
		return @"less than 5 seconds ago";
	} else if (d < 10) {
		return @"less than 10 seconds ago";
	} else if (d < 15) {
		return @"less than 15 seconds ago";
	} else if (d < 20) {
		return @"less than 20 seconds ago";
	} else if (d < 30) {
		return @"half a minute ago";
	} else if (d < 60) {
		return @"less than a minute ago";
	} else if (d < 45*60 ) {
		return [NSString stringWithFormat:@"about %d minute ago", d/60];
	} else if (d < 24*60*60) {
		int h = d/3600;
		if (h < 1) h = 1;
		return [NSString stringWithFormat:@"about %d hour ago",h];
	}
	
	char tmp[80];
	struct tm *tm_ = localtime(&t);
	strftime(tmp, sizeof(tmp), "%I:%M %p %b %dth", tm_);
	return [NSString stringWithUTF8String:tmp];
}

- (NSString*)descriptionWithNTLNStyle {
	time_t now = [[NSDate date] timeIntervalSince1970];
	time_t t = [self timeIntervalSince1970];
	struct tm *tm_ = localtime(&t);
	char tmp[80];
	
	int d = now - t;

	if (d < 24*60*60) {
		strftime(tmp, sizeof(tmp), "%I:%M %p", tm_);
	} else {
		strftime(tmp, sizeof(tmp), "%b %dth", tm_);
	}
	return [NSString stringWithUTF8String:tmp];
}

- (NSString*)descriptionWithRateLimitRemaining {
	time_t now = [[NSDate date] timeIntervalSince1970];
	time_t t = [self timeIntervalSince1970];
	
	int d = t - now;
	
	if (d < 0) {
		return @"soon";
	} else if (d < 60) {
		return [NSString stringWithFormat:@"about %d second", d];
	} else if (d < 60*60) {
		return [NSString stringWithFormat:@"about %d minute", d/60];
	} else if (d < 24*60*60) {
		return [NSString stringWithFormat:@"about %d hour",d/3600];
	}
	
	char tmp[80];
	struct tm *tm_ = localtime(&t);
	strftime(tmp, sizeof(tmp), "%I:%M %p %b %dth", tm_);
	return [NSString stringWithUTF8String:tmp];
}

@end
