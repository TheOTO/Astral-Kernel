#!/system/bin/sh

################################################################################
# helper functions to allow Android init like script

function write() {
    echo -n $2 > $1
}

function copy() {
    cat $1 > $2
}

function get-set-forall() {
    for f in $1 ; do
        cat $f
        write $f $2
    done
}

################################################################################

{

sleep 20

get-set-forall /sys/block/mmcblk*/queue/iosched/async_expire 2500
get-set-forall /sys/block/mmcblk*/queue/iosched/fifo_batch 8
get-set-forall /sys/block/mmcblk*/queue/iosched/sync_expire 300
get-set-forall /sys/block/loop*/queue/add_random 0
get-set-forall /sys/block/loop*/queue/rq_affinity 2
get-set-forall /sys/block/loop*/queue/nomerges 1
get-set-forall /sys/block/mmcblk*/queue/add_random 0
get-set-forall /sys/block/mmcblk*/queue/rq_affinity 2
get-set-forall /sys/block/mmcblk*/queue/nomerges 1
get-set-forall /sys/block/ram*/queue/add_random 0
get-set-forall /sys/block/ram*/queue/rq_affinity 2
get-set-forall /sys/block/ram*/queue/nomerges 1

chmod 0664 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
chmod 0664 /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq
chmod 0664 /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
chmod 0664 /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq
chmod 0664 /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
chmod 0664 /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor

write /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor ironactive
write /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor ironactive

write /sys/devices/system/cpu/cpu0/online 1
write /sys/devices/system/cpu/cpu1/online 1
write /sys/devices/system/cpu/cpu2/online 1
write /sys/devices/system/cpu/cpu3/online 1
write /sys/devices/system/cpu/cpu4/online 1
write /sys/devices/system/cpu/cpu5/online 1
write /sys/devices/system/cpu/cpu6/online 1
write /sys/devices/system/cpu/cpu7/online 1

write /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 960000
write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 200000
write /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq 960000
write /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq 200000
write /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq 960000
write /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq 200000
write /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq 960000
write /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq 200000
write /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq 800000
write /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq 200000
write /sys/devices/system/cpu/cpu5/cpufreq/scaling_max_freq 800000
write /sys/devices/system/cpu/cpu5/cpufreq/scaling_min_freq 200000
write /sys/devices/system/cpu/cpu6/cpufreq/scaling_max_freq 800000
write /sys/devices/system/cpu/cpu6/cpufreq/scaling_min_freq 200000
write /sys/devices/system/cpu/cpu7/cpufreq/scaling_max_freq 800000
write /sys/devices/system/cpu/cpu7/cpufreq/scaling_min_freq 200000

write /sys/module/msm_performance/parameters/touchboost 0
write /sys/module/cpu_boost/parameters/input_boost_freq "0:0 1:0 2:0 3:0 4:400000 5:400000 6:400000 7:400000"
write /sys/module/cpu_boost/parameters/boost_ms 0
write /sys/module/cpu_boost/parameters/input_boost_ms 50
write /sys/module/cpu_boost/parameters/sync_threshold 400000
write /sys/module/cpu_boost/parameters/wakeup_boost Y
write /sys/module/cpu_boost/parameters/hotplug_boost Y

for i in /sys/class/net/*; do
    echo 100 > $i/tx_queue_len;
done;

}&
