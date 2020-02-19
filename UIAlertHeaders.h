#include <Foundation/Foundation.h>
#include <UIKit/UIKit.h>

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
}

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

@interface UIAlertController (HookCat)
{
}

@property(readonly) UIView *_dimmingView;
@property(readonly) _Bool _shouldProvideDimmingView;

@property (nonatomic, assign) BOOL isBAEnabled;

- (void)applyButtonBlur:(_UIAlertControllerActionView*)view;
- (void)removeSeperatorViews:(NSArray*)subviews;

@end
