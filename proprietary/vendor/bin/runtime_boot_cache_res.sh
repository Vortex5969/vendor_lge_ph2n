#!/system/bin/sh

OPERATOR=`getprop ro.build.target_operator`
COUNTRY=`getprop ro.build.target_country`
BUILD_TYPE=`getprop ro.build.type`
DCOUNTRY=`getprop ro.build.default_country`
UI_BASE_CA=`getprop ro.build.ui_base_ca`
MCC=`getprop ro.lge.ntcode_mcc`
LGBOOTANIM=`getprop ro.lge.firstboot.openani`
IS_MULTISIM=`getprop ro.lge.sim_num`
SBP_VERSION=`getprop ro.build.sbp.version`

if [ $SBP_VERSION -ge 40 ]; then
    CUPSS_DEFAULT_PATH=/OP
    RES_PATH=_SMARTCA_RES
else
    CUPSS_DEFAULT_PATH=/cust
    RES_PATH=_COTA_RES
fi

SYSTEM_BOOTANIMATION_FILE=/system/media/bootanimation.zip
SYSTEM_BOOTANIMATION_SOUND_FILE=/system/media/audio/ui/PowerOn.ogg
CACHE_BOOTANIMATION_FILE=/persist-lg/poweron/bootanimation.zip
CACHE_BOOTANIMATION_SOUND_FILE=/persist-lg/poweron/PowerOn.ogg
COTA_BOOTANIMATION_FILE=${CUPSS_DEFAULT_PATH}/${RES_PATH}/bootanimation.zip
COTA_BOOTANIMATION_SOUND_FILE=${CUPSS_DEFAULT_PATH}/${RES_PATH}/PowerOn.ogg

if [ -d /OP ]; then
    ANI_ROOT_PATH=OP
else
    ANI_ROOT_PATH=cust
fi

if [ "${DCOUNTRY}" != "" ]; then
    if [ "${UI_BASE_CA}" != "" ]; then
        SUBCA_FILE=${UI_BASE_CA}/${DCOUNTRY}
    else
        if [ $IS_MULTISIM == "2" ]; then
            SUBCA_FILE=${OPERATOR}_${COUNTRY}_DS/${DCOUNTRY}
            if [ ! -d ${CUPSS_DEFAULT_PATH}/${SUBCA_FILE} ]; then
                SUBCA_FILE=${OPERATOR}_${COUNTRY}/${DCOUNTRY}
            fi
        elif [ $IS_MULTISIM == "3" ]; then
            SUBCA_FILE=${OPERATOR}_${COUNTRY}_TS/${DCOUNTRY}
            if [ ! -d ${CUPSS_DEFAULT_PATH}/${SUBCA_FILE} ]; then
                SUBCA_FILE=${OPERATOR}_${COUNTRY}/${DCOUNTRY}
            fi
        else
            SUBCA_FILE=${OPERATOR}_${COUNTRY}/${DCOUNTRY}
            if [ ! -d ${CUPSS_DEFAULT_PATH}/${SUBCA_FILE} ]; then
                if [ -d ${CUPSS_DEFAULT_PATH}/${OPERATOR}_${COUNTRY}_DS/${DCOUNTRY} ]; then
                    SUBCA_FILE=${OPERATOR}_${COUNTRY}_DS/${DCOUNTRY}
                fi
            fi
        fi
    fi
else
    if [ "${UI_BASE_CA}" != "" ]; then
        SUBCA_FILE=${UI_BASE_CA}
    else
        if [ $IS_MULTISIM == "2" ]; then
            SUBCA_FILE=${OPERATOR}_${COUNTRY}_DS
            if [ ! -d ${CUPSS_DEFAULT_PATH}/${SUBCA_FILE} ]; then
                SUBCA_FILE=${OPERATOR}_${COUNTRY}
            fi
        elif [ $IS_MULTISIM == "3" ]; then
            SUBCA_FILE=${OPERATOR}_${COUNTRY}_TS
            if [ ! -d ${CUPSS_DEFAULT_PATH}/${SUBCA_FILE} ]; then
                SUBCA_FILE=${OPERATOR}_${COUNTRY}
            fi
        else
            SUBCA_FILE=${OPERATOR}_${COUNTRY}
            if [ ! -d ${CUPSS_DEFAULT_PATH}/${SUBCA_FILE} ]; then
                if [ -d ${CUPSS_DEFAULT_PATH}/${OPERATOR}_${COUNTRY}_DS ]; then
                    SUBCA_FILE=${OPERATOR}_${COUNTRY}_DS
                fi
            fi
        fi
    fi
