import bpy

#排列选中的所有物体

_location_index=1
#从0开始排列
_location=0

for i in bpy.context.selected_objects:
    i.location[0]=_location
    _location+=_location_index
