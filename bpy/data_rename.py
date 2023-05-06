import bpy
import re

_type='all_images_autorename'
    #'action' #Rename action path.
    #'all_actions' #Rename all action channels name.
    #'all_images' #Rename all images file path.
    #'all_images_autorename' #Images name = file path.

_name='idel'
_str="mixamorig:"
_rep=""
#_str=".bmp"
#_rep=".png"

def fn_rename_action(_action):
    for i in bpy.data.actions[_action].groups:
        if re.findall(r''+_str+'',i.name):
            i.name = i.name.replace(_str,_rep)
        for j in i.channels:
            ss = j.data_path
            ss = ss[ss.index("\"")+1:]
            ss = ss[:ss.index("\"")]
            j.data_path = j.data_path.replace(ss,i.name)

def fn_rename_images_filepath():
    for i in bpy.data.images:
        if re.findall(r''+_str+'',i.filepath):
            i.filepath = i.filepath.replace(_str,_rep)

def fn_all_images_autorename():
    for i in bpy.data.images:
        i.name=i.filepath.replace('/','_')

match _type:
    case 'action':
        fn_rename_action(_name)
    case 'all_actions':
        for _action in bpy.data.actions:
            fn_rename_action(_action.name)
    case 'all_images':
        fn_rename_images_filepath()
    case 'all_images_autorename':
        fn_all_images_autorename()