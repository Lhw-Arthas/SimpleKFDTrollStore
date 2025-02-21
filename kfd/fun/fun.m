//
//  fun.c
//  kfd
//
//  Created by Seo Hyun-gyu on 2023/07/25.
//

#include "krw.h"
#include "offsets.h"
#include <sys/stat.h>
#import <UIKit/UIKit.h>
#import <sys/mount.h>
#include <sys/stat.h>
#include <sys/attr.h>
#include <sys/snapshot.h>
#include <sys/mman.h>
#include <mach/mach.h>
#include "proc.h"
#include "vnode.h"
#include "grant_full_disk_access.h"
#include "thanks_opa334dev_htrowii.h"
#include "utils.h"
#include "helpers.h"
#import "common.h"

int funUcred(u64 proc) {
    u64 proc_ro = kread64(proc + off_p_proc_ro);
    u64 ucreds = kread64(proc_ro + off_p_ro_p_ucred);
    
    u64 cr_label_pac = kread64(ucreds + off_u_cr_label);
    u64 cr_label = cr_label_pac | 0xffffff8000000000;
    print_message("[i] self ucred->cr_label: 0x%llx\n", cr_label);
//
//    print_message("[i] self ucred->cr_label+0x8+0x0: 0x%llx\n", kread64(kread64(cr_label+0x8)));
//    print_message("[i] self ucred->cr_label+0x8+0x0+0x0: 0x%llx\n", kread64(kread64(kread64(cr_label+0x8))));
//    print_message("[i] self ucred->cr_label+0x10: 0x%llx\n", kread64(cr_label+0x10));
//    u64 OSEntitlements = kread64(cr_label+0x10);
//    print_message("OSEntitlements: 0x%llx\n", OSEntitlements);
//    u64 CEQueryContext = OSEntitlements + 0x28;
//    u64 der_start = kread64(CEQueryContext + 0x20);
//    u64 der_end = kread64(CEQueryContext + 0x28);
//    for(int i = 0; i < 100; i++) {
//        print_message("OSEntitlements+0x%x: 0x%llx\n", i*8, kread64(OSEntitlements + i * 8));
//    }
//    kwrite64(kread64(OSEntitlements), 0);
//    kwrite64(kread64(OSEntitlements + 8), 0);
//    kwrite64(kread64(OSEntitlements + 0x10), 0);
//    kwrite64(kread64(OSEntitlements + 0x20), 0);
    
    u64 cr_posix_p = ucreds + off_u_cr_posix;
    print_message("[i] self ucred->posix_cred->cr_uid: %u\n", kread32(cr_posix_p + off_cr_uid));
    print_message("[i] self ucred->posix_cred->cr_ruid: %u\n", kread32(cr_posix_p + off_cr_ruid));
    print_message("[i] self ucred->posix_cred->cr_svuid: %u\n", kread32(cr_posix_p + off_cr_svuid));
    print_message("[i] self ucred->posix_cred->cr_ngroups: %u\n", kread32(cr_posix_p + off_cr_ngroups));
    print_message("[i] self ucred->posix_cred->cr_groups: %u\n", kread32(cr_posix_p + off_cr_groups));
    print_message("[i] self ucred->posix_cred->cr_rgid: %u\n", kread32(cr_posix_p + off_cr_rgid));
    print_message("[i] self ucred->posix_cred->cr_svgid: %u\n", kread32(cr_posix_p + off_cr_svgid));
    print_message("[i] self ucred->posix_cred->cr_gmuid: %u\n", kread32(cr_posix_p + off_cr_gmuid));
    print_message("[i] self ucred->posix_cred->cr_flags: %u\n", kread32(cr_posix_p + off_cr_flags));

    return 0;
}

void backboard_respring(void) {
    xpc_crasher("com.apple.cfprefsd.daemon");
    xpc_crasher("com.apple.backboard.TouchDeliveryPolicyServer");
}

void respring(void) {
    xpc_crasher("com.apple.frontboard.systemappservices");
}

