import bpy

#
actisonAnimeGraphResizeTime=False
actisonName='actisonName'
resizeX=1
actisonAnimeGraphMoveX=False #All actions keyframe.x move -1
move_value=-1
copyFirstkeyToEndkey=False #All actions channels add Endkey.
allActionInsertEndkey=False #Lll actions insert Endkey. Need select Bones.
#

obj_Armature='Armature'
scene=bpy.data.scenes['Scene']
if actisonAnimeGraphMoveX:
    for _actions in bpy.data.actions:
        for _groups in _actions.groups:
            for _channels in _groups.channels:
                for _co_ui in _channels.keyframe_points:
                    _co_ui.co_ui.x += move_value
if copyFirstkeyToEndkey:
    for _actions in bpy.data.actions:
        _actRange=_actions.frame_range.y #End key number.
        for _groups in _actions.groups:
            for _channels in _groups.channels:
                if len(_channels.keyframe_points) <= 1:
                    _key_type=_channels.keyframe_points[0].type
                    _value=_channels.keyframe_points[0].co.y
                    _channels.keyframe_points.insert(frame=_actRange,value=_value,keyframe_type=_key_type)
                    #Copy first key to end key.
if allActionInsertEndkey:
    _key_insert_type='Available' # 'Available', 'Location', 'Rotation', 'Scaling'...
    obj=bpy.data.objects[obj_Armature] #Bone obj name
    number=0 #Print count
    for _action in bpy.data.actions:
        obj.animation_data.action=_action
        scene.frame_current=int(_action.frame_range.y)
        bpy.ops.anim.keyframe_insert(type=_key_insert_type)
        number+=1
        print(number,obj.animation_data.action.name,"Frame:",scene.frame_current,"FINISH")
if actisonAnimeGraphResizeTime:
    bpy.data.objects[obj_Armature].animation_data.action=bpy.data.actions[actisonName]
    scene.frame_current=0
    if resizeX != 1 :
        old_type=bpy.context.area.type
        bpy.context.area.type='GRAPH_EDITOR'
        bpy.context.space_data.dopesheet.show_only_selected=False
        bpy.context.space_data.pivot_point='CURSOR'
        bpy.ops.graph.select_all(action='SELECT')
        bpy.ops.transform.resize(
            value=(resizeX, 1, 1),
            orient_type='GLOBAL',
            orient_matrix=((1, 0, 0), (0, 1, 0), (0, 0, 1)),
            orient_matrix_type='GLOBAL',
            constraint_axis=(True, False, False),
            mirror=False,
            use_proportional_edit=False,
            proportional_edit_falloff='SMOOTH',
            proportional_size=1,
            use_proportional_connected=False,
            use_proportional_projected=False,
            snap=False,
            snap_elements={'INCREMENT'},
            use_snap_project=False,
            snap_target='CLOSEST',
            use_snap_self=True,
            use_snap_edit=True,
            use_snap_nonedit=True,
            use_snap_selectable=False
        )
        bpy.context.area.type = old_type
    scene.frame_end=int(bpy.data.actions[actisonName].frame_range.y)
    bpy.ops.screen.animation_cancel()
    bpy.ops.screen.animation_play()