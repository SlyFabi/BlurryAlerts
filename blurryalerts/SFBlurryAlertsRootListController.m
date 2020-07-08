#import <Preferences/PSSpecifier.h>

#include <spawn.h>
#include <signal.h>

#include "SFBlurryAlertsRootListController.h"

static NSString *prefsFileName = @"com.slyfabi.blurryalerts";

@implementation SFBlurryAlertsRootListController

- (id)readPreferenceValue:(PSSpecifier*)specifier {
	NSString *path = [NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", prefsFileName];
	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
	return (settings[specifier.properties[@"key"]]) ?: specifier.properties[@"default"];
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
	NSString *path = [NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", prefsFileName];
	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
	[settings setObject:value forKey:specifier.properties[@"key"]];
	[settings writeToFile:path atomically:YES];
	CFStringRef notificationName = (__bridge CFStringRef)specifier.properties[@"PostNotification"];
	if (notificationName) {
		CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), notificationName, NULL, NULL, YES);
	}
}

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
        [self doRespring];
    }];
    
    [alertController addAction:destructiveAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)testAlert {
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Test Alert" message:@"This is a test alert." preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
	UIAlertAction *desAction = [UIAlertAction actionWithTitle:@"Destructive" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {}];
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];
    
    [alertController addAction:okAction];
	[alertController addAction:desAction];
	[alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)resetSettings {
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Confirm" message:@"Reset settings and respring ?" preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];
    UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:@"Reset" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
		NSString *settingsPath = [NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", prefsFileName];

		pid_t pid;
		int status;
		const char *argv[] = {"rm", [settingsPath UTF8String], NULL};
		posix_spawn(&pid, "/bin/rm", NULL, NULL, (char* const*)argv, NULL);
		waitpid(pid, &status, WEXITED);

		[self doRespring];
    }];
    
    [alertController addAction:destructiveAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)openTwitter {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/SlyFabi140"] options:@{} completionHandler:nil];
}

- (void)openDonate {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=VVQVBS8DS36LY&source=url"] options:@{} completionHandler:nil];
}

- (void)openRepo {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://slyfabi.github.io/"] options:@{} completionHandler:nil];
}

- (void)doRespring {
	pid_t pid;
	int status;
	const char *argv[] = {"killall", "SpringBoard", NULL};
	posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)argv, NULL);
	waitpid(pid, &status, WEXITED);
}

@end
