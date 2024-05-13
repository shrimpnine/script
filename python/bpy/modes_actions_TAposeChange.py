import bpy

all_actions=False
action='idle'
bonelist=[
    'LeftArm',
    'RightArm'
]

#change_y=0
change_y=-0.2217
key_interpolation="LINEAR"

def fn_change(_actions):
    for i in bpy.data.actions[_actions].groups:
        for blist in bonelist:
            if i.name == blist:
                number=0
                for j in i.channels:
                    number += 1
                    if number<=7:
                        for ilist in bonelist:
                            if j.data_path == 'pose.bones["'+ilist+'"].rotation_quaternion':
                                if j.array_index == 1: # X Quaternion Rotation
                                    for k in j.keyframe_points:
                                        k.interpolation = key_interpolation
                                        k.co.y += change_y
                                elif j.array_index == 3: # Z Quaternion Rotation
                                    for k in j.keyframe_points:
                                        k.interpolation = key_interpolation
                                        k.co.y += change_y
if all_actions:
    for _all_action in bpy.data.actions:
        fn_change(_all_action.name)
else:
    fn_change(action)