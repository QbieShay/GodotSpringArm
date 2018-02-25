# GodotSpringArm
A configurable spring arm node for Godot Engine

# How to use it

As soon as the spring is given a target, it will start following the target and looking at the target.
Currently, the spring node position itself on the back of the target, at given height and length
For the spring to work, it is needed to give it a collision shape.

 - Spring Max Length : How far the spring node will stay on the target's back vector
 - Spring Max Height : How high the spring node will stay on the target's up vector
 - Smoothness : How smooth the movement of the spring node should be
 - Look At Target : Should the spring node look at the target
 - Interpolate Physic Frame : Should the spring node interpolate between pysics frames
