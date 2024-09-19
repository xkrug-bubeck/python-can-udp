import can
import time
from can.interfaces.udp_multicast import UdpMulticastBus

bus1 = can.interface.Bus(channel='vcan0', interface='socketcan')
bus2 = can.interface.Bus(channel=UdpMulticastBus.DEFAULT_GROUP_IPv4, interface='udp_multicast')

notifier1 = can.Notifier(bus1, [can.RedirectReader(bus2)])
notifier2 = can.Notifier(bus2, [can.RedirectReader(bus1)])

while True:
    time.sleep(1.0)

bus1.shutdown()
bus2.shutdown()