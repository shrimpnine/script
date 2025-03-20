import bpy
import bmesh

obj = bpy.context.active_object

if obj.mode == 'EDIT':
    bm = bmesh.from_edit_mesh(obj.data)
    selected = [i.index for i in bm.verts if i.select == True]
    print('Selected:', len(selected))
    print(selected)
else:
    print("Object is not in edit mode.")