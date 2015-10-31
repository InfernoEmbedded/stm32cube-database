[#ftl]
[#if includes??]
[#list includes as include]
#include "${include}"
[/#list]
[/#if]

[#list IPdatas as IP]  
[#assign ipvar = IP]
[#list IP.configModelList as instanceData]
        [#assign instName = instanceData.instanceName]
        [#assign instMode= instanceData.halMode]
		[#assign ipName = instanceData.ipName]	
   [#if instName=="SD"]
   #include "sd_diskio.h"        /* defines SD_Driver as external */
   [/#if]
   [#if instName=="SDRAMDISK"]
   #include "sdram_diskio.h"     /* defines SDRAMDISK_Driver as external */
   [/#if]
   [#if instName=="USBH"]
   #include "usbh_diskio.h"      /* defines USBH_Driver as external */
   [/#if]
   [#if instName=="NAND"]
   #include "nand_diskio.h"      /* defines NAND_Driver as external */
   [/#if]
   [#if instName=="USER"]
   #include "user_diskio.h"      /* defines USER_Driver as external */
   [/#if]
[/#list]
[/#list]
