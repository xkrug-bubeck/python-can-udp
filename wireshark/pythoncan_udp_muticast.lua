--- dissects python-can udp_multicast packages
--- https://python-can.readthedocs.io/en/stable/interfaces/udp_multicast.html
--- https://github.com/kieselsteini/msgpack

local msgpack = require('msgpack')

--- udp_multicast frame
udp_multicast_protocol = Proto("can_udp_multicast", "Can over UDP")
udp_multicast_channel = ProtoField.string("udp_multicast.channel", "channel")
can_frame_timestamp = ProtoField.double("can.frame.timestamp", "timestamp")
can_frame_id = ProtoField.uint32("can.frame.arbitration_id", "can_id", base.HEX)
can_frame_dlc  = ProtoField.uint8("can.frame.dlc", "dlc", base.DEC)
can_frame_pdu = ProtoField.string("can.frame.data", "pdu")
udp_multicast_protocol.fields = {udp_multicast_channel, can_frame_timestamp, can_frame_id, can_frame_dlc, can_frame_pdu}

can_flags = Proto("can_udp_multicast_flags", "CAN flags")
can_flags_is_extended_id = ProtoField.bool("can.frame.extended", "extended ID")
can_flags_is_error = ProtoField.bool("can.flags.error", "error frame")
can_flags_is_fd = ProtoField.bool("can.flags.fd", "FD frame")
can_flags_bitrate_switch = ProtoField.bool("can.flag.brs", "bitrate switch")
can_flags_is_remote = ProtoField.bool("can.flag.is_remote", "remote frame")
can_flags.fields = {can_flags_is_extended_id, can_flags_is_error, can_flags_is_fd, can_flags_bitrate_switch, can_flags_is_remote}


-- https://stackoverflow.com/questions/9168058/how-to-dump-a-table-to-console
-- function dump(o)
--     if type(o) == 'table' then
--        local s = '{ '
--        for k,v in pairs(o) do
--           if type(k) ~= 'number' then k = '"'..k..'"' end
--           s = s .. '['..k..'] = ' .. dump(v) .. ','
--        end
--        return s .. '} '
--     else
--        return tostring(o)
--     end
--  end

                        
 
function udp_multicast_protocol.dissector(buffer, pinfo, tree)
  length = buffer:len()
  if length == 0 then return end

  local raw_buffer = buffer:raw(0, buffer:len())
  local decoded_buffer = msgpack.decode(raw_buffer)

  pinfo.cols.protocol = udp_multicast_protocol.name

  local subtree = tree:add(udp_multicast_protocol, buffer(), "CAN UDP Multicast Ch " .. decoded_buffer['channel'] .. ' ID ' .. decoded_buffer['arbitration_id'])
  subtree:add(udp_multicast_channel, decoded_buffer['channel'])
  subtree:add(can_frame_timestamp, decoded_buffer['timestamp'])
  subtree:add(can_frame_id, decoded_buffer['arbitration_id'])
  subtree:add(can_frame_dlc, decoded_buffer['dlc'])

--   https://devforum.roblox.com/t/missing-documentation-for-stringpack-stringunpack-and-stringpacksize/1286592/5
  local packfmt = ""
  local printfmt = ""
  for i=1,decoded_buffer['dlc'] do packfmt = packfmt .. "B" end
  for i=1,decoded_buffer['dlc'] do printfmt = printfmt .. " " .. "0x%02X" end

  subtree:add(can_frame_pdu, string.format(printfmt, string.unpack(packfmt, decoded_buffer['data'])))

  local flagsubtree = subtree:add(can_flags, buffer(), "Can Flags")
  flagsubtree:add(can_flags_is_extended_id, decoded_buffer['is_extended_id'])
  flagsubtree:add(can_flags_is_error, decoded_buffer['is_error_frame'])
  flagsubtree:add(can_flags_is_fd, decoded_buffer['is_fd'])
  flagsubtree:add(can_flags_bitrate_switch, decoded_buffer['bitrate_switch'])
  flagsubtree:add(can_flags_is_remote, decoded_buffer['is_remote_frame'])
end

local udp_port = DissectorTable.get("udp.port")
udp_port:add(43113, udp_multicast_protocol)