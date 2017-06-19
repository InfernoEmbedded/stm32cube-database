
[#ftl]
[#list configs as dt]
[#assign data = dt]
[#assign device = dt.device]
[#assign family = dt.family]
[#assign projectName = dt.projectName]
[#assign projectPath = dt.projectPath]
[#assign sourceRepository = dt.sourceRepository]
[#assign templateType = dt.templateType]
[#assign startupFiles = dt.startupFiles]
[#assign gpdsComponentsSource = dt.gpdsComponentsSource]
[#assign components = dt.components]
[#assign stackSize = dt.stackSize]
[#assign heapSize = dt.heapSize]
[#assign debugProtocol = dt.debugProtocol]

[#assign generatedFiles = dt.generatedFiles]
[#assign peripheralParams = dt.peripheralParams]
[#assign peripheralGPIOParams = dt.peripheralGPIOParams]
[#assign peripheralDMAParams = dt.peripheralDMAParams]
[#assign peripheralNVICParams = dt.peripheralNVICParams]
[#assign usedIPs = dt.usedIPs]
[#assign adc=false can=false fmpi2c=false i2c=false i2s=false sai=false sdio=false spi=false tim=false lptim=false]
[#assign uart=false usart=false irda=false smartcard=false pcd=false hcd=false]
[#assign nor=false nand=false pccard=false sram=false sdram=false]
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<!-- ******************************************************************************
 * File Name   : ${projectName}.gpdsc
 * Date        : ${date}
 * Description : Generator PDSC File generated by STM32CubeMX (DO NOT EDIT!)
 ****************************************************************************** -->

<package xmlns:xs="http://www.w3.org/2001/XMLSchema-instance" schemaVersion="1.4" xs:noNamespaceSchemaLocation="PACK.xsd">
  <vendor>STMicroelectronics</vendor>
  <name>${projectName}</name>
  <description>STM32CubeMX generated pack description</description>
  <url>${projectPath}</url>
  <releases>
    <release version="1.0.0">
     - Generated: ${date}
    </release>
  </releases>
  <requirements>
    <languages>
      <language name="C" version="99"/>
      <language name="C++" version="11"/>
    </languages> 
  </requirements>
  <create>
    <project>
      <options>
        [#if  family?upper_case == "STM32F7"]
       
        [/#if]
        <stack size="${stackSize}"/> 
        <heap size="${heapSize}"/>
        [#if debugProtocol=="swd" || debugProtocol=="jtag"]
        <debugProbe name="ST-Link" protocol="${debugProtocol}"/>
        [/#if]
      </options> 
    </project>
  </create>
  <generators>
    <generator id="STM32CubeMX">
      <description>STM32CubeMX GPDSC</description>
      <select Dname="${device}" Dvendor="STMicroelectronics:13"/>
      [#if templateType == "MDK-GPDSC"]
      [/#if]
      <project_files>${generatedFiles}      </project_files>
    </generator>
  </generators>
  <taxonomy>
    <description Cclass="Device" Cgroup="STM32Cube Framework" generator="STM32CubeMX">STM32Cube Framework</description>
  </taxonomy>
  <conditions>
[#if gpdsComponentsSource == "USE_PACK_Components"]
    <condition id="STCubeMX">
      <description>Condition to include CMSIS core and Device Startup components</description>
      <require Dvendor="STMicroelectronics:13" Dname="${family?upper_case}*"/>
      <require Cclass="CMSIS"  Cgroup="CORE"          Csub=""/>
      <require Cclass="Device" Cgroup="Startup"/>
      <require Cclass="Device" Cgroup="STM32Cube HAL" Csub="Flash"/>
[#list usedIPs as ip]
[#if peripheralParams.get(ip)??]
[#if ip == "CORTEX_M7"]
      <require Cclass="Device" Cgroup="STM32Cube HAL" Csub="Common"/>
[#elseif ip?starts_with("ADC")]
  [#if !adc]
      <require Cclass="Device" Cgroup="STM32Cube HAL" Csub="ADC"/>
      [#assign adc=true]
  [/#if]
[#elseif ip?starts_with("CAN")]
  [#if !can]
      <require Cclass="Device" Cgroup="STM32Cube HAL" Csub="CAN"/>
      [#assign can=true]
  [/#if]
[#elseif ip == "DSIHOST"]
      <require Cclass="Device" Cgroup="STM32Cube HAL" Csub="DSI"/>
[#elseif ip?starts_with("FSMC")]
  [#list peripheralParams.get(ip).entrySet() as paramEntry]
  [#if paramEntry.key?starts_with("MemoryType")]
    [#if paramEntry.value?contains("NOR")]
      [#if !nor]
      <require Cclass="Device" Cgroup="STM32Cube HAL" Csub="NOR"/>
      [#assign nor=true]
      [/#if]
    [#elseif paramEntry.value?contains("SRAM")]
      [#if !sram]
      <require Cclass="Device" Cgroup="STM32Cube HAL" Csub="SRAM"/>
      [#assign sram=true]
      [/#if]
    [/#if]
  [#elseif paramEntry.key == "NAND_Instance"]
    [#if !nand]
      <require Cclass="Device" Cgroup="STM32Cube HAL" Csub="NAND"/>
      [#assign nand=true]
    [/#if]
  [#elseif paramEntry.key == "PCCARD_Instance"]
    [#if !pccard]
      <require Cclass="Device" Cgroup="STM32Cube HAL" Csub="PC Card"/>
      [#assign pccard=true]
    [/#if]
  [/#if]
  [/#list]
[#elseif ip?starts_with("FMC")]
  [#list peripheralParams.get(ip).entrySet() as paramEntry]
  [#if paramEntry.key?starts_with("MemoryType")]
    [#if paramEntry.value?contains("NOR")]
      [#if !nor]
      <require Cclass="Device" Cgroup="STM32Cube HAL" Csub="NOR"/>
      [#assign nor=true]
      [/#if]
    [#elseif paramEntry.value?contains("SRAM")]
      [#if !sram]
      <require Cclass="Device" Cgroup="STM32Cube HAL" Csub="SRAM"/>
      [#assign sram=true]
      [/#if]
    [/#if]
  [#elseif paramEntry.key == "NAND_Instance"]
    [#if !nand]
      <require Cclass="Device" Cgroup="STM32Cube HAL" Csub="NAND"/>
      [#assign nand=true]
    [/#if]
  [#elseif paramEntry.key == "PCCARD_Instance"]
    [#if !pccard]
      <require Cclass="Device" Cgroup="STM32Cube HAL" Csub="PC Card"/>
      [#assign pccard=true]
    [/#if]
  [#elseif paramEntry.key == "SDRAM_Instance"]
    [#if !sdram]
      <require Cclass="Device" Cgroup="STM32Cube HAL" Csub="SDRAM"/>
      [#assign sdram=true]
    [/#if]
  [/#if]
  [/#list]
[#elseif ip?starts_with("FMPI2C")]
  [#if !fmpi2c]
      <require Cclass="Device" Cgroup="STM32Cube HAL" Csub="FMPI2C"/>
      [#assign fmpi2c=true]
  [/#if]
[#elseif ip == "HDMI_CEC"]
      <require Cclass="Device" Cgroup="STM32Cube HAL" Csub="CEC"/>
[#elseif ip?starts_with("I2C")]
  [#if !i2c]
      <require Cclass="Device" Cgroup="STM32Cube HAL" Csub="I2C"/>
      [#assign i2c=true]
  [/#if]
[#elseif ip?starts_with("I2S")]
  [#if !i2s]
      <require Cclass="Device" Cgroup="STM32Cube HAL" Csub="I2S"/>
      [#assign i2s=true]
  [/#if]
[#elseif ip?starts_with("LPTIM")]
  [#if !lptim]
      <require Cclass="Device" Cgroup="STM32Cube HAL" Csub="LPTIM"/>
      [#assign i2c=lptim]
  [/#if]
[#elseif ip?starts_with("NVIC")]
[#elseif ip == "QUADSPI"]
      <require Cclass="Device" Cgroup="STM32Cube HAL" Csub="QSPI"/>
[#elseif ip?starts_with("SAI")]
  [#if !sai]
      <require Cclass="Device" Cgroup="STM32Cube HAL" Csub="SAI"/>
      [#assign sai=true]
  [/#if]
[#elseif ip?starts_with("SDIO")]
  [#if !sdio]
      <require Cclass="Device" Cgroup="STM32Cube HAL" Csub="SD"/>
      [#assign sdio=true]
  [/#if]
[#elseif ip?starts_with("SDMMC")]
  [#if !sdio]
      <require Cclass="Device" Cgroup="STM32Cube HAL" Csub="SD"/>
      [#assign sdio=true]
  [/#if]
[#elseif ip?starts_with("SPI")]
  [#if !spi]
      <require Cclass="Device" Cgroup="STM32Cube HAL" Csub="SPI"/>
      [#assign spi=true]
  [/#if]
[#elseif ip?starts_with("SYS")]
[#elseif ip?starts_with("TIM")]
  [#if !tim]
      <require Cclass="Device" Cgroup="STM32Cube HAL" Csub="TIM"/>
      [#assign tim=true]
  [/#if]
[#elseif ip?starts_with("UART")]
  [#list peripheralParams.get(ip).entrySet() as paramEntry]
  [#if paramEntry.key?starts_with("Mode")]
    [#if paramEntry.value?starts_with("IRDA")]
      [#if !irda]
      <require Cclass="Device" Cgroup="STM32Cube HAL" Csub="IRDA"/>
      [#assign irda=true]
      [/#if]
    [#else]
      [#if !uart]
      <require Cclass="Device" Cgroup="STM32Cube HAL" Csub="UART"/>
      [#assign uart=true]
      [/#if]
    [/#if]
  [/#if]
  [/#list]
[#elseif ip?starts_with("USART")]
  [#list peripheralParams.get(ip).entrySet() as paramEntry]
  [#if paramEntry.key?starts_with("VirtualMode")]
    [#if paramEntry.value == "VM_IRDA"]
      [#if !irda]
      <require Cclass="Device" Cgroup="STM32Cube HAL" Csub="IRDA"/>
      [#assign irda=true]
      [/#if]
    [#elseif paramEntry.value == "VM_SMARTCARD"]
      [#if !smartcard]
      <require Cclass="Device" Cgroup="STM32Cube HAL" Csub="Smartcard"/>
      [#assign smartcard=true]
      [/#if]
    [#elseif paramEntry.value == "VM_SYNC"]
      [#if !usart]
      <require Cclass="Device" Cgroup="STM32Cube HAL" Csub="USART"/>
      [#assign usart=true]
      [/#if]
    [#else]
      [#if !uart]
      <require Cclass="Device" Cgroup="STM32Cube HAL" Csub="UART"/>
      [#assign uart=true]
      [/#if]
    [/#if]
  [/#if]
  [/#list]
[#elseif ip?starts_with("USB")]
  [#list peripheralParams.get(ip).entrySet() as paramEntry]
  [#if paramEntry.key?starts_with("VirtualMode")]
    [#if paramEntry.value?starts_with("Device")]
      [#if !pcd]
      <require Cclass="Device" Cgroup="STM32Cube HAL" Csub="PCD"/>
      [#assign pcd=true]
      [/#if]
    [#elseif paramEntry.value?starts_with("Host")]
      [#if !hcd]
      <require Cclass="Device" Cgroup="STM32Cube HAL" Csub="HCD"/>
      [#assign hcd=true]
      [/#if]
    [#else]
      [#if !pcd]
      <require Cclass="Device" Cgroup="STM32Cube HAL" Csub="PCD"/>
      [#assign pcd=true]
      [/#if]
      [#if !hcd]
      <require Cclass="Device" Cgroup="STM32Cube HAL" Csub="HCD"/>
      [#assign hcd=true]
      [/#if]
    [/#if]
  [/#if]
  [/#list]
[#else]
      <require Cclass="Device" Cgroup="STM32Cube HAL" Csub="${(ip)}"/>
[/#if]
[/#if]
[/#list]
    </condition>
[/#if]
[#if gpdsComponentsSource == "USE_MX_Components"]
    <condition id="ARM Toolchain">
      <description>ARM compiler for C and C++ Filter</description>
      <require Tcompiler="ARMCC"/>
    </condition>
    <condition id="GCC Toolchain">
      <description>GNU Tools for ARM Embedded Processors Filter</description>
      <require Tcompiler="GCC"/>
    </condition>
    <condition id="IAR Toolchain">
      <description>IAR compiler for C and C++ Filter</description>
      <require Tcompiler="IAR"/>
    </condition>
[/#if]
  </conditions>

  <components>
    [#if templateType == "MDK-GPDSC"]
    <component generator="STM32CubeMX" Cvendor="Keil" Cclass="Device" Cgroup="STM32Cube Framework" Csub="STM32CubeMX" Cversion="1.0.0" condition="STCubeMX">
      <description>Configuration via STM32CubeMX</description>   
      <RTE_Components_h>
        #define RTE_DEVICE_FRAMEWORK_CUBE_MX
      </RTE_Components_h>
      <files>
      </files>
    </component>
    [/#if]
    [#if gpdsComponentsSource == "USE_MX_Components"]
    <component Cclass="CMSIS" Cgroup="CORE" Cversion="4.0.0">
      <description>CMSIS-CORE for ARM</description>
       [#if templateType == "MDK-GPDSC"]
      <RTE_Components_h>
        #define RTE_DEVICE_HAL_CORE
      </RTE_Components_h>
      [/#if]
      <files>
      [#if  family?upper_case == "STM32F0"]
        <file category="header" name="${sourceRepository}Drivers\CMSIS\Include\core_cm0.h"/>
      [/#if]
      [#if  family?upper_case == "STM32L0"]
        <file category="header" name="${sourceRepository}Drivers\CMSIS\Include\core_cm0plus.h"/>
      [/#if]
      [#if  family?upper_case == "STM32F2" || family?upper_case ==  "STM32L1" || family?upper_case ==  "STM32L1"]
        <file category="header" name="${sourceRepository}Drivers\CMSIS\Include\core_cm3.h"/>
      [/#if]
      [#if  family?upper_case == "STM32F4" || family?upper_case ==  "STM32L4" || family?upper_case ==  "STM32F3"]
        <file category="header" name="${sourceRepository}Drivers\CMSIS\Include\core_cm4.h"/>
      [/#if]
      [#if  family?upper_case == "STM32F7"]
        <file category="header" name="${sourceRepository}Drivers\CMSIS\Include\core_cm7.h"/>
      [/#if]
      </files>
    </component>
    <component Cclass="Device" Cgroup="Startup" Cversion="2.1.0">  
      <description>System Startup for STMicroelectronics</description>
      [#if templateType == "MDK-GPDSC"]
      <RTE_Components_h>
        #define RTE_DEVICE_STARTUP_${family?upper_case}XX    
      </RTE_Components_h>
      [/#if]
      <files>
        <file category="header" name="${sourceRepository}Drivers\CMSIS\Device\ST\${family?upper_case}xx\Include\${family?lower_case}xx.h"/>
        <file category="header" name="${sourceRepository}Drivers\CMSIS\Device\ST\${family?upper_case}xx\Include\system_${family?lower_case}xx.h"/>
        <file category="sourceC" name="${sourceRepository}Drivers\CMSIS\Device\ST\${family?upper_case}xx\Source\Templates\system_${family?lower_case}xx.c"/>
[#if startupFiles?length > 0]
${startupFiles}
[/#if]
      </files>
    </component>
    <component Cclass="Device" Cgroup="STM32Cube HAL" Csub="COMMON" Cversion="1.3.2">
      <description>CubeMX Generated HAL COMMON</description>
      [#if templateType == "MDK-GPDSC"]
      <RTE_Components_h>
        #define RTE_DEVICE_HAL_COMMON
      </RTE_Components_h>
      [/#if]
      <files>
        <file category="header" name="${sourceRepository}Drivers\${family?upper_case}xx_HAL_Driver\Inc\${family?lower_case}xx_hal.h"/>
        <file category="sourceC" name="${sourceRepository}Drivers\${family?upper_case}xx_HAL_Driver\Src\${family?lower_case}xx_hal.c"/>
      </files>
    </component>
    [/#if]
[#if components?length > 0]
${components}
[/#if]
  </components>
</package>
[/#list]
