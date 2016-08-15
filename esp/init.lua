--t = require("ds18b20")
 
gpio.mode(6, gpio.OUTPUT)
gpio.write(6, gpio.LOW)
gpio.mode(7, gpio.OUTPUT)
gpio.write(7, gpio.LOW)

local function server_udp(client,data)
CMD = data
--tmr.delay(10) 
client:send ( CMD )
print("rxData: ",CMD)
tmr.delay(10) 


if CMD=="A+" then
        gpio.write(6, gpio.HIGH)
elseif CMD=="A-" then
        gpio.write(6, gpio.LOW)
elseif CMD=="B+" then
        gpio.write(7, gpio.HIGH)
elseif CMD=="B-" then
        gpio.write(7, gpio.LOW)
elseif CMD=="on" then
        gpio.write(6, gpio.HIGH)
        gpio.write(7, gpio.HIGH)
elseif CMD=="off" then
        gpio.write(6, gpio.LOW)
        gpio.write(7, gpio.LOW)
end
    
   
end


 

wifi.setmode(wifi.STATION)
wifi.sta.config("LOG","PASS")
wifi.sta.connect()

i=0
tmr.alarm(1, 1000, 1, function()
    if (wifi.sta.status() ~= 5 and i < 10) then
       print("Status:"..wifi.sta.status())
       i = i + 1
    else
       tmr.stop(1)
       if (wifi.sta.status() == 5) then
          print("IP:"..wifi.sta.getip())
       else
          print("Status:"..wifi.sta.status())
       end
    end
end)



svr = net.createServer(net.UDP)
svr:on("receive", server_udp)

svr:listen (8080)
