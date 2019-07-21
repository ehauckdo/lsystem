pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
resume_t = 0
clr = 4
cls()

draw = {} 
drawing = {}
wave_y = -1

sparks = {}
sparks_clr={7,9,10,6,0}


falling = {}

branch_clr={4,3,11}


function _update()
 
 
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
   wave_y = 130
   --[[for i=#draw,1,-1 do
    print(draw[i][4])
   end
   stop()]]--
  end
  
  if wave_y > -5 then
   wave_y = wave_y - 2
  end
  
  --[[local limit = 15
  local current = 0
  for i=#draw,1,-1 do
   //print(draw[i][4])
   if draw[i][4] > wave_y then
    add(drawing,draw[i])
    del(draw,draw[i])
   else
    break
   end
   
  end--]]
  
  // move sparks from initial
  // table to _draw table
  for i=#sparks,1,-1 do
   if sparks[i][2] > wave_y then
    add(falling,sparks[i])
    del(sparks,sparks[i])
   end
  end
  
  
end


function _draw()
 
 cls(1)
 //print(stat(7))
 
 circfill(64,190,90,5)
 
 --[[for i=1,#drawing,1 do 
   //x,y,dx,dy,clr = unpack(drawing[i])
   x = drawing[i][1]
   y = drawing[i][2]
   dx = drawing[i][3]
   dy = drawing[i][4]
   clr = drawing[i][5]
   line(x,y,dx,dy,clr)
 end--]]
 

 for i=#draw,1,-1 do 
  if draw[i][4] > wave_y then
   //x,y,dx,dy,clr = unpack(draw[i])
   x = draw[i][1]
   y = draw[i][2]
   dx = draw[i][3]
   dy = draw[i][4]
   clr = draw[i][5]
   line(x,y,dx,dy,clr)
  else
   break
  end
 end
 
 
 
 for i=#falling,1,-1 do
  local x = falling[i][1]
  local y = falling[i][2]
  local clr = falling[i][3]
  pset(x,y, clr)
  pset(x,y-1, clr)
  pset(x-1,y-1, clr)
  pset(x+1,y-1, clr)
  pset(x,y-2, clr)
  
   falling[i][4] -= 1
   falling[i][2] = y + 0.5
   if falling[i][4] < 1 then
    del(falling, falling[i])
   end
 end
 
 
 --[[
 for i=#sparks,1,-1 do
  //if sparks[i][2] > wave_y then
  if sparks[i][2] > wave_y then
   local x = sparks[i][1]
   local y = sparks[i][2]
   local clr = sparks[i][3]
   pset(x,y, clr)
   pset(x,y-1, clr)
   pset(x-1,y-1, clr)
   pset(x+1,y-1, clr)
   pset(x,y-2, clr)
   sparks[i][4] -= 1
   sparks[i][2] = y + 0.5
   if sparks[i][4] < 1 then
    del(sparks, sparks[i])
   end
  else
   break
  end
 end
 ]]--
 
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
 y = 120
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
 //drawing = reverse(drawing)
 //draw = sort(draw,4)
 
 qsort(draw,by_y)
 
 
 sparks = sort(sparks,2)
end



// execute a symbol, only "f"
// actually prints a line
function run_symbol(s)
 if s == "f" then
  d_x = d * cos(ang+ang_d) 
  d_y = d * sin(ang+ang_d)
  //line(x, y, x+d_x, y+d_y, clr)
  local myclr = branch_clr[flr(rnd(#branch_clr)+1)]
  add(draw,{x,y,x+d_x, y+d_y,myclr})
  if rnd() > 0.75 then
   add_spark(x+d_x/2,y+d_y)
  end
  x = x + d_x
  y = y + d_y
  
 elseif s == "k" then
  d_x = d * cos(ang+ang_d) 
  d_y = d * sin(ang+ang_d)
  line(x, y, x+d_x, y+d_y, 0)
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
-- utility functions

// returns a reversed sequence
function reverse(seq1)
 seq2 = {}
 for i=#seq1, 1,-1 do
  add(seq2, seq1[i])
 end
 return seq2
end

// unpack table into spread 
// values through recursion
function unpack(y, i)
  i = i or 1
  local g = y[i]
  if (g) return g, unpack(y, i + 1)
end

// specific unpacking with
// no recursion
function unpackl(list)
 x  = list[1]
 y  = list[2]
 dx = list[3]
 dy = list[4]
 return x,y,dx,dy
end

// order by y decrescent
function sort(list,index)
 for i=1,#list-1,1 do
  for j=i+1,#list,1 do
   if list[i][index] > list[j][index] then
    temp = list[i]
    list[i] = list[j]
    list[j] = temp
   end
  end
 end
 return list
end

-->8
function add_spark(x, y)
 local clr = sparks_clr[flr(rnd(5))+1]
 add(sparks, {x,y, clr, 5})
end
-->8
-- qsort by felice at
-- bbs/?tid=2477

-- common comparators
function  ascending(a,b) return a<b end
function descending(a,b) return a>b end
function by_y(a,b)
 return a[4]<b[4]
end


-- a: array to be sorted in-place
-- c: comparator (optional, defaults to ascending)
-- l: first index to be sorted (optional, defaults to 1)
-- r: last index to be sorted (optional, defaults to #a)
function qsort(a,c,l,r)
    c,l,r=c or ascending,l or 1,r or #a
    if l<r then
        if c(a[r],a[l]) then
            a[l],a[r]=a[r],a[l]
        end
        local lp,rp,k,p,q=l+1,r-1,l+1,a[l],a[r]
        while k<=rp do
            if c(a[k],p) then
                a[k],a[lp]=a[lp],a[k]
                lp+=1
            elseif not c(a[k],q) then
                while c(q,a[rp]) and k<rp do
                    rp-=1
                end
                a[k],a[rp]=a[rp],a[k]
                rp-=1
                if c(a[k],p) then
                    a[k],a[lp]=a[lp],a[k]
                    lp+=1
                end
            end
            k+=1
        end
        lp-=1
        rp+=1
        a[l],a[lp]=a[lp],a[l]
        a[r],a[rp]=a[rp],a[r]
        qsort(a,c,l,lp-1       )
        qsort(a,c,  lp+1,rp-1  )
        qsort(a,c,       rp+1,r)
    end
end
