#include "UIAlertHeaders.h"

//#define LOGGING

#ifdef LOGGING
#define DBG(fmt, ...) NSLog(fmt, ##__VA_ARGS__)
#else
#define DBG(fmt, ...)
#endif

@interface UIBlurEffect (HookCat)
{
}

@property (nonatomic,readonly) UIColor * _tintColor; 

+(id)effectWithBlurRadius:(double)arg1 ;
+(id)_effectWithTintColor:(id)arg1 ;

@end

@interface _UIBackdropViewSettings : NSObject
{
}

- (void)setColorTint:(id)arg1;
- (void)setColorTintAlpha:(double)arg1;

@end

@interface UIVisualEffect (HookCat)
{
}

@property (nonatomic, readonly) _UIBackdropViewSettings *effectSettings;

@end

%hook UIAlertController

%property (nonatomic, assign) BOOL isBAEnabled;

+ (id)alertControllerWithTitle:(id)title message:(id)message preferredStyle:(long long)style {
	UIAlertController *alertController = %orig;

	if(style == UIAlertControllerStyleActionSheet) {
		alertController.isBAEnabled = NO;
	} else {
		alertController.isBAEnabled = YES;
	}

	return alertController;
}

- (id)init {
	UIAlertController *alertController = %orig;
	alertController.isBAEnabled = YES;
	return alertController;
}

// _dimmingView -> blurView
- (void)viewDidLayoutSubviews {
	%orig;

	if(!self.isBAEnabled)
		return;

	// Remove background
	_UIAlertControllerView *view = MSHookIvar<_UIAlertControllerView*>(self, "_view");
	view.shouldHaveBackdropView = NO;

	_UIAlertControllerInterfaceActionGroupView *mainView = MSHookIvar<_UIAlertControllerInterfaceActionGroupView*>(view, "_mainInterfaceActionsGroupView");
	UIView *itemsView = MSHookIvar<UIView*>(mainView, "_topLevelItemsView");
	itemsView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];

	DBG(@"[BlurryAlerts] Top Level: %@", itemsView);

	UIView *bgView = MSHookIvar<UIView*>(mainView, "_backgroundView");
	if(bgView != 0) {
		bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
	}

	DBG(@"[BlurryAlerts] Background: %@", bgView);

	// Color Text
	for(UIView *textSuperView in [mainView arrangedHeaderViews]) {
		for(UIView *textView in [textSuperView subviews]) {
			if([textView isKindOfClass:%c(UILabel)]) {
				UILabel *label = (UILabel*)textView;
				label.tintColor = [UIColor whiteColor];
				label.textColor = [UIColor whiteColor];
			}
		}
	}

	// Get Buttons
	UIInterfaceActionGroup *actionGroup = MSHookIvar<UIInterfaceActionGroup*>(mainView, "_actionGroup");
	NSArray *actions = MSHookIvar<NSArray*>(actionGroup, "_actions");
	for(id actionInterface in actions) {
		DBG(@"[BlurryAlerts] Action: %@", actionInterface);

		if([actionInterface isKindOfClass:%c(_UIAlertControllerActionViewInterfaceAction)]) {
			_UIAlertControllerActionViewInterfaceAction *action = (_UIAlertControllerActionViewInterfaceAction*)actionInterface;
			_UIAlertControllerActionView *actionView = action.alertControllerActionView;
			[self applyButtonBlur:actionView];
		} else {
			DBG(@"[BlurryAlerts] Unknown action!");
		}
	}

	// Remove main seperators
	[self removeSeperatorViews:itemsView.subviews];

	// Get Stack View
	_UIInterfaceActionRepresentationsSequenceView *seqView = MSHookIvar<_UIInterfaceActionRepresentationsSequenceView*>(mainView, "_actionSequenceView");
	_UIInterfaceActionSeparatableSequenceView *sepView = MSHookIvar<_UIInterfaceActionSeparatableSequenceView*>(seqView, "_separatedContentSequenceView");
	UIStackView *stackView = MSHookIvar<UIStackView*>(sepView, "_stackView");

	DBG(@"[BlurryAlerts] StackView: %@ Views: %@", stackView, stackView.arrangedSubviews);

	// Remove seperators and add spacing
	[self removeSeperatorViews:stackView.arrangedSubviews];
	for(UIView *view in stackView.arrangedSubviews) {
		[stackView setCustomSpacing:5.0 afterView:view];
	}

	CGFloat scrollViewHeight = 0.0f;
	for (UIView* view in seqView.subviews) {
		scrollViewHeight += view.frame.size.height + 5;
	}

	[seqView setContentSize:(CGSizeMake(320, scrollViewHeight))];
	
	UIView *superview = seqView.superview;
    while (superview != nil) {
        for (NSLayoutConstraint *c in superview.constraints) {
            if (c.firstItem == seqView || c.secondItem == seqView) {
				DBG(@"[BlurryAlerts] Constraint: %@", c);
				if([[NSString stringWithFormat: @"%@", c] containsString:@"groupView.actionsSequence....height =="]) {
					c.constant = scrollViewHeight;
				}
            }
        }
        superview = superview.superview;
    }

	for (NSLayoutConstraint *c in seqView.constraints) {
		DBG(@"[BlurryAlerts] Constraint: %@", c);
		if([[NSString stringWithFormat: @"%@", c] containsString:@"groupView.actionsSequence....height =="]) {
			c.constant = scrollViewHeight;
		}
	}
}

- (void)viewWillAppear:(BOOL)arg1 {
	%orig;

	if(!self.isBAEnabled)
		return;

	// Apply blur
	UIView *blurView = self._dimmingView;
	blurView.alpha = 1;

	UIBlurEffect *blurEffect = [UIBlurEffect effectWithBlurRadius:10];
	_UIBackdropViewSettings *blurSettings = blurEffect.effectSettings;
	[blurSettings setColorTint:[UIColor colorWithRed:0 green:1 blue:0 alpha:1]];

	UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
	visualEffectView.alpha = 1;

	visualEffectView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	blurView.autoresizesSubviews = YES;
	blurView.clipsToBounds = YES;

	[blurView addSubview:visualEffectView];
}

// ToDo: Add Vibrancy with background
%new
- (void)applyButtonBlur:(_UIAlertControllerActionView*)view {
	view.layer.cornerRadius = 5;
	view.layer.masksToBounds = true;

	UIAlertAction *action = MSHookIvar<UIAlertAction*>(view, "_action");
	UILabel *label = MSHookIvar<UILabel*>(view, "_label");

	label.tintColor = [UIColor whiteColor];
	label.textColor = [UIColor whiteColor];

	if(action.style == UIAlertActionStyleDestructive) {
		view.backgroundColor = [UIColor colorWithRed:0.6 green:0 blue:0 alpha:1];
		UIFontDescriptor * fontD = [label.font.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
		label.font = [UIFont fontWithDescriptor:fontD size:0];
	} else {
		view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];

		UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
		UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];

		visualEffectView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		view.autoresizesSubviews = YES;
		view.clipsToBounds = YES;

		visualEffectView.frame = view.bounds;
		visualEffectView.alpha = 0.4;
		[view addSubview:visualEffectView];
		[view sendSubviewToBack:visualEffectView];
	}
}

%new
- (void)removeSeperatorViews:(NSArray*)subviews {
	for(UIView *view in subviews) {
		if([view isKindOfClass:%c(_UIInterfaceActionVibrantSeparatorView)]) {
			DBG(@"[BlurryAlerts] View: Removed seperator!");
			[view setHidden:YES];
		}
	}
}

%end