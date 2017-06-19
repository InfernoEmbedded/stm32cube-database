[#ftl]
[#compress]
[#assign threadControlBlock = "NULL"]
[#assign mutexControl       = "NULL"]
[#assign timerControlBlock  = "NULL"]
[#assign queueControlBlock  = "NULL"]
[#assign semaphoreControl   = "NULL"]

[#list SWIPdatas as SWIP]
  [#if SWIP.variables??]  
	[#list SWIP.variables as variable]
	
	  [#if variable.name=="Threads"]
	    [#assign s = variable.valueList]
	    [#assign index = 0]
        [#list s as i]
          [#if index == 0]
            [#assign threadName = i]
          [/#if]
          [#if index == 1]
            [#assign threadPriority = i]
          [/#if]
          [#if index == 2]
            [#assign threadStackSize = i]
          [/#if]
          [#if index == 3]
            [#assign threadFunction = i]
          [/#if]
          [#if index == 4]
            [#assign generateFunction = i]
          [/#if]
          [#if index == 5]
            [#assign codegenOption = i]
          [/#if]
          [#if index == 6]
            [#assign threadArguments = i]
          [/#if] 
          [#if index == 7]
            [#assign threadAllocation = i]
          [/#if]
          [#if index == 8]
            [#assign threadBuffer = i]
          [/#if]
          [#if index == 9]
            [#assign threadControlBlock = i]
          [/#if]      
          [#assign index = index + 1]
        [/#list]
        osThreadId ${threadName}Handle;
        [#if threadControlBlock != "NULL"]
          [#-- uint32_t ${threadBuffer}[ ${threadStackSize} * sizeof( uint32_t ) ]; --]  
          uint32_t ${threadBuffer}[ ${threadStackSize} ];
          osStaticThreadDef_t ${threadControlBlock};
        [/#if]
      [/#if]
      
      [#if variable.name=="Mutexes"]
	    [#assign s = variable.valueList]
	    [#assign index = 0]
        [#list s as i]
          [#if index == 0]
            [#assign mutexName = i]
          [/#if]
          [#if index == 1]
            [#assign mutexAllocation = i]
          [/#if]
          [#if index == 2]
            [#assign mutexControl = i]
          [/#if]
          [#assign index = index + 1]
        [/#list]
        [#if mutexName != "0"]
          osMutexId ${mutexName}Handle;
          [#if mutexControl != "NULL"]
          osStaticMutexDef_t ${mutexControl};
          [/#if]
        [/#if]
      [/#if]
     
      [#if variable.name=="RecursiveMutexes"]
	    [#assign s = variable.valueList]
	    [#assign index = 0]
        [#list s as i]
          [#if index == 0]
            [#assign mutexName = i]
          [/#if]
          [#if index == 1]
            [#assign mutexAllocation = i]
          [/#if]
          [#if index == 2]
            [#assign mutexControl = i]
          [/#if]
          [#assign index = index + 1]
        [/#list]
        [#if mutexName != "0"]
          osMutexId ${mutexName}Handle;
          [#if mutexControl != "NULL"]
          osStaticMutexDef_t ${mutexControl};
          [/#if]
        [/#if]
      [/#if]
      
      [#if variable.name=="Timers"]
	    [#assign s = variable.valueList]
	    [#assign index = 0]
        [#list s as i]
          [#if index == 0]
            [#assign timerName = i]
          [/#if]
          [#if index == 1]
            [#assign timerCallback = i]
          [/#if]
          [#if index == 2]
            [#assign timerType = i]
          [/#if]
          [#if index == 3]
            [#assign generateCallback = i]
          [/#if]
          [#if index == 4]
            [#assign timerCodeGen = i]
          [/#if]
          [#if index == 5]
            [#assign timerParameters = i]
          [/#if]
          [#if index == 6]
            [#assign timerAllocation = i]
          [/#if]
          [#if index == 7]
            [#assign timerControlBlock = i]
          [/#if]
          [#assign index = index + 1]
        [/#list]
        [#if timerName != "0"]
          osTimerId ${timerName}Handle;
          [#if timerControlBlock != "NULL"]
          osStaticTimerDef_t ${timerControlBlock};
          [/#if]
        [/#if]  
      [/#if]
      
      [#if variable.name=="Queues"]
	    [#assign s = variable.valueList]
	    [#assign index = 0]
        [#list s as i]
          [#if index == 0]
            [#assign queueName = i]
          [/#if]
          [#if index == 1]
            [#assign queueSize = i]
          [/#if]
          [#if index == 2]
            [#assign queueElementType = i]
          [/#if]
          [#if index == 3]
            [#assign queueThreadId = i]
          [/#if]
          [#if index == 4]
            [#assign queueAllocation = i]
          [/#if]
          [#if index == 5]
            [#assign queueBuffer = i]
          [/#if]
          [#if index == 6]
            [#assign queueControlBlock = i]
          [/#if] 
          [#assign index = index + 1]
        [/#list] 
        [#if queueName != "0"]
           osMessageQId ${queueName}Handle;
          [#if queueControlBlock != "NULL"]
           uint8_t ${queueBuffer}[ ${queueSize} * sizeof( ${queueElementType} ) ];
           osStaticMessageQDef_t ${queueControlBlock};
          [/#if]
        [/#if]  
      [/#if]
    
      [#if variable.name=="Semaphores"]
	    [#assign s = variable.valueList]
	    [#assign index = 0]
        [#list s as i]
          [#if index == 0]
            [#assign semaphoreName = i]
          [/#if]
          [#if index == 2]
            [#assign semaphoreAllocation = i]
          [/#if]
          [#if index == 3]
            [#assign semaphoreControl = i]
          [/#if]
          [#assign index = index + 1]
        [/#list]
        [#if semaphoreName != "0"]
          osSemaphoreId ${semaphoreName}Handle;
          [#if semaphoreControl != "NULL"]
          osStaticSemaphoreDef_t ${semaphoreControl};
          [/#if]
        [/#if]
      [/#if]
      
      [#if variable.name=="BinarySemaphores"]
	    [#assign s = variable.valueList]
	    [#assign index = 0]
        [#list s as i]
          [#if index == 0]
            [#assign semaphoreName = i]
          [/#if]
          [#if index == 1]
            [#assign semaphoreAllocation = i]
          [/#if]
          [#if index == 2]
            [#assign semaphoreControl = i]
          [/#if]
          [#assign index = index + 1]
        [/#list]
        [#if semaphoreName != "0"]
          osSemaphoreId ${semaphoreName}Handle;
          [#if semaphoreControl != "NULL"]
          osStaticSemaphoreDef_t ${semaphoreControl};
          [/#if]
        [/#if]
      [/#if]
      
    [/#list] 
     
  [/#if]
[/#list]
[/#compress]
