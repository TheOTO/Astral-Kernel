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

sleep 10

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

write /sys/module/governor_msm_adreno_tz/parameters/adrenoboost 1
write /sys/module/simple_gpu_algorithm/parameters/simple_gpu_activate 1
write /sys/module/simple_gpu_algorithm/parameters/simple_laziness 4
write /sys/module/simple_gpu_algorithm/parameters/simple_ramp_threshold 6000

write /sys/devices/system/cpu/cpu0/online 1
write /sys/devices/system/cpu/cpu4/online 1

write /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor ironactive
write /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor ironactive

write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 200000
write /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq 200000
write /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq 200000
write /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq 200000
write /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq 200000
write /sys/devices/system/cpu/cpu5/cpufreq/scaling_min_freq 200000
write /sys/devices/system/cpu/cpu6/cpufreq/scaling_min_freq 200000
write /sys/devices/system/cpu/cpu7/cpufreq/scaling_min_freq 200000

write /proc/sys/kernel/sched_rt_period_us 1000000
write /proc/sys/kernel/sched_rt_runtime_us 800000
write /proc/sys/kernel/sched_wake_to_idle 0
write /dev/cpuctl/cpu.rt_period_us 1000000
write /dev/cpuctl/cpu.rt_runtime_us 800000

write /sys/module/msm_performance/parameters/touchboost 0
write /sys/module/cpu_boost/parameters/input_boost_freq "0:345600 1:345600 2:345600 3:345600 4:400000 5:400000 6:400000 7:400000"
write /sys/module/cpu_boost/parameters/boost_ms 0
write /sys/module/cpu_boost/parameters/input_boost_ms 150
write /sys/module/cpu_boost/parameters/sync_threshold 345600
write /sys/module/cpu_boost/parameters/wakeup_boost Y
write /sys/module/cpu_boost/parameters/hotplug_boost Y

for i in /sys/class/net/*; do
    echo 100 > $i/tx_queue_len;
done;

}&
