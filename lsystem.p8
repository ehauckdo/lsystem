pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
resume_t = 0
clr = 4
cls()

draw = {} 
drawing = {}
wave_y = -1
max_y = 0
min_x = 0
max_x = 0

sparks={7,9,10,6,0}

function _update60()
 cls()
 // small delay to ensure
 // a single generation per
 // button press
 if time() < resume_t then
  return
  
 end
  if btn(❎) then
   resume_t = time() + 0.3
   draw = {}
   drawing = {}
  	iteration()
  	wave_y = 127
  	
  	max_y = 127
  	max_x = 0
  	min_x = 127
   for i=1,#draw,1 do
				x,y,dx,dy = unpackl(draw[i])
   	if draw[i][4] < max_y then
   	 max_y = draw[i][4]
   	end
   	if draw[i][3] > max_x then
   	 max_x = draw[i][3]
   	end
   	if draw[i][3] < min_x then
   	 min_x = draw[i][3]
   	end
   	
   end
   max_y = max_y - 10
   min_x = min_x - 10
   max_x = max_x + 10
  end
  
 	if wave_y > -1 then
   wave_y = wave_y - 1
  end
  
  if wave_y < max_y then
   if max_x-min_x <= 1 then
    wave_y = -1
   else
    max_x = max_x - 1
    min_x = min_x + 1
   end
  end
end

function unpackl(list)
 x  = list[1]
 y  = list[2]
 dx = list[3]
 dy = list[4]
 return x,y,dx,dy
end

function _draw()
 
	for i=1,#draw,1 do	
 	if draw[i][4] > wave_y then
 	 x,y,dx,dy = unpackl(draw[i])
 	 line(x,y,dx,dy,3)
 	end
 end
 
 //rectfill(0,max_y,128,wave_y, 0)
 //line(min_x,wave_y,max_x,wave_y,7)
 //line(min_x,wave_y+1,max_x,wave_y+1,10)
 
 for x=min_x,max_x,1 do
  rn1 = flr(rnd(5)) + 1
  rn2 = flr(rnd(5)) + 1
  pset(x,wave_y, sparks[rn1])
  pset(x,wave_y-1, sparks[rn2])
 end
 
end





-->8
finished = false

//plant 1
rules = {f="f[f+f][-f]f[+f][f]"}

string = "f"

//plant 2
//rules = {f="f[+f]f[-f]f"}

//plant 3
//rules = {x="f[+x][-x]fx", f="ff"}
//string = "x"

//plant 4
//rules = {x="f[+x]f[-x]x", f="ff"}
//string = "x"

// expand the current string
// once and print the result
d = 4

function iteration()
 cls()
 stack = {}
 
 x = 64
	y = 128
	d_x = 0
	d_y = -8
	
 ang = 0.25
 ang_d = 0

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
 drawing = reverse(drawing)
end


// execute a symbol
// only the f symbol will
// actually print a line
function run_symbol(s)
 if s == "f" then
  d_x = d * cos(ang+ang_d) 
 	d_y = d * sin(ang+ang_d)
  //line(x, y, x+d_x, y+d_y, clr)
  add(draw,{x,y,x+d_x, y+d_y,3})
  //d_x = d_x - x
  //d_y = d_y - y
  //add(drawing,{x,y,x,y,4,d_x,d_y,0})
  x = x + d_x
 	y = y + d_y
 	
 elseif s == "k" then
  d_x = d * cos(ang+ang_d) 
 	d_y = d * sin(ang+ang_d)
  //d_x = d_x - x
  //d_y = d_y - y
  line(x, y, x+d_x, y+d_y, 0)
  //add(drawing,{x,y,x,y,3,d_x,d_y,1})
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


-->8
// returns a reversed
// sequence
function reverse(seq1)
 seq2 = {}
 for i=#seq1, 1,-1 do
 	add(seq2, seq1[i])
	end
	return seq2
end

-- unpack table into spread values
function unpack(y, i)
  i = i or 1
  local g = y[i]
  if (g) return g, unpack(y, i + 1)
end
