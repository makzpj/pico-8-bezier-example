pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
function bezier_p(sp, cp, ep, t)
 q = {}
 u = 1 - t
 uu = u * u
 q.x = uu * sp.x + 2*u*t*cp.x + t*t*ep.x
 q.y = uu * sp.y + 2*u*t*cp.y + t*t*ep.y
 return q 
end

function bezier_c(sp, cp, ep, s)
 c = {}
 for t=0, s do
  t = t/s
  q = bezier_p(sp, cp, ep, t)
  add(c, q)
 end
 return c
end

function make_obj(x, y, sprite, visible)
 local o={}
 o.x=x
 o.y=y
 o.s=sprite
 o.visible=visible
 return o
end

function _init()
 sp={}
 ep={}
 cp={}
 sp.x=rnd(127)
 sp.y=rnd(127)
 ep.x=rnd(127)
 ep.y=rnd(127)
 cp.x=rnd(127)
 cp.y=rnd(127)
 s = 80
 sf=0
 ef=7
 f=sf
 
 ufo = make_obj(sp.x, sp.y, sf, true)
 ufo.hitxc = 0
 ufo.hityc = 2
 ufo.hitx = ufo.x+ufo.hitxc
 ufo.hity = ufo.y+ufo.hityc
 ufo.h=4
 ufo.w=7
 
 
 player = {}
 player.x = 64
 player.y = 120
 
 tick = 0
 bullets = {}

 c = bezier_c(sp, cp, ep, s)
 
 i = 1
end

function mk_bullet(x, y)
  bullet = {}
  bullet.x = x
  bullet.y = y
  add(bullets, bullet)
end

function mv_bullet(b)
 if collidep(ufo, b) then
   sfx(1)
   sf=8
   ufo.s=sf
   ef=10
 end 

 if b.y > -10 then
  b.y -=1
 else
  rm_bullet(b)
 end
end

function rm_bullet(b)
 del(bullets, b)
end

function _update()
 tick += 1
 
 local p=c[i]
 
 ufo.x = p.x
 ufo.y = p.y
 recalc_hitbox(ufo)
 
 for b in all(bullets) do
  mv_bullet(b)
 end

 
 --p.x =64
 --p.y=64
 
 if btn(0) then
  player.x -=1
 elseif btn(1) then
  player.x += 1
 end 
 
 if btnp(5) and #bullets < 3 then
  sfx(0)
  mk_bullet(player.x, player.y-1)
 end
 
 
end

function _draw()
 cls()
 
 spr(ufo.s, ufo.x, ufo.y)
 --pset(ufo.x, ufo.y, 11)
 --draw_hitbox(ufo)
 i += 1
 
 if tick % 2 == 0 then
  ufo.s += 1
 end
 
 if ufo.s > ef then
  ufo.s=sf
 end
 
 if i > s then
  i = 1
  sp.x = ep.x
  sp.y = ep.y
  cp.x=rnd(127)
  cp.y=rnd(127)
  ep.x=rnd(127)
  ep.y=rnd(127)

  c = bezier_c(sp, cp, ep, s)
 end
 
 spr(16, player.x, player.y)
 
 print(ufo.x .. "," .. ufo.y)
 
  
 for b in all(bullets) do
  print(b.x .. "," .. b.y)
  pset(b.x, b.y)
 end
end
-->8
function draw_hitbox(obj)
 rect(obj.hitx, obj.hity,
 obj.hitx+obj.w, obj.hity+obj.h,8)
end

function recalc_hitbox(o)
 o.hitx=o.x+o.hitxc
 o.hity=o.y+o.hityc
end

function collide(obj1, obj2)
 if (obj1.hitx+obj1.w < obj2.hitx) then
  return false
 end
 if (obj1.hitx > obj2.hitx+obj2.w) then
  return false
 end
 if (obj1.hity+obj1.h < obj2.hity) then
  return false
 end
 if (obj1.hity > obj2.hity+obj2.h) then
  return false
 end
 
 return true
end

function collidep(obj1, p)
 if (obj1.hitx+obj1.w < p.x) then
  return false
 end
 if (obj1.hitx > p.x) then
  return false
 end
 if (obj1.hity+obj1.h < p.y) then
  return false
 end
 if (obj1.hity > p.y) then
  return false
 end
 
 return true
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00cccc0000cccc0000cccc0000cccc0000cccc0000cccc0000cccc0000cccc0000c00c000000c000000000000000000000000000000000000000000000000000
0cccccc00cccccc00cccccc00cccccc00cccccc00cccccc00cccccc00cccccc00cc0cc000c0cc0c0000000000000000000000000000000000000000000000000
88ddddddd88ddddddd88ddddddd88ddddddd88ddddddd88ddddddd88ddddddd8dd00d00dd00d0d00000000000000000000000000000000000000000000000000
0cccccc00cccccc00cccccc00cccccc00cccccc00cccccc00cccccc00cccccc00ccc00c000cc0c00000000000000000000000000000000000000000000000000
00cccc0000cccc0000cccc0000cccc0000cccc0000cccc0000cccc0000cccc0000cc0c0000c0c000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00099000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05000050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000565007650066500a6500f6502a65022650136501265011650106500f6500f6500e6500e6500e6500e650000000000000000000000000000000000000000000000000000000000000000000000000000
00030000046500a650106501365013650136501265012650116500f6500c650066500265002650036500465006650086500c6500e650126501565018650186501765015650106500c65008650076500765009650
