#!/system/bin/sh

packet_log_prop=`getprop persist.service.packet.enable`

touch /data/logger/packet.pcap
chmod 0644 /data/logger/packet.pcap

optionC="-C20"

storage_full_prop=`getprop persist.service.logger.full`
storage_low_prop=`getprop persist.service.logger.low`

if [ "$radio_log_prop" = "3"]; then
	if [ "$storage_full_prop" = "1" ]; then
	    exit 0
	fi
	if [ "$storage_low_prop" = "1" ]; then
	    optionC="-C2"
	fi
fi

if test "1" -eq "$packet_log_prop"
then
# 2013-08-08 hobbes.song@lge.com LGP_DATA_TOOL_TCPDUMP  @ver2[START]
build_type=`getprop ro.build.type`
case "$build_type" in
        "user")
            /system/xbin/tcd -i any $optionC -W 10 -Z root -s 0 -w /data/logger/packet.pcap
        ;;
esac
case "$build_type" in
        "eng" | "userdebug")
            /system/xbin/tcpdump -i any $optionC -W 10 -Z root -s 0 -w /data/logger/packet.pcap
        ;;
esac
# 2013-08-08 hobbes.song@lge.com LGP_DATA_TOOL_TCPDUMP  @ver2[END]
fi