pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
resume_t = 0
cls()

function _update()
 // small delay to ensure
 // a single generation per
 // button press
 if time() < resume_t then
  return
  
 end
  if btn(❎) then
   resume_t = time() + 0.3
  	iteration()
  end
end





-->8
rules = {f="f[-f]f[+f][f]"}
string = "f"
stack = {}

// expand the current string
// once and print the result
function iteration()
 cls()
 
 x = 64
	y = 128
	d_x = 0
	d_y = -8
	
 ang = 0.25
 ang_d = 0
 d = 4

 expand()
 run_string()
 
 printh("expanded str: "..string, 'log.txt')
 
end

// execute the grammar,
// symbol by symbol
function run_string()
 for i=1,#string do
 	symbol = sub(string,i,i)
 	run_symbol(symbol)	
 end
end

// execute a symbol
// only the f symbol will
// actually print a line
function run_symbol(s)
 if s == "f" then
  d_x = d * cos(ang+ang_d) 
 	d_y = d * sin(ang+ang_d)
  line(x, y, x+d_x, y+d_y, 3)
  x = x + d_x
 	y = y + d_y
 elseif s == "+" then
  ang_d = ang_d + 0.10
 	d_x = d * cos(ang+ang_d) 
 	d_y = d * sin(ang+ang_d)
 elseif s == "-" then
 	ang_d = ang_d - 0.10
 	d_x = d * cos(ang-ang_d) 
 	d_y = d * sin(ang-ang_d)
 elseif s == "[" then
  add(stack, {x,y,ang_d})
 elseif s == "]" then
  coords = stack[#stack]
		x = coords[1]
		y = coords[2]
		ang_d = coords[3]
		stack[#stack] = nil
 end
end

// expand the current string
// based on the table "rules"
function expand()
 new_str = ""
 for i = 1,#string do
  symbol = sub(string,i,i)
  new_sym = rules[symbol]
  if new_sym != nil then
   new_str = new_str..new_sym
  else
   new_str = new_str..symbol
  end
 end
 string = new_str
end


