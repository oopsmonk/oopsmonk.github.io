---
title: "OpenNMS Architecture Introduction (Discovery & Monitor)"
tags: ["WebDevs"]
date: 2013-02-03
---

O.S. : Ubuntu12.04 LTS  
OpenNMS Version : 1.10.7  

OpenNMS base on [TMN](http://en.wikipedia.org/wiki/Telecommunications_Management_Network) & [FCAPS](http://en.wikipedia.org/w/index.php?title=FCAPS&oldid=535214862) network management models.  

### OpenNMS Block Diagram

![](/images/2013-02-03/OpenNMSBlockArchitecture.png)  

### Discovery & Monitor daemons

* [Eventd](http://www.opennms.org/wiki/Event_Configuration_How-To)  
    Event handling daemon  
    Configuration files:  
    eventconf.xml -> Defines the UEI (Universal Event Identifiers).  
    eventd-configuration.xml -> Defines operating parameters for eventd such as timeouts, listener threads and listener port.  
    events-archiver-configuation.xml -> Configuration for event archive daemon.  
    events.archiver.properties -> Fine tune events archive subsystem.  
    etc/events/*.xml -> Vendor UEI define files.  
    Listening "eventsConfigChange" event.  

* [Discovery](http://www.opennms.org/wiki/Discovery) (discovery-configuration.xml)  
    Discovery service implement the [Singleton](http://en.wikipedia.org/wiki/Singleton_pattern) pattern.  
    Listening events:  
    discPause, interfaceDeleted, discResume, nodeGainedInterface, discoveryConfigChange and reloadDaemonConfig.

* [Capsd](http://www.opennms.org/wiki/Capsd) (Capabilities daemon, capsd-configuration.xml)  
    Notified by the discovery process when a new node is discovered, the polls for all the capabilities for this node and loading the data collected into the database.  
    Listening events:  
    deleteService, changeService, deleteInterface, newSuspect, froceRescan, addInterface, nodeDeleted, addNode, updateServer, nodeAdded, duplicateNodeDeleted, deleteNode and updateService.  

* [Collectd](http://www.opennms.org/wiki/Collectd) (collectd-configuration.xml)  
    Responsible for gathering and storing data from various sources, including SNMP, JMX, HTTP and NSClient.  
    Listening events:  
    nodeGainedService, primarySnmpInterfaceChanged, reinitializePrimarySnmpInterface, interfaceReparented, nodeDeleted, duplicateNodeDeleted, interfaceDeleted, serviceDeleted, schedOutagesChanged, configureSNMP, thresholdConfigChange, reloadDaemonConfig and nodeCategoryMembershipChanged.  

* [Poller](http://www.opennms.org/wiki/Polling_Configuration_How-To) (poller-configuration.xml)  
    Polling services, including ICMP, DNS, FTP, HTTP, HTTPS, SSH, MySQL....  
    Listening events:  
    nodeGaineService, serviceDeleted, interfaceReparented, nodeDeleted, nodeLabelChanged, duplicateNodeDeleted, interfaceDeleted, suspendPollingService, resumePollingService, schedOutagesChanged, demandPollService, thresholdConfigChange, assetInfoChanged and nodeCategoryMembershipChanged.  

* [RTC](http://www.opennms.org/wiki/Rtcd) (Real-Time Collector)  
    The RTC initializes its data from the database when it comes up then subscribes to the events subsystem to receive events of interest to keep the data up-to-date.  
    Listening events:  
    nodeGainedService, nodeLostService, interfaceDown, nodeDown, nodeUp, nodeCategoryMembershipChanged, interfaceUp, nodeRegainedService, serviceDeleted, serviceunmanaged, interfaceReparented, subscribe, unsubscribe and assetInfoChanged.  

__Note:__  
There are two major ways that OpenNMS gathers data about the network.  
The first is through polling. Processes called monitors connect to a network resource and perform a simple test to see if the resource is responding correctly. If not, events are generated.  
The second is through data collection using collectors. Currently, the only collector is for SNMP data.  
Collectd record SNMP data to RRDTool in /share/rrd/snmp/NodeID/\*,  Ex:  tcpOutSegs.jrb, icmpInEchos.jrb, tcpInSegs.jrb, ifInOctets.jrb, ifoutOctets.jrb...  
Poller record Service data to RRDTool in /share/rrd/response/IP/\*,  Ex: icmp.jrb ssh.jrd...  

OpenNMS configuration files:  
http://www.opennms.org/wiki/Configuration_File_Index  

### Discovery & Monitor Flow  
Here is the event flow when press "Save and Restart Discovery" button on WebGUI.  
![Figure1](/images/2013-02-03/OpenNMSDiscoveryEventFlow.png "Figure1")  

![Figure2](/images/2013-02-03/OpenNMSDiscoveryEventFlow2.png "Figure2")  

References :  
[White Paper: Project OpenNMS](http://www.opennms.org/w/images/a/a8/Project_opennms-abstract-v2.pdf)  
[The architecture of OpenNMS](http://www.codeweblog.com/the-architecture-of-opennms/)  
[論OpenNMS 在 SUSE linux 之應用](http://www.syscom.com.tw/ePaper_Content_EPArticledetail.aspx?id=280&EPID=180&j=3&HeaderName=%E7%A0%94%E7%99%BC%E6%96%B0%E8%A6%96%E7%95%8C)  

