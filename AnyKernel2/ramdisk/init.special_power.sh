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

write sys/module/governor_msm_adreno_tz/parameters/adrenoboost 1

write /sys/devices/system/cpu/cpu0/online 1
write /sys/devices/system/cpu/cpu1/online 1
write /sys/devices/system/cpu/cpu2/online 1
write /sys/devices/system/cpu/cpu3/online 1
write /sys/devices/system/cpu/cpu4/online 1
write /sys/devices/system/cpu/cpu5/online 1
write /sys/devices/system/cpu/cpu6/online 1
write /sys/devices/system/cpu/cpu7/online 1

write /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor impulse
write /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor impulse

write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 200000
write /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq 200000
write /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq 200000
write /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq 200000
write /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq 400000
write /sys/devices/system/cpu/cpu5/cpufreq/scaling_min_freq 400000
write /sys/devices/system/cpu/cpu6/cpufreq/scaling_min_freq 400000
write /sys/devices/system/cpu/cpu7/cpufreq/scaling_min_freq 400000

write /sys/devices/system/cpu/cpu0/cpufreq/impulse/above_hispeed_delay 0
write /sys/devices/system/cpu/cpu0/cpufreq/impulse/go_hispeed_load 90
write /sys/devices/system/cpu/cpu0/cpufreq/impulse/max_freq_hysteresis 80000
write /sys/devices/system/cpu/cpu0/cpufreq/impulse/min_sample_time 40000
write /sys/devices/system/cpu/cpu0/cpufreq/target_loads "80 345600:33 400000:25 533330:50 800000:65 960000:70 1113600:85 134400:90 1459200:92 1497600:98"
write /sys/devices/system/cpu/cpu0/cpufreq/impulse/timer_rate 20000
write /sys/devices/system/cpu/cpu0/cpufreq/impulse/timer_slack -1

write /sys/devices/system/cpu/cpu4/cpufreq/impulse/above_hispeed_delay 0
write /sys/devices/system/cpu/cpu4/cpufreq/impulse/go_hispeed_load 95
write /sys/devices/system/cpu/cpu4/cpufreq/impulse/max_freq_hysteresis 80000
write /sys/devices/system/cpu/cpu4/cpufreq/impulse/min_sample_time 30000
write /sys/devices/system/cpu/cpu4/cpufreq/impulse/target_loads "80 249600:25 40000:50 499200:65 800000:70 998400:85 1113600:90 1209600:98"
write /sys/devices/system/cpu/cpu4/cpufreq/impulse/timer_rate 30000
write /sys/devices/system/cpu/cpu4/cpufreq/impulse/timer_slack -1

write /proc/sys/kernel/sched_rt_period_us 1000000
write /proc/sys/kernel/sched_rt_runtime_us 800000
write /proc/sys/kernel/sched_wake_to_idle 0
write /dev/cpuctl/cpu.rt_period_us 1000000
write /dev/cpuctl/cpu.rt_runtime_us 800000

write /sys/module/msm_performance/parameters/touchboost 0
write /sys/module/cpu_boost/parameters/input_boost_freq "0:400000 1:400000 2:400000 3:400000 4:800000 5:800000 6:800000 7:800000"
write /sys/module/cpu_boost/parameters/boost_ms 0
write /sys/module/cpu_boost/parameters/input_boost_ms 1500
write /sys/module/cpu_boost/parameters/sync_threshold 400000
write /sys/module/cpu_boost/parameters/wakeup_boost Y
write /sys/module/cpu_boost/parameters/hotplug_boost Y

for i in /sys/class/net/*; do
    echo 100 > $i/tx_queue_len;
done;

}&
