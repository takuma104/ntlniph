#import "UICTableViewCellTextInput.h"

@implementation UICTableViewCellTextInput

@synthesize textField;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code

		textField = [[[[UITextField alloc] 
					   initWithFrame:CGRectMake(110, 12, 160, 24)] autorelease] retain];
		
		textField.keyboardType = UIKeyboardTypeASCIICapable;
		textField.returnKeyType = UIReturnKeyDone;
		textField.autocorrectionType = UITextAutocorrectionTypeNo;
		textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
		textField.textColor = [UIColor colorWithRed:(0x32/255.0) green:(0x4f/255.0) blue:(0x85/255.0) alpha:1.0];
		textField.delegate = self;
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		[self addSubview:textField];
	
	}
    return self;
}

- (void)dealloc {
	[textField removeFromSuperview];
	[textField release];
	[prototype release];
    [super dealloc];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)aTextField {
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)aTextField {
	prototype.value = aTextField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField {
	[aTextField resignFirstResponder];
    return YES;
}

- (void)updateWithPrototype:(UICPrototypeTableCellTextInput*)aPrototype {
	[prototype release];
	prototype = [aPrototype retain];

	textField.text = prototype.value;
	textField.placeholder = prototype.placeholder;
	textField.secureTextEntry = prototype.secure;
}

@end
