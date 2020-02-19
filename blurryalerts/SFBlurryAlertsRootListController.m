#include <spawn.h>
#include <signal.h>

#include "SFBlurryAlertsRootListController.h"

@implementation SFBlurryAlertsRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (void)respring {
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Confirm" message:@"Do you really want to respring ?" preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];
    UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:@"Respring" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        pid_t pid;
		int status;
		const char *argv[] = {"killall", "SpringBoard", NULL};
		posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)argv, NULL);
		waitpid(pid, &status, WEXITED);
    }];
    
    [alertController addAction:destructiveAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated: YES completion: nil];
}

- (void)testAlert {
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Test Alert" message:@"This is a test alert." preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    
    [alertController addAction:okAction];
    [self presentViewController:alertController animated: YES completion: nil];
}

@end
