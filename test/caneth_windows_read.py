import can
import time

bus1 = can.interface.Bus(interface='vector', channel=0, bitrate=500000, app_name='python-read')

notifier1 = can.Notifier(bus1, [can.Printer()])

while True:
    time.sleep(1.0)

bus1.shutdown()