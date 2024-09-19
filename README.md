# python_can_udp

Python files to tunnel socketCAN device via multicast UDP to a virtual Vector CAN bus.

## Requirements

### CAN side

- [x] SocketCAN device
- [x] Python 3

```
pip install python-can msgpack
```

### Windows side

- [x] Python 3
- [x] Vector Driver
- [x] Vecor XL Library
  - vxlapi64.dll has to be in `C:\Windows\System32`

```
pip install python-can msgpack netifaces
```

#### Vector virtual CAN device

Davice 1 has to be configured for the `python-can` application.

#### Network

The interface that is used to communicate has to have the lowest metric.
Check `route print`

## Usage

At this moment, just run it.
