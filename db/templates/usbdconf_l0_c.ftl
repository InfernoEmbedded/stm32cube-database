[#ftl]
/**
  ******************************************************************************
  * @file           : ${name}
  * @date           : ${date}   
  * @version        : ${version}
[#--  * @packageVersion : ${fwVersion} --]
  * @brief          : This file implements the board support package for the USB device library
  ******************************************************************************
  *
  * COPYRIGHT(c) ${year} STMicroelectronics
  *
  * Redistribution and use in source and binary forms, with or without modification,
  * are permitted provided that the following conditions are met:
  * 1. Redistributions of source code must retain the above copyright notice,
  * this list of conditions and the following disclaimer.
  * 2. Redistributions in binary form must reproduce the above copyright notice,
  * this list of conditions and the following disclaimer in the documentation
  * and/or other materials provided with the distribution.
  * 3. Neither the name of STMicroelectronics nor the names of its contributors
  * may be used to endorse or promote products derived from this software
  * without specific prior written permission.
  *
  * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
  * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
  * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
  * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
  * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
  * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  ******************************************************************************
*/
/* Includes ------------------------------------------------------------------*/
[#if SWIncludes??]
[#list SWIncludes as include]
#include "${include}"
[/#list]
[/#if]
#include "usbd_core.h"
[#assign handleNameFS = ""]
[#assign handleNameUSB_FS = ""]
[#assign handleNameHS = ""]
[#assign instanceNb = 0]
[#assign includeMspDone = 0] 

[#list SWIPdatas as SWIP]  
[#compress]
[#-- Section2: Create global Variables for each middle ware instance --] 
[#-- Global variables --]
[#if SWIP.variables??]
	[#list SWIP.variables as variable]			
		[#-- extern ${variable.type} --][#if variable.value??][#--${variable.value};--]		
		[#if variable.value?contains("OTG_FS")][#assign handleNameFS = "FS"][/#if]
		[#if variable.value?contains("USB_FS")][#assign handleNameUSB_FS = "FS"][/#if]
		[#if variable.value?contains("OTG_HS")][#assign handleNameHS = "HS"][/#if]
		[/#if]		
	[/#list]
[/#if]
[#-- Global variables --]
[/#compress]
[/#list]
/* Private typedef -----------------------------------------------------------*/
/* Private define ------------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
[#if handleNameFS == "FS"]
[#include "Src/usb_otg_fs_vars.tmp"]
[/#if]
[#if handleNameUSB_FS = "FS"]
[#include "Src/usb_vars.tmp"]
[/#if]
[#if handleNameHS == "HS"]
[#include "Src/usb_otg_hs_vars.tmp"]
[/#if]

/* USER CODE BEGIN 0 */
__IO uint32_t remotewakeupon=0;
/* USER CODE END 0 */

/* Private function prototypes -----------------------------------------------*/
/* Private functions ---------------------------------------------------------*/
/* USER CODE BEGIN 1 */
static void SystemClockConfig_Resume(void);
/* USER CODE END 1 */

/*******************************************************************************
                       LL Driver Callbacks (PCD -> USB Device Library)
*******************************************************************************/
/* MSP Init */
[#if handleNameFS == "FS"]
[#if includeMspDone == 0]
[#assign includeMspDone = 1]
[#include "Src/usb_otg_fs_Msp.tmp"]
[/#if]
[/#if]
[#if handleNameHS == "HS"]
[#if includeMspDone == 0]
[#assign includeMspDone = 1]
[#include "Src/usb_otg_hs_Msp.tmp"]
[/#if]
[/#if]
[#if handleNameUSB_FS == "FS"]
[#if includeMspDone == 0]
[#assign includeMspDone = 1]
[#include "Src/usb_Msp.tmp"]
[/#if]
[/#if]

/**
  * @brief  Setup stage callback
  * @param  hpcd: PCD handle
  * @retval None
  */
void HAL_PCD_SetupStageCallback(PCD_HandleTypeDef *hpcd)
{
  USBD_LL_SetupStage(hpcd->pData, (uint8_t *)hpcd->Setup);
}

/**
  * @brief  Data Out stage callback.
  * @param  hpcd: PCD handle
  * @param  epnum: Endpoint Number
  * @retval None
  */
void HAL_PCD_DataOutStageCallback(PCD_HandleTypeDef *hpcd, uint8_t epnum)
{
  USBD_LL_DataOutStage(hpcd->pData, epnum, hpcd->OUT_ep[epnum].xfer_buff);
}

/**
  * @brief  Data In stage callback..
  * @param  hpcd: PCD handle
  * @param  epnum: Endpoint Number
  * @retval None
  */
void HAL_PCD_DataInStageCallback(PCD_HandleTypeDef *hpcd, uint8_t epnum)
{
  USBD_LL_DataInStage(hpcd->pData, epnum, hpcd->IN_ep[epnum].xfer_buff);
}

/**
  * @brief  SOF callback.
  * @param  hpcd: PCD handle
  * @retval None
  */
void HAL_PCD_SOFCallback(PCD_HandleTypeDef *hpcd)
{
  USBD_LL_SOF(hpcd->pData);
}

/**
  * @brief  Reset callback.
  * @param  hpcd: PCD handle
  * @retval None
  */
void HAL_PCD_ResetCallback(PCD_HandleTypeDef *hpcd)
{ 
  USBD_SpeedTypeDef speed = USBD_SPEED_FULL;

  /*Set USB Current Speed*/
  switch (hpcd->Init.speed)
  {
  [#if handleNameFS == "FS" || handleNameHS == "HS"]
  case PCD_SPEED_HIGH:
    speed = USBD_SPEED_HIGH;
    break;
  [/#if]  
  case PCD_SPEED_FULL:
    speed = USBD_SPEED_FULL;    
    break;
	
  default:
    speed = USBD_SPEED_FULL;    
    break;    
  }
  USBD_LL_SetSpeed(hpcd->pData, speed);  
  
  /*Reset Device*/
  USBD_LL_Reset(hpcd->pData);
}

/**
  * @brief  Suspend callback.
  * @param  hpcd: PCD handle
  * @retval None
  */
void HAL_PCD_SuspendCallback(PCD_HandleTypeDef *hpcd)
{
  USBD_LL_Suspend(hpcd->pData);
  /*Enter in STOP mode */
  /* USER CODE BEGIN 2 */
  if (hpcd->Init.low_power_enable)
  {
    /* Set SLEEPDEEP bit and SleepOnExit of Cortex System Control Register */
    SCB->SCR |= (uint32_t)((uint32_t)(SCB_SCR_SLEEPDEEP_Msk | SCB_SCR_SLEEPONEXIT_Msk));
  }
  /* USER CODE END 2 */
}

/**
  * @brief  Resume callback.
  * @param  hpcd: PCD handle
  * @retval None
  */
void HAL_PCD_ResumeCallback(PCD_HandleTypeDef *hpcd)
{
  /* USER CODE BEGIN 3 */
  if ((hpcd->Init.low_power_enable)&&(remotewakeupon == 0))
  {
    SystemClockConfig_Resume();
    /* Reset SLEEPDEEP bit of Cortex System Control Register */
    SCB->SCR &= (uint32_t)~((uint32_t)(SCB_SCR_SLEEPDEEP_Msk | SCB_SCR_SLEEPONEXIT_Msk));    
  }
  remotewakeupon=0;
  /* USER CODE END 3 */
  USBD_LL_Resume(hpcd->pData);
  
}

/**
  * @brief  ISOC Out Incomplete callback.
  * @param  hpcd: PCD handle
  * @param  epnum: Endpoint Number
  * @retval None
  */
void HAL_PCD_ISOOUTIncompleteCallback(PCD_HandleTypeDef *hpcd, uint8_t epnum)
{
  USBD_LL_IsoOUTIncomplete(hpcd->pData, epnum);
}

/**
  * @brief  ISOC In Incomplete callback.
  * @param  hpcd: PCD handle
  * @param  epnum: Endpoint Number
  * @retval None
  */
void HAL_PCD_ISOINIncompleteCallback(PCD_HandleTypeDef *hpcd, uint8_t epnum)
{
  USBD_LL_IsoINIncomplete(hpcd->pData, epnum);
}

/**
  * @brief  Connect callback.
  * @param  hpcd: PCD handle
  * @retval None
  */
void HAL_PCD_ConnectCallback(PCD_HandleTypeDef *hpcd)
{
  USBD_LL_DevConnected(hpcd->pData);
}

/**
  * @brief  Disconnect callback.
  * @param  hpcd: PCD handle
  * @retval None
  */
void HAL_PCD_DisconnectCallback(PCD_HandleTypeDef *hpcd)
{
  USBD_LL_DevDisconnected(hpcd->pData);
}

/*******************************************************************************
                       LL Driver Interface (USB Device Library --> PCD)
*******************************************************************************/
/**
  * @brief  USBD_LL_Init 
  *         Initialize the Low Level portion of the Device driver.
  * @param  pdev: Device handle
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_Init (USBD_HandleTypeDef *pdev)
{ 
#t/* Init USB_IP */
[#if handleNameFS == "FS"]
#tif (pdev->id == DEVICE_FS) {
#t[#include "Src/usb_otg_fs_HalInit.tmp"]
#t/* Link The driver to the stack */	
#thpcd_USB_OTG_FS.pData = pdev;
#tpdev->pData = &hpcd_USB_OTG_FS; 
#tHAL_PCD_SetRxFiFo(&hpcd_USB_OTG_FS, 0x80);
#tHAL_PCD_SetTxFiFo(&hpcd_USB_OTG_FS, 0, 0x40);
#tHAL_PCD_SetTxFiFo(&hpcd_USB_OTG_FS, 1, 0x80);
#t}
[/#if]
[#if handleNameHS == "HS"]
#tif (pdev->id == DEVICE_HS) {
[#include "Src/usb_otg_hs_HalInit.tmp"]
#t/* Link The driver to the stack */
#thpcd_USB_OTG_HS.pData = pdev;
#tpdev->pData = &hpcd_USB_OTG_HS;
#tHAL_PCD_SetRxFiFo(&hpcd_USB_OTG_HS, 0x200);
#tHAL_PCD_SetTxFiFo(&hpcd_USB_OTG_HS, 0, 0x80);
#tHAL_PCD_SetTxFiFo(&hpcd_USB_OTG_HS, 1, 0x174);
#t}
[/#if]
[#if handleNameUSB_FS == "FS"]
[#include "Src/usb_HalInit.tmp"]
#t/* Link The driver to the stack */
#thpcd_USB_FS.pData = pdev;
#tpdev->pData = &hpcd_USB_FS;
#tHAL_PCDEx_PMAConfig(pdev->pData , 0x00 , PCD_SNG_BUF, 0x18);
#tHAL_PCDEx_PMAConfig(pdev->pData , 0x80 , PCD_SNG_BUF, 0x58);
#tHAL_PCDEx_PMAConfig(pdev->pData , 0x81 , PCD_SNG_BUF, 0x100);  
[/#if]
#treturn USBD_OK;
}

/**
  * @brief  USBD_LL_DeInit 
  *         De-Initialize the Low Level portion of the Device driver.
  * @param  pdev: Device handle
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_DeInit (USBD_HandleTypeDef *pdev)
{
  HAL_PCD_DeInit(pdev->pData);
  return USBD_OK; 
}

/**
  * @brief  USBD_LL_Start 
  *         Start the Low Level portion of the Device driver.
  * @param  pdev: Device handle
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_Start(USBD_HandleTypeDef *pdev)
{
  HAL_PCD_Start(pdev->pData);
  return USBD_OK; 
}

/**
  * @brief  USBD_LL_Stop 
  *         Stop the Low Level portion of the Device driver.
  * @param  pdev: Device handle
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_Stop (USBD_HandleTypeDef *pdev)
{
  HAL_PCD_Stop(pdev->pData);
  return USBD_OK; 
}

/**
  * @brief  USBD_LL_OpenEP 
  *         Open an endpoint of the Low Level Driver.
  * @param  pdev: device handle
  * @param  ep_addr: Endpoint Number
  * @param  ep_type: Endpoint Type
  * @param  ep_mps: Endpoint Max Packet Size                 
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_OpenEP  (USBD_HandleTypeDef *pdev, 
                                      uint8_t  ep_addr,                                      
                                      uint8_t  ep_type,
                                      uint16_t ep_mps)
{

  HAL_PCD_EP_Open(pdev->pData, 
                  ep_addr, 
                  ep_mps, 
                  ep_type);
  
  return USBD_OK; 
}

/**
  * @brief  USBD_LL_CloseEP 
  *         Close an endpoint of the Low Level Driver.
  * @param  pdev: device handle
  * @param  ep_addr: Endpoint Number      
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_CloseEP (USBD_HandleTypeDef *pdev, uint8_t ep_addr)   
{
  
  HAL_PCD_EP_Close(pdev->pData, ep_addr);
  return USBD_OK; 
}

/**
  * @brief  USBD_LL_FlushEP 
  *         Flush an endpoint of the Low Level Driver.
  * @param  pdev: device handle
  * @param  ep_addr: Endpoint Number      
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_FlushEP (USBD_HandleTypeDef *pdev, uint8_t ep_addr)   
{
  
  HAL_PCD_EP_Flush(pdev->pData, ep_addr);
  return USBD_OK; 
}

/**
  * @brief  USBD_LL_StallEP 
  *         Set a Stall condition on an endpoint of the Low Level Driver.
  * @param  pdev: device handle
  * @param  ep_addr: Endpoint Number      
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_StallEP (USBD_HandleTypeDef *pdev, uint8_t ep_addr)   
{
  
  HAL_PCD_EP_SetStall(pdev->pData, ep_addr);
  return USBD_OK; 
}

/**
  * @brief  USBD_LL_ClearStallEP 
  *         Clear a Stall condition on an endpoint of the Low Level Driver.
  * @param  pdev: device handle
  * @param  ep_addr: Endpoint Number      
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_ClearStallEP (USBD_HandleTypeDef *pdev, uint8_t ep_addr)   
{
  
  HAL_PCD_EP_ClrStall(pdev->pData, ep_addr);  
  return USBD_OK; 
}

/**
  * @brief  USBD_LL_IsStallEP 
  *         Return Stall condition.
  * @param  pdev: device handle
  * @param  ep_addr: Endpoint Number      
* @retval Stall (1: yes, 0: No)
  */
uint8_t USBD_LL_IsStallEP (USBD_HandleTypeDef *pdev, uint8_t ep_addr)   
{
  PCD_HandleTypeDef *hpcd = pdev->pData; 
  
  if((ep_addr & 0x80) == 0x80)
  {
    return hpcd->IN_ep[ep_addr & 0x7F].is_stall; 
  }
  else
  {
    return hpcd->OUT_ep[ep_addr & 0x7F].is_stall; 
  }
}
/**
  * @brief  USBD_LL_SetDevAddress 
  *         Assign an USB address to the device
  * @param  pdev: device handle
  * @param  ep_addr: Endpoint Number      
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_SetUSBAddress (USBD_HandleTypeDef *pdev, uint8_t dev_addr)   
{
  
  HAL_PCD_SetAddress(pdev->pData, dev_addr);
  return USBD_OK; 
}

/**
  * @brief  USBD_LL_Transmit 
  *         Transmit data over an endpoint
  * @param  pdev: device handle
  * @param  ep_addr: Endpoint Number
  * @param  pbuf:pointer to data to be sent    
  * @param  size: data size    
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_Transmit (USBD_HandleTypeDef *pdev, 
                                      uint8_t  ep_addr,                                      
                                      uint8_t  *pbuf,
                                      uint16_t  size)
{

  HAL_PCD_EP_Transmit(pdev->pData, ep_addr, pbuf, size);
  return USBD_OK;   
}

/**
  * @brief  USBD_LL_PrepareReceive 
  *         prepare an endpoint for reception
  * @param  pdev: device handle
  * @param  ep_addr: Endpoint Number
  * @param  pbuf:pointer to data to be received    
  * @param  size: data size              
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_PrepareReceive(USBD_HandleTypeDef *pdev, 
                                           uint8_t  ep_addr,                                      
                                           uint8_t  *pbuf,
                                           uint16_t  size)
{

  HAL_PCD_EP_Receive(pdev->pData, ep_addr, pbuf, size);
  return USBD_OK;   
}

/**
  * @brief  USBD_LL_GetRxDataSize 
  *         Return the last transfered packet size.
  * @param  phost: Device handle
  * @param  ep_addr: Endpoint Number
  * @retval Recived Data Size
  */
uint32_t USBD_LL_GetRxDataSize  (USBD_HandleTypeDef *pdev, uint8_t  ep_addr)  
{
  return HAL_PCD_EP_GetRxCount(pdev->pData, ep_addr);
}

/**
  * @brief  USBD_LL_Delay 
  *         Delay routine for the USB Device Library
  * @param  Delay: Delay in ms
  * @retval None
  */
void  USBD_LL_Delay (uint32_t Delay)
{
  HAL_Delay(Delay);  
}

/**
  * @brief  static single allocation.
  * @param  size: size of allocated memory
  * @retval None
  */
void *USBD_static_malloc(uint32_t size)
{
  static uint32_t mem[MAX_STATIC_ALLOC_SIZE];
  return mem;
}

/**
  * @brief  Dummy memory free
  * @param  *p pointer to allocated  memory address
  * @retval None
  */
void USBD_static_free(void *p)
{

}

/* USER CODE BEGIN 4 */
/**
  * @brief  Configures system clock after wake-up from USB Resume CallBack: 
  *         enable HSI, PLL and select PLL as system clock source.
  * @param  None
  * @retval None
  */
static void SystemClockConfig_Resume(void)
{
}
/* USER CODE END 4 */

/* USER CODE BEGIN 5 */
/**
  * @brief  WakeUp_Callback function
  *         Handle remote-wakeup
  * @param  
  * @retval None
  */
void WakeUp_Callback(void)
{
   if ((((USBD_HandleTypeDef *)hpcd_USB_FS.pData)->dev_remote_wakeup == 1)&&
         (((USBD_HandleTypeDef *)hpcd_USB_FS.pData)->dev_state == USBD_STATE_SUSPENDED))
    {
      if ((&hpcd_USB_FS)->Init.low_power_enable)
      {
        /* Reset SLEEPDEEP bit of Cortex System Control Register */
        SCB->SCR &= (uint32_t)~((uint32_t)(SCB_SCR_SLEEPDEEP_Msk | SCB_SCR_SLEEPONEXIT_Msk));  
    
        SystemClockConfig_Resume();
      }
      
      /* Activate Remote wakeup */
      HAL_PCD_ActiveRemoteWakeup((&hpcd_USB_FS));
      /* remote wakeup delay */
      HAL_Delay(10);
      /* Desactivate Remote wakeup */
      HAL_PCD_DeActiveRemoteWakeup((&hpcd_USB_FS));

      /* change remote_wakeup feature to 0*/
      ((USBD_HandleTypeDef *)hpcd_USB_FS.pData)->dev_remote_wakeup=0;
      
      remotewakeupon = 1;
    }
}
/* USER CODE END 5 */

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
