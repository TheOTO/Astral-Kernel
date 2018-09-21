# AnyKernel2 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=by TheOTO @ xda-developers
do.devicecheck=1
do.modules=1
do.cleanup=1
do.cleanuponabort=0
device.name1=kiwi
'; } # end properties

# shell variables
block=/dev/block/platform/soc.0/7824900.sdhci/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. /tmp/anykernel/tools/ak2-core.sh;


## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
chmod 750 $ramdisk/init.ak.rc;
chmod 755 $ramdisk/init.astral.sh
chmod +x $ramdisk/init.astral.sh
chmod 755 $ramdisk/init.supolicy.sh
chmod +x $ramdisk/init.supolicy.sh
chown -R root:root $ramdisk/*;
chmod +x $ramdisk/sbin/spa


## AnyKernel install
dump_boot;

# begin ramdisk changes

# backup all original files before applying changes
backup_file init.rc
backup_file init.qcom.rc
backup_file init.qcom.power.rc
backup_file fstab.qcom

# init.qcom.rc
insert_line init.qcom.rc "init.ak.rc" after "import init.target.rc" "import init.ak.rc";

# init.rc
insert_line init.rc "import /init.spectrum.rc" after "import /init.cm.rc" "import /init.spectrum.rc";
replace_line init.rc "    mount cgroup none /dev/cpuctl cpu" "    mount cgroup none /dev/cpuctl cpu,timer_slack";
replace_line init.rc "    write /proc/sys/kernel/sched_rt_runtime_us 950000" "    write /proc/sys/kernel/sched_rt_runtime_us 800000";
replace_line init.rc "    write /dev/cpuctl/cpu.rt_runtime_us 950000" "    write /dev/cpuctl/cpu.rt_runtime_us 800000";
replace_line init.rc "    write /proc/sys/vm/dirty_expire_centisecs 200" "    write /proc/sys/vm/dirty_expire_centisecs 300";
replace_line init.rc "    write /proc/sys/vm/dirty_background_ratio  5" "    write /proc/sys/vm/dirty_background_ratio  20";
insert_line init.rc "    chown system system /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq" after "    chown system system /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq" "    chown system system /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq";
insert_line init.rc "    chmod 0660 /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq" after "    chmod 0660 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq" "    chmod 0660 /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq";

# init.qcom.power.rc
replace_line init.qcom.power.rc "    setprop sys.io.scheduler cfq" "    setprop sys.io.scheduler zen";
insert_line init.qcom.power.rc "    write /sys/module/lowmemorykiller/parameters/lmk_fast_run 1" after "    write /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk 0" "    write /sys/module/lowmemorykiller/parameters/lmk_fast_run 1";
insert_line init.qcom.power.rc "    write /sys/module/lowmemorykiller/parameters/cost 32" after "    write /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk 0" "    write /sys/module/lowmemorykiller/parameters/cost 32";
insert_line init.qcom.power.rc "    write /proc/sys/kernel/sched_wake_to_idle 0" after "    write /proc/sys/kernel/sched_mostly_idle_nr_run 3" "    write /proc/sys/kernel/sched_wake_to_idle 0";
replace_line init.qcom.power.rc "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load 99" "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load 95";
replace_line init.qcom.power.rc "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate 20000" "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate 10000";
replace_line init.qcom.power.rc "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/hispeed_freq 800000" "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/hispeed_freq 400000";
replace_line init.qcom.power.rc "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time 50000" "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time 60000";
insert_line init.qcom.power.rc "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_slack -1" after "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/io_is_busy 0" "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_slack -1";
insert_line init.qcom.power.rc "    write /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 960000" before "    write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 200000" "    write /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 960000";
replace_line init.qcom.power.rc "    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/hispeed_freq 998400" "    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/hispeed_freq 800000";
insert_line init.qcom.power.rc "    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_slack -1" after "    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/io_is_busy 0" "    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_slack -1";
insert_line init.qcom.power.rc "    write /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq 800000" after "    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/min_sample_time 40000" "    write /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq 800000";
replace_line init.qcom.power.rc "    write /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq 800000" "    write /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq 200000";
remove_line init.qcom.power.rc "    # Enable cluster plug now and allow the powerhal to control it";
remove_line init.qcom.power.rc "    chown system system /sys/module/cluster_plug/parameters/low_power_mode";
remove_line init.qcom.power.rc "    write /sys/module/cluster_plug/parameters/active 1";
replace_line init.qcom.power.rc '    write /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor "powersave"' '    write /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor "ondemand"';

# fstab.qcom
replace_line fstab.qcom "#/dev/block/zram0                        none               swap     defaults                                                     zramsize=536870912,zramstreams=3" "/dev/block/zram0                        none               swap     defaults                                                     zramsize=335544320,zramstreams=3";

$bin/sepolicy-inject -s init -t rootfs -c file -p execute_no_trans -P sepolicy;

# end ramdisk changes

write_boot;

## end install

# Add empty profile locations
if [ ! -d /data/media/Spectrum ]; then
  ui_print " "; ui_print "Creating /data/media/0/Spectrum...";
  mkdir /data/media/0/Spectrum;
fi
if [ ! -d /data/media/Spectrum/profiles ]; then
  mkdir /data/media/0/Spectrum/profiles;
fi
if [ ! -d /data/media/Spectrum/profiles/*.profile ]; then
  ui_print " "; ui_print "Creating empty profile files...";
  touch /data/media/0/Spectrum/profiles/balance.profile;
  touch /data/media/0/Spectrum/profiles/performance.profile;
  touch /data/media/0/Spectrum/profiles/battery.profile;
  touch /data/media/0/Spectrum/profiles/gaming.profile;
fi
