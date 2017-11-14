extends Node
var todo = """
Alright fuckheads, here's the shit that I need to do

Currently I am working on this bullshit where when you put the mouse
over a thing that does something in the adventure mode it will change
the mouse to some other mouse pointer.

so the mouse could go over multiple thingies too, so it sort of has to
be able to stack them and remove them from the stack not necessarily in the
same order that they were added, since an earlier one may get autism.

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
ok what we need is not a stack, we just need a flag for each kind of pointer,
and along with these we will have the priority which is the turn-on-er's
position as a child, this value will also let us know when we have two
instances of an item overlapping that when one is left we don't turn off
the flag.
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

"""