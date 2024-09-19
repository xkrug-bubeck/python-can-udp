import can
import time
from UdpMulticastBus_Windows import UdpMulticastBus_Windows

bus1 = can.interface.Bus(interface='vector', channel=0, bitrate=500000, app_name='python-can')
bus2 = UdpMulticastBus_Windows(channel=UdpMulticastBus_Windows.DEFAULT_GROUP_IPv4)

notifier1 = can.Notifier(bus1, [can.RedirectReader(bus2)])
notifier2 = can.Notifier(bus2, [can.RedirectReader(bus1), can.Printer()])

while True:
    time.sleep(1.0)

bus1.shutdown()
bus2.shutdown()