//
//  ViewController.m
//  CowaBLE
//
//  Created by MX on 16/9/14.
//  Copyright © 2016年 mx. All rights reserved.
//

#import "ViewController.h"
#import "CowaBLELib.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *TFCommand;
@property (weak, nonatomic) IBOutlet UITextView *TVContent;
@property (weak, nonatomic) IBOutlet UITextView *TVDevice;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *BtnCommands;
@property (weak, nonatomic) IBOutlet UITextField *TFOpenDistance;
@property (weak, nonatomic) IBOutlet UITextField *TFCloseDistance;

@property (weak, nonatomic) IBOutlet UILabel *labelStatus;
@property (weak, nonatomic) IBOutlet UIButton *btnSensor;

@property (nonatomic, strong) CowaBLEDevice *currentDevice;

@property (nonatomic, strong) UITableView *tableView;

//@property (nonatomic, strong) NSMutableArray<CowaBLEDevice *>*devices;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eStatusChanged) name:kBLENotiStatusUpdate object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eNotiDistance) name:kCowaBLENotiDistanceFaraway object:nil];
    
    UIButton *btn = [[UIButton alloc] init];
    btn.backgroundColor = [UIColor greenColor];
    btn.frame = CGRectMake(100, 400, 100, 100);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(eNotiBattery) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)eNotiBattery {
}

- (void)eNotiDistance {
}

- (IBAction)eBtnSensor:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.currentDevice.distanceSwith = sender.isSelected;
    self.currentDevice.distanceSensor = YES;
    self.currentDevice.distanceAlarm = YES;
    self.currentDevice.batteryLowAlarm = YES;
    sender.backgroundColor = sender.isSelected ? [UIColor greenColor] : [UIColor redColor];
}

- (void)eStatusChanged {
    self.labelStatus.text = [NSString stringWithFormat:@"电池:%lu锁M:%@锁F:%@信号:%@,距离:%.2f",self.currentDevice.status.battery, self.currentDevice.status.mLock ? @"开" : @"关", self.currentDevice.status.fLock ? @"开" : @"关",self.currentDevice.distanceTool.RSSI,self.currentDevice.distanceTool.distance];
    NSMutableString *content = [[NSMutableString alloc] initWithString:self.TVContent.text];
    [content appendString:self.currentDevice.status.resContent];
    [content appendString:@"\r\n"];
    self.TVContent.text = content;
}

- (IBAction)searchDevices:(UIButton *)sender {
    [[TBluetooth shareBluetooth] startScan];
//    [TBluetooth shareBluetooth].devicesChangedHandler = ^(NSDictionary *devs) {
//        if (devs.count > 0) {
//            _currentDevice = [[CowaBLEDevice alloc] initWithDevice:devs.allValues.firstObject];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                if (_currentDevice.device.macAddress) {
//                    _currentDevice.device.selected = YES;
//                }
//            });
//        }
//    };
}

//- (void)updateDevices:(NSArray<CowaBLEDevice *>*)devices {
//    if (devices) {
//        [self.devices removeAllObjects];
//        [self.devices addObjectsFromArray:devices];
//    }
//    [self.tableView reloadData];
//    self.tableView.hidden = false;
//}
//
- (void)refreshDeviceStatus {
    NSMutableString *statusStr = [[NSMutableString alloc] initWithCapacity:0];
    [statusStr appendFormat:@"isConnect:%@\r\n", self.currentDevice.device.isConnect ? @"YES" : @"NO" ];
    [statusStr appendFormat:@"isReady?:%@\r\n", self.currentDevice.device.isReady ? @"YES" : @"NO"];
    [statusStr appendFormat:@"信号强度:%@ \t测算距离:%.4f", self.currentDevice.device.RSSI, self.currentDevice.distanceTool.distance];
    self.TVDevice.text = statusStr;
}
//
- (IBAction)sendCommand:(UIButton *)sender {
    NSMutableString *command = [[NSMutableString alloc] initWithString:self.TFCommand.text];
    [command appendString:@"\r\n"];
    [_currentDevice.device sendACommand:command];
}
//
- (IBAction)selectCommand:(UIButton *)sender {
    self.TFCommand.text = [NSString stringWithFormat:@"AC+%@",sender.titleLabel.text];
}
//
//#pragma mark - UITableViewDelegate, UITableViewDataSource
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.devices.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//    }
//    cell.textLabel.text = self.devices[indexPath.row].macAddress;
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    TBLEManager *manager = [TBLEManager sharedManager];
//    CowaBLEDevice *dev = self.devices[indexPath.row];
//    [manager connect:dev completion:^(BOOL connect) {
//        NSLog(@"%@", @"连接成功，执行操作");
//        if (connect) {
//            self.currentDevice = dev;
//            self.tableView.hidden = YES;
//            self.TFOpenDistance.text = [NSString stringWithFormat:@"%.2f m", self.currentDevice.lockSwitchDistance];
//            self.TFCloseDistance.text = [NSString stringWithFormat:@"%.2f m", self.currentDevice.lockAlarmDistance];
//        }
//    }];
//}
//
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.TFOpenDistance]) {
        self.currentDevice.distanceTool.closerDistanceTrigger = [textField.text doubleValue];
    }
    if ([textField isEqual:self.TFCloseDistance]) {
        self.currentDevice.distanceTool.farDistanceTrigger = [textField.text doubleValue];
    }
    [textField resignFirstResponder];
    return YES;
}
//
//#pragma mark - getter
//- (UITableView *)tableView {
//    if (!_tableView) {
//        CGSize size = [[UIScreen mainScreen] bounds].size;
//        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, size.width, size.height - 150) style:UITableViewStylePlain];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//        _tableView.hidden = YES;
//    }
//    return _tableView;
//}

//- (NSMutableArray<CowaBLEDevice *>*)devices {
//    if (!_devices) {
//        _devices = [[NSMutableArray alloc] init];
//    }
//    return _devices;
//}

@end
