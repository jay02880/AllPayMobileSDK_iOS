#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@interface PopUpViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *popUpView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

- (void)showInView:(UIView *)aView withText:(NSString *)text animated:(BOOL)animated;

@end