fi

#/system/bin/mkdir /persist-lg/poweron 0771 system system
#/system/bin/chown -R system:sytem /persist-lg/poweron
#/system/bin/chmod -R 0775 /persist-lg/poweron

if [ $(ls /${ANI_ROOT_PATH}/${SUBCA_FILE}/poweron/bootanimation_${MCC}.zip | grep bootanimation_${MCC}.zip) ]; then
    if [ $LGBOOTANIM != "" ] && [ $LGBOOTANIM == "true" ]; then
        DOWNCA_BOOTANIMATION_FILE=/${ANI_ROOT_PATH}/${SUBCA_FILE}/poweron/bootanimation_${MCC}.zip
    else
        DOWNCA_BOOTANIMATION_FILE=/${ANI_ROOT_PATH}/${SUBCA_FILE}/poweron/bootanimation_${MCC}.zip
    fi
else
    DOWNCA_BOOTANIMATION_FILE=/${ANI_ROOT_PATH}/${SUBCA_FILE}/poweron/bootanimation.zip
fi

if [ $(ls /${ANI_ROOT_PATH}/${SUBCA_FILE}/poweron/PowerOn_${MCC}.ogg | grep PowerOn_${MCC}.ogg) ]; then
    if [ $LGBOOTANIM != "" ] && [ $LGBOOTANIM == "true" ]; then
        DOWNCA_BOOTANIMATION_SOUND_FILE=/${ANI_ROOT_PATH}/${SUBCA_FILE}/poweron/PowerOn_${MCC}.ogg
    else
        DOWNCA_BOOTANIMATION_SOUND_FILE=/${ANI_ROOT_PATH}/${SUBCA_FILE}/poweron/PowerOn_${MCC}.ogg
    fi

else
    DOWNCA_BOOTANIMATION_SOUND_FILE=/${ANI_ROOT_PATH}/${SUBCA_FILE}/poweron/PowerOn.ogg
fi

if [ $OPERATOR != "GLOBAL" ]; then
    if [ -f $COTA_BOOTANIMATION_FILE ]; then
        ln -sf $COTA_BOOTANIMATION_FILE $CACHE_BOOTANIMATION_FILE
    elif [ -f $DOWNCA_BOOTANIMATION_FILE ]; then
        if [ $(ls /${ANI_ROOT_PATH}/${SUBCA_FILE}/poweron/nobootani_${MCC}.open) ]; then
            ln -sf $SYSTEM_BOOTANIMATION_FILE $CACHE_BOOTANIMATION_FILE
        else
            ln -sf $DOWNCA_BOOTANIMATION_FILE $CACHE_BOOTANIMATION_FILE
        fi
    else
        rm $CACHE_BOOTANIMATION_FILE
    fi

    if [ -f $COTA_BOOTANIMATION_SOUND_FILE ]; then
        ln -sf $COTA_BOOTANIMATION_SOUND_FILE $CACHE_BOOTANIMATION_SOUND_FILE
    elif [ -f $DOWNCA_BOOTANIMATION_SOUND_FILE ]; then
        if [ $(ls /${ANI_ROOT_PATH}/${SUBCA_FILE}/poweron/nobootani_sound_${MCC}.open) ]; then
            ln -sf $SYSTEM_BOOTANIMATION_SOUND_FILE $CACHE_BOOTANIMATION_SOUND_FILE
        else
            ln -sf $DOWNCA_BOOTANIMATION_SOUND_FILE $CACHE_BOOTANIMATION_SOUND_FILE
        fi
    else
        rm $CACHE_BOOTANIMATION_SOUND_FILE
    fi
else
    rm $CACHE_BOOTANIMATION_FILE
    rm $CACHE_BOOTANIMATION_SOUND_FILE
fi
exit 0