int funCSFlags(char* process) {
    u64 pid = getPidByName(process);
    u64 proc = getProc(pid);
    
    u64 proc_ro = kread64(proc + off_p_proc_ro);
    uint32_t csflags = kread32(proc_ro + off_p_ro_p_csflags);
    print_message("[i] %s proc->proc_ro->p_csflags: 0x%x\n", process, csflags);
    
#define TF_PLATFORM 0x400

#define CS_GET_TASK_ALLOW    0x0000004    /* has get-task-allow entitlement */
#define CS_INSTALLER        0x0000008    /* has installer entitlement */

#define    CS_HARD            0x0000100    /* don't load invalid pages */
#define    CS_KILL            0x0000200    /* kill process if it becomes invalid */
#define CS_RESTRICT        0x0000800    /* tell dyld to treat restricted */

#define CS_PLATFORM_BINARY    0x4000000    /* this is a platform binary */

#define CS_DEBUGGED         0x10000000  /* process is currently or has previously been debugged and allowed to run with invalid pages */
    
//    csflags = (csflags | CS_PLATFORM_BINARY | CS_INSTALLER | CS_GET_TASK_ALLOW | CS_DEBUGGED) & ~(CS_RESTRICT | CS_HARD | CS_KILL);
//    sleep(3);
//    kwrite32(proc_ro + off_p_ro_p_csflags, csflags);
    
    return 0;
}

int funTask(char* process) {
    u64 pid = getPidByName(process);
    u64 proc = getProc(pid);
    print_message("[i] %s proc: 0x%llx\n", process, proc);
    u64 proc_ro = kread64(proc + off_p_proc_ro);
    
    u64 pr_proc = kread64(proc_ro + off_p_ro_pr_proc);
    print_message("[i] %s proc->proc_ro->pr_proc: 0x%llx\n", process, pr_proc);
    
    u64 pr_task = kread64(proc_ro + off_p_ro_pr_task);
    print_message("[i] %s proc->proc_ro->pr_task: 0x%llx\n", process, pr_task);
    
    //proc_is64bit_data+0x18: LDR             W8, [X8,#0x3D0]
    uint32_t t_flags = kread32(pr_task + off_task_t_flags);
    print_message("[i] %s task->t_flags: 0x%x\n", process, t_flags);
    
    
    /*
     * RO-protected flags:
     */
    #define TFRO_PLATFORM                   0x00000400                      /* task is a platform binary */
    #define TFRO_FILTER_MSG                 0x00004000                      /* task calls into message filter callback before sending a message */
    #define TFRO_PAC_EXC_FATAL              0x00010000                      /* task is marked a corpse if a PAC exception occurs */
    #define TFRO_PAC_ENFORCE_USER_STATE     0x01000000                      /* Enforce user and kernel signed thread state */
    
    uint32_t t_flags_ro = kread64(proc_ro + off_p_ro_t_flags_ro);
    print_message("[i] %s proc->proc_ro->t_flags_ro: 0x%x\n", process, t_flags_ro);
    
    return 0;
}

