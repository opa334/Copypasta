#include "CPARootListController.h"

@implementation CPARootListController

- (void)viewDidLoad {

    [super viewDidLoad];

    self.appearanceSettings = [CPAAppearanceSettings new];
    self.hb_appearanceSettings = [self appearanceSettings];


    self.preferences = [[HBPreferences alloc] initWithIdentifier:@"love.litten.copypastapreferences"];


    self.enableSwitch = [UISwitch new];
    [[self enableSwitch] setOnTintColor:[UIColor whiteColor]];
    [[self enableSwitch] addTarget:self action:@selector(setEnabled) forControlEvents:UIControlEventTouchUpInside];


    self.item = [[UIBarButtonItem alloc] initWithCustomView:[self enableSwitch]];
    self.navigationItem.rightBarButtonItem = [self item];
    [[self navigationItem] setRightBarButtonItem:[self item]];


    self.navigationItem.titleView = [UIView new];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [[self titleLabel] setFont:[UIFont boldSystemFontOfSize:17]];
    [[self titleLabel] setText:@"1.3.2"];
    [[self titleLabel] setTextColor:[UIColor whiteColor]];
    [[self titleLabel] setTextAlignment:NSTextAlignmentCenter];
    [[[self navigationItem] titleView] addSubview:[self titleLabel]];

    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.navigationItem.titleView.topAnchor],
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.navigationItem.titleView.leadingAnchor],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.navigationItem.titleView.trailingAnchor],
        [self.titleLabel.bottomAnchor constraintEqualToAnchor:self.navigationItem.titleView.bottomAnchor],
    ]];


    self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [[self iconView] setContentMode:UIViewContentModeScaleAspectFit];
    [[self iconView] setImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/CopypastaPrefs.bundle/icon.png"]];
    [[self iconView] setAlpha:0.0];
    [[[self navigationItem] titleView] addSubview:[self iconView]];

    self.iconView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.iconView.topAnchor constraintEqualToAnchor:self.navigationItem.titleView.topAnchor],
        [self.iconView.leadingAnchor constraintEqualToAnchor:self.navigationItem.titleView.leadingAnchor],
        [self.iconView.trailingAnchor constraintEqualToAnchor:self.navigationItem.titleView.trailingAnchor],
        [self.iconView.bottomAnchor constraintEqualToAnchor:self.navigationItem.titleView.bottomAnchor],
    ]];


    self.blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
    self.blurView = [[UIVisualEffectView alloc] initWithEffect:[self blur]];


    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    [[self headerImageView] setContentMode:UIViewContentModeScaleAspectFill];
    [[self headerImageView] setImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/CopypastaPrefs.bundle/Banner.png"]];
    [[self headerImageView] setClipsToBounds:YES];
    [[self headerView] addSubview:[self headerImageView]];

    self.headerImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.headerImageView.topAnchor constraintEqualToAnchor:self.headerView.topAnchor],
        [self.headerImageView.leadingAnchor constraintEqualToAnchor:self.headerView.leadingAnchor],
        [self.headerImageView.trailingAnchor constraintEqualToAnchor:self.headerView.trailingAnchor],
        [self.headerImageView.bottomAnchor constraintEqualToAnchor:self.headerView.bottomAnchor],
    ]];

    size_t size;
    cpu_type_t type;
    cpu_subtype_t subtype;
    size = sizeof(type);
    sysctlbyname("hw.cputype", &type, &size, NULL, 0);
    size = sizeof(subtype);
    sysctlbyname("hw.cpusubtype", &subtype, &size, NULL, 0);

    if (type == 16777228 && subtype == 2) {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Copypasta" message:@"You're using an arm64e device, you may or may not experience issues with this tweak on this architecture\n\n If some system apps start crashing, either uninstall this tweak or install choicy and blacklist Copypasta from injecting into that app" preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:@"Understood" style:UIAlertActionStyleDestructive handler:nil];

        [alertController addAction:confirmAction];

        [self presentViewController:alertController animated:YES completion:nil];
    }

    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/Copypasta.disabled"]) {
        [[self enableSwitch] setEnabled:NO];

        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Copypasta" message:@"Copypasta has detected that you have disabled it with iCleaner Pro, here are some quick actions you can perform" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* resetAction = [UIAlertAction actionWithTitle:@"Reset preferences" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
            [self resetPreferences];
        }];

        UIAlertAction* backAction = [UIAlertAction actionWithTitle:@"Back" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
            [[self navigationController] popViewControllerAnimated:YES];
        }];

        UIAlertAction* ignoreAction = [UIAlertAction actionWithTitle:@"Ignore" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
            [[self enableSwitch] setEnabled:YES];
        }];

        [alertController addAction:resetAction];
        [alertController addAction:backAction];
        [alertController addAction:ignoreAction];

        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    CGRect frame = self.table.bounds;
    frame.origin.y = -frame.size.height;

    [[[[self navigationController] navigationController] navigationBar] setBarTintColor:[UIColor colorWithRed:0.76 green:0.67 blue:1.00 alpha:1.00]];
    [[[[self navigationController] navigationController] navigationBar] setTintColor:[UIColor whiteColor]];
    [[[[self navigationController] navigationController] navigationBar] setShadowImage:[UIImage new]];
    [[[[self navigationController] navigationController] navigationBar] setTranslucent:YES];

    [[self blurView] setFrame:[[self view] bounds]];
    [[self blurView] setAlpha:1.0];
    [[self view] addSubview:[self blurView]];

    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [[self blurView] setAlpha:0.0];
    } completion:nil];

}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    [self setEnabledState];

}

