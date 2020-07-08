#include <Foundation/Foundation.h>
#include <UIKit/UIKit.h>

@interface _UIOverCurrentContextPresentationController : UIPresentationController
{
}

@end

@interface _UIInterfaceActionSeparatableSequenceView : UIView
{
	UIStackView* _stackView;
}

@end

@interface _UIInterfaceActionRepresentationsSequenceView : UIScrollView
{
	_UIInterfaceActionSeparatableSequenceView* _separatedContentSequenceView;
}

@end

@interface _UIAlertControllerActionView : UIView
{
	UIAlertAction * _action;
	UILabel * _label;
	UIAlertController* _alertController;
}

@property (nonatomic, retain) UIVisualEffectView *baActionBackgroundBlurView;

-(void)setHighlighted:(BOOL)arg1;

- (void)applyButtonStyle:(BOOL)isHighlighted;

@end

@interface _UIAlertControllerActionViewInterfaceAction : NSObject
{
}

@property(readonly, nonatomic) _UIAlertControllerActionView *alertControllerActionView;

@end

@interface UIInterfaceActionGroup : NSObject {
    NSArray * _actions; // ActionViewInterfaceAction
}

@end

@interface UIInterfaceActionGroupView : UIView
{
	UIView* _backgroundView;
	UIView* _topLevelItemsView;
	UIInterfaceActionGroup* _actionGroup;
	_UIInterfaceActionRepresentationsSequenceView* _actionSequenceView;
}

-(NSArray *)arrangedHeaderViews;

@end

@interface _UIAlertControllerInterfaceActionGroupView : UIInterfaceActionGroupView
{
    UIAlertController *_alertController;
}

@end

@interface _UIAlertControllerView : UIView
{
    UIAlertController *_alertController;

    _UIAlertControllerInterfaceActionGroupView *_mainInterfaceActionsGroupView;
    _UIAlertControllerInterfaceActionGroupView *_discreteCancelActionGroupView;
}

@property BOOL shouldHaveBackdropView;

@end

@interface UIInterfaceActionRepresentationView : UIView
{
}

- (void)invokeInterfaceAction;

@end


@interface UIAlertController (HookCat)
{
}

@property(readonly) UIView *_dimmingView;
@property(readonly) _Bool _shouldProvideDimmingView;

@property (nonatomic, assign) BOOL isBAEnabled;
@property (nonatomic, assign) BOOL isBAActionSheet;
@property (retain) UIInterfaceActionRepresentationView *baCancelActionView;

- (void)setPreferredStyle:(long long)style;
- (void)_dismissWithAction:(id)arg1;

- (void)handleSingleTap:(UITapGestureRecognizer*)recognizer;
- (void)colorAlertTextRecursive:(UIView *)view;
- (void)removeSeperatorViews:(NSArray*)subviews;

@end

@interface UIBlurEffect (HookCat)
{
}

+(id)effectWithBlurRadius:(double)arg1 ;

@end