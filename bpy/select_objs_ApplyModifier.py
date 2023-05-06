import bpy

_modifier="Armature"

for i in bpy.context.selectable_objects:
    bpy.context.view_layer.objects.active = i
    bpy.ops.object.modifier_apply(modifier=_modifier)