u64 fun_ipc_entry_lookup(mach_port_name_t port_name) {
    u64 proc = getProc(getpid());
    u64 proc_ro = kread64(proc + off_p_proc_ro);
    
    u64 pr_proc = kread64(proc_ro + off_p_ro_pr_proc);
    print_message("[i] self proc->proc_ro->pr_proc: 0x%llx\n", pr_proc);
    
    u64 pr_task = kread64(proc_ro + off_p_ro_pr_task);
    print_message("[i] self proc->proc_ro->pr_task: 0x%llx\n", pr_task);
    
    u64 itk_space_pac = kread64(pr_task + 0x300);
    u64 itk_space = itk_space_pac | 0xffffff8000000000;
    print_message("[i] self task->itk_space: 0x%llx\n", itk_space);
    uint32_t port_index = MACH_PORT_INDEX(port_name);
    uint32_t table_size = kread32(itk_space + 0x14);
    print_message("[i] table_size: 0x%x, port_index: 0x%x\n", table_size, port_index);
    if (port_index >= table_size) {
        print_message("[-] invalid port name 0x%x\n", port_name);
    }

    //0x20 = IPC_SPACE_IS_TABLE_OFF
    u64 is_table = kread64_smr(itk_space + 0x20);
    print_message("[i] self task->itk_space->is_table: 0x%llx\n", is_table);

    u64 entry = is_table + port_index * 0x18/*SIZE(ipc_entry)*/;
    print_message("[i] entry: 0x%llx\n", entry);

    u64 object_pac = kread64(entry + 0x0/*OFFSET(ipc_entry, ie_object)*/);
    u64 object = object_pac | 0xffffff8000000000;
    uint32_t ip_bits = kread32(object + 0x0/*OFFSET(ipc_port, ip_bits)*/);
    uint32_t ip_refs = kread32(object + 0x4/*OFFSET(ipc_port, ip_references)*/);
    u64 kobject_pac = kread64(object + 0x48/*OFFSET(ipc_port, ip_kobject)*/);
    u64 kobject = kobject_pac | 0xffffff8000000000;
    print_message("[i] ipc_port: ip_bits 0x%x, ip_refs 0x%x\n", ip_bits, ip_refs);
    print_message("[i] ip_kobject: 0x%llx\n", kobject);

    return 0;
}

void DynamicKFD(int subtype) {
    DynamicCOW(subtype);
}

void supervised(bool is) {
    setSuperviseMode(is);
}

void funcInit() {
    NSLog(@"initialising offsets");
    _offsets_init();
    pid_t myPid = getpid();
    u64 selfProc = getProc(myPid);
    NSLog(@"[i] self proc: 0x%llx\n", selfProc);
    funUcred(selfProc);
}

uint64_t createFolderAndRedirect2(char* path){
    return createFolderAndRedirect1(path);
}

uint64_t UnRedirectAndRemoveFolder2(uint64_t orig_to_v_data) {
    return UnRedirectAndRemoveFolder1(orig_to_v_data);
}

uint64_t createFolderAndRedirect4(char* path){
    return createFolderAndRedirect3(path);
}

uint64_t overwriteFileVar(char* to, char* from) {
    return overwriteFileVarHelp(to, from);
}

uint64_t UnRedirectAndRemoveFolder4(uint64_t orig_to_v_data) {
    return UnRedirectAndRemoveFolder3(orig_to_v_data);
}