- (NSArray *)specifiers {

	if (_specifiers == nil) _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];

	return _specifiers;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    tableView.tableHeaderView = [self headerView];

    return [super tableView:tableView cellForRowAtIndexPath:indexPath];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGFloat offsetY = scrollView.contentOffset.y;

    if (offsetY > 200)
        [UIView animateWithDuration:0.2 animations:^{
            [[self iconView] setAlpha:1.0];
            [[self titleLabel] setAlpha:0.0];
        }];
    else
        [UIView animateWithDuration:0.2 animations:^{
            [[self iconView] setAlpha:0.0];
            [[self titleLabel] setAlpha:1.0];
        }];

}

- (void)setEnabled {
        
    if ([[[self preferences] objectForKey:@"Enabled"] isEqual:@(YES)])
        [[self preferences] setBool:NO forKey:@"Enabled"];
    else
        [[self preferences] setBool:YES forKey:@"Enabled"];

    [self respring];

}

- (void)setEnabledState {

    if ([[[self preferences] objectForKey:@"Enabled"] isEqual:@(YES)])
        [[self enableSwitch] setOn:YES animated:YES];
    else
        [[self enableSwitch] setOn:NO animated:YES];

}

- (void)blacklistApps {

    SparkAppListTableViewController* blacklistController = [[SparkAppListTableViewController alloc] initWithIdentifier:@"love.litten.copypasta.blacklistpreferences" andKey:@"blacklistedApps"];

    [[self navigationController] pushViewController:blacklistController animated:YES];
    [[self navigationItem] setHidesBackButton:NO];

}

- (void)resetPrompt {

    UIAlertController* resetAlert = [UIAlertController alertControllerWithTitle:@"Copypasta" message:@"Do you really want to reset your preferences?" preferredStyle:UIAlertControllerStyleActionSheet];
	
    UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:@"Yaw" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        [self resetPreferences];
	}];

	UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Naw" style:UIAlertActionStyleCancel handler:nil];

	[resetAlert addAction:confirmAction];
	[resetAlert addAction:cancelAction];

	[self presentViewController:resetAlert animated:YES completion:nil];

}

- (void)resetPreferences {

    [[self preferences] removeAllObjects];
    
    [[self enableSwitch] setOn:NO animated:YES];
    [self respring];

}

- (void)resetClipboardPrompt {

    UIAlertController* resetAlert = [UIAlertController alertControllerWithTitle:@"Copypasta" message:@"This will reset your clipboard" preferredStyle:UIAlertControllerStyleActionSheet];
	
    UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:@"Okey" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        [self resetClipboard];
	}];

	UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

	[resetAlert addAction:confirmAction];
	[resetAlert addAction:cancelAction];

	[self presentViewController:resetAlert animated:YES completion:nil];

}

- (void)resetClipboard {

    HBPreferences* preferences = [[HBPreferences alloc] initWithIdentifier: @"love.litten.copypasta-items"];
    [preferences removeAllObjects];

    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)@"love.litten.copypasta/ReloadItems", nil, nil, YES);

}

- (void)respring {

    [[self blurView] setFrame:[[self view] bounds]];
    [[self blurView] setAlpha:0.0];
    [[self view] addSubview:[self blurView]];

    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [[self blurView] setAlpha:1.0];
    } completion:^(BOOL finished) {
        if (![[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/shuffle.dylib"])
            [HBRespringController respringAndReturnTo:[NSURL URLWithString:@"prefs:root=Copypasta"]];
        else
            [HBRespringController respringAndReturnTo:[NSURL URLWithString:@"prefs:root=Tweaks&path=Copypasta"]];
    }];

}

@end