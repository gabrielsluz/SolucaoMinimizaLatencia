#include "TestMpdr.h"

#define NUM_TESTS 7
#define TEST_DELAY 10000
#define FINISH_TIME 20000
#define TEST_DURATION 30000

#define NUM_MSGS 500
#define SEND_PERIOD 4

#define INIT_TIME 10000

module TestMpdrC {
  uses {
    interface Boot;

    interface Timer<TMilli> as InitTimer;
    interface Timer<TMilli> as SendTimer;
    interface Timer<TMilli> as TestTimer;
    interface Timer<TMilli> as FinishTimer;

    interface SplitControl as SerialControl;
    interface SerialLogger;

    interface SplitControl as RadiosControl;

    interface StdControl as MpdrControl;
    interface MpdrRouting;
    interface AMSend as MpdrSend;
    interface Receive as MpdrReceive;
    interface Packet as MpdrPacket;
    interface MpdrStats;
  }
}


implementation {

  bool transmitting = FALSE;

  message_t msgBuffer;
	message_t returnmsgBuffer;
  uint16_t sendCount = 0;
  uint16_t receivedCount = 0;
  uint8_t testCounter = 0;
  uint32_t startTime = 0;
  uint32_t endTime = 0;

  // Init route
  // cost: 9
  // len: 2
  uint8_t numPaths = 2;
  uint8_t sourceNode = 100;
  uint8_t destinationNode = 99;
//uint8_t numHops = 1;
  uint8_t numHops = 2;
  uint8_t hops[2][4] = {
    {100, 99, 2, 3},
    {100, 99, 1, 1},
  };
  // End route

  bool isRelay() {
    uint8_t i;
    if (TOS_NODE_ID == sourceNode || TOS_NODE_ID == destinationNode) {
      return FALSE;
    }
    for (i = 0; i < numHops; i++) {
      if (TOS_NODE_ID == hops[i][0]) {
        return TRUE;
      }
    }
    return FALSE;
  }

  void initializeNode() {
    uint8_t i;
    uint8_t node;
    uint8_t next_hop;
    uint8_t radio;
    uint8_t channel;
    /*call SerialLogger.log(LOG_INITIALIZED, TOS_NODE_ID);*/
    for (i = 0; i < numHops; i++) {
      node = hops[i][0];
      next_hop = hops[i][1];
      radio = hops[i][2];
      channel = hops[i][3];
      if (TOS_NODE_ID == node || TOS_NODE_ID == next_hop) {
        call MpdrRouting.setRadioChannel(radio, channel);
      }
      if (TOS_NODE_ID == node && TOS_NODE_ID == sourceNode) {
        call MpdrRouting.addSendRoute(sourceNode, destinationNode,
                                      next_hop, radio, channel);
      }
      if (TOS_NODE_ID == node && TOS_NODE_ID != sourceNode) {
        call MpdrRouting.addRoutingItem(sourceNode, destinationNode,
                                        next_hop, radio, channel);
      }
      if(next_hop == destinationNode && TOS_NODE_ID == destinationNode){
      	call MpdrRouting.addSendRoute(destinationNode,sourceNode,
                                      node, radio, channel);
      }
			if(next_hop == TOS_NODE_ID && TOS_NODE_ID != destinationNode){
				call MpdrRouting.addRoutingItem(destinationNode, sourceNode,
                                        node, radio, channel);
			}
    }

    if (TOS_NODE_ID == sourceNode) {
      call SerialLogger.log(LOG_SOURCE_NODE, sourceNode);
      call TestTimer.startPeriodicAt(TEST_DELAY, TEST_DURATION);
      call FinishTimer.startPeriodicAt(TEST_DELAY + FINISH_TIME, TEST_DURATION);
    } else if (TOS_NODE_ID == destinationNode) {
      call SerialLogger.log(LOG_DESTINATION_NODE, destinationNode);
      call FinishTimer.startPeriodicAt(TEST_DELAY + FINISH_TIME, TEST_DURATION);
    } else if (isRelay()){
      call SerialLogger.log(LOG_RELAY_NODE, TOS_NODE_ID);
      call FinishTimer.startPeriodicAt(TEST_DELAY + FINISH_TIME, TEST_DURATION);
    }
  }

  void sendMessage() {
    message_t* msg;
    mpdr_test_msg_t* payload;
    error_t result;
    uint8_t i;
    if (NUM_MSGS > 0 && sendCount >= NUM_MSGS) {
      return;
    }
    startTime = call FinishTimer.getNow();
    msg = &msgBuffer;
    payload = (mpdr_test_msg_t*) call MpdrPacket.getPayload(msg,
                                                       sizeof(mpdr_test_msg_t));
    payload->seqno = sendCount;
    for (i = 0; i < MSG_SIZE; i++) {
      payload->data[i] = i;
    }
    result = call MpdrSend.send(destinationNode, msg, sizeof(mpdr_test_msg_t));
    if (result == SUCCESS) {
      sendCount++;
    }
  }

  event void Boot.booted() {
    call SerialControl.start();
  }

  event void SerialControl.startDone(error_t err) {
    if (err != SUCCESS) {
      call SerialControl.start();
    } else {
      call RadiosControl.start();
    }
  }

  event void SerialControl.stopDone(error_t err) {}

  event void RadiosControl.startDone(error_t error) {
    if (error != SUCCESS) {
      call RadiosControl.start();
    } else {
      call MpdrControl.start();
      call MpdrRouting.setNumPaths(numPaths);
      call InitTimer.startOneShot(INIT_TIME);
    }
  }

  event void RadiosControl.stopDone(error_t error) {}

  event void MpdrSend.sendDone(message_t* msg, error_t error) {}

  event message_t* MpdrReceive.receive(message_t* msg, void* payload,
                                       uint8_t len) {
		message_t* returnmsg;
    mpdr_test_msg_t* returnpayload;
    error_t result;
		uint8_t i;
    receivedCount++;
    if (startTime == 0) {
      startTime = call FinishTimer.getNow();
    }

    endTime = call FinishTimer.getNow();
		if(TOS_NODE_ID == sourceNode){
			call SerialLogger.log(LOG_TIME_PARCIAL, endTime - startTime);
		}		
		//Envia a mensagem de retorno
		if(TOS_NODE_ID == destinationNode){

			returnmsg = &returnmsgBuffer;
		  returnpayload = (mpdr_test_msg_t*) call MpdrPacket.getPayload(returnmsg,
                                                       sizeof(mpdr_test_msg_t));
    	returnpayload->seqno = receivedCount;
    	for (i = 0; i < MSG_SIZE; i++) {
     	 returnpayload->data[i] = i;
    	}
   	 result = call MpdrSend.send(sourceNode, returnmsg, sizeof(mpdr_test_msg_t));
    	if (result == SUCCESS) {
    	  sendCount++;
    	}
		}
		
    return msg;
  }

  event void InitTimer.fired() {
    initializeNode();
  }

  event void TestTimer.fired() {
    transmitting = TRUE;
    call SendTimer.startPeriodic(SEND_PERIOD);
  }

  event void SendTimer.fired() {
    if (transmitting) {
      sendMessage();
      if (sendCount >= NUM_MSGS) {
        transmitting = FALSE;
      }
    } else {
      call SendTimer.stop();
    }
  }

  event void FinishTimer.fired() {
    uint16_t data;
    call SerialLogger.log(LOG_TEST_NUMBER, testCounter);

    call SerialLogger.log(LOG_SENT_TOTAL, sendCount);
    call SerialLogger.log(LOG_RECEIVED_TOTAL, receivedCount);
    call SerialLogger.log(LOG_TIME_TOTAL, endTime - startTime);

    data = call MpdrStats.getReceivedRadio1();
    call SerialLogger.log(LOG_RECEIVED_RADIO_1, data);
    data = call MpdrStats.getReceivedRadio2();
    call SerialLogger.log(LOG_RECEIVED_RADIO_2, data);
    data = call MpdrStats.getSentRadio1();
    call SerialLogger.log(LOG_SENT_RADIO_1, data);
    data = call MpdrStats.getSentRadio2();
    call SerialLogger.log(LOG_SENT_RADIO_2, data);
    data = call MpdrStats.getTimeRadio1();
    call SerialLogger.log(LOG_RADIO_TIME_1, data);
    data = call MpdrStats.getTimeRadio2();
    call SerialLogger.log(LOG_RADIO_TIME_2, data);
    data = call MpdrStats.getRetransmissions1();
    call SerialLogger.log(LOG_RETRANSMISSIONS_1, data);
    data = call MpdrStats.getRetransmissions2();
    call SerialLogger.log(LOG_RETRANSMISSIONS_2, data);
    data = call MpdrStats.getDropped1();
    call SerialLogger.log(LOG_DROPPED_1, data);
    data = call MpdrStats.getDropped2();
    call SerialLogger.log(LOG_DROPPED_2, data);
    data = call MpdrStats.getMaxQueueSize();
    call SerialLogger.log(LOG_MAX_QUEUE, data);
    data = call MpdrStats.getDuplicated1();
    call SerialLogger.log(LOG_DUPLICATED_1, data);
    data = call MpdrStats.getDuplicated2();
    call SerialLogger.log(LOG_DUPLICATED_2, data);
    data = call MpdrStats.getEbusyRadio1();
    call SerialLogger.log(LOG_EBUSY_RADIO_1, data);
    data = call MpdrStats.getEbusyRadio2();
    call SerialLogger.log(LOG_EBUSY_RADIO_2, data);
    call MpdrStats.clear();
    sendCount = 0;
    receivedCount = 0;
    testCounter++;
    startTime = 0;
    endTime = 0;
    if (NUM_TESTS > 0 && testCounter >= NUM_TESTS) {
      call TestTimer.stop();
      call FinishTimer.stop();
    }
  }

  event void MpdrRouting.pathsReady(am_addr_t destination) {}
}

// Fix