void do_fun(char** enabledTweaks, int numTweaks, int res_y, int res_x, int subtype) {
//    funVnodeOverwrite2("/System/Library/Fonts/CoreUI/SFUI.ttf", [NSString stringWithFormat:@"%@%@", NSBundle.mainBundle.bundlePath, @"/SFUI.ttf"].UTF8String);
//    funVnodeOverwrite2("/System/Library/Fonts/Watch/ADTTime.ttc", [NSString stringWithFormat:@"%@%@", NSBundle.mainBundle.bundlePath, @"/ADTTime.ttc"].UTF8String);
    print_message("initialising offsets");
    _offsets_init();
    
//    u64 kslide = get_kslide();
//    u64 kbase = 0xfffffff007004000 + kslide;
//    print_message("[i] Kernel base: 0x%llx\n", kbase);
//    print_message("[i] Kernel slide: 0x%llx\n", kslide);
//    u64 kheader64 = kread64(kbase);
//    print_message("[i] Kernel base kread64 ret: 0x%llx\n", kheader64);
//    
    pid_t myPid = getpid();
    u64 selfProc = getProc(myPid);
    print_message("[i] self proc: 0x%llx\n", selfProc);
    
    funUcred(selfProc);
//    funProc(selfProc);
    
//    CCTest();
//    removeSMSCache();
//    setSuperviseMode(true);
//    print_message("grant_full_disk_access.");
//    sleep(1);
//    grant_full_disk_access(^(NSError* error) {
//        NSLog(@"[-] grant_full_disk_access returned error: %@", error);
//    });
    
    for (int i = 0; i < numTweaks; i++) {
        char *tweak = enabledTweaks[i];
        if (strcmp(tweak, "HideDock") == 0) {
            funVnodeHide("/System/Library/PrivateFrameworks/CoreMaterial.framework/dockDark.materialrecipe");
            funVnodeHide("/System/Library/PrivateFrameworks/CoreMaterial.framework/dockLight.materialrecipe");
        }
        if (strcmp(tweak, "enableHideHomebar") == 0) {
            funVnodeHide("/System/Library/PrivateFrameworks/MaterialKit.framework/Assets.car");
        }
        if (strcmp(tweak, "enableResSet") == 0) {
            ResSet16(res_y, res_x);
        }
        if (strcmp(tweak, "enableCCTweaks") == 0) {
            funVnodeOverwrite2("/System/Library/ControlCenter/Bundles/DisplayModule.bundle/Brightness.ca/main.caml", [NSString stringWithFormat:@"%@%@", NSBundle.mainBundle.bundlePath, @"/mainbrightness.caml"].UTF8String);
            funVnodeOverwrite2("/System/Library/ControlCenter/Bundles/ConnectivityModule.bundle/Assets.car", [NSString stringWithFormat:@"%@%@", NSBundle.mainBundle.bundlePath, @"/PlampyWifi.car"].UTF8String);
            funVnodeOverwrite2("/System/Library/ControlCenter/Bundles/ConnectivityModule.bundle/Bluetooth.ca/main.caml", [NSString stringWithFormat:@"%@%@", NSBundle.mainBundle.bundlePath, @"/mainbluetooth.caml"].UTF8String);
            funVnodeOverwrite2("/System/Library/ControlCenter/Bundles/ConnectivityModule.bundle/WiFi.ca/main.caml", [NSString stringWithFormat:@"%@%@", NSBundle.mainBundle.bundlePath, @"/mainwifi.caml"].UTF8String);
            funVnodeOverwrite2("/System/Library/PrivateFrameworks/MediaControls.framework/Volume.ca/main.caml", [NSString stringWithFormat:@"%@%@", NSBundle.mainBundle.bundlePath, @"/mainvolume.caml"].UTF8String);
            funVnodeOverwrite2("/System/Library/PrivateFrameworks/FocusUI.framework/dnd_cg_02.ca/main.caml", [NSString stringWithFormat:@"%@%@", NSBundle.mainBundle.bundlePath, @"/focusmain.caml"].UTF8String);
            funVnodeOverwrite2("/System/Library/PrivateFrameworks/MediaControls.framework/ForwardBackward.ca/main.caml", [NSString stringWithFormat:@"%@%@", NSBundle.mainBundle.bundlePath, @"/mainforwardbackward.caml"].UTF8String);
            funVnodeOverwrite2("/System/Library/PrivateFrameworks/MediaControls.framework/PlayPauseStop.ca/main.caml", [NSString stringWithFormat:@"%@%@", NSBundle.mainBundle.bundlePath, @"/mainplaypausestop.caml"].UTF8String);
        }
        if (strcmp(tweak, "enableCustomFont") == 0) {
            NSString *fontsDir = [NSString stringWithFormat:@"%@%@", NSBundle.mainBundle.bundlePath, @"/Fonts"];
            NSFileManager *fileManager = [NSFileManager defaultManager];

            NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:fontsDir];

            NSString *file;
            while ((file = [dirEnum nextObject])) {
                if (![file hasPrefix:@"."]) { // 过滤掉隐藏文件
                    NSString *relativePath = [NSString stringWithFormat:@"/%@", file];
                    NSLog(@"Found file: %@", relativePath);
                }
            }
//            funVnodeOverwrite2("/System/Library/Fonts/CoreUI/SFUI.ttf", [NSString stringWithFormat:@"%@%@", NSBundle.mainBundle.bundlePath, @"/SFUI.ttf"].UTF8String);
//            funVnodeOverwrite2("/System/Library/Fonts/Watch/ADTTime.ttc", [NSString stringWithFormat:@"%@%@", NSBundle.mainBundle.bundlePath, @"/ADTTime.ttc"].UTF8String);
        }
        if (strcmp(tweak, "enableCustomSysColors") == 0) {
            funVnodeOverwrite2("/System/Library/PrivateFrameworks/CoreUI.framework/DesignLibrary-iOS.bundle/iOSRepositories/DarkIncreasedContrast.car", [NSString stringWithFormat:@"%@%@", NSBundle.mainBundle.bundlePath, @"/CoreUI/DarkIncreasedContrast.car"].UTF8String);
            funVnodeOverwrite2("/System/Library/PrivateFrameworks/CoreUI.framework/DesignLibrary-iOS.bundle/iOSRepositories/DarkStandard.car", [NSString stringWithFormat:@"%@%@", NSBundle.mainBundle.bundlePath, @"/CoreUI/DarkStandard.car"].UTF8String);
            funVnodeOverwrite2("/System/Library/PrivateFrameworks/CoreUI.framework/DesignLibrary-iOS.bundle/iOSRepositories/DarkVibrantStandard.car", [NSString stringWithFormat:@"%@%@", NSBundle.mainBundle.bundlePath, @"/CoreUI/DarkVibrantStandard.car"].UTF8String);
            funVnodeOverwrite2("/System/Library/PrivateFrameworks/CoreUI.framework/DesignLibrary-iOS.bundle/iOSRepositories/LightIncreasedContrast.car", [NSString stringWithFormat:@"%@%@", NSBundle.mainBundle.bundlePath, @"/CoreUI/LightIncreasedContrast.car"].UTF8String);
            funVnodeOverwrite2("/System/Library/PrivateFrameworks/CoreUI.framework/DesignLibrary-iOS.bundle/iOSRepositories/LightStandard.car", [NSString stringWithFormat:@"%@%@", NSBundle.mainBundle.bundlePath, @"/CoreUI/LightStandard.car"].UTF8String);
            funVnodeOverwrite2("/System/Library/PrivateFrameworks/CoreUI.framework/DesignLibrary-iOS.bundle/iOSRepositories/LightVibrantStandard.car", [NSString stringWithFormat:@"%@%@", NSBundle.mainBundle.bundlePath, @"/CoreUI/LightVibrantStandard.car"].UTF8String);
        }
        if (strcmp(tweak, "enableLSTweaks") == 0) {
            funVnodeOverwrite2("/System/Library/PrivateFrameworks/CoverSheet.framework/Assets.car", [NSString stringWithFormat:@"%@%@", NSBundle.mainBundle.bundlePath, @"/ios16.car"].UTF8String);
        }
        if (strcmp(tweak, "hideLSIcons") == 0) {
            funVnodeHide("/System/Library/PrivateFrameworks/CoverSheet.framework/Assets.car");
        }
        if (strcmp(tweak, "enableHideNotifs") == 0) {
            funVnodeHide("/System/Library/PrivateFrameworks/CoreMaterial.framework/platterStrokeLight.visualstyleset");
            funVnodeHide("/System/Library/PrivateFrameworks/CoreMaterial.framework/platterStrokeDark.visualstyleset");
            funVnodeHide("/System/Library/PrivateFrameworks/CoreMaterial.framework/plattersDark.materialrecipe");
            funVnodeHide("/System/Library/PrivateFrameworks/SpringBoardHome.framework/folderLight.materialrecipe");
            funVnodeHide("/System/Library/PrivateFrameworks/SpringBoardHome.framework/folderDark.materialrecipe");
            funVnodeHide("/System/Library/PrivateFrameworks/CoreMaterial.framework/platters.materialrecipe");
        }
        if (strcmp(tweak, "enableDynamicIsland") == 0) {
            DynamicCOW(subtype);
        }
        if (strcmp(tweak, "changeRegion") == 0) {
            regionChanger(@"h63QSdBCiT/z0WU6rdQv6Q", @"zHeENZu+wbg7PUprwNwBWg");
        }
        if (strcmp(tweak, "whitelist") == 0) {
            whitelist();
        }
        if (strcmp(tweak, "supervise") == 0) {
            setSuperviseMode(true);
        }
    }
}
